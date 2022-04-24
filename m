Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DE3C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbiDXFc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238314AbiDXFcv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:32:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF5532C1
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XFn34BcWBhLOeic5QbAziwh4JJ
        QFzcIOEIf+R24hpH5pwoUs/DmUNWWArBrO6smzFyw4Pzlbm2pc/JId3Zm3RLfoRaty/3DFjDAk10Z
        DGqxWw6ly6+z6lhZtA0FZ8E9WPChKh2f6UbJfNXZ0RgBpX+vDT8GUFf+l5tDkh3lz9AKuQEe4a9ON
        RH3UU5EoG7bNEE7f6AoEueGCwX2CkGknqaZ3M+ItAcnBYGkDyK14UgyD9sbgKVzahJz2ipx4NlEeJ
        XD+Memf5rrJAXPtM8kdu/xK+8h4DSzpNshFjELw98JAZGhuypCEFc/ggFyU7JUrywhVoZsewrNA4j
        5fHtSDag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niUoh-005qCF-To; Sun, 24 Apr 2022 05:29:51 +0000
Date:   Sat, 23 Apr 2022 22:29:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] xfs_quota: apply -L/-U range limits in
 uid/gid/pid loops
Message-ID: <YmTgT69ebxhgKZxN@infradead.org>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-6-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-6-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
