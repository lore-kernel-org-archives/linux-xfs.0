Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D89C5ACB3
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 04:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjKUEfE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 23:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjKUEfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 23:35:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567C9CF
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 20:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l/uylQuxFlmh0fsQ0f6hRCscp7
        xW1fLGi9gyq5ru3uW0CkKSQQl9XGjFhl7lj+Xnaf2y3/PJ5G2gUQFD0F3ja3isq9LnCBgtbewUQ/2
        obaIJEBxARrKOKX4jXPIOLrJ9vCUWbbnQPpdBCkNpKGhIdhjzkPw/cdWN4kaLn+cIba7dRnu3lkvU
        qcO9Sp1pOmUkGjvU7Wd9tVihaxDHQHArbTj7dw8lZDnI28lHY/rKVjVgcBZty5v83S6DPJnd4WMAn
        A54PyGdTh+xGYFT/mwaIVkQyODLPbbvZOOGQe/rTVdoX7ECclLItAgr3x9fECqvKYAmx5GSLDdhux
        LSHcOdQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r5ITS-00FbBb-27;
        Tue, 21 Nov 2023 04:34:58 +0000
Date:   Mon, 20 Nov 2023 20:34:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, chandanbabu@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: dquot recovery does not validate the recovered
 dquot
Message-ID: <ZVwzcvz7q8bHJO42@infradead.org>
References: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
 <170050510455.475996.9499832219704912265.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170050510455.475996.9499832219704912265.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
