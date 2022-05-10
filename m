Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2301CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 12:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240098AbiEJMwN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 08:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiEJMwN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:52:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C4511E1F2
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AAkN8jpgkZerzvroCcuoaokvXi
        jguNqdeAdB4kijo7mVWB44oNJenc3NLsTtcA5VI+T7EDIlUs7+pmZTkvXEy7c4oy/uj1biVTGezEj
        TJyEJ7x2DiWXnxHDHQl57/Brxz+ald1GlD4UgD6OV/xB80pc0wRG0ZKCDlUXutU07kmKf5BITtvea
        H2WNsJa+OMMTPdW3IVLLuVSz+e7dUzbhBCFRZVrv0M5udYypBYX/hh8BDLXW/7jsAPeZ+J3cK6ttk
        qLXjELKLRXLZNdEYEidAGWqeelZL+ybvTxRfWXxIh8AVzOiHuAjAsdfITkIpbaQiLK8u1n5kxysLu
        OktkPJTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPHk-001zwc-3a; Tue, 10 May 2022 12:48:16 +0000
Date:   Tue, 10 May 2022 05:48:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: fix potential log item leak
Message-ID: <YnpfEHfCigea4LSX@infradead.org>
References: <20220503221728.185449-1-david@fromorbit.com>
 <20220503221728.185449-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503221728.185449-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
