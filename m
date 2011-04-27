Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3R84ftS205996 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 03:04:41 -0500
Received: from edge20.ethz.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98BEE417537
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 01:08:13 -0700 (PDT)
Received: from edge20.ethz.ch (edge20.ethz.ch [82.130.99.26]) by cuda.sgi.com
	with ESMTP id iifBjIeDdemneTqv for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 01:08:13 -0700 (PDT)
Message-ID: <4DB7CF50.7050204@inf.ethz.ch>
Date: Wed, 27 Apr 2011 10:09:52 +0200
From: Benjamin Schindler <bschindler@inf.ethz.ch>
MIME-Version: 1.0
Subject: Re: xfs performance problem
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB7CC01.8090804@dermichi.com>
In-Reply-To: <4DB7CC01.8090804@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

Hi


On 04/27/2011 09:55 AM, Michael Weissenbacher wrote:
> schrieb Stan Hoeppner:
>> Benjamin Schindler put forth on 4/26/2011 2:44 PM:
>>> Hi
>> Also, slap yourself in the forehead at least 3 times for running your
>> root filesystem on RAID 0.  That's akin to riding a motorcycle, naked,
>> in a blizzard, down a steep, winding, ice covered mountain road with no
>> guard rails and a 3000 ft drop. ;)
>>
> If you are really adventurous and don't care about the data on your root
> fs use the following mount options:
> logbsize=256k,delaylog,nobarrier
> 
> Personally i would only enable "nobarrier" on Server-Class hardware with
> Battery Backup and proper UPS. But since you are using RAID-0 i suppose
> you really don't care that much about the data on your root fs.

Or stop using raid-0 all together. The performance gain is more than
offset by the barriers and it seems using xfs on just a single disk
would improve performance a lot more than using raid-0 (with disk
failure risk) + risk of corruption due to disabled barriers... or am I
missing something?

> 
> Note that both logbsize and delaylog will only have effect on your root
> fs if added to grub.conf (real_rootflags=) since remounting won't
> activate them. Use "cat /proc/mounts" to see if these options were
> really enabled.
> 
> hth,
> Michael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
