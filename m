Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D2DC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 17:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F280020737
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 17:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hw34L5cs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgH0RCp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgH0RCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 13:02:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B04CC061264;
        Thu, 27 Aug 2020 10:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/P1CBRr7WnQXAFXX1qifS3jS0DbNGykoEg2K9mn9nSk=; b=hw34L5cs2lB4lAA4qKHfCJtLIu
        GT0mXeKCC/apWuXnxLPv7Sc45Tj4qsMD3vZ67spwVVXssrpH2lD5CJkpUrRH+c4JMXpUBYuIumNgD
        bxi4tK3Ujc3kH6Kou4EWyLsAdSqpCT5KjSL414YOd+nNSqU2Y2/QDVCp6ZmbFLvqyIz4lnRvucAXF
        SDki+CukCWH6ITPeDtAIr+olPxuKhzZh4ZTXuFPb4NuFOhwyyJLd/nlEbOrClCqVrnxPMGLVT030d
        zJ7uUpceDKhRxfSzfgdLEQDAzUsmcw8C7Nq1z6OYFckRXwosEq/EwhUQPoF6ARqMhLJ6W5BREan+s
        CGz+BNDw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBLIQ-0004Sb-Bl; Thu, 27 Aug 2020 17:02:42 +0000
Date:   Thu, 27 Aug 2020 18:02:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200827170242.GA16905@infradead.org>
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

We have a write zeroes operation in the block layer.  For some devices
this is as efficient as discard, and that should (I think) dm.
