Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GHXpSq048620
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 12:33:51 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6FFCDC9156
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 10:33:49 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id B6o22GlkeZz5eUDx for <linux-xfs@oss.sgi.com>;
	Thu, 16 Jun 2011 10:33:49 -0700 (PDT)
Message-ID: <4DFA3E7D.4030408@sandeen.net>
Date: Thu, 16 Jun 2011 12:33:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: sparse file handling bug in XFS
References: <081DDE43F61F3D43929A181B477DCA95639B561F@MSXAOA6.twosigma.com>
	<4DFA2A76.6000104@sandeen.net>
In-Reply-To: <4DFA2A76.6000104@sandeen.net>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>, Ian Baum <Ian.Baum@twosigma.com>, Stephen Degler <Stephen.Degler@twosigma.com>

On 6/16/11 11:08 AM, Eric Sandeen wrote:
> On 6/16/11 9:49 AM, Sean Noonan wrote:
>> Sparse files do not stay sparse.
>> Here's the simplest test case I've got so far.  I don't think it can get much simpler than this.
>>
>> This did not exist in 2.6.36.  It appeared by 2.6.38-rc8.  It continued into 2.6.38.2.  It continues to exist on 3.0.0-rc3.
>>
>> # for x in gogo xfs; do date | dd of=sparse-file bs=1k seek=4096; stat sparse-file; done
> 
> Funky; if we do xfs_bmap, it shows the right nr of blocks allocated:
> 
> # for x in gogo xfs; do date | dd of=sparse-file bs=1k seek=4096; stat sparse-file | grep Blocks; xfs_bmap -v sparse-file; done
>   Size: 4194333   	Blocks: 8          IO Block: 4096   regular file
> sparse-file:
>  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL
>    0: [0..8191]:       hole                                          8192
>    1: [8192..8199]:    450475168..450475175  2 (18736320..18736327)     8
> 
>   Size: 4194333   	Blocks: 8192       IO Block: 4096   regular file
> sparse-file:
>  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL
>    0: [0..8191]:       hole                                          8192
>    1: [8192..8199]:    459367952..459367959  2 (27629104..27629111)     8
> 
> 
> And if we unmount & remount it's right again:
> 
> # stat sparse-file | grep Blocks
>   Size: 4194333   	Blocks: 8          IO Block: 4096   regular file
> 
> so they do remain sparse, but stat tells us the wrong thing.  I think it has
> to do with the count of delayed blocks but I'll try to look into it.

Actually this looks like it's a result of

6e857567dbbfe14dd6cc3f7414671b047b1ff5c7 xfs: don't truncate prealloc from frequently accessed inodes

I thought Dave's patch from the "Re: drastic changes to allocsize semantics in or around 2.6.38?"
thread would fix it, but it doesn't seem to.  Here it is anyway ;)

xfs: clear inode dirty release flag when recycling it

From: Dave Chinner <dchinner@redhat.com>

The state used to track dirty inode release calls is not reset when
an inode is reallocated and reused from the reclaimable state. This
leads to specualtive preallocation not being truncated away in the
expected manner for local files until the inode is subsequently
truncated, freed or cycles out of the cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index cb9b6d1..e75e757 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -241,6 +241,13 @@ xfs_iget_cache_hit(
 		 */
 		ip->i_flags |= XFS_IRECLAIM;
 
+		/*
+		 * clear the dirty release state as we are now effectively a
+		 * new inode and so we need to treat speculative preallocation
+		 * accordingly.
+		 */
+		ip->i_flags &= ~XFS_IDIRTY_RELEASE;
+
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
