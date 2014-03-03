Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 50CA729E06
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 23:40:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 14E4A8F8039
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 21:40:08 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4yeK2bReU6a5VRnS for <xfs@oss.sgi.com>;
	Sun, 02 Mar 2014 21:40:06 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKLbY-0002b9-Lo
	for xfs@oss.sgi.com; Mon, 03 Mar 2014 16:39:56 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKLbY-00085w-Ke
	for xfs@oss.sgi.com; Mon, 03 Mar 2014 16:39:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: use NOIO contexts for vm_map_ram
Date: Mon,  3 Mar 2014 16:39:54 +1100
Message-Id: <1393825194-1719-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1393825194-1719-1-git-send-email-david@fromorbit.com>
References: <1393825194-1719-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we map pages in the buffer cache, we can do so in GFP_NOFS
contexts. However, the vmap interfaces do not provide any method of
communicating this information to memory reclaim, and hence we get
lockdep complaining about it regularly and occassionally see hangs
that may be vmap related reclaim deadlocks. We can also see these
same problems from anywhere where we use vmalloc for a large buffer
(e.g. attribute code) inside a transaction context.

A typical lockdep report shows up as a reclaim state warning like so:

[14046.101458] =================================
[14046.102850] [ INFO: inconsistent lock state ]
[14046.102850] 3.14.0-rc4+ #2 Not tainted
[14046.102850] ---------------------------------
[14046.102850] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[14046.102850] kswapd0/14 [HC0[0]:SC0[0]:HE1:SE1] takes:
[14046.102850]  (&xfs_dir_ilock_class){++++?+}, at: [<791a04bb>] xfs_ilock+0xff/0x16a
[14046.102850] {RECLAIM_FS-ON-W} state was registered at:
[14046.102850]   [<7904cdb1>] mark_held_locks+0x81/0xe7
[14046.102850]   [<7904d390>] lockdep_trace_alloc+0x5c/0xb4
[14046.102850]   [<790c2c28>] kmem_cache_alloc_trace+0x2b/0x11e
[14046.102850]   [<790ba7f4>] vm_map_ram+0x119/0x3e6
[14046.102850]   [<7914e124>] _xfs_buf_map_pages+0x5b/0xcf
[14046.102850]   [<7914ed74>] xfs_buf_get_map+0x67/0x13f
[14046.102850]   [<7917506f>] xfs_attr_rmtval_set+0x396/0x4d5
[14046.102850]   [<7916e8bb>] xfs_attr_leaf_addname+0x18f/0x37d
[14046.102850]   [<7916ed9e>] xfs_attr_set_int+0x2f5/0x3e8
[14046.102850]   [<7916eefc>] xfs_attr_set+0x6b/0x74
[14046.102850]   [<79168355>] xfs_xattr_set+0x61/0x81
[14046.102850]   [<790e5b10>] generic_setxattr+0x59/0x68
[14046.102850]   [<790e4c06>] __vfs_setxattr_noperm+0x58/0xce
[14046.102850]   [<790e4d0a>] vfs_setxattr+0x8e/0x92
[14046.102850]   [<790e4ddd>] setxattr+0xcf/0x159
[14046.102850]   [<790e5423>] SyS_lsetxattr+0x88/0xbb
[14046.102850]   [<79268438>] sysenter_do_call+0x12/0x36

Now, we can't completely remove these traces - mainly because
vm_map_ram() will do GFP_KERNEL allocation and that generates the
above warning before we get into the reclaim code, but we can turn
them all into false positive warnings.

To do that, use the method that DM and other IO context code uses to
avoid this problem: there is a process flag to tell memory reclaim
not to do IO that we can set appropriately. That prevents GFP_KERNEL
context reclaim being done from deep inside the vmalloc code in
places we can't directly pass a GFP_NOFS context to. That interface
has a pair of wrapper functions: memalloc_noio_save() and
memalloc_noio_restore().

Adding them around vm_map_ram and the vzalloc call in
kmem_alloc_large() will prevent deadlocks and most lockdep reports
for this issue. Also, convert the vzalloc() call in
kmem_alloc_large() to use __vmalloc() so that we can pass the
correct gfp context to the data page allocation routine inside
__vmalloc() so that it is clear that GFP_NOFS context is important
to this vmalloc call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.c    | 21 ++++++++++++++++++++-
 fs/xfs/xfs_buf.c | 11 +++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 66a36be..844e288 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -65,12 +65,31 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 {
+	unsigned noio_flag = 0;
 	void	*ptr;
+	gfp_t	lflags;
 
 	ptr = kmem_zalloc(size, flags | KM_MAYFAIL);
 	if (ptr)
 		return ptr;
-	return vzalloc(size);
+
+	/*
+	 * __vmalloc() will allocate data pages and auxillary structures (e.g.
+	 * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context
+	 * here. Hence we need to tell memory reclaim that we are in such a
+	 * context via PF_MEMALLOC_NOIO to prevent memory reclaim re-entering
+	 * the filesystem here and potentially deadlocking.
+	 */
+	if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
+		noio_flag = memalloc_noio_save();
+
+	lflags = kmem_flags_convert(flags);
+	ptr = __vmalloc(size, lflags | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
+
+	if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
+		memalloc_noio_restore(noio_flag);
+
+	return ptr;
 }
 
 void
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9c061ef..107f2fd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -396,7 +396,17 @@ _xfs_buf_map_pages(
 		bp->b_addr = NULL;
 	} else {
 		int retried = 0;
+		unsigned noio_flag;
 
+		/*
+		 * vm_map_ram() will allocate auxillary structures (e.g.
+		 * pagetables) with GFP_KERNEL, yet we are likely to be under
+		 * GFP_NOFS context here. Hence we need to tell memory reclaim
+		 * that we are in such a context via PF_MEMALLOC_NOIO to prevent
+		 * memory reclaim re-entering the filesystem here and
+		 * potentially deadlocking.
+		 */
+		noio_flag = memalloc_noio_save();
 		do {
 			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
 						-1, PAGE_KERNEL);
@@ -404,6 +414,7 @@ _xfs_buf_map_pages(
 				break;
 			vm_unmap_aliases();
 		} while (retried++ <= 1);
+		memalloc_noio_restore(noio_flag);
 
 		if (!bp->b_addr)
 			return -ENOMEM;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
