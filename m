Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8750C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 05:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbiFAF00 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 01:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiFAF0Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 01:26:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859FF9A980;
        Tue, 31 May 2022 22:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EhsykQ0DZnIBDvOscgt7MBqRe8U2ul4byyryIhlPIVU=; b=BCbubFmSU1G0Iei7+ZJxqy8HUz
        tJSpOo8lez9ZAi6FvBvctOHJEqVqM3zFgPClRrzqb0rI93wei0cv/WkK0T1bYXiDyDMiEqNpT4Rm9
        aOTcM8+sJKgcml3KN0Y4z+yJrktX04QfH17shVynCzY2tU1dTxWPoxavkmqByFAsnWg2FPYizkHCA
        J5pCdstia07pshq3jhIOcOR3k53sB4dHJxNYsmWRqs8wTjtH2kib/3T2xuIMJC6B4CvZecSZHE9mA
        EKv02pCF1EtstiT4RNMcFXB2ZWnqtTJWExwvzqswZb0MrmDU1hS/R3njCHPeVjAhTcVg8efYde93u
        p5XSSvPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwGsB-00DvKN-Ex; Wed, 01 Jun 2022 05:26:23 +0000
Date:   Tue, 31 May 2022 22:26:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz
Subject: Re: [PATCH v6 14/16] xfs: Change function signature of
 xfs_ilock_iocb()
Message-ID: <Ypb4fzsBoWSbUh1Z@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-15-shr@fb.com>
 <YpW+DToVN0NjUpx4@infradead.org>
 <b0a521e2-6753-590b-ecb9-a8910d2ec678@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0a521e2-6753-590b-ecb9-a8910d2ec678@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 31, 2022 at 12:15:19PM -0700, Stefan Roesch wrote:
> The problem is that xfs_iolock_iocb uses: iocb->ki_filp->f_inode,
>                 but xfs_file_buffered_write: iocb->ki_ki_filp->f_mapping->host
> 
> This requires to pass in the xfs_inode *.

Both must be the same.  The indirection only matters for device files
(and coda).
