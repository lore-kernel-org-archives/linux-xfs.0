Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36A6C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 04:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiGLExk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 00:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLExj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 00:53:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854DD181
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 21:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FvY4gM6Xd79kff+G08gCHiqgvY/H6mIfBfGgw8/lEyw=; b=gMfEhY2Cv+mI0p+suNTgPgqdDz
        UCwSvc2BGsACzv2ciwpazz/Ha59od+rRBN5SGRIni7mrmfru34ZOcUtCMPdndfhBxDn5uLLV0ilZC
        420+E/pmiwDIr4yixGlOnyB8OZhPrCiM1wKvh4TKFuHuyET8AM+691PxqSE4hGCF09ihXQCxm280l
        jl8aYt+RkbUswp92RmkONZ6iH9ZuiZSza+Y+F2BiiXtF4FMS8U+log2vqRxnvBfA5kuCWdLfLgdOe
        wQIO6LGIIz5dmhDR/XL6zaYVA4DcqXdMxB79zC1Sby5HpKKKEX1f2jY6V0ufdDPML6tEwigIfMAuK
        /o3Sq7yA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB7tp-007XYO-Hd; Tue, 12 Jul 2022 04:53:29 +0000
Date:   Mon, 11 Jul 2022 21:53:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Subject: Re: [PATCH 1/5] xfs: convert XFS_IFORK_PTR to a static inline helper
Message-ID: <Ysz+SbVRh5yTWzXS@infradead.org>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
 <165740692193.73293.17607871779448850064.stgit@magnolia>
 <Ysu0iYgkaGdg6oVJ@infradead.org>
 <YszMaH4fLe0S6Jp7@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YszMaH4fLe0S6Jp7@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 11, 2022 at 06:20:40PM -0700, Darrick J. Wong wrote:
> I personally am not that bothered by shouty function names, but Dave
> has asked for shout-reduction in the past, so every time I convert
> something I also change the case.
> 
> AFAIK it /is/ sort of a C custom that macros get loud names and
> functions do not so that you ALWAYS KNOW, erm, when you're dealing with
> a macro that could rain bad coding conventions down on your head.

It is a bit of a historic custom, but not really followed strictly.
I tend to think of trivial container_of and similar addressing inline
functions just as macros with a saner implementation, and so does a
big part of the kernel community.  Where exactly that border is is not
clear, though.  And in doubt I think avoiding too much churn in changing
things unless there is a clear benefit is a good idea.  So maybe we
would have picked a lower case name for XFS_IFORK_PTR when adding it
new, but i don't really see any benefit in changing it now.

The same is true for some of the other patches later in the series,
except for maybe XFS_IFORK_Q, which has been really grossly and
confusingly misnamed.
