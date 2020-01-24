Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D32BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C555320718
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XhTGPZVC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgAXFYj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:24:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60850 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbgAXFYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:24:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IW0W059460;
        Fri, 24 Jan 2020 05:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=rLcMyfNrY7uJF+Ux81aRZApbQoVaorKWRTXHRXiTtJc=;
 b=XhTGPZVC/sxKfQ2pptWMi4F4ZSg3CjxA9X7wlntT0/YK6Gz+c7cGSMgtvIzsFm4XTWNx
 d7FdJbroUTA7q49UySJHKOJkXjwCF68qHrQaWWoX9j6HuoEqN9kkU9r1jpcwT+dViZq3
 5jWVnMH0+WcdXIOIQQEDllTH70bcykn6ryoFWNIHEfRQqw1ldo1F9FZaSaaqdX2UgK7c
 DgTw9sjzOnzLShtPVLSWlASnlFamnuS5y3qaPPB+5BApcqN5cYbGPK0IblKSCYZw03ng
 MiD8NXF6aGl5ci7ZFHv2V1PW88MIEDOvPkV0nAFZ1jFBj32Amd083sJxfXUvjypA6j+c hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseuy386-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:24:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IJPw156108;
        Fri, 24 Jan 2020 05:24:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xqmuy3p4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:24:34 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O5OXV1007037;
        Fri, 24 Jan 2020 05:24:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:24:33 -0800
Date:   Thu, 23 Jan 2020 21:24:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] xfs: remove unnecessary variable
Message-ID: <20200124052432.GF8247@magnolia>
References: <20200124052210.GV8257@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124052210.GV8257@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:22:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Stephen Rothwell reported an unused variable.  Remove it.
> 
> Fixes: 4bbb04abb4ee ("xfs: truncate should remove all blocks, not just to the end of the page cache")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

self NAK, YueHaibing already sent this, which going through bash history
I evidently misapplied and ... yeah.  I've lost my marbles. :(

--D

> ---
>  fs/xfs/xfs_inode.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1309f25c0d2b..1979a0055763 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1520,7 +1520,6 @@ xfs_itruncate_extents_flags(
>  	xfs_fileoff_t		first_unmap_block;
>  	xfs_filblks_t		unmap_len;
>  	int			error = 0;
> -	int			done = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
