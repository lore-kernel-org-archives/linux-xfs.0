Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9BAC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 20:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 302AD2074A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 20:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732559AbgJOUyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 16:54:32 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50843 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732367AbgJOUyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 16:54:32 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3F6D458C77C;
        Fri, 16 Oct 2020 07:54:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kTAGa-000uSa-6Y; Fri, 16 Oct 2020 07:54:28 +1100
Date:   Fri, 16 Oct 2020 07:54:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/27] xfsprogs: remove xfs_buf_t typedef
Message-ID: <20201015205428.GH7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-7-david@fromorbit.com>
 <20201015152252.GT9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015152252.GT9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Y6RHoOyzgV4TZ-AMcQ8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 08:22:52AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 06:21:34PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Prepare for kernel xfs_buf  alignment by getting rid of the
> > xfs_buf_t typedef from userspace.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  copy/xfs_copy.c           |  2 +-
> >  include/libxlog.h         |  6 +++---
> >  libxfs/init.c             |  2 +-
> >  libxfs/libxfs_io.h        |  7 ++++---
> >  libxfs/libxfs_priv.h      |  4 ++--
> >  libxfs/logitem.c          |  4 ++--
> >  libxfs/rdwr.c             | 26 +++++++++++++-------------
> >  libxfs/trans.c            | 18 +++++++++---------
> >  libxfs/util.c             |  7 +++----
> >  libxfs/xfs_alloc.c        | 16 ++++++++--------
> >  libxfs/xfs_bmap.c         |  6 +++---
> >  libxfs/xfs_btree.c        | 10 +++++-----
> >  libxfs/xfs_ialloc.c       |  4 ++--
> >  libxfs/xfs_rtbitmap.c     | 22 +++++++++++-----------
> 
> Hmmm, do you want me to apply this to the kernel ASAP, since we're
> approaching the end of the merge window and nobody's rebased to 5.10
> yet?

Sure, makes sense to do this before everyone rebases. It's not a
huge change, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
