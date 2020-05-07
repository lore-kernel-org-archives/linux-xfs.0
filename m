Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7BFC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 06:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A682075E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 06:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UmAGZ5h4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgEGGCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 02:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgEGGCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 02:02:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F467C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 23:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YKWcUwwulszqVHE43y73vZE7vt9KQwN2FnvNSurcz9U=; b=UmAGZ5h4D4cGGL2PB73EANA4cM
        qFUKLkdrIN/DLCv3UG4nkAonjYhS5adQEDlAXtKtoghmJhcdZa9vlle+NwPc8XirzDMn5/dsJYHA3
        kpeO5ekDdp30Lah6c7kLFRj1iBJjAp2MylLF3aMM+xLnsNxC8sqDl8D/LIRXhuqJgRszkILzdAQkN
        bwBI6jR25aJnbmla2grbfvTl+k0vyzpITrAWTrZnuh+H8cczRdSKGXQ0s3MPv0fQRpE7aSAqK1DMd
        fsd1LJ33awjeEcIi9Htb+fNLy/3OlIbnYwIo2T8qYMUxR+5Kn4yg6pRHpKGSpmVFtcoakTZccrmbb
        Ny0TSlfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWZbh-0001IV-Fi; Thu, 07 May 2020 06:02:05 +0000
Date:   Wed, 6 May 2020 23:02:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually account for quota changes in
 xfs_swap_extents
Message-ID: <20200507060205.GA3523@infradead.org>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
 <158864102885.182577.15936710415441871446.stgit@magnolia>
 <20200506145728.GC7864@infradead.org>
 <20200506163424.GT5703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506163424.GT5703@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 09:34:24AM -0700, Darrick J. Wong wrote:
> On Wed, May 06, 2020 at 07:57:28AM -0700, Christoph Hellwig wrote:
> > On Mon, May 04, 2020 at 06:10:29PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Currently, xfs_swap_extents neither checks for sufficient quota
> > > reservation nor does it actually update quota counts when swapping the
> > > extent forks.  While the primary known user of extent swapping (xfs_fsr)
> > > is careful to ensure that the user/group/project ids of both files
> > > match, this is not required by the kernel.  Consequently, unprivileged
> > > userspace can cause the quota counts to be incorrect.
> > 
> > Wouldn't be the right fix to enforce an id match?  I think that is a
> > very sensible limitation.
> 
> One could do that, but at a cost of breaking any userspace program that
> was using XFS_IOC_SWAPEXT and was not aware that the ids had to match
> (possibly due to the lack of documentation...)

I don't really expect that to be the case.  I'd throw in the check
and a printk_once warning, and I bet a beer at the next conference
(if there ever is one :)) that no one will trigger it.
