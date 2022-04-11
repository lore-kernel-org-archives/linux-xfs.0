Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F18C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiDKF0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244725AbiDKF0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:26:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D8463A7
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:24:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B2bKaa028053;
        Mon, 11 Apr 2022 05:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yROoea+BdYpjDttLZN8pI98YOs253pb/dbNlJvsxNmo=;
 b=ZtHP3WxsaNR21kaG6FTrhUzCa79Faxn3W7Wyf0U4PO/SRWf0xWL7w5jlII7lTKMJZwl/
 NCvzbuPNuKyu51u+n/NctFZ3TwLg27IUGrwcKkasEEOgUgEwPx18or2Pp4n2SDukx2Hf
 n7/N0sWjlVeimVy4QsQQS64jhUgwg7R7jDuIasZvWvxvhS7hptiTyMTfjyJ+2dE7Cvsm
 /QGZwCCpsy7mKkT0BPaapikYqOoc41w7L0DN5I+qPN8bu/hwb9jWpmb2YwDAk+DYWAMx
 8ggpqzAgkxiLDzI5Ib6FRj9Wfw/uTWnMw7YpewXTSoZxZLVPIM5O3wPfj8s1ni4jRRxc dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219tb2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:24:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5HJfY020333;
        Mon, 11 Apr 2022 05:24:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1bt8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:24:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKdn9OOdtn0/31iqfuTFeLp/iyZ8G+hXshwOUsvaAp2RhgMTUpBOHpWja+RPsnPqOlyZqHL629uhvUNWJB22FwzHKuu8kZMXNvpodqzqKCbJiLxxVxA7xZtMmZyJ1eIVVoC6wOXMPAmgh4Ti1KJ3MYoz0XgnnV8FY34PqD8EqvR6vGaiozBCtJHvVkIBS38SABduDsuYlaKoFfKHbWFWdBiwqxyKPMBmOComzw3gR/Y77R4YZ1AkLFh6Jn0cuypxCSaXOcwd/pbwgPvtmjcIUW+tNmDSaTmAOa46vGRUJWp4SNW0xzaVUSKXAmzbFPga2ouqtG+/5XO6mWGZV89asg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yROoea+BdYpjDttLZN8pI98YOs253pb/dbNlJvsxNmo=;
 b=keRZELVHePylqqgf74G2kxpSABuB3AH9IBmDI10wRzdGQb+9vwZWCLJxYhcIiw9I+wENfQFywqwHCEQLYKcT3ks+KxrF2M4Otjm1mUgCi5sZKnjyRD+aSg7akzzmi6rBf0a6n1Zi8NGokVL08t452JpjdwyYHZpKCowWwqn8NRaSqMcomRFos8/TkU/2/fHsA0U803IgqE8VfneJcMrfN3ZL8P5Ymy45Fm2+AcJ+FHKH/8b5PbaoifySXbuKSZJg0P20bjAdO4OR5uCpLOyUbpf8Qn3Bs54zsLXM8rwRqqm2qs+lCng2SOKIS6Q8X2gVxykwhxoFRFvKkbmNP7w+WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yROoea+BdYpjDttLZN8pI98YOs253pb/dbNlJvsxNmo=;
 b=oIcxVI1wk7hNT7fO0tevESv5HbHxO+vv//mIImAMWbcAcdBGqa3jbR6E+kZwsqMP8ZhRdiBuyelnNZ9Ib6+zeKRLMfu1GdK83t7Xu71ES4cO7Ot4h+YJRzMpULYrQ+1ZKfrmrgFII4Vmua2HDuEJcCqxJDp2RFdHND1Nndm6n00=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:24:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:24:22 +0000
Message-ID: <b9047c05f26e02136f66ad644a3bb42a3e2b90b2.camel@oracle.com>
Subject: Re: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:24:21 -0700
In-Reply-To: <20220314220631.3093283-6-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
         <20220314220631.3093283-6-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25ffa892-1e9a-4ab2-1627-08da1b7b8962
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4948446CF5F36E20843ECA8295EA9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JlxI9aGvt4+TIL5cDXHfH/PMhUu3D/MQPqOc0kKP8esgXhaev7rieSPxjcmNRvqEqXFiKpvN6Gz/bi1IiCbYWSy2JE3sctEeOLQSldLEEgDleYiYbJaE4hhuHGrPr9Ztfl+PXD3Yen/IX2x/8x17F0s/BsuNrkLumxsqz8Gi/LqxJJ08vaNvhab5saioQru2K7mjleoQhRqrCiTRsAXm9uVwXFjo4DeuJAaBeLqEyJV/0egrK2yDyJhhCHYKbKZmAUojVtr6peZIc3fUCXppLYa83LVEg2k2zeVBSWLOcuHcoJzOU6q1Kzsq03LQXQDQN28yvHYugakqf2cdT2jRNaXXl06L3cdP0L75LEAPpxMmRUoryVZnOREJoZuuE/QHtuROrNX/A8OuwOtVPFssoPcZiUSc4KllNO24OJuvyD+W5QXm5sLp/3qiuinlRznRXREvROKdFvAPX8sppi3a+rUbsSF/3hNAGuKJ5kWbm7/cu0yS/CqkpX6D3T+cqG034gY0mHNDANwtQSeVNERa/LS9sGoIxNRjPdv5xvd8utiICEoxfK/63JiU7lWHpC4a2my6P44RfDhwI2NiKKprQqTomjsi7rLNxHLeg093f3JlPQh+/Fei4d9r9mK5Dxfj6Am4u6SxD9H9/hPmx7LqLPCondJpiMocFKViY06C3wjsoOeFOdDAoVCkux3sHs3l/fTBkjhCsRMBTWK6DsA7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38350700002)(38100700002)(2906002)(316002)(5660300002)(6512007)(66476007)(26005)(52116002)(6506007)(2616005)(186003)(36756003)(508600001)(6486002)(66556008)(66946007)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmNmemVxWHN3VCtiVUlSVFFpWFJQR2xnaXRVWWFvbDVTaldSU3FSYVRoSEVM?=
 =?utf-8?B?dG4xS2pnZElYc1ZnZURnNDNuekM2d1VqMTA4VkNLaUtkcm1KUVhUeG5MM0NT?=
 =?utf-8?B?N0laUzVHVEFYdU9OVHV5NlpvVkhmTmoxTFZLM00yc29pTHhFeEIzOUFUZUVS?=
 =?utf-8?B?TXdyUlljRUloVFZORHI0WHEvZEtZcGRLdWsxRU5jOWJaSEx0S3paWTFmOTFp?=
 =?utf-8?B?eTdpaEJBa01GaXdlUFFIVXlVY0Y5ZHpkQWNzam53bUdYNktxeEc1VVI5Q3ZF?=
 =?utf-8?B?WkQwb1NvU0VBRG9ZcEtmRE1QMkV3L1VjTHVhN3E1czU1NTJmMkhHRkQ0Qks1?=
 =?utf-8?B?cUV6SlRVd1FlL25PMkEwcGl1bGxnNW41T0U2QXdScWNJYmY2WDQxTjFsVFla?=
 =?utf-8?B?cWlNMkFhVGNTdXBWbXJJR241WUw1UDZUK253N1lsS25rL0xleWsxSnFrT1lT?=
 =?utf-8?B?WDIrcjh1cVBjdGdPVkZsN0JOTjNjM2RhOXArTUFXV2prV0srbTRPMTBBR0tU?=
 =?utf-8?B?REdBbFVBUEdmSEFiWE9JVlJIQ1F5WjBPMFR6RWVOK2ZTS0hyMGZnME9KZnhR?=
 =?utf-8?B?U09nRXBZbmdhdWp3Nm1sNmtCSVpZYThrV2tZL1FvT3hiUnhwUmpWRnVkNTlV?=
 =?utf-8?B?Q1JjZ1poUFBhK1FNSGRnVy84bERvZVZWV3JZd1FOUlVtc1BKUzNyK0JzakQw?=
 =?utf-8?B?S1hrMXB3VFVqM002TXAzc2lBbWVReXU0V0I4bThuMWI2MjJIT0hQcnh6eXli?=
 =?utf-8?B?eUs2U1lLTks1cllibWJVRkVtVFNnU1pHdGVaSlptZ3I5UytQTUMycTIrb01m?=
 =?utf-8?B?enNqNDlMcFlCNzgrWlF5amlsclJvRS9jYTNWeVMySTFTUXExWGRQZHdPZEtR?=
 =?utf-8?B?bEpaamd3TmM0S0ZVVFRaWHN0TWl5RnhUZ1pJM1dKZEV3OTk2T1JldElmeXow?=
 =?utf-8?B?WC9zMElLQmh0V2dWTE1LRlZUS3hvSmgrLzZIdXoxdmxiTS84YW45YnBBSE1m?=
 =?utf-8?B?Y1haU1k3SElhREtwSFg1U0dpUGxlM3VuVlRQTHo0bmU5V05sL0lUYVhXalJp?=
 =?utf-8?B?NjNhbXhrMml4UnozZExMeVliZzkvMWIyNkU2a1VDSnJLcGtiSndmTndZQnNj?=
 =?utf-8?B?WEM3Z3RYY1lxU0F6VUpuMFNWZVlKeUNWN2dPNzZVV3pnU2V3SjlsdkQ1SVB6?=
 =?utf-8?B?YW9BNmlxc3hLRXA1ejcvcmpvVHJNY2N6MTNkb1FvNHdCQVR5bDU1cnNCK293?=
 =?utf-8?B?NzJrNHFnSzhvdkhmMU9XQTNTVUthbU40Ti80WVM1L2ZHU2MwOE9JUEpsN3Za?=
 =?utf-8?B?SkE5VW02aWJIV1BYVkFIdFNselQ1cGJaUVVINzcvRzNPRm53WjR0MGVhckcx?=
 =?utf-8?B?cjJGdk5HNkcvdHd4YlFWY2l1R0dJSmxORmxzN1hXNFJWbHNYZk5CQnowSDEx?=
 =?utf-8?B?MTlmNW13L3FOMVZONTREMWRaSnNKMmlHOGErV1VGVC9DWEQ1YmtCMmtkTjB1?=
 =?utf-8?B?Q3hrYyt0MkhKY3pZazZKS1pMclBnVkx5eU1pcUdkT1lpbXgyVmhMWVBjclcr?=
 =?utf-8?B?YjZVQmpUUlYzRmp3MFNKZ2t3dnYrVEVXL1ltc0xMVjlNOHJ6QXo0ZGMyVldx?=
 =?utf-8?B?blVPcG0yTWszQ2V6TFZRUzltend2ZzYxclpCMXZVS0tWdTlFS0RXekNQR2JE?=
 =?utf-8?B?Z0g3K1E1VThVaXMvL0l0YzY2bXZkL2lZNExEWEIxRnVkUUl1OW41UUdwVURK?=
 =?utf-8?B?cXpNQ3VSMEhtWjhQN3NoRUhyb2pQVjdxd3dHZVFQS0xuZTlkQXV0eVFjbGhy?=
 =?utf-8?B?ZU5iRlpXSWRoQlE1ODV0NENrckorYnV6b2h4a2U5M0VROFRpZnArYng2cklM?=
 =?utf-8?B?TWRQdXdDdmtLTCswVVQwMjhTSkpxSWZTR2lBT1pyVWVDeXp5SjZGbjJvZ2F5?=
 =?utf-8?B?OHF5SjJ3Q3lFZnIzeGZiM2dGdU4xRlo4ZldTdHhDNE5FZEp3UGVDTExpem9V?=
 =?utf-8?B?a0ZJS3I4a3cwbUVwVUIxMlpQK2JEa0pSb05LVDc2QUE2TkdGaFBkSCt3SE8y?=
 =?utf-8?B?a0xvdUhvYThzQzVWU3pzVHN3d1lsWmRibml4ZjlYNXJ4YVR6Mkc3NnYzNTcw?=
 =?utf-8?B?L3RvdE00QllveGQ2QVIyM1RpWU0wVTYybldrMGVQTVlwb2NoUjVjTEY5cWFp?=
 =?utf-8?B?UFZLbmltWWdZWDB4a0VEQjVrbFdOK2xtSGxKYjdyVVc4TWdGcGZHRlB0WXFX?=
 =?utf-8?B?alRDVHFSOGpYdlk5c1JZemkwU2t4VDFTTVY2QTlTV2pheitiK2drcEN3cG4z?=
 =?utf-8?B?RmtjajgxclRPYjZqNmkveU5GMWFzY1pxcXpuSU9yQStnMFgwSml1SW9OdEtE?=
 =?utf-8?Q?P9xOBpIinsv2SFRM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ffa892-1e9a-4ab2-1627-08da1b7b8962
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:24:22.7431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cChAOAk7j59tldYhl2ZmSOUiJjOfC44nbcw82jn9LjK6bu00DOPdC9NOgNPWgoJIxyDm4EC3eiR5gIMvgD+y5mOt7Gb2SI+jit+HKIGAzd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110030
X-Proofpoint-GUID: 0RjYpahiKOwwqaPTBzH1FEvl_Oa95jji
X-Proofpoint-ORIG-GUID: 0RjYpahiKOwwqaPTBzH1FEvl_Oa95jji
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In preparation for adding support for intent item whiteouts.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 119 ++++++++++++++++++++++++-----------------
> --
>  1 file changed, 67 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5179436b6603..dda71f1a25c5 100644
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
> +	return xlog_item_in_current_chkpt(lip->li_mountp->m_log-
> >l_cilp, lip);

I think this turns into "lip->li_log->l_mp->m_log->l_cilp" in the new
code base

> +}
> +
>  /*
>   * Unavoidable forward declaration - xlog_cil_push_work() calls
>   * xlog_cil_ctx_alloc() itself.
> @@ -924,6 +956,40 @@ xlog_cil_build_trans_hdr(
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
> 

This part below does not appear in the new rebase, so this would go
away in the hoisted helper

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
> @@ -946,7 +1012,6 @@ xlog_cil_push_work(
>  		container_of(work, struct xfs_cil_ctx, push_work);
>  	struct xfs_cil		*cil = ctx->cil;
>  	struct xlog		*log = cil->xc_log;
> -	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*new_ctx;
>  	int			num_iovecs = 0;

For me, I had to add the new num_bytes variable here:
	int			num_iovecs, num_bytes;

I think the new helper does not need the num_bytes parameter in the new
rebase, so we may be able to just remove num_bytes  entirely.

Otherwise these hoists look straight forward.

Allison

>  	int			num_bytes = 0;
> @@ -1043,31 +1108,7 @@ xlog_cil_push_work(
>  	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
>  				&bdev_flush);
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
> -	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
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

