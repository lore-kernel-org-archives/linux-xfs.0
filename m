Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7F5C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 05:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiKDFYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 01:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKDFYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 01:24:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E252251C
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 22:24:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A44OwLY023603;
        Fri, 4 Nov 2022 05:24:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ojyAbwSHy7DnbuE8etqIOKXgnSlLgtjPS6fX2Cc1gpU=;
 b=DOz+KfS6WHYi1HehIznypiU0pKc51TSJKninuQVbYUbSkOq/6D1QmrmT1EIg18uyR74U
 w1Oorc4oOT3OZJB+TUr/BvT41mDqSzBwGLKjfAvPwUOr3vaqK0xMKlKLA9uSNS+y25Na
 x+XCWedqwWH2Osdsdi5xJUvjYKCGY6PKDgyozaXp+9FnvCnviw5lyRZSonYrQnFIruQY
 kwD4DOhcwEe//JDL8UQlBDXmBXNKI62zEtfu5QjsI2YOUcjRy9j0bM2WyI0JH45P7mmh
 7zA2qfOBtYpoUqQ8Hnu6X/mj7C+1wx8eM4gHPIw2zoeM3BtihbRKrc8UW7OQQRmveoue UA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1f3r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 05:24:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A448LCd028963;
        Fri, 4 Nov 2022 05:24:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr8esgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 05:24:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6VjYdur2OMq1Oop9fHkqDq7wwWPqEpVZycnJi2wrj4mKN937qJ7MgkjHyNFbYL6+D3SEdEiQ+sr1TGHKx1P+Y3P/51FevRSXNuLJd2Wn81i4PFSBp9kID7MoQDXy6pyS2gwruNJ4NqROK4rFbNscenBFWjaEeopxxHKH3AHg/HQS2d4mMcZZC4/U21B9pUJOhAl/f8ipKlUcbSe9spRK8fi6lbYmdbAHZJgwKerYHVn6tr1CmMpI4gq7QgPdGOepVjfUn/LAFy6/e55+PWs5UO9O34LSuo3zT+N1cifUaY5jwz4R5Ws+Gx05kFw/gzV6ioioZt+w71XEBBY7gCszQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojyAbwSHy7DnbuE8etqIOKXgnSlLgtjPS6fX2Cc1gpU=;
 b=kz+aeZHcgyZqiQPnLcj/LK7dYeyLAiz49vjf/rCbck2ISHbMgn9qbiLB6Q7mlRxZyX0A/WbHVLObNmZsCkm1VX0fQeE+FnU4E+ilF6RFumWfam9zpSbVT/JwfkVNqzpSHJdm8T84m9SjNIjyoj6+jxl63X5QiMU8CqRMKXAQlKa71D41mZDNqkJmhAxc/p62VsvKPK2CFXtSIrHXTjRbUmoH1QPP04zrA6ge+4TjgnKrP6jLIK83gG1Hu2IigzQ1jry35TEux0YTWeHGrrLvfspcXR3+37k1XjPdvAKOTV8xayL0u5S7+eu+/L9IhgbHbWSU5OS7/knudq3QtRhSHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojyAbwSHy7DnbuE8etqIOKXgnSlLgtjPS6fX2Cc1gpU=;
 b=BNFA45XhnNvjInsPh7VWdrT3I4Dgdsh2bT8mWrBimDtmmE7MQZuMRRbGHtrKbtSG6+vE9Q8woz3k/2PeXQBFIVNooizZXgLqLLVFE0we4qm+d4SCUpv6lec36t/bMxT95iSdicfq8vPAwlBC0I1OVKFAPuCL0X0xD0/kZ6xg7g8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4224.namprd10.prod.outlook.com (2603:10b6:208:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Fri, 4 Nov
 2022 05:23:59 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 05:23:59 +0000
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
 <Y2Pf4qNn7LJxrJO0@magnolia>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 0/6] xfs stable candidate patches for
 5.4.y (from v5.8)
Date:   Fri, 04 Nov 2022 10:51:13 +0530
In-reply-to: <Y2Pf4qNn7LJxrJO0@magnolia>
Message-ID: <878rkrz40m.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0046.apcprd06.prod.outlook.com
 (2603:1096:404:2e::34) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4224:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ee1b4ae-eba1-4a73-0e4e-08dabe24c6f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7QJGf6zM1HtOX+INemgTrSn5v3XMeVFADI8GoecIwxrkl8ti8hkM/mE6hcszMgQN/+FlBmy2UtBQn3LhMrVlgwWMxI5Kv8z1cZQiL81gR9M0c4EC4oQZDBeL1q6gMlgztHdeqD4Pl82xAnVJsNmZvQUfH3ZZqaXNDQRKIxN8IuVtFbm5t9tY/Y4Tj6U0ICnhtpm6zR/vSzHu4joE6W+k0lhG3uohiguJx9xufw+5Ps8uY8/pcK01r/r7djjdPS2G6WO7u56BJS315dPILNAx4LcFcmUKkRBOUI5nPJ/RF9jHjobYuXAFuFUl2RuBbiaPwN+4RfgEfrwMplzaruX18TWE4OjvZ0c5MwSawNJbsIlklNJFi+2jk3cX0MksVVtOOFlLWKocH3v0h5Sn/zzsaEe7/S8Dc+7cEoxeWBBm3zSp7MsVC5Z6Z5I9jCJ+gHA3pfEhcIksK9kuwqU4pUgievQ66Nfidn+oa7hLTGhjNQzGBpLW940Q7XOD9OPWYUwSEFMOprqGKo1jpsYW4+ERLzbCw5XlC35/Fs+2GxTdOVSYzEwpS+uMwru0yEuj7Y73QzbDgCziudd4kid2uAY6WniSBFci3AyFSKfv+J0HtnK3HRhu1IUz+YGiQYOs4gnE8pFljWTV4/i57AGiFcVBe+Kro+yDeK3bqsnypLK6TDo3wOmhrRoyv7pHdoel4XO+tvJyMl5Fz0RtACm/N8Gxvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(6486002)(66556008)(66476007)(86362001)(6916009)(316002)(478600001)(8676002)(4326008)(53546011)(66946007)(6506007)(2906002)(38100700002)(41300700001)(6666004)(9686003)(26005)(6512007)(33716001)(186003)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTh2JEi6FOKJFHeZ5/YVVv+L9LTs5sLUxw0Z9leRfU93oDKFmZzpk0vHccAl?=
 =?us-ascii?Q?+E/qfUpShoHtcwUcR5VS/P5inLpOKuqWv/YKmKTHQzkFMzbDIscpk70mXAzm?=
 =?us-ascii?Q?LhxZWi8JFubyC6jD5YAGgAtRGLNVqfUt1eCc6U3RUUZJm1/oBKhBNJOk9Fdu?=
 =?us-ascii?Q?fjdpxGrO6/U4XvvOw3gNPn599/zx9HsLE0w40QzPFPWSlflgPXvJNYi1CvOC?=
 =?us-ascii?Q?n1FCuhE+ITzD1ILKAjyO3psA1Hf+J6v5hHfzCO+JdCcpXv+ygzHbbue4GAmZ?=
 =?us-ascii?Q?LkzzoyABWtZsYaZQDY3NmlNQ7bGXVOEauHOVQNDDmokzYfNmWSg13VHVS0Dd?=
 =?us-ascii?Q?OrVgpjyKrweWsGQ4CCoArs9bnBlIgGYwKjNLa8IDVH7g/7EBGqa65N7LTvyN?=
 =?us-ascii?Q?CboxOZgnBpf8xoUbbF7Ss27gCxDkDTMA7mGoF6PQrjj3V7zivasP9lLojcun?=
 =?us-ascii?Q?oVk22RpYk9raf5wGnnxqkNChZWifo2glMdBlxOWTml7XHjHKnDIIIu912bmx?=
 =?us-ascii?Q?usKuYq/AH6Cpm12oJVcLeCkwtSzpLSI2lPwzpezdbjPmduhD1QDeYFxNj7QA?=
 =?us-ascii?Q?5fYD6jTYfJgeG5AHj4yYlFKFaXUh/RZ+xySEIXkPS4zlBG4K1zH3+v25Np43?=
 =?us-ascii?Q?NzQadndxMdmwjIy19dbF095nHJ/NpfQEWXF4WCnLHG2qp+rA9Lu7wtUw6sUc?=
 =?us-ascii?Q?iWX4l5w7uhSbCWd9Fh0IiWAm7FGvCSFf/iGSBCO8E3Wd8d67q7E1WZliDv1v?=
 =?us-ascii?Q?wtvAe9vQrzdNZWjvaDQiBsUVEnlMPxZpFfFEVB4GyuGwCOswTxe5nDXdyruP?=
 =?us-ascii?Q?2auzWRcgLpMNiZm2ccx0Ta6fyAqGh+xb0sI99UrrjxOwgiIp1SaOn4FVyQeo?=
 =?us-ascii?Q?uf5rOFYRH4riPbJXPY3mq1s722z2x0ytX8N8GtmXsoCDfni8xnSGb06GYjM/?=
 =?us-ascii?Q?7wFZDtLK7SGoqRSCjZPIovb/4Ynj+/ieRu8SXORQJwPZyfTUmw5slJMFPRTc?=
 =?us-ascii?Q?85Ij5qzFXwwoyhKmM2LDemRUeRTt70/lvDl4VK1Dj6lAvONS07vfWH2T6Lvb?=
 =?us-ascii?Q?cVaBbtu3E3utVjWVSzzecn+qdwTkMHfYcOTQ6kzcIGnp2uGbpH3+c3ptQ2Ny?=
 =?us-ascii?Q?f/8s8ifzI/cFgOrSD0tjB9wsRS8oa4thvVm6EcUnoFg7u+9rt2gbAgN1wI4p?=
 =?us-ascii?Q?ylBy0kRkm9WAU2ZFh5hheQAd5663XSxLYA418vDr3ylFLMd8kmAuESKXP3oT?=
 =?us-ascii?Q?4irmD2O1WzmuR63w0EP3P1EwEXT4bjU+x/Wxt8H63gGKJ23eMuLbVBL7Qog7?=
 =?us-ascii?Q?TotsPFw/SFsr/rOgqfKLFJvu9JLG2E2VFxUSip/x9mbDJ2dUW9CO6HUxcspK?=
 =?us-ascii?Q?NnBMJQjccIMiKs/WgRrh6nfCcxh5SfXNbRjAbXMopGZ0NxY/Qcusnp8M8MMg?=
 =?us-ascii?Q?Gk0BYvQ+OQw1hL59TiHYtgEBxWvAR8kVZPnWOxEjJQrFFuEY9r/DFtJWdnMJ?=
 =?us-ascii?Q?KShv886ZugBrrC14vmpLzmNA5pdAYCgSQ4MaSQ1FuD3K8Jljn7wGRx5QdxjH?=
 =?us-ascii?Q?0xGfR6JhwFL5cN8m6+PCIIJvBp+bNMDEdaqyzyzCMCjbxD413PAWhAUo3GjO?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee1b4ae-eba1-4a73-0e4e-08dabe24c6f1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 05:23:59.4320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kUd9h//uSqXQIg4FuIU3/HkbPdyMj4srlBpPISUzLg5siiBQiL/6hqUwVfWX5jUQ2tBfvqT4GU5HpZ1bN/Dqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4224
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040037
X-Proofpoint-GUID: 9mLI_q8SIAdSQm6iCjI7mo7kfsAPce9q
X-Proofpoint-ORIG-GUID: 9mLI_q8SIAdSQm6iCjI7mo7kfsAPce9q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 08:36:02 AM -0700, Darrick J. Wong wrote:
> On Thu, Nov 03, 2022 at 05:23:55PM +0530, Chandan Babu R wrote:
>> Hi Darrick,
>> 
>> This 5.4.y backport series contains fixes from v5.8 release.
>> 
>> This patchset has been tested by executing fstests (via kdevops) using
>> the following XFS configurations,
>> 
>> 1. No CRC (with 512 and 4k block size).
>> 2. Reflink/Rmapbt (1k and 4k block size).
>> 3. Reflink without Rmapbt.
>> 4. External log device.
>> 
>> None of the fixes required any other dependent patches to be
>> backported.
>
> Patch 2 is missing quite a bit of commit message context.  Something
> filtered out the shell screencap:
>
> "# mkfs.xfs -f /dev/sda"
>
> Probably because some smart tool thought it was eliding unnecessary
> comments or something?

Sorry, I had not noticed that. I have sent a V2 of Patch 2 which fixes this
problem.

Git, by default, uses # as the comment character. I was able to overcome this
by adding the following to my ~/.gitconfig,

[core]
	commentChar = $

>
> For the other 5 patches,
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>
> --D

-- 
chandan
