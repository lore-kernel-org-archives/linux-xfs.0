Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2645C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 07:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC7B6139A
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 07:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhGIHoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:44:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhGIHoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 03:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625816500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6DR4yTtcwRwpazxeKBXfiR1UdFqy7iFYDk0DxNqHEpE=;
        b=Bj59NRQ8mH8RlWAPsFquH77Fjj8FJqVk/4GEg4NvIWguz65QoQ4wTOdMNV5fo3ud0i3vzO
        hJSDXZRXDJTcz/M5pX6zZ5+lflxoD25kIQXu5Wo31vHwJeMmkkoUKB0dGzB6f29mIblgSq
        a0/SxSt55nEAjhvy4rDmMh2F4oPp9bo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-v0PttGR0MiOPLuhN7eUCqA-1; Fri, 09 Jul 2021 03:41:37 -0400
X-MC-Unique: v0PttGR0MiOPLuhN7eUCqA-1
Received: by mail-ej1-f70.google.com with SMTP id d2-20020a1709072722b02904c99c7e6ddfso2750339ejl.15
        for <linux-xfs@vger.kernel.org>; Fri, 09 Jul 2021 00:41:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=6DR4yTtcwRwpazxeKBXfiR1UdFqy7iFYDk0DxNqHEpE=;
        b=JJgVDZj3lj5TEHuUXwPMdpzfzGfsfolHx/Ekfa8YoJBOilFSo0FXfzQDOC+fXeXI6P
         lllZXf9GtfhHh/h3GBOlStVgUJv6e6Vl/lnNtjI+uCOzqHW7x4x512s9sNpxEVaVf44X
         jnidJlEBo2c2fbKYDRQr0MOcmFfzbudorsV1bCpQS9qw470PXMZvoyUsyB/xjrqLpkpQ
         dtVMTrNPkpiQmzj/MOVLB2LnH0H/d//97fQExUwqGaaUBn1L9sOTTlkeYwTfY7sQBxPu
         GSCSueq5ei1v5XNJ63o3395EmYvRxUJZKwzAUreUj6ShS9OOKA3J+fSu/Sp93AmvIE8G
         wiZA==
X-Gm-Message-State: AOAM533LhkMs5xnSlJB9ZfC0tfSJ/VI+JDL7hC9mtEY5h8WCbCpR7zPp
        kZH3MdWb2SA/frAS/bfRZX118Izv5vXehezhHKDnFmEb/spyRSTJegR9PK5i6fR1+qDqe3Z+C8X
        UxTkjBhwzR9lYjD4oeLde
X-Received: by 2002:aa7:c952:: with SMTP id h18mr43009790edt.18.1625816496391;
        Fri, 09 Jul 2021 00:41:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmRLsr1Mn+V6wRdImZfm0lhAkSleiFT1ZdPQ/ZEMr0KPl0YWglVX+RNNdaG+epTibvBcKlOA==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr43009763edt.18.1625816496170;
        Fri, 09 Jul 2021 00:41:36 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id jx1sm1914451ejc.101.2021.07.09.00.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 00:41:35 -0700 (PDT)
Date:   Fri, 9 Jul 2021 09:41:33 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/2] xfs_repair: validate alignment of inherited rt
 extent hints
Message-ID: <20210709074133.eqplu474pucatihr@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
References: <162528106460.36302.18265535074182102487.stgit@locust>
 <162528107024.36302.9037961042426880362.stgit@locust>
 <YOF2n+aIKG/cqhyX@infradead.org>
 <20210708071116.njicib4zsxkdny3k@omega.lan>
 <20210708223157.GJ11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708223157.GJ11588@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 03:31:57PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 08, 2021 at 09:11:16AM +0200, Carlos Maiolino wrote:
> > On Sun, Jul 04, 2021 at 09:51:43AM +0100, Christoph Hellwig wrote:
> > > On Fri, Jul 02, 2021 at 07:57:50PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > If we encounter a directory that has been configured to pass on an
> > > > extent size hint to a new realtime file and the hint isn't an integer
> > > > multiple of the rt extent size, we should turn off the hint because that
> > > > is a misconfiguration.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  repair/dinode.c |   28 +++++++++++++++++++++++++++-
> > > >  1 file changed, 27 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/repair/dinode.c b/repair/dinode.c
> > > > index 291c5807..1275c90b 100644
> > > > --- a/repair/dinode.c
> > > > +++ b/repair/dinode.c
> > > > @@ -2178,6 +2178,31 @@ _("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
> > > >  		*dirty = 1;
> > > >  	}
> > > >  }
> > > > +/*
> > > > + * Inode verifiers on older kernels don't check that the extent size hint is an
> > > > + * integer multiple of the rt extent size on a directory with both rtinherit
> > > > + * and extszinherit flags set.  If we encounter a directory that is
> > > > + * misconfigured in this way, or a regular file that inherited a bad hint from
> > > > + * a directory, clear the hint.
> > > > + */
> > > > +static bool
> > > > +zap_bad_rt_extsize_hint(
> > > 
> > > The name suggests this function does the zapping itself, while it
> > > actually leaves that to the caller.
> > 
> > +1 here, I also led me to believe this was actually zeroing the extsize, but the
> > patch's logic is fine.
> > 
> > Maybe something like
> > 
> > {is,has}_bad_rt_extsize_hint()?
> 
> Renamed to is_misaligned_extsize_hint().

Great, thanks Darrick!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --D
> 
> > 
> > > 
> > > Oterwise looks good:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > 
> > -- 
> > Carlos
> > 
> 

-- 
Carlos

