Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64A087CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:22:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2ACEE304032
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 13:22:26 -0800 (PST)
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com
	[209.85.192.42]) by cuda.sgi.com with ESMTP id tGbEJmjoN9ViaN6h
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 13:22:18 -0800 (PST)
Received: by mail-qg0-f42.google.com with SMTP id b35so52865651qge.0
	for <xfs@oss.sgi.com>; Thu, 04 Feb 2016 13:22:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454373550-3102-1-git-send-email-david@fromorbit.com>
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
Date: Thu, 4 Feb 2016 14:22:17 -0700
Message-ID: <CAOxpaSVs=DmbjsBH68wwQVZeP4dm4PkfA3=jQF3LhR_kgp2tFQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] xfs: fix realtime device assert failures
From: Ross Zwisler <zwisler@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This series solves the assert and the follow-up XFS warning for me.

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>

The lockdep splat is still there, but I assume you know that.

On Mon, Feb 1, 2016 at 5:39 PM, Dave Chinner <david@fromorbit.com> wrote:
> Hi folks,
>
> This is a followup to Eric's patch that attempted to fix the assert
> failure that Ross reported. I'd mentioned I'd looked at this
> recently, because xfs/090 was triggering the same failure when
> configured with a RT device. This series fixes the original locking
> based assert failures, followed by the issues that fixing the
> original assert uncovered. This now results in xfs/090 failing
> because of xfs_db check problem (repair is clean) but it (and other
> tests) no longer assert fail.
>
> Cheers,
>
> Dave.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
