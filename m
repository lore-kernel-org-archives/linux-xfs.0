Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30816C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD28D206DD
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:25:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uqljxm/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgEVHZ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 03:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgEVHZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 03:25:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63532C061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2zGSEn/8/n9Cj9azd37bIvX1X0AQm2unowOFYhGpy30=; b=uqljxm/UIksc5YvFMv80lhZ7/f
        DQjxj/jLg5dCJbSIdTwxpAlqysoP5kB5EpugtYxKaFcl0yk404s+sgOo7r2s91+51I8SsDgsbJgaf
        D/VxwzPz/k+otdhVELd3eKKZRPErVli5rcpmvXkVsj3uSIK4mabZS8scj0U/lnqWU+clTZ0qQctXE
        zMbyD1uGwaVvk0T0VXe314esjxnhyvnkSqhrRP0epwOBrvT+qAYSwoaFWnI+gzEjP46JCkdIA6pcE
        PJq9zNi6taFaMSIHNYJE37AUvFCbHcFB7KfxB+RmPGUzcvskmnOnZxNSxmGygwhXKKKMwjJzz54i6
        baQhJD5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jc23a-0005z0-9F; Fri, 22 May 2020 07:25:26 +0000
Date:   Fri, 22 May 2020 00:25:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/24] xfs: remove logged flag from inode log item
Message-ID: <20200522072526.GA28816@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This was used to track if the item had logged fields being flushed
> to disk. We log everything in the inode these days, so this logic is
> no longer needed. Remove it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
