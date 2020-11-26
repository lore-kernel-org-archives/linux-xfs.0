Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05792C63798
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 07:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690AF2068D
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 07:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jhxn/jtf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388285AbgKZHVP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbgKZHVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Nov 2020 02:21:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DEDC0613D4;
        Wed, 25 Nov 2020 23:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SZR0GsSdbfjBui5Wk4EHWw9OSPLPRtpE0HYG9GmPIUI=; b=Jhxn/jtf9uxD1lSCrVk5FVgQSu
        NOlyvNStYP9XzDhPWeJzEETQCAdVqezYOpUkxJWXSnEm86Mk89+8lTEmb3+BrNYwF62gYEKoB8vKC
        hvx9Zj1uy0++ELp8zg36GpZ1hiN7cdKD2mK1lPRqBqIl5/7qu/6m/90RjVxdkYbg+JwAEGXvFxX00
        /Xm+rpVXJntmATI7+2EwhEVx7WAncvUDikE/3Xff/+N9tM7rq3TS0cOkumygttnblYNxunSjQcX6g
        Fbg0VxO7Hav5CzJWXReGWEUHTOFI0GiLVL1CZfUh/sxj5CXhw+HqoEN9Tsms8HIUiyd1j9dBMihs/
        c2Rhf8Iw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kiBZf-0007qP-K7; Thu, 26 Nov 2020 07:20:16 +0000
Date:   Thu, 26 Nov 2020 07:20:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH] drm/ttm: don't set page->mapping
Message-ID: <20201126072015.GA29730@infradead.org>
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
 <20201125162532.1299794-5-daniel.vetter@ffwll.ch>
 <CAKMK7uGXfqaPUtnX=VgA3tFn3S+Gt9GV+kPguakZ6FF_n8LKuA@mail.gmail.com>
 <20201125180606.GQ5487@ziepe.ca>
 <20201125181129.GA1858@infradead.org>
 <20201125235720.GR5487@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125235720.GR5487@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 07:57:20PM -0400, Jason Gunthorpe wrote:
> annotate is OK, I used that for a long time..
> 
> My main gripe was it didn't setup the to/cc until after the annotate
> editor closes.

I put the To/Cc into the cover letter text file.
