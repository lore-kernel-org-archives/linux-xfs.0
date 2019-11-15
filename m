Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD10C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 13:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E7F2073B
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 13:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t6Z61JPh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfKONNM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 08:13:12 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42328 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfKONNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 08:13:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5qrBznl1kz5QJqxp+sQGpXhaRVzPWa1p4hJJNJZ0Jd0=; b=t6Z61JPhK9IXU/lJ4yGh3OOzK
        gyhHKgZVsCGkNkSL6aEOaoVabBnVMo90ps+rq/SckVJEPwL+MMqAMJxsqlR4buTwGoTixGUM9whnw
        uyZkcjTmBkgmylU2/4MUiCpK+9RQv5aTNTsPqlhjMhmKZPvuJa8zSapEmOlIGr+xt7/9EnaDU8udX
        x43/eka0xB3lwd5bjaASiexgzw0Sr/j28On2VEk5oSWsAA0Vohci6bBvlHXlD32ST+Gjd2B+vJmJ6
        LeVa+Ud/9AzZ5T/ErB5f2NK4pUbiA+j4sbQ1zHroKy0Qu6fNDZTFWLwTOyjdZvKjMO4OV1YNmM/I+
        ZfIyFqKMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iVbPS-0006G2-P6; Fri, 15 Nov 2019 13:13:10 +0000
Date:   Fri, 15 Nov 2019 05:13:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/28] xfs: rework unreferenced inode lookups
Message-ID: <20191115131310.GA18378@infradead.org>
References: <20191031234618.15403-1-david@fromorbit.com>
 <20191031234618.15403-29-david@fromorbit.com>
 <20191106221846.GE37080@bfoster>
 <20191114221602.GJ4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114221602.GJ4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 09:16:02AM +1100, Dave Chinner wrote:
> > Can we tie these into the proper locking interface using flags? For
> > example, something like xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_ILOCK_NONOWNER)
> > or xfs_ilock(ip, XFS_ILOCK_EXCL_NONOWNER) perhaps?
> 
> I'd prefer not to make this part of the common locking interface -
> it's a one off special use case, not something we want to progate
> elsewhere into the code.
> 
> Now that I think over it, I probably should have tagged this with
> patch with [RFC]. I think we should just get rid of the mrlock
> wrappers rather than add more, and that would simplify this a lot.

Yes, killing off the mrlock wrappers would be very helpful.  The only
thing we use them for is asserts on the locking state.  We could either
switch to lockdep_assert_held*, or just open code the write locked bit.
While it is a little more ugly I'd tend towards the latter given that
the locking asserts are too useful to require lockdep builds with their
performance impact.
