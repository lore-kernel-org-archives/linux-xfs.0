Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB2L85qM013971 for <xfs@oss.sgi.com>; Sun, 2 Dec 2012 15:08:06 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lWd6JpF3XeeBg3Pz for <xfs@oss.sgi.com>;
	Sun, 02 Dec 2012 13:10:25 -0800 (PST)
Date: Mon, 3 Dec 2012 08:10:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump INTERRUPT issue
Message-ID: <20121202211023.GF12955@dastard>
References: <CCDF949D.B03CC%jellis@dhnet.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CCDF949D.B03CC%jellis@dhnet.us>
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
To: "J. Ellis" <jellis@dhnet.us>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Dec 01, 2012 at 11:03:57AM -0500, J. Ellis wrote:
> I'm trying to prepare a question regarding an xfsdump INTERRUPT error I'm
> getting, and I'm trying to follow the guidelines for reporting such issues
> here:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_r
> eporting_a_problem.3F
> 
> But these last two instructions I'm having a problem finding the information
> on how to generate:
> 
> 
> xfs_info output on the filesystem in question (I tried xfs_info /dev/sdc,
> but it keeps saying for each drive that it's not a mounted xfs system IIRC)

$ man xfs_info
....
	xfs_info [ -t mtab ] mount-point
....

> dmesg output showing all error messages and stack traces

Run the dmesg command....

> Then you need to describe your workload that is causing the problem, and a
> demonstration of the bad behavior that is occurring. If it is a performance
> problem, then 30s - 1 minute samples of:
>     1.    iostat -x -d -m 5
>     2.    vmstat 5
> 
> 
> Do I run this simultaneously while xfstools are working? I'm also not sure
> what's meant by describe your workload. Can someone step me through this?

Do you have a performance problem? I don't think you have - your problem is
that xfsdump is failing for some reason - so this information is
unnecessary.

As to your workload, your problem is xfsdump is failing for some
reason. Hence we need to know roughly what xfsdump is running on.
i.e. describe the directory structure/filesystem contents being
backed up....

BTW, don't expect responses to questions in a hour late on friday
night/weekends - if you are lucky someone will be in front of their
computer over a weekend, sometimes you are not so lucky...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
