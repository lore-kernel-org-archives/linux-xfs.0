Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373A1C7EE23
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 21:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjFAVoC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 17:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjFAVoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 17:44:01 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A09D1
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 14:44:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b039168ba0so11949485ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 Jun 2023 14:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685655840; x=1688247840;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rWE7fUtKddKIOSlE+ELrznceRtgHPDSIPev1IKzGaBw=;
        b=LbWybZTdw30aR9X91q+XrjraUiEcjfvjSftDilWu/k1cz8dDro7CCFgyL0IbWPdae7
         HawlqXiMjESR1LkUqdPU/4D9XPnPrBHbGzNpLS+mf0wXXO16ZNV6grszBn7cSDaKfoez
         fwtZRyQSRaKwiWwwTdn+QBO0LPg/UpQ2GB8f1fkGgaKnLA5+I/HiKSJn4tl2OJVKS5l0
         duefUGa2aF7yISBi0+TaXRxps29/BUwZqch/HVvVFxJ502oRCTTYRpveirHgdWCXU2Fs
         PgNOyA7RywLwtSXGVap/baNCUGgV+/3gMNYJxHxijl9KSdOzvGPh2XjvjwRruSBL7KZr
         jOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685655840; x=1688247840;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rWE7fUtKddKIOSlE+ELrznceRtgHPDSIPev1IKzGaBw=;
        b=HfKiGM/IPvzRKhtYN6hBT6+LipzyseKyvEPOps3DXfqugGI3xbUMVpyoOJITzZ4BKk
         Vbazu16EctkFFEpUY4ve0nLJQrkwoAVhB6NpjXZNHsLIE3K3AOeSUFw/TGITJcuzezGP
         G2Hi73kn5nuDjqDw0pcVebZWSVdkgCKvbvn0nVZlUlAhQ9W3/5TVb17pQjzz/yO3EyWO
         5Pl5qQ8rsJJvI1wVpF7wvpURahuy2YtSjdzYNq85YI1XSePskz5nuLIPDFAxi5WcpQBJ
         k0QkWyX1Xu4oUXfVwaGu3HFFq77/5yKA1eyQYjzRLsJw1/ABO7QU06qc98Rz+dqTThpT
         wpAw==
X-Gm-Message-State: AC+VfDyPSfSephcNgIgD8DVUwW3VzM/csl7eWB+faZVeIzqV5Ht+mTra
        o6XOSikNVeTEZnTzTC9z+9PgBpT3vXgmAv0tKqI=
X-Google-Smtp-Source: ACHHUZ7NmGQeuJzb0lbjhvgqFi5enz75rgoLDPpSU3w2ti/kO09jRF2EwzRV3INcieNLAe07fwmn/Q==
X-Received: by 2002:a17:902:f7d4:b0:1b0:2f15:e0b3 with SMTP id h20-20020a170902f7d400b001b02f15e0b3mr525686plw.50.1685655839943;
        Thu, 01 Jun 2023 14:43:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001b02bd00c61sm3969131plg.237.2023.06.01.14.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 14:43:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q4q5N-006eze-0B;
        Fri, 02 Jun 2023 07:43:57 +1000
Date:   Fri, 2 Jun 2023 07:43:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jianan Wang <wangjianan.zju@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question on the xfs inode slab memory
Message-ID: <ZHkRHW9Fd19du0Zv@dread.disaster.area>
References: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
 <ZHfhYsqln68N1HyO@dread.disaster.area>
 <7572072d-8132-d918-285c-3391cb041cff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7572072d-8132-d918-285c-3391cb041cff@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 31, 2023 at 11:21:41PM -0700, Jianan Wang wrote:
> Seems the auto-wraping issue is on my gmail.... using thunderbird should be better...

Thanks!

> Resend the slabinfo and meminfo output here:
> 
> Linux # cat /proc/slabinfo
> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
.....
> xfs_dqtrx              0      0    528   31    4 : tunables    0    0    0 : slabdata      0      0      0
> xfs_dquot              0      0    496   33    4 : tunables    0    0    0 : slabdata      0      0      0
> xfs_buf           2545661 3291582    384   42    4 : tunables    0    0    0 : slabdata  78371  78371      0
> xfs_rui_item           0      0    696   47    8 : tunables    0    0    0 : slabdata      0      0      0
> xfs_rud_item           0      0    176   46    2 : tunables    0    0    0 : slabdata      0      0      0
> xfs_inode         23063278 77479540   1024   32    8 : tunables    0    0    0 : slabdata 2425069 2425069      0
> xfs_efd_item        4662   4847    440   37    4 : tunables    0    0    0 : slabdata    131    131      0
> xfs_buf_item        8610   8760    272   30    2 : tunables    0    0    0 : slabdata    292    292      0
> xfs_trans           1925   1925    232   35    2 : tunables    0    0    0 : slabdata     55     55      0
> xfs_da_state        1632   1632    480   34    4 : tunables    0    0    0 : slabdata     48     48      0
> xfs_btree_cur       1728   1728    224   36    2 : tunables    0    0    0 : slabdata     48     48      0

There's no xfs_ili slab cache - this kernel must be using merged
slabs, so I'm going to have to infer how many inodes are dirty from
other slabs. The inode log item is ~190 bytes in size, so....

> skbuff_ext_cache  16454495 32746392    192   42    2 : tunables    0    0    0 : slabdata 779676 779676      0

Yup, there were - 192 byte slab, 16 million active objects. Not all
of those inodes will be dirty right now, but ~65% of the inodes
cached in memory have been dirty at some point. 

So, yes, it is highly likely that your memory reclaim/OOM problems
are caused by blocking on dirty inodes in memory reclaim, which you
can only fix by upgrading to a newer kernel.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
