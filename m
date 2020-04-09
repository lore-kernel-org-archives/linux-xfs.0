Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF82C2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB0B2075E
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ebs/thzW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDIHoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 03:44:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIHoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ebs/thzWHNWHdsSbFhQNw1Ubqi
        YUyP/QQed+WD7cRdAO/F4fqxkio4KjZbOH8HJSk0epHHKbGxycVIkjCJTCjuGjlnfgGgL1u4xWAQF
        srNGMcnaLIW33e5Y0rcHuHMesY32W/snyPBl0cXrMWBBTX8vUiMqMdIq5G+EjL66aO0q2m+9odxds
        gZlJGRWe/7Ev33D6exRJg/oKBTIfsJFmg57aXFSciigr3Aa+KXOU/DQzcboi0D46CWJY73NQEExZz
        t533NWfiH4CgSaHjkeO56uLx15FUEKIamtDV1eQvkFJvgggSIJAWnEmaaSf008WplugQIjzWf0hbI
        Jy0B0Tkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRrC-0000H8-Hk; Thu, 09 Apr 2020 07:44:14 +0000
Date:   Thu, 9 Apr 2020 00:44:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_repair: fix dir_read_buf use of
 libxfs_da_read_buf
Message-ID: <20200409074414.GG21033@infradead.org>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619916916.469742.10169263890587590189.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158619916916.469742.10169263890587590189.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
