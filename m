Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Feb 2008 01:28:19 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G9SGSd014482
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 01:28:17 -0800
Received: from smtp-out002.kontent.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C70EFE37AA0
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 01:28:41 -0800 (PST)
Received: from smtp-out002.kontent.com (smtp-out002.kontent.com [81.88.40.216]) by cuda.sgi.com with ESMTP id ehWs7COd9YH4HwE0 for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 01:28:41 -0800 (PST)
Message-ID: <47B6ACC5.3030605@theendofthetunnel.de>
Date: Sat, 16 Feb 2008 10:28:37 +0100
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: Re: tuning, many small files, small blocksize
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
In-Reply-To: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>
Cc: xfs@oss.sgi.com

Jeff Breidenbach wrote:
> The underlying disks use linux software RAID-1
> manged by mdadm with 5X redundancy. E.g. 5 drives that
> completely mirror each other.

That's maybe a bit paranoid, but on the other hand it should give good 
parallelism.

> a) Should I just go with the 512 byte blocksize or is that going to be
> bad for some performance reason? Going to 1024 is no problem,
> but I'd prefer not to waste 20% of the partition capacity by using 4096.

I don't think there is performance problem with 512 byte block size, but 
it limits the internal log size to 32MB. You might want to use a larger 
external log.

> b) Are there any other mkfs.xfs paramters that I should play with.

mkfs.xfs -n size=16k -i attr=2 -l lazy-count=1,version=2,size=32m -b 
size=512 /dev/sda

mount -onoatime,logbufs=8,logbsize=256k /dev/sda /mnt/xfs

Requires kernel 2.6.23 and xfsprogs 2.9.5. As said, you might want to 
use an external log device.


-- 
Best regards,
Hannes Dorbath
