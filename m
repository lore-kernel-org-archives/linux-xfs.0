Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5DCC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiF2H0q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiF2H0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:26:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2944819009
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uTmVfTj+8Wbks0df9f+hiSq69A
        ZueUC+6V3EVgTDEIaLg4zXzKDPUAxwZLc5Z7vjWc/Uwv+03o1zONWDlY8dtJ/f4Tt8Rxqt3ayM+lX
        tUuEZiBeMMS8Mu0NHEkMe730EbYdBSOU6Gyi/+XoEvhh35K9ggSpdJUC45aB9zDY8qQSnc/PxsCJn
        UUas9fa1LUQZJIvOY6/159cCyoLCScsai2W7f9druUIr72M9OUI8N+E+PX0jfzfXKr/FP0Lkw156A
        jPBG1GVCno5yQCY7VXgDoliXVVIjt+LXwO6lqyoFhs8VclEc3IHQqLtpyzLqa9d64Agqkh+idYjQ0
        v2FZGSyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6S5w-00A5ix-LB; Wed, 29 Jun 2022 07:26:40 +0000
Date:   Wed, 29 Jun 2022 00:26:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Subject: Re: [PATCH 3/3] xfs: dont treat rt extents beyond EOF as eofblocks
 to be cleared
Message-ID: <Yrv+sFDqwvyCRsC6@infradead.org>
References: <165636572124.355536.216420713221853575.stgit@magnolia>
 <165636573821.355536.976591440534807402.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165636573821.355536.976591440534807402.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
