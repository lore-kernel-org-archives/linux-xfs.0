Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFEEE7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 20:09:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEED18F8037
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:09:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FNT7ayGtY6CDWYVf for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 18:09:37 -0700 (PDT)
Date: Wed, 26 Aug 2015 11:09:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
Message-ID: <20150826010923.GX3902@dastard>
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
	<55DCE1CF.5030708@sandeen.net>
	<CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>
	<20150825234300.GN714@dastard> <55DD0AAF.9090401@opensuse.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55DD0AAF.9090401@opensuse.org>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Wed, Aug 26, 2015 at 02:39:11AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On 2015-08-26 01:43, Dave Chinner wrote:
> > On Tue, Aug 25, 2015 at 04:09:33PM -0700, Shrinand Javadekar 
> > wrote:
> 
> >> Formatted the new disks with mkfs.xfs. Ran the workload. 
> >> Reformatted the disks with mkfs.xfs -f. Ran the workload.
> 
> 
> > Anyway, please post the output so we can see the differences for 
> > ourselves. What we need is mkfs output in both cases, and xfs_info
> >  output in both cases after mount.
> 
> Suggestion (for the OP):
> 
> To reformat a third time without "-f", you can reformat as ext4, then
> format a second time as xfs.

That doesn't work - mkfs.xfs detects that the device has an ext4
filesystem on it, and demands you use -f to overwrite it.

> But to imitate a new disk, you have to
> zero it with dd.

Only the first MB or so - enough for blkid not to be able to see a
filesystem signature on it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
