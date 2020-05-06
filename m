Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98908C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9952073A
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:46:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gCoBDf7i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgEFOq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 10:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgEFOq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 10:46:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76D6C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 07:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gZXC6KW2VDmGE6tsmuxkoYg0PdVMSl1oRf3lTMfzvuY=; b=gCoBDf7iIv8ugkIr0y36cvdfrx
        zX3IWAjP3dVFFntZi9SyTG2VuFUtmM90WlBonadBtHAX/Atblg5qbXmkFleN2W3at/SD+45yJ/vzT
        L8ZRo1CvhvNPa7qmEplAOOVuW2a1c58Y1kXHo10ZyUcve/Odq6cD+qXLmdPUjnNNA3MNTh3qFesrs
        s/HR5m+n2oDJ/4e5swl/t7RD+dd1AVdwF6qwqgU3HnbZBlQSf9ShfptNiWgydTLcNp6FIG8eJrTl5
        /+mHaGNFZU2o9Fm69XDxVwDsZXOZ3+dT3L2DbyhstutO0UlhFIpMcO1pOzscPUATrE8hl54+2cfKx
        bFdSOjjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLJa-0005Z5-MV; Wed, 06 May 2020 14:46:26 +0000
Date:   Wed, 6 May 2020 07:46:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: clean up the error handling in xfs_swap_extents
Message-ID: <20200506144626.GA7864@infradead.org>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
 <158864101600.182577.8313719136212435982.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864101600.182577.8313719136212435982.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:10:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we release resources properly if we cannot clean out the COW
> extents in preparation for an extent swap.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
