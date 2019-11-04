Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC68CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6A4720663
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tvi1EuEW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfKDPWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:22:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKDPWW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:22:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rA62TkNYX0OksT5/rxnzawkf2upNWkobtf/cpXoav7E=; b=tvi1EuEWimuYPvOUYvy0R6FJT
        EaD0pPpLAaBpe5xqu0UB58+TeI76ziopivQQOhFFljObQpiwhxG5hZ23wht3OV81YHlWvYdaPFYJY
        z2Kc1MzEJczAqu2ynhRSc6VTBMAISAdnVAmXtL+36+1boUFKTIwV0b+yiq/K4+nl4cUKTkvvRYnjU
        Byv7SFUMq1pnjdA2G/ltcUgrPOI5g2QRGFLaVVQ8v9LieLcxm6O1O54zBy9sIJ0+zgKxPrO9dLHl+
        Pha0bsoJz9HXHFvhb5b9VA032nUhVgLgIyGa6FyYPKWCPG+za76tDcfPgpJNfP5XxI05rbtj9gOTY
        qGUz9+tdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iReBS-00089Q-1P; Mon, 04 Nov 2019 15:22:22 +0000
Date:   Mon, 4 Nov 2019 07:22:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: tidy up corruption reporting
Message-ID: <20191104152222.GC10485@infradead.org>
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281982341.4150947.10288936972373805803.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:23:43PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Linus requested that I audit the XFS code base to make sure that we
> always log something to dmesg when returning EFSCORRUPTED or EFSBADCRC
> to userspace.  These patches are the results of that audit.

Do you have a reference to that discussion?
