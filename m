Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E12C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jun 2022 00:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiFRAc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 20:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383025AbiFRAcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 20:32:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5641D324
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 17:32:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HJp4tK005230;
        Sat, 18 Jun 2022 00:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=S01NY7jpL0qYZ1RF8ijepSznU7iDMkK4Uqc3BetjRVg=;
 b=nbEXl6xiABlMAxN0zVWLDLRsqMqAoPZcPAzqLNMVEVfKSpY9ohwztMCn3BWg7LEbR5Ux
 n413BZfK56b1IK7NrFlqrPCmA61t9bbQIK9AVWEeTPJKu2KrdCkxqYxbge/3uJNyCoGi
 2PWuQ9kKaoiK5/18mFpG65q0fJMMpoVaxBVH0QzOHbTlt367RzTqQ3F0w9SeE6cZJvSY
 yvUM6HqXM1caEkzCYGtROQIm5kkuXCLOvExP5V2yeth8N+qc4Vu0MFHnUBnbiXcXhlma
 rQY22Zrr7u9CwyJMiwWX4IZjAmlkhw8N/qv9coOhVslwfi4pr42X2o2sj9LEXZHyMmTW ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjnsexn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25I0QQeA030476;
        Sat, 18 Jun 2022 00:32:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpqq4ahh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm1jYIgQ0vuHy4cbtiyfQ89OblEV191fyXScK6dQS4tVFNyO9ufnFxlGSntNRgWJjtuR/yEpqW1m58WC/GvebhF3PQfrCgspgIPkHNPiYPc0Fssc82YQvjiX49aTckh0tDTOHmCA91qqbvhfLZhn1sL3hBXtA7r/8RfwmnjQcTJy/GsXDiLFliYqmaP4MXTfFaIai770pG3POrtDY7doOlJ4SKAohhZ7EzEGZ6fYdZuHaLA+rmz68pXH0kUje+uMKHIz6EDKDWsXjTXG0WQ5AiTI8ZZ0SJ19FeuJ23D0ZSyoNHXM7MKWH76gsbXQWYHHAIYVa8KZ0sceLGMh4W6B2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S01NY7jpL0qYZ1RF8ijepSznU7iDMkK4Uqc3BetjRVg=;
 b=TrCFwoN1ZGoCHKqN60L9TO4UDpRwbaPyDuSRlvsVHsPd4+t6QGPwzTif4wlX5I2RlfvJleRtOGwez5GTiW+vsJJ1WlXzgM5PIOyJhf6gyvVHe3qDVrTkNOorrU6huU+Wz7NZoKpSrjAp8c+lZsxrw5opVYlZRxCXSFGEH/TrX+g21x2tNgG1bVb9IRWrcykWRhxw6X4JTrJbxZBl0PWkoC4VXejtOSA5j5TFu1pDTkkfhkJnz6OcNq8sLx4uyaNBmCi7gmWUJZyQsIazL5DV2j/IGdArhh/6FHjWh99gXNoBe1fc4Tkz8NzD01jbpPGEcMbbOAvM32LYw/kStEY2vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S01NY7jpL0qYZ1RF8ijepSznU7iDMkK4Uqc3BetjRVg=;
 b=bMCe/wWBFFSYYcPAngwZTSZqb4VyQWIhekittoc+iKmAAoQzBX8xroX6QLZUFIxu3+IY9fAz6MwHqM8INiCjz66mVO9nSgGdctWJE38jcExKVTIjsNMRaYA0IhN/CMKJLxVDvHj609HME2yqnmFgbNDG2oWKNg6vNwRt6wdttns=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5852.namprd10.prod.outlook.com (2603:10b6:303:19c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 00:32:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 00:32:46 +0000
Message-ID: <a3b5a1eac6287e6faf8ec253f903bcfdd554e9b3.camel@oracle.com>
Subject: Re: [PATCH v1 16/17] xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Jun 2022 17:32:45 -0700
In-Reply-To: <20220616215437.GF227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-17-allison.henderson@oracle.com>
         <20220616215437.GF227878@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:332::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 905c98fd-519c-46cc-8840-08da50c210e6
X-MS-TrafficTypeDiagnostic: MW5PR10MB5852:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB585245E52E494FD9078E949495AE9@MW5PR10MB5852.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9H1jSCi65ZWl4iICiA0yluFt2OWaSTbwNRpcowzjiubijeBZtxSl8MsEDZNy+jqn0xgtEM8YkkZ5wV2RVyD/WZ25T9LB79nHUg5C5INya+qxMVG0YKNk9tsktGiU+BM5MTqzl/9kvqyF6T+sANqNYza47yB1XK/GrpgXh28hBqDR4j7o9e9youWf6Lzv6YycePShiiPISqBHsOP5MiqxIUeOzak9bPUJ/hi1rlwglSbmejf02seYYCNVXLYFnbaKzTaDmfcgLMfPOqvxJIjKmyjwJMcskDdI7YYb9kYX6u4OtyRwuyuOKwMxIwrRxU2qxzgLnLbeJdza3+nTBIRo2IN0fEPtYNIWe9TX+E8ZuizG86nZEVp3E2sndfIBVg3rlqJHUWaI3klkAdS1eNMcCgEGmeg7QTmtyRWTiNe8UKhkX9iM+HR2ZEos3UIDcmIodXkSb2T0Pj0WEBdvzjcMBsop7BiY+mBXvU3G4tLQyRblFlHbas+fhH9Zlm1ODu7gDE31u1wQri9uqrD713cr4UTorZ6NlQd08K3tIv+s/Le/PER+HH2mUoXoLTMP/yUg2hcWrflg8dTI4JiWM4hNrq9Zx2BVA+wB2h1dXmlX16i6rF9QS2JFylAOIHCs1SeiKQrKR/nsQ6wTv8PavQifi+S0aq/DHGO7yC62zNQ0mV8tLFMRNnlIQ5P1Q/+TCQ5WRmp9DuTQDlm4FI9Iew/yEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(5660300002)(8936002)(86362001)(6506007)(6486002)(6512007)(52116002)(26005)(2616005)(498600001)(186003)(2906002)(36756003)(66946007)(4326008)(66556008)(66476007)(8676002)(38350700002)(6916009)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHZOQ1FsRnZlODJGblNaM1Fpb3g3MjJzMkE1QzRxZGdkQzA4d1lSbG9Fa3gy?=
 =?utf-8?B?VTFhaFdqcXJMMEZaOTJLaGF4VndPSC9kS1FtMHE1N05xOHZVZ0JYcXl0cWlX?=
 =?utf-8?B?U1BWTDJnNnZwUUU1eEFvc1BoQUxWTXl0RlJsV09CcFNkZGdpc2JZb0xCZ3M1?=
 =?utf-8?B?RFU1cU92TTkxdVp4cis3VnY0QitrcjZZeGVJSXVuemxDMVluMVl3OXNWRW5u?=
 =?utf-8?B?UklsZldYTUZSOGlXSlVoT3RoZVpGbHJYd0xDQkpZZU1oWmV0bmRHa05SSmd5?=
 =?utf-8?B?MkNaQjN2cHJRRzJDSSt1Q1c0ZHBSMS96WlVmd1ZpNEdtRUVQL01aNEgyNGF1?=
 =?utf-8?B?UVhBMlFwZGxnaUNQRXN2TFA4ZEswYUh2QmU3Y1NqYXErK2J3Tk9TZWl5ZDhs?=
 =?utf-8?B?bEZPS0pWaC8xN2ZpMStXM1FDYmtJT3k2MzFuU1ozeGk5dXlHWEo3QzAxbXZO?=
 =?utf-8?B?enVkWW42cGZLUDJKM0hvZTByU21GRTNBZzg4SkZIazRnOVhlUzRqd3ZBRjYw?=
 =?utf-8?B?eGVHc1kvZ0xyeHc4RHNzTVB3NGVSWE5oK01OSjBMMU9tMjhxZjkxcGNEMGlV?=
 =?utf-8?B?eWNoOVRZYVRKejJGamYyR1doRGZYN3llK1FzM3FpUG9hd1k3YUdXTHFJZWZj?=
 =?utf-8?B?RXlCL201TkdndllIMm1Ta1FGSDgvMHBrSEZjY3U2M3JHTGhMZzVHTXZ1akh1?=
 =?utf-8?B?Zks2VmswdXlpTTk3WncxMGFFMW1jazcyR2tReWhnak54a0YrcWh0U2crOHBa?=
 =?utf-8?B?OUFIRSsvdFpNZi9ab1hYRjZ2Wi9hd1d4WlFnRmJwUG42WkdkUS9PRW81Y3Z1?=
 =?utf-8?B?aURPY3NwdmkrdGNGYnI1Q05DMzZHcmRJSG5KTEVxbFNsQ09VRlZ1aWJSUWs4?=
 =?utf-8?B?RFBrUCs5dU9DOWJ6Ni9BQmFMaUVMb01jM08yZjhhN2ZWTDEzRThwRzBwRWpl?=
 =?utf-8?B?UXFkUE1NSkJmY0dRa3dVNkYyZXUrcXlUT1p0Zi9LQXlGS3YrRnJGdEhaZ2Ru?=
 =?utf-8?B?MGNtMTNQMGx6QlhNajRCZ2l6bE9DaG1qQWo2UlZsejJWN0xid1UvMnRTTFhW?=
 =?utf-8?B?RW54VUozRTFsVHFCYVVraHpGaWJ2QWVFNmpFaE5UQ05NakdLd2hDYnBJZnhG?=
 =?utf-8?B?aEcrWXN4ZEQ2RmJuRm1CemFPMDhmVW1oeW83d1lJWHpBSVJqN2Nsa2MzZFBw?=
 =?utf-8?B?YzhTWU9JeG9ncDdmd0hxLzdjbzh1UHlxMkpBaDJtRUVLeWEyUUxRWEpKV1Bj?=
 =?utf-8?B?MmR3UkxaeHNHZ3dMTDJWSG43Mm5DRWVieWRPQ0xkT3o2UnRYVjBUdUxyVkta?=
 =?utf-8?B?UGhLTWw5ak5uWkw5T0VwbENRN0ZQRk1FM2s5elpIc3hUNU8xV3ZKaFBqN3Yz?=
 =?utf-8?B?R1QwT2J5NFNIaXRYWWU0Qk5xNllRbCt4NGdJeEJYY1BxUEF3bTRoVnp5MzNY?=
 =?utf-8?B?cmh6Szh3ZTFqUkl3bTlwZHBoMGhPWkNPektUcFF5Yy9wRk50Ym5ZdUJ2Vkxz?=
 =?utf-8?B?b0pjVmU0bnZNTDQ0NXpvWUNlNUYrVFI1R0E0THRBak12OEJXRDBydVVaS0po?=
 =?utf-8?B?cjBkWEJBOG5HN3FzVkt0TzQ5ODBVYmNVK1luZ0k4MjZOb2o2dktHZExRdEho?=
 =?utf-8?B?NkJkOWl5OXhHalhNVjdkb2RxL2RLaVlrcmVpK3pVN2ZROEhybFU3U0dDV2tp?=
 =?utf-8?B?M241R3lZNUpGNlpoVDlKd0hYT0JzRmFJZFhOaUc5aDRoOWdpVFZraGZ4Y1B1?=
 =?utf-8?B?SnNyeTBPL1dHWitkQkt5V2NQWUlvWk5tT2ZBd0gwSnhTZUFudzd2YVFPSDIr?=
 =?utf-8?B?Slh3aHlVZVo0Q2xjSW5QY1o0dXdDaHU3ZE9iNHA3OG10ODVuRjN0cHZodjIv?=
 =?utf-8?B?MjdSeWwyWlVQcWhIeTdwMGdIWUNDMWthQlJRZnFWZGk3WnZqd1dzL3dvNVdv?=
 =?utf-8?B?ZkprMmh1cnNJS3daWWthdTlPcmh2djM3SWdHR1pXbTROYmtvUFUrREpWTysw?=
 =?utf-8?B?MzF0WCtPdmwwN0poOXFydmVPeVIxbTNQQ2hZM0M1V016dzBRWFBLaHF1b3Bq?=
 =?utf-8?B?V0g3VTBGTEw4alJZd0JnU285N2NsZDl6cXNFbVRTNFRZVEZMd2dxaG9qTElS?=
 =?utf-8?B?TFBHNkdieHFUSGxHRGMrUjVUa2oxSDB1WlZNeWFGSFhCQTlGUGpsUTFtRkR3?=
 =?utf-8?B?WGM5RGVUVUtMRFg5cWl5TWhJc3FtWEEzeVFEYUNYWmtrYjVaZ0x0aWhEMGdH?=
 =?utf-8?B?T1JCbmNHMTdwL3ZuQ0lvTzc0UWc3NTd2cjhDVEVpTlVzVENJQ1hGV05rTHZ6?=
 =?utf-8?B?Z1hYS3N4SzgzVWhRY2pOK21GVTR4RWNvUnFzSlZBeUV2M3hHaVVTbThMM0Y0?=
 =?utf-8?Q?NhMmrlitQoa29n5I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 905c98fd-519c-46cc-8840-08da50c210e6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 00:32:46.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiQk+Hyu/O75bl7d2AX2uoYfFulWWq6eG+1mKEmrQNXD+D49Z2AJqp7RoXYiqHRm+kTyAI/8TJ2Yjg99Rvfo30pyQWwij6U8Y/g513O9F3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5852
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_13:2022-06-17,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206180000
X-Proofpoint-GUID: QmNrUAjvw4NKrzDuckn78-3Jc3Aacq5k
X-Proofpoint-ORIG-GUID: QmNrUAjvw4NKrzDuckn78-3Jc3Aacq5k
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-06-17 at 07:54 +1000, Dave Chinner wrote:
> On Sat, Jun 11, 2022 at 02:41:59AM -0700, Allison Henderson wrote:
> > Renames that generate parent pointer updates will need to 2 extra
> > defer
> > operations. One for the rmap update and another for the parent
> > pointer
> > update
> 
> Not sure I follow this - defer operation counts are something
> tracked in the transaction reservations, whilst this is changing the
> number of inodes that are joined and held across defer operations.
> 
> These rmap updates already occur on the directory inodes in a rename
> (when the dir update changes the dir shape), so I'm guessing that
> you are now talking about changing parent attrs for the child inodes
> may require attr fork shape changes (hence rmap updates) due to the
> deferred parent pointer xattr update?
> 
> If so, this should be placed in the series before the modifications
> to the rename operation is modified to join 4 ops to it, preferably
> at the start of the series....

I see, sure, I can move this patch down to the beginning of the set
> 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index 114a3a4930a3..0c2a6e537016 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -70,7 +70,7 @@ extern const struct xfs_defer_op_type
> > xfs_attr_defer_type;
> >  /*
> >   * Deferred operation item relogging limits.
> >   */
> > -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> > +#define XFS_DEFER_OPS_NR_INODES	4	/* join up to four inodes
> > */
> 
> The comment is not useful  - it should desvribe what operation
> requires 4 inodes to be joined. e.g.
> 
> /*
>  * Rename w/ parent pointers requires 4 indoes with defered ops to
>  * be joined to the transaction.
>  */
Sure, will update

> 
> Then, if we are changing the maximum number of inodes that are
> joined to a deferred operation, then we need to also update the
> locking code such as in xfs_defer_ops_continue() that has to order
> locking of multiple inodes correctly.
Ok, I see it, I will take a look at updating that

> 
> Also, rename can lock and modify 5 inodes, not 4, so the 4 inodes
> that get joined here need to be clearly documented somewhere. 
Ok, I think its src dir, target dir, src inode, target inode, and then
wip.  Do we want the documenting in xfs_defer_ops_continue?  Or just
the commit description?

> Also,
> xfs_sort_for_rename() that orders all the inodes in rename into
> correct locking order in an array, and xfs_lock_inodes() that does
> the locking of the inodes in the array.
Yes, I see it.  You want a comment in xfs_defer_ops_continue referring
to the order?

Thanks!
Allison

> 
> Cheers,
> 
> Dave.

