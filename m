Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0EM0DjD096383 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 16:00:14 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E33301E9EE70
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 14:02:28 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id M6IDx8cTpE0hvVp2
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 14:02:28 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 6D6A36C116
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 16:02:27 -0600 (CST)
Message-ID: <4D30C7F3.3040105@hardwarefreak.com>
Date: Fri, 14 Jan 2011 16:02:27 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<20110113233527.6dca104d@galadriel.home>	<18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>	<4D30A945.4060000@hardwarefreak.com>
	<27616_1295038110_4D30B69E_27616_233_1_4D30B69E.4020506@davisvision.com>
In-Reply-To: <27616_1295038110_4D30B69E_27616_233_1_4D30B69E.4020506@davisvision.com>
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

Cory Coager put forth on 1/14/2011 2:48 PM:
> On 01/14/2011 02:51 PM, Stan Hoeppner wrote:
>> Make sure the write cache on the P600 (what size is it BTW?) is enabled and that
>> the BBU is in working order.  Also make sure the P600 is disabling the write
>> caches on the drives themselves.  Then...
>>
> Write cache is enabled on the controller, the size is 512MB, BBU is in good
> conditioned (checked with the HP utility).  How do I check the write cache on
> the drives?

The controller should do this automatically.  You'll have to check the docs to
verify.  This is to safeguard data.  The BBWC protects unwritten data in the
controller cache only, not the drives' caches.  It won't negatively affect
performance if the drives' caches are enabled.  On the contrary, it would
probably increase performance a bit.  It's simply less safe having them enabled
in the event of a crash.

After rereading your original post I don't think there's any issue here anyway.
 You stated you have 24 drives in 2 arrays (although you didn't state if all the
disks are on one P600 or two).

>> Mount with 'nobarrier' so XFS isn't interfering with the hardware cache
>> performance of the P600.  With barriers enabled (the default) XFS will
>> periodically flush the cache on the RAID card causing write performance problems.
>>
> Already using nobarrier.

This was the important part I was looking for.  It's apparently not a cache
issue then, unless the utility is lying or querying the wrong controller or
something.

Nothing relevant in dmesg or any other logs?  No errors of any kind?  Does
iostat reveal anything even slightly odd?

I also just noticed you're testing writes with a 1k block size.  That seems
awefully small.  Does the write throughput increase any when you test with a
4k/8k/16k block size?

BTW, this is an old machine.  PCI-X is dead.  Did this slow write trouble just
start recently?  What has changed since it previously worked fine?

You're making it very difficult to assist you by not providing basic
troubleshooting information.  I.e.

What has changed since the system functioned properly?
When did it change?
Did it ever work properly?
Etc.

God I hate pulling teeth... :)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
