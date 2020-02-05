Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E78AC35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C351421582
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:50:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XHrz55Qi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgBEAui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:50:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36732 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgBEAui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:50:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150mACH109097;
        Wed, 5 Feb 2020 00:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=GQGZM3R32OejC6De2GI0TRV+3NJUH14VFnH6WCUrKYc=;
 b=XHrz55Qi4gfZHOF/rRJaeHITipjRX8Cs7ezpx1WmCkZi9nVCY+tL9zO58YFqjLkEMZAd
 FImAOj0sZVbVkKFP+yFIdlTJ4cZc+za46kQRIH6nB3EgH+r7q+Mxe1be1Kh1OYFZNG3p
 8oXd0A7gsX6CFnXoGAS9hboDZL6b/UHPLoQfEa3iJeiJbQm0iViVVG9EDk/pAdsWw6J2
 kl9kb0DS3smrqy/eY3O4LyOlMPIHGhjiJSosbKWZt5VZORLJOrqlENcv6afa2YNfPAV6
 UYTI7GlTUi2CrjARDaOpGGmpAyXtuH9UYjYFJowodASvmsEoEnziu6pQZDyad8PNaJd8 lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xykbp00xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:50:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150nWTa141503;
        Wed, 5 Feb 2020 00:50:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xykc1gkny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:50:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150oY7t012104;
        Wed, 5 Feb 2020 00:50:35 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:50:34 -0800
Date:   Tue, 4 Feb 2020 16:50:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 1/7] xfs_repair: replace verify_inum with libxfs inode
 validators
Message-ID: <20200205005033.GC6870@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086360402.2079685.8627541630086580270.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086360402.2079685.8627541630086580270.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Repair uses the verify_inum function to validate inode numbers that it
> finds in the superblock and in directories.  libxfs now has validator
> functions to cover that kind of thing, so remove verify_inum().  As a
> side bonus, this means that we will flag directories that point to the
> quota/realtime metadata inodes.
> 
> This fixes a regression found by fuzzing u3.sfdir3.hdr.parent.i4 to
> lastbit (aka making a directory's .. point to the user quota inode) in
> xfs/384.

Whoops, this was supposed to be in the previous series, not this one.

--D

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    1 +
>  repair/dino_chunks.c     |    2 +-
>  repair/dinode.c          |   29 -----------------------------
>  repair/dinode.h          |    4 ----
>  repair/dir2.c            |    7 +++----
>  repair/phase4.c          |   12 ++++++------
>  repair/phase6.c          |    8 ++++----
>  7 files changed, 15 insertions(+), 48 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 6e09685b..9daf2635 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -176,6 +176,7 @@
>  #define xfs_trans_roll			libxfs_trans_roll
>  
>  #define xfs_verify_cksum		libxfs_verify_cksum
> +#define xfs_verify_dir_ino		libxfs_verify_dir_ino
>  #define xfs_verify_ino			libxfs_verify_ino
>  #define xfs_verify_rtbno		libxfs_verify_rtbno
>  #define xfs_zero_extent			libxfs_zero_extent
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 00b67468..dbf3d37a 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -65,7 +65,7 @@ check_aginode_block(xfs_mount_t	*mp,
>   * inode chunk.  returns number of new inodes if things are good
>   * and 0 if bad.  start is the start of the discovered inode chunk.
>   * routine assumes that ino is a legal inode number
> - * (verified by verify_inum()).  If the inode chunk turns out
> + * (verified by libxfs_verify_ino()).  If the inode chunk turns out
>   * to be good, this routine will put the inode chunk into
>   * the good inode chunk tree if required.
>   *
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8af2cb25..0d9c96be 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -171,35 +171,6 @@ verify_ag_bno(xfs_sb_t *sbp,
>  	return 1;
>  }
>  
> -/*
> - * returns 0 if inode number is valid, 1 if bogus
> - */
> -int
> -verify_inum(xfs_mount_t		*mp,
> -		xfs_ino_t	ino)
> -{
> -	xfs_agnumber_t	agno;
> -	xfs_agino_t	agino;
> -	xfs_agblock_t	agbno;
> -	xfs_sb_t	*sbp = &mp->m_sb;;
> -
> -	/* range check ag #, ag block.  range-checking offset is pointless */
> -
> -	agno = XFS_INO_TO_AGNO(mp, ino);
> -	agino = XFS_INO_TO_AGINO(mp, ino);
> -	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> -	if (agbno == 0)
> -		return 1;
> -
> -	if (ino == 0 || ino == NULLFSINO)
> -		return(1);
> -
> -	if (ino != XFS_AGINO_TO_INO(mp, agno, agino))
> -		return(1);
> -
> -	return verify_ag_bno(sbp, agno, agbno);
> -}
> -
>  /*
>   * have a separate routine to ensure that we don't accidentally
>   * lose illegally set bits in the agino by turning it into an FSINO
> diff --git a/repair/dinode.h b/repair/dinode.h
> index aa177465..98238357 100644
> --- a/repair/dinode.h
> +++ b/repair/dinode.h
> @@ -77,10 +77,6 @@ verify_uncertain_dinode(xfs_mount_t *mp,
>  		xfs_agnumber_t agno,
>  		xfs_agino_t ino);
>  
> -int
> -verify_inum(xfs_mount_t		*mp,
> -		xfs_ino_t	ino);
> -
>  int
>  verify_aginum(xfs_mount_t	*mp,
>  		xfs_agnumber_t	agno,
> diff --git a/repair/dir2.c b/repair/dir2.c
> index e43a9732..723aee1f 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -215,7 +215,7 @@ process_sf_dir2(
>  		if (lino == ino) {
>  			junkit = 1;
>  			junkreason = _("current");
> -		} else if (verify_inum(mp, lino)) {
> +		} else if (!libxfs_verify_dir_ino(mp, lino)) {
>  			junkit = 1;
>  			junkreason = _("invalid");
>  		} else if (lino == mp->m_sb.sb_rbmino)  {
> @@ -486,8 +486,7 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
>  	 * If the validation fails for the root inode we fix it in
>  	 * the next else case.
>  	 */
> -	if (verify_inum(mp, *parent) && ino != mp->m_sb.sb_rootino)  {
> -
> +	if (!libxfs_verify_dir_ino(mp, *parent) && ino != mp->m_sb.sb_rootino) {
>  		do_warn(
>  _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
>  				*parent, ino);
> @@ -674,7 +673,7 @@ process_dir2_data(
>  			 * (or did it ourselves) during phase 3.
>  			 */
>  			clearino = 0;
> -		} else if (verify_inum(mp, ent_ino)) {
> +		} else if (!libxfs_verify_dir_ino(mp, ent_ino)) {
>  			/*
>  			 * Bad inode number.  Clear the inode number and the
>  			 * entry will get removed later.  We don't trash the
> diff --git a/repair/phase4.c b/repair/phase4.c
> index e1ba778f..8197db06 100644
> --- a/repair/phase4.c
> +++ b/repair/phase4.c
> @@ -36,7 +36,7 @@ quotino_check(xfs_mount_t *mp)
>  	ino_tree_node_t *irec;
>  
>  	if (mp->m_sb.sb_uquotino != NULLFSINO && mp->m_sb.sb_uquotino != 0)  {
> -		if (verify_inum(mp, mp->m_sb.sb_uquotino))
> +		if (!libxfs_verify_ino(mp, mp->m_sb.sb_uquotino))
>  			irec = NULL;
>  		else
>  			irec = find_inode_rec(mp,
> @@ -52,7 +52,7 @@ quotino_check(xfs_mount_t *mp)
>  	}
>  
>  	if (mp->m_sb.sb_gquotino != NULLFSINO && mp->m_sb.sb_gquotino != 0)  {
> -		if (verify_inum(mp, mp->m_sb.sb_gquotino))
> +		if (!libxfs_verify_ino(mp, mp->m_sb.sb_gquotino))
>  			irec = NULL;
>  		else
>  			irec = find_inode_rec(mp,
> @@ -68,7 +68,7 @@ quotino_check(xfs_mount_t *mp)
>  	}
>  
>  	if (mp->m_sb.sb_pquotino != NULLFSINO && mp->m_sb.sb_pquotino != 0)  {
> -		if (verify_inum(mp, mp->m_sb.sb_pquotino))
> +		if (!libxfs_verify_ino(mp, mp->m_sb.sb_pquotino))
>  			irec = NULL;
>  		else
>  			irec = find_inode_rec(mp,
> @@ -112,9 +112,9 @@ quota_sb_check(xfs_mount_t *mp)
>  	    (mp->m_sb.sb_pquotino == NULLFSINO || mp->m_sb.sb_pquotino == 0))  {
>  		lost_quotas = 1;
>  		fs_quotas = 0;
> -	} else if (!verify_inum(mp, mp->m_sb.sb_uquotino) &&
> -			!verify_inum(mp, mp->m_sb.sb_gquotino) &&
> -			!verify_inum(mp, mp->m_sb.sb_pquotino)) {
> +	} else if (libxfs_verify_ino(mp, mp->m_sb.sb_uquotino) &&
> +		   libxfs_verify_ino(mp, mp->m_sb.sb_gquotino) &&
> +		   libxfs_verify_ino(mp, mp->m_sb.sb_pquotino)) {
>  		fs_quotas = 1;
>  	}
>  }
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 0874b649..70135694 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1814,7 +1814,7 @@ longform_dir2_entry_check_data(
>  			}
>  			continue;
>  		}
> -		ASSERT(no_modify || !verify_inum(mp, inum));
> +		ASSERT(no_modify || libxfs_verify_dir_ino(mp, inum));
>  		/*
>  		 * special case the . entry.  we know there's only one
>  		 * '.' and only '.' points to itself because bogus entries
> @@ -1845,7 +1845,7 @@ longform_dir2_entry_check_data(
>  		/*
>  		 * skip entries with bogus inumbers if we're in no modify mode
>  		 */
> -		if (no_modify && verify_inum(mp, inum))
> +		if (no_modify && !libxfs_verify_dir_ino(mp, inum))
>  			continue;
>  
>  		/* validate ftype field if supported */
> @@ -2634,14 +2634,14 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  		fname[sfep->namelen] = '\0';
>  
>  		ASSERT(no_modify || (lino != NULLFSINO && lino != 0));
> -		ASSERT(no_modify || !verify_inum(mp, lino));
> +		ASSERT(no_modify || libxfs_verify_dir_ino(mp, lino));
>  
>  		/*
>  		 * Also skip entries with bogus inode numbers if we're
>  		 * in no modify mode.
>  		 */
>  
> -		if (no_modify && verify_inum(mp, lino))  {
> +		if (no_modify && !libxfs_verify_dir_ino(mp, lino))  {
>  			next_sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
>  			continue;
>  		}
> 
