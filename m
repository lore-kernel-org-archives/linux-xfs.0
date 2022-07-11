Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B5FC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 06:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGKGH5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 02:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKGH5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 02:07:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3D818E17
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 23:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=adCyGc1dl0ykLvZuRq0DjapJUMiSOh80xnPS5PEJmpA=; b=NNCNN1/V3hCFI1dJjl3l8sNN/0
        cZIDTqkIOZ9YH6BvfHVb5saPEaXtTz9gdjU6WI6T6rNXzlQXixulo+/ByxjxznW/Ip+U4XLClCFM7
        EpAO2O2WYMANoW+zbzJDObtcy4gDCXTKbOyisoY8hF9WtS93mNOc/EVZbmDQ+qwUeniqqV6Q4TL8C
        otEXcqlMLHNc58QtQW2HKbl+DFYE4roueq62Dn8HHvJ5dWawqeoASnrqIuLDX4gh9I801+b8qAs1z
        1bNuSiOOvkzI0GwzxpJsKk1+IdwPy1VYYDj+BoZ6boeF3u7u0eem7QLWtV0q7On0kyrS3SsGrxF3s
        M9dDtbbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAmaK-00GK8C-93; Mon, 11 Jul 2022 06:07:56 +0000
Date:   Sun, 10 Jul 2022 23:07:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: ensure log tail is always up to date
Message-ID: <Ysu+PPbq41DKByAw@infradead.org>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:55:53AM +1000, Dave Chinner wrote:
>  	lockdep_assert_held(&log->l_icloglock);
> @@ -544,7 +543,7 @@ xlog_state_release_iclog(
>  	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
>  	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
>  	    !iclog->ic_header.h_tail_lsn) {
> -		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> +		xfs_lsn_t tail_lsn = atomic64_read(&log->l_tail_lsn);
>  		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);

Nit: I'd just do this as:

		iclog->ic_header.h_tail_lsn =
			cpu_to_be64(atomic64_read(&log->l_tail_lsn));

> +/*
> + * Callers should pass the the original tail lsn so that we can detect if the
> + * tail has moved as a result of the operation that was performed. If the caller
> + * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
> + * "did the tail LSN change?" checks.
> + */

Should we also document the old_lsn == 0 case here?
