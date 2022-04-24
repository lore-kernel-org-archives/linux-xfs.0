Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C001BC433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbiDXFpc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:45:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B74619C741
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UpCrsQx5g/9/D11iN52MhSxWNJfv/VkBzbQjidqtlks=; b=FdpIYUIpNXvpAOZbm7o4A0Om5X
        sqJ6JeNzge8ayEJGIRQAfVaXEv/zfWiSxZS6iWBKjFYx0P+pwKrk1HDjfyyAalp+ACtJnXFGFec8W
        fjmzvMEoEOcAAaP8pLyvRrHDphVGpPmKPlRdjc2nB1cVkCbhkvLFkiY5UTWHDySjLYXMJVS6LLJU6
        BVS/CIhjN8oVC323PkaHP0MfZx/bEap45lc3RAA2PSZrTWjS6UAawis9mzzrqXZn9Uizoj+JwwPCB
        e171T6MHvp5/mopdSate7nrZPPAC2sfNBXjakr3GWAbnfnufNR62VAUiojcVRLBQuHWH8h8BIZdiU
        bM6j1BhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niV0w-005re7-Bs; Sun, 24 Apr 2022 05:42:30 +0000
Date:   Sat, 23 Apr 2022 22:42:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: don't let internal logs bump the root dir
 inode chunk to AG 1
Message-ID: <YmTjRiv233HA/m77@infradead.org>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
 <164996215459.226891.14970225993709296570.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164996215459.226891.14970225993709296570.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 11:49:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, we don't let an internal log consume every last block in an
> AG.  According to the comment, we're doing this to avoid tripping AGF
> verifiers if freeblks==0, but on a modern filesystem this isn't
> sufficient to avoid problems because we need to have enough space in the
> AG to allocate an aligned root inode chunk, if it should be the case
> that the log also ends up in AG 0:

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
