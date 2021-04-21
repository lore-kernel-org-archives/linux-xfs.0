Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920E3C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 16:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627166144A
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 16:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhDUQg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 12:36:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234887AbhDUQg5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 12:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619022983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j4Q8MZ1IGNzIXI0KZpe4qbdLLnAqBptPOFdwNXaZ4Mg=;
        b=RJSg4DHiON2uoOk7w7AsD5BZV/CblbAlnV2clsi8qw0TVEC1S1FdjO8PYU9fvzi1WiYSor
        0YHXIomXNuOEiJua0n5nxIWThqDW2x2G3SOaIN1xB4QqaaPry/av3EsJOkFEluKaPPkLBg
        hYAC0KTjUznRTYv8YsWr86GM8oVuGpM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-4FTvIOoPNrqwUg1v2ZudZA-1; Wed, 21 Apr 2021 12:36:21 -0400
X-MC-Unique: 4FTvIOoPNrqwUg1v2ZudZA-1
Received: by mail-pf1-f197.google.com with SMTP id f19-20020a056a0022d3b02902608c8a75e0so5736618pfj.13
        for <linux-xfs@vger.kernel.org>; Wed, 21 Apr 2021 09:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j4Q8MZ1IGNzIXI0KZpe4qbdLLnAqBptPOFdwNXaZ4Mg=;
        b=VrvDVmgMGLuuIJApg3/bnFPqVzPiZv7VGhpuubdYgLfZjFp5Tm37cIf6rYqldjREPq
         gr4icZpUqRAmSDAL8vIoBcc4NdSxxj4A2t/w2uqnyIoiLJNKWZfUXdezCeLbdU0v5xOf
         CxBHFjn68t102U+VdaT8TS5Cl4QEReW9jLrigJVzrJ6v2lqS8MDtG+mpT7hcaTf+GJLA
         GArm4Yb0LaHfJi7aPKt6RpjYyw52Vn2qWSXDHIk+iLwkpVYBchAt1p8QhFcFluPzH+gi
         qsS02UMrWZ8iYGU59DuBI53/6Hlpp1BcBo0wX4cnEadCO2/BO0GqsB7mG7P3H61NQJ8Q
         GpvA==
X-Gm-Message-State: AOAM53297RWqpyiv4VNkOK4m5f8fFev+8R8IiEVtlSNWSR/wIlY3+LsD
        3vTmvzM9+fJQ+T2WoCQi7y3Nmr9mIM0LwntJ4BN2t3abY2dEas6VhXioBVaHgUxFurAwm46L0u+
        nyZjBC78+Uu9TQQI4Djyw
X-Received: by 2002:a17:90a:f402:: with SMTP id ch2mr12176054pjb.171.1619022980960;
        Wed, 21 Apr 2021 09:36:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx976QRNYZFH9McSw7jCWzT+WXgdLBbff+yJnOMHy/pf5q31uGAn9Qr36aQq3qbPnhwZrXtg==
X-Received: by 2002:a17:90a:f402:: with SMTP id ch2mr12176024pjb.171.1619022980670;
        Wed, 21 Apr 2021 09:36:20 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o62sm2135935pfg.79.2021.04.21.09.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:36:20 -0700 (PDT)
Date:   Thu, 22 Apr 2021 00:36:10 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] mkfs: warn out the V4 format
Message-ID: <20210421163610.GA3189421@xiangao.remote.csb>
References: <20210421085716.3144357-1-hsiangkao@redhat.com>
 <20210421155514.GS3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210421155514.GS3122264@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Apr 21, 2021 at 08:55:14AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 21, 2021 at 04:57:16PM +0800, Gao Xiang wrote:
> > Kernel commit b96cb835e37c ("xfs: deprecate the V4 format") started
> > the process of retiring the old format to close off attack surfaces
> > and to encourage users to migrate onto V5.
> > 
> > This also prints warning to users when mkfs as well.
> > 
> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Looks fine to me; but does this cause any golden output failures in
> fstests?

ok, I will check mkfs_filter later.

(btw, just in case... would you mind reply the message below:
 https://lore.kernel.org/r/20210420200029.GA3028214@xiangao.remote.csb
 so I could refine the series and send out the next version later?

 Also I still have no idea how to handle [PATCH v2 1/2], since
 I'd like just add some comments here to explain why sb_ifree,
 sb_icount doesn't matter and such logic can be (and will be)
 totally removed after [PATCH v2 2/2] in short time. )

Thanks,
Gao Xiang

> 
> --D
> 
> > ---
> >  mkfs/xfs_mkfs.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 0eac5336..ef09f8b3 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -4022,6 +4022,10 @@ main(
> >  	validate_extsize_hint(mp, &cli);
> >  	validate_cowextsize_hint(mp, &cli);
> >  
> > +	if (!cli.sb_feat.crcs_enabled)
> > +		fprintf(stderr,
> > +_("Deprecated V4 format (-mcrc=0) will not be supported after September 2030.\n"));
> > +
> >  	/* Print the intended geometry of the fs. */
> >  	if (!quiet || dry_run) {
> >  		struct xfs_fsop_geom	geo;
> > -- 
> > 2.27.0
> > 
> 

