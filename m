Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF97C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbhKVLlI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:41:08 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63474 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234018AbhKVLlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:41:07 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBaowR029278;
        Mon, 22 Nov 2021 11:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cccVC/ix2NJCosdedAMvadGc9s2mo0W+ZqnRQQVSLAw=;
 b=jDJpF4sSgl0dvDnWgklN8sARre5I48GEBabtD9PRuv1iLr9XwFA7aDt/Zm/MmDiEKGiJ
 tgp1dl3scJLw258Cowh48HUoucyeI2OMEJCRNWE70M1j/GOKBQ0lE8nudPJ+TYL1CGCY
 RsCcnq5QyompIIqX7bmJLJwBO/FxT+AIfyBRnBNUDu/BsP0hpPZLZ22f4mk3hzF/SBlg
 Ut5pTRbQf/kxJbi1DVaWnRrfJABAwHYrXy3ykP9M1ipFkRFEHnRpmyIm+zwyP04XlaRb
 EO/IDorJHu5UqI8qt0N+8zPYeuA324k7wnIYoB1pXzN2JRHtNkE9Vk9+YkBgX1q3P8es Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg5gj1ck0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:37:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBUwYD030436;
        Mon, 22 Nov 2021 11:37:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 3ceru3ccxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:37:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hi8Z/CSALyAxGco9IbSI7zJY2/Pw5oyxjCrDwIC2PkIFyJlxy9ZBxPpbNDqBiwAWLkTqUhar7tcoy0rx0B8hEEIx7b77JEWzLkMfLnAd6JfjKFz/Zd+XspVGOZj3EHRMf7YotGmVpE7TxYmRRTYdZLlZ2c3eThKs55c5NM4edIygvDmkSmEf8asLqo8ndwEapPqJ3FH64RjAar7h3s+/ZWfUHKJtYzFVls0MmuMil9HYWqxKvn2Q2SGGjl/ls6ZAyvgAAQiiEdDU/4hSh3rAZ7Cgd0Mf+IGrFhZJoIUxTKAJypEMWX863rp8wXQKJ49HgP4qhfLeZteG7mJWQiW1Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cccVC/ix2NJCosdedAMvadGc9s2mo0W+ZqnRQQVSLAw=;
 b=R4gczem1PHdJP2xByWOBR/iYobvH92tDCP8cX6jOwvhDzxtRHhP9NUrGviT2okykIiyR2XSDWA9x/1347yIl2a/QW3frNKepRUwzSJ2z9kg56dDUQ0NyH5pnrXDkdP4HmxJlt6yHASCiwKOohFogdwxIjDjhhnd9LumsYhoHigG7H76hF2bz93XfDvayEhwIHmebZdsi/c+nuASSj0kZ+PKB8P+DGKbZEZrCtvFx4ebG40KVz7fsipCGUgtsFJ5a92uxGsy6vrh1kSSeGbZ9zT6KY6/w8rA61NRQAxSdsHIHH2JRXDouQyV1zSb9jQI6yFhClZfpIHEM4FZYGeJ4uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cccVC/ix2NJCosdedAMvadGc9s2mo0W+ZqnRQQVSLAw=;
 b=nVDValkkmgj9goTBmAuPxWcRMj4YOnImUwQateGHwZVtzkr538eq6RwjWzwACL5wMmX976pnRJuGhrxBUYMO03DfvmxXSV6FnfoQir1ds4JuHrnlwDnjfjVi8VFH4e6tRLViQvpgV0MGm6dJnrxhPfH2So28XPUZa3CHRRynIKM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2496.namprd10.prod.outlook.com (2603:10b6:805:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 11:37:55 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:37:55 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-7-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: move log iovec alignment to preparation
 function
In-reply-to: <20211118231352.2051947-7-david@fromorbit.com>
Message-ID: <8735nowhdg.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 22 Nov 2021 17:07:47 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:404:f6::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by TY2PR04CA0014.apcprd04.prod.outlook.com (2603:1096:404:f6::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Mon, 22 Nov 2021 11:37:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ca52d1-10a7-47e8-e973-08d9adac8695
X-MS-TrafficTypeDiagnostic: SN6PR10MB2496:
X-Microsoft-Antispam-PRVS: <SN6PR10MB24964295CA41217AC407F205F69F9@SN6PR10MB2496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Fe6T4XzTnbKqJaMVtNFfJUFoDqEbSrbzene53aB0z/+rHj6Gc02dY4KTzobvZAvLB2C8vtXPpHSbDoJeSpdn54NSCRJh2MHMighzqgsDojXWZg8HhVHYT/3nKkXswHZHDhw3f5fZXM3W/owrl4Ad25VqaM3MXs+/q4hAxHLivRETZo6+rBYSdGTd+rqKD+ffEB3e4u/PelBhH8hHmpBnojVDhcUZq9wV70ZRasGakjam3FqBuYZDZ7BwZNCAbrPuGiJDIt5vymFbN2X0Az/syMYxojh+odUMyKekWodyJNF3urGD/U4HVxjF0MLMNRj5hrFrmu/a9pKsVDx+SCbYDmvnv8dM3aSLnQdYMdew9RKdGOkWCnE1v4xhIiuB0i0UvA4MMRSgMX3E4A2uf0QpEbtYyzuCTrp8MnJyHzjmUo4AZTV22qBVRkYvcx9AY5wUXAQjhnlQidznHlPJ74tKmQ2LpYkvehMdl53US22BCR9TaSTaQmbYmMErW4DsLTVL1+TSlMhQtiKgDuhF+vDWx2nPADvBN3V/0MDsba/Q3cOAnXo9GxOmZlAwGn5DGDfYVCGqpVyM35CQC9cy/dzGiY740YRTQHXJtnYB14AGewci53Jq8ymNDTpj3RFgpZ/UqitszmimTtJs2Mrcc73nrSYlFpffbKr+H1vz38/OoYjavMGTU9gp5r2u2TP/30QVC6iRDXIEH8VO90eB5qa+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(9686003)(38350700002)(8676002)(6486002)(52116002)(316002)(86362001)(6916009)(5660300002)(6666004)(83380400001)(4326008)(6496006)(38100700002)(66556008)(66476007)(53546011)(66946007)(956004)(186003)(33716001)(8936002)(508600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OpCJvjZm6/DQmORRv1x19cqxfoA6ADLXAAzF1F117i2/qPFCo6XeS/TdvXfV?=
 =?us-ascii?Q?Tc9EgaOOFZLhTELRsoUOE+QrSKpJqSzdQ+34wrgd/OyVdxRZDVyM1vDzeaXR?=
 =?us-ascii?Q?phZ96d8DKdlBda55f25KuWDYdqF0NdEmfVGGTdUlVGBWRlRpFqVPnc4dmoxU?=
 =?us-ascii?Q?UNHV+BZRsnV2QXMUHtPa8adFF9Lb30r0e/DXGkGI3s5jsx8ckgnK0ZopTseW?=
 =?us-ascii?Q?r1pHg7h1WVTBW3uVgngXSYBayOSd0yKatNwA3+AUF6kFoKYv7Yxv9ypvEaeS?=
 =?us-ascii?Q?mRnFpMDxaNEwGwC/V0rBdgpvv5txvXbppKCt2/vsx47QN3rwEsRl25AQ/tjF?=
 =?us-ascii?Q?/YG6BGS0I+pEAj6Y3wLwQrBH9WMtJiBQvrstpJ4ErPf4lDTpk2tk01iXL9EL?=
 =?us-ascii?Q?AH9LEx57BiED7QnD4FjKkyFUEIXsz6yE1KXKYw7J88KcpbahOS6bNQOc+0Kc?=
 =?us-ascii?Q?w5T9oiRlgaRnvqiptBE3p70dKW2ox0wburFEw5kiRgH7ve/hwrLyEakxTgjE?=
 =?us-ascii?Q?TVPzhOuc0y1Jdt6KCAIcTvAXSeGv7EoimLWlopk17aeCgLOMFDFp4q16w8SP?=
 =?us-ascii?Q?bvtHUM+oZmmJ9mAstjdtEfhX3IsRHZNWIst6utWVNItlo956qKXeibWI8ab9?=
 =?us-ascii?Q?8cSnpf42MRP0owhLqL45zaqBuUIT1Jiw3SPA4mM04U5vbjaOvevfU1ul3jPl?=
 =?us-ascii?Q?B3TOIPIfYGeIrqmic7mIWZEuWaLcEnJerO1Qf8JmuhNH9qkZUvSEy8QB9qsB?=
 =?us-ascii?Q?aRyEV0kztjBLpyVUFdVKmLL9z2R6acGHR1kkHvesTm583kH8aMpN+gANnSiF?=
 =?us-ascii?Q?FkXaRk2IY708lFo9ZpOAxEhbNeXgI/uFGGOouiqOnlRdU0D2S35ZvYW6+7HN?=
 =?us-ascii?Q?zZY/1TDHTd2b6mYeqCm2mMEvWAE7VdEoAP7RY0TFzJoCyDS8H+rEmQsceGq3?=
 =?us-ascii?Q?orBRB8Sz7ohefZP21CCn3pZJ6ClHoeSTy9QZDGUQFRFbSZlMVFJrfsrjiGtw?=
 =?us-ascii?Q?b32Fp9KViX05Qa36dqg7h4EnRXtAfDQCVmTXI7+BmxytWcQSaHvC7DF0Se4Q?=
 =?us-ascii?Q?iJHdvXUks93hduZOY8rXZaVcMvxk1KVF5269h4fzOOWd+1Xg7PwcL8rI/RV6?=
 =?us-ascii?Q?QUNY3t5wXF0mayEAhc36tSxiXfOuD2729g+yg+e5zr9cfOlORJH3z/PHl/P8?=
 =?us-ascii?Q?Hiu3Ax6HB1OJxiaHbdOKX/JGElxp7+yhFuhfNm0roA7Lof+lBXzTF9Kj31DQ?=
 =?us-ascii?Q?zXwuTcZpIZQ82SDzRg+JeBl6/WCLe/gis5La8pR5ydZIrDIMWDYLBJPesYjF?=
 =?us-ascii?Q?jxn9YwCRJ+Ugc080ft5+1x/TKtSoPSn0HEwpNrO5Ly9L6dlVky3bcFl9GZGX?=
 =?us-ascii?Q?+BllrL70vbN0+/F2kOh+n8k6jZHhQNQwafEdEdKTvHivLIWyigP7cdxiTvq0?=
 =?us-ascii?Q?DcwdzaeSvEidm9TU4ZbOUKwGmVdrEUUk3m2ya/yGbjrYgYUQDKDQlDVAfByT?=
 =?us-ascii?Q?ONWjIzi6MGLSfSzmKEznGEM5ugJa5CF/ovpoVbrC9i+446QdhgyzAgHRdek9?=
 =?us-ascii?Q?O8T/HXMUsrFwwOO/JHaOUizGTMDQCZQv6hPwT1TUR1q/BmTrXzfXjM2aspkO?=
 =?us-ascii?Q?kNR4lquoiJo5pMG4XKcxnDc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ca52d1-10a7-47e8-e973-08d9adac8695
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:37:55.5668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8exQEra3uzR0bDRgaEmAOy/MSJQYr7Hq819eIbX9BPMpGbRv4GY5bGuanNUotJFK3+a/Igz6VhPrRkJWXcAUFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220060
X-Proofpoint-GUID: MRUwcxZ3j3vcawg29L5Zx2dCfz1ffDUX
X-Proofpoint-ORIG-GUID: MRUwcxZ3j3vcawg29L5Zx2dCfz1ffDUX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> To include log op headers directly into the log iovec regions that
> the ophdrs wrap, we need to move the buffer alignment code from
> xlog_finish_iovec() to xlog_prepare_iovec(). This is because the
> xlog_op_header is only 12 bytes long, and we need the buffer that
> the caller formats their data into to be 8 byte aligned.
>
> Hence once we start prepending the ophdr in xlog_prepare_iovec(), we
> are going to need to manage the padding directly to ensure that the
> buffer pointer returned is correctly aligned.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log.h | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 09b8fe9994f2..d1fc43476166 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -21,6 +21,16 @@ struct xfs_log_vec {
>  
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
> +/*
> + * We need to make sure the buffer pointer returned is naturally aligned for the
> + * biggest basic data type we put into it. We have already accounted for this
> + * padding when sizing the buffer.
> + *
> + * However, this padding does not get written into the log, and hence we have to
> + * track the space used by the log vectors separately to prevent log space hangs
> + * due to inaccurate accounting (i.e. a leak) of the used log space through the
> + * CIL context ticket.
> + */
>  static inline void *
>  xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		uint type)
> @@ -34,6 +44,9 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		vec = &lv->lv_iovecp[0];
>  	}
>  
> +	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
> +		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
> +
>  	vec->i_type = type;
>  	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
>  
> @@ -43,20 +56,10 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  	return vec->i_addr;
>  }
>  
> -/*
> - * We need to make sure the next buffer is naturally aligned for the biggest
> - * basic data type we put into it.  We already accounted for this padding when
> - * sizing the buffer.
> - *
> - * However, this padding does not get written into the log, and hence we have to
> - * track the space used by the log vectors separately to prevent log space hangs
> - * due to inaccurate accounting (i.e. a leak) of the used log space through the
> - * CIL context ticket.
> - */
>  static inline void
>  xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
>  {
> -	lv->lv_buf_len += round_up(len, sizeof(uint64_t));
> +	lv->lv_buf_len += len;
>  	lv->lv_bytes += len;
>  	vec->i_len = len;
>  }


-- 
chandan
