Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2B0C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE46B6120F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhIPHsU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 03:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbhIPHsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 03:48:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F34C061574;
        Thu, 16 Sep 2021 00:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Tn5UQV4tSOxccnzIiKY+bhEcGS
        ors3O7VBtI2Hrf1wHSpxz2afRUcAiG/64sxvRQyx+i1wPF1ftBRgkjBor0GPkWOB41LNRM/qPwPs4
        6s9AG/5fMWX0bXJmavvjabpma5ZLqtXxX8JMEH4NS4w09O9soIlrG8GCGd66GmVJcooOZGLK1gFdk
        /iVXLir6Q4BvT7UhPNMqhm/hXWXO+9k8zHxCXJeWdW0Fcgus3BfnWA/zPotqn2T+t3rew/REtM3mI
        itQRnJma8sLB/p2yUyLFXe3KSe9+tcZlNyAvPvoGI+VBs2Wtr4YIPHwqzds5ax4dyUoTmgxLjeN9o
        CiT2bS0A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQm6E-00GQg6-Te; Thu, 16 Sep 2021 07:46:36 +0000
Date:   Thu, 16 Sep 2021 08:46:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] common/rc: re-fix detection of
 device-mapper/persistent memory incompatibility
Message-ID: <YUL2Um4DP/wWWBfp@infradead.org>
References: <163174932046.379383.10637812567210248503.stgit@magnolia>
 <163174932597.379383.18426474248994143835.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174932597.379383.18426474248994143835.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
