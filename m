Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163CAC433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D875022BF3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mI9Iyg9a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgH0HhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0HhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:37:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89FBC061264;
        Thu, 27 Aug 2020 00:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xv7uMIBubFsUa3JJj4NSseTuK/54PDkvPcIbF9EYCl4=; b=mI9Iyg9arOdrPB/JE4kqaKMJfh
        IXF/on35MpgAQBCEU4wRCtakJxsqGRwU6n0CUOVRxRKr6iuqNU0rWdxpH3jQZLNoka3l2egEYjZy0
        LtsUtVghArYTMw+g+VB9kEF/TfLCFaHe3IPixE6dlFSs43zYp4j2GyI6AIsMt7JloYz1MfNUzzTB+
        1gQCKVviobJDnesIN93iIzBlv6ctolYUulvMo7o1XSHVT3ANe2i30zTumTxd56zOcoBWHKqUBkhGb
        INmQHB3ailO5wGdaNYAEui90G1uSJJbfTFsXOp1l/Hzt6WuMzL03z+aQ9agf4tIgQP4y1oyJ8C7Pc
        9Mlqw3ww==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBCSy-000888-VJ; Thu, 27 Aug 2020 07:37:01 +0000
Date:   Thu, 27 Aug 2020 08:37:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200827073700.GA30374@infradead.org>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org>
 <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 10:29:05AM +0300, Amir Goldstein wrote:
> I figured you'd say something like that :)
> but since we are talking about dm-thin as a solution for predictable
> behavior at the moment and this sanity check helps avoiding adding
> new tests that can fail to some extent, is the proposed bandaid good enough
> to keep those tests alive until a better solution is proposed?

Well, the problem is that a test that wants to reliable nuke data needs
to... *drumroll* reliably nuke data.  Which means zeroing or at least
a known pattern.  discard doesn't give you that.

I don't see how a plain discard is going to work for any file system
for that particular case.
