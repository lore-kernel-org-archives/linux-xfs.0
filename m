Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEFBC33CB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69B86207FF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TmzNAWhi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgAPJZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 04:25:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40846 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgAPJZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 04:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sbKG23v2crouUVJ+NHySAIRBE17s5tM5boJR1h+kGwY=; b=TmzNAWhiFe/uU2pBXGyXGMhIR
        UE1HKCVmZ6Bl1KxlBCb5s8NEkLfoOhzthX/Xm1+sJdkeBwMMfBCJjXHciamlj2VJEeSSBTOid/uyq
        q3UayMghcWjRFJbHLkckQF/iF2HxE5HiTCwS1hkTaETHKHqM6D4MDVsPynzKRpVTU/alGIY/g50cZ
        GCkBqiLoxpCZpd4rzW0H1OTxK3Djhx1GGoo+09nIgfFetTInsIuZt97d0EqkxJ6Q5W2wkk51ZK4Ms
        CcFgn60G394CJ1wNVJyV3uBfGbAh96oXOAjwn8cJ71kbc8zIrAdxkAE8DXCMl0RQVfE11zwtma/1s
        Ol38hjylA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1Ok-0006vR-9v; Thu, 16 Jan 2020 09:25:06 +0000
Date:   Thu, 16 Jan 2020 01:25:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/7] rc: fix _get_max_lfs_filesize on 32-bit platforms
Message-ID: <20200116092506.GE21601@infradead.org>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915146694.2374854.4708773619544238610.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915146694.2374854.4708773619544238610.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:11:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The 32-bit calculation of the maximum filesize is incorrect.  Replace it
> with the formula that the kernel has used since commit 0cc3b0ec23ce
> ("Clarify (and fix) MAX_LFS_FILESIZE macros").  This fixes a regression
> in generic/351 on 32-bit kernels.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
