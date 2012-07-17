Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HHRSGY093790 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 12:27:28 -0500
Message-ID: <5005A079.4010007@sgi.com>
Date: Tue, 17 Jul 2012 12:27:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] do not take the iolock in inode reclaim context
References: <20120704151328.928543446@bombadil.infradead.org>
	<20120717071923.GD15473@infradead.org>
	<alpine.DEB.2.00.1207170845060.30672@cobra.newdream.net>
In-Reply-To: <alpine.DEB.2.00.1207170845060.30672@cobra.newdream.net>
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
To: Sage Weil <sage@inktank.com>
Cc: Christoph Hellwig <hch@infradead.org>, sage@newdream.net, xfs@oss.sgi.com

On 07/17/12 10:46, Sage Weil wrote:
> On Tue, 17 Jul 2012, Christoph Hellwig wrote:
>> ping/  I'd really like to get this queued up for 3.6
>
> I forget if I mentioned this before, but I pulled this series into our
> testing branch and have had no problems (aside from the last patch not
> applying to my tree) in qa (ceph on xfs) over the last couple of weeks.
>
> sage

Sage,

The patch "5-5-xfs-remove-iolock-lock-classes.patch" does not cleanly
apply because the comment that the patch is trying to remove in
xfs_iget.c has the following character sequence "<D1><95>" that the
mailer converted to a "?". It is easy enough to hand patch:


/*
  * Define xfs inode iolock lockdep classes. We need to ensure that all 
active
  * inodes are considered the same for lockdep purposes, including 
inodes that
  * are recycled through the XFS_IRECLAIMABLE state. This is the the 
only way to
  * guarantee the locks are considered the same when there are multiple lock
  * initialisation site<D1><95>. Also, define a reclaimable inode class 
so it is
                       ^^^^^^^^

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
