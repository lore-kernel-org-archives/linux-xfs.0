Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEB1C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 10:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEAA220776
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 10:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0X9mToU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgJOKBg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 06:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgJOKBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 06:01:35 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF77FC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 03:01:35 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gv6so1700060pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 03:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=53OIDB2eXtUoZ2YmoX8PNSNPRtg5aBIu7k2vK0Ui9hc=;
        b=Q0X9mToUiPwf7eM5+FZBEROiNX0dvle1qgDW23ZUAwUBxCDg5JT7AXKoOEAJqsY9sn
         Bh08CfOdw4BTRdgwpfOBjhQCqiNDd21W0iLaPxPcQwuIVNT5G3/mcXHSQTUcpXzjZ2hL
         Zjs8mlxrS4vKZbCi1OU/vCKpbh2s0/MqTWwgcVDBxY1je3imHJReXBOM72txeNF5P6bk
         HXXcl1XownNkCwNCjQz8Uo5E0gcusZoFLMgk0NWv/szwmNO/OWcPvb6e/ewQDqDEbzZO
         AtUPHJwO/JmRpQbnHhH649I8ohMM5GZsQGg+cWvNv+LftabVTYTtN3rXVGgCzKpu4HAC
         xWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=53OIDB2eXtUoZ2YmoX8PNSNPRtg5aBIu7k2vK0Ui9hc=;
        b=Wr8CCaHQ6JpMtnwDH82j9j9If2CKGnvCG+ca9vjSzPNiRT/v/fAzVvqrQDtWTnmCx+
         DgoyvRxZA6XOzn4EKHFh87dI/e6V7UgjWAMFjq149j/w//8iLGDhQSmIk0HOtvrlc5J5
         r2Fg+C2VcYTOyecXZBaaBWLrDyXqErVBOvzDMXN/t0QRAD959SGtjhPJaWEN4y7el1LC
         alBHytuH5VmpHTtTu18+MwMKfmV8S7ZkuHaNLbGcSnc1NEheRSZvcsxJETCcP1dpOjUR
         4rphWrqDgUDa2gRgsLzC0qcNLqxgMLchJOlTtIz2G8ixZjbghRowzhkVrtDSYt7BBgVn
         hEHQ==
X-Gm-Message-State: AOAM530Dz1/DHC902UAorZK5uRd4xuVw3btCpjF6e2/xqTU9kga3qUXi
        A7LXreRyEe64cUp7Rx/s960=
X-Google-Smtp-Source: ABdhPJzg0uS4KD1Bs8+zIiHffM4gJtwQ/kUHHiZELuvcntZWtWL2+ewgkO2YDCT5bmEeLUK8KlC0qQ==
X-Received: by 2002:a17:902:db82:b029:d4:cbd6:24c1 with SMTP id m2-20020a170902db82b02900d4cbd624c1mr3231185pld.5.1602756095171;
        Thu, 15 Oct 2020 03:01:35 -0700 (PDT)
Received: from garuda.localnet ([122.167.224.49])
        by smtp.gmail.com with ESMTPSA id f12sm2702414pju.18.2020.10.15.03.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 03:01:34 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping an extent
Date:   Thu, 15 Oct 2020 15:31:26 +0530
Message-ID: <1680655.hsWa3aTUJI@garuda>
In-Reply-To: <20201015083945.GH5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com> <20201012092938.50946-9-chandanrlinux@gmail.com> <20201015083945.GH5902@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 15 October 2020 2:09:45 PM IST Christoph Hellwig wrote:
> This patch demonstrates very well why I think having these magic
> defines and the comments in a header makes no sense.
> 
> > +/*
> > + * Remapping an extent involves unmapping the existing extent and mapping in the
> > + * new extent.
> > + *
> > + * When unmapping, an extent containing the entire unmap range can be split into
> > + * two extents,
> > + * i.e. | Old extent | hole | Old extent |
> > + * Hence extent count increases by 1.
> > + *
> > + * Mapping in the new extent into the destination file can increase the extent
> > + * count by 1.
> > + */
> > +#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
> > +	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
> > +
> >  /*
> >   * Fork handling.
> >   */
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 4f0198f636ad..c9f9ff68b5bb 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1099,6 +1099,11 @@ xfs_reflink_remap_extent(
> >  			goto out_cancel;
> >  	}
> >  
> > +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > +			XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written));
> > +	if (error)
> > +		goto out_cancel;
> > +
> 
> This is a completely mess.
> 
> If OTOH xfs_reflink_remap_extent had a local variable for the potential
> max number of extents, which is incremented near the initialization
> of smap_real and dmap_written, with a nice comment near to each
> increment it would make complete sense to the reader.
>

How about following the traits of XFS_IEXT_WRITE_UNWRITTEN_CNT (writing
to unwritten extent) and XFS_IEXT_REFLINK_END_COW_CNT (moving an extent
from cow fork to data fork) and setting XFS_IEXT_REFLINK_REMAP_CNT to a
worst case value of 2? A write spanning the entirety of an unwritten extent
does not change the extent count. Similarly, If there are no extents in the
data fork spanning the file range mapped by an extent in the cow
fork, moving the extent from cow fork to data fork increases the extent count
by just 1 and not by the worst case count of 2.


-- 
chandan



