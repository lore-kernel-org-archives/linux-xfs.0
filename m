Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFEBC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 08:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiEXIQF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 04:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiEXIP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 04:15:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75637A83B
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 01:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wXDipKshhJtY7SwUVLpstUChxt
        y9neO60XqoIx0f8d/DoLVc34+0TNodIhLkCPg8lXnIo/HTfXb53NZybtfQumtEFfl4LApMN0bSK23
        /L6jOzr2ELA+24iDm/EtT57uCgHZd7g7hhtlwfcqvu5eNURoblWmnx6W40rISm6NgbKLGZY9ER4sh
        6UAqOTZqlLj5u36PhQg3H9MgmdXGTP8D1xtG2bGQ4S5dtVcZsnw9dGbaKu142W7vGzEVoZKcyvsQS
        Pr83F76KOl8piDkp2n7KrFi9MqAmzOEgh4gNjKMOreSoQqqetLt8lYFqR0Ldo1M6oeDxEQb9IbTeV
        mYkYFZhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntPhr-007Dc9-C9; Tue, 24 May 2022 08:15:55 +0000
Date:   Tue, 24 May 2022 01:15:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Subject: Re: [PATCH 2/2] xfs: don't leak btree cursor when insrec fails after
 a split
Message-ID: <YoyUO8k4tzt50x32@infradead.org>
References: <165337056527.993079.1232300816023906959.stgit@magnolia>
 <165337057655.993079.5617036894740543906.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337057655.993079.5617036894740543906.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
