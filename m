Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO1d9Qd041567 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 19:39:09 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA7061C6C787
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 17:40:46 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id SX8uOVPELLkHxFTT
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 17:40:46 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id A54526C154
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 19:40:45 -0600 (CST)
Message-ID: <4CEC6D1D.1080706@hardwarefreak.com>
Date: Tue, 23 Nov 2010 19:40:45 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs delaylog hanged up
References: <4CEAC412.9000406@shiftmail.org>
	<20101122232929.GJ13830@dastard>	<4CEBA2D5.2020708@shiftmail.org>
	<20101123204609.GW22876@dastard>	<20101123234811.0ea3c41c@galadriel.home>
	<4CEC5E15.7080307@shiftmail.org>
In-Reply-To: <4CEC5E15.7080307@shiftmail.org>
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

Spelic put forth on 11/23/2010 6:36 PM:
> On 11/23/2010 11:48 PM, Emmanuel Florac wrote:
>> So Spelic, you're using the 3Ware as a SATA controller, but not a RAID
>> controller? This is quite unexpected, though going with md
>> instead provides better IOPS.
>>    
> 
> Yep, because I know MD better, I can see the code, it's more flexible
> and customizable, can be controlled with scripts more easily... Also
> parameters to the underlying drives can be controlled if I use MD, and
> it's easier to align filesystem to stripes. Also my time is better spent
> learning it as MD won't change the next time I buy a different hw
> controller.
> What would be the advantage of using hardware raid?

If there is no advantage then why buy an $800+ real hardware RAID card
and then deploy it as a vanilla SAS/SATA HBA with software RAID?  What a
waste of a decent RAID card...

You could have gone with two of these instead
http://www.newegg.com/Product/Product.aspx?Item=N82E16816117157

saving ~$500 and having similar if not slightly better performance with
software RAID.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
