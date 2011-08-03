Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73Lg8RH215407 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 16:42:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 986F3B8784
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 14:42:07 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qZefpO5yjMynI116 for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 14:42:07 -0700 (PDT)
Date: Wed, 3 Aug 2011 17:42:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Improve writeout pattern from xfs_flush_pages()
Message-ID: <20110803214206.GA20477@infradead.org>
References: <1312404545-15400-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312404545-15400-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 03, 2011 at 10:49:03PM +0200, Jan Kara wrote:
> 
>   Hi,
> 
>   at one of customer's machines, I've spotted an issue that sync(1) called
> after writing a single huge file has been achieving rather low throughput. After
> debugging this with blktrace, I've found that the culprit was in flusher thread
> racing with page writeout happening from XFS sync code. The patches below helped
> that case. Although they are not a complete solution, I belive they are useful
> anyway so please consider merging them...

We currently have three calls to xfs_flush_pages with XBF_ASYNC set:

 - xfs_setattr_size
 - xfs_sync_inode_data
 - xfs_release

The first one actually is a synchronous writeout, just implemented in
a rather odd way by doing the xfs_ioend_wait right after it, so your
change is actively harmful for it.  The second is only called from
xfs_flush_worker, which is the workqueue offload when we hit ENOSPC.
I can see how this might race with the writeback code, but the correct
fix is to replace it with a call to writeback_inodes_sb(_if_idle)
on that one is fixed to do a trylock on s_umount and thus won't
deadlock.  The third one is opportunistic writeout if a file got
truncated down on final release.  filemap_flush probably is fine
here, but there's no need for a range version.  If you replace it
with filemap_flush please also kill the useless wrapper while you're
at it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
