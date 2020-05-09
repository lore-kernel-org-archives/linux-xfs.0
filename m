Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3D7C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D9820735
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hgkhC+Ez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgEIQgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEIQgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:36:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A38CC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 09:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yxnmS895MLcJ49TOqJhD8jEmubNJl0GrHsq4Jfr15AA=; b=hgkhC+Ezd5D9Oo7Xa10mMY+S5p
        oC4k8TIp31mj2+yz5a0KSDHjGeGiEJXpawtdVhB2Jj4PQFVxVOd/Urw4dnRulcXzvfoilUAFepLM3
        UBa5JIpZcxwxKzsmNJhpmXnTHzpVD1VbxpzmvNHuaYTn6Y9ZUWgeOaSYEzMYiwVI/QB2wDRdNsqbU
        pgcj6eYs4utve5eHpYGzpQ7ARAp7ir/+NY6mOmu7s5c/tcxs85uMHjH90A2GmJ4v9NdJr56gnFiX6
        LIm3TAyKHzjM/jswsA5R3g7FkJws68yxxfFkTUO8Bhtvl9mIyjc2/ZFkQsJOZYpPC2wxlA+9mO4is
        gFsE93IQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSSy-00005D-6Z; Sat, 09 May 2020 16:36:44 +0000
Date:   Sat, 9 May 2020 09:36:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] find_api_violations: fix sed expression
Message-ID: <20200509163644.GC23078@infradead.org>
References: <158904177147.982835.3876574696663645345.stgit@magnolia>
 <158904178381.982835.124483584305094681.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904178381.982835.124483584305094681.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:29:43AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Apparently, the grep program in Ubuntu 20.04 is pickier about requiring
> '(' to be escaped inside range expressions.  This causes a regression in
> xfs/437, so fix it.

Mentioning the actual sed version would be a lot more helpful..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
