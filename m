Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB15BC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Apr 2022 01:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiDWBJk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 21:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiDWBJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 21:09:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C914E19981C
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 18:06:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MKEaHj009092;
        Sat, 23 Apr 2022 01:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PorJbU+wMlGa5Cd+f3WI2cEAWzVU9+bXPmRrv9nzMHQ=;
 b=he61xvB9qf3zqfm/3OpNBOGHWMLsWvWLkf6GdSAmATEWSEFzb0/QmtHo3wCYQnGXTx6M
 lyEEW0qHs660mFK1j1jUIzrZtgvCjU7iwdEa6dRtTOjEbsCVpQTo0jermpZi7UeiMK99
 7ilr4sS77J1LYLv8TiNUGt+e+Hry567so9i+YHtsOrQkkTur5+BGfrUWuvQm+K/NKZtK
 oVZHuJAJ0RDrgWJmy3BrgpA8QDGH2BDuiVxLHlN9aC4Q8ELT0SiANLuUYYUVlLd7VY3H
 zbHsyWHD+P+8kFPGvS2/JTx/XfrkeGeTw8OEfB90xbTYNe/SuvNVRIUMEKdUskhVKI2U 9Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk3007w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:06:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23N0v3MP030980;
        Sat, 23 Apr 2022 01:06:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm8btsb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Apr 2022 01:06:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lH8x9VgFHXpTRE/yu1ogyHir9Uh44jl2qV64ul3PLIkI5G7W/euWA1lByAxvArkpX4Lt9mM0129i9H20Jf1mA5/02ocs7XmVEuBcLrGpkHQQKrGIga7S5H5/vMOEybzboEVqteV3vPpVyV3vqgE7Is5A+7yy7T8YqQFs69THgEn8zze2aN1EoiHVrc+AH1IIgWbc4Jx7+c9OjMBdwpQtb3/lXe/7dvTq6kQgBt232j228Hy4Icb4rtwFmkhXPHDdp1GUL1ZHX6G+ab0CB8pF1B1+GqCTesA6YP8RmMugUVLBz50hjKao9mHkLFeJE3+LeGKFy1StpfsAASEOtVpj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PorJbU+wMlGa5Cd+f3WI2cEAWzVU9+bXPmRrv9nzMHQ=;
 b=V23E4UbhKOKg4za8w7UWf5YBbFJTCIGuxtxAfgcquGd6V1zB8cqIwf/IFylHsg/1eTLXG3nbSie5/kilrodX+SbJOV5h8hMTVOJdq7v6FYWuWVNYy/a1odo1sPPejxdyUXT9qi/2Qu2zWyGCQ2Gf9EiBgLptSFTGknZqLTIxXRImTvq5FfmvgISPHZiwyj5QjVzWMpTs+9GYAHoffA0nQ/12yycnkdUXjyvLOk132FWJHHbJ1oEvDR0wzTGc3G3fzW6dgIa291Agu/UuzcvNAUOBlJr5xkNA3owsNok3Dx7Gj3Ifmxm8mPOevAXW1FHi3uvFIG/TtGQQWmPhhw8J5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PorJbU+wMlGa5Cd+f3WI2cEAWzVU9+bXPmRrv9nzMHQ=;
 b=R/DPj436O7jFRAE4thASBYCPQ9fXkASO+XCN1wVVI/wUGEY6fzSovTPL8MTRGjf7pFuyg3tG6iQeoS4umRbQ0xH4Mub4sCZhKLKBoJa0hJ5ngDRYoZQeuZ9Ddzzcz+KSP/Wesv7LcA6T4QpIjm5NBx5dQIS6BfHnL95tPdTdbUs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MWHPR10MB1949.namprd10.prod.outlook.com (2603:10b6:300:10c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 23 Apr
 2022 01:06:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.018; Sat, 23 Apr 2022
 01:06:39 +0000
Message-ID: <4a536bea577f3f49ddfce4bbe7a0d90290ab99a3.camel@oracle.com>
Subject: Re: [PATCH 08/16] xfs: XFS_DAS_LEAF_REPLACE state only needed if
 !LARP
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 22 Apr 2022 18:06:38 -0700
In-Reply-To: <20220414094434.2508781-9-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-9-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d214127d-e7b5-4a37-edd5-08da24c58597
X-MS-TrafficTypeDiagnostic: MWHPR10MB1949:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1949878066357DCE9401012095F69@MWHPR10MB1949.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UkllHBrDmxQl79tJbo6MISFhmdYlYxmTJJIN+RGlq/rsPaRkE2BOdCpasvNhCKWNXGlZTLTgvP90nr1D8xXvPJG7uLeXu6U8+CYFzFTrcUKq42zu9xCHZLHS2PqBh+WAUuVt/DeLIqG0LQBFlILSeDFD0LnFPLcLZ30h/KWUthnpNNIuc/LsAqZ8gx3hwoTE/Grz4ei8iNyOn2xaOl/DwpUTLZbZtwEMTw2VmcGpDBLO+zLNHVgq9s9rwmaRPrJSbQuDk8JX4kFiOS2Vdw69HrkvGiYCqz7qONE2WT8xrPrbx3mA593apNF66F0xJC1RMLSVyAqPOZkeJotstxfoNKBmsnMN3zH5i5/EkPsXsiqc5A4XQjbzw1+UMDboU7si9PzW7dTnxdPQBRRPDseebmg1/fthky2ppY+E6+MzjF9VQcb93WAwGdG6Vhj/YxP4f6OqmqsvHr6ZjknzWNJUbiA69cVYBhpsagm5q0PnRpWPMylx6gz/+E6bnfc5sH5JXOudzTJXD6YMcXXYVHB+wRtYVlnY/1qI0humEYNetjnAYl32W9Z2NN8crw8KUY3O14z33rKKciZSxIjd81sYJ+WJ9T2U5lo+7JJP/v/n1pf3uV8JN2c10NkLyMuPvaa3NK8+FiyQgDI4g3qZ2BW9aLCxCsihH4J785CPHckLdtluMfAi4O+IBf+xLSeVhipHulHf+ZiGFssozRiTnCdqCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(6512007)(2906002)(8936002)(26005)(316002)(8676002)(66476007)(66556008)(66946007)(38350700002)(86362001)(38100700002)(5660300002)(2616005)(6506007)(186003)(508600001)(6486002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTZXMnliRXJFSzhBNlh4M2t4d1JBU1JkTlQ0VXFKcng1ZnV5bjVSdm1kVnZV?=
 =?utf-8?B?UGl4ZlloTjA1QlFCNlhxSUNlbDBjdlg0bzVKZzd0V1hPUm1idVZ4VXJDVG9t?=
 =?utf-8?B?MnFBdThCcWk0cWMzRjNGNThmbGNvbldkMXZqb2xGZWdjSUg3NDR1b3NFcTJt?=
 =?utf-8?B?NkNlSGFtTXQzOTFDNHFWcUQ3VWFMRFNYZjQ1NjBDaUluVHAvd09GRnZpbUJB?=
 =?utf-8?B?OTkvUlNLVzNiN3hWY1orTVVLTU5kejdWM1FjZUF6bjRhWXVGMmlkYzMzUVNt?=
 =?utf-8?B?dGhlMkVSZXlWZmVyTlkxeXFvN29xZ3VVTkFIZ3IxRUFjVFZ5QjJxSnJ0YWV1?=
 =?utf-8?B?bUlkQzlwU0w5UGpVdXJkZHRYUDhPKzNMS0tDYmFRVWN2RUFDTFlGWXI3S1c3?=
 =?utf-8?B?UVFFanpZTVhNMHZ2UjZJRW1TVEdoSjN4eWtRaStydG8wQitadnBYcXNLY1FO?=
 =?utf-8?B?YllZRFJnanFpbnlJWXVMUlBvZjZpUmdPbTdNQzhKd2FBNkdGeGJsSTRNRVRa?=
 =?utf-8?B?NHAvem55akNlSVlkcFdyWkhjYnhHeXpVVTUrTVNGcGovUERvVS9xUUFBVkRK?=
 =?utf-8?B?S0JkM0JGNVBmWHB6QUhHek9hSXVnU2Y0cE10aEVOdHoxZWNVeVZFN1ByYkpq?=
 =?utf-8?B?U3U1THZwYWFDbjViVC9vcnZMdklnbTh0ZEE0MG5nN0sva1ZpZ2Q5Y25tUGFj?=
 =?utf-8?B?VmZWTTRNZzBqMSszY3g1RElDekMySWxyaEQ2amhLb051Y3FkMmxlanM4WmRk?=
 =?utf-8?B?WDFnQWZLd2Zqei8vUEpYMUs2WmdFdG9qSTZiaGJEdldSaUVqUVFndjEwcVlr?=
 =?utf-8?B?aWkvM3lOYldjaEM1cnA2bW9ZejlaVXNsQVhqam9QK3d6dDRwZTgyOWRYMCtS?=
 =?utf-8?B?UzMwVVY4ZE1Vd1krZ09BUnpjcThZamNFNzY1WnRMdkdOdnl6UTBSc1dIMmtM?=
 =?utf-8?B?Rk5KZVhRdTl6Y1VRS1Z4U1RXVDdMQ1Nzc0luU2dhV2FxVjhUSlhjVTJyTzhs?=
 =?utf-8?B?TGRtazlzWU5HUE0vc0I0MmJzSTNpNEdQOWZ4UVRzUXpSTm9WQlVQUGlNZFFw?=
 =?utf-8?B?SGlud0xlTVNhQkZLbVNqejlNZGMrU1U3TG8zdTlaOEpzZzFHYVB4SUNPcnoz?=
 =?utf-8?B?bmhpa2JTR0NMUXR4UjdNakpLZXBYS3JIenFMaDJyaGdZZGkxakxJZlJEb2Ra?=
 =?utf-8?B?WmRmZzdCMUkweTl2enNKYUtxWFg5Wk41N1dxbUpjdS9TTGQ2c3hNRVFVRU9t?=
 =?utf-8?B?YUQwV05xT24yNWtqTjFiM3BZSmtkRFZKR0VLZm9WRzhyejlpNW9iU2llSERQ?=
 =?utf-8?B?SjVFY1ZSR00xUW9MWnBLa2VqcVA0UC9oM2xHLzRmMmZvWWdtQVk4eUtaNytw?=
 =?utf-8?B?dlliTXNiNHBxUTZIQ0JscVhnTzZFMFE3UEVVWkxTWGgrQzJTYitaVHl5WWRl?=
 =?utf-8?B?bUxFYWRuNFJMNWc3TzE5akhvaStqTUVMdEJlTXV4dGhQN1V5WnJNTWhpUU4w?=
 =?utf-8?B?TlcwMVpSSnRKYzdhSzZGRHorZ1RsMklZcmJ1OHBOV1NhL0M1N08zRHpBVHdL?=
 =?utf-8?B?RVV5VnVNOGhnVkUyTUtPVWVrRW5RdnJlRWhpODJCVlIwUnJiQ2VnRUcyaUx4?=
 =?utf-8?B?SEFBb3pxMG9FRkM5V3A4WnZxT1Zia2k2aVRxNkl4amJKWFZOQnltdjJ6UEZj?=
 =?utf-8?B?cXlxNUpUcGZlSDFVVnNwNko4VkFhNXZuTGp0bTAvUExUelk3T2h5RXkvQWYv?=
 =?utf-8?B?WWlJWlpNU2M5Tjc3Q1RNakhmWDRKNFBMSlNvU3c0RGtOSUpsVUZnaWRBZnJ1?=
 =?utf-8?B?TUZMZUhReFJHWFMvZWdlMlh4MHYzUDJJU05QVVFiZllUOGRLNWdPaTg0K1Ix?=
 =?utf-8?B?aVUzTkUzWFllaEk0WEtueFI3b1FSa003dWJJekg3Y01NZHZ3c2xQSHlhYWcx?=
 =?utf-8?B?UmluSGF3SEtDTjF5ZzV0UXd5ZW9RTE9DcmFXZ0xLU1FCL2pSQURMNHVxdmtN?=
 =?utf-8?B?UnUvZkN1KzBIMVIzNWI4ZkpjZ0tHUWtBQnlCeXNKUWxray9SY3ExU2RZM0VG?=
 =?utf-8?B?aGZoWGcyc0J5eHZnVnhWRnQ0NlExZmxqZlBZYWkxRUxydXM4amV3MTArNWVZ?=
 =?utf-8?B?d1U4WVd0RmNzWTBvOXMwRUU3MkxwN1NlWm1BeFZQMWFuMWh2UE94TVJ0YzJH?=
 =?utf-8?B?ZWgvaU4yNHNnN2NDRkRCd3B1eDcxSHZqcVppRHptbGoydS9NZWw3MUZXZ2Vh?=
 =?utf-8?B?S3ZHa2lnRzJOM2ROVG5xNWdJdHhwYnRMeFlURHB6Uk1aWnRJN1BWT2hSYU5i?=
 =?utf-8?B?dmg0eGhFZkpCR3R4Y0k1Q3llTnBDSE9STVpSZlc3ck8wWWY2Q3h5TFdsbEwy?=
 =?utf-8?Q?Kuljq/Pceqrh5pZI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d214127d-e7b5-4a37-edd5-08da24c58597
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2022 01:06:39.5779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6STHLVZIdfDjo/bPfTeKTTnSGQUDz0aJALA7/jwlT4ru3z+rB3GfpgIPw96xOyJOHOCvsigtlKpqrTt4NbI+Mib0KnxuxUa4IpZHaqWvjZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1949
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-22_07:2022-04-22,2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204230002
X-Proofpoint-GUID: PJKyN_y61dZBKCN3zcHwGQW7i8wnAygl
X-Proofpoint-ORIG-GUID: PJKyN_y61dZBKCN3zcHwGQW7i8wnAygl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We can skip the REPLACE state when LARP is enabled, but that means
> the XFS_DAS_FLIP_LFLAG state is now poorly named - it indicates
> something that has been done rather than what the state is going to
> do. Rename it to "REMOVE_OLD" to indicate that we are now going to
> perform removal of the old attr.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++----------
> ----
>  fs/xfs/libxfs/xfs_attr.h | 44 +++++++++++-----------
>  fs/xfs/xfs_trace.h       |  4 +-
>  3 files changed, 75 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4b9c107fe5de..c72f98794bb3 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -309,6 +309,23 @@ xfs_attr_sf_addname(
>  	return error;
>  }
>  
> +/*
> + * When we bump the state to REPLACE, we may actually need to skip
> over the
> + * state. When LARP mode is enabled, we don't need to run the atomic
> flags flip,
> + * so we skip straight over the REPLACE state and go on to
> REMOVE_OLD.
> + */
> +static void
> +xfs_attr_dela_state_set_replace(
> +	struct xfs_attr_item	*attr,
> +	enum xfs_delattr_state	replace)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +
	ASSERT(replace == XFS_DAS_LEAF_REPLACE ||
	       replace == XFS_DAS_NODE_REPLACE)
?

> +	attr->xattri_dela_state = replace;
> +	if (xfs_has_larp(args->dp->i_mount))
> +		attr->xattri_dela_state++;
> +}
> +
>  static int
>  xfs_attr_leaf_addname(
>  	struct xfs_attr_item	*attr)
> @@ -351,7 +368,7 @@ xfs_attr_leaf_addname(
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
>  		error = -EAGAIN;
>  	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> -		attr->xattri_dela_state = XFS_DAS_LEAF_REPLACE;
> +		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_LEAF_REPLACE);
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -382,7 +399,7 @@ xfs_attr_node_addname(
>  		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
>  		error = -EAGAIN;
>  	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> -		attr->xattri_dela_state = XFS_DAS_NODE_REPLACE;
> +		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_NODE_REPLACE);
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -421,6 +438,13 @@ xfs_attr_rmtval_alloc(
>  	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  		error = xfs_attr3_leaf_clearflag(args);
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> +	} else {
> +		/*
> +		 * We are running a REPLACE operation, so we need to
> bump the
> +		 * state to the step in that operation.
> +		 */
> +		attr->xattri_dela_state++;
> +		xfs_attr_dela_state_set_replace(attr, attr-
> >xattri_dela_state);
>  	}
>  out:
>  	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
> @@ -442,7 +466,6 @@ xfs_attr_set_iter(
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_buf			*bp = NULL;
>  	int				forkoff, error = 0;
> -	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
>  next_state:
> @@ -470,39 +493,39 @@ xfs_attr_set_iter(
>  		error = xfs_attr_rmtval_alloc(attr);
>  		if (error)
>  			return error;
> +		/*
> +		 * If there is still more to allocate we need to roll
> the
> +		 * transaction so we have a full transaction
> reservation for
> +		 * the next allocation.
> +		 */
> +		if (attr->xattri_blkcnt > 0)
> +			break;
Hmm, if attr->xattri_blkcnt > 0, then xfs_attr_rmtval_alloc returned
-EAGAIN, and we would have bailed out by now, so I dont think this part
ever gets executed.  Though I guess it doesnt hurt anything either?
 Rest looks ok though.

Allison
>  		if (attr->xattri_dela_state == XFS_DAS_DONE)
>  			break;
> -		attr->xattri_dela_state++;
> -		fallthrough;
> +
> +		goto next_state;
>  
>  	case XFS_DAS_LEAF_REPLACE:
>  	case XFS_DAS_NODE_REPLACE:
>  		/*
> -		 * If this is an atomic rename operation, we must
> "flip" the
> -		 * incomplete flags on the "new" and "old"
> attribute/value pairs
> -		 * so that one disappears and one appears
> atomically.  Then we
> -		 * must remove the "old" attribute/value pair.
> -		 *
> -		 * In a separate transaction, set the incomplete flag
> on the
> -		 * "old" attr and clear the incomplete flag on the
> "new" attr.
> +		 * We must "flip" the incomplete flags on the "new" and
> "old"
> +		 * attribute/value pairs so that one disappears and one
> appears
> +		 * atomically.  Then we must remove the "old"
> attribute/value
> +		 * pair.
>  		 */
> -		if (!xfs_has_larp(mp)) {
> -			error = xfs_attr3_leaf_flipflags(args);
> -			if (error)
> -				return error;
> -			/*
> -			 * Commit the flag value change and start the
> next trans
> -			 * in series at FLIP_FLAG.
> -			 */
> -			error = -EAGAIN;
> -			attr->xattri_dela_state++;
> -			break;
> -		}
> -
> +		error = xfs_attr3_leaf_flipflags(args);
> +		if (error)
> +			return error;
> +		/*
> +		 * Commit the flag value change and start the next
> trans
> +		 * in series at REMOVE_OLD.
> +		 */
> +		error = -EAGAIN;
>  		attr->xattri_dela_state++;
> -		fallthrough;
> -	case XFS_DAS_FLIP_LFLAG:
> -	case XFS_DAS_FLIP_NFLAG:
> +		break;
> +
> +	case XFS_DAS_LEAF_REMOVE_OLD:
> +	case XFS_DAS_NODE_REMOVE_OLD:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> a
>  		 * "remote" value (if it exists).
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 1de6c06b7f19..a4ff0a2305d6 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -455,7 +455,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a
> leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a
> leaf */
> -	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE
> attr flag */
> +	XFS_DAS_LEAF_REMOVE_OLD,	/* Start removing old attr from leaf
> */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks
> */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
>  
> @@ -463,7 +463,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a
> node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a
> node */
> -	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE
> attr flag */
> +	XFS_DAS_NODE_REMOVE_OLD,	/* Start removing old attr from node
> */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks
> */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
>  
> @@ -471,26 +471,26 @@ enum xfs_delattr_state {
>  };
>  
>  #define XFS_DAS_STRINGS	\
> -	{ XFS_DAS_UNINIT,	"XFS_DAS_UNINIT" }, \
> -	{ XFS_DAS_SF_ADD,	"XFS_DAS_SF_ADD" }, \
> -	{ XFS_DAS_LEAF_ADD,	"XFS_DAS_LEAF_ADD" }, \
> -	{ XFS_DAS_NODE_ADD,	"XFS_DAS_NODE_ADD" }, \
> -	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
> -	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
> -	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
> -	{ XFS_DAS_LEAF_SET_RMT,	"XFS_DAS_LEAF_SET_RMT" }, \
> -	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
> -	{ XFS_DAS_LEAF_REPLACE,	"XFS_DAS_LEAF_REPLACE" }, \
> -	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
> -	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
> -	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> -	{ XFS_DAS_NODE_SET_RMT,	"XFS_DAS_NODE_SET_RMT" }, \
> -	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
> -	{ XFS_DAS_NODE_REPLACE,	"XFS_DAS_NODE_REPLACE" },  \
> -	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
> -	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
> -	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> -	{ XFS_DAS_DONE,		"XFS_DAS_DONE" }
> +	{ XFS_DAS_UNINIT,		"XFS_DAS_UNINIT" }, \
> +	{ XFS_DAS_SF_ADD,		"XFS_DAS_SF_ADD" }, \
> +	{ XFS_DAS_LEAF_ADD,		"XFS_DAS_LEAF_ADD" }, \
> +	{ XFS_DAS_NODE_ADD,		"XFS_DAS_NODE_ADD" }, \
> +	{ XFS_DAS_RMTBLK,		"XFS_DAS_RMTBLK" }, \
> +	{ XFS_DAS_RM_NAME,		"XFS_DAS_RM_NAME" }, \
> +	{ XFS_DAS_RM_SHRINK,		"XFS_DAS_RM_SHRINK" }, \
> +	{ XFS_DAS_LEAF_SET_RMT,		"XFS_DAS_LEAF_SET_RMT" }, \
> +	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
> +	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
> +	{ XFS_DAS_LEAF_REMOVE_OLD,	"XFS_DAS_LEAF_REMOVE_OLD" },
> \
> +	{ XFS_DAS_RM_LBLK,		"XFS_DAS_RM_LBLK" }, \
> +	{ XFS_DAS_RD_LEAF,		"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_NODE_SET_RMT,		"XFS_DAS_NODE_SET_RMT" }, \
> +	{ XFS_DAS_NODE_ALLOC_RMT,	"XFS_DAS_NODE_ALLOC_RMT" },  \
> +	{ XFS_DAS_NODE_REPLACE,		"XFS_DAS_NODE_REPLACE" },  \
> +	{ XFS_DAS_NODE_REMOVE_OLD,	"XFS_DAS_NODE_REMOVE_OLD" },
> \
> +	{ XFS_DAS_RM_NBLK,		"XFS_DAS_RM_NBLK" }, \
> +	{ XFS_DAS_CLR_FLAG,		"XFS_DAS_CLR_FLAG" }, \
> +	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
>  
>  /*
>   * Defines for xfs_attr_item.xattri_flags
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index cf99efc5ba5a..a4b99c7f8ef0 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4108,13 +4108,13 @@ TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
> -TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
> -TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
>  

