Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD31C35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0518B20704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kJO5YVIz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAYXSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:18:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:18:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XmpAzHSx6hkJkis7wKJzW7uOMge3yyl1yyEpt5HY71U=; b=kJO5YVIzLFNSW8LYa9oSsjfXI
        Ag6G6hhScuH457cqTzQ42XgMDm6FdTKZCOzYox7q35/EY/RV95jYX2sslMIky842WMduT6DhUx+zo
        wUela6lpAw1TpmakOnRi6Gu9MIVGsDBGTVEWE6VfsEpew9Ax9gxv/nPQEnUlquHstf9nYkNCUpcNl
        qYjBPxBMdSz36sbNFjkaQI7tYLkrWe2KCPzV8JHoDcEUsfviW5S7hW6ujp1bJAojYshR4cWQ9u+Dp
        sw0sKtRZPukDRK7O4pSjjuN5dmBdeYPNa9LXQxb+qOp2O+Dxhxkc9YTPraVTqkf6bl8954SZYIyFJ
        VY/mddgNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUhM-0006mg-HS; Sat, 25 Jan 2020 23:18:40 +0000
Date:   Sat, 25 Jan 2020 15:18:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs_io: fix pwrite/pread length truncation on 32-bit
 systems
Message-ID: <20200125231840.GK15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982503725.2765410.9945705757777826157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982503725.2765410.9945705757777826157.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 04:17:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The pwrite and pread commands in xfs_io accept an operation length that
> can be any quantity that fits in a long long int; and loops to handle
> the cases where the operation length is larger than the IO buffer.
> 
> Weirdly, the do_ functions contain code to shorten the operation to the
> IO buffer size but the @count parameter is size_t, which means that for
> a large argument on a 32-bit system, we rip off the upper bits of the
> length, turning your 8GB write into a 0 byte write, which does nothing.
> 
> This was found by running generic/175 and observing that the 8G test
> file it creates has zero length after the operation:
> 
> wrote 0/8589934592 bytes at offset 0
> 0.000000 bytes, 0 ops; 0.0001 sec (0.000000 bytes/sec and 0.0000 ops/sec)
> 
> Fix this by pushing long long count all the way through the call stack.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
