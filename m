Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8B9lNLh064560 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 04:47:23 -0500
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id 1eCxcikUGeKZ2tiu
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 02:48:26 -0700 (PDT)
Message-ID: <504F08E8.6020500@canonical.com>
Date: Tue, 11 Sep 2012 10:48:24 +0100
From: Colin Ian King <colin.king@canonical.com>
MIME-Version: 1.0
Subject: slow xfs writes on loopback mounted xfs with dd + seek
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

Hi,

I've seeing really slow I/O writes on xfs when doing a dd with a seek 
offset to a file on an xfs file system which is loop mounted.

Reproduced on Linux 3.6.0-rc5 and 3.4

How to reproduce:

dd if=/dev/zero of=xfs.img bs=1M count=1024
mkfs.xfs -f xfs.img
sudo mount -o loop -t xfs xfs.img /mnt/test

First create a large file, write performance is excellent:

sudo dd if=/dev/zero of=/mnt/test/big bs=1M count=500
500+0 records in
500+0 records out
524288000 bytes (524 MB) copied, 1.69451 s, 309 MB/s

..next seek and write some more blocks, write performance is poor:

sudo dd if=/dev/zero of=/mnt/test/big obs=4K count=8192 seek=131072
8192+0 records in
1024+0 records out
4194304 bytes (4.2 MB) copied, 47.0644 s, 89.1 kB/s

Using blktrace and seektracer I've captured the I/O on the block device 
containing the xfs.img and I'm seeing ~55-70 seeks per second during the 
slow writes, which seems excessive.

I can reproduce this on hardware with 1, 4 or 8 CPUs.

I've testing this with other file systems I and don't see this issue, so 
it looks like an xfs + loop mounted issue.

Is this a known performance "feature"?

Colin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
