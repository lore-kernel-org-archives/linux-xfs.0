Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63F4C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8182165027
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCEIX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhCEIXj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:23:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6813EC061574
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 00:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q0v96vUeZFiQZpluEDzTY8O3DDrhUau5nkmdjimSXFc=; b=Zjby9Pl/EWiKbBwGR0G5veqwgx
        LtZD7bacrMn0GNCPu1zu6boDY8FvNY0fH80118z87+5Y8tmK/Ki32Z5Jvw4gpirJ97UEFA+MQK+vD
        bKL3ZM+5h6aSWaObQPjW8h/KWiMo14Nl9bGwtgT8LxQmtZeGNcBdEWaCh2IFX5jIfRynW/bVfUXcW
        qUcmJi8MHCaD5yL6fE2/fRhmQPZ6ULftaL7sleezmaga5OMy2EAAZqv9vEO6rAaa0PGbIrIDchiMa
        KbCGzmKyLCN8aOLcPDucPogdp70SChtfYozPi9hwwVi7Cxc9GHwH1RtPEQiwTis1ZGbI3PopAdcNk
        yIDOfHXw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5jg-00AoDA-11; Fri, 05 Mar 2021 08:23:10 +0000
Date:   Fri, 5 Mar 2021 08:23:00 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix uninitialized variables in
 xrep_calc_ag_resblks
Message-ID: <20210305082300.GA2567783@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472412192.3421582.514508996639938538.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472412192.3421582.514508996639938538.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we can't read the AGF header, we never actually set a value for
> freelen and usedlen.  These two variables are used to make the worst
> case estimate of btree size, so it's safe to set them to the AG size as
> a fallback.

Do we actually want to continue with the rest of the funtion at all
in this case?
