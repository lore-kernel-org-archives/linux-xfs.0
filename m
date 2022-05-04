Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D389C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  4 May 2022 14:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiEDOOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 10:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351209AbiEDONn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 10:13:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09A6433B5;
        Wed,  4 May 2022 07:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SfsnbVzUamDDwYSxHb3IxEH7g02ts4KSsBbvwnaHx+w=; b=OsmvvzBe+x2JP8XKFG7yBeZo2R
        TGstnZxp/QtX1mBHGud2OkH795aV0UEB3zSm5e8tgbiDhAZTnip7C0puzyPfKW/Y0MBoJgMU0+bhc
        L2UloEoi7e3apfh47yerferVgKq+UomJdE/G9mWyDiO5qITSYFzYWOEOGkuNqBAb/hzyoIFu89RbX
        Ed1yJPt4mVCsCnLhqUa+iqskOF7WRXIf4W37rfdrh1/KuQoYfZ/moImz5+jJwdaCw6xA3vROFq6R3
        N8z7BkXwGKmDlu7cPghyjtldKqeR9E8AuwCNrkz/RNke7AyEEB9pLuV1R/6tVPiiSY8MBnuHMZaUY
        DQsos9pA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nmFhW-00BDra-Pw; Wed, 04 May 2022 14:09:58 +0000
Date:   Wed, 4 May 2022 07:09:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: iomap_write_failed fix
Message-ID: <YnKJNvoeGYaxN/2f@infradead.org>
References: <20220503213645.3273828-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503213645.3273828-1-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 11:36:45PM +0200, Andreas Gruenbacher wrote:
> The @lend parameter of truncate_pagecache_range() should be the offset
> of the last byte of the hole, not the first byte beyond it.
> 
> Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
