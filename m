Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA8DC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 01:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6861720791
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 01:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="swy56HIJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGPBsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 21:48:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgGPBsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 21:48:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G1WAlq166704;
        Thu, 16 Jul 2020 01:48:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zr+EHWUF+aV9s/J/Kdy3dUa1fjf7lQyN00if1jicjHM=;
 b=swy56HIJKC5uHbT5Q+HOe9JAK6A2hfcC+Mc5W84QE0hFHZqrpoumTfPljLcnIPGN28+5
 2xt2fxhnAhh2gCp+On/GRvQGa30DcYQ0ap+QG1yCW0+zhnY3VHmrho1Awf/uo/QUBD3y
 MdnXN/QiVKhh2X9Xy5wO9szWI9MH2rcQwukZAcqfj5s2BQVO49hbdVVcaRDfPlIjEXyp
 2YfnabDzzFRvdUSszMl5lA1J4ZuueIy2R5Z8Cf/2F8JyPD933K0XeOBTbHDuDkPu3SDi
 +vcfmiepidWqp9Cycmx4iWydN3zgm/SRw+J0sYHqTuMEA6Z7p4etW+XpbWeOGdqdrUhs gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274uremey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Jul 2020 01:48:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G1Wgrs081158;
        Thu, 16 Jul 2020 01:48:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qc25165-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 01:48:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06G1m15w025652;
        Thu, 16 Jul 2020 01:48:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 18:48:00 -0700
Date:   Wed, 15 Jul 2020 18:47:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix inode allocation block res calculation
 precedence
Message-ID: <20200716014759.GH3151642@magnolia>
References: <20200715193310.22002-1-bfoster@redhat.com>
 <20200715222935.GI2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715222935.GI2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=5 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 08:29:35AM +1000, Dave Chinner wrote:
> On Wed, Jul 15, 2020 at 03:33:10PM -0400, Brian Foster wrote:
> > The block reservation calculation for inode allocation is supposed
> > to consist of the blocks required for the inode chunk plus
> > (maxlevels-1) of the inode btree multiplied by the number of inode
> > btrees in the fs (2 when finobt is enabled, 1 otherwise).
> > 
> > Instead, the macro returns (ialloc_blocks + 2) due to a precedence
> > error in the calculation logic. This leads to block reservation
> > overruns via generic/531 on small block filesystems with finobt
> > enabled. Add braces to fix the calculation and reserve the
> > appropriate number of blocks.
> > 
> > Fixes: 9d43b180af67 ("xfs: update inode allocation/free transaction reservations for finobt")
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_space.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > index 88221c7a04cc..c6df01a2a158 100644
> > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > @@ -57,7 +57,7 @@
> >  	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
> >  #define	XFS_IALLOC_SPACE_RES(mp)	\
> >  	(M_IGEO(mp)->ialloc_blks + \
> > -	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
> > +	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> >  	  (M_IGEO(mp)->inobt_maxlevels - 1)))
> 
> Ugh. THese macros really need rewriting as static inline functions.
> This would not have happened if it were written as:
> 
> static inline int
> xfs_ialloc_space_res(struct xfs_mount *mp)
> {
> 	int	res = M_IGEO(mp)->ialloc_blks;
> 
> 	res += M_IGEO(mp)->inobt_maxlevels - 1;
> 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> 		res += M_IGEO(mp)->inobt_maxlevels - 1;
> 	return res;
> }
> 
> Next question: why is this even a macro that is calculated on demand
> instead of a read-only constant held in inode geometry calculated
> at mount time? Then it doesn't even need to be an inline function
> and can just be rolled into xfs_ialloc_setup_geometry()....

Yeah, I hate those macros too.  Fixing all that sounds like a <cough>
cleanup series for someone, but in the meantime this is easy enough to
backport to stable kernels.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
