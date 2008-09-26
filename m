Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 21:29:06 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q4T0OJ008904
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:29:00 -0700
Message-ID: <48DC6575.3060403@sgi.com>
Date: Fri, 26 Sep 2008 14:30:45 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Clean up dquot pincount code
References: <48DC6102.2040602@sgi.com>
In-Reply-To: <48DC6102.2040602@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Peter Leckie wrote:
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
> 
> Signed-off-by: Peter Leckie <pleckie@sgi.com>

Looks good Peter, nice to get rid of that spinlock.

Don
