Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32F4C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99D9E22CF5
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="txM9dwCm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfH2IXL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:23:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58092 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2IXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6iPGb6bmBZZvZ+Y3mL8uXnkLjCWSRnxTff6ZfXZCRaM=; b=txM9dwCm60DmKlPSdMFoxfW0y
        s3FVLk6wIgmPJuUjZm30FUCH/rLA/digCNPUyadKuTFmfgv5Pkqbd7L4L569JkGRwb1skayGFjc+1
        ezhvtZHY7rZpvFP+Gv9i02NakPGEaBsMuLaEo3usvtlSbcW5xbsiXTATXWz79ViV2wrbOKaZTpTX8
        PfTTBZUiI7wA+w1zpuws2c36r8+0Acf6gwu7dr4WPHFNB/Omk0sbNWvu0EZ0gq19JKoGEBUL3rOMn
        E/ouXoGvvuyWmYWX1c4R3m/mLhqtjcND+tiY6hlkLgcmjqKr2lSSjfRPQV/AJSQfzNZOQELOl23h3
        FnBs5riQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Fi2-0004of-EM; Thu, 29 Aug 2019 08:23:10 +0000
Date:   Thu, 29 Aug 2019 01:23:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reverse search directory freespace indexes
Message-ID: <20190829082310.GA13557@infradead.org>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829063042.22902-6-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 04:30:42PM +1000, Dave Chinner wrote:
> 		create time(sec) / rate (files/s)
>  File count     vanilla             Prev commit		Patched
>   10k	      0.41 / 24.3k	   0.42 / 23.8k       0.41 / 24.3k
>   20k	      0.74 / 27.0k	   0.76 / 26.3k       0.75 / 26.7k
>  100k	      3.81 / 26.4k	   3.47 / 28.8k       3.27 / 30.6k
>  200k	      8.58 / 23.3k	   7.19 / 27.8k       6.71 / 29.8k
>    1M	     85.69 / 11.7k	  48.53 / 20.6k      37.67 / 26.5k
>    2M	    280.31 /  7.1k	 130.14 / 15.3k      79.55 / 25.2k
>   10M	   3913.26 /  2.5k                          552.89 / 18.1k

Impressive!

> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

FYI, the Off here should be all lower case.  Patch 2 actually has the
same issue, but I only noticed it here.

> @@ -1781,6 +1782,9 @@ xfs_dir2_node_find_freeblk(
>  		 */
>  		ifbno = fblk->blkno;
>  		fbno = ifbno;
> +		xfs_trans_brelse(tp, fbp);
> +		fbp = NULL;
> +		fblk->bp = NULL;

Hmm.  Doesn't this actually belong into the previous patch?
