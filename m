Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190A8C47404
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 10:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DFB2084C
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 10:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ckoCWi34"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfJKKbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 06:31:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37550 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfJKKbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 06:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LyKGAyW3gfj+dtXeOfhSEREW8br0SHPpId6OAsWbrD4=; b=ckoCWi34ERh6iwSu1YuSkl4/Z
        yhhrjWZj0c1VYc4sWd7Lcy/DVekSkQy7iIuanQttNWqelMClrN4dveT6Pt1Ud7JbEDUUf9bRpikad
        1BT3+TjbmfZTjExIRdPmZ/5cFHGy1ZRokBKmlQmRHpJrXnXx4qC4VAPW0M5+tGRbBoPM8lyMKYIOA
        w10ny9XvLLnuTIsa8HfMw7QzfPezMbYDPePvZzUeu2ZWHJOBsvGB8SlL5emePxEgHqziXibIp/PPR
        fC36pjWZ0xobn2uu/D1VoTqTlJ0BQLzjBf5p8+MYH78Xc0aqTlKFZjJN3RMXS0BVyAk0wYOaTVQN5
        c8D9/GWAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIsCg-0000RH-PG; Fri, 11 Oct 2019 10:31:22 +0000
Date:   Fri, 11 Oct 2019 03:31:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 19/26] xfs: kill background reclaim work
Message-ID: <20191011103122.GB12811@infradead.org>
References: <20191009032124.10541-1-david@fromorbit.com>
 <20191009032124.10541-20-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009032124.10541-20-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 02:21:17PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This function is now entirely done by kswapd, so we don't need the
> worker thread to do async reclaim anymore.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
