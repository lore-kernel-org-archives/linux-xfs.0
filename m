Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6922AC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4148C65079
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhCPOjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:39:24 -0400
Received: from casper.infradead.org ([90.155.50.34]:34946 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbhCPOix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:38:53 -0400
X-Greylist: delayed 1400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2021 10:38:53 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bd10odTU9izz1vQAOFMxF6cpPQkOGHiIxONBWYIH4ec=; b=AY2rOVCwIa6+93junUk3vleVxD
        xBhacmal8S7I+1YVE2h90z0voDacfADbcMrWWg2PPH/76MHMxDHbL266nzxl0pNWfQpdGRFhaLRzK
        eBXpanr2pEOKjiTkzZhHEmQlCHLrpA13Wd6TRWODsIvsPKIGI5F7+TuDqy835q1AE865uu8k/3iB0
        BCFYsi4/7RB8IJ/WxNl2Y9EgcuPIA85Qvv9P4TdWvr9K5OhMIwF+Bp7g8ZNth+L3WGd4MyM9PgP4F
        4ow6CB6dRWbsTHNzHkl24SS9YjojGaMEk1TNpmohmQhnAUjOumKf6s6ylS+p+Y8NeDhr44v1Nh1Pp
        zbyEqOCA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMATp-000AA9-BB; Tue, 16 Mar 2021 14:15:30 +0000
Date:   Tue, 16 Mar 2021 14:15:29 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/45] xfs: remove need_start_rec parameter from
 xlog_write()
Message-ID: <20210316141529.GA38532@infradead.org>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -818,9 +818,7 @@ xlog_wait_on_iclog(
>  static int
>  xlog_write_unmount_record(
>  	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	xfs_lsn_t		*lsn,
> -	uint			flags)
> +	struct xlog_ticket	*ticket)
>  {
>  	struct xfs_unmount_log_format ulf = {
>  		.magic = XLOG_UNMOUNT_TYPE,
> @@ -837,7 +835,7 @@ xlog_write_unmount_record(
>  
>  	/* account for space used by record data */
>  	ticket->t_curr_res -= sizeof(ulf);
> -	return xlog_write(log, &vec, ticket, lsn, NULL, flags, false);
> +	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);

The removal of the lsn argument from xlog_write_unmount_record and
making optional of the start_lsn argument to xlog_write is not
documented anywhere.  I still it would be best to split such tiny
argument passing cleanups from a more complicated and not quite trivial
one, but at very least it needs to be clearly documented.
