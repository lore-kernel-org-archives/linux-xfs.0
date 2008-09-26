Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 21:31:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q4VgeW009760
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:31:43 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D6BC1AF3086
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:33:13 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 0Gcu5PieiLQ2KiEn for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:33:13 -0700 (PDT)
Date: Fri, 26 Sep 2008 14:33:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Clean up dquot pincount code
Message-ID: <20080926043309.GL27997@disturbed>
References: <48DC6102.2040602@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC6102.2040602@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

On Fri, Sep 26, 2008 at 02:11:46PM +1000, Peter Leckie wrote:
> This is a code cleanup and optimization that removes a per mount point
> spinlock from the quota code and cleans up the code.
>
> The patch changes the pincount from being an int protected by a spinlock
> to an atomic_t allowing the pincount to be manipulated without holding
> the spinlock.
>
> This cleanup also protects against random wakup's of both the aild and
> xfssyncd by reevaluating the pincount after been woken. Two latter patches
> will address the Spurious wakeups.

Looks fine now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
