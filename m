Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37008C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 18:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbiDFSHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiDFSG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:06:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D83092D0A
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RXf5wbvbWIDXV60fW59OPdsf8xxYfFjyzah1GAOsXtQ=; b=KEPdLYk1hhH7QUfHs5/WT/1S3t
        yxYbnuOkNLwkB3wqeK9HKDFCR7mZB5DPuz5ZKqHSoZk79oe3StT0aR/swTJjpahVeCySys8NGhWhH
        GMDKKCdw2zw0dYb0Q9u8VFg8+8CiLFxSOGh3J687PwmsR1YFH5pzSk9/etzk+WrZs+yN9UGIwNPGZ
        MmvUguSli+OxqMbntFIFXL7j6LrwX7/pgtAv5p19BdS9qF7jRjv8Usp+ym0dqv9egEapM1nt3WR3R
        1g4krQh6m9NtaM+XNofj9TK5ClB7zoKyN9MjjvChCwgTgqcBBE1cScje9dM0PSeBqhUMez5G9DEjE
        Sw2VutIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8kX-007Eyt-Gl; Wed, 06 Apr 2022 16:43:17 +0000
Date:   Wed, 6 Apr 2022 09:43:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 6/6] xfs: don't report reserved bnobt space as available
Message-ID: <Yk3DJfsEA/lNO9B+@infradead.org>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840033043.54920.18407468773094720534.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840033043.54920.18407468773094720534.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 27, 2022 at 09:58:50AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a modern filesystem, we don't allow userspace to allocate blocks for
> data storage from the per-AG space reservations, the user-controlled
> reservation pool that prevents ENOSPC in the middle of internal
> operations, or the internal per-AG set-aside that prevents unwanted
> filesystem shutdowns due to ENOSPC during a bmap btree split.
> 
> Since we now consider freespace btree blocks as unavailable for
> allocation for data storage, we shouldn't report those blocks via statfs
> either.  This makes the numbers that we return via the statfs f_bavail
> and f_bfree fields a more conservative estimate of actual free space.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
