Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FCDC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351877AbiDLKBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391108AbiDLJZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 05:25:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB6535A5AF
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 01:43:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 93E1D5343E8;
        Tue, 12 Apr 2022 18:43:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1neC77-00GlNx-Vp; Tue, 12 Apr 2022 18:43:06 +1000
Date:   Tue, 12 Apr 2022 18:43:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/17] xfs: convert inode lock flags to unsigned.
Message-ID: <20220412084305.GE1544202@dread.disaster.area>
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-14-david@fromorbit.com>
 <87v8vezrrt.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8vezrrt.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62553b9b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=x3PwlDHbrOjqUHFclGcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 12:56:30PM +0530, Chandan Babu R wrote:
> On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> > fields to be unsigned.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> [...]
> 
> > @@ -350,12 +350,12 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
> >   */
> >  #define XFS_IOLOCK_SHIFT		16
> >  #define XFS_IOLOCK_MAX_SUBCLASS		3
> > -#define XFS_IOLOCK_DEP_MASK		0x000f0000
> > +#define XFS_IOLOCK_DEP_MASK		0x000f0000u
> >  
> >  #define XFS_MMAPLOCK_SHIFT		20
> >  #define XFS_MMAPLOCK_NUMORDER		0
> >  #define XFS_MMAPLOCK_MAX_SUBCLASS	3
> > -#define XFS_MMAPLOCK_DEP_MASK		0x00f00000
> > +#define XFS_MMAPLOCK_DEP_MASK		0x00f00000u
> >  
> >  #define XFS_ILOCK_SHIFT			24
> >  #define XFS_ILOCK_PARENT_VAL		5
> 
> Why isn't the value of XFS_ILOCK_DEP_MASK marked as unsigned?

Because I'm blind as a bat at the best of times... :)

Good catch - I'll fix it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
