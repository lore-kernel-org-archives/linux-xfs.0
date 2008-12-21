Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLH25MV026301 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 11:02:05 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC9CC3B430
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 09:02:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id plluWunyhHrZx1oP for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2008 09:02:03 -0800 (PST)
Message-ID: <494E766B.5080102@sandeen.net>
Date: Sun, 21 Dec 2008 11:01:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair problem.
References: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>	
	<494E66D9.5030704@sandeen.net>
	<7bcfcfff0812210852v6c1cd522i334de914e1e9a112@mail.gmail.com>
In-Reply-To: <7bcfcfff0812210852v6c1cd522i334de914e1e9a112@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: David Bernick <dbernick@gmail.com>
Cc: xfs@oss.sgi.com

David Bernick wrote:
> Thanks for the help so far:
>  
> It my output was from "sb 0". Thanks for reminding me to be explicit.
>  
> The system is a 64-bit system with 32-GB of RAM. It's going through the
> FS right now with XFS repair.
> Output of xfs_repair says, "arno=3" and about 81.6% of RAM is used by
> the process. Think 32 G will be enough to handle this task?
> I actually don't KNOW the original error, unfortunately, when growing. I
> came into this late.
>  
> We're using repair 2.9.4. Worth getting a more recent version?

2.9.8 had some memory usage improvements (reductions) for repair IIRC

> Kernel is - 2.6.18-92.1.1.el5

heh; RHEL5 does not support xfs ;)

You probably hit:

TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
http://oss.sgi.com/archives/xfs/2007-01/msg00053.html

I'd see if you can get centos to backport that fix (I assume you're
using centos or at least their kernel module; if not you can backport it
yourself...)

> I "backed off" by vgsplit-ing the new physical device from the original
> vgroup, so I was left with my original partition. I am hoping to mount
> the original device since the "expanded" fs didn't work. I am hoping
> xfs_repair helps that.

well, you don't want to take out part of the device if the fs thinks it
owns it now, but from the db output I think you still have the smaller size.

I'd read through:

http://oss.sgi.com/archives/xfs/2008-01/msg00085.html

and see if it helps you recover.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
