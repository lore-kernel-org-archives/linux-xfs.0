Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27D2F8047
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 15:52:18 -0500 (CDT)
Date: Fri, 15 Mar 2013 15:52:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Fix WARN_ON(delalloc) in xfs_vm_releasepage()
Message-ID: <20130315205214.GB22182@sgi.com>
References: <1363267854-25602-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363267854-25602-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

Hi Jan,

On Thu, Mar 14, 2013 at 02:30:54PM +0100, Jan Kara wrote:
> When a dirty page is truncated from a file but reclaim gets to it before
> truncate_inode_pages(), we hit WARN_ON(delalloc) in
> xfs_vm_releasepage(). This is because reclaim tries to write the page,
> xfs_vm_writepage() just bails out (leaving page clean) and thus reclaim
> thinks it can continue and calls xfs_vm_releasepage() on page with dirty
> buffers.
> 
> Fix the issue by redirtying the page in xfs_vm_writepage(). This makes
> reclaim stop reclaiming the page and also logically it keeps page in a
> more consistent state where page with dirty buffers has PageDirty set.

Was there an easy way to reproduce this?  I'm testing and reviewing this now
and it might help.

Thanks much,
       Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
