Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A37C001DE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjGMGsh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjGMGsg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:48:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1B1199D
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:48:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CL9FBV023772;
        Thu, 13 Jul 2023 06:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=suVEotZkRX36qktBqUgZkoyAzxnLcaky8SyYSucGnyo=;
 b=pMy7N+8CTf96NmUtoxD24qwj9jH3OiS+RSu7BDJOj8/B5e15jaoYWk355hxs+/lMtolI
 KlnDNpoD6eqs6wpCDcyeP0t3K8I7HyVSZk5K06kVtOIydohzTtkSGQV9K06AEwkYoBk8
 2Qs0BENL3I6bAyOEO4G27jB9X3vniwV2tdLd5aLrMHm34vY4gr0IpV4NESEqQiapdM74
 l488Arz/tq6ulBFgDeh/97ppLTHFDcWNtNGEItwFFptBfQ82bt90MSIN3xgG66MqYnJS
 q/QSeskGZAR/ZfQ+KHUsTt+6McL942KW7HQ+Mi0P84MBwHy9MiOQVOCu9/rPKytLoe6p BQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2xub8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:48:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D55WWL033236;
        Thu, 13 Jul 2023 06:48:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx88aq0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:48:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4SilyvOrMPCb9+VO1mYDUMnlTorteX6yqWt4yVKsIPM2j9GUrll+MIXXhldHydZSp4QBnkIs7W10tOAIBLkOlse788jama4q6f9o+hi74eKtCa7Zg3qqYgjU7OmwZRPWctnU3mQD+njhHSqpEIMmaXS0AU7fdemfldJbf5DYdk8rdacRjQwHBJfQx10hUqClCEhtJ9aeNikHg7m2Wq6L7nCA67hlQGHMdco9OAeBdUO9B2MMvzZLf610Hdo88VM9kGeC+a5vnwUwKVzws1a6GoeiNGJI6cuRu1pfJ44JRfLgf062EH/RsJZSOyMhyUizrxnOlCZjKOGbgjjeAk1yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suVEotZkRX36qktBqUgZkoyAzxnLcaky8SyYSucGnyo=;
 b=fQnC9+LZIOHKEW3/zQG5xY19OYAry9cHzhLHjlzK8IAKWWwVuTsgUBENM5qb5p+XXwpdjD6szR9mj7GxKmW7GcrXebYka9hwQvyIf2BCzC4ra7SkDLNDRBlBWkwtSG0JL+pedtlFAI9FpXnmJsHjWJB3Rys4JpM31GPOcisEQt6C4dYO9S8PGPkTt7mN4BNz4lR7fZa2M+pJS2T2k450WiNv5XCB9/mBtCiPNd2pFMCduYRSFdu/DRInR6dURyR3yGX65OdUhDS4AO4YWNIiXJW2hVVYt6Dh1Lg3Z5GNRndtDCmCJ2lUFYxJ/IHBZTqn9TNqg4SpK6RrYL6Ia2uCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suVEotZkRX36qktBqUgZkoyAzxnLcaky8SyYSucGnyo=;
 b=DWZ1ReOoy/TR9ta33JjF0WOtp3VJhn3VitU3b+jL64d2Ex6kl1MuksxLnb85N28+L7jFOfwkv9rnHLY01DwF5rQ9sR9rkRBrQ2auF5FXgdZH7RhqZhBMi8ZlJtvxmQ4rLZWMiRC1jfczmI2ujGGwpEsxBMDvsk4YXqfUbNOlG0c=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 06:48:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:48:29 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-24-chandan.babu@oracle.com>
 <20230712181028.GR108251@frogsfrogsfrogs>
 <181e7cbefa39e2dc59f2564c25966ac0d05aa6530483b7eb5d649de9a3d1cf7f@mu.id>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 23/23] mdrestore: Add support for passing log device
 as an argument
Date:   Thu, 13 Jul 2023 12:18:14 +0530
In-reply-to: <181e7cbefa39e2dc59f2564c25966ac0d05aa6530483b7eb5d649de9a3d1cf7f@mu.id>
Message-ID: <87sf9si9xo.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0166.apcprd04.prod.outlook.com (2603:1096:4::28)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4551:EE_
X-MS-Office365-Filtering-Correlation-Id: 49a5e371-d63f-4cbc-c7f6-08db836d2a7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iP0ihmCiZ7lL4z510jvhbmXWLOMmMo1yettmMbkIlZK1gNkyC3RYZOTgaVkg3DYE4hSy/ukxqqbe6ALzEJqhIGWqlltSo9njr4J/0aAyB1kodCCdElc0MoMxb/gWflGxmwchK6oPeI666OiHNuOVZGtcQr8zldVZkHiVZK+XBJbzGj1t34Q/eWmO6E7InMUb3xby3OqXA/xi1ouaI2UtsHiUP+MIGoYSULrRnXM30UPTaWH0lw0HbOylB98MfwECGhV85rWF/3gi6rYv2tzgx1VqW41ytrGhetXlt4skneis/hZTl7KxwV0Rj3M00MWIKuNWrpkEz9xy3VZUEhA7gLwJL0WsXJgDnEd8NuxZSuJHmNBXvmtYe3A6IoJEw6r4j42XVVM+pUcPR/iJ+Y+2/83C6dUR3QNdVXNAo5kJbPtD6DH7tvC9/iA/31G5WMD5UWIGaCR1zjqO9+Edi5+81Q3RNdT0puLGBTEyFxO9CGKCYC2ve+CI6bm5r4bdj1+BJrrPHLo6mejUyUSDF7kBy0IIWqOVpb2TQ19ZW++kT+6wQIy3XrOvn4LI8nwapmnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199021)(478600001)(6666004)(6486002)(26005)(6506007)(53546011)(6512007)(316002)(9686003)(66946007)(186003)(4744005)(2906002)(33716001)(41300700001)(6916009)(66476007)(66556008)(4326008)(8676002)(8936002)(5660300002)(38100700002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jEZbNxXnc0UMwY463q5OmpMPgeWtnR2ne2cAix36esCgaXGrVkP2d5FdRgh9?=
 =?us-ascii?Q?Tlg2NT0Wcijy8rLc1mVGYX9bMrz67TN7jgkg2DbHfl3YDCbnT6hVbOI6RWSk?=
 =?us-ascii?Q?Kel7aQ4kw9GoQcKpSR4fDmqMKWamE+Xf3fykaNV2wWd6YxftoRS2LeBbFVvB?=
 =?us-ascii?Q?5CRGRWOGY9o1S7KmJU7dGw89ec3arJHfh0fmAvLAgYHgd5/32IBugqeaM/iA?=
 =?us-ascii?Q?M4eYFKyBr9JRdETv5u2wBfnJ+8D+EYwh9rK9uR2CMqL5/JfpK2vTooTcFOIg?=
 =?us-ascii?Q?THzFvrNcRsztFZIzdDYUUIcturXdLap55ie+UOinASaxGc8SHEFHPDOceq8V?=
 =?us-ascii?Q?VOM3ueUJ5hXZTbe0czWfZDqs76Kj4jUwsncKrrVEED2aTAsLhK/274s14aD4?=
 =?us-ascii?Q?xOyKlnOFXB6Wca8sUwHp0LscA2oDmGCHEMz8u9EiBo+5cbbXqvBmPc46Y12M?=
 =?us-ascii?Q?SgUIHfvUYNdWQJES9ilIehqX5Bia/A44jp+Wc/fX4wdXEGcXLJff+ELqMW1R?=
 =?us-ascii?Q?BjDmWbxKu/uv9p4G/376K1jMWgBu8VCy8paUDxnQuhB9HvWYW3xw90diJlHu?=
 =?us-ascii?Q?PlThAP4ICGJptxd5I/ybSZtGcCcLpwDQNXOnPJoeg7R+xMuJQd9K5g+qJ2io?=
 =?us-ascii?Q?Iu2XsfeK40wtpLIiLbcwd0ohuP1S7Ji8sKg+t08LCMIJ24793hWKzf5bF4Vq?=
 =?us-ascii?Q?7dhlbBSMoJStB3D0qxTBvUYZp2EF/t4nMw3eCAQRp43G6e59Iqc2CwiswDk/?=
 =?us-ascii?Q?PJc9Mzz3HftDIGVsgOsakTLDQDqPNp/4GV/OrnaP5EQ4ikfMkIVWv+Jy2tL3?=
 =?us-ascii?Q?vHwQs80mhM1TVUEB/urSwue3f83j36/0uNDPcOChP68HyAkJfwfIPBT0/sPX?=
 =?us-ascii?Q?gJjMNjgAkFmmID39oQ6MiGpVohRErTSeHQvTtNKhsnc+olNpF6LsgClv9IDw?=
 =?us-ascii?Q?FThWkgLz9a1vYTX4Yz9kB0AN3pCX9Aum1zPwOgCsvPBHSNnEQ02yZ+4AWlKT?=
 =?us-ascii?Q?boIJfJJSkZ2AbZowtsrrYb71Kwtkqccin5FVQ0P7b45QbBZB2yAXf3Txm3Jf?=
 =?us-ascii?Q?drypR3gu7TsUL3wtvmRRdv43N2pbtEcXrzVtL27Pk9W6Tf7thKuq2gA0xglP?=
 =?us-ascii?Q?fEr6YExk4xw5cjROGCzmj5LGrjTSgXgq2xNHNyphbIgCKMEB5JIkOWgds9xZ?=
 =?us-ascii?Q?Fq0gb9gGLkdFOWD5gxNUhdbwj7OdaKp5PZhQo4IO9wrsxhue+rv3sIzaUAXq?=
 =?us-ascii?Q?gMb6TH6WCcE51CJMGe3WykDX46QC7k/xi46jIT4N1nWcEZ3KKWmtaUYT3tIl?=
 =?us-ascii?Q?UZKu1vo0GkabFXMavLblB6gBUU/S1W5f/mf4YM3UuhnVHg7MXg8Alzi6tRH/?=
 =?us-ascii?Q?MjxrPgN0wslmo/YgiA1CaEV0cAFBAgmSloOlEHUJuAPkJRIuE9uWefIlhWIi?=
 =?us-ascii?Q?q4TZylyjvS4Tl1eKQyhEpvUMXRSvDoV7LZj52CL6VAOKNHScKsBVuQK3mTIx?=
 =?us-ascii?Q?OUCUowHEumJ2hi+hE+kCd3Cqv3brFgmuFHAQWXAQqAvVxeovWOVhDviKaK6K?=
 =?us-ascii?Q?NMT5NhIlZvT4UZ2JHMFF3mhFuQnwx2S8SeeGU1iX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: utlgtnS8tfjFu6d8v7V77hgu5CZjdLcjf2Gu89eS1tVMqmt6mCcvcxjJOy5NRr7zlwLPpaUYq637IURA6GOOoh19geMEExE7djktBA3nMXr2JCLd0bNSGt8Hh3cD7OuCrLkGwToXfTF5CaAUuCAhl342PzrnPrP1tQXfnlUpdvLdjgu122iko9RzX/NLUfOPzpXTRmCMSAYoiEYOoJb8fpiiCYR/dOpUVc/U1MBUSyNyc6pdEjZfbQkZ9FAsOhK9rMtokYxnxDkbb8fScP7yIKDpIl/1RuNEJquhRRnfNcXdFZ+PPi6XFAh1Bi1HToqVQ3RG4lEzyNa5eXDfC4+/mjgB7/asycz7UPF1hwEXrN7DwFwX9Pryx1AuMTcYLGc4XpoA34+BKLydmjhhZd+wo8t/Baexoa7qUnflq48STzzD1JCqlZdUcbE1lNTcYIKiLpPHF913+9vTfYxwAaidhX2paqmC4NFgtX2aEAWsNnhq9131nv6KZrekn5DIVCra2VmuP0e5WlGM9LYsGJbNcVGcj6eU/MGN2HK+0a0S7yTHMNU9DLo3f/AYj+RLYMKOgAhpOlklQNbf1zZfOw5UbHXktL2GeX2PaJim7K7/D8PhFM2GITyifJGb3MWMGP0PMgp6+xtKLdoMRGZLcy8z7gV8Y8oUD8sRXTzwHkJTIqYgjX6PEKg4MU9QMUKPs9yq5MSNI35SBUnQNqAF/DNQhQ0pLGJZ+dPp9iumbBvwjSEIWUSE7niHNEJyGQHiEWV/1JBd+La88MwfkzvnWCwGC1kGTuWVQSQ/SBtk0FRkvcc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a5e371-d63f-4cbc-c7f6-08db836d2a7d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:48:29.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwWnXSqivu8JuiXMuo14DkJ3+qkUNyxZFSXUPPDRB808eYjNG5XIyDESEaWA5Sm4MK8hRO9/oglfukkFfXou5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=981
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130059
X-Proofpoint-GUID: PGVWt_yQObiF9aCS1aMpNk0m2MLQcaCg
X-Proofpoint-ORIG-GUID: PGVWt_yQObiF9aCS1aMpNk0m2MLQcaCg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2023 at 12:04:25 PM +0530, Chandan Babu R wrote:
> On Wed, Jul 12, 2023 at 11:10:28 AM -0700, Darrick J. Wong wrote:
>> On Tue, Jun 06, 2023 at 02:58:06PM +0530, Chandan Babu R wrote:
>>> metadump v2 format allows dumping metadata from external log devices. This
>>> commit allows passing the device file to which log data must be restored from
>>> the corresponding metadump file.
>>> 
>>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>>
>> Woot, thanks for working on this!
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>
> Thanks a lot for reviewing the entire patchset.

-- 
chandan
