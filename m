Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Feb 2008 07:59:04 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m12FwtFE022265
	for <xfs@oss.sgi.com>; Sat, 2 Feb 2008 07:59:01 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 915CE592AFB
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2008 07:54:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id U03eo3LQigmy7XQG for <xfs@oss.sgi.com>; Sat, 02 Feb 2008 07:54:17 -0800 (PST)
Message-ID: <47A49206.4020700@sandeen.net>
Date: Sat, 02 Feb 2008 09:53:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS: failed to read RT inodes
References: <8f1895b90802020212h278968efy7a644c55c480134e@mail.gmail.com>
In-Reply-To: <8f1895b90802020212h278968efy7a644c55c480134e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Per Lundberg <perlun@gmail.com>
Cc: xfs@oss.sgi.com

Per Lundberg wrote:
> Hello,
> 
> After a hard drive failure (and no backup...) I am trying with all my
> strength do recover the file systems... With no real success. I have
> dumped over the two file systems in question to another, healthy disk
> drive. After dumping back the data to a third hard disk, one of the
> file system can be successfully mounted but with a huge number of
> files in the lost+found directory (after recovery using xfs_repair).
> Strange since the dump indicated only 11 bad sectors on that file
> system.
> 
> However, the big (55 gig) file system cannot even be mounted and this
> is troublesome since it contains the most valuable data. This is what
> I get after doing xfs_repair on the volume:
> 
> Jan 10 10:30:59 amos kernel: SGI XFS with ACLs, security attributes,
> realtime, large block numbers, no debug enabled
> Jan 10 10:30:59 amos kernel: SGI XFS Quota Management subsystem
> Jan 10 10:31:00 amos kernel: XFS mounting filesystem sda10
> Jan 10 10:31:00 amos kernel: XFS: failed to read RT inodes

maybe try xfs_db on the device; "sb 0" and "p" commands to see what the
rt inodes are.

-Eric
