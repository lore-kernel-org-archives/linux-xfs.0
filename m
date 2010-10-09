Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o990lLfL073368 for <xfs@oss.sgi.com>; Fri, 8 Oct 2010 19:47:22 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB05818E3F72
	for <xfs@oss.sgi.com>; Fri,  8 Oct 2010 17:48:25 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id bldu42paWN8ICoDc for
	<xfs@oss.sgi.com>; Fri, 08 Oct 2010 17:48:25 -0700 (PDT)
Message-ID: <4CAFBBD8.4060408@sauce.co.nz>
Date: Sat, 09 Oct 2010 13:48:24 +1300
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: Quota confusion
References: <4CA55F09.2010609@sauce.co.nz> <20101002103505.GD4681@dastard>
In-Reply-To: <20101002103505.GD4681@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Dave Chinner wrote:

>> Disk quotas for Project shares (1)
>> Filesystem              Blocks      Quota      Limit  Warn/Time
>> Mounted on
>> /dev/dm-0           11816148292          0 12988658280   00
>> [--------] /mnt/storage1
>>
>> the number of blocks is less than the limit.
>
> Ok, that looks normal.

Ah. I was interpreting as total blocks, not blocks used.

>> Also, an xfs_quota df:
>>
>> Filesystem           1K-blocks       Used  Available  Use% Pathname
>> /dev/dm-0           13672271872 11816602148 1855669724   87% /mnt/storage1
>> /dev/dm-0           13672271872 23632296584 1855669724  173%
>> /mnt/storage1/share
>>
>> I do not understand the lower "Used" figure.
>
> Hmmm - looks like a directory quota output for a specific directory
> (/mnt/storage1/share), and for some reason the used field is roughly
> double the correct value. Can you post your project quota config
> files?

/etc/projects 1:/mnt/storage1/share
/etc/projid shares:1

kernel 2.6.35.4 xfsprogs 3.0.4

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
