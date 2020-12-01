Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F02DC64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 14:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15516205CA
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 14:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qw/MDWsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388332AbgLAOLS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:11:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391601AbgLAOJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 09:09:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606831669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D6jVrNQ+fRny1v9oPjfkC5/GRHz0xm8bQgw+lKp/qFg=;
        b=Qw/MDWsFaNFdneZ7C15jmQvZz/zt8DLM6+Czher/F1BQCNsokSg+zcQYUTybTsbFInR+Wy
        YzkM7tkcYlEq+AR95Hm7dvu+BbptAQGcyckxr/ABHi8WyUbW6w+qDgnMSqZIccR0N0vP5C
        cj7eka1ZHKB6CBpPiujJHU3JRURqbfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-pQ5eh-kZNZq0hKV6JZb2QQ-1; Tue, 01 Dec 2020 09:07:45 -0500
X-MC-Unique: pQ5eh-kZNZq0hKV6JZb2QQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81846107464C;
        Tue,  1 Dec 2020 14:07:44 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ECB4C5C1B4;
        Tue,  1 Dec 2020 14:07:43 +0000 (UTC)
Date:   Tue, 1 Dec 2020 09:07:42 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] spaceman: physically move a regular inode
Message-ID: <20201201140742.GA1205666@bfoster>
References: <20201110225924.4031404-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110225924.4031404-1-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 11, 2020 at 09:59:24AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To be able to shrink a filesystem, we need to be able to physically
> move an inode and all it's data and metadata from it's current
> location to a new AG.  Add a command to spaceman to allow an inode
> to be moved to a new AG.
> 
> This new command is not intended to be a perfect solution. I am not
> trying to handle atomic movement of open files - this is intended to
> be run as a maintenance operation on idle filesystem. If root
> filesystems are the target, then this should be run via a rescue
> environment that is not executing directly on the root fs. With
> those caveats in place, we can do the entire inode move as a set of
> non-destructive operations finalised by an atomic inode swap
> without any needing special kernel support.
> 
> To ensure we move metadata such as BMBT blocks even if we don't need
> to move data, we clone the data to a new inode that we've allocated
> in the destination AG. This will result in new bmbt blocks being
> allocated in the new location even though the data is not copied.
> Attributes need to be copied one at a time from the original inode.
> 
> If data needs to be moved, then we use fallocate(UNSHARE) to create
> a private copy of the range of data that needs to be moved in the
> new inode. This will be allocated in the destination AG by normal
> allocation policy.
> 
> Once the new inode has been finalised, use RENAME_EXCHANGE to swap
> it into place and unlink the original inode to free up all the
> resources it still pins.
> 
> There are many optimisations still possible to speed this up, but
> the goal here is "functional" rather than "optimal". Performance can
> be optimised once all the parts for a "empty the tail of the
> filesystem before shrink" operation are implemented and solidly
> tested.
> 

Neat idea. With respect to the shrink use case, what's the reasoning
behind userspace selecting the target AG? There's no harm in having the
target AG option in the utility of course, but ISTM that shrink might
care more about moving some set of inodes from a particular AG as
opposed to a specific target AG.

For example, might it make sense to implement a policy where move_inode
simply moves an inode to the first AG the tempdir lands in that is < the
AG of the source inode? We'd probably want to be careful to make sure
that we don't attempt to dump the entire set of moved files into the
same AG, but I assume the temp dir creation logic would effectively
rotor across the remaining set of AGs we do want to allow.. Thoughts?

Brian

> This functionality has been smoke tested by creating a 32MB data
> file with 4k extents and several hundred attributes:
> 
> $ cat test.sh
> fname=/mnt/scratch/foo
> xfs_io -f -c "pwrite 0 32m" -c sync $fname
> for (( i=0; i < 4096 ; i++ )); do
> 	xfs_io -c "fpunch $((i * 8))k 4k" $fname
> done
> 
> for (( i=0; i < 100 ; i++ )); do
> 	setfattr -n user.blah.$i.$i.blah -v blah.$i.$i.blah $fname
> 	setfattr -n user.foo.$i.$i.foo -v $i.cantbele.$i.ve.$i.tsnotbutter $fname
> done
> for (( i=0; i < 100 ; i++ )); do
> 	setfattr -n security.baz.$i.$i.baz -v wotchul$i$iookinat $fname
> done
> 
> xfs_io -c stat -c "bmap -vp" -c "bmap -avp" $fname
> xfs_spaceman -c "move_inode -a 22" /mnt/scratch/foo
> xfs_io -c stat -c "bmap -vp" -c "bmap -avp" $fname
> $
> 
> and the output looks something like:
> 
> $ sudo ./test.sh
> ....
> fd.path = "/mnt/scratch/foo"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 133
> /mnt/scratch/foo:
>  EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET        TOTAL FLAGS
>    0: [0..7]:          hole                                      8
>    1: [8..15]:         208..215           0 (208..215)           8 000000
>    2: [16..23]:        hole                                      8
>    3: [24..31]:        224..231           0 (224..231)           8 000000
> ....
> 8189: [65512..65519]:  65712..65719       0 (65712..65719)       8 000000
> 8190: [65520..65527]:  hole                                      8
> 8191: [65528..65535]:  65728..65735       0 (65728..65735)       8 000000
> mnt/scratch/foo:
>  EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET        TOTAL FLAGS
>    0: [0..7]:          392..399           0 (392..399)           8 000000
>    1: [8..15]:         408..415           0 (408..415)           8 000000
>    2: [16..23]:        424..431           0 (424..431)           8 000000
>    3: [24..31]:        456..463           0 (456..463)           8 000000
> move mnt /mnt/scratch, path /mnt/scratch/foo, agno 22
> fd.path = "/mnt/scratch/foo"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 47244651475
> ....
> /mnt/scratch/foo:
>  EXT: FILE-OFFSET      BLOCK-RANGE               AG AG-OFFSET        TOTAL FLAGS
>    0: [0..7]:          hole                                              8
>    1: [8..15]:         47244763192..47244763199  22 (123112..123119)     8 000000
>    2: [16..23]:        hole                                              8
>    3: [24..31]:        47244763208..47244763215  22 (123128..123135)     8 000000
> ....
> 8189: [65512..65519]:  47244828808..47244828815  22 (188728..188735)     8 000000
> 8190: [65520..65527]:  hole                                              8
> 8191: [65528..65535]:  47244828824..47244828831  22 (188744..188751)     8 000000
> /mnt/scratch/foo:
>  EXT: FILE-OFFSET      BLOCK-RANGE               AG AG-OFFSET        TOTAL FLAGS
>    0: [0..7]:          47244763176..47244763183  22 (123096..123103)     8 000000
> $
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  spaceman/Makefile     |   6 +-
>  spaceman/file.c       |   2 +-
>  spaceman/init.c       |   1 +
>  spaceman/move_inode.c | 518 ++++++++++++++++++++++++++++++++++++++++++
>  spaceman/space.h      |   1 +
>  5 files changed, 524 insertions(+), 4 deletions(-)
>  create mode 100644 spaceman/move_inode.c
> 
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index 2a3669183a40..e90f66e8abc6 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -7,11 +7,11 @@ include $(TOPDIR)/include/builddefs
>  
>  LTCOMMAND = xfs_spaceman
>  HFILES = init.h space.h
> -CFILES = info.c init.c file.c health.c prealloc.c trim.c
> +CFILES = info.c init.c file.c health.c move_inode.c prealloc.c trim.c
>  LSRCFILES = xfs_info.sh
>  
> -LLDLIBS = $(LIBXCMD) $(LIBFROG)
> -LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> +LLDLIBS = $(LIBXCMD) $(LIBFROG) $(LIBHANDLE)
> +LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG) $(LIBHANDLE)
>  LLDFLAGS = -static
>  
>  ifeq ($(ENABLE_EDITLINE),yes)
> diff --git a/spaceman/file.c b/spaceman/file.c
> index eec7ee9f4ba9..1777ed7d4602 100644
> --- a/spaceman/file.c
> +++ b/spaceman/file.c
> @@ -52,7 +52,7 @@ openfile(
>  	struct fs_path	*fsp;
>  	int		ret;
>  
> -	ret = -xfd_open(xfd, path, O_RDONLY);
> +	ret = -xfd_open(xfd, path, O_RDWR);
>  	if (ret) {
>  		if (ret == ENOTTY)
>  			fprintf(stderr,
> diff --git a/spaceman/init.c b/spaceman/init.c
> index cf1ff3cbb0ee..c3bfe3e5922f 100644
> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -35,6 +35,7 @@ init_commands(void)
>  	trim_init();
>  	freesp_init();
>  	health_init();
> +	move_inode_init();
>  }
>  
>  static int
> diff --git a/spaceman/move_inode.c b/spaceman/move_inode.c
> new file mode 100644
> index 000000000000..c3f791c82c45
> --- /dev/null
> +++ b/spaceman/move_inode.c
> @@ -0,0 +1,518 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2012 Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +
> +#include "libxfs.h"
> +#include "libfrog/fsgeom.h"
> +#include "command.h"
> +#include "init.h"
> +#include "libfrog/paths.h"
> +#include "space.h"
> +#include "input.h"
> +#include "handle.h"
> +
> +#include <linux/fiemap.h>
> +#include <linux/falloc.h>
> +#include <attr/attributes.h>
> +
> +static cmdinfo_t move_inode_cmd;
> +
> +/*
> + * We can't entirely use O_TMPFILE here because we want to use RENAME_EXCHANGE
> + * to swap the inode once rebuild is complete. Hence the new file has to be
> + * somewhere in the namespace for rename to act upon. Hence we use a normal
> + * open(O_CREATE) for now.
> + *
> + * This could potentially use O_TMPFILE to rebuild the entire inode, the use
> + * a linkat()/renameat2() pair to add it to the namespace then atomically
> + * replace the original.
> + */
> +static int
> +create_tmpfile(
> +	const char	*mnt,
> +	struct xfs_fd	*xfd,
> +	xfs_agnumber_t	agno,
> +	char		**tmpfile,
> +	int		*tmpfd)
> +{
> +	char		name[PATH_MAX + 1];
> +	mode_t		mask;
> +	int		fd;
> +	int		i;
> +	int		ret;
> +
> +	/* construct tmpdir */
> +	mask = umask(0);
> +
> +	snprintf(name, PATH_MAX, "%s/.spaceman", mnt);
> +	ret = mkdir(name, 0700);
> +	if (ret) {
> +		if (errno != EEXIST) {
> +			fprintf(stderr, _("could not create tmpdir: %s: %s\n"),
> +					name, strerror(errno));
> +			ret = -errno;
> +			goto out_cleanup;
> +		}
> +	}
> +
> +	/* loop creating directories until we get one in the right AG */
> +	for (i = 0; i < xfd->fsgeom.agcount; i++) {
> +		struct stat	st;
> +
> +		snprintf(name, PATH_MAX, "%s/.spaceman/dir%d", mnt, i);
> +		ret = mkdir(name, 0700);
> +		if (ret) {
> +			if (errno != EEXIST) {
> +				fprintf(stderr,
> +					_("cannot create tmpdir: %s: %s\n"),
> +				       name, strerror(errno));
> +				ret = -errno;
> +				goto out_cleanup_dir;
> +			}
> +		}
> +		ret = lstat(name, &st);
> +		if (ret) {
> +			fprintf(stderr, _("cannot stat tmpdir: %s: %s\n"),
> +				       name, strerror(errno));
> +			ret = -errno;
> +			rmdir(name);
> +			goto out_cleanup_dir;
> +		}
> +		if (cvt_ino_to_agno(xfd, st.st_ino) == agno)
> +			break;
> +
> +		/* remove directory in wrong AG */
> +		rmdir(name);
> +	}
> +
> +	if (i == xfd->fsgeom.agcount) {
> +		/*
> +		 * Nothing landed in the selected AG! Must have been skipped
> +		 * because the AG is out of space.
> +		 */
> +		fprintf(stderr, _("Cannot create AG tmpdir.\n"));
> +		ret = -ENOSPC;
> +		goto out_cleanup_dir;
> +	}
> +
> +	/* create tmpfile */
> +	snprintf(name, PATH_MAX, "%s/.spaceman/dir%d/tmpfile.%d", mnt, i, getpid());
> +	fd = open(name, O_CREAT|O_EXCL|O_RDWR, 0700);
> +	if (fd < 0) {
> +		fprintf(stderr, _("cannot create tmpfile: %s: %s\n"),
> +		       name, strerror(errno));
> +		ret = -errno;
> +	}
> +
> +	/* return name and fd */
> +	(void)umask(mask);
> +	*tmpfd = fd;
> +	*tmpfile = strdup(name);
> +
> +	return 0;
> +out_cleanup_dir:
> +	snprintf(name, PATH_MAX, "%s/.spaceman", mnt);
> +	rmdir(name);
> +out_cleanup:
> +	(void)umask(mask);
> +	return ret;
> +}
> +
> +static int
> +get_attr(
> +	void		*hdl,
> +	size_t		hlen,
> +	char		*name,
> +	void		*attrbuf,
> +	int		*attrlen,
> +	int		attr_ns)
> +{
> +	struct xfs_attr_multiop	ops = {
> +		.am_opcode	= ATTR_OP_GET,
> +		.am_attrname	= name,
> +		.am_attrvalue	= attrbuf,
> +		.am_length	= *attrlen,
> +		.am_flags	= attr_ns,
> +	};
> +	int		ret;
> +
> +	ret = attr_multi_by_handle(hdl, hlen, &ops, 1, 0);
> +	if (ret < 0) {
> +		fprintf(stderr, _("attr_multi_by_handle(GET): %s\n"),
> +			strerror(errno));
> +		return -errno;
> +	}
> +	*attrlen = ops.am_length;
> +	return 0;
> +}
> +
> +static int
> +set_attr(
> +	void		*hdl,
> +	size_t		hlen,
> +	char		*name,
> +	void		*attrbuf,
> +	int		attrlen,
> +	int		attr_ns)
> +{
> +	struct xfs_attr_multiop	ops = {
> +		.am_opcode	= ATTR_OP_SET,
> +		.am_attrname	= name,
> +		.am_attrvalue	= attrbuf,
> +		.am_length	= attrlen,
> +		.am_flags	= ATTR_CREATE | attr_ns,
> +	};
> +	int		ret;
> +
> +	ret = attr_multi_by_handle(hdl, hlen, &ops, 1, 0);
> +	if (ret < 0) {
> +		fprintf(stderr, _("attr_multi_by_handle(SET): %s\n"),
> +			strerror(errno));
> +		return -errno;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Copy all the attributes from the original source file into the replacement
> + * destination.
> + *
> + * Oh the humanity of deprecated Irix compatible attr interfaces that are more
> + * functional and useful than their native Linux replacements!
> + */
> +static int
> +copy_attrs(
> +	int			srcfd,
> +	int			dstfd,
> +	int			attr_ns)
> +{
> +	void			*shdl;
> +	void			*dhdl;
> +	size_t			shlen;
> +	size_t			dhlen;
> +	attrlist_cursor_t	cursor;
> +	attrlist_t		*alist;
> +	struct attrlist_ent	*ent;
> +	char			alistbuf[XATTR_LIST_MAX];
> +	char			attrbuf[XATTR_SIZE_MAX];
> +	int			attrlen;
> +	int			error;
> +	int			i;
> +
> +	memset(&cursor, 0, sizeof(cursor));
> +
> +	/*
> +	 * All this handle based stuff is hoop jumping to avoid:
> +	 *
> +	 * a) deprecated API warnings because attr_list, attr_get and attr_set
> +	 *    have been deprecated hence through compiler warnings; and
> +	 *
> +	 * b) listxattr() failing hard if there are more than 64kB worth of attr
> +	 *    names on the inode so is unusable.
> +	 *
> +	 * That leaves libhandle as the only usable interface for iterating all
> +	 * xattrs on an inode reliably. Lucky for us, libhandle is part of
> +	 * xfsprogs, so this hoop jump isn't going to get ripped out from under
> +	 * us any time soon.
> +	 */
> +	error = fd_to_handle(srcfd, (void **)&shdl, &shlen);
> +	if (error) {
> +		fprintf(stderr, _("fd_to_handle(shdl): %s\n"),
> +			strerror(errno));
> +		return -errno;
> +	}
> +	error = fd_to_handle(dstfd, (void **)&dhdl, &dhlen);
> +	if (error) {
> +		fprintf(stderr, _("fd_to_handle(dhdl): %s\n"),
> +			strerror(errno));
> +		goto out_free_shdl;
> +	}
> +
> +	/* loop to iterate all xattrs */
> +	error = attr_list_by_handle(shdl, shlen, alistbuf,
> +					XATTR_LIST_MAX, attr_ns, &cursor);
> +	if (error) {
> +		fprintf(stderr, _("attr_list_by_handle(shdl): %s\n"),
> +			strerror(errno));
> +	}
> +	while (!error) {
> +		alist = (attrlist_t *)alistbuf;
> +
> +		/*
> +		 * We loop one attr at a time for initial implementation
> +		 * simplicity. attr_multi_by_handle() can retrieve and set
> +		 * multiple attrs in a single call, but that is more complex.
> +		 * Get it working first, then optimise.
> +		 */
> +		for (i = 0; i < alist->al_count; i++) {
> +			ent = ATTR_ENTRY(alist, i);
> +
> +			/* get xattr (val, len) from name */
> +			attrlen = XATTR_SIZE_MAX;
> +			error = get_attr(shdl, shlen, ent->a_name, attrbuf,
> +						&attrlen, attr_ns);
> +			if (error)
> +				break;
> +
> +			/* set xattr (val, len) to name */
> +			error = set_attr(dhdl, dhlen, ent->a_name, attrbuf,
> +						attrlen, ATTR_CREATE | attr_ns);
> +			if (error)
> +				break;
> +		}
> +
> +		if (!alist->al_more)
> +			break;
> +		error = attr_list_by_handle(shdl, shlen, alistbuf,
> +					XATTR_LIST_MAX, attr_ns, &cursor);
> +	}
> +
> +	free_handle(dhdl, dhlen);
> +out_free_shdl:
> +	free_handle(shdl, shlen);
> +	return error ? -errno : 0;
> +}
> +
> +/*
> + * scan the range of the new file for data that isn't in the destination AG
> + * and unshare it to create a new copy of it in the current target location
> + * of the new file.
> + */
> +#define EXTENT_BATCH 32
> +static int
> +unshare_data(
> +	struct xfs_fd	*xfd,
> +	int		destfd,
> +	xfs_agnumber_t	agno)
> +{
> +	int		ret;
> +	struct fiemap	*fiemap;
> +	int		done = 0;
> +	int		fiemap_flags = FIEMAP_FLAG_SYNC;
> +	int		i;
> +	int		map_size;
> +	__u64		last_logical = 0;	/* last extent offset handled */
> +	off64_t		range_end = -1LL;	/* mapping end*/
> +
> +	/* fiemap loop over extents */
> +	map_size = sizeof(struct fiemap) +
> +		(EXTENT_BATCH * sizeof(struct fiemap_extent));
> +	fiemap = malloc(map_size);
> +	if (!fiemap) {
> +		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
> +			progname, map_size);
> +		return -ENOMEM;
> +	}
> +
> +	while (!done) {
> +		memset(fiemap, 0, map_size);
> +		fiemap->fm_flags = fiemap_flags;
> +		fiemap->fm_start = last_logical;
> +		fiemap->fm_length = range_end - last_logical;
> +		fiemap->fm_extent_count = EXTENT_BATCH;
> +
> +		ret = ioctl(destfd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> +		if (ret < 0) {
> +			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP): %s\n",
> +				progname, strerror(errno));
> +			free(fiemap);
> +			return -errno;
> +		}
> +
> +		/* No more extents to map, exit */
> +		if (!fiemap->fm_mapped_extents)
> +			break;
> +
> +		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
> +			struct fiemap_extent	*extent;
> +			xfs_agnumber_t		this_agno;
> +
> +			extent = &fiemap->fm_extents[i];
> +			this_agno = cvt_daddr_to_agno(xfd,
> +					cvt_btobbt(extent->fe_physical));
> +
> +			/*
> +			 * If extent not in dst AG, unshare whole extent to
> +			 * trigger reallocated of the extent to be local to
> +			 * the current inode.
> +			 */
> +			if (this_agno != agno) {
> +				ret = fallocate(destfd, FALLOC_FL_UNSHARE_RANGE,
> +					extent->fe_logical, extent->fe_length);
> +				if (ret) {
> +					fprintf(stderr,
> +						"%s: fallocate(UNSHARE): %s\n",
> +						progname, strerror(errno));
> +					return -errno;
> +				}
> +			}
> +
> +			last_logical = extent->fe_logical + extent->fe_length;
> +
> +			/* Kernel has told us there are no more extents */
> +			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
> +				done = 1;
> +				break;
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int
> +move_file_to_ag(
> +	const char		*mnt,
> +	const char		*path,
> +	struct xfs_fd		*xfd,
> +	xfs_agnumber_t		agno)
> +{
> +	int			ret;
> +	int			tmpfd = -1;
> +	char			*tmpfile = NULL;
> +
> +	fprintf(stderr, "move mnt %s, path %s, agno %d\n", mnt, path, agno);
> +
> +	/* create temporary file in agno */
> +	ret = create_tmpfile(mnt, xfd, agno, &tmpfile, &tmpfd);
> +
> +	/* clone data to tempfile */
> +	ret = ioctl(tmpfd, FICLONE, xfd->fd);
> +	if (ret)
> +		goto out_cleanup;
> +
> +	/* copy system attributes to tempfile */
> +	ret = copy_attrs(xfd->fd, tmpfd, ATTR_ROOT);
> +	if (ret)
> +		goto out_cleanup;
> +
> +	/* copy user attributes to tempfile */
> +	ret = copy_attrs(xfd->fd, tmpfd, 0);
> +	if (ret)
> +		goto out_cleanup;
> +
> +	/* unshare data to move it */
> +	ret = unshare_data(xfd, tmpfd, agno);
> +	if (ret)
> +		goto out_cleanup;
> +
> +	/* RENAME_EXCHANGE to replace the inode */
> +	ret = renameat2(AT_FDCWD, tmpfile, AT_FDCWD, path, RENAME_EXCHANGE);
> +
> +out_cleanup:
> +	if (ret == -1)
> +		ret = -errno;
> +
> +	close(tmpfd);
> +	if (tmpfile)
> +		unlink(tmpfile);
> +	free(tmpfile);
> +
> +	return ret;
> +}
> +
> +static int
> +move_inode_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	void			*fshandle;
> +	size_t			fshdlen;
> +	xfs_agnumber_t		agno = 0;
> +	struct stat		st;
> +	int			ret;
> +	int			c;
> +
> +	while ((c = getopt(argc, argv, "a:")) != EOF) {
> +		switch (c) {
> +		case 'a':
> +			agno = cvt_u32(optarg, 10);
> +			if (errno) {
> +				fprintf(stderr, _("bad agno value %s\n"),
> +					optarg);
> +				return command_usage(&move_inode_cmd);
> +			}
> +			break;
> +		default:
> +			return command_usage(&move_inode_cmd);
> +		}
> +	}
> +
> +	if (optind != argc)
> +		return command_usage(&move_inode_cmd);
> +
> +	if (agno >= file->xfd.fsgeom.agcount) {
> +		fprintf(stderr,
> +_("Destination AG %d does not exist. Filesystem only has %d AGs\n"),
> +			agno, file->xfd.fsgeom.agcount);
> +			exitcode = 1;
> +			return 0;
> +	}
> +
> +	/* this is so we can use fd_to_handle() later on */
> +	ret = path_to_fshandle(file->fs_path.fs_dir, &fshandle, &fshdlen);
> +	if (ret < 0) {
> +		fprintf(stderr, _("Cannot get fshandle for mount %s: %s\n"),
> +			file->fs_path.fs_dir, strerror(errno));
> +		goto exit_fail;
> +	}
> +
> +	ret = fstat(file->xfd.fd, &st);
> +	if (ret) {
> +		fprintf(stderr, _("stat(%s) failed: %s\n"),
> +			file->name, strerror(errno));
> +		goto exit_fail;
> +	}
> +
> +	if (S_ISREG(st.st_mode)) {
> +		ret = move_file_to_ag(file->fs_path.fs_dir, file->name,
> +				&file->xfd, agno);
> +	} else {
> +		fprintf(stderr, _("Unsupported: %s is not a regular file.\n"),
> +			file->name);
> +		goto exit_fail;
> +	}
> +
> +	if (ret) {
> +		fprintf(stderr, _("Failed to move inode to AG %d: %s\n"),
> +			agno, strerror(-ret));
> +		goto exit_fail;
> +	}
> +	fshandle_destroy();
> +	return 0;
> +
> +exit_fail:
> +	fshandle_destroy();
> +	exitcode = 1;
> +	return 0;
> +}
> +
> +static void
> +move_inode_help(void)
> +{
> +	printf(_(
> +"\n"
> +"Physically move an inode into a new allocation group\n"
> +"\n"
> +" -a agno       -- destination AG agno for the current open file\n"
> +"\n"));
> +
> +}
> +
> +void
> +move_inode_init(void)
> +{
> +	move_inode_cmd.name = "move_inode";
> +	move_inode_cmd.altname = "mvino";
> +	move_inode_cmd.cfunc = move_inode_f;
> +	move_inode_cmd.argmin = 2;
> +	move_inode_cmd.argmax = 2;
> +	move_inode_cmd.args = "-a agno";
> +	move_inode_cmd.flags = CMD_FLAG_ONESHOT;
> +	move_inode_cmd.oneline = _("Move an inode into a new AG.");
> +	move_inode_cmd.help = move_inode_help;
> +
> +	add_command(&move_inode_cmd);
> +}
> +
> diff --git a/spaceman/space.h b/spaceman/space.h
> index 723209edd998..79deed812cdf 100644
> --- a/spaceman/space.h
> +++ b/spaceman/space.h
> @@ -33,5 +33,6 @@ extern void	freesp_init(void);
>  #endif
>  extern void	info_init(void);
>  extern void	health_init(void);
> +void		move_inode_init(void);
>  
>  #endif /* XFS_SPACEMAN_SPACE_H_ */
> -- 
> 2.28.0
> 

