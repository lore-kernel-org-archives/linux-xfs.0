Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A10C41514
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14BFD23405
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PfKSAla8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfH2ISX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:18:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfH2ISX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yqrFSC0/x9vna/JkOIDK7czIidtu4Yi44zGEqNoa7Kw=; b=PfKSAla8qcIW1e7a4fSdDhYe0
        iZYCt1M857UOUgdmzopxuLryWl3U7wZFgdM5omHaFherwRmjDJaOlFSKQ6RoLq0vMLMcDLi0blqAO
        okDGMcufUP+bq9meukkxWVF2rQNI4ErCQRRf4im31AZGmL1TSdkKKaCACsqX1MS6hVpUlCAklv8m6
        xiwIc4ZCRBtktZwMgMegQOe4ldGQ7Nw//+HXTvadb41xKN1xpzlNMhNjHkbGkQuf2CgZMAg5Z1nSd
        hel5MKqZ5BfuNSVw7JETeu5CIHBSiBZvC4ij+T6erQqq8FvTl/UniKz3YG37ORg4acR4y30EjNPfv
        IO/paSZfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3FVV-00018O-N4; Thu, 29 Aug 2019 08:10:13 +0000
Date:   Thu, 29 Aug 2019 01:10:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: factor free block index lookup from
 xfs_dir2_node_addname_int()
Message-ID: <20190829081013.GC18195@infradead.org>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829063042.22902-4-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 04:30:40PM +1000, Dave Chinner wrote:
> +	/*
> +	 * Now we know if we must allocate blocks, so if we are checking whether
> +	 * we can insert without allocation then we can return now.
> +	 */
> +	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
> +		if (dbno != -1)
> +			return 0;
> +		return -ENOSPC;
> +	}

Nit: I'd invert the check to rturn -ENOSPC in the branch if dbno is
-1 to make the flow a littler easier.

Otherwise this looks great and makes the code much easier to read:

Reviewed-by: Christoph Hellwig <hch@lst.de>
