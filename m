Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 19:01:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P21LcJ017487
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 19:01:21 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1093A3C893F
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 19:02:43 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id vM4uyYfHy0rhGJzj for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 19:02:43 -0700 (PDT)
Date: Mon, 25 Aug 2008 12:02:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agi unlinked bucket
Message-ID: <20080825020239.GQ5706@disturbed>
References: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de> <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de> <20080825003929.GN5706@disturbed> <alpine.DEB.1.10.0808250254380.26780@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808250254380.26780@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 25, 2008 at 03:05:24AM +0200, Christian Kujau wrote:
> On Mon, 25 Aug 2008, Dave Chinner wrote:
>> If you do a mount then unmount then rerun xfs-check, does it go
>> away?
>
> Did that a few times already, and the fs is getting mounted during boot  
> anyway, but xfs_check still complains:

Ok, so if you do a 'ls -i /' do you see an inode numbered 20208090?
i.e. is it the unlinked bucket that is incorrect, or the root
directory.

> --------------------------------------
> # xfs_check /dev/mapper/md3 2>&1 | tee fsck_md3.log
> agi unlinked bucket 26 is 20208090 in ag 0 (inode=20208090)
> link count mismatch for inode 128 (name ?), nlink 335, counted 336
> link count mismatch for inode 20208090 (name ?), nlink 0, counted 1
> # mount /mnt/md3
> # dmesg | tail -2
>  XFS mounting filesystem dm-3
>  Ending clean XFS mount for filesystem: dm-3
> # grep xfs /proc/mounts
> /dev/mapper/md3 /mnt/md3 xfs ro,nosuid,nodev,noexec,nobarrier,noquota 0 0

You are not using barriers. Are you using write caching? The
problems with filesystem corruption on powerloss when using volatile
write caching have traditionally shown up in directory
corruptions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
