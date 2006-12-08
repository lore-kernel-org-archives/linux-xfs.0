Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Dec 2006 08:51:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB8GpYqw001282
	for <xfs@oss.sgi.com>; Fri, 8 Dec 2006 08:51:36 -0800
Message-ID: <457997E6.60900@sandeen.net>
Date: Fri, 08 Dec 2006 10:50:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Unable to mount XFS partition on Sun Ultra/Linux 2.6.17 - Function
 not implemented
References: <BAY116-W64E893DB16B1A8692B9FDC9D30@phx.gbl>
In-Reply-To: <BAY116-W64E893DB16B1A8692B9FDC9D30@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dennis Varouxis <dennisvarouxis@hotmail.com>
Cc: xfs@oss.sgi.com

Dennis Varouxis wrote:

> The output from xfs_db which admittedly doesn't mean much, to me at least,  is:
> 
> azrael ~ # xfs_db -c sb -c p /dev/sda1
...

> logblocks = 1000
> versionnum = 0x1094

Looks like version one directories, recently ripped out of Linux...

Try an older kernel... can't recall exactly when this changed, but you 
can probably find it in the archives, search "dirv1" I think.

> Also interesting is the output from xfs_check:
> 
> "ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check."

Linux can't replay irix logs, you could zero out the log with xfs_repair 
-L, or, less destructively, mount with -o ro,norecovery and see what you 
can get.

-Eric
