Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE4AC2D0A7
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D21E207DE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yfy/iNq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbgIHUFr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbgIHPV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:21:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3090CC09B052
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bt8BKokHImzGPQqIVTZT2S6fMTmKwFE0LgMSBLp32EU=; b=Yfy/iNq+iSo7b3s8KxlOz9YBux
        mHdmSFKYJwO/psvxXNzaxIc7cBakYOfO3kelmYKMR6nybREU2Vd/EhSHhAT+t5C8lgCRITE82vE2u
        Cbe1aJn18lsAvu+3dAzarzrg15ofgekDmvHlnZDu0Tt0hSQxPNoInUoGGQjsYxn1HwcerKNLj0Rcd
        /1n15Gu2YLn3fNc8EtNjhOBo23kKgMAXNXJix65fpRKta+HQvkogH5BPzcpaClN2Tf8EgDj7HgR2Q
        3uS1Y67FHNNelVjdi4ko1/jwyMHsRjLytjV1mnd4X1JPJ7ykWCrU+LKL2zMMsMGnwAEoWs6EWXXZn
        mza/EKWA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFeue-0002e9-30; Tue, 08 Sep 2020 14:48:08 +0000
Date:   Tue, 8 Sep 2020 15:47:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs_repair: junk corrupt xattr root blocks
Message-ID: <20200908144759.GH6039@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950113638.567790.12521493655366784663.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950113638.567790.12521493655366784663.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:52:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If reading the root block of an extended attribute structure fails due
> to a corruption error, we should junk the block since we know it's bad.
> There's no point in moving on to the (rather insufficient) checks in the
> attr code.
> 
> Found by fuzzing hdr.freemap[1].base = ones in xfs/400.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
