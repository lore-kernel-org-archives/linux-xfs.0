Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596D2C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23968613C6
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbhDFNLU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhDFNLT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 09:11:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0267C06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 06:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c5bCfXP9h9npnsLxVo4Eh5eKYv7m7ACjrqyuqXj2Brk=; b=myhP4w3YWAm2WAcqJt+1GL+dlJ
        r5HlftH9zB/fynvCFHXsKv1TGq2HsCVihBuWRUIvlaZEZb98Qyb9WolJWJs6/Af/kmUQAl1aMOLqH
        behwLcGejS/NWoWv53RbQ0OyAHZ9kCEXLMRhzeGRd2G0Io9uq9gcgnUUELgmSI2T5DJETRui1rRlv
        KMrycez8ZYKJkmj+qStXZUdMd6VHFzZqnE+xhXJcbwLB0lmyhkAHzF72sHzfBqescWW1C+0izPuld
        MVJm+8BcATH7weBz8FgHhhM7+kDQpIBdmBzHB7h1etUoYsr5x67QzlWprfNrwy50mxGveEOVxkuyw
        VZnuk54w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTlTn-00Cq23-LD; Tue, 06 Apr 2021 13:11:00 +0000
Date:   Tue, 6 Apr 2021 14:10:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
Message-ID: <20210406131051.GA3059873@infradead.org>
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406115923.1738753-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 09:59:21PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Due to confusion on when the XFS_IFEXTENT needs to be set, the
> changes in e6a688c33238 ("xfs: initialise attr fork on inode
> create") failed to set the flag when initialising the empty
> attribute fork at inode creation. Set this flag the same way
> xfs_bmap_add_attrfork() does after attry fork allocation.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
