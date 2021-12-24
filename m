Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A62C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 06:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351651AbhLXG5s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 01:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351656AbhLXG5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 01:57:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601F2C061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 22:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=yaz+Jp2H6OcGMqbViZimWLf4Di
        lIOdjWNIz+oPnbkLHL/pxN88ZTC3Any0S3cTPEngz5J116PK2EIZWbjrZ7c+0f2FDf5+YMJWnOwer
        ZAXr1VVtLzEhqzqz3S1RrtsFRU9e2r5ocAJ3LzEszZ9BBakv4vbwn0LtPiN4NuVbfsx4uuzrB7oQu
        AVGrJzcYMeoV6l4Y3f6MRdEMoNEabvruL53kS4WmRnD/EMUg8FE0hGvBAh8+hfBuymsWviDhZf6kE
        R9IvuAzah2xIE/QHIUQpa12fFVNymWyhos067qw4wa3DpEz6e7/cY9xtU5JaC13/WyZ/Cow3U2ESs
        If/V3zAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0eWR-00DpDa-2L; Fri, 24 Dec 2021 06:57:47 +0000
Date:   Thu, 23 Dec 2021 22:57:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Fwd: [PATCH] xfs_quota: Support XFS_GETNEXTQUOTA in range calls
Message-ID: <YcVvay+SkFYLUDtf@infradead.org>
References: <20211209123934.736295-1-arekm@maven.pl>
 <fbd06eb0-5d01-a01b-fb5a-af1f8a1ba053@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbd06eb0-5d01-a01b-fb5a-af1f8a1ba053@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
