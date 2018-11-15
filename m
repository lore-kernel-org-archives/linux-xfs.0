Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbeKOUYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 15:24:47 -0500
Date: Thu, 15 Nov 2018 02:17:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/2] splice: increase pipe size in
 splice_direct_to_actor()
Message-ID: <20181115101735.GC13913@infradead.org>
References: <20181108221909.27602-1-david@fromorbit.com>
 <20181109005410.GG19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109005410.GG19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> +long pipe_set_max_safe_size(struct pipe_inode_info *pipe)
> +{
> +	pipe_set_size(pipe, pipe_max_size);
> +	return pipe->buffers * PAGE_SIZE;
> +}

This should probably return an unsigned value, given that we don't return
errors.  Then again the callers ignores the return value entirely.
Wouldn't it be easier to just call pipe_set_size from splice.c after
removing the static marker?
