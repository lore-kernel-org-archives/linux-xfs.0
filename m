Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AB1C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA7D22BED
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DvYQCihI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgH0HCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgH0HCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:02:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE38C061264;
        Thu, 27 Aug 2020 00:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y14PR7vEoAxt2obEPID1Vajcbw7gBwRiB+nqg5pFyH8=; b=DvYQCihIgcV6v3Nlkuw6pmeFkN
        /2z1eWEW9N6acMfWl3yQvKQamKYNUu7jX/1UORrUbuncLxQ6V3+KUUlhYAV/520DekGLEm8VvmGGF
        whdGdXMRJNRPUWIDfbY/Wl4KX+BLrJFYMM3dPZbwXHix8mRuLiqQ+zb2H5UDU7QDFtp8EUC9nSdQ7
        0BiylTZE86nCAXL3G+8gYgbAnU5AFk5RyfeuLziKYJZY3XHxyhfpUDD5dYE80LR6gk+bAstQETlKo
        VMOFeSWrwHOgwlYsTgROXpd0A5199RwqtGkGvV3L26O7jnJ7pGtx5TdBGAYyOnMeDS3dGayDacocv
        dHRSwNRQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBvh-0005pk-O8; Thu, 27 Aug 2020 07:02:37 +0000
Date:   Thu, 27 Aug 2020 08:02:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200827070237.GA22194@infradead.org>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 09:58:09AM +0300, Amir Goldstein wrote:
> I imagine that ext4 could also be burned by this.
> Do we have a reason to limit this requirement to xfs?
> I prefer to make it generic.

The whole idea that discard zeroes data is just completely broken.
Discard is a hint that is explicitly allowed to do nothing.
