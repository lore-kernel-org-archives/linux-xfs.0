Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EA6C32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 05:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjARFns (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 00:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjARFnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 00:43:46 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C620A54105;
        Tue, 17 Jan 2023 21:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=if5gIiDr8spIFcbOUMMGthZlwk
        RutvIbHf8b5ccnlxeY6C/oq/PH0AzVl7WKcuZIkra2pqcfyqkjIifd4deVlBoT8+0UTs483V9+Oyr
        0wk4d7OdK8ezaZksb1tckBhGB8TAeFIMsrMvs8MREZ6F1v6OmwDCv43YguFKq1hChCgQ/2r64w++S
        NIsNUj70PLbUHhvOyw0z0Tin3Fn93I5abgOaVOuGWn0CX9Yjv/i1S9sbNU//xVRuIP8uOHXnF/S4k
        Swwhm+bj/FAnUopEfNEQlWEh5gIjowPTCP2SMkUn8UAAlrLOAOnfeTpm0/yZe6ZUZ2f2xPttWpU1x
        J4E4hqLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pI1Ec-00Gzza-B7; Wed, 18 Jan 2023 05:43:42 +0000
Date:   Tue, 17 Jan 2023 21:43:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] xfs/{080,329,434,436}: add missing check for
 fallocate support
Message-ID: <Y8eHDj6qQtCu9cHJ@infradead.org>
References: <167400102747.1914975.6709564559821901777.stgit@magnolia>
 <167400102773.1914975.13189675469601933878.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167400102773.1914975.13189675469601933878.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
