Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B90EC43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 18:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D795B2054F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 18:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gZdBNxCm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgDASmq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 14:42:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbgDASmq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 14:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+sGAewA2ZzBCWxDaGS1LCNXBr5CVOFWA8zdTR0hwdWg=; b=gZdBNxCmHpsyb2pe2YbptcdWcW
        ND/OdRBP6q/ITKDYcKU+6GqpDh5GrfvIA/FrWjkXr3fPTJNY6Y6D8EHABqVrS/dqZrdwXN+EA4zPY
        dlWl2WExJjw67IzLXYp7riL2P+91eMhiyVhZ2fvF/UAkaJvT4VxZflxVeZNeWnu/eQquWuB7pgmZM
        /QpcT0QpKq6MpexEFkc5vZvGbJVf8C7ddxr3EMlV/aij2eO/5q6NRf/aaC1Rg3a49uCxCvURU8rGN
        dhCW9kJXJR9Qb+zANmGID9mAU3GGYViYO2WfOjQO5dVF55p2m3sS3cbuuTtaqQkEWxM/A/VUjH+da
        ZJ8RYnLw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJiK6-0006Nx-29; Wed, 01 Apr 2020 18:42:46 +0000
Date:   Wed, 1 Apr 2020 11:42:45 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Add iomap_iter API
Message-ID: <20200401184245.GI21484@bombadil.infradead.org>
References: <20200401152522.20737-1-willy@infradead.org>
 <20200401152522.20737-2-willy@infradead.org>
 <20200401154248.GA2813@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401154248.GA2813@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 01, 2020 at 08:42:48AM -0700, Christoph Hellwig wrote:
> > +loff_t iomap_iter(struct iomap_iter *iter, loff_t written)
> > +{
> > +	const struct iomap_ops *ops = iter->ops;
> > +	struct iomap *iomap = &iter->iomap;
> > +	struct iomap *srcmap = &iter->srcmap;
> 
> I think it makes sense to only have members in the iter structure
> that this function modifies.  That is, just pass inode, ops and flags
> as explicit parameters.

One of the annoying things we do when looking at the disassembly is
spend a lot of instructions shuffling arguments around.  Passing as many
arguments as possible in a struct minimises that.  Ideally we'd pass
the iomap_iter to iomap_begin() and iomap_end().  Agreed passing the
ops there makes no sense, but I'd like to keep inode and flags in
the iomap_iter struct so they don't need to be passed to begin/end
as explicit arguments.

> OTOH the len argument / return value seems like something that would
> seems useful in the iter structure.  That would require renaming the
> current len to something like total_len..

I'm inclined to go with seg_len and op_len.

> > +/* Magic value for first call to iterator */
> > +#define IOMAP_FIRST_CALL	LLONG_MIN
> 
> Can we find a way to make a a zero initialized field the indicatator
> of the first call?  That way we don't need any knowledge of magic
> values in the callers.  And also don't need any special initializer
> value, but just leave it to the caller to initialize .pos and
> .total_len, and be done with it.

Yeah; this was just a quick hack.  I'll do something neater.
