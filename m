Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4MM8JTG087321 for <xfs@oss.sgi.com>; Sat, 22 May 2010 17:08:19 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE0E8142DADD
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 15:10:39 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id PGChH3SiQC5dxYRT
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 15:10:39 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9A8946C2B1
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 17:10:38 -0500 (CDT)
Message-ID: <4BF8571A.8020605@hardwarefreak.com>
Date: Sat, 22 May 2010 17:13:46 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Tuning XFS for real time audio on a laptop with encrypted LVM
References: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>	<20100521041415.GW8120@dastard>
	<4BF62766.8070105@hardwarefreak.com>	<AANLkTinobXUKRN0s_3Ia-5XBix05Tvhp36K5fUsysjh-@mail.gmail.com>	<4BF68E74.8040305@hardwarefreak.com>
	<AANLkTimf1CjF3c2QL22lfElVZWMETi987YjMEiT76MMb@mail.gmail.com>
In-Reply-To: <AANLkTimf1CjF3c2QL22lfElVZWMETi987YjMEiT76MMb@mail.gmail.com>
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

Pedro Ribeiro put forth on 5/22/2010 7:21 AM:

> Hi,
> results are attached. There appears to be no difference between any of
> the schedulers.

That's a bit more... thorough than what we need, and makes digesting it and
making comparisons difficult.  Can you make just 4 runs, one with each
elevator, on /dev/sda with 64 threads and post results?  I saw some
outrageously high numbers in your data due to caching of that tiny 337MB
/dev/sda partition.

Also, can you show confirmation of the elevator change between each run?

Thanks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
