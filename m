Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4E8C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 12:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbjFFMm1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 08:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbjFFMmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 08:42:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4AF170B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 05:42:03 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566Heek017276;
        Tue, 6 Jun 2023 12:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=HChsp++d+vQ447UzaDeepN80Qt4wytKVXuIZMbkzxxQ=;
 b=wWeiF+gS6vt0LvzPQiT/M70dfE+0rnQRndaAVs/uJMbUMTAYe3UbzTSfDa805qkNDZK3
 86WMOjEtSF5ZE9xy7LSpT4aB3e68mHY5zJgfB+ISsK2JEA7dB4vjAHHU38n3bX885zRu
 MR6gO2zK7SJRdOE334jZf/oW6U+0MBwrq1ldNhZTBQ7KgCmdj5JJVldI0DefQj7fNWxT
 3eo8VE2nZ3g9MlSyt8silYSNfnj5DivNw7YLy8sPLhBMnK7KSrhHFcl8lhI5S6KKZRss
 EE7znko22JFoeKWc5swSgmSZEyg+NA4Pyus43Vjx0c1HTKPOi2y27YW57u3369dIqoVi Rg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2c5ahv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 12:41:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 356BoIJc023746;
        Tue, 6 Jun 2023 12:41:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tq93uwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 12:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlMgfDc+97Hze4o6kW3Vztdp6Wmy3gfotp1WCD3PQYCBuqBzeIWiD0c/IfyYaKHjrIxgWVGsLtluFHtjtpZlOMXYSU+BwuQrmc4++Kyx7bemFCtHkG+fhiB4gh+LSnQnJhtAb7qr4vKlUYwwX7VuzI9WBQpLZ2G1wcgQCCEtN92JK1R5vL2qCYvmHkodlNYjCupnFJDpHyat3VxDAPgQL2fiKr8eTjhA/0mewQW62F+ml4y3xtM+8fnASTne3oJnsEpApbffdoEnUfUI0rYc+wTN8opxiBFIBpZ+O07D/Fp/ZVm2qMFIBEbIiMkEtI6Os+UR8lja8VaR2K586o72Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HChsp++d+vQ447UzaDeepN80Qt4wytKVXuIZMbkzxxQ=;
 b=BlNmDyYZ5rlhVVNRp8nsKAuZg3u+blNBuNeuhC5ecv8U0KFPk0Sx2Oe3Veos3KGUS5V70f95jgNRt899rzo7RF/bix+sRLHAu5H/FT5nL48PbekbiUpRBeFNAIMX0BjFKvu+XzYez5qK2AS+vcEeLXy2tHzcxI+0se6OVY+QiEWRmY5N42eYmg3ueG62AvevWmok2hKIEjJU2innFP4k2sB7idbCn1I/CtnLSEY8UHxyK4dLiwoNe5V8bw2IhgUx0TbOq5eXeafOqwouJRARKns5basKtdfluZS2MA8hStKTiBo/LqUBv99jhgli3hkB3XxQFMq8hrvKCbg+ZHHQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HChsp++d+vQ447UzaDeepN80Qt4wytKVXuIZMbkzxxQ=;
 b=MS3DFUnu8TdJFXHAvrjfgstyL02EbHlzvklRtwJFRKkmVtompfvtSHgnF+FijJ36niIYjQf+ZEF2jsMDRJqg+KfiwdGOJGgs0JydHhsCXbmLJJWQSlllXzpGAZO8aDX55kSytfR8xqObOuoKRa3kEYqIhJ+hMehnxFFeYQOWb40=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5182.namprd10.prod.outlook.com (2603:10b6:5:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 12:41:46 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 12:41:46 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606121017.zvq6d2f4vdroh66q@andromeda>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V2 00/23] Metadump v2
Date:   Tue, 06 Jun 2023 18:08:12 +0530
In-reply-to: <20230606121017.zvq6d2f4vdroh66q@andromeda>
Message-ID: <87ttvkhif2.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0091.apcprd02.prod.outlook.com
 (2603:1096:4:90::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5182:EE_
X-MS-Office365-Filtering-Correlation-Id: caeafbf0-403e-49c4-9348-08db668b63e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zio+329Xgsy7mrD069DykXGtNJOYpIu9JITcA8v6S5lpMReFVRSapdw9DGM70PhSn639qbdCle+52ouc7Ny4tqc0Bktaz6/+9gjyjh1yoDvgiMJufB26uAVpLa3BWY5477FnFUYbFhUv5AGKWSu8BvYACKBcD+f+GbsZrsZSwxqFzKJzK8QhppnyvOZJw74cyDhtW1yW42zrC/lG76ScwwxUYLgxenav+IeR32z0lnANkvjU8zvJrA1gBGXSHOZLVXSL5/hnngEQ06rIjzkdyG4WK/4tlAnOEAMzAH8yEqfhyDA10ONaSOQIC9M8bEG3wmgT9R5Np8p+5L7dPVDnnNFQmcsD5ixIvI374FZufKMt/nBNlsKZGEjmLQJs5MspeaygoWpua6Y0RTuHGj5Lj3IRgEnCNi3ETxUP29vX9c6vyL6bhfarrUCTUfv9APZoWzCamdw/fwoawagzUDFJCTLJh+J6+8IIZGVJv6P7wfBoyggVOVD/jOsYPPEpduz6r160PRjsQ4O3ZM8rpWY3GcvfpoxS311h/xWj/2DLOTZLQ3NulkMkYXT/iJmErfoOdoD/3PUy/Zr2c+dJFjKJ0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199021)(478600001)(6916009)(5660300002)(8676002)(86362001)(8936002)(2906002)(33716001)(4326008)(66476007)(66556008)(316002)(66946007)(38100700002)(41300700001)(83380400001)(26005)(6512007)(6506007)(9686003)(53546011)(186003)(966005)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fv6S+Nz2HzN+KLIG+PAGtbIYLXohnqMw/XfadObL8lo4yhn3E1UgQS0a9JkO?=
 =?us-ascii?Q?MjlRhoOiPoJXrdm2YDM3VLW2R3MAPIJH3MGoDtPnkpPcRF/ddVtfJZWlWWup?=
 =?us-ascii?Q?7iPyIP5aiXyhMQfC0ekYcuKJ8ebD/bHdXGK04ceJ1Bulr06C1r+JCTvdsL+/?=
 =?us-ascii?Q?94lgMzlGgzdhTpwnXo4riVmQY0a3gRdN1lwMvaJ9W9t18iXn6h11AR+Fbia1?=
 =?us-ascii?Q?LkSCwinPq9+X/hQ0h0QO0zyaC563cEM5F7b4I9wn+wr1Sf215JzRpH9WaoJv?=
 =?us-ascii?Q?OBu9keQetD96lyGS2Ub0U+5xyifJfNkNmaDoNGWOoeS8OwfyI/TUDkIOJTB5?=
 =?us-ascii?Q?xaolzTYJA9d0LGUX3Rjap79E3vEzRWei3q2ZP/Qk1T3jg6ZuUcv+ccf6YqFO?=
 =?us-ascii?Q?63QqYw3NcB6f4ePC8CrKR0tbl4J8EU6J6IrFNwSYjB9WqIDJPNMfKv51B4ip?=
 =?us-ascii?Q?dTFlGR5vzHx0ha+IW5LNTRyEkUJlIzXN20ahVQM8iG96NumgH6FxsU/5Vnbw?=
 =?us-ascii?Q?Y/RsWjF8cC0i3NfgVt5bs2O9sKLO1gVrOPYA0p8LbBPt/x8ua8hs3NLjhweA?=
 =?us-ascii?Q?tD4fIH0niAeXsqJMWsdRAXQXX1s/XKzlq6l+ggrt6pTOtKj2MVD+Qs2t/5pN?=
 =?us-ascii?Q?HmfTgARvwQfU2/cJKLcKrDNe5JDau9ltc//iWWyW1xXPpiHJL9X6yRerXk7n?=
 =?us-ascii?Q?1zMEtOQELkP0mHhlxrHTbTGrFjxQFQrDPb8qITI2Z4/pWSHNXdkw0OPozdcp?=
 =?us-ascii?Q?52EPT+2jhrKYTKSKzVAVXXQ5Xg6HniDc/dTOnHTnqeUp1Ki9PUi9tIZe2eY9?=
 =?us-ascii?Q?lTOMcrgkZvgr48wJGr4FSU9FlGEz4+dy6rlFCJqTNQO9cTbUd8w0JRGpuYbK?=
 =?us-ascii?Q?tzDxqxszomvxvG3oDQUKphYy2LW070GIwYQrG3SRgyTjrC4VzIqJaQ14POJz?=
 =?us-ascii?Q?z82SWriy0N4nkZu5kbF02zolMPdqP0Wi+Hf//tH6xrWtyDe2PrRxCSMHLUT4?=
 =?us-ascii?Q?8wbn5GbBv9zHzlMD/e+tvwJCYTlYlwySRWaKcZA9EO+Vnn+j8m/qQP0ozt5+?=
 =?us-ascii?Q?KFvNTlaru0fI8NwiNN87HhLNN1LD7Z0n+DcUUcqsxXTxtfJmoA6pR9lVtHXV?=
 =?us-ascii?Q?b2lBvy62UDB9BNGIYJXcCXEVocWS7Bnm1L+g26oFg0eBIDksmT3u22Z2hPIp?=
 =?us-ascii?Q?y96PXlJMjBJb3dtTElVjbY5KcBZ3+5ZCpyMN8dVRB+F7nBwQ+8mQk0K7Zm6j?=
 =?us-ascii?Q?0R5B9tasRNxrtO1yxytsh9TSKIFjN4YTPLakoFEw8QjuwxQNv96ouSA0+OWY?=
 =?us-ascii?Q?hOB7QmoZaDIPUWxwnT1E8PMo8nnFf/UQbgSbdKKPW3jzCd0YcEgB07wLlzyt?=
 =?us-ascii?Q?pkNcmM667njJZSNi6AGq7Li6t+4b16nJL4+GkazpYysUfBlbl/6k7dGRSeGx?=
 =?us-ascii?Q?oylf3lt8O3i/0vU7lOz9/vIWasLiGpEnPARakm4gguHmBkO04FcvcDTJFgH3?=
 =?us-ascii?Q?4dPYnzZsr2GUJGnJAgoG7PiL4HKqnHhxyPenHEbUJChtTmTPMXNTACX5ZeI/?=
 =?us-ascii?Q?179+eUqzO0sAE8mJmH4CUCDD16TPvYnZaFW5gj40wvDxeFkxL6o65GLTvrRl?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Oe6KszM6hvfe0URWoeCMxHivWhFvnKBXUh1rPvuMM/5Rs1D3AXNbeuxoX1ptA2ZhzJFVpnTLzIDoXsiTjOelkiYXizadSUEGggNBtwFwc4HT6T81tYaGuPsvjlnIR6bHgULhFADUj6nJvYvPTSEu0dFlDsAYVVcGJPgwx4oxr0sdri/giXHYI9Fe4r3KYuYj6TEsohce+MbPZpcbgDTYn55MWCg7U0K+/BLaXXAvUzFqRwNSlmqvL9VF9pFte95v2ONS8AB0fpMbgotd5GI5pulQ5fPqUFe/7aUSKc6aXUkGcrA5nSlFYNHmCXgGWde3Ty5LF35+g++ssk8tj3uAI7qZ8hiEs/X1fh62FIIYRYTv3kfqa61WA2JXJoifywr6z6ABHtTUwu4RB8m+4f8VqBxCMHlMCgjeU2wCjt+ihhxw3kVHk10vK2rgeVE+7Fr063wx4E20AHDMVjPqNP1cmD7e50zrQY6gOmOG4Wx8MU0+ByQEVdSAWy74wkCqISI1WqNekFaB/XHbhgFqr9oyIlYeHJ6Tk8CQXGurSudzhL2WIayHmQqcs+m5c5BEneJQz5kx+lCTu9ot/qT8QokB7CM3ZTd9nxi0pOWc4YqsVOYp9zlGSYH+Z8MMiJMk/AJlXUNkv7SeYrrBYcja7kUNGY1I/wFc7ZHziuOQamdB1YPIIVoLvaN21yunjeGMES5Zb5MfjWhgXvIFFDYZohgY5d+98rr17BItcWF1SAs073UXiIoLcLL4KWeaiK31lCWvx9pPoigBoDHRkz4ZWAK39CmU31goHHJJyVxOAJW74a8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caeafbf0-403e-49c4-9348-08db668b63e7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 12:41:46.6734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqFfYy8HQinCzHRUHJamBDSwLnadSks1mVpjyGE26ZxAdmFwgue5KRyNjmv9cS35AcAP9SkZxgNgihlamk0cOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_08,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=793 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060107
X-Proofpoint-ORIG-GUID: BNGpu7eiAKXp4dEctayAP_l6yhnDgF_g
X-Proofpoint-GUID: BNGpu7eiAKXp4dEctayAP_l6yhnDgF_g
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:10:17 PM +0200, Carlos Maiolino wrote:
> On Tue, Jun 06, 2023 at 02:57:43PM +0530, Chandan Babu R wrote:
>> Hi all,
>> 
>> This patch series extends metadump/mdrestore tools to be able to dump
>> and restore contents of an external log device. It also adds the
>> ability to copy larger blocks (e.g. 4096 bytes instead of 512 bytes)
>> into the metadump file. These objectives are accomplished by
>> introducing a new metadump file format.
>> 
>> I have tested the patchset by extending metadump/mdrestore tests in
>> fstests to cover the newly introduced metadump v2 format. The tests
>> can be found at
>> https://github.com/chandanr/xfstests/commits/metadump-v2.
>> 
>> The patch series can also be obtained from
>> https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.
>
> There is already a V2 on the list, why is this also tagged as V2?

The "v2" mentioned in "Metadump v2" refers to the newer version of metadump
ondisk layout to support
1. Dumping metadata from external log device and
2. Dumping larger extents (4096 bytes instead of 512 bytes).

-- 
chandan
