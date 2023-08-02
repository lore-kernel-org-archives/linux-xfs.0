Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79700C001DF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 13:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjHBNUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjHBNU1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 09:20:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFAC26B6
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 06:20:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372CxVfj020641;
        Wed, 2 Aug 2023 13:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=2zWXkS2xuknaSauCq82jXfLnp6UHcZ+WUejsUxisM4k=;
 b=kCuI+9YOFcNGgAXqP/EOK+qhbpZ8C/Acwb+h3xGkRzn/8RKLKWo2Di3fFhhEPqgdLZCM
 J+bwd6DG91viWaAaPRep0+AEjE87J1rglcsogMCWJW8apbr0MpDdcBcy0KF1swD0z/8h
 SZqBofv7HN97z8aFRKA8m7hpmZdQXoeilSj0hwDmyvhXdqU9LOhZblX2vEdqD0RfS4b7
 bM16UrnQSkT/eobtN4WOTcTI/Y/OH45EbWSHN04KxjXZZL6By83hK13nTc/WFqSg2h8+
 cOMrjHeabW/zT1u4HXtc4jaPNB6jbEl/GWZYMhDZ4odJfD3O3KfnNAqaCS0Da1wCug3V LA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tcty6nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:20:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372BmRCR006669;
        Wed, 2 Aug 2023 13:20:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7eeh5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:20:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fnrj8AP4lVeREm31opqPYYsg8xplvNNqChc3rOHfECDa3L8zk2HagXtz+KnNuKVqQrIcbXivyAG2Iq9R5nx2z6ei80TofNtuqd9Zdw3KCw7wFz1R/owW7cPtbsXJLu/DlBnsuPzimOk7NTZg98HxueQJhcB1O/lFWFNk7fpaJQvZHGNHmidVNjVcDsUvqquxazDj8qxHOX6VFGbDw/Q5/+2RW+gJuM5UPm8aGx4Gz1MUKiDMovwEOaBvWFVpV00cOBqLCBRuqaaAToxocf4yXhsaCDIAMVc1CXQFS/0hhAPqjHNQeWavf4uCWd6FBC9qHeKsYoVJMGMkACtYT7hNXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zWXkS2xuknaSauCq82jXfLnp6UHcZ+WUejsUxisM4k=;
 b=YVSnWe10majSfq6yS24dd2nygZu94FkhdW5Z3wNeEPqy8IL1l2NyYWtcQXjBuLgiyiuzFiBbURexOiiKfDQEiBSIrpRVZFwq052+kqP2EWr9dlO2fyLF9aEGlTjfa+OUVE5VnDbQlSrAsMMAPJx6nOERkmnZko5jxcoZrZDe2ycRtm9/5wjaYu/lxw1rYyZOXtOIn5nALhk6rvvX9/6TKB7E7JgAe32Nnkr5BL2TUuGL4ziW12RI+Cx7gzchPtf0g4BmTJhrBaWkm/ouVZ1bJejBglW9KevlQWojBEHFqGweoXCBPNHnQTeiXI4qUh9z5PyjJxHmQHAVW8R5HL2JAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zWXkS2xuknaSauCq82jXfLnp6UHcZ+WUejsUxisM4k=;
 b=Rf+BP4qSUM9HTpw81PbjjLsvoNjLRvqwkTPVpV11jCnP3VJwR/K0qkOGPShKjr7WxJzfMW6tkOij07/CjSsM5P+PqQ+GZyZSBuLNYYg1FtSb1LwmIFcR7HTYERotwKt8nmYZK9Ow7MQiQUTo0iivf0uvs1G27x6g1tllPVaVBXo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CH3PR10MB7356.namprd10.prod.outlook.com (2603:10b6:610:130::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 13:20:15 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 13:20:15 +0000
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-11-chandan.babu@oracle.com>
 <20230801234753.GR11352@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 10/23] metadump: Define metadump v2 ondisk format
 structures and macros
Date:   Wed, 02 Aug 2023 18:38:20 +0530
In-reply-to: <20230801234753.GR11352@frogsfrogsfrogs>
Message-ID: <87ttthr37f.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0041.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:380::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH3PR10MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 73aa5a09-81fa-4710-e460-08db935b3527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2WqfvYMFL2CIstbR6DMiDgFy1+CJKb3r2PYeTVpKIn4/Yvfwkqha5xvh2UmZLzHq/abPpF1pHK3oNyP0R375dDka7WALNOwfzqxlkuwP516zSk+43NNMj41dBnoCQBBEiH5tNTCT/tB16ijTXj+e/fpVC6gtB9leUvfgVA3Kb1Lb8JloUaatvahOTvSSNDjkO0NGG512N6Tckfakezb8rwA9mlSPICf5hsfaPVWMFImzVw46Jy89DIfq1Z8y5B0alux4u0Zh5Jd7svp1vlZ4pPMcPXIHJ46na7yuE8YMlT9hQYTI0DvQ9UJee9qfdK8tE3vrJ52G4X2hkhJUgWDZvrsJzNQLxwDkHGf1IGAbncogcGmsZBURFiUsOueKRj8x2jEiUDxEO6QuHfEu0xdxfxoNBZtsU2FfcURqoeB1KXYT+OQTz/1OwmFXNaCVFFBoMHWg6FqfUghu474EWCSjJWqoLdgI0WIwAmypMJVeBrnnaVy3UfNFPhP552YaVNk+pjWcljWKnDvnds9o/TkGgMajWu2GrUQmbIjX+7U38Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(41300700001)(2906002)(6916009)(316002)(4326008)(8676002)(8936002)(5660300002)(66556008)(66476007)(66946007)(86362001)(38100700002)(478600001)(26005)(186003)(9686003)(53546011)(6506007)(33716001)(966005)(6486002)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SCCgY7TgUqkKW9bB3xHnDGCOFFSRSf9VTINcIA1qHX90FjODrI1GVmlnS1wV?=
 =?us-ascii?Q?854XA8ZyB8/BiDGDon6tDJN47BGEH0pIaTeQYnFRTqVtsFwYuso7LYd9pWgf?=
 =?us-ascii?Q?qiQAiam2cJgNAeLRWXfS2rI/2VtiH6lzis7GQKJh4DcaxKgJIbVRHYlKRLTe?=
 =?us-ascii?Q?VV6UbcjDw0UqV/Hx3aNCzBl/x+MBop6yNAtTEHQSLcvLIUeMW2WE2PdHxbPe?=
 =?us-ascii?Q?MKh2FMUY9RZxJcf/V4QVpCi1zDj64ltHZ7zTvflzuDl1mukCVBIrkp096gvJ?=
 =?us-ascii?Q?Kn9AVA2bPLYRud8cvzgmPLLjw4uJBoQYoIVIz93exmcRvEm3wRqCTKFXAMKb?=
 =?us-ascii?Q?DtKP3TMcx9eY2rTaBPVHi+RPwchj2QGOTYiazQycHb9HS/JMtaeGaEPvCj8U?=
 =?us-ascii?Q?QL/SNomfUgeFgTSthWzc2fT36KjcpsXMqSV40N87uLiZbjABEiojdFFN+bNB?=
 =?us-ascii?Q?JDH/QpCJt0YQQXBa2P56LKe6wJGXmSSjcraRreT1jeTE6D0WgR2Jf8eHQe+R?=
 =?us-ascii?Q?2hFrkonx1JSngwu9xmLifUr45qQfch9h5oaOoSh810ZvSb8/kivN1ea0AB/Q?=
 =?us-ascii?Q?qTG9RUc4g7eBM1z41YaITKSIESvejCpLs6ZtmVxo/utIzCFYchC/2+FwgIxO?=
 =?us-ascii?Q?gNDoI9Syqumx0aveDUNhfLz50JZyOf1UnMVVmsmV5fs98NAjcVY8bZ6rNx+B?=
 =?us-ascii?Q?dHOgqe4XVTyssW68CAo75W9sdVokQpTiaNwHGS6gagXn1KXTD5FreaNDC5KX?=
 =?us-ascii?Q?FJ+rTFcTZzvQN0OSNZwvN46IB8ays7EQbhubC/m1uPFtgALp9M8Q+ROzNaT4?=
 =?us-ascii?Q?pesFKQ15XUirpEbkZeG8nxmkaLdbklLlxnhk5qYumiygfYLAj5iBOPP46kn+?=
 =?us-ascii?Q?ajIEE3Hjbwv4wnfV2sp+8k8/zvkwMD+MOcbRXYCzN5MCoVCXN2a514RgBvJD?=
 =?us-ascii?Q?18VBWVcuzaCRdovuoVExw1uOmx1ysSJVb7yxbSvBwZIhCt63FCzYJEydWxR6?=
 =?us-ascii?Q?bYRl6886q4TmFAANMd5mS1s0Uq4zIM026xIWRytcXgwicLItPMULN/QkUHlI?=
 =?us-ascii?Q?tIQUfX12rSYH0O+BXTFteUQi3KwxDuQEO9RWT42m3q5hd+EvLqczjeznnDer?=
 =?us-ascii?Q?QAXzviN7PYh4Xn74ec3wIsiNsCoZnm55vhMQrj64yqIPpvu6UGTT1Rwk6UxI?=
 =?us-ascii?Q?qVywCiAD5CDhHiwEB6ySELNi1t1c0C2PpKFPw0TI8GzwDSd0tKLjjR7p5y5F?=
 =?us-ascii?Q?hmOoh8HsxkE+svMwptY9Ug+kBeVpuwrFe4uf2BT7vjzwdF+JlpO10xIpUzP1?=
 =?us-ascii?Q?zuzeg/N6+AGovXShEc34MTzueXCxDYqzuYQmusGJtLKoZInM4zi6SkG1OYPl?=
 =?us-ascii?Q?H2QGg0qDEbH4lv7RZ0Oi8K0He+lH1YfD90hJ+RsOe41d78hgcMNzREab9g3H?=
 =?us-ascii?Q?0+TTF+BpLR4aKnLK2ff+4iS5Ezpqfqoi6bfId2Xc58kzC1kWtYO9gjidmYn2?=
 =?us-ascii?Q?V/lHwMugYRlc2GN4MD0mpBPnBlU3eNmJ0u3dsUsdWvZH7SKOjTp/FouPVTDT?=
 =?us-ascii?Q?SatwM51QT6FJRYowu5Y111cJT3WRktXSQ4+AZevN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2Q+tk+p1u+1qifnCl7OVYXMc5J3kYQU/KKmuCMY8jc0B+8GH1oSvM/cvQA8BGw/Ki6ekbM/NlWpLzwbyziU3Bh6xuvohfSqj7O7dUtp/3QGTTeKFTMpurlUeG594JIJXN6oirf0ZcNLacUAf3nbwgbFEE/fKw9dPDNGtebfI60NJcU9vdjoJ7QipqthsZs7VUz/z2ebhMhqNIwbMQCfgIiygR2dApEk+6swAr+mr3QtcmFTseViqS+sT7X4IvDmlT4cWm+OxtGlmS1epX+S5gsDOMx0egL+HxfFan02B3jkNrtsCJ2JZi/SayiHrbGNqMRxJAfyPcvTnIF+4Ia+/S6UWJUH5Q5pn3hgsmwpIvwqDkedyBx8ynrdO5k/gi8wvvBZKnxWcmPQi5sHpBoCzvSiTE3GgwymA3ra+0QtrOsk6+ZZEYF93x8s1/MneNCE3TekMk7nzKk523OpaRNMzJsO3bG2DLP20gnoG0EuRlvKq1rU7yLMevw8WVzKX1I1T8YXkGW0bYdBf2pXvNNsC2/80IDu8MK6yjeM4qqmwbrtVoU+JPFngr6qyNvhvnhx8V/y72EYBwMYhZB3Rw5Q1c+0yuLgy0+ooiqBBYimMsO0s4VLSY9rIEULf5jpcrqeIOU7HkVacKW0HdRxdq6dc8FjAq/w+T+eWc8YX8KneoWZOwQO/jOYB1VQmFGFQT0rRJdMXShZIvacsQRxeX6ztZK9KkgY2QqvYmseECbSAKVZsdXWB2JuB1pIM5YyXJG+C+UE9VthMN8AhMyXOD0NdnUukfMxRtTNnQR7RjxhTtjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73aa5a09-81fa-4710-e460-08db935b3527
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 13:20:14.9422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMxA/c7I9gUvLr2yahKtmgYkdUa7e6loTBOmKLFrrdLJHNUaCgt3wnDfTXaZOorpS/PpX2xj2EbM8PyNbIvYbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_09,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=975
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308020119
X-Proofpoint-GUID: BWg7C_ffL944_55JlrDP29hd7U-8qgWm
X-Proofpoint-ORIG-GUID: BWg7C_ffL944_55JlrDP29hd7U-8qgWm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2023 at 04:47:53 PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 24, 2023 at 10:05:14AM +0530, Chandan Babu R wrote:
>> The corresponding metadump file's disk layout is as shown below,
>> 
>>      |------------------------------|
>>      | struct xfs_metadump_header   |
>>      |------------------------------|
>>      | struct xfs_meta_extent 0     |
>>      | Extent 0's data              |
>>      | struct xfs_meta_extent 1     |
>>      | Extent 1's data              |
>>      | ...                          |
>>      | struct xfs_meta_extent (n-1) |
>>      | Extent (n-1)'s data          |
>>      |------------------------------|
>> 
>> The "struct xfs_metadump_header" is followed by alternating series of "struct
>> xfs_meta_extent" and the extent itself.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> Looks good,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> Could you please post a patch describing the metadump2 file format for
> https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/ ?

Sure, I will do that.

>
> (Sorry I posted an earlier reply to the truncated submission.)
>
> --D
>

-- 
chandan
