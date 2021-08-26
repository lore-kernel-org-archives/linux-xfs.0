Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E6CC432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 16:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E079D610C7
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 16:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243027AbhHZQUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:20:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233548AbhHZQUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Aug 2021 12:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629994796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7/3gAXjsOYCjvInZsh1tv7Gv6tJXcvyBWH3X0vwJBWc=;
        b=LnfkSJI5iWKHnrQvwUe0FSgO2T23xzPIkpupsN7Qngsl1Rpu1n8fSgHmpTCnRNC17MCIzT
        Ndyjr/cBU4bwY+dA7lb3J1o97zfhSKQLULx6We69blfEtDasTZrVcFy029/XMK+8W6x6Sw
        WETvhT3L1kkIHnzN4HHoYondmi/eQmg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-eV47ltyKPUyCI2vL8cs1Ag-1; Thu, 26 Aug 2021 12:19:52 -0400
X-MC-Unique: eV47ltyKPUyCI2vL8cs1Ag-1
Received: by mail-qk1-f198.google.com with SMTP id p23-20020a05620a22f700b003d5ac11ac5cso2629790qki.15
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 09:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7/3gAXjsOYCjvInZsh1tv7Gv6tJXcvyBWH3X0vwJBWc=;
        b=BzVpUxOc/RErm4xmSVFaYXqiEr77YpP2wXssd0w2P7nakQ04M9ml/q8LI6bON+XvO1
         dxSznblNr7qslMWQGr4Rxop2XcHUDaF5Uxv1cqPMvE3f1i7gvKTp73/diZ75XiOS1eSt
         ckS+CTg6Kp6PanGqlNXMpTKl8JRaNg0Gwfmm/pmj4o785N9IOySdRRgPQ1/1N1TksiVH
         laYA+6Q4WjhtDEczL5aZMkf/uiEc18Ta761xGhl33TDwRtz80NRlA+PN89Fif3uaP4rG
         s9JCdd7+mIqxmCQNzr0D9rSkVM54f3nIzDmjMXzenwj2jGFKAzl3nnIhly4hm0MHcady
         OEiQ==
X-Gm-Message-State: AOAM530jirHqqLymxBHM1XHHj0ohdbYJ+qXCYfdO+bpYI148B915fmKI
        K1Q2uXUpYaYx7yXvJQBjsA8XBOxAsXYYbadIsi1W0yNO/+LtGW+SuEg14idgKESnXuWMrQ8Lw1G
        /6m6Xf4H8wgRI5TBayMI=
X-Received: by 2002:ac8:6697:: with SMTP id d23mr4123800qtp.34.1629994791989;
        Thu, 26 Aug 2021 09:19:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJjb+DXO5M4rPM3LGWmmf30ajsbDc366at2OsGm2R0vZu/YOovqERPcrnuHp7PIFCzTyaymQ==
X-Received: by 2002:ac8:6697:: with SMTP id d23mr4123780qtp.34.1629994791782;
        Thu, 26 Aug 2021 09:19:51 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id m8sm2619535qkk.130.2021.08.26.09.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 09:19:51 -0700 (PDT)
Date:   Thu, 26 Aug 2021 12:19:50 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/9] dm: use fs_dax_get_by_bdev instead of dax_get_by_host
Message-ID: <YSe/JtXqoiHsRGqX@redhat.com>
References: <20210826135510.6293-1-hch@lst.de>
 <20210826135510.6293-4-hch@lst.de>
 <CAPcyv4ieXdjgxE+PkcUjuL7vdcnQfXhb_1aG2YeLtX9BZWVQfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ieXdjgxE+PkcUjuL7vdcnQfXhb_1aG2YeLtX9BZWVQfQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26 2021 at 10:42P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Thu, Aug 26, 2021 at 6:59 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > There is no point in trying to finding the dax device if the DAX flag is
> > not set on the queue as none of the users of the device mapper exported
> > block devices could make use of the DAX capability.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/md/dm.c | 2 +-
> 
> Mike, any objections to me taking this through a dax branch?

No.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Thanks.

