Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F01C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 08:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3165B613B3
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 08:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhEDI6g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 May 2021 04:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhEDI6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 May 2021 04:58:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E1BC061574
        for <linux-xfs@vger.kernel.org>; Tue,  4 May 2021 01:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qscdINsN0WbkTgWaVjYTzSjaSvc9tTc/ub6sBVFtDk4=; b=CEXZIoe5PR8HySsTKF+otMaivR
        Xx012oQyT7hdoIkPziizqSwD03WFuo+95C4Qxm0l7Rmrv/3CQbdzMt+kJygPtyy2vW7wpl9zsVDrk
        kejEtPv5iVe90Oamxq5btsGKyX0Ieno7fNKxYtXXo1MZ/yBNbM6rhMWuBIOJ6UF0zs8POSXgr2Otz
        Wz1V1CKeIWfUoT/4Xh/pukNUUI+qHtGt03+2fNWDTSG6lMVJ7ni9DI1IBzTEPkyPf7Z2oVd+wRhBU
        pmyaAFOQTlz1vA4whqbugJd+E8w5qrPLtedVHIBIChrn0LVVaZoI/s8XlE1C8KASz9zclGOi7hUBA
        bYGSk2cg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ldqrc-00GMm8-Q0; Tue, 04 May 2021 08:57:15 +0000
Date:   Tue, 4 May 2021 09:57:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: reject cowextsize after making final decision
 about reflink support
Message-ID: <20210504085708.GA3900666@infradead.org>
References: <20210501060745.GA7448@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210501060745.GA7448@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 30, 2021 at 11:07:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's a snippet of code that rejects cowextsize option if reflink is
> disabled.  This really ought to be /after/ the last place where we can
> turn off reflink.  Fix it so that people don't see stuff like this:
> 
> $ mkfs.xfs -r rtdev=b.img a.img -f -d cowextsize=16
> illegal CoW extent size hint 16, must be less than 9600.
> 
> (reflink isn't supported when realtime is enabled)
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
