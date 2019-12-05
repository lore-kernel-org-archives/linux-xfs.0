Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CE1C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 16:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEA3F24648
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 16:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b0ntG8oS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfLEQ3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 11:29:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50632 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfLEQ3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 11:29:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5GTA6W138205;
        Thu, 5 Dec 2019 16:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vN/D+vSbCxEhXRnKD9lLp2TKHA0LhzNMZPSB8FDACYQ=;
 b=b0ntG8oSy81J+yuEem+1dSn4BH0STCJHG/tgdo/r/8anJdRGKgTD30OHnTSc9zKpksxq
 FBNCFoJpMEMIcQUfXwBHLMRy+Xa72HpfFkroaxPUBmCmfF3RsHFAouIWJnn597Rjdxm2
 RuoWUHcHQQuAkuaDHgdyUdmlDd/AeKZ+5rZaj1LJODRum6+OVNO+0bAEYAJKLXP8O8ij
 ncZFlIAweB4ZWMGW1/0URISw3OdNMNEhHQ4imq/V+9CpaffJaqRZrBg7YqPB998yS3CQ
 Sg8VaY9zI7T7Hj+zJyxWRH3QHoV+ZiY/EaSXiw/+O73MecN/DDJWJI4nBfe4kjXNx/Gz Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wkh2rp720-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 16:29:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5GTHKD109825;
        Thu, 5 Dec 2019 16:29:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wpp74d6ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 16:29:20 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB5GSJPi030005;
        Thu, 5 Dec 2019 16:28:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Dec 2019 08:28:19 -0800
Date:   Thu, 5 Dec 2019 08:28:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 3/6] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
Message-ID: <20191205162818.GC13260@magnolia>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547908374.974712.5696639212883074825.stgit@magnolia>
 <20191205143727.GC48368@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205143727.GC48368@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912050138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912050138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 05, 2019 at 09:37:27AM -0500, Brian Foster wrote:
> On Wed, Dec 04, 2019 at 09:04:43AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs_repair has a very old check that evidently excuses the AG 0 inode
> > btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
> > AG headers).  mkfs never formats filesystems that way and it looks like
> > an error, so purge the check.  After this, we always complain if inodes
> > overlap with AG headers because that should never happen.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Strange.. This seems reasonable to me, but any idea on how this might
> have been used in the past?

I don't have a clue -- this code has been there since the start of the
xfsprogs git repo and I don't have the pre-git history.  Dave said
"hysterical raisins".

> The only thing I can see so far is that
> perhaps if the superblock (blocksize/sectorsize) is corrupted, the
> in-core state trees could be badly initialized such that the inode falls
> into the "in use" state. Of course if that were the case the fs probably
> has bigger problems..

Yeah.  These days if all those things collide (or look like they
collide) then chances are the filesystem is already toast.

--D

> Brian
> 
> >  repair/globals.c    |    1 -
> >  repair/globals.h    |    1 -
> >  repair/scan.c       |   19 -------------------
> >  repair/xfs_repair.c |    7 -------
> >  4 files changed, 28 deletions(-)
> > 
> > 
> > diff --git a/repair/globals.c b/repair/globals.c
> > index dcd79ea4..8a60e706 100644
> > --- a/repair/globals.c
> > +++ b/repair/globals.c
> > @@ -73,7 +73,6 @@ int	lost_gquotino;
> >  int	lost_pquotino;
> >  
> >  xfs_agino_t	first_prealloc_ino;
> > -xfs_agino_t	last_prealloc_ino;
> >  xfs_agblock_t	bnobt_root;
> >  xfs_agblock_t	bcntbt_root;
> >  xfs_agblock_t	inobt_root;
> > diff --git a/repair/globals.h b/repair/globals.h
> > index 008bdd90..2ed5c894 100644
> > --- a/repair/globals.h
> > +++ b/repair/globals.h
> > @@ -114,7 +114,6 @@ extern int		lost_gquotino;
> >  extern int		lost_pquotino;
> >  
> >  extern xfs_agino_t	first_prealloc_ino;
> > -extern xfs_agino_t	last_prealloc_ino;
> >  extern xfs_agblock_t	bnobt_root;
> >  extern xfs_agblock_t	bcntbt_root;
> >  extern xfs_agblock_t	inobt_root;
> > diff --git a/repair/scan.c b/repair/scan.c
> > index c383f3aa..05707dd2 100644
> > --- a/repair/scan.c
> > +++ b/repair/scan.c
> > @@ -1645,13 +1645,6 @@ scan_single_ino_chunk(
> >  				break;
> >  			case XR_E_INUSE_FS:
> >  			case XR_E_INUSE_FS1:
> > -				if (agno == 0 &&
> > -				    ino + j >= first_prealloc_ino &&
> > -				    ino + j < last_prealloc_ino) {
> > -					set_bmap(agno, agbno, XR_E_INO);
> > -					break;
> > -				}
> > -				/* fall through */
> >  			default:
> >  				/* XXX - maybe should mark block a duplicate */
> >  				do_warn(
> > @@ -1782,18 +1775,6 @@ _("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\
> >  				break;
> >  			case XR_E_INUSE_FS:
> >  			case XR_E_INUSE_FS1:
> > -				if (agno == 0 &&
> > -				    ino + j >= first_prealloc_ino &&
> > -				    ino + j < last_prealloc_ino) {
> > -					do_warn(
> > -_("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
> > -						agno, agbno, mp->m_sb.sb_inopblock);
> > -
> > -					set_bmap(agno, agbno, XR_E_INO);
> > -					suspect++;
> > -					break;
> > -				}
> > -				/* fall through */
> >  			default:
> >  				do_warn(
> >  _("inode chunk claims used block, finobt block - agno %d, bno %d, inopb %d\n"),
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 9295673d..3e9059f3 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -460,13 +460,6 @@ calc_mkfs(xfs_mount_t *mp)
> >  		first_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno);
> >  	}
> >  
> > -	ASSERT(M_IGEO(mp)->ialloc_blks > 0);
> > -
> > -	if (M_IGEO(mp)->ialloc_blks > 1)
> > -		last_prealloc_ino = first_prealloc_ino + XFS_INODES_PER_CHUNK;
> > -	else
> > -		last_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno + 1);
> > -
> >  	/*
> >  	 * now the first 3 inodes in the system
> >  	 */
> > 
> 
