Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4294FC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF1520575
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tJlr25QS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgEFPgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgEFPgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:36:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184AAC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uLdwlLYThu2GMhfI5UQA1Avzjzm1MlfPyC2TTe1wik4=; b=tJlr25QSBZsnbUHrQv8LcXA6L9
        HSDC6ENfq0/bT0GmXBqKy0+VQwY3tUA+mi5kR9iUKdKP6B/ryKUEv/nKnVGpy0wJBUkSR8wxTWOgn
        fckOP6OqGRWTsP2AZMSPkBCZrTToaAYSy8LrtDiOicdo/Cquj9XT4Cde6ZzG2GjowYkbJkedVTnox
        Q57BrJ3TZi8MLC4bErD3Y9jm5Y7ekiQv3Q+4trNhE0qgdttSGk2byAy645VmnRvoQEXKkgW+MZGRM
        dl9weXRXMh2UIRoKth+9auBdHA1LTlIY2YAngsEaHQJcgGhNBYstRU3o/z5NMLgxbe2rB8HTn4FCh
        +A9iwsjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWM64-0001tE-VL; Wed, 06 May 2020 15:36:32 +0000
Date:   Wed, 6 May 2020 08:36:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/28] xfs: use parallel processing to clear unlinked
 metadata
Message-ID: <20200506153632.GD27850@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864121071.182683.2313546760215092713.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864121071.182683.2313546760215092713.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:13:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Run all the unlinked metadata clearing work in parallel so that we can
> take advantage of higher-performance storage devices.

Can you keep this out of the series (and maybe the whole iunlink move)?
The series already is huge, no need to add performance work to the huge
refactoring bucket.
