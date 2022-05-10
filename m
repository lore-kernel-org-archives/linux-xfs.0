Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ABFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 12:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242075AbiEJM7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 08:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242162AbiEJM7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:59:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515E52B94E8
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4f2L0OoW78kDDaZx5FF0HDmvCGroxyP5aw+blIsSQvk=; b=Oxpo2jvu4T/rBOH1VBsHcA97p4
        Ia55DLhJlrBfEgRf81XBlBAAP2ZwnrQDfTt8Fl7bDlCVS9G6nQ3OkgppWJcl1H8Ak06BYpAiDBBeP
        pUipT9xU4QUvzykiaGuoUgJsjjPThjehra8004HhOZfruzORs0Ea+PKOMd3cdU7fiGn8lNaBRgn0v
        gE51dqqOHN8ualBZiQzjwpC32ufw1qPelHYznWsJ/Eqb6Ol0wzkLoNtLDJldlgjKYJ5S3WxV7j0at
        etstAuykk18+/wuutFrxLpcv95yiqET9zLABrWwkY5+SJxChla3F4KT1bHmlHP9T6dw5G9+hd/Myd
        McF4t9mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPOO-0022e5-4b; Tue, 10 May 2022 12:55:08 +0000
Date:   Tue, 10 May 2022 05:55:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] mkfs: round log size down if rounding log start up
 causes overflow
Message-ID: <YnpgrLFbPG4aBL9y@infradead.org>
References: <165176670883.248587.2509972137741301804.stgit@magnolia>
 <165176673695.248587.16584045364969444033.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176673695.248587.16584045364969444033.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 09:05:36AM -0700, Darrick J. Wong wrote:
> +	/*
> +	 * If the end of the log has been rounded past the end of the AG,
> +	 * reduce logblocks by a stripe unit to try to get it back under EOAG.
> +	 */
> +	if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks) &&
> +	    cfg->logblocks > sunit) {
> +		cfg->logblocks -= sunit;
> +	}

The curly braces look a little out of place here, but otherwise this
looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
