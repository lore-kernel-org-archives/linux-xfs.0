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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431D6C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 03:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E5360F91
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 03:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhG1DRo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 23:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhG1DRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 23:17:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907C1C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 20:17:38 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so2361031pjd.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 20:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=P3ofsPcKnKv3kMYnq7V65rnJlEJC0Bi9Me+pdROob9o=;
        b=a5ruqvK9gaHVGTSFGyejgV6xO0x1TflFioQ+xiS4uxbs6gRIJ2KlW32p2KH3XeqYiK
         3AFSHHCVby4DYNroUZu2cIxMZisp1tI0jHGocudoSOlCqlIruNz29SkuDG+9c+71uIbI
         UGbL6MJvI6rp1H9Ay+PHM02AmUAFGEXSrotpfdpTFzuMnyjUtt9BrrCfmRj6vQRXYthM
         XBSZoN6wAdPQ3z+i5DloYLkeV6TFI5MCLwtvkQ0xXxGFZwMHecb0H3UQ5PyC2Jg9qSoR
         4DCVouAComDAPyuEeVH+Q4LSB/UD8PEQlIzRB/8XazR4QO/ZjGtPppxYWrijppH90O78
         IBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=P3ofsPcKnKv3kMYnq7V65rnJlEJC0Bi9Me+pdROob9o=;
        b=jez3J/YpeV+UoFcr42wiRmCC1dcI1JCCdPCbZFZEF8EiFW3bN7PWl816NA9ob1U969
         14lSjZNOwGYhBrJS+9qr39H1KJ3wc+FJ10JyEBbSjL0TtAJxGzH1Tn9URkHua/3Nmg9E
         TZlh/TJ24Jg2pSYBeCxhj+W+FeP2xzO51unbJNLbauvB6m9bxpxThiyFj5CvK2iVLOb0
         GCKAF0Qu2I4dO7J9SpapDLnLp27H370+3pK++ubQR+kEgzD4SB5/tZ16WmEtWZoZ3Pa8
         BtDGE9O7fTar2qbccJq0f13t6BGJNvoo2mLddQ+89njEXsxN975SJi/FvKppGHeYFMMB
         bsYg==
X-Gm-Message-State: AOAM5311H/RMpkDchFi+HdAvboIUX+SYqDDZt/izl2V3o9GPbBQdqeMv
        FErf1L2c09yzXvWis+9jlLhoFb3SRKSU5w==
X-Google-Smtp-Source: ABdhPJzs/1sSAaKqkO5+ehzhZD+Pd4gfVf+ffmXYXjPEb10B+y0MLg29rCJxl36qgT462scfuxe2kg==
X-Received: by 2002:a17:90a:8403:: with SMTP id j3mr26191303pjn.212.1627442258043;
        Tue, 27 Jul 2021 20:17:38 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id i8sm5411712pfo.117.2021.07.27.20.17.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 20:17:37 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-4-chandanrlinux@gmail.com> <20210727215822.GL559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 03/12] xfs: Introduce xfs_iext_max() helper
In-reply-to: <20210727215822.GL559212@magnolia>
Date:   Wed, 28 Jul 2021 08:47:35 +0530
Message-ID: <87czr3w2i8.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 03:28, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 05:15:32PM +0530, Chandan Babu R wrote:
>> xfs_iext_max() returns the maximum number of extents possible for one of
>> data, cow or attribute fork. This helper will be extended further in a
>> future commit when maximum extent counts associated with data/attribute
>> forks are increased.
>> 
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
>>  fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
>>  fs/xfs/libxfs/xfs_inode_fork.c | 6 +++---
>>  fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
>>  fs/xfs/scrub/inode_repair.c    | 2 +-
>>  5 files changed, 19 insertions(+), 14 deletions(-)
>> 
>
> <snip>
>
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
>> index cf82be263b48..1eda2163603e 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.h
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
>> @@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>>  	return ifp->if_format;
>>  }
>>  
>> +static inline xfs_extnum_t xfs_iext_max(struct xfs_mount *mp, int whichfork)
>
> xfs_iext_max_nextents() to go with the constants?  "max" on its own is a
> little vague.  I /really/ like this getting cleaned up finally though.
>

Ok. I will rename the function as per your suggestion.

>> +{
>> +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
>> +		return XFS_IFORK_EXTCNT_MAXS32;
>> +	else
>> +		return XFS_IFORK_EXTCNT_MAXS16;
>
> No need for the 'else'.

Sure. I will fix it up.

>
> --D
>
>> +}
>> +
>>  struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
>>  				xfs_extnum_t nextents);
>>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
>> index c44f8d06939b..a44d7b48c374 100644
>> --- a/fs/xfs/scrub/inode_repair.c
>> +++ b/fs/xfs/scrub/inode_repair.c
>> @@ -1198,7 +1198,7 @@ xrep_inode_blockcounts(
>>  			return error;
>>  		if (count >= sc->mp->m_sb.sb_dblocks)
>>  			return -EFSCORRUPTED;
>> -		if (nextents >= XFS_IFORK_EXTCNT_MAXS16)
>> +		if (nextents >= xfs_iext_max(sc->mp, XFS_ATTR_FORK))
>>  			return -EFSCORRUPTED;
>>  		ifp->if_nextents = nextents;
>>  	} else {
>> -- 
>> 2.30.2
>> 


-- 
chandan
