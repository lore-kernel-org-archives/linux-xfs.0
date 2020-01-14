Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBBBC33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3B742084D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hpGTw2gl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgANIlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:41:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgANIlo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=hpGTw2glTlODeHOp+JzZVdnAM
        dNv0JZYiXtRYe0Yiw1ikiFrXEHnCR+ezb3HDjHwIt8llB/qroBpK99AH4qWFVjwCw5Hmabqjmfcxg
        KtCCs4BL/O5usbUPqvl9Anu9ISrAVn9hch+eNZy9E1bbXUMoMUQXCezDyWjdyVLDIahSNmniFaCgn
        AJiAnjZYoJtJtiPXyeQENYKtGSgfBd4lu8SweJHTAy95Mv+Mx6FZvtMJmdMpPfsEHCmtlARm30zoi
        CxCVT0f+9dPQSoG+JBEt889Euyas9rpMk9eYicKugnopBqCXKVD2zjVrHCAvKcviog+Yuy8d1eVOx
        rL+Og7Jqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHlg-0000n3-6Z; Tue, 14 Jan 2020 08:41:44 +0000
Date:   Tue, 14 Jan 2020 00:41:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 5/6] xfs: make struct xfs_buf_log_format have a
 consistent size
Message-ID: <20200114084144.GC10888@infradead.org>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
 <157898352339.1566005.1438502032061258214.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157898352339.1566005.1438502032061258214.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
