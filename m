Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B21C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4468F20775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h7nAV0zO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgGAIvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgGAIva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:51:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5EAC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mJV/G3iPx4phxzBEkkXKJNwANmlNV3IRXgge2yHAMhc=; b=h7nAV0zOX1BuEzimomzywe5y/Z
        ZLk0My9fjRHx0PF5Mj6XREl8A2vo42nN9aGglVtaAYGBkSD2ssDrh0i3gO2UupzZIeZpQXgDRlkvM
        /awRkvtcyoJDUpn11zaphEUjY6IvqzfE7mTKSOmPvDghwSL/n2M+tt1ZRrCvldIXgz2omZKzR6fcb
        MZ6gKuSZAXfZdiWqm/5bd/SN0slO+k1o99QUQvWtMfK/kMpGiSFcsEufuKxf4DX7h/h3+uy+QLQCz
        iRJJ7d8QzMXylgXm3eqBua7hU0TAyfRfzCk6mWz3gasrmQuDKC4g7gayWZxn3E8hK6yp+VkZt8sSK
        imWZ12xQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYSn-0007fI-58; Wed, 01 Jul 2020 08:51:29 +0000
Date:   Wed, 1 Jul 2020 09:51:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/18] xfs: stop using q_core warning counters in the
 quota code
Message-ID: <20200701085129.GI25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353176856.2864738.18281608729457160086.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353176856.2864738.18281608729457160086.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add warning counter fields to the incore dquot, and use that instead of
> the ones in qcore.  This eliminates a bunch of endian conversions and
> will eventually allow us to remove qcore entirely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
