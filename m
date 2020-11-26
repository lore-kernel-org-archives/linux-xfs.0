Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3BFC56201
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 02:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568052075A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 02:16:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGUp94DQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733008AbgKZCQi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 21:16:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732639AbgKZCQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 21:16:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606356996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uguMoFH+kwrpviQ3187PbbsfntNX+68NnH8KwBZPA9I=;
        b=MGUp94DQl5p4fJg9jo2MPmFvXKLrOO2TvnaVwRP/MlJvQuQGfg101KwixepHqPqVklPkHs
        iF83sRPC7fLGdzeswAwFwu4UDn/Ics8aUcstYaLG+uvDdpYe6UpTq9tL9SJVm2BC9QXkUH
        vPmAhBCqt9+7AWXfXU9asdBa7AJ11zI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-Eo7FKZKrNDKWPnwTmdX5-A-1; Wed, 25 Nov 2020 21:16:34 -0500
X-MC-Unique: Eo7FKZKrNDKWPnwTmdX5-A-1
Received: by mail-pg1-f197.google.com with SMTP id z24so386193pgu.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 18:16:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=uguMoFH+kwrpviQ3187PbbsfntNX+68NnH8KwBZPA9I=;
        b=VzlV/16ALkbNDdzogK6mgiYFz980+s/J7z+Oy5On/uqt/+O6jOiKu9Tgjz9IGkkU/J
         O5FsizCh3W40dw8fy0ZFk2/8Vz650qgQTpvF8wwha/TMQ/yXvpMUrxJZ9M41oEblxbQj
         EfbnLPb+cZCjRINmRlFdJ4feQo7SBFP8q+CHceNnKC5xY7j+BLBLR04zXK1AsaLzcvoW
         57ttkyXCrlI2nSmtqlciamR8oUQ3ChVbreUInM2AkCnRTzDav3pVQiGg80eZqHpTpOLL
         aB/tcu6FcPkFqh7ocAc52OEoH+65pF+rWxD1xxnGBlvE+MwG/fkAGkPvnwMjPrGnD6pu
         sMag==
X-Gm-Message-State: AOAM533Ll0MZc9e9glTynbxVVBgiHhcth8MejmLbCws4qv01UNIis3U1
        vxCHZz0E+ENHKSvIiASrRPBIEg1z7yt442yu0qhmkBzYGkRAi3EpM8Gkk1pGhRzF1HBOrr1Nko2
        PEQxXyh0migDWXKiky39S
X-Received: by 2002:a17:902:7b97:b029:d8:e703:1367 with SMTP id w23-20020a1709027b97b02900d8e7031367mr833158pll.11.1606356993749;
        Wed, 25 Nov 2020 18:16:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydbRTPpfQsca2Y0ykPJnWRG71ByeeDLMhrwRxCG8U5AVyaDPoyx8LTPPoGCHqXbNyjpmuzqQ==
X-Received: by 2002:a17:902:7b97:b029:d8:e703:1367 with SMTP id w23-20020a1709027b97b02900d8e7031367mr833143pll.11.1606356993480;
        Wed, 25 Nov 2020 18:16:33 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y25sm3004714pfn.44.2020.11.25.18.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 18:16:33 -0800 (PST)
Date:   Thu, 26 Nov 2020 10:16:22 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: check the return value of krealloc() in
 xfs_uuid_mount
Message-ID: <20201126021622.GA336866@xiangao.remote.csb>
References: <20201125065036.154312-1-miaoqinglang@huawei.com>
 <365b952c-7fea-3bc2-55ea-3f6b1c9f9142@sandeen.net>
 <9f998a9d-0684-6b45-009e-acf2e0ac4c85@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f998a9d-0684-6b45-009e-acf2e0ac4c85@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Qinglang,

On Thu, Nov 26, 2020 at 09:21:11AM +0800, Qinglang Miao wrote:
> 
> 
> 在 2020/11/25 23:55, Eric Sandeen 写道:
> > On 11/25/20 12:50 AM, Qinglang Miao wrote:
> > > krealloc() may fail to expand the memory space.
> > 
> > Even with __GFP_NOFAIL?
> > 
> >    * ``GFP_KERNEL | __GFP_NOFAIL`` - overrides the default allocator behavior
> >      and all allocation requests will loop endlessly until they succeed.
> >      This might be really dangerous especially for larger orders.
> > 
> > > Add sanity checks to it,
> > > and WARN() if that really happened.
> > 
> > As aside, there is no WARN added in this patch for a memory failure.
> > 
> > > Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
> > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> > > ---
> > >   fs/xfs/xfs_mount.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 150ee5cb8..c07f48c32 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -80,9 +80,13 @@ xfs_uuid_mount(
> > >   	}
> > >   	if (hole < 0) {
> > > -		xfs_uuid_table = krealloc(xfs_uuid_table,
> > > +		uuid_t *if_xfs_uuid_table;
> > > +		if_xfs_uuid_table = krealloc(xfs_uuid_table,
> > >   			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
> > >   			GFP_KERNEL | __GFP_NOFAIL);
> > > +		if (!if_xfs_uuid_table)
> > > +			goto out_duplicate;
> > 
> > And this would emit "Filesystem has duplicate UUID" which is not correct.
> > 
> > But anyway, the __GFP_NOFAIL in the call makes this all moot AFAICT.
> > 
> > -Eric
> Hi Eric,
> 
> Sorry for neglecting __GFP_NOFAIL symbol, and I would add a WARN in memory
> failure next time.

Sorry about my limited knowledge, but why it needs a WARN here since
I think it will never fail if __GFP_NOFAIL is added (no ?).

I'm not sure if Hulk CI is completely broken or not on this, also if
such CI can now generate trivial patch (?) since the subject, commit
message and even the variable name is quite similiar to
https://lore.kernel.org/linux-xfs/20201124104531.561-2-thunder.leizhen@huawei.com
in a day.

And it'd be better to look into the code before sending patches...

Thanks,
Gao Xiang

> 
> Thanks for your advice！
> 

