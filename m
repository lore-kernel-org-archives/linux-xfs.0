Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 May 2008 08:50:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m47FoRFN005656
	for <xfs@oss.sgi.com>; Wed, 7 May 2008 08:50:28 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA031B28CC1
	for <xfs@oss.sgi.com>; Wed,  7 May 2008 08:51:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id 3yf4FKBAWhtT4Kz8 for <xfs@oss.sgi.com>; Wed, 07 May 2008 08:51:13 -0700 (PDT)
Message-ID: <4821CFED.4030804@sandeen.net>
Date: Wed, 07 May 2008 10:51:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Is this XFS problem or something else? : xfs_trans_read_buf error
 5 buf count 4096
References: <007001c898f5$cae2f4a0$60a8dde0$@masuda@jlbond.com> <20080407220106.GF108924158@sgi.com> <000001c8b058$2ae68460$80b38d20$@net>
In-Reply-To: <000001c8b058$2ae68460$80b38d20$@net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bond Masuda <bm007@cox.net>
Cc: xfs@oss.sgi.com

Bond Masuda wrote:
> Not sure if this is XFS related or not, but this seems to be reoccurring. 

You are probably hitting:

https://bugzilla.redhat.com/show_bug.cgi?id=437968
Bugzilla Bug 437968: Corrupt xfs root filesystem with kernel
kernel-2.6.24.3-xx

Fix is in 2.6.25-rc9 upstream and kernel-2.6.24.5-85.fc8 has been
submitted as an update for Fedora 8 and is now in stable.

If you need to keep the system as-is I'd upgrade the kernel immediately,
then try xfs_repair.

A fresh install might be best; do an install, upgrade to that kernel,
reboot into it, *then* yum update the rest.

-Eric

> The hardware is:
> 
> Dell Inspiron 530, Q6600 quad core, 4GB Ram, 2x750GB SATA HDD
> 
> I have Fedora 8/64bit installed, using XFS for "/", ext3 for "/boot". The
> two identical 750GB drives are striped to create a 1.4TB "md1" device, which
> is mounted as "/". Kernel is from Fedora8, 2.6.24.4-64.fc8.
> 
> During the install, everything seemed to work fine. I was able to use the
> system without any problems for about 2 days. Then I reboot, and the md1
> device running XFS shows the following error messages:
> 
> I/O error in filesystem ("md1") meta-data dev md1 block 0x15d048574120008
> ("xfs_trans_read_buf") error 5 buf count 4096
> attempt to access beyond end of device
> md1: rw=0, want=98239738096517136, limit=2927780864
> 
> The above message repeats several times, but the system manages to boot to
> runlevel 3. I can login, but almost any command triggers that message which
> has flooded the logs. here is xfs_info on "/":
> 
> meta-data=/dev/root			isize=256	agcount=32,
> agsize=11436608 blks
> 	   =					sectsz=512	attr=1
> data	   =					bsize=4096
> blocks=365971456, imaxpct=25
> 	   =					sunit=64	swidth=128
> blks, unwritten=1
> naming   =version2			bsize=4096
> log	   =internal			bsize=4096	blocks=32768,
> version=1
> 	   =					sectsz=512	sunit=0
> blks, lazy-count=0
> realtime =none				extsz=524288 blocks=0, rtextents=0
> 
> At first, I thought perhaps something wrong with the disks so I had them
> replaced. Reinstalled Fedora8 as before, then again, 2 days later (I don't
> know if the 2 day time period is coincidental or not), I reboot, and the
> exact same problem occurred. Since I've gone through 4 brand new 750GB HDD
> now, (Seagate diagnostics show all the disks to be fine in both occurances,
> but I replaced them anyway) I'm feeling that this is not a hardware issue,
> but software related.
> 
> A search on google seems to show others with possibly similar issues:
> 
> http://ubuntuforums.org/archive/index.php/t-568309.html
> 
> Is that related? Other google searches show a pattern of this problem only
> with >1TB XFS partitions, but that's just what I found googling.
> 
> I'm considering re-installing again, but using ext3 for "/" to see if the
> problem reoccurs, in hopes of "isolating" the issue. Not sure if it is
> related to XFS, the software stripe md1, or something else (but I don't
> think it's HDD related now).
> 
> Thanks for any info or assistance. Though the system isn't really usable,
> (many commands fail, but does boot to runlevel 3 and permits me to login)
> I'll leave it as is for today so let me know if there's other info I can try
> to gather that would be useful.
> 
> Any help would be appreciated.
> -Bond
> 
> 
> 
