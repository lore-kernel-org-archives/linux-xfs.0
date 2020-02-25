Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EEFC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FA26218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jberP9z2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgBYP2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:28:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730909AbgBYP2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:28:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PFMc5D166113;
        Tue, 25 Feb 2020 15:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QcZS5lMH3wDuFbdyCB3lV7H4pgtB/EwySYkm0WpKeDw=;
 b=jberP9z2mahDz1P48DfV1wYHh7pxUH2nJ1DHQ+dXdBvnCfTvvjTsspsTiJRgA8gQrVXC
 mmM0DSuSfznJRZsgZQHPgrEOFZEXiCqoEMP2RZEUizQevkuVFQChThDyy4dffkMErIKd
 7f2TUIt8y6Hc3ZEF63oy9SdBG5f7huNzHWTVi1YfwK/t5Ka934G5kS5v+xtwF029Zdue
 AZJe0zq3q9teRklY67swue/uLu+EGn2J+pgzdlRbfCRIuAxnAIEtl67j9WHIJlLdu3rn
 zVQMgge4hoqPRTsuPhSCeOBwM2hpGHTpo8FG4E0kTYH+VYHxEt78JKsrcxAm87F3Stm9 kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yd0m1t4qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:28:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PFHxX1077230;
        Tue, 25 Feb 2020 15:28:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yd17q5gpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:28:08 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PFS6tM003779;
        Tue, 25 Feb 2020 15:28:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 07:28:06 -0800
Date:   Tue, 25 Feb 2020 07:28:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qian Cai <cai@lca.pw>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix an undefined behaviour in _da3_path_shift
Message-ID: <20200225152805.GG6740@magnolia>
References: <1582641477-4011-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582641477-4011-1-git-send-email-cai@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=31 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=31 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:37:57AM -0500, Qian Cai wrote:
> state->path.active could be 1 in xfs_da3_node_lookup_int() and then in
> xfs_da3_path_shift() could see state->path.blk[-1].

Under what circumstancs can it be 1?  Is this a longstanding bug in XFS?
A corrupted filesystem?  A deliberately corrupted filesystem?

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
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 875e04f82541..0906b7748a3f 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1986,7 +1986,11 @@ static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
>  	ASSERT(path != NULL);
>  	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
>  	level = (path->active-1) - 1;	/* skip bottom layer in path */
> -	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
> +
> +	if (level >= 0)
> +		blk = &path->blk[level];

...because if the reason is "corrupt metadata" then perhaps this should
return -EFSCORRUPTED?  But I don't know enough about the context to know
the answer to that question.

--D

> +
> +	for (; level >= 0; blk--, level--) {
>  		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
>  					   blk->bp->b_addr);
>  
> -- 
> 1.8.3.1
> 
