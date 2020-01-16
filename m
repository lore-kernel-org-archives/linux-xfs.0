Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80C4C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE4162081E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:49:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W0gt5k0G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgAPQtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:49:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbgAPQtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:49:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DLj5VSQXpRT9kfRmppcI0ZSH5frbcwHIcBnqai4DCmg=; b=W0gt5k0GeJ+Wzja3+gMMe4Y/w
        aRCCTh4MIYTQznLprhoAteQ5hw/y7zjVCESOzpDM+HKGfswtp231rAo7XZroVTjyjAOJbqjDAwqZh
        DnO7SEkjdKBZzahXneUebikO2xTyf46L9W5I9YtGUZwnHoxrUQ94HK8TypRNef3q4w0JOspvIELqX
        wk4F9bujWOZpch5r4lss77qkeIqdkSnFQxhqA1b904+UfKjLParwCi/Z8O5V5JvYwdASBYns68qVZ
        LMTdlgE3dSQAADvAsUDyDSQUP5Wb+7kX3HeyFFUJNnfxo8htYR2LgehiobVNRu9iXHb+pYtgAywcL
        zs0lrS0pg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is8KK-0003Ss-F3; Thu, 16 Jan 2020 16:49:00 +0000
Date:   Thu, 16 Jan 2020 08:49:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: relax unwritten writeback overhead under some
 circumstances
Message-ID: <20200116164900.GB4593@infradead.org>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535801.2406747.10502356876965505327.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915535801.2406747.10502356876965505327.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 10:15:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the previous patch, we solved a stale disk contents exposure problem
> by forcing the delalloc write path to create unwritten extents, write
> the data, and convert the extents to written after writeback completes.
> 
> This is a pretty huge hammer to use, so we'll relax the delalloc write
> strategy to go straight to written extents (as we once did) if someone
> tells us to write the entire file to disk.  This reopens the exposure
> window slightly, but we'll only be affected if writeback completes out
> of order and the system crashes during writeback.
> 
> Because once again we can map written extents past EOF, we also
> enlarge the writepages window downward if the window is beyond the
> on-disk size and there are written extents after the EOF block.  This
> ensures that speculative post-EOF preallocations are not left uncovered.

This does sound really sketchy.  Do you have any performance numbers
justifying something this nasty?
