Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D124FC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 05:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiDAFxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 01:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245216AbiDAFxV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 01:53:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C17153E02
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 22:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=IZRtq7wzPNw2K+hXrHacWwXQVk
        NwC9AUoKH09dEfC+4AHU8s91AgQDqcUJwivKLelbUyCLGS8tRTtok2LvOXH1aElBeA7g2vfxnJ+Mr
        arpbSUeYZ6pyLB4ZtZyBqCKN7lTcetHJbOB43yYS0/I12AK2c+smfXjXOX7kXbyjkAoGmuwtfN0XC
        bKOTs6YQW693g7Be+KryJAEowIS5QfaxH7rwhhkmHCc6eL04qAoZNOi65Q/+bENjFQXwE4jWQAlcE
        Wkr3L+GBFPxbNtap2xsFbzL1UuJ5CCSjDDMkc1p2MrobP5mbJz714b+Hso3oX+GYnozG4rZy1Ul/a
        11LPcOPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naAC3-004bDb-Uf; Fri, 01 Apr 2022 05:51:31 +0000
Date:   Thu, 31 Mar 2022 22:51:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Subject: Re: [PATCH 1/6] xfs: document the XFS_ALLOC_AGFL_RESERVE constant
Message-ID: <YkaS43tTmf8gUYrp@infradead.org>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840030231.54920.7952660071015931236.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840030231.54920.7952660071015931236.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
