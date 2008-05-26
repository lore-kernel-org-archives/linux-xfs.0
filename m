Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 20:39:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4Q3dE3U006426
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 20:39:14 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7773712B890E
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 20:40:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id H3kMVMuA5I32VJlk for <xfs@oss.sgi.com>; Sun, 25 May 2008 20:40:05 -0700 (PDT)
Message-ID: <483A3112.4090502@sandeen.net>
Date: Sun, 25 May 2008 22:40:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Lost Superblock and need help recovering
References: <483A231F.2030207@dynamicquest.com>
In-Reply-To: <483A231F.2030207@dynamicquest.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Javier Gomez <gomez@dynamicquest.com>
Cc: xfs@oss.sgi.com

Javier Gomez wrote:

>  > xfs_repair -nv /dev/etherd/e4.1p1
> ---------------------------------------------------------------
> Phase 1 - find and verify superblock...
> error reading superblock 4 -- seek to offset 1219003957248 failed
> couldn't verify primary superblock - bad magic number !!!

Looks to me like you still have storage problems.

1219003957248 is just over 1 terabyte... why can't repair seek to that
location if it's a 13T device?

What does /proc/partitions say about this block device (or do AoE
devices go there?)

-Eric

> attempting to find secondary superblock...
> ................................................................................................
> ......................................................
> ..................
> ..................
> ............Sorry, could not find valid secondary superblock
> Exiting now.
> ---------------------------------------------------------------
> 
> 
