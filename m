Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 15:32:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m96MWIrU029200
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 15:32:19 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BDDA13A26A9
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2008 15:33:56 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id sajCAbB5ese1Jg6G for <xfs@oss.sgi.com>; Mon, 06 Oct 2008 15:33:56 -0700 (PDT)
Date: Tue, 7 Oct 2008 09:31:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: "slow at directory traversal .. after 3 years of use"
Message-ID: <20081006223141.GS30001@disturbed>
References: <1c08324d0810061325kdd1453alb9eab9ceb769b1cf@mail.gmail.com> <alpine.DEB.1.10.0810061627260.15837@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810061627260.15837@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, Lennart Hansen <lahansen@gmail.com>

On Mon, Oct 06, 2008 at 04:30:22PM -0400, Justin Piszcz wrote:
> Someone pointed me to the following paper:
>
> http://www.stdlib.net/~colmmacc/Apachecon-EU2005/scaling-apache-handout.pdf
>
> Which states:
>
> After nearly 3 years of use, some problems with XFS became
> noticeable. As the number of used inodes in the filesystem grows
> XFS becomes very slow at directory traversal. Although this did
> not impede web-serving it did have a heavy impact on how quickly
> we could synchronise content with the primary sources.

There's no detail of what the problem was, just that it slowed down.
Could have been many things, and one of the possibilities was the
in-core XFS inode hash scalability problems (that you could work
around with an ihashsize=XXX mount option)....

> Dave / Eric, comments here?  Does ext3 suffer from the same
> problem?

An ext3 filesystem being faster than a 3 year old production XFS
filesystem - no surprise there as the XFS directories were probably
fragmented.  After three years of continual use, I'd be extremely
surprised if the ext3 H-tree directory structures perform anywhere
near as well as XFS as the fragmentation characteristics of ext3
directories are far worse than XFS and ext3 does not have directory
readahead like XFS does.

An example - kernel.org moved from ext3 to XFS primarily because
the directory performance of XFS is better than ext3 on these
sorts of workloads....

> Have these issues been fixed since 2005?  Would inode64 alleviate
> some of these problems?

Well, the incore inode hashes have no problems now they have been
converted to radix trees. Witout any further detail of what the
problem was, I can't really say anything else....

Barry - sounds like you need to make xfs_fsr defrag directories. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
