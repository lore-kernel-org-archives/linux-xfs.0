Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9DAC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 09:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238584AbiEJJl1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 05:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbiEJJlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:41:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F3366B4
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iYCbcLkhfThrAsgj2YZ54p+ToT
        KmCrFun2WOXmKHiXpZQNjiIPRyIIO8YojYpoejfH081Vc8Co53r1lzPkftHqvhQP83CgMFgpK84lB
        Qh7tgCnqKDzsYaTXLyW0oFQQwXkA0poKr+DiG6idabdm72sq/aa/55y0Y6fMx8TkBop5HfSk57ihz
        g+QFJEMJdWoYDlCykV90r+wCMICazJhn1W75xceGr1IPMC6dMAgbZecu2xoQiftZRWfnMg4O3BBcr
        FxDLMpTfIfkrOif2dvymr4S2R1KwbTPON4CbaKDJDWYCqRdZQOhVeXqj6dnca3uRjC8OP9s9SMDe8
        rX+qGvWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMJ5-000sTT-Bh; Tue, 10 May 2022 09:37:27 +0000
Date:   Tue, 10 May 2022 02:37:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: support multiarch for libhandle
Message-ID: <YnoyVxRWqE9eooQm@infradead.org>
References: <165176661877.246788.7113237793899538040.stgit@magnolia>
 <165176663588.246788.12144011845413653233.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176663588.246788.12144011845413653233.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
