Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DF3C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E8720790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T9D8yr7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgJ2Jpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgJ2Jpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:45:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F485C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iYMAXx++WYgH1oaB6t9MHjGY2t/pGh9OrW1DWEYBicM=; b=T9D8yr7lyU90AjtEkNR8tJeMOL
        EguUUOQBnNsxjFiczeOtdZrzgqn1xpgs5ysacS3D9YqvgKNbndUj53faybsxLYWsXIXqCvl/KIpXL
        5yHWu3QQWIQN7Ni7XbDg/DlKh5MzgSEKALFc+B1nBd0KZk3K191YeNNJUvHmjbTRgnLloBfL6BdZ/
        0W9Ixb7V2Hr+6j5E6MpwdM8dIvt6mgO8IauAlCdeYEvfI8a9PheRHHhyWolhfFK7tFUii9S0fCTli
        2Mo3kdnmKi5OajxZ2tBlzoDsYFxWNLot4gg612OTBDtdW4g6brG/VLuGSAqI2qi9qb6vSKbtXrjwd
        YLB+0a8Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4VB-0001QK-U4; Thu, 29 Oct 2020 09:45:49 +0000
Date:   Thu, 29 Oct 2020 09:45:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] libfrog: define LIBFROG_BULKSTAT_CHUNKSIZE to
 remove dependence on XFS_INODES_PER_CHUNK
Message-ID: <20201029094549.GH2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375526530.881414.1004347326416234607.stgit@magnolia>
 <20201029094504.GF2091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029094504.GF2091@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 09:45:04AM +0000, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

And no good reason to use struct timespec64 here, right?
