Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D14BC433E7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 11:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CEF207F7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 11:29:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+fKagAN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406342AbgJPL3A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 07:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406338AbgJPL27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Oct 2020 07:28:59 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D87C061755
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2020 04:28:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so1274199pgl.2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2020 04:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6XdYDRECZiUzPZNFm2VdGXKoKgjpMx99Id/4R7vF0yg=;
        b=m+fKagANZlxz4Xn6FGO5gq9kmuilxnC6F00pO2EFfivKgBuUAQ1wh17SZpI/5uJlCu
         +tuuhoYUywPUEQBOJPKLh32kJC8njJZunG/zn+vwro4efFb1rjx9k1WvsYrLTJk4qRSA
         pfLmHT7Sahz1IaF0FeIvgzjcgSLqR8y6H0H4duqB/vpyxSn3M0evfVyo90/ZE3XzyS7j
         7nHe3sottppOCPgDKNy1JsSXp2FNdpOJdSepx+NoRI4cbHIFanWG9ZsO2O/45iv9c2E6
         pn1Q0xMaqRFujAcHgNjDzeGwWUSbL6MRrO+F4aYlwVRMOFRlaZut4nNNJWXuBOebn/99
         v3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6XdYDRECZiUzPZNFm2VdGXKoKgjpMx99Id/4R7vF0yg=;
        b=MpHodA10CUYGNizVSXunLeLE/sU/ZMj2fDhO8SAd4Uv4yRWxuLfS8BKF7F+BWIp1aG
         KLZHmwgl/iZ+LDn+anLIAKXGWLR2/GU5C5PpubY3Xte6I6H6D8k8omnd3Js0/mi/Mje5
         ooiwykfn1WNKvs4HDa7k1ksC1SWSMwW0+B7viG0fexs/MXWlsOSSYVhv7ht5v5imPzr7
         zeFBPp7YIONygEL0agDJ36X76ieQt+lppxjnvznSyA177ybcNhoByzSVEMBVoySXACwx
         Wyjo5DKjIC78fCZrcPEuQ91WwcS9Hs63WGs6/VssEKOCW8nOEyJI0qF8tK47HL7cbscg
         mvog==
X-Gm-Message-State: AOAM530ryo+t7B4qqyZJ/GayxgmGyb7cjoRr8wzX/QwPaYlloniB5QeB
        gGsfPt9kt+ryCRbax0zLacpqcENHuZk=
X-Google-Smtp-Source: ABdhPJwVbOZPj2Zd08N/UtpoWT+7z7BOw1Jt2hhkCUKZ9hGGod3hawAl0Osv9mJM1w2jfEdhzkbqTA==
X-Received: by 2002:a63:396:: with SMTP id 144mr2882620pgd.364.1602847737418;
        Fri, 16 Oct 2020 04:28:57 -0700 (PDT)
Received: from garuda.localnet ([122.167.154.211])
        by smtp.gmail.com with ESMTPSA id 132sm2494070pfu.52.2020.10.16.04.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 04:28:56 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping an extent
Date:   Fri, 16 Oct 2020 16:58:53 +0530
Message-ID: <1899682.3A2Fs4cuYb@garuda>
In-Reply-To: <20201016070448.GA12318@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com> <1680655.hsWa3aTUJI@garuda> <20201016070448.GA12318@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 16 October 2020 12:34:48 PM IST Christoph Hellwig wrote:
> On Thu, Oct 15, 2020 at 03:31:26PM +0530, Chandan Babu R wrote:
> > How about following the traits of XFS_IEXT_WRITE_UNWRITTEN_CNT (writing
> > to unwritten extent) and XFS_IEXT_REFLINK_END_COW_CNT (moving an extent
> > from cow fork to data fork) and setting XFS_IEXT_REFLINK_REMAP_CNT to a
> > worst case value of 2? A write spanning the entirety of an unwritten extent
> > does not change the extent count. Similarly, If there are no extents in the
> > data fork spanning the file range mapped by an extent in the cow
> > fork, moving the extent from cow fork to data fork increases the extent count
> > by just 1 and not by the worst case count of 2.
> 
> No, I think the dynamic value is perfectly fine, as we have all the
> information trivially available.  I just don't think having a separate
> macro and the comment explaining it away from the actual functionality
> is helpful.
> 

Darrick, I think using the macros approach is more suitable. But I can go
ahead and implement the approach decided by the community. Please let me know
your opinion.

-- 
chandan



