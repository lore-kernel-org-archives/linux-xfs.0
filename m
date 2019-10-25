Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222DFCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 13:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D1020679
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 13:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D7jep0OD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502254AbfJYNxJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 09:53:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502085AbfJYNxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 09:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qSgvNb9u06gKc4FVL/2xLD4d5VPzNmRXDSYz2R2GrF8=; b=D7jep0ODO1W/NcfPji3DwYOk+
        XeXahFHhntQzm491KI3MMPHuIQpK+Npsda/GXD0dsVUviKv2xyZocEMS5MocxnP0VO+EnJz7OQqv1
        fE8DEtz52pAedomeTwiV/zRTLq3pYzkeChRlczoOLUnhFhWFGHL70JMhjxlG7ixgYwXgxidb5G3Fa
        TXw/rRIt4KsCB+uWup+CHx/cMZYjFF7sgLqYvmbBFCbhTNTMeyntFz+KqfMdLCXWX6ezDnB2Sbyhc
        QGE9XyqyxKPAeUJhOf+Q6YdQ2Qx8q+wF5/FIl1Hlje/K5dVkGvBWiKoslme0Aiam19gnW4rdil8GY
        45U95mLKQ==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO01Y-0000PO-QE; Fri, 25 Oct 2019 13:53:08 +0000
Date:   Fri, 25 Oct 2019 15:52:55 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 05/17] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
 check
Message-ID: <20191025135255.GA22076@infradead.org>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190346159.27074.3152127833811363522.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190346159.27074.3152127833811363522.stgit@fedora-28>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:01PM +0800, Ian Kent wrote:
> -#ifndef CONFIG_XFS_QUOTA
> -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +#if !IS_ENABLED(CONFIG_XFS_QUOTA)
> +	if (mp->m_qflags != 0) {

The whole point of IS_ENABLED is that you can directly use it in C code
instead of only through the preprocessor.  So this should be:

	if (!IS_ENABLED(CONFIG_XFS_QUOTA) && mp->m_qflags != 0) {
