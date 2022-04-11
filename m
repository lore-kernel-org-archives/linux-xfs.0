Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCC2C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 10:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345595AbiDKKgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345593AbiDKKf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 06:35:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F22D43AE6
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 03:33:44 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B8VMuN001710;
        Mon, 11 Apr 2022 10:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=d6y+Z6kLhhPDez/A0n/MBOzvyFQEPfQr1ehvmcFvCDQ=;
 b=RXoFRory0ud8pnK9agPhekj0NtXM4O+BQlnl1R/xfwH8b7c2nbjYjzXAaHaz9gjIwhWx
 FF5DJywqZ9jlrc7mbjjZWGHstdh7OktgwCgxJULIZfVGvcpAvdVb5aEXVUkKtXzEVU0N
 sGEtezDNen1vfto4de5q0ey+MfquC2ik+hC6htEbpXPWQ/pgBG4ZTcfLhLf9rpSQClH0
 7VxRysTNf9eHSwYrt5hXPhQVJ8nwXYKk2uJTPgcNfPm8DkC3ytXLie5NfYpNouwD4TXi
 xyC9fuVJdi/EQhe49i1ptbCDkpiHlWZvnOWv14GLaJPjrFyuUTqXlTXo0BixEY/j833H jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2b85a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:33:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BAV7iL008850;
        Mon, 11 Apr 2022 10:33:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1akvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiG/LjL1SZtU4H43r+nwCjLQP6tMngbN9jIoyTVY789S+Srw2vkQ5NcuzBYr8vlQIKpVYrwzdBreqieeUwtnFfUjc9toAbPIifbALPqTTADBDeHPIgkN3TTbSkxJVoRbgUy0UB33BZKPUsygtO6kq0PHyu/kpyEgerZLFGSWAUL19iyS1q/cBtVtBh3EqSokNLDjBuCEGzzCE72aqRM3X0uA5ozWofGvaDcV2Ue+MYw2R5fLkdFTN/RXS5CTLMksPSwth18faRptLMxOfTDl5SGLw9r6b3rzSZzvD5zT3BGWkibA3Q/D2W77gJqe6/vojCk1tNMU3TmC7grvU5jCaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6y+Z6kLhhPDez/A0n/MBOzvyFQEPfQr1ehvmcFvCDQ=;
 b=n81+2Q/i0Ruris6tSizDl3rQ/iTyFfs36UFTIrcDn6is+uRJQC4zulfZOQneKQvYUJJXbFSgC0Q90I/BTgFbOtTMM8F1kjbfYEpPHDBNm0ebB5q8feNAGZNANNMXHEgCsmsvif4R92t5iCzG0M3tascpbVkuVyUwLbM80Dh6yuQOV43h4sJYMzzmDPNzGVLF9VKpo811pUyg+S7TPGrrXXmVc+5iOEkf+eDctFlRy8+p0Sa+i5fQAGUNrd1xxM/OPdxU6kkp0CB9oepwnt5TJtcBBxebq7BQQygT/300O7IxYDbvfoSYOZVALmHiZ0bb3toHqygWhvrnIntte1CUfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6y+Z6kLhhPDez/A0n/MBOzvyFQEPfQr1ehvmcFvCDQ=;
 b=ufl8AL/95X+3UgUaHCaGCXKfB2Rdu+1k4e0TzKfyimJBl0hhyCiX05uYhnJKpYlsGTMhE/z4V/sUQSYl3Hc+y5ZJlAMSnlxooOj5S/67yze1AYbM0dZ0gy743MlU8sC0VBpQaz6H+lv0nlksNQh54yvezfyzshIvAeuLs9ATGa0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2798.namprd10.prod.outlook.com (2603:10b6:805:d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 10:33:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 10:33:41 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-4-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] xfs: convert scrub type flags to unsigned.
In-reply-to: <20220411003147.2104423-4-david@fromorbit.com>
Message-ID: <87o817vri9.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 16:03:34 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 665c3210-f18c-40c4-616c-08da1ba6bed5
X-MS-TrafficTypeDiagnostic: SN6PR10MB2798:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2798E4AC5A4A3EA588D4A5D5F6EA9@SN6PR10MB2798.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZ2OJP8loZA9t1n6lGxYKdio+qw8czdBGJc2n1rWRkwdKUjuRar4ul7Jd5N1okzq03qv+wD44+s1nFCOzHLiUShhL0LA+Ega79MdEuGBmJl6hhtqT5z9D0ZGNlQdKTBey9ujPVRKtDiSnvd7Q8pyQs90e0E8v1OxT+MdEBTeEeash3942N2XDhvXuiYad8Cluyoww0QXgL35pDfe0BfhUszt7ZOGFFcAtxSs6gpR4xv5Z5dUo5Pbol5LUlAH711G25XC6AMqp+ZTXSsNsPEh5sWbK0PtZ6LakmARs11Epk54FweplJm4hJ+5sZnx4m3lTLOod1FBNbRdXTpMBjrm/oDbFExv0xkqOnLYPvaBfWGc4pfI2ZNZIVfYHyLX2jJ1Qkq4zgjVVs7Bt79tya5mOTyGgrsAtwS6/x9TDuvpeGq94ZRn6yCc6wXZ2Up2idTqrBveLuCUzVnfoz+unwA33r+YKFOfFjjwzkuvgvjtW6B8l3p8ZStke5pBqXJH1Hzb3r7YC6f3LO/w6qSnOGPlqDOpB9/hzGVLmlJfuL/P9o9uI5rdAwd+KSabhcTXOXO/4m43L9ZkZBq/4MpFUGKz/+eCUaTUrNLtugCRwwucFTZdjG1Oi+T6KDhCNZdWv2rPM9ZAOHvGBHbmQNPhWWd8l324nlql31D6mVF/s0RSyUeHjX3Ip1k8xgFcCryNKgBMM4MzyNIP9WrgJAKTzBlkRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(33716001)(508600001)(6486002)(86362001)(186003)(38350700002)(316002)(38100700002)(26005)(5660300002)(6666004)(83380400001)(6512007)(6916009)(9686003)(2906002)(8676002)(66556008)(4326008)(66476007)(66946007)(6506007)(53546011)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MHoABmf9vhZUs6bcfu0WB5EMGehWXwiqy5aRqrzAO1PnKYixSsNnQrpGLGvt?=
 =?us-ascii?Q?WLRUjqUH1BUM296hlx3d2pIMtEzqveqlUwVYgK645gUksFNTeoZsATDRAJEx?=
 =?us-ascii?Q?6PqgZqt6p0DVHmw8yJQN9tzCIinESw3OBycptsC4sjUDJkrCNfuuWqjXKt5k?=
 =?us-ascii?Q?PObNHH9nxkbiVQoMvj0Pn1SmAQRS/LGkTK02OZm6NcV42r4cIxX+VWlyDQbi?=
 =?us-ascii?Q?vklDwBvsAxygH+RudH2okyjBQ8K6hqYdLkgbK2kZIYBMj3LcWzagPsORkDDS?=
 =?us-ascii?Q?T0ZcHhPTlnQj096n3LIV1YZCrwcJ0cpguFwEUmPuwhvX6xE1dKCx4VOqvFeB?=
 =?us-ascii?Q?0uC3SUqBNNfNlbdW9YTmbBc+AMGF7OmExr5TUe3bHMAvPGAmrfFVH/cMlRpe?=
 =?us-ascii?Q?MCCccFxI0vQYzPhdfNW5JYh97uq4xGcQCSbMuyUv9I5RMeVM0eiq+yjBNLst?=
 =?us-ascii?Q?r29tN7LDkOdjvwmogNpo+h/YXxonD0JgutDZbMqhKl5V3N8RhhxybstDZ42c?=
 =?us-ascii?Q?RYDblm9RTF7DG/VvHtmWA9tFfcDbctOdsEeX9Z3CwMqJN5Xox4HWF0fqU+bP?=
 =?us-ascii?Q?5u6V34yicYMme/1V1sdr4yXMYHJrhc5r47aNWaqCMZVbvzww25JnJHiAo3iH?=
 =?us-ascii?Q?k7VMPhIqwKoftIk+kHbcs/MKzAPHugfx/PZ+4Nk+qFqcBRuvToB7gWNGXT32?=
 =?us-ascii?Q?ubk0U6WPOjJS08S/k1SaQYdfyLFeEHAj9yaHQw2cej2OAVOtJW3Dzad2Sh6p?=
 =?us-ascii?Q?QD/oGyhj7Mo8fM04foaw6WrwxFPodzIuaSzLbmOFSISQE8Ybje3UlthJ1U0Z?=
 =?us-ascii?Q?9Qjq4o5hlBD6UJnjmkd8Hkt+fitRxXHE9NsZJ2jc4PmLUbnxqqbMZrGjkPRP?=
 =?us-ascii?Q?koCzFDm0w2GMasQGmTk7NvtCImLqYVTyKUS+he87eu2Ex5lf6rqGIJ95ZIWZ?=
 =?us-ascii?Q?wWknu4CSWK2LzvAOLUG6zUHkqwBHcyBIi+kR+qeEd2ObMODqQXxDYwIEXqUP?=
 =?us-ascii?Q?mWkf1Nz++t3jvmj9iERG7AF6uFOnL2lajovYVnmnliI89BtbgKev1/PH62dJ?=
 =?us-ascii?Q?xKZMf2PEEdw2p6PGmy1AD8r0VsmLxiNB7fFhctIg/+pwzu7jn38hgbJ8+otg?=
 =?us-ascii?Q?5gajZEhptWFhMOKa93nzA5Jb7otNN/b2lMX8/rLF+DW4f6uOJsdin76bzQ8s?=
 =?us-ascii?Q?yYnBQfQ2IwVYnFz0TwFdI0N3I7BM0WIM3NT0nVmzIb3PhQV9nMQa+XEKf5bF?=
 =?us-ascii?Q?4DxltGU1GvGuk0Ptuidqcved+VAnpgUXUx1DHAtudl1yeKJ4e3OWrgfll8/0?=
 =?us-ascii?Q?2bgh/Oc1J7PGz5xSEB2CLIo3wJwtAw0CzMmbgntpBUxTfqj0ukm/Y0TjfukH?=
 =?us-ascii?Q?9N5V9atsh7YSc3NNKBANiEjCZES/Y9GuFr8N089ATrNGRWMHthGyjWYd2pcZ?=
 =?us-ascii?Q?Rowj+kIt+A8yfYg/lJozNdj13Wqm9FnocLZlXssr1cefmLyInIsVcy0+V0V7?=
 =?us-ascii?Q?/4pzgCISJHikiP/wg87vq/Il05ebHcOdx957fZWbFBj2mVCyxj9g17zvGfQZ?=
 =?us-ascii?Q?lrJWKAmTX6GiRCQqzSR01mCbERwg6Xq7aL8rIpm75NW8+z8ADZDUhYvdsWG7?=
 =?us-ascii?Q?iOiIVCMpeBIKy/bDEQ/f7R22LK8Qq9yDB906fl1T+eGF/amX5oEvNpuFUu8f?=
 =?us-ascii?Q?+87BNCrmT05w9FsYePsD+r56wKAHMdbfRZRycvAF3ppsXr9+C2P+db5LJLhi?=
 =?us-ascii?Q?55EhwqU0U3qc42GsbweGjjN9oasnao8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665c3210-f18c-40c4-616c-08da1ba6bed5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 10:33:40.9348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3SGfogtgZYHZc5MuLRxgiwkQnCfDZtFzFjgm0AJnBPHv3bHLfoVVa7ZeJt6NwnW5GX7qBmcoeP5F6iFyxtuvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2798
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_03:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110059
X-Proofpoint-ORIG-GUID: mnQfyvAz3vYTDmkZI52dQAfuqGP3QdgN
X-Proofpoint-GUID: mnQfyvAz3vYTDmkZI52dQAfuqGP3QdgN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>
> This touches xfs_fs.h so affects the user API, but the user API
> fields are also unsigned so the flags should really be unsigned,
> too.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 505533c43a92..52c9d8676fa3 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -699,34 +699,34 @@ struct xfs_scrub_metadata {
>  #define XFS_SCRUB_TYPE_NR	25
>  
>  /* i: Repair this metadata. */
> -#define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
> +#define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
>  
>  /* o: Metadata object needs repair. */
> -#define XFS_SCRUB_OFLAG_CORRUPT		(1 << 1)
> +#define XFS_SCRUB_OFLAG_CORRUPT		(1u << 1)
>  
>  /*
>   * o: Metadata object could be optimized.  It's not corrupt, but
>   *    we could improve on it somehow.
>   */
> -#define XFS_SCRUB_OFLAG_PREEN		(1 << 2)
> +#define XFS_SCRUB_OFLAG_PREEN		(1u << 2)
>  
>  /* o: Cross-referencing failed. */
> -#define XFS_SCRUB_OFLAG_XFAIL		(1 << 3)
> +#define XFS_SCRUB_OFLAG_XFAIL		(1u << 3)
>  
>  /* o: Metadata object disagrees with cross-referenced metadata. */
> -#define XFS_SCRUB_OFLAG_XCORRUPT	(1 << 4)
> +#define XFS_SCRUB_OFLAG_XCORRUPT	(1u << 4)
>  
>  /* o: Scan was not complete. */
> -#define XFS_SCRUB_OFLAG_INCOMPLETE	(1 << 5)
> +#define XFS_SCRUB_OFLAG_INCOMPLETE	(1u << 5)
>  
>  /* o: Metadata object looked funny but isn't corrupt. */
> -#define XFS_SCRUB_OFLAG_WARNING		(1 << 6)
> +#define XFS_SCRUB_OFLAG_WARNING		(1u << 6)
>  
>  /*
>   * o: IFLAG_REPAIR was set but metadata object did not need fixing or
>   *    optimization and has therefore not been altered.
>   */
> -#define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1 << 7)
> +#define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
>  
>  #define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
>  #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \


-- 
chandan
