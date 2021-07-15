Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA66EC07E96
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 05:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D2361358
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 05:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhGOF7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 01:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbhGOF7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 01:59:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FB1C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 22:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+X3fTJCXKJNeIb5d98dnP62jYzyh5KwKKjDY6gPSVmk=; b=We5p69nYpQXOCHHwESm1+jZ9fT
        V9uH/WqRmJqUNS+Im8yvhnv2eVMYy4VBflURulbPOLYVOfu+gISlvqirWUtQsqu7z7Z1RxRsxBdYY
        jGUM5vUBe94Mp4WIvavI1YP36nFMntPYla302EDXddP4LvMaSrS8ahBJlmMD8qUnpPOwvu/ykznco
        P5QP1uQr1hmI8bEUVobsLIDR8MXJLHMzhk5xkBgYe0YJ9TMt47o/TWbx651PYB6kDe8Ex0JEfowWA
        iI3YoaGxzg4CuIU5FYdBxB/cyOPFwNFdyTX/Bt3swAScd7tltMKawAvKOPKto7bpk5J3TobmGJiS3
        dpRhj2PQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3uKt-0032Ky-Jn; Thu, 15 Jul 2021 05:55:15 +0000
Date:   Thu, 15 Jul 2021 06:55:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <YO/NtwOVVanEl6HE@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-4-david@fromorbit.com>
 <YO6LCbZWRz3q4JRg@infradead.org>
 <20210714094533.GY664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714094533.GY664593@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 07:45:33PM +1000, Dave Chinner wrote:
> That's what happens later in the patchset. The XFS_FEAT_ATTR2 is
> set when either the mount option or the on-disk sb flag is set, and
> it is overridden after log recovery (which can set the SB flag) if
> the XFS_FEAT_NOATTR2 feature has been specified.

I see where this is going.  I still think keeping the logic changes
together and killing XFS_MOUNT_ATTR2 here would be preferably,
especially with all the documentation you have for the attr2
situation in the commit log here.

