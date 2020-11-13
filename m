Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8312AC2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB9C21D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:58:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nkIXfemP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKMB6Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:58:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgKMB6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 20:58:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1tihv056788;
        Fri, 13 Nov 2020 01:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LEnHiQKgW7AKgrZUtZzYr+89RVxmPSKiU3G5/6HVErE=;
 b=nkIXfemPyaa2+FdffUgtVZ+xyd/X22xq9BEk7GtiPvfev8MNLXKKdO6Gc7hpAXisgUIz
 YiS6n8BxfU4lZMpIe6FeNK9cwCZp/nD4f9+VpPo0koRz1kj2nVbulMb72d+Gs/okhNfw
 5gcCsu/emp3KiSQKV3LtCO059yd5k9nF6Dqn6MkM9ANwqdlGAOuzksPlyVCi9DN6JCQY
 N0SdCtY/sg3LM/FK+JsmyBewTJWbdl+arKjw/9tWZ2hPxDAnSMnLz9nMNPlxt9OMZ6GB
 H/soznspk/ulbtJ+EdabPAt98HpqhMidTgoeBwl3Oz8gSEYvNVpiijJY8mrbDAE5PxB2 dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72exn46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 01:57:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1kGtc079309;
        Fri, 13 Nov 2020 01:55:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34rtksryc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 01:55:13 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AD1tCbf032551;
        Fri, 13 Nov 2020 01:55:12 GMT
Received: from localhost (/10.159.255.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 17:55:12 -0800
Date:   Thu, 12 Nov 2020 17:55:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v6 1/3] xfs: delete duplicated tp->t_dqinfo null check
 and allocation
Message-ID: <20201113015511.GW9695@magnolia>
References: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
 <1602819508-29033-2-git-send-email-kaixuxia@tencent.com>
 <20201026225226.GF347246@magnolia>
 <224e199b-36d1-401e-3f40-bd0e6c2b4c00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <224e199b-36d1-401e-3f40-bd0e6c2b4c00@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130009
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 12, 2020 at 10:53:39AM +0800, kaixuxia wrote:
> 
> 
> On 2020/10/27 6:52, Darrick J. Wong wrote:
> > On Fri, Oct 16, 2020 at 11:38:26AM +0800, xiakaixu1987@gmail.com wrote:
> >> From: Kaixu Xia <kaixuxia@tencent.com>
> >>
> >> The function xfs_trans_mod_dquot_byino() wraps around
> >> xfs_trans_mod_dquot() to account for quotas, and also there is the
> >> function call chain xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv
> >> -> xfs_trans_mod_dquot, both of them do the duplicated null check and
> >> allocation. Thus we can delete the duplicated operation from them.
> >>
> >> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> >> Reviewed-by: Brian Foster <bfoster@redhat.com>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > HAH this got all the way to v6, sorry I suck. :(
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hi Darrick,
> 
> There are some patches that have been reviewed but not been merged
> into xfs for-next branch, I will reply to them.
> Sorry for the noise:)

Same situation here -- these are 5.11 cleanups and I'm still working on
bug fixes for 5.10.  If you have time to review patches, can you please
have a look at the unreviewed patches in the series "xfs: fix various
scrub problems", please?

--D

> Thanks,
> Kaixu
> > 
> > --D
> > 
> >> ---
> >>  fs/xfs/xfs_trans_dquot.c | 7 -------
> >>  1 file changed, 7 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> >> index fe45b0c3970c..67f1e275b34d 100644
> >> --- a/fs/xfs/xfs_trans_dquot.c
> >> +++ b/fs/xfs/xfs_trans_dquot.c
> >> @@ -143,9 +143,6 @@ xfs_trans_mod_dquot_byino(
> >>  	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
> >>  		return;
> >>  
> >> -	if (tp->t_dqinfo == NULL)
> >> -		xfs_trans_alloc_dqinfo(tp);
> >> -
> >>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
> >>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
> >>  	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
> >> @@ -698,7 +695,6 @@ xfs_trans_dqresv(
> >>  	 * because we don't have the luxury of a transaction envelope then.
> >>  	 */
> >>  	if (tp) {
> >> -		ASSERT(tp->t_dqinfo);
> >>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
> >>  		if (nblks != 0)
> >>  			xfs_trans_mod_dquot(tp, dqp,
> >> @@ -752,9 +748,6 @@ xfs_trans_reserve_quota_bydquots(
> >>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> >>  		return 0;
> >>  
> >> -	if (tp && tp->t_dqinfo == NULL)
> >> -		xfs_trans_alloc_dqinfo(tp);
> >> -
> >>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
> >>  
> >>  	if (udqp) {
> >> -- 
> >> 2.20.0
> >>
> 
> -- 
> kaixuxia
