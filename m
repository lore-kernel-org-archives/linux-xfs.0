Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AC0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiBARSJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:18:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38454 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241061AbiBARSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:18:07 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HEC7g002994
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=lGdZlVAPfjVUWDGmpOQaW7hggA4cps13g/rHlY9du78=;
 b=yX8SqKagYdjVe+2IdVAqxFLH2eWexAXh3u/qGTaLReP88cVMryosWGtkIYQpM8BPCQmR
 P6mWvYYLWVZ8LCiYnJ04YiFSQgu+Vwuq9rq/8iLwWTpy0S73wZJML/4dxmvGfZw13e8a
 h9KeJMOd+TpsKq4lWU30KHBjJDP0z/xydW+iGukt/iu7TqXGuC4Ob2sa8iM/t0VT/iP1
 ct/4JXF1lagKYZWb+h/wTZb1R9l1TwABdHYXk9oitm0fT/yorcWThjs+XcTDUMWJAnLN
 lsW9Wb7MQ9eXZuNp+6cZ+Yw8WL4ODKl7ngyowf6N2jbrR2b8OT268W0mgTnCfJ1wFHyL KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatuph1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:18:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211HFf7s044953
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:18:04 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by aserp3030.oracle.com with ESMTP id 3dvumftbhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:18:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnMk2C6KHcdZvC4EYsh/jvTUeaBe/Nq7D0S2NxIfWRJuzt7Nu8txtd11bTslv0qxWwEevRsEzKpExBwtopecRoMG2MKLZgYO61d0SN3w4WzxByHHxFAcJubSbM8RJSkkEzcyke7sNokguC5nNmJrjUjGgoC8j0wPV8980k3PeaS9rCZtw2/SmVVDIJiQLX/eX25GfVbEhgBL58jZhph1sZ51hOitkRJn+30/zaHivBCFHay51y2zaqUb0b+3m9Wu8KSV6t7j/kEqR8ppcRQce+KdHqhVoEDw6sGJPeneBBNGcgR9yeYHz+dn4NAa6XkYxS2W4YuxYpq9DC3+Of0ung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGdZlVAPfjVUWDGmpOQaW7hggA4cps13g/rHlY9du78=;
 b=RYM2M6qe8x6Ro5VhQuz5RlDFWgAWkGwKx/nCnjvpAFClTFP/8PKIIsR9zNUJtMqLvkmZLNE/QzvH3+3LnHAXw9SMs8FnJjFn7LyHf1F7+Xrtwe0j4fgM957MusrI2qdOGPU1El4OGoZBKLMuVWOeFOMi6yo7LoSKExXMTfBL0Xn8pGrDGOQcYSr4Kw2NYvOYcnVzXztx6KHZyzUcL5LAoyPVwEaf94OyjBof/4fi6mTgRhiKEM6j9lzlp9Qavw2fZcrT+matMOYVJg5jbQUE51U/76Mb3d+6L06s2Rrt3PMHUdYI7YWpLTxdi4XlleOK0+ODQPAmlWefFzSz4Ug91A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGdZlVAPfjVUWDGmpOQaW7hggA4cps13g/rHlY9du78=;
 b=bF3fUUTGwJoGtw6fNgP9Gout70Lb9oWlYDJ5keSM4vo2ZAgoy/lp9C4YBnn4twbiNJSewPfGXcOoffQwPIR5GQrURsSOnwEAheho97ZM0vnUinzoKhuLFDw6/mEPaiquSkmqUmNzPVTVK7ZCHXF00f2UvK1PX9wYGYliAZ0UG98=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 CY4PR1001MB2344.namprd10.prod.outlook.com (2603:10b6:910:44::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 17:18:02 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:18:02 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v3 0/2] xfsprogs: add error tags for log attribute replay test
Date:   Tue,  1 Feb 2022 17:17:53 +0000
Message-Id: <20220201171755.22651-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:208:23d::31) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4dc8f06-e484-4c0b-032e-08d9e5a6cd5e
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2344:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2344B618E257C45321173E6589269@CY4PR1001MB2344.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NuW/TrJwyu2+s6eImMQrxPISx2ScDhhUaXmCRp+x/6PNKJIEfUuRvjYiwi5cxAQjafoN5bdtx5oXuZwyH2X4YME6w4JZDE7ygRGUkotIzLQFJX5ZoOoMKReKwnNtSuf521JMMkFGW0z0AUvKGt3at2BxozhxTa4gAGP0DRZiEcrbmeVnPxmA3n9rwDmdJkXvjniI8VZU/oECpfTqeCFmQvkeOJdNuHYkgsUVzRmghlNgnXW1Pc+/iZ5yuiKiG8bY15i1EiPnihemlf8XK65KTmCFZwptWB95WVXVJlWGg/epZktLUU8bEw1x5IjWZhap9XbrFJjDyPZsZbwifdwrAdyXfpR8jCi50FHIlqbHSQgBXDkHrx716+t066e8iGAKetxkeIITqzGlCXUYQjWmBt7QvFOtMzUjV9L8l672Lxr8NkNwCCzBN2hFZ+4djyBTyByi6kWRZtpcLX1Z3kIYrG0Gi4V/ptSY8ubE2xGQ0X1uo//r6EbHS/vKrqzw45AuVYQa2tJxdEOa0kXjmUUBgOJULx0hlDLmb7PZvC0j7wTsUUfeFjKjrHKiACE+0WKyCHlrBtTIlHIJe/VEUoDPfTeq+eaMGJGr/hX+xYkFM+c7lG2yYw8dBwBcfjVU5/LNIVOkngWYugbB20IOTfhPigZ956NIsJ2CGpOMYY7mI3FWMDhdssGZbQW4j8NNOBGNDk6HpWfuH1AW8rouapACJ7B5YzXIa5zmgRASDg4tp5wuvRyUym9xfZB3i3emFVS9Lc5JYIbTURLr1XE6avqRvSZXCs2DUA67W/G3Ub14jjk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(66476007)(966005)(66556008)(38350700002)(6486002)(316002)(86362001)(6666004)(66946007)(8676002)(8936002)(36756003)(6916009)(508600001)(52116002)(5660300002)(1076003)(186003)(26005)(6512007)(6506007)(2906002)(4744005)(44832011)(2616005)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0NUamxhdUYzWDFjbjk2S2V5R2JYQnFRVjl5S2JTNUVOZXRKZGljeDMzTUFv?=
 =?utf-8?B?RUxockpmaFJ4Z0FXcHczTkt4S0dlUEhuT1BKVksvK1RXY1J5b1RBcDBxWDhR?=
 =?utf-8?B?OE85ZjFXL2JVa21SckZqLy9ldUFuVm5TS0NkUGE2VFZ3ZE01ajUvSmVUQnEx?=
 =?utf-8?B?Rk1FRFJvWW1lVGpiKzVIN1Frc1dWYXZOUEZpNU1oTlAwZlZveHlHSCtFVHYx?=
 =?utf-8?B?b1BhU2tFRmd3Tm1lTys1N2F6SGlNaW9aZmVDSzdVSkt6djJObU5WbGFpMmt3?=
 =?utf-8?B?bkFJZElvd1RBT25TNi9jaGczaXZVeVY1clQyY1pDV01SdS9Ib1cxRmJPb0Ru?=
 =?utf-8?B?ZVdlRThaTE5vNVRGMGFFeTFZUXhZY3FVSGZMb0hJZHlmVGpKV3RtcWV0ck8x?=
 =?utf-8?B?bHpkR3dhcVA4OC83QnhtaVVYS1p5OEFmMGZtemtHRUpHTVlkbXdYY01lbURs?=
 =?utf-8?B?Y1k0bit5QnMrMmgyQkhIRDlOb1hrakp0THhHWXJMK3JNRkxrS2F2OE1ZNHpm?=
 =?utf-8?B?M0d5ZnQ2TEFVNlNPZDlCbjBnenVBWThJMmhMTEdQenYyT1AxMWpRbklPYVVR?=
 =?utf-8?B?QnN6MFJEVXlFYnF6Z0FkbnR0RERMMHdiQ1cyUkJGS2NGMks4TWpUTGxiUU91?=
 =?utf-8?B?K1hXQjBNWUphOWZ4YTdoelBvc2JSQi8zc1krUnhSSVg5aHA1MmExQVA2bStq?=
 =?utf-8?B?RnIvUDBKbUwvVWloNGFqemU3UkN5d2d1RXdiTTM4Zm1PZ0lzNkVnMzRLRndi?=
 =?utf-8?B?U25QZk0vUk81ZjNpQlo3SmVkS2c1L2FPcGwvbXFJUDVzMnJMNGRvSjNWV3dj?=
 =?utf-8?B?SDNSSGtpOTFuNWNaZTlORG5yY2F1a2NRNTEzakpLTXk1SWdLMmE4L1ZrNk9P?=
 =?utf-8?B?Q21PeWR6ZFp0VEFtWnZHRnFYb3V2WjI5ZGhsUEIwTElWenRtY0djQXNsUWJT?=
 =?utf-8?B?UEhvREdSbTloaVg4OXVTT0hBdHZTMGp5TWFKNVlVVXgvZ08wVWhOK3ZuTVdT?=
 =?utf-8?B?SmlQUzhPdjZuejhqeThEOVlMNkRJanZtMjEzTjRmeGNYS1c4c1VqUnMzRy9I?=
 =?utf-8?B?a1RjVWhEN2JBbEpWcWM0Zkl3OHFFL01XLy96bUpJT2o3d3lKVHUxTzRvMjdq?=
 =?utf-8?B?aUx0ODJWSTlmeCt3c3dLK1pHcWl0UDVWMS9SejhkR2xMbkVVa3ZqbVlsS0tV?=
 =?utf-8?B?eGRXVCtYUkViN2RkQ3ZkVVdoNjNyeGNrR1V6bXdKaUZoSHl6V0Y3Ym5vdnNq?=
 =?utf-8?B?TzdzSngybmNnRWRJSWswNWY0Snhuck9ZcGQ3VU43YUtvVDYwbnYzZUtVUDRO?=
 =?utf-8?B?aGxKUFY0eU9yTEZnWHNVdlNhMTAwODRRMnZrZDZWWDVGNG92NFdLcG00UDBR?=
 =?utf-8?B?Sk1aWFlEUUpVdEtTcDFNUThzN2JlKy91cjRONFdHclhuTnR5MWdINHVOeDR0?=
 =?utf-8?B?U3hSdzdoTXBzQ2dzSGhickRkOHo2Q0I3V1ZGVURXOHRSbDRVUk9ZZnU5bjJj?=
 =?utf-8?B?d2IxWGpBVk0vSnpvM0dpcDlMT1F5b0dnT2I5dEhIWFFtZVl0c2Z4blE0bnBV?=
 =?utf-8?B?U3NlQWpBR2RBVWV4VnpZNWZWOUJTSkIvbUM2S1l6VWJvdVFORU45RUZkaDVL?=
 =?utf-8?B?VkdWOE56dmhqQzU2am1LWDNabTJ1WGpwMCt6SDRaemxPK2hrTTNqcjFQd1By?=
 =?utf-8?B?MXA3cFNRWFY0MnJhSEZabEd3MHc0NDRIWDNMejRsNkY0amJ3czN0TWNZWXJD?=
 =?utf-8?B?cGQzUmd0eUJkYm9tc1NReTlsNjJLcGplZGtiNCs2MFhlc2RBQVcwUmlITlBN?=
 =?utf-8?B?K1hwSkVZWnA3QkFtV0lzUHM0ZzFzd0c0VkVRTFpRUjNkeklOZ24va0l2aUxC?=
 =?utf-8?B?TEpBSE8vSVhkR2V2U0FyZmJLUnpRc0dMNGgrOWpQanZHdTlGN0tOZ2ZwaDhY?=
 =?utf-8?B?akRHbVpDU2Q1NDFtM0gvd0Nrc2NyRWdSRVJTVmUvTnppeDZJNUszWm8yL0Z5?=
 =?utf-8?B?Q0VNMGFhNXZIMnZXWnJNTEd3OG9LajJnbkg3MElHRE9sSzZXYy9sRzQ2OGJO?=
 =?utf-8?B?YXM0UmN4OEtlcTQrWXFXdXROUlo5dFQrbmtCUGV1TXNKbkpVcVlqc0tTdFRt?=
 =?utf-8?B?VGFaWUI0MkZtUWVxZE11TGZ4ZnkwZG1COWp5NnQ1cjZudUVjRkVmVWJ0ZXl2?=
 =?utf-8?B?ZWtaRURkQW9QNWtkY2lKa3JyOHV0OWo5NXFHY243TlhqTUdnRm1ETmgvRGVZ?=
 =?utf-8?B?U1hndlpNNXFTM0dheUxwcDlUZ2N3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4dc8f06-e484-4c0b-032e-08d9e5a6cd5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:18:02.4333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiTZS9UVodVLKiYEt7TY1YTA2s8WD2Imzag0KnyTHB8P72b+8IJTRLZLcFmlq+xdBufcQOtmH4GWguYtp5ZaK+bKwzuhGVOWiFZcXVUVmgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2344
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010097
X-Proofpoint-GUID: iGpp881_7n95oxO2saYgnQ7uKKdl2kOS
X-Proofpoint-ORIG-GUID: iGpp881_7n95oxO2saYgnQ7uKKdl2kOS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the corresponding userspace changes for the new log attribute
replay test. These are built on top of Allison’s logged attribute patch
sets, which can be viewed here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v26_extended

This set adds the new error tags da_leaf_split and larp_leaf_to_node,
which are used to inject errors in the tests. 

v2->v3:
Rename larp_leaf_split to da_leaf_split

Suggestions and feedback are appreciated!

Catherine


Catherine Hoang (2):
  xfsprogs: add leaf split error tag
  xfsprogs: add leaf to node error tag

 io/inject.c            | 2 ++
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_da_btree.c  | 3 +++
 libxfs/xfs_errortag.h  | 6 +++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.25.1

