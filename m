Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92004C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 23:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355866AbhLFX7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 18:59:14 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23968 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377746AbhLFX7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 18:59:10 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5OkR003993
        for <linux-xfs@vger.kernel.org>; Mon, 6 Dec 2021 23:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=VSoXvDvSpdtfjDbtra9qnKKk/RWk7pg4Dz78k1m0yz4=;
 b=UrjJ60hnvHRgzRv4rxf+4eTv+0d3x5Ldk92zE8hT7q5E5FAPJRTsusOwcLcSfczoLK2w
 K9qQNuuJ2vdpsFlItHxBgTFWDKnDMqnkeCDiv2mgZ/Bi//bqiDucYgME4ux85YP7a7Ud
 ZSnsc5oRLGwzpG4zPk/NwGN9xqRrpTzKkLZWWpcWl/HXu6FYopoHGeT/evVjoL4MLJ5M
 YEH2MrKdJhxjVdGO+HTAIL8xuXG7DH0L0uGkELsWIUCy/hUyoaE/Ye+fhFX/792dnRcY
 8PVI+2Jra3YrmWt0ivcYDXkxnyYe8LHYkx1Vy3JvL7VEjdTlHMJJsSbP7E9o6iSLuwyJ cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cscwcc0h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 23:55:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Nk4oQ068205
        for <linux-xfs@vger.kernel.org>; Mon, 6 Dec 2021 23:55:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3020.oracle.com with ESMTP id 3cr05459d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 23:55:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkAxXYXMBtcrlUqkUWCh1yYn4G7h4Fbig8ICZxcK3jVCBAun3AkxS+2SvlPoDSXk237+d4SipLmYtSk8Z48npg6KEvv5A/CD8Ue3aHy4LVS0uNHzSL0ByMrrUz1MOygk0PJxGfJMNgzGVCMi+ak+/bqjVn+W3gM/oR9G6AevcY36PQqB8lr2Vnm86F0A5auWfS7UKg15Bcj/jSqqNpX8kIg4fMPlfA0gBC6mBrzTCBwqKCsmx0F25P0R6GNZVb33IOv61Kw1v21/He1vAoVAdSDo3Om+gqDcGpiYiDs4zMeQBKudqJoWf1r4Zr03UO8M4m7rwKh0+70y6EumGA8Frw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSoXvDvSpdtfjDbtra9qnKKk/RWk7pg4Dz78k1m0yz4=;
 b=jWqge+3yTZafJkkEXYW93YZg5HQ0ivykK2tSyOFso+Ewa0dN8KL1RRoOtyx6mY4vMbKBT+sc4TTWG2KU1LFio3VAEWOj7pOG+FmAp5YRnVpAiOSteW6Dk7uZyFPPmieXL9PmrDKbeVHq6wPCWlQ8H2yE+6gk7jpzcCvBrKbF5KHKgCUI62py2dg2xF8VmkW0+M3Zj8Sjj+H3VKQDyjztWC23dWMjLnzYrc10rv1wWwoSjrSlLJlKjCZWSzfROP9v4ME+cALXm0yQ5DE275cJTYLy5Soezx45/1LTpEVL0sDCfc3TTuQKXER5Uo6HWU+g2fBbUFMN16BCatiioyuRCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSoXvDvSpdtfjDbtra9qnKKk/RWk7pg4Dz78k1m0yz4=;
 b=Y0N5CMZaT7z20ZrZZYFnuiddRUAmHpsVsyo90YZf5zE8mfqBB3Kx7YfaNCFpvDivsh+ut5gJA0ifuCyJxYoB1EfVPZne0jfAdwivepIL5MUo4WrgPT/K4Bdjr2mW4X5QfPKHNx+7BMlEvLV7aOqnn8SHq/nwaiuBm6SPXO8Z4LI=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2250.namprd10.prod.outlook.com (2603:10b6:4:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Mon, 6 Dec 2021 23:55:37 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 23:55:37 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 0/2] xfs: add error tags for log attribute replay test
Date:   Mon,  6 Dec 2021 23:55:27 +0000
Message-Id: <20211206235529.65673-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by SJ0PR03CA0169.namprd03.prod.outlook.com (2603:10b6:a03:338::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Mon, 6 Dec 2021 23:55:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8a304b8-e6e3-4e43-6d89-08d9b913e67b
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2250:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2250A608D3A435B95E2595CA896D9@DM5PR1001MB2250.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Jkd0DXvg6vS/yqjPuehkoWx3gkk0jordTM55Bk/Mxb2XBy5Bw9NJfF/cDV1DT00F9IjBZm/QsBKziHmMbtubQJa7MhF9O5+crbE4f8P1GV9a5RfbyeqaZd6yIOoYs3e8CD3KDkhzMreAlMh56qXiOA+XJ62nYL7MgmmVc8FgsL/tbhvhf1FlDEWoS5RIbFbHmL3g1yoOrGSf6rygIjl4LRDNY4b3wbTJuUkVbAD9YCCYpaAFFe5mPIa8lxNf7DwFA7SaLG0joZsvHTOG2KfXvRbEno6kC+gqf/sToV3RZNf6sajfnt4HYD/7s+NU0cqeToIB5ACttyO+YqWPkj8tRrIfnLaMHnh2oDlJRN+BqFuDhdkZlsEL+RfwBc3cOwzZhoRlDb7XXsamD90V3qsQyAPV/La9oNFAbyrlf/qalcIpMHRxQpd2/yIOe4QXtLynsLc1F1Kkc4WDCJznNR9hFMa450WofdskpytpDT3t03Apeev7usQCWzD9OC7pDVYXrSw3JC5M8PJ+3lsYYCt0JEj8XljfUYNUO87+h/fKj1NskEUYwkCU6ZYYXGkqj17QBSu/URKMFXLphs6OQQ1efX5WDOJNoi9Hs7zygoOiFVX9oeLm8qnmX4Q3tWVc09im0PdSyce+YwQiuDLDrSu4VZNfDQCydy5hvAMzIYgutZmkwfFgGb9dhh81GH0Gd92kMy6rcdZGnVG/XIiNL10py0cH3q7H9Ng6SjdA2NyvxImnAl18J+x8omlCgGY1hH0V0Nt1RHjJDYsHKgvSjf2XPbMiG5EFZtGGbUENOfqbFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(66556008)(66476007)(6916009)(66946007)(966005)(2906002)(6666004)(36756003)(8936002)(8676002)(52116002)(4744005)(186003)(956004)(5660300002)(44832011)(2616005)(6486002)(316002)(1076003)(508600001)(83380400001)(86362001)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0k0Yjd1engyUWduajdrQ0JYUGhNdExNbkFnWEQvd2VqejJiL2twQUROKzZV?=
 =?utf-8?B?bVI0RW9KenBrVjRTYktLb1F2VXlVa2xXdUxuR0pYa0FlcXFzU0NMTEljVEFu?=
 =?utf-8?B?MWd2aTRTRUppTlVQa0o4elBCRVdOQlJMcnAxaHZvTlBNamgvTEpCM0wrU3VK?=
 =?utf-8?B?d2NVR2IvdlZCU1d1T1lOZWFuVHE2RVk5Nkc1ajI4RkU4SmNFV3U5dll3dlUw?=
 =?utf-8?B?ZWJEUFJkcEhPSzg2TmxBR1VrNGlQY2cvUmRkbUxmdXNucEZSRTZ0UXp6WE5Q?=
 =?utf-8?B?d3NSV0Z6Rm9WR2J1TytMZ0V3VWg4bFl4NHVHMlBEa0JNNFcrMkRWUTRBb0NT?=
 =?utf-8?B?MTZud0JNV2dlMjhRWjJZRTA4ak04OVBlNzg0cTd5ZmwyODdsU1FHMTgwc2dw?=
 =?utf-8?B?SklJK2FtbFhhWUg2ZlMwWmNyTEV6MW9rUi9LY3E0eldlMzdoZzZvR3FEQ1k5?=
 =?utf-8?B?M2JveHZyZDZjb3ZVSzZpOEdjWEdGeUFNMEx2TzdkTWpITjUrZUp6d3hmZFNW?=
 =?utf-8?B?MDZ5SXpwZHdIdE1LKzFUMmtHZytLSDJvUW80Y2xkbTlpdERoMTNHZEJTU2dD?=
 =?utf-8?B?NlFnS0xhVlNWNVowZE8rT0NmQVFid1ZlYjh4UkJ1aFNRVk9tMy9nZXJhYTNn?=
 =?utf-8?B?Qk9GZHVuY0xoc01BL25zamFhTDZISEFYcE1FYjFtQ2UrdnlNdkhzTHZtYmJ6?=
 =?utf-8?B?R2FVeGhLbGliMXlJMFZDeElFc1FhQkNiK3hrQzU5Q3NINzhJOXNFaUVHMWl1?=
 =?utf-8?B?UHh5V2g3TGRTdi9pTitzQ1JkbEV3WkFhTVdtNURaSGNTQmpHeUhNaEdrZWRK?=
 =?utf-8?B?Q2FYS21uRnJQMCtPb3R1TDIvekVqVnhsZEpTREZRRzVJKzVJbUlWZ3FXeHZ2?=
 =?utf-8?B?aWppMm5OdnFRMXJBd1pUenFPZXQ0NWdVTjM2K25RV3d4M1Awam5qVDJ5SS9z?=
 =?utf-8?B?SCszVGFXN2lGd3JUYXVkVi8rV3F6aU4rQ0Y2S0ZJQ05lVDZDWXhBQWlyTEli?=
 =?utf-8?B?djFvekFJMkIvUXlPNWp3SlBWMmFlditCWlkxVUY1T0xMM2YveWUwS3JmYUJs?=
 =?utf-8?B?OXlwejl4TCt0ZDIwTGlpenFuY1hwZWtRZ2FJWi9PVmM5d1FyQThNSEpYV2No?=
 =?utf-8?B?d2JPWlVNRWNNQ3JDTDhIV3d0NkpWbFRobXNvL1hPZDNXOGR0WmZIY0NOZE9G?=
 =?utf-8?B?ZVJYckcvYjNVV2FkSWdBN3ZDclJQZzNueHp3dmU3TFNaRjVyemxpR3FxNU9T?=
 =?utf-8?B?aE9FTjE3QkRNUVlJZFMzY1o5ZjVKam14ZkQwYUZPanpWN2VtY2szUzRXVVRt?=
 =?utf-8?B?WENLVzRFOWFqMzM3b0RvSnQ1M0dHemdrbGVDTnpOVi8zcUNNRzlnSXpwbU5T?=
 =?utf-8?B?aW1XYlZKVm1Yb2xXOU16Q3U4RUY0MTVDcnQycFBqbnc0YzRYWmdFUHM2Q3VO?=
 =?utf-8?B?MUFFMnovci9WNlJNTWVPdVBKcm5wekdzcFVTYnVPM0MzVGM5YmJ3ZDBlMmx5?=
 =?utf-8?B?bk9RM25NSHgzU0ZWamNLL0o4Sktwdm1NQ1pScEpRSmtPYWx1SG5JcnNoWFI0?=
 =?utf-8?B?R3JhZzJQVGs4cS9WRlFDTWpjWEoxNnpQL0N1cnNTOHplSmprVEpRTmNHMXVi?=
 =?utf-8?B?R3hiQzdiL1dHYWl0Y2VvSHdWOVoyQlpYd3FCQVFkYVVwYjJrNzQva0FHYUdF?=
 =?utf-8?B?QTNIS1RpQVJPQ1c0WkRhdms2RktWREZLczU1YWF3aExLZ0loS3VZSzl1SjFO?=
 =?utf-8?B?dnlxWmJ5cGMyWTdkSWZuUDMzR3dpZVBQVUxhMnpZQWhlVmVhbGpmYWpCelpW?=
 =?utf-8?B?MTV4bGtOTDVWNkV6ak4vZmgvOFBUdDdlTmd2ZUpjMWwrNWZoVm80dFRrN2M0?=
 =?utf-8?B?NUFGMnFQRngvakh1K05LYlFTTi9yWkp3Q2JYdnN0bzhCYzkyTVNsUERHcW9s?=
 =?utf-8?B?aDFnU0xPSStFNk9JRHJHSk5kRFhiZGhQT3NHcXBsOTc5eUhTOURSWDYxakxR?=
 =?utf-8?B?UDdOdkdpMFNPVVBDdEZvNzZ6RWtIeG5jd1U1b2ZiS2ZqTVRmcUdtWXNDT2lq?=
 =?utf-8?B?SjA1SUdQQ2ZaQm90MDR5dXF3V3VWSHVodFM0RXllcUt6RXF6RjZCbGMvUmpD?=
 =?utf-8?B?RGo5VDIrR0RQLzZhZVRFYUpUcXdGdVB4NGFEdlFsMDl3Qll4emRmTEdDZWxx?=
 =?utf-8?B?NXFWWlBkUlBnMVRDUndvWk5tdlJYNkxnUGZreW1aUkFNQkJDMFE5eEI1U2Vj?=
 =?utf-8?B?S3NQZjU2YjNDd3RCc2NYcnR3Q3V3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a304b8-e6e3-4e43-6d89-08d9b913e67b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 23:55:37.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IciFug0mUtiDXDdNbkgMQB/Y16ohGQMY+WloapXVx5Wo/DJJ6eRrGhAspF+2xTFKPFvEdjOiCv99fYKKatb4OFEJGlsl1f9bBjZwwKGCu0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2250
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112060143
X-Proofpoint-ORIG-GUID: 5OMkf98xoz0ljXp1z3QjgMikVgd9CnRw
X-Proofpoint-GUID: 5OMkf98xoz0ljXp1z3QjgMikVgd9CnRw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

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

