Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0J9uoNp198879 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 03:56:50 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A84B71621E2C
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 01:59:07 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id nEn1XbIOtHHLAl9A
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 01:59:07 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 08A286C106
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 03:59:07 -0600 (CST)
Message-ID: <4D36B5EA.6040603@hardwarefreak.com>
Date: Wed, 19 Jan 2011 03:59:06 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<20110113233527.6dca104d@galadriel.home>	<18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>	<4D30A945.4060000@hardwarefreak.com>	<27616_1295038110_4D30B69E_27616_233_1_4D30B69E.4020506@davisvision.com>	<4D30C7F3.3040105@hardwarefreak.com>
	<1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
In-Reply-To: <1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
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

Cory Coager put forth on 1/18/2011 8:16 AM:

> No, it has never worked properly.  Also, I want to stress that I am only having
> performance issues with one logical volume, the others seem fine.

Then, logically, there is something different about this logical volume than the
others.  All of them reside atop the same volume group, atop the same two
physical RAID6 arrays, correct?  Since I'm not quite tired of playing dentist (yet):

1. Were all of the LVs created with the same parameters?  If so, can you
demonstrate verification of this to us?

2. Are all of them formatted with XFS?  Were all formatted with the same XFS
parameters?  If so, can you demonstrate verification of this to us?

3. Are you encrypting, at some level, the one LV that is showing low performance?

Cory:  "The two arrays were added to a volume group and multiple logical volumes
were created."

4. Was this volume group preexisting?  Are there other storage devices in this
volume group, or _only_ the RAID6 arrays?

5. Have you attempted deleting and recreating the LV with the performance issue?

6. How many total logical volumes are in this volume group?

7. What Linux distribution are you using?  What kernel version?


We are not magicians here Cory.  We need as much data from you as possible or we
can't help you.  I thought I made this clear earlier.  You need to gather as
much relevant data from that box as you can and present it here if you're
serious about solving this issue.

I get the feeling you just don't really care.  In which case, why did you even
ask for help in the first place?  Troubleshooting this issue requires your
_full_ participation and effort.

In these situations, it is most often the OP who solves his/her own issue, after
providing enough information here that we can point the OP in the right
direction.  The key here is "providing enough information".

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
