Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A9CC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 16:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E2D206B7
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 16:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZitOErWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393434AbgFSQuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 12:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387909AbgFSOir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 10:38:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E365C06174E
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2020 07:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2OEfwnCrJIPg1QpQKfmHfkzg+qZjNDZh72BKoIM9y3s=; b=ZitOErWS+utxrFXH4UPSynGJaj
        hNJyUCPH+0PktltFLGPSjeKqkHqNfdwwqVOuydKBBOWezRt293TINgr2JuSXpOZ52cM7u357IOSrc
        WdVBewaCsMJ5X2ixcJKXbC++aghngnx4ZfWBCup6pRzj+uwHZxg5GczThoPowh4YWKRxhy74EIFad
        Jf/bvRwxIkPiApaFEoSWLpu9/2+ZvYyHtYvBrXB1+2KIjVqjf6a+R985DUVlWJHY6HjJjHUvcuFlh
        vW11gL8KcKGchhFVaAZV+LZmKrg94CZBRQ6NbXO7RTlNVhPcOAGyXSuwZwZjWdpg1hC+0lJ7ny1Jg
        VP53uvdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmIAI-0002sK-Ck; Fri, 19 Jun 2020 14:38:46 +0000
Date:   Fri, 19 Jun 2020 07:38:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org
Subject: Re: [PATCH 6/7] xfs: Extend data extent counter to 47 bits
Message-ID: <20200619143846.GC29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-7-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:44PM +0530, Chandan Babu R wrote:
> This commit extends the per-inode data extent counter to 47 bits. The
> length of 47-bits was chosen because,
> Maximum file size = 2^63.
> Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.

What is the use case for a large nuber of extents?  I'm not sure why
we'd want to bother, but if there is a good reason it really should
be documented here.

