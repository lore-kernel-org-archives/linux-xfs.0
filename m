Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18091C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 10:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB39B20658
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 10:41:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CcwcUoRb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgCPKlH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 06:41:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730661AbgCPKlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 06:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sSddVtaisXa0HMkn6tVU5Rk7Is+x30Yu5k4SaTEcUq8=; b=CcwcUoRbZG/2kF6H/urmdx7ntS
        I3b40GkrDSGV4zsX3ZVwS4djRmty5js1d/GKhxkq/2QQ1uS1IMphRvK7oyKk2w3WeqbN3MNMB8Kha
        6wGwis7YBHlcVILpsgu3sSECo0c1dqi6kbfsJMg5vZotTIiuv/byhPSDA5U8TTkkG26lawN6Ee+CU
        zKCxB9vMS4uxLXaHS3PjFu2S49elM5OOS+1Ot11rAnrjdQUvDQYPoWNWwW76u4L9mOF88Gr1IoxG4
        gtmmH43+3vFAS8lSOHUgR8YsOVsLrPWMv6QfjEsWctKG3qQyWgL+o+VwS572SaKDhn2lSI3h6P1Fs
        oRuC0eiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDnBC-00052M-Hq; Mon, 16 Mar 2020 10:41:06 +0000
Date:   Mon, 16 Mar 2020 03:41:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/7] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200316104106.GA9730@infradead.org>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431624662.357791.16507650161335055681.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158431624662.357791.16507650161335055681.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 135f4478aa5a..3b0b21a4dcde 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -41,6 +41,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_bmap.o \
>  				   xfs_bmap_btree.o \
>  				   xfs_btree.o \
> +				   xfs_btree_staging.o \

We only needs this for online repair don't we?  Can we exclude the
file from the build for xfs configs without scrub/repair?
