Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 053227F50
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 19:04:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A978AC002
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 17:04:50 -0800 (PST)
Received: from mail-qc0-f179.google.com (mail-qc0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	o32AI4gqh48TlHGz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2015 17:04:49 -0800 (PST)
Received: by mail-qc0-f179.google.com with SMTP id c9so15989723qcz.10
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 17:04:48 -0800 (PST)
Received: from yholen.ds (rrcs-97-76-23-49.se.biz.rr.com. [97.76.23.49])
	by mx.google.com with ESMTPSA id d5sm13510446qai.40.2015.01.11.17.04.47
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sun, 11 Jan 2015 17:04:47 -0800 (PST)
Message-ID: <54B31DAA.20008@gmail.com>
Date: Sun, 11 Jan 2015 20:04:42 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [RFC] xfs: remedy small writes during wrapped-log recovery
References: <54B033ED.9010805@gmail.com>
In-Reply-To: <54B033ED.9010805@gmail.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 01/09/15 15:02, Michael L. Semon wrote:
> A bisect still needs to be done to determine when the slow mount 
> behavior started.  It could very well be that somebody fixed the 
> buffer_io_error messages that I saw long ago, and the solution made 
> some mounts here rather miserable.

OK, I looked at this part.  bisect was unhelpful, so I checked out 
kernel 2.6.32.65 from -stable.  Lo and behold, the issue was there, 
too.  This means that Brian and Dave are right, that my hardware 
is slow and contended.  I'll add that the hardware gets worse with 
time and testing.  Something could still be made better here.

The test case I use is to copy xfsprogs source to $SCRATCH_MNT 
and do mount/touch/umount cycles, allowing the log to become 
wrapped and then unwrapped.  Run it through at least two cycles 
so you see that the new-FS case and repaired-FS case have 
different timings on v5 XFS.

Write caches are off for tests here.  The way hard drive write cache 
is shut off here is to have "/sbin/hdparm -W 0 /dev/sda" at the top 
of the first boot script.  It provides extra integrity during udev-
related catastrophes on boot, but slow mounts are made more obvious 
this way.

This test script should hopefully work (current cruft trimmed down 
while writing this E-mail):

#!/bin/sh
xfsprogs_src="/usr/src/xfs/xfsprogs"

umount $SCRATCH_DEV
mkfs.xfs -f -m crc=1,finobt=1 $SCRATCH_DEV
mount $SCRATCH_DEV $SCRATCH_MNT
echo -n "Files copied... "
cp -av $xfsprogs_src $SCRATCH_MNT/ | wc -l
sync
umount $SCRATCH_MNT
b=0

while true; do
        b=$((b+1))
        for a in `seq 1 75`; do
                echo "Loop $b, Pass $a:"
                time mount $SCRATCH_DEV $SCRATCH_MNT
                find $SCRATCH_MNT/xfsprogs -type f -exec touch {} \;
                sync
                umount $SCRATCH_MNT
                sync
		# Uncomment this to correlate wrapped logs with 
		# errors from xfs_logprint:
                # xfs_logprint $SCRATCH_DEV | grep "^xfs_logprint"
        done
        xfs_repair -v $SCRATCH_DEV
done

Really, though, the best way to spot this is to add a line of 
printk() to xlog_bwrite() and see how many times it is called on 
each mount.  In my opinion, it should be called not many times 
more for a wrapped-log mount than for a normal-log mount.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
