Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FEwMAi193899 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 09:58:23 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D731C4E530A
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:59:11 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id F2mCFs0IxIr9CzKx
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:59:11 -0700 (PDT)
Received: from cerberus.net4you.net ([194.177.153.130] helo=[192.168.200.108])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <mw@dermichi.com>) id 1OvtS1-0004B2-IS
	for xfs@oss.sgi.com; Wed, 15 Sep 2010 16:59:09 +0200
Message-ID: <4C90DF38.3070909@dermichi.com>
Date: Wed, 15 Sep 2010 16:59:04 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: no space left on device with 662G free
References: <4C90D080.5090004@mrc-lmb.cam.ac.uk>	<1284561000.2452.1.camel@doink>
	<4C90DA52.8090507@mrc-lmb.cam.ac.uk>
In-Reply-To: <4C90DA52.8090507@mrc-lmb.cam.ac.uk>
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

Hi Dave
>> I'm pretty sure you've run out of inodes.
> 
> # xfs_info /dev/mapper/vg--storage-lv--data
> meta-data=/dev/mapper/vg--storage-lv--data isize=256    agcount=4,
> agsize=134217728 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=536870912, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
Try:
# xfs_growfs -m 10 /dev/mapper/vg--storage-lv--data

It will increase your inode max percentage from 5 to 10.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
