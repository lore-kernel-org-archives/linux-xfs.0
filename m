Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0IEEVJI135063 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 08:14:31 -0600
Received: from zixvpm01.zixvpm.davisvision.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6636819E2002
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 06:16:48 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com
	(zixvpm01.zixvpm.davisvision.com [65.213.99.44]) by
	cuda.sgi.com with ESMTP id KULi2X7ChyxbTCMQ for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 06:16:48 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com (ZixVPM [127.0.0.1])
	by Outbound.davisvision.com (Proprietary) with ESMTP id 28E508CC032
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 09:16:48 -0500 (EST)
Message-ID: <1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
Date: Tue, 18 Jan 2011 09:16:47 -0500
From: Cory Coager <ccoager@davisvision.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<20110113233527.6dca104d@galadriel.home>	<18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>	<4D30A945.4060000@hardwarefreak.com>	<27616_1295038110_4D30B69E_27616_233_1_4D30B69E.4020506@davisvision.com>
	<4D30C7F3.3040105@hardwarefreak.com>
In-Reply-To: <4D30C7F3.3040105@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

On 01/14/2011 05:02 PM, Stan Hoeppner wrote:
> The controller should do this automatically.  You'll have to check the docs to
> verify.  This is to safeguard data.  The BBWC protects unwritten data in the
> controller cache only, not the drives' caches.  It won't negatively affect
> performance if the drives' caches are enabled.  On the contrary, it would
> probably increase performance a bit.  It's simply less safe having them enabled
> in the event of a crash.
>
> After rereading your original post I don't think there's any issue here anyway.
>   You stated you have 24 drives in 2 arrays (although you didn't state if all the
> disks are on one P600 or two).
>
Just one P600.

> This was the important part I was looking for.  It's apparently not a cache
> issue then, unless the utility is lying or querying the wrong controller or
> something.
>
> Nothing relevant in dmesg or any other logs?  No errors of any kind?  Does
> iostat reveal anything even slightly odd?
Nothing interesting in dmesg.  iostat looks pretty dead on average.  
During the dd write its doing about ~7tps according to iostat.
> I also just noticed you're testing writes with a 1k block size.  That seems
> awefully small.  Does the write throughput increase any when you test with a
> 4k/8k/16k block size?
Yes, it the throughput does increase with larger block sizes.  I was 
able to get ~13MB/s with 16k block size, still terrible however.
> BTW, this is an old machine.  PCI-X is dead.  Did this slow write trouble just
> start recently?  What has changed since it previously worked fine?
The array is new and newly implemented.
> You're making it very difficult to assist you by not providing basic
> troubleshooting information.  I.e.
>
> What has changed since the system functioned properly?
> When did it change?
> Did it ever work properly?
> Etc.
>
> God I hate pulling teeth... :)
No, it has never worked properly.  Also, I want to stress that I am only 
having performance issues with one logical volume, the others seem fine.



------------------------------------------------------------------------
The information contained in this communication is intended
only for the use of the recipient(s) named above. It may
contain information that is privileged or confidential, and
may be protected by State and/or Federal Regulations. If
the reader of this message is not the intended recipient,
you are hereby notified that any dissemination,
distribution, or copying of this communication, or any of
its contents, is strictly prohibited. If you have received
this communication in error, please return it to the sender
immediately and delete the original message and any copy
of it from your computer system. If you have any questions
concerning this message, please contact the sender.
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
