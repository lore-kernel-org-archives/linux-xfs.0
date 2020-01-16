Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B676C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E21A82192A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:43:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I7Hcc6to"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgAPQni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:43:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgAPQni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tnftK4oP3F5KWQnd0wUtacYrfPSw2QwrxcO7MFJvKl0=; b=I7Hcc6toUTIAqCRepdkYwIvY7
        LBJ8DAWtBpiEEPUFAtG/lUdqY+6RWbqrdWA6EWHDqGM6BfyrG/eSjG1pJNqC6ap4AUr3yMnHxY5xm
        VbqIYzTPu2TZiQJ5wsxqfo7lLa1C+e0rB+CVdGoostE3ZNWT6Wa0SnGXGwffNyCyHMz50Zs7Xc5P7
        0O0lFE38ZXxbL1hRz06XevE5EXuOXvm97MHtQqSXx9mR1gOxNk4gPgDO0kaFwwrV4Ww9dxrk9jTBH
        2mZdvpfeUYn5NTpH5PyP0Ao4QCheqwX8b84YERSBs0Sjyb3EJEIPCLAvz2eWBMe7EeyMrq3RXU+mj
        tKJqKrhuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is8F7-0006mn-Od; Thu, 16 Jan 2020 16:43:37 +0000
Date:   Thu, 16 Jan 2020 08:43:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 9/9] xfs: make xfs_btree_get_buf functions return an
 error code
Message-ID: <20200116164337.GA9318@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910787821.2028217.9307411154179566922.stgit@magnolia>
 <20200116163355.GI3802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116163355.GI3802@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:33:55AM -0800, Christoph Hellwig wrote:
> >  	ASSERT(fsbno != NULLFSBLOCK);
> >  	d = XFS_FSB_TO_DADDR(mp, fsbno);
> > -	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
> > -	if (error)
> > -		return NULL;
> > -	return bp;
> > +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, bpp);
> 
> Maybe kill the local variable while you're at it?

Or maybe just kill xfs_btree_get_bufl and xfs_btree_get_bufs?  They
are completely trivial now, and each one just has two callers.
