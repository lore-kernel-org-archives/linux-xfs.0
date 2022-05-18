Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA8DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 16:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbiERQi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 12:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240352AbiERQiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 12:38:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560CD1A8E3E
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 09:38:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IEZZKu002357;
        Wed, 18 May 2022 16:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MTtq3yABbzwpHcJz3RSKviOSlsUrzuSFivBOCZTfm1c=;
 b=d1fprPpZfQGANOVxyrAW+cOr4tpwc6KExjiBFLLTOPiV3NkTvEqLv9f3ybAl7T8An7D/
 b3CdP7+tgJnkXBuvaVRBSYhbZBs+oOdfoaf8FiVyvQYisLf/d4622TnB0blqh4SBPQns
 s7MHNrd2xQuj55oF+DCqZ0iFHODDv4UhN4iRX828SZAxEFF2+8ocDdrJqHkT/pje7b61
 b/a6869oJEWoXFmfoS5Bgc2MNIOSPBpwNaoGESQWrFRA863bPGFZ6xo1QMW+7StYUwNx
 jlrQaGImtofAZt+4yGse1C0DOO9w9Pl7n4CWuGMW5UnmvajsmeK8ttkQkWgHDrzH7uM4 HQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytsx08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 16:38:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24IGVn2b028684;
        Wed, 18 May 2022 16:38:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v4jgtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 16:38:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Chp32tLDZ4ibeL1tNq4dJV4+aN3XCrql1YMZgKN1O3MkE7x0tOde+XhjrqeBAZ9PgJAv0+/ntZJtATHnCu6bnq2QAKtYO8b+C3soie8zq6BmNMSuZP3Im5e2+ZZok0K9wolnS59FFl+T85DtmVla7mKH2XzQGk7u0YP1dPv5ImNfdbSd9cbrd218MHm6RXJ4th2Hfq1/DmHm/HfZ9kcwmdRapwQiOQ9J3LNtuABgRrbzMW8UcVbtOWgXZ8JvqezO45yPes483lk1GkWwrayg+PGjEFWSuBHMRunDV0UwhRN74ih/ETi9UBJJhDNI9fRrt3mddTAVegPkxs19+qy4dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTtq3yABbzwpHcJz3RSKviOSlsUrzuSFivBOCZTfm1c=;
 b=O3eF3blq+yBObjqoZWklEIQU08xwEC30/u5qTzb3nkO58PnOtVd6fELs9h9wHmnEfYQaxgHk0dk3I9KDWqqvyr2P4oNOz+21G3aFoia5dxZLsU8IipCjo7JyBoJISPeOjTxNWggMN2jsx0uMPcPCpDsVklKIAROO2we1BPMGPM2i3ClfbFJGLUcvGSdpVQ0Vx6q54ks90T+8SeI7AClrVR4VkKGWteqaJHyHQjyPDZsewtCEXQlJDPyzjRpCHrCcN1pTBTfcdYK49lTiZ4A49xlh8BFJTDxX+jAIjn9w6AqMH230TxAonrydwYUF44BQSTPXWpGbLYY27/pfnYrsYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTtq3yABbzwpHcJz3RSKviOSlsUrzuSFivBOCZTfm1c=;
 b=wv0XcmrLCoLtzkdO7BT6EvrJ1FKpKss2pod+nH24y2bYOqIw5QAM/2ki7oxl6Gdja1On1nCaDTGj+L3U0Lfos7hBMUWccLnefeUeqqM0vlnSXL7ew1eGXRdEWR4S3MgB/wl2oU6Uje4p8v2+oBARlknze7QaG5IdgpQNHNMOTHU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2864.namprd10.prod.outlook.com (2603:10b6:805:d6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 18 May
 2022 16:38:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 16:38:11 +0000
Message-ID: <8074f64681d94f506c5967869225714eeb5d9a0f.camel@oracle.com>
Subject: Re: [PATCH 08/18] xfsprogs: Implement attr logging and replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 18 May 2022 09:38:09 -0700
In-Reply-To: <YoQ+RkkbPDDj0Get@magnolia>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
         <20220518001227.1779324-9-allison.henderson@oracle.com>
         <YoQ+RkkbPDDj0Get@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85a3ab83-a63d-4c75-d834-08da38eccbf8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2864:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB286464AC9B822F52BA7D641295D19@SN6PR10MB2864.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Jl2KNHEvvN/RpSpx2R/qhfOaRiXWArUIH3FYshIAEZnQj8TmjnqcjijN1pF0jiLFUSU/KP1Y9vFm+7sa+IFBnDgllKMX4oDXE9UCYiwdIhEcYtghf2X5OyLbRrx5HbdmC4iESdCGbL/6KLfPsHgTZrQyhJ6jOsyZh19k6iuA9ce3zrAQaFWpFAvVCDRMqd2OUCvY0i6YgN0NekzQbBE6hrmmd/hCSPoGyf1E+NKz67CiqXONsa8yyYUGl/FGtCeN5YX29UM58y7r4rEVUBDcQjblZgqG1yLe6G4AuAxi0kk5ovogIMwMSCa/K8qZfJY9CI+s3IENuGCwEZj+3c+pIBdQa6Kwppb0/hPjtInTHCTCnRB6NotkDL6e3Hcghk6FM2Q809cbvNyXDiw/EzB6CEdnXx2Mfg9mlDhWl/2JcaMbccIExOvYXhrRasBixESLWUEai0PtJWBGld0CYOb9TKZIOUBZ6BUHLNkxJKDnYGmRE76HL88ghy/CI17e+lV41D6jZHez/PxlS0EzmTDW8FjhjUriz4X+rHrSdQDPyUEaClgWd9VurYq8F6dX5BkEGIFSUzXjp71LuZNzczhgRdqX3ZhGEGMzuROYDNtbZWB0Whr5T7UHiSc7quhN6/TnnBzjJBybtmelh2ia+CSxN1oqwTBzYw18EHfB9g1mcMw8ckoLFUI2DjNM/Of/r5kQmcYdBfpKZ/iCDSNczJ12w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(86362001)(5660300002)(6916009)(8676002)(4326008)(66556008)(66476007)(508600001)(186003)(66946007)(316002)(38350700002)(2616005)(38100700002)(36756003)(2906002)(52116002)(6506007)(6486002)(26005)(8936002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHREVW9mem9sRkxwU1NWYURRMHhVVHQycFhGWVY1MW5ONkNUNFhLWSt5Tlh4?=
 =?utf-8?B?S2J4WExsVnZ0TDlKdCt0SjhML0ExaGFVWXlDb3ZKRzF3NUdUdG8xVHZjM0RF?=
 =?utf-8?B?VGRQaEhlSGdXTEhzdmg1L0VicTlHL1djWHV5SGZLSkFvYVBhU0hGclhzbEkr?=
 =?utf-8?B?N1V1MFBJbm9yN2NZdFdmclpuTVhFZ2grNTRLejQ4ZzVzdEM5YVNidHgvbkFF?=
 =?utf-8?B?OEkxN1hUSWJkOHEzcFBsTlpXZzVjNXViWkRCODRHWW4yT3NEcU5vQ3lmbWZy?=
 =?utf-8?B?VlVhQTZkOGF2TUhrQ2VuQ0ViQzgvRFBXa2NubXFKN3U1UVpJRnhKYUlDRFhw?=
 =?utf-8?B?ZzR3RUlMcWxGakwycTNPeTBuVVZ6UG90eCtRVE81VmRUZEtyaXVUbHpWSUs4?=
 =?utf-8?B?aDZsMkY5WUh3ZE5iOGZTdEF5WDJ2bWJkQ3ZxL1N5NHM0Y3ZLVUNpUklJU3c3?=
 =?utf-8?B?bnZEMS9iRnAvUFpscWtzRzU2Tmd1N3Fjc1IydjdES2pCbmQxVWUzVHpkZXZJ?=
 =?utf-8?B?MEdaVFF5RE5DZkNIL1o2akQ4LzBsZ09OZWgwb0lsQURiVDM0YjN6SWxBVWtE?=
 =?utf-8?B?cjhzVnk3bVVhT3R3cGRETWl2ZVp4U1NPaVl1S09mcHBLNlBVeFM5aEwyS1Er?=
 =?utf-8?B?WjMwUmxUQURQQVVYdzNGNXhOcjk2N2ZRQXhKTS85YTlPSmhaUGd5Qlh0dFB2?=
 =?utf-8?B?bHpTMEZTQzk4S05SZDRPbDVGbVBnMkpxQUVBbHhNWEh5cFZvK3I3V3gzVEZO?=
 =?utf-8?B?a0JQbjB3c255T1RLYTlWRlpHZmhtaGNhL3Y1dlpYM1dVZWhHeHFZSDNNeGJu?=
 =?utf-8?B?Mm9vLzdtbGhIT0x6S0NsdWxaaTJoM3dzTW82WUozNnlldmM1MTY4TUVhdHNl?=
 =?utf-8?B?a0hNRm9XQXRta0FhazBXZy9iS24yMFh1T1FJMjNsT1pBNS8xTnRBVG95M3Nh?=
 =?utf-8?B?R0JwdmYvNTZQMkNzSUxXcG0yWloyRThtNmFxMDQ0OXZmWmJlQ2Y2UlJWRUEr?=
 =?utf-8?B?Slk0b0RoSXJVenJ4dTFSMU9lVWZpOEhBRVRlbjl3YnJWZ3pYcHByNWNQR056?=
 =?utf-8?B?YUFxSFQ0WTBqeHBxaE5NTXY3ZCtEYko5Z2libVU1Z0lZbmhYelc1RlVWSy9H?=
 =?utf-8?B?bXRzd1NxbmFZZkFXOUFsVERrYnduZDFNemRaYkExNkFmL2JKa2ZxS3d2eUxq?=
 =?utf-8?B?V3BTN1I1clJ1b2dKWTg3RWNPYkhrQXdia1ZlR2RzeUY0VVJhWnhzVHRidUxq?=
 =?utf-8?B?cDY2SjNnRmNBVERDVXRFN21IQ1ZIOGQyQmVGWm9vZ3NEQVc4ZTFrY3p6bjJX?=
 =?utf-8?B?Mis2V3g1blhmZkcyeWtRbzl2N0NqbCtjbHY1MDVCV0hjUVQwcExLOUc1MndK?=
 =?utf-8?B?YkNTa3F0Ykl0RTRCMGhsMlZxSzBRM1BTTjA0MGEybFRSSlVBMnlxbFlMaTBO?=
 =?utf-8?B?MW1xWjE4bXdNMHpnL2VwbTdLNFpPRDBzbWJ2a0VuMnNpZ1BUeW9uam9ua0pV?=
 =?utf-8?B?aFBuR3dGRWRRTTcwa3FXcklPK25pUVpwaXRiY3I0cDVLWnl4eUJMSnV2alpn?=
 =?utf-8?B?ZG94TVdoRnQ3SkJsOHk1RW1LTFV6T1Z1Rm03Z0tQYVowSllwYk5PdlBVYkdD?=
 =?utf-8?B?SjM1dm5Ja2xjNWxqSW9DQUtPYVhublpmYUFsWkF6YXJJVHFCUTE2MERRcCth?=
 =?utf-8?B?aXVPZWpsa2o5S1BXWW9Sc3hJRHF5d0gzckx3ZWpjMERlTEFJdWRoZzd2Q1ZS?=
 =?utf-8?B?UTlOY3FLOWp0YVpDUkJxcEtZNEovVG51UDVRdmdMTTZqZGUxYmVlb0pUR0xC?=
 =?utf-8?B?VDA4NU5RZit1dml2Mm5peFhUT05WQVRjejhTYjFUMENNNWMySVJOekMyNlk5?=
 =?utf-8?B?bFI0SGpudXIxQzA4VEdwV3VOQm1DZ2VWaTNKSkhvbUZ2RXpSZEUzdHNBRTVl?=
 =?utf-8?B?TDBGR0pHQUN5ck5YV0w2eFRxbHlRMkxpZVFmczNJRnFFLzZVZGZSU000QmYv?=
 =?utf-8?B?dm5qdVFuV2ZJZFY1ZDU0RVA5M2o2M0FpeWpTL0Q4bzVheFhmWWpZTmpRTkFr?=
 =?utf-8?B?LzY1c2hxK0FhN0kzbHJrZXk0ZExMbzlOdm13UDdPVW9nMmxhT1QxSzV5eFpH?=
 =?utf-8?B?aCt0eHpNdC83TU8zVFhRUE5uZGZpd2daR3BwNmM0eGFVTTd1UUQ5SmdEUUZZ?=
 =?utf-8?B?bklwdjFseVB6Z3B3dmdFcXN5S3pEYThvcThQZ0VpSDZaeHBmREhocmZZd21K?=
 =?utf-8?B?TjViWlUraS9PSEV6bkRjenRTaFJnYTRkTS9jaGtELzFHdEw1VmlEa2FXcWps?=
 =?utf-8?B?NnhUVnRybGJMMUlZcXd1WCsyTFFZUUNyblZUUjJBUEd2UU00VEFCbFUvNkVH?=
 =?utf-8?Q?xmW3DevbQoADPCuQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a3ab83-a63d-4c75-d834-08da38eccbf8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:38:11.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdmPldbwkZlBQr1pO9x95gDBqZordPomUuC64MUj9y6dYhiS2aQ1AItmr0pZ+2PZGbdGVF/aus0ow1DGzu7B70oqynguqU6l4Gx8eYc5JLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2864
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180099
X-Proofpoint-GUID: uRyJVUJQvJYylYqIJeXND5-rkDM0SPvx
X-Proofpoint-ORIG-GUID: uRyJVUJQvJYylYqIJeXND5-rkDM0SPvx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-05-17 at 17:31 -0700, Darrick J. Wong wrote:
> On Tue, May 17, 2022 at 05:12:17PM -0700, Allison Henderson wrote:
> > Source kernel commit: 1d08e11d04d293cb7006d1c8641be1fdd8a8e397
> > 
> > This patch adds the needed routines to create, log and recover
> > logged
> > extended attribute intents.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  libxfs/defer_item.c | 119
> > ++++++++++++++++++++++++++++++++++++++++++++
> >  libxfs/xfs_defer.c  |   1 +
> >  libxfs/xfs_defer.h  |   1 +
> >  libxfs/xfs_format.h |   9 +++-
> >  4 files changed, 129 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> > index 1337fa5fa457..d2d12b50cce4 100644
> > --- a/libxfs/defer_item.c
> > +++ b/libxfs/defer_item.c
> > @@ -120,6 +120,125 @@ const struct xfs_defer_op_type
> > xfs_extent_free_defer_type = {
> >  	.cancel_item	= xfs_extent_free_cancel_item,
> >  };
> >  
> > +/*
> > + * Performs one step of an attribute update intent and marks the
> > attrd item
> > + * dirty..  An attr operation may be a set or a remove.  Note that
> > the
> > + * transaction is marked dirty regardless of whether the operation
> > succeeds or
> > + * fails to support the ATTRI/ATTRD lifecycle rules.
> > + */
> > +STATIC int
> > +xfs_trans_attr_finish_update(
> 
> This ought to have a name indicating that it's an xattr operation,
> since
> defer_item.c contains stubs for what in the kernel are real logged
> operations.
Sure, maybe just xfs_trans_xattr_finish_update?   Or
xfs_xattr_finish_update?

> 
> --D
> 
> > +	struct xfs_delattr_context	*dac,
> > +	struct xfs_buf			**leaf_bp,
> > +	uint32_t			op_flags)
> > +{
> > +	struct xfs_da_args		*args = dac->da_args;
> > +	unsigned int			op = op_flags &
> > +					     XFS_ATTR_OP_FLAGS_TYPE_MAS
> > K;
> > +	int				error;
> > +
> > +	switch (op) {
> > +	case XFS_ATTR_OP_FLAGS_SET:
> > +		error = xfs_attr_set_iter(dac, leaf_bp);
> > +		break;
> > +	case XFS_ATTR_OP_FLAGS_REMOVE:
> > +		ASSERT(XFS_IFORK_Q(args->dp));
> > +		error = xfs_attr_remove_iter(dac);
> > +		break;
> > +	default:
> > +		error = -EFSCORRUPTED;
> > +		break;
> > +	}
> > +
> > +	/*
> > +	 * Mark the transaction dirty, even on error. This ensures the
> > +	 * transaction is aborted, which:
> > +	 *
> > +	 * 1.) releases the ATTRI and frees the ATTRD
> > +	 * 2.) shuts down the filesystem
> > +	 */
> > +	args->trans->t_flags |= XFS_TRANS_DIRTY |
> > XFS_TRANS_HAS_INTENT_DONE;
> > +
> > +	return error;
> > +}
> > +
> > +/* Get an ATTRI. */
> > +static struct xfs_log_item *
> > +xfs_attr_create_intent(
> > +	struct xfs_trans		*tp,
> > +	struct list_head		*items,
> > +	unsigned int			count,
> > +	bool				sort)
> > +{
> > +	return NULL;
> > +}
> > +
> > +/* Abort all pending ATTRs. */
> > +STATIC void
> > +xfs_attr_abort_intent(
> > +	struct xfs_log_item		*intent)
> > +{
> > +}
> > +
> > +/* Get an ATTRD so we can process all the attrs. */
> > +static struct xfs_log_item *
> > +xfs_attr_create_done(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_log_item		*intent,
> > +	unsigned int			count)
> > +{
> > +	return NULL;
> > +}
> > +
> > +/* Process an attr. */
> > +STATIC int
> > +xfs_attr_finish_item(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_log_item		*done,
> > +	struct list_head		*item,
> > +	struct xfs_btree_cur		**state)
> > +{
> > +	struct xfs_attr_item		*attr;
> > +	int				error;
> > +	struct xfs_delattr_context	*dac;
> > +
> > +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> > +	dac = &attr->xattri_dac;
> > +
> > +	/*
> > +	 * Always reset trans after EAGAIN cycle
> > +	 * since the transaction is new
> > +	 */
> > +	dac->da_args->trans = tp;
> > +
> > +	error = xfs_trans_attr_finish_update(dac, &dac->leaf_bp,
> > +					     attr->xattri_op_flags);
> > +	if (error != -EAGAIN)
> > +		kmem_free(attr);
> > +
> > +	return error;
> > +}
> > +
> > +/* Cancel an attr */
> > +STATIC void
> > +xfs_attr_cancel_item(
> > +	struct list_head		*item)
> > +{
> > +	struct xfs_attr_item		*attr;
> > +
> > +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> > +	kmem_free(attr);
> > +}
> > +
> > +const struct xfs_defer_op_type xfs_attr_defer_type = {
> > +	.max_items	= 1,
> > +	.create_intent	= xfs_attr_create_intent,
> > +	.abort_intent	= xfs_attr_abort_intent,
> > +	.create_done	= xfs_attr_create_done,
> > +	.finish_item	= xfs_attr_finish_item,
> > +	.cancel_item	= xfs_attr_cancel_item,
> > +};
> > +
> >  /*
> >   * AGFL blocks are accounted differently in the reserve pools and
> > are not
> >   * inserted into the busy extent list.
> > diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
> > index 3a2576c14ee9..259ae39f90b5 100644
> > --- a/libxfs/xfs_defer.c
> > +++ b/libxfs/xfs_defer.c
> > @@ -180,6 +180,7 @@ static const struct xfs_defer_op_type
> > *defer_op_types[] = {
> >  	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
> >  	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
> >  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	=
> > &xfs_agfl_free_defer_type,
> > +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
> >  };
> >  
> >  static bool
> > diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
> > index c3a540345fae..f18494c0d791 100644
> > --- a/libxfs/xfs_defer.h
> > +++ b/libxfs/xfs_defer.h
> > @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
> >  	XFS_DEFER_OPS_TYPE_RMAP,
> >  	XFS_DEFER_OPS_TYPE_FREE,
> >  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> > +	XFS_DEFER_OPS_TYPE_ATTR,
> >  	XFS_DEFER_OPS_TYPE_MAX,
> >  };
> >  
> > diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> > index d665c04e69dd..302b50bc5830 100644
> > --- a/libxfs/xfs_format.h
> > +++ b/libxfs/xfs_format.h
> > @@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
> >  	return (sbp->sb_features_incompat & feature) != 0;
> >  }
> >  
> > -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> > +#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed
> > Attributes */
> > +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> > +	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
> >  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_L
> > OG_ALL
> >  static inline bool
> >  xfs_sb_has_incompat_log_feature(
> > @@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
> >  	sbp->sb_features_log_incompat |= features;
> >  }
> >  
> > +static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
> > +{
> > +	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
> > +		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
> > +}
> >  
> >  static inline bool
> >  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
> > -- 
> > 2.25.1
> > 

