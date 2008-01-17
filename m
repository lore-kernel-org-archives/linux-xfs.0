Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 14:19:55 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0HMJlQs020061
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 14:19:48 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6AD85306CA
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 14:20:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id v9BVXo89fWwVol9k for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 14:20:02 -0800 (PST)
Message-ID: <478FD48F.1060707@sandeen.net>
Date: Thu, 17 Jan 2008 16:19:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
References: <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local> <478FA832.7030200@sandeen.net> <9CE70E6ED2C2F64FB5537A2973FA4F02535954@pvn-3001.purevideo.local>
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F02535954@pvn-3001.purevideo.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Mark Magpayo wrote:

> Here's the entire output:
> 
> major minor  #blocks  name
> 
>    3     0     512000 hda
>    3     1     511528 hda1
>  152     0 9523468862 etherd/e1.0
>  152    16 9523468862 etherd/e0.0
>  254     0 19046932480 dm-0
> 
> 
> I believe dm-0 is the lvm device.


Yep, in 1k units, so:

19046932480*1024
19504058859520

and:

superblock read failed, offset 19504058859520, size 2048, ag 64, rval 0

so it's trying to read a 2k (?) superblock right in the last 1k of the
device?  Hrm.  (Dave, Barry - isn't that 2048 the sector size, not block
size?)

Also from your sb 0 printout:

blocksize = 4096
dblocks = 11904332800

is 48760147148800, exactly 2.5x bigger than your device is. Weird.

-Eric
