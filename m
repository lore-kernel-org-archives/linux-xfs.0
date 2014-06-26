Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 799707F92
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 18:32:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 527048F8037
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 16:32:24 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7T3lX80Zmt33IPx1
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 16:32:22 -0700 (PDT)
Message-ID: <53ACAD89.8080701@hardwarefreak.com>
Date: Thu, 26 Jun 2014 18:32:25 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Repair hangs at inode repair in phase3
References: <trinity-20fa04a2-b771-42eb-afb3-a915026306bd-1403810247665@3capp-gmx-bs14>
In-Reply-To: <trinity-20fa04a2-b771-42eb-afb3-a915026306bd-1403810247665@3capp-gmx-bs14>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dragon <Sunghost@gmx.de>, xfs@oss.sgi.com

On 6/26/2014 2:17 PM, Dragon wrote:
> Hello,
> i upgraded to debian jessie with xfsprogs 3.2. if i run xfs_repair /dev/md2 the system hangs too. If i use -P it ends up with:
> corrupt block 0 in directory inode 2147702899: junking block
> Segmentation fault
> 
> if i use -n -P it ends up with:
> 
> No modify flag set, skipping phase 5
> Inode allocation btrees are too corrupted, skipping phases 6 and 7
> No modify flag set, skipping filesystem flush and exiting.

Did you lose the md/RAID6 array and reassemble it prior to seeing the
problems with the XFS filesystem?  You may have reassembled it in the
wrong order, in which case the sector offsets will be wrong, and XFS
will not see data where it should be.  This is reported as corruption.
You never posted your dmesg output so you may or may not be experiencing
hardware problems.  That needs to be eliminated as a possible cause.
Please post relevant lines from dmesg.

> Files are still not accessible - i think i lost some TB ;( - not a good experience for first use of xfs...

An XFS filesystem doesn't simply become corrupt like this during normal
operation.  Something happened that corrupted the on disk structures.
XFS is the messenger here, not the cause.

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
