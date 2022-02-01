Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFD2C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239820AbiBAROl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:14:41 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50948 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbiBAROl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:14:41 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HE3H1027869
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=pLozePUcLT1h6IztWZZdHv9w/2GYs1OFru384ZBrWLI=;
 b=AxZGCDq0tp7crFO4g425/k0hxhx3hrN6y1z5zpnQ5MStvVM3dX3CIr/mWq04fy5qbe7d
 h/BYiYi3qQ0lV/KSQr6dMoj6xLWy0Hbp7jhhQoTo0U7HHanlZ1z5UufnZnMxcK3Bvs+M
 nh2qinjwF8iGWGFrekvwfftEo0/ZrpqwsQ7Ym7WlYiV2sEem4calDiJ2oJX7KCBsoEBe
 EW7RHVt4940eFEoRuNSJb1Xmt7VAXZOZcdDcAP0Zk9xKSrs93PFsi2m7lNlzBtTHK7v0
 JEhMFy0KEHVkOaryvSu6QWPFt4xBsbpGAI1Ds6QTZPAvaqAlV9hHXRdOrH+eEQduN2kg 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9vbmmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:14:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211HBSu8156543
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:14:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3020.oracle.com with ESMTP id 3dvwd6k4tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:14:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uu1iGIUmSuw23SgxDtckLCZbKTJz6Aw0sfikapS9eujfGSPW5aJjsToQUnSxpa8sex6UjUoGk/DI4qPwdcqT5oc8eo+M3tL4ptTuZ9kAgrBsh2TJObFJSjMssopnF3RqdlRx2viZzXVUeBpwQvJn/tf3pMfqiSbr9iRHXqX9pjwozpfL8Bdad2D4GAHY0HoB6xJjgeuvF/zzom9doe4fHCuW0Ggj0RUtmK+ut3oTBQQVjbfQXvwZUZeVLmfCKbtBtbqwmVMpp9920+Wj7fkZzVQQLgcdiNQ5ADC6S165W5eJp4i6Vt9I8ztA4i2Wkm0P9D/j6Qr4HJg47ZmUsmd3ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLozePUcLT1h6IztWZZdHv9w/2GYs1OFru384ZBrWLI=;
 b=T0uP5OSBu3dFqSITvSajUaMXY+obhan/rzzTzi4yGqnJ0eFWQpPAwDapjHowzAviks0t5sqgZtU/CiGCjsaDXFTpk+jabZ29LEeW+0nC9V1m+l2RRdFgyeoO0iHEhrSxS5qwnMiTnM1aIEHFVQqFHPu2Pg0MgtkG4i0FfL8oCawahIsCav5S3U9L1RKE3yZlHJtv81tpXDRrClI+4N1KdX/yolAGEl+kRQOR0MkbGdaaS4g/GEJG0E3jVULiffRcH2Th9xLRPOAo/7u3I1cDIXjO5XRTrXbbxWoR0ZLjnXAxIfFdeJV9woLqsVzLl7QsHKe4h/ZfdiXb6IB5bODwJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLozePUcLT1h6IztWZZdHv9w/2GYs1OFru384ZBrWLI=;
 b=mEDKMWZ7S2w8Hh3VgSbpwNQI5Rm8CO33G+nrAcaEIucAoDPJ7/8hMzTgZLOAy8Q15NVa2pLpJOCFQO+F6hVY/54OsHIBMFG+xwObYbxN7HKI1B6CDPrFxbNwr+NEfTilZjyIzvnO6q17eWadZpobrTMQ7K5yV+hB7BA8GBP8q74=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 SJ0PR10MB4735.namprd10.prod.outlook.com (2603:10b6:a03:2d1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.19; Tue, 1 Feb 2022 17:14:36 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:14:36 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v3 0/2] xfs: add error tags for log attribute replay test
Date:   Tue,  1 Feb 2022 17:14:28 +0000
Message-Id: <20220201171430.22586-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:208:32a::24) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e8fd897-dba3-40be-4c68-08d9e5a65286
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4735:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4735D4E7E081A8E94B99004E89269@SJ0PR10MB4735.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rmvCC16MSNJZOkJHDiOEOxMo2Vr8TByXyzsiwDJfusVhj4S4RGYtjJdG7Nq/ahC8IbguRCwsL3u/OYNE+iRfH6soY8DXMBijKXufSktQ9NgeUc79WIBT3dMLxAoiocUuyy+X1O+dDPBN5BcKIlDgNlU3pe32TZ6dy5I9WooUAwFJwhxUNG4DcdLK33qkVgJRd2bSS0VVvL13HGTa1JjOZbQeOmduqezEE7IouRt8k/xoE1ShK+92/DyxFXI7JrWE0vmd0gugPs04AZz7E85ju0Qyny4LBjFe8KYMLEfI2Ev4XYuVMJ3oCLYArAYmWUrLZE538EZmhPvq+riSauDjgfCgm2BMqVZtL2dCxPzE6+AHoLiBCrcISJHXENLOaMevsk/hV1yzqJo52WSeMcC8148R+aOPgKCiWbQY/TaOLeBam9idpTjJHYLD3wJZOHMGrvChgMOOlJVuA6da7n1kMWb7765PDcUmxZsyHz80DH+p7h72+6UjZMxpH/nJxpPXIC/ClWOcUKYs3Bq4U+X3KMhMoT0zXLlg4ZiK5QQTLyYewcw7Pvdk6/B2a/dqASLBWD2UN1LWtHLjD5Ra61+xwNA4kPEuz4aT54flJIYs+fiPPTbdt6rRG0R2CriYt6HqmYQERtyZAdGS8UEct9lAmUp9BxvFqXwN/avK1j2wQuP5ipj3LEWfI4CEuIwlm/Gh4e7AusHBNERn8j4/V8i9TgXxdrnDx9B7uSwYz7nCP6sFkOh7x+IHgXQqGAd2RRsEnsFiI31hB9ircSr6f+przNSo6Twpl2RyruxH6oST4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(66556008)(38350700002)(38100700002)(186003)(508600001)(36756003)(316002)(6916009)(83380400001)(26005)(2616005)(1076003)(4744005)(86362001)(8676002)(8936002)(966005)(5660300002)(44832011)(6512007)(6666004)(6486002)(52116002)(6506007)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZERWWTAzdHlxUDcwWWkzRktHS1I2V2pxaHYzNWVSMW5WY0FkYTZHSU1Td0xh?=
 =?utf-8?B?RVhLUWU4WEVHaUl6RGJiSWN5cE8xZjhJVS8zdURPaGlFSmY1RkxHUHlqVzFz?=
 =?utf-8?B?K3gxa1FjWG5KdmNkazVUZk1XWFhjYW1HYkI5MWVhZWdxNldTVWVTdndZRnhU?=
 =?utf-8?B?UVhzMHRiNzJwZThLVUMzRS9nRzlrQ3NaWGY1VUpLTW1CRkNwV21EMEdydzRo?=
 =?utf-8?B?eVJ0bFVsRncybTFmL3dEdTJZUFNPc05RcVNyODFUVFRpd0gyNkhwYzNaVmtD?=
 =?utf-8?B?bFRyeVA1TS9leFQ4VjJWK3NWdkVFQ3dKYlpRQXU0TDZIdURkczZNTmFjRUd0?=
 =?utf-8?B?WlRRZjVkb28rNmxjSVdUOW5UdTZuTEV4cXR5cm13RnBIOUpSaWNkd1NLakFS?=
 =?utf-8?B?UVkxMXBINDJDVmRieVhOazN5K29uTVFKdTlKMTFNNVE5WTl3bDR6TkQ1MFN3?=
 =?utf-8?B?QTgzSFdFRCtsNVpXMDQ1QlFyR3U5c2lVKzdDUm14WERxTEVINzIxZmNtRENu?=
 =?utf-8?B?QkFmMkpyTyt1OVppZU1GbXg5ZG4rWVBPMnFWZmhzVE4wR3ZYOUYrOW1EV0RE?=
 =?utf-8?B?VjM5OFRCUStQaVl2ejZ4ci9vQ3M4T0JsSEZ0b3Zaa2kxUU9ydHpiUERVWE1r?=
 =?utf-8?B?QlV5bDgwVzI1ajBLbkI2ZXJuZHZQK21JR2J6blV4UnBlK2Z5bko1aW9sOTRF?=
 =?utf-8?B?UEdNNjFGd2hxTkpLNWxQRGNEbnMxczVJYU1saEIzblcyYlNhMkMwSzc2d29P?=
 =?utf-8?B?WHdOYjZ1dm1HR1ZITzNRVmttUVRwU2cvdW1jaEQxRDF6d3kwb2IvZFFWeEhT?=
 =?utf-8?B?V0NhclJmMDVTVElmN3JtdWZac3B2SnFEdTROTmF2dzd0UFMwdjZ5TFFhb2Ix?=
 =?utf-8?B?eUh6V1BEaFhqTmVRK0MvTjM3ejlNWjRPQTBGRWNFVURFUzYwa05aUThGWnFk?=
 =?utf-8?B?Q1h4NFhjRG1JWlk3MERwb3pSZHMrS0hEQnBrWm5xSW1EQUs1THgxalB1eFJx?=
 =?utf-8?B?aS9BYTA1azJMRk1sZVVmMUhxdjFZZ1VpcC8yK3hEZlFTM3I3WXQ2K2RVSUIv?=
 =?utf-8?B?ODZDWEwreDhDRVFXenRTWHJHOXlZOXhrTysvb0dPOU96Y0xGZ01oc0ZTZ2sx?=
 =?utf-8?B?eGk0cE4yc0NKUW5ZcHNvaHhONWFvR0JEcFlIN3htc2xURzRlZmF2VUZVNndT?=
 =?utf-8?B?TXBpMEx5SlNhcURhWjVHdGVCQ3VYN3Zza1VJUC9mN3BPS1ZUeXhidDZjQ3RZ?=
 =?utf-8?B?Y2NPQ2t5eEJpZWpBWFRHdzYxLytTMEtPTGJiU0xvZ3FUMDd2aXFSOElEUlhM?=
 =?utf-8?B?N1IyUzFrQy9ZSmxJMkJQNUFjNmFoUU1PVXJtVS80R3RtMzk4akxzQ1BmME5S?=
 =?utf-8?B?WGtsMnJnaGd0N1NLcHFDV3hFZGR6c1pHRlFPNmdrNFMxT3E0NGQ2RGh3bVFC?=
 =?utf-8?B?aDhwai9qYlNiUGNsQ0x0anlBMFZ5UURCa01vajh1VnZEY2w4bnBGSE1mNG1U?=
 =?utf-8?B?anlnTzNvZkNxMWx5TGRzaGNNdFY0a1FyRzB0alQ5YnEybm1kbUhMbjFiMHpz?=
 =?utf-8?B?azR3a21CZThpV2lQcXkyN2RydEVjSWJzVGlyUzZWVWFRbjJhbmlZUTJYS2tO?=
 =?utf-8?B?MkJoSE5TM2tUNUxTQlVIalUweEdFVU1CNG1XeFp6T0ZQbmdVbHRmakJ6eExB?=
 =?utf-8?B?WDV3VmhjS3l1RXVjVTZBM3dXdFhyaHJYbHlqamtidmJDelpkMnYvUzRaa0FL?=
 =?utf-8?B?SnRia1lWN2hkbE9DaW4wNWJKVzg0N3VhV1VOWTdma0V6SVI0TTEyVFBYUTQ1?=
 =?utf-8?B?VVU1dExtSWNEMkVJR0NMSXVYRm9IWFB2YWpjaytHME1UM1cyTitXcHRjYSt2?=
 =?utf-8?B?QnQwUHVaU3ZGUkpEb0ppVEZVN0dqWU5QOTh2SlgxbkNVMGpiSlBjZTFTUGF4?=
 =?utf-8?B?dmd4UGd1V3pRYVZXMjFFRUJGWS9peWZiTk45akFhTFF0SnZ6cThUV0o2T2JL?=
 =?utf-8?B?bkhFSTRUbFlxYjgwRlNvK1pyektEWTRVR1NDbTdqM0pjUU5vdkE5ZzBTeW1V?=
 =?utf-8?B?UmZ0NkpJVWRBaU1rWjlFdU4vOFB0Qk9ic3NoZStuMWRBdUdwOW5ORXYvQm01?=
 =?utf-8?B?Q0pyZDg1VkYxb3lQbzVzOVZrVHZBajFlT3dyaldFTVBNYlpKSmQvU1FhZXFw?=
 =?utf-8?B?WmJ6bEo1SUpyZlF3dkJ4enphUkt3Wk5OcC9RTWN3OWlvOGpzMWx2YTYvUGVJ?=
 =?utf-8?B?cmtrY2Y1b1EvWkVtYnhBVkRuR1h3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e8fd897-dba3-40be-4c68-08d9e5a65286
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:14:36.3375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3R/pRvz0woGE40oXCsn0N2nxoyY9GxXjm0gU9vz95xRmroyx34C6YyK8t2nEq8lXdGRb9QcRmQuVCeApN104e4ajHD+nAJ406hnh49EXbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4735
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010096
X-Proofpoint-ORIG-GUID: MVAb2MI7dU6O2_t8ge93mk913PUWeGVa
X-Proofpoint-GUID: MVAb2MI7dU6O2_t8ge93mk913PUWeGVa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the corresponding kernel changes for the new log attribute replay
test. These are built on top of Allison’s logged attribute patch sets, which
can be viewed here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v26_extended

This set adds the new error tags da_leaf_split and larp_leaf_to_node,
which are used to inject errors in the tests. 

v2->v3:
Rename larp_leaf_split to da_leaf_split

Suggestions and feedback are appreciated!

Catherine

Catherine Hoang (2):
  xfs: add leaf split error tag
  xfs: add leaf to node error tag

 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_da_btree.c  | 4 ++++
 fs/xfs/libxfs/xfs_errortag.h  | 6 +++++-
 fs/xfs/xfs_error.c            | 6 ++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

-- 
2.25.1

