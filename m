Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7535FC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbiAJVWD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:22:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33704 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241546AbiAJVWC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:22:02 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJliVg007280;
        Mon, 10 Jan 2022 21:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=XF3rWE19sH4kVI1NPw+52jGNrrT82VaYtaGYjfOnm5A=;
 b=uM2OiPbbvc1MDXz7ZrYSbdboxNM20PWWwipQihJGmM4ORDAUkRzFE7gLeKdRdiX4IJ6Z
 8C9zioowl+pR/7oqR9pLwGrQVRke/86Del3DoUrAZ1D7jnAge26eGqGIyDv0yqxFDHTM
 Z2BlXsyrDOU96Ob+8XkY1NZhvv9ZVKVBBjwkedsZ2VWvuOFFHp/HTF1BaTkooVhiuiIH
 uFSPDEbnDmfxRnNL5nHrIoDuRoBYP/oxpI90eldaGgKpLIv81WBBmutkQwzG7kUI6AmN
 Af9qsK3xcl+60r7j6rjhujC43ryI3MwLAlu+hhpPN9ystYuZ447H4p606VlPqEd66OZ4 uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgkhx1hj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 21:21:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AL1ZRp062250;
        Mon, 10 Jan 2022 21:21:53 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3020.oracle.com with ESMTP id 3df42kkbq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 21:21:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/BItOXH95FuCVb5AAwu6qh9s3ZxMf224w8lvFcZvGZQl3bIStk+StKQACLFMTk57lavSBM9TG5YOFPL4NnPTEtE1zGorUzVA3Fc7Lfjeo7INt5KjxRBI7zXVOaOFj9xVusWnS/8jwRMkXG/Gh/xBFFm9L9nq7s53thOdZIftvBb08/xbkP2WOkZ4qwVmoYhJil+oBvey5c/ffJQdimOFnHFf7WnhO8VKUd6oQGEf8FqyuuV3eGd+YlwKv/TpSOajwjL1VubWfBc5u+7A4/ouz+akQ+U+gNxIXJlGDQSi/G1dMdrpWoTkPcTL+2LeDmECE1QTbDuuJOL5YWb/Lb1qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XF3rWE19sH4kVI1NPw+52jGNrrT82VaYtaGYjfOnm5A=;
 b=jWwNVYlObLyO+zLz7pg6eyslv+4MPmlrUWnYBjj/zC4/h+jq+8HhruPxNrotKA6KHUMuimGum5lP2z6J/PV+Jsppe71WC59p2D9OVBou3+q+XUSbJ8bB0SJuKqiLvjojCpCQSLlwsB1teOnDP0fUz712jb0QMSg2s1l5bBVU3v5ZwNsCLEq0f5ka6zvWTXktHATUh7tvDZ1PVgOro9toT+7JUcfg6QylIQvb8Iqyo+fgZY1cMbe8Tbn+xb/py5JlJTzglkRC3tCUpuVio9JniC/8ALQzhcioSRypcPIe2itI8lt9QvL3kfFxGFvXxrRDIriqCzl+1F/VDfouyfH3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XF3rWE19sH4kVI1NPw+52jGNrrT82VaYtaGYjfOnm5A=;
 b=beVQr/fjFvHL+7DCc1P1Fr5mD3zfhagjvb3xwwSu81yh623Gocs9mATs5mV1uxkmqhQIJkoHtCOQioR+g4pa5KNKppTPLu2AyyWfsxB1plgDP/9I5wUxFyahmU/vo93uWl6tY/bZTZv1oygrmQSRuqjyQ0i7GsL/NFp6+k0zqs0=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2652.namprd10.prod.outlook.com (2603:10b6:5:ab::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 21:21:51 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:21:51 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v5 0/1] xfstests: add log attribute replay test
Date:   Mon, 10 Jan 2022 21:21:42 +0000
Message-Id: <20220110212143.359663-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4e998f5-402a-4615-858b-08d9d47f37a8
X-MS-TrafficTypeDiagnostic: DM6PR10MB2652:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2652869AE8125490518DD6C889509@DM6PR10MB2652.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cI6NNaruyq44L34FyXFqZJDh3dyvhhDjO6sgo7GyCI1WstRO4Qc8PUONS5W0aBeNLK8Zm+vSSGd32rWQc0Whfbf6K3vvZIiit1lQMvNrA6RM/LHq8KEVqj7qbi1p2oQRwLtlAVsTxFcXrIXrPgYfuISgL4/oZ76VXjwwIBbV/yHR1lfaljMvbNNvDpQFpsDKWrJpnQ8kXlr3prVAFvyEa8XKKlTy6FWfTOVJjm8EzLL6jp/vImRhVZJwSvbT+wroQCRaPcdMLRTwIwlD17RQ8lZPSkB7EgMHP7T9yQd3XCoZGmpk8LgNq3WEsDvG2aUBDVag4/Uh92+Hu7ONcJDk95sZACh+8ESgLSD3JLdTr61vgimgZeHoiXrqzYmZY8ZXjzfctDMddEJL3o8RDXMZpTEZku4qZIZHZgGoNijhQ2bIsOqw0yfryIsIvHstpNJRhWY3mK9NlRvht66w21FlUFYvhLZ2AUZX372/YY7zfjlTcmz1ngy31ISO23pI+B0UvnNhujqKj/1DlS3VCGZOo3JCGIHa/fd8tguYIn77S7oJ2L2jiE32rUczRqX9lJeN+5nYndcRnkcZ7ADAchMf5vMPFRHH73dYLzIeEs3oSisdHtM4vwrX70oX9gBH3QaE1ZBSXO5JEGgIN09lOWGlj22pWpOMpk3+dXEXwQgrZyopvMETkPpCq4PH8SPeuUXI1M11A/apwFvEKx4VM80zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(450100002)(186003)(38100700002)(1076003)(44832011)(316002)(26005)(36756003)(52116002)(8676002)(6506007)(8936002)(5660300002)(6512007)(86362001)(2616005)(508600001)(66946007)(2906002)(66476007)(66556008)(6666004)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWR5VytCMzhhR2YrSGxGY3pCVk5JcXpCRGwxUy9qN3ZpWEhTeWxXYTNkdnlQ?=
 =?utf-8?B?ck1SUVlWc1owa09VeG9kWmJOQ1NaaGoxbDB5b0xhY3ViMnF0N2pXUjZBc29T?=
 =?utf-8?B?eEowRERydk13bFZFOGJyOGU5MEtockk0clVjL2hUa0hVR3MxK0xpWmZzSXhH?=
 =?utf-8?B?cDZkd3lLYXRITXN5SUhzVjlkQTYxSGFZS1RwK1pLSjBRUm5UdE9BWS84VTR3?=
 =?utf-8?B?Y3BGbWFNMnRGV21qSEdMT3VTS2c0dGhibFZ3YXAwNGNKZ203L1VUWW54enVo?=
 =?utf-8?B?MVN2WER0M3h6UWw0MFR0SjYwSW9NbG9CSk4rbkt5ZkFwSnRabXgvb2ljWVZv?=
 =?utf-8?B?THJoODNtTEtoQXdJUXZkSU5zeEkyeUYySnptN2hkTk5iZGVZZUNkYVN5c00r?=
 =?utf-8?B?RWlxMmY4ZXg0MHRxQXY4aHY1V2JFWmVUdnZjcWVIeFYyWXRKb1BLV1YzMThp?=
 =?utf-8?B?Y1lsWjBxVjVacDR5b21MZXIyQUNDWm1YYlFYUEVLdlE3ZHpydDBIOUxGN0gx?=
 =?utf-8?B?ekt4dWtaT0Zrc1RTVUZHYjE3RWllajIwUm5mVjloWUN0TGRzclRlWnpBUER3?=
 =?utf-8?B?NEZYMlNrdXA4ZFdpak5qYmluVWQzcVJ6VHQyVTFRMUlzTWVVRkg5YVNWcisr?=
 =?utf-8?B?KzY4SmQ4WEJLR2djclNVcm9ZVDE0anhDbHVWUFlVRHN6RC9DbHlvenBsOVhJ?=
 =?utf-8?B?Rjh6ZXQrTTB0Z2FuUmorSUZrK3hQQStvMkRZTHV1ejJEN0N0QnNpT0hkVDFj?=
 =?utf-8?B?Z3RlNVFmNytwcGVObVVDc0JiUTNmcHB0bjFZcTU3SVBGOVdKTzZEZkRjNTlW?=
 =?utf-8?B?OWUrS2lIUmR2dzJzeWYyaWpGUmZpZk9tcnZKZmxxLzRXU1NmSjdKVTg3cDVv?=
 =?utf-8?B?dW81dzZKMjVPODdheDA2MVpuYjQyUTdHN1JHdlJIbU5LY0huN2R1SExHWS9V?=
 =?utf-8?B?TEJMWG1OK0F6QkcrcXRqSVVpa0RaSkNYN25sQSs1aHd3TTFjZU16WXc3K2xH?=
 =?utf-8?B?OFpVMnFmZUlBck9XTFErSndiaitIQTZUSVRvOFdRMVdvZ2Z4T3B3ZFc3RDZ2?=
 =?utf-8?B?azJiOWFXT3F2clUrQ1FBSEkvcFJ5MEc1c09jZW0vOWFUUGlJN1Z3NWVVRkNa?=
 =?utf-8?B?d2tHcE9SdmpzSXNYQkJGWEdwNlR2bmVQSlUwSFdLMjB1cm84SVpTVE12TkUx?=
 =?utf-8?B?YzVrR01yK3Nob2Vxa2xneVIvdnhYZ253QngrVG8rUEttaThKc3FzdExJRy9E?=
 =?utf-8?B?ZS9XZUxXTmNBd29KaitUd0FqSlRNYWpzSG43YTJHVzFpTVdKRFFZcDBid3d3?=
 =?utf-8?B?enJLNHhZQXN0dkJickpDdkVlRFJaRkhsc1RRZDNBaE9RYXBUTHVqd2xxTFBh?=
 =?utf-8?B?N2I4WGpBUmcxeGEwZlROQWtiWURlMEZlWndkclRzYmdDdndtMWZmZ0MxTHRu?=
 =?utf-8?B?M0dwRXp3VU0zdFZ5MGFvb0hKN3g3MDl0R21NcXVPWTJpZlNobFBUWVdqQVUx?=
 =?utf-8?B?WDBaR1AyandjNTE4VDRLNlBGcWxVbUZQaUtTTXpiejM5Wk5mMWdBRm0wcEJI?=
 =?utf-8?B?S3U1bWsvVFg4cmVXY1Y1U2IvQ1RUcmpsdHhFYTRTb2RONFhUQVcwdVhCdjFS?=
 =?utf-8?B?UHc2UnNXQ1hnTzBheXBQUnladG9xWjk2MnkyMlExdEhFb2RYOFBod1Vjbmdo?=
 =?utf-8?B?NXNQOGJyOWFadVdTT3lhN2RGUThlUU00bitybC9GQnY0dzFDVjZzTVdyMWtn?=
 =?utf-8?B?SEhOdHZ5SWlaQUhXUGpUbVFnajZaWWVhNlpNRTZ5QnBFM0E2RG5rWnA4RXhw?=
 =?utf-8?B?U01pNmZhOVVLd1hHY0lQeXdqQTBibGJHWkh6MjFoQm1iQVI2a1ZkbVA2SHZT?=
 =?utf-8?B?NjF5QjRQcmQyWlBBSzNHTkxONG5QeVNVUjVvWXNiZXg4TzlES3JuY2pycXBv?=
 =?utf-8?B?RnlrZUhTMGU0elI2OFd4K3VQRzRiMjRwTjRCeDJucisxZUhYQjJEeUlaK3la?=
 =?utf-8?B?V3RDS3JGYjg3alZ1WkRXM2laQjRxTnFqWlAvcUNRblU2aWplU2N5cHF1RlJF?=
 =?utf-8?B?eHdsSWhCSzZlS1UySUJ5YkxLbWlMTStUZytta1hiRlZWMTYwaGdLTzZTcHFj?=
 =?utf-8?B?aGFRQkJFRDAxVzNKUk0wSzZNdE5qMGUyZzRleHJMaGVhRXlpck5hZmVMWDhE?=
 =?utf-8?B?bkRCN2hERVA5aFpkRFFyQXRjQW41eDIwK0laa1l2MnE0WkM5TnB3RVZFdXFT?=
 =?utf-8?B?N29iT3l2RzNMVlBFYjcrK3kvdk5nPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e998f5-402a-4615-858b-08d9d47f37a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:21:51.1550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rmmnsg5c0o0n9s3hgPRtrR74n6ZiRG1sVjMUfKlEXpHOtkBf/adOKMax7NtsUz4hbnZJEnP7owDm1ZsyLveSxn0lE7cBdww10g7ITGQrFIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2652
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=836 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100141
X-Proofpoint-GUID: v9NPzIQ0XP1oBjJvovoIpI4Jq3KRUrl4
X-Proofpoint-ORIG-GUID: v9NPzIQ0XP1oBjJvovoIpI4Jq3KRUrl4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Just wanted to get this sent out again after the holidays. Original text
below:

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
that add the new error tags larp_leaf_split and larp_leaf_to_node.

v4->v5 changes:
- Changed mode of 543.out to 644

v3->v4 changes:
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

