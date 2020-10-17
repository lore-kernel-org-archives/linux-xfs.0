Return-Path: <SRS0=9vdY=DY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286CEC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 06:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5CF720709
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 06:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vdshartY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436977AbgJQGCS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Oct 2020 02:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436901AbgJQGBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Oct 2020 02:01:40 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA035C05BD41
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2020 19:55:10 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e10so2579644pfj.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2020 19:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VItq8Msb2njYV9Sq74yyFwxad6B/7+UH7GxygDpTh98=;
        b=vdshartYJqSxbk08WW+++pC2EHuGcI8ToC5Mqe7DL5VpH4Ijky1AqiIBm89o2RMhHS
         4dvRydqt2HhIJjmPqWyEz8LSsXua+4jk6Pl4yaXTOR1d8vLcNrMUzxBx8O3yhNEI6buT
         EW6RXDXB1b2xqzL+MPw+5CZDCbPTvdZyuJIYMLq3xXD+MBrKdTZqjsh+aAlhYlqS3VWT
         8PjRdjz9ovs2hSizGACVj98givXytm3ej/VyY9Xpq4Zs+dVcEjqmvTMZRhx90D9R17pm
         mRRdVlfPeVTGZ9qkektrGO6QsjnejuASaTFQ3QRbAN/LBqnsbnoRcIVyzVsRVR1wb4Cq
         ZQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VItq8Msb2njYV9Sq74yyFwxad6B/7+UH7GxygDpTh98=;
        b=SY38Tu695c54Vp8hMNHCPLo/lnRngZPRmitUddThYwBLMceViUT7nORRUiiAXNaUPn
         DXC9bNV8d+34bicRRvxthHih2YpWFfzb2GgmFjp1cKtGDarda+6BTCc0pCyxuECVCSga
         OodquA83gaYiFT/T/LlDyR3KfbLLcBcP4YcM2Q9gK5l8UX9RfEVfvWTNtp8YD8/woi27
         QiaLBEcKRE5oGgEzqS0yJ3boKNCdo5+q1IaP+1eWQ797nxPXwVpEoJxI1zAnmUCkuoES
         0Pohzr9gPMSWoR7zp0VFSn+m7lg5wm7T7FBe5K3n9hVPbbuKgm+mq9POMVqW5pQZNffa
         y8UA==
X-Gm-Message-State: AOAM531Djho4TYsNZdUFEj73+SbOMlHY1b/QRxgRxL9UgiPZPc8YB+PF
        EzLSyqxdj8ZxbRKXI/Hwnvo=
X-Google-Smtp-Source: ABdhPJyQi67Jx1eo7fW84B+Pl72ct40CP0t1P5vo7+wG+Cvnt2edy2WAnDn8d5r2qPno1AGrZbsJTQ==
X-Received: by 2002:a62:1b02:0:b029:154:fdbe:4d2a with SMTP id b2-20020a621b020000b0290154fdbe4d2amr6701743pfb.27.1602903310180;
        Fri, 16 Oct 2020 19:55:10 -0700 (PDT)
Received: from garuda.localnet ([122.171.207.103])
        by smtp.gmail.com with ESMTPSA id x4sm4025424pfm.86.2020.10.16.19.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 19:55:09 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping an extent
Date:   Sat, 17 Oct 2020 08:25:01 +0530
Message-ID: <6492308.izWhvZ5asW@garuda>
In-Reply-To: <20201016152900.GD9832@magnolia>
References: <20201012092938.50946-1-chandanrlinux@gmail.com> <1899682.3A2Fs4cuYb@garuda> <20201016152900.GD9832@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 16 October 2020 8:59:00 PM IST Darrick J. Wong wrote:
> On Fri, Oct 16, 2020 at 04:58:53PM +0530, Chandan Babu R wrote:
> > On Friday 16 October 2020 12:34:48 PM IST Christoph Hellwig wrote:
> > > On Thu, Oct 15, 2020 at 03:31:26PM +0530, Chandan Babu R wrote:
> > > > How about following the traits of XFS_IEXT_WRITE_UNWRITTEN_CNT (writing
> > > > to unwritten extent) and XFS_IEXT_REFLINK_END_COW_CNT (moving an extent
> > > > from cow fork to data fork) and setting XFS_IEXT_REFLINK_REMAP_CNT to a
> > > > worst case value of 2? A write spanning the entirety of an unwritten extent
> > > > does not change the extent count. Similarly, If there are no extents in the
> > > > data fork spanning the file range mapped by an extent in the cow
> > > > fork, moving the extent from cow fork to data fork increases the extent count
> > > > by just 1 and not by the worst case count of 2.
> > > 
> > > No, I think the dynamic value is perfectly fine, as we have all the
> > > information trivially available.  I just don't think having a separate
> > > macro and the comment explaining it away from the actual functionality
> > > is helpful.
> > > 
> > 
> > Darrick, I think using the macros approach is more suitable. But I can go
> > ahead and implement the approach decided by the community. Please let me know
> > your opinion.
> 
> The macro only gets used in one place anyway, so I don't see as strong a
> need for it as the other places.  I think this one could be open-coded
> next to the places where we decide the values of smap_real and
> dmap_written.  (i.e. what Christoph is suggesting)
>

Ok. I will make the relevant changes.

-- 
chandan



