Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C966C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 12:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359848AbiFPMBn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 08:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiFPMBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 08:01:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BD65EDC4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 05:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rKW7WRCGuyB1K2VUy63pf+lbzpQbFiXtIcTkDurcHJo=; b=1xGZfTA7L5tafnWjrJk3lnlrHc
        9RCHG73QDZKjQ1UrlzrAuYfKBNAlrvcjJhtjqEf3pgaAXIX/SQUQxUDV+M9vfPInOVBSmjGXBXhxY
        YN3vC9YJvKJFKRRCVR//KYi9WhzzHDllZo38o8ONlJgMhTOcP6juYC17+J0WclRQyg893VqU2C+M+
        0bvmvh0LSuVyreFSxw06tnOPAGel0EpL8dvVcb/ex4TuJJPb3u/7P/dLI07JwnXcZDFNtfAMeDPa3
        28y038syBNCuM+sa9LYDKHdF9WjVR+O4CKLgtgvPNlhp14N4d2XkYHk1NnNXxwEw/d0SFnR0MsNPf
        VurrXCWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1oBw-002DIu-B4; Thu, 16 Jun 2022 12:01:40 +0000
Date:   Thu, 16 Jun 2022 05:01:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC] [PATCH 00/50] xfs: per-ag centric allocation alogrithms
Message-ID: <YqsbpL9BZes7qDbv@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 11:26:09AM +1000, Dave Chinner wrote:
> 
> This series starts by driving the perag down into the AGI, AGF and
> AGFL access routines and unifies the perag structure initialisation
> with the high level AG header read functions. This largely replaces
> the xfs_mount/agno pair that is passed to all these functions with a
> perag, and in most places we already have a perag ready to pass in.

Btw, one neat thing would be versions of helpers like XFS_AG_DADDR
and XFS_AGB_TO_FSB that take the pag structure instead of the mp/agno
pair.
