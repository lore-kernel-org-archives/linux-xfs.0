Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2B7C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 07:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E3560F91
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 07:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhG1He7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 03:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbhG1Hez (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 03:34:55 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACF0C0613C1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 00:34:54 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id f13so1658225plj.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 00:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=a9g4KomGdelkcV9LjVLr3GMzYksdfXYlIb5aR/DyUko=;
        b=XWQlY8FXKtrTDpv4SBq0CcaMIpjyb805QYMYI0BgCt9S36o9dXhHfS+vNWJc82EgFG
         oColl4ZPZybU+L4hTLMxJlmJDF9JWqV5zjtKBKHELZynX3GMtrM3bzXTz8vPW7+knvLH
         4uIR7D9j7Jd3xS2PkwFx+lvYThOBBLpBMWfKaWewBrdZtdgOanEzSM86+n2s63WmOHSj
         4HNy09cEl17nLIw3j+v0yBZ4llZVchbtzcjnIt3PY/oWtNAwaV1h/arX+Wj//t3YA+UN
         kmfiecqzY5PhbrcO4E/rNeZGVGQY0wHLL1+6jKkUHKQYET37Xa4P3ui0yu5HCdv5EXci
         49GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=a9g4KomGdelkcV9LjVLr3GMzYksdfXYlIb5aR/DyUko=;
        b=s/M7IJZEXtEJ5Giy7aNwTwgzLJ7vAa93cPkGsmqFZJsnXb+9n9Q8g4is7fnmCEXUBD
         eLfzAi9bZl3vGoZ2eCB/KEO656lPw1kP+8zLauPu+lA9tvEQl8KEYD2s73GtWfZh1tVT
         9cceJf4bBBgyAPkhDtPEB641wPnjHImut8xHo6m4/JeUeDWByPUKQAews7659RJRiFO+
         BmDkraqIjwm4e250S3nyIyxjKAtr72t+i+p/uyMUjHcXz+NK756MJSCKfKNqle72dhgE
         qxT7gWhz9PRf8D1d0gq7VMDskOLiHyaqG7IQOymnbb+ETQpb0kKDX0NJulqxF4JaF9gF
         PMKQ==
X-Gm-Message-State: AOAM531UDCKJDqIm9TGbD0UCAUxgleU4WZqnRrsNC99o9RdK/st0x074
        i6aeeVWJItaZFSwk+ybULWajNM0AE6AY9Q==
X-Google-Smtp-Source: ABdhPJzayUbtzg0xKNf1Yo/UZCTLbvE88uWcO708hAR7BTrOb9Q7jWBzHikoP30EbvJ+zwCMeERa5g==
X-Received: by 2002:a17:90a:458f:: with SMTP id v15mr22133389pjg.189.1627457693615;
        Wed, 28 Jul 2021 00:34:53 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id i9sm5118710pju.50.2021.07.28.00.34.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Jul 2021 00:34:53 -0700 (PDT)
References: <20210726114724.24956-1-chandanrlinux@gmail.com> <20210726114724.24956-6-chandanrlinux@gmail.com> <20210727231439.GX559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 05/12] xfsprogs: Introduce xfs_dfork_nextents() helper
In-reply-to: <20210727231439.GX559212@magnolia>
Date:   Wed, 28 Jul 2021 13:04:50 +0530
Message-ID: <871r7ix55x.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 04:44, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 05:17:17PM +0530, Chandan Babu R wrote:
>> This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
>> xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
>> value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
>> counter fields will add more logic to this helper.
>> 
>> This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
>> with calls to xfs_dfork_nextents().
>> 
>> No functional changes have been made.
>> 
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  db/bmap.c               |  6 ++--
>>  db/btdump.c             |  4 +--
>>  db/check.c              | 27 ++++++++++-------
>>  db/frag.c               |  6 ++--
>>  db/inode.c              | 14 +++++----
>>  db/metadump.c           |  4 +--
>>  libxfs/xfs_format.h     |  4 ---
>>  libxfs/xfs_inode_buf.c  | 43 +++++++++++++++++++++++----
>>  libxfs/xfs_inode_buf.h  |  2 ++
>>  libxfs/xfs_inode_fork.c | 11 ++++---
>>  repair/attr_repair.c    |  2 +-
>>  repair/bmap_repair.c    |  4 +--
>>  repair/dinode.c         | 66 ++++++++++++++++++++++++-----------------
>>  repair/prefetch.c       |  2 +-
>>  14 files changed, 123 insertions(+), 72 deletions(-)
>> 
>> diff --git a/db/bmap.c b/db/bmap.c
>> index 50f0474bc..5e1ab9258 100644
>> --- a/db/bmap.c
>> +++ b/db/bmap.c
>> @@ -68,7 +68,7 @@ bmap(
>>  	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
>>  		fmt == XFS_DINODE_FMT_BTREE);
>>  	if (fmt == XFS_DINODE_FMT_EXTENTS) {
>> -		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +		nextents = xfs_dfork_nextents(mp, dip, whichfork);
>>  		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>>  		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
>>  			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
>> @@ -158,9 +158,9 @@ bmap_f(
>>  		push_cur();
>>  		set_cur_inode(iocur_top->ino);
>>  		dip = iocur_top->data;
>> -		if (be32_to_cpu(dip->di_nextents))
>> +		if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK))
>>  			dfork = 1;
>> -		if (be16_to_cpu(dip->di_anextents))
>> +		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
>>  			afork = 1;
>>  		pop_cur();
>>  	}
>> diff --git a/db/btdump.c b/db/btdump.c
>> index 920f595b4..59609fd2d 100644
>> --- a/db/btdump.c
>> +++ b/db/btdump.c
>> @@ -166,13 +166,13 @@ dump_inode(
>>  
>>  	dip = iocur_top->data;
>>  	if (attrfork) {
>> -		if (!dip->di_anextents ||
>> +		if (!xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) ||
>>  		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
>>  			dbprintf(_("attr fork not in btree format\n"));
>>  			return 0;
>>  		}
>>  	} else {
>> -		if (!dip->di_nextents ||
>> +		if (!xfs_dfork_nextents(mp, dip, XFS_DATA_FORK) ||
>>  		    dip->di_format != XFS_DINODE_FMT_BTREE) {
>>  			dbprintf(_("data fork not in btree format\n"));
>>  			return 0;
>> diff --git a/db/check.c b/db/check.c
>> index 0d923e3ae..fe422e0ca 100644
>> --- a/db/check.c
>> +++ b/db/check.c
>> @@ -2720,7 +2720,7 @@ process_exinode(
>>  	xfs_bmbt_rec_t		*rp;
>>  
>>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>> -	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +	*nex = xfs_dfork_nextents(mp, dip, whichfork);
>>  	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
>>  						sizeof(xfs_bmbt_rec_t)) {
>>  		if (!sflag || id->ilist)
>> @@ -2744,12 +2744,14 @@ process_inode(
>>  	inodata_t		*id = NULL;
>>  	xfs_ino_t		ino;
>>  	xfs_extnum_t		nextents = 0;
>> +	xfs_extnum_t		dnextents;
>>  	int			security;
>>  	xfs_rfsblock_t		totblocks;
>>  	xfs_rfsblock_t		totdblocks = 0;
>>  	xfs_rfsblock_t		totiblocks = 0;
>>  	dbm_t			type;
>>  	xfs_extnum_t		anextents = 0;
>> +	xfs_extnum_t		danextents;
>>  	xfs_rfsblock_t		atotdblocks = 0;
>>  	xfs_rfsblock_t		atotiblocks = 0;
>>  	xfs_qcnt_t		bc = 0;
>> @@ -2878,14 +2880,17 @@ process_inode(
>>  		error++;
>>  		return;
>>  	}
>> +
>> +	dnextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>> +	danextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
>> +
>>  	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
>>  		dbprintf(_("inode %lld mode %#o fmt %s "
>>  			 "afmt %s "
>>  			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
>>  			id->ino, mode, fmtnames[(int)dip->di_format],
>>  			fmtnames[(int)dip->di_aformat],
>> -			be32_to_cpu(dip->di_nextents),
>> -			be16_to_cpu(dip->di_anextents),
>> +			dnextents, danextents,
>>  			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
>>  			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
>>  			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
>> @@ -2903,19 +2908,19 @@ process_inode(
>>  		if (xfs_sb_version_hasmetadir(&mp->m_sb) &&
>>  		    id->ino == mp->m_sb.sb_metadirino)
>>  			addlink_inode(id);
>> -		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>> +		blkmap = blkmap_alloc(dnextents);
>>  		break;
>>  	case S_IFREG:
>>  		if (diflags & XFS_DIFLAG_REALTIME)
>>  			type = DBM_RTDATA;
>>  		else if (id->ino == mp->m_sb.sb_rbmino) {
>>  			type = DBM_RTBITMAP;
>> -			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>> +			blkmap = blkmap_alloc(dnextents);
>>  			if (!xfs_sb_version_hasmetadir(&mp->m_sb))
>>  				addlink_inode(id);
>>  		} else if (id->ino == mp->m_sb.sb_rsumino) {
>>  			type = DBM_RTSUM;
>> -			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>> +			blkmap = blkmap_alloc(dnextents);
>>  			if (!xfs_sb_version_hasmetadir(&mp->m_sb))
>>  				addlink_inode(id);
>>  		}
>> @@ -2923,7 +2928,7 @@ process_inode(
>>  			 id->ino == mp->m_sb.sb_gquotino ||
>>  			 id->ino == mp->m_sb.sb_pquotino) {
>>  			type = DBM_QUOTA;
>> -			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>> +			blkmap = blkmap_alloc(dnextents);
>>  			if (!xfs_sb_version_hasmetadir(&mp->m_sb))
>>  				addlink_inode(id);
>>  		}
>> @@ -3006,17 +3011,17 @@ process_inode(
>>  				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
>>  		error++;
>>  	}
>> -	if (nextents != be32_to_cpu(dip->di_nextents)) {
>> +	if (nextents != dnextents) {
>>  		if (v)
>>  			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
>> -				be32_to_cpu(dip->di_nextents), id->ino, nextents);
>> +				dnextents, id->ino, nextents);
>>  		error++;
>>  	}
>> -	if (anextents != be16_to_cpu(dip->di_anextents)) {
>> +	if (anextents != danextents) {
>>  		if (v)
>>  			dbprintf(_("bad anextents %d for inode %lld, counted "
>>  				 "%d\n"),
>> -				be16_to_cpu(dip->di_anextents), id->ino, anextents);
>> +				danextents, id->ino, anextents);
>>  		error++;
>>  	}
>>  	if (type == DBM_DIR)
>> diff --git a/db/frag.c b/db/frag.c
>> index 90fa2131c..3e43a9a21 100644
>> --- a/db/frag.c
>> +++ b/db/frag.c
>> @@ -262,9 +262,11 @@ process_exinode(
>>  	int			whichfork)
>>  {
>>  	xfs_bmbt_rec_t		*rp;
>> +	xfs_extnum_t		nextents;
>>  
>>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>> -	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
>> +	nextents = xfs_dfork_nextents(mp, dip, whichfork);
>> +	process_bmbt_reclist(rp, nextents, extmapp);
>>  }
>>  
>>  static void
>> @@ -275,7 +277,7 @@ process_fork(
>>  	extmap_t	*extmap;
>>  	xfs_extnum_t	nex;
>>  
>> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +	nex = xfs_dfork_nextents(mp, dip, whichfork);
>>  	if (!nex)
>>  		return;
>>  	extmap = extmap_alloc(nex);
>> diff --git a/db/inode.c b/db/inode.c
>> index e59cff451..681f4f98a 100644
>> --- a/db/inode.c
>> +++ b/db/inode.c
>> @@ -278,7 +278,7 @@ inode_a_bmx_count(
>>  		return 0;
>>  	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
>>  	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
>> -		be16_to_cpu(dip->di_anextents) : 0;
>> +		xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) : 0;
>>  }
>>  
>>  static int
>> @@ -332,6 +332,7 @@ inode_a_size(
>>  {
>>  	struct xfs_attr_shortform	*asf;
>>  	xfs_dinode_t			*dip;
>> +	xfs_extnum_t			nextents;
>>  
>>  	ASSERT(startoff == 0);
>>  	ASSERT(idx == 0);
>> @@ -341,8 +342,8 @@ inode_a_size(
>>  		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
>>  		return bitize(be16_to_cpu(asf->hdr.totsize));
>>  	case XFS_DINODE_FMT_EXTENTS:
>> -		return (int)be16_to_cpu(dip->di_anextents) *
>> -							bitsz(xfs_bmbt_rec_t);
>> +		nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
>> +		return (int)nextents * bitsz(xfs_bmbt_rec_t);
>
> I think you can drop the cast (and convert the typedef) her.
>
>>  	case XFS_DINODE_FMT_BTREE:
>>  		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
>>  	default:
>> @@ -503,7 +504,7 @@ inode_u_bmx_count(
>>  	dip = obj;
>>  	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
>>  	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
>> -		be32_to_cpu(dip->di_nextents) : 0;
>> +		xfs_dfork_nextents(mp, dip, XFS_DATA_FORK) : 0;
>>  }
>>  
>>  static int
>> @@ -589,6 +590,7 @@ inode_u_size(
>>  	int		idx)
>>  {
>>  	xfs_dinode_t	*dip;
>> +	xfs_extnum_t	nextents;
>>  
>>  	ASSERT(startoff == 0);
>>  	ASSERT(idx == 0);
>> @@ -599,8 +601,8 @@ inode_u_size(
>>  	case XFS_DINODE_FMT_LOCAL:
>>  		return bitize((int)be64_to_cpu(dip->di_size));
>>  	case XFS_DINODE_FMT_EXTENTS:
>> -		return (int)be32_to_cpu(dip->di_nextents) *
>> -						bitsz(xfs_bmbt_rec_t);
>> +		nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>> +		return (int)nextents * bitsz(xfs_bmbt_rec_t);
>
> ...and here.
>

Ok. I will apply the two review comments before posting the next version.

> The rest of the db/repair changes look good.
>
> --D

-- 
chandan
