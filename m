Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FD1C83003
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 07:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6FB2083B
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 07:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="scdEtZoh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgD2HSZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 03:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgD2HSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 03:18:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E446CC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 00:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eiTfSDEdfMInK3TVbDXo+TDzhFKe82b7aeNBPDowW+o=; b=scdEtZoh6eXP4By5+u2VpJ2xQe
        w5sUeSMKMJKXUofGmdhrnRk7rIWs+2iYYLMc/+itoAs4qFlAEN2UgTOFlGd1PQBoWGhwRVMsX5jeN
        KfqsoVc3oL7MLt57C51h0KJ10qdxjFrK25zSunGbAowh3OXW//7vDeXi0Tq6C1tu/CbpaNbifGJTA
        NVEWI8vp0p4KE3jtPoPfR1MrKAMTyc0k6nnGk3UlXiU/6+6Fe6mkbOABJ1UO34GdFSJmLb0LzujoY
        b5GZdn6V8EkKCcWVRqLDwLGRMvt1Q+YLoPuBcg0f4ISw5zLMC1zmQY0lWW5Ih3zeEWHXa3MS84w1a
        4ftDdO2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTgzA-0002mN-PW; Wed, 29 Apr 2020 07:18:24 +0000
Date:   Wed, 29 Apr 2020 00:18:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/19] xfs: refactor EFI log item recovery dispatch
Message-ID: <20200429071824.GA9260@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123303.2140829.7801078756588477964.stgit@magnolia>
 <20200425182801.GE16698@infradead.org>
 <20200428224132.GP6742@magnolia>
 <20200428234557.GR6742@magnolia>
 <20200429070916.GA2625@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429070916.GA2625@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 12:09:16AM -0700, Christoph Hellwig wrote:
> Maybe those should move to xfs_item_ops as they operate on a "live"
> xfs_log_item? (they'd need to grow names clearly related to recovery
> of course).  In fact except for slightly different calling convention
> ->cancel_intent already seems to be identical to ->abort_intent in
> xfs_item_ops, so that would be one off the list.

Actually abort_intent is in xfs_defer_op_type, so we can't share it
easily.  But at least in another step we could refactor them to have
the same prototype :)
