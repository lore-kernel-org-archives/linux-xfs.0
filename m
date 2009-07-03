Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n63EbQoM172078 for <xfs@oss.sgi.com>; Fri, 3 Jul 2009 09:37:27 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CCC91AECFBD
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2009 07:37:58 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id D3pkZ5lR0qCfm26T for
	<xfs@oss.sgi.com>; Fri, 03 Jul 2009 07:37:58 -0700 (PDT)
Message-ID: <4A4E17C5.8020105@sandeen.net>
Date: Fri, 03 Jul 2009 09:37:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Clustered version of XFS
References: <7778c60e0907030557j357f88e5g4ab3ce0d3377bb41@mail.gmail.com>
In-Reply-To: <7778c60e0907030557j357f88e5g4ab3ce0d3377bb41@mail.gmail.com>
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
To: tharindu@sentstory.com
Cc: xfs@oss.sgi.com

Tharindu Rukshan Bamunuarachchi wrote:
> we are using XFS high speed transaction processing system.
> 
> we are very happy with XFS performance compared to ZFS, EXT3, JFS etc.
> 
> i have two questions regarding XFS ...
> 
> 1. Is there any cluster version of XFS. (e.g. like GFS, Luste, GPFS)

SGI sells a product called CXFS (http://lmgtfy.com/?q=clustered+xfs) ;)

> 2. I am currently using my root partition as XFS. but i need to modify
> XFS source code and reload module without rebooting machine.
>     Is there anyway to play with XFS source/module while using XFS
> module for mounted file system ....?

In general no, but you might look into KSplice.

-Eric

> 
> cheers
> __
> tharindu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
