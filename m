Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE2BC3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 01:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E9B32073B
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 01:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ug+RzulA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCFBDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:03:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgCFBDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 20:03:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yAqE1cEX1uAruAQ6OsL0vLb7sAZost3nasEsEZ8Dv5U=; b=ug+RzulA4QsdR885SxqKIsCwHJ
        JS3IHuT4d+zQkhyv26XBFt29Yg23XVoAaB1TyA0yC41IoW4SyU+KSYUJSWnYO8+aGT0sQ0hQ2kZeX
        jcvS7xi8fcyHv0gVQlB5/zMxBSQbrFaeyo+d2C2F3rSwU4Z5FGCcmqzMVpcqDYYLUY3XJuJ+Lrmp2
        xxtwpqV+RkaMcm3jHB5GwE31NBNZ/+PdVjZjRY4QcsV/Zm6xj0ukbQZhD1G0H/Z5ThBE/Sj02dXCy
        e2w1hMtTAvAGJo91PYKHLxpOVTAj8yshFce5/zjpgF3Sd3upRx1CbqYCw+2+OPGH/iDSRJ0/oGH7M
        D5aylLcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jA1OV-0006jd-GL; Fri, 06 Mar 2020 01:03:15 +0000
Date:   Thu, 5 Mar 2020 17:03:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/11] xfs: clean up log tickets and record writes
Message-ID: <20200306010315.GA23750@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200305160522.GA4825@infradead.org>
 <20200305214224.GK10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305214224.GK10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 08:42:24AM +1100, Dave Chinner wrote:
> On Thu, Mar 05, 2020 at 08:05:22AM -0800, Christoph Hellwig wrote:
> > FYI, I'd prefer to just see the series without patches 6, 7 and 9 for
> > now.  They aren't really related to the rest, and I think this series:
> > 
> >     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-kill-XLOG_STATE_IOERROR
> 
> URL not found.

Weird, works for me.
