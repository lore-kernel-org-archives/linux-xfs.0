Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6418DC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDKE7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKE7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:59:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFAC173E
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XK1/gKP8QamTS+5l74bz/LP5oQ
        MhvqQYHpIEhaKmnpyYwZBdGaV38X/VlGrNpmb4vvEeSSJ7gEj4geSSGFrsU16O0mW6CLieSQz0I+F
        pXbzAGo2VBiJhCd85L49nN0De70hDOhRwNi/c6icadd/Vg0Xwl++sQzTroAzqFErGK2cRDdbpdbT3
        zr8n/YRzSfCp4hZx1fx/TSziOfG0SFDePg5z1/z3qCfdpK66Ci/h3/DkLs40OWv7XLybW+HT65Zbv
        2KxZPU03NJvzCGgzlYxCVwRzTXZjgefsViGFV4/tq8SIewewH81bktC398JW7lgGpZH1KavSpsUdj
        m1Fd3jng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm667-00GQP9-2e;
        Tue, 11 Apr 2023 04:59:15 +0000
Date:   Mon, 10 Apr 2023 21:59:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 6/6] mkfs: deprecate the ascii-ci feature
Message-ID: <ZDTpI3iL16SpBgk6@infradead.org>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
 <168073980709.1656666.3199846607416694974.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073980709.1656666.3199846607416694974.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
