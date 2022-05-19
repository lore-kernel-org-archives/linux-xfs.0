Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23A7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 20:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244622AbiESUe1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 16:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244761AbiESUe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 16:34:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17E67A81D
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 13:34:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JJxHaj016065;
        Thu, 19 May 2022 20:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GhyV9RX1/24OkY7DLq8lrgsGt5I6GABkgMzN2YtPfcU=;
 b=OvxPnLlrCfaHVP/uB85/4Bw1b/Qb7y112ONdWceUwpODGl+BIUzCQ03ULK37hk2Pmomm
 z/Ty9dKWV980w7TGste/SUTH/vOO8RRryYH7DrAe7chYtz4x7ojMBOtS+oNqwJ8SDiKV
 9lOE0oSwJtVPMRqVdjCKO50HnT6DTl2EWGbE9fne1G2372NUSznTkmCpQmQmTaRGUsyo
 v2y7T/KahFmDATlPZkl9BE2nmFfjmBszydcV1u8wE4VTswzo1lKU5NK0eH5JlyJ5Wn2x
 wMflGR+lZA2B54p9D2ddJY3zUPIZhySgrFl2pUefHuDkO69mbpIwGb82QURcbg26rIRv qQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytwewn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:34:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JKFcFm009660;
        Thu, 19 May 2022 20:34:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v5cvbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+K/GmPvB5pfV8PtZ3J/3aEUsAOJ0NqonnROP365eMNSBxWQOdeEThf18EpVxIYMEqVWHt0tjG8huc+HZ8sHZl0Lyi1yCjP0nWywZ2PmIEKWXP4eJPTwiDKn9LghZ495vl61csXF8UDYL5lm9En6IUxsCe6fIH3JuIJKbn+RdqeiR226769qeoo245Viot0KTeyKj3mbKYY5K92IiRItz0qFB+KjFuJ42gUH3PB60wpnVxhe1pMfIXSjd4mEKc8ldYU4fcSdcwKj8D/bwe0Eo4emrOlxk5u2+LUMXAfY7vHmG5h6hgaL92gY70EEHYBiTigRLcx5o3n23lZ4VU/HiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhyV9RX1/24OkY7DLq8lrgsGt5I6GABkgMzN2YtPfcU=;
 b=D/I8twAUgDdNxiuIt2ONTW5dAG0SoDp7SAyOiXf9Sn2LfAu3w7qTIX0QS1fKjnlBEHTxIspvC7K9ghsA2EZZgFeI2YQwqW1xCMZTVJIoVmRLg5gTXBlojKudRDLElXAcQhlIARJKmIabKpdjs2L3YCGw7T4EZQ93zBlGR1bwPi7XtcHyDWcTEGHAYeMF7i60bMEvBQdYkUPjyvN79roV0z4KE2jYfzk3Sjdq0wbMP2bJXq9BxqgK+5hE/y5N8eiwYH7d5YfrbTjBBntt0jDDQBxDxD+yAsbBc4ru0DBh+hr04YmcrKiVdIEbLeNN+hjPj88GBAsWojEmnToe9pea9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhyV9RX1/24OkY7DLq8lrgsGt5I6GABkgMzN2YtPfcU=;
 b=QMkeDAwFQXADv3X4+t7TFCz3jReYETJD3sqpgaHZzEnz3sj2QgCWIvGj9aZBsX0bW1aE6oS+dLYDP32s+3mT/WEBdr9aIAAnLXn04478r7dgaQnvq0SXTdpsgiYSN+f+4rs0si08AVxbZNleiEgLfxRYJSVX7a/ZFfAGEhbNOXU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2186.namprd10.prod.outlook.com (2603:10b6:4:35::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 20:34:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 20:34:17 +0000
Message-ID: <b55b3a2f03ba00afa6ee90162d297e03318ac949.camel@oracle.com>
Subject: Re: [PATCH 4/4] xfs: reject unknown xattri log item filter flags
 during recovery
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 19 May 2022 13:34:16 -0700
In-Reply-To: <165290009876.1646028.9980499225084838287.stgit@magnolia>
References: <165290007585.1646028.11376304341026166988.stgit@magnolia>
         <165290009876.1646028.9980499225084838287.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0091.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1448248-225c-4f1c-8674-08da39d6f23c
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2186:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21861F206D5C91FFB4BFC42E95D09@DM5PR1001MB2186.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OEnhxhNK+4+e+nQnxNuqe70Z9JXiSdlDrtP28MVMSNwh2QvEd8tJ+JBrKyvRlUqdatpoDevGLBgvpaCkeHSKZVIUtFm9n2VHbtbe5gEGBfMJFkHP0iBQKzmBRtwO49KIHOoMtW77NB5vUUx90ZwzP2UmzKqTsyJW7zT8Z2q1DzwXGsTKn2+TNtzXm+fRpMeuBAQ+KDBMgmhEMv7jhWj73NK1shSedLG0oeUEcTQseVVb5qiPp2zgF0BgammLKSNtBmoOt385Dzmw92HSGFWfPHA2g4+0Lbcp9BnXlRtwJDr9mGprmBipRCY2zcAimaoP4LPsQjYnI8lS/6S7htEryN6BqjBT2ryU0tw0qF5G1E34Bpe8JZ13o9GZBXOCLhttFKsRiX868bX4b4L+gkMGQii2wXFJPu4JmMxlyhgq1BTrQ5+n29jCmYWlqT0bB8tlkDr6XLd+ALOSBK5PUMm9o6O5QPp2nRfNw4xOL+VdXLh2iBunyBHqxWs1kw5E7n188eUKofGbu5J/7obPGfi50yoqms6c1U6wAp2jEu50bnFUNE0iVUI+w2gKQyns2Im3kMd4TscbwH9EH5pfUPpB3CPba7vVHB0tEuZlcdkts3oAFxcMsr1Dyz+4LBIYGvnpby8+30IbUWZEU4IGqT1FNE/oboem2ahPZ6HvxeMTENob/UCbEWdLbPL55XMA/WFtErk/Eh87GQBMpiA82UiDDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(52116002)(66556008)(6486002)(86362001)(6506007)(6512007)(186003)(26005)(4326008)(83380400001)(316002)(8936002)(5660300002)(38350700002)(38100700002)(36756003)(6916009)(8676002)(2906002)(66946007)(2616005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmxvNlFLalQ1RVU1Tm5xSG1RMHhPR05ub1A1T25SWHFiRysxZ3dVeUwxOTNw?=
 =?utf-8?B?UFNJdHErZkdRWlZKbklRYWJTWHo2V2N3WDdXUmlxVlZBVE8zS0FWcXlCN3RU?=
 =?utf-8?B?MmRtZ0swdDdnOEVncUVYYk54WmMzaGNTdFZSNk92cHRDbWhsYXpVbHp1d085?=
 =?utf-8?B?b0c1ZXpacnZTcTFnOFRmMlFZejVNeDBuMG1yZmFsVHBBcGFpT3V4RnBHckhk?=
 =?utf-8?B?ejYyOHJ6U01XY2xZZlJwTUFBUHlpWnVJSGZZQ1dwTEhDTEI1OHY2bHFIbjFM?=
 =?utf-8?B?b3haT0QwdEZPOFk3RU5GWU5PWEtBZ0orc05YalBuWHo1bjVNTkJxanpJN09B?=
 =?utf-8?B?ZTdzZ2ZISXdwVXV5M25CakhTTFp0RElHM2JlenV5TDJNVnhmUlVxMDNjeUNv?=
 =?utf-8?B?cklzNThRa212ZHpnTTE1L1E5L2JHVUFQSnR2cGw0Y1RJRXN5ZnF2dlBhZUla?=
 =?utf-8?B?SnNoUlFLc2xnK3hmRW14SjdlUDJuUm10ZWtsQlBPZ285TzZXTTcxSmlqR3R4?=
 =?utf-8?B?cER4WGw0UFB2aFJ3MkdCV0xHbnRSQkZFVlA2TlB3OXpXVTMxWTNUM0gxZFRp?=
 =?utf-8?B?SE1GT1lvbGZmNitEK3ZFNGhNSDZ4aTJlTEhpNEJ3REdadms4WTFSdUk1R1Ro?=
 =?utf-8?B?Sy9LUU92WTUvMHdWOWFTV1p5T3NMbytzUlNXRVRlUGhXbkdLVmlJemtzS0JU?=
 =?utf-8?B?aExPSFY0ZEYvRGxnbDdudkFBVjhZL3YxaW43S29XUXR0Qys1TFlFc1ZWeExx?=
 =?utf-8?B?S0dHaDRVWnpZc0I3SzBXcHFVN0xzZlNnTnlIaTRDMUExWVNJNE1nQUpPVUtV?=
 =?utf-8?B?eU5ybFZWUDJpcXhwRmtQZWsrdC9adEcxOFdTVi9EVFpPaW9FQzVmZTNWQWUx?=
 =?utf-8?B?STI1OGlLamdFNDdaN1dNYlg4MnVyRzUwakRIRXZ4WVlPaXJmV09hUHBDRmdw?=
 =?utf-8?B?RkZoZ1ZsbnJlUllxcnlWOVpTQWJZOVZTeTByTzR4ekRJZC92VmJhWnlyZVhF?=
 =?utf-8?B?SkpVbGEzYTFra01QTU5IeWlKVnBVeDYwVERwVEc2UE01QndtL3NiM0ZVQ0g4?=
 =?utf-8?B?WU15SzAvSVlFKy9RdDFVTUIxaVlLSTduN3FyTFViamNJMFg1dEdrbzBSTlEr?=
 =?utf-8?B?OUxPMjdoYmhXeVlhV25ySWJ1NXU4YWFWUjA4ZGpZOEdEZ1JlVUttZDM1dDVa?=
 =?utf-8?B?MGxnM3Rwck0yRnJOMVUweWpuUUdOWm1MZU5pTU9IajVDQU5raDl4R1hwRk41?=
 =?utf-8?B?QU5nR3hEZXNTMG5hWjZxUHpRU09yRk9QZG5YOTBHYllBeXJUeDYrNjkvTjJF?=
 =?utf-8?B?VmtuU3MrSmpNSUE1Mmhqd0RsSTdLYW1heW9aSkw5UkRkQ1k2V2pxZWVhSU9N?=
 =?utf-8?B?d1dwck1OVktTUm9rKzBxZjNIV0NvWXBaUnJQTDRhZnJxayt5WVB2TWRVcFB6?=
 =?utf-8?B?R3VuVjV6VkkwNTExajJ2cmJjZmdDcmlWek03SktQVDkwTWtrcU9sRmMrNjBh?=
 =?utf-8?B?WEY5VmlxM3p1bGhMSWI5VFhsR2o3Y2VSU1ZkdXpINWxLbDU2d0NQeUZaVVRO?=
 =?utf-8?B?am5pbzVKSzEvenoyeXRNZCs3OTBJclpsNkgwS2RhajAvYzZPWTVPVEJISlpX?=
 =?utf-8?B?TW1WT2pKdmw0aEJtdzBuMkE2ckFYV3JaK2dJR1ppdFUxSGwzLzl1cElsb3hL?=
 =?utf-8?B?bUNwOUdLZ2IwdnpUNUlrazcvUVl3VWdzUkR5V2NwNUFJMG9MYTVXSlNjUVE5?=
 =?utf-8?B?L0FpWW9OdWdYQnFRTjl0RGk2dmFtTGh2cDgrcDBBVWFTZ2JzQ1JIMWozTHJl?=
 =?utf-8?B?K0VkRzZlYWg1V3AyemRrVi9mdHNGcmRpb0R3eld1YkZzM0tWUWJSQVFUY2Q2?=
 =?utf-8?B?Z2I0amtOUmhKTDA1NnNuNkdzaGFrNjNIb3gzeGdlbVhpZitleWxUZ2I2WTda?=
 =?utf-8?B?eGtYb1VvOUd4WThhREltWStvcTAwb0FkWG9MS2puMG1xV0FNM2VieWlESlNG?=
 =?utf-8?B?N3lYY3g5K2M4RHFCWGlJelpZNGNkMnkyN3N3Qll0S01NMWJrMnk3azlXRlZQ?=
 =?utf-8?B?NzVBMzQyQlhjaTJlcUk0R25ZZGhyRFRuQ2JneXkxemwvYkFCaTVPcktYVDBG?=
 =?utf-8?B?VW9vR2hGZjBOVTcvVzZ4bG5wOWZYU1o4eXE5bXl1YjdNTWNrQ3dvZ3Z1NVNu?=
 =?utf-8?B?WWZsMHJOa21DUkQ1NnF3VzhSbWtmTHlncWYyRnVSdC9WOFBLMm0yMExrQ0xn?=
 =?utf-8?B?OGRlUW1GRklvbUh4enEvK1NZekNwd1RYNUxaS0JDcG5VbHZheDAxL09HeTFC?=
 =?utf-8?B?Z0NuVTZmd3MyVytZOWJXRE9yay92akJ4UjlUSjZUbGw4MVFDYnRmbDBqTkRl?=
 =?utf-8?Q?K7sA8kXf1SeEpqh8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1448248-225c-4f1c-8674-08da39d6f23c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 20:34:17.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yk0e7QgtXWpdW2itg5/KeyZydiPCoJahIP1hg+NdBtk1UcLxyqpNoc7jaY+ORKhwx2Es9BUCMaZ51JKjyPWAMqQqfQAd7XhSVZqYEAxiors=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2186
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190112
X-Proofpoint-GUID: 0jEEPRmdiWnkdc78SHPiHUwTAGCixrb-
X-Proofpoint-ORIG-GUID: 0jEEPRmdiWnkdc78SHPiHUwTAGCixrb-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-18 at 11:54 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we screen the "attr flags" field of recovered xattr intent
> log
> items to reject flag bits that we don't know about.  This is really
> the
> attr *filter* field from xfs_da_args, so rename the field and create
> a mask to make checking for invalid bits easier.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks ok now
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_log_format.h |   10 +++++++++-
>  fs/xfs/xfs_attr_item.c         |   10 +++++++---
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h
> b/fs/xfs/libxfs/xfs_log_format.h
> index f7edd1ecf6d9..a9d08f3d4682 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -911,6 +911,14 @@ struct xfs_icreate_log {
>  #define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
>  #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
> +/*
> + * alfi_attr_filter captures the state of xfs_da_args.attr_filter,
> so it should
> + * never have any other bits set.
> + */
> +#define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
> +					 XFS_ATTR_SECURE | \
> +					 XFS_ATTR_INCOMPLETE)
> +
>  /*
>   * This is the structure used to lay out an attr log item in the
>   * log.
> @@ -924,7 +932,7 @@ struct xfs_attri_log_format {
>  	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
>  	uint32_t	alfi_name_len;	/* attr name length */
>  	uint32_t	alfi_value_len;	/* attr value length */
> -	uint32_t	alfi_attr_flags;/* attr flags */
> +	uint32_t	alfi_attr_filter;/* attr filter flags */
>  };
>  
>  struct xfs_attrd_log_format {
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index ae227a56bbed..fd0a74f3ef45 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -353,7 +353,8 @@ xfs_attr_log_item(
>  	attrp->alfi_op_flags = attr->xattri_op_flags;
>  	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
>  	attrp->alfi_name_len = attr->xattri_da_args->namelen;
> -	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
> +	ASSERT(!(attr->xattri_da_args->attr_filter &
> ~XFS_ATTRI_FILTER_MASK));
> +	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
>  
>  	memcpy(attrip->attri_name, attr->xattri_da_args->name,
>  	       attr->xattri_da_args->namelen);
> @@ -500,6 +501,9 @@ xfs_attri_validate(
>  	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
>  		return false;
>  
> +	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
> +		return false;
> +
>  	/* alfi_op_flags should be either a set or remove */
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
> @@ -569,7 +573,7 @@ xfs_attri_item_recover(
>  	args->name = attrip->attri_name;
>  	args->namelen = attrp->alfi_name_len;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> -	args->attr_filter = attrp->alfi_attr_flags;
> +	args->attr_filter = attrp->alfi_attr_filter &
> XFS_ATTRI_FILTER_MASK;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
>  
>  	switch (attr->xattri_op_flags) {
> @@ -658,7 +662,7 @@ xfs_attri_item_relog(
>  	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>  	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>  	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> -	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
> +	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
>  
>  	memcpy(new_attrip->attri_name, old_attrip->attri_name,
>  		new_attrip->attri_name_len);
> 

