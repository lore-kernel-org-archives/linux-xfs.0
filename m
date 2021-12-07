Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D294C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 00:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359871AbhLGAFU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 19:05:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55512 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378046AbhLGAFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 19:05:18 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5C3L004499
        for <linux-xfs@vger.kernel.org>; Tue, 7 Dec 2021 00:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=nwQo+dRTESr5iM9qAB7ifh2MoeH7/9fQACmelP5TfoI=;
 b=g1MU9prGqdM3UEUVjwVJeiHMNWE3Kn1bzagV0C0isJPpyYYzRSV4WnRIA6uudLFhJLsk
 +Z5T15xl1/d/VwkdDZ2rtMlVz/t96kyhJueY5NTnLNLo4OCwGc+wYNnbYGqst6g4x2MP
 uvxRpqPg6w908QJiLlSNDhm9tbUbwctoU5hP12c2JKtEqhjyAUqEMViz3TYK/6FH/eAa
 w7WowNHwFiGSB3RqSprNbYIfSLD9gcGLTijltCEoFz0JXdkwa2/+yDfJiNNugpqTE74y
 QsVsfHONhbdiNJRRtprYqWul+ih7lHoRmnvplINPpkBHSFfS438cMFJmKszJ8UD14SXK tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjbpsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Dec 2021 00:01:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6NudqM089637
        for <linux-xfs@vger.kernel.org>; Tue, 7 Dec 2021 00:01:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3cr1smy59v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Dec 2021 00:01:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbtcPOPb5DrZOUsdaasf8m4yAZRRt0u08u4SyZ1Cj9neKC32k0s6UiXuTH6VZeVX4jjdXGEqm5UusBaEm3JOciZPif7897+8THuJsqtp3xY/YvBefg1ZMfZqllr5jjo/zw8CVsje8Et2gLkqHoSe5VbDioIbB1dL1p/0u5DcU9x0zP4Ivc3H/HTXm6Xl7rWuXe8ornfb3T347nwu5Wo1z4I/DASHQtS5B1mIgvibSwxRDD5yjOz0Sha1vwt/sStexD3Cgy2+AsHOl15yR4klekcrZco/7SAAzz9H7oSzh4tMylPpUJ4g380Qr1xVv4a3vop889bjS5jLV/xGGwAwmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwQo+dRTESr5iM9qAB7ifh2MoeH7/9fQACmelP5TfoI=;
 b=k/5TSTNObG7xf5L9BvLBcB06/JcSzmTFul/4U2dslBOH7TF/wQm6asS8nPRfO6JyUbaBhBNAEg5z9WbyWafDDrhBC7PpuRCGFa1Xufys0o336h+YYiPAW8UkJGl0K+k8RZaRy/uzYGZV9Wa9oJqDWmFZ6plTjhupd7/sIpsLrDkJy0+YRduxN2tdMLsUWP1A+koNVwWlZFmNTNDj/VTDZlU5c5w5FYFWImn/4fsZTJzEEcHjRMZ+exKawSnWAWSvcl1vMcKt1RoFASmfp97c/b2ToqcDC6LG70IvkKfwjRg4YjeMJ0yoYmA63x/Ie8ZPGnu8sw9582rO1kbzMd0baw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwQo+dRTESr5iM9qAB7ifh2MoeH7/9fQACmelP5TfoI=;
 b=JMx5LLWjc7Ufa6hKy4pvYNu+3uKUCX3Xm8GRgVQXwl/BRRroOYo1xrZWm8U8ZotKHREeZz8BziFRk1Mi7IY0dn80GXc7lxP9W1dycgI+Ey9bQeSNzVzGqT2SrU7GQNf6iGQQwie2gFWL3bExPh0T4eHFFuljhS/5/l2Qvsx/3Qs=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2250.namprd10.prod.outlook.com (2603:10b6:4:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Tue, 7 Dec 2021 00:01:43 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 00:01:43 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 0/2] xfsprogs: add error tags for log attribute replay test
Date:   Tue,  7 Dec 2021 00:01:34 +0000
Message-Id: <20211207000136.65748-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BYAPR07CA0036.namprd07.prod.outlook.com (2603:10b6:a02:bc::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 00:01:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bdb529f-1bd6-4967-c46f-08d9b914c0ac
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2250:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2250C50DC85DB16E86CFE6D9896E9@DM5PR1001MB2250.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jyi/mh1dU5wugDvo8Iu9exk35g1FLSS1bDtH2YBOCry9olcQsXmqnd/pAwzT4hJM+kMW8+dXUKEOTXEvie8FT6miuh1UdsG2dnPDc26Hn1fDFMCy2WYTIakKUgjsEcBaRe2xxJo/d/1vWHQPdu5nRDwKtSfxytKHhWr1psQ7Euvispozfg9snnLEWN4+lbnYlSQSRQ3OS/n64hTRErT08fVclay4gIwO2+XObNgFAUHTosPPEByIT1DNjfecblLBEgRBdnLH1+imwsqJQk+YAS7LGHvbMm3Z/2R2jTb6LnHCm6W5SDLskJYR9YWA9+XUukSg9kwP2uIK4dPwfdtGfF91OLidPNCK1X551mqwRpYzjcAZ80zT3u9KT5pCwj4eUvAfRpQbn4oQsy0CHCxs1LMeEsx/wmeoz39UwLgUx79B55jeIR6DK6bMXB9JKz5FpyeVar6+K/7odpQTgU/J9u3h9nJmg8ryAMMTHbcfuGLtuePqU7j2Id0BZb7kvcLxIA/Z8d1Hz8Pw9A9xL3cFXkBJQnbpH46U+xIzatQcfUdYse2nycEn0Buu1eC48e1aYOD6RVLUAUQ5KT/PKNv6Mp+WyueXY2yBXDeCD59JtHKoNiTUGrVNzCqVUd6Rf2lWL18eWOyz3KzmrHnM70pt36VvqTPbPL1KeIdIkCTkkgVrzs2mcBDfXmkbV9NfKPzdqmpyGLy6sWUeP4qp/T5d8ZTkeHKXpthhVDcn/Iof9n9jrRtqqh/nYCAAXlEnLAQ/jP9GqKd+ccj2ypKhoHU1JBYBfiyTDxNQLN6/G3nxzdM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(66556008)(66476007)(6916009)(66946007)(966005)(2906002)(6666004)(36756003)(8936002)(8676002)(52116002)(4744005)(186003)(956004)(5660300002)(44832011)(2616005)(6486002)(316002)(1076003)(508600001)(83380400001)(86362001)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzFXenRIdmZ0Ukl5M3dxaThwMlJ3b2pkS1RBWWwrWFFvNER4SU0zRm5KRC9k?=
 =?utf-8?B?UG1WRDBqMXU1T1VPSUo4VFdDdEhpR0dmQm1CcHJDT2Nvc0kzVFBhUjRQbzNz?=
 =?utf-8?B?c3VmYVBIZnIrVzhDTmpMb05WMm1INVpGSVUrUXQ1TzRNZzRvTnJOUk1WZFY5?=
 =?utf-8?B?QTRKRTQvdFIyYjJGYXZXZ3VwaUF1MEhPYzRIZ0x1ZWRPdU92VFRncTQvM3BK?=
 =?utf-8?B?MFg1cktHZnFSRWIzZUpPN2JLMzBZSXdZK1A2Y2pwa3dqSWYvNzJDNmkrYUQr?=
 =?utf-8?B?bm1Fd1pxOXBCeUVuVExVeEs1LzVTOG5mdFhQMWR0eml5bTVDem5sVjJtREU5?=
 =?utf-8?B?Q0lGYkRSc2RRMXV1dnFmVkFIa04rQU0rTVBYdjJweWh3Y256dEtWM0J6Vjcx?=
 =?utf-8?B?RU5tdW9qNmdVSU1PNG1hTzc1eDNlNHQ5OUgrVkIyVEhjaVZkdGxJejhrOFgr?=
 =?utf-8?B?TW9WYXJUUXg4QmloYzV5Z1owaEMzOThRZFgrQVZ5Y0k0WXk1NWliWnRzb2Q5?=
 =?utf-8?B?YmRwRmJUMG5IaGxXUXRoVDBKUXRCMWI3eFJFQ0JBdlZ0UWUvRjhhYlVYdDNj?=
 =?utf-8?B?R0hPNjEwU1ZvY1FCdVZrSmoyckorUlBkeXVjclBkOHduTWttYkVDQXFzUkh6?=
 =?utf-8?B?b3lFVXRwMUxIcUtzenUrUzNoRU5KRkp4OUs4M2pPeUYrQjVBVVMrODJrWXNB?=
 =?utf-8?B?YTNJdjVtNTZyMkFsSGdlSkVPRENtaTUxa3dmTnMvd1NMbW9WM2NSQUZTQVZG?=
 =?utf-8?B?aFk4YXZyVEVvVDdQNW03Rm1LdTBtalRkY25MR1dlaWxpbVh2YzZ2VHpVdDlG?=
 =?utf-8?B?U0RiOVo5NXIyZjhIY1RJdU44WnU1TjZaRWlMK1lTR2JwQmpWbzNMMVRyK0Rq?=
 =?utf-8?B?Z0taZFowZEV4RTBnbW55VE94YkdNVnVNRTY0K1k2VStGZFRDbGR0Y3VKRW9V?=
 =?utf-8?B?a0ZoWHBia0p5MUUzL1d3S2p1R0lwY1RCeXAySWFGVWlFRHRiRDI1bzNqelpY?=
 =?utf-8?B?czcxck8yZnF4Z1dwaVVYazJjTFRRQ1FhU0JCV1JVa0hvQ3JaRHoxLzNnNWR4?=
 =?utf-8?B?VGN5aVJ5Q1VDUmdYdU1UdU16RFF6cjFZZ3Q2TEd0U3NERklMMU13bit5ZkdO?=
 =?utf-8?B?RXBkUUtpd2Z0RVhyYUVrRUVHT0xXY3BxV01VVjJSWlgxQk5RQ0ZRbjh1cTFX?=
 =?utf-8?B?K3BGeE9VTnJybXlRakQ5ZDBGdjRDb0xSZ3FEWElGWDdTcCtMQndJMTRRdU9i?=
 =?utf-8?B?bHZJQ2x1VVBEOWYyYnJrVTlCTGVsaU40L0FmTE1wM0hTTnFnYkRCMzhCWGJr?=
 =?utf-8?B?dTc3TXZINS8vWCtuUXd4ay9EeHRkaVJLZEtoUGRENzBPOGZOdGkzd2hPdzBt?=
 =?utf-8?B?VGczWDBtWHRUamR0aENQUmNSZDREOVVieVdJMC9tNFhnK1I3UmtzSkpraWx0?=
 =?utf-8?B?QXVpS1RuZXY5alR4T1hvY1BpSzlSRnJiWjhkeXYveklrM0xWYVJzU2h1LzdG?=
 =?utf-8?B?QnNGT0JwLzBWZU1EeUVBejhENWc2NFh0QUJCZThkSWFpd01aTERXbGZOY3RP?=
 =?utf-8?B?VytqNk1INnM4MStnSE9XMkc1a2sra2ZuYWxFZUtIZjVCWXhuVEhub005amp5?=
 =?utf-8?B?M2tQYno1M1RGVzQ5NkRPMHlXQzcvQkRlZGQxNmU3Yk1uQTMyai9qUWhvZXhY?=
 =?utf-8?B?TnVKaTUyNGVWKzdIYTc1WmcvZ05ML2hNYXVPaXl1VTlYSUVqQkl4aWduR1Rs?=
 =?utf-8?B?cHM3azd3Tk1rQkVCalJPVldBRGliZ0xZNDdZckhrVzNaUjA2NTVPU0N4QkRP?=
 =?utf-8?B?ZmlhYTFVOTZCdVZaZVQwNGdsNFBRSCtlSGE1MGhLYjZSZkdzRFU4Z1BEOGx4?=
 =?utf-8?B?eE0vWEpqSmUvd21RSjJEcC9jSkxoYnpFUTl3SHRqOUYxSVZ6bkJEM04xbkZQ?=
 =?utf-8?B?YUJkRVA1dE9tWFBYdlcxRk1sZGU0cUpGcmorMXdnV0pyMWk0cktHeWMzRHlp?=
 =?utf-8?B?dmZWTHlJQ1JBS3FsY3dmWkl5VU42bEtyQk9zWmwza2g4TWRicExlNWduc01t?=
 =?utf-8?B?bDV2UGFhRFBDbVlSbk5zeFJOR3l4UWdFSXVLaWFCbjlKR3lBS01uaHcyZUls?=
 =?utf-8?B?WnUzcmhObTN5bVhBeHlXV3FZY20wWlpzUURTWEhTRndDOXVQNElRSDdBbXhT?=
 =?utf-8?B?NmZ0Q1ZMYkRWcFJWRFFwOEoxai8zUTcyRUZjbVVZQXlqWjl2bGhscUhOUUpq?=
 =?utf-8?B?RjhrVkttdjNNejBXY0Nnd1NIUUlnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bdb529f-1bd6-4967-c46f-08d9b914c0ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 00:01:43.4487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8miwieEO6hqGaM6j7JMAeetam/d7GcBAodZ/gJ01azLOFIY7JCvKG/fw13S4DeBFmca3JL+9jA6rKyJ/rMduMKPJ8CjlvX5C5mp0TmMYh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2250
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112060144
X-Proofpoint-GUID: fQThiRGNKulYUUw528hM7Fbwcnk7qfNX
X-Proofpoint-ORIG-GUID: fQThiRGNKulYUUw528hM7Fbwcnk7qfNX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

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

