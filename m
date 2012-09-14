Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ECtXpg098734 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 07:55:33 -0500
Message-ID: <50532979.2070002@sgi.com>
Date: Fri, 14 Sep 2012 07:56:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 020/102] xfs: warn if direct reclaim tries to writeback
	pages
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<1345698180-13612-21-git-send-email-david@fromorbit.com>
	<20120827181742.GA13970@infradead.org>
	<20120905113242.GL11266@suse.de> <50523E20.5000508@sgi.com>
	<20120914094523.GD11266@suse.de>
In-Reply-To: <20120914094523.GD11266@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On 09/14/12 04:45, Mel Gorman wrote:
> On Thu, Sep 13, 2012 at 03:12:16PM -0500, Mark Tinguely wrote:
>> On 09/05/12 06:32, Mel Gorman wrote:
>>> On Mon, Aug 27, 2012 at 02:17:42PM -0400, Christoph Hellwig wrote:
>>>> On Thu, Aug 23, 2012 at 03:01:38PM +1000, Dave Chinner wrote:
>>>>> From: Mel Gorman<mgorman@suse.de>
>>>>>
>>>>> Upstream commit: 94054fa3fca1fd78db02cb3d68d5627120f0a1d4
>>>>>
>>>>> Direct reclaim should never writeback pages.  For now, handle the
>>>>> situation and warn about it.  Ultimately, this will be a BUG_ON.
>>>>
>>>> Is this actually the case on 3.0-stable?
>>>>
>>>
>>> No, it is not. AFAIK, 3.0-stable does not contain [ee72886d: mm: vmscan:
>>> do not writeback filesystem pages in direct reclaim] which is the absolute
>>> minimum required for commit [94054fa3: xfs: warn if direct reclaim tries
>>> to writeback pages] to make sense.
>>>
>>
>> I hit this warning testing on a linux-30.42 with a x86_64.
>>
>
> Just to be clear, this was linux 3.0.42 with this series of patches
> applied on top, right?
>
>> WARNING: at fs/xfs/linux-2.6/xfs_aops.c:961 xfs_vm_writepage+0x63c/0x6a0()
>> Hardware name: S2721-533 Thunder i7501 Pro
>> Modules linked in: ext4 jbd2 crc16
>> Pid: 12122, comm: cp Not tainted 3.0.42 #2
>
> I ask because on 3.0.42 this warning is not present. This patch should
> not be merged to 3.0-stable.
>

Correct. Linux-3.0.42 with Dave 102 patches, I removed patch 94 and 95 
per list comments. I added Brian Foster's patch as 103 <below>

I am testing xfstest 109 and 273 in a loop for shutdown worker races - 
none found yet. That message happened in the first loop, and never 
occurred again.

And the machine was a x86_32 not 64.

patch 103:


Subject: xfs: check for stale inode before acquiring iflock on push
From: Brian Foster <bfoster@redhat.com>
Upstream commit: 9a3a5dab63461b84213052888bf38a962b22d035

     An inode in the AIL can be flush locked and marked stale if
     a cluster free transaction occurs at the right time. The
     inode item is then marked as flushing, which causes xfsaild
     to spin and leaves the filesystem stalled. This is
     reproduced by running xfstests 273 in a loop for an
     extended period of time.

     Check for stale inodes before the flush lock. This marks
     the inode as pinned, leads to a log flush and allows the
     filesystem to proceed.

     Signed-off-by: Brian Foster <bfoster@redhat.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Reviewed-by: Christoph Hellwig <hch@lst.de>
     Reviewed-by: Mark Tinguely <tinguely@sgi.com>
     Signed-off-by: Ben Myers <bpm@sgi.com>


Index: linux-3.0.42/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-3.0.42.orig/fs/xfs/xfs_inode_item.c
+++ linux-3.0.42/fs/xfs/xfs_inode_item.c
@@ -507,6 +507,21 @@ xfs_inode_item_trylock(
  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
  		return XFS_ITEM_LOCKED;

+	/*
+	 * Re-check the pincount now that we stabilized the value by
+	 * taking the ilock.
+	 */
+	if (xfs_ipincount(ip) > 0) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return XFS_ITEM_PINNED;
+	}
+
+	/* Stale items should force out the iclog */
+	if (ip->i_flags & XFS_ISTALE) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return XFS_ITEM_PINNED;
+	}
+
  	if (!xfs_iflock_nowait(ip)) {
  		/*
  		 * inode has already been flushed to the backing buffer,
@@ -516,13 +531,6 @@ xfs_inode_item_trylock(
  		return XFS_ITEM_PUSHBUF;
  	}

-	/* Stale items should force out the iclog */
-	if (ip->i_flags & XFS_ISTALE) {
-		xfs_ifunlock(ip);
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return XFS_ITEM_PINNED;
-	}
-
  #ifdef DEBUG
  	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
  		ASSERT(iip->ili_fields != 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
