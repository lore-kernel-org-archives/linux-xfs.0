Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M3UQTR024444 for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 22:30:26 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D706C1DA2558
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 20:30:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	InCKkjQENmzrop9y for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 20:30:23 -0700 (PDT)
Date: Mon, 22 Aug 2011 13:28:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug#638158: xfsprogs: Damaged filesystem causes xfs_repair to
	sometimes (but not always) segfault
Message-ID: <20110822032849.GD3162@dastard>
References: <E1QtbO1-0005u8-5N@eamp.org> <201108171518.53374@zmi.at>
	<E1QvGzO-0001aI-4l@eamp.org> <20110822012705.GC3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110822012705.GC3162@dastard>
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
To: Robert Jacobs <debbtsb06@eamp.org>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Mon, Aug 22, 2011 at 11:27:05AM +1000, Dave Chinner wrote:
> On Sun, Aug 21, 2011 at 03:59:34PM -0700, Robert Jacobs wrote:
> > > On Mittwoch, 17. August 2011 Robert Jacobs wrote:
> > > > I've attached the outputs of xfs_check and three different runs of
> > > > xfs_repair (with backtrace, when available).
> > > 
> > > Can you provide a XFS metadump? That should help devs to reproduce the 
> > > error. 
> > 
> > I've uploaded it to <http://eamp.org/metadumpf.lzma>. It's 9MB but I
> > have somewhat limited upload quota. I noticed that some filenames
> > weren't obscured so I obscured them by hand -- if this is a problem,
> > please tell me. 
> 
> The metadump image you have provided does not trigger problems on
> either 3.1.5 on a current xfs_repair build out of the xfsprogs-dev
> repository on my machines. Can you restore the image and run
> xfs_repair on the image and confirm it still crashes?

I stand corrected - it doesn't crash on x86-64, but does crash on
i686. I get several different random crashes, so it looks like some
kind of heap corruption is occurring. Running under valgrind shows
that the inode extent blkmaps are getting out of bound reads and
writes. I think the problem is this:

typedef struct bmap_ext {
        xfs_dfiloff_t   startoff;
        xfs_dfsbno_t    startblock;
        xfs_dfilblks_t  blockcount;
} bmap_ext_t;

That's a 32 byte structure. Then there is this:

/*
 * Block map.
 */
typedef struct blkmap {
        int             naexts;
        int             nexts;
        bmap_ext_t      exts[1];
} blkmap_t;

#define BLKMAP_SIZE(n)  \
        (offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))

So the allocation here is (8 + (32 * n)) bytes. In the case of the
corruption, I am seeing this number of extents being asked for:

realloc from 11 to 536870913 fork data

so n = 536870913. therefore the allocation size is:

	size = 8 + (32 * 536870913)
	     = 17,179,869,224
	     = 0x400000028

Which, when we truncate to 32 bits is 0x28 or 40 bytes. So, access
to the second extent will overflow the allocated array and we
corrupt memory.

The patch below will result in the following output with that
metadump image when it encounters this corruption:

Number of extents requested in blkmap_alloc (536870913) overflows 32 bits.
If this is not a corruption, then you will need a 64 bit system
to repair this filesystem.

It will then continue and shouldn't crash.

As it is, I'd recommend upgrading to x86-64 anyway - XFS on i686
doesn't receive a lot of developer testing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs-repair: fix some valgrind reported errors on i686

From: Dave Chinner <dchinner@redhat.com>

Fix a potential prefetch read problem due to the first loop
execution of pf_batch_read potentially not initialising the fsbno
varaible:

==10177== Thread 6:
==10177== Conditional jump or move depends on uninitialised value(s)
==10177==    at 0x8079CAB: pf_batch_read (prefetch.c:408)
==10177==    by 0x6A2996D: clone (clone.S:130)
==10177==

Fix a bunch of invalid read/write errors due to excessive blkmap
allocations when inode forks are corrupted. These show up some time
after making a blkmap allocation for 536870913 extents on i686,
which is followed some time later by a crash caused bymemory
corruption.

This blkmap allocation size overflows 32 bits in such a
way that it results in a 32 byte allocation and so access to the
second extent results in access beyond the allocated memory and
corrupts random memory.

==5419== Invalid write of size 4
==5419==    at 0x80507DA: blkmap_set_ext (bmap.c:260)
==5419==    by 0x8055CF4: process_bmbt_reclist_int (dinode.c:712)
==5419==    by 0x8056206: process_bmbt_reclist (dinode.c:813)
==5419==    by 0x80579DA: process_exinode (dinode.c:1324)
==5419==    by 0x8059B77: process_dinode_int (dinode.c:2036)
==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
==5419==    by 0xFFF: ???
==5419==  Address 0x944cfb8 is 0 bytes after a block of size 32 alloc'd
==5419==    at 0x48E1102: realloc (in
/usr/lib/valgrind/vgpreload_memcheck-x86-linux.so)
==5419==    by 0x80501F3: blkmap_alloc (bmap.c:56)
==5419==    by 0x80599F5: process_dinode_int (dinode.c:2027)
==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
==5419==    by 0xFFF: ???

Add overflow detection code into the blkmap allocation code to avoid
this problem, and also free large allocations once they are finished
with to avoid pinning large amounts of memory due to the occasional
large extent list in a filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/bmap.c     |   37 ++++++++++++++++++++++++++++++++++++-
 repair/prefetch.c |    2 +-
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 79b9f79..1127a87 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -47,6 +47,17 @@ blkmap_alloc(
 	if (nex < 1)
 		nex = 1;
 
+#if (BITS_PER_LONG != 64)
+	if (nex > (INT_MAX / sizeof(bmap_ext_t) - 1)) {
+		do_warn(
+	_("Number of extents requested in blkmap_alloc (%u) overflows 32 bits.\n"
+	  "If this is not a corruption, then will need a 64 bit system\n"
+	  "to repair this filesystem.\n"),
+			nex);
+		return NULL;
+	}
+#endif
+
 	key = whichfork ? ablkmap_key : dblkmap_key;
 	blkmap = pthread_getspecific(key);
 	if (!blkmap || blkmap->naexts < nex) {
@@ -66,12 +77,27 @@ blkmap_alloc(
 
 /*
  * Free a block map.
+ *
+ * If the map is a large, uncommon size (say for hundreds of thousands of
+ * extents) then free it to release the memory. This prevents us from pinning
+ * large tracts of memory due to corrupted fork values or one-off fragmented
+ * files. Otherwise we have nothing to do but keep the memory around for the
+ * next inode
  */
 void
 blkmap_free(
 	blkmap_t	*blkmap)
 {
-	/* nothing to do! - keep the memory around for the next inode */
+	/* consider more than 100k extents rare */
+	if (blkmap->naexts < 100 * 1024)
+		return;
+
+	if (blkmap == pthread_getspecific(dblkmap_key))
+		pthread_setspecific(dblkmap_key, NULL);
+	else
+		pthread_setspecific(ablkmap_key, NULL);
+
+	free(blkmap);
 }
 
 /*
@@ -218,6 +244,15 @@ blkmap_grow(
 	}
 
 	blkmap->naexts += 4;
+#if (BITS_PER_LONG != 64)
+	if (blkmap->naexts > (INT_MAX / sizeof(bmap_ext_t) - 1)) {
+		do_error(
+	_("Number of extents requested in blkmap_grow (%u) overflows 32 bits.\n"
+	  "You need a 64 bit system to repair this filesystem.\n"),
+			blkmap->naexts);
+		return NULL;
+	}
+#endif
 	blkmap = realloc(blkmap, BLKMAP_SIZE(blkmap->naexts));
 	if (blkmap == NULL)
 		do_error(_("realloc failed in blkmap_grow\n"));
diff --git a/repair/prefetch.c b/repair/prefetch.c
index d2fdf90..da074a8 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -397,7 +397,7 @@ pf_batch_read(
 	int			len, size;
 	int			i;
 	int			inode_bufs;
-	unsigned long		fsbno;
+	unsigned long		fsbno = 0;
 	unsigned long		max_fsbno;
 	char			*pbuf;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
