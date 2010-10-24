Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9O0GcRc076777 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 19:16:39 -0500
Received: from omr3.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EB704EC355
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 17:17:54 -0700 (PDT)
Received: from omr3.networksolutionsemail.com (omr3.networksolutionsemail.com
	[205.178.146.53]) by cuda.sgi.com with ESMTP id
	JVfMzYooDga8TXMJ for <xfs@oss.sgi.com>;
	Sat, 23 Oct 2010 17:17:54 -0700 (PDT)
Received: from cm-omr9 (mail.networksolutionsemail.com [205.178.146.50])
	by omr3.networksolutionsemail.com (8.13.6/8.13.6) with ESMTP id
	o9O0HsQ8021474 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 20:17:54 -0400
Message-ID: <4CC37B2D.3050005@chaven.com>
Date: Sat, 23 Oct 2010 19:17:49 -0500
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: Best filesystems ?
References: <4CBE2403.8070108@hardwarefreak.com>	<20101019234217.GD12506@dastard>	<19646.55189.843933.481529@tree.ty.sabi.co.uk>	<20101021020009.GG12506@dastard>	<19648.27859.799400.168394@tree.ty.sabi.co.uk>	<Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
	<19651.9652.631329.903552@tree.ty.sabi.co.uk>
In-Reply-To: <19651.9652.631329.903552@tree.ty.sabi.co.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 2010-10-23 13:13, Peter Grandi wrote:
>
> * JFS is good for almost everything, including largish filesystems
>    on somewhat largish systems with lots of processes accessing
>    lots of files, and works equally well on 32b and 64b, is very
>    stable, and has a couple of nice features. Its major downside is
>    less care than XFS for barriers. I think that it can support
>    well filesystems up to 10-15TB, and perhaps beyond. It should
>    have been made the default for Linux for at least a decade
>    instead of 'ext3'.

Would comment here that JFS is indeed very good, but does have a problem 
when reaching/hitting the 32TB boundary.   This appears to be a user 
space tool issue.   It is the main reason why I switched over to XFS as 
was running into this problem too often.

> * XFS is like JFS, and with somewhat higher scalability both as to
>    sizes and as to higher internal parallelism in the of multiple
>    processes accessing the same file, and has a couple of nice
>    features (mostly barrier support, but also small blocks and large
>    inodes). Its major limitation are internal complexity and should
>    only be used on 64b systems. It can support single filesystems
>    larger than 10-15TB, but that's stretching things.

Have used XFS up to 120TB myself on real media (i.e. not sparse files) 
under linux; will be building >128 shortly.    Have used more w/ XFS 
Irix in the past.


Generally I find with most file  systems/tools there are many bugs when 
you cross bit boundaries where they were not tested.    Whenever 
using/planning large systems /always/ test first and  have good backups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
