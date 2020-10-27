Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CE8C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B76BB21D7B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C99VFlYa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505915AbgJ0Ff5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 01:35:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40108 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505912AbgJ0Ff5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 01:35:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5ZUA5028992;
        Tue, 27 Oct 2020 05:35:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9oTqLZR0W6XvZYmzPKlhiYktLoil1Jk86c7b44154lE=;
 b=C99VFlYaRaeg0xwRGhA0mhlT+j+xzvx2Di5mlM+MZ/Z9Js2nO9s+wGcC6b5KWh7wtyKa
 l9C8lf4fvRCBkZKZH7WFtZ1zWSxl2seOJ066UI9DlcqcfuNYS+Ed/UVmaHMWXBdbUpaO
 OpwdND7090mj8xX9gZ/G0s3AnMIelNaeY1nJEMYm43N4UzEBVhPq1arvcFfQ85929hMD
 amHu0p8QgAk1tdIwVhzzGVjFyuNzRdxTT8mzOgb/gW+I0mcwNRcp7QUs/R670s/NUzRQ
 iRN8z0olSQ2BurE5Gmp+pzBEQ0QW4fIkmr50XuUvx+VGvyjbdjM5piZ+52P98nWx4QSk Zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sar2hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 05:35:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5ZJSn064566;
        Tue, 27 Oct 2020 05:35:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6vhw83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 05:35:54 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09R5ZrfC017686;
        Tue, 27 Oct 2020 05:35:53 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 22:35:53 -0700
Subject: Re: [PATCH 4/5] xfs_repair: skip the rmap and refcount btree checks
 when the levels are garbage
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375513815.879169.8550751453198927018.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <25e4d31b-7af6-b90a-1c14-7d6a2fa8a3b7@oracle.com>
Date:   Mon, 26 Oct 2020 22:35:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160375513815.879169.8550751453198927018.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270037
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/26/20 4:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In validate_ag[fi], we should check that the levels of the rmap and
> refcount btrees are valid.  If they aren't, we need to tell phase4 to
> skip the comparison between the existing and incore rmap and refcount
> data.  The comparison routines use libxfs btree cursors, which assume
> that the caller validated bc_nlevels and will corrupt memory if we load
> a btree cursor with a garbage level count.
> 
> This was found by examing a core dump from a failed xfs/086 invocation.
> 
Ok, looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   repair/scan.c |   36 ++++++++++++++++++++++++++----------
>   1 file changed, 26 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 42b299f75067..2a38ae5197c6 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -2279,23 +2279,31 @@ validate_agf(
>   
>   	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
>   		struct rmap_priv	priv;
> +		unsigned int		levels;
>   
>   		memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
>   		priv.high_key.rm_blockcount = 0;
>   		priv.agcnts = agcnts;
>   		priv.last_rec.rm_owner = XFS_RMAP_OWN_UNKNOWN;
>   		priv.nr_blocks = 0;
> +
> +		levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
> +		if (levels >= XFS_BTREE_MAXLEVELS) {
> +			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
> +				levels, agno);
> +			rmap_avoid_check();
> +		}
> +
>   		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
>   		if (libxfs_verify_agbno(mp, agno, bno)) {
> -			scan_sbtree(bno,
> -				    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
> -				    agno, 0, scan_rmapbt, 1, XFS_RMAP_CRC_MAGIC,
> -				    &priv, &xfs_rmapbt_buf_ops);
> +			scan_sbtree(bno, levels, agno, 0, scan_rmapbt, 1,
> +					XFS_RMAP_CRC_MAGIC, &priv,
> +					&xfs_rmapbt_buf_ops);
>   			if (be32_to_cpu(agf->agf_rmap_blocks) != priv.nr_blocks)
>   				do_warn(_("bad rmapbt block count %u, saw %u\n"),
>   					priv.nr_blocks,
>   					be32_to_cpu(agf->agf_rmap_blocks));
> -		} else  {
> +		} else {
>   			do_warn(_("bad agbno %u for rmapbt root, agno %d\n"),
>   				bno, agno);
>   			rmap_avoid_check();
> @@ -2303,20 +2311,28 @@ validate_agf(
>   	}
>   
>   	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		unsigned int	levels;
> +
> +		levels = be32_to_cpu(agf->agf_refcount_level);
> +		if (levels >= XFS_BTREE_MAXLEVELS) {
> +			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
> +				levels, agno);
> +			refcount_avoid_check();
> +		}
> +
>   		bno = be32_to_cpu(agf->agf_refcount_root);
>   		if (libxfs_verify_agbno(mp, agno, bno)) {
>   			struct refc_priv	priv;
>   
>   			memset(&priv, 0, sizeof(priv));
> -			scan_sbtree(bno,
> -				    be32_to_cpu(agf->agf_refcount_level),
> -				    agno, 0, scan_refcbt, 1, XFS_REFC_CRC_MAGIC,
> -				    &priv, &xfs_refcountbt_buf_ops);
> +			scan_sbtree(bno, levels, agno, 0, scan_refcbt, 1,
> +					XFS_REFC_CRC_MAGIC, &priv,
> +					&xfs_refcountbt_buf_ops);
>   			if (be32_to_cpu(agf->agf_refcount_blocks) != priv.nr_blocks)
>   				do_warn(_("bad refcountbt block count %u, saw %u\n"),
>   					priv.nr_blocks,
>   					be32_to_cpu(agf->agf_refcount_blocks));
> -		} else  {
> +		} else {
>   			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
>   				bno, agno);
>   			refcount_avoid_check();
> 
