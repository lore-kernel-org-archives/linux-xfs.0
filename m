Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EK2aZk145799 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 15:02:36 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3202417F1449
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 13:03:25 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id QiYCM3TgGgsGoqit
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 13:03:25 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id AB5CA6C04C
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 15:03:24 -0500 (CDT)
Message-ID: <4C8FD50C.1030905@hardwarefreak.com>
Date: Tue, 14 Sep 2010 15:03:24 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Delaylog
References: <AANLkTin6FSBK3tMXhSxDuLdjyb+R0LhNnaa2CKt37FcV@mail.gmail.com>
	<201009142106.24448.arekm@maven.pl>
In-Reply-To: <201009142106.24448.arekm@maven.pl>
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

Arkadiusz Miskiewicz put forth on 9/14/2010 2:06 PM:
> On Tuesday 14 of September 2010, Fabricio Archanjo wrote:
>> Hey all,
>>
>>    I just trying delaylog in my server that has a mysql database. When
>> i monted my /var/lib/mysql with delaylog option, it showed me:
>> "Enabling EXPERIMENTAL delayed logging feature - use at your own
>> risk". Ok, i know it's experimental, but what kind of problem could i
>> have using delaylog?
> 
> ... and what problems in case of system hang or power loss when compared to 
> nodelaylog mode?

This was covered in prior posts IIRC.  Delaylog holds more write
transactions in memory in an effort to decrease the amount of disk I/O
and optimize write patterns.  The more blocks waiting in the in memory
log, the more data will be lost due to power outage, controller/disk
failure, storage HBA/network failure (iSCSI/FC), kernel panics, etc.

Same failure modes as before, but with potentially greater loss of
data--unless there is an undiscovered bug that can wreck the entire
filesystem.  ;)  Which I believe is the reason for the "experimental"
boilerplate.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
