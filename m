Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 23:30:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q6Tv90032091
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 23:29:57 -0700
Date: Fri, 26 Sep 2008 02:31:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Clean up dquot pincount code
Message-ID: <20080926063132.GB20516@infradead.org>
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

Looks good.
