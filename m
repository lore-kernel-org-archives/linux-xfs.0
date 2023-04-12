Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405B7C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 12:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjDLMSJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 08:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjDLMSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 08:18:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8123419AB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 05:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZdMzpT0QBf7UyB3dyHgAx+RCW2znHrrjSqe98SZp8Qs=; b=Ucih7LOI9C+rdc9eS4aoHAbFYb
        NoKSayIQHyUx9k2QMjPDfzBNut0pNgrsJxrcBM6Qi/NdwzrjX49NwNwWPzuhwIHIZ36/LQt7J1vqy
        17uD7cvurdHHkrKNAdh6OqTQFcZRsOXJpb0sBhynzSQhNZBl4tcYGYAdl7c70rUcHQE2JhNEI1Lc1
        gTrSDK3XEpuEAWmkxqTsHl0vYRV3FeZiG2aUirduWSUkrwWNiWO7bcEj4uvfWMQFRy0GJt3S2s/1Y
        Qj3Oe607/1BaQ53chPgiB++in4hR8i7bKrU8UKCtuDFzTLoZTnb7R9/5lX39QM/3wUkbqfDTf4eVA
        gAdj8PIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmZQN-0033VN-1G;
        Wed, 12 Apr 2023 12:18:07 +0000
Date:   Wed, 12 Apr 2023 05:18:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
Message-ID: <ZDahf6XEA2trj7sQ@infradead.org>
References: <20230411233159.GH360895@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411233159.GH360895@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 04:31:59PM -0700, Darrick J. Wong wrote:
> Unfortunately, the ondisk buffer is corrupt, but recovery just read the
> buffer with no buffer ops specified:
> 
> 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
> 			buf_f->blf_len, buf_flags, &bp, NULL);

> +
> +		/*
> +		 * We're skipping replay of this buffer log item due to the log
> +		 * item LSN being behind the ondisk buffer.  Verify the buffer
> +		 * contents since we aren't going to run the write verifier.
> +		 */
> +		if (bp->b_ops) {
> +			bp->b_ops->verify_read(bp);
> +			error = bp->b_error;
> +		}

How do we end up with ops attached here if xfs_buf_read doesn't
attach them?  The buf type specific recover routines later attach
ops, but this is called before we reach them.

