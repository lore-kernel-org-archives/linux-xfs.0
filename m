Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC29C5519F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937F821D7E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jl9CRas2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgKNKst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 05:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgKNKss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:48:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7837EC0613D1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ctUpxS+f6himlesII4YzTMKXOmend2wS+y1MG7ssqbE=; b=Jl9CRas2LCH3b9x3nvEJKaq90m
        BTBW1Ig+93XaCCapkHOYfbJsDrSbs7FJOE86RY/XKy0pigtAa8JNWM4ZKLhLgDFoelnGjm0CC7Fcr
        G2SqApOyU4hvRZ79chutnyklsi4LySmt7aH3kZpGkKQFRz8+/XI8TqBW3B1avF+xo2ntvxim3lMxp
        AH6wbMk6ZNe9lTREtsa8DhSNoh2+LDDtSxuaedEvrmfpLQHJds+Ki5t8PNiYcY8AruphE4ZAlAWj7
        OjvZe+cTlY09H0W4Di0fH5S2he3aNPyNb9HiKAsvO2SQ5FejEGpviy+UR5icXNvIfsRz2DXSz6rKU
        /6qb6oPQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdt6q-0003Sa-DO; Sat, 14 Nov 2020 10:48:44 +0000
Date:   Sat, 14 Nov 2020 10:48:44 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: add realtime extent reservation and usage
 tracking to transactions
Message-ID: <20201114104844.GH11074@infradead.org>
References: <20201112174345.GT9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112174345.GT9695@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 12, 2020 at 09:43:45AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> An upcoming patch will add to the deferred ops code the ability to
> capture the unfinished deferred ops and transaction reservation for
> later replay during log recovery.  This requires transactions to have
> the ability to track rt extent reservations and usage, so add that
> missing piece now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> FWIW this should have been a prep patch ahead of "xfs: xfs_defer_capture
> should absorb remaining block reservations" but I goofed.  Sorry about
> that... :(

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
