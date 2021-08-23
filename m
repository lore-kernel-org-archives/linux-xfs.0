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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E10C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 07:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27E8A6126A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 07:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhHWHS3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 03:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhHWHS3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 03:18:29 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058ABC061575
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 00:17:47 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s11so15844066pgr.11
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 00:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=XK62++rwaHUWpHkWj0E2Qf1P1jPztXQhBSve/8lgaYM=;
        b=NFwqTnPNF1WVBu1bsa57xuPwzLL9tVc63t+b+R4cXLfRQunpAUbalZ1yGHB5cak+dB
         K1ngyJz9Fs3dNmUKhu5I5al5HlLeOkqYvDrt+Ed/QH7PxicMjEwFJW+5aqYM15/ENtFW
         sH5oEQVxfAEo7fjeFiMVFe52kjOerR3j+QEdiu6HpUaU4BFCwqCUCfMAuw5jkC7/W5rb
         ZQIIFY68kk8o3tJdyZcE6j05fRFudqxTFODdqA6nTU5DEmCBdO0y/xtV9ErovIMGZU6O
         FFzIExbjYyZFj9G0rHvU7bGwoVtm8JAJqMbFegwwWHtEKsaEqWm2R1+0qK5+Xvtjgqzu
         JVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=XK62++rwaHUWpHkWj0E2Qf1P1jPztXQhBSve/8lgaYM=;
        b=WRnuIqNcBQhNuF433HIutLUED3BXyVBamWe7WuxTiD3/GV/caBOEIdqanhnojt/+IV
         wLmb1ao3G6eJfi0TfNAdlqEPjky5nbM3umVLV5HsuhJAdt+WW0FSj5rtiUG8ISsjAHHm
         jW43xPiD1os2krkZ/0Br3Pd6HT1WkwYRfGO0Sl0vVl4dOCMDiTOnlxhk3rIP1t4uW+qW
         ZGlcxPM3rTik8ma6GLTSPKMUfB7KcSHFOQoHy6bCUrFzDwBN0sqCXVVqnbGGNvUjAVYr
         rhBfXBXieSIwXNRLVyAQsYNqIg22bIwbAKq+Samj0Wa/yjsx5vpkgreMR1S97ilLvsTy
         cKIg==
X-Gm-Message-State: AOAM5304Ebm5t9+XG/f8wMHmPTt3JkmoiEtq742EMqVN4PDbdvamMZke
        PfiQwGV055+LEGPea1X2vrJkwgVhJ1A=
X-Google-Smtp-Source: ABdhPJx+fBOc/f/ouJ795XfxTM28jmkoL8+CNrltrxNOgOyZ1TOs6ptcrG+6hUkQgymMdz5ET2p6mg==
X-Received: by 2002:a63:f94c:: with SMTP id q12mr30482368pgk.171.1629703066412;
        Mon, 23 Aug 2021 00:17:46 -0700 (PDT)
Received: from garuda ([122.171.49.230])
        by smtp.gmail.com with ESMTPSA id a190sm12682441pfa.49.2021.08.23.00.17.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Aug 2021 00:17:46 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-3-chandanrlinux@gmail.com>
 <20210727215611.GK559212@magnolia> <20210727220318.GN559212@magnolia>
 <87eebjw2lj.fsf@garuda>
 <87y28sg5e5.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 02/12] xfs: Rename MAXEXTNUM, MAXAEXTNUM to
 XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
In-reply-to: <87y28sg5e5.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87v93wfx48.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 23 Aug 2021 12:47:43 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Aug 2021 at 09:48, Chandan Babu R wrote:
> On 28 Jul 2021 at 08:45, Chandan Babu R wrote:
>> On 28 Jul 2021 at 03:33, Darrick J. Wong wrote:
>>> On Tue, Jul 27, 2021 at 02:56:11PM -0700, Darrick J. Wong wrote:
>>>> On Mon, Jul 26, 2021 at 05:15:31PM +0530, Chandan Babu R wrote:
>>>> > In preparation for introducing larger extent count limits, this commit renames
>>>> > existing extent count limits based on their signedness and width.
>>>> > 
>>>> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>>>> > ---
>>>> >  fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
>>>> >  fs/xfs/libxfs/xfs_format.h     | 8 ++++----
>>>> >  fs/xfs/libxfs/xfs_inode_buf.c  | 4 ++--
>>>> >  fs/xfs/libxfs/xfs_inode_fork.c | 3 ++-
>>>> >  fs/xfs/scrub/inode_repair.c    | 2 +-
>>>> >  5 files changed, 11 insertions(+), 10 deletions(-)
>>>> > 
>>>> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>>>> > index f3c9a0ebb0a5..8f262405a5b5 100644
>>>> > --- a/fs/xfs/libxfs/xfs_bmap.c
>>>> > +++ b/fs/xfs/libxfs/xfs_bmap.c
>>>> > @@ -76,10 +76,10 @@ xfs_bmap_compute_maxlevels(
>>>> >  	 * available.
>>>> >  	 */
>>>> >  	if (whichfork == XFS_DATA_FORK) {
>>>> > -		maxleafents = MAXEXTNUM;
>>>> > +		maxleafents = XFS_IFORK_EXTCNT_MAXS32;
>>>> 
>>>> I'm not in love with these names, since they tell me roughly about the
>>>> size of the constant (which I could glean from the definition) but less
>>>> about when I would expect to find them.  How about:
>>>> 
>>>> #define XFS_MAX_DFORK_NEXTENTS    ((xfs_extnum_t) 0x7FFFFFFF)
>>>> #define XFS_MAX_AFORK_NEXTENTS    ((xfs_aextnum_t)0x00007FFF)
>>>
>>> Or, given that 'DFORK' already means 'ondisk fork', how about:
>>>
>>> XFS_MAX_DATA_NEXTENTS
>>> XFS_MAX_ATTR_NEXTENTS
>>
>> Yes, I agree. These names are better. I will incorporate your suggestions
>> before posting V3.
>>
>
> Using XFS_MAX_[ATTR|DATA]_NEXTENTS won't be feasible later in the patch series
> since the maximum extent count for the two inode forks depend on whether
> XFS_SB_FEAT_INCOMPAT_NREXT64 feature bit is set or not. With the incompat
> feature bit set, extent counts for attr and data forks can have maximum values
> of (2^32 - 1) and (2^48 - 1) respectively. With the incompat feature bit not
> set, extent counts for attr and data forks can have maximum values of (2^15 -
> 1) and (2^31 - 1) respectively.
>
> Also, xfs_iext_max_nextents() (an inline function introduced in the next patch
> in this series) abstracts away the logic of determining the maximum extent
> count for an inode fork.

I think introducing xfs_iext_max_nextents() before renaming the max extent
counter macros would reduce proliferation of XFS_IFORK_EXTCNT_MAX* macros
across the source code. If you are ok with it, I will reorder the current
patch and the next patch.

-- 
chandan
