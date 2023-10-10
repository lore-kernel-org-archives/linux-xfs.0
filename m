Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F19CD68F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442389AbjJJHDp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 03:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442368AbjJJHDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 03:03:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4EF9E;
        Tue, 10 Oct 2023 00:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Zim/nQTd5/jXaWGyB0x1r4t/sw
        C0E1JR7nEt8kIxjrJ91Z0kx9mGOADFFLqP4ot1rebw1fZv0i8Hs/EPQhJN1hzeo4rkOOlsmN33bJT
        fCfYITESgQM0pHOe9XxrnoUGIkXJpVMy89lGuBGoqn8mMaDmjapKNZ0dhncZH6pCqiga4yv9a2HAV
        I3fxngepnWx31BkGH4A1XIgm96QNxfU9q4grDeoQDlHWt9PPwsZg07cZVhKd3VW1g2PGzK1JnEHFI
        hPeXePxj7BUA+M0rzVjSn2aDKHLaHfdCrXuCgVqV13dws7YUOZXmf/OLGlYaTVzGad9ONVrOVuN5l
        L5T/YbVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq6mM-00CfTC-1P;
        Tue, 10 Oct 2023 07:03:42 +0000
Date:   Tue, 10 Oct 2023 00:03:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] generic/269,xfs/051: don't drop fsstress failures to
 stdout
Message-ID: <ZST3TrZQPIMEwicr@infradead.org>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687552545.3948976.16961989033707045098.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169687552545.3948976.16961989033707045098.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
