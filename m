Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813E3C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 23:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351190AbhLFXyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 18:54:36 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31566 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237826AbhLFXyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 18:54:36 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5WcM016368;
        Mon, 6 Dec 2021 23:51:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=wIygX38aR5R889C/so6aW3nIqJ8SG1kl0wktnWFAhnA=;
 b=azobgtwVV6iu510zlDK9qZCrqDjQpeEzjzCqCVFJ0xiDGPiWFn7uiV02sjnxmyE1bqDX
 9mcnDYxCGI/EbBUbHhGVN6YtpeSw0C1jX4vzQuGncl6O0Bgnjiyk34eQRv6dQ1UcFy5X
 9WjApt8HPA0e6EHvsHBEOL3yc8B0b+YE/16D6yUaESakSST3S3V6y1P6THnJvUZ9dv+Y
 /NvP9pf7TlP3JTpBcA6RR8jr1am8TUI5zXlxXTyUnOCNkLFUP7KV4RDmc9wU4GDiqYAl
 gEpGEO/gBkcmuAlyy7DuIgJMaUB3ymhf3RsZGy+0/o6gAUTWh2t0VLmIPmsD0CUlyjHH rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csctwkv1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Dec 2021 23:51:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Nk4V1068124;
        Mon, 6 Dec 2021 23:51:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by aserp3020.oracle.com with ESMTP id 3cr0545610-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Dec 2021 23:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9omFrFbl3bpzbvWvbzXgJlVcigK3B3pzP8XPS0vjrT0PllhAccXc7hzwNEX514HgLr1DW/RQ/cZ83MAjoAMi+rwLkWAiZBFKmcN/+Pgma+6JiWm6C5RQAwn2DDIDps6pf42/2wJRACtTW0D/ZT/PSQWKK7fStDEH1k6sT/I2LeHoDcB96NRTKOIoZwVb1eYVhRAJUl6YdTSCnhhhXKNz5WhapEp4XQC3pSQFxcHXptECjAuMQpdYVrNgj7+//bBmQb+SMnf1vjCKA9YLTFV3RUsNqdYdXQd6W3ZmkboC1xDxyaJMHP+p1fD9fhOCp0yoCDtFUkxmfiHy7AqUM5vTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIygX38aR5R889C/so6aW3nIqJ8SG1kl0wktnWFAhnA=;
 b=D3W1zrhUVQgfX95Cvv3SkM/djRkBpupl+Ps1u4YlGgvQeqlBQE5nG4u45nDebLEBC1k3B8LkcBo9poU/NkvjWi+c687APtDLbTozNR35nJcG+7l3SlgVwjzplUcpBj4SkfKi6jBYTBVA2nPOYVCDBKcaFM1Et9A/D+iOVmxmJgHUcSNHBpNDo0aSf6fZ3r2m159/a3SsJg12q94eath9GcAWyk+vRboBVehqEWFS2vhB9Hx8MKD95sY7mnmWYHDpRSf6QXWmmqfoCL+HvWCbycay8yhMfx49a6BFzfaTsuGsb0WiHD2D3p7A1njauX5psfiJll/IildMivEAfCNqyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIygX38aR5R889C/so6aW3nIqJ8SG1kl0wktnWFAhnA=;
 b=khtlgm+frn+hVoVnGVFd/bUb7XSvey+B9fW3mrDBTVg9nzgYrV55EBxYcqya5TvpQUNTNcwVy7ib9NdD2xqhIu3jy9EKyL82Bkdp/a/1sNcFHLbPpFpUStx+FhCXkJrpDTXRHdDdo2jP+48WUqnOxals8Md0DSqQ0zYlUjO1sPw=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2331.namprd10.prod.outlook.com (2603:10b6:4:2f::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.15; Mon, 6 Dec 2021 23:51:03 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 23:51:03 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v4 0/1] xfstests: add log attribute replay test
Date:   Mon,  6 Dec 2021 23:50:56 +0000
Message-Id: <20211206235057.65575-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0119.namprd04.prod.outlook.com
 (2603:10b6:806:122::34) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by SN7PR04CA0119.namprd04.prod.outlook.com (2603:10b6:806:122::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 23:51:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf19fc47-c3d7-4a8c-1cef-08d9b913434d
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2331:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB233119B9CC17ECBCAB86BE34896D9@DM5PR1001MB2331.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PRcjdh+NOstH77Dzs4wTnBRor6UvY2TYjmRySNoiH2z4VUR7s0hiH14pWOHRSgJsoluPMHJwg2G1PUCzYNxspQtGjaXE9kaXnO8/SjG99KeufUzexVUoh/IfMKcBs2Z0ouq0YypGFa4GEMhqS0ThRwzUgxwNJIgn7132nmJjTPWFvJlt3mVD2nZgI+1AXOHOTNwj83qUu7G0lzjtcD7q6Y6Dqzg/ExCLlzZgRrZ5NnxcF/2MeoTAoNxr9SK61mLGIPfBmsKR4YaoZAnDJbEilPKiE+OucvLtm+6LaVAsc9+S+6ery1ZGUzBoQEs7MX1qevKuCEH+vU2XtK4vhmwkt19wcTbtxAVKl3xc+AF3571/PHRb0WnJ9wtM4QyHzK6EAXz9cvLBDzUzyIXLtdga4IcxKTlrYUdP24GZP6gzLfH+bqGkR4ow4IwIwn16rEz2IZ0PT1simfuN8gE9rXHhMd6VwtwkfR5xCcSLXgPy2wHOFXaue3JTpf8acg96PNEBJj1yO4RZ4wKC+1uyUSpBpR29Ot3Hd4iutWDKLcndAWQWcV0pvhYb6SQDhR89IVHGx5sf5GQtb0dMYAVE01aWhaKvusTGNO6DM6xlK07l/LYd2Y220KWGMPbE+lfnLi0SpKm5SBl3PsjtcZ7aeVkQxGHvHDaGnpgFoczq5gJW1gwTq2RAW3GR6hrSK/EXd+5YqsViYw0wjmBuKGIlQAzBlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6506007)(66476007)(5660300002)(2906002)(6486002)(44832011)(8936002)(86362001)(66556008)(956004)(2616005)(6512007)(186003)(6666004)(38100700002)(38350700002)(26005)(1076003)(508600001)(52116002)(36756003)(316002)(450100002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2o5MGFvTEdsQmJpalZJaDlFODF6aE9yMndFb1Iyc04vd2htTXBneUc5dEFZ?=
 =?utf-8?B?L3dVRU8wSDdwNjJwZFk2bStYMmtWQmN5SjY0Y0tqMVNTcjAybE1aUWRWdWJX?=
 =?utf-8?B?dTBrQ1B3YnFPV2ZGMURBVnMxb1FQQmVhSXdidzR0TFVOaW9LY0NzNlJGYW1V?=
 =?utf-8?B?bzVXSjhrdnIzTGtjQjFzNWNyU3dHQXFHQ0Q5c1FRcUpraXBHVVJqVGl4a205?=
 =?utf-8?B?WkhZMmcwQzZBSStPZ0JGbHlKWW1ZaTk2QjhMaTRqNVRDS1lTYWZ5YUI0UG9j?=
 =?utf-8?B?VkF2V25aSC9MOFhHNkEvVHp5d3RpOVNzV2lVOWNsWWNoZ3dZZUpuQkV4ZllX?=
 =?utf-8?B?RGo2T0tHU1kvZUNiSzMrUTh4MDNZRzZheVRUOC9Cck9WdWpXQTJPOC9OUkFK?=
 =?utf-8?B?eHRnbGx2cHh1bktnTmxQNVdWNzJJMWxScHp3cFdhSGpLK3lZZlg5dTBIbllR?=
 =?utf-8?B?YWpudjAxcE41dEl3NGdCNGJEVWRGUVcraUJReUtzcytmZ0p6Vk8zWkhCV0E3?=
 =?utf-8?B?VU43R096aDhGUFlGM1hjUzlRRytXS1dOMk9TOU56Yk0rdENwalI4NWp0T3M1?=
 =?utf-8?B?OWE0RzAzWjg5RVhQeElqSFRBRitEN29zWDRpcTd1Qy9yRHRsVUx4cFYzS3pY?=
 =?utf-8?B?ek45TCtnclZ4QTFDTExDNmNwdXZ5ZG5vV1QrWVE1NmFKaU5UaWhpWE1mR01Z?=
 =?utf-8?B?RVk3MUk4UEJkNmRtcXZkU1dGQ2sxSmNvQ1lDMGtseEhxN3lISHFtNTh6S0FR?=
 =?utf-8?B?cWNsVzIrT3NveWV1ZFNZWSs5b3luWUZiMWczWHJZSS95V2JpbG1wekxTWHlR?=
 =?utf-8?B?aU53ZHNqYXNyR2tyRUh5S0V3SW4weDIyVnBubEhYNk9TOXVwanZMK1h5cER1?=
 =?utf-8?B?TTJIdGtMK2s4YWFESng1SmhTbkRTenJkSGZKSmw3UzczYkhrSFhSVmhwQ0h1?=
 =?utf-8?B?TXN0TWkramRPeWJNbGJYazNreVFiN1hCYmZySy9yNnZwYXA4dERXUk4xMWdO?=
 =?utf-8?B?RHJPZjk5UXNSbGcvUDF3WTNSTHZRKzY0TFFEYXJsZkI3eWxoVFh3OXMvSU80?=
 =?utf-8?B?dHlZS2l4eXdsS0luek5oQ0Y2bDV2Y20xTmdsY015WXZoWnNESjFlWkhaL2pS?=
 =?utf-8?B?RUdBSURrZjhTbTlFVnNGZUNnQit1Y2dSY2w3WFBxYlNRMEM4cmJ6Zk5HTmUr?=
 =?utf-8?B?d29TRHBZY2R4WG4wSlhTQlBPbVBySWluby9jakhCWUdDV1grYXRHeGxkWVc4?=
 =?utf-8?B?Qy84c3F0d3Q2QTloR0NjZE4xb2FJV3ZCRk82dkJZTkNMT2srYjQ2Y2p0c0dx?=
 =?utf-8?B?SGY5U3pwM3hmRGh3bWo2WWhsZVJsa3lYd1hOSk8wWXFLVHBvWlM4NGVXVng3?=
 =?utf-8?B?K2NhZHRWTmhWcmRFYmY1WXRxRDJkWHdLRWxFYzZEM1hzU0o3VnVXN0tiRk00?=
 =?utf-8?B?Y29hQXh0cGNMSkJpM3l0UVZNV1hPa3E1ZXpybDFvVmhudVpkak4yanIyRGs1?=
 =?utf-8?B?RTQ3cGs4aTFSWDI0QVBMak9iZFpBUHNucGQwaCtqTktxWmt3VVNtc3pEZURp?=
 =?utf-8?B?V3BQdTFSYjBaL0QxNE41eEwwZ3hhb2NlZzNiWW1RWVFJK01raXdpSHE0VStw?=
 =?utf-8?B?Z3NxOUU3dXh5OG5iOXBUb3ZPNzRSV1oxZnNJNGtpUXZPck83d2FkTThCaTRC?=
 =?utf-8?B?YjNmcEJUd1RVL0xPL0QvcEx4K2RIeXFwRDgrRG1qd2pqaXppK3BDa3NCY1hP?=
 =?utf-8?B?YTlIM0ZZWEFtM2JJS2NWRlZiRk1wUVljeDVtUnhFQUFlQTdickhFTnhpTTlo?=
 =?utf-8?B?clh6Z2ZxY0JBOUw4SjhUam5hUXU0N2VnT3l1WGlMdUpralFTZGhuRjc5eE1i?=
 =?utf-8?B?SWt2cEFtSW9yRjdHQVJSRjMxaWlXNmxhY1ozNlJ4L0l6dmo1MlVUMlN2UFhz?=
 =?utf-8?B?eWtNTFZpZGdYMGJJOWw0ZjdYMzRWQ2tyaE41c2ltTmUvK0U1UVJEV2RlbHBq?=
 =?utf-8?B?VXhBS1M5b1RWOTN1RWV3ZVJ5b1V0MkxwelVaQzV2RjlGcTdBbEdxcjFxcDFx?=
 =?utf-8?B?bU8xMkk0eHRUN3JkOU1XTnJTZms2SnAyZmNJVjRLT3A3eWl2N2dKbDdueUlJ?=
 =?utf-8?B?bEhoTGcyMk81Y25heVhlb2JCVnUwVmxFYXhnU1doODVwWXltSmlmS2d3S2g4?=
 =?utf-8?B?RW1zcFlpd09zUk14SmI3ZHlkSyt1d1MyNWwvQms4L1RJVHIvdHlsL29MNzFC?=
 =?utf-8?B?RzdCWC9GdUd6Y3NWbjRKaWRFZUNRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf19fc47-c3d7-4a8c-1cef-08d9b913434d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 23:51:03.5559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqAvmY6EcjKY1Oy9wgE90w3Q4JiFIX3q8CWcE64bQxIW5nIcAVRfsO+E7COXWF+ROThWfMEvE9NpJlM9VpnRv5zWNHm0LNBhYBSiJl/YUZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2331
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=843 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112060143
X-Proofpoint-ORIG-GUID: hFFu-YxCowB2Tda10ik59atfX-3UVanR
X-Proofpoint-GUID: hFFu-YxCowB2Tda10ik59atfX-3UVanR
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
that add the new error tags larp_leaf_split and larp_leaf_to_node.

v4 changes:
- Removed leading underscore on functions
- Filtered $SCRATCH_MNT on md5sum check
- Removed unnecessary unmount code
- Replaced _scratch_mkfs_xfs with _scratch_mkfs

Suggestions and feedback are appreciated!

Catherine

Allison Henderson (1):
  xfstests: Add Log Attribute Replay test

 tests/xfs/542     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/542.out | 149 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 320 insertions(+)
 create mode 100755 tests/xfs/542
 create mode 100755 tests/xfs/542.out

-- 
2.25.1

