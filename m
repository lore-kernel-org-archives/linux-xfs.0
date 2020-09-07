Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621BEC433E2
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 11:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27EB5207C3
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 11:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S6H7M9T6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgIGLdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 07:33:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42515 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729086AbgIGLdL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 07:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599478390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dc6vQVoQVIP3ZXwwfJ+jTCDMQKiarIgOjjhXM/a9n0c=;
        b=S6H7M9T6LDOUkZlMDCbXHlbV2JlHqz9YaQ4/sQKXk1qFIAYbrlW1VlzAbbE5La+Asf6NQl
        2aPlAuFzusR/0FUAsLw2lftUlUUMs8GhQwfxnqzAFKUZ8PKaTlcJOXoPs27GbmAoYuzeHH
        0j0WQn/kSrivmrzPdFuct7YtC03wXgg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-aKb93d9QOkKE8-x-zG4O8w-1; Mon, 07 Sep 2020 07:33:08 -0400
X-MC-Unique: aKb93d9QOkKE8-x-zG4O8w-1
Received: by mail-ej1-f71.google.com with SMTP id md9so5150834ejb.8
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 04:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Dc6vQVoQVIP3ZXwwfJ+jTCDMQKiarIgOjjhXM/a9n0c=;
        b=pCmfTxIdBsFfix/b6n5AAUeUDei9lxCF1tWBjcis9O4rIvdVD6cDse1//vL+H4VH+l
         fjCdovI5Pi0MGAB+ZIJSEWYTv1p4U7exjWjlm8vOQ/V6xmm1dsFiNfV91W5tpGh1vobf
         8GGBROCm14w7fte1KHLYJgTLpSFx4keWGJ7FcS2kAZjfzalIRuq/t51nmV6ztN5IK9RS
         HPaHSGSVnQB2u0KqjevlFp2hBBAyi9yjQD+LiQO9m00phv1XBSKo7GR+d/ZqYDqU7x4F
         KZrRT8xw49Lgplueqf+2tAdsgcGuEem1fZ1eXFZDososQNlp5ba+v9sw9vIeP0ZeAPFR
         GRAg==
X-Gm-Message-State: AOAM531yjXQazTTNEdDQbc9naI+pKwsUqReqw7lWgM5tRA/ZcAsvP1Ap
        0gJ/0XYX6txPYaFhumRwwfG9Pw/1psqEhrq35KvkrdfZDKj9XLD4twP1TH8vD9AFU90Uhj/MUFU
        hrmsY7JKzcoAS0wcatwPu
X-Received: by 2002:aa7:c61a:: with SMTP id h26mr20610857edq.254.1599478386743;
        Mon, 07 Sep 2020 04:33:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdDX3eoxPw7BrmxBCRdIDXpHewb3DsiztfVSsGo8AcwyKYOLr6Sh/+J5blVdmriLk3l9FRwA==
X-Received: by 2002:aa7:c61a:: with SMTP id h26mr20610848edq.254.1599478386586;
        Mon, 07 Sep 2020 04:33:06 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id b13sm2120867edf.89.2020.09.07.04.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 04:33:05 -0700 (PDT)
Date:   Mon, 7 Sep 2020 13:33:03 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200907113303.hzrziwj3lfzgrpon@eorzea>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20200903161724.85328-1-cmaiolino@redhat.com>
 <20200903161859.85511-1-cmaiolino@redhat.com>
 <20200906220011.GN12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906220011.GN12131@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> >  
> > +/* total space in use */
> 
> Comment is redundant.
> 
> > +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
> > +{
> > +	struct xfs_attr_shortform *sf =
> > +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> > +
> > +	return be16_to_cpu(sf->hdr.totsize);
> > +}
> 
> If you have to break the declaration line like that, you
> may as well just do:
> 
> +	struct xfs_attr_shortform *sf;
> +
> +	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> +	return be16_to_cpu(sf->hdr.totsize);
> 
> 
> Otherwise the patch looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Fair enough, I'll re-send this patch, thanks for the review guys.


> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Carlos

