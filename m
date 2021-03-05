Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FA9C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C879A6501F
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCEIbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCEIa7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:30:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78ABC061574;
        Fri,  5 Mar 2021 00:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cREsF1ojdb7G9ip0LEJezo6tZgTsN1Oz0UtdrUhM2ko=; b=q9Yynna7/cYcz5lv4tz2AveC/P
        fjquLlkS79K9HSJIyTPmfSbdl6Ry2+ZFFQ45sjpZyVFnPBKAHJmKRNqZEs1pAQx9/S+hWfWhsGObb
        zTpLGcH+56TlJLDHN/Nedav///Yc7Y8i231v2QvS3SwlnY7aw/UP7NhrKnpdyrLM8SL5pRhvXNZ/6
        ycmuMBuZI7C3GU8fNw9rvKEchz6rzrDsTR7RJQ7waAPFfxe6kg01wIpZQcIHvedWsl/sHaQvuOxSL
        fSWACj2algWgnTQuiz6fHkkxVnVvvetG5byKeex7Rpo5zMdgheOGyt6HFekltEqrjeui88wKGybiW
        ezDoGkkQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5r5-00AqBr-70; Fri, 05 Mar 2021 08:30:39 +0000
Date:   Fri, 5 Mar 2021 08:30:39 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/4] generic/623: don't fail on core dumps
Message-ID: <20210305083039.GH2567783@infradead.org>
References: <161472735404.3478298.8179031068431918520.stgit@magnolia>
 <161472735969.3478298.17752955323122832118.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472735969.3478298.17752955323122832118.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 03:22:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test is designed to fail an mmap write and see what happens.
> Typically this is a segmentation fault.  If the user's computer is
> configured to capture core dumps, this will cause the test to fail, even
> though we got the reaction we wanted.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
