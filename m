Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881D4C3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 00:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57B5023401
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 00:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lHAvxhJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfHWAOm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 20:14:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbfHWAOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 20:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EEPeXKHeyHPUF+mY9X4HgzOAHDW9xJaBlJDYUqhQ3Ro=; b=lHAvxhJZHEMfcwQC1ogHhZeLJ
        FFTWoV11nQerSX0KwMBjOZpUeIcPiYTfGZqRKA3TOLiqRFOWCALI40p1y9XiIiEKUV1PIDLGoSH3m
        Cm9jp8uKQj+uAaZyCKLbTkP/FU1MQZpVGSc7bn/NcSRiMvFC2b2EHhKccahuo5CLVNEq1kEX658/D
        R3cEgxmObspdHeitQ7kvEHKWtyuuQE5OOla+XXzLKuhw/yj7+UDarxySHY6QuTblwOYMGLAjDRRVV
        uImimL0DO3a6gnIQlgq/mM0mF/0DxzY/u51Lzycztqp/n/4lNdcCd5bP1hfzdO36OJ9VjJF8Vb5Jd
        niYiDJUBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0xE0-0000pm-NP; Fri, 23 Aug 2019 00:14:40 +0000
Date:   Thu, 22 Aug 2019 17:14:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Ming Lei <tom.leiming@gmail.com>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190823001440.GA32209@infradead.org>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
 <20190822044905.GU1119@dread.disaster.area>
 <20190822080852.GC31346@infradead.org>
 <20190822101958.GA9632@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822101958.GA9632@ming.t460p>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 06:20:00PM +0800, Ming Lei wrote:
> In theory, fs bio shouldn't care any DMA limits, which should have been done
> on splitted bio for doing IO to device.
> 
> Also .dma_alignment isn't considered in blk_stack_limits(), so in case
> of DM, MD or other stacking drivers, fs code won't know the accurate
> .dma_alignment of underlying queues at all, and the stacking driver's
> queue dma alignment is still 512.

Trying to handling alignment lower down means bounce buffering, so I
don't think trying to hndle it is a sane idea.  I'd be much happier to
say non-passthrough bios need 512 byte alignment, period.  That should
cover all the sane cases and we can easily check for it.  The occasional
device that would need larger alignment just needs to deal with it.

> Also suppose the check is added, I am a bit curious how fs code handles the
> failure, so could you explain a bit about the failure handling?

Even just an assert is a a start.  But a bio_add_page variant with
saner return value semantic would be helpful, and I have some ideas
there that I need to try out first.
