Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008C0C43381
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08F164E7A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhBWSZ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 13:25:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233943AbhBWSZ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 13:25:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90CD64E05;
        Tue, 23 Feb 2021 18:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614104718;
        bh=l7ChLWQbggIIwAxU5/iFwJuoxZLm7tPImCCY2FdNYO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iiGzyZiTdMDmkwAM0pwZIpKJXbvWdPs+K2rrGr+y6mRcyu+IwnZMfvwLOniJ426V1
         b7VgzlDD4KxdwMrwz33W1AC9cNMHCFOlP9LFMuqICLPUeIV5VqbCROw+6EKmWB98lX
         gnQ9090Enf/T+QrGFEquDnU/RZoUTH6bDTmX5303ea5Vv+d49jZo1/jq23IQMgE9SK
         TsGf73L3iX1Fsu1i++4xcZ15YoH7swCu1tTVkc5EpqEb2B6D/Rv0vIc8NLIuNGDsu2
         qcUB7A5M8PqWsfKG/4mErsrKLqb/V3++E/r5nLwOLIVDKSGDaBROnWkiO0Zcqc0m5u
         l0SjJ+78dYc4A==
Date:   Tue, 23 Feb 2021 10:25:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
Message-ID: <20210223182517.GM7272@magnolia>
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-3-preichl@redhat.com>
 <61f66b91-4343-f28e-dd47-6b6c70ee8b96@sandeen.net>
 <e29b3877-385b-3e0a-5761-51bb1265b302@redhat.com>
 <a5a94542-750c-0741-f95d-799e34656ca0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5a94542-750c-0741-f95d-799e34656ca0@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 12:10:41PM -0600, Eric Sandeen wrote:
> On 2/23/21 11:53 AM, Pavel Reichl wrot
> > 
> > On 2/22/21 11:19 PM, Eric Sandeen wrote:
> >>
> >> On 2/20/21 4:15 PM, Pavel Reichl wrote:
> >>> Skip the warnings about mount option being deprecated if we are
> >>> remounting and deprecated option state is not changing.
> >>>
> >>> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
> >>> Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
> >>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> >>> ---
> >>>  fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
> >>>  1 file changed, 19 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >>> index 813be879a5e5..6724a7018d1f 100644
> >>> --- a/fs/xfs/xfs_super.c
> >>> +++ b/fs/xfs/xfs_super.c
> >>> @@ -1169,6 +1169,13 @@ xfs_fs_parse_param(
> >>>  	struct fs_parse_result	result;
> >>>  	int			size = 0;
> >>>  	int			opt;
> >>> +	uint64_t                prev_m_flags = 0; /* Mount flags of prev. mount */
> >>> +	bool			remounting = fc->purpose & FS_CONTEXT_FOR_RECONFIGURE;
> >>> +
> >>> +	/* if reconfiguring then get mount flags of previous flags */
> >>> +	if (remounting) {
> >>> +		prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
> >>
> >> I wonder, does mp->m_flags work just as well for this purpose? I do get lost
> >> in how the mount api stashes things. I /think/ that the above is just a
> >> long way of getting to mp->m_flags.
> > 
> > Hi Eric, I'm sorry to disagree, but I think that mp->m_flags is
> > newly allocated for this mount and it's not populated with previous
> > mount's mount options.

Yeah, that's one of the (IMHO) ugliest warts of the new fs parsing code.

> No need to be sorry ;) And in any case, you're corrrect here.
> 
> > 
> > static int xfs_init_fs_context(
> >         struct fs_context       *fc)
> > {
> >         struct xfs_mount        *mp;
> > 
> > So here it's allocated and zeroed
> > 
> >         mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
> >         if (!mp)
> >                 return -ENOMEM;
> >                 
> > ...
> 
> and eventually:
> 
> 	fc->s_fs_info = mp;
> 
> Ok, yup, I see.  so I guess we kind of have:
> 
> *parsing_mp = fc->s_fs_info;
> 
> and 
> 
> *current_mp = XFS_M(fc->root->d_sb);
> 
> (variable names not actually in the code, just used for example)

Maybe they should be. ;)

--D

> Sorry for the noise, my mistake!
> 
> -Eric
