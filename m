Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC60FC18E19
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A64622CAD
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbhASQiR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbhASQiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 11:38:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26037C061573
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 08:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rOXJqgFi2AFTLikEr+Cz+5i490+GFLjDsdrvZOqYzJI=; b=iAykSn7d6ruwJxDLdpedV+5Bh6
        AzMBFJGkBUz1tphj/eezibKmTD9FXPUf5dGVSpamdD97oBbKxP6nSf8V1E7AMg+gKPo7xcQ17faOV
        4Kj/egp4WvmsNDH9Uwg6ErIhGnWeAkzWCnmY+dwlHfRqj7BDZpOfk+ahyv71hl+mskRrPK632JP8F
        u1Aeo1SqEnL0EOoau5eRgxDsTG3i7cpt6TntOw++y8ICvD243AR+jqk27sFHgg3xuORM3fTF5qIN5
        JGDZUUkCFOFnvFte02P+B4rt1apgFR4DvVHz4qwmI1KRLAzJrcvoHoJehUCCtw4pPkdM1CysTltHn
        RhTF11hQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1u0F-00EYxC-7s; Tue, 19 Jan 2021 16:37:20 +0000
Date:   Tue, 19 Jan 2021 16:37:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210119163711.GA3470705@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740189.1582286.17385075679159461086.stgit@magnolia>
 <X/8IfJj+qgnl303O@infradead.org>
 <20210114213259.GF1164246@magnolia>
 <20210114223849.GI1164246@magnolia>
 <20210118173628.GB3134885@infradead.org>
 <20210118195710.GL3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118195710.GL3134581@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:57:10AM -0800, Darrick J. Wong wrote:
> Where should I add a sysfs attributes for per-fs configuration knobs?  I
> don't really want to add "expected parallelism" to /sys/fs/xfs/*/error
> because that seems like the wrong place, and /proc/sys/fs/xfs/ is too
> global for something that could depend on the device.

Maybe a mount option that can be changed using remount?

