Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2FFF2836F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:43:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3F24304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:04 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UaD3IAjnC4HBR9vA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:01 -0700 (PDT)
Subject: [PATCH 116/145] xfs_io: get and set the CoW extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:42:57 -0700
Message-ID: <146612777707.16048.16381607370131674150.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Enable administrators to get or set the CoW extent size hint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/attr.c         |    8 ++-
 io/open.c         |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |   16 +++++
 3 files changed, 189 insertions(+), 1 deletion(-)


diff --git a/io/attr.c b/io/attr.c
index 0186b1d..13bec73 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -48,9 +48,11 @@ static struct xflags {
 	{ FS_XFLAG_NODEFRAG,		"f", "no-defrag"	},
 	{ FS_XFLAG_FILESTREAM,		"S", "filestream"	},
 	{ FS_XFLAG_DAX,			"x", "dax"		},
+	{ FS_XFLAG_REFLINK,		"R", "reflink"		},
+	{ FS_XFLAG_COWEXTSIZE,		"C", "cowextsize"	},
 	{ 0, NULL, NULL }
 };
-#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSx"
+#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSxRC"
 
 static void
 lsattr_help(void)
@@ -75,6 +77,8 @@ lsattr_help(void)
 " f -- do not include this file when defragmenting the filesystem\n"
 " S -- enable filestreams allocator for this directory\n"
 " x -- Use direct access (DAX) for data in this file\n"
+" R -- file data blocks may be shared with another file\n"
+" C -- for files with shared blocks, observe the inode CoW extent size value\n"
 "\n"
 " Options:\n"
 " -R -- recursively descend (useful when current file is a directory)\n"
@@ -111,6 +115,8 @@ chattr_help(void)
 " +/-f -- set/clear the no-defrag flag\n"
 " +/-S -- set/clear the filestreams allocator flag\n"
 " +/-x -- set/clear the direct access (DAX) flag\n"
+" +/-R -- set/clear the reflink flag\n"
+" +/-C -- set/clear the CoW extent-size flag\n"
 " Note1: user must have certain capabilities to modify immutable/append-only.\n"
 " Note2: immutable/append-only files cannot be deleted; removing these files\n"
 "        requires the immutable/append-only flag to be cleared first.\n"
diff --git a/io/open.c b/io/open.c
index 2303527..1e682a4 100644
--- a/io/open.c
+++ b/io/open.c
@@ -46,8 +46,10 @@ static cmdinfo_t chproj_cmd;
 static cmdinfo_t lsproj_cmd;
 static cmdinfo_t extsize_cmd;
 static cmdinfo_t inode_cmd;
+static cmdinfo_t cowextsize_cmd;
 static prid_t prid;
 static long extsize;
+static long cowextsize;
 
 off64_t
 filesize(void)
@@ -125,6 +127,7 @@ stat_f(
 		printxattr(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
 		printf(_("fsxattr.projid = %u\n"), fsx.fsx_projid);
 		printf(_("fsxattr.extsize = %u\n"), fsx.fsx_extsize);
+		printf(_("fsxattr.cowextsize = %u\n"), fsx.fsx_cowextsize);
 		printf(_("fsxattr.nextents = %u\n"), fsx.fsx_nextents);
 		printf(_("fsxattr.naextents = %u\n"), fsxa.fsx_nextents);
 	}
@@ -696,6 +699,158 @@ extsize_f(
 	return 0;
 }
 
+static void
+cowextsize_help(void)
+{
+	printf(_(
+"\n"
+" report or modify preferred CoW extent size (in bytes) for the current path\n"
+"\n"
+" -R -- recursively descend (useful when current path is a directory)\n"
+" -D -- recursively descend, only modifying cowextsize on directories\n"
+"\n"));
+}
+
+static int
+get_cowextsize(const char *path, int fd)
+{
+	struct fsxattr	fsx;
+
+	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
+			progname, path, strerror(errno));
+		return 0;
+	}
+	printf("[%u] %s\n", fsx.fsx_cowextsize, path);
+	return 0;
+}
+
+static int
+set_cowextsize(const char *path, int fd, long extsz)
+{
+	struct fsxattr	fsx;
+	struct stat64	stat;
+
+	if (fstat64(fd, &stat) < 0) {
+		perror("fstat64");
+		return 0;
+	}
+	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	if (S_ISREG(stat.st_mode) || S_ISDIR(stat.st_mode)) {
+		fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
+	} else {
+		printf(_("invalid target file type - file %s\n"), path);
+		return 0;
+	}
+	fsx.fsx_cowextsize = extsz;
+
+	if ((xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx)) < 0) {
+		printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	return 0;
+}
+
+static int
+get_cowextsize_callback(
+	const char		*path,
+	const struct stat	*stat,
+	int			status,
+	struct FTW		*data)
+{
+	int			fd;
+
+	if (recurse_dir && !S_ISDIR(stat->st_mode))
+		return 0;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, _("%s: cannot open %s: %s\n"),
+			progname, path, strerror(errno));
+	} else {
+		get_cowextsize(path, fd);
+		close(fd);
+	}
+	return 0;
+}
+
+static int
+set_cowextsize_callback(
+	const char		*path,
+	const struct stat	*stat,
+	int			status,
+	struct FTW		*data)
+{
+	int			fd;
+
+	if (recurse_dir && !S_ISDIR(stat->st_mode))
+		return 0;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, _("%s: cannot open %s: %s\n"),
+			progname, path, strerror(errno));
+	} else {
+		set_cowextsize(path, fd, cowextsize);
+		close(fd);
+	}
+	return 0;
+}
+
+static int
+cowextsize_f(
+	int		argc,
+	char		**argv)
+{
+	size_t			blocksize, sectsize;
+	int			c;
+
+	recurse_all = recurse_dir = 0;
+	init_cvtnum(&blocksize, &sectsize);
+	while ((c = getopt(argc, argv, "DR")) != EOF) {
+		switch (c) {
+		case 'D':
+			recurse_all = 0;
+			recurse_dir = 1;
+			break;
+		case 'R':
+			recurse_all = 1;
+			recurse_dir = 0;
+			break;
+		default:
+			return command_usage(&cowextsize_cmd);
+		}
+	}
+
+	if (optind < argc) {
+		cowextsize = (long)cvtnum(blocksize, sectsize, argv[optind]);
+		if (cowextsize < 0) {
+			printf(_("non-numeric cowextsize argument -- %s\n"),
+				argv[optind]);
+			return 0;
+		}
+	} else {
+		cowextsize = -1;
+	}
+
+	if (recurse_all || recurse_dir)
+		nftw(file->name, (extsize >= 0) ?
+			set_cowextsize_callback : get_cowextsize_callback,
+			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
+	else if (cowextsize >= 0)
+		set_cowextsize(file->name, file->fd, cowextsize);
+	else
+		get_cowextsize(file->name, file->fd);
+	return 0;
+}
+
 static int
 statfs_f(
 	int			argc,
@@ -964,6 +1119,16 @@ open_init(void)
 		_("Query inode number usage in the filesystem");
 	inode_cmd.help = inode_help;
 
+	cowextsize_cmd.name = "cowextsize";
+	cowextsize_cmd.cfunc = cowextsize_f;
+	cowextsize_cmd.args = _("[-D | -R] [cowextsize]");
+	cowextsize_cmd.argmin = 0;
+	cowextsize_cmd.argmax = -1;
+	cowextsize_cmd.flags = CMD_NOMAP_OK;
+	cowextsize_cmd.oneline =
+		_("get/set preferred CoW extent size (in bytes) for the open file");
+	cowextsize_cmd.help = cowextsize_help;
+
 	add_command(&open_cmd);
 	add_command(&stat_cmd);
 	add_command(&close_cmd);
@@ -972,4 +1137,5 @@ open_init(void)
 	add_command(&lsproj_cmd);
 	add_command(&extsize_cmd);
 	add_command(&inode_cmd);
+	add_command(&cowextsize_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6c45c37..cc70b7c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -283,6 +283,22 @@ The
 should be specified in bytes, or using one of the usual units suffixes
 (k, m, g, b, etc). The extent size is always reported in units of bytes.
 .TP
+.BI "cowextsize [ \-R | \-D ] [ " value " ]"
+Display and/or modify the preferred copy-on-write extent size used
+when allocating space for the currently open file. If the
+.B \-R
+option is specified, a recursive descent is performed
+for all directory entries below the currently open file
+.RB ( \-D
+can be used to restrict the output to directories only).
+If the target file is a directory, then the inherited CoW extent size
+is set for that directory (new files created in that directory
+inherit that CoW extent size).
+The
+.I value
+should be specified in bytes, or using one of the usual units suffixes
+(k, m, g, b, etc). The extent size is always reported in units of bytes.
+.TP
 .BI "allocsp " size " 0"
 Sets the size of the file to
 .I size

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
