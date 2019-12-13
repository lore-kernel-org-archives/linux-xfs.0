Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719A5C751F2
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1EC1247DA
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UdEkOo7B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfLMQKv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:10:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLMQKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 11:10:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDG9WS0057312;
        Fri, 13 Dec 2019 16:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Fb6SXzYkf9vfn6yKg4vPoyKzjfF6L4zz2EzszeOr0WY=;
 b=UdEkOo7BySboDQrltEXHJ1+Al2F6nSxqQd53i+QH8QBG4ENf42uclaxiflLt/iSv1oiQ
 DV6PpVdtFCUqK3mF9n0NhEpdfFvk4ehYLIpXpTp6/b4NVkJOwxaqYBIA+u5UdF53+sIY
 C10YBENpcHZGCB28taJ/k2EnWhVLhsjpgfC+BE6aJ/liSY0/dVltWS8JY9jEifp7V6v3
 3j/M05vKE8UvTQXt5MROJ2iE7ts3LizWHQLG9X4g8UJs6oFMgLdf6019XO3BZxsyB/ZN
 exssFefSbJMhNCnp9c3anPnXFx1KiBf9rm3L04tKUUkRp+ynCAwMrmVM1qGZ3fuKuJFJ 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wr4qs1v81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 16:10:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDG3iDI126652;
        Fri, 13 Dec 2019 16:10:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wvb997222-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 16:10:43 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDGAgWX015784;
        Fri, 13 Dec 2019 16:10:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 08:10:41 -0800
Date:   Fri, 13 Dec 2019 08:10:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
Message-ID: <20191213161039.GG99875@magnolia>
References: <20191204170340.GR7335@magnolia>
 <20191205143618.GA48368@bfoster>
 <20191205214222.GE13260@magnolia>
 <20191206105751.GA55746@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206105751.GA55746@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 06, 2019 at 05:57:51AM -0500, Brian Foster wrote:
> On Thu, Dec 05, 2019 at 01:42:22PM -0800, Darrick J. Wong wrote:
> > On Thu, Dec 05, 2019 at 09:36:18AM -0500, Brian Foster wrote:
> > > On Wed, Dec 04, 2019 at 09:03:40AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> > > > and swidth values could cause xfs_repair to fail loudly.  The problem
> > > > here is that repair calculates the where mkfs should have allocated the
> > > > root inode, based on the superblock geometry.  The allocation decisions
> > > > depend on sunit, which means that we really can't go updating sunit if
> > > > it would lead to a subsequent repair failure on an otherwise correct
> > > > filesystem.
> > > > 
> > > > Port the computation code from xfs_repair and teach mount to avoid the
> > > > ondisk update if it would cause problems for repair.  We allow the mount
> > > > to proceed (and new allocations will reflect this new geometry) because
> > > > we've never screened this kind of thing before.
> > > > 
> > > > [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
> > > > 
> > > > Reported-by: Alex Lyakas <alex@zadara.com>
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > > v2: compute the root inode location directly
> > > > ---
> > > >  fs/xfs/libxfs/xfs_ialloc.c |   81 ++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_ialloc.h |    1 +
> > > >  fs/xfs/xfs_mount.c         |   51 ++++++++++++++++++----------
> > > >  3 files changed, 115 insertions(+), 18 deletions(-)
> > > > 
> ...
> > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > index fca65109cf24..a4eb3ae34a84 100644
> > > > --- a/fs/xfs/xfs_mount.c
> > > > +++ b/fs/xfs/xfs_mount.c
> ...
> > > > @@ -398,28 +399,42 @@ xfs_update_alignment(xfs_mount_t *mp)
> > > >  			}
> > > >  		}
> > > >  
> > > > -		/*
> > > > -		 * Update superblock with new values
> > > > -		 * and log changes
> > > > -		 */
> > > > -		if (xfs_sb_version_hasdalign(sbp)) {
> > > > -			if (sbp->sb_unit != mp->m_dalign) {
> > > > -				sbp->sb_unit = mp->m_dalign;
> > > > -				mp->m_update_sb = true;
> > > > -			}
> > > > -			if (sbp->sb_width != mp->m_swidth) {
> > > > -				sbp->sb_width = mp->m_swidth;
> > > > -				mp->m_update_sb = true;
> > > > -			}
> > > > -		} else {
> > > > +		/* Update superblock with new values and log changes. */
> > > > +		if (!xfs_sb_version_hasdalign(sbp)) {
> > > >  			xfs_warn(mp,
> > > >  	"cannot change alignment: superblock does not support data alignment");
> > > >  			return -EINVAL;
> > > >  		}
> > > > +
> > > > +		if (sbp->sb_unit == mp->m_dalign &&
> > > > +		    sbp->sb_width == mp->m_swidth)
> > > > +			return 0;
> > > > +
> > > > +		/*
> > > > +		 * If the sunit/swidth change would move the precomputed root
> > > > +		 * inode value, we must reject the ondisk change because repair
> > > > +		 * will stumble over that.  However, we allow the mount to
> > > > +		 * proceed because we never rejected this combination before.
> > > > +		 */
> > > > +		if (sbp->sb_rootino !=
> > > > +		    xfs_ialloc_calc_rootino(mp, mp->m_dalign)) {
> > > > +			xfs_warn(mp,
> > > > +	"cannot change stripe alignment: would require moving root inode");
> > > > +
> > > 
> > > FWIW, I read this error message as the mount option was ignored. I don't
> > > much care whether we ignore the mount option or simply the on-disk
> > > update, but the error could be a bit more clear in the latter case.
> > 
> > Ok, I'll add a message about how we're skipping the sb update.
> > 
> > > Also, what is the expected behavior for xfs_info in the latter
> > > situation?
> > 
> > A previous revision of the patch had the ioctl feeding xfs_info using
> > the incore values, but Dave objected so I dropped it.
> > 
> 
> Ok, could you document the expected behavior for this new state in the
> commit log so it's clear when looking back at it? I.e., xfs_info should
> return superblock values, xfs_growfs should update based on superblock
> values, etc.

Yeah, I'll do that.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > +			/*
> > > > +			 * XXX: Next time we add a new incompat feature, this
> > > > +			 * should start returning -EINVAL.
> > > > +			 */
> > > > +			return 0;
> > > > +		}
> > > > +
> > > > +		sbp->sb_unit = mp->m_dalign;
> > > > +		sbp->sb_width = mp->m_swidth;
> > > > +		mp->m_update_sb = true;
> > > >  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
> > > >  		    xfs_sb_version_hasdalign(&mp->m_sb)) {
> > > > -			mp->m_dalign = sbp->sb_unit;
> > > > -			mp->m_swidth = sbp->sb_width;
> > > > +		mp->m_dalign = sbp->sb_unit;
> > > > +		mp->m_swidth = sbp->sb_width;
> > > >  	}
> > > >  
> > > >  	return 0;
> > > > 
> > > 
> > 
> 
