Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE95C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 09:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55622206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 09:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A19td1ai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgFBJSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 05:18:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33733 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726139AbgFBJSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 05:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591089529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HE4Y+UGpUJazwLFJiWEC2YNlm0xekuok79hR3ezheDY=;
        b=A19td1ai4h/rpxaU4oPScSul/ymaoAG7v3DT+oplcjCoYswdZZMWgX2BqtnHDR4JEwioSI
        z4qsaMDobLRAX4d7J0zIzCG+ccWwnOeUD+Xv8+C1ZsPN30jip8NOMdnw7DsN4Uf3LJ4fd+
        cVFPoAVHhxkZvF/bkbG8LFnHL96rLPg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-5Lh9xdvVPTq290nJGiLkAg-1; Tue, 02 Jun 2020 05:18:48 -0400
X-MC-Unique: 5Lh9xdvVPTq290nJGiLkAg-1
Received: by mail-wm1-f72.google.com with SMTP id h25so698496wmb.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jun 2020 02:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=HE4Y+UGpUJazwLFJiWEC2YNlm0xekuok79hR3ezheDY=;
        b=jS7yP9Effw5wtL6H3ZoKViyYvMzi0BPq/1aT6c07e112doZsSQi4rLId0ubPSxJrhW
         cqNQugJusK4nBhsf0CPLQvnVaWrB4UYu1obw5N9baLfS719CaxzuVlkOvxTRwsKW08oi
         PGzmIm+QSAK2YWeqnYXZrWaILrDz1NyIwGig3y4BA7Y+CQyALWMDzbmR+T0TlSVKazJ7
         t/RdZi0kt5A8bsXtMLb/tfUyG05TwtuSbGoLgHDh9N43OExYLrwcK3c791XsGGiz/rJM
         S8+CRUCBfVY9drQ+qHW1DdbmbGoSmSORYqSjDSQPBkmVSg3cjzDuUoMdmH6yD6sRorSR
         YomA==
X-Gm-Message-State: AOAM532n0+xsYQw/+w3MfR3RTWVq0m8a035MolnQc/p7dHxc59XN0gZo
        7NUz3UfhbE37w1FsKS7sKjNBnMZQv1kg8aj9DfggKxHGRJ2CduKnZZ6nnUkAOE+aWSLCpsiubv3
        4ca2uvvYWOQWb1blmh+An
X-Received: by 2002:a7b:c761:: with SMTP id x1mr3445874wmk.90.1591089527023;
        Tue, 02 Jun 2020 02:18:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoRyRqP60hSt+oOSFlahnB/s3EGJnHtFFqW3gZJJZjmgnZ65rYxT85sTpsTQpDeRmpKAEwSQ==
X-Received: by 2002:a7b:c761:: with SMTP id x1mr3445850wmk.90.1591089526671;
        Tue, 02 Jun 2020 02:18:46 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id q128sm2717698wma.38.2020.06.02.02.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 02:18:45 -0700 (PDT)
Date:   Tue, 2 Jun 2020 11:18:44 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Bypass sb alignment checks when custom values
 are used
Message-ID: <20200602091844.nsi63ixzm6zgxy76@eorzea>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20200601140153.200864-1-cmaiolino@redhat.com>
 <20200601140153.200864-3-cmaiolino@redhat.com>
 <20200601212115.GC2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601212115.GC2040@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave.

On Tue, Jun 02, 2020 at 07:21:15AM +1000, Dave Chinner wrote:
> On Mon, Jun 01, 2020 at 04:01:53PM +0200, Carlos Maiolino wrote:
> > index 4df87546bd40..72dae95a5e4a 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -360,19 +360,27 @@ xfs_validate_sb_common(
> >  		}
> >  	}
> >  
> > -	if (sbp->sb_unit) {
> > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > -		    sbp->sb_unit > sbp->sb_width ||
> > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > +	/*
> > +	 * Ignore superblock alignment checks if sunit/swidth mount options
> > +	 * were used or alignment turned off.
> > +	 * The custom alignment validation will happen later on xfs_mountfs()
> > +	 */
> > +	if (!(mp->m_flags & XFS_MOUNT_ALIGN) &&
> > +	    !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> 
> mp->m_dalign tells us at this point if a user specified sunit as a
> mount option.  That's how xfs_fc_validate_params() determines the user
> specified a custom sunit, so there is no need for a new mount flag
> here to indicate that mp->m_dalign was set by the user....

At a first glance, I thought about it too, but, there is nothing preventing an
user to mount a filesystem passing sunit=0,swidth=0. So, this means we can't
really rely on the m_dalign/m_swidth values to check an user passed in (or not)
alignment values. Unless we first deny users to pass 0 values into it.

> 
> Also, I think if the user specifies "NOALIGN" then we should still
> check the sunit/swidth and issue a warning that they are
> bad/invalid, or at least indicate in some way that the superblock is
> unhealthy and needs attention. Using mount options to sweep issues
> that need fixing under the carpet is less than ideal...
> 
> Also, I see nothing that turns off XFS_MOUNT_ALIGN when the custom
> alignment is written to the superblock and becomes the new on-disk
> values. Once we have those values in the in-core superblock, the
> write of the superblock should run the verifier to validate them.
> i.e. leaving this XFS_MOUNT_ALIGN set allows fields of the
> superblock we just modified to be written to disk without verifier
> validation.

I didn't think about it, thanks for the heads up.

> 
> From that last perspective, I _really_ don't like the idea of
> having user controlled conditional validation like this in the
> common verifier.
> 
> From a user perspective, I think this "use mount options to override
> bad values" approach is really nasty. How do you fix a system that
> won't boot because the root filesystem has bad sunit/swidth values?
> Telling the data center admin that they have to go boot every
> machine in their data center into a rescue distro after an automated
> upgrade triggered widespread boot failures is really not very user
> or admin friendly.
> 
> IMO, this bad sunit/swidth condition should be:
> 
> 	a) detected automatically at mount time,
> 	b) corrected automatically at mount time, and
> 	c) always verified to be valid at superblock write time.
> 
> IOWs, instead of failing to mount because sunit/swidth is invalid,
> we issue a warning and automatically correct it to something valid.
> There is precedence for this - we've done it with the AGFL free list
> format screwups and for journal structures that are different shapes
> on different platforms.

Eh, that was one of the options I considered, and also pointed by Eric when we
talked about it previously. At the end, I thought automatically modifying it
under the hoods was too invasive in regards of changing geometry configuration
without user interaction. Foolish me :P

> 
> Hence we need to move this verification out of the common sb
> verifier and move it into the write verifier (i.e. write is always
> verified).  Then in the mount path where we set user specified mount
> options, we should extent that to validate the existing on-disk
> values and then modify them if they are invalid. Rules for fixing
> are simple:
> 
> 	1. if !hasdalign(sb), set both sunit/swidth to zero.
> 	2. If sunit is zero, zero swidth.
> 	1. If swidth is not valid, round it up it to the nearest
> 	   integer multiple of sunit.
> 
> The user was not responsible for this mess (combination of missing
> validation in XFS code and bad storage firmware providing garbage)
> so we should not put them on the hook for fixing it. We can do it
> easily and without needing user intervention and so that's what we
> should do.
> 

Thanks for the insights, I'll work on that direction.

Cheers

-- 
Carlos

