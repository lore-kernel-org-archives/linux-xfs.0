Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F65C07E95
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jul 2021 08:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE49461483
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jul 2021 08:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhGDIzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jul 2021 04:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGDIzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jul 2021 04:55:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80321C061762
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jul 2021 01:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w+m2hpVrWf9tXo4r5/ZV/E04llV7eiRkR/vnj2lQeGE=; b=VjwB7a5qR/2VhvkkeH6gfheuaM
        Op7LtqoRiM6MPhQvGXBn96hbY5KmwnTfe7X3rsGj/1/d3T2dm4LGPnFPMaIIMHshNr7dTW82O70IF
        +56iBpnW8bHk3ibAoZlmC2r0a+PWql2QeiSENwpoNyf/KbkznHv1xWxxwVoYk2/HhntEadufkNLml
        G+e3fu209gecxkMp5yfQfGtjTqGmNg543KPqZ8Nlh4mOLLkkfAsapPrzApgoANwZSGc0IXEL4oRQB
        vlAWuu/TbIgXqFkQ2XnI76hg/gW+Bfxe7ZqBoBxGTWQCaJdCpL4/Q9Jb+BPXGfU4rZxIKRJHQsti5
        LzofwOUA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzxqp-009BOF-VX; Sun, 04 Jul 2021 08:52:01 +0000
Date:   Sun, 4 Jul 2021 09:51:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 1/2] xfs_repair: validate alignment of inherited rt
 extent hints
Message-ID: <YOF2n+aIKG/cqhyX@infradead.org>
References: <162528106460.36302.18265535074182102487.stgit@locust>
 <162528107024.36302.9037961042426880362.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528107024.36302.9037961042426880362.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:57:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we encounter a directory that has been configured to pass on an
> extent size hint to a new realtime file and the hint isn't an integer
> multiple of the rt extent size, we should turn off the hint because that
> is a misconfiguration.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/dinode.c |   28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 291c5807..1275c90b 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2178,6 +2178,31 @@ _("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
>  		*dirty = 1;
>  	}
>  }
> +/*
> + * Inode verifiers on older kernels don't check that the extent size hint is an
> + * integer multiple of the rt extent size on a directory with both rtinherit
> + * and extszinherit flags set.  If we encounter a directory that is
> + * misconfigured in this way, or a regular file that inherited a bad hint from
> + * a directory, clear the hint.
> + */
> +static bool
> +zap_bad_rt_extsize_hint(

The name suggests this function does the zapping itself, while it
actually leaves that to the caller.

Oterwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
