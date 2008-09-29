Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 14:43:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TLhmBK031335
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:43:48 -0700
Date: Mon, 29 Sep 2008 17:45:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080929214524.GA12523@infradead.org>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925010318.GB27997@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Thu, Sep 25, 2008 at 11:03:18AM +1000, Dave Chinner wrote:
> This is a similar situation - if the sv_t is broken, we need to
> replace all users, not just work around one symptom of the
> brokenness. This is expecially important as the remaining users
> of sv_t's are in the log for iclog synchronisation....

The sv_t is not broken per se but a quite dangerous primitive as
people can easily miss re-checking the condition after a wakeup.

After a quick check 5 out of 10 callers of sv_wait re-check their
condition, and most do in a quite broad loop.  It might make sense
to just that lille bit of code and use prepare_wait / finish_wait
explicitly.
