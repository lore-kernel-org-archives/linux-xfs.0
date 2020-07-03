Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C17AC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 18:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A48A21D79
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 18:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vHaHJZ1e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGCSDh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 14:03:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCSDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jul 2020 14:03:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063I2Klw192692;
        Fri, 3 Jul 2020 18:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9Qo1I12CdfBq6uyFM1ifPqtKTEf1kB6aCR3vNb0YbHY=;
 b=vHaHJZ1e5MzIS2FED765BXE8RCwn5PZVd+MN2lp7z+qpQhuypncHxmMzje4wssllZox1
 yaCoVkbXGJU4cK1vTubHfcfHDIhSb7B63BgJLlbtKcZ1Zo+wQ4rMOfaP9A5+4wsrS4rl
 5y+PQkPUFHcMEJaUyA7XsR5hDdwqZs8TBOR2XSwxnQrQayfWRl6tp4EVelJwybrU0Og6
 z1tPp//eiCDjm/BlkJ3R/TTHkgbTvKdL3IevAJ6fGh7RuVedg9dNaJhZgKlTV6Jy3wHy
 KP65vXgY7XNb62Ys62CW8zgDmBwwVzqAXm6INGvNJT6G7DkVN7lxyUkoRKDiIPJdpihG wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrnppj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 18:03:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063HqjVe024070;
        Fri, 3 Jul 2020 18:01:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvxrkcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 18:01:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063I1Xtc018570;
        Fri, 3 Jul 2020 18:01:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 18:01:33 +0000
Date:   Fri, 3 Jul 2020 11:01:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
Message-ID: <20200703180132.GE7606@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353173676.2864738.5361850443664572160.stgit@magnolia>
 <20200701225053.GA2005@dread.disaster.area>
 <20200701231910.GQ7625@magnolia>
 <20200701234435.GF2005@dread.disaster.area>
 <20200701235031.GY7606@magnolia>
 <20200703005850.GJ2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703005850.GJ2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 03, 2020 at 10:58:50AM +1000, Dave Chinner wrote:
> On Wed, Jul 01, 2020 at 04:50:31PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 02, 2020 at 09:44:35AM +1000, Dave Chinner wrote:
> > > On Wed, Jul 01, 2020 at 04:19:10PM -0700, Darrick J. Wong wrote:
> > > > On Thu, Jul 02, 2020 at 08:50:53AM +1000, Dave Chinner wrote:
> > > > > On Tue, Jun 30, 2020 at 08:42:16AM -0700, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > Use the incore dq_flags to figure out the dquot type.  This is the first
> > > > > > step towards removing xfs_disk_dquot from the incore dquot.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > >  fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
> > > > > >  fs/xfs/scrub/quota.c           |    4 ----
> > > > > >  fs/xfs/xfs_dquot.c             |   33 +++++++++++++++++++++++++++++++--
> > > > > >  fs/xfs/xfs_dquot.h             |    2 ++
> > > > > >  fs/xfs/xfs_dquot_item.c        |    6 ++++--
> > > > > >  fs/xfs/xfs_qm.c                |    4 ++--
> > > > > >  fs/xfs/xfs_qm.h                |    2 +-
> > > > > >  fs/xfs/xfs_qm_syscalls.c       |    9 +++------
> > > > > >  8 files changed, 45 insertions(+), 17 deletions(-)
> > > > > > 
> > > > > > 
> > > > > > diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> > > > > > index 56d9dd787e7b..459023b0a304 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_quota_defs.h
> > > > > > +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> > > > > > @@ -29,6 +29,8 @@ typedef uint16_t	xfs_qwarncnt_t;
> > > > > >  
> > > > > >  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
> > > > > >  
> > > > > > +#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)
> > > > > 
> > > > > That's used as an on-disk flags mask. Perhaps XFS_DQF_ONDISK_MASK?
> > > > 
> > > > Well, based on Christoph's suggestions I broke the incore dquot flags
> > > > (XFS_DQ_*) apart from the ondisk dquot flags (XFS_DQFLAG_*).  Not sure
> > > > if that's really better, but at least the namespaces are separate now.
> > > 
> > > Sure, but the point I was trying to make is that "XFS_DQ_ONDISK"
> > > doesn't actually indicate what part of the on-disk dquot it refers
> > > to. We use the phrase "on-disk dquot" to refer to the entire on-disk
> > > dquot, not a subset of flags in a flags field in the on-disk
> > > dquot. Hence the name of this variable needs to be more specific as
> > > to what it applies to in the on-disk dquot...
> > 
> > Sorry, I was typing too fast.  xfs_format.h now has:
> > 
> > #define XFS_DQFLAG_USER		0x01		/* user dquot record */
> > #define XFS_DQFLAG_PROJ		0x02		/* project dquot record */
> > #define XFS_DQFLAG_GROUP	0x04		/* group dquot record */
> > 
> > #define XFS_DQFLAG_TYPE_MASK	(XFS_DQFLAG_USER | \
> > 				 XFS_DQFLAG_PROJ | \
> > 				 XFS_DQFLAG_GROUP)
> > 
> > #define XFS_DQFLAG_ALL		(XFS_DQFLAG_TYPE_MASK)
> > 
> > /*
> >  * This is the main portion of the on-disk representation of quota
> >  * information for a user. This is the q_core of the struct xfs_dquot
> >  * that is kept in kernel memory. We pad this with some more expansion
> >  * room to construct the on disk structure.
> >  */
> > struct xfs_disk_dquot {
> > 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
> > 	__u8		d_version;	/* dquot version */
> > 	__u8		d_flags;	/* XFS_DQFLAG_* */
> > 
> > I'm not particularly thrilled about the DQFLAG/DQ thing though.  DDFLAG?
> > (Also note that the future bigtime series will add a new ondisk flag
> > XFS_DQFLAG_BIGTIME, which ofc will get added to XFS_DQFLAG_ALL.)
> 
> /me shrugs
> 
> I don't have any good ideas, but I think that DQFLAG is a bad choice
> for an on-disk flag namespace because it's way too generic. It's
> more a type/feature indicator so perhaps we should rename d_flags to
> d_type or d_features and use:
> 
> #define XFS_DDQTYPE_USER
> #define XFS_DDQTYPE_PROJ
> #define XFS_DDQTYPE_GROUP
> #define XFS_DDQTYPE_BIGTIME
> 
> #define XFS_DDQTYPE_QUOTA_MASK	(XFS_DDQTYPE_USER | ...
> 
> #define XFS_DDQTYPE_ALL		(XFS_DDQTYPE_QUOTA_MASK | XFS_DDQTYPE_BIGTIME)
> 
> Or something like that...

I prefer d_features/DDQFEAT over d_type/DDQTYPE because I don't want
people to mix up "ondisk dquot type (user/group/proj/bigtime)" with
"quota type (user/group/proj)".

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
