Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D436AC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 04:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B787761040
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 04:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhHWETn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 00:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhHWETn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 00:19:43 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62C6C061575
        for <linux-xfs@vger.kernel.org>; Sun, 22 Aug 2021 21:19:01 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so15498723pga.13
        for <linux-xfs@vger.kernel.org>; Sun, 22 Aug 2021 21:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=sAuFgxdIlpemINWQtUeo7wBohksbYFVSPRzYQl0Ok4U=;
        b=JDxzd5/v0F7N2X1JU2NwMamUs+EgLWL48otF7A/+aRuEzh/jI1iahfmiv+eT1KSCef
         tZoaEo+ZULM3QMHpwYQV0pWPozlhjicod7F27q52iauLvNs2qAIjH/aBWjOYGlzTR8Xg
         hq8ynyAYYzSOUpy1vI3RtJlwmdPwqSrjucYYWtV9QagyXuRITnUttAuox710bOyPQv2+
         g+o6uxJAsiYGBpekv8gRy9OKr9OWTys8GzsLZ6fZw2TC+zrtPdsQx9sOkkw0bOBxCDbL
         nZ7vROsu5GjCjhH65CcIEC1L+gIUEyZphj/CjMcumAmUVVtnd0EaBteQxdEHSJXIJVLh
         gAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=sAuFgxdIlpemINWQtUeo7wBohksbYFVSPRzYQl0Ok4U=;
        b=QO/P4kPOJD3bFf59w2dMbQoebMKPdO2iklMaBOEqS/A/aOi3Gt+8bo4WO0YhkaZLrb
         Ep4XcI+78XJGQiOgdveibQ1N5BiwP+jREv74CQnAN8wRQIXab5ifPMnjt6a/alRVV0zz
         MkaL340SI0ZbciYpSF0pUmaC6IMJX1MzIsLFZRZ2c4/inxE+CDfWiaKmA7MeVXaME1xm
         BomPl1ILRQCwMOaEKJkGNnAexZgqYRzlCMdSOJvodl5RYNjwBf7OxbyHEqwqM9PDYKld
         9FI03OIm4DR64dR0++gmIJsEO3shAU/Jnws2O4CIKOx1XduGvOa0k3VsTmlNwNQVWp6D
         ItpQ==
X-Gm-Message-State: AOAM531l/4NK5XXDkHXIMa6EB3eZB3y8y5U518/8WqkqRvbs+XqDFpDL
        bVsnfjrCJMlaWumEv1oGfjcrZL6SDFw=
X-Google-Smtp-Source: ABdhPJwu2ReCiA9mxBb0ApHFYgv2IVTBGDNbtMNFxnW+prxk1O5aEvUULEBs04pARltKrMzo0FterA==
X-Received: by 2002:a63:f656:: with SMTP id u22mr30558800pgj.392.1629692341322;
        Sun, 22 Aug 2021 21:19:01 -0700 (PDT)
Received: from garuda ([122.171.62.216])
        by smtp.gmail.com with ESMTPSA id x1sm13763905pfn.64.2021.08.22.21.18.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Aug 2021 21:19:00 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-3-chandanrlinux@gmail.com>
 <20210727215611.GK559212@magnolia> <20210727220318.GN559212@magnolia>
 <87eebjw2lj.fsf@garuda>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 02/12] xfs: Rename MAXEXTNUM, MAXAEXTNUM to
 XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
In-reply-to: <87eebjw2lj.fsf@garuda>
Message-ID: <87y28sg5e5.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 23 Aug 2021 09:48:58 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 08:45, Chandan Babu R wrote:
> On 28 Jul 2021 at 03:33, Darrick J. Wong wrote:
>> On Tue, Jul 27, 2021 at 02:56:11PM -0700, Darrick J. Wong wrote:
>>> On Mon, Jul 26, 2021 at 05:15:31PM +0530, Chandan Babu R wrote:
>>> > In preparation for introducing larger extent count limits, this commit renames
>>> > existing extent count limits based on their signedness and width.
>>> > 
>>> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>>> > ---
>>> >  fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
>>> >  fs/xfs/libxfs/xfs_format.h     | 8 ++++----
>>> >  fs/xfs/libxfs/xfs_inode_buf.c  | 4 ++--
>>> >  fs/xfs/libxfs/xfs_inode_fork.c | 3 ++-
>>> >  fs/xfs/scrub/inode_repair.c    | 2 +-
>>> >  5 files changed, 11 insertions(+), 10 deletions(-)
>>> > 
>>> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>>> > index f3c9a0ebb0a5..8f262405a5b5 100644
>>> > --- a/fs/xfs/libxfs/xfs_bmap.c
>>> > +++ b/fs/xfs/libxfs/xfs_bmap.c
>>> > @@ -76,10 +76,10 @@ xfs_bmap_compute_maxlevels(
>>> >  	 * available.
>>> >  	 */
>>> >  	if (whichfork == XFS_DATA_FORK) {
>>> > -		maxleafents = MAXEXTNUM;
>>> > +		maxleafents = XFS_IFORK_EXTCNT_MAXS32;
>>> 
>>> I'm not in love with these names, since they tell me roughly about the
>>> size of the constant (which I could glean from the definition) but less
>>> about when I would expect to find them.  How about:
>>> 
>>> #define XFS_MAX_DFORK_NEXTENTS    ((xfs_extnum_t) 0x7FFFFFFF)
>>> #define XFS_MAX_AFORK_NEXTENTS    ((xfs_aextnum_t)0x00007FFF)
>>
>> Or, given that 'DFORK' already means 'ondisk fork', how about:
>>
>> XFS_MAX_DATA_NEXTENTS
>> XFS_MAX_ATTR_NEXTENTS
>
> Yes, I agree. These names are better. I will incorporate your suggestions
> before posting V3.
>

Using XFS_MAX_[ATTR|DATA]_NEXTENTS won't be feasible later in the patch series
since the maximum extent count for the two inode forks depend on whether
XFS_SB_FEAT_INCOMPAT_NREXT64 feature bit is set or not. With the incompat
feature bit set, extent counts for attr and data forks can have maximum values
of (2^32 - 1) and (2^48 - 1) respectively. With the incompat feature bit not
set, extent counts for attr and data forks can have maximum values of (2^15 -
1) and (2^31 - 1) respectively.

Also, xfs_iext_max_nextents() (an inline function introduced in the next patch
in this series) abstracts away the logic of determining the maximum extent
count for an inode fork.

-- 
chandan
