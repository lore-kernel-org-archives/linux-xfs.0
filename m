Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 07:22:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0AFM0qw020227
	for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 07:22:01 -0800
Message-ID: <45A50462.40601@sandeen.net>
Date: Wed, 10 Jan 2007 09:21:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Mounting an external HDD fails each second time after xfs_repair
References: <eo2q35$h6e$1@sea.gmane.org>
In-Reply-To: <eo2q35$h6e$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Bier <christoph.bier@web.de>
Cc: linux-xfs@oss.sgi.com

Christoph Bier wrote:
> Hi all,
> 
> I use 14 partitions (one extended partition; partition table see
> below) on my new external 400GB HDD that is managed by LVM2 on
> Debian Sarge with a vanilla kernel 2.6.19.
> 
> The first time I mounted the HDD on my desktop everything worked
> fine and I was able to copy 71GB of data. I unmounted and exported
> the HDD and imported and mounted it on my laptop (commands see
> below) running Ubuntu Edgy. Fine, too, I was able to read the data.
> I exported again and imported again on my desktop. But now mounting
> fails with
> 
> 	mount: /dev/mm-extern/audiovideo: can't read superblock
> 
> /var/log/syslog prints:
> [Output:
> http://www.zvisionwelt.de/tmpdownloads/mount-failure-syslog.output]

These are not xfs errors, you have device problems:

Jan 10 11:43:21 localhost kernel: sd 0:0:0:0: SCSI error: return code = 
0x00070000
Jan 10 11:43:21 localhost kernel: end_request: I/O error, dev sda, 
sector 234300481
Jan 10 11:43:22 localhost kernel: I/O error in filesystem ("dm-1") 
meta-data dev dm-1 block 0x17495339       ("xlog_bread") error 5 buf 
count 262144
Jan 10 11:43:22 localhost kernel: XFS: empty log check failed
Jan 10 11:43:22 localhost kernel: XFS: log mount/recovery failed: error 5
Jan 10 11:43:22 localhost kernel: XFS: log mount failed

XFS is responding -properly- to an I/O error from your disk.

-Eric
