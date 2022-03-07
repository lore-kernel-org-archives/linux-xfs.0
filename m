Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FF5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 10:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbiCGK60 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 05:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241904AbiCGK5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 05:57:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AA98F9A7
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 02:21:00 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2279Ji1Q018407;
        Mon, 7 Mar 2022 10:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vLQwJyEwnFfNNJTeK6DPeGhhym9sV/Jm3KaCry2NWgo=;
 b=i2ZKhx/7MiUoefawwueedDJZHN3vFnOjhixdxQngSaTN1PYwirxXbr2e4E3T4tCUCcT3
 ypGZAx6yObEiKFUMDZYfcZLSEJoMvlMjlzAL1rcPRJTY1a9jUunYQ7OZoYA+w4IhLX95
 lzzrZzh2yW+nFH1wGCAeYEsQKL3opem9jdeNEoCvzUcwGt17PA+kscBSz7jW84Kz287W
 AmM3DHdK1sg1+WKIlhGfR/Pet8eRm+kFxeL+T6xYOdE7gFOFkD6KLaTKh96pJOrdZwWX
 QMezCmlKesys5iYOSWjhvmRKrSrWJ4ARi1dQPGLF/QvsVxG1sanQQfFl9P4AA2R+BmKp MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0dtub4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 10:20:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227A5WJu164955;
        Mon, 7 Mar 2022 10:20:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 3ekwwasf2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 10:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvqH3Gq9kDXt4i4/XWc3ZGCcrI08G+MBY2Gux7ap9MKZwQhVqQu9SbdiUL5ORsSoKMJYvwW6qBGhp28QcWuKqvoxLrDDaSF3qfuH+VD3RwSiJ+31qsODOWvL0U6DDInVyw+So176VIUV3tjscKcPeAXjft5A328JFHdkopEvPeqXmyyLmq33M+VBw0oRyg5A92k4zqeNAc22boQQWQtSWvrZHwPiB0kg0eaPVngvTdvkboQoIh5rnbVPBWC0S0nqFNWi63DUJW21DD7qbUmpBuL/uVHoL/+jxEJUT1PTJVWi7RTTF8OM9YusuZmtYydYMs4j2ccI0Qqmf8eZ3u8Tgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLQwJyEwnFfNNJTeK6DPeGhhym9sV/Jm3KaCry2NWgo=;
 b=PIcJImxa1+w7v/Z38hxC176JjZE/DJvg0Ax3WwjOrcfABYZv4dIUTnnsOGgqNYMrUSa0h+0OZGUHd3o+9x6PBURdYAgn7efyqqcf2GAG5MoghGq63hWmGjdLn58S7XHDFwmSCHzi6CX+FKdWuLBlnB5s/Y9Ib4N5YufTNQ9CFcdkfh/rSarVDpQ4AQjhnal9E83NbcmZPx6XiLZLDhonHvZPtfC/s5/GBacRGInmMM1WjMttuUZ8olzWanJVKW4lv8jED0UVfUdY6exBgRqBpFuBgaQbWqbsJCCZ6mtl2Rg5X7717YMq+0GLrNzd0f5kzKAHhAASjU7Kw9x6lvu8WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLQwJyEwnFfNNJTeK6DPeGhhym9sV/Jm3KaCry2NWgo=;
 b=yslDJIkAX354SacCFrs4OIvG0xzzkSQBRf97Wz3LSlIEe8qGDq1D7TMhGVmS/v5cQ8VOm2J2s4sW8J0XqShLGUuZ9VcImbloJZkmXxetWOPH9syRuZ+dvr0m9ehFvbC84z3vn3uJ7zBCXH9LuK8B3/eN4jYQwNHK8R99dO/4w4c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB3370.namprd10.prod.outlook.com (2603:10b6:5:1aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Mon, 7 Mar
 2022 10:20:53 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 10:20:53 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-15-chandan.babu@oracle.com>
 <20220304075133.GJ59715@dread.disaster.area>
 <87ilsslg9w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220307050254.GN59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 14/17] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <20220307050254.GN59715@dread.disaster.area>
Message-ID: <87o82irrlv.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 07 Mar 2022 15:50:44 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0185.jpnprd01.prod.outlook.com (2603:1096:403::15)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12984431-e466-432f-1413-08da002428de
X-MS-TrafficTypeDiagnostic: DM6PR10MB3370:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33700D4469BC52128F0A7899F6089@DM6PR10MB3370.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qOpqEkDmyGnv8lZsfYRzIvmxV98qHWuKT4Nf2M1sx0cbBXwaZTbUHsWjnhJRp2cA34hr6Mki5Yb3vpWO5oFSnkMTNo1J15xZUmRpWyTdJWo/q7IbE6GhGupTBrIKUFfW+/Od9dWlRbG4g4wyvVOtKf9TP/3zbVy+RbzcPXldJuqfn9tbejnlIy39gaCRTu0cyMBG9duLVt/UtiSPgqI8cO8mEhTJBTdVj2rcG6Dd2zI9T0PY1rNABgcGyxceBsEzmLGnPQKiVlcOIv45+cbqtHLjVTTtGwLpYgV6yn2Bm1C6BSyjUSau8z8V/NvfvrUQ+tokz8myCOCHwn9XCjCdfBmVScsgiPy1/OEsxH7aGaN5Un5KwzNxKvzvRz/pIYW/zXQyMFjeTpmOmqfz3XNMiA8M1/7L1WzfmAh1TspAwSD/tBlvlI2NJ8lEfhaAndwhyM1AtJGBkhbWCeREPLIWilVbTOnOUcPWvztD2cVLt3+BBij+7O6GJfegPLgDYRF9YGHhA+D/yGDDZHFfnmMuFDC1bg4zNlAmnSijasVFWYZ8MfUXjak8oNbjBs73IcJZ3Y2zr6sNRDBA+iDJ+3sXDhxko4U1Nh+h5tdxVB8aC22NHErnl6gWhan79Il5jfJtHU+EK7E+GBp0hINObXBIuHCuZ31tuwWSrd1i3YrutNPw0UXRLtpOfqXVkUYKLUnr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(38350700002)(33716001)(6666004)(66946007)(8936002)(4326008)(8676002)(66556008)(508600001)(2906002)(5660300002)(66476007)(83380400001)(86362001)(26005)(6506007)(6512007)(316002)(9686003)(186003)(6486002)(6916009)(52116002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RMl66GLoTY7PSuPMY+4TONzbQNIx1sy8z9hp2vGYl1RitSw6GmUeOPyNN3ix?=
 =?us-ascii?Q?QpjG64mkGOTZYl4ZUxBu95cA+V6Zx06BFOObLQJqiIQdLgnS0ym3/8jD8DKq?=
 =?us-ascii?Q?dou/hKbWC1IMaEKzycIdttqchDSJEIiCPJFJtShguT5AMVD4dH8FfmXG6sc7?=
 =?us-ascii?Q?sMTOrm8wU0JRSL8DzQZ3R8QEcL3BFHwtdWQza1XhzmSjJ2eWOrfrCD/lOAKx?=
 =?us-ascii?Q?fX6DCx4uqrzOxM31Jtst4X1+Dcx6ZvWiajTG37oTGv2LhpmvC9JFYMsPzWT4?=
 =?us-ascii?Q?84vRcreY0sT2VnmFo4DAuWoQEZATrtI69k2QzWmdXtCglLdimK5Gw6w5rPRj?=
 =?us-ascii?Q?64IDfRSwv0be86BbF2Oe75OLwaKGMGk8IKCkCcaKveaAR66B+XSYc85uB4Rm?=
 =?us-ascii?Q?wPzjnuKg3Gv8qfMaRu8Fp9B2ND4uR90drfKZNLa0J2Kn06DWLLepdKyWD1NQ?=
 =?us-ascii?Q?eP/eGgIUIRGZTkME+3I2lvOYAFpRbYy4ETT3Wyn7gtUsE1oXNRJlrT+/HNeV?=
 =?us-ascii?Q?9GgkCAZ3a2wAp7P9eH+827IYOtMQ0BLr0LlhLpCNV4paPi5ptdv7gBREqH4b?=
 =?us-ascii?Q?yFd/Sji98uStogpAdjIoACijhMjVqPnz9TC4yJVkaPVLgUq3nqSumLKFYh4W?=
 =?us-ascii?Q?ozMSq9uR+zH1IJC+aCx25jO9m769oq5R3KLtqL2aOL+xZADEHYcUOTJ2Rbf0?=
 =?us-ascii?Q?cxzuxvg2WRT08nPRe7KD0Jy9Ar9AomUg7s0ISqUdw/9UHrjDO0SkMbiTx4FM?=
 =?us-ascii?Q?Kn1GQvQhcyKUmttpXK+tZQJc5mZX27i9M/94CXbQQp/beBgVpEdGysxMEkLa?=
 =?us-ascii?Q?ePiA1TfxhHDRUVUNI6Bm1TgJZGsjhP1fqCiHvnhlYlzOOJrF4VdmbQIvRvbr?=
 =?us-ascii?Q?s9bHrGRC8pc/+ZhZ3H2ltkaYu90Vj2t0L2tJjy6OCes9/8QfngJ9zH4ECXad?=
 =?us-ascii?Q?VvXW26hV/vPpUks5kYk08Js3lMSH0QYOLK+ayBU/BozsLaKQ6ppjfQG1VuGp?=
 =?us-ascii?Q?7KbFfHAX3h5/WEbMC1NsApF6nLlndoFatauN3r8DV5kRVzUx1R2oXxmkFKNa?=
 =?us-ascii?Q?hhrgCLu1CoRda1N3zNxgwwhF7I4mB0d771UpbWNWEy4xqpar6V2Jo8AQqUn+?=
 =?us-ascii?Q?/zU3MyQblDO5/ecxoqMwVXeNXgWeAwJ15d4PBjg/NU61QWQ3z2RBrKm+Ey0I?=
 =?us-ascii?Q?925frDf2wv1cv/p594NV8ils5/l9jtg9k4aO1UWq5fL61SGumsA5qF018AQL?=
 =?us-ascii?Q?Wvf7W4avmvYvVwuf+RcIM1TCc4+a0APBd8v9+VvfwTjIT+PqW6omn9i7ZoFk?=
 =?us-ascii?Q?VHgjN3+/79XACHC8lMWvILlCsJbC/h9TEHvug+G1M2DC/0cTKXjCIIlCy8rS?=
 =?us-ascii?Q?/KwqJonEdZvCosfgHj+4mFPg5oGbpG51QJ7kfigdW/13VF4KdiCP3yIgCOGO?=
 =?us-ascii?Q?NoJl4oM08D6Ietc8ozD3P037y/wm6Xhv73q9FW37hTHwvzSipDjZeuq8C0uc?=
 =?us-ascii?Q?ZL2efx+wUZreFo4EYvOvEAIeiVcvIa1qSbi7bUqm8cKjc74uSEGOWvG+7EZf?=
 =?us-ascii?Q?9YruXsK1oWGWSUuNGsUobXxVx2Z4WS+fYu2DP8rrdAGeUpjeWCVHm7YWN7Wc?=
 =?us-ascii?Q?Q3961NenTX/ps94raK1208k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12984431-e466-432f-1413-08da002428de
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 10:20:53.3155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X8l17vSMv1ZM/w/2+JHapa7q1nJoYqpqD4xLjui+htfzRBRyvd6gSwAeSyMnM35gknBV3E/n5H0ExnUmoA2q9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3370
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=774 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070060
X-Proofpoint-ORIG-GUID: xLuYTMuop8MN2-8tg0B2YZ-vTRnRkOI0
X-Proofpoint-GUID: xLuYTMuop8MN2-8tg0B2YZ-vTRnRkOI0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Mar 2022 at 10:32, Dave Chinner wrote:
> On Sat, Mar 05, 2022 at 06:15:15PM +0530, Chandan Babu R wrote:
>> On 04 Mar 2022 at 13:21, Dave Chinner wrote:
>> > On Tue, Mar 01, 2022 at 04:09:35PM +0530, Chandan Babu R wrote:
>> >> This commit upgrades inodes to use 64-bit extent counters when they are read
>> >> from disk. Inodes are upgraded only when the filesystem instance has
>> >> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
>> >> 
>> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> .....
>> >> +	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
>> >
>> > If the answer is so we don't cancel a dirty transaction here, then
>> > I think this check needs to be more explicit - don't even try to do
>> > the upgrade if the number of extents we are adding will cause an
>> > overflow anyway.
>> >
>> > As it is, wouldn't adding 2^47 - 2^31 extents in a single hit be
>> > indicative of a bug? We can only modify the extent count by a
>> > handful of extents (10, maybe 20?) at most in a single transaction,
>> > so why do we even need this check?
>> 
>> Yes, the above call to xfs_iext_count_may_overflow() is not correct. The value
>> of nr_to_add has to be larger than 2^17 (2^32 - 2^15 for attr fork and 2^48 -
>> 2^31 for data fork) for extent count to overflow. Hence, I will remove this
>> call to xfs_iext_count_may_overflow().
>
> Would it be worth putting an assert somewhere with this logic in it?
> That way we at least capture such bugs in debug settings and protect
> ourselves from unintentional mistakes.
>

Sure. I will add an ASSERT() call to check if we ever add more than 2^17
extents in a single modification of an inode's data/attr fork extent count.

-- 
chandan
