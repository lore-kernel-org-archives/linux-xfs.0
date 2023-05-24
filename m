Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA28C7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242192AbjEZIrb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbjEZIr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:47:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8A9119
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:47:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8itLJ017233;
        Fri, 26 May 2023 08:47:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=vLMgFInykt+5Nfk5JVA/Y9XzUPNrkPu/sBtCa6cSdro=;
 b=yckPbmkh0gxVA6watEwZjLjNDVZjQIMVQuYb85BdlMVZCWJ6FBk1xjG9hi2KH3T1htcf
 rJKXhgFIci9YGn+Gs7/b11SUrTpudTgMON5yqQexkz+6zv/lhM1WFDF91DAbyJc/yRMG
 qHnQ869Jxu+A2eov0EeDCuITsUIeUVRy1+SQV1l206Tc5XiMJP/t/DUKeO5S8KDxT56T
 sUI5oOTV9jtyNWDFylCqbXoiYyvJxSB7k1vWxpkB4JqsCpFyrAp2RebR4i54uCJKCbPv
 3iv0WwGmJMCw6+hRv/QHeg7mGlQLcPMv5PKNvp5kX17psqI+SfLCN43U1597y14cQFec JQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtshb00e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:47:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8XnvU028892;
        Fri, 26 May 2023 08:47:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2eqejj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:47:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1QB8FE8ZgF82jU+5+FIA0ZJDVWfARTNhENADIc6UP0jGd9VhW95ewHyRQV6rMLyhmpJqINrH3c7yOUfFk1PQe0z/euiCXWu4woG7V0IB9MO1VcBKpCXO8xf2KSkDCsYRxs0IiJ5dWhFSVs5KH2IjZqRtQgcH8B7KxNztlg0s1FcZnBQNxvU7wdcoH3BE01aW0u1hbhvUddBl53i0QGWnExaHwY+tW39atBdwaOCGvTjfriUEGFDwnyTu7DM1+ghiQFb+G89GnTe3Zf9NRpcPLXmhHB8HFWnzGeEzZkFqs5OW1s9ig0JhuC085PZVZzfY5uagjElcUG0whN/Zwg1QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLMgFInykt+5Nfk5JVA/Y9XzUPNrkPu/sBtCa6cSdro=;
 b=hMX8RorD7IsJd2Ls3N1rvIhOg1OGpG0UH63VCdGO2zZNkK0c1C+INQVAkJSD11hVKTPYK3fcVFvvdhdMoIinsDqvPYqNh+jUFZhZQcsaNHYsTIV1M4BFOl3le1uU4djSq2cYK2E9uHDWveOMvdY6pegUS1wQk+bB7EL3Mjbun7xbcvqKrIGYqCQzWkZAon5pMesBmF6U8ebPMdRoQ9BE3hJEZS2yqizrRb2VAJnkjD5CS66Cs3GueaGmO/1YoOjaf+b2cHBedZSHuxy8usIdZy+rjQc6xFp8cRxBc7jHbqbw6vWITUIFPi4pyUHx3i1T82w1Z8v+FDzBBCDNvjbPLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLMgFInykt+5Nfk5JVA/Y9XzUPNrkPu/sBtCa6cSdro=;
 b=JbpiAz+KRcn+JgNpmDGiDuNhcHdCYukUkKOGcNbFlQbLgNVgxOdUtZUnlUwGaqtInoUi9OeKCVJbjwex2w2bDpw0t8s6ZJMHbbd976qekJntcJI+3QKSJIUiBka8L8qjWHB5ZPfAFxpP1hVpdADJwnYxUjVw4bKKPTOdOX9VQ2E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by IA0PR10MB7351.namprd10.prod.outlook.com (2603:10b6:208:3dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:47:21 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:47:21 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-4-chandan.babu@oracle.com>
 <20230523163514.GJ11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/24] metadump: Define and use struct metadump
Date:   Wed, 24 May 2023 10:20:14 +0530
In-reply-to: <20230523163514.GJ11620@frogsfrogsfrogs>
Message-ID: <87bki7lbse.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:404:15::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA0PR10MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: 65af4794-54c7-4c44-af8c-08db5dc5d1ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UH2xbHz6iIXQRnru5BNLkpAqcxmSHMQzglvxL0IYklHRa2PzYWnXRCstCSb/kcuTOkiYucwinX3w0rtgBIEBb8PgunAq+vGlLwPI9jFT2zlxHzh+t8VFrVvJliq25St07bu0i1YXQcT5egEvEwNKrPYV874Szm9ahM6noy9aup4Jz6kgpJ+CCh5ZAmXVe/S7dp0Y0pgJdN1ppr9G7/mEH4QAwgKx52G23Ofea1NZlfUpQt92ZusN05JPAtj6PSfmi/qGhPUVQfMTfPgYaudf/zxoLDLoAPiZu7aln/x5Mz2BUw+DT8Q81C/g1924+JlDQIE2paJdddBT3z/yWp3hafWxevZj+qFcBB4jZ2J4JgRQSTnI5WSm5hlKZv3yWc/16/zN/JjB8qMcCUaEFGtCXFDmQoB3vNZVKTKQ4QqNsS4Yr38zgS+qiPojAsZC7TczGsa45DkIVS1prOPAAItdvIM4u9oJFXSdLsTpatLrigmMNCUVPwtNlRQiNMjSYFlqMe6rOpPkcmZ5FWibnSc1nqzQ1G9K2u5lmztnTd5LQ9uEXW4cFANbdGs+cVRfhSHe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199021)(41300700001)(6486002)(5660300002)(86362001)(66556008)(478600001)(66946007)(66476007)(33716001)(4326008)(6916009)(38100700002)(8936002)(8676002)(83380400001)(9686003)(6666004)(53546011)(6506007)(6512007)(26005)(186003)(4744005)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q3yIy1Xp9uh7ik+D1E8BpSIzhsVeKSQ/q96wpCa0wfOAthsqd5Rv32lY41fP?=
 =?us-ascii?Q?rbfb0RA76T7eF4T0K/1ClfTl1BnGQC8hNwiXLtthgliShEmqUdRSPDzyO7pQ?=
 =?us-ascii?Q?SJlINDJ6jAmRm03LsayOvTHAFO6Cyi+664TY0LuYHvGEgMUUhSXICfvuMaTT?=
 =?us-ascii?Q?vCpCs6vxSWriRTYWuvj4RnO95CbBN7wrb2SPL/RnjJzXbwolPkEUlqJIRtIt?=
 =?us-ascii?Q?kPn6wHqfUgC0LJCr7RMExjh+3CWCGed6EInCVqcjUZ3I7eA6doesLpk2HRpa?=
 =?us-ascii?Q?kRI5IPku8sIRMSJT7h8nyD0gJAgOnEgFMfoCzISTY3J0Ije+yfUj4hslPwnO?=
 =?us-ascii?Q?lqlUPEb5zpy5cfty6DhjZPnBygqf3BPzusKwpyddHNJvNIG/o8l2BDZy/WWI?=
 =?us-ascii?Q?v1ctrJbpfQOsk27gWDGxTV/pT/b71H215SRUqhBPqxWbZwWZbkiAwe+eeMpP?=
 =?us-ascii?Q?fqxUhg9OCl9hQffv0xb1PR/Hnt4NGRKAx0Ret3RFUYirnoVQf4Lgg7rgtOWh?=
 =?us-ascii?Q?GGOIDdKjM9XS4J/YDEqsVO/5iB/n45Tk4DdP8nbFMlJjwUgBD9ZbFbknHaCN?=
 =?us-ascii?Q?mRBBkQ3qUnQA+uobpZtO2v9MRyZTaX1ZZ/AvsiIlW7SZDCVdCLk7vcemaP40?=
 =?us-ascii?Q?2Ik4+XRBDOOWpKpOIK07VEnieIUFR/be2b6hsop7qhs/984KXx3SX3JLLHhC?=
 =?us-ascii?Q?ww6pblIJC6OCCOUn1tSZNNUrVwUUw5O9okTAA6jgGJL7Mvrj0c0DMM8Zw9mV?=
 =?us-ascii?Q?EES9S8RsLg59niFUlgSJM/fSOyeEWaxDwtijWO1Wm7JF2gNmTPrTpRk+T/YU?=
 =?us-ascii?Q?9wvJQ+W5aXhHPPKoixlymiTzAP/DD8Z6IWvMcMv9SBfrpJ2Vdls73FkNgoTA?=
 =?us-ascii?Q?FPYv6rZV/lj6fGJ75hEuljqoht5hE92//UawDvW+63eTE8/w5va5YFEBmc0/?=
 =?us-ascii?Q?SCeA1jL9xUMLIZSnHiAt0d8OfMFKNRBQTXooAsE9EbJlVF+G4Z0OedjXHZU2?=
 =?us-ascii?Q?duD+aj4c7RtFoul14Es8M3snRxBZ3EoiFUMvGZ+qqpDqclKP0huo6KfOLVQm?=
 =?us-ascii?Q?fE+yxP9LJ1/7j17u7jX5hJq2elUzFs6OyRYpV33ReMUpFrm/gKBVs7Nkjf/G?=
 =?us-ascii?Q?louLlPdUCEybRk0SRz9Oo308RZnM97Dn7DaecDr7cd4CorU0vatOSPr4vg4G?=
 =?us-ascii?Q?VkYijS0o1KiXIpBLnlIWNoYoU++oXst5r9x4RzuHqAWkUvL9pS9vvfUYy1/Y?=
 =?us-ascii?Q?6K3Xt6/e9W5gJbBUy8P1CHTFT9QbVyx89I01wWaHbIiyjzD2qfA/V1ICSSBc?=
 =?us-ascii?Q?ym35CQURoaSRyNojXKO507l9dRTaELMnybpaYx0ZRv4JIQ1dlKKAMCEqHSnt?=
 =?us-ascii?Q?yMAW9sa28d4WvK4t+SxEzaDK9jQ8aPbMKFyjl8+Ni2tS7XBBeW+NzJcZ9Ygf?=
 =?us-ascii?Q?j6r4g5bSb/N4SLpvt6JY1hgM32bc+DdZI+XdllmaPAIc/ytxvbhMtaGFYCIX?=
 =?us-ascii?Q?qtp/FdoNITxtyqPDCBs9BVn1RSZd3sgWa4Ji/v+ehXRAv4xOD/OtboYOwJEY?=
 =?us-ascii?Q?uDm03GZwsKULYBrnB1CfJYJwmp4BGXgh41bBjBpO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OetSbyqbcZJL2EuVwTBzmtxugFxcVaVRjqqS/dS+3j/QogzMu3ApYHO40CTaw72Ks/+ZN4PCy4i49rUwWY28rNeYkowUHG4Rr3oNtpzM/Lez4aXTXr555r5hDLZyzVjdJBKEslYW6Lmb8n/quLH6UsFH1dyvsejqYVu7o+VJeh+CpkD/TaMcXEZIzH3/PxywZSKrxJTzqmHUaG3suSgKU/hLGnVIHrtIbU1a5K+JBWAbJWH2CYwsadC94baH8a3w9/WJgi38m5/6/rr9OR8XzZwnU1lEQJKnZs7aV9KRtiFH4aVOTy69bysePbShC3tCrwkvLFhgv7CoNjyENJbc4DQin0n6iiR3OGSJUEkbyvrLgAUahNhpkhp8ECh07WrZPbjhJdMfuBmEplakFjMJnVLwbNUZ4fcoVgRjYPiVxxM+l6p2/p298WCz/vqX87R5PyYFAwCcAMj81JDzZEinKxA/T3LPD6y3SC50vcmptPviqM0Q5PFoW/r0N6E72qil/nXaYxWoUigOsjc1RQ1UYDWseG1Eq8QOEsNxUhuIX4vm266P1QiVFMOsMlqaKvT1YXImYd1rMuN5G+yqroCJNiFtFE1VKcysO4pJAeoTq/1giDuuAWcsAMVO+T7ljL2ychBkLUfRlPcfYHW/gEgRLTpwR9L4Cjn9qnFUH5qsWVClt57GVrFLr/xWkk3PeOvZNZbKdNagPuPn13c2KhewDqvdkSImpR34Kwgbt4RyVNIn6BZW0tdaWAUDdSBXnOsjkIMOIyRlLfZlgFmHAagRBBrfxdyvl6DWKO2/kkV4S0M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65af4794-54c7-4c44-af8c-08db5dc5d1ce
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:47:21.6103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rlDXIrj6kXRhQEJtBWd6T5MOjnK7nRnoCL+XZBJP+zVDSfRO0Tskenyx9qypR67dgjV+jaDUfC6wSq6XuU3Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7351
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260074
X-Proofpoint-GUID: 7UofsI3Vp2P5FdNChoxnTkalcGObOGKx
X-Proofpoint-ORIG-GUID: 7UofsI3Vp2P5FdNChoxnTkalcGObOGKx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On Tue, May 23, 2023 at 09:35:14 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:29PM +0530, Chandan Babu R wrote:
>> This commit collects all state tracking variables in a new "struct metadump"
>> structure.
>
> I think this commit message needs to capture the reasons for /why/ all
> these global variables are being pulled into a struct definition that
> itself is used once to define a global variable.
>

The purpose of moving the global variables into one structure was to collect
them in one place in the code rather than having them spread across the
file. A new member of type "struct metadump_ops *" will be added by a future
commit to support the two versions of metadump.


I will add the above as part of the commit description.

-- 
chandan
