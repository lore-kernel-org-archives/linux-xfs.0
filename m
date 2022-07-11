Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7B7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGKFST (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKFSS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:18:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807181903E
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1ohBGTCfU0MQ7d+rvf+5RDPCIs
        Q+WSe03Zddyu7f71xbjTyYD1AfEQ0QOHIX55Rd0IBfT8x1z6ndkcjOKU9Qal3Ye53rmFxaifB1eVx
        S7AsU04X5qcwVaeWNYeykwF8+h1nGTM8ppsh+M55lkCxRDOj58UfL0bzE1JxP+UT+5JfgIiXkBVew
        TSFbqHN26DZmiVxAuDF+efMfJ5DCKzc5Y+s/aSyQGB7lQodfMZ0bapRqKOPoCQre5Mm7Ifh+w22im
        G7vQ5DdrXoeG+sCg3Qzi19gENDA60dF7flz973HIoyRu2BxnUPepe34kOcqAYqmnOUDFNDtmp+bW0
        O1ztEMNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAloI-00G5TP-6n; Mon, 11 Jul 2022 05:18:18 +0000
Date:   Sun, 10 Jul 2022 22:18:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: introduce xfs_iunlink_lookup
Message-ID: <YsuymvWCU2MLMReq@infradead.org>
References: <20220707234345.1097095-1-david@fromorbit.com>
 <20220707234345.1097095-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707234345.1097095-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
