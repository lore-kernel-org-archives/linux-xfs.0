Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA46C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7294E20716
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PLNWT4ah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgICKkH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 06:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgICKkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 06:40:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE7EC061244
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 03:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9cbjg3t69wIg8Xe3KkzcZVTVotv4Yz1xk5GwWLMB84s=; b=PLNWT4ahnm0sAXcBBevclePHhp
        LgTjG+oQHdmCijhqLFG8V/xfy+OKfYgZAGMNEDxLNNouWFBtd1C4hBNj+XbhHvsS87X7TV0rkoPWv
        AFPZ7RxzFT+rgMF8Uyu7e6Jxc/6PY/bgJmdUd/HQmTnY65zZ3aqRzCguHogz7H8PygY7HVyG1P5jN
        Gpbe2TO8IwNEXrvMbC+o418DJ3OUzwFZmHlXl11RMMCNFLPGGlGfltd/RBtXvfyflh3azyPTp3r6U
        1RRXVk+2LjyQfsmRtuaudOod9UR8+pfu4b7ozFmrmD87Lhnu7Q9rfzB/qaefMKv9DVF8sZJ2wJQFx
        GgM2yUvg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDmeq-0000Lt-L2; Thu, 03 Sep 2020 10:39:56 +0000
Date:   Thu, 3 Sep 2020 11:39:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200903103956.GA1210@infradead.org>
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-5-cmaiolino@redhat.com>
 <20200903091436.GD10584@infradead.org>
 <20200903103821.wt75v7p2mzuauzca@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903103821.wt75v7p2mzuauzca@eorzea>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 12:38:21PM +0200, Carlos Maiolino wrote:
> > Same for these.  Also if you cast to void * instead of char * in
> > xfs_attr_sf_nextentry (and gcc extension we make heavy use of), you
> > don't need the case back.
> 
> I believe you meant cast here? For sure, looks a good simplification, I'll add
> it. Thanks again!

Yes, sorry.
