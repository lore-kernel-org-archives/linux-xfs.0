Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1994C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Apr 2022 01:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiD2CAi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 22:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354120AbiD2CAh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 22:00:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2506BF53A
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 18:57:19 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23T1opwo015405;
        Fri, 29 Apr 2022 01:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QiaSGfMNwMGQxbldMXCX3d2lJEAicST8e1iNEUb3rck=;
 b=w17MyJLCeYNRnip/D82WJZMoOpF0QPMYvvyXriSYiaUlu9k0HcqwfyC6uaj+zvf3Qpdu
 0fjCMYsmBbNgKitePZs82JwQZ2FDfocDxr+xJKIkqHAc6d8JDlKUEADjhfeasLQeioac
 BfE8d/8nRwrTWyDp/PtYr86gyUwzegTKuFk7Ci+nAoRYUj/vR2EM+wbnuAHh+f9wphyG
 v/tnCyUaBwTDDhfQPDTOQLYYfmJGD+sKVJAa2Mz+JaMVhFQX06bTLraLvbD0tXpsRkbv
 E7GRSUZFf1ff6PO5VQxj8gaMfwoGHxc4J0PnONQn5Bmpf21509mwwzsZP1Ex3sBSb9fW 5g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9awgfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 01:57:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23T1vFiJ011398;
        Fri, 29 Apr 2022 01:57:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ypnmbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 01:57:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdPs/LANXKFqtX2OptiLWVgaZK+XcZ1WGoi4wOTx7tWtbpAs51taB9LzftpF+XKfWwbibFMHM4Aavw/NHd+FkclVqCiPn/q8nZN7nn71JptVJyz427z1uLqquhCxMRcuzOhsb/p8c/sdKKwWyplTwzs/weHFxperatpM5XPiWlsRHZjwcHE1m8u9cklxK+djmd7IiMN4yWOKCdHWaDSp1RJx+ALb6gJekUYwtDpbs2AN1Rhq2rvcyqTUspU7GXErw9qASIIlzlCNPa3u5Hoc9ZdhEYQc2f9Hm2eVvL3W6aY/PtZchosBs8hnqdwAYjTwP0zBN02Rl52x4bMXzfdxBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiaSGfMNwMGQxbldMXCX3d2lJEAicST8e1iNEUb3rck=;
 b=l3IyqiGCw1T/vkjxrw5mkr7k6ZTbyjAJlLNuGJFmrzCK2zlQ3toM702ZohyWcUOX9UzZnkn6ZJrf/I+ZrTYu0EHUyMRlNDaB6wzV1wjMQOxx3fbfGvoGZqTftMv1pdcoIHx+9P44Kj+65kR+rUAoXnFiRWGMb5EsYSC9vC4Ezy6jxLGR4vw4irHwTJaQogvpjUsvySzCaXqqpDfiKWQVWBBH67xwAVQLdfuX6m//sckNd1TeOX1vDdBS9Lk8HJaCKdG3fichEZMXj559LjPql4gwwkeoO3/TdXxDlAejk8c0z+tzH1ijlnAvc3tdmmgIJTOUE8mOCVyfnVA3S4Xb2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiaSGfMNwMGQxbldMXCX3d2lJEAicST8e1iNEUb3rck=;
 b=Yc/YRFzc237z14kbQ8pQ0DL4XvjwSL9R4yQM5HvUZWyZ4O8UrvBjRxxe83eqgqujSNIbaN/Z6RdWdfI8248+mpKCf/N7nmhqxqXpHMXyq64O5UAn5723eBTTq+3U7FopJvm2WIZb+JG5BVzZP/qMpTavxQNW9EWa+rdvACJgw4Q=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BN6PR10MB1474.namprd10.prod.outlook.com (2603:10b6:404:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 01:56:40 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::b444:a720:24c7:76c8]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::b444:a720:24c7:76c8%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 01:56:40 +0000
Message-ID: <8716368fbf75465cf53e26cf1478d56a55bea213.camel@oracle.com>
Subject: Re: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 28 Apr 2022 18:56:37 -0700
In-Reply-To: <20220427022259.695399-6-david@fromorbit.com>
References: <20220427022259.695399-1-david@fromorbit.com>
         <20220427022259.695399-6-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::34) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cf9c4c8-4cea-45bf-96c0-08da2983809f
X-MS-TrafficTypeDiagnostic: BN6PR10MB1474:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB14742B7E79F87288FD35C5D295FC9@BN6PR10MB1474.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlMWEPwsNqZtiLWZUCURll0BKZy2pBzJVmObYm1LV0OVT5O4KzMtR/RJ0Xx6TdsKHm8SvG5mfsXMObicVTSMZYiuGyScCqtUVVeZeK0oGZtLjf8ReAYC0HRyYEt8KhDO1MgKsUeD20V/R16Mo2Msvi5tfNd3/rnC63AJEMZ45ZvO5KAMF3MqHrpzh9b4GkIBnwwk8sPQ2ACP83tvkeZ2EmO6NEvyojfxRb0YDNxzthRARqDTtkUWJSVjgEbYLssarQn9lQ+x/M1VCo5dJHgrQFx0wpNkEqc0UjCZAW/a+JhWUT3xn8Sya15s5KxwEQm0IqBMkJYIjWkPyk9+d5cBXeWHST1KCxJGI59NPwXjsIDeZPUatb7Y9J3nSv4cng/H32eeIaBzLV0/5+cJA605phtzmQcIUSnY71S/bLdJg38MmqYcwoJpS2IsjPUPTgfeKzbLQpvBFq1EONd7aw9HiYEMnIbipSj0KIy/PCK5VSHdAY6maWl4o0l7+Tq0nGJXtLeJO6+yVU2otKbmKyi2F58KKwSWULzejt6gN4CjD8jnWpcTogOVZMckJsYJlE3JQwi2kJo50zc8HikB2Zzuzk0Mva0i1U1HGh1WFrIdlMoGR8ToHFVraMYVZ+yyaowRNeOwXDT8kW7CGJgUGLKbgjGt+fn9abpVfQp3yV8Rm04B4y4g2EOq9H2ipG5f+ajmBXJyxJYdzGlQvbu/vgnV1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(6666004)(52116002)(8936002)(2906002)(26005)(86362001)(508600001)(36756003)(2616005)(186003)(6486002)(38350700002)(38100700002)(8676002)(66476007)(66946007)(5660300002)(66556008)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm9jWnNZY3NGQVdCQWk5dzl3aHZjQThvWEpsUk1KMlE0ekNrT2pVWmxvejhn?=
 =?utf-8?B?MFRIRUhPZEdxbzc4RkViNzJjYnpHaWxnSFZUdEh2QW9aSnhIa2VRaVBvK2N5?=
 =?utf-8?B?ZUZIQ1pPandNcHcxM0VuWThaS09VZkpmalMwMkhTeWxBNmk1LzU5K1Bpc1Bh?=
 =?utf-8?B?Nm5wOFo5K28veGhkMVhHa0VVeHg2dmRDeUNpUEk2blkxRWpKV1NRZ2QySmF2?=
 =?utf-8?B?eEp5bFlTQzlBQlJWQ2lYRERTWmN4SzlycTY5c2ZBS1ZKcG9PY0Z4NHMvWHBm?=
 =?utf-8?B?cGlISG5hNkpoTzlPeUgvRkRESENIaXU3UnJYNGVjTUwzZjhhWTFzNVVIRDRx?=
 =?utf-8?B?S3liU3ZpVk5PUEZJVlhZaEVIc0JWTUVWVTJmMkxERGdGTUZqY2pualRLeEds?=
 =?utf-8?B?K3QwM1BydXhBQzVyYmVnck54c0FBdzNFRnlxWDJEZFJsOWphVi9EekVWa3BX?=
 =?utf-8?B?bmRMU2d5MGdxOTJmTGZYUHdlVFEwY3l3aTNrb2hTamJWOHp2VlI4cERicTR1?=
 =?utf-8?B?VmRDWnlGTEMvRmV6SHVTZ05kRVZCSDI5cGpCUHBEVjNQMFVoMDQ3YlpTZitV?=
 =?utf-8?B?TXJzVUUveEpQYTlxb0MwRU94TStjT2hCM0RPdmFoSW1zNktIQjQ0TDE2QStV?=
 =?utf-8?B?ZW1iaVlVMDBBU1Y5Mk42VEp1d3hyOEtMa2h2Mys4RXRiY1J4NHZxOFFaSnpD?=
 =?utf-8?B?eU5QYUhXNFE3L0Q3azQzMVV2clMya0tzbDVBSTNpZS9rbDNNdzFOTHJjUFZK?=
 =?utf-8?B?Nm8wcDgxQ0xRaG1NNnFyeGdBeDBxMU9sUlR2M1EzK1lTN2JzSUxFQ2tWbnp0?=
 =?utf-8?B?WnVSWE9XM0JBRDVKaXZ4WUluQ1RUTDNCZ3hhNUEwVUNvWC96WlFXNlgycDNn?=
 =?utf-8?B?ajVGZXdwR1JxMHI5bC9SN0ptcG53U1RmOXkzdDgvSWJhZ09lb0psM2Z0Z211?=
 =?utf-8?B?a3M5NW5oOXRndkV5Q09JT0ZMdW90WnNEZitlV29RNWw4NGM5LzUvZnFmYU1O?=
 =?utf-8?B?RDdyZ2VpNjF3SmNDL3lncFplcU82N2xydE5PVFBYRXN4dnF3NU9VK1cyNWJI?=
 =?utf-8?B?cWtnR2JhWnkxaHUrZTlmalo4cWV5K1NnaXUxWFU5ZUZUQlphbTJmb3hLRWlC?=
 =?utf-8?B?QW4yck5wRm9iQkYvUnpHbFV5RnN3dU1lNk9UcE94YTZsemVqNnBBSnZ5L29C?=
 =?utf-8?B?dWZCVmVXVTFMRDRtU3FaREVzcGI4d0tKSnlnbGpIcnVLcXkyM2JKVTFkc1Jv?=
 =?utf-8?B?a3kzNXY2ZkRUM0tBU2NoNU4zaU8vQ0dMbVNGek9IR0VwditJbzROK2FGQktx?=
 =?utf-8?B?Y1o5M0ZhTEFjOTJ4MVZOMHlvQm5HemtmN3FvNEtxaERjTWEzcVFGazVHSG5T?=
 =?utf-8?B?VHQ4YXp3cW81VlZ4NjV4aG5tb1FSaEF4WHZPcjM1QmI0eHc3cVBDMWhQMElL?=
 =?utf-8?B?M0JmTVpzeFFpSDNwMWwwMlllSmNDYWNKYXJaZEJFM0VPQmZycngraVlNZitQ?=
 =?utf-8?B?cDZrMzZFeEVkWE1SNEMvb3lNazBFdkk0V2t5Z1lMbE1GRWVzQ2ZCR29abEJs?=
 =?utf-8?B?LzhtdnRoRG5EYnNNNVBtcWFIc0FsMmpvOUc1NUVpdnJrd3h3SnFoWkVXdXoy?=
 =?utf-8?B?a0F3R1lXZHd6VER3SytNUDl6N3ZLaGp1d3Jyb3I3TUdtZGlGZXU3Rk1BZ3Nt?=
 =?utf-8?B?VDB4Vkk2QVZyU25rU2dLMi94WlVpK1lPZ0kwbC9KdG1Hc2VTRkFYZUhudElh?=
 =?utf-8?B?RjlRbTJneGgrZGJ3UDFTQyt3RlliL3RzMjJ5ZUVsZVp2SS9pYjQ3SzRjWmVN?=
 =?utf-8?B?dElqWThlMzZ2aURGQ1BPVk5CUEM0S0ZPMzI0U3ppbEdYMzhiSEpmcXh4aU8y?=
 =?utf-8?B?VUFwdm5hQ0xyMXZBbnArQzFtM1hkZ3Rpa3hjcXRLaWJlczV5K0pZdDFDVnZD?=
 =?utf-8?B?b244bEp1dThxWmg4cm1rQlNibVdmOVVmK0RvbTBqSHY2QjVxT2tmVkpQVHRq?=
 =?utf-8?B?bDFheUxqWTF4bVNaZGJkOUdaVUVodmR0YXZjaHdVbTV0MmdpU1Q1SFg1cTlD?=
 =?utf-8?B?Q0JMRnY5blBSZUE5a3JtR05kWEY0Z1NEWW8rZTdYSkJqRlJaOHN5a2g2a3RH?=
 =?utf-8?B?TG9ta2lGRk80eVQxM2lxRWhsS3A2eGhESFhZT1dtOWl4K05DNUxyZVF2a2Iv?=
 =?utf-8?B?bWhkM3hMd0dxbkhnbHZkRHJ1YjFHaVR0aUpQNG5ibmRSekptVmdaZU5XUXh0?=
 =?utf-8?B?cnFKMGk4K2R5bHBtalc2TjROZGVzVHVMK2FwUlNZbzQwVXNCTDk3N3NNa1FG?=
 =?utf-8?B?aDhDSXRVaEtZendZbm1JeUgyMGR4MW91QWlWcVUrY3hiRzQzTVptbTc4ZFpi?=
 =?utf-8?Q?BH43zmAmx0pq6b34=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf9c4c8-4cea-45bf-96c0-08da2983809f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 01:56:40.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1yWJv47+o0rmvj9dOUDq5q1tsHni6rBW/BVkaFcrKnhwZ6y8W3Z2Vj7z3EU2aU7Ev+kkcZNG9Zny21uUJ+ZBcrUeV5bxnbIrdW65FfMVpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1474
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_05:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290008
X-Proofpoint-ORIG-GUID: xEYpD6FHyGSttWPQJdcN2EytuyW6ClXn
X-Proofpoint-GUID: xEYpD6FHyGSttWPQJdcN2EytuyW6ClXn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-04-27 at 12:22 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In preparation for adding support for intent item whiteouts.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks good to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_log_cil.c | 119 ++++++++++++++++++++++++-----------------
> --
>  1 file changed, 67 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index e5ab62f08c19..0d8d092447ad 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -47,6 +47,38 @@ xlog_cil_ticket_alloc(
>  	return tic;
>  }
>  
> +/*
> + * Check if the current log item was first committed in this
> sequence.
> + * We can't rely on just the log item being in the CIL, we have to
> check
> + * the recorded commit sequence number.
> + *
> + * Note: for this to be used in a non-racy manner, it has to be
> called with
> + * CIL flushing locked out. As a result, it should only be used
> during the
> + * transaction commit process when deciding what to format into the
> item.
> + */
> +static bool
> +xlog_item_in_current_chkpt(
> +	struct xfs_cil		*cil,
> +	struct xfs_log_item	*lip)
> +{
> +	if (list_empty(&lip->li_cil))
> +		return false;
> +
> +	/*
> +	 * li_seq is written on the first commit of a log item to
> record the
> +	 * first checkpoint it is written to. Hence if it is different
> to the
> +	 * current sequence, we're in a new checkpoint.
> +	 */
> +	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
> +}
> +
> +bool
> +xfs_log_item_in_current_chkpt(
> +	struct xfs_log_item *lip)
> +{
> +	return xlog_item_in_current_chkpt(lip->li_log->l_cilp, lip);
> +}
> +
>  /*
>   * Unavoidable forward declaration - xlog_cil_push_work() calls
>   * xlog_cil_ctx_alloc() itself.
> @@ -934,6 +966,40 @@ xlog_cil_build_trans_hdr(
>  	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
> +/*
> + * Pull all the log vectors off the items in the CIL, and remove the
> items from
> + * the CIL. We don't need the CIL lock here because it's only needed
> on the
> + * transaction commit side which is currently locked out by the
> flush lock.
> + */
> +static void
> +xlog_cil_build_lv_chain(
> +	struct xfs_cil		*cil,
> +	struct xfs_cil_ctx	*ctx,
> +	uint32_t		*num_iovecs,
> +	uint32_t		*num_bytes)
> +{
> +	struct xfs_log_vec	*lv = NULL;
> +
> +	while (!list_empty(&cil->xc_cil)) {
> +		struct xfs_log_item	*item;
> +
> +		item = list_first_entry(&cil->xc_cil,
> +					struct xfs_log_item, li_cil);
> +		list_del_init(&item->li_cil);
> +		if (!ctx->lv_chain)
> +			ctx->lv_chain = item->li_lv;
> +		else
> +			lv->lv_next = item->li_lv;
> +		lv = item->li_lv;
> +		item->li_lv = NULL;
> +		*num_iovecs += lv->lv_niovecs;
> +
> +		/* we don't write ordered log vectors */
> +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> +			*num_bytes += lv->lv_bytes;
> +	}
> +}
> +
>  /*
>   * Push the Committed Item List to the log.
>   *
> @@ -956,7 +1022,6 @@ xlog_cil_push_work(
>  		container_of(work, struct xfs_cil_ctx, push_work);
>  	struct xfs_cil		*cil = ctx->cil;
>  	struct xlog		*log = cil->xc_log;
> -	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*new_ctx;
>  	int			num_iovecs = 0;
>  	int			num_bytes = 0;
> @@ -1033,31 +1098,7 @@ xlog_cil_push_work(
>  	list_add(&ctx->committing, &cil->xc_committing);
>  	spin_unlock(&cil->xc_push_lock);
>  
> -	/*
> -	 * Pull all the log vectors off the items in the CIL, and
> remove the
> -	 * items from the CIL. We don't need the CIL lock here because
> it's only
> -	 * needed on the transaction commit side which is currently
> locked out
> -	 * by the flush lock.
> -	 */
> -	lv = NULL;
> -	while (!list_empty(&cil->xc_cil)) {
> -		struct xfs_log_item	*item;
> -
> -		item = list_first_entry(&cil->xc_cil,
> -					struct xfs_log_item, li_cil);
> -		list_del_init(&item->li_cil);
> -		if (!ctx->lv_chain)
> -			ctx->lv_chain = item->li_lv;
> -		else
> -			lv->lv_next = item->li_lv;
> -		lv = item->li_lv;
> -		item->li_lv = NULL;
> -		num_iovecs += lv->lv_niovecs;
> -
> -		/* we don't write ordered log vectors */
> -		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> -			num_bytes += lv->lv_bytes;
> -	}
> +	xlog_cil_build_lv_chain(cil, ctx, &num_iovecs, &num_bytes);
>  
>  	/*
>  	 * Switch the contexts so we can drop the context lock and move
> out
> @@ -1508,32 +1549,6 @@ xlog_cil_force_seq(
>  	return 0;
>  }
>  
> -/*
> - * Check if the current log item was first committed in this
> sequence.
> - * We can't rely on just the log item being in the CIL, we have to
> check
> - * the recorded commit sequence number.
> - *
> - * Note: for this to be used in a non-racy manner, it has to be
> called with
> - * CIL flushing locked out. As a result, it should only be used
> during the
> - * transaction commit process when deciding what to format into the
> item.
> - */
> -bool
> -xfs_log_item_in_current_chkpt(
> -	struct xfs_log_item	*lip)
> -{
> -	struct xfs_cil		*cil = lip->li_log->l_cilp;
> -
> -	if (list_empty(&lip->li_cil))
> -		return false;
> -
> -	/*
> -	 * li_seq is written on the first commit of a log item to
> record the
> -	 * first checkpoint it is written to. Hence if it is different
> to the
> -	 * current sequence, we're in a new checkpoint.
> -	 */
> -	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
> -}
> -
>  /*
>   * Perform initial CIL structure initialisation.
>   */

