Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641ACC433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 19:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286DA64E92
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 19:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBATNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 14:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhBATNB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 14:13:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D9864DA8;
        Mon,  1 Feb 2021 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612206741;
        bh=v0ZOVyR2t/hoOpZBQRcCp5JFOwznDehwffoTYTET9qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AFasA3eUjtFTck0pnQQrKfFGxQSJx3+61UytIPnLL4kis1/7KR74inLR7+lq9Tkmc
         l30/+2gMlrZIp7+MbtXiJD00RYS247qzooPrBdAzKUVXpqTcAWtdtD+Nw29YpGtO6n
         TjFxLR36yz64OHdGsSPoCrO+7fnXz6GzBHSi6zznREkZP42eDLw7skSiYZe0UqNV34
         MLWeDr5xVIwdD+mNoi6V5gTwX+GSjQgqc3yJjL3MAHsR+hHrewS388v8UM0eNwg9YK
         mRCA+KMlwNYjEvp6RIi0L/bTzPxl3z9UR/N1lqrnb3aFm0lSLin4m6guEl60/uIM4Z
         d4lCnIY2B26xQ==
Date:   Mon, 1 Feb 2021 11:12:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 09/12] xfs: flush eof/cowblocks if we can't reserve quota
 for chown
Message-ID: <20210201191220.GH7193@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214517714.140945.1957722027452288290.stgit@magnolia>
 <20210201123637.GC3279223@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201123637.GC3279223@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:36:37PM +0000, Christoph Hellwig wrote:
> On Sun, Jan 31, 2021 at 06:06:17PM -0800, Darrick J. Wong wrote:
> > @@ -1175,6 +1177,13 @@ xfs_trans_alloc_ichange(
> >  	if (new_udqp || new_gdqp || new_pdqp) {
> >  		error = xfs_trans_reserve_quota_chown(tp, ip, new_udqp,
> >  				new_gdqp, new_pdqp, force);
> > +		if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
> 
> One more :)
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Cool, thanks for reviewing!

--D
