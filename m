Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F306C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F5C760F4A
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbhIIRnV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 13:43:21 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22712 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242783AbhIIRnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 13:43:05 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189GUSAi023507;
        Thu, 9 Sep 2021 17:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=O6g5htrlg03HOuTfk5vZkaG9XCjTf6GXdpfntkqu8Oo=;
 b=uwxANT5bJgX6Gf9+u9cVA1eStiNuu8x35iodPA6KPV6rSVq6JIZ7fZr6F0eP18GE85tm
 /IeqLrfsJ/uS5KQzve6Jdygm+zI016VBUBPIPk17Mc8j2P02lRDasOVobgOXCzyv3wSM
 Kok9c//m8/t2qCgs1IwpkUIkzlMkuLEf1oq5NjZHOw8drnNrFn6cm8LDqAGTCPKrv2Rp
 qrrKV/NSWiPxrXVog1g5FFnHIzbywvevt80y0tI9qrjJ84PoVtf7xiiljp/bBeQIkZlA
 mV2r8gZTVnSE4sm93+UzCDk4As9nWMauBeVndiOjajrp1LMb7BRARROGFS738NshVD4w 7g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=O6g5htrlg03HOuTfk5vZkaG9XCjTf6GXdpfntkqu8Oo=;
 b=Ro6+XVilhOMRANLGKfjAcrJZlix4ZbhVKZaWBhKx+NWRDNjSfOIgo/WD9zqCvWSlJlR/
 n3ZW/I8c/kF9j251qtnAKzl3r5bo1IL0IXzYkpXWTwcXj2cYtSDuhNVo9aRUhE4vjWLE
 Unk9a9UgFGFJS5u/CCnEW5ahcA2SpiqaHxczTdrRbFzh46GciMukqSVnDyOz2lhnvIs5
 LZ87dhtT/IuWzBedsoDqiVUOMbRE5Vt2qUWwUBT1pLq4YfoBJseATzJd8jOi/6bLuy9S
 AwjrV1ZX+gqdNBCc+2UsQWiYiwtcfJGccbDAnEFp0o1dZTSBIFH08Y7tt/cfre7XE+jA Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aydrsj0jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189HQqdP102240;
        Thu, 9 Sep 2021 17:41:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3axst5sdxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MorN7jlle8MwwCpMra3BQShFbOZveUIt2e6i7rewBq8VjiHfA+ru0IXUAFipgUoXOTOG64d+/AXTXcnMdtuWjwYynW+XdElSwQQNeJd/DpMLByWpBSP/FevSrhtD0/KcEmkE2Drr0dGxkyYSM1GPgyt93+DJNziGaK6nRCvfeTY6DvkXgK3vgK91a8pttNUa91fpu3SFC6YhRWQPluxkfEi6EgPN6BNHGyNm30shev0PUE4urqyks7EKxbF4VJP8tV8wR7O8TOwJUtf2lx/vaqhZuoUrjNT26kOL85fM773vXkmGr1zT/jrMvVOlVsf6FKV0ghZDCfjaOCMXWdCmqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=O6g5htrlg03HOuTfk5vZkaG9XCjTf6GXdpfntkqu8Oo=;
 b=BsaA5VKHsTx7Z9mjecRjoMlhYUQ5XQjljrqHJOG4uyNCHnyuUA1c5eNQTLiFQruGFqaMc8Ifvne63NtPuO4eqr7MXWZ4+5cfP2hkV8lgQx2G4siLXYObLKJP4XmTxHoHe6L/IKzaNwJunkbnXADZJbJdwrp/y7YzfhLmIPz8wNIIz+7RbV6NFuTbYcBLFJHSjmj5u15iHQ1yXepOWNKSVfqmruoUA2BJ5rVLY3daYs+DwqQqDxb2oWhKldaRbTmg1uzRR35PbX9IYUj/UdBvxSxm+DJl+g7ay0V/VZc0rsO4SNLyzaGkMvGQBjDEahgIzFJ7L7eUjisKLGNcsXaYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6g5htrlg03HOuTfk5vZkaG9XCjTf6GXdpfntkqu8Oo=;
 b=dpzE3vd29lWx33jGBTKiLlkBOi+iPiDTl7Szk9KrUUOVE6d7Zxe8IfaKNGEySfEC0s3JAqJ3+paOLDdsLif31rxY61qRjBXtZ+80dMIJCNnTYkbZdRSBe3zMNqXOR1zkaXzz053+j41JpyFLnoRr7rWQmiholY+MAbHzoWKK0ew=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16)
 by BY5PR10MB4321.namprd10.prod.outlook.com (2603:10b6:a03:202::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 9 Sep
 2021 17:41:51 +0000
Received: from BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64]) by BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64%3]) with mapi id 15.20.4500.017; Thu, 9 Sep 2021
 17:41:50 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 0/3] Dump log cleanups
Date:   Thu,  9 Sep 2021 17:41:39 +0000
Message-Id: <20210909174142.357719-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0349.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::24) To BYAPR10MB2791.namprd10.prod.outlook.com
 (2603:10b6:a03:83::16)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL1PR13CA0349.namprd13.prod.outlook.com (2603:10b6:208:2c6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Thu, 9 Sep 2021 17:41:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c573a7a8-18b1-4fed-4287-08d973b91ad1
X-MS-TrafficTypeDiagnostic: BY5PR10MB4321:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43213842511200FE06AF708A89D59@BY5PR10MB4321.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8P9VZE2OeXeiTPNkj6B1r9W57DKWx/fro7k6TrB/tFN/Isgq0ICfLr/nUmrHWlCiaPgqzmWVsDlY/M32hanEvSWXrCVGGrsCQ+CADPzSHTaRGVdS5Fp1onDp1ZucOTn8z3/81OnaHgtjqHPri6lJoZFg+kG8Xbp8cyq3YafpVqH7fzBGUpesv4Oaelm98v3EmU1cgMkK8nP+i8ZE6WzgoGnuJ+qBppXHXNEMcby01XxxGOcDwpcFoE8IJ1VkM3KXbcQPxCDsjQzAmEU3mJj95o1Cr9bU547a+Q39ePBP8H8lxcZb9Dx/zyc1PzYamZCEyqKPo+g6BTcwoJHh9dJM+HAyghidZEov8zqLZdMlcXfaewVHGsUNodzHrwpsbwlhUEL8dlCSS7oDddOFjKGObn984YyQM28L8RR5808DxCZ9Ls09rZeGc94zXSBY3LZHL77tA1kWLXitCgW8PN8Y5H57PYNANNOnV4JEJ9l/vXl5C9wECTdaA8hIUBbbo2gz4iqlMJhf7hFoGyt/bCdqERXD/UuLK2yWOiQvhktaUloWVumsi0GmbV8oM7QtY4ZfN5Eza9kM6k0bPP/TJcwv83Se5rRcDGXSfue8CI8M13PFcdJChpxDxZqt5DvNKdJ0rMVfNz65B3YELtd2K/Bd33R5JtFYB/PVy045w17Z9MkQ2KmAPHfDfo3bz5GZPMUFOSpxb4+IZJNrVP9u7p/LCZWFeGJxt1Qt2WjMnFMa7O2PoDP5fqqFw5gW6d4TJOj/kdKkxPhAx84gI1VxrS2fRiZ85BwkBBsNrH0STETGaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2791.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(956004)(38100700002)(86362001)(38350700002)(2616005)(6506007)(44832011)(316002)(2906002)(26005)(966005)(66556008)(83380400001)(8936002)(6666004)(508600001)(186003)(8676002)(6512007)(1076003)(66476007)(450100002)(52116002)(36756003)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dZFxY+05X7jC0F6aLXW/csdjOdM3VAj9t3TiqBi1XeMd5rlndHvzb1i4dSwY?=
 =?us-ascii?Q?dVI4uhqaMayssd+7+BEv+UN7acapFepNQpTaCi6fv6XIGB+ZZtdIr7UFuoeb?=
 =?us-ascii?Q?NbBRLlZNb4a79cbRU7XQFqE5XWmwOHsh5Vd2BO5NyFHahxn7sC86lC1Bs8Wh?=
 =?us-ascii?Q?BYXr+2zv4NY+2noorrkU19WAumAgnoxExdrWuKm2NUH42ogLHwqeZr0y8tNw?=
 =?us-ascii?Q?tNeaINbf20T0psiS6OifHTKCfypd4KedfGdpRNoXSWGJ4yZ5+9BqmZy9xYzE?=
 =?us-ascii?Q?AVgBVdty3Fhzs1FYLSs/O6J++86l0snNK0KTk8zQUhNJ2VfkJT+kB5eD/bJE?=
 =?us-ascii?Q?noL0iEY00zK4NAp8tf43Rei8xfWv7LdGbf1EHuwSccu3+Co+Xn6GdJI8UwhM?=
 =?us-ascii?Q?eQinAl9KYHq9F9EZLGtqInTITqRqcfIS/u5qLn1RMYy43/3gNr0fW8gyYZjH?=
 =?us-ascii?Q?3MMMikyLPLP6r3A9HV89b9KuheQUkl8y+a5IcvQTgZWDfZOktdxanFn+HLyr?=
 =?us-ascii?Q?090fQeAVG+r8G9iKdBoUzKGS3DWfP4AdjnMBzwtgq730JcLQPNwjzFztKqj3?=
 =?us-ascii?Q?evBME415at1Cx50pK7Jd5U4x69LpeN5i76vsos0eSUG2lwRNgn2LoZKi/bgH?=
 =?us-ascii?Q?eDmUOOXhanlAc3PeBsLS5TKMMBnQ8LTcE4GztCxZCfqeKOLX1n4rZtMBP3S/?=
 =?us-ascii?Q?u4G1nNODjhQovl2R0tU7IcV/39672EM6IJiOMRiTUVKvltGGiyPpl+VWRq14?=
 =?us-ascii?Q?p262nVC2cbhbw6PEQDTxVFpQMJjpXkutMD6hKNAy6ZiV4R1/ofdI00e9Dpwo?=
 =?us-ascii?Q?gY22btdX0JZeJvpmYCP+nQkbaJlw5jYEkuvLfSyZowUM6m610mFEioMuWZVr?=
 =?us-ascii?Q?eLUCA4urdrvK26iXVfTS6HWzRuvObUD2RdWzfrH4fkedF2h713+3NLnp9as+?=
 =?us-ascii?Q?cW7GKUEtqJnvcLD93kYvGMx8PSLwfMgvmm3Ufq0PnGFYzuFqI+O1C1tUqR9c?=
 =?us-ascii?Q?/HCXlKgG2RZ8mohr92vK0mMMdH8wZN9df/GCrkKLPwT3vQoLGyK9smVKEuv6?=
 =?us-ascii?Q?P44OWIamow9ltyRzG+NgeTZsUkPBSqzmehgqJlgVRXx5X4vjcCAfErZ7HgZp?=
 =?us-ascii?Q?SlIQeQjtAO84M+OIjE4BNPz33t/LptKykD4a6E1Aqh7li09X8E9Ey6tEn6sR?=
 =?us-ascii?Q?TYW8XCwfmHXgVq0vNRBHH863H27QIKnzx98MvKJMN35INXEAFBRWDZEd0XC7?=
 =?us-ascii?Q?/G7D4aX+Ug4d2rvwNRrlCAVsBRtqP7Jc1mGRT5+DJZ9DOLtxqMqb+UJZPVFa?=
 =?us-ascii?Q?e465LGwx3lejlv1kaDQaKbJ1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c573a7a8-18b1-4fed-4287-08d973b91ad1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2791.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 17:41:50.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fg90x2/Vut5NlYXoynkoOer7xfUdZ+B3/71m8t02VWcrp0nyzplubPpPMOfBSmIC01f/YJqcRlBMAxqCiljdGxHRXm5tEuAkBVSlCFKqcJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4321
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=881 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090107
X-Proofpoint-GUID: z5ODENulO4cgzF3zj361ztMrZkc351Or
X-Proofpoint-ORIG-GUID: z5ODENulO4cgzF3zj361ztMrZkc351Or
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This cleanup set is a followup to the log attribute replay test that was
posted here:

https://lore.kernel.org/linux-xfs/20210901221006.125888-2-catherine.hoang@oracle.com/

This set renames the *_inject_logprint functions to *_remount_dump_log
and moves them to common/xfs.

Questions and feedback are appreciated!

Catherine

Catherine Hoang (3):
  xfstests: Rename _scratch_inject_logprint to _scratch_remount_dump_log
  xfstests: Rename _test_inject_logprint to _test_remount_dump_log
  xfstests: Move *_dump_log routines to common/xfs

 common/inject | 26 --------------------------
 common/xfs    | 26 ++++++++++++++++++++++++++
 tests/xfs/312 |  2 +-
 tests/xfs/313 |  2 +-
 tests/xfs/314 |  2 +-
 tests/xfs/315 |  2 +-
 tests/xfs/316 |  2 +-
 tests/xfs/317 |  2 +-
 tests/xfs/318 |  2 +-
 tests/xfs/319 |  2 +-
 tests/xfs/320 |  2 +-
 tests/xfs/321 |  2 +-
 tests/xfs/322 |  2 +-
 tests/xfs/323 |  2 +-
 tests/xfs/324 |  2 +-
 tests/xfs/325 |  2 +-
 tests/xfs/326 |  2 +-
 tests/xfs/329 |  2 +-
 18 files changed, 42 insertions(+), 42 deletions(-)

-- 
2.25.1

