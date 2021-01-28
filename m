Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DBCC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C1364E25
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhA1ScG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:32:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231140AbhA1S3r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 13:29:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B85664E0E;
        Thu, 28 Jan 2021 18:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611858170;
        bh=ybzFb59HoQ8Pri/2f0j+XPrEquRirezczzFmZFBhbBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jitCPM3sfrOPaHUh6idMRmIL2A7TToiZUuYVpt0WZECHwI+l4IQO1+3UYtlq4w34q
         JQyXu6rFhpoMm9161lNvxCdIduE1mHms6h0IOzc8Ehfm53nHri/NBjDrkJPqfw994r
         GQEWXub4HB8k90CFnpwKxzsvOA3lqmuKqBuhJ6cF1dwQNG47M+C0T/Dpr5nMXDCFhh
         zip+B+KxxpUCWIFrZZ9c3myxqzr/oZT9ugTP0Y7C8USbcVVIrbzhdjECrpbfKBDbc6
         n24p/NWQC+ATTg5tcZuYZ+/9l4VtVS+5BS15tSCq5gvlZIBj4/97mU2Ji2BgI1YGak
         RRv68iRy/5Msg==
Date:   Thu, 28 Jan 2021 10:22:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 05/13] xfs: fix up build warnings when quotas are disabled
Message-ID: <20210128182249.GW7698@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181369266.1523592.14023535880347018628.stgit@magnolia>
 <20210128180922.GD2619139@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128180922.GD2619139@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 01:09:22PM -0500, Brian Foster wrote:
> On Wed, Jan 27, 2021 at 10:01:32PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix some build warnings on gcc 10.2 when quotas are disabled.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_quota.h |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> > index d1e3f94140b4..72f4cfc49048 100644
> > --- a/fs/xfs/xfs_quota.h
> > +++ b/fs/xfs/xfs_quota.h
> ...
> > @@ -166,8 +166,8 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
> >  #define xfs_qm_dqattach(ip)						(0)
> >  #define xfs_qm_dqattach_locked(ip, fl)					(0)
> >  #define xfs_qm_dqdetach(ip)
> > -#define xfs_qm_dqrele(d)
> > -#define xfs_qm_statvfs(ip, s)
> > +#define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)
> 
> What's the need for the assignment, out of curiosity?

It shuts up a gcc warning about how the dquot pointer is set but never
used.  One hopes the same gcc is smart enough not to generate any code
for this.

--D

> Regardless, LGTM:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +#define xfs_qm_statvfs(ip, s)			do { } while(0)
> >  #define xfs_qm_newmount(mp, a, b)					(0)
> >  #define xfs_qm_mount_quotas(mp)
> >  #define xfs_qm_unmount(mp)
> > 
> 
