Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 00:20:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5F7KiWt028384
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 00:20:46 -0700
Message-ID: <46723DC4.1080107@sgi.com>
Date: Fri, 15 Jun 2007 17:20:36 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr allocation group optimization
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se> <20070612014452.GK86004887@sgi.com>
In-Reply-To: <20070612014452.GK86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Johan Andersson <johan@e-626.net>, xfs@oss.sgi.com, Nathan Scott <nscott@aconex.com>

David Chinner wrote:
> On Mon, Jun 11, 2007 at 08:51:32AM +0200, Johan Andersson wrote:
>> Does anyone know of a good way to find one filename that points o a
>> certain inode?
> 
> We need an rmap....
> 
> We have some prototype linux code that does parent pointers (i.e.
> each inode has a back pointer to it's parent inode), but that, IIUC,
> is a long way from prime-time. Tim?
> 
> Cheers,
> 
> Dave.

I don't know about a "long way" (longer to fully supported, yes)
Firstly, I need to move its hooks out of linux-2.6/xfs_iops.c which were 
referring to xfs inodes (instead of vnodes) probably back where they were in
xfs_vnodeops.c.

Nathan, did you have some other suggestion than this - unfortunately,
I haven't looked at this code (until recently) for a while.

Cheers,
Tim.
