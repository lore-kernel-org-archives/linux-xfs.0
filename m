Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8B0C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F76F61354
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhJTQgA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 12:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhJTQf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 12:35:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE25C061749
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 09:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GkTe9vlZaF19g61mEdpyCWdQ2KR3VK97AIr0SimsAbg=; b=ExtgytiVJBdUeS98ytip4S1Mxz
        8y9Ru9+lzOwJ8o06AX3XWykAacHb5+oqnNiue/8DEehju3jNFODHMyyFJZ8spY4m+nrR9O2AfysJ+
        DQ7pprZ+4BqIzivbKrBFU7CnPEYMyIn5Tud90g5TR1Id2t3QHYi+/DjW4yweg6z3AOJFyZI/hNohe
        gAT+b9PzpjMEWuYcywigwhw1zJAmzUvyKItTUTK00mCL5vECXPUoj7BYdt+PVNGWtcflia2a4ct1i
        V73Tg6fuijTqsWbk4c7z3iK2j3zZZb9koPUHprZYh4gE04/Mg3yezBJNsClEMHsAKXRYjt22GUM1e
        Ps1Xtozg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mdEX9-005Fju-JH; Wed, 20 Oct 2021 16:33:43 +0000
Date:   Wed, 20 Oct 2021 09:33:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Greenfield <dgrnfld@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS NVMe RDMA?
Message-ID: <YXBE5y2cJtAaMfzs@infradead.org>
References: <965EC18A-BF96-4544-AFE0-FA0F1787FD49@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <965EC18A-BF96-4544-AFE0-FA0F1787FD49@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 20, 2021 at 12:51:05PM +0100, Dan Greenfield wrote:
> Do you have any ideas how they could have been able to utilise RDMA so that node A can directly access data chunks stored on XFS on node B? Is the only approach to mmap the chunk on node B and then RDMA it to/from node A?

I'm not going to watch a video, but with the pNFS code other nodes can
access data on an XFS node directly using any SCSI transport.
For RMDA that would be SRP or iSCSI/iSER.

Note that I also have an unfinished draft to support NVMe, which has
an RDMA transports as well and someone else could trivially reimplement
that as well.
