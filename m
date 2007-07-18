Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 07:17:18 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.249])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IEHCbm021265
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 07:17:14 -0700
Received: by an-out-0708.google.com with SMTP id c38so48539ana
        for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 07:17:15 -0700 (PDT)
Message-ID: <f44c5fdf0707180649h778f017dlb532c3ba224944b2@mail.gmail.com>
Date: Wed, 18 Jul 2007 15:49:07 +0200
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
Subject: XFS -git changes and Linux-VServer patch porting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Linux-VServer patch adds 2 new flags: barrier and iunlink.
With recent changes in -git (filestreams), XFS now lacks di_flags bits
to add these.
iunlink flag adds Copy-on-Write semantics to hard links, while barrier
flag signifies a filesystem barrier no virtual context can pass.

I'd like to know how to possibly resolve this problem w/o negatively
impacting performance (especially of iunlink) or changing on-disc
format in an incompatible way, as well as being more future-proof.
