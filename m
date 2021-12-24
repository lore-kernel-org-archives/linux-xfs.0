Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898C5C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343512AbhLXHWE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbhLXHWD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:22:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC18C061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZFY60F5OZKNhOQJgt2PDzfbbOYs41tji0iRVPT6DykA=; b=i2QPb77C6Gh8dTNuefpBe4UlV9
        pWu2l8RcL9VBOlmRCngnOLDPxWW66BLVbCOkIb/fdKthp0BK/rheAMGV17gIwBYE080pPTBXHbGPe
        y6wMy5udoQbFtnzanbCe2dqB6BWjm1XNFx+rNRhUFQ83m2SWB5qaeQNDMmPJhwq2lnjA9njeoW/sd
        hpVcTQpDEfja5EVujEenWsMq9TzzKIqIpXUbrqiQnDgIrxnaO+CIBJhX7WiRWt5jim7JULokBHfvv
        n6P9n2n5f8HstW825YqhZM4XHioTGU1R1npsZhqHUsSiioyF3AiggpRNwlYWDOFylPRLi/62UBi4Y
        Fs37t6hA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0etu-00DqKD-2C; Fri, 24 Dec 2021 07:22:02 +0000
Date:   Thu, 23 Dec 2021 23:22:02 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't expose internal symlink metadata buffers
 to the vfs
Message-ID: <YcV1GpaqWCrA0A15@infradead.org>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961698851.3129691.1262560189729839928.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961698851.3129691.1262560189729839928.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ian Kent reported that for inline symlinks, it's possible for
> vfs_readlink to hang on to the target buffer returned by
> _vn_get_link_inline long after it's been freed by xfs inode reclaim.
> This is a layering violation -- we should never expose XFS internals to
> the VFS.
> 
> When the symlink has a remote target, we allocate a separate buffer,
> copy the internal information, and let the VFS manage the new buffer's
> lifetime.  Let's adapt the inline code paths to do this too.  It's
> less efficient, but fixes the layering violation and avoids the need to
> adapt the if_data lifetime to rcu rules.  Clearly I don't care about
> readlink benchmarks.
> 
> As a side note, this fixes the minor locking violation where we can
> access the inode data fork without taking any locks; proper locking (and
> eliminating the possibility of having to switch inode_operations on a
> live inode) is essential to online repair coordinating repairs
> correctly.
> 
> Reported-by: Ian Kent <raven@themaw.net>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

This should also allow us to avoid the magic overallocation in
xfs_init_local_fork.
