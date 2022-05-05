Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D036DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 17:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382565AbiEERte (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 13:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380815AbiEERtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 13:49:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5754C42A
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 10:45:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245Fbww7026114
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 17:45:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HST+AFnAjJWD3VSz3XH6JTJ0x0Nn7mV7SS+cqfoz0sI=;
 b=gqHxhWoZC397JJ9bmSR4XsPgnUAN78MKqDL+m3EBhdVUG1MTsGQwYTPsGBc/l9pASpBN
 Y+9y3A9lLMqZDsxzAmK3VoVBChVo0jJTTOhw/monlOx25Q8tiA3UYg/n2PiH9JTgnlbU
 tPnKbmWRPnvb/t1RfGdNsJgAI3Fgtl3LAJt4JYytKjxX3dWwkOh5QBqjcZ4OK01y8B1v
 QTMicNfkewHzdbmSFcAS4dg6KrfKtLgv9JbJEbMokDmL61CnFnBifc7COz6PDrHTa7oE
 p63ov+XD39Rc8U7adwWRvlEtY98dHCTPf7N5KoU3kDO58OGTHcI1JWsnAlMuNpLiJtoT KQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhcbv0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 17:45:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245HesDo015307
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 17:45:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj50agq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 17:45:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wt9gpleG1WiC+VdURC6kS1wofngq37zdsYv9PK1A3l6QE9JaikDjb7xyDjw7tQ0vg4ByYQm9/SUbbfI9l2pWHXYQ5/duGpF3X0CXV8/CDNdiNtEbI+FaDedVqjJBUC+KGb2tqIV1tME4eTyOdOnIHkXKz4K66Z5CPZq+P3YWnDU3Szt2cnLsUPmQpXpiytq11wNA/cgL6aq6Lcril3CYR+khJMrimGP69eZvdbwrN8+QEzgm+rwtBwcfDT3seVFFBexT3qckI71A1W59VJ//GFPNDRdh4T/UJwR9RDS0hikdNLiHyrEspwDlPoYEk56OJkaj9fDNr3kPOiq5Yfu7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HST+AFnAjJWD3VSz3XH6JTJ0x0Nn7mV7SS+cqfoz0sI=;
 b=IExs7cuI5Bder/KnNJQ316L/jtG04lYIL4zFjweAyAceosngqNoGNHCAJfQqyhLY8bsycq/SxsYasC8WDeR1IWVgystUdiRe13gKUwrTtU0B0/PpDewbCPb4KgTXO/WKHwPPwjSUDxfIMNIIau+wZ2VGCBd5mxp7HGIc6TCAZtpG6PH+EHrn4VWSjmW/7rs7fZdoXkQ5ImnwQAQElr1OpPKpZXGphevfZHVM9cAClMXEN0lYCy6nrd95j2S2OjV+RfrcK8kBB00l5W/vFsc9CEk9nN9HSfTY5op2VQpaA8Q39scbpBZZ/ce17oVGw5/B5x/wwlEPS5tyzUDN9mgsuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HST+AFnAjJWD3VSz3XH6JTJ0x0Nn7mV7SS+cqfoz0sI=;
 b=y298ZEErZPNb8A54hHAdzAZI91e/O7nn3e3T32iSMMt6Ycdtcqmi9hafz3nTVnmP7MXXZl0d40lbWlGpf6jCx9DbV5mNcNtoc5tkYOQFgQ+f3MSwMxwii4JZBrcmkmEba3wjeJKf4Af4fqV5ox5JOZTFU6WISJqW9JKofwsIjWA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5202.namprd10.prod.outlook.com (2603:10b6:208:306::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 17:45:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 17:45:48 +0000
Message-ID: <20968bf96ef6d4191268e52b4a81fe9f1a7f1c75.camel@oracle.com>
Subject: Re: [PATCH v2 2/3] xfs: remove warning counters from struct
 xfs_dquot_res
From:   Alli <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 10:45:45 -0700
In-Reply-To: <20220505011815.20075-3-catherine.hoang@oracle.com>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
         <20220505011815.20075-3-catherine.hoang@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7cef277-d664-4dcf-86ce-08da2ebf16c5
X-MS-TrafficTypeDiagnostic: BLAPR10MB5202:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB520275B4AA47A5B2D5BD8CBD95C29@BLAPR10MB5202.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K4HBM73920fltzizdSBLmHA3qr3luPoUcdURNVShaA11Kyn3MDn8o5l8egJYJgyr0p9OzwEbyTuxg5gDY8nmWnhz2SAlYXgRD7h9bQ39HzlA531zK0N3nEyoe/AfXrrDUd8NTuZELnTODkRx6HK3a5oY7M0EJZaRJItcv/zcc5X1fIjrBop4JZZjSwlXwjRdj2YATVMxi5sVKrPcIZEcxyf8Isy9OfsI6SY0G0gHPVs+R5zyL5CO5eaajIK/wd37kATzSKiBJH+hOByKVMQdIa4czn/HGkGepenfm6q0P2IjTLrYFp6RIbpZAM1jhs4DLWhKG6DzYF3ELZMgmQtH8+p9RxTGtaHIsFvW8vD0BgLeZ4Tr4dQa6Oj6ZBrznDuTaVMp/K6QzywLKEeOMwLz7szM/bqSuIv25IcVTQMAWEm5twkRQ2K0FNkFzwZHZDTEDV7I4bGs9KborOvJfXEtqo7qXBNPkIqP3Nzs2UoqfbbKwOrIE6gcHkS8xPI/ugQLuQzQ8uQEGBfyxMrpo1BKBtKXGRRF0fFhnq7ClNa10WYPtEH7VDbcslXFsaVw1G2lf7LNmS8AgRj5IAFgk/v3zmSoMJ55cw1YAMU4XVWsVi78h3soi5LrDMD+QblfTQw71tygnM9OqCLglq2EAFmLiVHAefH+wGAQ8/7BT/mWOxFY/4HXJfLZN/0AZ466ZDn1gQNwevBFFXS8/NyhyFqkxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38350700002)(38100700002)(2616005)(508600001)(5660300002)(8936002)(66476007)(66556008)(8676002)(6486002)(66946007)(6512007)(26005)(186003)(6506007)(6666004)(36756003)(316002)(2906002)(52116002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFhjNzZvL2tJM1VDeUxiZnYxZG12aXJ3WlFJZjlXK1YwUnN1MUFyQUVCSjBw?=
 =?utf-8?B?MkQ2R3c4MWRIYkZyNjd5aWxHZ2RxTU11N3IvQjVMUWQ5cmpxcGtuUEl5Qnp4?=
 =?utf-8?B?WVBWUUFvVmRjY21zQnRJcEZqSHAzaGcxa0VHZnA1KzJ0WGFpZG4xSHpHZ1V5?=
 =?utf-8?B?ZW90UE9yWEZSTzhhVmdlcXppNkxUcU0vdEdqTGx0SmpWUWF0RW1xazFteE1j?=
 =?utf-8?B?YVUzMkxnZjVaMmZmYzFxc1ZraTc0MG9IdFpwSkNBRUZ3NUltTDZCTkZlN3FH?=
 =?utf-8?B?WXlwQWdJWllMSVQvYVllZk1qWnlUSFVnMnFHTm1yQTgycWxtMXFOZ2x4cFd6?=
 =?utf-8?B?U1VQSjZKRUpXdTJtbG1peVpoVVFaMWVCQTZKQlMvbjZQUjIwVzlSaCtKSlY5?=
 =?utf-8?B?cXZhRDFwaGtlaXZBMlN1RUV1QXd2dUNxMnM0K1U0TWV2L3NXaXE1d3pzRlJW?=
 =?utf-8?B?Vi9UM1EzS2o3OVFvcmpqVU9KcVd2SmlvRnhyWjFZRkx0LzByVVVYb29aeTlw?=
 =?utf-8?B?ajZsYUp2SDV1TFBBL2Q1ZXdpWnp5em9OVk1iSjBkckRueWt4THN1VkVYZ04r?=
 =?utf-8?B?cFNQbTE0Z25kUUZuVXVNbWFVS1FtYllHQUF0bGxrRzFPdFByRVB3aDR3Wmxy?=
 =?utf-8?B?ekNIMU82bWtla3B6dXlYa1JESWJVMHJLMTRRN2hyT1Z0R0NhOWdUUStDU3R4?=
 =?utf-8?B?RDQrWklIR1lxeEpZMldIRkpaZ2MySWt4Y1hXQXNIRm5JckM0S2lST0wwYlNv?=
 =?utf-8?B?WTdaNDVLZENCejBZSW1GT1cybTR6U0ZqSjFna1dlTzVubllBWGFpN1RHNDVD?=
 =?utf-8?B?MUpHenBJQWNsOWxseXE2WWIzYTJFUVRQNUQ4ZjZHdXJNdDhhMTF3S2NuZEFU?=
 =?utf-8?B?NUxuc2dKbk1kbnU4Um1HaHBIazB2SkgrcE0zMlNOQXZjb3hkZ2hwUVNQR0xn?=
 =?utf-8?B?ekpaV093UWswZjNHbk1vWmxDUXBwZHc1RzlyY0M1N0p3a0lxVjlzK3JCZFJG?=
 =?utf-8?B?QnphcVEzYXFkZVhKNnBuYXR6a2tuRVlvSitCc2h1UlJVUjMzNXZNc210WEsy?=
 =?utf-8?B?VzdiMXBtZ2FlY3FTZGNxNnUzZWhYQXFJYisvSWNBeCtidFNCSkdBa1RGRmtC?=
 =?utf-8?B?QUwrN1VzOWVUZG40ZFBVVWIyMEtJNmRQdW1BbDU3YUJKNmdBbjBOcHpkSG5m?=
 =?utf-8?B?dU9yTGpFWk1DaDVMKzVueGtIUHNsY3dRRzc1ODBYTzFweXdYRDN2a0NORmo0?=
 =?utf-8?B?eGJPVnMvb0l6enZhbFhQMUtaYy9jbHJoTEpMZ3MzTEZRMThrcHhCL1o1c3lC?=
 =?utf-8?B?ZGdPR01wTEI1M1FBT2dRbkVOTjhpbzkvSEQ4bmswL2k3dGx6dHBYbXJTSlE3?=
 =?utf-8?B?MCt4UWRXTjNRcG1ZQU1Xd2RVa09YQ3hUb1Q3TnpJM3V2MVN4QnJ0NkdCQXFT?=
 =?utf-8?B?b2E2ZXRWVm9JU0g3UUltNTd3elpuWXlYN091Y253amUyU1VNNXhoR0hRN2VF?=
 =?utf-8?B?enVsem12RXhXOUtWenpYTG1ZNXltVVFNTnhCOGdDeDY0TWpxdXhlZjF3cFAy?=
 =?utf-8?B?Z21OeXAwNHF4Qi9KU21qdkk5eXIyU0ZPRExCbE9TaU44WnZEcTdUU2FNbjlO?=
 =?utf-8?B?dFAwZFJlelZpSGJjS2o5UTFZalRmTWppV203eDJVY1VOZ3c3N1UzQWRFWlpT?=
 =?utf-8?B?NnJBZzdaeFNmcVV3UVVNTTdlbkREZ2YwTTlocG5wUmNrTVBqQzJxblh5L3dW?=
 =?utf-8?B?bHR3a0FCREJqTUlHaVpMUUhEalNZZ250QS82Y044YmZQVDFvU1N3VHhKNy9W?=
 =?utf-8?B?Y2hybTQrTlJYOTAxcTBvVk9HSGJTNkpaRElnZ3B1UG96SmxOT0dKZk9yQzN3?=
 =?utf-8?B?THlkZFg5Q1dDNExHclM1c0JuQnRsRExWLzhPT09qOCt4R2ZOMjhwakVhZHlL?=
 =?utf-8?B?c2NOYlZwZW5icHB2RzMwU2xQNmdhZzMxUUptYmtMbHlYUDRwaXpubjRGY0Vn?=
 =?utf-8?B?SlcvRlB1dzNGdGRXbXdzdURJSC9zSVRoQThocWVuemdwKytubkpXTG4wejRH?=
 =?utf-8?B?ajZPTmhhL2tnb0Rya2Fkb3ZaU1hISjFBaHdEYnU5YytFRXlNVWpCVmJPVTZS?=
 =?utf-8?B?VHhMbG4xcDIwNHJQMjNkRVlNTlprTWw4TWNGQ1p0RGRhdVNxS3EwMmE3OEJ2?=
 =?utf-8?B?b3QrcU1ZL2QzS0hIZ2pFWjVYWC95M2t5a3Y0NEZHbG1KdTlnTXNiRnl2VW5w?=
 =?utf-8?B?QkttMmI1OTdCWHluaHpDNkdIQ1RnNnJRaEZRbmdzU1k3TjBuVFY2N0l5eGY4?=
 =?utf-8?B?YWNjU29RZW1Vdk5uRDRaU0RTd2N1TGYxbW84eUZzUXFTS1JHT0IrMUJlcnNo?=
 =?utf-8?Q?eojpXSAnFKQE/HJw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7cef277-d664-4dcf-86ce-08da2ebf16c5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 17:45:48.3583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLTi4gyMQSVZCh9JUhgnorZ6jE9SVK7NqTTfuHQ/0q9DeRiMBiHSs7hWBd0D0xCfOGvx5gxiWHBo8cxO5NNZjCDlKryOUQRc1rFnKoxzXq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5202
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_06:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050120
X-Proofpoint-GUID: Yul-rIIhdn1KK9yb0MzqJPFaHw76xcE8
X-Proofpoint-ORIG-GUID: Yul-rIIhdn1KK9yb0MzqJPFaHw76xcE8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-04 at 18:18 -0700, Catherine Hoang wrote:
> Warning counts are not used anywhere in the kernel. In addition,
> there
> are no use cases, test coverage, or documentation for this
> functionality. Remove the 'warnings' field from struct xfs_dquot_res
> and
> any other related code.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

White space nits aside, I think this looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |  1 -
>  fs/xfs/xfs_dquot.c             | 15 ++++-----------
>  fs/xfs/xfs_dquot.h             |  8 --------
>  fs/xfs/xfs_qm_syscalls.c       | 12 +++---------
>  4 files changed, 7 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h
> b/fs/xfs/libxfs/xfs_quota_defs.h
> index a02c5062f9b2..c1e96abefed2 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -16,7 +16,6 @@
>   * and quota-limits. This is a waste in the common case, but hey ...
>   */
>  typedef uint64_t	xfs_qcnt_t;
> -typedef uint16_t	xfs_qwarncnt_t;
>  
>  typedef uint8_t		xfs_dqtype_t;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5afedcbc78c7..aff727ba603f 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -136,10 +136,7 @@ xfs_qm_adjust_res_timer(
>  			res->timer = xfs_dquot_set_timeout(mp,
>  					ktime_get_real_seconds() +
> qlim->time);
>  	} else {
> -		if (res->timer == 0)
> -			res->warnings = 0;
> -		else
> -			res->timer = 0;
> +		res->timer = 0;
>  	}
>  }
>  
> @@ -589,10 +586,6 @@ xfs_dquot_from_disk(
>  	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
>  	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
>  
> -	dqp->q_blk.warnings = be16_to_cpu(ddqp->d_bwarns);
> -	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
> -	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
> -
>  	dqp->q_blk.timer = xfs_dquot_from_disk_ts(ddqp, ddqp-
> >d_btimer);
>  	dqp->q_ino.timer = xfs_dquot_from_disk_ts(ddqp, ddqp-
> >d_itimer);
>  	dqp->q_rtb.timer = xfs_dquot_from_disk_ts(ddqp, ddqp-
> >d_rtbtimer);
> @@ -634,9 +627,9 @@ xfs_dquot_to_disk(
>  	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
>  	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
>  
> -	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
> -	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
> -	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
> +    ddqp->d_bwarns = 0;
> +    ddqp->d_iwarns = 0;
> +    ddqp->d_rtbwarns = 0;
>  
>  	ddqp->d_btimer = xfs_dquot_to_disk_ts(dqp, dqp->q_blk.timer);
>  	ddqp->d_itimer = xfs_dquot_to_disk_ts(dqp, dqp->q_ino.timer);
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 6b5e3cf40c8b..80c8f851a2f3 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -44,14 +44,6 @@ struct xfs_dquot_res {
>  	 * in seconds since the Unix epoch.
>  	 */
>  	time64_t		timer;
> -
> -	/*
> -	 * For root dquots, this is the maximum number of warnings that
> will
> -	 * be issued for this quota type.  Otherwise, this is the
> number of
> -	 * warnings issued against this quota.  Note that none of this
> is
> -	 * implemented.
> -	 */
> -	xfs_qwarncnt_t		warnings;
>  };
>  
>  static inline bool
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index e7f3ac60ebd9..2149c203b1d0 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -343,8 +343,6 @@ xfs_qm_scall_setqlim(
>  
>  	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
>  		xfs_dquot_set_prealloc_limits(dqp);
> -	if (newlim->d_fieldmask & QC_SPC_WARNS)
> -		res->warnings = newlim->d_spc_warns;
>  	if (newlim->d_fieldmask & QC_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
>  
> @@ -359,8 +357,6 @@ xfs_qm_scall_setqlim(
>  	qlim = id == 0 ? &defq->rtb : NULL;
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
> -	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -		res->warnings = newlim->d_rt_spc_warns;
>  	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim-
> >d_rt_spc_timer);
>  
> @@ -375,8 +371,6 @@ xfs_qm_scall_setqlim(
>  	qlim = id == 0 ? &defq->ino : NULL;
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
> -	if (newlim->d_fieldmask & QC_INO_WARNS)
> -		res->warnings = newlim->d_ino_warns;
>  	if (newlim->d_fieldmask & QC_INO_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
>  
> @@ -417,13 +411,13 @@ xfs_qm_scall_getquota_fill_qc(
>  	dst->d_ino_count = dqp->q_ino.reserved;
>  	dst->d_spc_timer = dqp->q_blk.timer;
>  	dst->d_ino_timer = dqp->q_ino.timer;
> -	dst->d_ino_warns = dqp->q_ino.warnings;
> -	dst->d_spc_warns = dqp->q_blk.warnings;
> +	dst->d_ino_warns = 0;
> +	dst->d_spc_warns = 0;
>  	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp-
> >q_rtb.hardlimit);
>  	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp-
> >q_rtb.softlimit);
>  	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
>  	dst->d_rt_spc_timer = dqp->q_rtb.timer;
> -	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
> +	dst->d_rt_spc_warns = 0;
>  
>  	/*
>  	 * Internally, we don't reset all the timers when quota
> enforcement

