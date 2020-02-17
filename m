Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51E4C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A906E2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YRTWRktZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgBQNps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:45:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51434 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgBQNps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZJaJ8TJGBGpoQ+UcrPSFkiQr7s55YP0j2mYf0TuC9JA=; b=YRTWRktZIeR5yO4frkoYVn5VT8
        WzhddYSxHcqMKw3idjt5hJ15PBeKS0IfbZktW56KXHlHYHgxMuL/eMaDpFbBpkYdA3NRoc279He38
        XdMDelH2bvEt3o8M94vtf7O8Ol9yISqB7GHzAIlwcvkK/Rlfcsi4+Mn+tAU4eC+kqnfksF9r9adh9
        lH/hZgx0/0rRCMmq55n8zxYp4/LqZg8XgLNGNNT9XG4nJ1KqFLk/ac2SLYYmoqirJUCkupYkrAQEw
        ygAFR37NVX+FzpFqIbhV7pXRZnSgtwPdrvdyIIonW6S/TmgIdEpWI8SQUDNXudvRpKDUUZ7X9fyQG
        IfzzSvlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3giY-0006Eu-RD; Mon, 17 Feb 2020 13:45:46 +0000
Date:   Mon, 17 Feb 2020 05:45:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: re-sort libxfs_api_defs.h defines
Message-ID: <20200217134546.GA18371@infradead.org>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086357391.2079557.7271114884346251108.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086357391.2079557.7271114884346251108.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Re-fix the sorting in this file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
