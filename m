Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNJRGEq231359 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:27:17 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC846147E486
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:29:14 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id buFa7pOr05MtX5CE
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:29:14 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 1331E6C0B8
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:29:14 -0600 (CST)
Message-ID: <4D13A30A.3090600@hardwarefreak.com>
Date: Thu, 23 Dec 2010 13:29:14 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101223165532.GA23813@peter.simplex.ro>
In-Reply-To: <20101223165532.GA23813@peter.simplex.ro>
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

Petre Rodan put forth on 12/23/2010 10:55 AM:

> this hard drive has exceeded it's 300k load/unload maximum from the specs in only 140 days, which means it was woken up every 30s or so. not willingly.

Contact WD and request a warranty replacement for the drive due to
exceeding the spec'd cycle max in less than 6 months.  They may not
honor your request.  Whether they do or not, I'd replace the drive as
the mechanism obviously has too much wear on it already, and within one
year of use will have well over double the spec'd cycles.  If you
replace it with another 20EARS, replace the firmware immediately as
mentioned below to decrease the load/unload rate.  (It would be nice if
they offered the ability to disable the sleep mode totally, but then it
wouldn't be "green" pfft).

Modern drives consume so little power compared to CPUs and GPUs I can't
understand the big power save quest the HD industry has embarked upon,
especially with potential consequences to drive life you and others are
seeing.  I can understand the need WRT huge drive count enterprise near
line disk arrays, but not the average desktop or server.  And the EARS
series drives are anything but enterprise caliber.  Note the power specs
for the WD20EARS:

Current Requirements
	12 VDC
	Read/Write	296 mA
	Idle		243 mA
	Standby		3 mA
	Sleep		3 mA
	5 VDC
	Read/Write	503 mA
	Idle		172 mA
	Standby		160 mA
	Sleep		160 mA
	Power Dissipation
	Read/Write	6.00 Watts
	Idle		3.70 Watts
	Standby		0.80 Watts
	Sleep		0.80 Watts

6 watts maximum draw for read/write and 3.7 watts idle.  Sure, the sleep
mode consumes 10x less power, but when you're already at less than 4
watts idle it doesn't matter except in huge disk arrays.  For
comparison, your average dual core cpu today consumes an average of
20-50 watts or more.  Power supplies burn more wasted juice than
anything, so get a 90% efficiency PSU and disable all the power save
features of your disk drives to prolong their lifespan.

To replace the 20EARS firmware:

From:
http://community.wdc.com/t5/Desktop/Green-Caviar-High-Load-Cycle-Cout-after-short-operation-time/td-p/15731/page/2


Re: Green Caviar: High Load Cycle Count after short operation time

04-08-2010 04:03 PM

Sorry, but our agent didn't know that this policy was just changed.
Current WDIDLE3 works with the RE and GP drives listed below.

RE Drives - WD1000FYPS-01ZKB0, WD7500AYPS-01ZKB0, WD7501AYPS-01ZKB0

GP Drives - WD20EADS, WD20EARS, WD15EADS, WD15EARS, WD10EADS, WD10EARS,
WD8000AARS, WD7500AADS, WD7500AARS, WD6400AADS, WD6400AARS, WD5000AADS,
WD5000AARS

WDIDLE3

http://support.wdc.com/product/download.asp?groupid=609&sid=113&lang=en


-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
