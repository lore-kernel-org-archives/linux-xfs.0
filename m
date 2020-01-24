Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85721C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C8DA2072C
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mFHVjwig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbgAXXMd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:12:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387419AbgAXXMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 18:12:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X8DwzQF11cSFD9UYu4h9bRqoXFx0ejUB10RVPfs5slk=; b=mFHVjwigdFoNzrFSuBSnk+kpW
        L+QNTsKJP6o6g6anqbcXiDm8ybbS5ckk5j3jj3IveEe8fYRpDBhYe0GxNjaPeXO+hB3G1eBOfx1n5
        X2TrB8ynRBXVYrEs+89SFltPw4ZN98LYl6ddZNM/5xC0xxL9Be5tyFgUnl94HEhorMQABl7Buf/Oy
        wlrqlUNmTVY/dZZyyu8y4p6w+hBHXDaB2ViR1rwXtpGihL+Zx5wHJo+W++VVS+EYtslNPwxQBK2fW
        ner3IunRDrpy8Nxvy9myav2yb2tDv+bFss+TJ2SpmCy/wxEIwMguwje7CQfaeS5ZVo8wvhG+ftuTm
        pFr+RNFYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv87s-0005iT-2f; Fri, 24 Jan 2020 23:12:32 +0000
Date:   Fri, 24 Jan 2020 15:12:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 12/12] xfs: fix xfs_buf_ioerror_alert location reporting
Message-ID: <20200124231232.GE20014@infradead.org>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984321599.3139258.18182616196423217091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157984321599.3139258.18182616196423217091.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:20:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Instead of passing __func__ to the error reporting function, let's use
> the return address builtins so that the messages actually tell you which
> higher level function called the buffer functions.  This was previously
> true for the xfs_buf_read callers, but not for the xfs_trans_read_buf
> callers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
