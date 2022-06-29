Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D626CCA47C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiF2HVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiF2HVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:21:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DA21D0FF
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KukQfUTctUv1/YwJvRLYkKmjzv
        llb1lMoIACamV2XtCixl79OPoJFzu8ldhV+OpIvhFiM+WW+so9e6LfGuLzOdN2vOBYrIqhKDGrbST
        Hr+M5yTSjuCwp5Ksjv/h4kWGGtuhDpgAnr+SSoyjdUnczaB4Ty8c1fZm7kXByVK9OYo07YyLYehGl
        MEdw5TvBJG7B5YOyXY7w5L+DH7bz3uYlVXR5zQw7vhLDf9M7o9B361I32N7D6CbG/8OhnFl16puLd
        LIRWsRWyAHoPKBPTqV34zD58f8vSOF+Tyy9ttNN5pqlahpH9mFD7wDjQqQV1K3yo1ugt3yspM72x2
        piLknXOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6S0c-00A4FD-TO; Wed, 29 Jun 2022 07:21:10 +0000
Date:   Wed, 29 Jun 2022 00:21:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: clean up xfs_iunlink_update_inode()
Message-ID: <Yrv9ZkRt/VokhCCo@infradead.org>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
