Return-Path: <SRS0=bIZx=BU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94975C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 23:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D249206C3
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 23:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHJXVp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 19:21:45 -0400
Received: from sandeen.net ([63.231.237.45]:47474 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbgHJXVp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Aug 2020 19:21:45 -0400
Received: from [10.0.0.11] (liberator [10.0.0.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 823D215B02;
        Mon, 10 Aug 2020 18:21:19 -0500 (CDT)
Subject: Re: [PATCH 1/3] xfs_db: stop misusing an onstack inode
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159476319690.3156851.8364082533532014066.stgit@magnolia>
 <159476320311.3156851.15212854498898688157.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCVFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgAUCUzMzbAIZAQAKCRAgrhaS4T3e4Fr7D/wO+fenqVvHjq21SCjDCrt8HdVj
 aJ28B1SqSU2toxyg5I160GllAxEHpLFGdbFAhQfBtnmlY9eMjwmJb0sCIrkrB6XNPSPA/B2B
 UPISh0z2odJv35/euJF71qIFgWzp2czJHkHWwVZaZpMWWNvsLIroXoR+uA9c2V1hQFVAJZyk
 EE4xzfm1+oVtjIC12B9tTCuS00pY3AUy21yzNowT6SSk7HAzmtG/PJ/uSB5wEkwldB6jVs2A
 sjOg1wMwVvh/JHilsQg4HSmDfObmZj1d0RWlMWcUE7csRnCE0ZWBMp/ttTn+oosioGa09HAS
 9jAnauznmYg43oQ5Akd8iQRxz5I58F/+JsdKvWiyrPDfYZtFS+UIgWD7x+mHBZ53Qjazszox
 gjwO9ehZpwUQxBm4I0lPDAKw3HJA+GwwiubTSlq5PS3P7QoCjaV8llH1bNFZMz2o8wPANiDx
 5FHgpRVgwLHakoCU1Gc+LXHXBzDXt7Cj02WYHdFzMm2hXaslRdhNGowLo1SXZFXa41KGTlNe
 4di53y9CK5ynV0z+YUa+5LR6RdHrHtgywdKnjeWdqhoVpsWIeORtwWGX8evNOiKJ7j0RsHha
 WrePTubr5nuYTDsQqgc2r4aBIOpeSRR2brlT/UE3wGgy9LY78L4EwPR0MzzecfE1Ws60iSqw
 Pu3vhb7h3bkCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJ
 X4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTEajUY0Up+b3ErOpLpZwhvgWatjifpj6bB
 SKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA
 2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuC
 GV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG5
 1u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
 Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQHngeN5fPx
 ze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3jAQnsWTru4RV
 TZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5etheLMO
 gRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQY
 AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0ki
 YPveGoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWN
 mcQT78hBeGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/
 LKjxnTedX0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
 LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0
 MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+
 JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBO
 Pk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/
 m1F3vYvdlE4p2ts1mmixMF7KajN9/E5RQtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlf
 fWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLX pA==
Message-ID: <a363fb32-1f78-5af3-d830-0ccdf806c164@sandeen.net>
Date:   Mon, 10 Aug 2020 18:21:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <159476320311.3156851.15212854498898688157.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/14/20 2:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The onstack inode in xfs_check's process_inode is a potential landmine
> since it's not a /real/ incore inode.  The upcoming 5.8 merge will make
> this messier wrt inode forks, so just remove the onstack inode and
> reference the ondisk fields directly.  This also reduces the amount of
> thinking that I have to do w.r.t. future libxfs porting efforts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I ended up merging & testing the original patch last week, and Darrick's
recent response indicates that likely only the cosmetic changes seemed
worth making; given that I've already run regression on this patch as is,
I'm going to go ahead & give it my rvb, and keep it merged.  We can clean
up the other stuff in another patch if needed.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/check.c |  100 ++++++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 56 insertions(+), 44 deletions(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 12c03b6d..96abea21 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2707,7 +2707,6 @@ process_inode(
>  {
>  	blkmap_t		*blkmap;
>  	xfs_fsblock_t		bno = 0;
> -	struct xfs_inode	xino;
>  	inodata_t		*id = NULL;
>  	xfs_ino_t		ino;
>  	xfs_extnum_t		nextents = 0;
> @@ -2724,6 +2723,12 @@ process_inode(
>  	xfs_qcnt_t		rc = 0;
>  	int			v = 0;
>  	mode_t			mode;
> +	uint16_t		diflags;
> +	uint64_t		diflags2 = 0;
> +	xfs_nlink_t		nlink;
> +	xfs_dqid_t		uid;
> +	xfs_dqid_t		gid;
> +	xfs_dqid_t		prid;
>  	static char		okfmts[] = {
>  		0,				/* type 0 unused */
>  		1 << XFS_DINODE_FMT_DEV,	/* FIFO */
> @@ -2750,10 +2755,6 @@ process_inode(
>  		"dev", "local", "extents", "btree", "uuid"
>  	};
>  
> -	/* xfs_inode_from_disk expects to have an mp to work with */
> -	xino.i_mount = mp;
> -	libxfs_inode_from_disk(&xino, dip);
> -
>  	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
>  	if (!isfree) {
>  		id = find_inode(ino, 1);
> @@ -2775,12 +2776,25 @@ process_inode(
>  		error++;
>  		return;
>  	}
> +	if (dip->di_version == 1) {
> +		nlink = be16_to_cpu(dip->di_onlink);
> +		prid = 0;
> +	} else {
> +		nlink = be32_to_cpu(dip->di_nlink);
> +		prid = (xfs_dqid_t)be16_to_cpu(dip->di_projid_hi) << 16 |
> +				   be16_to_cpu(dip->di_projid_lo);
> +	}
> +	uid = be32_to_cpu(dip->di_uid);
> +	gid = be32_to_cpu(dip->di_gid);
> +	diflags = be16_to_cpu(dip->di_flags);
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb))
> +		diflags2 = be64_to_cpu(dip->di_flags2);
>  	if (isfree) {
> -		if (xino.i_d.di_nblocks != 0) {
> +		if (be64_to_cpu(dip->di_nblocks) != 0) {
>  			if (v)
>  				dbprintf(_("bad nblocks %lld for free inode "
>  					 "%lld\n"),
> -					xino.i_d.di_nblocks, ino);
> +					be64_to_cpu(dip->di_nblocks), ino);
>  			error++;
>  		}
>  		if (dip->di_nlink != 0) {
> @@ -2809,24 +2823,24 @@ process_inode(
>  	 */
>  	mode = be16_to_cpu(dip->di_mode);
>  	if ((((mode & S_IFMT) >> 12) > 15) ||
> -	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << xino.i_d.di_format)))) {
> +	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << dip->di_format)))) {
>  		if (v)
>  			dbprintf(_("bad format %d for inode %lld type %#o\n"),
> -				xino.i_d.di_format, id->ino, mode & S_IFMT);
> +				dip->di_format, id->ino, mode & S_IFMT);
>  		error++;
>  		return;
>  	}
>  	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >= XFS_LITINO(mp)) {
>  		if (v)
>  			dbprintf(_("bad fork offset %d for inode %lld\n"),
> -				xino.i_d.di_forkoff, id->ino);
> +				dip->di_forkoff, id->ino);
>  		error++;
>  		return;
>  	}
> -	if ((unsigned int)xino.i_d.di_aformat > XFS_DINODE_FMT_BTREE)  {
> +	if ((unsigned int)dip->di_aformat > XFS_DINODE_FMT_BTREE)  {
>  		if (v)
>  			dbprintf(_("bad attribute format %d for inode %lld\n"),
> -				xino.i_d.di_aformat, id->ino);
> +				dip->di_aformat, id->ino);
>  		error++;
>  		return;
>  	}
> @@ -2834,43 +2848,43 @@ process_inode(
>  		dbprintf(_("inode %lld mode %#o fmt %s "
>  			 "afmt %s "
>  			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
> -			id->ino, mode, fmtnames[(int)xino.i_d.di_format],
> -			fmtnames[(int)xino.i_d.di_aformat],
> -			xino.i_d.di_nextents,
> -			xino.i_d.di_anextents,
> -			xino.i_d.di_nblocks, xino.i_d.di_size,
> -			xino.i_d.di_flags & XFS_DIFLAG_REALTIME ? " rt" : "",
> -			xino.i_d.di_flags & XFS_DIFLAG_PREALLOC ? " pre" : "",
> -			xino.i_d.di_flags & XFS_DIFLAG_IMMUTABLE? " imm" : "",
> -			xino.i_d.di_flags & XFS_DIFLAG_APPEND   ? " app" : "",
> -			xino.i_d.di_flags & XFS_DIFLAG_SYNC     ? " syn" : "",
> -			xino.i_d.di_flags & XFS_DIFLAG_NOATIME  ? " noa" : "",
> -			xino.i_d.di_flags & XFS_DIFLAG_NODUMP   ? " nod" : "");
> +			id->ino, mode, fmtnames[(int)dip->di_format],
> +			fmtnames[(int)dip->di_aformat],
> +			be32_to_cpu(dip->di_nextents),
> +			be16_to_cpu(dip->di_anextents),
> +			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
> +			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
> +			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
> +			diflags & XFS_DIFLAG_IMMUTABLE? " imm" : "",
> +			diflags & XFS_DIFLAG_APPEND   ? " app" : "",
> +			diflags & XFS_DIFLAG_SYNC     ? " syn" : "",
> +			diflags & XFS_DIFLAG_NOATIME  ? " noa" : "",
> +			diflags & XFS_DIFLAG_NODUMP   ? " nod" : "");
>  	security = 0;
>  	switch (mode & S_IFMT) {
>  	case S_IFDIR:
>  		type = DBM_DIR;
> -		if (xino.i_d.di_format == XFS_DINODE_FMT_LOCAL)
> +		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
>  			break;
> -		blkmap = blkmap_alloc(xino.i_d.di_nextents);
> +		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>  		break;
>  	case S_IFREG:
> -		if (xino.i_d.di_flags & XFS_DIFLAG_REALTIME)
> +		if (diflags & XFS_DIFLAG_REALTIME)
>  			type = DBM_RTDATA;
>  		else if (id->ino == mp->m_sb.sb_rbmino) {
>  			type = DBM_RTBITMAP;
> -			blkmap = blkmap_alloc(xino.i_d.di_nextents);
> +			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>  			addlink_inode(id);
>  		} else if (id->ino == mp->m_sb.sb_rsumino) {
>  			type = DBM_RTSUM;
> -			blkmap = blkmap_alloc(xino.i_d.di_nextents);
> +			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>  			addlink_inode(id);
>  		}
>  		else if (id->ino == mp->m_sb.sb_uquotino ||
>  			 id->ino == mp->m_sb.sb_gquotino ||
>  			 id->ino == mp->m_sb.sb_pquotino) {
>  			type = DBM_QUOTA;
> -			blkmap = blkmap_alloc(xino.i_d.di_nextents);
> +			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
>  			addlink_inode(id);
>  		}
>  		else
> @@ -2887,10 +2901,10 @@ process_inode(
>  		break;
>  	}
>  
> -	id->isreflink = !!(xino.i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
> -	setlink_inode(id, VFS_I(&xino)->i_nlink, type == DBM_DIR, security);
> +	id->isreflink = !!(diflags2 & XFS_DIFLAG2_REFLINK);
> +	setlink_inode(id, nlink, type == DBM_DIR, security);
>  
> -	switch (xino.i_d.di_format) {
> +	switch (dip->di_format) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		process_lclinode(id, dip, type, &totdblocks, &totiblocks,
>  			&nextents, &blkmap, XFS_DATA_FORK);
> @@ -2906,7 +2920,7 @@ process_inode(
>  	}
>  	if (XFS_DFORK_Q(dip)) {
>  		sbversion |= XFS_SB_VERSION_ATTRBIT;
> -		switch (xino.i_d.di_aformat) {
> +		switch (dip->di_aformat) {
>  		case XFS_DINODE_FMT_LOCAL:
>  			process_lclinode(id, dip, DBM_ATTR, &atotdblocks,
>  				&atotiblocks, &anextents, NULL, XFS_ATTR_FORK);
> @@ -2941,30 +2955,28 @@ process_inode(
>  		default:
>  			break;
>  		}
> -		if (ic) {
> -			quota_add(&xino.i_d.di_projid, &VFS_I(&xino)->i_gid,
> -				  &VFS_I(&xino)->i_uid, 0, bc, ic, rc);
> -		}
> +		if (ic)
> +			quota_add(&prid, &gid, &uid, 0, bc, ic, rc);
>  	}
>  	totblocks = totdblocks + totiblocks + atotdblocks + atotiblocks;
> -	if (totblocks != xino.i_d.di_nblocks) {
> +	if (totblocks != be64_to_cpu(dip->di_nblocks)) {
>  		if (v)
>  			dbprintf(_("bad nblocks %lld for inode %lld, counted "
>  				 "%lld\n"),
> -				xino.i_d.di_nblocks, id->ino, totblocks);
> +				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
>  		error++;
>  	}
> -	if (nextents != xino.i_d.di_nextents) {
> +	if (nextents != be32_to_cpu(dip->di_nextents)) {
>  		if (v)
>  			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
> -				xino.i_d.di_nextents, id->ino, nextents);
> +				be32_to_cpu(dip->di_nextents), id->ino, nextents);
>  		error++;
>  	}
> -	if (anextents != xino.i_d.di_anextents) {
> +	if (anextents != be16_to_cpu(dip->di_anextents)) {
>  		if (v)
>  			dbprintf(_("bad anextents %d for inode %lld, counted "
>  				 "%d\n"),
> -				xino.i_d.di_anextents, id->ino, anextents);
> +				be16_to_cpu(dip->di_anextents), id->ino, anextents);
>  		error++;
>  	}
>  	if (type == DBM_DIR)
> 
