Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20818C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Apr 2022 19:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbiD2Tlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Apr 2022 15:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235528AbiD2Tll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Apr 2022 15:41:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A2BC4004
        for <linux-xfs@vger.kernel.org>; Fri, 29 Apr 2022 12:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A35B837BB
        for <linux-xfs@vger.kernel.org>; Fri, 29 Apr 2022 19:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8CCC385A7;
        Fri, 29 Apr 2022 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651261099;
        bh=2vj3Xu4A1NuxkRUgQA+57qXVF99P2xn0iFnQ8yeeceE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YohQ/BD5N99123TzUvwY56lXr1NNwTvJHsPRqtfTRxtIRMWXtXQF+DnxUfttwjGJc
         BtPoTE/Ak9tGvC804au4EHPQlmstRxJX/ZfSjuBpB55LDtdhMw3BppA+UjQU5JGEfI
         2ad0wrbC7PDwX/Q9dBs/N1cnDkRYRLLCVdWt5P8yrV/wFPycoD+3M9jgADzF8Qjlsr
         DtgMB6mW8iYWlVGOeUZeF4ecrzouitZ775dCQKaVhtCFPMCZrvpWf86pYnGkUYEXAh
         Xvyd3RJU1UdZ75LCG1fmIp74Rawc330v18oaTq/F4cN7TSbHtr2JCbrwvCsf8aPHpx
         +Sm4wPmhdRTWg==
Date:   Fri, 29 Apr 2022 12:38:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH v1 2/2] xfs: don't set warns on the id==0 dquot
Message-ID: <20220429193818.GQ17025@magnolia>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <20220421165815.87837-3-catherine.hoang@oracle.com>
 <20220422014017.GV1544202@dread.disaster.area>
 <05AA5136-1853-4296-8C56-8153A34F44D1@oracle.com>
 <20220425224246.GJ1544202@dread.disaster.area>
 <f9680a721516bbdbc411a9ad9b6e10daa313ce2f.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9680a721516bbdbc411a9ad9b6e10daa313ce2f.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 29, 2022 at 10:20:18AM -0700, Alli wrote:
> On Tue, 2022-04-26 at 08:42 +1000, Dave Chinner wrote:
> > On Mon, Apr 25, 2022 at 03:34:52PM +0000, Catherine Hoang wrote:
> > > > On Apr 21, 2022, at 6:40 PM, Dave Chinner <david@fromorbit.com>
> > > > wrote:
> > > > 
> > > > On Thu, Apr 21, 2022 at 09:58:15AM -0700, Catherine Hoang wrote:
> > > > > Quotas are not enforced on the id==0 dquot, so the quota code
> > > > > uses it
> > > > > to store warning limits and timeouts.  Having just dropped
> > > > > support for
> > > > > warning limits, this field no longer has any meaning.  Return
> > > > > -EINVAL
> > > > > for this dquot id if the fieldmask has any of the QC_*_WARNS
> > > > > set.
> > > > > 
> > > > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > > > ---
> > > > > fs/xfs/xfs_qm_syscalls.c | 2 ++
> > > > > 1 file changed, 2 insertions(+)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_qm_syscalls.c
> > > > > b/fs/xfs/xfs_qm_syscalls.c
> > > > > index e7f3ac60ebd9..bdbd5c83b08e 100644
> > > > > --- a/fs/xfs/xfs_qm_syscalls.c
> > > > > +++ b/fs/xfs/xfs_qm_syscalls.c
> > > > > @@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
> > > > > 		return -EINVAL;
> > > > > 	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
> > > > > 		return 0;
> > > > > +	if ((newlim->d_fieldmask & QC_WARNS_MASK) && id == 0)
> > > > > +		return -EINVAL;
> > > > 
> > > > Why would we do this for only id == 0? This will still allow
> > > > non-zero warning values to be written to dquots that have id !=
> > > > 0,
> > > > but I'm not sure why we'd allow this given that the previous
> > > > patch just removed all the warning limit checking?
> > > > 
> > > > Which then makes me ask: why are we still reading the warning
> > > > counts
> > > > from on disk dquots and writing in-memory values back to dquots?
> > > > Shouldn't xfs_dquot_to_disk() just write zeros to the warning
> > > > fields
> > > > now, and xfs_dquot_from_disk() elide reading the warning counts
> > > > altogether? i.e. can we remove d_bwarns, d_iwarns and d_rtbwarns
> > > > from the struct fs_disk_quota altogether now?
> > > > 
> > > > Which then raises the question of whether copy_from_xfs_dqblk()
> > > > and
> > > > friends should still support warn counts up in
> > > > fs/quota/quota.c...?
> > > 
> > > The intent of this patchset is to only remove warning limits, not
> > > warning
> > > counts. The id == 0 dquot stores warning limits, so we no longer
> > > want
> > > warning values to be written here. Dquots with id != 0 store
> > > warning
> > > counts, so we still allow these values to be updated. 
> > 
> > Why? What uses the value? After this patchset the warning count is
> > not used anywhere in the kernel. Absent in-kernel enforced limits,
> > the warning count fundamentally useless as a userspace decision tool
> > because of the warning count is not deterministic in any way.
> > Nothing can be inferred about the absolute value of the count
> > because it can't be related back to individual user operations.
> > 
> > i.e. A single write() can get different numbers of warnings issuedi
> > simply because of file layout or inode config (e.g. DIO vs buffered,
> > writes into sparse regions, unwritten regions, if extent size hints
> > are enabled, etc) and so the absolute magnitude of the warning count
> > doesn't carry any significant meaning.
> > 
> > I still haven't seen a use case for these quota warning counts,
> > either with or without the limiting code. Who needs this, and why?
> 
> Hmm, I wonder if this is eluding to the idea of just removing the
> function all together then?  And replacing it with a -EINVAL or maybe
> -EOPNOTSUPP?  I only see a few calls to it in xfs_quotaops.c

I don't think /anyone/ needs it, but we're spending a lot of time
speculating and arguing about a poorly defined feature that has never
been satisfactorily implemented.  I broke it two LTSes ago based on my
misunderstanding (and nobody said anything during review) by making the
kernel bump the warning count, and nobody noticed until RH QA hit it.

I spoke to Jan Kara yesterday about removing the warning counts, and he
said he was fine if we simply made the VFS quotactl code return EINVAL
if you try to set the warning values, and then just remove everything
else behind that.

--D

> Allison
> > 
> > > In regards to whether or not warning counts should be removed, it
> > > seems
> > > like they currently do serve a purpose. Although there's some
> > > debate about
> > > this in a previous thread:
> > > https://lore.kernel.org/linux-xfs/20220303003808.GM117732@magnolia/
> > 
> > Once the warning count increment is removed, there are zero users of
> > the warning counts.
> > 
> > Legacy functionality policy (as defined by ALLOCSP removal) kicks in
> > here: remove anything questionable ASAP, before it bites us hard.
> > And this has already bitten us real hard...
> > 
> > Cheers,
> > 
> > Dave.
> 
