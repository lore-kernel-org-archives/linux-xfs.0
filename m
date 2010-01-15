Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FL7Wgr130361 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 15:07:47 -0600
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7E2816AB47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 13:08:09 -0800 (PST)
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1]) by
	cuda.sgi.com with ESMTP id vftjyEQBkw3omtY0 for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 13:08:09 -0800 (PST)
Message-ID: <4B50D9F9.1010809@fnac.net>
Date: Fri, 15 Jan 2010 22:11:21 +0100
From: Paul Chavent <paul.chavent@fnac.net>
MIME-Version: 1.0
Subject: Re: usage of xfsctrl for embedded development / uuid question
References: <5340782.170001263558076439.JavaMail.www@wsfrf1111>
	<20100115124617.GJ28498@discord.disaster>
In-Reply-To: <20100115124617.GJ28498@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> It's a wrapper around ioctl(). You can call ioctl() directly
> on not need xfsctl at all...

Right, but i found nowhere the structures and the definition of XFS_IOC_* in the headers "exported" by the kernel.

So i have two solutions :
(1) i add -I/path_to_the_kernel_sources/fs to the cflags of my project.
(2) i install those headers in my sysroot.

I thought that those solutions where worst that only install headers from the xfsprogs package.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
