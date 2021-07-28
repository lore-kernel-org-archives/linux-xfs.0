Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3C6C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 02:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 161A960FBF
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 02:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhG1CNH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 22:13:07 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:43899 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233256AbhG1CNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 22:13:07 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 24F4280B462;
        Wed, 28 Jul 2021 12:13:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8Z4B-00BasK-VO; Wed, 28 Jul 2021 12:13:03 +1000
Date:   Wed, 28 Jul 2021 12:13:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 14/16] xfs: Add delattr mount option
Message-ID: <20210728021303.GA2757197@dread.disaster.area>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-15-allison.henderson@oracle.com>
 <20210728004757.GB559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728004757.GB559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=e3T0hG8cuRK7unx8Y6kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:47:57PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:51PM -0700, Allison Henderson wrote:
> > This patch adds a mount option to enable delayed attributes. Eventually
> > this can be removed when delayed attrs becomes permanent.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.h |  2 +-
> >  fs/xfs/xfs_mount.h       |  1 +
> >  fs/xfs/xfs_super.c       | 11 ++++++++++-
> >  fs/xfs/xfs_xattr.c       |  2 ++
> >  4 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index c0c92bd3..d4e7521 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
> >  
> >  static inline bool xfs_hasdelattr(struct xfs_mount *mp)
> >  {
> > -	return false;
> > +	return mp->m_flags & XFS_MOUNT_DELATTR;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 66a47f5..2945868 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -257,6 +257,7 @@ typedef struct xfs_mount {
> >  #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
> >  #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
> >  #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
> > +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
> 
> So uh while we're renaming things away from "delattr", maybe this ...
> 
> 	LOGGED ATTRIBUTE RE PLAY
> 
> ... really should become the "larp" debug-only mount option.
> 
> 	XFS_MOUNT_LARP
> 
> Yeah.  Do it!!!
> 
> >  /*
> >   * Max and min values for mount-option defined I/O
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 2c9e26a..39d6645 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -94,7 +94,7 @@ enum {
> >  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
> >  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
> >  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> > -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
> > +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
> >  };
> >  
> >  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> > @@ -139,6 +139,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
> >  	fsparam_flag("nodiscard",	Opt_nodiscard),
> >  	fsparam_flag("dax",		Opt_dax),
> >  	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
> > +	fsparam_flag("delattr",		Opt_delattr),
> 
> I think you need this line to be guarded by #ifdefs so that the mount
> options parsing code will reject -o larp on non-debug kernels.

As i mentioned on #xfs, this really should be like the "always_cow"
debug option - access it via /sys/fs/xfs/debug/larping_with_larts -
rather than being a mount option that users might accidentally
discover and start using...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
