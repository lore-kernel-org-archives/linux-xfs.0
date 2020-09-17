Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EA9C2D0E3
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A5A20707
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Olkdvh/C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgIQHv2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgIQHvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:51:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E23BC06174A;
        Thu, 17 Sep 2020 00:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K9roFyT/GUCIqKX6bgZhX3vhM2I5W7yauMk6g9dXP6E=; b=Olkdvh/CrD6wDf/W3xwai3da/O
        09i2+G4P5loFnUQ3ULa6ue2NDHpUVy6gteeasrEJ9Aw+XEVLDhwQP4rmOF9aZ7xyGQ+cDnkMY+fcE
        ZWTpvJKDLAc1MG23a/XuphtECVRaQcQSApjdc2P+ls6/ZJDmqdJurC/8kMoY/ckfwUd5oS79qvK39
        5b88oTrn08++IM2iChROwdOAu8i+jdFQI89xmcbooio6TcsAxWafC66uUi7sUdExekaVoDFP5tzAM
        TATwfxJxIwafbVU/cQWAS98T+7iw/8U71/0aGIY9IQON3evq8ax4ZarSvhYRwJ+Yuq7hDWR+hS9Ad
        yN45fsoA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIohE-0006z6-PR; Thu, 17 Sep 2020 07:51:12 +0000
Date:   Thu, 17 Sep 2020 08:51:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 02/24] generic/60[01]: fix test failure when setting new
 grace limit
Message-ID: <20200917075112.GB26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013418837.2923511.12713913160160876814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013418837.2923511.12713913160160876814.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The setquota command can extend a quota grace period by a certain number
> of seconds.  The extension is provided as a number of seconds relative
> to right now.  However, if the system clock increments the seconds count
> after this test assigns $now but before setquota gets called, the test
> will fail because $get and $set will be off by that 1 second.  Allow for
> that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
