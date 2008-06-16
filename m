Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 21:44:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G4igVo008603
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 21:44:42 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D9488CC179B
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 21:45:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id sy57TCE3TJvK7KLw for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 21:45:37 -0700 (PDT)
Subject: Re: xfs_repair trouble
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <dd599fe00806140943g13c790dfo9b3a84d7f9841641@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 14:47:04 +1000
Message-ID: <op.uctrkqf73jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <dd599fe00806140943g13c790dfo9b3a84d7f9841641@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Simon <simonjj@gmail.com>, xfs@oss.sgi.com

On Sun, 15 Jun 2008 02:43:12 +1000, Simon <simonjj@gmail.com> wrote:

> Hello all,
>
>
> I have a corrupted xfs filesystem on top of a RAID 5 (1TB in size).
> The RAID is still fully intact but the filesystem was damaged. When
> trying to repair the filesystem xfs_repair fails. I have tried various
> versions of xfs_repair, the latest stable (2.9.8) and the latest trunk
> (from CVS). I'd love to investigate and/or fix the issue further but I
> am a bit confused about some of my xfs_repair runs (both done with
> trunk).
> Could someone shed some light on where the problem could be, I'd be
> happy to continue digging if I would only know where roughly

Are you able to generate an xfs_metadump? If you can make that available,
I should be able to find out the problem pretty easily.

Regards,
Barry.
