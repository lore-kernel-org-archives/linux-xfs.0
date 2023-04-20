Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F58C77B72
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 14:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjDTOkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 10:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjDTOkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 10:40:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F1630C2
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 07:40:10 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KDu12h013171;
        Thu, 20 Apr 2023 14:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=swEtVEd8CzVXooPoHRKiPFt7qVpZihnEr/sBcddkl78=;
 b=sL0jyK/jYMCYtV8kaU7CmkaV5jEOet/18infkTIwcchOMoXJB2Sf489OQr528vhEX+TI
 wmIMMhL1ZiH48/D7p3heSm8WO85LgzwQc2IZkgfXDlA2RwCD0OoATYeyixSySecWZRJJ
 wlcyKsDAcdmZFAmIR0GFWteMHr5Lj+uB/5ZxDwxaA2QCqnM7Tr+6QUUeUClC//RATKnR
 28Ns2+1JfMLeSvq1f1XXegYbt+z4DEmKr1modmitaYlbn3DggDWBbkQJXaZ+PWTEM1b3
 +HANNgUAMEJ1NlPIxooPsUfrB5aWSS232bvhKVMfuQD1q+mGumCDJ6YmgJr0f3ptj30p Kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjucb4xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 14:40:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KEWRZT037932;
        Thu, 20 Apr 2023 14:40:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc8bw2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 14:40:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aczJV9/nwT36nDJTyIn/wQ1bDS2JM+FwiBuU6ih29h/Jj67BnzoeYMdltrq9i6Q9lQ57nTT+kJ8m0ZHYn34mXBmJG5BGTvP762XX2PTrgC9QRylJkw5/bmHfqKeE+YY9UFBmvj197XcZ1BrB7iFsPll8WjE++8Rjh3YS2nibw6yY53Zez7g+1gCOAj1ATJo/XjMWJTh+5H4uaAp7yCnR8P5mUeX9+Uc4+Z8TAzpQkuV9Z7cUrl6WICIoxtVVay1RDT7+SWi0xd4xpOlGST6p1mWSWqYVKN5t7NWAbociaYmS2TgIWvyJJm0mF1Hr7FNOJRFj+J4kaU+TidM5lc7HWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swEtVEd8CzVXooPoHRKiPFt7qVpZihnEr/sBcddkl78=;
 b=DLcxdc52Ooo6rzzDCxfEC+amNdM/IF//rf9QFRE2opUpnWOmWMQJkAkur2OlFBv/sD0VRxv+lK9lqc0m+7072P5bUhNPVuKivmAh+rMq2tKmSkSBy7vgacuJ0ppn0wdoTuETvuZX8IrlG0Gmzv++qKFgf5AmEDTtzSNWENYxHzy3qPwVE6dfQKPHkl1NLCZi1Cc3TNzrWoA0+wBn5cCcv+T8Vtw9ES88KWYqQfH3rg2xU+8xay7fy0I/fAHUurp3Q9+7Kl0vN/LLNlTMMajR7YyA0TC74Jjmllq3dlgE/M08NJxVzee/gw0tzCIGtNy6sRcdmuSqxlwA2Os0VvvWTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swEtVEd8CzVXooPoHRKiPFt7qVpZihnEr/sBcddkl78=;
 b=S8cpGD16mBcNESGazD0FRMvWQv8Tfju+MGQJWxIvHRt2FUGUckFV8sn4IBU2n1Cp4k0cPXdN27nujROKeUE93//GEzrFhrzTL03G5jjDweayNs0riIfMk59CehCBCIKj49Klz/4UY0XgIrui7+gHNiP9Gz/jJtwkn1UnswpspUk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6743.namprd10.prod.outlook.com (2603:10b6:8:10d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:40:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%3]) with mapi id 15.20.6319.020; Thu, 20 Apr 2023
 14:40:01 +0000
References: <901a579d-f43a-157a-72df-6725cd391599@sandeen.net>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Marcos Mello <marcosfrm@gmail.com>
Subject: Re: [PATCH] xfsprogs: nrext64 option should be in [inode] section
 of mkfs conf files
Date:   Thu, 20 Apr 2023 20:09:15 +0530
In-reply-to: <901a579d-f43a-157a-72df-6725cd391599@sandeen.net>
Message-ID: <87edoesjly.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0001.jpnprd01.prod.outlook.com (2603:1096:404::13)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6743:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f94b349-d76b-4c6e-2f15-08db41ad1f52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqohWcB1CLKtmNPTmIMj8iOHc+OXIAr1qNKt84mxyPOakP9s+f5n1rEyB+bEKBaC9NAk8n1tBDn2LsCdrsT2ULyvEGs0b/ChU6JuDAWo05jAvKvFMkTZS5Iv2XYIbZ9U3ryP8t2eaDv06i2xvmNch/YABO7Hwjd/CrC+NGpPtouDpTmNbPGMhTlnyXpAdETUJv20Pd8Owt3skn0lOhHPjg1P0NNkvKoroh9bDAOFCXn7uN2o4n+dREwTEHNtprJgOpO64JslUIqM/B/MSdko7RLo1QtpYOqii9EWAkS8HMLc3fDHezY3QtsQyye2hKyGn1EJhFgSayzC2SGyToj/bd8pD8TMVsF6yMAUBNRXScWQZEwrgVQaNYq2d5wmlE4dy+GrYjrdJ1X/VLWs8lm+FFoRLb5KjSujab8If5Iz8eoD+1EJuZT30asrAZERw5ENjQZnniM0qv3DpeN9novIcuN1hQDsOU8O+U0429lE/hKnhrhdiv10KMzNHPvA0kwVRgZSczMDPjiHlEKCyc6HRDQEis+Iv27Z/Mfp6Xk3GPkYnM4nYo3MrmuvN+AVsphW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(66476007)(38100700002)(2906002)(4744005)(8936002)(8676002)(86362001)(5660300002)(33716001)(41300700001)(6486002)(6666004)(9686003)(6512007)(53546011)(26005)(6506007)(54906003)(478600001)(186003)(316002)(66946007)(66556008)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O9zVA+oMaklVId/XDCBv6q2U8TrRIkK3xL6wrKu+RABHrVU0ZqLAHsJ7vMaB?=
 =?us-ascii?Q?aqVVp+ciR4ytmHdhbSCedlXWcd/E5lvFD24F9sgD2X6GZx/RG2ljt2mBZfBK?=
 =?us-ascii?Q?avFj8iG7f9b/QE+E0ooRmZmjuzn3yqSELTtAYXKU7jv8ilx5G2xABPhj8iNU?=
 =?us-ascii?Q?p6NwpUqdhhkvM+B/3khuqhLaRKFIQicMrG3l5W1R97xcVA4Qt4sBGS3NW4pW?=
 =?us-ascii?Q?GaCV33M/43ofsK3AdXC3iF83vwUY0lC293roh/vfFMlbUgRTXx+2rgYvRJHa?=
 =?us-ascii?Q?oImBaetjdiS+DpFMDvRQpucpcurm1K+rvRWJL60j6gKmLRkAlGsMN+XDjbAN?=
 =?us-ascii?Q?9J8PF9XGnxair/R3INBPghG0Fes2Y0lv9Jd0x4svOOultSrbMhyztReMc2EZ?=
 =?us-ascii?Q?Tqw6baUr3T/V/g3oWc7g6Ga4dupFviovu1lDwbIXeMzSAaUQ0hHyQPLBXjfz?=
 =?us-ascii?Q?rzNlioZOpS9j7Hnb1Q2lihyapgIke1ugw1ERFTyYlA1fnuTOdw+2i9G3BDE4?=
 =?us-ascii?Q?eEJPAmn3ZyaVxk79p/FsKn/t/71hQlOm5Yv8VTbBeMP3tyF/TcSRZ4oN2NiB?=
 =?us-ascii?Q?HZXCZYJ9YGUiXVMUNI/EXAyv91wAgV2pZa3UP4xy7pSiLdL+Ivy1o7jzOAXr?=
 =?us-ascii?Q?rPplld9DKccPtp1QtmFU7uFu72q0XIziNO3DVvFbVClbCfikwiod4asCfUhv?=
 =?us-ascii?Q?kIQohGGW+1u4M/fcNX/PEW4GiFDOFQlEaa9Vp8k3wQI2p6GGQSK94HPe7DLq?=
 =?us-ascii?Q?8eADkvakVeDuc5rfdKwEDrpfHHBA+GPug6nYy5DuE7DZDiRc6554c6aVpKaL?=
 =?us-ascii?Q?9Q71oKK3Z+A/KLeY1xgbAl6auvR2pLJ2qEnQ7Bw2rdTl6dZp5kHZa90ah6P+?=
 =?us-ascii?Q?qH2nYy+69k/GgdVMTOjRXuy0AW4n/kHAn5NycUjMuDal2Yq1Q0NQQzKxKSVh?=
 =?us-ascii?Q?sUT+WSdR4yk0a2LOM3ZbUV4+nv7++LiIsX5Mk7N3A3fNBGmb+Ph7scQ9IN6l?=
 =?us-ascii?Q?1UJViS9NSiqqQBJmjQ9JXzR5D3SjPuP/zANRNe5Jja/2VGkGClNtf8vwlRqk?=
 =?us-ascii?Q?ECC5fO8rlePhgQ2oeYyb1zfX4O7zaoswUrFQVO5umuJT7bSPhbp/yLH7Hrtt?=
 =?us-ascii?Q?0S40fyDj+UUEweK0POQNOHg2DuUE1qsemG7rL3GQXVzUAH7uaeYq1uXXjev0?=
 =?us-ascii?Q?CwTeHxnPeC5LRoaI+m1BGfNLpWBByDd0WqUHXv71JY2pz1A0B9Fh7c6Sp+Qa?=
 =?us-ascii?Q?K6NVTOXlgwPJJh7vjAoVp9g+PlNcLQzWsZYrnA8TcA09pwx4dDAxvyXSkO8c?=
 =?us-ascii?Q?vpSNNFCQWfklr4n3up5hhKqapKIcVbAiQQ+I+9aQDw8lNeXsWVWYzkqy2eD3?=
 =?us-ascii?Q?g7yJtXOMhl8qBxm4UxBYZxPql7W5cabsA+FgLs+KH5naoWzZUYItW5fa+rOv?=
 =?us-ascii?Q?MgqTSFetvEoUS1nLoyQEFCkt62nMilrXTAzbC8jYE2/PdpjsmCXreMIRA/0j?=
 =?us-ascii?Q?RNhUN+1K7U7s2g8au1loiSnhaR8cr/KApRM2pA0eHyv4s/V3WZ1q9OOiNB+h?=
 =?us-ascii?Q?1RP+6LyXw8XEPhZ9iHlTK08r9bFiC/ByNA12vbA4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KDYcrfgxN6CLCLDFw6vFe+Fq7GaXNMsunV4HNwwPWp3ojpK/pwsXyO7BeYiAizAFwPSmxAxOC7nwdxm5clMu48IIBxPRyaHKaOzryuS2P76obNmeKBldjTaDQOrG9dFBTC3stLVIl3v7tIKwzYKK7lXUyvxE2HDAv3mLQh/M0zZ2J7gjucavxLhuUKSmE7DfkZpuKmuu6G4zI9qsH1KoEwRvyajg9cncESPbA8jUTSNsJkLuJWZ86dyHBfMWC4HKU0fv5lX8o5Rct7TKTxM7K6u1ufgy4Y7Xak1rxf0dnnDKfTqgeEIhIDDU3dVKYNm8CfoTW3EW+Dyprir1uqy7uxlhtZNJ4AU7VdMi+VFUNU1+NJsrEnhpCjIwnbjRtVlPKUXhXUrRXvy8APxavhhGUcudmO1UU1pLUB4qo2NDEG/v2tE4WdfUZ0V4wVizKE+SCALhnz1LLgtIkC7VjwUN135ac9TudivwTZt/xMF6spatJQ9afryK9xluKE/HuTuTcx6fY901wio/648Vfvc5O0K6Q6g8zE4lyJITpixVVvqZ+cJN3uTAUtUy4lJJRIraxh4f1BlX72QJvsmDgD+TJ+G9/s7TE2Da3FO9rhWvJKFi6gjOw6wF2Bj3S8fTDSL92fRXHKTuGcbFXwE5ar7tkTN6sH0fj6KC83RJGUFdMkz1zsJLFBnOIdZ31+v/59PGLbgoQCIGgPD7mJF8LPjrS49Q4E9NDdw21liLgdhF5eLChRBY+lZJ2tMBFycK3iUmg1oJepUcg5FFLZsG5R0m1zFdOpF8QN1hRpEAqNnIxKdwTS9DHmzwhn7fAe2bxo2OKyKcB4o3Uuyfs9cWAE8AZ/CjIYrqSJW1mw6YmMQjHbc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f94b349-d76b-4c6e-2f15-08db41ad1f52
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:40:01.5745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCMQ4TGerV/7ta+lkGKveRP8zmWxLtdQ6Yi6WtwHi0ldejb3g9leMsgBUVWCXCUufy0R8yrK/1Ene9SnoqkdBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6743
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_11,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304200120
X-Proofpoint-GUID: 3QXaW58GtpAi0qNyHvreX7yV21NlIuI9
X-Proofpoint-ORIG-GUID: 3QXaW58GtpAi0qNyHvreX7yV21NlIuI9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2023 at 09:01:01 AM -0500, Eric Sandeen wrote:
> nrext64 is an inode (-i) section option, not a metadata (-m) section option.
>
> Reported-by: Marcos Mello <marcosfrm@gmail.com>
> Fixes: 69e7272213 ("mkfs: Add option to create filesystem with large extent counters")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks for fixing this.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

-- 
chandan
