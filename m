Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD866C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C1BD20866
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aHi6lIZu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgHMO4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 10:56:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgHMO4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 10:56:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DEr3id119928;
        Thu, 13 Aug 2020 14:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HxTpxjHoITUgsncNZJx8RYijKRIJVadBt2cUcJl9+bk=;
 b=aHi6lIZuXc9j2PNy3NdzqvMtkKrECLxTy5+01hCx1oHbEXYU4GZYHrJ5i9MnzXDzKt61
 fF1fF+Dzi/pLqZKbgyrR30H7kkHtCBB7ZJNaHyA1TIIEkJKrmLu1R0OeDhc+GbXWN/qv
 TYibb8A/QrTL09r7h7kHQF9S66Vh5LAUNnXIgTLxuZXgOgbbTbyHIiODVghkookl0K2n
 RFiidRoQDOAoM6hb47dNk3jX8rHbsExYm+zGg+AyrdG4Xz15Vyk5MLqnTy0tGk+FK4zY
 EFsg0b9YNmDrVa90Fn4GZupXbt/KHxL5UqS8MIo9OXCj56MYStTVJuRlGotYvZioYpqt 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32sm0n14y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 14:56:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DErdTi161331;
        Thu, 13 Aug 2020 14:56:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32t5mrvpkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 14:56:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07DEuHv0020797;
        Thu, 13 Aug 2020 14:56:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 14:56:17 +0000
Date:   Thu, 13 Aug 2020 07:56:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: use correct inode to set inode type
Message-ID: <20200813145616.GI6096@magnolia>
References: <20200813060324.8159-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813060324.8159-1-zlang@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=1 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 02:03:24PM +0800, Zorro Lang wrote:
> A test fails as:
>   # xfs_db -c "inode 133" -c "addr" -c "p core.size" -c "type inode" -c "addr" -c "p core.size" /dev/sdb1
>   current
>           byte offset 68096, length 512
>           buffer block 128 (fsbno 16), 32 bbs
>           inode 133, dir inode -1, type inode
>   core.size = 123142
>   current
>           byte offset 65536, length 512
>           buffer block 128 (fsbno 16), 32 bbs
>           inode 128, dir inode 128, type inode
>   core.size = 42
> 
> The "type inode" get wrong inode addr due to it trys to get the
> beginning of an inode chunk, refer to "533d1d229 xfs_db: properly set
> inode type".

It took me a minute to figure out what this was referring to (though it
was obvious from the code change).  Might I suggest something like:

The "type inode" command accidentally moves the io cursor because it
forgets to include the io cursor's buffer offset when it computes the
inode number from the io cursor's location.

Fixes: 533d1d229a88 ("xfs_db: properly set inode type")

> We don't need to get the beginning of a chunk in set_iocur_type, due
> to set_cur_inode(ino) will help to do all of that and make a proper
> verification. We just need to give it a correct inode.
> 
> Reported-by: Jianhong Yin <jiyin@redhat.com>
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  db/io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 6628d061..61940a07 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -591,6 +591,7 @@ set_iocur_type(
>  	/* Inodes are special; verifier checks all inodes in the chunk */
>  	if (type->typnm == TYP_INODE) {
>  		xfs_daddr_t	b = iocur_top->bb;
> +		int		bo = iocur_top->boff;
>  		xfs_ino_t	ino;
>  
>  		/*
> @@ -598,7 +599,7 @@ set_iocur_type(
>   		 * which contains the current disk location; daddr may change.
>   		 */
>  		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> -			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> +			(((b << BBSHIFT) + bo) >> mp->m_sb.sb_inodelog) %
>  			XFS_AGB_TO_AGINO(mp, mp->m_sb.sb_agblocks));

/me feels like this whole thing ought to be revised into something
involving XFS_OFFBNO_TO_AGINO to make the unit conversions easier to
read, e.g.:

	xfs_daddr_t	b = iocur_top->bb;
	xfs_agbno_t	agbno;
	xfs_agino_t	agino;

	agbno = xfs_daddr_to_agbno(mp, b);
	agino = XFS_OFFBNO_TO_AGINO(mp, agbno,
			iocur_top->boff / mp->m_sb.sb_inodesize);
	ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b), agino);

--D

>  		set_cur_inode(ino);
>  		return;
> -- 
> 2.20.1
> 
