Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD3FC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 05:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiGTFDT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 01:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGTFDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 01:03:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CAD69F1B;
        Tue, 19 Jul 2022 22:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RyhzVxMbaoPbL9A0bk3Afb4Ipszyt1fT4jChXme2gxQ=; b=KsBZ6uQJI0GUCu2vNLPOIKty/E
        Lw2T9B64G6PgVBoSaxdWVIPkaFMCo4m/bG1Ci+rki3dItqIevm/5AEdtFr99wOyOt02J+ygGCNNQ+
        E1QtxkZ1Hr4jeZBWXn7WNZR/fGDGrzqGKA1YnYTRvR4jK+sUVS/ClKSNxvV3mWpDhD+yjT3t6wAS8
        y6rv0cNaNgDEnesPoSp0fJZnP5zZ6CtqObut17EQHDARHoVl5P5lFsJQD63ueLWd8gkJV6ikWXh1M
        19ACAdzoCxFk8w2iCg8ToWtdIKPUnte1X8Nq6X3oBviEn0eJHXIxsoi+pO3R7QhKhSIZlI02c1J0z
        J/IDJNeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oE1rf-000N1j-Da; Wed, 20 Jul 2022 05:03:15 +0000
Date:   Tue, 19 Jul 2022 22:03:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 0/8] make statx() return DIO alignment information
Message-ID: <YteMkySHHFOTKSAW@infradead.org>
References: <20220616201506.124209-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616201506.124209-1-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

can you resend the series based on the received feedback?
