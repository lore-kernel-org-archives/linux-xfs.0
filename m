Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE292C433E1
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 07:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96F31206C3
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 07:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hrLw30Pj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgFCH6q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 03:58:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47673 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726120AbgFCH6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 03:58:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591171122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LFhF9EeMzwFrPIjEyJ6kWuDjj1Jy4QiMagkG3VLJv54=;
        b=hrLw30PjPJGM0AouhH6TQj5ysgGv9lxUdPhvK/pEfLAMWf56w0wHtRHPLZgaObmdm7lUqD
        Tg75xkMRSM58dAI/R/DYc8DQyie5o9sgiR50SQcg4sc/XoYal4il4N36LbVZF5K4ouNzgs
        kqXA9MDRko/gjxWt9Jibbrqe6JxkCxg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-QgxpF7dtOHO1_w09rvbMPg-1; Wed, 03 Jun 2020 03:58:41 -0400
X-MC-Unique: QgxpF7dtOHO1_w09rvbMPg-1
Received: by mail-wr1-f70.google.com with SMTP id e1so770473wrm.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jun 2020 00:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LFhF9EeMzwFrPIjEyJ6kWuDjj1Jy4QiMagkG3VLJv54=;
        b=nDwMZrENe6cm3OpgtWlJ+BTmwgNfIMrcgcKxbtBwHVGfovnKx6iTUhawnqkVYyUGRt
         BWD3QMHtHNe0gTx8nM43zxE706OxKvVjlz2Xa9NZeuXx4mF75Ley/vgxhO3vFFIMveyb
         54aJgDL7NKjINxmn01DLaK747niJ0hsJd2CZOyWR1xvV+6ePTDEGQScA0mhDn0nx0gyl
         q6Z+eX0v02BxA1EXeN89+LfvkXHR9KzzswYtayqLpDOUaUplWj45kO+34RtE9ktOcMVe
         GVd4sLDhfyg1yXxIm0jthxlwjKzPaNxy5gQuKDCxG5nZ9eV+94ErySva3VANJ/8TCVZl
         8s7A==
X-Gm-Message-State: AOAM5332B9plfm3AryAht9z9/mqC1IQQHxbCpcei52WZ/jBVCBvrauyy
        EFPREnv6/aQ+pWyqDkGaSaNhPklwnk+hhuJwKbWtBqJ97HpWHi2+e3s6z/JZjOzCLoABpsu0e/o
        buH/UoVtvJ1YsAFxRTomf
X-Received: by 2002:a5d:608d:: with SMTP id w13mr29463338wrt.298.1591171119653;
        Wed, 03 Jun 2020 00:58:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRfGJSd1b0W59jsmlLd3byCAosExmZF+6b1DZS6lWKr+Avq3S+nbP2lkiYg5DZjxd9XZ5wIQ==
X-Received: by 2002:a5d:608d:: with SMTP id w13mr29461529wrt.298.1591171089489;
        Wed, 03 Jun 2020 00:58:09 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id d18sm2077583wrn.34.2020.06.03.00.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 00:58:08 -0700 (PDT)
Date:   Wed, 3 Jun 2020 09:58:06 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Bypass sb alignment checks when custom values
 are used
Message-ID: <20200603075806.wloczwn6tus37vli@eorzea>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20200601140153.200864-1-cmaiolino@redhat.com>
 <20200601140153.200864-3-cmaiolino@redhat.com>
 <20200601212115.GC2040@dread.disaster.area>
 <20200602091844.nsi63ixzm6zgxy76@eorzea>
 <20200602231235.GJ2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602231235.GJ2040@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 09:12:35AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2020 at 11:18:44AM +0200, Carlos Maiolino wrote:
> > Hi Dave.
> > 
> > On Tue, Jun 02, 2020 at 07:21:15AM +1000, Dave Chinner wrote:
> > > On Mon, Jun 01, 2020 at 04:01:53PM +0200, Carlos Maiolino wrote:
> > > > index 4df87546bd40..72dae95a5e4a 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -360,19 +360,27 @@ xfs_validate_sb_common(
> > > >  		}
> > > >  	}
> > > >  
> > > > -	if (sbp->sb_unit) {
> > > > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > > > -		    sbp->sb_unit > sbp->sb_width ||
> > > > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > > > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > > > +	/*
> > > > +	 * Ignore superblock alignment checks if sunit/swidth mount options
> > > > +	 * were used or alignment turned off.
> > > > +	 * The custom alignment validation will happen later on xfs_mountfs()
> > > > +	 */
> > > > +	if (!(mp->m_flags & XFS_MOUNT_ALIGN) &&
> > > > +	    !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > > 
> > > mp->m_dalign tells us at this point if a user specified sunit as a
> > > mount option.  That's how xfs_fc_validate_params() determines the user
> > > specified a custom sunit, so there is no need for a new mount flag
> > > here to indicate that mp->m_dalign was set by the user....
> > 
> > At a first glance, I thought about it too, but, there is nothing preventing an
> > user to mount a filesystem passing sunit=0,swidth=0. So, this means we can't
> > really rely on the m_dalign/m_swidth values to check an user passed in (or not)
> > alignment values. Unless we first deny users to pass 0 values into it.
> 
> Sure we can. We do this sort of "was the mount option set" detection
> with m_logbufs and m_logbsize by initialising them to -1. Hence if
> they are set by mount options, they'll have a valid, in-range value
> instead of "-1".

Funny thing is I thought about "let's initialize to -1" and gave up because it
seemed ugly :)

> 
> That said, if you want users passing in sunit=0,swidth=0 to
> correctly override existing on-disk values (i.e. effectively mean -o
> noalign), then you are going to need to modify
> xfs_update_alignment() and xfs_validate_new_dalign() to handle
> mp->m_dalign == 0 as a valid value instead of "sunit/swidth mount
> option not set, use existing superblock values".....
> 
> IOWs, there are deeper changes needed here than just setting a new
> flag to say "mount option was set" for it to function correctly and
> consistently as you intend. This is why I think we should just fix
> this situation automatically, and not require the user to manually
> override the bad values.

Sure, I'm not opposed to fix things automatically, I just thought it wasn't an
acceptable solution, but looks like I'm wrong.

> 
> Thinking bigger picture, I'd like to see the mount options
> deprecated and new xfs_admin options added to change the values on a
> live, mounted filesystem.
I haven't been following this development. So, you meant geometry mount options
or mount options as a whole?

> That way users who have issues like this
> don't need to unmount the filesystem to fix it,

Sure, but it doesn't fix those filesystems which were already unmounted. But,
fixing it automatically during mount seem to cover this part.

cheers.

-- 
Carlos

