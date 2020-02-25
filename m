Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070BEC35E15
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2AE920675
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SM3k+FIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgBYVkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 16:40:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39976 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYVkq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 16:40:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8h8Mk/+i2ci77DBxC+22pQBGtOSOCk88EXwXWgQP6/o=; b=SM3k+FIk88DTWRwntxpfYAN89K
        8730/L0k8T1+XsnrvgFNMWAfU3J+npnA7AcglPMW6Bo1xxfLLLpVFkPpIYJPJP6Bhu7+++sdf2nEH
        YB261ciNtDjMI/oof919hR4o1Vy1b/Tpm1qbQB3EJuexLkfZNNuOV19796072HGhlsh0EIzWw5HYM
        eUtiC/75UHd7z4CtLi7iS7enj2b4YxR2RIq/XwjOL2jsuV22QQdFs+uI19makOCqv8ClbB0oAVsbW
        Z77s9bVrdikXc2kEfrt+0KjleiaHbcqyykssQ37fBRsVTqPhlgghL5coVoY1AOq2xP0UIa8q2Eciy
        KEJgOYKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6hwb-0005MJ-8Z; Tue, 25 Feb 2020 21:40:45 +0000
Date:   Tue, 25 Feb 2020 13:40:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Qian Cai <cai@lca.pw>
Cc:     darrick.wong@oracle.com, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix an undefined behaviour in _da3_path_shift
Message-ID: <20200225214045.GA14399@infradead.org>
References: <1582660388-28735-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582660388-28735-1-git-send-email-cai@lca.pw>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 02:53:08PM -0500, Qian Cai wrote:
> xfs_da3_path_shift() could see state->path.blk[-1] because
> state->path.active == 1 is a valid state when it tries to add an entry
> to a single dir leaf block and then to shift forward to see if
> there's a sibling block that would be a better place to put the new
> entry.

I think this needs a better explanation.  Something like:

In xfs_da3_path_shift() blk can be assigned to state->path.blk[-1] if
state->path.active is 1 (which is a valid state) when it tries to add an
entry > to a single dir leaf block and then to shift forward to see if
there's a sibling block that would be a better place to put the new
entry.  This causes a KASAN warning given negative array indices are
undefined behavior in C.  In practice the warning is entirely harmless
given that blk is never dereference in this case, but it is still better
to fix up the warning and slightly improve the code.
