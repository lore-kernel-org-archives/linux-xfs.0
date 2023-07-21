Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43CAEB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 10:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjGUKAi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 06:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGUKAh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 06:00:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B3F10F5
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 03:00:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMq1g027141;
        Fri, 21 Jul 2023 10:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=k+teW+cCikAM2heQ04c7W+d0A+P/Of7O19Z3/RW1Ot4=;
 b=Vcmd/uCJ/441ShHwCFizJouYzL8UeO8Joxqi2brU5cCVHgeGIySm/jnGpRfUDJaNeRVg
 JX1gefM8aRNR+OfpPswJ3AHK2m1fzDjPhWAtDM3mcQuwkT/V1SG5/0fxtxrigqtSF/eO
 Uvhces9gU6VZ99Y28C4PilcOW6uGT2Z0NCekYSPtoDs1wCHbIn3n0qwOf0h+Zwl4KFRS
 x2GQ2dnNT2qX8unAJfvjAALjlh6sH7JU3pj6mr4iPx8dFHz2/51yycOQTapuF2xK/93G
 IJvYdVNqEHyeGesDkH5r2ejZ5T2wXL51Liw/cArWXtP2G5uzCi1fCq6a5kdr7fNAzYGY yg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88upxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 10:00:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L7wdLL019173;
        Fri, 21 Jul 2023 10:00:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa9bu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 10:00:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhpRqwAZRUY4rg5vAUITAhfTbl1b0pv6ArEZrW+FY/nRMeVtr0YMbL8swLoNcVHqAjBEntaGxpegC+RCitrc1Unp7K4Zg1PuvGDZmfQinbJis3NkSssGmMGDCSgCGk4rI26wP1Km3HcxkBBqGqmpuP2tCeCKEO7t9C8ufKR9ROKw56PCc0UsfGiT/6upJtNIQHGrdiOzbWjx+Dji8B6JKdu/bs1F7O7FFwXmN/r3iHFwbRzZ4nzVKm9L+AiRJgPMRMqrsz5NXesaPwSweGMet7Z4kauC1qvF641EjURLp3WZ4PHnC/XVAobVVVsoaTmdVGDKX3ISwrs7jeSKMDrCzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+teW+cCikAM2heQ04c7W+d0A+P/Of7O19Z3/RW1Ot4=;
 b=UXnvIeRcmbGScPhAi94+zxwaFi1J9Sww7EUE1gtwDvV8vd6C+PFn1EJiXj9q5ddaS0boArrhB/nllgKDF+Lrdj7fLGsgivojaP2b6cqAz+8Pg2ep9nOud57T+oiqJNL3bJEBsiiA/KvxojyWPQ5dppXR0eaNMkwc1hM8JHeguuprCWs3Ir2GO6C4qk3gQ6TF7006CmRvVP1WHxboNm6hOZCgMAE4nK9sYA4WkSruOyyA2W2JI0ONRjIWqo8U+Ik4v9mmIUsVkkS+X6a4+LC9KQlEb8qnf2y2I9ZlDNo3ZJy8ok6DRxiypvWvTP2vJrM9xficmcTd2S29xgXlyckODg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+teW+cCikAM2heQ04c7W+d0A+P/Of7O19Z3/RW1Ot4=;
 b=F0T5fxVOIGhxDl6kv2e6+ZlAgjpd9SC+GbrRHfYh3mx4Lg3wqEuV5c9bhKPeL3oizx/LUdAmAQmBkH1o1bqk7r+DwU8Yo1KE9hEk3f7X4I8qc1L66l1pNChjWuKVUBcy+wv0Nt78gXTCTV4rAtUrP+qyuWkA3Lk3VOX3LYCJe8M=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4482.namprd10.prod.outlook.com (2603:10b6:303:99::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 10:00:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 10:00:09 +0000
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 00/23] Metadump v2
Date:   Fri, 21 Jul 2023 15:27:54 +0530
In-reply-to: <20230721094533.1351868-1-chandan.babu@oracle.com>
Message-ID: <87o7k5mvod.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0311.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38b::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4482:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cf77329-9c31-4030-1790-08db89d1447c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpOs3NFTfa97j0Vja4hk9/reO6UoyqaYvFSFWc+yHRIt6E34EMh2sOrZU7H3AdkiCrekmihPt2OfsYgRLPyEXbIJAIjh05tg12i+lfMmNvvjaHp5lwWFGUOR3x/j+nejtPT5U1YjSbdBwa8RuaATMIBbofSCp4dpSomfZNBCMab1+ugKohY93vuzWk5fFRNaFXvo3zLNA4XlnoamuxV+95v8GWdBUj7C9WiWcZXaV/9rJadndH+BkJwPX36cqpmvFfBqdA0P/HKy99hFos73ComuawCijzB7Av9RgKBhcxCL6VvKkBYR+1qCmlVEKXKlq8LrCCkRfZmkQYiz4NP8SpBtQJxacs5ssZaLcr5G0YT2ozIen+kAgUjMMqJyb5aJKH9cjEXb3Wb7/a6LPagEt8kUqWENMgwCqlY38GqTWd8vAD039QsIpJG8rD22K4iZIJBYXIMna6+EEOgASLcdf5hBm9zyoh6r2Z/Vy8CjtZSk45a1wI3VlPySqDO+uKXGv8rTLiqVl3K3HwfpYRoUivHFJfgTo9qGJ6YIuVkbDF3Ddrt7CVq/JNt4+PIjurvbUIYf4KwCKP/3dEFKN0+W3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199021)(53546011)(6506007)(26005)(186003)(8936002)(8676002)(5660300002)(41300700001)(86362001)(2906002)(478600001)(4326008)(33716001)(6916009)(316002)(66556008)(66946007)(66476007)(38100700002)(966005)(6486002)(6512007)(6666004)(9686003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JkgGfEWLL+YVdVkW/Zv0JuIpdzVNrwV4e1VWdOComuoSPyRFK4ydbvyZGNNh?=
 =?us-ascii?Q?xvnCjbScXCpUXJ+fcw61BssEqQfBBo/eRJLaOnwCe5dQNReFFQs56X7RKngJ?=
 =?us-ascii?Q?L1i3Ea+IZEyU9idsWqN8eb6uBLbKaC1yViMmfBK7ID4bHYztEJbOqlFxlneb?=
 =?us-ascii?Q?uB3W7kld7PawB9TA8tNsgvFUBvhgETcxjkHJqnh1vqJ73fetXeJ4+9lvMDh4?=
 =?us-ascii?Q?U/oeVSzsPMqJhjkb++MmMFajgeR+ljK6at9Vw8nnQtR6Np13fJ/ZqstxdxpW?=
 =?us-ascii?Q?O7NH/zDeZDL39hotPrFmm9E8Er5et93P5QAEOU4UeZEMuJVDPA+L/2XL5v/v?=
 =?us-ascii?Q?AIWaQeHNTUaRJvyBLYN1Qj5mQCW5p4OMDUbmwLQyptVUEXwJZInTE3K2eh47?=
 =?us-ascii?Q?izvl2LY3MiuUERhoVrU4Q+DDNTuUO8jzF8qUa+loK9wvaBLFnHTcdafUW12j?=
 =?us-ascii?Q?Ici0u4R1xjsZmaFW0iJ84IwIJOSae6E0cS+pWuQWXAL601+X3kcmbi9VJlIU?=
 =?us-ascii?Q?PXQAoZx6y8u6pYRbariyVBRbaTgWQK2jrYvqGUJuR51prkbwpiQRM/RvQ2mU?=
 =?us-ascii?Q?wsjli4LS/4o1jxdQO/g0uS2NXDjwQWa6EM6xxfVin9pDAE34hUCrmkAR1bUb?=
 =?us-ascii?Q?eaYcP3l/Smhlkz9SluMrpITqtJ2vU/jWldsba8wVEYvrftB6155Qf5xS9eEb?=
 =?us-ascii?Q?K1tKLglIi4QH9MIi8xlmV5JJMBE3+1gxrxClCXGgOrJ2BHBmimCQ+0mCneiJ?=
 =?us-ascii?Q?HLgEzfNX0Ea2AmAb9JbduKgyYOv8zpR3eKYn95m9aVlMWDgN/cBfxTtkMk1b?=
 =?us-ascii?Q?XFuzSS3yKdFF2yFzUQdf9IMoY0UhZGDvvMjWGvVgyI4jSxg7s1155vAqq/F0?=
 =?us-ascii?Q?staChYcBgNCKsYf02FU4qVi+/oWgQKktxAubCvDMDaG99Hw4aQ8X4kSMBAgY?=
 =?us-ascii?Q?goU9BZVsY+zygJY+OekKHNfyjmJHUuOn4aYpDPP1oqVXy/ZdWCrOIp3jjwac?=
 =?us-ascii?Q?AIXZo/uOzaVt56FdFvYi2VdmqwdH/Cjx0BF6X4yio4bnru6YaNGU+QvBbuEs?=
 =?us-ascii?Q?NEDuC2HZbXyVew+K7BqCf+45QufLzyNzMlhiZ8Tjw432dud8uGlnCH33ZbQU?=
 =?us-ascii?Q?P2We1pJ7oS/A5hvLLRRm1dqRJYkCgPqFlNF8wIhJMgC4xN0JIUAgiyabwacY?=
 =?us-ascii?Q?8EP3KFzqVbMN/H2avUL8lVyvTlOe0KLvMVZXcDqxgIwoJnSp+rFGfMFhpREm?=
 =?us-ascii?Q?WM8gHOfVO/+INRTssO29jNo1QtJBJxjuZbTYrT2NSjclNizOZwOXnJ8ZXuQ4?=
 =?us-ascii?Q?2qrmITwlrJWRIEjaYwiknBu6Ja94mxPwXUd1N+pmRnxWn8DGxotROh7rJ1Xd?=
 =?us-ascii?Q?Ds99ioCeiF9nSIdP5bzmRVUvv90ky58sjb1wMWU+PRWmShny6fawhb83HKJZ?=
 =?us-ascii?Q?QFnTeHy/LrBda1ThNjSebqnoZdkAzMUmMNfD8LZYjZzx8BoUHk5+vHrLc1HX?=
 =?us-ascii?Q?bLELcbNFdDtdubQFRdz99gzGOHYCmBGhUkw9PoN68YmOmWQenm7XjBFJbiXQ?=
 =?us-ascii?Q?/AylYpAV5eU5V9i+B4iXk5TxZSGaKC2GZDAayHEf7wVNwH41c/TBFFmxnBa8?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: p7KoVB2PuZI2hvMt5k2u9wEtkYMhlNqZyA3mvMm5zZ4pqIPJnvTjS8J01xiaqncD2I9xVUOd2cYLaf5V+Z50xuAUQ6gSgey4hUU9XXpVBNKQSSA7srUXrytdjUKlhH4NNjuZPnE7YewFZo3sfTzR2PsA+P71GHrI0PSjfoxP/EB5FM6k40bF8RZbSc0VujCFJ3pQuiNQEtYNJjXx0mDlYmZEptP8Mp0e+e3zeHxLOCeFPtQt0IbWsZzCsxlFyve1pINB5LmyJHt+/Nx4OkD5/5si6UTI9qbnrj82R4YhZz3OrN+3FTgLX/epmhXpvLTKfdhqSwo6DWblCr97My1xeZTZF+K4p/Tr76ssoew8oOEl3QSdJl6LfNnvdOJ9AlD8YI1PH2mm2yoG1D3mNqgwemq2jwebTM/dpsdXefpgJ0Fts1zMahbaw9pSd1zNqU6JS5T0kiHEhRxpAfAD7n8Iz5TJbx42X4VfJ24+WiHIz+2UvTmWUG1xEwx5H0vZSkOsRDYy7L4p4wDc9m3N4Ci9ke7gGX5OoWk1l0d3xMXgdqww9/VW/cSvj7jQCgt2nY9vUh0xxOQyY0GeVbKX7ogg7cPkzoyX9jkWc4siTCpKUPNl0UeueLgAVNewFjZC3A39V36bfXXHrV6P2asAo0IVxndg8F0cZoof9GPwp+Ap3iyjh5M+fSgylZ6CpMwQehjuB6UuleKeBWN4uEgP8SRX0ZrPiT/t2/TNeTiMkJKZjp0JCdgrhksOMFcAEcJc7zUw3zmKGXWq7LXpx9SRu8QZTol68xSPqsLO8o6+kEDjAvg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf77329-9c31-4030-1790-08db89d1447c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 10:00:09.5365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKjJgMq7c0yTUmm4IPtQh/SZWOMvp1/e9u97+mEY0play9feQ+9dqsIJQVkBXfq3A413GBXpytDbl+eFhqXb/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4482
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210089
X-Proofpoint-GUID: b_vQRnM_lCgGHz1HYhMhsHWpLrJglUD0
X-Proofpoint-ORIG-GUID: b_vQRnM_lCgGHz1HYhMhsHWpLrJglUD0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Please ignore the entire thread. "git send-email" failed after sending patch
"[PATCH V3 14/23] mdrestore: Declare boolean variables with bool type". I will
attempt to resend the patchset once again sometime tomorrow.

On Fri, Jul 21, 2023 at 03:15:10 PM +0530, Chandan Babu R wrote:
> Hi all,
>
> This patch series extends metadump/mdrestore tools to be able to dump
> and restore contents of an external log device. It also adds the
> ability to copy larger blocks (e.g. 4096 bytes instead of 512 bytes)
> into the metadump file. These objectives are accomplished by
> introducing a new metadump file format.
>
> I have tested the patchset by extending metadump/mdrestore tests in
> fstests to cover the newly introduced metadump v2 format. The tests
> can be found at
> https://github.com/chandanr/xfstests/commits/metadump-v2.
>
> The patch series can also be obtained from
> https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.
>
> Darrick, Please not that I have removed your RVB from "metadump: Add
> support for passing version option" patch. copy_log() and metadump_f()
> were invoking set_log_cur() for both "internal log" and "external
> log". In the V3 patchset, I have modified the patch to,
> 1. Invoke set_log_cur() when the filesystem has an external log.
> 2. Invoke set_cur() when the filesystem has an internal log.
>
> Changelog:
> V2 -> V3:
>   1. Pass a pointer to the newly introduced "union mdrestore_headers"
>      to call backs in "struct mdrestore_ops" instead of a pointer to
>      "void".
>   2. Use set_log_cur() only when metadump has to read from an external
>      log device.
>   3. Rename metadump_ops->end_write() to metadump_ops->finish_dump().
>   4. Fix indentation issues.
>   5. Address other trivial review comments.
>
> V1 -> V2:
>   1. Introduce the new incompat flag XFS_MD2_INCOMPAT_EXTERNALLOG to
>      indicate that the metadump file contains data obtained from an
>      external log.
>   2. Interpret bits 54 and 55 of xfs_meta_extent.xme_addr as a counter
>      such that 00 maps to the data device and 01 maps to the log
>      device.
>   3. Define the new function set_log_cur() to read from
>      internal/external log device. This allows us to continue using
>      TYP_LOG to read from both internal and external log.
>   4. In order to support reading metadump from a pipe, mdrestore now
>      reads the first four bytes of the header to determine the
>      metadump version rather than reading the entire header in a
>      single call to fread().
>   5. Add an ASCII diagram to describe metadump v2's ondisk layout in
>      xfs_metadump.h.
>   6. Update metadump's man page to indicate that metadump in v2 format
>      is generated by default if the filesystem has an external log and
>      the metadump version to use is not explicitly mentioned on the
>      command line.
>   7. Remove '_metadump' suffix from function pointer names in "struct
>      metadump_ops".
>   8. Use xfs_daddr_t type for declaring variables containing disk
>      offset value.
>   9. Use bool type rather than int for variables holding a boolean
>      value.
>   11. Remove unnecessary whitespace.
>
>
> Chandan Babu R (23):
>   metadump: Use boolean values true/false instead of 1/0
>   mdrestore: Fix logic used to check if target device is large enough
>   metadump: Declare boolean variables with bool type
>   metadump: Define and use struct metadump
>   metadump: Add initialization and release functions
>   metadump: Postpone invocation of init_metadump()
>   metadump: Introduce struct metadump_ops
>   metadump: Introduce metadump v1 operations
>   metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
>   metadump: Define metadump v2 ondisk format structures and macros
>   metadump: Define metadump ops for v2 format
>   xfs_db: Add support to read from external log device
>   metadump: Add support for passing version option
>   mdrestore: Declare boolean variables with bool type
>   mdrestore: Define and use struct mdrestore
>   mdrestore: Detect metadump v1 magic before reading the header
>   mdrestore: Add open_device(), read_header() and show_info() functions
>   mdrestore: Introduce struct mdrestore_ops
>   mdrestore: Replace metadump header pointer argument with a union
>     pointer
>   mdrestore: Introduce mdrestore v1 operations
>   mdrestore: Extract target device size verification into a function
>   mdrestore: Define mdrestore ops for v2 format
>   mdrestore: Add support for passing log device as an argument
>
>  db/io.c                   |  56 ++-
>  db/io.h                   |   2 +
>  db/metadump.c             | 777 ++++++++++++++++++++++++--------------
>  db/xfs_metadump.sh        |   3 +-
>  include/xfs_metadump.h    |  70 +++-
>  man/man8/xfs_mdrestore.8  |   8 +
>  man/man8/xfs_metadump.8   |  14 +
>  mdrestore/xfs_mdrestore.c | 497 ++++++++++++++++++------
>  8 files changed, 1014 insertions(+), 413 deletions(-)


-- 
chandan
