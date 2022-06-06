Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74099C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 01:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351944AbiFFBZf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 21:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348931AbiFFBZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 21:25:34 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7831113C
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 18:25:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D7A3A10E7295;
        Mon,  6 Jun 2022 11:25:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ny1Up-003Blc-GN; Mon, 06 Jun 2022 11:25:31 +1000
Date:   Mon, 6 Jun 2022 11:25:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: fix TOCTOU race involving the new logged xattrs
 control knob
Message-ID: <20220606012531.GP1098723@dread.disaster.area>
References: <YpzbrQdA9voYKRCE@magnolia>
 <20220605224743.GM1098723@dread.disaster.area>
 <Yp1FjrXqwcAgMYg/@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp1FjrXqwcAgMYg/@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629d578d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=WYgVogkDKTYDbkFp6T0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 05, 2022 at 05:08:46PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 06, 2022 at 08:47:43AM +1000, Dave Chinner wrote:
> > On Sun, Jun 05, 2022 at 09:37:01AM -0700, Darrick J. Wong wrote:
> > > --- a/fs/xfs/xfs_xattr.c
> > > +++ b/fs/xfs/xfs_xattr.c
> > > @@ -68,6 +68,18 @@ xfs_attr_rele_log_assist(
> > >  	xlog_drop_incompat_feat(mp->m_log);
> > >  }
> > >  
> > > +#ifdef DEBUG
> > > +static inline bool
> > > +xfs_attr_want_log_assist(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	/* Logged xattrs require a V5 super for log_incompat */
> > > +	return xfs_has_crc(mp) && xfs_globals.larp;
> > > +}
> > > +#else
> > > +# define xfs_attr_want_log_assist(mp)	false
> > > +#endif
> > 
> > If you are moving this code, let's clean it up a touch so that it
> > is the internal logic that is conditional, not the function itself.
> > 
> > static inline bool
> > xfs_attr_want_log_assist(
> > 	struct xfs_mount	*mp)
> > {
> > #ifdef DEBUG
> > 	/* Logged xattrs require a V5 super for log_incompat */
> > 	return xfs_has_crc(mp) && xfs_globals.larp;
> > #else
> > 	return false;
> > #endif
> > }
> 
> I don't mind turning this into a straight function move.  I'd figured
> that Linus' style preference is usually against putting conditional
> compilation inside functions, but for a static inline I really don't
> care either way.

Well, for conditional helper functions, having the static inline for
type checking in all builds is better than having a macro that makes
it go away silently when those build options are not turned on.

Better would probably be:

	if (!IS_ENABLED(CONFIG_XFS_DEBUG))
		return false;

	/* Logged xattrs require a V5 super for log_incompat */
	return xfs_has_crc(mp) && xfs_globals.larp;

And all the ifdef mess goes away at that point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
