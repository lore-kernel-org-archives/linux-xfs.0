Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 09:07:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8JG7ZaG028247
	for <linux-xfs@oss.sgi.com>; Tue, 19 Sep 2006 09:07:35 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA641D1783BB
	for <linux-xfs@oss.sgi.com>; Tue, 19 Sep 2006 08:02:57 -0700 (PDT)
Message-ID: <4510069A.6050508@sandeen.net>
Date: Tue, 19 Sep 2006 10:02:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_check - out of memory | xfs_repair - superblock error reading
References: <200609181519.18448.christian.gattermair@mci.edu> <450EB025.5020007@oss.sgi.com> <200609191203.22083.christian.gattermair@mci.edu>
In-Reply-To: <200609191203.22083.christian.gattermair@mci.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: christian gattermair <christian.gattermair@mci.edu>
Cc: linux-xfs@oss.sgi.com

christian gattermair wrote:
> hi!
> 
> thanks for all your answers
> 
> 
> parted:
> 
> Disk geometry for /dev/sda: 0.000-3147012,000 megabytes
> Disk label type: msdos
> Minor    Start       End     Type      Filesystem  Flags
> 1          0,031 1049854,423  primary   xfs
> 
> cat /proc/partitions
> 
>   8     0 3222540288 sda
>    8     1 1075050898 sda1

sda1 is only 1 terabyte.  sda itself appears to be about 3 terabytes.

I think you need to sort out where your filesystem is living...

Did someone repartition sda?

>   Vendor: AMCC      Model: 9500S-12   DISK   Rev: 2.06
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> sda : very big device. try to use READ CAPACITY(16).

Or perhaps this is the 2T lun problem... although you say it was working
before.  At any rate this isn't looking like an xfs problem at this
stage - your kernel thinks that your storage is smaller than you think
it is.

-Eric

> SCSI device sda: 6445080576 512-byte hdwr sectors (3299881 MB)
> SCSI device sda: drive cache: write back, no read (daft)
>  /dev/scsi/host0/bus0/target0/lun0: p1
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
