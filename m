Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF758C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbhKVLdj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:33:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60500 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237127AbhKVLdi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:33:38 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMB4r9u019937;
        Mon, 22 Nov 2021 11:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dzfM+paK9WWXC4GuwZr1Lvu1YOJhSyL+i6Wc5S1pmFg=;
 b=eP0/6UnBpJkIPNFGWHQC6pTBWnVdiHcwPrC2ZLwrKz9r5BVBOXCdogh/wzc7xVAlRo5c
 pdqouGDFMEu0wJUyVYtLVtyhv0qZm6PLgP1BiaceBZuNGwJNvoXsz7NF8ZPoWg5lTLlP
 ovxn60C3wEMVE7JyWgv54SuGa0gk49WF6s2hnnsvbgF0Dft79X0akgJ7WdfWLzYXMVL7
 MEMHzP13neV7vRG68iu99bfUtjK61V4VBYfCbK20cxajZJZKeRKcmZa9xXpftz0UZpEy
 lunPJdRJgB+q5IgYSxYnE/InoqHKagPiWhvKOnpuXDLJHC7ub80QWqMWk7FkE8eKmrco 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg55fseyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:30:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBAiqB053567;
        Mon, 22 Nov 2021 11:30:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 3ceq2cetet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:30:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmM8bSEq8y3ldpFDUEOg5VzkcK74px7FSt/Or7FQFAdOWAwHHb2V3Lhj1qOmfWfpM7Ygpa/dT61Wl2ycJsfzGnukVpIx8r5/qbBIHFup716Zt7vkln25BhZLrZQvL+4+M5I/Q24cePPYTMkQ2zU0YPW+ZAyEd91sZAUZEAydsKLQsDGZsnjAHWtZv009t963U7nlw2Etzm9TRpVODcfEynQGoDtU6KyXMYFi4sYOu8mnPpC9Jh+1g9qPw2UK72UhfPmEZ9+2lrswShnX/Ey6BDlYfebrqzSUlZrNqyJGrZBZeiwr3AuCKC6QrAQ5EQC4RVDvaIS2ghp5uMFoTb6xSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzfM+paK9WWXC4GuwZr1Lvu1YOJhSyL+i6Wc5S1pmFg=;
 b=T2qDU+48QpqYAFnvaULEL8/BIgXocFoGVQH+h6u18CVBTqvD96AKWXJWePn9B0AfP5sshDs7gcJq4fSw/qqmNZd3hGMnilFuQQHtbnhspjoIX/IFDfV2GcIjRFZAeX3Al7CQd+PcRyOGtNkWFsu4HHwX90nDWbPqvD2w/ER5TNuLk5zcDkQW5G99EuQJ8Gf+1rstYkKcbnYgDS7+YoxbFCv51zBPpTW1CeR/lxn1Dm/v+KjVb02wN8gGYMm6ex+gHI1uPDOdVKPIkJh5jeYXEJhZCNXzhJSJyijEDdTIyiIxcSHu/Oy9+pUYBBP082XxhNrGD1c8Yz5UNjzZgKI5LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzfM+paK9WWXC4GuwZr1Lvu1YOJhSyL+i6Wc5S1pmFg=;
 b=PYEnx7O+mqURpFzvP5/jKUL/KqMdEeJ1LON5fbNwVFmIBgTBTQmIJCJ6QHl2yGO1PxTP5hOoatuosiAmTBclrExABVawE8z8NrN2V/l/E85ynMKeFnZu97FZQzUHIc5getVrBPCLwPPwyLAxETIIAqIH3Zt6ywCocO0AKQmtpto=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2877.namprd10.prod.outlook.com (2603:10b6:805:cf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 11:30:28 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:30:28 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-4-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: embed the xlog_op_header in the unmount record
Message-ID: <87a6hxvoxa.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20211118231352.2051947-4-david@fromorbit.com>
Date:   Mon, 22 Nov 2021 17:00:18 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by SI2PR02CA0014.apcprd02.prod.outlook.com (2603:1096:4:194::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Mon, 22 Nov 2021 11:30:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f049ad1-2198-4543-9504-08d9adab7c27
X-MS-TrafficTypeDiagnostic: SN6PR10MB2877:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2877EA5B844A25500CCA1907F69F9@SN6PR10MB2877.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:321;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cyqds7tDPAIETBjIRL8FKQwmsWz/NTtpfeFP4DOe6n1fntKVSNY6jY9gNMKitEbU9fudNq+aJupw9DkhHLPwDPnJ8wwr4o7de5yK8iWAnBfzfFGoRldrZbWIYID7DOx+1LoDuH3KCVCJ35fvu/z8JtDPWIlV8ftMxUwEVd67UaDeToBCZqclLzTM2zLxAVVulsICOhcBW1zyMmVi0vF9tf5ba/gbIX9qxhNsnD/Vbe8B651ysYk2kn82EfuMcjG5iIxA9YdQV7v3Z0qcgWRf/MilNsq2lginNBhKib2YFTBawJ71hjFx9yhLE+ih1wX7AzJ5oyujac0RpC79l/8PaUNforZDSLkEqu2zExKecGUQnRSJmdTd2pF9t1ro/EirooQrqahIiG0UE/F/GV2a4tyDbmFRD6wjUnCviIXGD33hflhzc3zRbOtuRotTKD2GUbzNLd+YyO2lsPKcGrv5kEF3PmgxgLwitp7oWzrXsNeejhtAARZ688S0o4LvEqj+rco8OckXD6cMqikdEVSsgKjz7Kh1Ftnr//b52bsxnNHwhLhc2S5IqECEA8+E081NCCe34xQztM2v/U17Z9h9XzAN0I7bw78y8DtxUw1gxQFxuMCThCFJBoYVp3XgHP5xehfks+P/8g50ZaTtrVLrR247TG3ik6v1NoWmezK4rJ1kK+n1T7b0WqcpLrZ3qemj2e0PCqDkFVekKIDTg5wIGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(66476007)(5660300002)(6666004)(9686003)(4326008)(33716001)(508600001)(83380400001)(8676002)(316002)(53546011)(66556008)(8936002)(66946007)(6496006)(956004)(6916009)(52116002)(38100700002)(38350700002)(6486002)(186003)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VjKjQS/vfzHUnkp48h+/P6V8tD9BURMggpHUq31ek0nAU6lgNVzwtFLW5bM8?=
 =?us-ascii?Q?IhFgKDnDsyTKmlNaccRmAX+4MulDa5uvWYaQsb87I//0sYNLHggkpWZGl2wc?=
 =?us-ascii?Q?/0jC6yw0aG91EgocL9+kfg0HKYRFGj2ad1pOM9doFEWSC5EE7JXVgO7iMGIl?=
 =?us-ascii?Q?d9HDuppoolvRv6lQGfiMIkohnnn2ubmBbWvLoNXXrS94FinBRORRrpz0je1l?=
 =?us-ascii?Q?e9Lg2o4DRJ+fVCjjeIcYeVtt12iqxCnstXkZxO86zDeJxJYgj9mIgCj4BT+4?=
 =?us-ascii?Q?mtIBp9WDgtGI8Ys8tRUEzivWvQh7N8A0WSRG2FnnBddOTnY1ldi96SAhK2q5?=
 =?us-ascii?Q?dC2kRpXtxT0zaQjsvqgDzTlVtgO0V/sbkTSgMGrUxrMr0KLF6aZpo+m8S0Yn?=
 =?us-ascii?Q?dmwtjdUyvdJtBomdsrkAfsxwxhiMf2+ZWdOGBeINxdEBpA8gmLuEfAAoxKZI?=
 =?us-ascii?Q?1qH1xMfFUN05KhGqzFo2qxkG6UToJtKvVOL1HLODohWPpt6BT7AUEDQoZAS9?=
 =?us-ascii?Q?jS5ju3clPGi/YyatAzBnpdAEXokTJJI4jiOrefbPCFbZXp8S2CWwfH2vTOsH?=
 =?us-ascii?Q?RnTC+/LWsLAoxuJmh5+mEmLwpXTJdj/Bb5eCNaxRKVwb39SFOPtft0SvDgmS?=
 =?us-ascii?Q?LNXhwablHMjtRm5J57SWCSdoqqu1ZjqIU9HcFkxMFoqRL5mZrkDMYp6el4iG?=
 =?us-ascii?Q?LXrt/UGRTlIddXyE/RSEuYeOXEyBgJbD+jFNxRBVxLWuzY2H/AkeVh/fmc7Y?=
 =?us-ascii?Q?3O9dFh7uSI88hug41vfW6SWzxuUBQmw3Y/67YZU4CuwBpcFOMutCC1H2B+s6?=
 =?us-ascii?Q?xNKZfAN1FAp3dLaofxhwjBACkHh8kHW5VhowerSzeHEK8HAGbW9PwYy3BIsF?=
 =?us-ascii?Q?iCgZVAetc6zA9Vn5v5yB7BVXL045OnaxiH3aA0bhKXTGqCa+AwXhtU7hX8O7?=
 =?us-ascii?Q?+aT4uM0tFGAuBwjcJE+ORum6/SKOv2eGTMmuaxyBj1GoNuqsEuGlDd0HEDVr?=
 =?us-ascii?Q?OysGLgrZYozAr+FWimMLI8SW8ZSurML3ahyUWrVJ+4MwyBwHEECAqLitEVgm?=
 =?us-ascii?Q?Fh1UO3mttLc9MXA5TMxDj0wH3uCimYPJOyETr6C2TzTucy38bn5aezIPrlvc?=
 =?us-ascii?Q?rVNn4GURL2v1qMdK6rYQSEsyIsa/c4GnZkQRQ1YHeG4VjSHq2lyajdql+6st?=
 =?us-ascii?Q?GfJFEM3DI3nO3Ko6DJ0heS7jnKaROkrewE0GC0c3M8r7DLeC1jJIVzTzxMyx?=
 =?us-ascii?Q?4n3U6N84Xhuy+RvP/nTnWvh9yabM7+O1GhyBij3hUzVWRngLOX/qX/KD8etA?=
 =?us-ascii?Q?y09NAqriZSjmIY/UDV3fzW7A2fuIhLhnSvZeOZV5Db5KB2XZdw04dXjKiXlg?=
 =?us-ascii?Q?E8Kwe8AcwASdKQwDWswiO/lwuk5Gd1L8gwe+3BJYJCbI5cTqd1/fAD1UFDKO?=
 =?us-ascii?Q?R2QjWsoytDHoCF/0rLcjHCApIrCTkz5YcuwKyrUHI2gf6bhZ4BN3XeiizvY3?=
 =?us-ascii?Q?6Hd/UxT24L30Tn0SpQRyUpIMOvOsMjFE7fHYSKe+92EW2+a/D6Kjq4qVIDAi?=
 =?us-ascii?Q?oizDOXAKBKjXAncT+nO4HAin+ixJ2wJiTlLuDkfJ1la9A7DGeMcbHLTILSGx?=
 =?us-ascii?Q?yi5oQh3ihukhrKWQ04smErI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f049ad1-2198-4543-9504-08d9adab7c27
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:30:28.6415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDXGeyDLG9HIPuT8uegH2lWNAt1W2Lto2Z+auFQC0jnzRf8PDEkvkSZKqVEH1tHTovc3qH/Ny7Z/h5KTBTAKHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2877
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220059
X-Proofpoint-ORIG-GUID: alnptiUmKBYUliRrwAIDFJBAnBtkIuL9
X-Proofpoint-GUID: alnptiUmKBYUliRrwAIDFJBAnBtkIuL9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Remove another case where xlog_write() has to prepend an opheader to
> a log transaction. The unmount record + ophdr is smaller than the
> minimum amount of space guaranteed to be free in an iclog (2 *
> sizeof(ophdr)) and so we don't have to care about an unmount record
> being split across 2 iclogs.
>

All the corner cases w.r.t xlog_write() were handled correctly by the previous
patch. Hence,

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c | 39 ++++++++++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 11 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e2953ce470de..e5515d0c85c4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -915,12 +915,22 @@ xlog_write_unmount_record(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket)
>  {
> -	struct xfs_unmount_log_format ulf = {
> -		.magic = XLOG_UNMOUNT_TYPE,
> +	struct  {
> +		struct xlog_op_header ophdr;
> +		struct xfs_unmount_log_format ulf;
> +	} unmount_rec = {
> +		.ophdr = {
> +			.oh_clientid = XFS_LOG,
> +			.oh_tid = cpu_to_be32(ticket->t_tid),
> +			.oh_flags = XLOG_UNMOUNT_TRANS,
> +		},
> +		.ulf = {
> +			.magic = XLOG_UNMOUNT_TYPE,
> +		},
>  	};
>  	struct xfs_log_iovec reg = {
> -		.i_addr = &ulf,
> -		.i_len = sizeof(ulf),
> +		.i_addr = &unmount_rec,
> +		.i_len = sizeof(unmount_rec),
>  		.i_type = XLOG_REG_TYPE_UNMOUNT,
>  	};
>  	struct xfs_log_vec vec = {
> @@ -928,8 +938,12 @@ xlog_write_unmount_record(
>  		.lv_iovecp = &reg,
>  	};
>  
> +	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
> +		      sizeof(struct xfs_unmount_log_format)) !=
> +							sizeof(unmount_rec));
> +
>  	/* account for space used by record data */
> -	ticket->t_curr_res -= sizeof(ulf);
> +	ticket->t_curr_res -= sizeof(unmount_rec);
>  
>  	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS);
>  }
> @@ -2267,6 +2281,8 @@ xlog_write_calc_vec_length(
>  
>  	/* Don't account for regions with embedded ophdrs */
>  	if (optype && headers > 0) {
> +		if (optype & XLOG_UNMOUNT_TRANS)
> +			headers--;
>  		if (optype & XLOG_START_TRANS) {
>  			ASSERT(headers >= 2);
>  			headers -= 2;
> @@ -2472,12 +2488,11 @@ xlog_write(
>  
>  	/*
>  	 * If this is a commit or unmount transaction, we don't need a start
> -	 * record to be written.  We do, however, have to account for the
> -	 * commit or unmount header that gets written. Hence we always have
> -	 * to account for an extra xlog_op_header here for commit and unmount
> -	 * records.
> +	 * record to be written.  We do, however, have to account for the commit
> +	 * header that gets written. Hence we always have to account for an
> +	 * extra xlog_op_header here for commit records.
>  	 */
> -	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> +	if (optype & XLOG_COMMIT_TRANS)
>  		ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2541,6 +2556,8 @@ xlog_write(
>  				ophdr = reg->i_addr;
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
> +			} else if (optype & XLOG_UNMOUNT_TRANS) {
> +				ophdr = reg->i_addr;
>  			} else {
>  				ophdr = xlog_write_setup_ophdr(log, ptr,
>  							ticket, optype);
> @@ -2571,7 +2588,7 @@ xlog_write(
>  			/*
>  			 * Copy region.
>  			 *
> -			 * Commit and unmount records just log an opheader, so
> +			 * Commit records just log an opheader, so
>  			 * we can have empty payloads with no data region to
>  			 * copy.  Hence we only copy the payload if the vector
>  			 * says it has data to copy.


-- 
chandan
