Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06Mmvlf117975 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 16:48:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7ECBAEDA0DF
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 14:49:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	FFkVPmG6pmOJTIQC for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2010 14:49:47 -0800 (PST)
Date: Thu, 7 Jan 2010 09:49:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] Kill async inode writeback V2
Message-ID: <20100106224944.GW13802@discord.disaster>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
	<20100106180800.GA9613@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100106180800.GA9613@infradead.org>
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

On Wed, Jan 06, 2010 at 01:08:00PM -0500, Christoph Hellwig wrote:
> Btw, after this series XFS_IFLUSH_DELWRI_ELSE_SYNC is also unused,
> might be worth to throw something like the patch below in to clean
> up xfs_iflush:

Yes, makes sense. I'll add the patch to my QA series after updating
it for the slight changes to the unmount reclaim I ahd in the
second posting of the patch. Can I get a signoff from you for this?

> I'm also not sure we do enough of the noblock calls either with or
> without your series.  There seem to be a lot more non-blocking sync
> calls than iflush calls.

I don't quite follow - inode flushes from the bdi threads should be
the majority of flushes (i.e. from xfs_fs_write_inode()) and they
are non-blocking. the xfssyncd does delwri writeback (maybe that
should be non-blocking and then we can get rid of that flag, too),
so the only sync inode writeback path is from xfs_fs_write_inode()
for sync flushing, as well as the unmount reclaim path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
