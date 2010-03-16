Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2G15CS8104628 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 20:05:12 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73D701D342BF
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 18:06:44 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	IgP5EqucUcKozTzH for <xfs@oss.sgi.com>;
	Mon, 15 Mar 2010 18:06:44 -0700 (PDT)
Date: Tue, 16 Mar 2010 12:06:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100316010636.GA12369@dastard>
References: <20100315043000.GK4732@dastard>
	<20100315160154.GA10406@infradead.org>
	<20100315163324.GA26379@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315163324.GA26379@infradead.org>
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

On Mon, Mar 15, 2010 at 12:33:24PM -0400, Christoph Hellwig wrote:
> On Mon, Mar 15, 2010 at 12:01:54PM -0400, Christoph Hellwig wrote:
> > Running the series on my KVM testbox trips out this assert in
> > xfstests 013, which suggests we might be calling iput one too
> > much somewhere (e.g. IOP_UNLOCK)):
> > 
> > [  132.174780] Assertion failed: atomic_read(&VFS_I(dp)->i_count) > 0, file: fs/xfs/xfs_vnodeops.c, line: 1430
> 
> Turns out this was due to the fsync clustering patch, which adds inodes
> to a transaction without first grabbing a reference to them.
> Unofrtunately grabbing the reference is not a easy as it sounds, as
> inodes in the cluster might be on the unused list or even not have
> valid VFS state anymore, so we can't simply call IHOLD here.  I've
> reverted the patch in my local tree for now.

Yeah, that change was only half-baked - I was in two minds as to
whether to include it. I'll drop it from the series until I've had
more time to consider it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
