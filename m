Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EF2C3F2C0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 21:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC1A02468E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 21:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P3VUiuTE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgB0VA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 16:00:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56006 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgB0VA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 16:00:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKqnE7026412;
        Thu, 27 Feb 2020 21:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1j1wIGZzkncxnj7jsTz8jSjZfonsf/xDL6AfRKZbpJs=;
 b=P3VUiuTEpkX3yOyb3kOZY4EpYte+M7RIoL8GrXwVL1gPk45ivphXne+nzEg/zhdz1z4C
 OVXGTOOQ+MsJ+cCbwsdK41B4EVwYWVhn/QKeL7pA+mF7ewgUkkkaC9egqWcoSs4MnaG2
 O49B8g1s+QVnkGPMYua+JfSOj3bDcYpvyN0nr8EFZFNZo6/kJKSCpAdJR7Pa38d2ibOF
 vGzwk2+GhL7KjwAYTrYGFwBp5127vMG9cgXfkIyvXOC2KTKdaHJ6q8nUNKRyjnDlrT6H
 n3yJUgyuRHlw2cYL4obG6s+Ha8WAfpUVdxNeGMSH41NDALP2/92cD99cExDj0ZzGmtbt UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct3dm8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 21:00:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKm8H4005466;
        Thu, 27 Feb 2020 21:00:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ydj4nm3s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 21:00:55 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RL0seO019366;
        Thu, 27 Feb 2020 21:00:54 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 13:00:54 -0800
Date:   Thu, 27 Feb 2020 13:00:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: join realtime inodes to transaction only once
Message-ID: <20200227210052.GO8045@magnolia>
References: <85aaa9e9-8aa4-301d-741a-94d4ef2291d6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85aaa9e9-8aa4-301d-741a-94d4ef2291d6@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 12:50:54PM -0800, Eric Sandeen wrote:
> fill_rbmino() and fill_rsumino() can join the inode to the transactions
> multiple times before committing, which is not permitted.
> 
> This leads to cache purge errors when running repair:
> 
>   "cache_purge: shake on cache 0x92f5c0 left 129 nodes!?"
> 
> Move the libxfs_trans_ijoin out of the while loop to avoid this.
> 
> Fixes: e2dd0e1cc ("libxfs: remove libxfs_trans_iget")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks reasonable, insofar as I have a patchset to port a few more kernel
APIs to xfsprogs so thta we can replace all the opencoded file setting
code in mkfs/repair to use that.

OH, heh, I never sent that.  Sigh....

This code takes advantage of behavioral differences between xfsprogs
transactions and kernel transactions to wrap up all the bmapi_write
calls in a single transaction.  This whole loop thing looks *weird* but
this does fix the ijoin usage to be correct WRT userspace transactions,
so...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 70135694..7bbc6da2 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -645,7 +645,6 @@ fill_rbmino(xfs_mount_t *mp)
>  		/*
>  		 * fill the file one block at a time
>  		 */
> -		libxfs_trans_ijoin(tp, ip, 0);
>  		nmap = 1;
>  		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
>  		if (error || nmap != 1) {
> @@ -676,6 +675,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
>  		bno++;
>  	}
>  
> +	libxfs_trans_ijoin(tp, ip, 0);
>  	error = -libxfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
> @@ -716,7 +716,6 @@ fill_rsumino(xfs_mount_t *mp)
>  		/*
>  		 * fill the file one block at a time
>  		 */
> -		libxfs_trans_ijoin(tp, ip, 0);
>  		nmap = 1;
>  		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
>  		if (error || nmap != 1) {
> @@ -748,6 +747,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
>  		bno++;
>  	}
>  
> +	libxfs_trans_ijoin(tp, ip, 0);
>  	error = -libxfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
> 
