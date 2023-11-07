Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C795C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjKGIlL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjKGIlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:41:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE457FD
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UuWKwlSGN6GLXxCTixo+HUeDqT
        yTnnMwXReynGi6lfMaElDFcBcnmaIdxBqTMqgUmstQu/p58tkcFaV7Ueif6moyDbR75CLssLFjuHk
        MfYFsEplQoNPiYmIr5LPzcFA1jBOJSWvtkfdUzC7ikQf3RtlQ38oBe1uNJkqZQcv2/ZQuK4m8R8Q/
        t55+KCkHNBX78fgX+9BGZN/JmkMMzdJ85Rh+9aZtfx8eRwworkxFV3wAYbkwqjH1woeXkAxpeV4yF
        eTIJ+umU+ZPRDKabbB14rBp5PnOjiXsZQX04qmDqJ5Du1d7m6JuGSp5qBhQVMAOonjU6GOhgZ7BcB
        DlVw52UA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0Hdz-000qKg-2l;
        Tue, 07 Nov 2023 08:41:07 +0000
Date:   Tue, 7 Nov 2023 00:41:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_scrub_all: simplify cleanup of run_killable
Message-ID: <ZUn4I/K3lr9hUdZJ@infradead.org>
References: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
 <168506074216.3745941.15053679918709139887.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506074216.3745941.15053679918709139887.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
