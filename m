Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 17:38:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P0cDgS013286
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 17:38:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 543291A3F06E
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 17:39:35 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id W3Xjz6Yhd4Lf3rFl for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 17:39:35 -0700 (PDT)
Date: Mon, 25 Aug 2008 10:39:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agi unlinked bucket
Message-ID: <20080825003929.GN5706@disturbed>
References: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de> <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 23, 2008 at 02:14:06PM +0200, Christian Kujau wrote:
> On Sat, 23 Aug 2008, Christian Kujau wrote:
>> # xfs_repair -V
>> xfs_repair version 2.9.8
>
> The same errors occur when running with xfs_check from the latest CVS  
> checkout :-\
>
>> # blockdev --getsize64 /dev/mapper/md3
>> 147445706752
>> # xfs_check /dev/mapper/md3
>> agi unlinked bucket 26 is 20208090 in ag 0 (inode=20208090)
>> link count mismatch for inode 128 (name ?), nlink 333, counted 334
>> link count mismatch for inode 20208090 (name ?), nlink 0, counted 1
>> Command exited with non-zero status 3
>
> Anybody?

If you do a mount then unmount then rerun xfs-check, does it go
away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
