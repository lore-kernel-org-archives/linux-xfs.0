Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C465FC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 14:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971BF2054F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 14:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiWA/jwX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgH0Oqf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbgH0ODp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 10:03:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C931DC061237
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 06:51:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u128so3548115pfb.6
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 06:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bOOR/XjCeTDV9QcX9XgIFuW962jiAA4qNIfyybCnoM=;
        b=KiWA/jwXXGcRO9TJKHWV348kXCjl6XE3Hsapr2m+LkIIQ3faPQcA051KxZRpO9aJAY
         z86NgR2O0kNphAHyUamXFdKo/Mvwz5bmTuNHuur6ZEvZ9uyghb3AepTffUK4TAA/UBlR
         2S/b66BCR3+WksGamArkH3MOeKanTlZEwc8pGaOKUBZrooqgdA8bsYfEo1co6pNzPe/B
         QyNQNQWDW/f926bdd+3bwwz+kdx3N8jGIhjRugN3ruT/ftnd02oPdnl1dfUcFKjiNR/W
         iY6K6B3faA/S6G88L+hVv0jh5PXOrUfJkPSkvSNe4kJ2/bYYsapx9VsrUvY6RZbW1j4/
         ZkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bOOR/XjCeTDV9QcX9XgIFuW962jiAA4qNIfyybCnoM=;
        b=UDrbRIcoPubeh6pIi5vfiIiZkflC0QrDOvhEJpmMJzUrXSM3Kkb4Qt5iVnPn/PI7nL
         zEVHZuVwQz5Cl4DCaWW75tMmS/ycS08ctvS6OU2GGeqbzjy09ZmJ3fGIxUumVz+hQslS
         N3ge8rgw9SyYctk8D/2I6k5ioV5DYaDn3tfA2SQ0Qar+g7573t7gHdUs/FvhkXialrab
         0z4drpxIqgVKNNH2yxMf+vdZq26I+3g0QLS5XR48o1zsTVbVsc7bbJoku5W4LFDfGn4h
         pGJqwViHLLobn7LcymDIA6GIijnd0lfv71HRgwsseJI+6YT4ViXAM6mTcueiuB8kk0OE
         naqQ==
X-Gm-Message-State: AOAM532X+r8wq5wUeiIAyHzpbTqJWpx0IrDh+sC2EIBx01CZG9ys2UJY
        4RBUjpvaAUnsYOpUEyx823bz9hGtA28=
X-Google-Smtp-Source: ABdhPJwPfbD4Cq73oQJev8mhayPdZVLW2UGyfn5ygXFxavcfjZYtIVTSbEN+GnjH8Rcn6ZhiK2rpCg==
X-Received: by 2002:a65:4b86:: with SMTP id t6mr5848122pgq.81.1598536304395;
        Thu, 27 Aug 2020 06:51:44 -0700 (PDT)
Received: from garuda.localnet ([122.167.43.0])
        by smtp.gmail.com with ESMTPSA id u14sm2976287pfm.103.2020.08.27.06.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 06:51:43 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V2 02/10] xfs: Check for extent overflow when trivally adding a new extent
Date:   Thu, 27 Aug 2020 19:21:40 +0530
Message-ID: <1656934.1cLk1VkT8O@garuda>
In-Reply-To: <20200827080903.GA7605@infradead.org>
References: <20200814080833.84760-1-chandanrlinux@gmail.com> <1740557.YaExq995uO@garuda> <20200827080903.GA7605@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 27 August 2020 1:39:03 PM IST Christoph Hellwig wrote:
> On Mon, Aug 17, 2020 at 01:14:16PM +0530, Chandan Babu R wrote:
> > > > +		error = xfs_iext_count_may_overflow(ip, whichfork,
> > > > +				XFS_IEXT_ADD_CNT);
> > > 
> > > I find the XFS_IEXT_ADD_CNT define very confusing.  An explicit 1 passed
> > > for a counter parameter makes a lot more sense to me.
> > 
> > The reason to do this was to consolidate the comment descriptions at one
> > place. For e.g. the comment for XFS_IEXT_DIR_MANIP_CNT (from "[PATCH V2 05/10]
> > xfs: Check for extent overflow when adding/removing dir entries") is slightly
> > larger. Using constants (instead of macros) would mean that the same comment
> > has to be replicated across the 6 locations it is being used.
> 
> I agree with a constant if we have a complex computed value.  But a
> constant for 1 where it is obvious from the context that one means
> the number one as in adding a single items is just silly and really
> hurts when reading the code.

I think we should retain the macros because there are nine macros out of which
three macros do trivial amounts of computation rather than having literal
integers as values. Having macros for these three while using literal integers
for other six cases would IMHO make the code non-uniform. If we end up
removing the macros completely we would have two problems,
1. Redundant code comments sprinkled across the code base explaining the logic
   behind computing the "extent delta".
2. In the future, if the "extent delta" value has to be changed for an
   operation, it has to be changed across all the relevant invocations of
   xfs_iext_count_may_overflow().

-- 
chandan



