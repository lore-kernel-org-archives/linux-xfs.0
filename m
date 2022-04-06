Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9A3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 18:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiDFSG6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiDFSGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:06:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DF8260C7C
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1qE1pwPNO4Nrx4t1kDLQN5jXDeRbNlp9WeovF8ZFKxk=; b=ekpO2+EI5sPf5V5Edwom1QQrxr
        3CcYoCDi0o4CQkKC+bi1Iw43Y+aA2zyFAICAKn34cZhEry6U3pNqTO0CvxwNDyGohWui/V0LyPksx
        hZH+64YfSm58+lAagnr4q73nKPcqIWcZOAcQTNfD1VnobUniflErI27DnME1oLUWvyBA+ksVKm1tg
        EeJ/Mw/x4ecPUqrg3Xd4tlcic+pFmuCUFPFeoZrp8pNR7SCSrCkwDfJyQciqFh6YXrKTkJymhoymt
        vEVOr5yo/iPHtONVijrxoC9ALlmuNFVMmaS7t3l1cO8bNcnPAFz32at634Bij3GopzOzgCahM9bXH
        bPJ2jtQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8k1-007Et5-Eh; Wed, 06 Apr 2022 16:42:45 +0000
Date:   Wed, 6 Apr 2022 09:42:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Subject: Re: [PATCH 5/6] xfs: fix overfilling of reserve pool
Message-ID: <Yk3DBR7kn6U4+yua@infradead.org>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840032479.54920.10404960270844945481.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840032479.54920.10404960270844945481.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 27, 2022 at 09:58:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Due to cycling of m_sb_lock, it's possible for multiple callers of
> xfs_reserve_blocks to race at changing the pool size, subtracting blocks
> from fdblocks, and actually putting it in the pool.  The result of all
> this is that we can overfill the reserve pool to hilarious levels.
> 
> xfs_mod_fdblocks, when called with a positive value, already knows how
> to take freed blocks and either fill the reserve until it's full, or put
> them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
