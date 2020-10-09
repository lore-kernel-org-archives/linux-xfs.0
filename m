Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68657C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 13:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0265E222C3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 13:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbn/FQca"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbgJINvD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 09:51:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732456AbgJINvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 09:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602251462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sC9XgxigjqCfR++5uYtloEmUEB0wfUmZJyX91e953w0=;
        b=dbn/FQcazSspY30bdMQENXahovW4dEDhRUpXfNDRVH+rNXx5C3JvJHZtv3A9D02F2yD36g
        6ibVYmkxkF/CAhQR6kGHIalwinS5XlOPv7xfh6vcZ7cKkDJ45Wr15GGD2HnajwqGlZ22Bl
        0hTuQkndP7KmkAY7sLJGSU18peSU+A4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-J69AXmRkNjOBE8B3KcUK8w-1; Fri, 09 Oct 2020 09:50:59 -0400
X-MC-Unique: J69AXmRkNjOBE8B3KcUK8w-1
Received: by mail-pf1-f199.google.com with SMTP id y7so6746034pff.20
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 06:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sC9XgxigjqCfR++5uYtloEmUEB0wfUmZJyX91e953w0=;
        b=aLEnKMyMyBs0JZtdlacu9kLdy8aWuu77j3eX+QTFOqLjTS4zkQHgQUXQPAKlXtIRoo
         XtwVY1LycSfIlfo0pRooGzFYR8Ss/J9umTzr4GIVbVEUekyC5evBtuL5dS+6ZZIelk9P
         uyi/86gM7T2bWSROZQiQd2Ywa9zDv7YuqfxNYBlIOXCRESg31xk5X8LHU6ei3+D8OzfI
         3NWubIukNozYJTAiGPJg85YhaVCDC4jC4F8L/1DEVDH6vS/j2oQ0BS7ETy7XPuJYIVeb
         /e7M9Tqn55i9Dno0vBabBame4xUki/k1uFQh99rVvsY68vlIKMvfmfPzswUD53LBoaJ6
         BdZw==
X-Gm-Message-State: AOAM530a9JEV/o5nR9MtTAidH07h8ASUOvoas8V5NxOEyMj6FvD2UInf
        XQFYVMOOUW7+cH650h4NfABroJQHyl998tViXfFanDwwoaKnG7snZ0M15dij2Vino6BlQb730nR
        SUB5zG3wIy0tMmAfJRJpQ
X-Received: by 2002:a17:90a:c90d:: with SMTP id v13mr3582316pjt.166.1602251458337;
        Fri, 09 Oct 2020 06:50:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrysGrt5RwBkz9mCQvt9bEHxstkQJ5NzQP1dbira0Bwyrl+S4R7HEuA08UGdMJqQFJzAAr/g==
X-Received: by 2002:a17:90a:c90d:: with SMTP id v13mr3582289pjt.166.1602251458055;
        Fri, 09 Oct 2020 06:50:58 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm4456047pfj.114.2020.10.09.06.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 06:50:57 -0700 (PDT)
Date:   Fri, 9 Oct 2020 21:50:47 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@aol.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 3/3] xfsprogs: make use of
 xfs_validate_stripe_factors()
Message-ID: <20201009135047.GA8068@xiangao.remote.csb>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-4-hsiangkao@aol.com>
 <20201007223044.GI6540@magnolia>
 <20201009005847.GB10631@xiangao.remote.csb>
 <b00455fd-a017-8daf-2b15-d3062f0d6bef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b00455fd-a017-8daf-2b15-d3062f0d6bef@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 08:02:02AM -0500, Eric Sandeen wrote:
> On 10/8/20 7:58 PM, Gao Xiang wrote:
> >> Unless we get rid of the weird libxfs macro thing, you're supposed to
> >> use prefixes in userspace.
> > I vaguely remembered Christoph sent out a patch intending to get
> > rid of xfsprogs libxfs_ prefix months ago, so I assumed there was
> > no need to introduce any new libxfs_ userspace API wrappers anymore.
> 
> He did, and it's on my (perpetual) TODO list to get that finally reviewed,
> sorry.
> 
> For now we still have libxfs*

Yeah, I've sent out the next version with libxfs_ prefix at
https://lore.kernel.org/r/20201009052421.3328-4-hsiangkao@redhat.com

Thanks for the information as well!

Thanks,
Gao Xiang

> 
> -Eric
> 
> > But yeah, will add such libxfs_ marco wrapper in the next version.
> > 
> > Thanks,
> > Gao Xiang
> > 
> 

