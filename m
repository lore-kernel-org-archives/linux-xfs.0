Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB12C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4427B2184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I3W+yU3e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgEIRKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:10:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5D3C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7PO85y6eNg3Y59abtL4IQkfk3A/RQC1CnlCEPiOLXCI=; b=I3W+yU3eTo6hmD54lx7Vb7Zqe6
        kwsdRBh9686fpbhNxtOl7AJh43sPQaIVlhUwwnumNi/No7poy7x7vzOiAP0hRUwK/oTFrm9LA4UmW
        ObGv/iQkCgcVWidsxCrpCkdNWxbaUVVTkTEGqe7e2vX0bCIX6VFOTt3VWQRzl9e26MNSgZ9h8nGYi
        VXxJuzOKVAa3vYqiLl6vRHpl9RqkfQ7MAkpeb23yPRGNQKn/VJ6jBP730Z16rLnpc+vKm9tECaEi0
        zxYeEwU7G03GrxUn2x1qlNT9hJr2yj3tSXHYrSpfsBxsVwXD8jgT8COBZORFmtL6N3MZqrkNZhxAZ
        5Ssr61qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSzr-0003PU-O3; Sat, 09 May 2020 17:10:43 +0000
Date:   Sat, 9 May 2020 10:10:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs_repair: fix bnobt and refcountbt record order
 checks
Message-ID: <20200509171043.GD12777@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904181736.982941.3404117959961230293.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904181736.982941.3404117959961230293.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The bnobt and refcountbt scanners attempt to check that records are in
> the correct order.  However, the lastblock variable in both functions
> ought to be set to the end of the previous record (instead of the start)
> because otherwise we fail to catch overlapping records, which are not
> allowed in either btree type.
> 
> Found by running xfs/410 with recs[1].blockcount = middlebit.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
