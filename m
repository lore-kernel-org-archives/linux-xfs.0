Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C916C433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6948961A13
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239355AbhCYAoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239203AbhCYAo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 20:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616633065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Drd0FJRdZHDWQs2z+vg3u0w5fBp7KZouTW8TVRZOy7Y=;
        b=N7csgkHbU0z5YQSTJkmW8hogEksmto9h8cMZ7C/1hiaR9Oi0UZsJFboCwyPPCs2dpW3a8u
        aGQB2n7NEmFNwhcHTjcDM5rJOhVG6DDsFY9hMAc9aOhoWpU1faGjm8JC3bv8t5V3W6wUCA
        wJXWWLJcqWxDEaKYxZPrvdoZbBg8I/o=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-swO94hcRNJCgXjIRFOopGQ-1; Wed, 24 Mar 2021 20:44:24 -0400
X-MC-Unique: swO94hcRNJCgXjIRFOopGQ-1
Received: by mail-pg1-f198.google.com with SMTP id j26so2566700pgj.19
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 17:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Drd0FJRdZHDWQs2z+vg3u0w5fBp7KZouTW8TVRZOy7Y=;
        b=KQTeXAmQsTVBxAYG8gufRM+QwWffxunU0MwN5kbdbn8YkMRGw0lH/FSwSrHXsuohD7
         DMPAvZLCDIGS6guZ70ZJOgQD0QNrvevXswXr1aS/l/ujlxc7Vjf8IFWG7X89arkcbRLJ
         FijK4ToAxgnFje5D+y44pNZE4+C6eAXSzsPEjcdXsUY+xEhB1vKyjfPc5e+f9a5nqoCj
         oYSZOoY9xH+q1sTx/IETcb3uennU4nSV1pk9eX9rdI9sVAE4n79y9RwU5LHPBpKX4gwO
         UREnOORpFP3fLcevWhvXF9YVDXCaxCcJTO/9Zna+VSpHD0pPbIlVKCg/ooobW+tBEU3B
         hzsQ==
X-Gm-Message-State: AOAM5333wI/jpG4vIKWstYpjTTY3hZkaOwfTY2/x1w7ppeM6IzVsCp3+
        AH8033djWs0B4kzzWiJbEyAfQQoIb3lOdQ+vFaDSv+5x7KEFkF9r0+5e29ftP46peICwkKR0Yh5
        ZHVw9K49o+dTbmP2CRrTj
X-Received: by 2002:a65:6208:: with SMTP id d8mr5099439pgv.365.1616633063072;
        Wed, 24 Mar 2021 17:44:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXOm8bLbG3VAJiHmFaydeJUWwK39aTUBsVfzsnLWWuCArAWpahUJaSxzUYbCteerIuIVXncg==
X-Received: by 2002:a65:6208:: with SMTP id d8mr5099422pgv.365.1616633062718;
        Wed, 24 Mar 2021 17:44:22 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2sm3547721pfb.121.2021.03.24.17.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 17:44:22 -0700 (PDT)
Date:   Thu, 25 Mar 2021 08:44:13 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [WIP] [RFC PATCH] xfs_growfs: allow shrinking unused space in
 the last AG
Message-ID: <20210325004413.GA2421109@xiangao.remote.csb>
References: <20201028114010.545331-1-hsiangkao@redhat.com>
 <20210324173215.GU22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324173215.GU22100@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 10:32:15AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 28, 2020 at 07:40:10PM +0800, Gao Xiang wrote:
> > This allows shrinking operation can pass into kernel.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > preliminary version.
> 
> ...which is going to need a manpage update:
> 
> "-d | -D size
> 
> "Specifies that the data section of the filesystem should be resized. If
> the -D size option is given, the data section is changed to that size,
> otherwise the data section is grown to the largest size possible with
> the -d option. The size is expressed in filesystem blocks.  A filesystem
> with only 1 AG cannot be shrunk further, and a filesystem cannot be
> shrunk to the point where it would only have 1 AG."

Ah, ok, will update this. thanks for pointing out.

Thanks,
Gao Xiang

> 
> --D
> 
> > 
> >  growfs/xfs_growfs.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> > index a68b515d..d45ba703 100644
> > --- a/growfs/xfs_growfs.c
> > +++ b/growfs/xfs_growfs.c
> > @@ -246,12 +246,11 @@ main(int argc, char **argv)
> >  			error = 1;
> >  		}
> >  
> > -		if (!error && dsize < geo.datablocks) {
> > -			fprintf(stderr, _("data size %lld too small,"
> > -				" old size is %lld\n"),
> > +		if (!error && dsize < geo.datablocks)
> > +			fprintf(stderr,
> > +_("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
> >  				(long long)dsize, (long long)geo.datablocks);
> > -			error = 1;
> > -		} else if (!error &&
> > +		if (!error &&
> >  			   dsize == geo.datablocks && maxpct == geo.imaxpct) {
> >  			if (dflag)
> >  				fprintf(stderr, _(
> > -- 
> > 2.18.1
> > 
> 

