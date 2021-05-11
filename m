Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FF4C43460
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4793561622
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhEKCEU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 22:04:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230398AbhEKCET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 22:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620698593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BB6AI7LxTkGduZ9KSz41ZOkSC6UJmvZiWABS80gkoc4=;
        b=U3mBkjuC8hojWcaMasNz9ykMNwTtYnmOCl0PQruYf/1uDi9NyE7MrdCL6MvEz0gtGJ2Y+/
        CAtKoy0g1/iuqo2k12SyrkOBp8skdSnIOXPx32f3s434TvpNe/AsEI6NGngJ2UVAeMtQ7g
        z05rOL3Ebn7/91HpeTPm2Qg8obhK0c4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-sOk2DykANIS7PMy3biwK8A-1; Mon, 10 May 2021 22:03:11 -0400
X-MC-Unique: sOk2DykANIS7PMy3biwK8A-1
Received: by mail-pl1-f199.google.com with SMTP id u14-20020a170903304eb02900ec9757f3dbso6800583pla.17
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 19:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BB6AI7LxTkGduZ9KSz41ZOkSC6UJmvZiWABS80gkoc4=;
        b=mrU7lMjmLUa47SGrRz8BRQRwParSdLCVb9gECLIheUQDEepPrNz/vzhw0nrh3Vea+M
         fgGvKaxdqLM/QePTwnV2Iq7WGi0fUfnT1s/ptRJa5njmz5OJwLL7nHVkkiq58olw2W4H
         tmnOs/kraOGbTJKKmGdipicYlGC2OmsvtHLHeI5getjVJiZX1qFKEPbNcXvhF3qZ9G8/
         w+4wOTtqRibPF3O6brnuIT7pzL8Ddd/WrMROMVR9m9yX643mUMtOA7aKNdYzY3h1w9X/
         YIpAXdr6cEod8x1QRoA5Yj2J6EZZkAuii4mYEJ/hu9Hk8STV0c2ch81zWRr3SepgC6ga
         k27g==
X-Gm-Message-State: AOAM533j6HgjfgQssGnDN6wXBVmfONWiRaa5VPa4HfP53IzylLNbf/Hf
        avbkiLXIEQ14I1gTPrSY36ofoMcPpU1+qLCAgmTBwzohfVsnbUHZCVI8i8zYJCeXl+H1L7RpiEO
        WnwPf7F6p5G4KD98nIM/L
X-Received: by 2002:a05:6a00:87:b029:28d:f62f:a749 with SMTP id c7-20020a056a000087b029028df62fa749mr28059545pfj.54.1620698589834;
        Mon, 10 May 2021 19:03:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuivukfDMohdQTPnByN7s7gDTalpHb9o5kxY1oysDueAqVQ4rUdr3Ch3QETfFONjpv4uxWIA==
X-Received: by 2002:a05:6a00:87:b029:28d:f62f:a749 with SMTP id c7-20020a056a000087b029028df62fa749mr28059522pfj.54.1620698589401;
        Mon, 10 May 2021 19:03:09 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x13sm5488462pjl.22.2021.05.10.19.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:03:09 -0700 (PDT)
Date:   Tue, 11 May 2021 10:02:48 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v4 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Message-ID: <20210511020248.GC741809@xiangao.remote.csb>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
 <20210402094937.4072606-2-hsiangkao@redhat.com>
 <20210510175952.GA8558@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210510175952.GA8558@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 10, 2021 at 10:59:52AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 02, 2021 at 05:49:35PM +0800, Gao Xiang wrote:
> > In order to detect whether the current kernel supports XFS shrinking.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  common/xfs | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 69f76d6e..c6c2e3f5 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -766,6 +766,20 @@ _require_xfs_mkfs_without_validation()
> >  	fi
> >  }
> >  
> > +_require_xfs_scratch_shrink()
> > +{
> > +	_require_scratch
> > +	_require_command "$XFS_GROWFS_PROG" xfs_growfs
> > +
> > +	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > +	. $tmp.mkfs
> > +	_scratch_mount
> > +	# here just to check if kernel supports, no need do more extra work
> > +	$XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" > /dev/null 2>&1 || \
> > +		_notrun "kernel does not support shrinking"
> 
> I think isn't sufficiently precise -- if xfs_growfs (userspace) doesn't
> support shrinking it'll error out with "data size XXX too small", and if
> the kernel doesn't support shrink, it'll return EINVAL.

I'm not sure if we need to identify such 2 cases (xfsprogs doesn't support
and/or kernel doesn't support), but if it's really needed I think I could
update it. But I've confirmed with testing that both two cases can be
handled with the statements above properly.

> 
> As written, this code attempts a single-block shrink and disables the
> entire test if that fails for any reason, even if that reason is that
> the last block in the filesystem isn't free, or we ran out of memory, or
> something like that.

hmm... the filesystem here is brandly new, I think at least it'd be
considered as "the last block in the new filesystem is free". If we're
worried that such promise could be broken, I think some other golden
output is unstable as well (although unrelated to this.) By that time,
I think the test script should be updated then instead. Or am I missing
something?

If we're worried about runing out of memory, I think the whole xfstests
could not be predictable. I'm not sure if we need to handle such case.

> 
> I think this needs to check the output of xfs_growfs to make the
> decision to _notrun.

I could check some golden output such as "data size XXX too small", yet
I still don't think we should check some cases e.g. run out of memory..

Thanks,
Gao Xiang

> 
> --D
> 
> > +	_scratch_unmount
> > +}
> > +
> >  # XFS ability to change UUIDs on V5/CRC filesystems
> >  #
> >  _require_meta_uuid()
> > -- 
> > 2.27.0
> > 
> 

