Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3175C19F2D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 12:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiHKMcb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 08:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiHKMc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 08:32:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EBEDEC7;
        Thu, 11 Aug 2022 05:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=drojHqukM40qyDmuO+N50P+7yl
        BP8LsLmliSX/NJiZFQgMnbC5HzM4z595TPUyZA5Mr4Pbl1uhU5CU2PBENgx4t8OJA2JHTkg0nTiaW
        bTiVtWzP7Rag2TgHpjXLiJPvAp8Nce4hJ+Qk610RMpbSeVH9iLDSfCpnhf2CgCZKGuu/2h2/BXsEj
        3xJGT9xg3oHlvcfj64xK1bf4cgwU2XMfCbQi1B4bNapEUug3VhHrjaEVI/AyP19z1ptZjf7yybL48
        bD037boRlejhugA1RikdN9RN5ZnPZIgQ7EtTAomPkgNuGX7BWmgP0MqXCsB23fgpN5GblccKnnY+R
        JwIz2uOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oM7MM-00C98q-Oe; Thu, 11 Aug 2022 12:32:22 +0000
Date:   Thu, 11 Aug 2022 05:32:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, tytso@mit.edu,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] common/rc: move XFS-specific parts of
 _scratch_options into common/xfs
Message-ID: <YvT21l+vbZF6loh6@infradead.org>
References: <166007884125.3276300.15348421560641051945.stgit@magnolia>
 <166007885241.3276300.13584305054616588936.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166007885241.3276300.13584305054616588936.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
