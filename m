Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 15:49:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lBANnmEo025882
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 15:49:52 -0800
Message-ID: <475D7C74.6080004@sandeen.net>
Date: Mon, 10 Dec 2007 11:50:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 972756 - Implement fallocate.
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
In-Reply-To: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:
> Implement fallocate.
> 
> Implement the new generic callout for file preallocation.
> Atomically change the file size if requested.
> 
> 
> Date:  Fri Nov  2 13:42:52 AEDT 2007
> Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
> Inspected by:  hch@infradead.org
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
> 
> 
> Modid:  xfs-linux-melb:xfs-kern:30009a
> fs/xfs/linux-2.6/xfs_iops.c - 1.268 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.268&r2=text&tr2=1.267&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.268&r2=text&tr2=1.267&f=h
> 	- implement ->fallocate()
> 
> 
> 

Is this ever going to go upstream...?

-eric
