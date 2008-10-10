Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Oct 2008 11:03:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9AI34ht002319
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2008 11:03:04 -0700
Date: Fri, 10 Oct 2008 11:04:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fix barrier fail detection in XFS
In-Reply-To: <48EEF60D.4020602@sgi.com>
Message-ID: <alpine.LFD.2.00.0810101103520.3503@nehalem.linux-foundation.org>
References: <48EEF60D.4020602@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: lkml@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>, Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org, toei.rei@stargazer.at



On Fri, 10 Oct 2008, Timothy Shimmin wrote:
> 
> This is an important fix posted by Christoph Hellwig today.
> Without this fix, XFS can turn off barriers when we wrap our ondisk log.
> Which could lead to corruption after unclean unmounts/shutdowns
> on machines without a persistent write cache etc.

Ok, it clearly didn't make it into 2.6.27. I assume it it should be marked 
for stable?

		Linus
