Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 36F8D7FDF
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 09:51:58 -0600 (CST)
Message-ID: <5130CE9E.9080501@sgi.com>
Date: Fri, 01 Mar 2013 09:51:58 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
	<20130223235546.GA5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
	<20130224141017.GC5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tony Lu <zlu@tilera.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On 02/26/13 01:28, Tony Lu wrote:
> I get a reliable way to reproduce this bug. The logprint and metadump are attached.
>
> Kernel version: 2.6.38.8
> Mkfs.xfs version: xfsprogs-3.1.1
> mkfs.xfs -s size=4096 /dev/sda1
>
> Run the following mount-cp-umount script to reproduce:
> #!/bin/sh
> device=/dev/sda1
> mount_point=/mnt
> times=10
>
> for ((num=1;num<=$times;num++))
> do
>          echo "$num mount $device $mount_point"
>          mount $device $mount_point
>
>          echo "cp -rf /bin $mount_point/$num"
>          cp -rf /bin $mount_point/$num
>
>          echo "$num umount $device $mount_point"
>          umount $mount_point
>
> #num=$(($num + 1))
> done
>
> After several times of mount/cp/umount, this xfs crashes, and the xfs partition can not be mounted any more. Here is the output of console.
> -sh-4.1# ./umount-test
> 1 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> cp -rf /bin /mnt/1
> 1 umount /dev/sda1 /mnt
> 2 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> cp -rf /bin /mnt/2
> 2 umount /dev/sda1 /mnt
> 3 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> cp -rf /bin /mnt/3
> 3 umount /dev/sda1 /mnt
> 4 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> cp -rf /bin /mnt/4
> 4 umount /dev/sda1 /mnt
> 5 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> Ending XFS recovery on filesystem: sda1 (logdev: internal)cp -rf /bin /mnt/5
> 5 umount /dev/sda1 /mnt
> 6 mount /dev/sda1 /mnt
>
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> Ending XFS recovery on filesystem: sda1 (logdev: internal)Interrupt
> cp -rf /bin /mnt/6
> 6 umount /dev/sda1 /mnt
> 7 mount /dev/sda1 /mnt
>
> XFS mounting filesystem sda1
> cp -rf /bin /mnt/7
> 7 umount /dev/sda1 /mnt
> Interrupt
> 8 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
>
> Thanks
> -Tony

It works fine on a 2.6.32 machine I had sitting around - and I never 
required log recovery.

I think you need to answer Dave's question as to why is your unmounts 
are requiring recovery?

Are there errors in the /var/log/messages?

I downloaded the Linux 2.6.38.8 source and take a look if I can recreate 
the problem.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
