Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q18MiJEn112249 for <xfs@oss.sgi.com>; Wed, 8 Feb 2012 16:44:19 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TJufeqrPIKb6mAZd for <xfs@oss.sgi.com>;
	Wed, 08 Feb 2012 14:44:15 -0800 (PST)
Date: Thu, 9 Feb 2012 09:44:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE
	copy check
Message-ID: <20120208224412.GA7479@dastard>
References: <4F2FE410.2040508@oracle.com> <20120208085557.GI20305@dastard>
	<4F328163.8020800@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F328163.8020800@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Feb 08, 2012 at 10:06:27PM +0800, Jeff Liu wrote:
> On 02/08/2012 04:55 PM, Dave Chinner wrote:
> 
> > On Mon, Feb 06, 2012 at 10:30:40PM +0800, Jeff Liu wrote:
> >> Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.
> >>
> >> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > 
> > This has the same problems with $seq.out as 279, so I won't repeat
> > them here.
> > 
> > .....
> >> +_cleanup()
> >> +{
> >> +	rm -f $src $dest
> >> +}
> >> +
> >> +# seek_copy_test_01()
> >> +# create a 100Mytes file in preallocation mode.
> >> +# fallocate offset start from 0.
> >> +# the first data extent offset start from 80991, write 4Kbytes,
> >> +# and then skip 195001 bytes for next write.
> > 
> > Oh, man, you didn't write a program to do this, do you?
> 
> Unfortunately, I have already included file creation at seek_copy_tester :(
> 
> > This is what
> > xfs_io is for - to create arbitary file configurations as quickly as
> > you can type them.  Then all you need is a simple program that
> > copies the extents, and the test can check everything else.
> 
> Yes, xfs_io is pretty cool, and it really convenient for file creation for XFS.

xfs_io is filesystem agnostic. Currently it needs the "-F" flag to
tell it to work on non-xfs filesystems, but Eric posted patches a
couple of days ago to remove that (i.e to automatically detect XFS
filesystems and enable all the xfs specific stuff).

> I wrote it(create_data_and_holes()) in seek_copy_tester since I'd make it as a general SEEK_DATA/SEEK_HOLE tester
> for other file systems without this utility too.

xfs_io is used all throughout xfstests in generic tests. Just look
at common.punch::_test_generic_punch as an example. That function
uses xfs_io to test the different methods of perallocation and hole
punching supported by a bunch of different filesystems in 3
different tests. IOWs, the generic tests use fallocate and the XFS
specific tests use XFS ioctls, but all tests use xfs_io to run the
commands....

> >> +# seek_copy_test_02()
> >> +# create a 100Mytes file in preallocation mode.
> >> +# fallocate offset start from 0.
> >> +# the first data extent offset start from 0, write 16Kbytes,
> >> +# and then skip 8Mbytes for next write.
> >> +# Try flushing DIRTY pages to WRITEBACK mode, this is intended to
> >> +# test data buffer lookup in WRITEBACK pages.
> > 
> > There's no guarantee that that the seeks will occur while the pages
> > are in the writeback. It's entirely dependent on IO latency -
> > writing 16k of data to a disk cache will take less time than it
> > takes to go back up into userspace and start the sparse copy.
> > Indeed, i suspect that the 16x16k IOs that this tes does will fit
> > all into that category even on basic SATA configs....
> > 
> > Also, you could the fadvise command in xfs_io to do this, as
> > POSIX_FADV_DONTNEED will trigger async writeback -it will then skip
> > invalidation of pages under writeback so they will remain in the
> > cache. i.e. '-c "fadvise -d 0 100m"'
> > 
> > Ideally, we should add all the different sync methods to an xfs_io
> > command...
> 
> Thanks again for the detained info.
> It's definitely depending on the IO latency to test cover those page status conversion.
> I have verified the old patch with page probe routine on my laptop SATA disk controller,
> but not tried against other faster controllers.  If we agree to make it as a general tester, maybe I can
> try to implement it by referring to xfs_io fadvise, I guess it use posix_fadvise(2), will check it later.

Yes, it uses posix_fadvise64().

As it is, I spent 15 minutes adding support for sync_file_range()
to xfs_io. The patch is attached below.

> >> +# the first data extent offset start from 512, write 4Kbytes,
> >> +# and then skip 1Mbytes for next write.
> >> +# don't make holes at the end of file.
> > 
> > I'm not sure what this means - you always write zeros at the end of
> > file, and the only difference is that "make holes at EOF" does an
> > ftruncate to the total size before writing zeros up to it. It
> > appears to me like you end up with the same file size and shape
> > either way....
> 
> Oops! this is a code bug. I want to create a hole at EOF if possible when "-E(wrote_hole_at_eof)" option was specified.
> It can be fixed as below FIXME:

Yes, that'd work ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs_io: add sync_file_range support

From: Dave Chinner <dchinner@redhat.com>

Add sync_file_range support to xfs_io to allow fine grained control
of data writeback and syncing on a given file.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 io/Makefile          |    5 ++
 io/init.c            |    1 +
 io/io.h              |    6 +++
 io/sync_file_range.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8    |   19 +++++++++
 5 files changed, 138 insertions(+), 0 deletions(-)

diff --git a/io/Makefile b/io/Makefile
index 9d79dca..bf46d56 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -58,6 +58,11 @@ CFILES += inject.c resblks.c
 LCFLAGS += -DHAVE_INJECT -DHAVE_RESBLKS
 endif
 
+ifeq ($(PKG_PLATFORM),linux)
+CFILES += sync_file_range.c
+LCFLAGS += -DHAVE_SYNC_FILE_RANGE
+endif
+
 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
 endif
diff --git a/io/init.c b/io/init.c
index a166ad1..99f8cb7 100644
--- a/io/init.c
+++ b/io/init.c
@@ -78,6 +78,7 @@ init_commands(void)
 	sendfile_init();
 	shutdown_init();
 	truncate_init();
+	sync_range_init();
 }
 
 static int
diff --git a/io/io.h b/io/io.h
index 2923362..8151b7b 100644
--- a/io/io.h
+++ b/io/io.h
@@ -141,3 +141,9 @@ extern void		fiemap_init(void);
 #else
 #define fiemap_init()	do { } while (0)
 #endif
+
+#ifdef HAVE_SYNC_FILE_RANGE
+extern void		sync_range_init(void);
+#else
+#define sync_range_init()	do { } while (0)
+#endif
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
new file mode 100644
index 0000000..35d8cc5
--- /dev/null
+++ b/io/sync_file_range.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright (c) 2012 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t sync_range_cmd;
+
+static void
+sync_range_help(void)
+{
+	printf(_(
+"\n"
+" Trigger specific writeback commands on a range of the current file\n"
+"\n"
+" With no options, the SYNC_FILE_RANGE_WRITE is implied.\n"
+" -a -- wait for IO to finish after writing (SYNC_FILE_RANGE_WAIT_AFTER).\n"
+" -b -- wait for IO to finish before writing (SYNC_FILE_RANGE_WAIT_BEFORE).\n"
+" -w -- write dirty data in range (SYNC_FILE_RANGE_WRITE).\n"
+"\n"));
+}
+
+static int
+sync_range_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		offset = 0, length = 0;
+	int		c, sync_mode = 0;
+	size_t		blocksize, sectsize;
+
+	while ((c = getopt(argc, argv, "abw")) != EOF) {
+		switch (c) {
+		case 'a':
+			sync_mode = SYNC_FILE_RANGE_WAIT_AFTER;
+			break;
+		case 'b':
+			sync_mode = SYNC_FILE_RANGE_WAIT_BEFORE;
+			break;
+		case 'w':
+			sync_mode = SYNC_FILE_RANGE_WRITE;
+			break;
+		default:
+			return command_usage(&sync_range_cmd);
+		}
+	}
+
+	/* default to just starting writeback on the range */
+	if (!sync_mode)
+		sync_mode = SYNC_FILE_RANGE_WRITE;
+
+	if (optind != argc - 2)
+		return command_usage(&sync_range_cmd);
+	init_cvtnum(&blocksize, &sectsize);
+	offset = cvtnum(blocksize, sectsize, argv[optind]);
+	if (offset < 0) {
+		printf(_("non-numeric offset argument -- %s\n"),
+			argv[optind]);
+		return 0;
+	}
+	optind++;
+	length = cvtnum(blocksize, sectsize, argv[optind]);
+	if (length < 0) {
+		printf(_("non-numeric length argument -- %s\n"),
+			argv[optind]);
+		return 0;
+	}
+
+	if (sync_file_range(file->fd, offset, length, sync_mode) < 0) {
+		perror("sync_file_range");
+		return 0;
+	}
+	return 0;
+}
+
+void
+sync_range_init(void)
+{
+	sync_range_cmd.name = "sync_range";
+	sync_range_cmd.cfunc = sync_range_f;
+	sync_range_cmd.argmin = 2;
+	sync_range_cmd.argmax = -1;
+	sync_range_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	sync_range_cmd.args = _("[-abw] off len");
+	sync_range_cmd.oneline = _("Control writeback on a range of a file");
+	sync_range_cmd.help = sync_range_help;
+
+	add_command(&sync_range_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6fc6bad..a9f95d7 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -283,6 +283,25 @@ See the
 .B fsync
 command.
 .TP
+.BI "sync_range [ \-a | \-b | \-w ] offset length "
+On platforms which support it, allows control of syncing a range of the file to
+disk. With no options, SYNC_FILE_RANGE_WRITE is implied on the range supplied.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-a
+wait for IO in the given range to finish after writing
+(SYNC_FILE_RANGE_WAIT_AFTER).
+.TP
+.B \-b
+wait for IO in the given range to finish before writing
+(SYNC_FILE_RANGE_WAIT_BEFORE).
+.TP
+.B \-w
+start writeback of dirty data in the given range (SYNC_FILE_RANGE_WRITE).
+.RE
+.PD
+.TP
 .BI resvsp " offset length"
 Allocates reserved, unwritten space for part of a file using the
 XFS_IOC_RESVSP system call described in the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
