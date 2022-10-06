Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C20EC43219
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Oct 2022 13:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiJFNQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Oct 2022 09:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiJFNPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Oct 2022 09:15:53 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E970CA926B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Oct 2022 06:15:49 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id d15so942511qka.9
        for <linux-xfs@vger.kernel.org>; Thu, 06 Oct 2022 06:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GSOPunDdTF0UIVvBpION9xBpexDiGo+rjOxipFbXtOA=;
        b=YJq2YGkFeQQnZGQs1UjeUfp3PIbxvPtc3BRdIrayZPHuDxEr90DSosTDzJRxyOXYiY
         hrXJC5lUxJRra0qPv5OhUKtzMK36wwIum4JVVBROb3hXEn4kT2T2RDgsnXVRvpM68qDA
         Eby+sYlqS6k8sHtuWJGwCc6XlXdfw6LjUvrfTWCzcKHqbCzXEmswmVHOAbZ03Eo8xYCf
         4DLXFP68ls86QAzktnCq8UNyvZydsdX2X+ThEGxlurjcVi3lVjwo3ujhUaumFmY2flNO
         fDQiKf+GCGO35onUA3GUoRAY8pMUDgeTpHyE1Pr5QDAaJuux5a0l2Pc6upnuuoK+jLtw
         5hIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSOPunDdTF0UIVvBpION9xBpexDiGo+rjOxipFbXtOA=;
        b=no2+jyqWlyZgIaGAVbmIChoQC1p3nNxE54YuklOShajDnC59C54cWMvkJpZwI74HCo
         yfv5YaHjxFDzTvQM43CZz16kuPn2XW1Gua/6fEcVKWEV8Bfx4JT7TRf4j5u85hYCN7kO
         59vPAYHRcj8f80kI50fNFXMEMK3C2rOZN8bGpFos6BWYUx4/XKKiJaP5uoag6f1x9/X9
         84pENZILocDtPH4MaMhWzC3Yu+W9Fx6zQszM6j80U9DDKNmTIthkCWDnUcU3bszvF0K/
         l6Pw0BQOb6hp7ZHGsvM4qarpP5On6dgbyEA7cBwNxbIJInaAXwg+ltrOa2XrCtVuwGNq
         F3BA==
X-Gm-Message-State: ACrzQf3OGnk3A94ZIqAU/q3F3LT9yMOrWO+V1I+gUpH15UJqgP4VNZxE
        Qsc0PGFb+m1NA836mOoDp9sRoe0CeaFvI0Uy
X-Google-Smtp-Source: AMsMyM4GpHypPhwf4qnIOCDMCCPPCaDHHZXra2UnB6U4hePjwcf7/TKsWZTRJwrBHYFFgt7B+K7zfA==
X-Received: by 2002:ac8:5703:0:b0:35c:c3f6:5991 with SMTP id 3-20020ac85703000000b0035cc3f65991mr3383265qtw.185.1665062137334;
        Thu, 06 Oct 2022 06:15:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id k11-20020a05620a0b8b00b006cbc6e1478csm18686320qkh.57.2022.10.06.06.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 06:15:36 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ogQit-00A1hY-6O;
        Thu, 06 Oct 2022 10:15:35 -0300
Date:   Thu, 6 Oct 2022 10:15:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        cake@lists.bufferbloat.net, ceph-devel@vger.kernel.org,
        coreteam@netfilter.org, dccp@vger.kernel.org, dev@openvswitch.org,
        dmaengine@vger.kernel.org, drbd-dev@lists.linbit.com,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
        linux-actions@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-raid@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xfs@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        SHA-cyfmac-dev-list@infineon.com, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v1 3/5] treewide: use get_random_u32() when possible
Message-ID: <Yz7U99PPl8uHCLFY@ziepe.ca>
References: <20221005214844.2699-1-Jason@zx2c4.com>
 <20221005214844.2699-4-Jason@zx2c4.com>
 <Yz7OdfKZeGkpZSKb@ziepe.ca>
 <CAHmME9r_vNRFFjUvqx8QkBddg_kQU=FMgpk9TqOVZdvX6zXHNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9r_vNRFFjUvqx8QkBddg_kQU=FMgpk9TqOVZdvX6zXHNg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 06, 2022 at 07:05:48AM -0600, Jason A. Donenfeld wrote:

> > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > index fd9d7f2c4d64..a605cf66b83e 100644
> > > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > @@ -465,7 +465,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id,
> > >               goto err_qp;
> > >       }
> > >
> > > -     psn = prandom_u32() & 0xffffff;
> > > +     psn = get_random_u32() & 0xffffff;
> >
> >  prandom_max(0xffffff + 1)
> 
> That'd work, but again it's not more clear. Authors here are going for
> a 24-bit number, and masking seems like a clear way to express that.

vs just asking directly for a 24 bit number?

Jason
