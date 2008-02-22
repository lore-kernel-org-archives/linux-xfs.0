Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 18:50:45 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M2obMA024188
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 18:50:38 -0800
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5825604C53
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 18:46:03 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with ESMTP id XKMIIgLIk4SMcvcW for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 18:46:03 -0800 (PST)
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [RFC, patch 1/2] Allow up to 1GB logs in mkfs.xfs
References: <20080221230833.GG155407@sgi.com>
Date: Fri, 22 Feb 2008 13:44:38 +1100
In-Reply-To: <20080221230833.GG155407@sgi.com> (David Chinner's message of
	"Fri, 22 Feb 2008 10:08:34 +1100")
Message-ID: <ncctzk11zhl.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner <dgc@sgi.com> writes:

> Increase the maximum log size supported by mkfs.
>
> The log size can be increased easily in mkfs by changing a few
> defines and a couple of types to allow the log size to increase to
> 1GB. Theoretically, the log size can be made much, much larger than
> this (up to 2^32 sectors), but going beyond 2^30 *bytes* causes
> integer overflow issues in the kernel log code.
>
> e.g. a 2GB log (2^31 bytes) will not mount because the
> space calculations in the kernel use "int" types and
> overflow:
>
> STATIC int
> xlog_space_left(xlog_t *log, int cycle, int bytes)
>
> Hence logs larger than 2^30 will not work without kernel
> modifications.  Therefore this change is limited to increasing the
> log size to what we can currently support in kernel space with
> needing kernel modifications.

I'm glad you got time to get around this, I didn't include it in the
first batch as I was told it 'broke things'.

Looks good to me.

Cheers,
-- 
Niv Sardi
