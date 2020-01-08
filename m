Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A26C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343F620692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:54:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DG9w6lNZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgAHIyC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:54:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56088 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgAHIyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h4IOCuM64JTKY9XN4ROqZ1j0avw6G9K5ojtE+SFFO3M=; b=DG9w6lNZoKKbAv6HRLWf+yjgR
        lx4O+ptEze0RKcXHKualVQok0eimE1XeAX4XCGR5iuJDia9558Yrc9stozxWpd9NET6LnTV/j0xvu
        wDxQlmmUzy9s5QQETCGDi1TMt5yj6Nui5B5QXkThIK1jsMyPmK7ZRkXLRA3dQARuI+k/fSSaOS/qV
        wcmUr1fwouU4YTnL7nTVScVQez6kaoDqdPE67PMehi4yyKKYqj7S+ydZ0XJrwHpVDnyBeTFP3t7pT
        raoCtqV1Pa+5VVMfnwR4eYGH29uqqb+du+ItusgAlPKJX/q3PuXJix8RcwB+zHfQRnc0LyaDRhldP
        ZgvBrLWLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip76I-0000TT-9W; Wed, 08 Jan 2020 08:54:02 +0000
Date:   Wed, 8 Jan 2020 00:54:02 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make struct xfs_buf_log_format have a
 consistent size
Message-ID: <20200108085402.GC12889@infradead.org>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845710512.84011.14528616369807048509.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845710512.84011.14528616369807048509.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 08:18:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
> end of struct xfs_buf_log_format.  This makes the size consistent so
> that we can check it in xfs_ondisk.h, and will be needed once we start
> logging attribute values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |    9 +++++----
>  fs/xfs/xfs_ondisk.h            |    1 +
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 8ef31d71a9c7..5d8eb8978c33 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -462,11 +462,12 @@ static inline uint xfs_log_dinode_size(int version)
>  #define	XFS_BLF_GDQUOT_BUF	(1<<4)
>  
>  /*
> - * This is the structure used to lay out a buf log item in the
> - * log.  The data map describes which 128 byte chunks of the buffer
> - * have been logged.
> + * This is the structure used to lay out a buf log item in the log.  The data
> + * map describes which 128 byte chunks of the buffer have been logged.  Note
> + * that XFS_BLF_DATAMAP_SIZE is an odd number so that the structure size will
> + * be consistent between 32-bit and 64-bit platforms.
>   */
> -#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
> +#define XFS_BLF_DATAMAP_SIZE	(1 + ((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD))

I don't understand the explanation.  Why would the size differ for
32-bit vs 64-bit architectures when it only uses fixed size types?
