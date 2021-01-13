Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917C6C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE1523339
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbhAMPF7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhAMPF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:05:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87BBC061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/uourFaL2BtvtcxT2E64BlY6kh+nqo17FqN/YbLNU6o=; b=RD7emrD2tgH1vsOIG8n5gaq2Ls
        1CJsCk0gfIBsgS+QWHhWiuDEhvNIO61lVGZoEtzoHC8lNnn4SMWGX4YnnKf5L1QW1fMct3dbFqaSR
        cFLXtRZnc0bEx5yAWv53SXDasYTwy98UNcC1DTmCwJcT/sowSxeaalPt0nRETHuR5tU/nd671xh+R
        7G+xQ/1FXG9DOLiIxt9FP/Av/59cD8qYZIb/hNHNOzLh6o/gV4vpOZjaNLYHEgL5quYhcEYUxrYml
        +8tKITPoNyahpGhLGicexQ/5OSlwqrJ82M8/mOxQ7nvdkxnJCKtVepmOBfpQfuMmfcUIkkm4YRFFh
        +vnR1C+A==;
Received: from [2001:4bb8:19b:e528:d345:8855:f08f:87f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzhhH-006OP0-MY; Wed, 13 Jan 2021 15:04:53 +0000
Date:   Wed, 13 Jan 2021 16:04:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: consolidate the eofblocks and cowblocks workers
Message-ID: <X/8L/uY2Pj4c7biG@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040742050.1582286.5743015618624198962.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161040742050.1582286.5743015618624198962.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 03:23:40PM -0800, Darrick J. Wong wrote:
> + * 100ths of a second) with the exception of blockgc_timer, which is measured
> + * in seconds.
>   */
>  xfs_param_t xfs_params = {
>  			  /*	MIN		DFLT		MAX	*/
> @@ -28,8 +28,7 @@ xfs_param_t xfs_params = {
>  	.rotorstep	= {	1,		1,		255	},
>  	.inherit_nodfrg	= {	0,		1,		1	},
>  	.fstrm_timer	= {	1,		30*100,		3600*100},
> -	.eofb_timer	= {	1,		300,		3600*24},
> -	.cowb_timer	= {	1,		1800,		3600*24},
> +	.blockgc_timer	= {	1,		300,		3600*24},

Renaming this is going to break existing scripts.  We could either kill off the
COW timer as it is relatively recent, or we could keep both and use the minimum.
But removing both and picking an entirely new name seems a little dangerous.

Otherwise this looks sane to me.
