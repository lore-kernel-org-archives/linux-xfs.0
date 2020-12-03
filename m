Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1B6C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08222221F2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgLCVpV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:45:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgLCVpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 16:45:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LZb7W162324;
        Thu, 3 Dec 2020 21:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8CnLWe/tyo68lVZokxqvYEcsJl3vfxm5yqYmekjdANI=;
 b=wmSl8aBRri1xLU26WsD3CnHYk+rL7Y7MeT7QpNwv8Ux5OuderNeiDANatURkJVwiEqSE
 nPCDxIRxoi4iqMZXLXXNakJR+fGC4t5fwuC3sK7Xfr+tLjxv5iRM9rsxdku5WvuFKLTN
 mk2F8nNWvYHGwspqup2qYr3lpNIJJrz6hW5+AD/U1eFfT2X0s9bh+4JJoakSBVCg15cJ
 inffuZMAZHlPhq7S62ZhzylYDGrEUm2xFwVU5dXyTEMZ3ddl7T6+OlGztlO1AAZErI9d
 5rUkCUqZ8QLklIfu+5qE+XAKBVL5VP6zcXqTX2ZmMLbN37v8mwP/knUz4TQRHJ4rKL2O jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyr0dwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 21:44:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LfYAH194242;
        Thu, 3 Dec 2020 21:44:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540g2ghyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 21:44:37 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3LiaFk011794;
        Thu, 3 Dec 2020 21:44:37 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 13:44:36 -0800
Date:   Thu, 3 Dec 2020 13:44:36 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: don't catch dax+reflink inodes as corruption in
 verifier
Message-ID: <20201203214436.GA629293@magnolia>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <4b655a26-0e3c-3da7-2017-6ed88a46a611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b655a26-0e3c-3da7-2017-6ed88a46a611@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 01:16:09PM -0600, Eric Sandeen wrote:
> We don't yet support dax on reflinked files, but that is in the works.
> 
> Further, having the flag set does not automatically mean that the inode
> is actually "in the CPU direct access state," which depends on several
> other conditions in addition to the flag being set.
> 
> As such, we should not catch this as corruption in the verifier - simply
> not actually enabling S_DAX on reflinked files is enough for now.
> 
> Fixes: 4f435ebe7d04 ("xfs: don't mix reflink and DAX mode for now")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index c667c63f2cb0..4d7410e49db4 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -547,10 +547,6 @@ xfs_dinode_verify(
>  	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
>  		return __this_address;
>  
> -	/* don't let reflink and dax mix */
> -	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
> -		return __this_address;

If we're going to let in inodes with the DAX and REFLINK iflags set,
doesn't that mean that xfs_inode_should_enable_dax needs to return false
if REFLINK is set?

--D

> -
>  	/* COW extent size hint validation */
>  	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
>  			mode, flags, flags2);
> -- 
> 2.17.0
> 
