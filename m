Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48789C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A9C20708
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sjKsNV6C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgA3U2I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 15:28:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgA3U2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 15:28:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UK8XQu190145;
        Thu, 30 Jan 2020 20:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=C0ucoA5N0YQSl+2hn32+8juThChwOak+VJjCE8p9lmY=;
 b=sjKsNV6CzGYbt4PHSJDA1XjDaqB/PmJGmXWlnTJFh23pqP22VxuJMH4YpBBbuUCKPT4f
 EKiXdn++wkwINQlR//tgCUzsFCaRefI82DMpB+ttykYCf6xcoRa2NE+Qq4/zDRjHTXRv
 +u3bQ5mfn7uMo3a51YdKpU/cMW4J63p0hTnD4UcXzk+e9AFp2mP48E9YJ18Gua00citM
 TLcpyBgdF89XneTA/HXJsS9VMX6bp9OL5qhX91wed7vuieGcnSXbSK5QpgCb0EJyaNxJ
 R62vTkgAg5nMSGf0pb4EqIzT55LYLFIY9KvC07vqHj5wRV2sIaGlFuEq4TvNeN6/6mEo RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xrdmqxmwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 20:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UK8wji131601;
        Thu, 30 Jan 2020 20:26:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xuemx5feu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 20:26:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00UKQ31N031942;
        Thu, 30 Jan 2020 20:26:03 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 12:26:03 -0800
Date:   Thu, 30 Jan 2020 12:26:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 2/6] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
Message-ID: <20200130202600.GE3447196@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
 <157982505923.2765631.10587375380960098225.stgit@magnolia>
 <eb2b3973-0301-5b96-58e9-7f754a58d0f6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb2b3973-0301-5b96-58e9-7f754a58d0f6@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001300136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001300136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 01:38:52PM -0600, Eric Sandeen wrote:
> On 1/23/20 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs_repair has a very old check that evidently excuses the AG 0 inode
> > btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
> > AG headers).  mkfs never formats filesystems that way and it looks like
> > an error, so purge the check.  After this, we always complain if inodes
> > overlap with AG headers because that should never happen.
> 
> I peered back into the mists of time to see if I could find any reason for
> this exception, and I couldn't.
> 
> Only question is why you removed the
> 
> -	ASSERT(M_IGEO(mp)->ialloc_blks > 0);
> 
> assert, that's still a valid assert, no?

The superblock validation routines are supposed to reject all the
combinations that can result in ialloc_blks being zero.

That said, I can't think of a reason to remove the assert.  If you want
me to put it back, it I can... or pretty-please put it back in for me?
:)

--D

> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
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
