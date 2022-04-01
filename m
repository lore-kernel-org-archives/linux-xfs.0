Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA178C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 11:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbiDALxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 07:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240724AbiDALxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 07:53:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2863927085F
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 04:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iHpa23Pthig4mtLkBsmg+5SmMh1ytPUPxVsGWcxPlvo=; b=oMImOWngepeoeFIDSivCbADhux
        l7VvOwN2rwUZdDD5iCFnUFVg1EMdGxQJVD35Bc22ZaH2uBcyTMlQp+yz9faWCCHYZOC/X3/iv8efn
        t+Zw0GSY3LvAxj6bzL5o8ErJUeQjaKym5SYCUDzFfLIqbJq17mbtXHeoZPYPitNfsYcVIxPWUgvpH
        kuM9Xzerp5BDD4Rxwb1Hxaetgb4rYOP5U9Jk6uSuD22nmcJOGABe1x52gQMItWKlsnN2wDiJ4A3cN
        RJshlErT5ITmjDd0Rqw0lay3WdD3o0I0YBino7lwAPEbSMO2pPWPPz8pG3sCgdmKYoJlYpjNQN+01
        ADH6rzFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naFot-005PVa-Qc; Fri, 01 Apr 2022 11:51:59 +0000
Date:   Fri, 1 Apr 2022 04:51:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: run callbacks before waking waiters in
 xlog_state_shutdown_callbacks
Message-ID: <YkbnXzMUkkzYT4so@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 12:10:43PM +1100, Dave Chinner wrote:
> @@ -501,7 +504,6 @@ xlog_state_shutdown_callbacks(
>  	struct xlog_in_core	*iclog;
>  	LIST_HEAD(cb_list);
>  
> -	spin_lock(&log->l_icloglock);

It would be really helpful to have a

	lockdep_assert_held(&log->l_icloglock);

here now.

> @@ -509,14 +511,16 @@ xlog_state_shutdown_callbacks(
>  			continue;
>  		}
>  		list_splice_init(&iclog->ic_callbacks, &cb_list);
> +		spin_unlock(&log->l_icloglock);
> +
> +		xlog_cil_process_committed(&cb_list);
> +
> +		spin_lock(&log->l_icloglock);

.. and this should be fine because log->l_iclog can't move once
we're shut down.  I'd maybe add a comment on that, but otherwise
this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
