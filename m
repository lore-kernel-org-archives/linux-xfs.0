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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DBAC432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 04:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C81060C3F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 04:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhG1EVy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 00:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhG1EVx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 00:21:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAD3C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 21:21:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso2403158pjo.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 21:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=xxyP222bD5idyE2eeHpHY4g8v8jEpusfDGMinKX3moU=;
        b=a44/aMARX3AC/jbyGYgM3fSPbEc4rWcwxdgl7q5cinqbsa7K4rE+UPovqhqrdqnJzD
         d0RV7vtXToGu5IqQ30YPLfZtIM/qUjy3LPofOvP2Jgu+6RnRlOv71HemKlhUNZ3vxAgK
         gk0HhXhvYA4hJqN83AvuZzDyg6JGf0ANYXtV2mUcAeSJ8E1EBRRgqKvjAx8wt4MKY8Yq
         k/BZFMFEHD9+gVOYsd7jthhJ4eKQhUMRhJ5itmBJ4DgMWw8rjWRhedvKKFkkqJmwh63O
         wvqOnvHGadRfRV3/fxp1R0fiQHmrWEHAc/JS3u1vMkbBT7qi3CRU89RYUZIpGim7mHGO
         EVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=xxyP222bD5idyE2eeHpHY4g8v8jEpusfDGMinKX3moU=;
        b=TcjbhQ2wJHuY2CiWMy7OloglvZHfA00Va6T81f5z8Qb29xMSDVK1IAbUBqEDu6ORl4
         qulZb882SgY4qNgqlxmba7X9ma9yAqWcHlNqDhJOt0BN8Mqq3YsmbYj7n03fecMyScyC
         IsUdF28xctF5CggBnpqsDsV+39kYfpexk8ELawEzrsej7zbVEDo3EDgNGDPm3a052ffm
         uq9JS4ucYXPIST0QiRcGWLyk5MaD+b+N4K4XQvjgCfXvdONxVJfUViEAFrN3/89fNdpF
         6Oqbfzsign/M849oSaXybYcVTesVGwnaJahitraetVsZfzftyaEYPJ64NPj88Ec32puc
         Rhsg==
X-Gm-Message-State: AOAM530FYjwZK3lcLD64+5DIa3wRqH1rIAaYdMUz0fqgXannFIbKzVuu
        tLyM7opPs44Ecavrh5mWfn9UiVEzT6V1wg==
X-Google-Smtp-Source: ABdhPJw9RP3LqpU91NuhkJT2efgm8UCkPbMhoMq7RD2OmVL5S7Rcb6y/UGW41UDYZqAtFXebMDpGDg==
X-Received: by 2002:a63:1309:: with SMTP id i9mr26297402pgl.216.1627446111589;
        Tue, 27 Jul 2021 21:21:51 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id s24sm5395599pfg.186.2021.07.27.21.21.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 21:21:51 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-7-chandanrlinux@gmail.com> <20210727222215.GP559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 06/12] xfs: xfs_dfork_nextents: Return extent count via an out argument
In-reply-to: <20210727222215.GP559212@magnolia>
Date:   Wed, 28 Jul 2021 09:51:48 +0530
Message-ID: <878s1rvzj7.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 03:52, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 05:15:35PM +0530, Chandan Babu R wrote:
>> This commit changes xfs_dfork_nextents() to return an error code. The extent
>> count itself is now returned through an out argument. This facility will be
>> used by a future commit to indicate an inconsistent ondisk extent count.
>> 
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  fs/xfs/libxfs/xfs_inode_buf.c  | 29 +++++++----
>>  fs/xfs/libxfs/xfs_inode_buf.h  |  4 +-
>>  fs/xfs/libxfs/xfs_inode_fork.c | 22 ++++++--
>>  fs/xfs/scrub/inode.c           | 94 +++++++++++++++++++++-------------
>>  fs/xfs/scrub/inode_repair.c    | 34 ++++++++----
>>  5 files changed, 119 insertions(+), 64 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 6bef0757fca4..9ed04da2e2b1 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -345,7 +345,8 @@ xfs_dinode_verify_fork(
>>  	xfs_extnum_t		di_nextents;
>>  	xfs_extnum_t		max_extents;
>>  
>> -	di_nextents = xfs_dfork_nextents(mp, dip, whichfork);
>> +	if (xfs_dfork_nextents(mp, dip, whichfork, &di_nextents))
>> +		return __this_address;
>>  
>>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>>  	case XFS_DINODE_FMT_LOCAL:
>> @@ -377,29 +378,31 @@ xfs_dinode_verify_fork(
>>  	return NULL;
>>  }
>>  
>> -xfs_extnum_t
>> +int
>>  xfs_dfork_nextents(
>>  	struct xfs_mount	*mp,
>>  	struct xfs_dinode	*dip,
>> -	int			whichfork)
>> +	int			whichfork,
>> +	xfs_extnum_t		*nextents)
>>  {
>> -	xfs_extnum_t		nextents = 0;
>> +	int			error = 0;
>>  
>>  	switch (whichfork) {
>>  	case XFS_DATA_FORK:
>> -		nextents = be32_to_cpu(dip->di_nextents);
>> +		*nextents = be32_to_cpu(dip->di_nextents);
>>  		break;
>>  
>>  	case XFS_ATTR_FORK:
>> -		nextents = be16_to_cpu(dip->di_anextents);
>> +		*nextents = be16_to_cpu(dip->di_anextents);
>>  		break;
>>  
>>  	default:
>>  		ASSERT(0);
>> +		error = -EINVAL;
>
> -EFSCORRUPTED?  We don't have a specific code for "your darn software
> screwed up, hyuck!!" but I guess this will at least get peoples'
> attention.

Ok. I will update this.

>
>>  		break;
>>  	}
>>  
>> -	return nextents;
>> +	return error;
>>  }
>>  
>>  static xfs_failaddr_t
>> @@ -502,6 +505,7 @@ xfs_dinode_verify(
>>  	uint64_t		flags2;
>>  	uint64_t		di_size;
>>  	xfs_extnum_t            nextents;
>> +	xfs_extnum_t            naextents;
>>  	int64_t			nblocks;
>>  
>>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>> @@ -533,8 +537,13 @@ xfs_dinode_verify(
>>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>>  		return __this_address;
>>  
>> -	nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>> -	nextents += xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
>> +	if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents))
>> +		return __this_address;
>> +
>> +	if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &naextents))
>> +		return __this_address;
>> +
>> +	nextents += naextents;
>>  	nblocks = be64_to_cpu(dip->di_nblocks);
>>  
>>  	/* Fork checks carried over from xfs_iformat_fork */
>> @@ -595,7 +604,7 @@ xfs_dinode_verify(
>>  		default:
>>  			return __this_address;
>>  		}
>> -		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
>> +		if (naextents)
>>  			return __this_address;
>>  	}
>>  
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
>> index ea2c35091609..20f796610d46 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.h
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
>> @@ -36,8 +36,8 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
>>  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
>>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>>  		uint64_t flags2);
>> -xfs_extnum_t xfs_dfork_nextents(struct xfs_mount *mp, struct xfs_dinode *dip,
>> -		int whichfork);
>> +int xfs_dfork_nextents(struct xfs_mount *mp, struct xfs_dinode *dip,
>> +		int whichfork, xfs_extnum_t *nextents);
>>  
>>  static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
>>  {
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index 38dd2dfc31fa..7f7ffe29436d 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -107,13 +107,20 @@ xfs_iformat_extents(
>>  	struct xfs_mount	*mp = ip->i_mount;
>>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>>  	int			state = xfs_bmap_fork_to_state(whichfork);
>> -	xfs_extnum_t		nex = xfs_dfork_nextents(mp, dip, whichfork);
>> -	int			size = nex * sizeof(xfs_bmbt_rec_t);
>> +	xfs_extnum_t		nex;
>> +	int			size;
>>  	struct xfs_iext_cursor	icur;
>>  	struct xfs_bmbt_rec	*dp;
>>  	struct xfs_bmbt_irec	new;
>> +	int			error;
>>  	int			i;
>>  
>> +	error = xfs_dfork_nextents(mp, dip, whichfork, &nex);
>> +	if (error)
>> +		return error;
>> +
>> +	size = nex * sizeof(xfs_bmbt_rec_t);
>
> sizeof(struct xfs_bmbt_rec);
>
> (Please convert the old typedef usage when possible.)

Sure. I will go through the patchset and update relevant code.

>
>> +
>>  	/*
>>  	 * If the number of extents is unreasonable, then something is wrong and
>>  	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
>> @@ -235,7 +242,10 @@ xfs_iformat_data_fork(
>>  	 * depend on it.
>>  	 */
>>  	ip->i_df.if_format = dip->di_format;
>> -	ip->i_df.if_nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>> +	error = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK,
>> +			&ip->i_df.if_nextents);
>> +	if (error)
>> +		return error;
>>  
>>  	switch (inode->i_mode & S_IFMT) {
>>  	case S_IFIFO:
>> @@ -304,9 +314,11 @@ xfs_iformat_attr_fork(
>>  {
>>  	struct xfs_mount	*mp = ip->i_mount;
>>  	xfs_extnum_t		nextents;
>> -	int			error = 0;
>> +	int			error;
>>  
>> -	nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
>> +	error = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &nextents);
>> +	if (error)
>> +		return error;
>>  
>>  	/*
>>  	 * Initialize the extent count early, as the per-format routines may
>> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
>> index a161dac31a6f..e9dc3749ea08 100644
>> --- a/fs/xfs/scrub/inode.c
>> +++ b/fs/xfs/scrub/inode.c
>> @@ -208,6 +208,44 @@ xchk_dinode_nsec(
>>  		xchk_ino_set_corrupt(sc, ino);
>>  }
>>  
>> +STATIC void
>> +xchk_dinode_fork_recs(
>> +	struct xfs_scrub	*sc,
>> +	struct xfs_dinode	*dip,
>> +	xfs_ino_t		ino,
>> +	xfs_extnum_t		nextents,
>> +	int			whichfork)
>> +{
>> +	struct xfs_mount	*mp = sc->mp;
>> +	size_t			fork_recs;
>> +	unsigned char		format;
>> +
>> +	if (whichfork == XFS_DATA_FORK) {
>> +		fork_recs =  XFS_DFORK_DSIZE(dip, mp)
>> +			/ sizeof(struct xfs_bmbt_rec);
>> +		format = dip->di_format;
>> +	} else if (whichfork == XFS_ATTR_FORK) {
>> +		fork_recs =  XFS_DFORK_ASIZE(dip, mp)
>> +			/ sizeof(struct xfs_bmbt_rec);
>> +		format = dip->di_aformat;
>> +	}
>
> 	fork_recs = XFS_DFORK_SIZE(dip, mp, whichfork);
> 	format = XFS_DFORK_FORMAT(dip, whichfork);
>
> ?

I agree. This increases readability of code.

>
>> +
>> +	switch (format) {
>> +	case XFS_DINODE_FMT_EXTENTS:
>> +		if (nextents > fork_recs)
>> +			xchk_ino_set_corrupt(sc, ino);
>> +		break;
>> +	case XFS_DINODE_FMT_BTREE:
>> +		if (nextents <= fork_recs)
>> +			xchk_ino_set_corrupt(sc, ino);
>> +		break;
>> +	default:
>> +		if (nextents != 0)
>> +			xchk_ino_set_corrupt(sc, ino);
>> +		break;
>> +	}
>> +}
>> +
>>  /* Scrub all the ondisk inode fields. */
>>  STATIC void
>>  xchk_dinode(
>> @@ -216,7 +254,6 @@ xchk_dinode(
>>  	xfs_ino_t		ino)
>>  {
>>  	struct xfs_mount	*mp = sc->mp;
>> -	size_t			fork_recs;
>>  	unsigned long long	isize;
>>  	uint64_t		flags2;
>>  	xfs_extnum_t		nextents;
>> @@ -224,6 +261,7 @@ xchk_dinode(
>>  	prid_t			prid;
>>  	uint16_t		flags;
>>  	uint16_t		mode;
>> +	int			error;
>>  
>>  	flags = be16_to_cpu(dip->di_flags);
>>  	if (dip->di_version >= 3)
>> @@ -379,33 +417,22 @@ xchk_dinode(
>>  	xchk_inode_extsize(sc, dip, ino, mode, flags);
>>  
>>  	/* di_nextents */
>> -	nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>> -	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>> -	switch (dip->di_format) {
>> -	case XFS_DINODE_FMT_EXTENTS:
>> -		if (nextents > fork_recs)
>> -			xchk_ino_set_corrupt(sc, ino);
>> -		break;
>> -	case XFS_DINODE_FMT_BTREE:
>> -		if (nextents <= fork_recs)
>> -			xchk_ino_set_corrupt(sc, ino);
>> -		break;
>> -	default:
>> -		if (nextents != 0)
>> -			xchk_ino_set_corrupt(sc, ino);
>> -		break;
>> -	}
>> -
>> -	naextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
>> +	error = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents);
>> +	if (error)
>> +		xchk_ino_set_corrupt(sc, ino);
>> +	else
>
> 	error = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents);
> 	if (error) {
> 		xchk_ino_set_corrupt(sc, ino);
> 		return;
> 	}
> 	xchk_dinode_fork_recs(sc, dip, ino, nextents, XFS_DATA_FORK);
>
> At this point you might as well return; you have sufficient information
> to generate the corruption report for userspace.

Ok. I will update.

>
>> +		xchk_dinode_fork_recs(sc, dip, ino, nextents, XFS_DATA_FORK);
>>  
>>  	/* di_forkoff */
>>  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
>>  		xchk_ino_set_corrupt(sc, ino);
>> -	if (naextents != 0 && dip->di_forkoff == 0)
>> -		xchk_ino_set_corrupt(sc, ino);
>>  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
>>  		xchk_ino_set_corrupt(sc, ino);
>>  
>> +	error = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &naextents);
>> +	if (error || (naextents != 0 && dip->di_forkoff == 0))
>> +		xchk_ino_set_corrupt(sc, ino);
>
> Please keep these separate so that the debug tracepoints can capture
> them as separate corruption sources.  Also, if xfs_dfork_nextents
> returns an error, you might as well return since we have enough data to
> generate the corruption report.
>

Ok. I will update this as well.

> (The rest of the scrub and repair code changes look good, btw.)

Thanks for the review.

-- 
chandan
