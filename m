Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53818 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753214AbcLOET0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 23:19:26 -0500
Subject: Re: [PATCH] xfs_io: implement 'set_encpolicy' and 'get_encpolicy'
 commands
References: <1480371512-12493-1-git-send-email-ebiggers@google.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c6553dba-e7da-0692-cc2e-a1a59aaa8bf8@sandeen.net>
Date: Wed, 14 Dec 2016 22:19:24 -0600
MIME-Version: 1.0
In-Reply-To: <1480371512-12493-1-git-send-email-ebiggers@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Richard Weinberger <richard@nod.at>, David Gstir <david@sigma-star.at>, Michael Halcrow <mhalcrow@google.com>

On 11/28/16 4:18 PM, Eric Biggers wrote:
> Add set_encpolicy and get_encpolicy commands to xfs_io so that xfstests
> will be able to test filesystem encryption using the actual user API,
> not just hacked in with a mount option.  These commands use the common
> "fscrypt" API currently implemented by ext4 and f2fs, but it's also
> under development for ubifs and planned for xfs.
> 
> Note that to get encrypted files to actually work, it's also necessary
> to add a key to the kernel keyring.  This patch does not add a command
> for this to xfs_io because it's possible to do it using keyctl.  keyctl
> can also be used to remove keys, revoke keys, invalidate keys, etc.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  io/Makefile       |   6 +-
>  io/encrypt.c      | 303 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  io/init.c         |   1 +
>  io/io.h           |   1 +
>  man/man8/xfs_io.8 |  27 +++++
>  5 files changed, 335 insertions(+), 3 deletions(-)
>  create mode 100644 io/encrypt.c
> 
> diff --git a/io/Makefile b/io/Makefile
> index 1072e74..89cca66 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -9,9 +9,9 @@ LTCOMMAND = xfs_io
>  LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
>  HFILES = init.h io.h
>  CFILES = init.c \
> -	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
> -	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
> -	sync.c truncate.c reflink.c cowextsize.c
> +	attr.c bmap.c encrypt.c file.c freeze.c fsync.c getrusage.c imap.c   \
> +	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c     \
> +	shutdown.c sync.c truncate.c reflink.c cowextsize.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
> diff --git a/io/encrypt.c b/io/encrypt.c
> new file mode 100644
> index 0000000..2006684
> --- /dev/null
> +++ b/io/encrypt.c
> @@ -0,0 +1,303 @@
> +/*
> + * Copyright (c) 2016 Google, Inc.  All Rights Reserved.
> + *
> + * Author: Eric Biggers <ebiggers@google.com>
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
> +#include "platform_defs.h"
> +#include "command.h"
> +#include "init.h"
> +#include "io.h"
> +
> +#ifndef ARRAY_SIZE
> +#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> +#endif
> +
> +/*
> + * We have to define the ioctl structures and constants ourselves because
> + * someone may be compiling xfsprogs with old kernel headers.  Also, as of Linux
> + * 4.9, not all the needed definitions are in <linux/fs.h>.
> + */

Ok, but this needs to be guarded, then - or else newer kernel
headers will cause it to fail:

    [CC]     encrypt.o
encrypt.c:37:8: error: redefinition of ‘struct fscrypt_policy’
 struct fscrypt_policy {
        ^~~~~~~~~~~~~~
In file included from ../include/xfs/linux.h:38:0,
                 from ../include/xfs.h:37,
                 from io.h:19,
                 from encrypt.c:23:
/usr/include/linux/fs.h:257:8: note: originally defined here
 struct fscrypt_policy {
        ^~~~~~~~~~~~~~
../include/buildrules:59: recipe for target 'encrypt.o' failed


> +#define FS_KEY_DESCRIPTOR_SIZE  8
> +
> +struct fscrypt_policy {
> +	__u8 version;
> +	__u8 contents_encryption_mode;
> +	__u8 filenames_encryption_mode;
> +	__u8 flags;
> +	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> +} __attribute__((packed));
> +
> +#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
> +#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
> +#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
> +
> +#define FS_POLICY_FLAGS_PAD_4		0x00
> +#define FS_POLICY_FLAGS_PAD_8		0x01
> +#define FS_POLICY_FLAGS_PAD_16		0x02
> +#define FS_POLICY_FLAGS_PAD_32		0x03
> +#define FS_POLICY_FLAGS_PAD_MASK	0x03
> +#define FS_POLICY_FLAGS_VALID		0x03
> +
> +#define FS_ENCRYPTION_MODE_INVALID	0
> +#define FS_ENCRYPTION_MODE_AES_256_XTS	1
> +#define FS_ENCRYPTION_MODE_AES_256_GCM	2
> +#define FS_ENCRYPTION_MODE_AES_256_CBC	3
> +#define FS_ENCRYPTION_MODE_AES_256_CTS	4
> +
> +static cmdinfo_t get_encpolicy_cmd;
> +static cmdinfo_t set_encpolicy_cmd;
> +
> +static void
> +get_encpolicy_help(void)
> +{
> +	printf(_(
> +"\n"
> +" display the encryption policy of the currently open file\n"
> +"\n"));
> +}

No need to add this, it ends up just restating the short help:

xfs_io> help get_encpolicy
get_encpolicy -- display the encryption policy of the current file

 display the encryption policy of the currently open file

xfs_io> 

if you leave out the .help altogether you'll just get the oneline
help, which is enough here.

(random thought, if you call them encpolicy_set and encpolicy_get,
they'll end up next to each other in help output, but *shrug*)

> +static void
> +set_encpolicy_help(void)
> +{
> +	printf(_(
> +"\n"
> +" assign an encryption policy to the currently open file\n"
> +"\n"
> +" Examples:\n"
> +" 'set_encpolicy' - assign policy with default key [0000000000000000]\n"
> +" 'set_encpolicy 0000111122223333' - assign policy with specified key\n"
> +"\n"
> +" -c MODE -- contents encryption mode\n"
> +" -n MODE -- filenames encryption mode\n"
> +" -f FLAGS -- policy flags\n"
> +" -v VERSION -- version of policy structure\n"
> +"\n"
> +"MODE can be numeric or one of the following predefined values:\n"
> +"    AES-256-XTS, AES-256-CTS, AES-256-GCM, AES-256-CBC\n"
> +"FLAGS and VERSION must be numeric.\n"
> +"\n"
> +"Note that it's only possible to set an encryption policy on an empty\n"
> +"directory.  It's then inherited by new files and subdirectories.\n"
> +"\n"));

I think every other long help indents each line by at one space, so for
consistency that would be good here as well - it sets the help text
apart a bit more.

> +}
> +
> +static const struct {
> +	__u8 mode;
> +	const char *name;
> +} available_modes[] = {
> +	{FS_ENCRYPTION_MODE_AES_256_XTS, "AES-256-XTS"},
> +	{FS_ENCRYPTION_MODE_AES_256_CTS, "AES-256-CTS"},
> +	{FS_ENCRYPTION_MODE_AES_256_GCM, "AES-256-GCM"},
> +	{FS_ENCRYPTION_MODE_AES_256_CBC, "AES-256-CBC"},
> +};
> +
> +static int
> +parse_byte_value(const char *arg, __u8 *value_ret)
> +{
> +	long value;
> +	char *tmp;
> +
> +	value = strtol(arg, &tmp, 0);
> +	if (value < 0 || value > 255 || tmp == arg || *tmp != '\0')
> +		return 1;
> +	*value_ret = value;
> +	return 0;
> +}
> +
> +static int
> +parse_mode(const char *arg, __u8 *mode_ret)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(available_modes); i++) {
> +		if (strcmp(arg, available_modes[i].name) == 0) {
> +			*mode_ret = available_modes[i].mode;
> +			return 0;
> +		}
> +	}
> +
> +	return parse_byte_value(arg, mode_ret);
> +}
> +
> +static const char *
> +mode2str(__u8 mode)
> +{
> +	static char buf[32];
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(available_modes); i++)
> +		if (mode == available_modes[i].mode)
> +			return available_modes[i].name;
> +
> +	sprintf(buf, "0x%02x", mode);
> +	return buf;
> +}
> +
> +static const char *
> +keydesc2str(__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE])
> +{
> +	static char buf[2 * FS_KEY_DESCRIPTOR_SIZE + 1];
> +	int i;
> +
> +	for (i = 0; i < FS_KEY_DESCRIPTOR_SIZE; i++)
> +		sprintf(&buf[2 * i], "%02x", master_key_descriptor[i]);
> +
> +	return buf;
> +}
> +
> +static int
> +get_encpolicy_f(int argc, char **argv)
> +{
> +	struct fscrypt_policy policy;
> +
> +	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY, &policy) < 0) {
> +		fprintf(stderr, "%s: failed to get encryption policy: %s\n",
> +			file->name, strerror(errno));
> +		return 1;

Ok, I need to go look at dave's other patch series to give you guidance
on what to return here, or anything else under the foo_f() functions.

see [PATCH 0/6] xfs_io: fix up command iteration - I need to see how dave
wants that all to work now.  Prior to that, anyway, most commands returned
0 even on an error, and possibly set exitcode = 1, but I have to see what
that patchset does.

> +	}
> +
> +	printf("Encryption policy for %s:\n", file->name);
> +	printf("\tPolicy version: %u\n", policy.version);
> +	printf("\tMaster key descriptor: %s\n",
> +	       keydesc2str(policy.master_key_descriptor));
> +	printf("\tContents encryption mode: %u (%s)\n",
> +	       policy.contents_encryption_mode,
> +	       mode2str(policy.contents_encryption_mode));
> +	printf("\tFilenames encryption mode: %u (%s)\n",
> +	       policy.filenames_encryption_mode,
> +	       mode2str(policy.filenames_encryption_mode));
> +	printf("\tFlags: 0x%02x\n", policy.flags);
> +	return 0;
> +}
> +
> +static int
> +set_encpolicy_f(int argc, char **argv)
> +{
> +	int c;
> +	struct fscrypt_policy policy;
> +
> +	/* Initialize the policy structure with default values */
> +	memset(&policy, 0, sizeof(policy));
> +	policy.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
> +	policy.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
> +	policy.flags = FS_POLICY_FLAGS_PAD_16;
> +
> +	/* Parse options */
> +	while ((c = getopt(argc, argv, "c:n:f:v:")) != EOF) {
> +		switch (c) {
> +		case 'c':
> +			if (parse_mode(optarg,
> +				       &policy.contents_encryption_mode)) {
> +				fprintf(stderr, "invalid contents encryption "
> +					"mode: %s\n", optarg);
> +				return 1;
> +			}
> +			break;
> +		case 'n':
> +			if (parse_mode(optarg,
> +				       &policy.filenames_encryption_mode)) {
> +				fprintf(stderr, "invalid filenames encryption "
> +					"mode: %s\n", optarg);
> +				return 1;
> +			}
> +			break;
> +		case 'f':
> +			if (parse_byte_value(optarg, &policy.flags)) {
> +				fprintf(stderr, "invalid flags: %s\n", optarg);
> +				return 1;
> +			}
> +			break;
> +		case 'v':
> +			if (parse_byte_value(optarg, &policy.version)) {
> +				fprintf(stderr, "invalid policy version: %s\n",
> +					optarg);
> +				return 1;
> +			}
> +			break;
> +		default:
> +			return command_usage(&set_encpolicy_cmd);
> +		}
> +	}
> +	argc -= optind;
> +	argv += optind;
> +
> +	if (argc > 1)
> +		return command_usage(&set_encpolicy_cmd);
> +
> +	/* Parse key descriptor if specified */
> +	if (argc > 0) {
> +		const char *keydesc = argv[0];
> +		char *tmp;
> +		unsigned long long x;
> +		int i;
> +
> +		if (strlen(keydesc) != FS_KEY_DESCRIPTOR_SIZE * 2) {
> +			fprintf(stderr, "invalid key descriptor: %s\n",
> +				keydesc);
> +			return 1;
> +		}
> +
> +		x = strtoull(keydesc, &tmp, 16);
> +		if (tmp == keydesc || *tmp != '\0') {
> +			fprintf(stderr, "invalid key descriptor: %s\n",
> +				keydesc);
> +			return 1;
> +		}
> +
> +		for (i = 0; i < FS_KEY_DESCRIPTOR_SIZE; i++) {
> +			policy.master_key_descriptor[i] = x >> 56;
> +			x <<= 8;
> +		}
> +	}
> +
> +	/* Set the encryption policy */
> +	if (ioctl(file->fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) < 0) {
> +		fprintf(stderr, "%s: failed to set encryption policy: %s\n",
> +			file->name, strerror(errno));
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +void
> +encrypt_init(void)
> +{
> +	get_encpolicy_cmd.name = "get_encpolicy";
> +	get_encpolicy_cmd.cfunc = get_encpolicy_f;
> +	get_encpolicy_cmd.argmin = 0;
> +	get_encpolicy_cmd.argmax = 0;
> +	get_encpolicy_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	get_encpolicy_cmd.oneline =
> +		_("display the encryption policy of the current file");
> +	get_encpolicy_cmd.help = get_encpolicy_help;

just drop that, since it's the same as the oneline.

-Eric

> +
> +	set_encpolicy_cmd.name = "set_encpolicy";
> +	set_encpolicy_cmd.cfunc = set_encpolicy_f;
> +	set_encpolicy_cmd.args =
> +		_("[-c mode] [-n mode] [-f flags] [-v version] [keydesc]");
> +	set_encpolicy_cmd.argmin = 0;
> +	set_encpolicy_cmd.argmax = -1;
> +	set_encpolicy_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	set_encpolicy_cmd.oneline =
> +		_("assign an encryption policy to the current file");
> +	set_encpolicy_cmd.help = set_encpolicy_help;
> +
> +	add_command(&get_encpolicy_cmd);
> +	add_command(&set_encpolicy_cmd);
> +}
> diff --git a/io/init.c b/io/init.c
> index a9191cf..ee7683e 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -59,6 +59,7 @@ init_commands(void)
>  	attr_init();
>  	bmap_init();
>  	copy_range_init();
> +	encrypt_init();
>  	fadvise_init();
>  	file_init();
>  	flink_init();
> diff --git a/io/io.h b/io/io.h
> index 5d21314..d257daa 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -94,6 +94,7 @@ extern void		dump_buffer(off64_t, ssize_t);
>  
>  extern void		attr_init(void);
>  extern void		bmap_init(void);
> +extern void		encrypt_init(void);
>  extern void		file_init(void);
>  extern void		flink_init(void);
>  extern void		freeze_init(void);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 885df7f..27008de 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -890,6 +890,33 @@ verbose output will be printed.
>  .IP
>  .B [NOTE: Not currently operational on Linux.]
>  .PD
> +.TP
> +.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]
> +On filesystems that support encryption, assign an encryption policy to the
> +current file.
> +.I keydesc
> +is a 16-byte hex string which identifies the encryption key to use.
> +If not specified, a "default" key descriptor of all 0's will be used.
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.BI \-c " mode
> +contents encryption mode (e.g. AES-256-XTS)
> +.TP
> +.BI \-n " mode
> +filenames encryption mode (e.g. AES-256-CTS)
> +.TP
> +.BI \-f " flags
> +policy flags (numeric)
> +.TP
> +.BI \-v " version
> +version of policy structure (numeric)
> +.RE
> +.PD
> +.TP
> +.BR get_encpolicy
> +On filesystems that support encryption, display the encryption policy of the
> +current file.
>  
>  .SH SEE ALSO
>  .BR mkfs.xfs (8),
> 
