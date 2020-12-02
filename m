Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A49C64E7C
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 10:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC70221FA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 10:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgLBKRM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728730AbgLBKRM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 05:17:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46FEC0613CF
        for <linux-xfs@vger.kernel.org>; Wed,  2 Dec 2020 02:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Gs8fwXbjUljklEMwx+2Skp6Yf2MTc9CliQpuurEvt0E=; b=ChUmF7qPyAWuDqhsjjr2w1ZdnM
        mA+k33R4/Czo36fQzhMAsJfMBIYJPTTdV+d6aIJmpb9RaAORwM8A3hp4zuPvCeK7lmRWcPt2wAom1
        8IsmcosEd25x8+9p3QQd46DIB8T/lh5vq8An5Q3SQDHApYFhH+V7miDlNZZ4NlCPE1MNR6VCf0Qd2
        77rKiKeBGSnG9N45mENc+TX0rT+ZUTSUFU0ITOxTC76OMhX1vkY/3LMaCgOEKTQ00pGUZy49Nb5dP
        GCDTdJziAMkPp5DCQK9xP5rfJ05VAzUkKtx9vvhLiyCUkG0MKsEKRE3Azzz5Jzs4xiiznxhh0K9If
        3ZgrnGsA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkPBW-0005AY-2u; Wed, 02 Dec 2020 10:16:30 +0000
Date:   Wed, 2 Dec 2020 10:16:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: don't catch dax+reflink inodes as corruption in
 verifier
Message-ID: <20201202101630.GA19762@infradead.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <4b655a26-0e3c-3da7-2017-6ed88a46a611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b655a26-0e3c-3da7-2017-6ed88a46a611@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 01:16:09PM -0600, Eric Sandeen wrote:
> We don't yet support dax on reflinked files, but that is in the works.
> 
> Further, having the flag set does not automatically mean that the inode
> is actually "in the CPU direct access state," which depends on several
> other conditions in addition to the flag being set.
> 
> As such, we should not catch this as corruption in the verifier - simply
> not actually enabling S_DAX on reflinked files is enough for now.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
