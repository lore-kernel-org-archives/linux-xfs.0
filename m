Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 00:54:18 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0N8rmVw032626
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 00:53:50 -0800
Received: from stlx01.stz-softwaretechnik.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6641654D59B
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 00:54:05 -0800 (PST)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211]) by cuda.sgi.com with ESMTP id DKCwjrRJjdduZeeF for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 00:54:05 -0800 (PST)
Date: Wed, 23 Jan 2008 09:53:39 +0100
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: xfs_rapair memory requirement per TB
Message-ID: <20080123085339.GB12435@p15145560.pureserver.info>
References: <1201042882.32649.256.camel@holwrs01.bp.com> <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com

Barry Naujok schrieb:
> >
> >Reading the "Repairing a possibly incomplete xfs_growfs command?" thread
> >this month makes me wonder if there is some type of rough formula or
> >guesstimation cheat sheet to figure out how much memory and swap one
> >would need for an xfs_repair given a file system with many terabytes.
> >
> >
> >Say I have an 8TB LUN that needs an xfs_repair.  What would be the rough
> >memory requirements and swap space?
> >
> 
> General rule of thumb at the moment is 128MB of RAM/TB of filesystem
> plus 4MB/million inodes on that filesystem.

Did this change lately? I found the rule of thumb: 2 GB RAM for 1 TB
of disk storage + some RAM per x inodes.

http://oss.sgi.com/archives/xfs/2005-08/msg00045.html

I'm interested in this too, because we'll get additional 15 TB disk
space soon. Until now I created filesystems of max 7-8 TB on a server
with 16 GB RAM. The 15 TB (mostly 2-5 GB large files) will be used on
a server with only 6 GB RAM (debian etch, xfsprogs 2.8.11-1). We plan
to expand the RAM to 12 GB. What size would be safe for a xfs
filesystem on a server with 12 GB RAM (given mostly large files)?

Ralf
