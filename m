Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB980C25B0C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 12:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbiHKMra (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 08:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbiHKMr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 08:47:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031082558F
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 05:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5x15X1FHhO3htGarNFH/34oD1dQcuOw/kuCr3YRUSLs=; b=UqwnMBgDoC0dsUJDLkjNfWj7+k
        g3jt9Jpd3dRj+hiWsiRiOlj8DGO1kaPo5+02mJcTmoIRljjgWGK3mjWKVJqa6LjOwbQ914y648sfq
        8E8NKEZPqu0WkA6j3lNDwob1nd5Mbz4onmazybgPlfoyQ7VTPC/AYhGgWVIF98LUeY6G64GpknO0c
        hjglHzxb8VuiEJwLCIfNr0nel67BUyQrHPdWbY+CUMcCMOi1Ea6UGJZe8+JBorc4+/VPoA6ZxEoDL
        9+r5V5cXut+yEAoJPKqEz6ZZ9k7Uk/pd2Pe8AtvjC1B0CfzJ5rc1SPHpu+FTshDivSZp6xgS4cBcm
        s8LpAwow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oM7aw-00CHQ9-K1; Thu, 11 Aug 2022 12:47:26 +0000
Date:   Thu, 11 Aug 2022 05:47:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: retain superblock buffer to avoid write
 hook deadlock
Message-ID: <YvT6XjTWPKfsPbI7@infradead.org>
References: <166007920625.3294543.10714247329798384513.stgit@magnolia>
 <166007921743.3294543.7334567013352169774.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166007921743.3294543.7334567013352169774.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maybe we just simply need to set NEEDSREPAIR for any run that does
not specify the no-modify flag and avoid this magic lazy behavior?

That being said the code looks sane if we can't fix this better by
just working differently.
