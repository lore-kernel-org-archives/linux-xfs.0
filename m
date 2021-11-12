Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F34C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 06:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C2C60F45
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 06:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhKLGm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Nov 2021 01:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhKLGm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Nov 2021 01:42:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1148DC061766
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 22:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KkJn5a2hSWRpD4SIGG2hBAqrHsN8rD2dxLrp6OdUHdQ=; b=nYFg6dqPVml4OSo8/DEYDG3Whd
        RtjiyUvExQsyiivP+no8HuBYu0So2Nt6XSlv553xwdSFhT+IjW1OtB8Yq1SphCQMamqpNQWTLH3V8
        5UB/dqZ/m0XsfcdSC/zWPP5q+IhTSVy1Jl6AfRfQNNAT/AFmKGL+0grbqNMRvybW74y+V+eEssqUb
        QvfjEuYIyoJ1l9+SiiRjm+Ksjom8ikK2USG6Q1N6TfDZwXvQTKVR9oFk7Q+gM5R2PDb/Tk1DD4q5v
        hnwNDatrw0WjrW5YeHokQwTqzj2Xz9THS8XW4OMUUHiaEvf7zXARsnYK3UuUYULVfpjvEse+SswCb
        3WrN1RMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlQEK-009Xos-NF; Fri, 12 Nov 2021 06:40:08 +0000
Date:   Thu, 11 Nov 2021 22:40:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Greenfield <dgrnfld@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: XFS NVMe RDMA?
Message-ID: <YY4MSDOJKc64JcU/@infradead.org>
References: <965EC18A-BF96-4544-AFE0-FA0F1787FD49@gmail.com>
 <YXBE5y2cJtAaMfzs@infradead.org>
 <YXBFaOqjMRN7ucFb@infradead.org>
 <3CBB4EC9-5953-4276-8219-DA8B10ABB05F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3CBB4EC9-5953-4276-8219-DA8B10ABB05F@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dan,

sorry for the late reply.  This sat in my outbox for a while almost
fully written.

On Wed, Oct 27, 2021 at 09:23:42AM +0100, Dan Greenfield wrote:
> Quick Question: would I be correct in assuming that if I mmap()ed each 8-64MB (chunk) file from XFS, and then did RDMA from the mmap region, that it would first be copied from NVMe into DRAM (does this bypass CPU?) and *then* be copied across RDMA, rather than directly be copied from NVMe by RDMA? Or does O_DIRECT properly allow bypass straight to NVMe for RDMA?

The answer is: it depends.  mmap on a non-DAX file system always copied
into DRAM.  mmap on a DAX file system (that is using pmem) can map
the "storage" directly into memory, in which case some RDMA setups can
DMA without a copy.

But with a plain old SSD there is no path available to userspace to
transfer without copying to DRAM.  If OTOH you use in-kernel NVMe over
fabics target, it can directly transfers from the SSDs in some
circumstances.  Currently that does require using the SSD directly
without a file system, but with a little more work it could also work
using a file system.
