Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C04C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 18:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BCE619CE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 18:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhCWSde (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 14:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbhCWSd3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 14:33:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD59C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 11:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yLWfR6PgbSiFVxQMMsfpSa+z0YjYdHLt4utxU4NEb68=; b=eW5xsH2w3CHZJUPSa2A/VHa4Z3
        18g4NNuBIg6DN62GnrgkHOgfwbZQeXG7xVVgGoHdCv4VVbxSSt1IHRIPcet0sMaecE1ZGvkgxtMyc
        hT43tfxAbm0+mCqJVYYFGhmJZCKVTFYY4BESfwFMYxzbhhriqJ31/kFXlqIMeAqcpR4LcMm4M7+mb
        UX1T6EwZcd53E+oSRiEO1Wa3Hc+6er76tUHXZpJbkhtT9gjPqI6bmMRlXD0Vdh1Xsk0GibG7CCsBv
        IZye0KyJjp6HaV9zYcpLTuz1WLvgEBcYz3tuOPI7ZATZEyy9QB8K08YxBUJSV4Oz2OYFUD2ksKUTu
        VmPoWkQg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOloy-00AP9C-Q0; Tue, 23 Mar 2021 18:32:33 +0000
Date:   Tue, 23 Mar 2021 18:32:04 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: move the check for post-EOF mappings into
 xfs_can_free_eofblocks
Message-ID: <20210323183204.GA2479637@infradead.org>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681767.1887542.5197301352012661570.stgit@magnolia>
 <20210319055907.GB955126@infradead.org>
 <20210319060534.GF1670408@magnolia>
 <20210319063537.GB965589@infradead.org>
 <20210319165924.GR22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319165924.GR22100@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 09:59:24AM -0700, Darrick J. Wong wrote:
> > Yes.  What I meant is that if we can deduce that we are in inactive
> > somehow (probably using the VFS inode state) we can ASSERT that we
> > are either in inactive or hold the iolock.
> 
> Yeah, I think we can do:
> 
> 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL) ||
> 	       (VFS_I(ip)->i_state & I_FREEING));

Yes, that looks sensible.
