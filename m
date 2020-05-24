Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4B8C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 05:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1E3020776
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 05:33:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tMHAjM/h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgEXFdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 01:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgEXFdA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 01:33:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077E7C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 22:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hqE5myBxRS/ap6E0WOHf/ui94kgpEGGfzPxFGAvaUxc=; b=tMHAjM/hIr+fL8VVDprozbV39w
        WysUV49Fz0W1aX7yX7Oi/rBKv+6JVnf35k8QfWFuhOr/bTRPR4xBbCJ5Z2c6BHguHeXX7xYb7Gg9u
        GIKyR1DtWVDk23uiw5qfVESvgynuB+fK2x92TbM3RfBep0kQUuH8gMb1bYEwLsd007MPP3uKJhiVz
        gp1w8fRJcHszJiqXWAVGbX/dHqPDZaa/X28upq735jBzkG1JosRdcr7m0XEocISVyToTWaDYc3drV
        teoIQNnM+8x9/TU5X/otCUuuMEtRJMNYFuLbAe2xbTI46CCdjeLZGboiXaO1uq7kTiLZZPwGz0Qfq
        OODx6ZrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcjFr-0004K7-Su; Sun, 24 May 2020 05:32:59 +0000
Date:   Sat, 23 May 2020 22:32:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200524053259.GA16359@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-23-david@fromorbit.com>
 <20200523113131.GA1421@infradead.org>
 <20200523232319.GN2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523232319.GN2040@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 09:23:19AM +1000, Dave Chinner wrote:
> That's the exact opposite way the follow-on patchset I have goes.
> xfs_inode_item_push() goes away entirely because tracking 30+ inodes
> in the AIL for a single writeback IO event is amazingly inefficient
> and consumes huge amounts of CPU unnecessarily.

Ok.  It might still make sense to move the checks and locking into
xfs_iflush, as the code flow is much easier to follow that way.
