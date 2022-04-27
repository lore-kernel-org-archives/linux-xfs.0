Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367B9C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 01:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiD0BgY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 21:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiD0BgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 21:36:24 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52D7791371
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 18:33:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 70F93536861;
        Wed, 27 Apr 2022 11:33:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njWYJ-004yH9-8Y; Wed, 27 Apr 2022 11:33:11 +1000
Date:   Wed, 27 Apr 2022 11:33:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfsprogs: autoconf modernisation
Message-ID: <20220427013311.GD1098723@dread.disaster.area>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-5-david@fromorbit.com>
 <20220427004241.GY17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427004241.GY17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62689d59
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=KFe9eKCfoDDzrHzlbyMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:42:41PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 09:44:53AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because apparently AC_TRY_COMPILE and AC_TRY_LINK has been
> > deprecated and made obsolete.
> > 
> > .....
> > configure.ac:164: warning: The macro `AC_TRY_COMPILE' is obsolete.
> > configure.ac:164: You should run autoupdate.
> > ./lib/autoconf/general.m4:2847: AC_TRY_COMPILE is expanded from...
> > m4/package_libcdev.m4:68: AC_HAVE_GETMNTENT is expanded from...
> > configure.ac:164: the top level
> > configure.ac:165: warning: The macro `AC_TRY_LINK' is obsolete.
> > configure.ac:165: You should run autoupdate.
> > ./lib/autoconf/general.m4:2920: AC_TRY_LINK is expanded from...
> > m4/package_libcdev.m4:84: AC_HAVE_FALLOCATE is expanded from...
> > configure.ac:165: the top level
> > .....
> > 
> > But "autoupdate" does nothing to fix this, so I have to manually do
> > these conversions:
> > 
> > 	- AC_TRY_COMPILE -> AC_COMPILE_IFELSE
> > 	- AC_TRY_LINK -> AC_LINK_IFELSE
> > 
> > because I have nothing better to do than fix currently working
> > code.
> > 
> > Also, running autoupdate forces the minimum pre-req to be autoconf
> > 2.71 because it replaces other stuff...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I hate autoconf, and this seems like stupid pedantry on their part...

Same, and yes, I really don't see the point of forcing everyone to
update code like this when it largely could have been handled simply
by rewriting the AC_TRY_COMPILE macro to use the AC_LANG_PROGRAM
macro internally.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
