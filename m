Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD9BC43461
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80613207DE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 20:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GIJMpbt7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgIHUHn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730294AbgIHPTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:19:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B39C08C5E7
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 08:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wMtWx4o0d3mwGV+qrcmR4jCbx4hGH63OAon/bPwkpbA=; b=GIJMpbt76RYg1HV9SH96oMXUWB
        l0ANtNo8MYzd8mhrG174rn+d1YWXoeYsWrfuuQOi32OMahwLtUe++Yz5gRKab0FZa3JBW+MCO7Ajx
        3jj2RY/VjlMW3L5U2FuUuDcq8rEpQlb6iyQrCplUOMyfPMXSn+NCG0HsXlwt6Zmb4cUtc8FDZ9rk+
        k2vDlpg7jCT7WDt9zDfLeezF2O87gXLCfs+p6z19rpJZbuqpiQB4nICBTHf982nImIgvogbjVUzdc
        WZMVLK1TI1kpm0gXObpXWSdkBeAMRLR01wcPFazmjb0Cg/An3Kr2lFXsaqLh/7r27TFj9ZdqHwW4B
        MNCEDweQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFfLC-0004Ga-GH; Tue, 08 Sep 2020 15:15:26 +0000
Date:   Tue, 8 Sep 2020 16:15:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_repair: throw away totally bad clusters
Message-ID: <20200908151526.GA15797@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950115513.567790.16525509399719506379.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950115513.567790.16525509399719506379.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:52:35AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the filesystem supports sparse inodes, we detect that an entire
> cluster buffer has no detectable inodes at all, and we can easily mark
> that part of the inode chunk sparse, just drop the cluster buffer and
> forget about it.  This makes repair less likely to go to great lengths
> to try to save something that's totally unsalvageable.
> 
> This manifested in recs[2].free=zeroes in xfs/364, wherein the root
> directory claimed to own block X and the inobt also claimed that X was
> inodes; repair tried to create rmaps for both owners, and then the whole
> mess blew up because the rmap code aborts on those kinds of anomalies.

How is the rmap.c chunk related to this?  The dino_chunks.c part looks
fine, and the rmap.c at least not bad, but I don't understand how it
fits here.
