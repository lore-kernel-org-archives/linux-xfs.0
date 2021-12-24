Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33BCC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351794AbhLXHTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343514AbhLXHTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:19:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1192C06175D
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=SOIkaeXmKBKrP+j1w5fC8jjk0Y
        E7Io+RMkEbQ748r/YkwKkLCx6987rDgtzoOuZ4m9jIspD6zQ3QCWjYXxRm/y8uHFULIPWqoK/cfja
        mXwI1G/CaSctIqFpLuYzlzEQRD58zqZawF9eIMjFoWtgcCmCkw7Kv2KetbcXl1zAahtm2d/HrImhu
        B7xQtxbq7Jq+fSG7qjLI7U9/ipyMDI8XQzINqKVP/k+De2Eqh5/KvNCWUXR0N/PBEno66FzoB39Ek
        ciK9Smqw2c6q1umMFAKIESYk8l5DeFjJQyDqS758Yzs0LtmmfCIIZmvGRNVk6BUQOlO8Ihxl4OuEG
        bNwcFN0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0epi-00DpxK-Hb; Fri, 24 Dec 2021 07:17:42 +0000
Date:   Thu, 23 Dec 2021 23:17:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: fix quotaoff mutex usage now that we don't
 support disabling it
Message-ID: <YcV0FulARvx2hd/j@infradead.org>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961698300.3129691.4408918955613874796.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961698300.3129691.4408918955613874796.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
