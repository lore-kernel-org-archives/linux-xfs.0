Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D61C46466
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4349520757
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FU34DMz/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgJFE0e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:26:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52286 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgJFE0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:26:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964NqIG139513;
        Tue, 6 Oct 2020 04:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EnFCVr40GijYNBUBLuefIcCiCpw9Td8MNyvPxWP+qeo=;
 b=FU34DMz/Fx/TTBWOywaPlqjT5o7jDlDM0H6qtBwGszATcj/g9erIBOtyLDj2kpOtZ8Co
 U1kC24WAkeC1XY39sL41+6paL2t/Kxoz68wMXTRoFpmYJ3QjThzi4H66g8gUSLI5/0Lc
 TH9mDtDQqTcvdJeAjuYHkQjyG3AixcNDZhZhxvrqpnw7Dp414VUrB4kwoFR167YQ+sdi
 qf+y/6fzZcXM7L6/AjW6UpFd8nokjvVRWAFIGgTVSJDj4uXE5DgtSiNKAv51DXwJWkvC
 olcCoVIrWPefeLPTLEkn6+8EGWnujcaKAK6a4oK3BvArJHqqpcMP/RmeYaN5aaZJGF5k EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34ev4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:26:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964P6SB190464;
        Tue, 6 Oct 2020 04:26:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33yyjexbay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:26:31 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0964QU8P014355;
        Tue, 6 Oct 2020 04:26:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:26:29 -0700
Date:   Mon, 5 Oct 2020 21:26:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 11/12] xfs: Set tp->t_firstblock only once during a
 transaction's lifetime
Message-ID: <20201006042629.GQ49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-12-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003055633.9379-12-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=2 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 03, 2020 at 11:26:32AM +0530, Chandan Babu R wrote:
> tp->t_firstblock is supposed to hold the first fs block allocated by the
> transaction. There are two cases in the current code base where
> tp->t_firstblock is assigned a value unconditionally. This commit makes
> sure that we assign to tp->t_firstblock only if its current value is
> NULLFSBLOCK.

Do we hit this currently?  This seems like a regression fix, since I'm
guessing you hit this fairly soon after adding the next patch and
twisting the "shatter everything" debug knob it establishes?  And if
you can hit it there, you could hit this on a severely fragmented fs?

--D

> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 51c2d2690f05..5156cbd476f2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -724,7 +724,8 @@ xfs_bmap_extents_to_btree(
>  	 */
>  	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
>  	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
> -	tp->t_firstblock = args.fsbno;
> +	if (tp->t_firstblock == NULLFSBLOCK)
> +		tp->t_firstblock = args.fsbno;
>  	cur->bc_ino.allocated++;
>  	ip->i_d.di_nblocks++;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
> @@ -875,7 +876,8 @@ xfs_bmap_local_to_extents(
>  	/* Can't fail, the space was reserved. */
>  	ASSERT(args.fsbno != NULLFSBLOCK);
>  	ASSERT(args.len == 1);
> -	tp->t_firstblock = args.fsbno;
> +	if (tp->t_firstblock == NULLFSBLOCK)
> +		tp->t_firstblock = args.fsbno;
>  	error = xfs_trans_get_buf(tp, args.mp->m_ddev_targp,
>  			XFS_FSB_TO_DADDR(args.mp, args.fsbno),
>  			args.mp->m_bsize, 0, &bp);
> -- 
> 2.28.0
> 
