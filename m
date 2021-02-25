Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5001C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B6664ED3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhBYIhz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbhBYIhy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:37:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BEFC061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3l8kxor38nJYLXJSvNiz3pqieSlDVvuFpCyM5tkLzSA=; b=gLd+Rkr5zxPEN2jMzDwWA6B9Vb
        DTWJi7O+1OEI137dsOL/AT0nOM3jg9gchaCRLwvN9+1ubFp6WTTW60utcsHhwoYayhI5uqxuQ2/8M
        c20yjq7Dk62r/FO6PZgOy0eEDH4TaxGWC399nF8bA8BKbnBbqEWxVXnqR8sXEvAN2O6miKMV9II1R
        DYEJOqCciyEuMn2glKLPpxAy4qti06LNiEPzrJYfvPF9uF0F2epgR5M6EzJ8uaPsoLV429eZCU4Tz
        nWyVK28JyzSln9tGBb2mKX1+FUBR2uoY0RwkRFXyisWyBljvHUpIfrdpaXO+izneiQR685yvA4URp
        hu/mOkGA==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFC8p-00ATTd-9D; Thu, 25 Feb 2021 08:37:02 +0000
Date:   Thu, 25 Feb 2021 09:34:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <YDdhJ0Oe6R+UXqDU@infradead.org>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224214417.GB4662@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 08:44:17AM +1100, Dave Chinner wrote:
> > Also, do you have any idea what was Christoph talking about wrt devices
> > with no-op flushes the last time this patch was posted?  This change
> > seems straightforward to me (assuming the answers to my two question are
> > 'yes') but I didn't grok what subtlety he was alluding to...?
> 
> He was wondering what devices benefited from this. It has no impact
> on highspeed devices that do not require flushes/FUA (e.g. high end
> intel optane SSDs) but those are not the devices this change is
> aimed at. There are no regressions on these high end devices,
> either, so they are largely irrelevant to the patch and what it
> targets...

I don't think it is that simple.  Pretty much every device aimed at
enterprise use does not enable a volatile write cache by default.  That
also includes hard drives, arrays and NAND based SSDs.

Especially for hard drives (or slower arrays) the actual I/O wait might
matter.  What is the argument against making this conditional?
