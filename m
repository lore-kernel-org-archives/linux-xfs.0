Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582D3C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3985A6023B
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbhI1Js6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 05:48:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21600 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240011AbhI1Js5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Sep 2021 05:48:57 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8W8Ok000445;
        Tue, 28 Sep 2021 09:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oS/h5Z+AhU+LQIJvljhZAUrwk4PYD7JUcR2sPUqOL/c=;
 b=Rs2HNaBZjaS/wYafMWCeusCaXEr6u+9dMUJqPTu+yadRDS/Q8A3ZIYwukBUzm4XcQkdG
 tMjnQXRykt0Yr6FfEyCnnNN7WbI3cAB28YvWzDYX3D1C+aU7UmGCZwJjwPCqYdc5BCn3
 GC0Tcu+UB+uvvWndPap3g5DBvNvJl1+vkBNI11WvqSmyh/8ywP/pNy5No7EfPq8kLqtA
 U7/QsxhK/WSE7eDPH9bxXPyhj6BVY5mPiihoz35gy8ywaXC5s/o17D9mbv033J+i+PIu
 lMNFS0TxzKGQbPqVNMnxXL8G82Xv5knMA08WLkfT0WYVrPFpt6f5qrmuLOfCd1fNzf/c 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbeu16vee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:47:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18S9VNLv010330;
        Tue, 28 Sep 2021 09:47:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3020.oracle.com with ESMTP id 3b9x51ud11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:47:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjSNkSlkf1RU6JsVZerSYf380+dP/sKHtAPm5JdFcaklLdvdlKxJAzIg9sckUKG3WuFY71h6bMKj9tjXXLivn+ZgJlifliTv7SQ5MX6Uyb+6wgC8BlPrpajCKFPyx7k3Pw0D8NDDapxKyK5PH4ZJqNpXWLr2ZUJimgGAld8q2ZTAQAu3fJjsqDvTtpqVURiCrsL4mOaY2lpb9oqdVhIni4XryzhbpvhPExkW1c5emfrQ0U/KZvmBEQLjgrNF3gqRvWnIo/BIagiw1MyraBpc3qqhDUFrjrjE5ZVUl6gaaPVEEJXcE7Xn9ch+5SAwwFMYb4Rrryo0TyCy9VmVBNfeYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oS/h5Z+AhU+LQIJvljhZAUrwk4PYD7JUcR2sPUqOL/c=;
 b=DrEOdS+JfEZKGbzO1MaM4fG0CqwnjWwJyopfLMGQ4FvMdhzLUs5bh3jHgsh+22eh96f88n7wxfQfB0lBRXdCH8OVdCQ9l0dwputPMUtSKfUEesYY4mGXYtFGF0xvBAZYjDr8+9LsWORKAFfdf7EO18Ji9OSw9g90an8wVCUOxTPh12ymn7r2AOjs4deVMm3PPW+EvMlpbvdPOz7xYAsYJPLYbrRSi6nlv+5Bk6g2i/VP1yfQsFGDA7jo/Ig0afyc60mr+NJW+Sn93XLGfABoj0p5l8ThExKYelYTqKrNmOAvJmfWKjugAVGQh6zOinhD8bGmdlDrQfDDNkt+BQ5Hbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oS/h5Z+AhU+LQIJvljhZAUrwk4PYD7JUcR2sPUqOL/c=;
 b=gBsH1E/8MFvOoT/FfzXYZvx5GrAx204sx18u/xmJ03hgeGaNuXKP0kxbvpuWSHN67igJvki93Yziq9hHtdZg+A7R5aMOSwJ4ZLxXqcqnM1bE1ujbn//tTEPU16zYTFdKJ/3N0NB5gnpwBCEOuA2dQ/qu0b5SrFkW8qAwQqGmRBQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3053.namprd10.prod.outlook.com (2603:10b6:805:d2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 09:47:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 09:47:14 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-6-chandan.babu@oracle.com>
 <20210927224649.GK1756565@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 05/12] xfs: Introduce xfs_dfork_nextents() helper
In-reply-to: <20210927224649.GK1756565@dread.disaster.area>
Message-ID: <87a6jx117w.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 28 Sep 2021 15:16:59 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::30) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.171.129.29) by MA1PR0101CA0020.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Tue, 28 Sep 2021 09:47:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42de222d-6ee8-4eea-0456-08d98264f332
X-MS-TrafficTypeDiagnostic: SN6PR10MB3053:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3053BA029D03EACFFF321620F6A89@SN6PR10MB3053.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lokimsBnJDV0bsN7MmRtsECcF7GNn72geTsFAmiw5vuOQP4IbKtSocMYRoRKIjW/FDtpC4pbXTkEjLnS+j1LpuRDmM5tXwOa5GoMVkMp7qAsmJINaGxjQQoItJEMWR0QFVCx/veVfaVQU7zsTPUSkghkTquL6IBUDR6+UgO+AHxS4jmt/s2vuXs3tvE9p6YgvDSSHZ2n+PH8AvqJJZyxNFAcUPC+cTfnqaJuLD7Pw52jW1TvaMtuVwyx020slKPBy0l5Dw/d/FqYfu40BoOJpg6CfdYcLNAfc8SsRo+Dt7aFrCYKtCHue1lMEVaGqFsJ/3gorBiEIWZ5+LNlyua1WGERdLnieKWWKeGbT/I+ED1IZ44E2Pyrh6cIh3VxfX/ZHIwe4z69ZX6DO58BFtOkS78MfBMYaDmTmAXnc52a1h8Y2tH21+yA1T0uRGlCmEXFuMQ7QwEZtWHRpRygrmgRAHV/Q+1ZEi/uYYjnCen5wWHnsWldgbf38bVgC0UuJK/T7X0nqQ9pKW1P4ieuXSMjOg2fGgLJeZ1X1gi8wULmrBWD3RljOcEPIfkGRRJ9EFaKcJ6E7i78E/bhUCWyDUOZz4TSdshlqtDUN2a2rd9jaT3IZXnv772H+Hk5UU0YN4M8vaxEZz3+G+8+IEMIgZ4v9LoUyc811EOr1FW+s5IbNEYm09iurcij+W9qRDOVZjoFWxDQUHOXFmYzg7yUYhBrSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(6666004)(6496006)(26005)(52116002)(33716001)(4326008)(508600001)(8676002)(956004)(9686003)(83380400001)(8936002)(38350700002)(86362001)(5660300002)(6916009)(2906002)(6486002)(53546011)(66946007)(66476007)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nmlEwDlKS0X5OF5qnfuOqViIVwJch4SByvcFWKFwkupGvSaUBhYqUkTsB56C?=
 =?us-ascii?Q?FBWKPheOR5jvy6HrZAujuoAObbirmpIyox+AhP+o5p82Dka69iktysS5nR75?=
 =?us-ascii?Q?I8pwv/d/YcVDFC24ImUP0YnJL4uAGiKa8VVvPqOOwNkkEnHaqCH4gQrMlccG?=
 =?us-ascii?Q?/fw3s3U0Qoe4I/vSePxU9mrTcVeiJbSFFgrEAYvM2P5OgtmJnCNh1u4yTXsy?=
 =?us-ascii?Q?0b5Nw5OqW01IMkVzqfzQBzj7uAHG0QdydzF8vQqcbZrEhF373skyVRZCrS5M?=
 =?us-ascii?Q?hKySIlAYE3YKGqlVlWp6xIzfJI5dsKYRXpg24aGGt8JudO+thueceaqcNUbX?=
 =?us-ascii?Q?EyijSHP1bel471Wm6VbVAysH8+KA8PvvXXW2N45FBhkZcMqNeYsbu/pW9eOr?=
 =?us-ascii?Q?KlNc3F5xL6QmyaECAHEHS+2Sg5Uzuha6cB3vwIYewlowbf7FsRWKRfU+oHu7?=
 =?us-ascii?Q?cWtQX3Bkf4ssTiKL2fUg5n43JoRMjV6ynyemjOJl9VWZaIs0Tw3fbmzSZ366?=
 =?us-ascii?Q?/ihyV/H56iDvIQq0W3Y+smPcBewufQncd4JcwF+Cj/JZgRbfTS/QOxcrL9Ah?=
 =?us-ascii?Q?H9OBII0X8MAsfTq5AoDyqmLfQhN734Z+2AAUn0ILf7dJK4bAwcxTDc+IaGgb?=
 =?us-ascii?Q?zSHNIdD6vsUKMB9OQFlC5ZHucd7Ybk4ixeE4FV3toTcJZ0fvEWjre9tO0akh?=
 =?us-ascii?Q?rvJMtr53LxokR8wQlpVMsTI9lV2xwVIJav1e9IDF/wfnE6MoPNRsyU/n/GIU?=
 =?us-ascii?Q?cpGAq+oAdhb6BqXSB/xTcDntfTL/8pQE1SeuU06qTqX8YvZH76q8cW1Q8C3K?=
 =?us-ascii?Q?KfYAozNImGFtTccILSHxGItuF6NguGLxZy1FdsWxDruu9rDv1BBUVJP1UyIH?=
 =?us-ascii?Q?PBuUoZeu+SV7Bf20YKuhDs+etlSHK1NAHn0UzoLkya3yGhyZTqTwzhm+qEJH?=
 =?us-ascii?Q?V8OW+tvUIubDu5U21AnQDJkctzML+NKZhTuqql02B/3UGECGXnhA2/ku2PK7?=
 =?us-ascii?Q?GTSru5AGt+N11SPLLW3IHx+JN095sb42FtLVsa83NKTvR1qCIriiP5aIxzDc?=
 =?us-ascii?Q?RX0f7fwDVB/t0tnK6KPzRioG7hmS2WO3beaB9W+8TGqOZdjXhBNNACnvWWOb?=
 =?us-ascii?Q?D9j1SsfcjdNfM2jevU1Txlq6gQMURd3bXYnJlpyj6lO9r+YN0pFhvUQ13+Ol?=
 =?us-ascii?Q?lXAES/PLt89ME+YGpkY58kOaiG7uU44aNBzo0gQOYvieZpD0C9m7JY4IWEaJ?=
 =?us-ascii?Q?YhguFrUpz7pvOr5E9DHcUEKesURXCyV6OHTwbf+GDYe+SxirMbpCY2muwsYB?=
 =?us-ascii?Q?iIWT74oPnBNfW1XvfrRp5w2Q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42de222d-6ee8-4eea-0456-08d98264f332
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 09:47:14.1552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAwEX/94KOgmu4423TGPYWtQa2YkljbA+lwizn3I38MtKIBTAku9MIRwD2MGeQMLa5AxdUTHfVCV9FPrRht1Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3053
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280056
X-Proofpoint-GUID: 2nxpRiQgQsx_B5Y0MTcw4Gtglhpm608M
X-Proofpoint-ORIG-GUID: 2nxpRiQgQsx_B5Y0MTcw4Gtglhpm608M
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Sep 2021 at 04:16, Dave Chinner wrote:
> On Thu, Sep 16, 2021 at 03:36:40PM +0530, Chandan Babu R wrote:
>> This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
>> xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
>> value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
>> counter fields will add more logic to this helper.
>> 
>> This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
>> with calls to xfs_dfork_nextents().
>> 
>> No functional changes have been made.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++----
>>  fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++-----
>>  fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++----
>>  fs/xfs/scrub/inode.c           | 18 +++++++++-------
>>  fs/xfs/scrub/inode_repair.c    | 38 +++++++++++++++++++++-------------
>>  5 files changed, 75 insertions(+), 35 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index ed8a5354bcbf..b4638052801f 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -930,10 +930,30 @@ enum xfs_dinode_fmt {
>>  	((w) == XFS_DATA_FORK ? \
>>  		(dip)->di_format : \
>>  		(dip)->di_aformat)
>> -#define XFS_DFORK_NEXTENTS(dip,w) \
>> -	((w) == XFS_DATA_FORK ? \
>> -		be32_to_cpu((dip)->di_nextents) : \
>> -		be16_to_cpu((dip)->di_anextents))
>> +
>> +static inline xfs_extnum_t
>> +xfs_dfork_nextents(
>> +	struct xfs_dinode	*dip,
>> +	int			whichfork)
>> +{
>> +	xfs_extnum_t		nextents = 0;
>> +
>> +	switch (whichfork) {
>> +	case XFS_DATA_FORK:
>> +		nextents = be32_to_cpu(dip->di_nextents);
>> +		break;
>> +
>
> No need for whitespace line after the break, and this could just
> return the value directly.
>

Ok. I will fix this.

>> +	case XFS_ATTR_FORK:
>> +		nextents = be16_to_cpu(dip->di_anextents);
>> +		break;
>> +
>> +	default:
>> +		ASSERT(0);
>> +		break;
>> +	}
>> +
>> +	return nextents;
>> +}
>
> I think that all the conditional inode fork macros
> should be moved to libxfs/xfs_inode_fork.h as they are converted.
>
> These macros are not acutally part of the on-disk format definition
> (which is what xfs_format.h is supposed to contain) - it's code that
> parses the on-disk format and that is supposed to be in
> libxfs/xfs_inode_fork.[ch]....
>
> Next thing: the caller almost always knows what fork it wants
> the extents for - only 3 callers have a whichfork variable. So,
> perhaps:
>
> static inline xfs_extnum_t
> xfs_dfork_data_extents(
> 	struct xfs_dinode	*dip)
> {
> 	return be32_to_cpu(dip->di_nextents);
> }
>
> static inline xfs_extnum_t
> xfs_dfork_attr_extents(
> 	struct xfs_dinode	*dip)
> {
> 	return be16_to_cpu(dip->di_anextents);
> }
>
> static inline xfs_extnum_t
> xfs_dfork_extents(
> 	struct xfs_dinode	*dip,
> 	int			whichfork)
> {
> 	switch (whichfork) {
> 	case XFS_DATA_FORK:
> 		return xfs_dfork_data_extents(dip);
> 	case XFS_ATTR_FORK:
> 		return xfs_dfork_attr_extents(dip);
> 	default:
> 		ASSERT(0);
> 		break;
> 	}
> 	return 0;
> }
>
> So we don't have to rely on the compiler optimising away the switch
> statement correctly to produce optimal code.
>

I will fix this too.

>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -342,9 +342,11 @@ xfs_dinode_verify_fork(
>>  	struct xfs_mount	*mp,
>>  	int			whichfork)
>>  {
>> -	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +	xfs_extnum_t		di_nextents;
>>  	xfs_extnum_t		max_extents;
>>  
>> +	di_nextents = xfs_dfork_nextents(dip, whichfork);
>> +
>>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>>  	case XFS_DINODE_FMT_LOCAL:
>>  		/*
>> @@ -474,6 +476,8 @@ xfs_dinode_verify(
>>  	uint16_t		flags;
>>  	uint64_t		flags2;
>>  	uint64_t		di_size;
>> +	xfs_extnum_t            nextents;
>> +	xfs_rfsblock_t		nblocks;
>
> That's a block number type, not a block count:
>
> typedef uint64_t        xfs_rfsblock_t; /* blockno in filesystem (raw) */
> ....
> typedef uint64_t        xfs_filblks_t;  /* number of blocks in a file */
>
> The latter is the appropriate type to use here.
>
> Oh, the struct xfs_inode and the struct xfs_log_dinode makes
> this same type mistake. Ok, that's a cleanup for another day....
>

I will add this cleanup to my todo list. 

-- 
chandan
