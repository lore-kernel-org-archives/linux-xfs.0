Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E175C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 20:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8CC223AA7
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 20:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbhAOUnM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 15:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbhAOUnL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 15:43:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8824323A9C;
        Fri, 15 Jan 2021 20:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610743350;
        bh=GU+hi9SNPH7Jwvmt97xnjJHmgHpAifMfZMU2zwiGfOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GW/l9bTUvKuDyek7F6rCbKaUzNQjiqdedoVnyxp2aZPD8q6etNWcSsdhALayoeSc2
         wjwM2AflA/xS4/nSRasV/iKWtPkwQtbfNjgiQZ6UDLWdsF/0yyJHs73twlRAUaA7rd
         g7bz6ZY4AiTiiz/VE2DbYe+OBdkoJmtprFFrD3cw0YKsgvA40qYpkI/QFsomK+x7mj
         Yc+6dUpYEinU8pgNKI+Io52BenOd6FC2hIypeGdgxUYQsHG2CBBNR5mrb4tCoUOjKO
         W8laf6S3c+AstmaQHdPNCzsGkclcFbJ1dsKTf86v8tRhjmx0cXCfCbRwRMGqFZy095
         TGZjnPswHLblA==
Date:   Fri, 15 Jan 2021 12:42:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: clear the needsrepair flag
Message-ID: <20210115204229.GC3134581@magnolia>
References: <161017367756.1141483.3709627869982359451.stgit@magnolia>
 <161017369673.1141483.6381128502951229066.stgit@magnolia>
 <20210113181749.GC1284163@bfoster>
 <20210114010548.GV1164246@magnolia>
 <20210114093942.GB1333929@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114093942.GB1333929@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 04:39:42AM -0500, Brian Foster wrote:
> On Wed, Jan 13, 2021 at 05:05:48PM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 13, 2021 at 01:17:49PM -0500, Brian Foster wrote:
> > > On Fri, Jan 08, 2021 at 10:28:16PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Clear the needsrepair flag, since it's used to prevent mounting of an
> > > > inconsistent filesystem.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  repair/agheader.c |   11 +++++++++++
> > > >  1 file changed, 11 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/repair/agheader.c b/repair/agheader.c
> > > > index 8bb99489..f6174dbf 100644
> > > > --- a/repair/agheader.c
> > > > +++ b/repair/agheader.c
> > > > @@ -452,6 +452,17 @@ secondary_sb_whack(
> > > >  			rval |= XR_AG_SB_SEC;
> > > >  	}
> > > >  
> > > > +	if (xfs_sb_version_needsrepair(sb)) {
> > > > +		if (!no_modify)
> > > > +			sb->sb_features_incompat &=
> > > > +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > > +		if (!do_bzero) {
> > > > +			rval |= XR_AG_SB;
> > > > +			do_warn(_("needsrepair flag set in sb %d\n"), i);
> > > > +		} else
> > > > +			rval |= XR_AG_SB_SEC;
> > > > +	}
> > > > +
> > > 
> > > Looks reasonable modulo the questions on the previous patch. When I give
> > > this a test, one thing that stands out is that the needsrepair state
> > > itself sort of presents as corruption. I.e.,
> > > 
> > > # ./db/xfs_db -x -c "version needsrepair" <dev>
> > > Upgrading V5 filesystem
> > > Upgraded V5 filesystem.  Please run xfs_repair.
> > > versionnum [0xb4a5+0x18a] =
> > > V5,NLINK,DIRV2,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK,NEEDSREPAIR
> > > # ./repair/xfs_repair <dev>
> > > Phase 1 - find and verify superblock...
> > > Phase 2 - using internal log
> > >         - zero log...
> > >         - scan filesystem freespace and inode maps...
> > > needsrepair flag set in sb 1
> > > reset bad sb for ag 1
> > > needsrepair flag set in sb 2
> > > reset bad sb for ag 2
> > > needsrepair flag set in sb 0
> > > reset bad sb for ag 0
> > > needsrepair flag set in sb 3
> > > reset bad sb for ag 3
> > >         - found root inode chunk
> > > Phase 3 - for each AG...
> > > ...
> > > 
> > > So nothing was ever done to this fs besides set and clear the bit. Not a
> > > huge deal, but I wonder if we should print something more user friendly
> > > to indicate that repair found and cleared the needsrepair state, or at
> > > least just avoid the "reset bad sb ..." message for the needsrepair
> > > case.
> > 
> > Hm.  For the backup supers I guess there's really not much point in
> > saying anything about the bit being set, because the only time they get
> > used is when repair tries to use one to fix a filesystem.
> > 
> > As for AG 0, I guess I could change that to say:
> > 
> > 	dbprintf(_("Thank you for running xfs_repair!"));
> > 
> > :D Or maybe there's no need to say anything at all.
> > 
> 
> Heh. FWIW, the "needsrepair flag set ..." messages didn't seem as
> alarming as the "reset bad sb ..." ones, but that's just me. I'd be fine
> with making this entirely silent too, or at least starting that way
> until some user complains with a good enough reason for a new message..
> ;)

I changed it so repair says "clearing needsrepair flag and regenerating
metadata" and omits the "reset bad sb" warnings.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  	return(rval);
> > > >  }
> > > >  
> > > > 
> > > 
> > 
> 
