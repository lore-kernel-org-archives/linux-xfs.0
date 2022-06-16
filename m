Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92247C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 07:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358952AbiFPHab (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 03:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiFPHa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:30:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453214FC46
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/9neD/QxT8v1vEqPtk6eqVRMJwL7tR5pJIy1pY7Ynl0=; b=aj/bhM5yL4itrxAw0q30LuJm/i
        WHh4FsuLO+Kg96pTOxE3yk2diLxP0N45TzrQQD9AnVRLCF3NfEAcwwqvHIRU1fKn/HG3IlnY0zTTL
        Q1OV8TxN+/g86U0ppXX2mN89fBNHk1DTdErxr/ilp7iWPjLfwPcyFkXR7kEwXAhERtbmz0UVOXwdL
        xG5dpgDojjHoSnFf7Oj2xCpp6hG9Or+j1MHk9n367FrZGycGYu3ifoLhqvwrjNf/b913wWKcHUXgv
        XPPLVwt6b+Bjx7bc6ilovmkx9qyTIvyvkUqNTcdQ6lhCGnOvBOkg5YE3++/p8bgjor7kk4CQuuVpp
        cLhuA57A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1jxU-0013N7-L7; Thu, 16 Jun 2022 07:30:28 +0000
Date:   Thu, 16 Jun 2022 00:30:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/50] xfs: make last AG grow/shrink perag centric
Message-ID: <YqrcFL/N3vq0Z67J@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 11:26:10AM +1000, Dave Chinner wrote:
> +	error = xfs_ialloc_check_shrink(*tpp, pag->pag_agno, agibp, aglen - delta);

Overly long line here.

> +	error = xfs_ialloc_read_agi(pag->pag_mount, NULL, pag->pag_agno, &agi_bp);
>  	if (error)
>  		return error;
> -	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
> +	error = xfs_alloc_read_agf(pag->pag_mount, NULL, pag->pag_agno, 0, &agf_bp);

.. and two more here

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
