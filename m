Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 08:29:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IFT7bm022184
	for <linux-xfs@oss.sgi.com>; Wed, 18 Jul 2007 08:29:08 -0700
Message-ID: <469E31C5.6010606@sandeen.net>
Date: Wed, 18 Jul 2007 10:29:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS log warning "Writing back config space on device"
References: <11667329.post@talk.nabble.com>
In-Reply-To: <11667329.post@talk.nabble.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: amilrego <victor.amil@gmail.com>
Cc: linux-xfs@oss.sgi.com

amilrego wrote:
> Hello.
> I have formated one 300 GB partition in Linux OS, and then i worked whitout
> problems.
> But, If I do a "dmesg" there is a warning error (i don´t know if is really a
> problem or maybe could cause problems in future):
> 
> SCSI device sdb: drive cache: write back
>  sdb: sdb1
>  ---
> 
> XFS mounting filesystem sdb1
> Ending clean XFS mount for filesystem: sdb1
> PM: Writing back config space on device 0000:05:02.0 at offset b (was
> 165314e4, writing 12bc103c)

That's not an xfs message; it's from the PCI subsystem.  It shouldn't be
related to anything xfs is doing...  It's also only a debug-level
message (at least in 2.6.18).

-eric
