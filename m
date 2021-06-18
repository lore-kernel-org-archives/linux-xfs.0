Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3003C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B034661369
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhFROMa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbhFROMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:12:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABDDC061767
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 07:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ejy8e8WGxjy1/OcL88KF1835guUSn0IdMwuRzS7FPgM=; b=VV8WmhGeKXyEnc5QO4kbRmcECi
        1POzJ5ZWE8x31hj/YhiRH/OcqKGXUHLZGkuXI2Utm5T90rFN6gKm8n3fMg3tsSjSngoRN64Kbbofj
        KNXiD9Wf7Jag3+0kNVkjwZC/sJrzrt550FAge1RnBmanTrfP3WB7zrKk6JpjwewVAcfyd4NxD4cu4
        TjfrYqL8FwIDSi6oebZ22v0PjWv2NJTF3yHBGTo9MFbdnu4LrJJrx5rxM4zWYRWOdZvAmxs51wguW
        +ZQIxGgC0sJDMhwloGDUenk9E7Zj90T9/O2BhQUfi/1jr6uMFyrPtoHjlPSAVWtANebZdnjGSHKIm
        QeZF2Cjw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luFBW-00ALDx-Tx; Fri, 18 Jun 2021 14:09:37 +0000
Date:   Fri, 18 Jun 2021 15:09:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: add iclog state trace events
Message-ID: <YMypFnAPoHH1J0dZ@infradead.org>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For the DEBUGS!
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(although I wouldn't mind a more useful commit message)
