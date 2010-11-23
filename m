Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANMCdpp016029 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:12:40 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F8A81C6BD0E
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:14:17 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id gPshlN7JKfZEIbAQ
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:14:17 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id DA1E56C149
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:14:16 -0600 (CST)
Message-ID: <4CEC3CB8.8000509@hardwarefreak.com>
Date: Tue, 23 Nov 2010 16:14:16 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs delaylog hanged up
References: <4CEAC412.9000406@shiftmail.org>
	<20101122232929.GJ13830@dastard>	<4CEBA2D5.2020708@shiftmail.org>
	<20101123204609.GW22876@dastard>
In-Reply-To: <20101123204609.GW22876@dastard>
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

Dave Chinner put forth on 11/23/2010 2:46 PM:

> I've been unable to reproduce the problem with your test case (been
> running over night) on a 12-disk, 16TB dm RAID0 array, but I'll keep
> trying to reproduce it for a while. I note that the load is
> generating close to 10,000 iops on my test system, so it may very
> well be triggering load related problems in your raid controller...

Somewhat off topic, but how are you generating 10,000 IOPS by carving a
16TB LUN/volume from 12 x 2TB SATA disk spindles?  Such drives aren't
even capable of 200 seeks per second.  Even if they were you'd top out
at less than 2,500 IOPS (random).  16TB/12=1.33 TB per disk.  No such
capacity disk exists.  So I assume you're using 12 x 2TB disks and
slicing/dicing out 16TB.  What am I missing Dave?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
