Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F0407F4E
	for <xfs@OSS.SGI.com>; Sun, 19 Oct 2014 05:10:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2551AC005
	for <xfs@OSS.SGI.com>; Sun, 19 Oct 2014 03:10:33 -0700 (PDT)
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	XlX97zs4dIprvoHY for <xfs@OSS.SGI.com>;
	Sun, 19 Oct 2014 03:10:28 -0700 (PDT)
Received: from ty.sabi.co.UK (94.192.123.208) by woodbine.london.02.net
	(8.5.140)
	id 53BD9B4503A6D8BB for xfs@OSS.SGI.com; Sun, 19 Oct 2014 11:40:51 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1XfnRM-0007WZ-PE
	for <xfs@OSS.SGI.com>; Sun, 19 Oct 2014 11:10:20 +0100
MIME-Version: 1.0
Message-ID: <21571.36364.518119.806191@tree.ty.sabi.co.uk>
Date: Sun, 19 Oct 2014 11:10:20 +0100
Subject: Re: Problem about very high Average Read/Write Request Time
In-Reply-To: <20141018143848.3baf3266@galadriel.home>
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>
	<20141018143848.3baf3266@galadriel.home>
From: pg@xfs.list.sabi.co.UK (Peter Grandi)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@OSS.SGI.com>

>> I am using xfs on a raid 5 (~100TB) and put log on external
>> ssd device, the mount information is: /dev/sdc on
>> /data/fhgfs/fhgfs_storage type xfs
>> (rw,relatime,attr2,delaylog,logdev=/dev/sdb1,sunit=512,swidth=15872,noquota).
>> when doing only reading / only writing , the speed is very
>> fast(~1.5G), but when do both the speed is very slow (100M),
>> and high r_await(160) and w_await(200000).

> What are your kernel version, mount options and xfs_info output ?

Those are usually important details, but in this case the
information that matters is already present.

There is a ratio of 31 (thirty one) between 'swidth' and 'sunit'
and assuming that this reflects the geometry of the RAID5 set
and given commonly available disk sizes it can be guessed that
with amazing "bravery" someone has configured a RAID5 out of 32
(thirty two) high capacity/low IOPS 3TB drives, or something
similar.

  It is even "braver" than that: if the device name
  "/data/fhgfs/fhgfs_storage" is dedscriptive, this "brave"
  RAID5 set is supposed to hold the object storage layer of a
  BeeFS highly parallel filesystem, and therefore will likely
  have mostly-random accesses.

This issue should be moved to the 'linux-raid' mailing list as
from the reported information it has nothing to do with XFS.

BTW the 100MB/s aggregate over 31 drives means around 3MB/s per
drive, which seems pretty good for a RW workload with
mostly-random accesses with high RMW correlation.

It is notable but not surprising that XFS works well even with
such a "brave" choice of block storage layer, untainted by any
"cowardly" consideration of the effects of RMW and using drives
designed for capacity rather than IOPS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
