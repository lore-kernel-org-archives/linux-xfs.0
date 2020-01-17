Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6E3C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B32B22082F
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:17:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ciYbDhSN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgAQGRC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:17:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgAQGRC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:17:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68VoP186719;
        Fri, 17 Jan 2020 06:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=4TOKhipqmrCsgvCLGU5jhoCV7/t8LwEnDe/T9FY/bdY=;
 b=ciYbDhSNXaZI4kmd62VzISKNQqEwMNgub4uKinaEjmjtRlDpo9+DIIw3ookHr+Z/ZFDT
 bJh/+MdDIQ8dQ/BwKZN3Sc95pAlELceNMdmlmJsXkuapi9UyL9wDzSowuBcDBSk+AZpw
 JG0XiRBy9vo+oNriDRkeAotnRGLknYa8tHs1GsR6tiLSTg8rqyfKzt9r7LTZUEFTc3Q/
 eOzSP+DegprTi7M/UgRvu6zm+zrJ26XYM0K7Ts5rikFxt/A1P1INIOhZAYwwJy2Q2Liy
 /VmoOi2NBUf9KnbhUjac6iD8YZQyMQWwX8emFG4dAWPPafsyKhW2HtBUr5euAKvua2yr /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74spsg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:16:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H69HnS076237;
        Fri, 17 Jan 2020 06:16:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xk2309qtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:16:51 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H6Gn32031289;
        Fri, 17 Jan 2020 06:16:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:16:49 -0800
Date:   Thu, 16 Jan 2020 22:16:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove unused variable 'done'
Message-ID: <20200117061647.GR8247@magnolia>
References: <20200117015011.50412-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117015011.50412-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 17, 2020 at 09:50:11AM +0800, YueHaibing wrote:
> fs/xfs/xfs_inode.c: In function 'xfs_itruncate_extents_flags':
> fs/xfs/xfs_inode.c:1523:8: warning: unused variable 'done' [-Wunused-variable]
> 
> commit 4bbb04abb4ee ("xfs: truncate should remove
> all blocks, not just to the end of the page cache")
> left behind this, so remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1309f25..1979a00 100644
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
> -- 
> 2.7.4
> 
> 
