Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36F9C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EE3D21874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mx6cMUEF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfH3FYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:24:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfH3FYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SVW+gxwwX7dPCTFXrx3WbxAG/zclvEv55AesJw8eDDw=; b=Mx6cMUEFjAMsXE2bza+6pQt8x
        GFtBE/Zx99vA3iN01n086KG1SDmkQvdJRRxMws5MpuhRKP7VFWVRTaUTTtQhXSmFiDhobVjbSxKe5
        gd2kWYgp2tQrXFpoJbHciToGkl1kBaFNr9xk66PBGrhpHycsc5+xafOBnWTOleadm0C/k0AzwgnJ0
        xmR/jstV8NV+p4ZGqcCTv5RVeaT2FcLZNHwLEX3NWhKQeVe4jRxKGXn5mL2iLkurIQgVLGF9w5iWe
        S4a2tlHKRR1YDRx9nsaobYZBdkdD5/W7mwONM6upXAf603aoTAT8ijSZqp/GORA3ZLTCRB8mJH96M
        bf6XiAxKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ZP4-00021h-Pq; Fri, 30 Aug 2019 05:24:54 +0000
Date:   Thu, 29 Aug 2019 22:24:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reverse search directory freespace indexes
Message-ID: <20190830052454.GC6077@infradead.org>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-6-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:47:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a directory is growing rapidly, new blocks tend to get added at
> the end of the directory. These end up at the end of the freespace
> index, and when the directory gets large finding these new
> freespaces gets expensive. The code does a linear search across the
> frespace index from the first block in the directory to the last,
> hence meaning the newly added space is the last index searched.
> 
> Instead, do a reverse order index search, starting from the last
> block and index in the freespace index. This makes most lookups for
> free space on rapidly growing directories O(1) instead of O(N), but
> should not have any impact on random insert workloads because the
> average search length is the same regardless of which end of the
> array we start at.
> 
> The result is a major improvement in large directory grow rates:
> 
> 		create time(sec) / rate (files/s)
>  File count     vanilla             Prev commit		Patched
>   10k	      0.41 / 24.3k	   0.42 / 23.8k       0.41 / 24.3k
>   20k	      0.74 / 27.0k	   0.76 / 26.3k       0.75 / 26.7k
>  100k	      3.81 / 26.4k	   3.47 / 28.8k       3.27 / 30.6k
>  200k	      8.58 / 23.3k	   7.19 / 27.8k       6.71 / 29.8k
>    1M	     85.69 / 11.7k	  48.53 / 20.6k      37.67 / 26.5k
>    2M	    280.31 /  7.1k	 130.14 / 15.3k      79.55 / 25.2k
>   10M	   3913.26 /  2.5k                          552.89 / 18.1k
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Same here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
