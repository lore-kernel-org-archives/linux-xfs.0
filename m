Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C89C07E95
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 20:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C851F6121E
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 20:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbhGSTTI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 15:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382857AbhGSRnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 13:43:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B063BC061574
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jul 2021 11:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MPMlGxYJHpz5k5b1SlpCjw0QkJWjJdajs5puxsg3eOE=; b=aw17msLk+YEjvs5iGBrueJEZvP
        VFe0/35tGPFE6EUIarhG/eTgaLN5rrFZEQ6WHWBLw1/WBuQwzsyKi/yP1cz65LHcZ9hRAHja5fdiH
        5PKnitbYpELJCWtoO/pIbzIT+TohWCt1Jr1Ki8PD5QUN0kY+T42IkUbDGiISlcoD2b47Zhcqq0rP+
        v30NyCQxWZGgRCSQG7prDDjod33iE74+lZyTIi4QYO9II2sQ0VputRvoCVmR+VSeDhY8FcgEXD6k7
        rhnER5Oc7VVXQXCbiw6cIqtgl7uNnBSUMzF62lKJsJH7l91ec81MK5YObFbVV35cEGuOAq3nn8ARa
        K4ImJEaA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5XtQ-007Iy9-T9; Mon, 19 Jul 2021 18:22:09 +0000
Date:   Mon, 19 Jul 2021 19:21:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: xfs/319 vs 1k block size file systems
Message-ID: <YPXCqMUoSLehQqde@infradead.org>
References: <YPVSBie+Bk5FAngH@infradead.org>
 <20210719180015.GH22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719180015.GH22402@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 19, 2021 at 11:00:15AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 19, 2021 at 12:20:54PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > xfs/319 keeps crashing for me when running it for a 1k block size
> > file systems on x86 with debugging enabled.  The problem is that
> > xfs_bmapi_remap is called on a range that is not a hole.
> 
> Hmm.  Dave sent me a warning late last night about some sort of log
> recovery problem in -rc2 due to FUA changes or something.  Did this
> happen in -rc1?

I've reproduced it all the way back to 5.12 so far.
