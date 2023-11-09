Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F19C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 05:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjKIFju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 00:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjKIFjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 00:39:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F2B26B5;
        Wed,  8 Nov 2023 21:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VHb4k4Hp51eahTDHPTtr9nAIrHBHgHKaX5N7mwJ8nf0=; b=jShRZ0k/wedZUv7S+uy8gvMvlJ
        LRw5dstI/Z1C+EQ7So4oM3banG558IyNe9cINm57ouJG7QsGzXwo95Fi9mNFaBKdbZ5vCrJJgQiYt
        jnXQ9guqw+A/sI+jrubv5q/Kxvvup70eu2rYczOM/EMXqOp5Sl2jbi+MlTy5NXrfn1HPRTk6bH0gf
        xTS1DmAacxXWMNcOd/OQ/L56XXITy134l6wsqWNBjpQC4fwZKsS0kikuT52BipBGXKFHNEwhWNTsD
        CUpXOGu4xhKSiKg6IeQ+OcHJY4eVLGowqQhCAqBVYlB+3Dikz5DOHfz7SCL28vO9LevF/C8pCR2Jm
        T7oQES/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0xlY-005KrU-2W;
        Thu, 09 Nov 2023 05:39:44 +0000
Date:   Wed, 8 Nov 2023 21:39:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, guan@eryu.me, david@fromorbit.com,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test unlinked inode list repair on demand
Message-ID: <ZUxwoLoy2D/CIUbE@infradead.org>
References: <169947894813.203694.3337426306300447087.stgit@frogsfrogsfrogs>
 <169947895967.203694.8763078075817732328.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169947895967.203694.8763078075817732328.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +# Modify as appropriate.

Btw, why do we keep adding this pointless boilerplate everywhere?

> +_supported_fs generic

I think this should be xfs only.

> +source ./common/filter
> +source ./common/fuzzy
> +source ./common/quota

When did we switch from using . to source other shell files
to "source"?  Just curious.

> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic

xfs again.

