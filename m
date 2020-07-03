Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFE2C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 00:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA372073E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 00:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgGCA6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 20:58:55 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:40812 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbgGCA6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 20:58:55 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 74FEB104D5E;
        Fri,  3 Jul 2020 10:58:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jrA2U-0001mB-LI; Fri, 03 Jul 2020 10:58:50 +1000
Date:   Fri, 3 Jul 2020 10:58:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
Message-ID: <20200703005850.GJ2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353173676.2864738.5361850443664572160.stgit@magnolia>
 <20200701225053.GA2005@dread.disaster.area>
 <20200701231910.GQ7625@magnolia>
 <20200701234435.GF2005@dread.disaster.area>
 <20200701235031.GY7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701235031.GY7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=BiJ8t_5Znzq9ORB7pEIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 04:50:31PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 02, 2020 at 09:44:35AM +1000, Dave Chinner wrote:
> > On Wed, Jul 01, 2020 at 04:19:10PM -0700, Darrick J. Wong wrote:
> > > On Thu, Jul 02, 2020 at 08:50:53AM +1000, Dave Chinner wrote:
> > > > On Tue, Jun 30, 2020 at 08:42:16AM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Use the incore dq_flags to figure out the dquot type.  This is the first
> > > > > step towards removing xfs_disk_dquot from the incore dquot.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
> > > > >  fs/xfs/scrub/quota.c           |    4 ----
> > > > >  fs/xfs/xfs_dquot.c             |   33 +++++++++++++++++++++++++++++++--
> > > > >  fs/xfs/xfs_dquot.h             |    2 ++
> > > > >  fs/xfs/xfs_dquot_item.c        |    6 ++++--
> > > > >  fs/xfs/xfs_qm.c                |    4 ++--
> > > > >  fs/xfs/xfs_qm.h                |    2 +-
> > > > >  fs/xfs/xfs_qm_syscalls.c       |    9 +++------
> > > > >  8 files changed, 45 insertions(+), 17 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> > > > > index 56d9dd787e7b..459023b0a304 100644
> > > > > --- a/fs/xfs/libxfs/xfs_quota_defs.h
> > > > > +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> > > > > @@ -29,6 +29,8 @@ typedef uint16_t	xfs_qwarncnt_t;
> > > > >  
> > > > >  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
> > > > >  
> > > > > +#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)
> > > > 
> > > > That's used as an on-disk flags mask. Perhaps XFS_DQF_ONDISK_MASK?
> > > 
> > > Well, based on Christoph's suggestions I broke the incore dquot flags
> > > (XFS_DQ_*) apart from the ondisk dquot flags (XFS_DQFLAG_*).  Not sure
> > > if that's really better, but at least the namespaces are separate now.
> > 
> > Sure, but the point I was trying to make is that "XFS_DQ_ONDISK"
> > doesn't actually indicate what part of the on-disk dquot it refers
> > to. We use the phrase "on-disk dquot" to refer to the entire on-disk
> > dquot, not a subset of flags in a flags field in the on-disk
> > dquot. Hence the name of this variable needs to be more specific as
> > to what it applies to in the on-disk dquot...
> 
> Sorry, I was typing too fast.  xfs_format.h now has:
> 
> #define XFS_DQFLAG_USER		0x01		/* user dquot record */
> #define XFS_DQFLAG_PROJ		0x02		/* project dquot record */
> #define XFS_DQFLAG_GROUP	0x04		/* group dquot record */
> 
> #define XFS_DQFLAG_TYPE_MASK	(XFS_DQFLAG_USER | \
> 				 XFS_DQFLAG_PROJ | \
> 				 XFS_DQFLAG_GROUP)
> 
> #define XFS_DQFLAG_ALL		(XFS_DQFLAG_TYPE_MASK)
> 
> /*
>  * This is the main portion of the on-disk representation of quota
>  * information for a user. This is the q_core of the struct xfs_dquot
>  * that is kept in kernel memory. We pad this with some more expansion
>  * room to construct the on disk structure.
>  */
> struct xfs_disk_dquot {
> 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
> 	__u8		d_version;	/* dquot version */
> 	__u8		d_flags;	/* XFS_DQFLAG_* */
> 
> I'm not particularly thrilled about the DQFLAG/DQ thing though.  DDFLAG?
> (Also note that the future bigtime series will add a new ondisk flag
> XFS_DQFLAG_BIGTIME, which ofc will get added to XFS_DQFLAG_ALL.)

/me shrugs

I don't have any good ideas, but I think that DQFLAG is a bad choice
for an on-disk flag namespace because it's way too generic. It's
more a type/feature indicator so perhaps we should rename d_flags to
d_type or d_features and use:

#define XFS_DDQTYPE_USER
#define XFS_DDQTYPE_PROJ
#define XFS_DDQTYPE_GROUP
#define XFS_DDQTYPE_BIGTIME

#define XFS_DDQTYPE_QUOTA_MASK	(XFS_DDQTYPE_USER | ...

#define XFS_DDQTYPE_ALL		(XFS_DDQTYPE_QUOTA_MASK | XFS_DDQTYPE_BIGTIME)

Or something like that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
