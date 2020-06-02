Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A35C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 23:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9043C2068D
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 23:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgFBXMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 19:12:45 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:42958 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728012AbgFBXMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 19:12:45 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8F526D78660
        for <linux-xfs@vger.kernel.org>; Wed,  3 Jun 2020 09:12:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgG5D-00019H-3o
        for linux-xfs@vger.kernel.org; Wed, 03 Jun 2020 09:12:35 +1000
Date:   Wed, 3 Jun 2020 09:12:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Bypass sb alignment checks when custom values
 are used
Message-ID: <20200602231235.GJ2040@dread.disaster.area>
References: <20200601140153.200864-1-cmaiolino@redhat.com>
 <20200601140153.200864-3-cmaiolino@redhat.com>
 <20200601212115.GC2040@dread.disaster.area>
 <20200602091844.nsi63ixzm6zgxy76@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602091844.nsi63ixzm6zgxy76@eorzea>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=pqTjJ6TGZNTBi7Q8GE4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 11:18:44AM +0200, Carlos Maiolino wrote:
> Hi Dave.
> 
> On Tue, Jun 02, 2020 at 07:21:15AM +1000, Dave Chinner wrote:
> > On Mon, Jun 01, 2020 at 04:01:53PM +0200, Carlos Maiolino wrote:
> > > index 4df87546bd40..72dae95a5e4a 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -360,19 +360,27 @@ xfs_validate_sb_common(
> > >  		}
> > >  	}
> > >  
> > > -	if (sbp->sb_unit) {
> > > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > > -		    sbp->sb_unit > sbp->sb_width ||
> > > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > > +	/*
> > > +	 * Ignore superblock alignment checks if sunit/swidth mount options
> > > +	 * were used or alignment turned off.
> > > +	 * The custom alignment validation will happen later on xfs_mountfs()
> > > +	 */
> > > +	if (!(mp->m_flags & XFS_MOUNT_ALIGN) &&
> > > +	    !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > 
> > mp->m_dalign tells us at this point if a user specified sunit as a
> > mount option.  That's how xfs_fc_validate_params() determines the user
> > specified a custom sunit, so there is no need for a new mount flag
> > here to indicate that mp->m_dalign was set by the user....
> 
> At a first glance, I thought about it too, but, there is nothing preventing an
> user to mount a filesystem passing sunit=0,swidth=0. So, this means we can't
> really rely on the m_dalign/m_swidth values to check an user passed in (or not)
> alignment values. Unless we first deny users to pass 0 values into it.

Sure we can. We do this sort of "was the mount option set" detection
with m_logbufs and m_logbsize by initialising them to -1. Hence if
they are set by mount options, they'll have a valid, in-range value
instead of "-1".

That said, if you want users passing in sunit=0,swidth=0 to
correctly override existing on-disk values (i.e. effectively mean -o
noalign), then you are going to need to modify
xfs_update_alignment() and xfs_validate_new_dalign() to handle
mp->m_dalign == 0 as a valid value instead of "sunit/swidth mount
option not set, use existing superblock values".....

IOWs, there are deeper changes needed here than just setting a new
flag to say "mount option was set" for it to function correctly and
consistently as you intend. This is why I think we should just fix
this situation automatically, and not require the user to manually
override the bad values.

Thinking bigger picture, I'd like to see the mount options
deprecated and new xfs_admin options added to change the values on a
live, mounted filesystem. That way users who have issues like this
don't need to unmount the filesystem to fix it, not to mention users
who reshape online raid arrays and grow the filesystem can also
change the filesystem geometry without needing to take the
filesystem offline...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
