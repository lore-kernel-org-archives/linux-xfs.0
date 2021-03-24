Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6060C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E10D61A1B
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhCXSGy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237258AbhCXSGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 14:06:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3D5C061763;
        Wed, 24 Mar 2021 11:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KNO0RhLY2n/PqZbR3V4lvT7S2rLX10DewvwvQZI+8A8=; b=ZJysItIO2Cv5DSBeW7/OFrKVTu
        Mf8GoD2/j5sH0P7mMv0zLHZIYAGZjH9fwzf5Yo6SMrHrw4FLkQP5mah82R3406xQjSI1iG4KTR9wj
        Sd/L0IjDYYG9RGc7J18im6b2h2Ilhm3TRROym615PiefVxmvDsyMDTt2txTtk2rBi63OtodMJVlDA
        rssrIlishVdMfQWLECzAtDfkp1LeDUXuXBtkf5cswAagQe+lTOCNbPKKN6KfvrnGBeQdCeOonzSK1
        LFzOrFDsKQDjIdvJ2MppjWeOzyf3KGjUiqahXw8/1748N1LrMFC7hTZV5x35ASkJKGsr3S7O8EkFb
        7I0y7ZzQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lP7sx-00Bfey-EZ; Wed, 24 Mar 2021 18:05:49 +0000
Date:   Wed, 24 Mar 2021 18:05:39 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] common/populate: create fifos when pre-populating
 filesystems
Message-ID: <20210324180539.GB2779737@infradead.org>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
 <161647319358.3429609.6818899550213439595.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647319358.3429609.6818899550213439595.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:19:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create fifos when populating the scratch filesystem for completeness.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
