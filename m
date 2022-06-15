Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7234DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 22:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbiFOWcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 18:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbiFOWcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 18:32:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EC049258
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 15:32:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FLpTSN029747;
        Wed, 15 Jun 2022 22:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0mDEsb+dObO0vYQ3aqiIAyay9SmXGIBvF6ilhp0WNXE=;
 b=JG0ZbSMd6FBj2K0st+bXkS9AxF3GsIn8uhd/qkmGXp4CXdOTJOqt2A4z+9PYXb4CmAS+
 vVetpBwnCS3Icjc+J+FJHPwkxcUKFb/pLed9VjOiDMDy1obGzwWN+pT5ZOYBXCEnNIg7
 hJqUxiRlIa7s0JcuZWhL2WBgFCxJOsJKY4XT/5+ZIQ2kURTh2pDRT0BOFxVs2ssmZZ/r
 jxDImGSOspTejcF35fQTMCgzriFmGYt+8pNzJWsgsvh9jvQXor5N3x8Q5crwxGj7iZ0B
 wCoFcfrUsr8w69RkCzCZsGurrcPz3l56Ackzz0YL1ggjlBDJFy1bQGEa0WaBBq+5Wjpk hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9hjr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 22:32:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25FMG0lk024567;
        Wed, 15 Jun 2022 22:32:10 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr269b9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 22:32:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnD0McYejUBIccLol06jFPJiZhvw3fCSzd6YZATg7n5LlHz77U9ZHQ88/GkbBsC+2CWFJAJ6ILb0JN0MeUt+HMk5Y45DDgWk8ucbFJfiPgVJQG42GuUuVi2twQ0qpoiI/vWo1NLLrir4yQbOYxjtXoRck8ekU32dDoIJ7SuatCAKl6bK3JuLfCRc9MmmQIOvQO+OQIaKz9pBwI4nmV5LPTzd8fC0Vz4ZK2mjMG02E5SIYFeDWgmxHoBBG3cCp1/geJjoWedvpNfgdjB0Lv0Dl62jEkASbg4aNjJBTmhTyplooTiuGJYEyBn/qxlj0SpV3i1oSaCFM2xOH2NNRH9tuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mDEsb+dObO0vYQ3aqiIAyay9SmXGIBvF6ilhp0WNXE=;
 b=lIsUaYtkZF3n3ygwCixEqkoqCW1kse+JVjf07DWuErJjSEjR3GEslw18iOWDnspZEyK7vesjyaO2fgeR0d6GM/6ZIBfy7ytGkHXhDkd6Z4GC9t5VcUblFggkbHuzCZpyUTsnW0xrneENwomKRviz0tzLESZI8X9LFBNt8laubk7D/ybFksVo/Uuq6mrrBwLsmKpmJfR85HOv2+rTLmq6ZY0daAFy5NtXojhtnCMJaE9arwYkjEKrf20VPMIdRd27IQPbJ89Dbhloa15tkPHDUW3joQpNWQ9fjsGsxfxlbCNiI1LGbyNwKqIfVdNVj5PxC+MADTcCoWU6VaEf+9w9Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mDEsb+dObO0vYQ3aqiIAyay9SmXGIBvF6ilhp0WNXE=;
 b=CspSSWCtSvJDFOzGIB87zIHn+9JiOCAsnHzkMCVXMNFPJkge+pwALt4ePb+c8oJxnmotAC9GqLrFU47Dkl1c2JMMKHY1o+FymEMu6c+fm9dq2pH1+0b0R6hTFTHDDHCI0+5nFb90r55EbBHKL+nuHGcjisMosjtYN+LC8xfhx0Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5141.namprd10.prod.outlook.com (2603:10b6:408:125::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Wed, 15 Jun
 2022 22:32:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.015; Wed, 15 Jun 2022
 22:32:07 +0000
Message-ID: <197b0440720e538e59638c0633cdf0afd0e7e97e.camel@oracle.com>
Subject: Re: [PATCH 3/3] xfs: preserve DIFLAG2_NREXT64 when setting other
 inode attributes
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 15 Jun 2022 15:32:05 -0700
In-Reply-To: <165463579982.417102.16435790324978634359.stgit@magnolia>
References: <165463578282.417102.208108580175553342.stgit@magnolia>
         <165463579982.417102.16435790324978634359.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e22afc5f-7a52-4aaa-763b-08da4f1ee166
X-MS-TrafficTypeDiagnostic: BN0PR10MB5141:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB514196E979A02F2CEAA7624E95AD9@BN0PR10MB5141.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dvL7Q/VM9sD1cBuPMh+HRX1O2kgyoHYmjawJQeZ4WRhRBl1PLhPH74lMZ9gBetrNOhZ1HkuYd27rdlckCCFkGWjpZGdAL9GHpdOSPFS+YgpAzhjXrmWw1y2Oy9EY84ondyiz8lBe1csEur9UYGYCCUHLJiOhInhBKfYFDEvI2zwT+j6aTEFphj9nAuEdAnLVwXV+A0/0i7WPz5wjUeDX9crHgfSH+rL0ctq9BnxJ356awcMi4oKinPYtpNRaL6h54u5zaY5OFlgf6LgVBCReFBEqOHhqI5xwTEPtbaGsjFuILpMQi95NkwPtvEycsT/fQYbqXZ8ZkU06s6qryByI77fq2B/C9QAv96JirNgixMMQest3E/K5MQGMQYC5mZtpSTzXtDhopjDktUk65In2gB0ECexBARK4CsFjCZ+lZrIKPwRDvap5+F0WwqgptszLNMfZOQh28bTcK+3I4uhqMymNO9eQToXUVeDNXvzkbycXgbHwOEMWUUlp1m5aNf/nIrTxchYbwPtXTiPURWFKZ+MZalmmjmtRkr31hTX233Ii4v6+/Elw+rBr/DLAXQ8I2qM9Iw+orDpWYspaHnyV09114a/mNp8m5kUBYS5N4no2y3T6DJhqVunFQwUN/vLPIoxG8I8FmMoYrBGVoWD6I5kzcMN3Qw6TyKTW+rUf1r0VYi0QUBuMCsSRIIxVGbMrH7JM9PGrgIWBrqvStgn5Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66476007)(508600001)(66556008)(8676002)(4326008)(8936002)(66946007)(5660300002)(36756003)(316002)(6486002)(2906002)(54906003)(6916009)(2616005)(6512007)(186003)(52116002)(86362001)(6506007)(83380400001)(38100700002)(38350700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0hFYytXQUFXY2JkWHBVNzNpYVR4endscnNGNnZqM1BRQ2lNVWpQUGJOd2F1?=
 =?utf-8?B?SmZnb1h6ZGljKzFTQk56djNTUExMcEltMGI4VnAwdndpQjNrWnkxRkp4Zk1R?=
 =?utf-8?B?ckZyQWc2MEptZ2liZlFXK256SEFYYXRTQjlvWVdycm9XTnROTU5pdFZlUVB2?=
 =?utf-8?B?dkt5S0RESzF4R3R3REovczMyVFN5VDlEbnVvMHljVHVFMG44WGsyK2Jja3VH?=
 =?utf-8?B?dHk5ME1KUXIzWVFnT2VtNEYySnl2Wlgzb3lwSjBsbndyeDFXekxPM2M4dFZt?=
 =?utf-8?B?elBMNGVOaU5uZGNsV1h2WTBNS1ZKU21VdUkyclFnMHd5THdqM3AyNldwWWt5?=
 =?utf-8?B?Q3luTGJUWlB4SjBncXJLWTdORUV4Z1FOckU4by9OQkxHRm1ldWh0anJQYlRR?=
 =?utf-8?B?S3M0OHRVdnZObGVzQWhEMWhjVk5EbDBZWENDUmowbk5lano3OXFNanpXc29y?=
 =?utf-8?B?Nm4zNFg5cS9jbkNpNXRnc0dKVEhaRlkxN1lGUS82bzlCVEh2Qzl0V0VpaStt?=
 =?utf-8?B?cXlLbk9OYkx4aWd3eUdSZWE3enNtUGw1WHB0Y2hCVGlHTTZ6TjZKUUdiQ3RL?=
 =?utf-8?B?R2FFQUIrU0JkZTZ4ZGRHVTROR0ZIaVhlRFA1b0FTSWZEQ3ZabFV2akR2UFY0?=
 =?utf-8?B?RU5BNnd2U0Y5V3p6M2w5S1BzaTduMnBxN3ZrSksyU2NFRy9MNHVJZE1XRzVa?=
 =?utf-8?B?UWhHUk5rRUplWXRHV2hLWmdOVzdiMXFzeFhvRk1YbnkybkVlUGVkWEJZSFUr?=
 =?utf-8?B?bVFiS3Q4MjRhQkVDTUFhVmoyQkhoWFRNNkViT0FGWk1jb2hXQ2Jrb1NCMkxi?=
 =?utf-8?B?c0I4SHU2RUtLb1Nrcm9BczgxUjZjVXdNL1FiQW9jekdpaGQyNWNoaFhTRnB3?=
 =?utf-8?B?QlZGdjRHZmNYaExRZnh2NU1uTVdTRUJKNk9EWnFDeldTMkl2aGZwLzl0SHgw?=
 =?utf-8?B?R1BQdGJBMDVheFRoMGdQMkcxcjNXV2VLbkxjSDVaT1dDYUpLK0RZcklucTli?=
 =?utf-8?B?TUJlVTBGMjNwZytSSkpaV0QrYVF1bDVNejEyb1hVMDJ5MENpVVJsb0ZZTGoz?=
 =?utf-8?B?aE9sNHJ1bkcydFIwMm5vcmZTYTdOdUxkZ0ExMFZETXNpY2xxZCs5dzZueWU4?=
 =?utf-8?B?M25FYXFjL0lKRGNXUU90eFB1c1hEdkEwN09TZWxRWFlpUnVvOWVobnVMV0xY?=
 =?utf-8?B?RnBBQlZ5RkJUdDVVWVFxRHRKVXhTMy9IcVJIUVJqYUFmK0xndzlaMy9oYzVs?=
 =?utf-8?B?WHV5Y1N0RkwwNFlkYlNFblowWk5LNGh2WllSNWFZTS9PUWg4VmRKbVBEMmpK?=
 =?utf-8?B?NU9sd1FxTVZ1WTNLbXZ5TC9YZ3VKb2RmZEI5Vms2YndtUCtaV0dHbzJMS2Uy?=
 =?utf-8?B?eXVPbC9TQmY1VFB0Z2ZLdjFBcDBSWU1qYk5VYzFHMFg1NVZRUVNWZkZPQnRM?=
 =?utf-8?B?YzV6MEVTR25YR21OL09pU04zaVhnSUhQOEpPYmZFejlOUWI3dWtmcTNXR0ZN?=
 =?utf-8?B?VFNpYXkzaEtxWHgybDZaTktna2QrODVlWUNETWNQSzhNeTk0VnNRUFlNaVZ3?=
 =?utf-8?B?UGdEaFNQWjZVK2VQd3ZOeFhHaDh3K3V3YTZYcFRUOXhPOU9heWJ3NjBmWW1H?=
 =?utf-8?B?SGhBRFBtRGtGMnNBUWN0S0l3by81MHlxdGhDZ205MTFKVXFMUCt0bnhWb3ZV?=
 =?utf-8?B?SDJtaTZiMFZJRW5YMkhjK2lxRnFhajhaMnl2ZlpZTkpHM3RrMnNHTzlYRGMy?=
 =?utf-8?B?eTlqUDhxZUJjK3lzb25leHBWb3F6V3JjN1IybWRSUW5OSXFYODllU01STXpS?=
 =?utf-8?B?UUQ0dzhyODhkR21aNU1pdHIwaW5xRy83UE0xS2tPUXdKS2h5dU5YeTBqRkgx?=
 =?utf-8?B?UUxiNWFKTzNVWk82OStKNGFia0hVNXdIL2Y5OGpFSXpyd3dGVUg2Rkl6N1hx?=
 =?utf-8?B?SFN0S2tsTnQvZjZUMk9JZVNEOE9IMitsMk9kKzU0Ykc1cG5odGZ5RncrZURo?=
 =?utf-8?B?NmNFeHQ1b3gxTW5GbEhTd29CSWtuVEp2ZHNxQ0NjYkkrZjVaaHFKeUxxQVdo?=
 =?utf-8?B?YzVDK2J1a0swN2w1YURXYnJrQi93NFN1K3ZVb3JJT1Vnb0N4WHJpejVsTXJo?=
 =?utf-8?B?T01ZbDRHWWcrRUxZaG5HMnpiT1JBMzlQbEJXb2FwR1ZYZitMbWtlWnFpSVdL?=
 =?utf-8?B?SHkzeGI1MzFsOUVTd0JIQVc0RVJHaUMxaXdGYnlEZUlmM2h6Q0p2NTFPTnB2?=
 =?utf-8?B?RWtBWFBXY3ZRWlJZUjYrQXFrcEd3Q0pUOUkrcDBGcHFuRnBzVVJFTjNNTUhC?=
 =?utf-8?B?WG43U3lJeW45RldveE9jVFRNa3FDZTJLWVU2Vmo1aXJKK3JlbkN6Mld0ekZP?=
 =?utf-8?Q?6W+RtTVAA51RkC1E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e22afc5f-7a52-4aaa-763b-08da4f1ee166
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 22:32:07.6641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BHQIiqr6MlZa02bYOkFWF1BzJsjGtiE5Cotqeklbp+vLttIeMjAgDoTH4BKcDdDhuveY6Ln3NrNnkEo+rQLrcehrrPzAqa8t2+OjQnX8xZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5141
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-15_07:2022-06-15,2022-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150082
X-Proofpoint-ORIG-GUID: YcuQ_aeONCZz-aGFw5UCljh-5kc1N69R
X-Proofpoint-GUID: YcuQ_aeONCZz-aGFw5UCljh-5kc1N69R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-06-07 at 14:03 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It is vitally important that we preserve the state of the NREXT64
> inode
> flag when we're changing the other flags2 fields.
> 
> Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and
> associated helpers")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5a364a7d58fd..0d67ff8a8961 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1096,7 +1096,8 @@ xfs_flags2diflags2(
>  {
>  	uint64_t		di_flags2 =
>  		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
> -				   XFS_DIFLAG2_BIGTIME));
> +				   XFS_DIFLAG2_BIGTIME |
> +				   XFS_DIFLAG2_NREXT64));
>  
>  	if (xflags & FS_XFLAG_DAX)
>  		di_flags2 |= XFS_DIFLAG2_DAX;
> 

