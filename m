Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD8AC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD503233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rtEMctuX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfH2ISX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:18:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2ISX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yxk7Hm7VBdGk33Z2KfWWbKixCb3a+8Q/S5p20+k3o+k=; b=rtEMctuXMwGPxK5fNSb82l5W1
        NCpr1JtRi80xKGJvqfx98DfLNxQVDiaFQX01vZdKqnFC99K0Qo9gkeat065ctIR/sARWXgApZu/XA
        uJorRlQmSzq1+94QGsD3ELuwUzCyeaUX2pmyDNi/tb7stB3LHoR59tvFNp1z27VmfrQr9qegTJTCb
        q01wF53mm7TVf0G/GQn9aX/vnT+8/UkkqRz/pEXrNU8eLgFwBHmi9lpaE20viqYsNU7sOzcFOPqnJ
        JklQvLA26IYEc9WYrEUyWTXJYZQX/igD8UMMaGlDHRRikzXBk5RYb6CpCs7Gsn7diB66eFXS3GZL1
        znIfVnmJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3FdO-0003Ug-Qj; Thu, 29 Aug 2019 08:18:22 +0000
Date:   Thu, 29 Aug 2019 01:18:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190829081822.GD18195@infradead.org>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829063042.22902-5-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 04:30:41PM +1000, Dave Chinner wrote:
> +		bests = dp->d_ops->free_bests_p(free);
> +		dp->d_ops->free_hdr_from_disk(&freehdr, free);
>  		if (findex >= 0) {
>  			/* caller already found the freespace for us. */
> -			bests = dp->d_ops->free_bests_p(free);
> -			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> -

I don't see any way how this is needed or helpful with this patch,
we are just going to ovewrite bests and freehdr before even looking
at them if the branch is not taken.

>  			ASSERT(findex < freehdr.nvalid);
>  			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
>  			ASSERT(be16_to_cpu(bests[findex]) >= length);
>  			dbno = freehdr.firstdb + findex;
> -			goto out;
> +			goto found_block;

The label rename while more descriptive also seems entirely unrelated.

> +		findex = 0;
> +		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
>  		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +
> +		/* Scan the free entry array for a large enough free space. */
> +		do {
> +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> +			    be16_to_cpu(bests[findex]) >= length) {
> +				dbno = freehdr.firstdb + findex;
> +				goto found_block;
>  			}
> +		} while (++findex < freehdr.nvalid);

Nit: wou;dn't this be better written as a for loop also taking the
initialization of findex into the loop?

Otherwise this looks good.  I always like it when a speedup removes
code..
