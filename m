Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDDDC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDKEwt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjDKEwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:52:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1018F1BC7
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=12G8nPez26vfqZBQZZWk5ZKG60
        A34rnj8vyKVPhn2Ts5Z9zA+6L/L7uyop8F7SP9lub1AHtEm17v2AmpzIuNX5j8m7GguSFRSNuro+9
        gJM+xn0hsYF8B+p4FX7d7khgXnM7arZQeRzSAIDwwPcW5EA1mIYFI1ZDlwIUEYhWcH87cbAtakuyt
        ClMMWfpvm3A3jxHV5l0B0B53kKL8sEB36kDoIHzCHuXO17ulvDPwe3hEZboApZqzCq+/kfmyLCt+B
        91uInXSQuOVBYqCLbO1djlSNpG3Sk0fXSFUGyzBQ7QUoeGgfir0PRLITuJ2zxn79vZyVlYOQSXV8x
        M7noy35Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm5zm-00GPks-33;
        Tue, 11 Apr 2023 04:52:42 +0000
Date:   Mon, 10 Apr 2023 21:52:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/6] xfs_db: move obfuscate_name assertion to callers
Message-ID: <ZDTnmoGdSajRSgIP@infradead.org>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
 <168073979023.1656666.15017884571352314641.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073979023.1656666.15017884571352314641.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
