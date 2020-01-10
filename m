Return-Path: <SRS0=1MH2=27=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770BDC33CA2
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43A9C2072A
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ezsISvtn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgAJL6X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:58:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbgAJL6X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NZLziClpk1lPJCzb/G35TvpYvi3T4+5kkBkKhDyObg0=; b=ezsISvtnZwWscE3ciciEgeq8s
        NITz2Jy+lW0c4XhQuqgKhe2WQGq/yKUAWIUTZhNhLOY8IS50ycPKVNPLV3ulV0bU3Q4DK/OUK3z1C
        gXl60W20FBBU88v1MVaao/StZOB0DiaixkFOd7YM3AGLFuFhrmcmR9TCO6FfIlXqi4Mx0T+fBpZmF
        pEaz5kF/ChoibTKXs50378JMN/vclQOGZDWBRtKDOEL1ngQ1tKXalnRBcQsmpnwj9n9vfeJCrKosh
        cXkTJQcdWRyml4+yec1WxyHMZgl2F5EQvUtawDBhAMEqwW8j8A9yyTGhKkdyFqBpJjrJQQcIbXLI7
        aJgjl2ZPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipsvn-0002nP-Ej; Fri, 10 Jan 2020 11:58:23 +0000
Date:   Fri, 10 Jan 2020 03:58:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: complain if anyone tries to create a too-large
 buffer log item
Message-ID: <20200110115823.GF19577@infradead.org>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859550791.164065.17052138010295333685.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859550791.164065.17052138010295333685.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 10:45:08AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Complain if someone calls xfs_buf_item_init on a buffer that is larger
> than the dirty bitmap can handle, or tries to log a region that's past
> the end of the dirty bitmap.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
