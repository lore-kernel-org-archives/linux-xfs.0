Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R18NWp146053 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 20:08:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD0B89FD29
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 18:09:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	FSCgwCA8lYVAQqdA for <xfs@oss.sgi.com>;
	Sun, 26 Sep 2010 18:09:19 -0700 (PDT)
Date: Mon, 27 Sep 2010 11:09:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/18] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20100927010914.GB5665@dastard>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
	<1285331476-23015-6-git-send-email-david@fromorbit.com>
	<20100925234248.GA23975@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100925234248.GA23975@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Sep 25, 2010 at 07:42:48PM -0400, Christoph Hellwig wrote:
> As mentioned before I think xfs_trans_ichgtime should go into
> xfs_trans_inode.c/xfs_trans.h.  Instead of keeping xfs_ichgtime around
> for one caller it might be easier to just opencode it similar to
> what other filesystems do, e.g. just:
> 
> 	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
> 	mark_inode_dirty_sync(inode);
> 
> there's really no point in doing the check for an actual time change
> first as it's a relatively rare operation.

Ok. I'll respin it to do this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
