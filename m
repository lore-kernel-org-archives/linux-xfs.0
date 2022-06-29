Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282A1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiF2HkK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiF2HkJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:40:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D828A34BBB
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0bBx/1X5gVax/ZiCcr4+TSyBwKWMWIstz0BSrMwJpYc=; b=iux81Swl/vq73pNYcCmdh+qikz
        ORd/w6xIlqWcXyw8HnUQhkP/qlhZO1BiZi2+BrZot9fqlUcBgjsR+DcX+kwoOse3Zpb5RhOaY9sjX
        ZHRpRrkvpnScb301Lxd2aSIwp02HoLyu3K50Srs60BWwm75n816ARWAXnw7s0knNKsBvRj2u0PcKk
        X5Q6iDDSObFtQ1rNxuZHhusc3IVTEfjN7gPSSAXnQDo4cnXdO8FH9PMx6d15oJMYb3clAoIV9p/q1
        +i9/834XxB3d2IWt3cFOeLWEy7H15FioqpBQcZS6P+bxjlnP0n00Ybgz8yB0C2eN5eXEeem1GBprt
        2Ob0zFJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SIy-00A9UD-Fw; Wed, 29 Jun 2022 07:40:08 +0000
Date:   Wed, 29 Jun 2022 00:40:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: merge xfs_buf_find() and xfs_buf_get_map()
Message-ID: <YrwB2JS9oVRh6l0L@infradead.org>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  
> -static inline struct xfs_buf *
> -xfs_buf_find_fast(
> -	struct xfs_perag	*pag,
> -	struct xfs_buf_map	*map)
> -{
> -	struct xfs_buf          *bp;
> -
> -	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
> -	if (!bp)
> -		return NULL;
> -	atomic_inc(&bp->b_hold);
> -	return bp;
> -}

> -static int
> -xfs_buf_find_insert(
> -	struct xfs_buftarg	*btp,
> -	struct xfs_perag	*pag,

Adding the function just in the last patch and moving them around
here and slighty changing seems a little counter productive.
I think just merging the two might actually end up with a result
that is easier to review.

