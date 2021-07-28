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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0191C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 03:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C56F060F9C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 03:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhG1Dic (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 23:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbhG1Dic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 23:38:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E332C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 20:38:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so2415577pjd.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 20:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=XNOdi0qbU2/0UQJ2lQLOdpH70YjVAhm3i/1Ir+KL8Wk=;
        b=nX/oorK5rZgKwVN/iJS/VzXZY69/vwyD3Cw1A85Jm06a45FCBNNPnvQKYV5VLGYjez
         MhkKYVeooE3PK+qv2pOZUMr9sdoGf23WywHwYNGgVHPjlvouniUOkPI/oKfK5k+dtHhM
         QFK2Djyy6/W8x6tIq0RtFVgL/Tz3xo/bgGQdEk0jaFZ1zvwWTvFBPS4IsDxZQnLmwf83
         lhX1voWkQ70ZG3nypAQdO+6a/UjOxmPgV018wbY2erunzNmNL9bexG4dkb396M1ivjf1
         nMhW71I0h7dFlGloWuZSrImu4GswqSV7rOU5SoNkZrr8NZo6ANJtiwbPdQiFQ0J+nLOO
         ywIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=XNOdi0qbU2/0UQJ2lQLOdpH70YjVAhm3i/1Ir+KL8Wk=;
        b=uepTbhIgJXUiYou6H45GOoTAYdpEZvT/C3ZQU6PrOpgPRj/irX0Jzq4BI7akbcZGer
         maKzvV/yCdbxML+a6ylyLQu5IJx86YqPzrMYMG6D7xw/v5S7tXuXa2Vp6HXrMS6zcv8k
         6sTHrcEdsSIHHHzQLHXDssoLmDsUAIXVz4y+0+cY8Ckm4jLSrBOV203GPueuaSKwwKYd
         QOMXTLOm5Lz1OArmRfR/huC32LvGCXdUshkvGmz3MWPZqQj9VvxEEI5morKScAeDhMWD
         f8+J3Z4veLgZ+ZMPG9PxV1J1oWlZjdDeqjAr5mB7wswu5LDfHXAW4hhHMcUMbw7XcrWZ
         Dhvg==
X-Gm-Message-State: AOAM532i6vTtretrFQ5FA0qNGcSgmQtzswpX7iii8tys5rNo/MDULUFv
        pctB6jfoXjf6PnKZXEpMmd3HyEkHVO5+Qg==
X-Google-Smtp-Source: ABdhPJzbkf0nXPfii4Pt/p/W5Cf2gUWTQcGaCmNmRjcphF77FxzMa0NVl1Pi9K0ar7CwPHWxIDPGNA==
X-Received: by 2002:a63:fe51:: with SMTP id x17mr26662638pgj.58.1627443510893;
        Tue, 27 Jul 2021 20:38:30 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id q17sm6166882pgd.39.2021.07.27.20.38.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 20:38:30 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-5-chandanrlinux@gmail.com> <20210727215924.GM559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 04/12] xfs: Use xfs_extnum_t instead of basic data types
In-reply-to: <20210727215924.GM559212@magnolia>
Date:   Wed, 28 Jul 2021 09:08:28 +0530
Message-ID: <87bl6nw1jf.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 03:29, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 05:15:33PM +0530, Chandan Babu R wrote:
>> xfs_extnum_t is the type to use to declare variables which have values
>> obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
>> types (e.g. uint32_t) with xfs_extnum_t for such variables.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>
> Not sure why the structure members change places, but otherwise LGTM.

The re-arrangement of local variables was supposed to happen in the patch
where "xfs_[a]extnum_t" get promoted to larger data types. I will make those
movements happen in that patch.

>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the review.

>
> --D
>
>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c       | 2 +-
>>  fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
>>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>>  fs/xfs/scrub/inode.c           | 2 +-
>>  fs/xfs/scrub/inode_repair.c    | 2 +-
>>  fs/xfs/xfs_trace.h             | 2 +-
>>  6 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 282aeb3c0e49..e5d243fd187d 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -53,9 +53,9 @@ xfs_bmap_compute_maxlevels(
>>  	xfs_mount_t	*mp,		/* file system mount structure */
>>  	int		whichfork)	/* data or attr fork */
>>  {
>> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>>  	int		level;		/* btree level */
>>  	uint		maxblocks;	/* max blocks at this level */
>> -	uint		maxleafents;	/* max leaf entries possible */
>>  	int		maxrootrecs;	/* max records in root block */
>>  	int		minleafrecs;	/* min records in leaf block */
>>  	int		minnoderecs;	/* min records in node block */
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 419b92dc6ac8..cba9a38f3270 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -342,7 +342,7 @@ xfs_dinode_verify_fork(
>>  	struct xfs_mount	*mp,
>>  	int			whichfork)
>>  {
>> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>>  	xfs_extnum_t		max_extents;
>>
>>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index c6856ec95335..a1e40df585a3 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -107,7 +107,7 @@ xfs_iformat_extents(
>>  	struct xfs_mount	*mp = ip->i_mount;
>>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>>  	int			state = xfs_bmap_fork_to_state(whichfork);
>> -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>>  	struct xfs_iext_cursor	icur;
>>  	struct xfs_bmbt_rec	*dp;
>> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
>> index e6068590484b..246d11ca133f 100644
>> --- a/fs/xfs/scrub/inode.c
>> +++ b/fs/xfs/scrub/inode.c
>> @@ -219,7 +219,7 @@ xchk_dinode(
>>  	size_t			fork_recs;
>>  	unsigned long long	isize;
>>  	uint64_t		flags2;
>> -	uint32_t		nextents;
>> +	xfs_extnum_t		nextents;
>>  	prid_t			prid;
>>  	uint16_t		flags;
>>  	uint16_t		mode;
>> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
>> index a44d7b48c374..042c7d0bc0f5 100644
>> --- a/fs/xfs/scrub/inode_repair.c
>> +++ b/fs/xfs/scrub/inode_repair.c
>> @@ -597,9 +597,9 @@ xrep_dinode_bad_extents_fork(
>>  {
>>  	struct xfs_bmbt_irec	new;
>>  	struct xfs_bmbt_rec	*dp;
>> +	xfs_extnum_t		nex;
>>  	bool			isrt;
>>  	int			i;
>> -	int			nex;
>>  	int			fork_size;
>>
>>  	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index affc9b5834fb..5ed11f894f79 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -2338,7 +2338,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>>  		__field(int, which)
>>  		__field(xfs_ino_t, ino)
>>  		__field(int, format)
>> -		__field(int, nex)
>> +		__field(xfs_extnum_t, nex)
>>  		__field(int, broot_size)
>>  		__field(int, fork_off)
>>  	),
>> --
>> 2.30.2
>>


--
chandan
