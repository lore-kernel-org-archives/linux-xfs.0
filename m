Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB10DC4363A
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94EA2222BA
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KfxrEq0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764056AbgJXTaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 15:30:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48808 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764055AbgJXTaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 15:30:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJUe2f050328;
        Sat, 24 Oct 2020 19:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wht3laSmhNg88vto8y4kjuJFARvjMcJpSZ+ksv56PAA=;
 b=KfxrEq0faGHrYi2htjuVArM11BXMHoFFZ6AtzFjZSUA6XOPKVGhzfccJoubB1YAK079F
 Bm/dNlXqVpkr3fcClIpGc8/ox7Zgk+gWthOFNkZPKDgb1vFE2Yt7XALNJ6eYhufLfYbB
 48WHiyHww7u5c6zupw81IUcri2y42KO5XkqLl7nrcSoXT76I2EFe7MzELOkB810n/eGe
 j2hMBCb3ORQydcdp+8tzdXruEWQ7sJ3d17mQFjRnD+PTJ+eyb/wqZ7vAo6QSn6dryKSj
 22Jnfr4Mi1wY+VQT1CO+2tS2B6nsyPcbvLQuuCQdcVoVbaRpDStP2sjdWylbvBf1I0ze MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sah6ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 19:30:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJK613052350;
        Sat, 24 Oct 2020 19:28:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cbkhn743-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 19:28:39 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OJSXUd029921;
        Sat, 24 Oct 2020 19:28:33 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 12:28:33 -0700
Subject: Re: [PATCH V7 01/14] xfs: Add helper for checking per-inode extent
 count overflow
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-2-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <bbf1a3d5-4658-7c15-be20-ca4a252536c3@oracle.com>
Date:   Sat, 24 Oct 2020 12:28:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-2-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240149
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> XFS does not check for possible overflow of per-inode extent counter
> fields when adding extents to either data or attr fork.
> 
> For e.g.
> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
>     then delete 50% of them in an alternating manner.
> 
> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
>     extents to be created in the attr fork of the inode.
> 
>     xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> 
> 3. The incore inode fork extent counter is a signed 32-bit
>     quantity. However the on-disk extent counter is an unsigned 16-bit
>     quantity and hence cannot hold 98511 extents.
> 
> 4. The following incorrect value is stored in the attr extent counter,
>     # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
>     core.naextents = -32561
> 
> This commit adds a new helper function (i.e.
> xfs_iext_count_may_overflow()) to check for overflow of the per-inode
> data and xattr extent counters. Future patches will use this function to
> make sure that an FS operation won't cause the extent counter to
> overflow.
> 
Looks good to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
>   fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>   2 files changed, 25 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7575de5cecb1..8d48716547e5 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -23,6 +23,7 @@
>   #include "xfs_da_btree.h"
>   #include "xfs_dir2_priv.h"
>   #include "xfs_attr_leaf.h"
> +#include "xfs_types.h"
>   
>   kmem_zone_t *xfs_ifork_zone;
>   
> @@ -728,3 +729,25 @@ xfs_ifork_verify_local_attr(
>   
>   	return 0;
>   }
> +
> +int
> +xfs_iext_count_may_overflow(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	int			nr_to_add)
> +{
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	uint64_t		max_exts;
> +	uint64_t		nr_exts;
> +
> +	if (whichfork == XFS_COW_FORK)
> +		return 0;
> +
> +	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
> +
> +	nr_exts = ifp->if_nextents + nr_to_add;
> +	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> +		return -EFBIG;
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index a4953e95c4f3..0beb8e2a00be 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>   
>   int xfs_ifork_verify_local_data(struct xfs_inode *ip);
>   int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> +int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
> +		int nr_to_add);
>   
>   #endif	/* __XFS_INODE_FORK_H__ */
> 
