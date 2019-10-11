Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A044ECE58E
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD5B420659
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 09:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DwRUICkX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfJKJut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 05:50:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfJKJus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 05:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l1gKV4m2Xh6y/JU+QG5ITDUuZ6n2VNnxxqWyXaO8R/Y=; b=DwRUICkXD44PtMnHeQVrduLu1
        tOf2LZrExMV29zsIlHhIsH9Dtmv98BJInV3RWh3FNtSnBUApmoKvXo0JRLfGijoumRm9xhLVE6QvE
        Jm8KE8rcNer9Ux0maQMKMyUtRwGor+40SmRFz/0GdASQvQ0hZtoVWq+99mVm205kw83p4OACvTrfe
        ICvObpaogMtB6U7Fw4jmSXzrKp4VYFzohUDPBppjDD2LH12prHLi5R92CVehE8VrEDLMOWPEEhcj7
        tdSsXYCzBGKshoiecRnGiar+LwaDGcX+pa/vRfu/RmSeYpBM8Vuu+Qsk7ZI87FZ0Mo7owf0zLRIan
        5XR/MBcTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIrZQ-0001dJ-GX; Fri, 11 Oct 2019 09:50:48 +0000
Date:   Fri, 11 Oct 2019 02:50:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: tail updates only need to occur when LSN
 changes
Message-ID: <20191011095048.GC5787@infradead.org>
References: <20191009032124.10541-1-david@fromorbit.com>
 <20191009032124.10541-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009032124.10541-8-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	if (need_ail) {
> -		bool			mlip_changed = false;
> +		xfs_lsn_t	tail_lsn = 0;
>  
>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>  		spin_lock(&ailp->ail_lock);
>  		list_for_each_entry(blip, &tmp, li_bio_list) {
>  			if (INODE_ITEM(blip)->ili_logged &&
> +			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
> +				/*
> +				 * xfs_ail_update_finish() only cares about the
> +				 * lsn of the first tail item removed, any others

This adds an > 80 chars line.  Maybe just do the xfs_clear_li_failed
in the if and continue to make the code a little easier to read.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
