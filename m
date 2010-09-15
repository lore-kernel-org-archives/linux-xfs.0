Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F0RjQ1156057 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:27:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FD4B73D04
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:28:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	5K4BZpGjzpO5RUhd for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 17:28:32 -0700 (PDT)
Date: Wed, 15 Sep 2010 10:28:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/18] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20100915002828.GK15695@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-8-git-send-email-david@fromorbit.com>
	<1284502337.9701.89.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284502337.9701.89.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 14, 2010 at 05:12:17PM -0500, Alex Elder wrote:
> On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Under heavy multi-way parallel create workloads, the VFS struggles to write
> > back all the inodes that have been changed in age order. The bdi flusher thread
> > becomes CPU bound, spending 85% of it's time in the VFS code, mostly traversing
> > the superblock dirty inode list to separate dirty inodes old enough to flush.
> > 
> > We already keep an index of all metadata changes in age order - in the AIL -
> > and continued log pressure will do age ordered writeback without any extra
> > overhead at all. If there is no pressure on the log, the xfssyncd will
> > periodically write back metadata in ascending disk address offset order so will
> > be very efficient.
> 
> So log pressure will cause the logged updates to the inode to be
> written to disk (in order), which is all we really need.  Is that
> right?

Yes. And if there is no log pressure, xfssyncd will do the writeback
in an disk order efficient manner.

> Therefore we don't need to rely on the VFS layer to get
> the dirty inode pushed out?

No. Indeed, for all other types of metadata (btree blocks,
directory/attribute blocks, etc) we already rely on the
xfsaild/xfsbufd to write them out in a timely manner because the VFS
knows nothing about them.

> Is writeback the only reason we should inform the VFS that an
> inode is dirty?  (Sorry, I have to leave shortly and don't have
> time to follow this at the moment--I may have to come back to
> this later.)

Yes, pretty much. Take your time - this is one of the more radical
changes in the patch set...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
