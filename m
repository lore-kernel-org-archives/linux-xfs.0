Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898DCC2D0EC
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 03:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5433020692
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 03:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ExFqeK3d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgDKDTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 23:19:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50882 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgDKDTe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Apr 2020 23:19:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03B3Am87110607;
        Sat, 11 Apr 2020 03:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MJtVFMvkHCmTD4ZLfxik0EtiPczz2RJSmD1K5E7nxxY=;
 b=ExFqeK3d2d8Fa37c91+IE6BW65GcNLiLOi8pPweg/sxR/lm5KD3KG3sSpR5n1/CTykOl
 GbMBP1wdZT3myux/g7ISSKk6Nx1C1OEKDIovq/b/TI02nNWS1J0rG3RR1vGh2r+zy0Gg
 ZZlSomEyT/yJ7jf2SWBP64DSzApKVeeuHH2gRIJLe7PAhb+6eXIp36QgDs8E5uM+POgY
 GNcZCpxBJ8RQrzXQf0+pLNlqJxsI+NXziKLCfaDdclbGGj3QY8Pe3sFhcAA9cK4QW2cs
 3zk8MQi493xsOLNwjfJspfYYDk2RbNsHgmpDHvkV4Mxey3LHSZ2euIyLHPNgFfzy8Vnt cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 309gw4mfp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Apr 2020 03:18:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03B3GfOc193450;
        Sat, 11 Apr 2020 03:18:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30b57gtc63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Apr 2020 03:18:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03B3IdwK017970;
        Sat, 11 Apr 2020 03:18:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 20:18:38 -0700
Date:   Fri, 10 Apr 2020 20:18:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: simplify the flags setting in xfs_qm_scall_quotaon
Message-ID: <20200411031838.GQ6742@magnolia>
References: <1586509024-5856-1-git-send-email-kaixuxia@tencent.com>
 <20200410145138.GP6742@magnolia>
 <06737124-3742-e956-b715-0f1f7010170d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06737124-3742-e956-b715-0f1f7010170d@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 suspectscore=2 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004110026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=2 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004110025
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 11, 2020 at 09:09:57AM +0800, kaixuxia wrote:
> 
> On 2020/4/10 22:51, Darrick J. Wong wrote:
> > On Fri, Apr 10, 2020 at 04:57:04PM +0800, xiakaixu1987@gmail.com wrote:
> >> From: Kaixu Xia <kaixuxia@tencent.com>
> >>
> >> Simplify the setting of the flags value, and only consider
> >> quota enforcement stuff here.
> >>
> >> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> >> ---
> >>  fs/xfs/xfs_qm_syscalls.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> >> index 5d5ac65..944486f 100644
> >> --- a/fs/xfs/xfs_qm_syscalls.c
> >> +++ b/fs/xfs/xfs_qm_syscalls.c
> >> @@ -357,11 +357,11 @@
> > 
> > No idea which function this is.  diff -p, please.
> 
> Yeah, the changed function is xfs_qm_scall_quotaon().
> Anyway, the result of diff -p as follows,

That was a request to generate your patches with diff -Naurp.

--D

> *** fs/xfs/xfs_qm_syscalls.c	Sat Apr 11 08:32:03 2020
> --- /tmp/xfs_qm_syscalls.c	Sat Apr 11 08:31:51 2020
> *************** xfs_qm_scall_quotaon(
> *** 357,367 ****
>   	int		error;
>   	uint		qf;
>   
>   	/*
> ! 	 * Switching on quota accounting must be done at mount time,
> ! 	 * only consider quota enforcement stuff here.
>   	 */
> ! 	flags &= XFS_ALL_QUOTA_ENFD;
>   
>   	if (flags == 0) {
>   		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
> --- 357,367 ----
>   	int		error;
>   	uint		qf;
>   
> + 	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>   	/*
> ! 	 * Switching on quota accounting must be done at mount time.
>   	 */
> ! 	flags &= ~(XFS_ALL_QUOTA_ACCT);
>   
>   	if (flags == 0) {
>   		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
> 
> > 
> > Also, please consider putting all these minor cleanups into a single
> > patchset, it's a lot easier (for me) to track and land one series than
> > it is to handle a steady trickle of single patches.
> Yeah, got it. Should I resend all of the patches that have been
> reviewed or just resend the last two patches with a single patchset?
> 
> The patches that have been reviewed as follows,
> xfs: trace quota allocations for all quota types
> xfs: combine two if statements with same condition
> xfs: check if reserved free disk blocks is needed
> xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
> 
> The last two patches that have not been reviewed as follow,
> xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
> xfs: simplify the flags setting in xfs_qm_scall_quotaon
> 
> > 
> > --D
> > 
> >>  	int		error;
> >>  	uint		qf;
> >>  
> >> -	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
> >>  	/*
> >> -	 * Switching on quota accounting must be done at mount time.
> >> +	 * Switching on quota accounting must be done at mount time,
> >> +	 * only consider quota enforcement stuff here.
> >>  	 */
> >> -	flags &= ~(XFS_ALL_QUOTA_ACCT);
> >> +	flags &= XFS_ALL_QUOTA_ENFD;
> >>  
> >>  	if (flags == 0) {
> >>  		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
> >> -- 
> >> 1.8.3.1
> >>
> 
> -- 
> kaixuxia
