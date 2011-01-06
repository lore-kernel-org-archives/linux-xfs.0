Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06I6GoY099293 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 12:06:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC5F71D13A66
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 10:08:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7XWaDa4BnuAmGrIW for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 10:08:20 -0800 (PST)
Date: Thu, 6 Jan 2011 13:08:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: add FITRIM support
Message-ID: <20110106180818.GC32670@infradead.org>
References: <20101125112304.GA4195@infradead.org>
	<20110103232514.GF15179@dastard>
	<alpine.LFD.2.00.1101051105120.3095@dhcp-lab-213.englab.brq.redhat.com>
	<201101052307.38379@zmi.at> <20110105225039.GD8322@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110105225039.GD8322@dastard>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jan 06, 2011 at 09:50:39AM +1100, Dave Chinner wrote:
> If we want optimised, only-trim-what-we-free behaviour, we need to
> hook into the transaction subsystem and issue TRIM commands at the
> time extents are actually freed. That is much more complex to
> implement but much easier to optimise because it doesn't require
> persistent state on disk. However, most devices are simply not ready
> to handle the flood of TRIM commands this generates, with
> performance degrading by ~10-20% for the best of devices and
> _10-100x_ for the worst...

I tested a few devices that have zero to 1% degradation, but those
were arrays, which allow for queued WRITE SAME/UNMAP commands instead
of the unqueued TRIM in ATA.  But I'm gettig close to finishing the
online discard and will start another benchmark session soon.  With
PCI-E flash devices that aren't limited by the ATA protocol, and the
proposed queueable TRIM command this looks like what we need for the
future.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
