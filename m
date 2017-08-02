Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752834AbdHBLGX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 07:06:23 -0400
Date: Wed, 2 Aug 2017 13:06:18 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 7/7] xfs_db: introduce fuzz command
Message-ID: <20170802110618.xiu2wectqjfgrybp@hades.localdomain>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153525206.26081.8927560161890396433.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150153525206.26081.8927560161890396433.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Jul 31, 2017 at 02:07:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new 'fuzz' command to write creative values into
> disk structure fields.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/Makefile       |    3 
>  db/bit.c          |   17 +-
>  db/bit.h          |    5 -
>  db/command.c      |    2 
>  db/fuzz.c         |  467 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  db/fuzz.h         |   21 ++
>  db/type.c         |   44 ++++-
>  db/type.h         |    1 
>  man/man8/xfs_db.8 |   49 ++++++
>  9 files changed, 589 insertions(+), 20 deletions(-)
>  create mode 100644 db/fuzz.c
>  create mode 100644 db/fuzz.h
> 

Code looks good and tested here.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> diff --git a/db/Makefile b/db/Makefile
> index 6618bff..8111bf1 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -12,7 +12,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
>  	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
>  	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
>  	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
> -	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h
> +	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
> +	fuzz.h
>  CFILES = $(HFILES:.h=.c) btdump.c
>  LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
>  
> diff --git a/db/bit.c b/db/bit.c
> index f5ebf68..a20b6ba 100644
> --- a/db/bit.c
> +++ b/db/bit.c
> @@ -19,13 +19,8 @@
>  #include "libxfs.h"
>  #include "bit.h"
>  
> -#undef setbit	/* defined in param.h on Linux */
> -
> -static int	getbit(char *ptr, int bit);
> -static void	setbit(char *ptr, int bit, int val);
> -
> -static int
> -getbit(
> +int
> +getbit_l(
>  	char	*ptr,
>  	int	bit)
>  {
> @@ -39,8 +34,8 @@ getbit(
>  	return (*ptr & mask) >> shift;
>  }
>  
> -static void
> -setbit(
> +void
> +setbit_l(
>  	char *ptr,
>  	int  bit,
>  	int  val)
> @@ -106,7 +101,7 @@ getbitval(
>  
>  
>  	for (i = 0, rval = 0LL; i < nbits; i++) {
> -		if (getbit(p, bit + i)) {
> +		if (getbit_l(p, bit + i)) {
>  			/* If the last bit is on and we care about sign
>  			 * bits and we don't have a full 64 bit
>  			 * container, turn all bits on between the
> @@ -162,7 +157,7 @@ setbitval(
>  
>  	if (bitoff % NBBY || nbits % NBBY) {
>  		for (bit = 0; bit < nbits; bit++)
> -			setbit(out, bit + bitoff, getbit(in, bit));
> +			setbit_l(out, bit + bitoff, getbit_l(in, bit));
>  	} else
>  		memcpy(out + byteize(bitoff), in, byteize(nbits));
>  }
> diff --git a/db/bit.h b/db/bit.h
> index 9fd71f4..78fcd05 100644
> --- a/db/bit.h
> +++ b/db/bit.h
> @@ -21,9 +21,12 @@
>  #define	bitszof(x,y)	bitize(szof(x,y))
>  #define	byteize(s)	((s) / NBBY)
>  #define	bitoffs(s)	((s) % NBBY)
> +#define	byteize_up(s)	(((s) + NBBY - 1) / NBBY)
>  
>  #define	BVUNSIGNED	0
>  #define	BVSIGNED	1
>  
>  extern int64_t		getbitval(void *obj, int bitoff, int nbits, int flags);
> -extern void             setbitval(void *obuf, int bitoff, int nbits, void *ibuf);
> +extern void		setbitval(void *obuf, int bitoff, int nbits, void *ibuf);
> +extern int		getbit_l(char *ptr, int bit);
> +extern void		setbit_l(char *ptr, int bit, int val);
> diff --git a/db/command.c b/db/command.c
> index c90c85c..5ff3c4f 100644
> --- a/db/command.c
> +++ b/db/command.c
> @@ -51,6 +51,7 @@
>  #include "dquot.h"
>  #include "fsmap.h"
>  #include "crc.h"
> +#include "fuzz.h"
>  
>  cmdinfo_t	*cmdtab;
>  int		ncmds;
> @@ -147,4 +148,5 @@ init_commands(void)
>  	type_init();
>  	write_init();
>  	dquot_init();
> +	fuzz_init();
>  }
> diff --git a/db/fuzz.c b/db/fuzz.c
> new file mode 100644
> index 0000000..b4c62ca
> --- /dev/null
> +++ b/db/fuzz.c
> @@ -0,0 +1,467 @@
> +/*
> + * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include "libxfs.h"
> +#include <ctype.h>
> +#include <time.h>
> +#include "bit.h"
> +#include "block.h"
> +#include "command.h"
> +#include "type.h"
> +#include "faddr.h"
> +#include "fprint.h"
> +#include "field.h"
> +#include "flist.h"
> +#include "io.h"
> +#include "init.h"
> +#include "output.h"
> +#include "print.h"
> +#include "write.h"
> +#include "malloc.h"
> +
> +static int	fuzz_f(int argc, char **argv);
> +static void     fuzz_help(void);
> +
> +static const cmdinfo_t	fuzz_cmd =
> +	{ "fuzz", NULL, fuzz_f, 0, -1, 0, N_("[-c] [-d] field fuzzcmd..."),
> +	  N_("fuzz values on disk"), fuzz_help };
> +
> +void
> +fuzz_init(void)
> +{
> +	if (!expert_mode)
> +		return;
> +
> +	add_command(&fuzz_cmd);
> +	srand48(clock());
> +}
> +
> +static void
> +fuzz_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +" The 'fuzz' command fuzzes fields in any on-disk data structure.  For\n"
> +" block fuzzing, see the 'blocktrash' or 'write' commands."
> +"\n"
> +" Examples:\n"
> +"  Struct mode: 'fuzz core.uid zeroes'    - set an inode uid field to 0.\n"
> +"               'fuzz crc ones'           - set a crc filed to all ones.\n"
> +"               'fuzz bno[11] firstbit'   - set the high bit of a block array.\n"
> +"               'fuzz keys[5].startblock add'    - increase a btree key value.\n"
> +"               'fuzz uuid random'        - randomize the superblock uuid.\n"
> +"\n"
> +" In data mode type 'fuzz' by itself for a list of specific commands.\n\n"
> +" Specifying the -c option will allow writes of invalid (corrupt) data with\n"
> +" an invalid CRC. Specifying the -d option will allow writes of invalid data,\n"
> +" but still recalculate the CRC so we are forced to check and detect the\n"
> +" invalid data appropriately.\n\n"
> +));
> +
> +}
> +
> +static int
> +fuzz_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	pfunc_t	pf;
> +	extern char *progname;
> +	int c;
> +	bool corrupt = false;	/* Allow write of bad data w/ invalid CRC */
> +	bool invalid_data = false; /* Allow write of bad data w/ valid CRC */
> +	struct xfs_buf_ops local_ops;
> +	const struct xfs_buf_ops *stashed_ops = NULL;
> +
> +	if (x.isreadonly & LIBXFS_ISREADONLY) {
> +		dbprintf(_("%s started in read only mode, fuzzing disabled\n"),
> +			progname);
> +		return 0;
> +	}
> +
> +	if (cur_typ == NULL) {
> +		dbprintf(_("no current type\n"));
> +		return 0;
> +	}
> +
> +	pf = cur_typ->pfunc;
> +	if (pf == NULL) {
> +		dbprintf(_("no handler function for type %s, fuzz unsupported.\n"),
> +			 cur_typ->name);
> +		return 0;
> +	}
> +
> +	while ((c = getopt(argc, argv, "cd")) != EOF) {
> +		switch (c) {
> +		case 'c':
> +			corrupt = true;
> +			break;
> +		case 'd':
> +			invalid_data = true;
> +			break;
> +		default:
> +			dbprintf(_("bad option for fuzz command\n"));
> +			return 0;
> +		}
> +	}
> +
> +	if (corrupt && invalid_data) {
> +		dbprintf(_("Cannot specify both -c and -d options\n"));
> +		return 0;
> +	}
> +
> +	if (invalid_data && iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
> +			!iocur_top->ino_buf && !iocur_top->dquot_buf) {
> +		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
> +		return 0;
> +	}
> +
> +	argc -= optind;
> +	argv += optind;
> +
> +	/*
> +	 * If the buffer has no verifier or we are using standard verifier
> +	 * paths, then just fuzz it and return
> +	 */
> +	if (!iocur_top->bp->b_ops ||
> +	    !(corrupt || invalid_data)) {
> +		(*pf)(DB_FUZZ, cur_typ->fields, argc, argv);
> +		return 0;
> +	}
> +
> +
> +	/* Temporarily remove write verifier to write bad data */
> +	stashed_ops = iocur_top->bp->b_ops;
> +	local_ops.verify_read = stashed_ops->verify_read;
> +	iocur_top->bp->b_ops = &local_ops;
> +
> +	if (corrupt) {
> +		local_ops.verify_write = xfs_dummy_verify;
> +		dbprintf(_("Allowing fuzz of corrupted data and bad CRC\n"));
> +	} else if (iocur_top->ino_buf) {
> +		local_ops.verify_write = xfs_verify_recalc_inode_crc;
> +		dbprintf(_("Allowing fuzz of corrupted inode with good CRC\n"));
> +	} else if (iocur_top->dquot_buf) {
> +		local_ops.verify_write = xfs_verify_recalc_dquot_crc;
> +		dbprintf(_("Allowing fuzz of corrupted dquot with good CRC\n"));
> +	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
> +		local_ops.verify_write = iocur_top->typ->set_crc;
> +		dbprintf(_("Allowing fuzz of corrupted data with good CRC\n"));
> +	} else { /* invalid data */
> +		local_ops.verify_write = xfs_verify_recalc_crc;
> +		dbprintf(_("Allowing fuzz of corrupted data with good CRC\n"));
> +	}
> +
> +	(*pf)(DB_FUZZ, cur_typ->fields, argc, argv);
> +
> +	iocur_top->bp->b_ops = stashed_ops;
> +
> +	return 0;
> +}
> +
> +/* Write zeroes to the field */
> +static bool
> +fuzz_zeroes(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	char		*out = buf;
> +	int		bit;
> +
> +	if (bitoff % NBBY || nbits % NBBY) {
> +		for (bit = 0; bit < nbits; bit++)
> +			setbit_l(out, bit + bitoff, 0);
> +	} else
> +		memset(out + byteize(bitoff), 0, byteize(nbits));
> +	return true;
> +}
> +
> +/* Write ones to the field */
> +static bool
> +fuzz_ones(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	char		*out = buf;
> +	int		bit;
> +
> +	if (bitoff % NBBY || nbits % NBBY) {
> +		for (bit = 0; bit < nbits; bit++)
> +			setbit_l(out, bit + bitoff, 1);
> +	} else
> +		memset(out + byteize(bitoff), 0xFF, byteize(nbits));
> +	return true;
> +}
> +
> +/* Flip the high bit in the (presumably big-endian) field */
> +static bool
> +fuzz_firstbit(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	setbit_l((char *)buf, bitoff, !getbit_l((char *)buf, bitoff));
> +	return true;
> +}
> +
> +/* Flip the low bit in the (presumably big-endian) field */
> +static bool
> +fuzz_lastbit(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	setbit_l((char *)buf, bitoff + nbits - 1,
> +			!getbit_l((char *)buf, bitoff));
> +	return true;
> +}
> +
> +/* Flip the middle bit in the (presumably big-endian) field */
> +static bool
> +fuzz_middlebit(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	setbit_l((char *)buf, bitoff + nbits / 2,
> +			!getbit_l((char *)buf, bitoff));
> +	return true;
> +}
> +
> +/* Format and shift a number into a buffer for setbitval. */
> +static char *
> +format_number(
> +	uint64_t	val,
> +	__be64		*out,
> +	int		bit_length)
> +{
> +	int		offset;
> +	char		*rbuf = (char *)out;
> +
> +	/*
> +	 * If the length of the field is not a multiple of a byte, push
> +	 * the bits up in the field, so the most signicant field bit is
> +	 * the most significant bit in the byte:
> +	 *
> +	 * before:
> +	 * val  |----|----|----|----|----|--MM|mmmm|llll|
> +	 * after
> +	 * val  |----|----|----|----|----|MMmm|mmll|ll00|
> +	 */
> +	offset = bit_length % NBBY;
> +	if (offset)
> +		val <<= (NBBY - offset);
> +
> +	/*
> +	 * convert to big endian and copy into the array
> +	 * rbuf |----|----|----|----|----|MMmm|mmll|ll00|
> +	 */
> +	*out = cpu_to_be64(val);
> +
> +	/*
> +	 * Align the array to point to the field in the array.
> +	 *  rbuf  = |MMmm|mmll|ll00|
> +	 */
> +	offset = sizeof(__be64) - 1 - ((bit_length - 1) / sizeof(__be64));
> +	return rbuf + offset;
> +}
> +
> +/* Increase the value by some small prime number. */
> +static bool
> +fuzz_add(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	uint64_t	val;
> +	__be64		out;
> +	char		*b;
> +
> +	if (nbits > 64)
> +		return false;
> +
> +	val = getbitval(buf, bitoff, nbits, BVUNSIGNED);
> +	val += (nbits > 8 ? 2017 : 137);
> +	b = format_number(val, &out, nbits);
> +	setbitval(buf, bitoff, nbits, b);
> +
> +	return true;
> +}
> +
> +/* Decrease the value by some small prime number. */
> +static bool
> +fuzz_sub(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	uint64_t	val;
> +	__be64		out;
> +	char		*b;
> +
> +	if (nbits > 64)
> +		return false;
> +
> +	val = getbitval(buf, bitoff, nbits, BVUNSIGNED);
> +	val -= (nbits > 8 ? 2017 : 137);
> +	b = format_number(val, &out, nbits);
> +	setbitval(buf, bitoff, nbits, b);
> +
> +	return true;
> +}
> +
> +/* Randomize the field. */
> +static bool
> +fuzz_random(
> +	void		*buf,
> +	int		bitoff,
> +	int		nbits)
> +{
> +	int		i, bytes;
> +	char		*b, *rbuf;
> +
> +	bytes = byteize_up(nbits);
> +	rbuf = b = malloc(bytes);
> +	if (!b) {
> +		perror("fuzz_random");
> +		return false;
> +	}
> +
> +	for (i = 0; i < bytes; i++)
> +		*b++ = (char)lrand48();
> +
> +	setbitval(buf, bitoff, nbits, rbuf);
> +	free(rbuf);
> +
> +	return true;
> +}
> +
> +struct fuzzcmd {
> +	const char	*verb;
> +	bool		(*fn)(void *buf, int bitoff, int nbits);
> +};
> +
> +/* Keep these verbs in sync with enum fuzzcmds. */
> +static struct fuzzcmd fuzzverbs[] = {
> +	{"zeroes",		fuzz_zeroes},
> +	{"ones",		fuzz_ones},
> +	{"firstbit",		fuzz_firstbit},
> +	{"middlebit",		fuzz_middlebit},
> +	{"lastbit",		fuzz_lastbit},
> +	{"add",			fuzz_add},
> +	{"sub",			fuzz_sub},
> +	{"random",		fuzz_random},
> +	{NULL,			NULL},
> +};
> +
> +/* ARGSUSED */
> +void
> +fuzz_struct(
> +	const field_t	*fields,
> +	int		argc,
> +	char		**argv)
> +{
> +	const ftattr_t	*fa;
> +	flist_t		*fl;
> +	flist_t		*sfl;
> +	int		bit_length;
> +	struct fuzzcmd	*fc;
> +	bool		success;
> +	int		parentoffset;
> +
> +	if (argc != 2) {
> +		dbprintf(_("Usage: fuzz fieldname verb\n"));
> +		dbprintf("Verbs: %s", fuzzverbs->verb);
> +		for (fc = fuzzverbs + 1; fc->verb != NULL; fc++)
> +			dbprintf(", %s", fc->verb);
> +		dbprintf(".\n");
> +		return;
> +	}
> +
> +	fl = flist_scan(argv[0]);
> +	if (!fl) {
> +		dbprintf(_("unable to parse '%s'.\n"), argv[0]);
> +		return;
> +	}
> +
> +	/* Find our fuzz verb */
> +	for (fc = fuzzverbs; fc->verb != NULL; fc++)
> +		if (!strcmp(fc->verb, argv[1]))
> +			break;
> +	if (fc->fn == NULL) {
> +		dbprintf(_("Unknown fuzz command '%s'.\n"), argv[1]);
> +		return;
> +	}
> +
> +	/* if we're a root field type, go down 1 layer to get field list */
> +	if (fields->name[0] == '\0') {
> +		fa = &ftattrtab[fields->ftyp];
> +		ASSERT(fa->ftyp == fields->ftyp);
> +		fields = fa->subfld;
> +	}
> +
> +	/* run down the field list and set offsets into the data */
> +	if (!flist_parse(fields, fl, iocur_top->data, 0)) {
> +		flist_free(fl);
> +		dbprintf(_("parsing error\n"));
> +		return;
> +	}
> +
> +	sfl = fl;
> +	parentoffset = 0;
> +	while (sfl->child) {
> +		parentoffset = sfl->offset;
> +		sfl = sfl->child;
> +	}
> +
> +	/*
> +	 * For structures, fsize * fcount tells us the size of the region we are
> +	 * modifying, which is usually a single structure member and is pointed
> +	 * to by the last child in the list.
> +	 *
> +	 * However, if the base structure is an array and we have a direct index
> +	 * into the array (e.g. write bno[5]) then we are returned a single
> +	 * flist object with the offset pointing directly at the location we
> +	 * need to modify. The length of the object we are modifying is then
> +	 * determined by the size of the individual array entry (fsize) and the
> +	 * indexes defined in the object, not the overall size of the array
> +	 * (which is what fcount returns).
> +	 */
> +	bit_length = fsize(sfl->fld, iocur_top->data, parentoffset, 0);
> +	if (sfl->fld->flags & FLD_ARRAY)
> +		bit_length *= sfl->high - sfl->low + 1;
> +	else
> +		bit_length *= fcount(sfl->fld, iocur_top->data, parentoffset);
> +
> +	/* Fuzz the value */
> +	success = fc->fn(iocur_top->data, sfl->offset, bit_length);
> +	if (!success) {
> +		dbprintf(_("unable to fuzz field '%s'\n"), argv[0]);
> +		flist_free(fl);
> +		return;
> +	}
> +
> +	/* Write the fuzzed value back */
> +	write_cur();
> +
> +	flist_print(fl);
> +	print_flist(fl);
> +	flist_free(fl);
> +}
> diff --git a/db/fuzz.h b/db/fuzz.h
> new file mode 100644
> index 0000000..c203eb5
> --- /dev/null
> +++ b/db/fuzz.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +extern void	fuzz_init(void);
> +extern void	fuzz_struct(const field_t *fields, int argc, char **argv);
> diff --git a/db/type.c b/db/type.c
> index bf31e04..740adc0 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -39,6 +39,7 @@
>  #include "dir2.h"
>  #include "text.h"
>  #include "symlink.h"
> +#include "fuzz.h"
>  
>  static const typ_t	*findtyp(char *name);
>  static int		type_f(int argc, char **argv);
> @@ -254,10 +255,17 @@ handle_struct(
>  	int           argc,
>  	char          **argv)
>  {
> -	if (action == DB_WRITE)
> +	switch (action) {
> +	case DB_FUZZ:
> +		fuzz_struct(fields, argc, argv);
> +		break;
> +	case DB_WRITE:
>  		write_struct(fields, argc, argv);
> -	else
> +		break;
> +	case DB_READ:
>  		print_struct(fields, argc, argv);
> +		break;
> +	}
>  }
>  
>  void
> @@ -267,10 +275,17 @@ handle_string(
>  	int           argc,
>  	char          **argv)
>  {
> -	if (action == DB_WRITE)
> +	switch (action) {
> +	case DB_WRITE:
>  		write_string(fields, argc, argv);
> -	else
> +		break;
> +	case DB_READ:
>  		print_string(fields, argc, argv);
> +		break;
> +	case DB_FUZZ:
> +		dbprintf(_("string fuzzing not supported.\n"));
> +		break;
> +	}
>  }
>  
>  void
> @@ -280,10 +295,17 @@ handle_block(
>  	int           argc,
>  	char          **argv)
>  {
> -	if (action == DB_WRITE)
> +	switch (action) {
> +	case DB_WRITE:
>  		write_block(fields, argc, argv);
> -	else
> +		break;
> +	case DB_READ:
>  		print_block(fields, argc, argv);
> +		break;
> +	case DB_FUZZ:
> +		dbprintf(_("use 'blocktrash' or 'write' to fuzz a block.\n"));
> +		break;
> +	}
>  }
>  
>  void
> @@ -293,6 +315,14 @@ handle_text(
>  	int           argc,
>  	char          **argv)
>  {
> -	if (action != DB_WRITE)
> +	switch (action) {
> +	case DB_FUZZ:
> +		/* fall through */
> +	case DB_WRITE:
> +		dbprintf(_("text writing/fuzzing not supported.\n"));
> +		break;
> +	case DB_READ:
>  		print_text(fields, argc, argv);
> +		break;
> +	}
>  }
> diff --git a/db/type.h b/db/type.h
> index 85d89c7..3971975 100644
> --- a/db/type.h
> +++ b/db/type.h
> @@ -30,6 +30,7 @@ typedef enum typnm
>  	TYP_TEXT, TYP_FINOBT, TYP_NONE
>  } typnm_t;
>  
> +#define DB_FUZZ  2
>  #define DB_WRITE 1
>  #define DB_READ  0
>  
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index b3129f7..49e665a 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -613,6 +613,55 @@ in units of 512-byte blocks, no matter what the filesystem's block size is.
>  .BI "The optional " start " and " end " arguments can be used to constrain
>  the output to a particular range of disk blocks.
>  .TP
> +.BI "fuzz [\-c] [\-d] " "field action"
> +Write garbage into a specific structure field on disk.
> +Expert mode must be enabled to use this command.
> +The operation happens immediately; there is no buffering.
> +.IP
> +The fuzz command can take the following
> +.IR action "s"
> +against a field:
> +.RS 1.0i
> +.TP 0.4i
> +.B zeroes
> +Clears all bits in the field.
> +.TP 0.4i
> +.B ones
> +Sets all bits in the field.
> +.TP 0.4i
> +.B firstbit
> +Flips the first bit in the field.
> +For a scalar value, this is the highest bit.
> +.TP 0.4i
> +.B middlebit
> +Flips the middle bit in the field.
> +.TP 0.4i
> +.B lastbit
> +Flips the last bit in the field.
> +For a scalar value, this is the lowest bit.
> +.TP 0.4i
> +.B add
> +Adds a small value to a scalar field.
> +.TP 0.4i
> +.B sub
> +Subtracts a small value from a scalar field.
> +.TP 0.4i
> +.B random
> +Randomizes the contents of the field.
> +.RE
> +.IP
> +The following switches affect the write behavior:
> +.RS 1.0i
> +.TP 0.4i
> +.B \-c
> +Skip write verifiers and CRC recalculation; allows invalid data to be written
> +to disk.
> +.TP 0.4i
> +.B \-d
> +Skip write verifiers but perform CRC recalculation; allows invalid data to be
> +written to disk to test detection of invalid data.
> +.RE
> +.TP
>  .BI hash " string
>  Prints the hash value of
>  .I string
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
