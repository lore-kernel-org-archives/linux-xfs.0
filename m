Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140A9C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 18:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiEQSWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 14:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352067AbiEQSW0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 14:22:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E74531344
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 11:22:24 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HHTCHE031717;
        Tue, 17 May 2022 18:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OAyJ71sQ53zmbTAKdUpKg9I2W4rlJbbnEjaidYPTL2U=;
 b=JngAyTvAVT3H4+GuE/AiAt83EOsRwTzuGIlEjQkx/UgD6EqBoNH8c+vMETG+QnCq9BA2
 EEzbegJcfZ/DdqWYq3+o6mNRAXtVTl/oYboNYUXwaMY6iiTMWkw+Eniwq3AjkwYaD6eF
 Dzs6KFMReE1mHWSFCdmyyIKlEqqWBkadA+XBrG2WUeTNY98RaDxdmvvM6R61cgkwtktc
 nMWEc+smKEhbZEbPVGCs0J/N8JtW7ii53juXEAnM/aDLTr69miKHhOR6GfmLBmQyzv1l
 twJeZadewt0wEKlGb/X5VQQSehBghc0B2ednNXcmrStsNqtwU96Gl3dGN4qRTrs0aysE Fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aaf29a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:22:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HI604K036153;
        Tue, 17 May 2022 18:22:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3ce8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:22:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWcCR4tTTNIegaToHiQGksfZ8wgVvTPdopB5En/BxWueQgd+X9z9qVY4gruBWi1KppAqA0HPjDRioWQ+iH0xnX4WZ7LSYJWOYNLIZAQJltLC0dsWgIX9i7YmCyj8+bJMOSL/47i1gKjcTWocsTrZ5M+LiDo7wIOEywJt3wJ0fk54+GdCjK9l8TmXgeHUa05o61PtWVJJIgdEQ5PuaVVB6gw5ZQY7kPyB/mz3x5e/Ic97Wws/nIvdIpPgPv1HU9XNvaJlMgbRXV1gCZimnA+2h/9Dvur4TBsv3rrHZXp9BShHgt2zP9T24KyLx5/Xh787Ibu2u7ZBd9B/zocZJpzwCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAyJ71sQ53zmbTAKdUpKg9I2W4rlJbbnEjaidYPTL2U=;
 b=ii54kTmRAKE0DS9LARvdMWKM4DcUox/gSRHUnWZe2mrQOR5ovlnw+1ROIFYprjvDeXbS6tY1FfHmz8DmymDlbKP/cM+eXX8Evq0NpkGRna2rbP8QMkRd2NXDf0siDTQXP3YSaqRBbuN4aSjRTUqn7NMkTig5hDK/yWhU3iNVB3wX1EEM//u7YggrFCxgcGVEWDeHYruJUMQBwZ7rWWWEfheAeW3qm+7fDeC5ce3QHpR8BmsyFbX3W75qIGmUOzNvW8nuS4H+3VT66wcDQbab5IpvhfCwoS1HDa1TIECYjh4WlJgM8CrXkV6xRe2ZHPKRjly5mIUnXN01rRsQkk8gcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAyJ71sQ53zmbTAKdUpKg9I2W4rlJbbnEjaidYPTL2U=;
 b=AnHdjscQrHuQe8nxTBN45DSz7J+IUe5HrB9ydIU3i2n0K8A5gdalrbKeeT8/yK2gRwp1B4s3CkHYxlIwzqirzY30wtf1qIT1MPBTFhLKaCs3MXtJSWkGUDImqmNfqCOyXx3dbfJau4bLtnt9bXZIXPgYsjSBvJ8uWGxdRlHw7NU=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by MWHPR10MB1551.namprd10.prod.outlook.com (2603:10b6:300:27::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16; Tue, 17 May
 2022 18:22:15 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 18:22:15 +0000
Message-ID: <74889636c9ad1d4a781146571bac122bb06da225.camel@oracle.com>
Subject: Re: [PATCH 4/6] xfs: remove struct xfs_attr_item.xattri_flags
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 17 May 2022 11:22:13 -0700
In-Reply-To: <165267196090.626272.13190997050322531901.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
         <165267196090.626272.13190997050322531901.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0039.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::16) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 681239f0-cdd8-4a97-bfc8-08da38322b8a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1551:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1551F60B2AFAFF89A707A3A495CE9@MWHPR10MB1551.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p/il9QEeQum6P7quudB8uySUuSsCFP3u0APPtacU0SXlzesYr3FnjFXHJhzNdEoS4+4/VjXur8M4/GcMifn1QuDzDljxc+LD4zpa9GBMARs0o6w3Oc6oj2ux8sWY1uMeiVdeaHkA9xW8YavR1sS90MHqvkZnIu6GmtL7QnchPfUjuEE+GKkgeqKkFzvVlhizWfPoIaq+dRc2QbpO7GxAxgWiMTNwWkHDVy7mMf2Z6W/atlX8g5MggNZLl5+QYmjt16guFZPE01NbiPfx4xBgjgXpXVCTMSK7CBSULrVRat0P1L0qN4mfed/tJs+EAuG8ri6TUf3Bp4ud25tlERvC6vtk+FkKQJNZtQDP3ld0oAG15yD5ngvaR3M/8cESBKlwBvJ9309n2/kqpKcKWUL5+QijzFGSdDS01yGi2TqzY4sEFfgMblCgemuoKQ27bm9XXQvRhbSScRlH6Q6tZn99hhTdQZ3yK5VZE03xzBvoQElsfYbL+GRLc5uKrbpr9f8NElDGUggXUOXdCZUV76EDqcERyPF6dpKDKUg4AFnfmxzHOZbTATA4CIT/SnWFHsPB1eI1xyQ/6HbEBVZS07aQlnWrVGFcvOlKI9h9KVuV9vo4UebVcFmd+OrI9WyAaOa7+HsdVRTwiuTa3i7bIXnbrQ1jFkBMC29BQYNWVAFvbcjieTnzeHEI3DDgQdIIA3NiZmuA2o4S7gr63AIgmnaB6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(26005)(6512007)(2906002)(83380400001)(38100700002)(38350700002)(66946007)(8676002)(4326008)(66556008)(52116002)(66476007)(6486002)(86362001)(5660300002)(186003)(8936002)(36756003)(6916009)(508600001)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmQ1YTJYOWFnbHJHRkRTSE1uQWJ1b2RVZlh6R3NpR3RIZzRRbkhxdVg1SWI4?=
 =?utf-8?B?RUFMNHVDNzFvcUVtTVZjT1lRb0lrUWt4ZmhCWWhsMCtHakt2V2ZEUktIWFBk?=
 =?utf-8?B?TjAvU2wyTDNRS2JFN1l0QncxMk1yUFBmck1nRlV2OEZFWlhTQnRJaUUzbytG?=
 =?utf-8?B?MitJbC90RGwrSXNpa0I0TzE1b3d6QkxVRmV4ak9KbmRSTWpWcnYwTUZFZFg0?=
 =?utf-8?B?WHdYMlc3UDJENmh4TWFYcjJYNHc4OW1XakxDVFlNNVo5ME1TeDdXSWx4VUt0?=
 =?utf-8?B?dURHV1JqK3h5TVk4Y0dOTDE4VGJsOFZKVFAwUzlxM092a0RNeXZuSWw3dzNV?=
 =?utf-8?B?QmZ5bURiWDNicWROUFhNeGV2eFpnUUZKUy9hRnRIbFk2bklEM3pvYTB5Zy9a?=
 =?utf-8?B?SXVlM1M3ZXpUQlVUaWFhSXppTGRIMjZPNktzMXRHR1NFeHh5UmxsTitUS1I1?=
 =?utf-8?B?UWdGQ0NmRUsrMHdydnk0dGQ3R2ZhN21yWGQyelMwYm5iSVlNd3dpbUVaYzBI?=
 =?utf-8?B?OVNUN0Q1T0ZIeFdmc2VYenNOb01MaW9QN05kbE5OTUowKzJQWGtYbzBJWlF6?=
 =?utf-8?B?dS9jdTROdUhuV3Jwb2R0ZFdhNlVEZUxxWUMyTjNmdlE0YUJaZkdyaExGT0JX?=
 =?utf-8?B?VHlKVDJudFg4cWRERktZOVRBeHl1aHdHOVVVcllUUURYd1kwbWVsYTc2N0hT?=
 =?utf-8?B?VWgxWkttZ1c1WUNsMkxJMDIrZVVQeVpLdElQMm50TE9YcjRxZGFSNUFXNGxZ?=
 =?utf-8?B?Z1VkM1Bndy8wNkR0bmNPVkZQaWN3cXJHUmJoSnFwaXFyQjVaLysvNGhLWDlk?=
 =?utf-8?B?N0M0WjVJbXlyNCtTUTJaQzZwV0pTeHZUUjR3U1cwM3orZVJ0YW1NOUw2a25J?=
 =?utf-8?B?RFhaM0pXenFxRTFSYzhyU3JWZzRXK0pJYjhJWDBiRkNsWmZLZ1RycmMzMFkz?=
 =?utf-8?B?bit4SDhqQUhNaFlHTSs4OHg4czk0dERBUVo0bVJnSUtoOWcxY0NTeThOWTV4?=
 =?utf-8?B?K1owdWZNTnBabEpBWHVRa3A1Uk5DTWVmVWttS3NhVGNKK0cvTmNTMWdSYkdp?=
 =?utf-8?B?ZFBvRUdkVmd0Qi9QNCtFWUhCeWtWcFBtMHF6cFB6SzdWWkpSZ0t6bHJveUQx?=
 =?utf-8?B?UDF0K21OaE0zTFlRSFc2SG53ZWJqVUczT3B1M3U0YnV1NUVDaWJhVnVIckpJ?=
 =?utf-8?B?UUJIVUl6ZVdVRzVrTmg4dDhFUnRrWFJlRUUxUHE5TnczK3F2Z0RseGZ2TUJu?=
 =?utf-8?B?aFNEMHZRNURxQUl1ZUkvL3RWeXZreUsraE9iZGZGVFM2bnE4TUZaNjNPVEFj?=
 =?utf-8?B?ekMrbHlBMGt4NHdCcnByK0ZqMnlqVXovSmpZZEFwOXA3aU5sWHV1eTNDdHlN?=
 =?utf-8?B?L2VRWlByanhqcExqN1dudFN5N3dVaVlZQ0tNS0tKVFRvMGtuLzU1NDQzdFBm?=
 =?utf-8?B?OVRJdnViUnZDTlFvem9FRzIvL0lDTTk3VHp1dTRQZEt2YzkyRzBvTjZJQVVL?=
 =?utf-8?B?U25yMG1GeTd4SFBZS0phOXJKSzV4Z2RSUGt0RWp1cFNPOHV2UThKWlEyZm5C?=
 =?utf-8?B?Z0NwSTJ4K1ViS0hkNTdReCtKelorTU1abFF6NGNvb05aV1pCQTMreGJ6Y3FS?=
 =?utf-8?B?TFdRQ0U5QjJndW9HR1Zma1d6U1NTUG9nUElEN290aGhKY2cvNWxpYmFBUlFo?=
 =?utf-8?B?Rjg5QnNyaGFSek1QclEwQUpONmJiSmlsQ3pJRmxuMU9uN2JqSXRTUWdHY2x4?=
 =?utf-8?B?UmVOMHl1OTdReExoallWbERBaHdQU1k2NGFrRE13Z3Z5dXRpT3ZOLzJybjFl?=
 =?utf-8?B?YnlyV3IzMHZ4SEVIUHQrNkw1VWRLa00vMUhWQU5iUkhieHQyVHgwOVpVMldJ?=
 =?utf-8?B?Vkh4OVMxUFFOZ3BpTGJiTHJMbElURlJ5T2pLSkFtNC9uSFgyVU5USXdHellV?=
 =?utf-8?B?VE9jOG9uRlFjM0orbm5yaG5EZkxkMFZLbi92R1p1NjRrbFNsK0ZBb0FDRzFR?=
 =?utf-8?B?T3U4a3ZodEEvZ3A1aXZHZjdsQ0dmQTJZbWVrODYzZjd5Uy9teDlvN2V4Ti9B?=
 =?utf-8?B?TlJrcHR3RDZLSkZUUDBYQmwvd0xBUktOemUwOW1HY2FTMzhqdjBlRDRQc09y?=
 =?utf-8?B?eXpGY2ZmV3M2d0twaURqaEFVMTZaN081WnllZHNGSUR3Q3N4Y3gwTmIzT3lx?=
 =?utf-8?B?Qkp2dy8wMHpHUHNWZ3pIMFJqalZQNHM2bjNZL1dnd2hoZDFoOTVubmw3Nisw?=
 =?utf-8?B?VTZlVzZyaTNudVIwVmdxeUtlODZBYkhxMCtOQWcySlhPQ3FqQWdldHRGeDl1?=
 =?utf-8?B?Q3R0c0xlN0ZBbkcwdnF3ZzNRNHJQWnZhR0NTdkw4TjdYbGIwMFdpUE9rcXl5?=
 =?utf-8?Q?oVPMTGl6Jwjegivo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681239f0-cdd8-4a97-bfc8-08da38322b8a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 18:22:15.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RRlVETyicXCTyyqyeqAZYQNQHzLzUrRAOHDWz8Zc7Uyio1380zSiM200cd8tGfItBnq+DjaJiUOSmfDi0SjmqXBDmWiBtHobBBOZJ5Io4vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1551
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170107
X-Proofpoint-ORIG-GUID: 5ZtpzEZkLMB3QZPfzIzoqCfbIYsIO-zS
X-Proofpoint-GUID: 5ZtpzEZkLMB3QZPfzIzoqCfbIYsIO-zS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Nobody uses this field, so get rid of it and the unused flag
> definition.
> Rearrange the structure layout to reduce its size from 96 to 88
> bytes.
> This gets us from 42 to 46 objects per page.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h |   32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index cb3b3d270569..f0b93515c1e8 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -501,15 +501,19 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_NODE_REMOVE_ATTR,	"XFS_DAS_NODE_REMOVE_ATTR" },
> \
>  	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
>  
> -/*
> - * Defines for xfs_attr_item.xattri_flags
> - */
> -#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname
> init*/
> -
>  /*
>   * Context used for keeping track of delayed attribute operations
>   */
>  struct xfs_attr_item {
> +	/*
> +	 * used to log this item to an intent containing a list of
> attrs to
> +	 * commit later
> +	 */
> +	struct list_head		xattri_list;
> +
> +	/* Used in xfs_attr_node_removename to roll through removing
> blocks */
> +	struct xfs_da_state		*xattri_da_state;
> +
>  	struct xfs_da_args		*xattri_da_args;
>  
>  	/*
> @@ -517,16 +521,7 @@ struct xfs_attr_item {
>  	 */
>  	struct xfs_buf			*xattri_leaf_bp;
>  
> -	/* Used in xfs_attr_rmtval_set_blk to roll through allocating
> blocks */
> -	struct xfs_bmbt_irec		xattri_map;
> -	xfs_dablk_t			xattri_lblkno;
> -	int				xattri_blkcnt;
> -
> -	/* Used in xfs_attr_node_removename to roll through removing
> blocks */
> -	struct xfs_da_state		*xattri_da_state;
> -
>  	/* Used to keep track of current state of delayed operation */
> -	unsigned int			xattri_flags;
>  	enum xfs_delattr_state		xattri_dela_state;
>  
>  	/*
> @@ -534,11 +529,10 @@ struct xfs_attr_item {
>  	 */
>  	unsigned int			xattri_op_flags;
>  
> -	/*
> -	 * used to log this item to an intent containing a list of
> attrs to
> -	 * commit later
> -	 */
> -	struct list_head		xattri_list;
> +	/* Used in xfs_attr_rmtval_set_blk to roll through allocating
> blocks */
> +	xfs_dablk_t			xattri_lblkno;
> +	int				xattri_blkcnt;
> +	struct xfs_bmbt_irec		xattri_map;
>  };
>  
>  
> 

