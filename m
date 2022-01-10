Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87302C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243231AbiAJVaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:30:00 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42074 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345239AbiAJV3u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:29:50 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJm3BT026277
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=muIcIvvZY0zs7ofQUaeFAqmCKMzKOOhDBNXA1C+O5uY=;
 b=vxPPEVBG+fTwG//r2ZbZzn4wwnkySb6WldIXakK6EFTFEzHLjxs/3PIKGgzZz6wjYMzO
 nGsrj0iiDsbQdbM9i9ysxMDIer4tBN40+vKjJn4gTrhCptK9RnRNekVAmc9Jn9nqT4NW
 L/Bo4NsnHAFOZl2j0ZAvDrtkXrO5IzYykv9tRf1zE2PAMfHCUg89mbUk07Q95aKySa1s
 GD5A7ua4+7Ha8SHIYNeVtiBJwnfO1oJ4jjC57e3tfOKZNEzEHdNuxDUn0O5ic/H7AzAu
 wUajRKsPRhdcWh7QISUyK+oyq8UfET1e6YdQX0ocYFctURuJQJ1rZiQGAChj05ddojcC AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgp7nh88h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALQflp074520
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 3df0nd4bdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZK3OYR+iXFG6zqqsFro+mSPn/3uTdyoYZo8jiIdTgI9rqtvYgsZHNA3VzwByChZnN1OCULQePhIongIM4w/2dwud8wv9OwQ8BzpXOA6PFuatKLymXqYvPCjqO4xrrmeyf6audJ4rPggC4bYCnf+leGq6HVikyxFGTQHbh7ZtMS16JKjQMGrcsVfpQeKttBJwGDk11ocbjvqWhhH99SW5FQwp9Ve3N8j4Pb0+ieZfGwb9KangqwB8gA0JZkOoyFrQGDwsErnsXJ0JpcRFVw0oK3pJfThh5WfXV96KVE23vG2wfVbCS23mVOe/Fwaa8OHCEqNSJ05O33nT6HsdWzCDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muIcIvvZY0zs7ofQUaeFAqmCKMzKOOhDBNXA1C+O5uY=;
 b=N4aThmfNkBeVulMjdwWMRPGRKNwV37ynqgEGd2pvY+mvy5Ol3MX1khEFMKg7F8r2R2jfED5Lxsh1Gnya0Eu74lTPp8Q4KnHCtaAeYbWsW3A3eioPLdy+P2Fk4t0EjCbWqDTrEaHwW9RGRStffkce8ylFbfodxO4C47OK0SdGqqFkaTIYuOaLdRjN1iCUEY3V9w6J0XE1o8i4oAolddMfQwD5xuTnmPY/ixi3k2H0rqJbF/aQaDVhxmo+ZiDQsLor95oP2fUUFFEKQreFImO76bDtvdR716CNm51jtJSFkEaAhtQFaiXxlwl2WqqXNF6FvChYLgiTg0hfqZ7xI0WPLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muIcIvvZY0zs7ofQUaeFAqmCKMzKOOhDBNXA1C+O5uY=;
 b=C7R2RcOc9mpTmx4uDeM+paPBHQoNznXmU2ylrahMQpMxvjr/9HQ50mt24XtKhR6Z5SlRnQMC2ixpjtuSqX40z86dvt/A1Rm0FMexVmq8UXCuIvnTYf7zUUw780Daw+eyNmFtT3lcTnjjZLlyI5jDhIMJGwEI3623HoqkhlAvLTs=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR10MB1561.namprd10.prod.outlook.com (2603:10b6:3:a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Mon, 10 Jan 2022 21:29:47 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:29:47 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 0/2] xfsprogs: add error tags for log attribute replay test
Date:   Mon, 10 Jan 2022 21:29:38 +0000
Message-Id: <20220110212940.359823-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:805:f2::42) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce90d70d-9a40-4b57-1f97-08d9d4805358
X-MS-TrafficTypeDiagnostic: DM5PR10MB1561:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB15615AF5629025CA9D4A976989509@DM5PR10MB1561.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ekRRQSIKAx0y1vUqg02CoOUhgpk5LhOSvo/CV1is+289CdIv0WlMEGiBXuk8Cf8yLUqAMzxQFkw7R287lRTFMajYXKD3rLh4jB9D5K6aYdi0DW0Uf5hvBbI8YclArOmwEctXaWKFwubOP9ATycimRSKmaMrS0dTCFNkE0qMpyv7ejWCnsxdmu+x3OPtXEIaBDop+l2RcYeW5MegoDy3r06vo9PCqFUlqaJP3Idist7zGFT+1ghFa8iJ0qPhsOhfn+4gBJfH8S4PYP0gY4txj/gqA10Ks48Mqy0rDGnjONqDk2cY4fcO+qJ3bqzp9T7HsUB9xgF3/n3glUnoGgOW/wMLqWrgqhr4OqNTDJLE7Et6cMRpVZwbMuFz71YqfllBIM4n2LuOx/G5c95eMW5HAMWSvwtRNim0ADTur0o1cVehyYHLobzVx/TsLG2dJ08K0SEqTMfWSEgQ9qrKdqhTirlXhC7ukz/QohXSEw591/awS9Yg5V2mo4xtWdUHK6XPvyOIIYKE1wZqT17eOIpUR2iWUksYaSYg78dpEi+g/EiMy98vU8TzA0KYXq1vSoMyltuH1gjn/p0tWADNtHEAiAJfMinmi+yf6Frm6iq6gkWEdvFif0CgPazYsakM0PRSWK8R86qwCGdNulGVrNCXqz0yVz08j2QTpO0zLfN7lcYZdsvCVVZ5kZo0ORVmC2UZrhso9fDp7xxQKHS/+D8r9qYxA/64gXWhkAs5GzNm8xcwI+X9sv92kmuNt72K4ZBLXRiBqplG3hsS4VfpaXfp+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66946007)(6512007)(66556008)(508600001)(83380400001)(8936002)(36756003)(52116002)(966005)(1076003)(86362001)(2616005)(4744005)(6486002)(26005)(8676002)(6666004)(186003)(6506007)(2906002)(5660300002)(38350700002)(6916009)(38100700002)(316002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFVZVTkzQXJCTjYwYzJPQUNkSEJ6TklUQlVRWitJb3IrMSsvYnlqTk53VzNH?=
 =?utf-8?B?cHZCQ2VUbGlsLzVOS01yeUVZdlY0eG8xM3RtV1dzVC8rQnVZT1htRWs4VXlT?=
 =?utf-8?B?a1lyb3BiSVRGTGhNZnBhR0I1VzdnQ2l2UjYydkVicGFJQ0tDWHNreVZ1TU45?=
 =?utf-8?B?eVh6Qnlxek5aT2xyNUxqb0JVdkZZWXBkdGRmQnlabnpqeVFzdjRVK1Zha0Zx?=
 =?utf-8?B?eEZ4SEY3UjlFV2tUbFhidUVuQXdXVXROdzFpeWRkdEZhMmZuZXdOMTBkUlVp?=
 =?utf-8?B?YnZPQ1hjakJuU3c0MEhGQWRQMUxGaWJ1WWZhQlFRL0ltbXhHN3czc0IvVk13?=
 =?utf-8?B?NFc3ZEhiUTRDNWFHTEQwaWFEUFROS0x2YnlwZUo4cjZiUU52ajRqL2crQTBo?=
 =?utf-8?B?b1RyL05TNmdQeWRzeDhGOWdMOS8wSEJqWVEzTGM4anlOenlTd0N3Z2piUkVj?=
 =?utf-8?B?R3lBZFJpb1ZWOXhxK1BweXNrYTAvYitqOTZjSk1OeXdWODRtVDRvbjFTY1Yr?=
 =?utf-8?B?a0xiNlhCS1BSQVowbkVXTDVZdU5MVTkxcHBCN2VacHFWeFd5M0s2dU1qLzht?=
 =?utf-8?B?S00xU3Rrak1kejlBUi8vdW4zNkpuQUp2cGtqQmZvYjZQOTh0cGgwbC95cEhp?=
 =?utf-8?B?aXdnWlFtN3BGcnZMc2dMTHFnZkZQZTU0eTkweXJXNWIxOWtjOFplRDZxZy9I?=
 =?utf-8?B?UG05VnZ3M1dYSmNnQUErQXNLd2Rtb1FWS045OSt1YlZYZEgxdmdyLy91VkRH?=
 =?utf-8?B?cU5XZ3FxSHFuVy9sc3AvQUo1MEN5WlIxWFNYL1NNdEtURnJLVHVSWGJwa1ZT?=
 =?utf-8?B?M21IeG1Vd2xXZHkrMlgwNHR0N3lOUlNTZFVaRjc4Uk41NGtLM2IrVlkxNUpR?=
 =?utf-8?B?cGJWRVRrcU4xQUxySHZTV21XRHhWRHlKTFI0S1VVcnVGazMySkV4Vy9ZS0NR?=
 =?utf-8?B?YmxhTDJGdityUGhwWnJpbTE5S0FsNTdhMndLL0xZY083NEZENm9ndkpsSTJL?=
 =?utf-8?B?VjdSME04dWtMQm85OEJGMHZQTVc5OUlhejRBM3BreVFlbnM1WENONkJpT3dH?=
 =?utf-8?B?cFBQei9ucnNOc0lNVUpKbm45b1VhSjJjc0dnT3g0L1QwSTJScGFaYno1Wndv?=
 =?utf-8?B?QnAvN01haVFYem5zU3gvMEo4a2FZTzZNcTZYZjQySVJUNGlXd3FseTNBSFFJ?=
 =?utf-8?B?d3BmVDlESVBQbG5XS0JNbmRjbEtCczhhbHZzZlJhNyt2aGN6cHBEUHA2NGFI?=
 =?utf-8?B?SjRoN1kvUUVqTVJqSGdhUm9vN3EyamZFMjQyRi9Ldy9wcmtRYzdtcEc3aXhr?=
 =?utf-8?B?RVYwcmlzTUY4S3p2V3dKTmxYNkFsL3BYVytLeTl0cFl0emo4OTdGdmd2MjIr?=
 =?utf-8?B?WER3UGdFMXhzTHpuMFVNYUdPWFErYkFnZ2hHdmVqNm5mbHUybDllc1Q4U2lx?=
 =?utf-8?B?RHZ5RTY1YXV5QW5TalFLQ0IyaG44TktwUzNQa0hWRk15YnNTQ0x0SnVEVUJ3?=
 =?utf-8?B?VDZnNkV0a2o5KzRIeVFCeVZ4cU5kZTFYa2RnR2JPWFVzWmI3Mk1WTzZibHYv?=
 =?utf-8?B?Q2lERmk2WGlwMzZlR1h6RUVEWHQvbXlUempNeGJGU3RjRk5kcTY2eHpraGMw?=
 =?utf-8?B?eDlRZ1ExRTFpTlZKV0c4VkRaaXNLN0VBb3ZtTnBGd0NmRzRZcHh3Q1RIZGFO?=
 =?utf-8?B?eEIxWno2WGxtU0FDVHBTeTV2KzBPdy9FdEQ3dC9Xd1FCbE84YWVjOTR0OHdH?=
 =?utf-8?B?NDBtRFpubHJWUnRhR0xrQloxUTJWQnBTYnFJQm9VbDBBdHlXaSthZGhmOXJP?=
 =?utf-8?B?WUZ3bUp5WkFyVjdOYzZuUXorUlpUTk40NTJjUVRtYjJWdUc0a2dsVEFnMFBi?=
 =?utf-8?B?R3orMXU1TS91U2FkSENPK05IS1ZBNTIxM3dSaDI4MENwMDlFRlJhSGJTeFli?=
 =?utf-8?B?TXUxRXdsNkJtVHRvbzVKV0ZmU1llWWVXNzUyTU84RU1mMG56VkVUQWNiR0oz?=
 =?utf-8?B?RW1ucmR0RnNsT1FTNUJJYmFKY0JRWUhUaVF6M1lZVjRBNDhRcGhZTnB1Y29K?=
 =?utf-8?B?WXY0bWExbkhSeGtoYUlHblIzUUJmL3MwZG51aDVkRW5GSVNkdWlsM0prYmZ5?=
 =?utf-8?B?aStNamVHV1Jxb01Ec21sWXNyTkhpaU1VbUdZS0hHQnVwajFnRkFlM1JEUWVK?=
 =?utf-8?B?UnQ0NDd3SWFnWi9MMGMwMGdCSUYxNmNXK01PNWNkVW9VSDhaQkNmcW5oZWJM?=
 =?utf-8?B?WmhEK1A4UHVqNnpBbEFFckkvekZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce90d70d-9a40-4b57-1f97-08d9d4805358
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:29:47.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4TbNoymxygLEtGvpnbDjkPiLm1BUKjtLxpG1qzarMdWEVDKvBUCA02JNeJM5icxbAuTwViT1eQDiUzGrF75tit3KnWLkZRQcDatUSacpXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1561
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100142
X-Proofpoint-GUID: JdFLMLRdA5Cl-O16f-98EQMRs1YI5Drs
X-Proofpoint-ORIG-GUID: JdFLMLRdA5Cl-O16f-98EQMRs1YI5Drs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Just wanted to get this sent out again after the holidays. Original text
below:

These are the corresponding userspace changes for the new log attribute
replay test. These are built on top of Allison’s logged attribute patch
sets, which can be viewed here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v25_extended

This set adds the new error tags larp_leaf_split and larp_leaf_to_node,
which are used to inject errors in the tests. 

v2 changes:
Updated naming scheme to make it clear that these error tags are meant to
trigger on the attribute code path for a replay

Suggestions and feedback are appreciated!

Catherine

Catherine Hoang (2):
  xfsprogs: add leaf split error tag
  xfsprogs: add leaf to node error tag

 io/inject.c            | 2 ++
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_da_btree.c  | 4 ++++
 libxfs/xfs_errortag.h  | 6 +++++-
 4 files changed, 16 insertions(+), 1 deletion(-)

-- 
2.25.1

