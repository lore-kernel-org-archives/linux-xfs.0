Return-Path: <SRS0=2Dxs=CH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79A7C433E2
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B73D72137B
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Aug 2020 06:47:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="THxzUJ1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgH2GrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 02:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgH2GrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Aug 2020 02:47:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69A4C061236;
        Fri, 28 Aug 2020 23:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eHjOevIaVBKwVisRXTUJmUg7pAYLM1iHHVfRC0Uy46Y=; b=THxzUJ1KYsURtTsPuJxQ3fCzL2
        NSPeq+PSRLFcdzFKqadHtNwq7EXOKZp40riMIsM44+YMK++PHtcxZXB23HvVKNyFOCdllTAJWl45v
        I8YTu0HLoQ3yhw7CcfyDH08LlYvAq057oExyThX/Z2lPjqyDI4NxrbDrwSGJsVLZOzs53puPZGK6l
        SN18ju6carORCCv/3FzgcT55QNpn7GcS5gh/ix9E/CEy+CRiY1D1UpM6HnoZu/YdBFrpRb1ZEhQsJ
        DREmPce3sIj+nrHliovXnrppxGTVVI6+9JaGCg8gxU8jEtfXHPHlRQxsbquKHYiI+7cRAxC3fZt+1
        ISap8zeA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBudf-0007pL-Uv; Sat, 29 Aug 2020 06:46:59 +0000
Date:   Sat, 29 Aug 2020 07:46:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200829064659.GB29069@infradead.org>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org>
 <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
 <20200827073700.GA30374@infradead.org>
 <c59a4ed6-2698-ab61-6a73-143e273d9e22@toxicpanda.com>
 <20200827170242.GA16905@infradead.org>
 <20200827183507.GB434083@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827183507.GB434083@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 02:35:07PM -0400, Brian Foster wrote:
> OTOH, perhaps the thinp behavior could be internal, but conditional
> based on XFS. It's not really clear to me if this problem is more of an
> XFS phenomenon or just that XFS happens to have some unique recovery
> checking logic that explicitly detects it. It seems more like the
> latter, but I don't know enough about ext4 or btrfs to say..

The way I understand the tests (and Josefs mail seems to confirm that)
is that it uses discards to ensure data disappears.  Unfortunately
that's only how discard sometimes work, but not all the time.

> > We have a write zeroes operation in the block layer.  For some devices
> > this is as efficient as discard, and that should (I think) dm.
> > 
> 
> Do you mean BLKZEROOUT? I see that is more efficient than writing zeroes
> from userspace, but I don't think it's efficient enough to solve this
> problem. It takes about 3m to manually zero my 15GB lvm (dm-linear)
> scratch device on my test vm via dd using sync writes. A 'blkdiscard -z'
> saves me about half that time, but IIRC this is an operation that would
> occur every time the logwrites device is replayed to a particular
> recovery point (which can happen many times per test).

Are we talking about the block layer interface or the userspace syscall
one?  I though it was the former, in which case REQ_OP_WRITE_ZEROES
is the interface.  User interface is harder - you need to use fallocate
on the block device, but the flags are mapped kinda weird:

FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE guarantees you a
REQ_OP_WRITE_ZEROES, but there is a bunch of other variants that include
fallbacks.
