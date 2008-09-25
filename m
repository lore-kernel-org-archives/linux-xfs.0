Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 02:10:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P9AWBJ015261
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 02:10:32 -0700
Date: Thu, 25 Sep 2008 05:12:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080925091205.GA11706@infradead.org>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DB4F3F.8040307@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

On Thu, Sep 25, 2008 at 06:43:43PM +1000, Peter Leckie wrote:
> So I would say the fix I proposed is a good solution for this issue.
>
> However there are other functions that use sv_wait and should also be  
> fixed in a similar way so I'll
> look into the other callers and prepare a patch tomorrow.

Note that most users of sv_wait do actually re-check the condition.
It's just that wait_event enforces it in the API while sv_wait doesn't
make it as explicit.   But another audit of this would be a good thing.
