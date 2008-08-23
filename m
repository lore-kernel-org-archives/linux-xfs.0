Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Aug 2008 05:12:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7NCCjW5015007
	for <xfs@oss.sgi.com>; Sat, 23 Aug 2008 05:12:46 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A2F83C54BC
	for <xfs@oss.sgi.com>; Sat, 23 Aug 2008 05:14:07 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.188]) by cuda.sgi.com with ESMTP id HadlLCPMpmJhyu9l for <xfs@oss.sgi.com>; Sat, 23 Aug 2008 05:14:07 -0700 (PDT)
Date: Sat, 23 Aug 2008 14:14:06 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: agi unlinked bucket
In-Reply-To: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de>
References: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Sat, 23 Aug 2008, Christian Kujau wrote:
> # xfs_repair -V
> xfs_repair version 2.9.8

The same errors occur when running with xfs_check from the latest CVS 
checkout :-\

> # blockdev --getsize64 /dev/mapper/md3
> 147445706752
> # xfs_check /dev/mapper/md3
> agi unlinked bucket 26 is 20208090 in ag 0 (inode=20208090)
> link count mismatch for inode 128 (name ?), nlink 333, counted 334
> link count mismatch for inode 20208090 (name ?), nlink 0, counted 1
> Command exited with non-zero status 3

Anybody?

Thanks,
Christian.
-- 
BOFH excuse #301:

appears to be a Slow/Narrow SCSI-0 Interface problem
