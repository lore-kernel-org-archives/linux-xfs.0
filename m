Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VMOI6X109570 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 16:24:18 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9iciGfJ7sOYH17nb for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 14:24:16 -0800 (PST)
Date: Wed, 1 Feb 2012 09:24:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Identify patches for superblock changes for Crossmeta
Message-ID: <20120131222413.GO9090@dastard>
References: <CAM=3LEd2yu6rgSCg=6-Mop7wgKK5FnVKx6E=H2NapzJQ9ahSeg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAM=3LEd2yu6rgSCg=6-Mop7wgKK5FnVKx6E=H2NapzJQ9ahSeg@mail.gmail.com>
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
To: sam supramani <suprasam@crossmeta.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 09:13:36AM -0800, sam supramani wrote:
> Hi,
> 
> I am trying to get Crossmeta that includes windows port of XFS file
> system,
> to recognize newer ondisk format changes seen with the newer
> linux kernels.(RHEL6)
> The crossmeta-xfs port in https://github.com/crossmeta/sgi is quite
> old based on XFS 1.1 release with log v2 patches added later.
>
> I am interested in knowing submittal ID for the following changes;
> attr=2 lazy-count=1.

You've got a 10+ year old code base. That's a significant problem -
nobody is going to search 10 years worth of history for you. It's
all in various git trees around the place, so you should probably
learn to use git blame....

BTW, filesystems that have been mounted on windows are completely
unsupportable by the Linux community, so using crossmeta to access
your Linux XFS filesystem is not an advisable thing to do in the
first place...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
