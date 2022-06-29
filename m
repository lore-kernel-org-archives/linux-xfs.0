Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B429BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiF2HUz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiF2HUz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:20:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F251D300
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bIC+IUOTbceMRUIRg7Fg5eebYfCoepnPosGCrIlAu8k=; b=JnKEO5o0qerNm8bA0ziABoTUCv
        f27b+1raeyHwxGh1vaMpdtk4/quVeN5Ptw9xWXiMqbXvTb0yUBEReLrr7UwdWxL4v0sUM5aeOHjzI
        bX5zGudxs+fMVXup3rMkl1+EKSWi6DGsterK521sROVI8ktCEA7MBP8sc5oFXN2TIzWLS5mfXNV09
        4RarnJRdRnQIW64aVj4de9gy/pKR9s1WORho84sB+miInotQlc+tzth6V1hYEAgDwKP923T/e8jvW
        NrOa/ftMo6T0IPRFYAVm2HMDoqmHT/fyM+bYGC1N2f05ek6wdtPxpYtcWNnhoRJc6yNyjGUVZEcjx
        AR2j55ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6S0L-00A4Bu-OH; Wed, 29 Jun 2022 07:20:53 +0000
Date:   Wed, 29 Jun 2022 00:20:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: double link the unlinked inode list
Message-ID: <Yrv9VVaHT8WnHts3@infradead.org>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -70,6 +70,7 @@ typedef struct xfs_inode {
>  
>  	/* unlinked list pointers */
>  	xfs_agino_t		i_next_unlinked;
> +	xfs_agino_t		i_prev_unlinked;

Ok, this somewhat invalidates my previous comment, unless we find
another hole in the xfs_inode layout.
