Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 04:26:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8QBPtMl000806
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 04:25:56 -0700
Date: Fri, 26 Sep 2008 07:27:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080926112729.GA3287@infradead.org>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926003401.GG27997@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

>  	/*
> -	 * Cant flush a pinned dquot. Wait for it.
> +	 * Cant flush a pinned dquot. If we are not supposed to block,
> +	 * don't wait for it.
>  	 */
> +	if (!(flags & XFS_QMOPT_SYNC) && dqp->q_pincount > 0) {
> +		xfs_dqfunlock(dqp);
> +		return (0);
> +	}
>  	xfs_qm_dqunpin_wait(dqp);

Looks good, but please remove the braces around the 0.  (And yes, I know
that the statement just above it does it too..)
