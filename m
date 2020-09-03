Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6677C433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9A920716
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 10:38:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1OUsxBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgICKif (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 06:38:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726025AbgICKia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 06:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599129509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4HNAySK8FeEMG1/hgM9m0kdfMGWgz5OyaEAu6PaQYRc=;
        b=e1OUsxBLGcIs29vHNTpA3p35qeR/h78zHv2yu7CZrcvdpj+NeCtnRwkn0O2M87lcB9x/oR
        QuCOK198Xrb5Jy0c758t4+UV2+xYYEtz7OjMxSaKzpcoYyAZEQE1PblxHcx5LqxsinwfsF
        m9Lg878++uOqW0H7D/PUW80rd/aFHkQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-z8WAwKYXN_uBztRJRtQyaQ-1; Thu, 03 Sep 2020 06:38:25 -0400
X-MC-Unique: z8WAwKYXN_uBztRJRtQyaQ-1
Received: by mail-wm1-f71.google.com with SMTP id q7so815557wmc.6
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2020 03:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=4HNAySK8FeEMG1/hgM9m0kdfMGWgz5OyaEAu6PaQYRc=;
        b=RIeKn8XsBEhBO7l4oY2IzaymAsDwsQmOvEQHGIRZjNv5QQYPQwlf9mEhL4wJoherKF
         qTw4EKO5olLzNEOBgemxmOyaEbJQTnYAQPHv6TBB1S7Tssb/96KOtiHXzNLowj0cWjik
         QXouaxv3NSxt5gP01ieBwr4LQklRGPKD0GYgPq0gw3mJa5JyLoMpuCYO97y2BP/ZsLlV
         UiNAMJ6HiAGKu01IPhtH3YvLFKoSLYbV/iMYWnrui8BM04jXEAdP9G157uKSeMzb0Dl6
         q604KWdizyz5t/hfLM6pP+Y23O9T44BLwvIlAstYJmtYYiS+3yOwCZ+pUKm+7YaONKsi
         YZJA==
X-Gm-Message-State: AOAM530GKx4uInIIbwgCT+D4d2OZ8aXIxftHwZA40Yb47bg+RrkhkNOT
        EDKS7JqMzWaghBXQa+7c99WC8cUhW0tGv6EylCbJR6t+vVXusmQNTAnKTfUyiaFjdgBWmw8wpR3
        sE0ES01/LZj5mX9LkaChA
X-Received: by 2002:a05:600c:410e:: with SMTP id j14mr1901604wmi.13.1599129504387;
        Thu, 03 Sep 2020 03:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzm0Odx/Vu2OafbW7Vco5kDqX5lk7w70iixkOj40FbroDjdfbERUscD79EevlBnJ14gZJJYIg==
X-Received: by 2002:a05:600c:410e:: with SMTP id j14mr1901584wmi.13.1599129504172;
        Thu, 03 Sep 2020 03:38:24 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id q192sm4070251wme.13.2020.09.03.03.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 03:38:23 -0700 (PDT)
Date:   Thu, 3 Sep 2020 12:38:21 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200903103821.wt75v7p2mzuauzca@eorzea>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
References: <20200902144059.284726-1-cmaiolino@redhat.com>
 <20200902144059.284726-5-cmaiolino@redhat.com>
 <20200903091436.GD10584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903091436.GD10584@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 10:14:36AM +0100, Christoph Hellwig wrote:
> > +/* total space in use */
> > +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
> > +	struct xfs_attr_shortform *sf =
> > +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> > +	return be16_to_cpu(sf->hdr.totsize);
> > +}
> 
> The opening curly brace should go on a line of its own.
> 

Thanks for spotting this, I'll fix on the next version
> > +/* space name/value uses */
> > +static inline int xfs_attr_sf_entsize_byname(uint8_t nlen, uint8_t vlen) {
> > +	return sizeof(struct xfs_attr_sf_entry) + nlen + vlen;
> > +}
> > +
> > +/* space an entry uses */
> > +static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep) {
> > +	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
> > +}
> > +
> > +/* next entry in struct */
> > +static inline struct xfs_attr_sf_entry *
> > +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep) {
> > +	return (struct xfs_attr_sf_entry *)((char *)(sfep) +
> > +					    xfs_attr_sf_entsize(sfep));
> > +}
> 
> Same for these.  Also if you cast to void * instead of char * in
> xfs_attr_sf_nextentry (and gcc extension we make heavy use of), you
> don't need the case back.

I believe you meant cast here? For sure, looks a good simplification, I'll add
it. Thanks again!


-- 
Carlos

