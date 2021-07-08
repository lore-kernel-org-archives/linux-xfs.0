Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73511C07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54878619C6
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhGHHTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 03:19:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhGHHTQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jul 2021 03:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625728594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hvQB9kpoumxvAIvss+61RFzsG9CobXlO98wmvfcf7yo=;
        b=RqkyY87lYtKxHxJNN5SV9iRm/4ffcvLxC2DoJ2HU1yazVhLREib5YbbYFiuDVo139uWchR
        +MJjbSo1SEVFKYD+xainT+/Yi2fTHzW9tsOMFzKDIbbr9yfiD5duAc7G+TkOc7jfVKXHNn
        gLdP4HnzkQ2uDDSTnTD2+tCU46eBER8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-COkChk87OKeACUtYXgs8NQ-1; Thu, 08 Jul 2021 03:16:33 -0400
X-MC-Unique: COkChk87OKeACUtYXgs8NQ-1
Received: by mail-ed1-f71.google.com with SMTP id f20-20020a0564020054b0290395573bbc17so2781117edu.19
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jul 2021 00:16:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=hvQB9kpoumxvAIvss+61RFzsG9CobXlO98wmvfcf7yo=;
        b=tUHV5ZakA/EPxl7ocbstrl68gFw3igbWWPujcvuxNbNWwYeL70IrozH/qJvYhOblOe
         3gAi5ErdekfNfSKdhjXx1zjkERkyWsC3EmV9kNdI8yT+kzGkXC8CBjtR2qELYTTNPz9y
         ZpUqNDKFs2S/2zi2y+zXT9PPYRwvpoYxIKaUQhC0EjKFriX1V8sD1kgPpjB1gupBNFzp
         yJXjAA354atTzN3uWR04Q0FZznHTjpYg87eDb9qy3Cjkonqxe7BoO17FGS72Bvh83nlh
         KXkg7Slco+hJCmlbK3hTrpYY6ZacOTan4Jh2ioXiUTUSvt0ORtaJKYPraIbFbA19Bmir
         UjMw==
X-Gm-Message-State: AOAM530MTxlT+2AKMT289i3FZogKNAHc8sGVVpqkcF1tWFPz5jpbcwEZ
        ZDsH415roaL8Yx62VIOPG6A+SOupCrgbdDwlG1V7h4qj6uBlyXiyti7699uPEy/2DVJ81vqhman
        zQeS1L9NW0ZkXheHuKSY4
X-Received: by 2002:a05:6402:90d:: with SMTP id g13mr16630200edz.47.1625728279060;
        Thu, 08 Jul 2021 00:11:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjkKknm6AUSkggFuSFcBosasP85PHGFbIinpxDluIMNh04HOMoGbxX3w40iDvNVtkn3chQWw==
X-Received: by 2002:a05:6402:90d:: with SMTP id g13mr16630175edz.47.1625728278872;
        Thu, 08 Jul 2021 00:11:18 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id jy6sm467205ejc.21.2021.07.08.00.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 00:11:18 -0700 (PDT)
Date:   Thu, 8 Jul 2021 09:11:16 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/2] xfs_repair: validate alignment of inherited rt
 extent hints
Message-ID: <20210708071116.njicib4zsxkdny3k@omega.lan>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
References: <162528106460.36302.18265535074182102487.stgit@locust>
 <162528107024.36302.9037961042426880362.stgit@locust>
 <YOF2n+aIKG/cqhyX@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOF2n+aIKG/cqhyX@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 04, 2021 at 09:51:43AM +0100, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 07:57:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we encounter a directory that has been configured to pass on an
> > extent size hint to a new realtime file and the hint isn't an integer
> > multiple of the rt extent size, we should turn off the hint because that
> > is a misconfiguration.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  repair/dinode.c |   28 +++++++++++++++++++++++++++-
> >  1 file changed, 27 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/repair/dinode.c b/repair/dinode.c
> > index 291c5807..1275c90b 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -2178,6 +2178,31 @@ _("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
> >  		*dirty = 1;
> >  	}
> >  }
> > +/*
> > + * Inode verifiers on older kernels don't check that the extent size hint is an
> > + * integer multiple of the rt extent size on a directory with both rtinherit
> > + * and extszinherit flags set.  If we encounter a directory that is
> > + * misconfigured in this way, or a regular file that inherited a bad hint from
> > + * a directory, clear the hint.
> > + */
> > +static bool
> > +zap_bad_rt_extsize_hint(
> 
> The name suggests this function does the zapping itself, while it
> actually leaves that to the caller.

+1 here, I also led me to believe this was actually zeroing the extsize, but the
patch's logic is fine.

Maybe something like

{is,has}_bad_rt_extsize_hint()?

> 
> Oterwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
Carlos

