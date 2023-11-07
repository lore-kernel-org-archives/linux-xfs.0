Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B56C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjKGIwk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKGIwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:52:39 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BC9106
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K7Mb7mSPjR7Mh1AP1BxZwm+H0AgzE5CgkwmsCpF9slk=; b=rWNX0qXAwoDEurXxRONVg9M3NV
        Xm3k+kih98DZEJz1BbvyHIYSZwd0CVtuOBo1H7ASq7pueYaWLjZPUgCKKuSnF7ycht21iGyY7lS/L
        xoo0KQJbQ1IKAbt4I2+5vre6uF/L1ATDhgXOLKByueSBCQtjtBYKZCIpHz0d1tp7dwvCwiawWY3Oq
        dqcrlKEhMEQj3RGt83wMNhUxbm0WE9ID3VRAkCEcrSU5DX2dhc0ZSxxlOvhfNPSRHHqRPeBpyTMH7
        DS93DLqXPKoO8tH5Fqgeg1yavdVuZqLQ5pQQTqoMFIb1brbtKayb9HABEHIMTb+S+N7TYHXYyjbD3
        0vfD2K3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0Hp3-000rU2-2O;
        Tue, 07 Nov 2023 08:52:33 +0000
Date:   Tue, 7 Nov 2023 00:52:33 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: tighten up the security on the background
 systemd service
Message-ID: <ZUn60XdaxeY4+1I8@infradead.org>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074549.3746099.6129822996056625257.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506074549.3746099.6129822996056625257.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 06:55:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, xfs_scrub has to run with some elevated privileges.  Minimize
> the risk of xfs_scrub escaping its service container or contaminating
> the rest of the system by using systemd's sandboxing controls to
> prohibit as much access as possible.
> 
> The directives added by this patch were recommended by the command
> 'systemd-analyze security xfs_scrub@.service' in systemd 249.

All the additional lockdowns look good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Maybe you can split the dynamic user change out as a small standalone
fix, though?

