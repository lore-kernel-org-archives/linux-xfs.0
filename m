Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D7CC433C1
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 19:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E77961920
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 19:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhC1TwD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:52:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhC1Tvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Mar 2021 15:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616961099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HRkAEwUZiWNcfM4p41i7DUasLa0+aHNq1oDfUZcdnMg=;
        b=TaHPQnDz/GDxvLWVBY77Ww2CCx0WDcCZdLx+9M/7TCAhVTTp6nQHCUMoC4+pTkn6BB/JTC
        5UqbNkD9j/7/kaT8npVW35LT4JdfcY+VGvcUmm/vMbvL0nQo9ziNs3KvHKY/9MZD42vmwR
        o5wKZnRghcfTqJk4av5z9Z24iqVUqbc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-qQKcpFW5PLCyI-rdkmB7bw-1; Sun, 28 Mar 2021 15:51:37 -0400
X-MC-Unique: qQKcpFW5PLCyI-rdkmB7bw-1
Received: by mail-pj1-f70.google.com with SMTP id e15so9705823pjg.6
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 12:51:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HRkAEwUZiWNcfM4p41i7DUasLa0+aHNq1oDfUZcdnMg=;
        b=B5POVbACkRlx0p4fjpnZqTGDFir9gNii+UKUwsDAO9a8QeFws14nIUC+FX2MJ/WRVo
         FcoOcTwFInEaT/EpUnB5HjQnVnKNAFl7dbJMgalIBeUQtn8tCM3Ed+O8CrZ8ivoUHAAY
         Ph5F8O5ujwIOCuxFIwAJzwWnNeP+QDtjMOYxoi7a2m0Fu64P7wuPIF2HbN25gRIQ5G1e
         e0uRMaAhrtxsKfM+Vr5HnP5qq3ZIqpcr/QoApaGI47m20gNbDUmbu5zH/xJQUcGj8EAy
         fLPpEkIJvsP9ZckFqb4/HHtsrOTBNPD1FcmraGEAMb+Nc9UbVvZXArMoT5SNFH7MRidS
         9viQ==
X-Gm-Message-State: AOAM531Hs0LoikNU4lUWoDOzydtqi1oNK7QaZJfYa408d3n8+ee6ronk
        luOSVk4/8Y9Tm6itg/AmmoBAmIU/Pq2eNA6cFfnaiF4uvTzqFHtvF2qaeLPScd3C2UNVuCAzCuF
        k83IOW22V3Y3iFL2HOu1u
X-Received: by 2002:a17:902:c389:b029:e7:1029:8ba5 with SMTP id g9-20020a170902c389b02900e710298ba5mr24812752plg.55.1616961096118;
        Sun, 28 Mar 2021 12:51:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIB3Sd/MgDSmXIdYj9RWphjzMzNSWtXvuYtyrVkKHipBMhuMTo+7QhCDVjUCwhECR4HrLKaQ==
X-Received: by 2002:a17:902:c389:b029:e7:1029:8ba5 with SMTP id g9-20020a170902c389b02900e710298ba5mr24812735plg.55.1616961095917;
        Sun, 28 Mar 2021 12:51:35 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 6sm15110383pfv.179.2021.03.28.12.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 12:51:35 -0700 (PDT)
Date:   Mon, 29 Mar 2021 03:51:24 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eryu Guan <guan@eryu.me>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [RFC PATCH v3 1/3] common/xfs: add a _require_xfs_shrink helper
Message-ID: <20210328195124.GA3213575@xiangao.remote.csb>
References: <20210315111926.837170-1-hsiangkao@redhat.com>
 <20210315111926.837170-2-hsiangkao@redhat.com>
 <YGCsUXMF+uupaHNV@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGCsUXMF+uupaHNV@desktop>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 12:18:25AM +0800, Eryu Guan wrote:
> On Mon, Mar 15, 2021 at 07:19:24PM +0800, Gao Xiang wrote:
> > In order to detect whether the current kernel supports XFS shrinking.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  common/xfs | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 2156749d..ea3b6cab 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -432,6 +432,17 @@ _supports_xfs_scrub()
> >  	return 0
> >  }
> >  
> > +_require_xfs_shrink()
> > +{
> > +	_require_scratch
> 
> _require_command "$XFS_GROWFS_PROG" xfs_growfs

will update.

> 
> > +
> > +	_scratch_mkfs_xfs > /dev/null
> > +	_scratch_mount
> > +	$XFS_GROWFS_PROG -D1 "$SCRATCH_MNT" 2>&1 | grep -q 'Invalid argument' || \
> > +		_notrun "kernel does not support shrinking"
> 
> Better to describe the behavior here to explain why EINVAL means kernel
> supports shrink.

hmmm.. I also don't think this check is correct now. Maybe try to shrink
one fs-block would be better. Will update later.

Thanks,
Gao Xiang

> 
> Thanks,
> Eryu
> 
> > +	_scratch_unmount
> > +}
> > +
> >  # run xfs_check and friends on a FS.
> >  _check_xfs_filesystem()
> >  {
> > -- 
> > 2.27.0
> 

