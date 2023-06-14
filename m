Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0EFEB64D9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jun 2023 11:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbjFNLcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 07:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbjFNLcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 07:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC8F199B
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 04:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4149B640F9
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 11:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D32C433C8;
        Wed, 14 Jun 2023 11:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686742358;
        bh=823fsoWJyl9v7izfH6YiopsW6jnRR5XdMZ0OWSfKNK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sfBcOFjINvIJwVNmlfWmgbeQr238UyJKXH384lX4jOjDzWnSd4D0/J0tgpEjha5Bi
         mborgkc5oWwovCL9kznS+kKCQC+srihPZyt8l1zVbFxds5aBwqNpuVKQypX/3iLIDr
         Lb2dHSoBdrbJUYXrJ3kMN1b42vp4LIq1qk/LWS8YRCt90nEbw53oENJO/tXQDiNu8g
         hjjBDxhBuXySuW0NW9kCAuhoFAQD5SftRXNOQmbdOMOSQXuUBPBc5EvlHIuyYlzZdY
         aUweUhTE3r8i5/KCiouwHk2yZTed17DorBU4sMvKHinP+8bGgGxf0Bq7AT53it0esA
         iNWwtyWh3M9aQ==
Date:   Wed, 14 Jun 2023 13:32:34 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_db: create dirents and xattrs with colliding
 names
Message-ID: <20230614113234.7pumraglyop3xhrc@andromeda>
References: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
 <kLYmWsQKNR_apZ0Yx8S3syddXm4nd4p7G5nI70z-T_kTGS9rutWN0Ps1Tpl7xCvk-0jehmy5ZHmoSQQCugcMXA==@protonmail.internalid>
 <168597942996.1226265.4909168279377490281.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <168597942996.1226265.4909168279377490281.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick.

On Mon, Jun 05, 2023 at 08:37:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new debugger command that will create dirent and xattr names
> that induce dahash collisions.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/hash.c         |  376 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_db.8 |   31 ++++
>  2 files changed, 407 insertions(+)

This patch is trigerring a bunch of warnings due differing type on db/hash.c, like:


=====
hash.c: In function ‘collide_dirents’:
hash.c:226:22: warning: pointer targets in passing argument 2 of ‘openat’ differ in signedness [-Wpointer-sign]
  226 |   newfd = openat(fd, name, O_CREAT, 0600);
      |                      ^~~~
      |                      |
      |                      const unsigned char *
In file included from /usr/include/features.h:461,
                 from /usr/include/x86_64-linux-gnu/bits/libc-header-start.h:33,
                 from /usr/include/stdio.h:27,
                 from ../include/platform_defs.h:10,
                 from ../include/libxfs.h:11,
                 from hash.c:7:
/usr/include/fcntl.h:196:12: note: expected ‘const char *’ but argument is of type ‘const unsigned char *’
  196 | extern int __REDIRECT (openat, (int __fd, const char *__file, int __oflag,
      |            ^~~~~~~~~~
hash.c:241:11: warning: pointer targets in passing argument 1 of ‘strncpy’ differ in signedness [-Wpointer-sign]
  241 |   strncpy(direntname, name, MAXNAMELEN);
      |           ^~~~~~~~~~
      |           |
      |           unsigned char *
In file included from ../include/platform_defs.h:17,
                 from ../include/libxfs.h:11,
                 from hash.c:7:

=====

Could you please take a look onto it?

Thanks!

-- 
Carlos

> 
> 
> diff --git a/db/hash.c b/db/hash.c
> index 68c53e7f9bc..79a250526e9 100644
> --- a/db/hash.c
> +++ b/db/hash.c
> @@ -5,12 +5,15 @@
>   */
> 
>  #include "libxfs.h"
> +#include "init.h"
>  #include "addr.h"
>  #include "command.h"
>  #include "type.h"
>  #include "io.h"
>  #include "output.h"
>  #include "hash.h"
> +#include "obfuscate.h"
> +#include <sys/xattr.h>
> 
>  static int hash_f(int argc, char **argv);
>  static void hash_help(void);
> @@ -46,8 +49,381 @@ hash_f(
>  	return 0;
>  }
> 
> +static void
> +hashcoll_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Generate obfuscated variants of the provided name.  Each variant will have\n"
> +" the same dahash value.  Names are written to stdout with a NULL separating\n"
> +" each name.\n"
> +"\n"
> +" -a -- create extended attributes.\n"
> +" -i -- read standard input for the name, up to %d bytes.\n"
> +" -n -- create this many names.\n"
> +" -p -- create directory entries or extended attributes in this file.\n"
> +" -s -- seed the rng with this value.\n"
> +"\n"),
> +			MAXNAMELEN - 1);
> +}
> +
> +struct name_dup {
> +	struct name_dup	*next;
> +	uint32_t	crc;
> +	uint8_t		namelen;
> +	uint8_t		name[];
> +};
> +
> +static inline size_t
> +name_dup_sizeof(
> +	unsigned int	namelen)
> +{
> +	return sizeof(struct name_dup) + namelen;
> +}
> +
> +#define MAX_DUP_TABLE_BUCKETS	(1048575)
> +
> +struct dup_table {
> +	unsigned int	nr_buckets;
> +	struct name_dup	*buckets[];
> +};
> +
> +static inline size_t
> +dup_table_sizeof(
> +	unsigned int	nr_buckets)
> +{
> +	return sizeof(struct dup_table) +
> +				(nr_buckets * sizeof(struct name_dup *));
> +}
> +
> +static int
> +dup_table_alloc(
> +	unsigned long		nr_names,
> +	struct dup_table	**tabp)
> +{
> +	struct dup_table	*t;
> +
> +	*tabp = NULL;
> +
> +	if (nr_names == 1)
> +		return 0;
> +
> +	nr_names = min(MAX_DUP_TABLE_BUCKETS, nr_names);
> +	t = calloc(1, dup_table_sizeof(nr_names));
> +	if (!t)
> +		return ENOMEM;
> +
> +	t->nr_buckets = nr_names;
> +	*tabp = t;
> +	return 0;
> +}
> +
> +static void
> +dup_table_free(
> +	struct dup_table	*tab)
> +{
> +	struct name_dup		*ent, *next;
> +	unsigned int		i;
> +
> +	if (!tab)
> +		return;
> +
> +	for (i = 0; i < tab->nr_buckets; i++) {
> +		ent = tab->buckets[i];
> +
> +		while (ent) {
> +			next = ent->next;
> +			free(ent);
> +			ent = next;
> +		}
> +	}
> +	free(tab);
> +}
> +
> +static struct name_dup *
> +dup_table_find(
> +	struct dup_table	*tab,
> +	unsigned char		*name,
> +	size_t			namelen)
> +{
> +	struct name_dup		*ent;
> +	uint32_t		crc = crc32c(~0, name, namelen);
> +
> +	ent = tab->buckets[crc % tab->nr_buckets];
> +	while (ent) {
> +		if (ent->crc == crc &&
> +		    ent->namelen == namelen &&
> +		    !memcmp(ent->name, name, namelen))
> +			return ent;
> +
> +		ent = ent->next;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int
> +dup_table_store(
> +	struct dup_table	*tab,
> +	unsigned char		*name,
> +	size_t			namelen)
> +{
> +	struct name_dup		*dup;
> +	uint32_t		seq = 1;
> +
> +	ASSERT(namelen < MAXNAMELEN);
> +
> +	while ((dup = dup_table_find(tab, name, namelen)) != NULL) {
> +		int		ret;
> +
> +		do {
> +			ret = find_alternate(namelen, name, seq++);
> +		} while (ret == 0);
> +		if (ret < 0)
> +			return EEXIST;
> +	}
> +
> +	dup = malloc(name_dup_sizeof(namelen));
> +	if (!dup)
> +		return ENOMEM;
> +
> +	dup->crc = crc32c(~0, name, namelen);
> +	dup->namelen = namelen;
> +	memcpy(dup->name, name, namelen);
> +	dup->next = tab->buckets[dup->crc % tab->nr_buckets];
> +
> +	tab->buckets[dup->crc % tab->nr_buckets] = dup;
> +	return 0;
> +}
> +
> +static int
> +collide_dirents(
> +	unsigned long		nr,
> +	const unsigned char	*name,
> +	size_t			namelen,
> +	int			fd)
> +{
> +	struct xfs_name		dname = {
> +		.name		= name,
> +		.len		= namelen,
> +	};
> +	unsigned char		direntname[MAXNAMELEN + 1];
> +	struct dup_table	*tab = NULL;
> +	xfs_dahash_t		old_hash;
> +	unsigned long		i;
> +	int			error = 0;
> +
> +	old_hash = libxfs_dir2_hashname(mp, &dname);
> +
> +	if (fd >= 0) {
> +		int		newfd;
> +
> +		/*
> +		 * User passed in a fd, so we'll use the directory to detect
> +		 * duplicate names.  First create the name that we are passed
> +		 * in; the new names will be hardlinks to the first file.
> +		 */
> +		newfd = openat(fd, name, O_CREAT, 0600);
> +		if (newfd < 0)
> +			return errno;
> +		close(newfd);
> +	} else if (nr > 1) {
> +		/*
> +		 * Track every name we create so that we don't emit duplicates.
> +		 */
> +		error = dup_table_alloc(nr, &tab);
> +		if (error)
> +			return error;
> +	}
> +
> +	dname.name = direntname;
> +	for (i = 0; i < nr; i++) {
> +		strncpy(direntname, name, MAXNAMELEN);
> +		obfuscate_name(old_hash, namelen, direntname, true);
> +		ASSERT(old_hash == libxfs_dir2_hashname(mp, &dname));
> +
> +		if (fd >= 0) {
> +			error = linkat(fd, name, fd, direntname, 0);
> +			if (error && errno != EEXIST)
> +				return errno;
> +
> +			/* don't print names to stdout */
> +			continue;
> +		} else if (tab) {
> +			error = dup_table_store(tab, direntname, namelen);
> +			if (error)
> +				break;
> +		}
> +
> +		printf("%s%c", direntname, 0);
> +	}
> +
> +	dup_table_free(tab);
> +	return error;
> +}
> +
> +static int
> +collide_xattrs(
> +	unsigned long		nr,
> +	const unsigned char	*name,
> +	size_t			namelen,
> +	int			fd)
> +{
> +	unsigned char		xattrname[MAXNAMELEN + 5];
> +	struct dup_table	*tab = NULL;
> +	xfs_dahash_t		old_hash;
> +	unsigned long		i;
> +	int			error;
> +
> +	old_hash = libxfs_da_hashname(name, namelen);
> +
> +	if (fd >= 0) {
> +		/*
> +		 * User passed in a fd, so we'll use the xattr structure to
> +		 * detect duplicate names.  First create the attribute that we
> +		 * are passed in.
> +		 */
> +		snprintf(xattrname, MAXNAMELEN + 5, "user.%s", name);
> +		error = fsetxattr(fd, xattrname, "1", 1, 0);
> +		if (error)
> +			return errno;
> +	} else if (nr > 1) {
> +		/*
> +		 * Track every name we create so that we don't emit duplicates.
> +		 */
> +		error = dup_table_alloc(nr, &tab);
> +		if (error)
> +			return error;
> +	}
> +
> +	for (i = 0; i < nr; i++) {
> +		snprintf(xattrname, MAXNAMELEN + 5, "user.%s", name);
> +		obfuscate_name(old_hash, namelen, xattrname + 5, false);
> +		ASSERT(old_hash == libxfs_da_hashname(xattrname + 5, namelen));
> +
> +		if (fd >= 0) {
> +			error = fsetxattr(fd, xattrname, "1", 1, 0);
> +			if (error)
> +				return errno;
> +
> +			/* don't print names to stdout */
> +			continue;
> +		} else if (tab) {
> +			error = dup_table_store(tab, xattrname, namelen + 5);
> +			if (error)
> +				break;
> +		}
> +
> +		printf("%s%c", xattrname, 0);
> +	}
> +
> +	dup_table_free(tab);
> +	return error;
> +}
> +
> +static int
> +hashcoll_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	const char	*path = NULL;
> +	bool		read_stdin = false;
> +	bool		create_xattr = false;
> +	unsigned long	nr = 1, seed = 0;
> +	int		fd = -1;
> +	int		c;
> +	int		error;
> +
> +	while ((c = getopt(argc, argv, "ain:p:s:")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			create_xattr = true;
> +			break;
> +		case 'i':
> +			read_stdin = true;
> +			break;
> +		case 'n':
> +			nr = strtoul(optarg, NULL, 10);
> +			break;
> +		case 'p':
> +			path = optarg;
> +			break;
> +		case 's':
> +			seed = strtoul(optarg, NULL, 10);
> +			break;
> +		default:
> +			exitcode = 1;
> +			hashcoll_help();
> +			return 0;
> +		}
> +	}
> +
> +	if (path) {
> +		int	oflags = O_RDWR;
> +
> +		if (!create_xattr)
> +			oflags = O_RDONLY | O_DIRECTORY;
> +
> +		fd = open(path, oflags);
> +		if (fd < 0) {
> +			perror(path);
> +			exitcode = 1;
> +			return 0;
> +		}
> +	}
> +
> +	if (seed)
> +		srandom(seed);
> +
> +	if (read_stdin) {
> +		char	buf[MAXNAMELEN];
> +		size_t	len;
> +
> +		len = fread(buf, 1, MAXNAMELEN - 1, stdin);
> +
> +		if (create_xattr)
> +			error = collide_xattrs(nr, buf, len, fd);
> +		else
> +			error = collide_dirents(nr, buf, len, fd);
> +		if (error) {
> +			printf(_("hashcoll: %s\n"), strerror(error));
> +			exitcode = 1;
> +		}
> +		goto done;
> +	}
> +
> +	for (c = optind; c < argc; c++) {
> +		size_t	len = strlen(argv[c]);
> +
> +		if (create_xattr)
> +			error = collide_xattrs(nr, argv[c], len, fd);
> +		else
> +			error = collide_dirents(nr, argv[c], len, fd);
> +		if (error) {
> +			printf(_("hashcoll: %s\n"), strerror(error));
> +			exitcode = 1;
> +		}
> +	}
> +
> +done:
> +	if (fd >= 0)
> +		close(fd);
> +	return 0;
> +}
> +
> +static cmdinfo_t	hashcoll_cmd = {
> +	.name		= "hashcoll",
> +	.cfunc		= hashcoll_f,
> +	.argmin		= 0,
> +	.argmax		= -1,
> +	.args		= N_("[-a] [-s seed] [-n nr] [-p path] -i|names..."),
> +	.oneline	= N_("create names that produce dahash collisions"),
> +	.help		= hashcoll_help,
> +};
> +
>  void
>  hash_init(void)
>  {
>  	add_command(&hash_cmd);
> +	add_command(&hashcoll_cmd);
>  }
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 1a2bb7e98fb..fde1c5c6c69 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -768,6 +768,37 @@ Prints the hash value of
>  .I string
>  using the hash function of the XFS directory and attribute implementation.
>  .TP
> +.BI "hashcoll [-a] [-s seed] [-n " nr "] [-p " path "] -i | " names...
> +Create directory entries or extended attributes names that all have the same
> +hash value.
> +The metadump name obfuscation algorithm is used here.
> +Names are written to standard output, with a NULL between each name for use
> +with xargs -0.
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.TP 0.4i
> +.B \-a
> +Create extended attribute names.
> +.TP 0.4i
> +.B \-i
> +Read the first name to create from standard input.
> +Up to 255 bytes are read.
> +If this option is not specified, first names are taken from the command line.
> +.TP 0.4i
> +.BI \-n " nr"
> +Create this many duplicated names.
> +The default is to create one name.
> +.TP 0.4i
> +.BI \-p " path"
> +Create directory entries or extended attributes in this file instead of
> +writing the names to standard output.
> +.TP 0.4i
> +.BI \-s " seed"
> +Seed the random number generator with this value.
> +.PD
> +.RE
> +.TP
>  .BI "help [" command ]
>  Print help for one or all commands.
>  .TP
> 
