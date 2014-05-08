Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76A6C7F52
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 20:13:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E319BAC007
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 18:13:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BdtBk9xFz4jHrXjG for <xfs@oss.sgi.com>;
	Wed, 07 May 2014 18:13:22 -0700 (PDT)
Date: Thu, 8 May 2014 11:12:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140508011256.GS5421@dastard>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
	<20140507144822.GA4061@bfoster.bfoster>
	<20140507224755.GR5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140507224755.GR5421@dastard>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, May 08, 2014 at 08:47:55AM +1000, Dave Chinner wrote:
> On Wed, May 07, 2014 at 10:48:22AM -0400, Brian Foster wrote:
> > Note that the Makefile structure between the core and libxfs/ subdir
> > appears to be busted for module compiles. It attempts to create a
> > libxfs.ko and doesn't appear to create any real link dependency between
> > the logical modules:
> 
> Ok, I hadn't tested that. I'll look into it.
> 
> > ...
> > WARNING: "__tracepoint_xfs_dir2_sf_create" [fs/xfs/libxfs/libxfs.ko]
> > undefined!
> > WARNING: "__tracepoint_xfs_da_root_join" [fs/xfs/libxfs/libxfs.ko]
> > undefined!
> > WARNING: "xfs_trans_mod_sb" [fs/xfs/libxfs/libxfs.ko] undefined!
> > WARNING: "xfs_extent_busy_insert" [fs/xfs/libxfs/libxfs.ko] undefined!
> > WARNING: "__tracepoint_xfs_dir2_sf_addname" [fs/xfs/libxfs/libxfs.ko]
> > undefined!
> 
> That tends to imply I didn't do the right thing with the tracing,
> either.
> 
> >   CC      fs/xfs/xfs.mod.o
> >   CC      fs/xfs/libxfs/libxfs.mod.o
> >   LD [M]  fs/xfs/xfs.ko
> >   LD [M]  fs/xfs/libxfs/libxfs.ko
> > 
> > I played with it a bit but didn't get anywhere without just pulling the
> > source file dependency up into fs/xfs/Makefile. :/
> 
> I'll see what I can dig up.

Well, I can make use of "lib-y" to get around the "libxfs is built
as a module" problem:

....
  CC      fs/xfs/libxfs/xfs_sb.o
  CC      fs/xfs/libxfs/xfs_symlink_remote.o
  CC      fs/xfs/libxfs/xfs_trans_resv.o
  AR      fs/xfs/libxfs/lib.a

but then there is the issue of adding it as a link flag to the xfs
object itself. That involved a bit of a ld hack, but I have it
compiling as a module now. Patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

libxfs: fix modular build

From: Dave Chinner <dchinner@redhat.com>

As reported by Brain Foster:

Note that the Makefile structure between the core and libxfs/ subdir
appears to be busted for module compiles. It attempts to create a
libxfs.ko and doesn't appear to create any real link dependency between
the logical modules:

...
WARNING: "__tracepoint_xfs_dir2_sf_create" [fs/xfs/libxfs/libxfs.ko]
undefined!
WARNING: "__tracepoint_xfs_da_root_join" [fs/xfs/libxfs/libxfs.ko]
undefined!
WARNING: "xfs_trans_mod_sb" [fs/xfs/libxfs/libxfs.ko] undefined!
WARNING: "xfs_extent_busy_insert" [fs/xfs/libxfs/libxfs.ko] undefined!
WARNING: "__tracepoint_xfs_dir2_sf_addname" [fs/xfs/libxfs/libxfs.ko]
undefined!
  CC      fs/xfs/xfs.mod.o
  CC      fs/xfs/libxfs/libxfs.mod.o
  LD [M]  fs/xfs/xfs.ko
  LD [M]  fs/xfs/libxfs/libxfs.ko

Fix it by converting libxfs to be a static library, and hack the
fs/xfs/xfs.o linker commands to include it directly and so
completely avoid the need for a libxfs.ko module until we have
sorted out all the circular dependency issues.

Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile        | 22 +++++++++++++++++++---
 fs/xfs/libxfs/Makefile | 12 +++++++-----
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c520bff..726cfaa 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -20,10 +20,26 @@ ccflags-y += -I$(src)			# needed for trace events
 ccflags-y += -I$(src)/libxfs		# XXX: temporary!
 ccflags-y += -I$(src)/libxfs/include	# XXX: temporary!
 
-ccflags-$(CONFIG_XFS_DEBUG) += -g
+# libxfs should inheret this as well.
+subdir-ccflags-$(CONFIG_XFS_DEBUG) += -g
 
-obj-$(CONFIG_XFS_FS)		+= xfs.o \
-				   libxfs/
+# When building as a module, we don't want a separate libxfs.ko,
+# so we specifically have to link the libxfs.o object into the
+# xfs.ko module. Hence we need to tell LD to do this appropriately.
+#ldflags-y += -L$(obj)/libxfs -l:libxfs.o
+#
+# The use of --start-group without --endgroup here is a bit of a hack
+# to avoid needing to use symbol exports and real modules.
+# This works around the fact that ldflags-y is included on the linker command
+# line before all the object files built in this directory, and hence
+# it drops all the unreferenced symbols from libxfs. i.e. all the ones that
+# that xfs.ko module actually requires. The lack of an "--end-group" varaible
+# means LD considers all object files on the command line for recursive object
+# searching and hence solves the specification order problem.
+ldflags-y += --start-group $(obj)/libxfs/lib.a
+
+obj-$(CONFIG_XFS_FS)		+= libxfs/ \
+				   xfs.o
 
 # this one should be compiled first, as the tracing macros can easily blow up
 xfs-y				+= xfs_trace.o
diff --git a/fs/xfs/libxfs/Makefile b/fs/xfs/libxfs/Makefile
index e3de6df..b5f443b 100644
--- a/fs/xfs/libxfs/Makefile
+++ b/fs/xfs/libxfs/Makefile
@@ -8,11 +8,13 @@
 ccflags-y += -I$(src)/..
 ccflags-y += -I$(src)/include -Werror		# needed for trace events
 
-ccflags-$(CONFIG_XFS_DEBUG) += -g
+# Use the lib-X directives rather than obj-X so that this doesn't get built as a
+# module itself and have unresolvable circular dependencies with the xfs module.
+# This means the xfs module needs to specifically link libxfs/lib.a because we
+# are not adding fs/xfs/libxfs to the libs-y built-in library search
+# directories. A bit hacky, but it seems to work as desired for modular builds.
 
-obj-$(CONFIG_XFS_FS)	+= libxfs.o
-
-libxfs-y		+= xfs_alloc.o \
+lib-(CONFIG_XFS_FS)	+= xfs_alloc.o \
 			   xfs_alloc_btree.o \
 			   xfs_attr.o \
 			   xfs_attr_leaf.o \
@@ -38,4 +40,4 @@ libxfs-y		+= xfs_alloc.o \
 			   xfs_symlink_remote.o \
 			   xfs_trans_resv.o
 
-libxfs-$(CONFIG_XFS_RT)	+= xfs_rtbitmap.o
+lib-$(CONFIG_XFS_RT)	+= xfs_rtbitmap.o

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
