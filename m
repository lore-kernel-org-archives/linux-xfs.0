Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p05MnFiU242194 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 16:49:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF02D2385E3
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 14:51:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	h9iduD2kN6dTbqam for <xfs@oss.sgi.com>;
	Wed, 05 Jan 2011 14:51:22 -0800 (PST)
Date: Thu, 6 Jan 2011 09:50:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: add FITRIM support
Message-ID: <20110105225039.GD8322@dastard>
References: <20101125112304.GA4195@infradead.org>
	<20110103232514.GF15179@dastard>
	<alpine.LFD.2.00.1101051105120.3095@dhcp-lab-213.englab.brq.redhat.com>
	<201101052307.38379@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201101052307.38379@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Wed, Jan 05, 2011 at 11:07:35PM +0100, Michael Monnerie wrote:
> On Mittwoch, 5. Januar 2011 Lukas Czerner wrote:
> > If we
> > notice that we are running out of space in advance (how much in
> > advance?), we can start trimming smaller chunks, until we reach
> > reasonable a reasonable pool of reclaimed space, or until we trim
> > the whole device.
> 
> Would it be possible that all blocks that have been in use since the 
> last FITRIM run can be logged? Like this, we would only need to clean 
> those. If you have a 2TB volume, probably only 25% of it have been 
> rewritten (=500GB) since the last run, and of that maybe 80% are still 
> in use at the time we run FITRIM, so only 100GB would need the cleanup.
> Maybe each AG could store a bitmap of written blocks, that are reset by 
> a FITRIM run. That could be an asynchronous written bitmap and shouldn't 
> disturb performance too much. Maybe it's even only needed to store a bit 
> per sunit*swidth blocks, to keep that table small. A mount option could 
> be used to enable that feature, so only those which use thin 
> provisioning or SSDs or similar devices enable it at wish.

Not easily. It would need a second set of free space btrees for
tracking freed but untrimmed extents. The idea of the background
trim is that it doesn't need all that complexity because all the
status information on where the trim process is up to can be kept
in userspace.

This is basically the same mode of functioning as the period
background xfs_fsr defragmentation mode - run it for an hour every
couple of nights,and it will slowly work it way through the entire
filesystem over a period of weeks. No state or additional on-disk
structures are needed for xfs_fsr to do it's work....

The background trim is intended to enable even the slowest of
devices to be trimmed over time, while introducing as little runtime
overhead and complexity as possible. Hence adding complexity and
runtime overhead to optimise background trimming tends to defeat the
primary design goal....

> Especially for 100TB size devices that seems like something that should 
> be thought of, as maybe if you run FITRIM once a week there, only <10TB 
> have been rewritten, if at all, and such a table would boost a FITRIM 
> run a lot.

If we want optimised, only-trim-what-we-free behaviour, we need to
hook into the transaction subsystem and issue TRIM commands at the
time extents are actually freed. That is much more complex to
implement but much easier to optimise because it doesn't require
persistent state on disk. However, most devices are simply not ready
to handle the flood of TRIM commands this generates, with
performance degrading by ~10-20% for the best of devices and
_10-100x_ for the worst...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
