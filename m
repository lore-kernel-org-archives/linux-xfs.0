Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC0CC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbhKVLeo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:34:44 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37980 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235099AbhKVLeo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:34:44 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMAB228006209;
        Mon, 22 Nov 2021 11:31:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OyL9K8Ruj5Yu/JQJQxDnrAUSykj0sn2Tbw4mfyyHcPM=;
 b=ofj+3qgW4QFH0tfT5p/QkyCdXVxGfhwN/CfKEfaY7XR4Q/yV9gxQA8vydc+9wteXImjp
 Ll9OEMslA4CPD14g+oglNqFa8zbFlEttuCVeFhpMgu3MEjVXzILuR54XIrB5uSwuvsh+
 OCAr1pIqw2EEOho/nbDp29FG92Q+7NtSM7IJm2ngTLtm7irz0LeZ1hVZgGk37PapbTJG
 NHCJ0b08Ho9/6rTbL86PjUa2HTr8qcng3YUj2e5tQeGl9823E/zXs8xNPhptLSfUTe/v
 k3UJWD+tePgktbgG09AQvx4HimLuszJSkopqe8FZ2R1g5luzs17NHS/HpP+MmpZqU9W7 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg3051q5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:31:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBUvbi030409;
        Mon, 22 Nov 2021 11:31:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 3ceru3c6q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:31:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8zIZNS7CQd8p2BIG8oRizNZOhVpttS6KaJx+jnfswTiCRhVEqLUnWvlktisjuvFbCM0DMFeMiOxq0suVWHGNsMH1JgmJcX1Zt6VF72o0V+BRxrcibyHuIx4pWJyBHUe+v3sHigsP0dSKnc5Jm3JA7CYq4v3K+/vq1yq7xmJUXL1mIzpET5sbNJ2/c1BuwwPdIeiQKJQzIxGj14M1BCGuKtsGWbtuTSr/vwLu91NocDAikYyFVgXAWjSfFbM54BcZXhkNVUYbJiEgysp7onS8vnGdf02JBi5CeJ6tQwaUPNeutRGeCEHVPJNjLGMLXP7GsB9N7PH36/A6yIAUC1YbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyL9K8Ruj5Yu/JQJQxDnrAUSykj0sn2Tbw4mfyyHcPM=;
 b=GdR5+eIt3aLBgfxIvTWmNqwb4blbDQfC9jvP8IGLOoNvul4tAj33gkWxPDhOSjD4Tn7nsCVUHCdyPLlHPStplRrcnuAtGrNGj0Dvh66lQGpVN2mFhi8vbKVKAVAhGlL6uuuTCGvJA6rpSirlzrJJRn47vWCtGJJIILBt0KQbb12pz+2wZG0rtxI9K/PH/nhBNRaiq7ZKw8/1uBZcoTELNq5mSMi7GUJRVwnCefsK5Gfw3dRYurreQMSP/+TbcX5aVfgd7nTAY2Iwt6D2BPztPyOnkGC6lw17Y30WyWy4EEg0SMw7Fp/+uUmwZvzxwS6YYb3c78EXcjm+5KCmagUHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyL9K8Ruj5Yu/JQJQxDnrAUSykj0sn2Tbw4mfyyHcPM=;
 b=bxZL0Km9c/rJKx8WVu13b684en4j9FqTB/enGwX8ILsaweYkIAUY6JTYNgEp4EGWNu5/yxEhtFB6/k2VGmbO22QGPnqEiqlV0eOurDpKd8BMLnaWki95Lazv0mBLFxvxbsw/AMVItkwKOZsom0LcsX20wRQP2jNNvS22L7/3BEQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2877.namprd10.prod.outlook.com (2603:10b6:805:cf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 11:31:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:31:33 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-5-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: embed the xlog_op_header in the commit record
Message-ID: <875yslvig4.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20211118231352.2051947-5-david@fromorbit.com>
Date:   Mon, 22 Nov 2021 17:01:23 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by SI2PR01CA0003.apcprd01.prod.exchangelabs.com (2603:1096:4:191::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Mon, 22 Nov 2021 11:31:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3bf171c-2ed8-408c-e932-08d9adaba2ed
X-MS-TrafficTypeDiagnostic: SN6PR10MB2877:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2877F0626933663CDFF850DDF69F9@SN6PR10MB2877.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2t1BY1tMBomHK2lH1GRB+HXXFkxTCbed1+Zby4I0gxiKNg1tkNvRnI5LuyhCSSmpfeRS3dFBBb5TA85R5SM3aNd5kykAGX6I8DSSHWv6TbBbbeQl0qeZqZIKoc7azroYTvYze+J8Y1D+ZjYk5WNU2UAxM7yp6vjwmZtIHLuV/dU1mLWt++BQeE7wG/32QiW5PCN47jdNkGrwyLE6evdkqtUeaL5HkpF2Z5lCLbQA9LzhK4eG4Dy6aLSsyIqyiJfISGfOVaI7Wzr51eQZ4Kg6CnLdmnlNj+o4Ley1qUeGkC5qSAwteItTIEz3CCUvTmJXrZxs4nbUXEzf8gjp5U+GUWatq8yqhtbHInG2/axJ3NaD1uE2pi0hKuIMx3ZBQzwJ1vpTU0GXhPokvAMLn8PCTolN06zrRTZ/FU6307sIp44iFcF9DjfLedJjQzE8g+5R08zPBOyFZGHi8U8vk0bkrxOUaE0s05Vcn3emyCooFxsbkzIXZiD9MJKBCxrKxE8gMQ4m4k4W3Q1i6i7OW3WTCOi75njagEX0xhOORoaDjPs15R1B+x5Zqd1LJPHZw5gx/vDs4FBLwa0Q78mYOMtwGAhrQofQkNNU9kOZFj64r2b7zXkW9Lye96NIz9j3fjO+rBO/yYsL6+vIM6ivqU+VvaO2ZcNN8YP2Ool3rS4Sh3bm8quHXJrAE/q2lj8DiPI+H10x1mUMjBwRHxxQPwXytg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(66476007)(5660300002)(6666004)(9686003)(4326008)(33716001)(508600001)(83380400001)(8676002)(316002)(53546011)(66556008)(8936002)(66946007)(6496006)(956004)(6916009)(52116002)(38100700002)(38350700002)(6486002)(186003)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RieZ+vlG1lwPcGXWpnu8Q6FqwLaw+i/2VS+whAhk773X3bK9QCnXA14P2lIA?=
 =?us-ascii?Q?erf+YibZMMHYDUiCmJw/BJRSHnQd+UX4gTn9dajvnWIC16t1qisG91XD0Ikc?=
 =?us-ascii?Q?+CQuSMIlj8uW5ZdIAhgc7GnuO5dG7itlhAswDcTOgnrI9LrBm+4D1Budvj16?=
 =?us-ascii?Q?y7OyNLRZ6vzdaelgmbIM8hT8gdQKDsfRiPSIWM5wY7bw2AFW6KmzcNeFqjP8?=
 =?us-ascii?Q?+cohhLc8S/2PIwRukXYVwTLfzfpvdxiHPAOAvhU4opEtnVmLFDOv5gOAMPKk?=
 =?us-ascii?Q?qsnkWZl8yU+E8LslTzOpty9WQUsceD17JNFnPa+TdNdtj/s3Jsh2rEViTh98?=
 =?us-ascii?Q?e6FxfgMawrUtUiwpnwdl85Me1rLH4v7qsjCpbULLQ1PZbYpDrcIVqOrqTomh?=
 =?us-ascii?Q?xjeVMSJxuowfu/3zKIN8vgbclyoSyZ29X5tdDJsYPlnEyaiW1SpqPE+lHcAT?=
 =?us-ascii?Q?YLpO85k5Zp7Fqah+TW5/4rj70jKh9oX7eAeEMybLRwEYt4gTsmZHgst4iwtx?=
 =?us-ascii?Q?olft787w9CmDzrEBBPGq3w61xRjYrsGqy8nqqPN7KJyACnmsAX6EUz20VwSe?=
 =?us-ascii?Q?a/00OV1dOaTqFXa48W2T0/8Fa7N+SHmf5GTBXLkFOLsP6QSh+s7YPcXw1tGf?=
 =?us-ascii?Q?+bONUUmzR2ysfeAOPOz5sBd9N1bSxX6NlfKQovuIXkC7/888V7TtQiOnl6M2?=
 =?us-ascii?Q?Fktq0TSDt5iKXdQir/kZxoIGnr1cUr+OjWWQqzCdOhQOZBUml8ddNW5lJJV4?=
 =?us-ascii?Q?QD1eJB2jX1IPgJzWURQHEGw8oEhIlD7vnbk25gIdesbVSfn+EvKHH/lonKno?=
 =?us-ascii?Q?01fN3j1n92NEqJIeEmQgZvCoBe6yvNN2Pus1J2OltnXHG9sD+7sJ/ZCAgL5x?=
 =?us-ascii?Q?w8GJNWciGDzMi6oofeD8xtu+oTNOPuYU9huII9GSKmxnxumLQNYRs+om2K+l?=
 =?us-ascii?Q?G8qE7JlAKeQ+O3LIX1nzolH+TJc4iZ+oqjYebSPn6jvqinhyv/uXUCLBPTM/?=
 =?us-ascii?Q?A17RMYe6ELdZmNBAyem2jNgIvgyhA547DDQmZLjPPWTb7IXYoEnDEIi/HVjt?=
 =?us-ascii?Q?qAYAy2LrapnotO7flntUajKpB20j0o4JSgpBmYUR2EKqCcyWNbV8kfcZTrwW?=
 =?us-ascii?Q?UZYG5RQ6DihStiCNLZyOVW7jU+gxWvtrnlBIx4gEGliQonxuwKBAW8j1JgIP?=
 =?us-ascii?Q?R+Y8v3URKYDFCzwMxKhvVy6K2koLUg8uKwWfVLOBA4Z/UVxkK5DUwqwDc1+5?=
 =?us-ascii?Q?0bhQSfo6FjpOef2fEDG9nj2yz+u/LNSgDAvC4trorfSqNR3LtqtP5/RqYjuu?=
 =?us-ascii?Q?hyqv1AkzQdY5DVdtZd+lNeQ8Vs+qnvSaR5Rj2baU7g6QAgECWcndZF+HZDov?=
 =?us-ascii?Q?k/d6HX2pyiu+CVFaBooJGaVLkDt/iVPwhpkxUf8E9TADs+nDGKZT+eixGQj7?=
 =?us-ascii?Q?mKNs2w7vglO2yCloKwpcJyDbly+wupkCsCUOB+hxpgxDziKq4Ks/pwLvCOYw?=
 =?us-ascii?Q?EJVdTjZddluxdx+AHAkxa4NdLiSK6gCvsx9DuxId9bSX+Vmkm21BMsRORUyW?=
 =?us-ascii?Q?y4CQd+qm4HvgRinhjGHvjFpgN8PMugdSsWwl9LsLaHi1tZhZnVxRyoJoDZL2?=
 =?us-ascii?Q?JD03sNeMUyHef3Fh2dPZ+VM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bf171c-2ed8-408c-e932-08d9adaba2ed
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:31:33.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXooN7tUTt7BoPsl1MlmrmvSp+IquAemL41ii24GoiREgmpktHMSGHCDT9pBTpS0pU/aJjuQo66dglI6xdhBQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2877
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220060
X-Proofpoint-GUID: S_elgaXt-fCrg-Gc5nlk6Xgal_2C97vN
X-Proofpoint-ORIG-GUID: S_elgaXt-fCrg-Gc5nlk6Xgal_2C97vN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> Remove the final case where xlog_write() has to prepend an opheader
> to a log transaction. Similar to the start record, the commit record
> is just an empty opheader with a XLOG_COMMIT_TRANS type, so we can
> just make this the payload for the region being passed to
> xlog_write() and remove the special handling in xlog_write() for
> the commit record.
>

I have verfified the following,
1. xfs_log_vec and xfs_log_iovec contents have been initialized correctly.
2. Checkpoint transaction's log reservation is accounted for correctly.
3. Commit record's embedded xlog_op_header's oh_len is correctly set to 0
   by xlog_write() since there is no corresponding payload.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 22 ++++++----------------
>  fs/xfs/xfs_log_cil.c | 11 +++++++++--
>  2 files changed, 15 insertions(+), 18 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e5515d0c85c4..f789acd2f755 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2281,11 +2281,10 @@ xlog_write_calc_vec_length(
>  
>  	/* Don't account for regions with embedded ophdrs */
>  	if (optype && headers > 0) {
> -		if (optype & XLOG_UNMOUNT_TRANS)
> -			headers--;
> +		headers--;
>  		if (optype & XLOG_START_TRANS) {
> -			ASSERT(headers >= 2);
> -			headers -= 2;
> +			ASSERT(headers >= 1);
> +			headers--;
>  		}
>  	}
>  
> @@ -2486,14 +2485,6 @@ xlog_write(
>  	int			data_cnt = 0;
>  	int			error = 0;
>  
> -	/*
> -	 * If this is a commit or unmount transaction, we don't need a start
> -	 * record to be written.  We do, however, have to account for the commit
> -	 * header that gets written. Hence we always have to account for an
> -	 * extra xlog_op_header here for commit records.
> -	 */
> -	if (optype & XLOG_COMMIT_TRANS)
> -		ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
>  		     "ctx ticket reservation ran out. Need to up reservation");
> @@ -2550,14 +2541,13 @@ xlog_write(
>  			/*
>  			 * The XLOG_START_TRANS has embedded ophdrs for the
>  			 * start record and transaction header. They will always
> -			 * be the first two regions in the lv chain.
> +			 * be the first two regions in the lv chain. Commit and
> +			 * unmount records also have embedded ophdrs.
>  			 */
> -			if (optype & XLOG_START_TRANS) {
> +			if (optype) {
>  				ophdr = reg->i_addr;
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
> -			} else if (optype & XLOG_UNMOUNT_TRANS) {
> -				ophdr = reg->i_addr;
>  			} else {
>  				ophdr = xlog_write_setup_ophdr(log, ptr,
>  							ticket, optype);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 9a810a2c92e9..2c4fb55d4897 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -810,9 +810,14 @@ xlog_cil_write_commit_record(
>  	struct xfs_cil_ctx	*ctx)
>  {
>  	struct xlog		*log = ctx->cil->xc_log;
> +	struct xlog_op_header	ophdr = {
> +		.oh_clientid = XFS_TRANSACTION,
> +		.oh_tid = cpu_to_be32(ctx->ticket->t_tid),
> +		.oh_flags = XLOG_COMMIT_TRANS,
> +	};
>  	struct xfs_log_iovec	reg = {
> -		.i_addr = NULL,
> -		.i_len = 0,
> +		.i_addr = &ophdr,
> +		.i_len = sizeof(struct xlog_op_header),
>  		.i_type = XLOG_REG_TYPE_COMMIT,
>  	};
>  	struct xfs_log_vec	vec = {
> @@ -828,6 +833,8 @@ xlog_cil_write_commit_record(
>  	if (error)
>  		return error;
>  
> +	/* account for space used by record data */
> +	ctx->ticket->t_curr_res -= reg.i_len;
>  	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);


-- 
chandan
