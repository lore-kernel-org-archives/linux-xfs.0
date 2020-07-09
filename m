Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478FDC433E1
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A98206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 13:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ceadNfM5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGINry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 09:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgGINry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 09:47:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C38C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 06:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wvkOEtcpswN0EDDUWOrMojHLgS+Cix9NMJ5iQjXmvok=; b=ceadNfM5VrS+fj0lJuw5kFFY94
        ojo/uoW46jeW8w/8rDhitcTZImNOFfiiX1mRZ34/sdEtIU+GIGhYMKG0cpkUB8Bgs48qD+zXoPsWZ
        jmGMj+8GFKkLnlkKSWD+1VHIt0559UmAywgHNoQIAkvQIS+hb4c0B0GOUqbndPn4CW+SWRUlpfMiU
        T34dEC8rv1kaKpN6Glgki0rzWdhILF4r+pLYpIWkQq44+KrsxPqkNMuVPK76vyjZAw8C78Zaktqyb
        kU6BtdZHrsowctNzsjtpPkyn+ukSldczo5Vc2jJQf5bjY96p69dsyL1y7bZhDK+p+OyEqeYALVntD
        LB3jrIsQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWu0-0001SJ-Ny; Thu, 09 Jul 2020 13:47:52 +0000
Date:   Thu, 9 Jul 2020 14:47:52 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/22] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the
 ondisk format
Message-ID: <20200709134752.GE3860@infradead.org>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
 <159398718628.425236.8654425233877130537.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159398718628.425236.8654425233877130537.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 05, 2020 at 03:13:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the dquot cluster size #define to xfs_format.h.  It is an important
> part of the ondisk format because the ondisk dquot record size is not an
> even power of two, which means that the buffer size we use is
> significant here because the kernel leaves slack space at the end of the
> buffer to avoid having to deal with a dquot record crossing a block
> boundary.
> 
> This is also an excuse to fix one of the longstanding discrepancies
> between kernel and userspace libxfs headers.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
