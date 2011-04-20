Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KEa8Ug098784 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 09:36:08 -0500
Received: from mx.meyering.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B0C715048A9
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 07:39:31 -0700 (PDT)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64]) by
	cuda.sgi.com with ESMTP id voXIy22enwQ2XaII for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2011 07:39:31 -0700 (PDT)
From: Jim Meyering <jim@meyering.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
In-Reply-To: <20110414102608.GA1678@x4.trippels.de> (Markus Trippelsdorf's
	message of "Thu, 14 Apr 2011 12:26:08 +0200")
References: <20110414102608.GA1678@x4.trippels.de>
Date: Wed, 20 Apr 2011 16:39:30 +0200
Message-ID: <87d3khugv1.fsf@rho.meyering.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-ext4@vger.kernel.org, coreutils@gnu.org, xfs@oss.sgi.com

Markus Trippelsdorf wrote:
> I trashed my system this morning when I installed coreutils-8.11.
>
> What happened is that coreutils compiles and links correctly, but then
> the following command (during the installation phase):
>
> ./ginstall chroot hostid nice who users pinky stty df stdbuf [ base64
...
>
> apparently produces files which have the length of the originals but are
> full of zeros. (and these were then installed to my live system, thereby
> trashing it).
...

Thanks again for the report.
I believe that the following series addresses this problem
and have confirmed that tests pass with 2.6.39-rc3 on all
of ext3, ext4, btrfs and xfs -- though there was what appears
to be a spurious failure in tests/cp/sparse-fiemap when run on xfs.
On one iteration of this loop, with j=31, in these loops

  for i in $(seq 1 2 21); do
    for j in 1 2 31 100; do

[in http://git.savannah.gnu.org/cgit/coreutils.git/tree/tests/cp/sparse-fiemap]
the two files compared equal, yet their extents did not match,
even after merging.  I'm inclined to skip the extent-comparing check
at least for XFS, now.

Here's the unusually-technical-for-NEWS summary:

** Changes in behavior

  cp's extent-based (FIEMAP) copying code is more reliable in the face
  of varying and undocumented file system semantics:
  - it no longer treats unwritten extents specially
  - a FIEMAP-based extent copy always uses the FIEMAP_FLAG_SYNC flag.
      Before, it would incur the performance penalty of that sync only
      for 2.6.38 and older kernels.  We thought all problems would be
      resolved for 2.6.39.
  - it now attempts a FIEMAP copy only on a file that appears sparse.
      Sparse files are relatively unusual, and the copying code incurs
      the performance penalty of the now-mandatory sync only for them.




>From 2783b52b273dd8fca824d8e1a64f8c4f41a54c00 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Wed, 20 Apr 2011 09:49:15 +0200
Subject: [PATCH 1/4] copy: always use FIEMAP_FLAG_SYNC, for now

* src/extent-scan.c (extent_need_sync): Always return true,
to make the sole caller always use FIEMAP_FLAG_SYNC.
This will doubtless have an undesirable performance impact,
but we'll mitigate that shortly, by using extent_copy only on
files with holes.
---
 src/extent-scan.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/src/extent-scan.c b/src/extent-scan.c
index da7eb9d..596e7f7 100644
--- a/src/extent-scan.c
+++ b/src/extent-scan.c
@@ -36,6 +36,13 @@
 static bool
 extent_need_sync (void)
 {
+  /* For now always return true, to be on the safe side.
+     If/when FIEMAP semantics are well defined (before SEEK_HOLE support
+     is usable) and kernels implementing them are in use, we may relax
+     this once again.  */
+  return true;
+
+#if FIEMAP_BEHAVIOR_IS_DEFINED_AND_USABLE
   static int need_sync = -1;

   if (need_sync == -1)
@@ -57,6 +64,7 @@ extent_need_sync (void)
     }

   return need_sync;
+#endif
 }

 /* Allocate space for struct extent_scan, initialize the entries if
--
1.7.5.rc2.295.g19c42


>From f35019b45e2b1ff6e1940db7b452dcb8f674f190 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Wed, 20 Apr 2011 10:15:15 +0200
Subject: [PATCH 2/4] copy: do not treat unwritten extents specially (avoid
 XFS corruption)

* src/copy.c (extent_copy): Do not treat "unwritten extents" specially.
Otherwise, with XFS and a release-candidate 2.6.39-rc3 kernel, and
when using gold as your linker[*], and if you don't run "make check",
you could end up installing files full of zeros instead of the
expected binaries.  For a lot of discussion, see
http://thread.gmane.org/gmane.comp.file-systems.xfs.general/37895

[*] Gold preallocates space for the files it writes, which is good.
However, on XFS, that conspired with the other conditions to result
the malfunctioning of the just-built install binary.
---
 src/copy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/copy.c b/src/copy.c
index 9b53127..f6f9ea6 100644
--- a/src/copy.c
+++ b/src/copy.c
@@ -398,7 +398,10 @@ extent_copy (int src_fd, int dest_fd, char *buf, size_t buf_size,
           /* Treat an unwritten but allocated extent much like a hole.
              I.E. don't read, but don't convert to a hole in the destination,
              unless SPARSE_ALWAYS.  */
-          if (scan.ext_info[i].ext_flags & FIEMAP_EXTENT_UNWRITTEN)
+          /* For now, do not treat FIEMAP_EXTENT_UNWRITTEN specially,
+             because that (in combination with no sync) would lead to data
+             loss at least on XFS and ext4 when using 2.6.39-rc3 kernels.  */
+          if (0 && (scan.ext_info[i].ext_flags & FIEMAP_EXTENT_UNWRITTEN))
             {
               empty_extent = true;
               last_ext_len = 0;
--
1.7.5.rc2.295.g19c42


>From 489261905dfee95cc1ebb708e8302bb246519b8b Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Wed, 20 Apr 2011 10:23:32 +0200
Subject: [PATCH 3/4] copy: factor out a tiny sparse-testing function

* src/copy.c (HAVE_STRUCT_STAT_ST_BLOCKS): Define to 0 if undefined,
so we can use it in the return expression, here:
(is_probably_sparse): New function, factored out of...
(copy_reg): ...here.  Use the new function.
---
 src/copy.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/src/copy.c b/src/copy.c
index f6f9ea6..3db07b5 100644
--- a/src/copy.c
+++ b/src/copy.c
@@ -764,6 +764,23 @@ fchmod_or_lchmod (int desc, char const *name, mode_t mode)
   return lchmod (name, mode);
 }

+#ifndef HAVE_STRUCT_STAT_ST_BLOCKS
+# define HAVE_STRUCT_STAT_ST_BLOCKS 0
+#endif
+
+/* Use a heuristic to determine whether stat buffer SB comes from a file
+   with sparse blocks.  If the file has fewer blocks than would normally
+   be needed for a file of its size, then at least one of the blocks in
+   the file is a hole.  In that case, return true.  */
+static bool
+is_probably_sparse (struct stat const *sb)
+{
+  return (HAVE_STRUCT_STAT_ST_BLOCKS
+          && S_ISREG (sb->st_mode)
+          && ST_NBLOCKS (*sb) < sb->st_size / ST_NBLOCKSIZE);
+}
+
+
 /* Copy a regular file from SRC_NAME to DST_NAME.
    If the source file contains holes, copies holes and blocks of zeros
    in the source file as holes in the destination file.
@@ -984,15 +1001,13 @@ copy_reg (char const *src_name, char const *dst_name,
           if (x->sparse_mode == SPARSE_ALWAYS)
             make_holes = true;

-#if HAVE_STRUCT_STAT_ST_BLOCKS
           /* Use a heuristic to determine whether SRC_NAME contains any sparse
              blocks.  If the file has fewer blocks than would normally be
              needed for a file of its size, then at least one of the blocks in
              the file is a hole.  */
-          if (x->sparse_mode == SPARSE_AUTO && S_ISREG (src_open_sb.st_mode)
-              && ST_NBLOCKS (src_open_sb) < src_open_sb.st_size / ST_NBLOCKSIZE)
+          if (x->sparse_mode == SPARSE_AUTO
+              && is_probably_sparse (&src_open_sb))
             make_holes = true;
-#endif
         }

       /* If not making a sparse file, try to use a more-efficient
--
1.7.5.rc2.295.g19c42


>From 39fdf629729319ab4011cf15c0a16cba4e4aba1b Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Wed, 20 Apr 2011 11:21:09 +0200
Subject: [PATCH 4/4] copy: use FIEMAP (extent_copy) only for
 apparently-sparse files,

to avoid the expense of extent_copy's unconditional use of
FIEMAP_FLAG_SYNC.
* src/copy.c (copy_reg): Do not attempt extent_copy on a file
that appears to have no holes.
* NEWS (Changes in behavior): Document this.  At first I labeled this
as a bug fix, but that would be inaccurate, considering there is no
documentation of FIEMAP semantics, nor even consensus among kernel
FS developers.  Here's hoping SEEK_HOLE/SEEK_DATA support will soon
make it into the linux kernel.
---
 NEWS       |   13 +++++++++++++
 src/copy.c |   37 +++++++++++++++++++++----------------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/NEWS b/NEWS
index 4873b5a..7bc2ef3 100644
--- a/NEWS
+++ b/NEWS
@@ -2,6 +2,19 @@ GNU coreutils NEWS                                    -*- outline -*-

 * Noteworthy changes in release ?.? (????-??-??) [?]

+** Changes in behavior
+
+  cp's extent-based (FIEMAP) copying code is more reliable in the face
+  of varying and undocumented file system semantics:
+  - it no longer treats unwritten extents specially
+  - a FIEMAP-based extent copy always uses the FIEMAP_FLAG_SYNC flag.
+      Before, it would incur the performance penalty of that sync only
+      for 2.6.38 and older kernels.  We thought all problems would be
+      resolved for 2.6.39.
+  - it now attempts a FIEMAP copy only on a file that appears sparse.
+      Sparse files are relatively unusual, and the copying code incurs
+      the performance penalty of the now-mandatory sync only for them.
+

 * Noteworthy changes in release 8.11 (2011-04-13) [stable]

diff --git a/src/copy.c b/src/copy.c
index 3db07b5..6edf52e 100644
--- a/src/copy.c
+++ b/src/copy.c
@@ -993,6 +993,7 @@ copy_reg (char const *src_name, char const *dst_name,

       /* Deal with sparse files.  */
       bool make_holes = false;
+      bool sparse_src = false;

       if (S_ISREG (sb.st_mode))
         {
@@ -1005,8 +1006,8 @@ copy_reg (char const *src_name, char const *dst_name,
              blocks.  If the file has fewer blocks than would normally be
              needed for a file of its size, then at least one of the blocks in
              the file is a hole.  */
-          if (x->sparse_mode == SPARSE_AUTO
-              && is_probably_sparse (&src_open_sb))
+          sparse_src = is_probably_sparse (&src_open_sb);
+          if (x->sparse_mode == SPARSE_AUTO && sparse_src)
             make_holes = true;
         }

@@ -1038,21 +1039,25 @@ copy_reg (char const *src_name, char const *dst_name,
       buf_alloc = xmalloc (buf_size + buf_alignment_slop);
       buf = ptr_align (buf_alloc, buf_alignment);

-      bool normal_copy_required;
-      /* Perform an efficient extent-based copy, falling back to the
-         standard copy only if the initial extent scan fails.  If the
-         '--sparse=never' option is specified, write all data but use
-         any extents to read more efficiently.  */
-      if (extent_copy (source_desc, dest_desc, buf, buf_size,
-                       src_open_sb.st_size,
-                       S_ISREG (sb.st_mode) ? x->sparse_mode : SPARSE_NEVER,
-                       src_name, dst_name, &normal_copy_required))
-        goto preserve_metadata;
-
-      if (! normal_copy_required)
+      if (sparse_src)
         {
-          return_val = false;
-          goto close_src_and_dst_desc;
+          bool normal_copy_required;
+
+          /* Perform an efficient extent-based copy, falling back to the
+             standard copy only if the initial extent scan fails.  If the
+             '--sparse=never' option is specified, write all data but use
+             any extents to read more efficiently.  */
+          if (extent_copy (source_desc, dest_desc, buf, buf_size,
+                           src_open_sb.st_size,
+                           S_ISREG (sb.st_mode) ? x->sparse_mode : SPARSE_NEVER,
+                           src_name, dst_name, &normal_copy_required))
+            goto preserve_metadata;
+
+          if (! normal_copy_required)
+            {
+              return_val = false;
+              goto close_src_and_dst_desc;
+            }
         }

       off_t n_read;
--
1.7.5.rc2.295.g19c42

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
