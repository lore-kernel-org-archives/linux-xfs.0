Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B7BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbiBARKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:10:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18534 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239969AbiBARKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:10:01 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211H2crs016293;
        Tue, 1 Feb 2022 17:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=Cj6HbEZVh2uuuQ7+AU/TPzzFAftAp0Ho2tCV+yZFkv0=;
 b=Q4U8+Hj8vAkYoZQE8Da8tHyzBCh9fNQ1nHrs4PpyKh+RaS2sb76rJjho1zXyA6L26jjA
 nOQ0QSdQjyIAdIVRgAp09Z6XvjDJ+Zhtb1xL9dVIwkDmAaSj0HauHCBCqhkiL6dKAXI2
 LrAW0+vYzHwqEegSex5woIXjoJhRGE1cMlAGEl2Jcl+aEzJxmdURAK8a4xf/yht8/k0d
 vkYoQ0zKLTdtAOGkMxV2CfTtEvzguQQ49vLCVJSJwszgWoTb0KPQxTgFShoX2QUeLyxQ
 bPRAwCBdVDE3UF51tGg2A+zcnCI6NUL4DGltOVdZ06JrXRPGYPOFc6v/aIvGF9qAf9d5 SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9wbg8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 17:10:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211GpgJN131715;
        Tue, 1 Feb 2022 17:10:00 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by aserp3030.oracle.com with ESMTP id 3dvumfsycg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 17:10:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcEtZpajbbFVCPj3cK2ZNzTFH4xQHL4lKqWLzJV8UGIqg0g8OMqo1TARD5+kp59h797xI/YkAdcQilqsxnIKqSGI19g8mWP23UlvBDcDGH/rDQKw641EJ0wmvjLroHyrVJisVLUFCAXDulDJYMYCkalveNzuB8etUUNM7SgKysTk7Lf/XQ/elPzIuKDfMYzDfvxUL9OJCFJ3kqk23zeDqicWJQGrfEZRwxI4fWxTGF9XO7k1R0unJI+EnWSDUN72qP3hu53fPx6y7V77i+/B++nfqbT3XvYYkAa5pSM0vd9Df+5zwzqeWha2ygDl4bFEoKzX5AlYWy+mDCxqB0so7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cj6HbEZVh2uuuQ7+AU/TPzzFAftAp0Ho2tCV+yZFkv0=;
 b=gSVbN07CRNiCqAqMJPEig+/pnxupSVgpTBpFLZFU15htTPYRKwENxC9ziI+7kkCjaVyj6A4eQzL7PTRaN8B1vM3iYAtlncfebuNr5YgSVBoSANS59X8XtZzmwWyNqZv9lBjfcFuh5Tb6k5xPq3P8CrTCWFSEwkTChMq2SQVfYUqQuX/z1m7LijGM4U86OnHDVJOYh7qNHUR57arT0qFol8fVMycKbT87jRQTOZIVZksV46eaEgCs1t2sjW7bhoisJWejuR2nAnz2JSfOeFP5u5HAufXXH0iffMEX+sCwB+B+1hsVmQGgYMi1rYOiFo7uXkFJDXLY0zyxPKDNuvW8kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cj6HbEZVh2uuuQ7+AU/TPzzFAftAp0Ho2tCV+yZFkv0=;
 b=j3qZrYlmJvhnAsgl1VE+on8H48HXtWFD3ACLaxFanMSpJGPECaSporr2DcTl16u1SpdMIa9NKoP4PjogBwr2G3FcZkPb6t9zy83pJOowvYVl5v0KF0y9a1dpQ6XT1wod5P2qhOjZxH/cSGVU3wvD6ljVb5VX46c5ZkRHOvIg2kM=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 SN6PR10MB2607.namprd10.prod.outlook.com (2603:10b6:805:4e::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.18; Tue, 1 Feb 2022 17:09:58 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:09:58 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v6 0/1] xfstests: add log attribute replay test
Date:   Tue,  1 Feb 2022 17:09:51 +0000
Message-Id: <20220201170952.22443-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR14CA0014.namprd14.prod.outlook.com
 (2603:10b6:208:23e::19) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 405f78bd-60d6-4168-d2eb-08d9e5a5acfb
X-MS-TrafficTypeDiagnostic: SN6PR10MB2607:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB26074E930DF5D495F0509A9C89269@SN6PR10MB2607.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RwsTNfAv9GBX2F1/yqgl+mM/8mVIZBbHWdMor6EoJEFTQHydE2waWZLzb4QeDlEhYU7dpxUoIou/CJKlCC5G7OL+Ya9b/chPpVO++gFgDb4ckJgd6PU0432kbpxJvtecG7+DH1lUe8KYbIDlnGOCPnmW2K4pzHXfGAP/WI0m00xq/w9NKZzCfJF5jqZQDRXE7cm0oeNzTFe4KaPeP4HOxamTUdQAz7qYQs5QQQFgw11RSVdPiInWL1fxJ8Oo6wW4D1tuolHfwd8Tj3x0d0W1lCZeymCXUczB6DAMDcBjuVV4eBNzBesYdfg/cygL39bq/0JiJdEw8qLaowinJyEYxhkcce2xpBjsPq6yZFeNnqbn1KXWNXUcwsfJakF/GJES2VwWiy4TXa8+5oMsFhjhQzIxtRan1Akww9KJ7+eHED4asehIogxtFVyoHl/1gLbX8qIRHgCN0rXYaTpVf4PMbNWkrXBCmOfEYdZSAgASBAjpERlz11NsKkee2E8FfdwgcDkKQ4JStfuBbEERWrLXjWa3UNOHibziNoUtE2QBWjzFv+cvK8XHuAuOaw0w1Zbn258yYD1U8rjRCeDw18t14Ksp5NA//BBjnYT1DlLRuYvpfeKjufS3gUyZCN1ypu/Bz3Kh6yad97XP+KFMaro/AhCrW8x5pLHQ4VJfk7XxL1uTfkgxrj4U8ArYiee41vSweVzNQ4WlAyByPfZ5t7bEVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(316002)(86362001)(52116002)(36756003)(38100700002)(5660300002)(508600001)(6666004)(66946007)(38350700002)(66556008)(8936002)(6486002)(66476007)(8676002)(450100002)(6512007)(2616005)(26005)(44832011)(186003)(2906002)(1076003)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTJnOE5uaE9taFBBU0JaZGtiWVA1NDQzTUYrSmo2dkcwV3ptdko0cGZHMkxy?=
 =?utf-8?B?VTZDMEQxZXpZd1FUSlNnR3Z1ckFUaytwajRWWnBQVjdkMDM4UmlwTHJxYWtQ?=
 =?utf-8?B?T0lTUy9EWVc0aUZUQmJ5ZGlHRmZ0a1NRMTZWUEsxR2VGYmYzbkJsTTJTVitr?=
 =?utf-8?B?T1pwbG1CSHRHYlN2ZjIzYWlrN29FSHhwU1FvT1IybXMxZG1PM1FRaDZDc2FI?=
 =?utf-8?B?YVJBd2orTmNmckFONHFrRGxwdXpuVkx5YVRjNFNVdHQ0S1dXaFNZL00xdExP?=
 =?utf-8?B?WGlRZXpwUjNkUDhtNTZNRVMwanBudkF1VVc3K1JzTzdRUVQ4Yk9oaFlQekcv?=
 =?utf-8?B?QTF1YjIvN05CZG1vYnlhbk9XdnNJZFc4cnI5M1N4OGgzN3ZaYkxzUGRkTkk3?=
 =?utf-8?B?aFZ4aVV4V2ZCY241MkE3K0szZzN2K2NTbjU1ZXc5MXNwcS9oWmpCUEEyN2ZU?=
 =?utf-8?B?NnlwSmZIK1FBZHcrSXZvV2o1L2Jud0xrWDVXekFsbzlRMXZHQ2RvUFJTTUlj?=
 =?utf-8?B?YUFkdlZwY1dBQk82NjRnVzEvVjdPSnBldHZ5U3JkZ0VxbHRZZ2N4cDVHTm9K?=
 =?utf-8?B?RnB0a0NxT2ZmclNHM1IzaldEMkFEQkxxR2hWZXBvaC91TktxaXVpMk1kTSsz?=
 =?utf-8?B?Nk5NbkxHTVVoZTFYL2dvYVd6TlhHY1JaZXZCeEVreU8rUlJ1eU45NmNBV25H?=
 =?utf-8?B?aTFVV0lRZFBIZTFQbVZsOGpXcGNrQ0FiMk9URFVoUkp5TGMyWjk0NG1LcEVX?=
 =?utf-8?B?K0Vja0lIUVVYUTdCMWY1TW9GTlY2ZFA5bFBIMHF0MjVWVVN2cHdpUGtrZXFV?=
 =?utf-8?B?eEJyelQ3S1Zxb3NhME96ZHp6UnpRdE1aK1dVc1h2WVB6azhWczhJMTVXUU5h?=
 =?utf-8?B?dXV5S3l2RHI2ekkxT2hXZzFySjQ0WldBbUZzM1NvRXA5ZXNMNHZHNmc3OFZq?=
 =?utf-8?B?dzJodjJobmttN29EZ3U0V2pSZ2hvellFcmVQYjJzaUZITjA3aEZvRzQ0VTdv?=
 =?utf-8?B?SGxtSlBUYTQ3RWsxMWVvWSthNHVJT2c4SnowOS9QbmJUME05VkVBUE5ibXph?=
 =?utf-8?B?YjEyVU9mQ2thcCticXBwcmF0dWJDeDBjZmVCaU5iTWkxVmdwc0tNQUtCeHBW?=
 =?utf-8?B?VFE0bDVJY09yMXhCOHc1QjJEQzhRNDZzQjF6akNHZzJEc2wxYUROZ1QzODBy?=
 =?utf-8?B?dG83WHlsYkp4VXdCV2Y3ZjNrM3ZCMmhFTUNSWkw2Ym5ySEZyVy9FcDlIS0l2?=
 =?utf-8?B?L2VvZG1nWTMveTBiRlBVeUY0cFBTdzQ4NGNwTGNMcDVuczFkSWlOcDJWdW1W?=
 =?utf-8?B?cnhMNndHTmt4a0hsQWhHNjlaOFJYTXdhOHFCK0ZkMFJRQ3piQkdRY0dHUEx3?=
 =?utf-8?B?YWRUbytnUktqdy8xbEJvVlA3YWhRNkU1VVlYWi9JYjlGSGE2ZmF2OVM3dkZj?=
 =?utf-8?B?dXZYSU1SUW5pRzdBTm9jTXRjbkluZW95eEttVkNHWGxkSFp3bzR5RnJqaDJ3?=
 =?utf-8?B?Nk9wSmxYR04ySmgzSGtCSGFJd01ieThhQWhucmhuWjlCcHZHdnZVZFFWcllo?=
 =?utf-8?B?QWNCL1NtTjVmdm4rSzh3SzZKeXZSZG1vcmhWQ0NYY3JtdzB5Ti92RlVGTUpk?=
 =?utf-8?B?ZXpWYjUrY1E1cU5pMFpORU96ZUw3RW85QjBFZ0FvZ3NnZlRXTFhuZGtzbzN3?=
 =?utf-8?B?clZaYVB0TGF4R243ZFYrSmpESVhSMXM1Q0d0RHRLNVlhUWdnNUQ0NXNQMXly?=
 =?utf-8?B?Y1AwVlZTS3N0UGhWcmFaSTJVbXpkNWdxTWZuQTEzNWorcnJOL0k4U1dCakx4?=
 =?utf-8?B?TUhZMWVxZUxtNERrL05ERXFyUkFCUERKNmliWndONDR6d2lhTFpnOUIyb1Ir?=
 =?utf-8?B?QXVlZlpRN2RRN2NCK3NIdGJXU1V0TG9rWFRab09rMnBMc3dZMUUyVHdWOUd1?=
 =?utf-8?B?ZjlsWkNncUNLSTFBVzV4Tmd6TS9ma2ZCNE40eEtsZzIvZytTc015Y000UkVJ?=
 =?utf-8?B?RFhXbGVLZ0VYc0R0N013Y1ZkOHAwd2sweGFCRlhKYVZucGQ1aHBhV0kwMEY2?=
 =?utf-8?B?U0VDZWpZbkdRdldwMG9uaGRSN0poWnM1YlNZaVBoT0o0RzBBOGNFcmJrai9k?=
 =?utf-8?B?R1EwOVpZMGJ1bDJvYnQxdERNaGl1bjZkRnJzamtJZTFPUzF0SkpnSVllTCtz?=
 =?utf-8?B?dEpnK3l2WXV4bFJRRHIyM2VpbUc2SkNnS1J4V3pGNUpFSExENk4rWWJyL05G?=
 =?utf-8?B?RWNSMHhKT2cxc1Zsc1RiK21USTlnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 405f78bd-60d6-4168-d2eb-08d9e5a5acfb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:09:58.5747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdV06J3tBLDwy6Ra6e3qL9dYSKY7l8FnUY6R05wgHbFYqM+V1/j06p6z8USDFeMYQ11mxeme4TB2aoXYx19xpvsd6bX4+etD4mgZPSGDb0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2607
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=806 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010095
X-Proofpoint-ORIG-GUID: hEQPvY-7Q8rYcT_10brsmViC7_DYC4Ti
X-Proofpoint-GUID: hEQPvY-7Q8rYcT_10brsmViC7_DYC4Ti
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch aims to provide better test coverage for Allison’s delayed
attribute set. These tests aim to cover cases where attributes are added,
removed, and overwritten in each format (shortform, leaf, node). Error
inject is used to replay these operations from the log.

The following cases are covered in this test:
- empty, add/remove inline attr		(64 bytes)
- empty, add/remove internal attr	(1kB)
- empty, add/remove remote attr		(64kB)
- inline, add/remove inline attr	(64 bytes)
- inline, add/remove internal attr	(1kB)
- inline, add/remove remote attr	(64kB)
- extent, add/remove internal attr	(1kB)
- extent, add multiple internal attr	(inject error on split operation)
- extent, add multiple internal attr	(inject error on transition to node)
- extent, add/remove remote attr	(64kB)
- btree, add/remove multiple internal	(1kB)
- btree, add/remove remote attr         (64kB)
- overwrite shortform attr
- overwrite leaf attr
- overwrite node attr 

Running these tests require the corresponding kernel and xfsprogs changes
that add the new error tags da_leaf_split and larp_leaf_to_node.

v5->v6:
- Renamed larp_leaf_split to da_leaf_split
- Updated copyright year to 2022

v4->v5:
- Changed mode of 543.out to 644

v3->v4:
- Removed leading underscores on functions
- Filtered $SCRATCH_MNT on md5sum check
- Removed unnecessary unmount code
- Replaced _scratch_mkfs_xfs with _scratch_mkfs

Suggestions and feedback are appreciated!

Catherine

Allison Henderson (1):
  xfstests: Add Log Attribute Replay test

 tests/xfs/543     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/543.out | 149 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 320 insertions(+)
 create mode 100755 tests/xfs/543
 create mode 100644 tests/xfs/543.out

-- 
2.25.1

