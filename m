Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83917C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 08:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhKXI61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Nov 2021 03:58:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30108 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234200AbhKXI61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Nov 2021 03:58:27 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8YkJB028565;
        Wed, 24 Nov 2021 08:55:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1kxJgsWCPqL0TkVwXE5+rMVtqP7hI0rXfvKERoyHqOc=;
 b=XVbkzohJt4PsDMlJkVISLais+XKtsx59NAWTKc2l7ChC31Yln+JXy8vAz9smaLKllUma
 nXrms5uCaQ3pgD0QzOL8HdmvoNI7L6rzMyJG6q0t26KGcAYPAZiZnv+T0DY9ISONJA0a
 kAnq1dPTx62CpAftXvsJBL+C1Q6giA9/HnK8CeWA/6kjW/pqgdOPGGNmABcN7zHAOog8
 aGdxcpQvGrVBd8JuHQ3ezZKfcO3lPX/RhfTQI48pQCRVfRMKEFYxig8zIYRB9ZRI40Pb
 PS0KJk8nHWOjnku+G7SxlQFbubFSHi7krin+/GbidWo6mAqegH6ZgFCik4uM0LT9sJaC VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg461pyu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:55:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8kdvk023027;
        Wed, 24 Nov 2021 08:55:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 3cep514p4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOrNxzk1yZ+wWtB25zVNgzG3C/EuIOszxwVuTZE/2omajFg4ME7AC991wM05xVFmMga5sc4IF4DC+hIN+Fgjs82FFnMmW/xEIAfTAVLPCANwGnspDwg/Ohj2JZKQfjEo6erYTnZrzzGciK1KLlkJoydVHYJWK8Eb5zKRXiOnaXELQSn/Yg3ruWlSUXHD3GQKbjDsOf1cVc+YsUse3qLxbDfpbw2HWVHZoEcwDUhlTs2S6ke8VyAR7kXQsfCqbQSh7fVNpnpQwLENaNEfxRncJ9IkSp0Xrhq0IfygU6Hqu1K+2Zd15+2FE7Vbx02HQwJRB2WOp1tVGJoERODGJhGIUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kxJgsWCPqL0TkVwXE5+rMVtqP7hI0rXfvKERoyHqOc=;
 b=cxTk0yFHVgrc/JwRBDVWwAt6YBWmTA5CDIQHrIvInZvawujRBoK4w9CfxOm2HlhthxWcG+SdtB/OhId9qUjWgwp+yAHlOSam5tYgOsFPefZwLtSzLw3Eesa4FnctCBBeY+2fPzPmTXNKvDQS6qtPTUuj9LasZylC0/deYNzZnhRCPaYy9DdX1jsYhCfhKZD3fdJ7Xi9tRTgBemZ9OiI+th5hmq9NN5B9Lul4eT8lFGUQWOZqpu5+jOOqH8mZcnUs6amU0kLjFLLYTWV4UQjnpK4eiiWa9P8NdWkd0lSKLOR+tKnFzddh4Hk3TDcNYRV68Rhh7nKZXAE9Cl4Y3heR1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kxJgsWCPqL0TkVwXE5+rMVtqP7hI0rXfvKERoyHqOc=;
 b=i5/kLsQ1gsdIpEv9v3jin19qC/y/jwFCA3muKq3B8GoTHkZ0MGCRjwGuhbdpzRvSOQwF4qhmOCPIJu0MdGIDZ91j8irume0LLTc/SpHQFc3AK4M/1oPukUdaNrn8cmT9W5QzUKumpzf4d8SiHza3kcdDheQsrfuytPl+YM0LOmA=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB3126.namprd10.prod.outlook.com (2603:10b6:a03:15c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 08:55:09 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::6c4a:b9e2:6c7:cf2]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::6c4a:b9e2:6c7:cf2%6]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 08:55:09 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-16-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/16] xfs: xlog_write() doesn't need optype anymore
In-reply-to: <20211118231352.2051947-16-david@fromorbit.com>
Message-ID: <87y25erl0b.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 24 Nov 2021 14:25:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0201.jpnprd01.prod.outlook.com (2603:1096:403::31)
 To SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
Received: from nandi (138.3.205.55) by TY1PR01CA0201.jpnprd01.prod.outlook.com (2603:1096:403::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Wed, 24 Nov 2021 08:55:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d6b2107-338e-48db-cc34-08d9af281e13
X-MS-TrafficTypeDiagnostic: BYAPR10MB3126:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31265B8CACC7A6D63EAAFEDFF6619@BYAPR10MB3126.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:366;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aE93oCAUwhLnbjqbLdVFUvedwqEzmdiEr+7ezNvKsbmci4UeF8IFJabpxBU83zYhKA+bKHdzGE4nrSgaLxAg+ulrmIzJxgbHEFcscQpydyek9yXJuq+CGZCCakrVJkI0egstCe6OnEO9JsEGauqPFGpkIJZXbIunANuwr+16gJyoeYnHaXO9sic42nwtUy1MVyhO7p0F7lN/f/blGx5HINbwAs36jxsScOyVlEMvLZOBjSYXO13fmw/+BkWd3eKtgFoU1jubrBDEm/Zcoo70yNEPWb98Q0hI/NHKNFwecK039X/IA8VCNUaV2T/A9sr3QnAhDEZwY4MppcEjVvUE5iMddsrkVjzNxll4W5S66107z5Iy1BbY07T9fNkMmesnFM6t9J/21eB+dYbaSD+k3NZX1cyemMz4WS0vNjkwVQLjIQob5VtABHk7Gsh6r1Ai//X7FUflVneN/N0Pe/Ktclh4g22yPW4UpodXoZV68/Smg5WKyPzRx9YBmBH/GvPatAPJ04fcpIOXejRR/gtL8ICjj2dz354B2hqidDmpIthDPHjq4oRPoKwuN9WWabo5wqUCn1cE1VCqLgNF6ioW+quRkFULUVA4nVTu55+kpDwAS5QQjlhSszHNeRY2z+yfO/KNQbJsymaxLgQVFSKCnMKX4Ugx6zdLqI534JJhYw1beKr5ZbJq0JVkaMiTPofs783sVZV2cUHr2ae6Hb5+lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(38100700002)(38350700002)(186003)(2906002)(6916009)(33716001)(956004)(8936002)(52116002)(66476007)(26005)(316002)(66556008)(6486002)(66946007)(5660300002)(9686003)(508600001)(83380400001)(4326008)(86362001)(53546011)(6666004)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1btwDuNAwo80uHnrWVQpAYISDcoE91TYk3Lzohl4tX10DzRtMiz596Aj1zn8?=
 =?us-ascii?Q?DAUidRunp8MtbIX+uTmw8o1XUL6xWKUXDUYFIoTjlux1H0tl4bHX6N9A+1wz?=
 =?us-ascii?Q?ZR/g/FIpamqJbNmiVSq+Vjquot3Uw6Gdcd3hqHRo32wA8DPZUkhZxHuoSWM6?=
 =?us-ascii?Q?vZUDUtTnLVPgmPgoU0sFpWEoVsJvw641ZH2QFcQ5QNZstHquIXX7Ckcl/v5N?=
 =?us-ascii?Q?R84Yt7uNNHkhv7ZJ2Pg3aTD3x/8nD/TPRmy8mj5RrPfL53EsNNZ7CluNufOk?=
 =?us-ascii?Q?FQVooCb3zApK7a3v3sQbnWuMa9uEfRK4AcWpDt0Hh8Mk3bhRKPp57X579PnP?=
 =?us-ascii?Q?ktrG/4PFFJNUbp+nujkW6nzNIF2kbgWumE20v9KYy8fSl2bW/dOmxeM3Tjuh?=
 =?us-ascii?Q?l4aV8Oz5UooeVwvolY3TD/pUEkN38DBCn5N4Ph4GF9Z9IMKNEY+mcCflF7jk?=
 =?us-ascii?Q?nRuu3Y5o6ZuwWaJuvH4KIspoPlXfixl7arnbHGeUtGxAQbd+Zka41bCv0cYe?=
 =?us-ascii?Q?FV8/3NT7sdlYEkXCNMqHBZaTRkjpE0dRIOnSw3R5qFhJWsOX0Ts/ZzkrbfN8?=
 =?us-ascii?Q?8UyxCbgPldfbGCHJORj7O9ocrwjsQAaIp3dkED7PLK3JktgeWMydjWR1TmJJ?=
 =?us-ascii?Q?A+1HZDE8P2I5BavXHvVZ79YfshkZGYIKXyUXYj+Za2MUDRWEgJjBO15IZiEz?=
 =?us-ascii?Q?3ti/9e4H3DKHKC+8WXHeY2XlRvvBxXGeetXsQewvo/mF5DZ5RdhDijPWcEtW?=
 =?us-ascii?Q?tGStOVA21lIO53WXn3c2NL7mx6Rdh2wk8PMJ2abIDsPG1vflmqSRTx1PRgPK?=
 =?us-ascii?Q?UKBWeybH+hilSSuFdmu9LYs2Ur0LuoapmEZkP18ZVcThLkw7zZU5W2DDceXr?=
 =?us-ascii?Q?87oaxp2/KoRRIYID9dE/lFjedoR9VDITsPFC7Lde+F8PkR7n8ZRkR7FFNZni?=
 =?us-ascii?Q?hW654eVg7ZPNEnvllvwIeuBrRyN8X67wwuEgd+mjFHpp3HTkAgPj+BBCV0lz?=
 =?us-ascii?Q?3GCTaoaXMSfnlOe9Iif3Wk7DCQNuAIhYX6l9ox++fkfnOZEj/9SqU3q1QVny?=
 =?us-ascii?Q?jCFL0tzz8aFuiobe70PO6fm5tPlsyV6zfovlYrJYHaklx22v5DI2/8smNfdB?=
 =?us-ascii?Q?ljJmKa/rAhd9Yq6Lduv9Sn+uehhzUsOdp5w4V4MAVVzHRrCU5yEykD5kO49x?=
 =?us-ascii?Q?kdHT7LKOC4+1H7OWjzGN2QZ6RQpDSq8NwVesN164fbk77e6XlCn/91p5M27S?=
 =?us-ascii?Q?YSA+3DlCXOZnolGPNL+BJZnIkRlPS7OwB4LX1LCZ1gbZzofrG8F24pyONZxu?=
 =?us-ascii?Q?MhbJKt7bZAJZX2M/YFYZoBeYALnM0ThYMpZpDBgH+RyuXt1fPRxKH1ayxJuh?=
 =?us-ascii?Q?la/14ZiWF6GKLhZ9vOGr+Rnmf45kAHUXmbFE8gaCHN8UjaZF+0NDyus0BJ7P?=
 =?us-ascii?Q?gPjCaUIEnedGbescuzUEpkCf8TgZqpc/zlZ/Bpyhau05P9VIyzRX/onv2xVH?=
 =?us-ascii?Q?VC7BsfW1h5Wvry4fd0/pLVSXjP/DQHubRgJO5+KyFB16tvQweByvYyrZVHnI?=
 =?us-ascii?Q?mqAbCSXHUvh1YDrfo8FF7qq2BMMtERXCY0aT36Hv+ZniU/IqMPQ1ZMPqbH5x?=
 =?us-ascii?Q?VIciwHE8t3z8EWtCr5IEZ2w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6b2107-338e-48db-cc34-08d9af281e13
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 08:55:08.9753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zdx1XgzTUGy2uwA/MB+VGh/8Fzsai2WEsZnn2MWXrgL6bKS4e/J4Y6nVWist1P+QJe2kYs9f11q8hkmQA2JUjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3126
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240048
X-Proofpoint-GUID: fz4Xg4XlQnF1PxzEtwYosbmreSugm-CK
X-Proofpoint-ORIG-GUID: fz4Xg4XlQnF1PxzEtwYosbmreSugm-CK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> So remove it from the interface and callers.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 4 +---
>  fs/xfs/xfs_log_cil.c  | 6 ++----
>  fs/xfs/xfs_log_priv.h | 2 +-
>  3 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index da660e09aa5c..9a49acd94516 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -966,8 +966,7 @@ xlog_write_unmount_record(
>  	/* account for space used by record data */
>  	ticket->t_curr_res -= sizeof(unmount_rec);
>  
> -	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS,
> -			reg.i_len);
> +	return xlog_write(log, NULL, &vec, ticket, reg.i_len);
>  }
>  
>  /*
> @@ -2483,7 +2482,6 @@ xlog_write(
>  	struct xfs_cil_ctx	*ctx,
>  	struct xfs_log_vec	*log_vector,
>  	struct xlog_ticket	*ticket,
> -	uint			optype,
>  	uint32_t		len)
>  
>  {
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 99ef13f1b248..ad98e4df0e2c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -800,8 +800,7 @@ xlog_cil_write_chain(
>  	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
>  	if (error)
>  		return error;
> -	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS,
> -			chain_len);
> +	return xlog_write(log, ctx, chain, ctx->ticket, chain_len);
>  }
>  
>  /*
> @@ -840,8 +839,7 @@ xlog_cil_write_commit_record(
>  
>  	/* account for space used by record data */
>  	ctx->ticket->t_curr_res -= reg.i_len;
> -	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS,
> -			reg.i_len);
> +	error = xlog_write(log, ctx, &vec, ctx->ticket, reg.i_len);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 8c98b57e2a63..3008c0c884c7 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -480,7 +480,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
>  		struct xfs_log_vec *log_vector, struct xlog_ticket *tic,
> -		uint optype, uint32_t len);
> +		uint32_t len);
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);


-- 
chandan
