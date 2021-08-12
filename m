Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60011C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 409B060FED
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhHLIM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbhHLIM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:12:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372CBC061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+feBsywzksRjPysiCa9tlksrIpsLdDfp1fWUu3EuSss=; b=nr6qMCVe7xyu3TBY36EaECVwGv
        jY1o4XytkqI6d8ZlDkmWBQJKLOk6Rl2pWx0wimDl81//gtuoKZmcEd7QvfiUnj6b5mImys1DR+igz
        HjvTVsCiB11TdnGgt+Y+TP8a2zURrI/rJ59yVADz2lDbIL0+E9ZHV0Tl+CtMfsNiEqHRqDbVPuZ13
        W3Nm1cVWB4n2KIcDwOBfeC+X0qGpwqbrq498hsBazaNxFRBwFvOGEe73WP8hG8IeV4LUEh/oMhZHi
        ILzfVKoQqh5qGyRB5EdIECxDxvV9ipiR8zeaspLda74jimrr/hw9cHolFRXz0Uyc5/VYOpxAT7O/b
        x2F5IZxQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5nk-00EKf8-Mz; Thu, 12 Aug 2021 08:11:25 +0000
Date:   Thu, 12 Aug 2021 09:10:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce xfs_buf_daddr()
Message-ID: <YRTXkHkJeIzEfGfQ@infradead.org>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052851.42312-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:28:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce a helper function xfs_buf_daddr() to extract the disk
> address of the buffer from the struct xfs_buf. This will replace
> direct accesses to bp->b_bn and bp->b_maps[0].bm_bn, as well as
> the XFS_BUF_ADDR() macro.
> 
> This patch introduces the helper function and replaces all uses of
> XFS_BUF_ADDR() as this is just a simple sed replacement.

The end result looks sane, but I would have preferred to do one patch
that just does the script rename of XFS_BUF_ADDR, and one ore more to
clean up the rest.
