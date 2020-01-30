Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E6BC2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6AC214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 20:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jdlNW7Cc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgA3Ue4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 15:34:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43684 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbgA3Ue4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 15:34:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UKSvaE010492;
        Thu, 30 Jan 2020 20:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=aRXXZJ3S/gBsbNLFGNDZBhrD0oDvfUT91kFFEar4Zu8=;
 b=jdlNW7Cc8EBusRVyVJrNBpsbeVl/Xn8uJalR5EbO0gTnEFEmoPL/Z4VmMQxL+m2qkfXU
 BW7ocvBSWNlChM2DU37JKHpOZMG5jUKYg6yQX2CyXWjMGsqGnzKdpGwnyQ3cwIa1TAKH
 1j/AJ+hDpyFMv/nW8KRbAXXN0DeLx2XPf+B+OG3UeiiDkKTEPB9nyNwWCAThPNfO2dsK
 pjmprbdeQT+spj5/yPP+iWCQUDx02Ty28SdG8U/LD2QITOYzBlD79T9YQ0UkJvlIC4bJ
 0MUP8tcrJIZG7NoPqJLb7oX/D273tIjHUXx0FL+Tw06LU9eA3cGoYdufHDmw4nJrm7rB 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xrdmqxnwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 20:34:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00UKTAej162525;
        Thu, 30 Jan 2020 20:34:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xuhes1kj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 20:34:53 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00UKYpQC003154;
        Thu, 30 Jan 2020 20:34:51 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 12:34:51 -0800
Date:   Thu, 30 Jan 2020 12:34:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 5/6] xfs_repair: check plausibility of root dir pointer
 before trashing it
Message-ID: <20200130203448.GF3447196@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
 <157982507752.2765631.16955377241063712365.stgit@magnolia>
 <4fb8e608-959e-813a-2424-865a765a2b92@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fb8e608-959e-813a-2424-865a765a2b92@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001300137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001300137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 02:18:52PM -0600, Eric Sandeen wrote:
> On 1/23/20 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If sb_rootino doesn't point to where we think mkfs should have allocated
> > the root directory, check to see if the alleged root directory actually
> > looks like a root directory.  If so, we'll let it live because someone
> > could have changed sunit since formatting time, and that changes the
> > root directory inode estimate.
> 
> I forget, is there an fstest for this?

https://lore.kernel.org/linux-xfs/20191218041831.GK12765@magnolia/

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ...
> 
> > @@ -438,6 +469,20 @@ calc_mkfs(
> >  
> >  	rootino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
> >  
> > +	/*
> > +	 * If the root inode isn't where we think it is, check its plausibility
> > +	 * as a root directory.  It's possible that somebody changed sunit
> > +	 * since the filesystem was created, which can change the value of the
> > +	 * above computation.  Don't blow up the root directory if this is the
> > +	 * case.
> > +	 */
> > +	if (mp->m_sb.sb_rootino != rootino && has_plausible_rootdir(mp)) {
> > +		do_warn(
> > +_("sb root inode value %" PRIu64 " inconsistent with alignment (expected %"PRIu64")\n"),
> > +			mp->m_sb.sb_rootino, rootino);
> 
> what would a user do with this warning?  Is there any value in emitting it?
> 
> Otherwise this looks good.

I dunno -- on the one hand, I understand that nobody wants to deal with
the support calls that will erupt from that message.  On the other hand,
it's an indication that this filesystem isn't /quite/ the way we
expected it to be, and that would be a helpful hint if you were
debugging some other weird problem with an xfs filesystem.

What if this were a do_log()?

--D
> 
> 
> > +		rootino = mp->m_sb.sb_rootino;
> > +	}
> > +
> >  	ensure_fixed_ino(&mp->m_sb.sb_rootino, rootino,
> >  			_("root"));
> >  	ensure_fixed_ino(&mp->m_sb.sb_rbmino, rootino + 1,
> > 
