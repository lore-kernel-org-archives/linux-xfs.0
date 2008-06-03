Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 06:04:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53D4n2h021751
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 06:04:49 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85E571DDDAA
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 06:05:42 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id BffiYCscHIWAQevg for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 06:05:42 -0700 (PDT)
Date: Tue, 3 Jun 2008 15:05:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix mount option parsing in remount
Message-ID: <20080603130534.GA8694@lst.de>
References: <20080518153539.GA5218@lst.de> <48453E5D.8050301@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48453E5D.8050301@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jun 03, 2008 at 07:51:41AM -0500, Eric Sandeen wrote:
> Maybe expand this a little:
> 
> /*
>  * Today only the barrier/nobarrier xfs mount options are handled
>  * on remount.  This table should be expanded to cover all options,
>  * and used for the initial mount path, too.
>  */
> 
> ... I'd also like this for the mount path because for example:
> 
> mount -t xfs -o barrier=0 /dev/blah /mnt/foo
> 
> works... but does not turn off barriers.
> 
> So as a first step/example this looks ok but I'd sure like to see it
> extended soon.  Maybe when I'm bored... :)

Doh.  But yeah, mount path should be switched over soon.  I alredy
posted the patches to kill the xfs_mount_args gunk which have been on
the list for a while and happily ignored, and switching to the parser.h
helper ontop of that is quite easy.  I just want to wait a little bit
so that any problems with the previous patch are shaked out before the
new one gets added.
