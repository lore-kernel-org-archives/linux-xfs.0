Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D090C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E6661251
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhKKAOW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:14:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27704 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234172AbhKKAOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:14:21 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AANdm9a023573
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=wPWD31PBcAb3TRJcipRmGIvlgmGLzu94wsdkuHkYxyQ=;
 b=Av1w23J02YbP8lp3iQejjLkGrYa9nKkw+rzHP08eNGUzjpvsKEi0x25DjytLiawTVIEs
 HSidHJraFPwgkkY4vK2ALmwBhdCzaAJMjAiNSTy70JiNkLICV9rTz3qsVlv8zk2oWzyr
 NGB3+B3lcmYPiycu6F+6+M1JLNveEDPncWP3tVG3qQ7paC8HprCoYJCNxgABg4154kYf
 o0wWyxhHV9L9opR8ZmSB05VxxymSNKrgL0lNMHxhgTI0fHapfUZ7f++asiiGy1VDpbk5
 f+gnP4pf44r/OQOyr+B/jewziEt2QZbzchH8nySiuSDY5sQUsfnZiyC3C1NpdAd2m29g AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c7yq7gg41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB066iU064032
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3c5frgd70v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:11:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOe7o/OtJlTPf9qHrtThqaUcszrx3T5RBj/EPr/0rih08p9A9yH6DpMOcOC3laOYyNGgzcJJuKMNpHHpFeDs1a4wn5EFuKoLEi6WkxFuvqj378j0IJ0z3/d0hZ5fdyTg6dGss/gKjvXqjEvGnZh7NYdLdhhZD5U/Naepa7XseRx/2baWkOQet/H27jOP04wAWD7fYcKSkVGQKCLosJXnHfG9aHo4aYtj2yjuUR9vkwAEMaM4V1AHk5ZDaL2cuYBEwM0Y1YUxy/kz1BFYTiCnoQX1EH8NVw6lGkmc7Vih8Vmh/0gSCR8gl66MOwCuVW97feSIOEJWGCPNyvkwVj5O+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPWD31PBcAb3TRJcipRmGIvlgmGLzu94wsdkuHkYxyQ=;
 b=kCp3BevFDRe2N1gWQthjeAX3JPei+THiMiK6QkIvT9T7fdFm9URiP4s6CADv7WiWc3Sjb0xtn5bpD0/TDZVFjPNOTAW3DL8UlN4CkJbg+osHIpmof/3PZziBzVQNj5RcQe3SF08dgrdI/vqinYiBuCXk1ALsFuhWZRVEKX5FQlAtN38DV4rl1lRWjRpgMX0yb2hYPrCE+m4x0LO0SntKpzsDzerdKvqurk4TQilXjijD6QORa/W4qni8NLzUZ/kGXCkctF+yNuhgXs605JMsq5iNJTOp96IzQxnS/YQ14Wz2McDf5VgNATQA5hPfNlPbP5tZ7aIqiYBYuFxgYfkxkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPWD31PBcAb3TRJcipRmGIvlgmGLzu94wsdkuHkYxyQ=;
 b=C1n1Rb3fDAQZPWlFy1AKnhPBJtqkxM+Ozzp0AKU2MO4yS0wKzcdLSP9bEIU9h5kTuoT2yxWWV+FzNrz6cRWWq7HjUq2IFpxVbcbXDUlFKVkHKb4hf53a/UkdQFCokdtlxNdGyRSRDrefrWrGFsgem8ndTB7660rFfIF9zQfxfKo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2252.namprd10.prod.outlook.com (2603:10b6:4:31::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Thu, 11 Nov 2021 00:11:19 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:11:19 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/2] xfsprogs: add error tags for log attribute replay test
Date:   Thu, 11 Nov 2021 00:11:10 +0000
Message-Id: <20211111001112.76438-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0428.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::13) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL1PR13CA0428.namprd13.prod.outlook.com (2603:10b6:208:2c3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 11 Nov 2021 00:11:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddb77d49-8a73-48eb-3662-08d9a4a7c953
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2252:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2252C5BFA734E864CF8A285F89949@DM5PR1001MB2252.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4SFJi1eAgRYPStHJV8LMvm14PbY6jtZQZk7wDZMU/M9xzT9AiESDr3DRFaIGhAgYGLlnxAOZzBfm9HjTrxqWXy4lachVSp2tQaloVmIO/wL3AbEuu+f+O+zMB7hiRn7xPrMRfhMcIXNh2FlyVuZ5V5SOgNkMZpjn/GE7h4ZkNhsgD5gEG0dbnmCibIE6Zp75XdVswDuKsM64JCOyKo8FUlSKYxGI1z+lq7OthpuKOPh0FHgmdSj4aeervPttKsmuIHVzPdvQbHf2N6Fv56jc5OFltxZoIG+SE5dlXIKn0SbvH+hGqB3Ai1WEXidj2TAHawINBKhRYiY+9tqrvgJvxHWmaM2cIgiQuN1KGiVPWXZhhWFsXt0rGmL9qIeYjt8nFN99Pc80OSZdvo78eH02gCyUbRkKNz/XV4E12eMidxzIntP85jh27MjJ3fFQD/3yj6EVYM5MXiPuq8Q+ZbyezoOeH7WOOXyeN82AfmtLvExHVQRa1NKF6Se1Swrp9ZLn5hsz1Wfg1TMDFijJKW81EQU+/i0sxZMWgmUqbSDfWtIJd4Qjk0rJ6KWrpa2c6d4utS280jK0io/iX88d3mAb9+fZ1Aztk5Cau1vKQmsCCU5IV1kjP1aaW/j1ZkDrqOwZQpxL4kCf4UnYHsbAoemyO4gbW1PxDk1HbxkK8KFg0218wqxkvkdh4mdeiBDU97Z+spMXznGsKLKVkPGhPmeXRD0Cgk+OcAy6yj5wCu8c3JtLABpgC+mP3/dJNaJvqD23z4v/xWeJauWTpI+c5yksGAZHlkCkd+4DFbrQ+fMIrog=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6486002)(6916009)(38100700002)(38350700002)(508600001)(186003)(2616005)(6666004)(956004)(966005)(83380400001)(26005)(36756003)(2906002)(52116002)(66946007)(8936002)(86362001)(4744005)(44832011)(1076003)(6512007)(5660300002)(8676002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGFjeldubUl2dWd2ODZZQ1pmRUx5ZFAxN2MvNG8xbnBaMGkyZjNVc2k1Yko0?=
 =?utf-8?B?TXJyS3VZaFpkdWZRMzN1L0dieW5UVC8xb3RlTjE2b3NhZjhWeWxHYk1ia213?=
 =?utf-8?B?eUE4Zjh2SGNRanZ6a1JZVklvQS80ZW8zYlpRK3h1c1hMUFBoOFdFcnR3OS9S?=
 =?utf-8?B?S2t6dzFlTFVMaml0OXRwYTMxaHI1OUpQV2lUeWFlS3ZFWjNkNlE4RFZvSTNv?=
 =?utf-8?B?VU9kMGM3elBNRXJ1TGswREIxUCtDekVrM21KOCtJTGFTSUQrSXZmenRmVjEv?=
 =?utf-8?B?OFN2VDNUZVlVWmg0eFRuM0hpeTdpM2taS0cydmd0QkNTWGJvRnZ5UWtZR2Jk?=
 =?utf-8?B?RHFTSUhzZ2ZWdXFQYThuV3ZCR056TlRKczFVNlRpTU0zeFBSbTV5bnA4b3lq?=
 =?utf-8?B?SGRFbnVlWDB2bEVaSmFmK0l0M2l3Zk9hUnRtNFJtL2kvOVBRem0xdFpNdlFZ?=
 =?utf-8?B?K0NrQk1qL2ZZbGpoeU93MFpUQ29HRVNIZitlL1ZjbUQrWWhuamNYNmdmeUJS?=
 =?utf-8?B?YXBsVWdEdys1VGplWEh1SUtsaEVqbHR6bUpNNEVvZFY2Ums5ZCtaTDh4SjhY?=
 =?utf-8?B?NkRsUUZlMGFQaW5FODdEbWd4TTRETlNpVVNQRlZOZ0VBNzR6THUxbmxleG56?=
 =?utf-8?B?NG1TQmllb1haYmYvSVB1b2xSaG00TExCRTFxdnVPbGViMUk4U0FRMWZPVjBP?=
 =?utf-8?B?R3M2WVJ2dVpVYkY5K2Y5YTZxMWp1VVlxL1VDYjN5MXF0NVFuMHRYOWJFK2gr?=
 =?utf-8?B?dnM2QWdjem4zWUFqZzRzSUM1bFJ0bFB1UU5SbFFCZzBpWlJJWHE4Rml0TTY4?=
 =?utf-8?B?MEhZdW4wQWpBYjBsd0Zhb0ptTXJmY3RqeGJaazFOejgvZiszTkpYd2VxV2hE?=
 =?utf-8?B?cjcxYVh0UGZ2ZGRaNTAxZ2NncnltbUN4R242TFNXQlNldHZqYStpNi9ZR1lZ?=
 =?utf-8?B?bkduL2ozZTVtck8xOFd4YTRSN3VPZk1rVzZmczBHVmw0U0h2djZuYWNPeWNM?=
 =?utf-8?B?SDBXTSs2eVA0bXRXSGFWTzRZdmZ2aDZacEJBem9XU1lMbXFFR0tydmJZeHJZ?=
 =?utf-8?B?TzIyUDhobERZV0pVWjFjekRZN3VuVFdFTnk0djNwSG5JUm9qRTE3RVlrNVlD?=
 =?utf-8?B?QmljY1BhNVFKMnZrWDZyNG5xRnBHS2I5TFNFN2FtcVA2c2pzWEtjaFBXRmt0?=
 =?utf-8?B?M2hZMDNxQjNqNDdsdmpXbjV4cVlhdWRFSTJWQjRUQk4yU0tXdG1VUWFKZ254?=
 =?utf-8?B?eXgzbWdXNGV4a3pYd3RZYjJrbW1UdDlHU2RER2pndHdmRjBzTnNwUXZHUXAw?=
 =?utf-8?B?Zlh2N1VzT0FlOHVOZDRxYi9mankraGhzdUNsalI5RzNDaUQ3K1lOQXluSFFF?=
 =?utf-8?B?cnpjcFRNQndldXRNQ2xMVkZhaVFRWWtwWTlWUTdHSm1haVFsaVVOQkRxRW43?=
 =?utf-8?B?SEZqU2Y1Rngxc09DZExiNGo4M1RMc0FsUmV1ZUF0UE9qalBucy8vdStuQTBn?=
 =?utf-8?B?WXQ3c0d1MWEvcjRnMHhGUFg3WVNwUDFSdENoY0RKeU1kS2gzS3RldXV1bCtk?=
 =?utf-8?B?WTlGNE5PMk1ZZUtLOXBLTEtXNWQ2Sys3MFNQeVg0UHVtN0pxRG5oaXlnbFhn?=
 =?utf-8?B?WmloaGdjL05rbzZTa3orSW00SDdPUXlXM0dVemkxeWRsUmgvL3c2SkgybVpa?=
 =?utf-8?B?ZlFPeTFyQitMdlRyaUhhZlZJdWhqSnZVWDF2dDF2VmNBTVFiSVdqeU9HRUtr?=
 =?utf-8?B?Nm5ta3poSCs0KzU4TXJBQk9SbSthQkNRc1pjWEw0MGtuOE1Ecm5tK28yWW13?=
 =?utf-8?B?VU1VTzFUVk1yWHcvQVBVSHc3RUtvazF1SjE0UGUrOHdLV1dpMWxTVEk4dit6?=
 =?utf-8?B?bVNnSm5MSWNFdHJUSnhoK1d0MURneXh4ay9zWi9ZNk9FSENZK2F4VlpCa3JG?=
 =?utf-8?B?VEtjUE5QZUlFV1I1UFl3Tzl1bUFZWFV1K0pQU3BoczdsNmpzYUtva041bVRl?=
 =?utf-8?B?aHVpQkM2emRlRUxkdUhUK3F1MDhob0FsNTNIZHNuL05Pd1cvNEtvcVl1Q3h2?=
 =?utf-8?B?N0hoSUhPRHJOdTVpNFY0Y0tkL3pQRXZLSDVrdUxGaENTZzFaVGkraEtGWkJB?=
 =?utf-8?B?SmJKaDZ6QjZVMkk1TWR3d3ZPa21LMWFJVnR1N2J0NGwrWFdjQkVEUUtxdzNh?=
 =?utf-8?B?VWtmbmZnTnVKaVZCL29KU3Q5dHB1Q3d4M2JYUCs2clpmMWVYR2FQZkpUM00z?=
 =?utf-8?B?N3IvNTlHb1V4VGh5NmQ2eEpHRCtBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb77d49-8a73-48eb-3662-08d9a4a7c953
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:11:19.5252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/XPgKvz7ArVbRNyIfNROD2SZJ1gnE92oeIQPo6sJ/AOX95NzdAdpjmUxM3rzxTIkzjyR0kl6S/jeDavKW9cqsS73H+YBkU3uZEAfp2BRC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2252
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100116
X-Proofpoint-GUID: bYP_W4ZSO2QaMEC6cLQj8Q3uebt1kXvS
X-Proofpoint-ORIG-GUID: bYP_W4ZSO2QaMEC6cLQj8Q3uebt1kXvS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the corresponding userspace changes for the new log attribute replay
test. These are built on top of Allison’s logged attribute patch sets, which can
be viewed here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v25_extended

This set adds the new error tags leaf_split and leaf_to_node, which are used to
inject errors in the tests. 

Suggestions and feedback are appreciated!

Catherine

Catherine Hoang (2):
  xfsprogs: add leaf split error tag
  xfsprogs: add leaf to node error tag

 io/inject.c            | 2 ++
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_da_btree.c  | 5 +++++
 libxfs/xfs_errortag.h  | 6 +++++-
 4 files changed, 17 insertions(+), 1 deletion(-)

-- 
2.25.1

