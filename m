Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2043CC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA5DB20663
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kKI6unbD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGOS3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgGOS3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:29:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A261C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GzLDxDaEI1PmOvKz7YgjsM/zMpGm92SqyMMrJ/mTFdM=; b=kKI6unbDYNY89qt2fZtH5BaNOt
        bXKPyoSdezwhI5YjIipyCcSu9F/ocAj1fp60WmK9PzuTqbb4K8xcPSkLZSD/TVxPh34uPreJzw3Cr
        Ax+yFOPpumzV3CiXwsj3wamRHx+M3zdi9BsN3fOiUaCFcTEWU23TcmI1xg+QEFGX56G/5IgZMOwdk
        4ANPD6gDPH3IUJttmIVuP1w4dEcnBnUDPBYpwkDnt+FK+9u5kNIHAEfPlcFA8/esuvzsOmZNZa321
        3gpJ7dGR2fcnWJ6xhQMgADPmcyapjSV6b+ZRoFbbmR05MfbsxoxRqVn01ZAlgGHCmuoXSb3qJBEKu
        9h1TJOnQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvm9w-0005a3-UJ; Wed, 15 Jul 2020 18:29:36 +0000
Date:   Wed, 15 Jul 2020 19:29:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: check quota values if quota was loaded
Message-ID: <20200715182936.GA20231@infradead.org>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
 <159476318590.3156699.15126640025600603984.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159476318590.3156699.15126640025600603984.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 02:46:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the filesystem looks like it had up to date quota information, check
> it against what's in the filesystem and report if we find discrepancies.
> This closes one of the major gaps in corruptions that are detected by
> xfs_check vs. xfs_repair.

This looks pretty good!

Reviewed-by: Christoph Hellwig <hch@lst.de>

One nitpick below:

> +/* Initialize an incore dquot tree. */
> +static struct qc_dquots *
> +qc_dquots_init(
> +	uint16_t		type)
> +{
> +	struct qc_dquots	*dquots;
> +
> +	dquots = calloc(1, sizeof(struct qc_dquots));
> +	if (!dquots)
> +		return NULL;
> +
> +	dquots->type = type;
> +	pthread_mutex_init(&dquots->lock, NULL);
> +	avl64_init_tree(&dquots->tree, &qc_cache_ops);
> +	return dquots;
> +}

I'd name this something will alloc instead of init as it allocates the
qc_dquots structure.
