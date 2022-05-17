Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29415C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 18:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiEQSUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 14:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiEQSUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 14:20:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C3D506F5
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 11:20:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HHSfsC023077;
        Tue, 17 May 2022 18:20:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=C2gRE6d0JYg8h9AWnoFDjz3Ra75w9NNEVO7p557IjTE=;
 b=fNs3jUXi/ihl1vTY4rFYcUt2lCYJlUh52axZx/9LJdMODnfRrGBwQTCeaMFnL76qpTe2
 prpkVEtgzXxQiwpw+wbKZSTYiLuJNqESvJaEeMwc/U5AyQHB91AYhLzosj0yhfEKJ3k3
 f7RUdHRCyfx4sP4X+dP+9e60TbWeggOcCNW8/nomV61vXXCXnuGBtfa7VFKagQdX8v1o
 pBf9j+oEIH5C2lDuL91X4AOJz97atDwHEl5a5SIA/W39vSc6Nu/X1mPdwRdveRdsKTOv
 NLdyOKjUeZGKZLUM/flGMDx1Sl/9ppsZDKub3ePfX/+cPDxBAD0dhAy105VEeKW71ERu lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s74sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:20:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HI51qa037213;
        Tue, 17 May 2022 18:20:29 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3dva1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:20:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1fVZVXFmfpRwOUujipV28LdSUpGqMc6lcvr8l587/mWkTbBUEwGWlnP9gQldTu0RiAQ3CK/HhMElcdtZOiyFb1msJiYwSXqISI702t6ZrSSznkefUsnYla2j7Es0Xkvtw9KjqQQn+Q3cGqPXNm8cV9U6H+UfvaG0iS0bo2W45iYJdl8Y4fAYIiQV+02oUNAORIQwRTYFz0wA4/G5fpPooP56bC/XOfTgLDlLgi19cnrmeG6LBFYMwfo4QQE5LfdjxznvVEACtmyKhCSxOJen+1zGGh8U2OlxZWK1Vp2qc0LW1AcotGQJ49xN9hXu7YbO2j+1/yUnDnQG9tx3m4Vjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2gRE6d0JYg8h9AWnoFDjz3Ra75w9NNEVO7p557IjTE=;
 b=FN8SLztSOkdBrvitm0eaS1ZiW++Rv8stRWyQ5807vGwNsw4agHybP1ijDDImMem9g93yxP33dsMFN2KFsVisKRDWmtYk6ZIGoh8Ikgm2v8yT1JWQrIHhjtLJjrQVipvw3nRbtSMWuf6qCxmRItn2c+zIcbhe61R7xDRTZZTS02Fno+6ghHhdrzjdTp1egsZ4LfRBO9bUZfs+Ig+DIZCU62WmE2rvytESxTYRY9f/AwY5BfjQMvY2jywX5Ky0OhsPZGj3FqhjHNos90/dtuAaN+aecSstR2jU6BokCs9yRn/2NGBtN02bBksypKL1p/CG3MBujCQg2DiAKVDZ7HHI1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2gRE6d0JYg8h9AWnoFDjz3Ra75w9NNEVO7p557IjTE=;
 b=W7ri7YiC9MdXXCo0W4+fdWh/6FQ6Bt9yxdQGzldfxN4C5qSv5aQHmCOzIW2aAilFGtJHN3BszVjV8pJdgEVf/9eRfsizKG0EKFwE7FiZOBlm31T8RI1o3Q8f1YdeB+1v5odvG4v+D58hyhaps/aIygolWsXbt7KHpdtHYA7iEWQ=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by DM6PR10MB3786.namprd10.prod.outlook.com (2603:10b6:5:1fe::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 18:20:27 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 18:20:27 +0000
Message-ID: <224bda1f8df627a0db1328947de6050b1e648af2.camel@oracle.com>
Subject: Re: [PATCH 2/6] xfs: put the xattr intent item op flags in their
 own namespace
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 17 May 2022 11:20:24 -0700
In-Reply-To: <165267194968.626272.5616764509389152783.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
         <165267194968.626272.5616764509389152783.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::26) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f380b168-585f-46b1-0356-08da3831ead3
X-MS-TrafficTypeDiagnostic: DM6PR10MB3786:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB378610924AB1842AEDB1E95095CE9@DM6PR10MB3786.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X7l3oJXwi1p9cFDRrLYquQGEx581mYIvLP2CCS2/idA25l0jbwZvTnHzeHVHXfl9ZYBG24xQ3uppYQf+WsGPwowIIo4/NKd0hk7tfkszmAluEMrY3JCQXNGSY8N40TfTCqoKmZjMvrnYlX984r9Q5sm8iPDHtDIGxZw02M4rzcocPbJXxqndDwtkK3RoxAqIvFXzYTjKh3RfCFeG08J+ZVLXaVHbSV/KZUbo+U9LH7vd9AVDZFs55hPvEcoQOF1fA02PB5YxJU2/5dTqaEWmffN/60zXkPBquLln+AMdLMp3N6KKg+PXHNeYE7scYFZ++TDMoPskJrsZC23W8um3NuEinZIwVRafbSBfMOfXmzrl0c0ElFU+fxEpIZrX6fPNQ8e+aY7wr22xB9g6prC0Trr1BOlsHs0Ril2nYlv/p6MAK6fd6SUjjZgbJFuam6551JF9G2S+YhJGZ2KCMyo16MZbLOX+arKWgSnyeOBXa0+JL3TBs4XktVzzkmFACcAIkJzE4VuW7mPkUM1KuMISj28YVIgLcCOc6o4jD0xTUjAlaBio4cexBQ5e1+JrXr3+wDr8pTd8IKrVvfyAuQNJJZRWeCFugkcXPyfWKLvmdJq02FWnw27+07WtxCoMwGK0kwyOVQr9df+caT+QL/31liubpTaAng5LS1WZFeDbQrIUbF9zR/Ak8rfugLp4f+DMRN6DiiMD/L92rB5ajsXNow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6512007)(6486002)(38350700002)(38100700002)(6506007)(6666004)(52116002)(26005)(8936002)(316002)(86362001)(83380400001)(36756003)(8676002)(4326008)(2616005)(66476007)(66556008)(66946007)(5660300002)(2906002)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckRlSS9BNVVjNzlCZGtOT1JBa0dLRkwxM2U4V053My91Y25lY3p3Y0NJZGtR?=
 =?utf-8?B?aHNRYTMzVFp5K0F0VFl2L3FHOGMrMnQzUDFCU0FjYWlpd2ViaExxQXVwUXNJ?=
 =?utf-8?B?SFBmaGg3NUpTelJId1E1MGx6WjRRS0pVVEdKVHpEamUzTFRNdnJYUFNkdi9q?=
 =?utf-8?B?bXVRRjVyWWo3SkFiSUZrWC9FV2xvWXJpMzlOWjBjRmlETVlsbFRMdzFtYkU4?=
 =?utf-8?B?UnBSRTRqK2VCbjVXQTFLQVR2c05RSnhvZmcwT3Q3cDNOYzNOemFXVXlNZTJJ?=
 =?utf-8?B?TFQvUHpobEFEbE9EbExhVjRYbi85THpodENGNEJSTG5HaWZnaUIyMEFkNjc4?=
 =?utf-8?B?bHdjVGtudTN6SWxDSmNHdzVqQ1pjNG5QbTBQemJYVzJTZ0FxVW5acjNwTUpU?=
 =?utf-8?B?UXBxUWVmZWhNVzRKSjZpdDUyaGFtbzFtV2YzV09uOS9STVVkT3AyZTVHSE1D?=
 =?utf-8?B?RnNCbUcrZXhGSzk2S0JRQ0VhVHZRYUN5T3ZSV1F2cDMyb2JxY1FlOW9MMXpY?=
 =?utf-8?B?VmpSM0hobnlwZjkxT1BNYjVnaFZ6Z0g5VGRiV1B3Ni9kRlpiOU5FZks5cmNh?=
 =?utf-8?B?aU84UXRibG5NQ3lqWWlCV1lJZUJOaGRRR2lMQlpML3ZMWjVEbHIyWUlTMHJi?=
 =?utf-8?B?N1FPUlY0YWVNeWIyUlB0aHJwMDNISmlGS0t0Ykoyd0F1bzYzZVZXeDBZVFRy?=
 =?utf-8?B?QWZkS0lTaSttZmJOQU5oVUkyM2ZCc0c2c05OaGl1VW95TjhDMzZIdUJ5QUpY?=
 =?utf-8?B?amZNamtGY2V3TDF6dUFmYWphemVtVDhwS2JFZnBrTTgwcnl6TUJQMEhGajYr?=
 =?utf-8?B?TytZZFpJdFlVdVNtdWIxbWtISzlaY1RoUU1lVlFmREZNRi9OUisva1RmVU1V?=
 =?utf-8?B?UDBsSWt6U3gyNkFtU0txLzlnUSsrb0YwNjZta3lhSGZ2MUJzaUQxR3dQL2hB?=
 =?utf-8?B?S2Z3blpsQ2d4dHBtTWc4Qi80R1ZNRWRlSVZNb3JTVE95NndyY3h1c1AzMjl4?=
 =?utf-8?B?R3huSnV3Nm1kdEJwRHB2NkpiNUFiMEdQY2tVcS94RVFHQVcvNG9Gb0RmRGVX?=
 =?utf-8?B?enZHSnJaRWdDNlZYdFFnNkFJTE1KajlXUW0yZi9xbnRmVHB4WHhiTTJ4MUp1?=
 =?utf-8?B?WTVacEhqZGN0N1Y2Mk1EVnBNMlVTS1QxOEkxWVpQeUlKQWtrcTNLWmxHZDhL?=
 =?utf-8?B?T2JHV1NMTjZyVFR4MUtmaHpoTmNrV3BnaDBPQTJ3QWN1VnhRZzlsb0lyQW80?=
 =?utf-8?B?TmtHSnlza1hqanlLQ2RGNGF6SzFkQ2VJOHVLck84eXNhdXcxSFF2NDBWQzFV?=
 =?utf-8?B?bjV1WWx4QmxUcG9tOWhLVlFjZHV3cWNJUCsrOUt2amZLQWE0c0VLdFFVM3dO?=
 =?utf-8?B?bTFFdUppUnBkeUtockMrTlcrQWl0Mm1IclN5bER6MXVaM2hvOTlxOHNILzBS?=
 =?utf-8?B?cnpRaFBhamR2b2JBNEcrWGdhQ29KNE5pQmc4amErbEdiZWJUS3FZNks4TlMx?=
 =?utf-8?B?dENVNHhYNi9PUW00QVhiNlFsVTFBQkRIRFgwbXE2QWx2cGlzL3lHRk91M1VP?=
 =?utf-8?B?d2psc0dQNHM2VmdrOVRhamRSVU9YYUQrNHNQaUhmYTArVy9lWHpKeXhrVHd0?=
 =?utf-8?B?c0VsWGV4UVRUL0lkd01qQ3JEd0lsM29RVWdGb0V0YitGVVc1SFQ0VUg4SnpZ?=
 =?utf-8?B?TlZNbFF6cnFOa0w0RlR2YVAvaS9YMExwc3lOV3lRaUEzd2lQUGwwOThiM1pC?=
 =?utf-8?B?dlhvUEFUUFd0R3pya3VHRUg4UitKZWZoeWRhSlNVNXRDakdJNktVMzhNdUxW?=
 =?utf-8?B?OFowcUdoQ002YVZSbjRwQUw2UkdNV3FqeE9RcS9FbGRzdDBwL0RiMXM0RERB?=
 =?utf-8?B?NzFmbEhrSkFaZzU0VmxBT1ZNOFpWQTR3R0hiMEJOZzJWNjBzeFJQdjJVRnFo?=
 =?utf-8?B?WkRHT1IrUnhoOWVGc0Uyd2V6SENXODNmUllvNk9TalBKYkRxdE8ydU42ZlRn?=
 =?utf-8?B?MTkrV2k1WjduS09hOTIxUUQ1MHJjbWdUYWpqZlpsVVF1RGJMY29KRHA3c1Fu?=
 =?utf-8?B?bG8rRzgxOW5JT25heFJwcTNXL0trNVJHa3BKL202czRxZWJ2QjFycW55VTBM?=
 =?utf-8?B?OCthYnMveHpTMFY5TE9pMU1GYjRNZWcxMVdQSXFxbk1qbWRqdkpBWHJPQ0t3?=
 =?utf-8?B?Z1JjZU5xNksxRWoxcnJrOUNCVUVFb1NLTGdXa1pkT0gyVVAvMHRjajN0bXFy?=
 =?utf-8?B?aHBKVUpMSmJhUEpnSW4ycm5GdVFBTlZxcHlUN2FRVXBoVllmWnVSYVBreDJh?=
 =?utf-8?B?NUpaSjRZc1JQWXhwamVSbmQ2OWRhY3l3a2MyS2MzdGRBUGpjMUZSbUlTdnBV?=
 =?utf-8?Q?DWojhMDm2CAcbrKY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f380b168-585f-46b1-0356-08da3831ead3
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 18:20:27.1846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Aze11pnYaPuOH5Tw+lg+TTZ1YiW45qAFFqfL7vYLKJAP8Sq1WZy2SdiWQL+/hcqmdJsiYCusrhsnRXhNF/k3pIiMdTl5EFxE5mNrStmGhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3786
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170107
X-Proofpoint-GUID: 1uP6KptoxGPmC0Yoz2FNB0RSJ4bXI5MI
X-Proofpoint-ORIG-GUID: 1uP6KptoxGPmC0Yoz2FNB0RSJ4bXI5MI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The flags that are stored in the extended attr intent log item really
> should have a separate namespace from the rest of the XFS_ATTR_*
> flags.
> Give them one to make it a little more obvious that they're intent
> item
> flags.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |    6 +++---
>  fs/xfs/libxfs/xfs_attr.h       |    2 +-
>  fs/xfs/libxfs/xfs_log_format.h |    8 ++++----
>  fs/xfs/xfs_attr_item.c         |   20 ++++++++++----------
>  4 files changed, 18 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 381b8d46529a..0f88f6e17101 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -918,7 +918,7 @@ xfs_attr_defer_add(
>  	struct xfs_attr_item	*new;
>  	int			error = 0;
>  
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
>  	if (error)
>  		return error;
>  
> @@ -937,7 +937,7 @@ xfs_attr_defer_replace(
>  	struct xfs_attr_item	*new;
>  	int			error = 0;
>  
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REPLACE,
> &new);
> +	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REPLACE,
> &new);
>  	if (error)
>  		return error;
>  
> @@ -957,7 +957,7 @@ xfs_attr_defer_remove(
>  	struct xfs_attr_item	*new;
>  	int			error;
>  
> -	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE,
> &new);
> +	error  = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REMOVE,
> &new);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 1af7abe29eef..c739caa11a4b 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -530,7 +530,7 @@ struct xfs_attr_item {
>  	enum xfs_delattr_state		xattri_dela_state;
>  
>  	/*
> -	 * Attr operation being performed - XFS_ATTR_OP_FLAGS_*
> +	 * Attr operation being performed - XFS_ATTRI_OP_FLAGS_*
>  	 */
>  	unsigned int			xattri_op_flags;
>  
> diff --git a/fs/xfs/libxfs/xfs_log_format.h
> b/fs/xfs/libxfs/xfs_log_format.h
> index 5017500bfd8b..377b230aecfd 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -906,10 +906,10 @@ struct xfs_icreate_log {
>   * Flags for deferred attribute operations.
>   * Upper bits are flags, lower byte is type code
>   */
> -#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute
> */
> -#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> -#define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
> -#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
> +#define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute
> */
> +#define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> +#define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
> +#define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
>  #define XFS_ATTRI_FILTER_ROOT		(1u <<
> XFS_ATTR_ROOT_BIT)
>  #define XFS_ATTRI_FILTER_SECURE		(1u <<
> XFS_ATTR_SECURE_BIT)
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 7cbb640d7856..930366055013 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -350,7 +350,7 @@ xfs_attr_log_item(
>  	attrp = &attrip->attri_format;
>  	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
>  	attrp->alfi_op_flags = attr->xattri_op_flags &
> -						XFS_ATTR_OP_FLAGS_TYPE_
> MASK;
> +						XFS_ATTRI_OP_FLAGS_TYPE
> _MASK;
>  	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
>  	attrp->alfi_name_len = attr->xattri_da_args->namelen;
>  	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter &
> @@ -493,12 +493,12 @@ xfs_attri_validate(
>  	struct xfs_attri_log_format	*attrp)
>  {
>  	unsigned int			op = attrp->alfi_op_flags &
> -					     XFS_ATTR_OP_FLAGS_TYPE_MAS
> K;
> +					     XFS_ATTRI_OP_FLAGS_TYPE_MA
> SK;
>  
>  	if (attrp->__pad != 0)
>  		return false;
>  
> -	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
> +	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
>  		return false;
>  
>  	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
> @@ -506,9 +506,9 @@ xfs_attri_validate(
>  
>  	/* alfi_op_flags should be either a set or remove */
>  	switch (op) {
> -	case XFS_ATTR_OP_FLAGS_SET:
> -	case XFS_ATTR_OP_FLAGS_REPLACE:
> -	case XFS_ATTR_OP_FLAGS_REMOVE:
> +	case XFS_ATTRI_OP_FLAGS_SET:
> +	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +	case XFS_ATTRI_OP_FLAGS_REMOVE:
>  		break;
>  	default:
>  		return false;
> @@ -565,7 +565,7 @@ xfs_attri_item_recover(
>  
>  	attr->xattri_da_args = args;
>  	attr->xattri_op_flags = attrp->alfi_op_flags &
> -						XFS_ATTR_OP_FLAGS_TYPE_
> MASK;
> +						XFS_ATTRI_OP_FLAGS_TYPE
> _MASK;
>  
>  	args->dp = ip;
>  	args->geo = mp->m_attr_geo;
> @@ -577,8 +577,8 @@ xfs_attri_item_recover(
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
>  
>  	switch (attr->xattri_op_flags) {
> -	case XFS_ATTR_OP_FLAGS_SET:
> -	case XFS_ATTR_OP_FLAGS_REPLACE:
> +	case XFS_ATTRI_OP_FLAGS_SET:
> +	case XFS_ATTRI_OP_FLAGS_REPLACE:
>  		args->value = attrip->attri_value;
>  		args->valuelen = attrp->alfi_value_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> @@ -587,7 +587,7 @@ xfs_attri_item_recover(
>  		else
>  			attr->xattri_dela_state =
> xfs_attr_init_add_state(args);
>  		break;
> -	case XFS_ATTR_OP_FLAGS_REMOVE:
> +	case XFS_ATTRI_OP_FLAGS_REMOVE:
>  		if (!xfs_inode_hasattr(args->dp))
>  			goto out;
>  		attr->xattri_dela_state =
> xfs_attr_init_remove_state(args);
> 

