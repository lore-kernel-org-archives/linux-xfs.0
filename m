Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22BEJfB041741 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 05:14:19 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DQKqIdNhNRHCBB0b (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 03:14:18 -0800 (PST)
Date: Fri, 2 Mar 2012 06:14:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: add a shrinker for quotacheck
Message-ID: <20120302111416.GA18979@infradead.org>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-9-git-send-email-david@fromorbit.com>
	<20120302075104.GG4117@infradead.org>
	<20120302100426.GI5091@dastard>
	<20120302103831.GA16825@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120302103831.GA16825@infradead.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 02, 2012 at 05:38:31AM -0500, Christoph Hellwig wrote:
> Right, the whole issue also applies to any bulkstat.  But even for that
> it doesn't seem that bad.
> 
> We add a new XFS_IGET_BULKSTAT flag for iget, which then sets an
> XFS_INOTCACHE or similar flag on the inode.  If we see that in bulkstat
> on a clean inode in ->drop_inode return true there, which takes care
> of the VFS side.
> 
> For the XFS side we'd have to move the call to xfs_syncd_init earlier 
> during the mount process, which effectively revers
> 2bcf6e970f5a88fa05dced5eeb0326e13d93c4a1.  That should be fine now that
> we never call into the quota code from the sync work items.  If we want
> to be entirely on the safe side we could only move starting the reclaim
> work item earlier.

It seems like we actually only need the second for to fix the quotacheck
issue (or to be equivalent to your patch), even if the first one would
be nice to have eventually.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
