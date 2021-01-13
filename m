Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAF2C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32DC623441
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 14:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbhAMOrY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbhAMOrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 09:47:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3667C061795
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 06:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iYG0d3R20pVLjT7InAnNq6u5IJHXska8rgmpYARgYgQ=; b=meDL7Lwq4N85V6J6FstNI4TNHu
        COFJoyxFaTPAnTIPBWz2Udpd3BPmQymmsXUKF3IUTzacgW0ABIPIQq5vFOgWjBlhqTmdDkyG+M7Y3
        2gkoHhUiINSMdopNy6CMQ/k26REV88+RK69cjR6TpQh1gq61JEIOmdEmUu2hPAcaWTilH03riAKyd
        DzzZuITisO1vHFLuR3nL7Du1lfYoGfdjoYt5jiwmNpYWWf04BgrZ1oNx9AkoDyWRJ+5oviQG3oSLN
        ojdPt/rXbOhkayJ5acIVaScqLpVaSEf9wEzfbdYEV+Fg/4gnLrYsv+CoSUIAfS521hBwHbQwerAoV
        evUwtUkw==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhPE-006NLJ-S3; Wed, 13 Jan 2021 14:46:00 +0000
Date:   Wed, 13 Jan 2021 15:45:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: xfs_inode_free_quota_blocks should scan project
 quota
Message-ID: <X/8HnpL3nVbEjmHy@infradead.org>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040737875.1582114.10240657258164907570.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040737875.1582114.10240657258164907570.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:22:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Buffered writers who have run out of quota reservation call
> xfs_inode_free_quota_blocks to try to free any space reservations that
> might reduce the quota usage.  Unfortunately, the buffered write path
> treats "out of project quota" the same as "out of overall space" so this
> function has never supported scanning for space that might ease an "out
> of project quota" condition.
> 
> We're about to start using this function for cases where we actually
> /can/ tell if we're out of project quota, so add in this functionality.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
