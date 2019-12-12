Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08537C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 22:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C227320663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 22:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y2CBaO1v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbfLLWMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 17:12:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730811AbfLLWMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 17:12:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCM4PVM037064;
        Thu, 12 Dec 2019 22:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sCNv8/zkovE+ekXqYr+DeefASl4pI0gWc78FM4L9yMU=;
 b=Y2CBaO1vLztriSH9Xcp7lOHOzAT7xQrebLt8JqU87yAWzz4auC62B+9qPwwnNu0Q7TQm
 uUvy12P8/DTKMN/y5HX1qcHVPpedKjoIwfMeP8MgZQqupmbUuaWClr2CoyWkUfx4aIXs
 ZD8zoNzm4hE5y0fyvxX7J3oqKCfuKbuoXaWgOz/OHlgXFZiv1pbiClGf8NlTT/z4bW6S
 7jDg+I/Vt9znGJ/h5I5MI+nEhOkkHtYWop4khnsZnJPLDzCntEj9Da7F62bNa7KEphfB
 DQeQ80ZM/5udgu3vN8+YXhzVWui7flP/uoeRJou+iiEePG/vXovhWnyeVQuoSmADskhk Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wr41qnv5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 22:12:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCM4Plh132731;
        Thu, 12 Dec 2019 22:10:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wumw1u107-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 22:10:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCMA6g2004480;
        Thu, 12 Dec 2019 22:10:07 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 14:10:06 -0800
Date:   Thu, 12 Dec 2019 14:10:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 3/6] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
Message-ID: <20191212221005.GD99875@magnolia>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547908374.974712.5696639212883074825.stgit@magnolia>
 <d7a378f8-dec0-c809-fb0f-10225bdfdea4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7a378f8-dec0-c809-fb0f-10225bdfdea4@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 02:38:12PM -0600, Eric Sandeen wrote:
> On 12/4/19 11:04 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs_repair has a very old check that evidently excuses the AG 0 inode
> > btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
> > AG headers).  mkfs never formats filesystems that way and it looks like
> > an error, so purge the check.  After this, we always complain if inodes
> > overlap with AG headers because that should never happen.
> 
> So the only thing I can think here is that if you make a 64k block filesystem
> with a 512-byte inode size, you can actually get your first user-created
> inode in the range between first_prealloc and last_prealloc.  So that's
> maybe a clue.
> 
> But then we'd need something to mark all the blocks in that range as
> XR_E_INUSE_FS to justify the existence of the test you're removing here,
> and I can't make up any story or find anything in old code
> that indicates that was ever done.
> 
> Still, that's my best guess, that maybe the system preallocated inodes
> used to be marked as XR_E_INUSE_FS or something.  But then it's weird
> to code "if it's marked XR_E_INUSE_FS and it's in the preallocated
> inode range then re-mark it as XR_E_INO"
> 
> Maybe the prealloc inode range got calculated later or something...
> 
> </handwave>
> 
> Anyway, on to the nitpicking!
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
> 
> I guess there's no real reason to list a couple cases that all fall through
> to default:, I'd just remove them as well since they aren't any more special
> than the other unmentioned cases.
> 
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
> Otherwise I think I'm ok with this, I can't convince myself that there's any
> reason to keep it.
> 
> I can drop the extra cases if you agree.

Yeah, seems fine to me.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
