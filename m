Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ2JABM023488 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:19:11 -0600
Message-ID: <4923777D.9070101@sgi.com>
Date: Wed, 19 Nov 2008 13:18:37 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: assertion failed in xfs_reclaim_inodes_ag()
References: <49221D83.6030406@sgi.com> <20081118133844.GA17894@infradead.org>
	<20081118135356.GA21792@infradead.org>
In-Reply-To: <20081118135356.GA21792@infradead.org>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, Nov 18, 2008 at 08:38:44AM -0500, Christoph Hellwig wrote:
>> On Tue, Nov 18, 2008 at 12:42:27PM +1100, Lachlan McIlroy wrote:
>>> Hit this while running stress tests.  Looks like an inode is tagged with
>>> XFS_ICI_RECLAIM_TAG but not XFS_IRECLAIMABLE|XFS_IRECLAIM.  I can't see
>>> how that can happen.
>> Looks it's xfs_iget_cache_hit when the inode is marked XFS_IRECLAIMABLE,
>> in that case we first clear XFS_IRECLAIMABLE and then call
>> __xfs_inode_clear_reclaim_tag, and all that under
>> read_lock(&pag->pag_ici_lock) only, so no protection against the assert
>> in xfs_reclaim_inodes_ag.
Oh, of course.  I thought I found the problem but then saw the pag_ici_lock
was held in xfs_iget_cache_hit - I didn't realise it was only in read mode.
I assumed that if we are changing the state of the inode we would at least
have some lock exclusive.

> 
> And the easiest fix is to just remove the assert, xfs_reclaim_inode does
> the right thing (bail out) if XFS_IRECLAIMABLE is not set, and it does
> so with the correct locks.  The more complicated fix would be to take
> the pag_ici_lock in write more from the very beginning in
> xfs_reclaim_inodes_ag, and open-code a variant of xfs_reclaim_inode
> there.
> 
Thanks.  I'll just remove the assert.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
