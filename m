Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575DBC47404
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F70F21D7C
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gkNHqsjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfJKJzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 05:55:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49688 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfJKJzH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 05:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cFNx4WelrZkKlW7Ty3H+V6/wo9BQwgoSI66x0VapOuY=; b=gkNHqsjQPLZeZpKgRcC/H6AIO
        ePIX2BZBFGLFq7GsiXbNUK6RLVBdmFRM5ITX4gxt8FgkTvYMrezemuzA/5SL1uzbr5bGBrgAm7KXU
        oD7tESe9o6CbIeXnZncr3pLa4OgWQV69UBFOmVJL8Z6XDogBjxugdVzs9IiovifNGqDLGPv7qQL64
        51CHWPUDCrGb/XKlmGRABLejAm0ZrBpz0NLl+QuL4ZR0Az3RQkq9HDsadkMMXE7APfxxn/t9IH2h/
        rEsUCIwxiJCbzZXGa61LnJewFlm4xObvTQw+G0MU+SQbrGjWFH6EEjdNvz37lpfMJ0GL8cRIFcPoT
        cyco7Fy0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIrdb-0003DA-9o; Fri, 11 Oct 2019 09:55:07 +0000
Date:   Fri, 11 Oct 2019 02:55:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 26/26] xfs: use xfs_ail_push_all_sync in
 xfs_reclaim_inodes
Message-ID: <20191011095507.GA8692@infradead.org>
References: <20191009032124.10541-1-david@fromorbit.com>
 <20191009032124.10541-27-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009032124.10541-27-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -1106,6 +1111,9 @@ xfs_reclaim_inodes(
>  		/* push the AIL to clean dirty reclaimable inodes */
>  		xfs_ail_push_all(mp->m_ail);
>  
> +		/* push the AIL to clean dirty reclaimable inodes */
> +		xfs_ail_push_all(mp->m_ail);
> +

This is adding the third xfs_ail_push_all in a row with no comments
why we'd want to do it multiple times.  Is that a merge error or
is there a good reason for that?
