Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FA7C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344316AbiAJVZ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:25:28 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21214 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344266AbiAJVZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:25:09 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlf1H011393
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=+dQG98B2fx1dktUxzFvZd/n+He+Jm5ic3RJxMexB7UM=;
 b=tEgbWZi7bQh7ejLeGzuOGOcdQWiT6HulGGzXDfSG2gJ2lj48Jce7MKx/9RUuoDQLaGN2
 qO7iD0sQfHR+eMH1esFNYBYR318b6kawCeiLYg6aVEqegfIgXV3EARsvEvu+XFdk+zrU
 z/e2ixJFcBOCFhYuH2ymHxKhthrUdftSM0ulyXpWqT8+4IQCjeugn+v+wSwPwJT7eVGZ
 cQhb/kC7y+rQstYuTglX9imubccJ6CKNVtTgc5ZXsxQLAclzNTC0zkrpybpfT3aoeEDd
 4HaKJbjegy5TgSOOkmJ7Y6HHUCazsh2bSlX/pyskK3zOdkBl7AfIezDovg7Nwo/DGjQP mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjdbsrja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AL072S013591
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3deyqw1ndt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPahiz6zBk+yhlqocXuaUaU/S3PHUFblhf+87ArG+Ta1hUkKsRsF213rs43o/ivyQqTntprxjtLrd5FvdpxV7mEUcBQnBdrIjJ4grfdWOgaLI2AQzxbjGtraiityOq4dqR/Ky2hSdtbswsuP1kuJWxhRUTlmYTBT8YxFk8ZIeHWg7my7KReb4P4rcd8MKijSYmBi3+Yu2sTunM/22l2iJNeD/sKXm7jxmaUCwPlWht8sUd+uUfH7wrTdUtOijeVmTMazONZznTXmwhr2lIleqXILw2Ns3x4HdmReddHlKvKvta4ssf2lViot0DCIR55BWGGCwTP2+dNbUCl/+xJ0ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dQG98B2fx1dktUxzFvZd/n+He+Jm5ic3RJxMexB7UM=;
 b=gpFW/37DkD+8ijqf6B9G10ap3YwBWrYhzv6dt6EUHtDCNvGaJvju0Nmf+Fo16DSR0Eal9UBQkNQgY/D22PlEfBNrpv3ZOVNw9xz3Lk6ktEpG97qwzuLt6vC0WZA+bfbcxnD9gHX0p1Sl7jxu0HQSh76rbNWyUFjlDUvluirhqdnU+EBV6IVQyUPZSSTNzVhqm1KWOTQe/nVmrrQqyRmFpYMJoa/PD482Rj41CaijdusP0oWj3bdEz3YsQXeQwSatTMvvaglwbRNb2Sjt2C/VWUtd9Vs7+zP37c5OKSUuxAM5a55xCLwtLW/g/id7u2fex3xy7lCvZqXhH3AtBseNIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dQG98B2fx1dktUxzFvZd/n+He+Jm5ic3RJxMexB7UM=;
 b=t9X6vNQ7HAqKOOzlNaJLa9lC/GTtdTajrMKD0mvP497l+jrgM6LeFFXte7tniRjoDgfIKDF5/CR87RCeOl7FAyYRlknBMyRNZVNr0Z5lxsBYCWDkBDypTQiv3cPSXKM8wz6OjJHNu8E84J3roVQxglMW3dLXObSOMQTO8RWyZRY=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2570.namprd10.prod.outlook.com (2603:10b6:5:ba::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 21:25:00 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:25:00 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 0/2] xfs: add error tags for log attribute replay test
Date:   Mon, 10 Jan 2022 21:24:52 +0000
Message-Id: <20220110212454.359752-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:208:32e::21) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18abca96-107b-468d-28c6-08d9d47fa894
X-MS-TrafficTypeDiagnostic: DM6PR10MB2570:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2570921EBB705A584354171889509@DM6PR10MB2570.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQjkUqcd6mFVoeBDVVJqLqRfUrK8LDGA3GBzNPM6CIiXbWr64uphSiTmB+oJu8FASSuKNE8gZ9I1E4Agu5tnMdQzwj7k4v6bjsP+GHnDOaOgCVkzQsuIfN6ayQmK7WaEYxuupLprBvyZiY3n6IhLfQTE+ywC8wHSMdqfI4qBNR2E5kL0jiUI4rv+dr4uryLv8ESsVtxL5Ljj/4R1llT70aRPNNrg0RyaTILslMeaBC1M9OlBAishrxmUx+taxblUVbCCIcnALQU9dmWLVBUBcZmxxieqUbBknU38YnMgGGGR4nu3XWrksDhd7ROBWi1cdeOm1SKUqBfcihcbikWWucvGMCtxxUUHR55xoigFN0WfESu6Sijq6EOgfuT4MrStH23vA1IEUpSVsv2vn46lK0jshnBzNRzuQ3N+nTH0RU81T0+JQPCOJ54+Omz+PQ7sZJ7eTzlQU1+lgkABRofIYvX+KQunpmFuGgVt7k4oxO7L/UlAmpeHdVpokJvIDKMWh9p/FeGKy4eNado/UI72imYKTNW5X/a6S7DRaQx+i1CfrUHX5PKPaExtXB1J8YFww/pcjk6QIrWjGLs0zKBAifMz8JoBaSKokcw6RC/G7IxqyEP8tuXbJFMruTrWjwmzE35Z5qi/Xxz4BsQ8RGEEOnPOpYjMU5rQOXRY7PmM4zMXVoH4wRGfhBsQyamBEKw72P0NEDY510fqJ7J/4QUS/y4Qt/qawdMV8Ib/PZ7rlmsznKBzTarH1zGSa7INbM0/qq6x0e8nHxJUnv+PeHQLFZizUMmyStbKaSGs6cNJQNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(6506007)(4744005)(86362001)(66476007)(5660300002)(6486002)(66946007)(44832011)(6916009)(26005)(316002)(2616005)(186003)(1076003)(83380400001)(6512007)(36756003)(8676002)(966005)(8936002)(52116002)(508600001)(38100700002)(2906002)(38350700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YS9XRFZLdEhzMUhiODFmelB5N0daUi9Xb2k1M055RWE1TlpNaDJKVWtMUnl2?=
 =?utf-8?B?RklYdUk1dzcyUTNZdDd2V3RiYllCUHJ0cFc3T2o2R3E3cDhZOVJSSWNvWDg0?=
 =?utf-8?B?YVYyR2xlaTlSS1BHSEFVYjZQenVJWFRITzd3ZS82bWwvQ1dpbXZ2MHZDOFBL?=
 =?utf-8?B?VDZhKzlvRjZraXZBei9vdFR0WDJ6UklSU3ZmeTVmNWdaTXZ3R1NrWDhnSm9i?=
 =?utf-8?B?SW1kcW1zVnZYSDI5alF6ZER0ZXNXVjExQ2cxVmFSYmY5Yy8vUWF0eEM1UmRW?=
 =?utf-8?B?U2ZwWEtpQTU1WXdCV2V0TjFlVUVmWGYyU3VmYTZjbHJ1ZHltTXlNYXA2WHE4?=
 =?utf-8?B?L0JuTi9DSDdIN1l4emJJQ0FhNFB3dlo3NDVhejAzQ3JTUzFlSCtoQjNBUEpZ?=
 =?utf-8?B?YmxkZDZ1MWRMMXl4OTRQRWhsL3cwOGRqK3hSaFljSTRLZWkwekVLc1pLSkxn?=
 =?utf-8?B?Z3dVSE5oSzVSeU9meStuQ1JELzlKWlEwQzhsaGE5bWphV2wzbXd5WUtTa0ZG?=
 =?utf-8?B?TmdLdmd0MjJ6T1FleFRURDF3Y2lkbW9qeTRJd2VkSEZETndEcjJiK1JYRUhL?=
 =?utf-8?B?ZTVFK2t1SGw5SFRQVzB2MFVKcVJ2K1l3dUp0TGJjV0RDMzdHMWNsZ1ZrWXBY?=
 =?utf-8?B?VW5oTVEyT25lb0NQSmYwQThTVzE3ZG1CMU5EVGVtM3ZFRDRoZFJzNGo5M1Jt?=
 =?utf-8?B?SUtIN3hUZzNxRmlLdUk5MjNlWDVDYjMxSkVPeTVXZGZqSmNESGVseG5mdnFV?=
 =?utf-8?B?cFI1SVNoWDRsYWpRMElnUytkR3o4ekNGUlZpT2VMZG5XaFlPMUVyVkNIRHQw?=
 =?utf-8?B?Nldac0VkVlRTLzBVeHZUM0JEaXVCaVhJY1BmNllsWU5pRFFMRXlPZlNDSGpQ?=
 =?utf-8?B?a3hvbnRDQ1pDUWFGdTdsSmtJWFRRUm5LVC90Z1VNQkUrb3FMTSs0ekdPOHQx?=
 =?utf-8?B?SzdZa1pkK0RMVGpQWTIvQkZqUUJkbldSaGZNcEczMEFoRXQvbTZGektic2Ey?=
 =?utf-8?B?dVFSYVJwUEdHY3dpa05va09lSFhudUZKS2xlWURTRC85UHFlUFFTZVRRajky?=
 =?utf-8?B?Q2FEUEk4dU0vUERvMm5MWFJpVjNRM2NmZWJUelhNV3hFMk5OVnMzUEpnSFU2?=
 =?utf-8?B?ZlJYTnBybjN4L1o5MGhxemVhcVN6Vk1SN1VSbzI5OUpLeUU5STdWRzZBNjFr?=
 =?utf-8?B?OHlkNGtyaGxVclJrdVV2ZzhmdDVnVC9MbVFaYmJwY0N0cDdQUXFNRDllVU5x?=
 =?utf-8?B?Nkx0TTlvNkl3MGZvbWg5d3ZmS2F0ZFJJTUZJdEVycE93Kzh5NVRhNHZLUUo2?=
 =?utf-8?B?bmhJL0laRXZEQWNBS04xcXdyWGRJTTlEWXltVGxuc0s4Zm1qdUZPQk95Zm5B?=
 =?utf-8?B?VzNQUGtiNWltMzRVb0tkVXBmQ0RybDFZMW1NazNLakRJVEtUN1RCVW52NkNs?=
 =?utf-8?B?Z1R0MmgxSDI0SnJzL0JZZ1BqZ3VYOWF5SWp4NDJRb2d2MlJmU1hGTE5waW5S?=
 =?utf-8?B?U240dGlnL0FFcXVHeXF3RitQYWtvVU4ybzR4OEVvMHQ2RytkNCt1Q1NlRTlz?=
 =?utf-8?B?YVhMUExraUI1amcxUVB6dzVOaFZmenprTDhFY1g5c01mMy92NnRRQ3d2V0Jr?=
 =?utf-8?B?VTRxQWxwWUkxdXRuckdDNjNIc1NWb3ZjS3VyNFA5NC9XOU02QnplQWF4dmVo?=
 =?utf-8?B?VkxHR0lsZUQxZEJsNkdERXROZ3ZpOHJpVEFnUXgvSTkzMjdhL25DcnhwZHY2?=
 =?utf-8?B?SkdZcXVpYlp1T1UyK0JzUTNBMGNPTldvbmNhYzRTejBpd3lxVmNzTzkvaGh1?=
 =?utf-8?B?L2RzNGVmcmFIS2dLNFJESDBzZWFEekFyd2JFRS84QlgvYUxLVnJWSWlKZ1dG?=
 =?utf-8?B?QjBXZGMyWnhVYTRaVEtLenRtMHduSDJaaUZKTTN6OWwxMC9MZndQZHZGOXNW?=
 =?utf-8?B?UUMxZm5uQWo5Y2dvNko5cUt2T2JrRWh6R01lYnVBc3FBbXBGQ091K3RrdExK?=
 =?utf-8?B?YmlnSENXWnN1NGlYMUxNM2NZeWo0MUhldkV2SDMxcjlCQkgyWVQvVFVMd2Q4?=
 =?utf-8?B?Mis1T0FkUlEvTFlzaGxmTmlobzIwMWZ2enlhelhnUkNhZXZGbFVjTVhqZldK?=
 =?utf-8?B?U3U0a2c3Nzkra0xnNmpTeWh3R0NRSW12eWp3QnNic1N2MHl1bnpHZGhvYk9H?=
 =?utf-8?B?OTZSeFFKTWROUVE2L3NPVkFVQUthQWV2WkZJQ05Cd2xLbkxIKzhaMlBJb202?=
 =?utf-8?B?dUdXYm95eXJ6d25XbDlWYVB2cCtnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18abca96-107b-468d-28c6-08d9d47fa894
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:25:00.6411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbttR0rg7ClcW9kNhgzL/oaSpTxYKmhS//UYohMV9L/V5ZfIJT+YLg5F604MXrMopS718zRKQpA8DGsIa6WXMQXPlTqyAx0nEa7AnTDi/2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2570
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100141
X-Proofpoint-GUID: V0GyzlFiQe3uqsjbwv0XYus-yJ2VmTpc
X-Proofpoint-ORIG-GUID: V0GyzlFiQe3uqsjbwv0XYus-yJ2VmTpc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Just wanted to get this sent out again after the holidays. Original text
below:

These are the corresponding kernel changes for the new log attribute replay
test. These are built on top of Allison’s logged attribute patch sets, which
can be viewed here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v25_extended

This set adds the new error tags larp_leaf_split and larp_leaf_to_node,
which are used to inject errors in the tests. 

v2 changes:
Updated naming scheme to make it clear that these error tags are meant to
trigger on the attribute code path for a replay

Suggestions and feedback are appreciated!

Catherine

Catherine Hoang (2):
  xfs: add leaf split error tag
  xfs: add leaf to node error tag

 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_da_btree.c  | 5 +++++
 fs/xfs/libxfs/xfs_errortag.h  | 6 +++++-
 fs/xfs/xfs_error.c            | 6 ++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

-- 
2.25.1

