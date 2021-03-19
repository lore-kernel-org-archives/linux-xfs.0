Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC75C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6952C64E10
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhCSGd0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 02:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbhCSGdF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Mar 2021 02:33:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB61C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 23:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BVzkkqyYKuEXHRTRi9bzx/buQtt04QjkDJyo0D47KiI=; b=KFTxhHGVt1BE6hyh0F5+W+LgGS
        oDMBrRB/72c8fSR8WNi68yEPw/kR+HclIs7BvWJK1vGNmxdQcVdinSaU6kYkIDc7a7i8S/iNBRaKt
        rLjENPfvDkF4P7lpiDRP+ewAsYz86UZ/TzStNZXJoPKn/KHVzJzaNtKfx2y6dtH3WB+h4gA9Ikdf/
        yf1xAz1Wzpvqw6bOG5wSeO5FMo1l43g9ALrrDB8C08kPpUCodmBs9vRdrkasIQ3e1BgprfEOpLxX6
        +HAyLWSN+QP7LRHR5o6VYXf9n2tf/t4P4vZItXLVFN9S2NUkv4uSc74uUQvXYfausCucI+lFyYBoQ
        XyB0Ts/g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lN8fk-0043IL-Rn; Fri, 19 Mar 2021 06:31:54 +0000
Date:   Fri, 19 Mar 2021 06:31:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: move the xfs_can_free_eofblocks call under the
 IOLOCK
Message-ID: <20210319063148.GA965589@infradead.org>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681213.1887542.5172499515393116902.stgit@magnolia>
 <20210319055340.GA955126@infradead.org>
 <20210319060110.GE1670408@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319060110.GE1670408@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 11:01:10PM -0700, Darrick J. Wong wrote:
> I don't think so, because xfs_free_eofblocks will call
> xfs_inode_clear_eofblocks_tag if it succeeds in freeing anything.
> 
> Though perhaps you're correct that we need to clear the tag if
> !xfs_can_free_eofblocks, since we could have been called if
> XFS_ICI_BLOCKGC_TAG was set in the radix tree because we once had a
> posteof block but now we really only have cow blocks.

Yes, that's what I meant.
