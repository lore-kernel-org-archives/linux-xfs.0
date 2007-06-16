Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Jun 2007 15:59:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5GMxgWt015321
	for <xfs@oss.sgi.com>; Sat, 16 Jun 2007 15:59:43 -0700
Message-ID: <4674645F.5000906@gmail.com>
Date: Sun, 17 Jun 2007 08:29:51 +1000
From: David Robinson <zxvdr.au@gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com>
In-Reply-To: <46744065.6060605@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>

David Greaves wrote:
> This isn't a regression.
> 
> I was seeing these problems on 2.6.21 (but 22 was in -rc so I waited to 
> try it).
> I tried 2.6.22-rc4 (with Tejun's patches) to see if it had improved - no.
> 
> Note this is a different (desktop) machine to that involved my recent bugs.
> 
> The machine will work for days (continually powered up) without a 
> problem and then exhibits a filesystem failure within minutes of a resume.
> 
> I know xfs/raid are OK with hibernate. Is lvm?

I have LVM working with hibernate w/o any problems (w/ ext3). If there 
were a problem it wouldn't be with LVM but with device-mapper, and I 
doubt there's a problem with either. The stack trace shows that you're 
within XFS code (but it's likely its hibernate).

You can easily check whether its LVM/device-mapper:

1) check "dmsetup table" - it should be the same before hibernating and 
after resuming.

2) read directly from the LV - ie, "dd if=/dev/mapper/video_vg-video_lv 
of=/dev/null bs=10M count=200".

If dmsetup shows the same info and you can read directly from the LV I 
doubt it would be a LVM/device-mapper problem.

Cheers,
Dave
