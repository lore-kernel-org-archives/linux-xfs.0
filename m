Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22405C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 05:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF11613CF
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 05:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348630AbhDGFJO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 01:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348629AbhDGFJN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 01:09:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13EBC06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 22:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eiBMF60/QHCRAqkIMD5/ZObf2zv6SLItjpAuvp6g2OI=; b=LDaI1GdmddkdyhkywEDa22Yvy6
        EyJ7+y4+p89JRobqwUMFax7FEJ1xw+kcsQYeMtTCIbDzkew4zgq7+CUZsNmUSL3DC2OTS4HiK+F/N
        jn8g4Ar6qtS+SRAJX210g9v8c6kcTimRZlY47ePyGMdodDjtddFaD3ykEX7QfJffDWamBIbKH2T8l
        cvUb8hnQ+ciNQ+lZqh2j+k59TEA37spH0xPQlLfxZSST/YD6VBWuvVUB7TihlAq9HIJWpmPcZJULm
        Csgkn28cd30w8S2iAcn7Yh3mwdTcwECMyAxZC29TaMdD3nwWU5cxTHJ4sIlQ/EbM6NW/v9g4sWmSO
        lna58WiQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU0Qb-00DvE1-QA; Wed, 07 Apr 2021 05:08:40 +0000
Date:   Wed, 7 Apr 2021 06:08:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature
 awareness
Message-ID: <20210407050833.GA3317957@infradead.org>
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-2-david@fromorbit.com>
 <20210406154016.GA3104374@infradead.org>
 <20210406212905.GB63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406212905.GB63242@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 07:29:05AM +1000, Dave Chinner wrote:
> On Tue, Apr 06, 2021 at 04:40:16PM +0100, Christoph Hellwig wrote:
> > On Tue, Apr 06, 2021 at 09:59:20PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The pitfalls of regression testing on a machine without realising
> > > that selinux was disabled. Only set the attr fork during inode
> > > allocation if the attr feature bits are already set on the
> > > superblock.
> > 
> > This doesn't apply to the current xfs/for-next tree to me, with
> > rejects in xfs_default_attroffset.
> 
> Not sure why you'd get rejects in xfs_default_attroffset() given
> this patch doesn't change that function at all.
> 
> The whole series applies fine here on 5.12-rc6 + xfs/for-next. Head
> of the xfs/for-next branch I'm using is commit 25dfa65f8149 ("xfs:
> fix xfs_trans slab cache name") which matches the head commit in the
> kernel.org tree...

Yes. that's the one I tried to apply it to.  Oh, bloddy git-am trying
to sort by something applies "xfs: precalculate default inode attribute
offset" first.  This has been happening to me a bit lately.  Sorry for
the noise.
