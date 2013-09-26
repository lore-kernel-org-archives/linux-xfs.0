Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC4637F5A
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 03:44:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7323304059
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 01:44:07 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id fSBR8qfgGhHDexaX
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 01:44:07 -0700 (PDT)
Message-ID: <5243F3DE.3050900@hardwarefreak.com>
Date: Thu, 26 Sep 2013 03:44:14 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs hardware RAID alignment over linear lvm
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
	<20130925215713.GH26872@dastard>
In-Reply-To: <20130925215713.GH26872@dastard>
Reply-To: stan@hardwarefreak.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/25/2013 4:57 PM, Dave Chinner wrote:
...
> Linear concatentation looks like this:
> 
> offset		volume				array
> 0		+-D1-+-D2-+.....+-Dn-+		0	# first sw
> .....
> X-sw		+-D1-+-D2-+.....+-Dn-+		0
> X		+-E1-+-E2-+.....+-En-+		1	# first sw
> .....
> 2X-sw		+-E1-+-E2-+.....+-En-+		1
> 2X		+-F1-+-F2-+.....+-Fn-+		2	# first sw
> .....
> 3X-sw		+-F1-+-F2-+.....+-Fn-+		2
> 
> Where:
> 	D1...Dn are the disks in the first array
> 	E1...En are the disks in the second array
> 	F1...Fn are the disks in the third array
> 	X is the size of the each array
> 	sw = su * number of data disks in array
> 
> As you can see, all the volumes are arranged in a single column -
> identical to a larger single array of the same size.  Hence the
> exposed alignment of a single array is what the filesystem should be
> aligned to, as that is how the linear concat behaves.
> 
> You also might note here that if you want the second and subsequent
> arrays to be correctly aligned to the initial array in the linear
> concat (and you do want that), the arrays must be sized to be an
> exact multiple of the stripe width.

On a similar note, if I do a concat like this I specify agsize/agcount
during mkfs.xfs so no AGs straddle array boundaries.  I do this to keep
per AG throughput consistent, among other concerns.  This may or may not
be of benefit to the OP.  mkfs.xfs using defaults is not aware of the
array boundaries within the concat, so it may well create AGs across
array boundaries.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
