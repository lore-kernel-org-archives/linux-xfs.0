Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 02:30:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5B9UaWt032039
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 02:30:40 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA25823; Mon, 11 Jun 2007 19:30:29 +1000
Message-ID: <466D1635.3040005@sgi.com>
Date: Mon, 11 Jun 2007 19:30:29 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix xfs_quota command handling.
References: <200705310422.AA05481@TNESG9305.tnes.nec.co.jp>
In-Reply-To: <200705310422.AA05481@TNESG9305.tnes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs-oss <xfs@oss.sgi.com>

Utako Kusaka wrote:
> Hi,
> 
> This is my last patch for xfs_quota, maybe.
Thanks all your work on quotas, the xfs quota code is in much better
shape thanks to your efforts.

> When path argument is not specified, xfs_quota executes commands repeatedly
> to the number of mounted XFS file systems.
> As a result, I get the same command report many times. 
> This patch implements the similar command loop operation to xfs_db.

This bug has been around for some time. I've applied your patch and
confirmed it fixes the problem.

When verifying it with the xfs qa tools I found that the quota test (xfstest/050)
fails with expected output problems. The code in test 050 always
passes the mount point in so your change should have no effect on it.
I suspect this is a failure in the qa script itself.

Sorry for the delay in picking up your last five patches.
I'll get them checked in as soon as I resolve our qa problem.

Donald
