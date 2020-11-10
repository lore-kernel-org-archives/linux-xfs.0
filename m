Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F38C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AA420797
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PRJgtR4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgKJShb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgKJShb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:37:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1EDC0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YYTXwqqrL8qELlCOEtPt2zWCCq/WmuhhZWFLv21O5mU=; b=PRJgtR4QAcOtBk0dZHTrTGM/ur
        IYm/7OtFP744Xc5YOcB4oIUvdY+TrnFqAIFLSej76uuzwmcIYAqRGIQAfab1oTaTeWn/GNiCBEoLz
        6sH2cDKhcyY6qka2bcny8w02nDoRZEmKdXP3MNWPcszB6u4u0JJaMQTzq4NGaXv4srqOG3Ptr3Okq
        O0PynUgGOm+WGtEBEWNF6aa6ZbJagD0kGDS4um2s3CZCNapCKr1HVydUfZwrJyau5MLeGHwe7hxd7
        yT63M0zI5E5EYo+8pxGb8J4mSpK1gj1dmgMACAU0S0OUipbILfFq/UNR6pffgAR4Ny/WhuDtY/gdW
        /3c6/bag==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYWG-0002gk-BE; Tue, 10 Nov 2020 18:37:28 +0000
Date:   Tue, 10 Nov 2020 18:37:28 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_repair: directly compare refcount records
Message-ID: <20201110183728.GH9418@infradead.org>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
 <160503143411.1201232.10096865635977108103.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160503143411.1201232.10096865635977108103.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 10:03:54AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check that our observed refcount records have exact matches for what's
> in the ondisk refcount btree, since they're supposed to match exactly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
