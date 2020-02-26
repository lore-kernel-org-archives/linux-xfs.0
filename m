Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1027C4BA13
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D32206E6
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 16:28:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LOeELr7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgBZQ2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:28:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgBZQ2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 11:28:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QGMhGw065270;
        Wed, 26 Feb 2020 16:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rSpxlhkAatwy5CEDZO3Imq99OvHCaK7NacrlAX8vWKw=;
 b=LOeELr7zmIww0rks3k14dOY9o7JD1FLuXk2A77TyJ1M63qgaRhmJdHrpomlI/rRNQ+s5
 HYejiw/0yhmqtE2iiR6Y6Bv/et8BrK89cSqRp7l81fXlkbVQdM80maarn+oK4vNbeApI
 t8zCWI4YNaVpmPM/n9/YVVVFrh8ApVqBNJzNXM1u4nGLp1dAY/u80fxMtV1n3ie71Tvr
 7Mn+wByuH9BezL40rac/vWYM/eqsdzqfUwAOkH1raBYvi7sVN2FMhPVyQB4WyK6A4P/x
 /ibpoaLGZHqmBytO6jLhd2rcCjeK5jEOh95Fj/c/GwtWPWiCt/YiNxo6wGtWs/65KhPy Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct34sh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:28:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QGMe4H076138;
        Wed, 26 Feb 2020 16:28:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ydcsa5u2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:28:38 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01QGSbEU002323;
        Wed, 26 Feb 2020 16:28:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 08:28:37 -0800
Date:   Wed, 26 Feb 2020 08:28:36 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qian Cai <cai@lca.pw>
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xfs: fix an undefined behaviour in _da3_path_shift
Message-ID: <20200226162836.GC8045@magnolia>
References: <20200226020637.1065-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226020637.1065-1-cai@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=31 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=31 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:06:37PM -0500, Qian Cai wrote:
> In xfs_da3_path_shift() "blk" can be assigned to state->path.blk[-1] if
> state->path.active is 1 (which is a valid state) when it tries to add an
> entry to a single dir leaf block and then to shift forward to see if
> there's a sibling block that would be a better place to put the new
> entry. This causes a UBSAN warning given negative array indices are
> undefined behavior in C. In practice the warning is entirely harmless
> given that "blk" is never dereferenced in this case, but it is still
> better to fix up the warning and slightly improve the code.
> 
>  UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_da_btree.c:1989:14
>  index -1 is out of range for type 'xfs_da_state_blk_t [5]'
>  Call trace:
>   dump_backtrace+0x0/0x2c8
>   show_stack+0x20/0x2c
>   dump_stack+0xe8/0x150
>   __ubsan_handle_out_of_bounds+0xe4/0xfc
>   xfs_da3_path_shift+0x860/0x86c [xfs]
>   xfs_da3_node_lookup_int+0x7c8/0x934 [xfs]
>   xfs_dir2_node_addname+0x2c8/0xcd0 [xfs]
>   xfs_dir_createname+0x348/0x38c [xfs]
>   xfs_create+0x6b0/0x8b4 [xfs]
>   xfs_generic_create+0x12c/0x1f8 [xfs]
>   xfs_vn_mknod+0x3c/0x4c [xfs]
>   xfs_vn_create+0x34/0x44 [xfs]
>   do_last+0xd4c/0x10c8
>   path_openat+0xbc/0x2f4
>   do_filp_open+0x74/0xf4
>   do_sys_openat2+0x98/0x180
>   __arm64_sys_openat+0xf8/0x170
>   do_el0_svc+0x170/0x240
>   el0_sync_handler+0x150/0x250
>   el0_sync+0x164/0x180
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Qian Cai <cai@lca.pw>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
>  v3: Borrow the commit log from Christoph.
>  v2: Update the commit log thanks to Darrick.
>      Simplify the code.
> 
>  fs/xfs/libxfs/xfs_da_btree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 875e04f82541..e864c3d47f60 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1986,7 +1986,8 @@ xfs_da3_path_shift(
>  	ASSERT(path != NULL);
>  	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
>  	level = (path->active-1) - 1;	/* skip bottom layer in path */
> -	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
> +	for (; level >= 0; level--) {
> +		blk = &path->blk[level];
>  		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
>  					   blk->bp->b_addr);
>  
> -- 
> 2.21.0 (Apple Git-122.2)
> 
