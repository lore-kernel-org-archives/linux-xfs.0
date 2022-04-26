Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8FDC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 13:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbiDZNuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 09:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240946AbiDZNuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 09:50:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50581CB05
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 06:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CVesncXGNdIaBOgxFdg+E9wzPcIr1XNQLeHKHLsTyBE=; b=qLAJY7pttbQ+8aYl/jKx9CqIld
        4E0dkjAfXY6oGufRDBiSOPF5rK6X5yib03FIIKRoJd/WL0xl1RJayEscc9ZNammuTpysIaNljM0bb
        Alnzu4O42bUVmGZBapO61hAg/UNpB+Dj7brGNtgMgEpLFoe3efSM3GoEcm/Qg1l6GueEi822qYIQ4
        akSnGjAPaZb6OzFHYdmsNBLEkXS9LzeILf24t1IpfPwO3m9J7yTT2rSR3csaS8aTV8wJ5Xp79vBdG
        HiUOMg050K8lruxssziutkHWhvHrAOjnC7s7OMmNvUAv3vWD8VooxdUMyenIxg/caH2MIqkhPGkBA
        gMFOxDyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1njLWx-00EjDV-NL; Tue, 26 Apr 2022 13:47:03 +0000
Date:   Tue, 26 Apr 2022 06:47:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: remove a __xfs_bunmapi call from reflink
Message-ID: <Ymf310jOG8Jr/CEs@infradead.org>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997687710.383881.15849921169442020335.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997687710.383881.15849921169442020335.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 03:54:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This raw call isn't necessary since we can always remove a full delalloc
> extent.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
