Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0EJnJpg078832 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 13:49:20 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE05B15408D5
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 11:51:34 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id raCfIA5nCUy8uzta
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 11:51:34 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 749466C130
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 13:51:33 -0600 (CST)
Message-ID: <4D30A945.4060000@hardwarefreak.com>
Date: Fri, 14 Jan 2011 13:51:33 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<20110113233527.6dca104d@galadriel.home>
	<18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>
In-Reply-To: <18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Cory Coager put forth on 1/13/2011 6:17 PM:

>   --- Physical volume ---
>   PV Name               /dev/cciss/c1d1p1
>   VG Name               vg0
>   PV Size               2.94 TB / not usable 1.51 MB
>   Allocatable           yes
>   PE Size (KByte)       4096
>   Total PE              769902
>   Free PE               562351
>   Allocated PE          207551
>   PV UUID               IAZAbk-eMNZ-puMJ-DqW1-zsC7-C0ux-66vYTN

Make sure the write cache on the P600 (what size is it BTW?) is enabled and that
the BBU is in working order.  Also make sure the P600 is disabling the write
caches on the drives themselves.  Then...

Mount with 'nobarrier' so XFS isn't interfering with the hardware cache
performance of the P600.  With barriers enabled (the default) XFS will
periodically flush the cache on the RAID card causing write performance problems.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
