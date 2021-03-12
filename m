Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0D8C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 15:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6620964FFB
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 15:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhCLPTE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 10:19:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231371AbhCLPTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 10:19:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615562341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kj5oZXuHyIi9m87E0ij1hZzPU5DAiQfu0GrgV/1bu9c=;
        b=Z76k4U1ShT34+Wg4Tf8M5owzbUdYjXsCP28TY3kfoCgEk9L9tXDOp2HcwBCNFUAZLhLsd7
        j11EOZo9Nfkl5BTxdExu3u6t4XfOPwSOFolt2jCgMB8RP2RqgYgUU3WpIat5Y2Ai74C7+6
        pPPOmWespVzmhnYz+JqvXsGkdyQHV3w=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-29VAPtfuO2Cece0exwk9HQ-1; Fri, 12 Mar 2021 10:18:59 -0500
X-MC-Unique: 29VAPtfuO2Cece0exwk9HQ-1
Received: by mail-pj1-f69.google.com with SMTP id l17so8738099pjt.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Mar 2021 07:18:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kj5oZXuHyIi9m87E0ij1hZzPU5DAiQfu0GrgV/1bu9c=;
        b=KgeTrvdMyH658gzIWUStIJvJKv2bu5oCBIm/gcyC/4qJgxHor6Od2vJ96CQohTP27F
         4EN5c/lKRBsWNbk7qFlBgVBeQxZaPi1V07mTlBL1W6wRY9v/8AldnRkmmuZlfp6muc6N
         F9uDsk0fqdrCPvac4F7Pfd1UKXtvEubIbbCueX4bxW2qx4eQMGdc6KakgJLQ9gBmpHd5
         o1mJaTaClsXIf9dULy2vSnBep/aCNzc3VZBIMaLqh3rWI1flC1w2tey59+Inm8IfIOlY
         WvLLnbDKCdsYruv6X2KzOmyPnijtvF3BkWBmRmQZhi0zzperCMkzeJpTHPF1c1UDBTBe
         jQzQ==
X-Gm-Message-State: AOAM533HHW7cGTks/xUdbE40uXdYree0xGn/sWv9amTUz5QbiMzzCAKo
        F9xc9sb4fDirupjIXoMYwMyo9GTuF7TOCwX0JcqECRgjyttN6WN54P8bqxahuh/z1q0XG4Kqnc3
        brF2HpO2mtAxA1c7qcDNH
X-Received: by 2002:a17:902:f54e:b029:e6:3d74:eb3 with SMTP id h14-20020a170902f54eb02900e63d740eb3mr14103587plf.14.1615562338426;
        Fri, 12 Mar 2021 07:18:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3n9I34vyt1jzguAtbcB3/knsxjW0ZZZLt89JdGbaE382I+7QB5zAfEwACXuQ5V0tLG7CojA==
X-Received: by 2002:a17:902:f54e:b029:e6:3d74:eb3 with SMTP id h14-20020a170902f54eb02900e63d740eb3mr14103566plf.14.1615562338183;
        Fri, 12 Mar 2021 07:18:58 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d22sm2598884pjx.24.2021.03.12.07.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:18:57 -0800 (PST)
Date:   Fri, 12 Mar 2021 23:18:47 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/3] common/xfs: add a _require_xfs_shrink helper
Message-ID: <20210312151847.GA272122@xiangao.remote.csb>
References: <20210312132300.259226-1-hsiangkao@redhat.com>
 <20210312132300.259226-2-hsiangkao@redhat.com>
 <20210312152506.GJ3499219@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210312152506.GJ3499219@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorro,

On Fri, Mar 12, 2021 at 11:25:06PM +0800, Zorro Lang wrote:
> On Fri, Mar 12, 2021 at 09:22:58PM +0800, Gao Xiang wrote:
> > In order to detect whether the current kernel supports XFS shrinking.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > use -D1 rather than -D0 since xfs_growfs would report unchanged size
> > instead.
> > 
> >  common/xfs | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 2156749d..326edacc 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -432,6 +432,16 @@ _supports_xfs_scrub()
> >  	return 0
> >  }
> >  
> > +_require_xfs_shrink()
> > +{
> > +	_scratch_mkfs_xfs >/dev/null 2>&1
> > +
> > +	_scratch_mount
> > +	$XFS_GROWFS_PROG -D1 "$SCRATCH_MNT" 2>&1 | grep -q 'Invalid argument' || { \
> > +		_scratch_unmount; _notrun "kernel does not support shrinking"; }
> 	        ^^^^
> 		I think this unmount isn't necessary, due to after "_notrun" the
> 		$SCRATCH_DEV will be umounted "automatically".

I didn't dig into it more. Just follow _require_xfs_scratch_rmapbt().

If it's not necessary (assumed ./check does that), will update it in
the next version. Thanks for your suggestion.

Thanks,
Gao Xiang

