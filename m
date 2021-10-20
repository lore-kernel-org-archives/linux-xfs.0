Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEF6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BBD76137C
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhJTQiM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 12:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJTQiG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 12:38:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7924BC061753
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 09:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zx+ak0Ea0xbaTBVHW/n6DapveIqJ7LfvfSX6V19C9Jk=; b=C51qq5phbkSRs+AIeNJ1FDERzt
        JsckUg1nhD6JjtM0iURVhGXqOou82MOkeL4kchsCROwhifd2SAhEqrZ5sTp/bTjq0DR1ZbAmY+Rzy
        fGgPPSncIPe/iCB1abfBfKFU8Cyr2veIjHK2OVq671g8Co+eaGnywAQ6AZK/x2BFf06OmzwoNsrwP
        BW4li0aP2tzWinQTUFprKi3RWpH+tPEr+DGmQ5Nh+JS6ZiwkthFsAVsjBzT9Sbk9Gh1KNBcM8K9kb
        63HSiFE9Zw1ThQ2d29yeKISCi8ORdDLtBx93wVUUiC8w/kC/7cpPJTUaDMiwcRbh/faojxXXg0MjJ
        Xc1+l/qA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mdEZE-005FyD-7A; Wed, 20 Oct 2021 16:35:52 +0000
Date:   Wed, 20 Oct 2021 09:35:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Greenfield <dgrnfld@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS NVMe RDMA?
Message-ID: <YXBFaOqjMRN7ucFb@infradead.org>
References: <965EC18A-BF96-4544-AFE0-FA0F1787FD49@gmail.com>
 <YXBE5y2cJtAaMfzs@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXBE5y2cJtAaMfzs@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 20, 2021 at 09:33:43AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 20, 2021 at 12:51:05PM +0100, Dan Greenfield wrote:
> > Do you have any ideas how they could have been able to utilise RDMA so that node A can directly access data chunks stored on XFS on node B? Is the only approach to mmap the chunk on node B and then RDMA it to/from node A?
> 
> I'm not going to watch a video, but with the pNFS code other nodes can
> access data on an XFS node directly using any SCSI transport.
> For RMDA that would be SRP or iSCSI/iSER.
> 
> Note that I also have an unfinished draft to support NVMe, which has
> an RDMA transports as well and someone else could trivially reimplement
> that as well.

Oh, and just FYI here are my slides on the pNFS support:

https://events.static.linuxfound.org/sites/events/files/slides/pnfs.pdf
