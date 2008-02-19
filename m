Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 17:20:53 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1J1KnDw017368
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 17:20:50 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39AE15EE1A4
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 17:21:14 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id SWs0D8DkEsFh7RuR for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 17:21:14 -0800 (PST)
Date: Tue, 19 Feb 2008 02:20:42 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080219002059.GX155407@sgi.com>
Message-ID: <Pine.LNX.4.63.0802190209490.20408@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
 <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk>
 <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk> <20080219002059.GX155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 19 Feb 2008, David Chinner wrote:

> 
> The output I showed you was from an ia64 machine, so it's not
> purely 64bit related.
> 
> Can you rebuild you x86_64 kernel from the same kernel
> tree you built the ia32 (make mrproper; make ....) and reinstall
> it and see if the still exists?

Done, but the problem still exists.
# xfs_check /dev/loop0
sb_fdblocks 253756, counted 254780

Dave, when you tested on ia64, did you use mkfs.xfs which wrote feature2
record on right place or did you use your patch to correct feature2 on
mount? Because I use mkfs.xfs patched with Eric Sandeen patch on x86_64 to
create FS which really has lazy-count=1.

Cheers,
 
jan

-- 
