Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48E7C761A6
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F8E52070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QF4PR8Tt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgBQNiV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:38:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgBQNiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:38:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c2oMipmbYf8WFl65armfFuM95ErhFnG3KT69bl/6lUk=; b=QF4PR8TtkQ4+Yz2dnu4ah9h+nk
        b5YDRT1pIjFG1qoWhPngYlliqhn4lGz4Bg6ZaFiXDQv197+07PjsKyHMsnUnZZm+nQlGAhIJYsCmE
        QiWJxYGJLIu63nu1oi/XnPROd51J6NeDhIL1JBsJo0c2Brl8pU9eFYbGuZz+uBc6J37Mqwhk30Hcv
        qaaT44ImKeAcAtj/3IGJoxSyAAQcqwA1mQzUEpPBAx0+ANROAxtCia1gzGLytkoae2L3kwYA4Hw+7
        lRMFqsdCUi4Dv/yQuNTl0n6vb65u8lXZxNiZgvZvtu7CYm890Cc89gp/TNQ2pseKa0r+U7DmWkPJn
        oY6PRbuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gbN-0002bV-0T; Mon, 17 Feb 2020 13:38:21 +0000
Date:   Mon, 17 Feb 2020 05:38:20 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] xfs: simplify args to xfs_get_defquota
Message-ID: <20200217133820.GG31012@infradead.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <26218bfd-b003-c1fc-3ea3-e53d9c35187d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26218bfd-b003-c1fc-3ea3-e53d9c35187d@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_disk_dquot	*d = &dq->q_core;
>  	struct xfs_def_quota	*defq;
>  	int			prealloc = 0;
>  
>  	ASSERT(d->d_id);
> -	defq = xfs_get_defquota(dq, q);
> +	defq = xfs_get_defquota(dq);

Move this up to the declaration line while you're at it?

>  {
>  	struct xfs_dquot	*dqp;
>  	struct xfs_def_quota	*defq;
> @@ -554,7 +553,7 @@ xfs_qm_set_defquota(
>  		return;
>  
>  	ddqp = &dqp->q_core;
> -	defq = xfs_get_defquota(dqp, qinf);
> +	defq = xfs_get_defquota(dqp);

Same here.

> @@ -585,13 +585,12 @@ xfs_trans_dqresv(
>  	xfs_qwarncnt_t		warnlimit;
>  	xfs_qcnt_t		total_count;
>  	xfs_qcnt_t		*resbcountp;
> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
>  
>  
>  	xfs_dqlock(dqp);
>  
> -	defq = xfs_get_defquota(dqp, q);
> +	defq = xfs_get_defquota(dqp);

And here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
