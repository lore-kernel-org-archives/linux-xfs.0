Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1FDC47095
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 08:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D2761040
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 08:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhFII5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 04:57:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231556AbhFII5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jun 2021 04:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623228911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dYhoUJnb5xNwCAKC9O2r5jEUZgiOxpcY0IIBMxg1Nnc=;
        b=LSIS4Y1e2wqYvPwOSQ4gxQjQdSCh1ERRRw71pWSpD2OzsFIzEcngG/8Y4SMpQ9IjYY41Ol
        91SxXmjePiktlxd9hNvfhxUMddip8SBhPWC10tEJQe9kcxnpSld6k4LEavyvYc8Quvm5/u
        6ovYFbNmEqb9ENo9hz5uD8BgktiuxmI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-D6pes6wNNf-QjbCYHNyjyA-1; Wed, 09 Jun 2021 04:55:09 -0400
X-MC-Unique: D6pes6wNNf-QjbCYHNyjyA-1
Received: by mail-wm1-f70.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso1691594wmj.0
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jun 2021 01:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=dYhoUJnb5xNwCAKC9O2r5jEUZgiOxpcY0IIBMxg1Nnc=;
        b=e20v2/Xef/PkNtFqgS0yslK5pwBg6VxAWkmKzonpLbYwBVi82rtQX4wwwIvAFcbeIB
         G/EFMHDSuCO8uAMrhaw2MiwB/EevKbhYAvXH5XaoLWsOkPWcRIRnG+M5KNq+9KQuihBD
         NR8EkeHWztJnY0YtYIhvmjVh38gHiEu5+gJ5PCVc1byoU+tPxNzk8DSOy7glIyzoK45p
         ZlnmBJcB9Px9DUBLVmPYuXias7Ta+QCO2zk/h36tQXbK05g1keEbQMis5Wxg1dYhXzu8
         BlnbC9uvjaortSOuZ1GT/jf4UF/mh9bxl2cc8IBkvGiPxJsX80YFPidl6Ez/rYiC4Xw5
         5rbw==
X-Gm-Message-State: AOAM530XXPGfyJlTo0/NsnkhX2SexpQoq+xx03Zx/2voIFUsgXh/NWh5
        zL1Kju0+2EqgVNfZTLazGwYV/ocQDTe0HkSeWPi+SKJSSUnEeQ2qaqzEOYyl7R6kf/eAM1kk7G8
        hOQ3gtIgiS3L5ogfqDxy8
X-Received: by 2002:a05:600c:3b13:: with SMTP id m19mr26515531wms.53.1623228908160;
        Wed, 09 Jun 2021 01:55:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYgI/XfySDjKIsefu65ibfoWRglyB6ITFmRqWEG2Q7lWT21J0V9FZCj2J29y0NdNYVNqPuWg==
X-Received: by 2002:a05:600c:3b13:: with SMTP id m19mr26515499wms.53.1623228907813;
        Wed, 09 Jun 2021 01:55:07 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id g186sm14622613wme.6.2021.06.09.01.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 01:55:07 -0700 (PDT)
Date:   Wed, 9 Jun 2021 10:55:05 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <20210609085505.j2isfiydym7aabqz@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
References: <162300204472.1202529.17352653046483745148.stgit@locust>
 <162300205695.1202529.8468586379242468573.stgit@locust>
 <20210608145948.b25ejxdfbm33uz42@omega.lan>
 <20210608152146.GR2945738@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608152146.GR2945738@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 08:21:46AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 08, 2021 at 04:59:48PM +0200, Carlos Maiolino wrote:
> > Hi,
> > 
> > On Sun, Jun 06, 2021 at 10:54:17AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > When we decide to mark an inode sick, clear the DONTCACHE flag so that
> > > the incore inode will be kept around until memory pressure forces it out
> > > of memory.  This increases the chances that the sick status will be
> > > caught by someone compiling a health report later on.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > The patch looks ok, so you can add:
> > 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> > 
> > Now, I have a probably dumb question about this.
> > 
> > by removing the I_DONTCACHE flag, as you said, we are increasing the chances
> > that the sick status will be caught, so, in either case, it seems not reliable.
> > So, my dumb question is, is there reason having these inodes around will benefit
> > us somehow? I haven't read the whole code, but I assume, it can be used as a
> > fast path while scrubbing the FS?
> 
> Two answers to your question: In the short term, preserving the incore
> inode means that a subsequent reporting run (xfs_spaceman -c 'health')
> is more likely to pick up the sickness report.
> 
> In the longer term, I intend to re-enable reclamation of sick inodes
> by aggregating the per-inode sick bit in the per-AG health status so
> that reporting won't be interrupted by memory demand:
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting
> 
> (I haven't rebased that part in quite a while though.)

Thanks!

> 
> --D
> 
> > 
> > Cheers.
> > 
> > > ---
> > >  fs/xfs/xfs_health.c |    9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > > index 8e0cb05a7142..806be8a93ea3 100644
> > > --- a/fs/xfs/xfs_health.c
> > > +++ b/fs/xfs/xfs_health.c
> > > @@ -231,6 +231,15 @@ xfs_inode_mark_sick(
> > >  	ip->i_sick |= mask;
> > >  	ip->i_checked |= mask;
> > >  	spin_unlock(&ip->i_flags_lock);
> > > +
> > > +	/*
> > > +	 * Keep this inode around so we don't lose the sickness report.  Scrub
> > > +	 * grabs inodes with DONTCACHE assuming that most inode are ok, which
> > > +	 * is not the case here.
> > > +	 */
> > > +	spin_lock(&VFS_I(ip)->i_lock);
> > > +	VFS_I(ip)->i_state &= ~I_DONTCACHE;
> > > +	spin_unlock(&VFS_I(ip)->i_lock);
> > >  }
> > >  
> > >  /* Mark parts of an inode healed. */
> > > 
> > 
> > -- 
> > Carlos
> > 
> 

-- 
Carlos

