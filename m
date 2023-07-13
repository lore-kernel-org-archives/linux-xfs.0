Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F42C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbjGMGrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbjGMGrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:47:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315C51BFA
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:47:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CLAZD4016674;
        Thu, 13 Jul 2023 06:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=l0Qsx8bOOckXJU4VjlfE78W1ZB7ZJ653uwCe19ngxm4=;
 b=lFQIqkq3gi2WC6Zznu7KWV4kKa1DhIGi+mj54opPdWhBvqymBV+Tfsany9sFiOb4RBUh
 ACskKNumDvODFvFi3W+crvwq8fyhrUR2kq1HvqvcufUMaQgm7JLadikqpZCevIDFh1xy
 vxmABgDmyfIixBxWssf/S5Hctbn1Tkqr0Lx44AeCGf006Vr5w1ulOT8m2L8PC/2MwyAy
 xJudgVco99zGOGxkxHxQzsBcahDSdw4F0nCPYN0N1mADCByB5KbsiYZuRx90AiSJXRDY
 LYSkktu2AEs47mqg1XMx3IOpMB+2YG6/K12/+KVvs3I1rESw14qifK2T/NM3nCG1HWUw Tg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrjmhec9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:47:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D6dThY008279;
        Thu, 13 Jul 2023 06:47:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8e3h17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:47:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEY+PnWrRg3wCSlclrTrXfLxsPYpHFN/Ym/06Mt1U0PmiLygVorA4nCBjdRugWRHA9ZZtuBSIdTJ2e1x35/XowzxLgIRAbA71M9eazRxnnFPhpElGwsMNAn3hKYF35yPPLyXoEgmOCsdmKvXDHovhB6Pdd5fm2sAtt+Xr/MzxZrFqZSu62xZLbIELAWFeoFMEnCC7So0ZJWAcuqtt0ZIJcnBN8Qn95cwu3UVoSdFpRURNulGl0ECJ7chCdrXRHGzh7M1/mLUwsqfwrEV3Q5A1rAcrO4vGBFP2Te6u9jSRle3IcD1oQNTcVzDL1EaidK2AxKxAOwSL+xmZGrg7wC9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0Qsx8bOOckXJU4VjlfE78W1ZB7ZJ653uwCe19ngxm4=;
 b=OU/eWxsGwiBVpAVO9B72I6o5hIo15+TVRj1FxHvy0GGEZfF78gQ/ey4DY6jX3V0oCVnyGW9aNSDVaGgLvomswXD3EiCwa5YzJEqDcoYJpTfmQBNuFra5F41wlj8gAK74WeCVTiY5ja0srWW1npOSYS+tO8YXElXwma0qWWsPrj8TXJzOD/Qx1hUFFiIV9XbkCn/MHoAOY/xAO5PXHXHhtZo4OARmsuo18Fk5zNZwuhWoYMsxhRKrdPSW/gRi9GjdY2i34vfdB470Y+799SOCBBAf5a2uIHK68rSM/AE4v+95BxY2pKdgsV0urCgFrmfD9YQXrPzUFR3jsAqMEE5liA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0Qsx8bOOckXJU4VjlfE78W1ZB7ZJ653uwCe19ngxm4=;
 b=BZQMOdV+xu91NGZEwIsMt8meMpYsqsxE/MAF4nfTBCzj7XPCYDB2P4SkBDFTLbljHJm/BZkXgg5eWKrkF8ZmVb/n+D9+RPnVaDCxsRM8tCjp5gU6p/Ys2alpuscxSQ7X4N5YCOta76Lv/KcJEbKiXF2K1CQmJ0nHppMcQ85Vn6E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 06:47:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:47:35 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-20-chandan.babu@oracle.com>
 <20230712175524.GO108251@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 19/23] mdrestore: Replace metadump header pointer
 argument with generic pointer type
Date:   Thu, 13 Jul 2023 11:38:14 +0530
In-reply-to: <20230712175524.GO108251@frogsfrogsfrogs>
Message-ID: <871qhcjojl.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4551:EE_
X-MS-Office365-Filtering-Correlation-Id: bd1ea3d4-985d-4db0-071f-08db836d0a33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ohlFfYoA0EVxM+BZs/bAfVgoetXU8VnSVbhBOC/+ly3xBuKApNvLNzFuoQ4uBXJPhGhgYk94+mgosP4p5sVppZWqqSe/abdYXj/ulqOzuGC9HX8Tga4cyn1wZrXAJeZl0yCbBQRoALcJ9MrZSkXknPyD43UNMFuUkjNw20k7UKcDnVtqyajIOKSMcmoI7cEvis2in/6i4VcvFLAbxU5LAxQYurUeadQl4EzW8FoTKwuEKKdYv6vomS2GmD9sMeK5Hvz/0jfc8cqqaHEKOe77Rmm03s4JwKSNoXp43dIQRRQ1nPr8Zg2O0uY+/fEtIRjg4g+O2OzqjXg93UpQqA4NEaESDqO9ik1qaDvMRzybIY3EAZIf+zHMr6ED3LvZLbODJfF/inM/IrNXqqvz1dPGcENtPlulXM6H5wpCaMbRlrZKp93zxtEBOKwYxmkmf558kuzbVxUCQptJqfQJPOjNwCmATDdZGBZwymNdfzJ2v34U/3AUvUVv9Qq401MdK4vMStIje+4ajuBHZc52iPlj0H0dWDAvBhZgtr/9TbK7mH/mYY4BU6J89vRd15j8DuwARLzHW/3Vrc5NY+MvAHHrjso2JwJ39hKqQ/6n5jQAakU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199021)(478600001)(6666004)(6486002)(26005)(6506007)(53546011)(6512007)(316002)(9686003)(66946007)(186003)(2906002)(33716001)(41300700001)(6916009)(66476007)(66556008)(4326008)(8676002)(8936002)(5660300002)(38100700002)(86362001)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PL2wo4lo+Tf6plh0NVJS9QAiZICcw3gaNQhHvTK+MpFpfFYUp+fR0S0ny1L?=
 =?us-ascii?Q?2VGrideOC00TN7VG+A7JO/Q1cYhoSZ+nlmrPFvCBJV+kXoqOMMLxGSzYbukk?=
 =?us-ascii?Q?VXZYbBeMwXt2kGyEEbWgHyy0aDVsD9CsCoceMgZ2iAPyQ6n/1YORAxi0nC+G?=
 =?us-ascii?Q?5sLHZ2v1Q1qj5DnUCgeROIuDKv1PWqN0k4v7Bn9s6oTMAIYkRg5P8fvQQgku?=
 =?us-ascii?Q?b4y3dwHBF1rfcvicUWik1Lujjkws0OtF88po1OFi0TRNYu9vCZLktjEhYfYh?=
 =?us-ascii?Q?oafHNJEqVQ4+quSiDhG4mH+3oxFwnQukaaAx2K5q/yGgskyQmt51ST5isuNo?=
 =?us-ascii?Q?iGrismE9Jdtq93vSWwti7GjRcQGmsXmetlvaETBTYT5EKVDM8GGQmzSImrQ3?=
 =?us-ascii?Q?8hEr6WvQC6tbfrxFHqLxLozuGXQZcV8aRz9a16bpN8HAle6PBUW1kttzwHS/?=
 =?us-ascii?Q?DsvBz/dK6LtS7LUM9Xc5SWUshKbB4JdpHw7mBhWknE73UnzqyYbB31BKpuX4?=
 =?us-ascii?Q?hfFuwnRFplcR1Pqp4WFLYh1vhv5XqDACnhx9f/AmUSXOnfFbUAr+BUeosa7T?=
 =?us-ascii?Q?Z9NVD4Et87aD/40MBH3zkt9+hx7Bb1fywD9hmudzDp1RQi1hAPgDvMCbvLVG?=
 =?us-ascii?Q?FBnIkSCaljdMhS6G1pDAzE2IqicmlmJvkXeaJzUNeb5naGCfbPAfKPYnqcbW?=
 =?us-ascii?Q?MHjohhsivG64PjFoVMzg6vdtnEeF2dafd4BWVydGPxSgJ07deEaUdp2FMbg8?=
 =?us-ascii?Q?av282L8nprtnDceUtNnAlMjLokl5qLYchuq+wHf+RDWVqF2NVg5s6qimLKdO?=
 =?us-ascii?Q?CxxI4ys1vPQJLlm5adhmMUuotxnZ6x90NyKMruVw4f7aU0jRULe+HRyUUYKP?=
 =?us-ascii?Q?u8+gGnUYl5QMp76AKMUJwDS7UvdkFdJVw2BLBXSDrywNgMCJOGhmqB05xnem?=
 =?us-ascii?Q?LqxDikH9CYe6DIDxNlDiGE3h4xY3NJ2ebmRtNhNP+WxDuzpi6r2FuiImSmzo?=
 =?us-ascii?Q?RkJ2KBGbuF3iPKBfSFr8ZdDSptl+jfQxm7bXnAEO8/O/TTdDmeyiWMweuUuQ?=
 =?us-ascii?Q?H3OnrQIv/1hofhFxludY/iuJ9oApVQ3JiQMdOa2kEKEy1UnGQWmAsLlp74bR?=
 =?us-ascii?Q?KcnjalzeU923yA3fTgGjv1kFf6INx0laVYZS8ZmdOsymEje6yfhjKx65Ejjn?=
 =?us-ascii?Q?hLd+kstGaIwIlwyDz+dIv58ziOgDTXBIiS+EYv1CvUa/1BB/BTPa8X+FwhMf?=
 =?us-ascii?Q?AQvog8GX/cvMJ2xyBVbY8sLEv7iSfS9honUZtiOhVVNCNH3fVj2aBqW1fICQ?=
 =?us-ascii?Q?Ni+n/eXOvlwqpv8DbryS996Y7RX64AP9cWgOjhD30n5qBxh9G7fn3/UbFPmR?=
 =?us-ascii?Q?tKOo6EOdsfsBfu01T66wtO5xrjZwlx7IqzcNME8JbVNW9PWn/zW3yyVYTRW5?=
 =?us-ascii?Q?/RiZFqHlss11fBEFsGPCieQ2nkJ7w0xtpTJwqEHC+T0oD5IRiJCKow/wZpHo?=
 =?us-ascii?Q?uDXtc+jIOQqJrvBc9cpbas9JGB7swFsacz4mCddUKDSjkmiBP2znPBMZYkY2?=
 =?us-ascii?Q?lxhyXLRy2h2mcxdJ4uV1FGMtJTJiME7e7/xZZp+/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NgiXbs9+KtuYy8CqbaZlmgDJSdbmr3or01s6dYoBZgR/0Ydrx2unu3MdDoQXb80Z/UwF4d2b2OCR/tE3C/pOGXQEvXA9xUKve4wGir6iXoAur37RojGENYEwH03Or/HhzDm/a+qtWZw8pie6Z114gTTB/GVxN4tz3I+oSAI+q6o+jPOmM1hvdywS+R+ZxtsZBLcJrRu7Lf97j0TihHndw2oeHZ7CSWORcDszalmtcnU4yK9pSz2Somhv8Nsrg6hMDUn1TlJllDIsFXeux9CZxCWIqENU2T+B5utxmYZOVeSOClN3x1DNnU/6x4/zcnzeAnuuCUeG4igIhi4xm8ixiYPILmBTQ8L75D9Mw/sdBDG+UYWILiEFQc0QbhUWIEZ9VWGYf5YVJWXe3HCaUdHSWfOvEMe/v9EaCJplfBv5ZYO0xwaHt+/SvtYq7m6+CP3Grq41918AExTCPad0lAwVG/j5e+k/nLib31celOGYSPTDr34ekYBmUk/eWYyjcdWK8dmOHEVSLHC66LWJrqI/TLJMryXRny0NHbRMkZH31sycMDIaXfPUGO5GlwsKsIPmw5TLzEAtivoGaISTwDqOfkYRn8HHy+gsAdj+kicx5Il8Efp6+j8xQ46Fw3+3QbLc5hMUmOOme8Y33JIOjacXv8Ww+aboJibynIiZZraq0LhNXCvJaX19wvkxDXZBr05o5NtQQuS00zmaT7/esRwvVhXzuR8894qFp3d3KiTOnZO6q2NQr2nUOegDYbHlbV+Y7whhnhB2oOFCKhFc5p0UW9ogHns3LSALrDNxSHRZ/BU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1ea3d4-985d-4db0-071f-08db836d0a33
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:47:35.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrnbcpVaGnQnxziX4iqyKlpQvA8PU2ip5DpKNzxIFSXG4apkEAQM7PDyWxM8h8nOdEZyUGgZjnm2yr30BpqdkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130059
X-Proofpoint-ORIG-GUID: ATxQx4rP5BtTz9SdtvUNlHChGNp5YbWf
X-Proofpoint-GUID: ATxQx4rP5BtTz9SdtvUNlHChGNp5YbWf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 10:55:24 AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:58:02PM +0530, Chandan Babu R wrote:
>> We will need two variants of read_header(), show_info() and restore() helper
>> functions to support two versions of metadump formats. To this end, A future
>> commit will introduce a vector of function pointers to work with the two
>> metadump formats. To have a common function signature for the function
>> pointers, this commit replaces the first argument of the previously listed
>> function pointers from "struct xfs_metablock *" with "void *".
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  mdrestore/xfs_mdrestore.c | 24 +++++++++++++++++-------
>>  1 file changed, 17 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index 08f52527..5451a58b 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -87,9 +87,11 @@ open_device(
>>  
>>  static void
>>  read_header(
>> -	struct xfs_metablock	*mb,
>> +	void			*header,
>
> Should we be using a union here instead of a generic void pointer?
>
> union xfs_mdrestore_headers {
> 	__be32				magic;
> 	struct xfs_metablock		v1;
> 	struct xfs_metadump_header	v2;
> };
>
> Then you can do:
>
> 	union xfs_mdrestore_headers	headers;
>
> 	fread(&headers.magic, sizeof(headers.magic), 1, md_fp));
>
> 	switch (be32_to_cpu(headers.magic)) {
> 	case XFS_MD_MAGIC_V1:
> 		ret = dosomething_v1(&headers, ...);
> 		break;
> 	case XFS_MD_MAGIC_V2:
> 		ret = dosomething_v2(&headers, ...);
> 		break;
>
> And there'll be at least *some* typechecking going on here.
>
>>  	FILE			*md_fp)
>>  {
>> +	struct xfs_metablock	*mb = header;
>> +
>>  	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
>
> And no need for the casting:
>
> static void
> read_header_v1(
> 	union xfs_mdrestore_headers	*h,
> 	FILE				*md_fp)
> {
> 	fread(&h->v1.mb_count, sizeof(h->v1.mb_count), 1, md_fp);
> 	...
> }
>
> static void
> read_header_v2(
> 	union xfs_mdrestore_headers	*h,
> 	FILE				*md_fp)
> {
> 	fread(&h->v2.xmh_version,
> 			sizeof(struct xfs_metadump_header) - offsetof(struct xfs_metadump_header, xmh_version),
> 			1, md_fp);
> 	...
> }
>

I agree with the above suggestions. I will apply them to the patchset.

-- 
chandan
