Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94F7C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1BE022CF5
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fiWSXoH2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfIDGmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:42:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDGmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v2hY/JpPG1NEVG2Ukyajn+iZ+yBR41D2aihQ/4vMtSk=; b=fiWSXoH25SPChUoxItkr9tSFr
        4C9H1t2RedYLfuqKQ/6on8FXsw35Uq/beT58fZf9s/GFcAMyeOrafKIxhdTpDUzHvbkM+HCraQBUK
        nFPUV6GSxhQSoEngreWsKRWQsb/YUmI/hFBsG+EJHYPFFV51ceHXBjQjLuk8xVTQZqxWxsSpQchHW
        QBEVJujeYIY/EKLwx1tyyYMzDOFoeAUeZS98uQjVRqq6MYxGcJeYwT14MTH7KTt3OMDLV/53Ewe88
        0E55ySxx4O/1MbECtmG00Pffq3XU/BtoW+vl6qd98lUy+PkVlyk1hw10ztxY9C8LT8e8V9tXwhONq
        F3qLpQC1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5Ozl-0002rU-Jt; Wed, 04 Sep 2019 06:42:21 +0000
Date:   Tue, 3 Sep 2019 23:42:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: factor iclog state processing out of
 xlog_state_do_callback()
Message-ID: <20190904064221.GA3960@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-6-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 02:24:49PM +1000, Dave Chinner wrote:
> +	/* Skip all iclogs in the ACTIVE & DIRTY states */
> +	if (iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))
> +		return false;

Please use spaces around the "|".

> +			if (iclog->ic_state & XLOG_STATE_IOERROR)
> +				ioerrors++;

This now also counts the ierrror flag for dirty and active iclogs.
Not sure it matters given our state machine, but it does change
behavior.

> +			ret = xlog_state_iodone_process_iclog(log, iclog,
> +								ciclog);
> +			if (ret)
> +				break;

No need for the ret variable.

>  
> -			} else
> -				ioerrors++;
> +			if (!(iclog->ic_state &
> +			      (XLOG_STATE_CALLBACK | XLOG_STATE_IOERROR))) {
> +				iclog = iclog->ic_next;
> +				continue;
> +			}

Btw, one cleanup I had pending is that all our loops ovr the iclog
list can be cleaned up nicely so that continue does that right thing
without all these manual "iclog = iclog->ic_next" next statements.  Just
turn the loop into:

	do {
		..
	} while ((iclog = iclog->ic_next) != first_iclog);

this might be applicable to a few of your patches.
