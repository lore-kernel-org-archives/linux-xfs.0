Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561ABC54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2658420704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ovuZr6Sc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDYS2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYS2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:28:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A20DC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8APCyObPV0JKo+exrR4uXV/8d5mcphMhqbaA39MytaA=; b=ovuZr6SczrvxvG/aOEUnLOtb7R
        E0/WMKK4NL5qbgghrByIcaCVAtJVUXVH6mTJEdlAaQAvXX3JBoGUPvtclhIuY2D6iV0eSa/IzYmUZ
        fPai8JPkMc3XxeiXSlCy85kyU5CpZ99QX8GCY+wqwSOsmRSnL50rp1fek5bm6VAOxqv4IP06CiJQA
        xrlK/6fCJ47dI3olSsISmbqM+J3lKGBQ5TJPmAHIWwsAmkSPjzL09uSNCg1h85dCMsZJnmMy+z3Et
        aW53Aofwj7AMMfqVGdTfDmtcCk3G3ynSM3CEUn7bThg610hmwRghzi6cgGOjdXEuPXxP3yJkyxbHv
        gliT0pYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPWz-0005HP-84; Sat, 25 Apr 2020 18:28:01 +0000
Date:   Sat, 25 Apr 2020 11:28:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/19] xfs: refactor EFI log item recovery dispatch
Message-ID: <20200425182801.GE16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123303.2140829.7801078756588477964.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752123303.2140829.7801078756588477964.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:07:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the extent free intent and intent-done log recovery code into the
> per-item source code files and use dispatch functions to call them.  We
> do these one at a time because there's a lot of code to move.  No
> functional changes.

What is the reason for splitting xlog_recover_item_type vs
xlog_recover_intent_type?  To me it would seem more logical to have
one operation vector, with some ops only set for intents.
