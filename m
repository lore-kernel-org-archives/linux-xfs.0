Return-Path: <SRS0=2Dxs=CH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E391C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 737B0214DB
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UWfIuHYy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgH2GoQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 02:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgH2GoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Aug 2020 02:44:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B0DC061236;
        Fri, 28 Aug 2020 23:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9n7BXslLDALMBKpnbrzb5yS5tjxumV/kCSr/JQW5G7k=; b=UWfIuHYyqoP0cm8xSuu4NfJ9Zr
        xTstESSjwdTiyOfljMtkMDShGfE2TnjGgoGSLkLPPpbp6FA8XGsFB9Ct5QkwfTrgBzBnzfei5JPRs
        zVVAjSwe0bjyqmFRo3ZLV6HQ44N4QcGPk6IJ8UnhWvlt1ZnTERW9CXFrUpzRo7pQ8EOtoT+t0IjhV
        NhTpIkgeAVuYnYggJQNK9MhfXpLA3HOq05pHb+qFD9U94B1ZYAN5xlA5iwT1anHvDbJGyinEOq4iD
        8WmI/j3Pq/wMtk/MqhdjkQLib/qnbOxn1EiNeWGiAkrrqnSwKRc2W08yEGFE64o7gc0IITjgrNfQE
        TaoP23UA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBuax-0007dW-V8; Sat, 29 Aug 2020 06:44:12 +0000
Date:   Sat, 29 Aug 2020 07:44:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200829064411.GA29069@infradead.org>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org>
 <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
 <20200827073700.GA30374@infradead.org>
 <c59a4ed6-2698-ab61-6a73-143e273d9e22@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c59a4ed6-2698-ab61-6a73-143e273d9e22@toxicpanda.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 11:57:03AM -0400, Josef Bacik wrote:
> > 
> 
> This sort of brings up a good point, the whole point of DISCARD support in
> log-writes was to expose problems where we may have been discarding real
> data we cared about, hence adding the forced zero'ing stuff for devices that
> didn't support discard.  But that made the incorrect assumption that a drive
> with actual discard support would actually return 0's for discarded data.
> That assumption was based on hardware that did actually do that, but now we
> live in the brave new world of significantly shittier drives.  Does dm-thinp
> reliably unmap the ranges we discard, and thus give us this zero'ing
> behavior?  Because we might as well just use that for everything so
> log-writes doesn't have to resort to pwrite()'ing zeros everywhere.  Thanks,

So the right fix is to replace issuing REQ_OP_DISCARD bios with
REQ_OP_WRITE_ZEROES (plus the check for that).  That'll give you the
effective zeroing part if the device supports it, and you can still
fall back to manual zeroing (and blk-lib.c actually has helpers for
that as well).
