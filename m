Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4UN6sS7131537 for <xfs@oss.sgi.com>; Sun, 30 May 2010 18:06:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36F1DA9311E
	for <xfs@oss.sgi.com>; Sun, 30 May 2010 16:11:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	NIYSfB5CH8a67MNo for <xfs@oss.sgi.com>;
	Sun, 30 May 2010 16:11:27 -0700 (PDT)
Date: Mon, 31 May 2010 09:09:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove lazy per-AG initialization
Message-ID: <20100530230915.GA13732@dastard>
References: <20100528175108.GA9421@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100528175108.GA9421@infradead.org>
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

On Fri, May 28, 2010 at 01:51:08PM -0400, Christoph Hellwig wrote:
> Historically XFS initializes the allocator / inode allocator per-AG
> lazily, that is the first time this information is required.  For
> filesystems that use lazy superblock counters (which is the default now)
> we already have to walk all AGs to initialize the superblock counters
> on an unclean shutdown.

Which is not common, so isn't frequently triggered in the normal
mount process. The reason for the lazy initialisation is to speed
the mount process up when there are thousands of AGs. That is, we
avoid thousands of serialised IOs in the mount path. Have you
checked to see what the impact is on the clean mount execution time
is on such a filesystem?

FWIW, in the case of an unclean shutdown, we are already on the slow path
due to log recovery so adding IO to read all the headers it not such
a big deal as they have probably been read in during replay, anyway.

> This patch generalizes that code so that we
> always initialize the per-AG data on mount, and also during growfs so
> that we can remove all the special case code in the fastpath which
> couldn't assume that the per-AG data is already initialized.

I like the cleanup, but I'm not sure that potentially adding tens of
seconds to the time to mount a really large filesystem is a good
tradeoff...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
