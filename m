Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00709C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC9A660F25
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhITKMR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:12:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5480 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235607AbhITKMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:12:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K9qF1w028218;
        Mon, 20 Sep 2021 10:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ChemLjfoCJPImDhe/aZN+E0y07oShuJ30KdhhXq1Myg=;
 b=weUZCAA8QVO9si/NAM8oM4Brmt3tH1uUSXmHpVB74pDN6p83lulgLoGCymkQq5eokiJ/
 m/wcGnMIjYGRlT8LU6YAKYO0vwtOr1qp9UgNpW7J7SgTC7sKE2r/bCr5cXTY26qOHQqI
 iMfNfSa1fK3onS0E55ojuiY8hWnyv/RvNn/3XxScOP+2/OLGehIN6uoOuCt0jvAoUcIa
 v6yo7+v//308wcDv/SCQs1aM7Yu35BJE4IliOCxdbhmZEPSWaz/UxAsWvo+3FrYXphsY
 UCEf7z0FV6UoFueotx2YJel0EybdPPYyUjKtmQhS6r1m85JVJqFm3oSQxlgesgcpPYjJ Xg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ChemLjfoCJPImDhe/aZN+E0y07oShuJ30KdhhXq1Myg=;
 b=eFcR+9+hUJ+v9tecgfxrN5tYCWqL6dqMeLTvFT375qcEki368PV4I2mEn1guTfFTWLUQ
 AsAB/j9ZZLtR6Wu5WlG+0S/q5urC1TT5g9k8bJxiy/n6gICz6331hUIjEnFpf352KHSK
 0RkXvhY9gik41zxUQ+8GhNTSPuJW1D7oBGtBNGkZq94+LHrrUj7z8yilhgEAl9elDLVY
 dCisB7PDj7cSrQpHXTaatfE/EJwdAFW5ABBA8DJasP9UHlEIcyfgaWTUv+zcg6n2iwjV
 JlP1HWV/vJiYCBCEw/ds/efiPLI10XbMvm0w+5M1abyTQOVeICx3Bvt2tmr873rpRjjn 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66wn1svy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAAh1r115987;
        Mon, 20 Sep 2021 10:10:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 3b57x3ty8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoB4ZSAch8PAdaVkjS+ub8DLejeaegPtw12vMZRjXe1odgHbJXKzhxyJ2V5l9LgY1djBP0nksRrWQ+aQtAJ4PPF2UEG9Xhx/HBKEc80Bu7M/vU+XXQ1k4r8dlSz6/M2/TKNA+OcMeBy75D4GLj/MH0WLDN4qfRZJORl4BFiThqV5jynAkQGdfBxdoqqpZzBG9PbZvyyJ8PoJasTxDgEW86GfKuBOtIGojz1RyxyQo59OyVsvDqRphAgCLvvrNJ35qtgCVMKHTqXd0CbrNbdiMN6mL48/nKOjet1Man+re9XQMW1IupEW5SWFVnsoLCCyNMF52IcXZ35stxA64ZLlqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ChemLjfoCJPImDhe/aZN+E0y07oShuJ30KdhhXq1Myg=;
 b=H6ztTTGZ3C1IkLeW6J3x5d9hYYhxXV6pbpmdOorRv/au9tPzhT9VbCrdW4NCEwz9Ou5zm5XFkpN22PuvkJT4hKXxRvWU2Zbwf/4EW79EEAnVZtpEpls1hAmPJxVz5mnfY+fytCYYpz8U2llYV9XDnfkcTuYLriAIrydcm45u/hQbwazbdB6MR/RC/MF8N4+I000KhbITvHcTMcforpASvxtmWFOgYP1uWscJz3DXKTGhP7TGjai6RRsh3ABDCr8RbulvgafdhHy89xIm1pmZBPcLT24zGA+Gf9E6gToizukddl6I2mWXAmbGZcDndWx07Lu90TLuHGDp8BlEKy3rxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChemLjfoCJPImDhe/aZN+E0y07oShuJ30KdhhXq1Myg=;
 b=RY0ucfasG9Pdh2u6lTuwlkoKy9ZwZZt1wmgBFsJHSxxQB3rSeR3n8WsVXS8Igv8WOvQ22xtHc9hDzAsnH7qDcGAw5kJdcyRzYse9Z+1qBuOgz5C87VCC8l31BGYZpqjR/RT97lJOjibve4+D7ALDS3LPvtsEAvKVW83q2yWGI94=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:10:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:10:38 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192858823.416199.17720760425094444911.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/14] xfs: support dynamic btree cursor heights
In-reply-to: <163192858823.416199.17720760425094444911.stgit@magnolia>
Message-ID: <87k0jb7erv.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:25:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:10:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ece1d2e-5765-4033-5eec-08d97c1ee458
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4540869666F8F66CC6F9C907F6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:18;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hpQMrrJRXV826Uo5eReHRAX8gHNZhHochtXZtZgGfsuWp6M60lgUNRpJBOtx+YOCsW+0FPhmA9YT7ZdZMH7xm5Fk2DEPC5rBBgmDbtWQrPkJo62O5Dvd8xIdnWgl/3zIld0eWmIy5nviJrymtOb6KM2O6bEl9m0QIveaL9bMHNAVSxKBeoRCET44w3E9NsIYldLyxvhOQ5dLtXxNyBeTIsOzQQyfssGJT/6gRqLa/XOiFp57sO4QkKMpfWqQmZxGEwOoKE9IjEc4NC1dc4UfB3k5gRctPF9uuzufDFsEx7oyoZn7rsuhGCTrpgxejS83by/AkO3+6JcVRx+1gGVy7iqpg98/1By30zJlmGJBnC2Vth8jl1sW/8iEiWXMLR6F1kT6yQAqW4Y8YLHmUByh+fdU1VI4G8Lt25hQB7/PHMQuBlmiw9tGS7Un7lOfO0z3GTWMTslXn7iElZFyyInoEi96liOShns+ARvWheGGLN7No21T/gxnQ12atAFT5awQEgeU+CajKQeNF82uOx47aBPYF8n3VbyO/E3b6wZMfbk5WZim1Ymj56fUJNI7LOQukIuir/WsOpfDcRwTv0sw50NJqCr0unMMVO03KLrCFC8cJojyYuWEePYXcM2yZyhcU9IKN3+BuaLbwSI4eHEF/g1OkUxkpozTTxO8TFrpC8hJwc2YfylUtHziOGm6aM8CB4UAUS2ynpieYBFdgfKDyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(30864003)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YRqFBrwOq5tD4R3itMMQ9YMwuO/esbkiihvgsydy5/8Dsa+wfEDrcdqrzOq5?=
 =?us-ascii?Q?JZOe4Nf3MNOrT37zm4sTmOEaQXblOW2/DLi9juS5A9S8wqpgZwcPnFSRlnOj?=
 =?us-ascii?Q?XpIJX8XZhBwFWII3E87JjjOuSR/IsjzF4qC7O7Lae9eHfqjj19HRKKLYNM0s?=
 =?us-ascii?Q?/omqD7K8SoX2IrD3so/eRQkPCw9F59VMrl2KKLRZCWNTtMGQeakPwbIIWmHE?=
 =?us-ascii?Q?P7QyhiN/5R+9Atad+pRbAEvZBpWMObYjbELd7q80sCUTxxIXskgE0tLn9ysf?=
 =?us-ascii?Q?NyRZEWAhTXvFu1c4pLf+AUBZXGeddUYAcTHP4Owrezv2FpKUElsqT2CqEuV5?=
 =?us-ascii?Q?30Fi7d3n5FtV6Hk1uxH4gTv0F48LYSfp77Wd2shlOSwVMvmwm2H+Q4sOo7dl?=
 =?us-ascii?Q?TYlsJScFYpFfNSL9VK0ipNuf8YfV0dyunNmoil/lrAmQz9tZad+lecS5S5Kr?=
 =?us-ascii?Q?2nfdUu3QJTZqVk1LfBokUp497GcbnMmp/FxO7jSTaxzwed0qugG+h2/9xebk?=
 =?us-ascii?Q?glixCKJUv3F7UuZFhUAUC7O8CMGkk8X75MP+pgdsL5Kg2JWvGEQPNHxWEz2G?=
 =?us-ascii?Q?VPKHBsWnjX2VKWb0Uv2NjanBI/1tZ7R6RsSTNfU5erdqa7z1y3CCFKXVbOrl?=
 =?us-ascii?Q?iBONsYI9b2dhQt3/utUx2V5j550Ts+ESh6bIZDG4dpXcVUbspnVT99lcNcD5?=
 =?us-ascii?Q?W8EGEaZ8mLNXRqPvSJhjk8cTA6ltXE0KoDD9gySop4RZlozpy+kTgnCUZTJy?=
 =?us-ascii?Q?CZI1dGq2On+qMNfY4HEMDG1CiHfqELr1YJjfccsX6flMcIshgWI/FDbSWPXc?=
 =?us-ascii?Q?FO3P0mHjCxw/4zpDDCybfTOWKPR26TGwS7Mq4eDvulRFkJZ8cgqP+1AJ7XR/?=
 =?us-ascii?Q?YnVq3XwLpAgDf+7sB3VCLHcEDaolv4cWjs+mWpyli+0HtMjdavl9PTcRrgBv?=
 =?us-ascii?Q?TNceeaKm2HmE5Zo/xIXNFfN71jNLcd5Y8tziwxVPKd1xFxbV8N/bjdW7KxVf?=
 =?us-ascii?Q?nPop3VUU/ciynltpdM0cxHxiqsp3oI5xiMPkeQM1Kz0OlQXFiVmlwyByzqkR?=
 =?us-ascii?Q?mFYD3eNCvL1gfQ8v/odiKh0IGoQn0tT6/vcl3rsqnSJhkTckyxJoDPcUrzgp?=
 =?us-ascii?Q?0s6aZtq0qA2/HXzgU6d7qYIqXMX3qBPF4CXWyFgVLlaI2A7uGTAkNM8Aq+5Z?=
 =?us-ascii?Q?ITX1scEvfrFq7grDVjt47CPIMN4aL8CKhBMMfClSERLwh4DxaaydHn3hV7E5?=
 =?us-ascii?Q?NLPSoc493hBaIdMJPXQdiO3F8t0593oag5YaMfjvndJxjGzokyV5A8kQPKex?=
 =?us-ascii?Q?WAnLVI5L1PLPfMIkf91Hn4iT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ece1d2e-5765-4033-5eec-08d97c1ee458
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:10:38.2158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6SlvbvCWKelDi1xlOV+Q7ve3vHMmgy6LpxQU47J8dkz+UJIeZ1+ysPO6MrVoC4tk7KGLj11NB5ZIbAScY0C2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200063
X-Proofpoint-GUID: g5JhAt5Jpk26mBm_YacmqKM2CJKqu0xw
X-Proofpoint-ORIG-GUID: g5JhAt5Jpk26mBm_YacmqKM2CJKqu0xw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Split out the btree level information into a separate struct and put it
> at the end of the cursor structure as a VLA.  The realtime rmap btree
> (which is rooted in an inode) will require the ability to support many
> more levels than a per-AG btree cursor, which means that we're going to
> create two btree cursor caches to conserve memory for the more common
> case.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |    6 +-
>  fs/xfs/libxfs/xfs_bmap.c  |   10 +--
>  fs/xfs/libxfs/xfs_btree.c |  154 +++++++++++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_btree.h |   28 ++++++--
>  fs/xfs/scrub/bitmap.c     |   16 ++---
>  fs/xfs/scrub/bmap.c       |    2 -
>  fs/xfs/scrub/btree.c      |   40 ++++++------
>  fs/xfs/scrub/trace.c      |    7 +-
>  fs/xfs/scrub/trace.h      |   10 +--
>  fs/xfs/xfs_super.c        |    2 -
>  fs/xfs/xfs_trace.h        |    2 -
>  11 files changed, 147 insertions(+), 130 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 35fb1dd3be95..55c5adc9b54e 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -488,8 +488,8 @@ xfs_alloc_fixup_trees(
>  		struct xfs_btree_block	*bnoblock;
>  		struct xfs_btree_block	*cntblock;
>  
> -		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_bufs[0]);
> -		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_bufs[0]);
> +		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_levels[0].bp);
> +		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_levels[0].bp);
>  
>  		if (XFS_IS_CORRUPT(mp,
>  				   bnoblock->bb_numrecs !=
> @@ -1512,7 +1512,7 @@ xfs_alloc_ag_vextent_lastblock(
>  	 * than minlen.
>  	 */
>  	if (*len || args->alignment > 1) {
> -		acur->cnt->bc_ptrs[0] = 1;
> +		acur->cnt->bc_levels[0].ptr = 1;
>  		do {
>  			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
>  			if (error)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 499c977cbf56..644b956301b6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -240,10 +240,10 @@ xfs_bmap_get_bp(
>  		return NULL;
>  
>  	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
> -		if (!cur->bc_bufs[i])
> +		if (!cur->bc_levels[i].bp)
>  			break;
> -		if (xfs_buf_daddr(cur->bc_bufs[i]) == bno)
> -			return cur->bc_bufs[i];
> +		if (xfs_buf_daddr(cur->bc_levels[i].bp) == bno)
> +			return cur->bc_levels[i].bp;
>  	}
>  
>  	/* Chase down all the log items to see if the bp is there */
> @@ -629,8 +629,8 @@ xfs_bmap_btree_to_extents(
>  	ip->i_nblocks--;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	xfs_trans_binval(tp, cbp);
> -	if (cur->bc_bufs[0] == cbp)
> -		cur->bc_bufs[0] = NULL;
> +	if (cur->bc_levels[0].bp == cbp)
> +		cur->bc_levels[0].bp = NULL;
>  	xfs_iroot_realloc(ip, -1, whichfork);
>  	ASSERT(ifp->if_broot == NULL);
>  	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index bc4e49f0456a..93fb50516bc2 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -367,8 +367,8 @@ xfs_btree_del_cursor(
>  	 * way we won't have initialized all the entries down to 0.
>  	 */
>  	for (i = 0; i < cur->bc_nlevels; i++) {
> -		if (cur->bc_bufs[i])
> -			xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
> +		if (cur->bc_levels[i].bp)
> +			xfs_trans_brelse(cur->bc_tp, cur->bc_levels[i].bp);
>  		else if (!error)
>  			break;
>  	}
> @@ -415,9 +415,9 @@ xfs_btree_dup_cursor(
>  	 * For each level current, re-get the buffer and copy the ptr value.
>  	 */
>  	for (i = 0; i < new->bc_nlevels; i++) {
> -		new->bc_ptrs[i] = cur->bc_ptrs[i];
> -		new->bc_ra[i] = cur->bc_ra[i];
> -		bp = cur->bc_bufs[i];
> +		new->bc_levels[i].ptr = cur->bc_levels[i].ptr;
> +		new->bc_levels[i].ra = cur->bc_levels[i].ra;
> +		bp = cur->bc_levels[i].bp;
>  		if (bp) {
>  			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  						   xfs_buf_daddr(bp), mp->m_bsize,
> @@ -429,7 +429,7 @@ xfs_btree_dup_cursor(
>  				return error;
>  			}
>  		}
> -		new->bc_bufs[i] = bp;
> +		new->bc_levels[i].bp = bp;
>  	}
>  	*ncur = new;
>  	return 0;
> @@ -681,7 +681,7 @@ xfs_btree_get_block(
>  		return xfs_btree_get_iroot(cur);
>  	}
>  
> -	*bpp = cur->bc_bufs[level];
> +	*bpp = cur->bc_levels[level].bp;
>  	return XFS_BUF_TO_BLOCK(*bpp);
>  }
>  
> @@ -711,7 +711,7 @@ xfs_btree_firstrec(
>  	/*
>  	 * Set the ptr value to 1, that's the first record/key.
>  	 */
> -	cur->bc_ptrs[level] = 1;
> +	cur->bc_levels[level].ptr = 1;
>  	return 1;
>  }
>  
> @@ -741,7 +741,7 @@ xfs_btree_lastrec(
>  	/*
>  	 * Set the ptr value to numrecs, that's the last record/key.
>  	 */
> -	cur->bc_ptrs[level] = be16_to_cpu(block->bb_numrecs);
> +	cur->bc_levels[level].ptr = be16_to_cpu(block->bb_numrecs);
>  	return 1;
>  }
>  
> @@ -922,11 +922,11 @@ xfs_btree_readahead(
>  	    (lev == cur->bc_nlevels - 1))
>  		return 0;
>  
> -	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
> +	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
>  		return 0;
>  
> -	cur->bc_ra[lev] |= lr;
> -	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[lev]);
> +	cur->bc_levels[lev].ra |= lr;
> +	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
>  
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
>  		return xfs_btree_readahead_lblock(cur, lr, block);
> @@ -991,22 +991,22 @@ xfs_btree_setbuf(
>  {
>  	struct xfs_btree_block	*b;	/* btree block */
>  
> -	if (cur->bc_bufs[lev])
> -		xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[lev]);
> -	cur->bc_bufs[lev] = bp;
> -	cur->bc_ra[lev] = 0;
> +	if (cur->bc_levels[lev].bp)
> +		xfs_trans_brelse(cur->bc_tp, cur->bc_levels[lev].bp);
> +	cur->bc_levels[lev].bp = bp;
> +	cur->bc_levels[lev].ra = 0;
>  
>  	b = XFS_BUF_TO_BLOCK(bp);
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
>  		if (b->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK))
> -			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
> +			cur->bc_levels[lev].ra |= XFS_BTCUR_LEFTRA;
>  		if (b->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK))
> -			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
> +			cur->bc_levels[lev].ra |= XFS_BTCUR_RIGHTRA;
>  	} else {
>  		if (b->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK))
> -			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
> +			cur->bc_levels[lev].ra |= XFS_BTCUR_LEFTRA;
>  		if (b->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK))
> -			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
> +			cur->bc_levels[lev].ra |= XFS_BTCUR_RIGHTRA;
>  	}
>  }
>  
> @@ -1548,7 +1548,7 @@ xfs_btree_increment(
>  #endif
>  
>  	/* We're done if we remain in the block after the increment. */
> -	if (++cur->bc_ptrs[level] <= xfs_btree_get_numrecs(block))
> +	if (++cur->bc_levels[level].ptr <= xfs_btree_get_numrecs(block))
>  		goto out1;
>  
>  	/* Fail if we just went off the right edge of the tree. */
> @@ -1571,7 +1571,7 @@ xfs_btree_increment(
>  			goto error0;
>  #endif
>  
> -		if (++cur->bc_ptrs[lev] <= xfs_btree_get_numrecs(block))
> +		if (++cur->bc_levels[lev].ptr <= xfs_btree_get_numrecs(block))
>  			break;
>  
>  		/* Read-ahead the right block for the next loop. */
> @@ -1598,14 +1598,14 @@ xfs_btree_increment(
>  	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
>  		union xfs_btree_ptr	*ptrp;
>  
> -		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
> +		ptrp = xfs_btree_ptr_addr(cur, cur->bc_levels[lev].ptr, block);
>  		--lev;
>  		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
>  		if (error)
>  			goto error0;
>  
>  		xfs_btree_setbuf(cur, lev, bp);
> -		cur->bc_ptrs[lev] = 1;
> +		cur->bc_levels[lev].ptr = 1;
>  	}
>  out1:
>  	*stat = 1;
> @@ -1641,7 +1641,7 @@ xfs_btree_decrement(
>  	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
>  
>  	/* We're done if we remain in the block after the decrement. */
> -	if (--cur->bc_ptrs[level] > 0)
> +	if (--cur->bc_levels[level].ptr > 0)
>  		goto out1;
>  
>  	/* Get a pointer to the btree block. */
> @@ -1665,7 +1665,7 @@ xfs_btree_decrement(
>  	 * Stop when we don't go off the left edge of a block.
>  	 */
>  	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
> -		if (--cur->bc_ptrs[lev] > 0)
> +		if (--cur->bc_levels[lev].ptr > 0)
>  			break;
>  		/* Read-ahead the left block for the next loop. */
>  		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
> @@ -1691,13 +1691,13 @@ xfs_btree_decrement(
>  	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
>  		union xfs_btree_ptr	*ptrp;
>  
> -		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
> +		ptrp = xfs_btree_ptr_addr(cur, cur->bc_levels[lev].ptr, block);
>  		--lev;
>  		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
>  		if (error)
>  			goto error0;
>  		xfs_btree_setbuf(cur, lev, bp);
> -		cur->bc_ptrs[lev] = xfs_btree_get_numrecs(block);
> +		cur->bc_levels[lev].ptr = xfs_btree_get_numrecs(block);
>  	}
>  out1:
>  	*stat = 1;
> @@ -1735,7 +1735,7 @@ xfs_btree_lookup_get_block(
>  	 *
>  	 * Otherwise throw it away and get a new one.
>  	 */
> -	bp = cur->bc_bufs[level];
> +	bp = cur->bc_levels[level].bp;
>  	error = xfs_btree_ptr_to_daddr(cur, pp, &daddr);
>  	if (error)
>  		return error;
> @@ -1864,7 +1864,7 @@ xfs_btree_lookup(
>  					return -EFSCORRUPTED;
>  				}
>  
> -				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
> +				cur->bc_levels[0].ptr = dir != XFS_LOOKUP_LE;
>  				*stat = 0;
>  				return 0;
>  			}
> @@ -1916,7 +1916,7 @@ xfs_btree_lookup(
>  			if (error)
>  				goto error0;
>  
> -			cur->bc_ptrs[level] = keyno;
> +			cur->bc_levels[level].ptr = keyno;
>  		}
>  	}
>  
> @@ -1933,7 +1933,7 @@ xfs_btree_lookup(
>  		    !xfs_btree_ptr_is_null(cur, &ptr)) {
>  			int	i;
>  
> -			cur->bc_ptrs[0] = keyno;
> +			cur->bc_levels[0].ptr = keyno;
>  			error = xfs_btree_increment(cur, 0, &i);
>  			if (error)
>  				goto error0;
> @@ -1944,7 +1944,7 @@ xfs_btree_lookup(
>  		}
>  	} else if (dir == XFS_LOOKUP_LE && diff > 0)
>  		keyno--;
> -	cur->bc_ptrs[0] = keyno;
> +	cur->bc_levels[0].ptr = keyno;
>  
>  	/* Return if we succeeded or not. */
>  	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
> @@ -2104,7 +2104,7 @@ __xfs_btree_updkeys(
>  		if (error)
>  			return error;
>  #endif
> -		ptr = cur->bc_ptrs[level];
> +		ptr = cur->bc_levels[level].ptr;
>  		nlkey = xfs_btree_key_addr(cur, ptr, block);
>  		nhkey = xfs_btree_high_key_addr(cur, ptr, block);
>  		if (!force_all &&
> @@ -2171,7 +2171,7 @@ xfs_btree_update_keys(
>  		if (error)
>  			return error;
>  #endif
> -		ptr = cur->bc_ptrs[level];
> +		ptr = cur->bc_levels[level].ptr;
>  		kp = xfs_btree_key_addr(cur, ptr, block);
>  		xfs_btree_copy_keys(cur, kp, &key, 1);
>  		xfs_btree_log_keys(cur, bp, ptr, ptr);
> @@ -2205,7 +2205,7 @@ xfs_btree_update(
>  		goto error0;
>  #endif
>  	/* Get the address of the rec to be updated. */
> -	ptr = cur->bc_ptrs[0];
> +	ptr = cur->bc_levels[0].ptr;
>  	rp = xfs_btree_rec_addr(cur, ptr, block);
>  
>  	/* Fill in the new contents and log them. */
> @@ -2280,7 +2280,7 @@ xfs_btree_lshift(
>  	 * If the cursor entry is the one that would be moved, don't
>  	 * do it... it's too complicated.
>  	 */
> -	if (cur->bc_ptrs[level] <= 1)
> +	if (cur->bc_levels[level].ptr <= 1)
>  		goto out0;
>  
>  	/* Set up the left neighbor as "left". */
> @@ -2414,7 +2414,7 @@ xfs_btree_lshift(
>  		goto error0;
>  
>  	/* Slide the cursor value left one. */
> -	cur->bc_ptrs[level]--;
> +	cur->bc_levels[level].ptr--;
>  
>  	*stat = 1;
>  	return 0;
> @@ -2476,7 +2476,7 @@ xfs_btree_rshift(
>  	 * do it... it's too complicated.
>  	 */
>  	lrecs = xfs_btree_get_numrecs(left);
> -	if (cur->bc_ptrs[level] >= lrecs)
> +	if (cur->bc_levels[level].ptr >= lrecs)
>  		goto out0;
>  
>  	/* Set up the right neighbor as "right". */
> @@ -2664,7 +2664,7 @@ __xfs_btree_split(
>  	 */
>  	lrecs = xfs_btree_get_numrecs(left);
>  	rrecs = lrecs / 2;
> -	if ((lrecs & 1) && cur->bc_ptrs[level] <= rrecs + 1)
> +	if ((lrecs & 1) && cur->bc_levels[level].ptr <= rrecs + 1)
>  		rrecs++;
>  	src_index = (lrecs - rrecs + 1);
>  
> @@ -2760,9 +2760,9 @@ __xfs_btree_split(
>  	 * If it's just pointing past the last entry in left, then we'll
>  	 * insert there, so don't change anything in that case.
>  	 */
> -	if (cur->bc_ptrs[level] > lrecs + 1) {
> +	if (cur->bc_levels[level].ptr > lrecs + 1) {
>  		xfs_btree_setbuf(cur, level, rbp);
> -		cur->bc_ptrs[level] -= lrecs;
> +		cur->bc_levels[level].ptr -= lrecs;
>  	}
>  	/*
>  	 * If there are more levels, we'll need another cursor which refers
> @@ -2772,7 +2772,7 @@ __xfs_btree_split(
>  		error = xfs_btree_dup_cursor(cur, curp);
>  		if (error)
>  			goto error0;
> -		(*curp)->bc_ptrs[level + 1]++;
> +		(*curp)->bc_levels[level + 1].ptr++;
>  	}
>  	*ptrp = rptr;
>  	*stat = 1;
> @@ -2934,7 +2934,7 @@ xfs_btree_new_iroot(
>  	xfs_btree_set_numrecs(block, 1);
>  	cur->bc_nlevels++;
>  	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
> -	cur->bc_ptrs[level + 1] = 1;
> +	cur->bc_levels[level + 1].ptr = 1;
>  
>  	kp = xfs_btree_key_addr(cur, 1, block);
>  	ckp = xfs_btree_key_addr(cur, 1, cblock);
> @@ -3095,7 +3095,7 @@ xfs_btree_new_root(
>  
>  	/* Fix up the cursor. */
>  	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
> -	cur->bc_ptrs[cur->bc_nlevels] = nptr;
> +	cur->bc_levels[cur->bc_nlevels].ptr = nptr;
>  	cur->bc_nlevels++;
>  	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
>  	*stat = 1;
> @@ -3154,7 +3154,7 @@ xfs_btree_make_block_unfull(
>  		return error;
>  
>  	if (*stat) {
> -		*oindex = *index = cur->bc_ptrs[level];
> +		*oindex = *index = cur->bc_levels[level].ptr;
>  		return 0;
>  	}
>  
> @@ -3169,7 +3169,7 @@ xfs_btree_make_block_unfull(
>  		return error;
>  
>  
> -	*index = cur->bc_ptrs[level];
> +	*index = cur->bc_levels[level].ptr;
>  	return 0;
>  }
>  
> @@ -3216,7 +3216,7 @@ xfs_btree_insrec(
>  	}
>  
>  	/* If we're off the left edge, return failure. */
> -	ptr = cur->bc_ptrs[level];
> +	ptr = cur->bc_levels[level].ptr;
>  	if (ptr == 0) {
>  		*stat = 0;
>  		return 0;
> @@ -3559,7 +3559,7 @@ xfs_btree_kill_iroot(
>  	if (error)
>  		return error;
>  
> -	cur->bc_bufs[level - 1] = NULL;
> +	cur->bc_levels[level - 1].bp = NULL;
>  	be16_add_cpu(&block->bb_level, -1);
>  	xfs_trans_log_inode(cur->bc_tp, ip,
>  		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork));
> @@ -3592,8 +3592,8 @@ xfs_btree_kill_root(
>  	if (error)
>  		return error;
>  
> -	cur->bc_bufs[level] = NULL;
> -	cur->bc_ra[level] = 0;
> +	cur->bc_levels[level].bp = NULL;
> +	cur->bc_levels[level].ra = 0;
>  	cur->bc_nlevels--;
>  
>  	return 0;
> @@ -3652,7 +3652,7 @@ xfs_btree_delrec(
>  	tcur = NULL;
>  
>  	/* Get the index of the entry being deleted, check for nothing there. */
> -	ptr = cur->bc_ptrs[level];
> +	ptr = cur->bc_levels[level].ptr;
>  	if (ptr == 0) {
>  		*stat = 0;
>  		return 0;
> @@ -3962,7 +3962,7 @@ xfs_btree_delrec(
>  				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
>  				tcur = NULL;
>  				if (level == 0)
> -					cur->bc_ptrs[0]++;
> +					cur->bc_levels[0].ptr++;
>  
>  				*stat = 1;
>  				return 0;
> @@ -4099,9 +4099,9 @@ xfs_btree_delrec(
>  	 * cursor to the left block, and fix up the index.
>  	 */
>  	if (bp != lbp) {
> -		cur->bc_bufs[level] = lbp;
> -		cur->bc_ptrs[level] += lrecs;
> -		cur->bc_ra[level] = 0;
> +		cur->bc_levels[level].bp = lbp;
> +		cur->bc_levels[level].ptr += lrecs;
> +		cur->bc_levels[level].ra = 0;
>  	}
>  	/*
>  	 * If we joined with the right neighbor and there's a level above
> @@ -4121,11 +4121,11 @@ xfs_btree_delrec(
>  	 * We can't use decrement because it would change the next level up.
>  	 */
>  	if (level > 0)
> -		cur->bc_ptrs[level]--;
> +		cur->bc_levels[level].ptr--;
>  
>  	/*
>  	 * We combined blocks, so we have to update the parent keys if the
> -	 * btree supports overlapped intervals.  However, bc_ptrs[level + 1]
> +	 * btree supports overlapped intervals.  However, bc_levels[level + 1].ptr
>  	 * points to the old block so that the caller knows which record to
>  	 * delete.  Therefore, the caller must be savvy enough to call updkeys
>  	 * for us if we return stat == 2.  The other exit points from this
> @@ -4184,7 +4184,7 @@ xfs_btree_delete(
>  
>  	if (i == 0) {
>  		for (level = 1; level < cur->bc_nlevels; level++) {
> -			if (cur->bc_ptrs[level] == 0) {
> +			if (cur->bc_levels[level].ptr == 0) {
>  				error = xfs_btree_decrement(cur, level, &i);
>  				if (error)
>  					goto error0;
> @@ -4215,7 +4215,7 @@ xfs_btree_get_rec(
>  	int			error;	/* error return value */
>  #endif
>  
> -	ptr = cur->bc_ptrs[0];
> +	ptr = cur->bc_levels[0].ptr;
>  	block = xfs_btree_get_block(cur, 0, &bp);
>  
>  #ifdef DEBUG
> @@ -4663,23 +4663,23 @@ xfs_btree_overlapped_query_range(
>  	if (error)
>  		goto out;
>  #endif
> -	cur->bc_ptrs[level] = 1;
> +	cur->bc_levels[level].ptr = 1;
>  
>  	while (level < cur->bc_nlevels) {
>  		block = xfs_btree_get_block(cur, level, &bp);
>  
>  		/* End of node, pop back towards the root. */
> -		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
> +		if (cur->bc_levels[level].ptr > be16_to_cpu(block->bb_numrecs)) {
>  pop_up:
>  			if (level < cur->bc_nlevels - 1)
> -				cur->bc_ptrs[level + 1]++;
> +				cur->bc_levels[level + 1].ptr++;
>  			level++;
>  			continue;
>  		}
>  
>  		if (level == 0) {
>  			/* Handle a leaf node. */
> -			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> +			recp = xfs_btree_rec_addr(cur, cur->bc_levels[0].ptr, block);
>  
>  			cur->bc_ops->init_high_key_from_rec(&rec_hkey, recp);
>  			ldiff = cur->bc_ops->diff_two_keys(cur, &rec_hkey,
> @@ -4702,14 +4702,14 @@ xfs_btree_overlapped_query_range(
>  				/* Record is larger than high key; pop. */
>  				goto pop_up;
>  			}
> -			cur->bc_ptrs[level]++;
> +			cur->bc_levels[level].ptr++;
>  			continue;
>  		}
>  
>  		/* Handle an internal node. */
> -		lkp = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
> -		hkp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
> -		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
> +		lkp = xfs_btree_key_addr(cur, cur->bc_levels[level].ptr, block);
> +		hkp = xfs_btree_high_key_addr(cur, cur->bc_levels[level].ptr, block);
> +		pp = xfs_btree_ptr_addr(cur, cur->bc_levels[level].ptr, block);
>  
>  		ldiff = cur->bc_ops->diff_two_keys(cur, hkp, low_key);
>  		hdiff = cur->bc_ops->diff_two_keys(cur, high_key, lkp);
> @@ -4732,13 +4732,13 @@ xfs_btree_overlapped_query_range(
>  			if (error)
>  				goto out;
>  #endif
> -			cur->bc_ptrs[level] = 1;
> +			cur->bc_levels[level].ptr = 1;
>  			continue;
>  		} else if (hdiff < 0) {
>  			/* The low key is larger than the upper range; pop. */
>  			goto pop_up;
>  		}
> -		cur->bc_ptrs[level]++;
> +		cur->bc_levels[level].ptr++;
>  	}
>  
>  out:
> @@ -4749,13 +4749,13 @@ xfs_btree_overlapped_query_range(
>  	 * with a zero-results range query, so release the buffers if we
>  	 * failed to return any results.
>  	 */
> -	if (cur->bc_bufs[0] == NULL) {
> +	if (cur->bc_levels[0].bp == NULL) {
>  		for (i = 0; i < cur->bc_nlevels; i++) {
> -			if (cur->bc_bufs[i]) {
> -				xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
> -				cur->bc_bufs[i] = NULL;
> -				cur->bc_ptrs[i] = 0;
> -				cur->bc_ra[i] = 0;
> +			if (cur->bc_levels[i].bp) {
> +				xfs_trans_brelse(cur->bc_tp, cur->bc_levels[i].bp);
> +				cur->bc_levels[i].bp = NULL;
> +				cur->bc_levels[i].ptr = 0;
> +				cur->bc_levels[i].ra = 0;
>  			}
>  		}
>  	}
> @@ -4917,7 +4917,7 @@ xfs_btree_has_more_records(
>  	block = xfs_btree_get_block(cur, 0, &bp);
>  
>  	/* There are still records in this block. */
> -	if (cur->bc_ptrs[0] < xfs_btree_get_numrecs(block))
> +	if (cur->bc_levels[0].ptr < xfs_btree_get_numrecs(block))
>  		return true;
>  
>  	/* There are more record blocks. */
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 513ade4a89f8..827c44bf24dc 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -212,6 +212,19 @@ struct xfs_btree_cur_ino {
>  #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
>  };
>  
> +struct xfs_btree_level {
> +	/* buffer pointer */
> +	struct xfs_buf	*bp;
> +
> +	/* key/record number */
> +	unsigned int	ptr;
> +
> +	/* readahead info */
> +#define	XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
> +#define	XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
> +	uint8_t		ra;
> +};
> +
>  /*
>   * Btree cursor structure.
>   * This collects all information needed by the btree code in one place.
> @@ -223,11 +236,6 @@ struct xfs_btree_cur
>  	const struct xfs_btree_ops *bc_ops;
>  	uint			bc_flags; /* btree features - below */
>  	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
> -	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
> -	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
> -	uint8_t		bc_ra[XFS_BTREE_MAXLEVELS];	/* readahead bits */
> -#define	XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
> -#define	XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
>  	uint8_t		bc_nlevels;	/* number of levels in the tree */
>  	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
>  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
> @@ -243,8 +251,17 @@ struct xfs_btree_cur
>  		struct xfs_btree_cur_ag	bc_ag;
>  		struct xfs_btree_cur_ino bc_ino;
>  	};
> +
> +	/* Must be at the end of the struct! */
> +	struct xfs_btree_level	bc_levels[];
>  };
>  
> +static inline size_t xfs_btree_cur_sizeof(unsigned int nlevels)
> +{
> +	return sizeof(struct xfs_btree_cur) +
> +	       sizeof(struct xfs_btree_level) * (nlevels);
> +}
> +
>  /* cursor flags */
>  #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
>  #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
> @@ -258,7 +275,6 @@ struct xfs_btree_cur
>   */
>  #define XFS_BTREE_STAGING		(1<<5)
>  
> -
>  #define	XFS_BTREE_NOERROR	0
>  #define	XFS_BTREE_ERROR		1
>  
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index d6d24c866bc4..b8b8e871e3b7 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -222,20 +222,20 @@ xbitmap_disunion(
>   * 1  2  3
>   *
>   * Pretend for this example that each leaf block has 100 btree records.  For
> - * the first btree record, we'll observe that bc_ptrs[0] == 1, so we record
> - * that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
> + * the first btree record, we'll observe that bc_levels[0].ptr == 1, so we record
> + * that we saw block 1.  Then we observe that bc_levels[1].ptr == 1, so we record
>   * block 4.  The list is [1, 4].
>   *
> - * For the second btree record, we see that bc_ptrs[0] == 2, so we exit the
> + * For the second btree record, we see that bc_levels[0].ptr == 2, so we exit the
>   * loop.  The list remains [1, 4].
>   *
>   * For the 101st btree record, we've moved onto leaf block 2.  Now
> - * bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
> - * bc_ptrs[1] == 2, so we exit the loop.  The list is now [1, 4, 2].
> + * bc_levels[0].ptr == 1 again, so we record that we saw block 2.  We see that
> + * bc_levels[1].ptr == 2, so we exit the loop.  The list is now [1, 4, 2].
>   *
> - * For the 102nd record, bc_ptrs[0] == 2, so we continue.
> + * For the 102nd record, bc_levels[0].ptr == 2, so we continue.
>   *
> - * For the 201st record, we've moved on to leaf block 3.  bc_ptrs[0] == 1, so
> + * For the 201st record, we've moved on to leaf block 3.  bc_levels[0].ptr == 1, so
>   * we add 3 to the list.  Now it is [1, 4, 2, 3].
>   *
>   * For the 300th record we just exit, with the list being [1, 4, 2, 3].
> @@ -256,7 +256,7 @@ xbitmap_set_btcur_path(
>  	int			i;
>  	int			error;
>  
> -	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
> +	for (i = 0; i < cur->bc_nlevels && cur->bc_levels[i].ptr == 1; i++) {
>  		xfs_btree_get_block(cur, i, &bp);
>  		if (!bp)
>  			continue;
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 017da9ceaee9..a4cbbc346f60 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -402,7 +402,7 @@ xchk_bmapbt_rec(
>  	 * the root since the verifiers don't do that.
>  	 */
>  	if (xfs_has_crc(bs->cur->bc_mp) &&
> -	    bs->cur->bc_ptrs[0] == 1) {
> +	    bs->cur->bc_levels[0].ptr == 1) {
>  		for (i = 0; i < bs->cur->bc_nlevels - 1; i++) {
>  			block = xfs_btree_get_block(bs->cur, i, &bp);
>  			owner = be64_to_cpu(block->bb_u.l.bb_owner);
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 7b7762ae22e5..5a453ce151ed 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -136,7 +136,7 @@ xchk_btree_rec(
>  	struct xfs_buf		*bp;
>  
>  	block = xfs_btree_get_block(cur, 0, &bp);
> -	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> +	rec = xfs_btree_rec_addr(cur, cur->bc_levels[0].ptr, block);
>  
>  	trace_xchk_btree_rec(bs->sc, cur, 0);
>  
> @@ -153,7 +153,7 @@ xchk_btree_rec(
>  	/* Is this at least as large as the parent low key? */
>  	cur->bc_ops->init_key_from_rec(&key, rec);
>  	keyblock = xfs_btree_get_block(cur, 1, &bp);
> -	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
> +	keyp = xfs_btree_key_addr(cur, cur->bc_levels[1].ptr, keyblock);
>  	if (cur->bc_ops->diff_two_keys(cur, &key, keyp) < 0)
>  		xchk_btree_set_corrupt(bs->sc, cur, 1);
>  
> @@ -162,7 +162,7 @@ xchk_btree_rec(
>  
>  	/* Is this no larger than the parent high key? */
>  	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
> -	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
> +	keyp = xfs_btree_high_key_addr(cur, cur->bc_levels[1].ptr, keyblock);
>  	if (cur->bc_ops->diff_two_keys(cur, keyp, &hkey) < 0)
>  		xchk_btree_set_corrupt(bs->sc, cur, 1);
>  }
> @@ -184,7 +184,7 @@ xchk_btree_key(
>  	struct xfs_buf		*bp;
>  
>  	block = xfs_btree_get_block(cur, level, &bp);
> -	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
> +	key = xfs_btree_key_addr(cur, cur->bc_levels[level].ptr, block);
>  
>  	trace_xchk_btree_key(bs->sc, cur, level);
>  
> @@ -200,7 +200,7 @@ xchk_btree_key(
>  
>  	/* Is this at least as large as the parent low key? */
>  	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
> -	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
> +	keyp = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr, keyblock);
>  	if (cur->bc_ops->diff_two_keys(cur, key, keyp) < 0)
>  		xchk_btree_set_corrupt(bs->sc, cur, level);
>  
> @@ -208,8 +208,8 @@ xchk_btree_key(
>  		return;
>  
>  	/* Is this no larger than the parent high key? */
> -	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
> -	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
> +	key = xfs_btree_high_key_addr(cur, cur->bc_levels[level].ptr, block);
> +	keyp = xfs_btree_high_key_addr(cur, cur->bc_levels[level + 1].ptr, keyblock);
>  	if (cur->bc_ops->diff_two_keys(cur, keyp, key) < 0)
>  		xchk_btree_set_corrupt(bs->sc, cur, level);
>  }
> @@ -292,7 +292,7 @@ xchk_btree_block_check_sibling(
>  
>  	/* Compare upper level pointer to sibling pointer. */
>  	pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> -	pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> +	pp = xfs_btree_ptr_addr(ncur, ncur->bc_levels[level + 1].ptr, pblock);
>  	if (!xchk_btree_ptr_ok(bs, level + 1, pp))
>  		goto out;
>  	if (pbp)
> @@ -597,7 +597,7 @@ xchk_btree_block_keys(
>  
>  	/* Obtain the parent's copy of the keys for this block. */
>  	parent_block = xfs_btree_get_block(cur, level + 1, &bp);
> -	parent_keys = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1],
> +	parent_keys = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr,
>  			parent_block);
>  
>  	if (cur->bc_ops->diff_two_keys(cur, &block_keys, parent_keys) != 0)
> @@ -608,7 +608,7 @@ xchk_btree_block_keys(
>  
>  	/* Get high keys */
>  	high_bk = xfs_btree_high_key_from_key(cur, &block_keys);
> -	high_pk = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1],
> +	high_pk = xfs_btree_high_key_addr(cur, cur->bc_levels[level + 1].ptr,
>  			parent_block);
>  
>  	if (cur->bc_ops->diff_two_keys(cur, high_bk, high_pk) != 0)
> @@ -672,18 +672,18 @@ xchk_btree(
>  	if (error || !block)
>  		goto out;
>  
> -	cur->bc_ptrs[level] = 1;
> +	cur->bc_levels[level].ptr = 1;
>  
>  	while (level < cur->bc_nlevels) {
>  		block = xfs_btree_get_block(cur, level, &bp);
>  
>  		if (level == 0) {
>  			/* End of leaf, pop back towards the root. */
> -			if (cur->bc_ptrs[level] >
> +			if (cur->bc_levels[level].ptr >
>  			    be16_to_cpu(block->bb_numrecs)) {
>  				xchk_btree_block_keys(bs, level, block);
>  				if (level < cur->bc_nlevels - 1)
> -					cur->bc_ptrs[level + 1]++;
> +					cur->bc_levels[level + 1].ptr++;
>  				level++;
>  				continue;
>  			}
> @@ -692,7 +692,7 @@ xchk_btree(
>  			xchk_btree_rec(bs);
>  
>  			/* Call out to the record checker. */
> -			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> +			recp = xfs_btree_rec_addr(cur, cur->bc_levels[0].ptr, block);
>  			error = bs->scrub_rec(bs, recp);
>  			if (error)
>  				break;
> @@ -700,15 +700,15 @@ xchk_btree(
>  			    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
>  				break;
>  
> -			cur->bc_ptrs[level]++;
> +			cur->bc_levels[level].ptr++;
>  			continue;
>  		}
>  
>  		/* End of node, pop back towards the root. */
> -		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
> +		if (cur->bc_levels[level].ptr > be16_to_cpu(block->bb_numrecs)) {
>  			xchk_btree_block_keys(bs, level, block);
>  			if (level < cur->bc_nlevels - 1)
> -				cur->bc_ptrs[level + 1]++;
> +				cur->bc_levels[level + 1].ptr++;
>  			level++;
>  			continue;
>  		}
> @@ -717,9 +717,9 @@ xchk_btree(
>  		xchk_btree_key(bs, level);
>  
>  		/* Drill another level deeper. */
> -		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
> +		pp = xfs_btree_ptr_addr(cur, cur->bc_levels[level].ptr, block);
>  		if (!xchk_btree_ptr_ok(bs, level, pp)) {
> -			cur->bc_ptrs[level]++;
> +			cur->bc_levels[level].ptr++;
>  			continue;
>  		}
>  		level--;
> @@ -727,7 +727,7 @@ xchk_btree(
>  		if (error || !block)
>  			goto out;
>  
> -		cur->bc_ptrs[level] = 1;
> +		cur->bc_levels[level].ptr = 1;
>  	}
>  
>  out:
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index c0ef53fe6611..816dfc8e5a80 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -21,10 +21,11 @@ xchk_btree_cur_fsbno(
>  	struct xfs_btree_cur	*cur,
>  	int			level)
>  {
> -	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> +	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
>  		return XFS_DADDR_TO_FSB(cur->bc_mp,
> -				xfs_buf_daddr(cur->bc_bufs[level]));
> -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +				xfs_buf_daddr(cur->bc_levels[level].bp));
> +	else if (level == cur->bc_nlevels - 1 &&
> +		 cur->bc_flags & XFS_BTREE_LONG_PTRS)
>  		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
>  		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index a7bbb84f91a7..93ece6df02e3 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -348,7 +348,7 @@ TRACE_EVENT(xchk_btree_op_error,
>  		__entry->level = level;
>  		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
>  		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
> -		__entry->ptr = cur->bc_ptrs[level];
> +		__entry->ptr = cur->bc_levels[level].ptr;
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> @@ -389,7 +389,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
>  		__entry->type = sc->sm->sm_type;
>  		__entry->btnum = cur->bc_btnum;
>  		__entry->level = level;
> -		__entry->ptr = cur->bc_ptrs[level];
> +		__entry->ptr = cur->bc_levels[level].ptr;
>  		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
>  		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
>  		__entry->error = error;
> @@ -431,7 +431,7 @@ TRACE_EVENT(xchk_btree_error,
>  		__entry->level = level;
>  		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
>  		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
> -		__entry->ptr = cur->bc_ptrs[level];
> +		__entry->ptr = cur->bc_levels[level].ptr;
>  		__entry->ret_ip = ret_ip;
>  	),
>  	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
> @@ -471,7 +471,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
>  		__entry->level = level;
>  		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
>  		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
> -		__entry->ptr = cur->bc_ptrs[level];
> +		__entry->ptr = cur->bc_levels[level].ptr;
>  		__entry->ret_ip = ret_ip;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
> @@ -511,7 +511,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
>  		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
>  		__entry->level = level;
>  		__entry->nlevels = cur->bc_nlevels;
> -		__entry->ptr = cur->bc_ptrs[level];
> +		__entry->ptr = cur->bc_levels[level].ptr;
>  	),
>  	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c4e0cd1c1c8c..30bae0657343 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1966,7 +1966,7 @@ xfs_init_zones(void)
>  		goto out_destroy_log_ticket_zone;
>  
>  	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
> -					       sizeof(struct xfs_btree_cur),
> +				xfs_btree_cur_sizeof(XFS_BTREE_MAXLEVELS),
>  					       0, 0, NULL);
>  	if (!xfs_btree_cur_zone)
>  		goto out_destroy_bmap_free_item_zone;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 1033a95fbf8e..4a8076ef8cb4 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2476,7 +2476,7 @@ DECLARE_EVENT_CLASS(xfs_btree_cur_class,
>  		__entry->btnum = cur->bc_btnum;
>  		__entry->level = level;
>  		__entry->nlevels = cur->bc_nlevels;
> -		__entry->ptr = cur->bc_ptrs[level];
> +		__entry->ptr = cur->bc_levels[level].ptr;
>  		__entry->daddr = bp ? xfs_buf_daddr(bp) : -1;
>  	),
>  	TP_printk("dev %d:%d btree %s level %d/%d ptr %d daddr 0x%llx",


-- 
chandan
