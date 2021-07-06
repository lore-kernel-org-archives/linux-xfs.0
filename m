Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A40C07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 17:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F8461C5F
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 17:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhGFRVy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 13:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230141AbhGFRVy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 13:21:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA33761C5B;
        Tue,  6 Jul 2021 17:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625591955;
        bh=sH404mqM7gdychrrefpxi/stNaxEx76o5lay6QyuINA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BvvPhojx1bLS/Lakuu2tuDQiZs5E0V+e8y7SipD2g/BnwLJ0DSyfRGqjM/d1zU42D
         Q1EXZDBgR8h0uxT/oZQqB8qtElEI1F/uxKS8pZ4aS69OtvFbh5GV/BrADAqvlkBNvH
         4g7/6dD0toiGNSQu/GSLLW9MVc/DC/3FKE9QkbpVnFBbxedY9+4EY9ESUAHybBc5rB
         cvBTk1bvjFMgXWuKo0+cjcFc2ePx7FjVhRm6H1IrFvADEZ2kEvCp6D4TBHJ6D9msK8
         91gPTL7sM0Jv5bBmptDA6XPpMzhw/lGSVfpG8EL/0+JwNPEJ0wEX/hBLksLiwMyoN0
         pqZ0wE04ji+jA==
Date:   Tue, 6 Jul 2021 10:19:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix warnings in compat_ioctl code
Message-ID: <20210706171915.GA11588@locust>
References: <20210703030120.GB24788@locust>
 <YOLGKMyrVNMmGX7g@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOLGKMyrVNMmGX7g@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 05, 2021 at 09:43:20AM +0100, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 08:01:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix some compiler warnings about unused variables.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> The change looks silly but otherwise ok.  What compiler gives these
> stupid warnings?

gcc 10.3, but it doesn't matter because the kbuild robot says this patch
creates even /more/ silly warnings on other weird architectures, so I'm
withdrawing this patch because I DGAF^W have decided that chasing unused
variable warnings is a bad use of anybody's time.

--D
