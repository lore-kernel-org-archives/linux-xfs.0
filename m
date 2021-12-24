Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72FCC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241350AbhLXHEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbhLXHEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:04:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D6FC061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=wXma9Ny0yrzbbcd4ETUtiq8F5s
        uz43A6MWLXbZs8l1HjbGXijP7e1u295PHiPCcCh2cdcQeTrdc+SjtC+LIhKN2vtCQu18dFceaVW8F
        uOAYU/svpQPilmCeKO7N1+7gOx3z1HiPFO8rp/omMhYNbpAUB5L8uwClz9k17XmStZlPEI9Fl95p/
        ql+odhZwZg2wS081ihb0+CmrS3vlbU1S6FKcC3O/oCgQpmTbA/NrF9mFV8JOyKdLIPO9cs1XpjE9K
        TfkJJWaK1chVYp9maCH7ok4Y1It/XYZ+E+vqCfmKBC3LqPAaCLtDeKMIotHdCwEnfz/xIn4v43g38
        hfE4kp3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0eca-00DpSy-7e; Fri, 24 Dec 2021 07:04:08 +0000
Date:   Thu, 23 Dec 2021 23:04:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] mkfs: prevent corruption of passed-in suboption
 string values
Message-ID: <YcVw6EmyY89f3npH@infradead.org>
References: <20211218001616.GB27676@magnolia>
 <20211218002010.GT27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218002010.GT27664@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
