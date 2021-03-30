Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284FCC433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 22:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EC26192C
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 22:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhC3WxU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:53:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232825AbhC3WxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 18:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617144793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MRNrolOJwD/v/zNS15RLDzPb5yLWFNB3r1ARcSZ4nM8=;
        b=Ezo/mwU6AACdTgrevkj+M9WDQdei1YvZWHHjZNbyTOr0AWTbtQyTdpNc64TUvVJMl0ZOt6
        Ae8a2FJJ5P8ryBSaUex3amCEGvlfP/xF652/pBZpt1yBHlDgCBFG+BN6Lj0y8mGYmUqWES
        KSy7aesUYIsq5qIsYq/3AaFFn552Gr4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-hPsDR46VPEuFgLtGrSHPJA-1; Tue, 30 Mar 2021 18:53:09 -0400
X-MC-Unique: hPsDR46VPEuFgLtGrSHPJA-1
Received: by mail-pf1-f198.google.com with SMTP id g6so201792pfc.14
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 15:53:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MRNrolOJwD/v/zNS15RLDzPb5yLWFNB3r1ARcSZ4nM8=;
        b=nd0MvOHEeiKiMxL69sHQgKREYq0WSq+5TySzgNwEznlY2z36Nzm3m7hxZGeUORBTNN
         2rGnw6z/bRszZZSEYxQxgqnQL2ijOnmU5Q1lFqNRprUyEYDn7H50r1kypdyJ+nlJfMhw
         Ru9WrDNu9H19Knu8mVT9eudR2y4ZhR6d80DMNQ8fR+bMwL6dig1x1EZkUs5S71m5hSq3
         DS/SpFq4lAV1AOtMgs0xGzpONT82JaUn4Rveq0mCrgdBlAfqeIUM4Hi4WIrTHfswgFBW
         svVsw1NEUhRCJfJ+MNIvlRaNwphgH1AFZMM2+S3J5S4XKgmE0uHF2TfpN6k5bqCYutYT
         0EYw==
X-Gm-Message-State: AOAM533mwJECUQzvDEaKuSHZWlkxaX+wfc9FcKsVymdGtE/yMJAdr6O2
        9QUaAXVpESt9pFvT6iJKNwa5ttJUYM+LyaLgaIPWBaB11hi18r72/NH9PRBMS/P/7DNwdAJL/Ey
        d2rcWsMVmvk9WExGXo5fH
X-Received: by 2002:a17:902:dac4:b029:e6:b39f:7ee2 with SMTP id q4-20020a170902dac4b02900e6b39f7ee2mr282691plx.85.1617144788462;
        Tue, 30 Mar 2021 15:53:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ6ZIyipBhECpq5VHa59kcT00kV67TiXxB5UVsmjl/XfywiPZiwR2aAbqjLdlRn86XcVR7ng==
X-Received: by 2002:a17:902:dac4:b029:e6:b39f:7ee2 with SMTP id q4-20020a170902dac4b02900e6b39f7ee2mr282675plx.85.1617144788185;
        Tue, 30 Mar 2021 15:53:08 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gw20sm161763pjb.3.2021.03.30.15.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 15:53:07 -0700 (PDT)
Date:   Wed, 31 Mar 2021 06:52:57 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Gao Xiang <hsiangkao@aol.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3 3/8] repair: Protect bad inode list with mutex
Message-ID: <20210330225257.GA3589611@xiangao.remote.csb>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-4-hsiangkao@aol.com>
 <20210330222642.GW63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210330222642.GW63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 09:26:42AM +1100, Dave Chinner wrote:
> On Tue, Mar 30, 2021 at 10:25:26PM +0800, Gao Xiang wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To enable phase 6 parallelisation, we need to protect the bad inode
> > list from concurrent modification and/or access. Wrap it with a
> > mutex and clean up the nasty typedefs.
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  repair/dir2.c | 19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/repair/dir2.c b/repair/dir2.c
> > index b6a8a5c40ae4..c1d262fb1207 100644
> > --- a/repair/dir2.c
> > +++ b/repair/dir2.c
> > @@ -26,6 +26,7 @@ struct dir2_bad {
> >  };
> >  
> >  static struct dir2_bad	dir2_bad;
> > +pthread_mutex_t		dir2_bad_lock = PTHREAD_MUTEX_INITIALIZER;
> >  
> >  static void
> >  dir2_add_badlist(
> > @@ -33,6 +34,7 @@ dir2_add_badlist(
> >  {
> >  	xfs_ino_t	*itab;
> >  
> > +	pthread_mutex_lock(&dir2_bad_lock);
> >  	itab = realloc(dir2_bad.itab, (dir2_bad.nr + 1) * sizeof(xfs_ino_t));
> >  	if (!ino) {
> >  		do_error(
> > @@ -42,18 +44,25 @@ _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
> >  	}
> >  	itab[dir2_bad.nr++] = ino;
> >  	dir2_bad.itab = itab;
> > +	pthread_mutex_unlock(&dir2_bad_lock);
> 
> Putting a global mutex around a memory allocation like this will
> really hurt concurrency. This turns the add operation into a very
> complex operation instead of the critical section being just a few
> instructions long.
> 
> The existing linked list code is far more efficient in this case
> because the allocation of the structure tracking the bad inode is
> done outside the global lock, and only the list_add() operation is
> done within the critical section.

I agree with your conclusion here and actually realized the problem
at that time.

> 
> Again, an AVL or radix tree can do the tracking structure allocation
> outside the add operation, and with an AVL tree there are no
> allocations needed to do the insert operation. A radix tree will
> amortise the allocations its needs over many inserts that don't need
> allocation. However, I'd be tending towards using an AVL tree here
> over a radix tree because bad inodes will be sparse and that's the
> worst case for radix tree indexing w.r.t to requiring allocation
> during insert...

Yeah, I saw some AVL infrastructure, yet AVL needs amortise insert/lookup
O(logn). Anyway, let me try use ACL instead and do some profile.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

