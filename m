Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9EF29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688785; cv=none; b=Vi/cL+HnsUC/6L7YL1Mq7VnK5CkKJPnp/Znr45ljAxrgwzW9G/3dphYgzVuPkvFkdicvrvjN++UWXa7wkCCq03LcJwU5BXiWL/IpIfRxZaC5FActFsMW4VNjkgRPmAt+jxMtCfEXDaBhD8aawxdx6XC0lYGfPLELT4xwY+/N3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688785; c=relaxed/simple;
	bh=0OHgJQOD3GvFa4LoUEWO7SZOsMOatkSscug1oz4E2mM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xl+aA53ZmQxxlr4i+ZV1EnjWiOWbUJu1XvjBeOeie3x6bx9CL/fzo64BXTOYERaXQJTPIeU79dy9JPNQaU43ushDHfAwoyAEQZjzi1E8N1rA22Gh8IVecsgcyL1ahXd6kSdLAVgu+/+wXOo+VB9rpOqAYc/6OfJdEP5M4r2HjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCglMnVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCglMnVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEBCC4CED2;
	Tue, 31 Dec 2024 23:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688785;
	bh=0OHgJQOD3GvFa4LoUEWO7SZOsMOatkSscug1oz4E2mM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uCglMnVTFmlLzYhZGP9KEcYvPlvdPOGMPbDW0TQrXZJED1LNRs0rKf3AT6aAGZyqZ
	 p2LBDTO2zYIL3b/n6r6lkk+vXIatQd/uqF5MbwcwZ6opornaF2cfloM19es52jsovM
	 I0pomdMtgWFOZPvfCsovKpV8+d0bcyUq9BpF+eKAXKaxefRrZnd3OeMD9pZgUwYNge
	 aSVx/kgMZrZ5WGJN3xOLiZyq1t9v30N7qvKvQuTDrmjvqALUMLBXASSlMBDIdGp4vW
	 2v9pMMf2LptNrjDOgeSfAQJQOVNNENQaW0cV7YZOLS537Rb6WxHiVfeFyx7mGFbgVw
	 lgnkQzEMRWm2w==
Date: Tue, 31 Dec 2024 15:46:24 -0800
Subject: [PATCH 06/11] spaceman: physically move a regular inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <173568777962.2709794.5863683217799517220.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
References: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

To be able to shrink a filesystem, we need to be able to physically
move an inode and all it's data and metadata from it's current
location to a new AG.  Add a command to spaceman to allow an inode
to be moved to a new AG.

This new command is not intended to be a perfect solution. I am not
trying to handle atomic movement of open files - this is intended to
be run as a maintenance operation on idle filesystem. If root
filesystems are the target, then this should be run via a rescue
environment that is not executing directly on the root fs. With
those caveats in place, we can do the entire inode move as a set of
non-destructive operations finalised by an atomic inode swap
without any needing special kernel support.

To ensure we move metadata such as BMBT blocks even if we don't need
to move data, we clone the data to a new inode that we've allocated
in the destination AG. This will result in new bmbt blocks being
allocated in the new location even though the data is not copied.
Attributes need to be copied one at a time from the original inode.

If data needs to be moved, then we use fallocate(UNSHARE) to create
a private copy of the range of data that needs to be moved in the
new inode. This will be allocated in the destination AG by normal
allocation policy.

Once the new inode has been finalised, use RENAME_EXCHANGE to swap
it into place and unlink the original inode to free up all the
resources it still pins.

There are many optimisations still possible to speed this up, but
the goal here is "functional" rather than "optimal". Performance can
be optimised once all the parts for a "empty the tail of the
filesystem before shrink" operation are implemented and solidly
tested.

This functionality has been smoke tested by creating a 32MB data
file with 4k extents and several hundred attributes:

$ cat test.sh
fname=/mnt/scratch/foo
xfs_io -f -c "pwrite 0 32m" -c sync $fname
for (( i=0; i < 4096 ; i++ )); do
	xfs_io -c "fpunch $((i * 8))k 4k" $fname
done

for (( i=0; i < 100 ; i++ )); do
	setfattr -n user.blah.$i.$i.blah -v blah.$i.$i.blah $fname
	setfattr -n user.foo.$i.$i.foo -v $i.cantbele.$i.ve.$i.tsnotbutter $fname
done
for (( i=0; i < 100 ; i++ )); do
	setfattr -n security.baz.$i.$i.baz -v wotchul$i$iookinat $fname
done

xfs_io -c stat -c "bmap -vp" -c "bmap -avp" $fname
xfs_spaceman -c "move_inode -a 22" /mnt/scratch/foo
xfs_io -c stat -c "bmap -vp" -c "bmap -avp" $fname
$

and the output looks something like:

$ sudo ./test.sh
....
fd.path = "/mnt/scratch/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 133
/mnt/scratch/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          hole                                      8
   1: [8..15]:         208..215           0 (208..215)           8 000000
   2: [16..23]:        hole                                      8
   3: [24..31]:        224..231           0 (224..231)           8 000000
....
8189: [65512..65519]:  65712..65719       0 (65712..65719)       8 000000
8190: [65520..65527]:  hole                                      8
8191: [65528..65535]:  65728..65735       0 (65728..65735)       8 000000
mnt/scratch/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          392..399           0 (392..399)           8 000000
   1: [8..15]:         408..415           0 (408..415)           8 000000
   2: [16..23]:        424..431           0 (424..431)           8 000000
   3: [24..31]:        456..463           0 (456..463)           8 000000
move mnt /mnt/scratch, path /mnt/scratch/foo, agno 22
fd.path = "/mnt/scratch/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 47244651475
....
/mnt/scratch/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE               AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          hole                                              8
   1: [8..15]:         47244763192..47244763199  22 (123112..123119)     8 000000
   2: [16..23]:        hole                                              8
   3: [24..31]:        47244763208..47244763215  22 (123128..123135)     8 000000
....
8189: [65512..65519]:  47244828808..47244828815  22 (188728..188735)     8 000000
8190: [65520..65527]:  hole                                              8
8191: [65528..65535]:  47244828824..47244828831  22 (188744..188751)     8 000000
/mnt/scratch/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE               AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          47244763176..47244763183  22 (123096..123103)     8 000000
$


Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_spaceman.8 |    4 
 spaceman/Makefile       |    3 
 spaceman/init.c         |    1 
 spaceman/move_inode.c   |  562 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/space.h        |    1 
 5 files changed, 570 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/move_inode.c


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index a326b9a6486296..f898a8bbe840ea 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -146,6 +146,10 @@ .SH COMMANDS
 .TP
 .BR "help [ " command " ]"
 Display a brief description of one or all commands.
+.TP
+.BI "move_inode \-a agno"
+Move the currently open file into the specified allocation group.
+
 .TP
 .BI "prealloc [ \-u id ] [ \-g id ] [ -p id ] [ \-m minlen ] [ \-s ]"
 Removes speculative preallocation.
diff --git a/spaceman/Makefile b/spaceman/Makefile
index b9eead8340cec1..9d080b67de9a22 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -14,11 +14,12 @@ CFILES = \
 	health.c \
 	info.c \
 	init.c \
+	move_inode.c \
 	prealloc.c \
 	trim.c
 LSRCFILES = xfs_info.sh
 
-LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/spaceman/init.c b/spaceman/init.c
index bce62dec47f2c8..dbeebcf97b9fb2 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -36,6 +36,7 @@ init_commands(void)
 	freesp_init();
 	health_init();
 	clearfree_init();
+	move_inode_init();
 }
 
 static int
diff --git a/spaceman/move_inode.c b/spaceman/move_inode.c
new file mode 100644
index 00000000000000..b7d71ee7a46dc6
--- /dev/null
+++ b/spaceman/move_inode.c
@@ -0,0 +1,562 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include "libfrog/fsgeom.h"
+#include "command.h"
+#include "init.h"
+#include "libfrog/paths.h"
+#include "space.h"
+#include "input.h"
+#include "handle.h"
+
+#include <linux/fiemap.h>
+#include <linux/falloc.h>
+#include <attr/attributes.h>
+
+static cmdinfo_t move_inode_cmd;
+
+/*
+ * We can't entirely use O_TMPFILE here because we want to use RENAME_EXCHANGE
+ * to swap the inode once rebuild is complete. Hence the new file has to be
+ * somewhere in the namespace for rename to act upon. Hence we use a normal
+ * open(O_CREATE) for now.
+ *
+ * This could potentially use O_TMPFILE to rebuild the entire inode, the use
+ * a linkat()/renameat2() pair to add it to the namespace then atomically
+ * replace the original.
+ */
+static int
+create_tmpfile(
+	const char	*mnt,
+	struct xfs_fd	*xfd,
+	xfs_agnumber_t	agno,
+	char		**tmpfile,
+	int		*tmpfd)
+{
+	char		name[PATH_MAX + 1];
+	mode_t		mask;
+	int		fd;
+	int		i;
+	int		ret;
+
+	/* construct tmpdir */
+	mask = umask(0);
+
+	snprintf(name, PATH_MAX, "%s/.spaceman", mnt);
+	ret = mkdir(name, 0700);
+	if (ret) {
+		if (errno != EEXIST) {
+			fprintf(stderr, _("could not create tmpdir: %s: %s\n"),
+					name, strerror(errno));
+			ret = -errno;
+			goto out_cleanup;
+		}
+	}
+
+	/* loop creating directories until we get one in the right AG */
+	for (i = 0; i < xfd->fsgeom.agcount; i++) {
+		struct stat	st;
+
+		snprintf(name, PATH_MAX, "%s/.spaceman/dir%d", mnt, i);
+		ret = mkdir(name, 0700);
+		if (ret) {
+			if (errno != EEXIST) {
+				fprintf(stderr,
+					_("cannot create tmpdir: %s: %s\n"),
+				       name, strerror(errno));
+				ret = -errno;
+				goto out_cleanup_dir;
+			}
+		}
+		ret = lstat(name, &st);
+		if (ret) {
+			fprintf(stderr, _("cannot stat tmpdir: %s: %s\n"),
+				       name, strerror(errno));
+			ret = -errno;
+			rmdir(name);
+			goto out_cleanup_dir;
+		}
+		if (cvt_ino_to_agno(xfd, st.st_ino) == agno)
+			break;
+
+		/* remove directory in wrong AG */
+		rmdir(name);
+	}
+
+	if (i == xfd->fsgeom.agcount) {
+		/*
+		 * Nothing landed in the selected AG! Must have been skipped
+		 * because the AG is out of space.
+		 */
+		fprintf(stderr, _("Cannot create AG tmpdir.\n"));
+		ret = -ENOSPC;
+		goto out_cleanup_dir;
+	}
+
+	/* create tmpfile */
+	snprintf(name, PATH_MAX, "%s/.spaceman/dir%d/tmpfile.%d", mnt, i, getpid());
+	fd = open(name, O_CREAT|O_EXCL|O_RDWR, 0700);
+	if (fd < 0) {
+		fprintf(stderr, _("cannot create tmpfile: %s: %s\n"),
+		       name, strerror(errno));
+		ret = -errno;
+	}
+
+	/* return name and fd */
+	(void)umask(mask);
+	*tmpfd = fd;
+	*tmpfile = strdup(name);
+
+	return 0;
+out_cleanup_dir:
+	snprintf(name, PATH_MAX, "%s/.spaceman", mnt);
+	rmdir(name);
+out_cleanup:
+	(void)umask(mask);
+	return ret;
+}
+
+static int
+get_attr(
+	void		*hdl,
+	size_t		hlen,
+	char		*name,
+	void		*attrbuf,
+	int		*attrlen,
+	int		attr_ns)
+{
+	struct xfs_attr_multiop	ops = {
+		.am_opcode	= ATTR_OP_GET,
+		.am_attrname	= name,
+		.am_attrvalue	= attrbuf,
+		.am_length	= *attrlen,
+		.am_flags	= attr_ns,
+	};
+	int		ret;
+
+	ret = attr_multi_by_handle(hdl, hlen, &ops, 1, 0);
+	if (ret < 0) {
+		fprintf(stderr, _("attr_multi_by_handle(GET): %s\n"),
+			strerror(errno));
+		return -errno;
+	}
+	*attrlen = ops.am_length;
+	return 0;
+}
+
+static int
+set_attr(
+	void		*hdl,
+	size_t		hlen,
+	char		*name,
+	void		*attrbuf,
+	int		attrlen,
+	int		attr_ns)
+{
+	struct xfs_attr_multiop	ops = {
+		.am_opcode	= ATTR_OP_SET,
+		.am_attrname	= name,
+		.am_attrvalue	= attrbuf,
+		.am_length	= attrlen,
+		.am_flags	= ATTR_CREATE | attr_ns,
+	};
+	int		ret;
+
+	ret = attr_multi_by_handle(hdl, hlen, &ops, 1, 0);
+	if (ret < 0) {
+		fprintf(stderr, _("attr_multi_by_handle(SET): %s\n"),
+			strerror(errno));
+		return -errno;
+	}
+	return 0;
+}
+
+/*
+ * Copy all the attributes from the original source file into the replacement
+ * destination.
+ *
+ * Oh the humanity of deprecated Irix compatible attr interfaces that are more
+ * functional and useful than their native Linux replacements!
+ */
+static int
+copy_attrs(
+	int			srcfd,
+	int			dstfd,
+	int			attr_ns)
+{
+	void			*shdl;
+	void			*dhdl;
+	size_t			shlen;
+	size_t			dhlen;
+	attrlist_cursor_t	cursor;
+	attrlist_t		*alist;
+	struct attrlist_ent	*ent;
+	char			alistbuf[XATTR_LIST_MAX];
+	char			attrbuf[XATTR_SIZE_MAX];
+	int			attrlen;
+	int			error;
+	int			i;
+
+	memset(&cursor, 0, sizeof(cursor));
+
+	/*
+	 * All this handle based stuff is hoop jumping to avoid:
+	 *
+	 * a) deprecated API warnings because attr_list, attr_get and attr_set
+	 *    have been deprecated hence through compiler warnings; and
+	 *
+	 * b) listxattr() failing hard if there are more than 64kB worth of attr
+	 *    names on the inode so is unusable.
+	 *
+	 * That leaves libhandle as the only usable interface for iterating all
+	 * xattrs on an inode reliably. Lucky for us, libhandle is part of
+	 * xfsprogs, so this hoop jump isn't going to get ripped out from under
+	 * us any time soon.
+	 */
+	error = fd_to_handle(srcfd, (void **)&shdl, &shlen);
+	if (error) {
+		fprintf(stderr, _("fd_to_handle(shdl): %s\n"),
+			strerror(errno));
+		return -errno;
+	}
+	error = fd_to_handle(dstfd, (void **)&dhdl, &dhlen);
+	if (error) {
+		fprintf(stderr, _("fd_to_handle(dhdl): %s\n"),
+			strerror(errno));
+		goto out_free_shdl;
+	}
+
+	/* loop to iterate all xattrs */
+	error = attr_list_by_handle(shdl, shlen, alistbuf,
+					XATTR_LIST_MAX, attr_ns, &cursor);
+	if (error) {
+		fprintf(stderr, _("attr_list_by_handle(shdl): %s\n"),
+			strerror(errno));
+	}
+	while (!error) {
+		alist = (attrlist_t *)alistbuf;
+
+		/*
+		 * We loop one attr at a time for initial implementation
+		 * simplicity. attr_multi_by_handle() can retrieve and set
+		 * multiple attrs in a single call, but that is more complex.
+		 * Get it working first, then optimise.
+		 */
+		for (i = 0; i < alist->al_count; i++) {
+			ent = ATTR_ENTRY(alist, i);
+
+			/* get xattr (val, len) from name */
+			attrlen = XATTR_SIZE_MAX;
+			error = get_attr(shdl, shlen, ent->a_name, attrbuf,
+						&attrlen, attr_ns);
+			if (error)
+				break;
+
+			/* set xattr (val, len) to name */
+			error = set_attr(dhdl, dhlen, ent->a_name, attrbuf,
+						attrlen, ATTR_CREATE | attr_ns);
+			if (error)
+				break;
+		}
+
+		if (!alist->al_more)
+			break;
+		error = attr_list_by_handle(shdl, shlen, alistbuf,
+					XATTR_LIST_MAX, attr_ns, &cursor);
+	}
+
+	free_handle(dhdl, dhlen);
+out_free_shdl:
+	free_handle(shdl, shlen);
+	return error ? -errno : 0;
+}
+
+/*
+ * scan the range of the new file for data that isn't in the destination AG
+ * and unshare it to create a new copy of it in the current target location
+ * of the new file.
+ */
+#define EXTENT_BATCH 32
+static int
+unshare_data(
+	struct xfs_fd	*xfd,
+	int		destfd,
+	xfs_agnumber_t	agno)
+{
+	int		ret;
+	struct fiemap	*fiemap;
+	int		done = 0;
+	int		fiemap_flags = FIEMAP_FLAG_SYNC;
+	int		i;
+	int		map_size;
+	__u64		last_logical = 0;	/* last extent offset handled */
+	off_t		range_end = -1LL;	/* mapping end*/
+
+	/* fiemap loop over extents */
+	map_size = sizeof(struct fiemap) +
+		(EXTENT_BATCH * sizeof(struct fiemap_extent));
+	fiemap = malloc(map_size);
+	if (!fiemap) {
+		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
+			progname, map_size);
+		return -ENOMEM;
+	}
+
+	while (!done) {
+		memset(fiemap, 0, map_size);
+		fiemap->fm_flags = fiemap_flags;
+		fiemap->fm_start = last_logical;
+		fiemap->fm_length = range_end - last_logical;
+		fiemap->fm_extent_count = EXTENT_BATCH;
+
+		ret = ioctl(destfd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+		if (ret < 0) {
+			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP): %s\n",
+				progname, strerror(errno));
+			free(fiemap);
+			return -errno;
+		}
+
+		/* No more extents to map, exit */
+		if (!fiemap->fm_mapped_extents)
+			break;
+
+		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			struct fiemap_extent	*extent;
+			xfs_agnumber_t		this_agno;
+
+			extent = &fiemap->fm_extents[i];
+			this_agno = cvt_daddr_to_agno(xfd,
+					cvt_btobbt(extent->fe_physical));
+
+			/*
+			 * If extent not in dst AG, unshare whole extent to
+			 * trigger reallocated of the extent to be local to
+			 * the current inode.
+			 */
+			if (this_agno != agno) {
+				ret = fallocate(destfd, FALLOC_FL_UNSHARE_RANGE,
+					extent->fe_logical, extent->fe_length);
+				if (ret) {
+					fprintf(stderr,
+						"%s: fallocate(UNSHARE): %s\n",
+						progname, strerror(errno));
+					return -errno;
+				}
+			}
+
+			last_logical = extent->fe_logical + extent->fe_length;
+
+			/* Kernel has told us there are no more extents */
+			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
+				done = 1;
+				break;
+			}
+		}
+	}
+	return 0;
+}
+
+/*
+ * Exchange the inodes at the two paths indicated after first ensuring that the
+ * owners, permissions and timestamps are set correctly in the tmpfile.
+ */
+static int
+exchange_inodes(
+	struct xfs_fd	*xfd,
+	int		tmpfd,
+	const char	*tmpfile,
+	const char	*path)
+{
+	struct timespec	ts[2];
+	struct stat	st;
+	int		ret;
+
+	ret = fstat(xfd->fd, &st);
+	if (ret)
+		return -errno;
+
+	/* set user ids */
+	ret = fchown(tmpfd, st.st_uid, st.st_gid);
+	if (ret)
+		return -errno;
+
+	/* set permissions */
+	ret = fchmod(tmpfd, st.st_mode);
+	if (ret)
+		return -errno;
+
+	/* set timestamps */
+	ts[0] = st.st_atim;
+	ts[1] = st.st_mtim;
+	ret = futimens(tmpfd, ts);
+	if (ret)
+		return -errno;
+
+	/* exchange the two inodes */
+	ret = renameat2(AT_FDCWD, tmpfile, AT_FDCWD, path, RENAME_EXCHANGE);
+	if (ret)
+		return -errno;
+	return 0;
+}
+
+static int
+move_file_to_ag(
+	const char		*mnt,
+	const char		*path,
+	struct xfs_fd		*xfd,
+	xfs_agnumber_t		agno)
+{
+	int			ret;
+	int			tmpfd = -1;
+	char			*tmpfile = NULL;
+
+	fprintf(stderr, "move mnt %s, path %s, agno %d\n", mnt, path, agno);
+
+	/* create temporary file in agno */
+	ret = create_tmpfile(mnt, xfd, agno, &tmpfile, &tmpfd);
+	if (ret)
+		return ret;
+
+	/* clone data to tempfile */
+	ret = ioctl(tmpfd, FICLONE, xfd->fd);
+	if (ret)
+		goto out_cleanup;
+
+	/* copy system attributes to tempfile */
+	ret = copy_attrs(xfd->fd, tmpfd, ATTR_ROOT);
+	if (ret)
+		goto out_cleanup;
+
+	/* copy user attributes to tempfile */
+	ret = copy_attrs(xfd->fd, tmpfd, 0);
+	if (ret)
+		goto out_cleanup;
+
+	/* unshare data to move it */
+	ret = unshare_data(xfd, tmpfd, agno);
+	if (ret)
+		goto out_cleanup;
+
+	/* swap the inodes over */
+	ret = exchange_inodes(xfd, tmpfd, tmpfile, path);
+
+out_cleanup:
+	if (ret == -1)
+		ret = -errno;
+
+	close(tmpfd);
+	if (tmpfile)
+		unlink(tmpfile);
+	free(tmpfile);
+
+	return ret;
+}
+
+static int
+move_inode_f(
+	int			argc,
+	char			**argv)
+{
+	void			*fshandle;
+	size_t			fshdlen;
+	xfs_agnumber_t		agno = 0;
+	struct stat		st;
+	int			ret;
+	int			c;
+
+	while ((c = getopt(argc, argv, "a:")) != EOF) {
+		switch (c) {
+		case 'a':
+			agno = cvt_u32(optarg, 10);
+			if (errno) {
+				fprintf(stderr, _("bad agno value %s\n"),
+					optarg);
+				return command_usage(&move_inode_cmd);
+			}
+			break;
+		default:
+			return command_usage(&move_inode_cmd);
+		}
+	}
+
+	if (optind != argc)
+		return command_usage(&move_inode_cmd);
+
+	if (agno >= file->xfd.fsgeom.agcount) {
+		fprintf(stderr,
+_("Destination AG %d does not exist. Filesystem only has %d AGs\n"),
+			agno, file->xfd.fsgeom.agcount);
+		exitcode = 1;
+		return 0;
+	}
+
+	/* this is so we can use fd_to_handle() later on */
+	ret = path_to_fshandle(file->fs_path.fs_dir, &fshandle, &fshdlen);
+	if (ret < 0) {
+		fprintf(stderr, _("Cannot get fshandle for mount %s: %s\n"),
+			file->fs_path.fs_dir, strerror(errno));
+		goto exit_fail;
+	}
+
+	ret = fstat(file->xfd.fd, &st);
+	if (ret) {
+		fprintf(stderr, _("stat(%s) failed: %s\n"),
+			file->name, strerror(errno));
+		goto exit_fail;
+	}
+
+	if (S_ISREG(st.st_mode)) {
+		ret = move_file_to_ag(file->fs_path.fs_dir, file->name,
+				&file->xfd, agno);
+	} else {
+		fprintf(stderr, _("Unsupported: %s is not a regular file.\n"),
+			file->name);
+		goto exit_fail;
+	}
+
+	if (ret) {
+		fprintf(stderr, _("Failed to move inode to AG %d: %s\n"),
+			agno, strerror(-ret));
+		goto exit_fail;
+	}
+	fshandle_destroy();
+	return 0;
+
+exit_fail:
+	fshandle_destroy();
+	exitcode = 1;
+	return 0;
+}
+
+static void
+move_inode_help(void)
+{
+	printf(_(
+"\n"
+"Physically move an inode into a new allocation group\n"
+"\n"
+" -a agno       -- destination AG agno for the current open file\n"
+"\n"));
+
+}
+
+void
+move_inode_init(void)
+{
+	move_inode_cmd.name = "move_inode";
+	move_inode_cmd.altname = "mvino";
+	move_inode_cmd.cfunc = move_inode_f;
+	move_inode_cmd.argmin = 2;
+	move_inode_cmd.argmax = 2;
+	move_inode_cmd.args = "-a agno";
+	move_inode_cmd.flags = CMD_FLAG_ONESHOT;
+	move_inode_cmd.oneline = _("Move an inode into a new AG.");
+	move_inode_cmd.help = move_inode_help;
+
+	add_command(&move_inode_cmd);
+}
diff --git a/spaceman/space.h b/spaceman/space.h
index 509e923375f42f..96c3c356f13fec 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -38,5 +38,6 @@ extern void	clearfree_init(void);
 #endif
 extern void	info_init(void);
 extern void	health_init(void);
+void		move_inode_init(void);
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */

