Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A907CC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 02:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E97520707
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 02:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ncJE4xT0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHZC00 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 22:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgHZC00 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 22:26:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC55C061574;
        Tue, 25 Aug 2020 19:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sxFvO/GLCLgBRfmkOAspDUyP4lpcTibuAN2MiSmiuaE=; b=ncJE4xT0RV0DL88DyjXY0ZZWNX
        c5H0dGv17CatAlJxzga6RRk56Q8fwDpXIuW7EEgf7tICAzbPlgtNvK36sFxtwQvfroJ8qKcfn9ct+
        v4xOejFU30Eo6Um3PIONALTAT6Ii6GySy9Kynet63yIETPr4X7Oj3m9vt0bUhKXato+jPPJgzIcmN
        xCRFwAEBsbxCuWcC3955WsJF+6u+RN5YmHIZREM7WnjcBaZxITdzSi1qvAFtPV8idzN0tt+oTQK6S
        sSkJThXGSEmeNs+teYiAx47mwssooc7xfO79kmW10tUeb6CG3YyCKJVsgR67CM/sfzG2kQmIpROjy
        HXDE9yLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAl8p-0003AS-OR; Wed, 26 Aug 2020 02:26:23 +0000
Date:   Wed, 26 Aug 2020 03:26:23 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] iomap: Support arbitrarily many blocks per page
Message-ID: <20200826022623.GQ17456@casper.infradead.org>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-6-willy@infradead.org>
 <20200825210203.GJ6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825210203.GJ6096@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 02:02:03PM -0700, Darrick J. Wong wrote:
> >  /*
> > - * Structure allocated for each page when block size < PAGE_SIZE to track
> > + * Structure allocated for each page when block size < page size to track
> >   * sub-page uptodate status and I/O completions.
> 
> "for each regular page or head page of a huge page"?  Or whatever we're
> calling them nowadays?

Well, that's what I'm calling a "page" ;-)

How about "for each page or THP"?  The fact that it's stored in the
head page is incidental -- it's allocated for the THP.

