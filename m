Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28B117F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:43:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 057768F8037
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:43:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ok9JwfQmNUcfQMcG for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 16:43:13 -0700 (PDT)
Date: Wed, 26 Aug 2015 09:43:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
Message-ID: <20150825234300.GN714@dastard>
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
	<55DCE1CF.5030708@sandeen.net>
	<CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Aug 25, 2015 at 04:09:33PM -0700, Shrinand Javadekar wrote:
> I did this on 2 different setups.

Details?

> Formatted the new disks with mkfs.xfs. Ran the workload.
> Reformatted the disks with mkfs.xfs -f. Ran the workload.
> 
> >
> >> Any ideas why this might be happening?
> >
> > With the paucity of information you've provided, nope!
> 
> Apologies. What more information can I provide?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> > What version of xfsprogs are you using?
> 
> # xfs_repair -V
> xfs_repair version 3.1.9

That's pretty old.

> > What was the output of mkfs.xfs each time; did the geometry differ?
> 
> I have the output of xfs_info /mount/point from the first experiment
> and that of mkfs.xfs -f. One difference I see is that reformatting
> adds projid32bit=0 for the inode section.

xfs_info didn't get projid32bit status output until 3.2.0.

Anyway, please post the output so we can see the differences for
ourselves. What we need is mkfs output in both cases, and xfs_info
output in both cases after mount.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
