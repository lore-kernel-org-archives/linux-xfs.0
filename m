Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DCAC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A988F23120
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 06:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbhASGxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 01:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbhASGxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 01:53:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BDDC061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 22:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KFx28UM0DRp0SxVngQvelYsnwKYSbanyYuOfEP0sf18=; b=PZsNQOldMdVYyh8PJ9lgGZP4p6
        briJzlq7L2IALBoN4tGgGM1C71/hJPcf/2QnbUgY7EQbI9hteqX4L3Cj2AYrfnmDtW2FxKAkat9y9
        9yVEZa1ETIwlwhzYd4vwrW2N/sg9hR0+xobPlFFKQjgB9hLvstxrg0pywTAlXX07F+cmDn46VFOTR
        IHIDJYA/kgYRWihxNQWOq03i2OfZKzlvm/Oqwq8N/BktjdUWpXVSl3SVAu/y9LAmT86827ceW71QK
        3IsZQRgLU5/phls4cIcHYtsFx9ss49aFp6DSupCTzETUVMBs/zrtovVZ2zrFEJ42xu+1xVILSzLL/
        uCJyEw3Q==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1krz-00DvQA-Im; Tue, 19 Jan 2021 06:52:13 +0000
Date:   Tue, 19 Jan 2021 07:49:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <YAaBD6A5ZmfLjtNS@infradead.org>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
 <161100792917.88816.7369361459458348804.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100792917.88816.7369361459458348804.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:12:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't stall the cowblocks scan on a locked inode if we possibly can.
> We'd much rather the background scanner keep moving.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
