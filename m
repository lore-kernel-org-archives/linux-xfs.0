Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5294C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81240207C4
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XAI0GOXq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgEQHsq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 03:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgEQHsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 May 2020 03:48:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C25C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 17 May 2020 00:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eFwbpoD/0+xWU0buugAdJ6NQE7TwPf9QaEFcXUw2d38=; b=XAI0GOXq6GRO2WkxSVBCBvmNUw
        fqfincEOJ/mwUFFv2LOngnkpncy++FsCU7DukZB0mxRRlhkqHHNnVKFaZnz6cpbcNxxY3zr2VgZ0r
        sZw6qg4w47KTDBuq3oG3gwRX0t3Bg3bsWHfKpVll+fiZnnW2m4C3PK0wJUiPFcaa/3qYHO4qJl3mq
        lT9CBN/imsQvNr1Z444FF9vfI6+92jDhdkhL3l7DfWnz8YHNjw7Aw2sAUigN+4QUoq8GCvH0Bpxxa
        Bywj/0KTLB68M3OMD2vr/1mHTIQmjf7cax42UAuwgymBsG/o/q0raS5JbOYBhjZpvhlot16v++F8F
        wDFJIAbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaE2N-0002Fu-5M; Sun, 17 May 2020 07:48:43 +0000
Date:   Sun, 17 May 2020 00:48:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200517074843.GC32627@infradead.org>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
 <20200119204925.GC9407@dread.disaster.area>
 <20200203201445.GA6870@magnolia>
 <20200507103232.GB9003@bfoster>
 <20200514163317.GA6714@magnolia>
 <20200514174448.GE50849@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514174448.GE50849@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 01:44:48PM -0400, Brian Foster wrote:
> It looks like Christoph already reviewed the patch. I'm not sure if his
> opinion changed it all after the subsequent discussion, but otherwise
> that just leaves Dave's objection. Dave, any thoughts on this given the
> test results and broader context? What do you think about getting this
> patch merged and revisiting the whole unwritten extent thing
> independently?

Absolutely no change of mind.  I think we need to fix the issue ASAP
and then look into performance improvements as soon as we get to it.
