Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 08:13:14 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0AGD7qw029106
	for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 08:13:09 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1H4g3Y-0003Ak-IQ
	for linux-xfs@oss.sgi.com; Wed, 10 Jan 2007 17:12:05 +0100
Received: from p54a57214.dip.t-dialin.net ([84.165.114.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 17:12:04 +0100
Received: from christoph.bier by p54a57214.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 17:12:04 +0100
From: Christoph Bier <christoph.bier@web.de>
Subject: Re: Mounting an external HDD fails each second time after xfs_repair
Date: Wed, 10 Jan 2007 17:11:55 +0100
Message-ID: <eo338a$mt9$1@sea.gmane.org>
References: <eo2q35$h6e$1@sea.gmane.org> <45A50462.40601@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: <45A50462.40601@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Eric Sandeen schrieb am 10.01.2007 16:21:

> Christoph Bier wrote:
>> Hi all,
>> 
>> I use 14 partitions (one extended partition; partition table see
>> below) on my new external 400GB HDD that is managed by LVM2 on
>> Debian Sarge with a vanilla kernel 2.6.19.
>> 
>> The first time I mounted the HDD on my desktop everything worked
>> fine and I was able to copy 71GB of data. I unmounted and exported
>> the HDD and imported and mounted it on my laptop (commands see
>> below) running Ubuntu Edgy. Fine, too, I was able to read the data.
>> I exported again and imported again on my desktop. But now mounting
>> fails with
>> 
>> 	mount: /dev/mm-extern/audiovideo: can't read superblock
>> 
>> /var/log/syslog prints:
>> [Output:
>> http://www.zvisionwelt.de/tmpdownloads/mount-failure-syslog.output]
> 
> These are not xfs errors, you have device problems:
> 
> Jan 10 11:43:21 localhost kernel: sd 0:0:0:0: SCSI error: return code = 
> 0x00070000
> Jan 10 11:43:21 localhost kernel: end_request: I/O error, dev sda, 
> sector 234300481
> Jan 10 11:43:22 localhost kernel: I/O error in filesystem ("dm-1") 
> meta-data dev dm-1 block 0x17495339       ("xlog_bread") error 5 buf 
> count 262144
> Jan 10 11:43:22 localhost kernel: XFS: empty log check failed
> Jan 10 11:43:22 localhost kernel: XFS: log mount/recovery failed: error 5
> Jan 10 11:43:22 localhost kernel: XFS: log mount failed
> 
> XFS is responding -properly- to an I/O error from your disk.

Hm. Ok, thanks for your answer!

Best,
  Christoph
-- 
+++ Typografie-Regeln: http://zvisionwelt.de/downloads.html (1.6)
