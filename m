Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35495C4BA18
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 17:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B677222C2
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 17:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CFhAczPi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgBZR1A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:27:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgBZR1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 12:27:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QHNX8j174281;
        Wed, 26 Feb 2020 17:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=K/imnMIp0EmnfdX9++I+CS8fP4GijoFk8BLL3aA+tds=;
 b=CFhAczPiDtZGaA1VKxwmGleTm0bh9/NUCXoTBv9x6bk8s5P6tkxmFfoNN3ixD+S049Nx
 PkJWfq/5P+eSTrywu7PpEO6siKup16y6g9RZIa8BmTw5XkzWRBUlGiprMqTiQ8hhGodn
 bV76LgAaGz5Ofjd+cjlk8iTTOZSRwYEjQbVBuE9/VlSmBlxzfIUEuK3kTPMhZzF7U7Qg
 /2jQpOScNp1MMuCUYfwB2goTq75od/vC3YWs9uJHSffkRWyFj97e6ZVfxhaWtGr9HE4Q
 PY9lb0hmyyg2+Cdt9mtun3NOgL1DUk3r5gLEypv0f0mXVLRum12R9hRTouRglGM//5fk vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ydcsnd77u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 17:26:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QHEAvU125741;
        Wed, 26 Feb 2020 17:24:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ydj4j18f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 17:24:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01QHOtVF007979;
        Wed, 26 Feb 2020 17:24:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 09:24:55 -0800
Date:   Wed, 26 Feb 2020 09:24:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 3/7] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
Message-ID: <20200226172454.GF8045@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086361666.2079685.8451949513769071894.stgit@magnolia>
 <dd15d451-c745-0318-91b0-36864c0052f7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd15d451-c745-0318-91b0-36864c0052f7@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260114
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 09:09:42AM -0800, Eric Sandeen wrote:
> On 2/4/20 4:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs_repair has a very old check that evidently excuses the AG 0 inode
> > btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
> > AG headers).  mkfs never formats filesystems that way and it looks like
> > an error, so purge the check.  After this, we always complain if inodes
> > overlap with AG headers because that should never happen.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I know it's hard to keep track, but it'd be nice if
> 
> > -	ASSERT(M_IGEO(mp)->ialloc_blks > 0);
> 
> this line had been kept per the feedback on the last patchset...

I've added that back.  For real this time.

> This also lost my feedback the first time, re:
> 
> @@ -1782,18 +1775,6 @@ _("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\
>   				break;
>   			case XR_E_INUSE_FS:
>   			case XR_E_INUSE_FS1:
> 
> "I guess there's no real reason to list a couple cases that all fall through
> to default:, I'd just remove them as well since they aren't any more special
> than the other unmentioned cases."
> 
> -				if (agno == 0 &&
> -				    ino + j >= first_prealloc_ino &&
> -				    ino + j < last_prealloc_ino) {
> -					do_warn(
> -_("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
> -						agno, agbno, mp->m_sb.sb_inopblock);
> -
> -					set_bmap(agno, agbno, XR_E_INO);
> -					suspect++;
> -					break;
> -				}
> -				/* fall through */
>  			default:
> 
> I guess I should stop saying "I'll do that on the way in" if 2 more
> versions are going to hit the list, maybe it takes the feedback off
> your radar.

I (almost) always make the changes to my local tree even if you say
you'll do it on the way in, because that makes it easier to compare the
for-next tree vs. my about-to-be-rebased dev tree.

Unfortunately, I do occasionally slip up and forget to make the changes,
even if I've sent email assenting to the changes, because there's not
anything linking "I will make this change" in the email thread to
actually scribbling in the git tree.

Add to that the fact that email clients don't maintain spatial locality
between v3->v4->v5 of a patchset and that just makes it more difficult
to stay on top of reviews as a developer, because I can't even
self-check without having to scroll through hundreds of emails.

So yeah, I guess I'll go review my reviews...  sorry for the crap.

--D

> -Eric
