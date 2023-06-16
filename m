Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E150EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 07:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjFPHlw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjFPHlv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 03:41:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A67E45
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 00:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8n/uxdhQkHUbDkkWy9pox31TF2CT/xQFmwnCl/tKg2A=; b=uybSABKNaX5pqUJeI/ne9EMqWt
        U+uykLi+l9Zj4emsoxaNVgp0QAZmCFT4Y3hfSBPEoljoXKuA6bXPB092eAjJGS6iBlKS0UlNm89PP
        c922m8WHk7c4nvejKR7Q2BJ47Iufzaw/T42EH0ZvpwHgnBni0QwMZsk+4O30QaCoEzoyyLRYtcdFj
        8gjAZLDid6nVrytRmFxP1b9oa3+MOmtkcALiFYTYq+JfNN43Os7LT34dmJ8kSmWBpgNfyjDQtxywQ
        Yufk59JeWsff5FUfbBowWN7yb9twXlt18f/S0bi9QHVCc98SrJ/frtpJDsQS2bWgtsa3Urj4iBHzH
        lNrAQfJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qA45c-00HBBK-0K;
        Fri, 16 Jun 2023 07:41:48 +0000
Date:   Fri, 16 Jun 2023 00:41:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: AGF length has never been bounds checked
Message-ID: <ZIwSPLeduXQwzmsU@infradead.org>
References: <20230616015906.3813726-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616015906.3813726-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2023 at 11:59:06AM +1000, Dave Chinner wrote:
> +	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum))))

This has a superflous set of braces that can be dropped.

> +	/*
> +	 * during growfs operations, the perag is not fully initialised,

Missing captialization for the first word.  (And yes I noticed this
just moved, but we might as well fix it up while at it).

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
