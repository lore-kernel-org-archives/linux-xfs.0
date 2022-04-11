Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C671C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbiDKF3k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244722AbiDKF3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:29:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7CA11C34
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:27:26 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B3Lbaj029741;
        Mon, 11 Apr 2022 05:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Jy+s6IqmWHoz1ziuuudjTr9ZDGhKBrBpcpGqRvDX0vA=;
 b=xt1swff3hxRUr+V3QGkx6MqrZMDuIHH45pshpk22WWoEy8NhiIUYELLZGsYWELon0YIA
 UjSGMUkaNpGEcfLDLy5gfLn9pgnW6O1ZPWlvtv9qM37dY/B3jX5WszCnGwYEGRe1wHh3
 J2UDis3u10YchZq+a4GKjOrGUmbivq0FIkcmz1cZCyG0Un1Lz3KBUNVEYp64N5wvo6rN
 aODAV9pZq6JlruKJ/FlFZT69wKluEFP67w8nHbjJGRjqrtZ9srJtywGEN6kWPjRchetU
 r1OS/mU2rrKt0yUbNYHsjP8JnvViBV6wxYq+rtXUQfyCOEPZBqZEFJCYKGElRczrP+lj zA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd2cmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:27:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5G57h032989;
        Mon, 11 Apr 2022 05:27:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k1xq6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:27:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKTFKj+NABRSSd8pN2NAg8bpuAxmAvDlgSrfO1bLxbL5z3DbznwxZjce5FHkwAsBEmkgXsJLCc0Djz2MFOuNgPfy2ipleweE0L3jrD+J4XitxOst7wjTBtcB5k3V6LTHtZfdrBLmJzQ976U0qtvBM7JESNHTNxE0pgqWh/5jUfM7NhK2aJt3MgEFHiyIFcu3tA/22rSEEHUsN2Iv/CAolctYrWZLSQyEOeeS+4Xk9JHXO4OcZ8eJnxScjKeLeTEFX3vF9ggIoh6khjkk7DTiVtHKsWhix+7cT1MJ3cahCIQbBxkLM4XMgDO9SvNcwSDn7W7HtvWf3BWGAwb9GGeZCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jy+s6IqmWHoz1ziuuudjTr9ZDGhKBrBpcpGqRvDX0vA=;
 b=Dq+jwQjDvrh2jmrli1zKJZkO6FTwr9YPfrCxaAlXhHZf9damUWuljEFI5M77/YFl9T4835ALY0mRn/LtyNKdOeSATQCEBSsFo9ur+GSG3W0usRgYw2d0f7v6G3gzu6KscjY+/QAm3neWeLPD5vIaNPqhr5WPCnLTl9BGDLIhLRPAuAasTEJPGvBPyY2iVJUOXb5vA6uaH+NIgNSdZ+8XaT4iz5q/dwDMnGDENo0OEHyCl3MqXnCGhorRs2a7yYOJVbIBOufXxeLioT/NvW1m9s5VWfdm8S0C6gmSVpIZDbkw7M5W1fw14jF3B/ydfPXqJnXFEgbwI6Wgkh4NijjTfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jy+s6IqmWHoz1ziuuudjTr9ZDGhKBrBpcpGqRvDX0vA=;
 b=z8LC61aduj8VfPXuMMxWMuYW8+OkqViFm+V22yQ84+gSROi3aoClZB2SZqnGKITcM7rA465ibHB19i8ZmxUhFpDB9mSh1IkBfk6m7q99EWegouQwN6qhcjBENin5WzUhCHYi5/hZo5+cINJIXXz5qHF2aqPfe3UwYpUglTj4Q38=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5114.namprd10.prod.outlook.com (2603:10b6:610:dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:27:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:27:22 +0000
Message-ID: <951beb03273160a55d796036a2a494af55e34b8a.camel@oracle.com>
Subject: Re: [PATCH 7/8] xfs: whiteouts release intents that are not in the
 AIL
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:27:21 -0700
In-Reply-To: <20220314220631.3093283-8-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
         <20220314220631.3093283-8-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d2d68f8-8a2d-4c05-f499-08da1b7bf440
X-MS-TrafficTypeDiagnostic: CH0PR10MB5114:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5114FAC78BE71D247F6D230E95EA9@CH0PR10MB5114.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KK02LrOvYbIl76rXw+LXwU5NUdrUMtLeOEhky5yGhZ2OlNuMG6noKYbwQWqC8fbR8QG2vxUqFsW+mOix4SJY2I3hdSEMXFe9ZqUTwAdB2xF+N3XkJbWf2U9061DTlWk/IHcHIeX4a0FCcXFb6XP7CTQ0/YTRxtAyQSHr+5Akul0TiAS1Sj5JSvDbX6AIusB0bm6XTgc8fIi8eYplFgY9rumypV4tF19RS8X6/VucUkhhFA/9AifAwINnWmeNTsRiIs5PIOzOVt/jQcsDNsvZhB3s6F2/KSr9CudEFceSDJs9i7M+UDg0zGerxhl0Hz1syo3Ypza3IqeELjLjck2gt0SWSEcGBfRBmVh6xPJhAGrZNrJxSw797PUNF0bLkCnF/IiJPOgaC9eq27SjVEqdMkaL/WLfW2/PBM43ttJydzCMGGhi2mAgMKRIaQbnXIM5b2zSrd4k6aGJgOiGTjfqwLsJuNt9TTrezlBoIPYJC2rHN0wPntMST//bbLapPfd7SLWMd0fMAm0BIv4ZltFbBajPkvW8PpbXmfnKMmwutwoc8WvW42ikKn5Ku1EKPyQyYjlbzhpKdBP4TMF9N4A2gu1RrdqcXlxk2+0/xoLV3Zc2j3XwVFdtzGZpH6UfDLNrEZHNIue4iWBv+PYyqeyMP2f11atqJMr0/RyXxSYsYEQWDG2suUKukbJHg3ZG61ro
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(83380400001)(186003)(26005)(8936002)(2906002)(66946007)(66476007)(36756003)(8676002)(5660300002)(316002)(52116002)(6506007)(6512007)(2616005)(86362001)(38350700002)(38100700002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGd2enJTRjR5M0hUQjBqS1RTUldGVXVhRFVaNEswZlFsOUwzejM3NlI3ZXU4?=
 =?utf-8?B?eVE5SDVBOXYzTFcvLzNkMVMxVFIrL0VhT2JtWXdFUUc1amI5Z0J6cHQzL3Jn?=
 =?utf-8?B?Qm9vdURXZTBqem96TFFqZTlUV1A4eEgwb0RzbjdBM25XSW50d1hlZGp5U1dR?=
 =?utf-8?B?NEhGZVY4bk5LQjY2K3l2ZjhrcjE1L29SMCtWaCtGSjVJMGlnSFQ0bzJ5RHdL?=
 =?utf-8?B?UUVtOFNxRXNIQTB6VDhxTjRMZDlDNTNReldPSTBwWXhkQzE4UnF0emVtcE9K?=
 =?utf-8?B?TTA3NUgxN0ZQalpLN1o5Nng2bkVQZWo5NlFYblJXTDFyNzNzK1lYRlJNUlZ6?=
 =?utf-8?B?K09DVHl6Qng0blFLV2E0QWRxWXZadmtUTjcxQ0kybnpJeUxBUGxubW5ET0lJ?=
 =?utf-8?B?RXpjcHJUa0RuTVp5U0NvbnVvVFRnYWxCZ2o5MVJTWE53ODBlR3JsMXFMQ2c0?=
 =?utf-8?B?cnA5ejhiTXI3a1lMbnFrRklGYVdBZTF0VktXVE1CbTFaekV6aDlZSTl4NXg1?=
 =?utf-8?B?dVlnbEZ2SVdIeCt1RkIvMTUxZ0hEeWxsUUhhcWQ0U3phdkxjSUxuam1jbFZE?=
 =?utf-8?B?Wlp3ZXltWWR2WVlkYVZRWWZRbFpsOWdxdmlhdWUrazVTL0RGc09wV2N4N2Y4?=
 =?utf-8?B?d2VXcE1LNmZGRk5HRkp4UHpmbjFTNWIycm1pVHd4NkpWcDZLNElsMnY4VmNh?=
 =?utf-8?B?TFVwTWRIUXFFd2hRa3d1a0I2WnVCN1NsL0NvNXUzU0xBU3BkT3NTU25NdzJw?=
 =?utf-8?B?Z2pHUHNObEl3SDBmcmdDTkJsSkZqQ2xmL2hOVS9sODNXM3EyZ0cxTnZZaVR5?=
 =?utf-8?B?KzJuWk9WQ3lSTG5HRTUzOEdWMGkxTUIydkZhZ0NvUmJmUTNnT2NZLzBGdlFC?=
 =?utf-8?B?NmxKblF4ZGVDd1liQmtqYUw0SDF2NmhGdklic0YrZ2RzTU9wc284MkVnRlFj?=
 =?utf-8?B?c3NweHRlcEF2V0NjK2FOWUpuaWM3MG5NbFFQOG5ONnJvOGJpY3M1ai8zc3Ru?=
 =?utf-8?B?OHVvWm1jaUZRNmtXdE02UFhvbjl1eVRneFF5blF0UTlJSWZwOExEL1QwUE1l?=
 =?utf-8?B?MTRtSkxVMmVjZ3lWMTcrMHJCcEZXZnZNblk0QlZ0bmY3VWVKOUp5TDhmdVVl?=
 =?utf-8?B?eU9aOW5lWHNMSmVyODVNcVd2MFh6b0pUeU1Nam15bUVCRVp3dzZYYmtuRWlt?=
 =?utf-8?B?ZmxlNXI0eHdIMnlXOUp4RXBGa2U5dW1BOFA3QVoxbFBlWEloZFMvckZ0dWVX?=
 =?utf-8?B?TUdGWkQ5S1V6TmgzY2dWTld1ZVRmNS9KNmtPM2FpVVBaR2l6d0V0K0NpRytu?=
 =?utf-8?B?eDVrV1BSRHFpbTJsQ0kvZmhBL1JEdjdlU0dLbkl0Mm0wb2daTDgxbnBYQ3VL?=
 =?utf-8?B?UTFLR0FWalhQODdPV2lzeExSOHZHTTJQalpDVkFMbFlXMFI1OC9nV1JqWHo5?=
 =?utf-8?B?NklQbUozdzdSRXFJY2JDeFg2bHVtUTllNGNRWGZSUERiM21tb3YvRDdIVmhm?=
 =?utf-8?B?MVpMZ3g0TVZ1MExTZUo2anZGVnZMQVdpSXRnVnRtK3c3NGtYcTFUbVlhZjVa?=
 =?utf-8?B?MjBZODNLQnlJNkJnOHB3WjdiS0pXK2tlTklsTkFKR0s2UHJXcWFReTYrTnhq?=
 =?utf-8?B?bDJTOHRQM3A0WlhCNGdDeHltQ2I1dTZWRGg0OURNdG0rQVNvcVVYQlBGaEZB?=
 =?utf-8?B?UW9LZyt4ODExNXZBVFdneEpFc3NOeUdXRm94SkJZVW9lUUlGUEZPK1NTZUdw?=
 =?utf-8?B?V3JnaENHSDZyMm9pd2RxUmFNbjNQc29PYU5UTzBzRmdHc1pnam5nTEc5N29a?=
 =?utf-8?B?YUpyTGFnNWhpM3kvTVpFZVJma2ExWE4rY1BJSG8zbFZCMGgza1BkbFY4YlNa?=
 =?utf-8?B?bUN3dHVsSkxoOUUyeitSUkYvOVNaRlhBWjBlMExzakFKZmVQY1FkZjBiQWtK?=
 =?utf-8?B?ODFWd21qek5mZ3BraVRmNmIyemJiZWljd0xsbnE5d3lWRXByL2RRYjBTWERN?=
 =?utf-8?B?UjFaNkxjNEFTYWtsZTVpRm5vQlNWRXpXNXVKWHhZSGRYZWxIY0pPM00ybHR3?=
 =?utf-8?B?M0lqWVdkMmUyMmVJbkU2SFkyWHVGVnlyMG5QTGtiTWdvb1R0SGpUak9WMS93?=
 =?utf-8?B?a094VmFsM2ZlQWZtOVBTV3BYc2VLYmxUYWd3d1Q1N0hhUTFaNGJDbExSVEVa?=
 =?utf-8?B?LzgvdnhBRkxHTTZ2L1dxbnVUVVNwR0pyWGRuVEgrSXkrN0V5c0srUFBpWXZM?=
 =?utf-8?B?VFJpU21vT3ZtYW0rKzRGQUdIemZmOTBTSG1ScUs5Qk12VUVKNWNadFhnK284?=
 =?utf-8?B?ejRkMTd4d1J5UzhIT0YrZ2J2ZTZnbFJkR0ExUzRSbVhpMVNqcCs5dlZ1dTlo?=
 =?utf-8?Q?xw1Snq2iqkpFtkP0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2d68f8-8a2d-4c05-f499-08da1b7bf440
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:27:22.0421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugpfqfkpG29+CXLhSIZrCSqRKDt3l8P6Zh/KOVoqoHP+Cbacjsb8RdQqdQ2eoCD+F8a7YsHCdVnjxvT/XY0oup6cyR1d0HtFPcCuI4IO3GE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5114
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110030
X-Proofpoint-ORIG-GUID: wqZU75pbFq43BP9tLAvcqsqIYGLttSZg
X-Proofpoint-GUID: wqZU75pbFq43BP9tLAvcqsqIYGLttSZg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we release an intent that a whiteout applies to, it will not
> have been committed to the journal and so won't be in the AIL. Hence
> when we drop the last reference to the intent, we do not want to try
> to remove it from the AIL as that will trigger a filesystem
> shutdown. Hence make the removal of intents from the AIL conditional
> on them actually being in the AIL so we do the correct thing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, makes sense
Reviewed-by Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_bmap_item.c     | 8 +++++---
>  fs/xfs/xfs_extfree_item.c  | 8 +++++---
>  fs/xfs/xfs_refcount_item.c | 8 +++++---
>  fs/xfs/xfs_rmap_item.c     | 8 +++++---
>  4 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 2e7abfe35644..c6f47c13da27 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -54,10 +54,12 @@ xfs_bui_release(
>  	struct xfs_bui_log_item	*buip)
>  {
>  	ASSERT(atomic_read(&buip->bui_refcount) > 0);
> -	if (atomic_dec_and_test(&buip->bui_refcount)) {
> +	if (!atomic_dec_and_test(&buip->bui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &buip->bui_item.li_flags))
>  		xfs_trans_ail_delete(&buip->bui_item,
> SHUTDOWN_LOG_IO_ERROR);
> -		xfs_bui_item_free(buip);
> -	}
> +	xfs_bui_item_free(buip);
>  }
>  
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 1d0e5cdc15f9..36eeac9413f5 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -58,10 +58,12 @@ xfs_efi_release(
>  	struct xfs_efi_log_item	*efip)
>  {
>  	ASSERT(atomic_read(&efip->efi_refcount) > 0);
> -	if (atomic_dec_and_test(&efip->efi_refcount)) {
> +	if (!atomic_dec_and_test(&efip->efi_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &efip->efi_item.li_flags))
>  		xfs_trans_ail_delete(&efip->efi_item,
> SHUTDOWN_LOG_IO_ERROR);
> -		xfs_efi_item_free(efip);
> -	}
> +	xfs_efi_item_free(efip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index ada5793ce550..d4632f2ceb89 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -53,10 +53,12 @@ xfs_cui_release(
>  	struct xfs_cui_log_item	*cuip)
>  {
>  	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
> -	if (atomic_dec_and_test(&cuip->cui_refcount)) {
> +	if (!atomic_dec_and_test(&cuip->cui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &cuip->cui_item.li_flags))
>  		xfs_trans_ail_delete(&cuip->cui_item,
> SHUTDOWN_LOG_IO_ERROR);
> -		xfs_cui_item_free(cuip);
> -	}
> +	xfs_cui_item_free(cuip);
>  }
>  
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 6e66e7718902..fa691a6ae737 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -53,10 +53,12 @@ xfs_rui_release(
>  	struct xfs_rui_log_item	*ruip)
>  {
>  	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
> -	if (atomic_dec_and_test(&ruip->rui_refcount)) {
> +	if (!atomic_dec_and_test(&ruip->rui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &ruip->rui_item.li_flags))
>  		xfs_trans_ail_delete(&ruip->rui_item,
> SHUTDOWN_LOG_IO_ERROR);
> -		xfs_rui_item_free(ruip);
> -	}
> +	xfs_rui_item_free(ruip);
>  }
>  
>  STATIC void

