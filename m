Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E536EC54FB9
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 04:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjKUEfl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 23:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKUEfk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 23:35:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A4810F;
        Mon, 20 Nov 2023 20:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=my+4MPCmPa79GC+oEhbXaAuFHF
        btphRb0tIE2/5rkxgY/f7yZjd5FKP41zLOeOHeZN+RgnwJiufKtUEXcefHAX2AE+4ECIbvd+2CbIS
        eZ6zTX612OU+JQ5Dyk9hnM217nFj5+7DsJEWsE7hhprJ5dFghqwWjp74jpg2Ml0fV3gaBIgyrMNuL
        syOvhoo0j4ERqUU1F2p+ChO47f9WCjaTJzuTzkxVMphTNx+AkXHwvNHXHIWjyhLOsDbRaBDstzxYA
        lp+tn6p1Ijp2vRWZgwXRzScd+kOisXdM8rxT0PfNcMUC2BVpcmFYRPt4+Y162Lw+E3oXNUIHItLcH
        ZPsaR6xQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r5IU4-00FbHJ-2B;
        Tue, 21 Nov 2023 04:35:36 +0000
Date:   Mon, 20 Nov 2023 20:35:36 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/604: add missing falloc test
Message-ID: <ZVwzmP3WJr+M35k1@infradead.org>
References: <170050890870.536459.4420904342934916414.stgit@frogsfrogsfrogs>
 <170050892015.536459.5750821914760062267.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170050892015.536459.5750821914760062267.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
