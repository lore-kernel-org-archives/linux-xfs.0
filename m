Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F0FC3F68F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EE02176D
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 09:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ldSza1sp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgAPJXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 04:23:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40764 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgAPJXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 04:23:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+GthjrsKJEIKgqAF5HxUGneSGB9wSoWWLocB5Hc/jjw=; b=ldSza1spqaStsHbcWoSOq+ZLG
        367sTADOOFYMKbKaLiEv8oT68WmNDE5I6OmtUonAMNDZLvZ8/Uhgg+foTKAik74gga6ck4KJSZdYm
        t3GUe/EfTzpJg2a+oq42/qInL1ag9v3F/naSJHusPy6EIDPexokeq4+qmPWkDpNVb5Ym590i/mqri
        nHB9+Ys0wK5U5RfppCeJ198898NXUeoI4QsX0b7/GvX4zkK0TwMM9x3eTFIzxd5XuHcEG9RZPnEEZ
        0QZLF+u4o3V38JLRffu+YzIyxOSJky960bs5vccjUToLe2BztIbkO7XoML3r3XS9Nut25WeztSuKl
        tYR9S4grQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1Na-00064q-T3; Thu, 16 Jan 2020 09:23:54 +0000
Date:   Thu, 16 Jan 2020 01:23:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs/122: add disk dquot structure to the list
Message-ID: <20200116092354.GB21601@infradead.org>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915144805.2374854.13253824378743886853.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915144805.2374854.13253824378743886853.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:10:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add disk dquot structures to the check list now that we killed the
> typedef.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
