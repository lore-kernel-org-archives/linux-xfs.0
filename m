Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD32C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjKGIfr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbjKGIfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:35:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9261510A
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FY5YpbTWdacUsQG1rs+er3s5QQoM48qRfWd94ZFWOVM=; b=HX4UFNESRTgEk47nQGDkv0+ePL
        3cePEFPA+uxN7cuOlqHfbeG7w1UVJnUNQVHAUXIjZ5nLNVQkg4q0A14am4VNXnjOGq+fzCnL7h7Bt
        xAYQAvrOwL2XlFMlYgVP2Yyey4sB5aR++zTo1o88yFWYBepDv7Cbi1p32L5ZnzZ/HxsJY3WsuJ78K
        CRPf3OI7NfwmNGDYa/w413121dM29g/Su37V3mztQseKaJYaR08mbZiUOmpX5f88gJnvjv+MJWPzv
        Sz7XBk0fP5TVMmyEw3dSaXABd08F5W+2mcT/To2dXxDu9UEfXrCwZ7EV0e950tmWc7sgAgcISpvKa
        GOYh8Xyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0HYk-000pVB-1W;
        Tue, 07 Nov 2023 08:35:42 +0000
Date:   Tue, 7 Nov 2023 00:35:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] debian: install scrub services with dh_installsystemd
Message-ID: <ZUn23tAsaXnd8IS7@infradead.org>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
 <168506073846.3745766.1338318814898903856.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506073846.3745766.1338318814898903856.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 06:52:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use dh_installsystemd to handle the installation and activation of the
> scrub systemd services.  This requires bumping the compat version to 11.
> Note that the services are /not/ activated on installation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
