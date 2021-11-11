Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4ACC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2CA360F26
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhKKAUN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:20:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32260 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230210AbhKKAUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:20:13 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AB0ALGa032539
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=r+3K3jCEz3SStteQGIQ6n//lbOCYFqUA6YEMDn/sK7c=;
 b=zHJsugcx418ilxwqRa9qETADXOhI0PSHiFS6GZCGRGC6RwiQyFV3+4054VynaIJMxekl
 tSn7MFxz6UrXBhn+JC/4zGDgKEH1l2ouS/nBvKTARy5fTS8HrW/lQxpbYIPFoYssKlC3
 m7CgoT69feK7hO0f2Bg2ZHZsN3xMRDrOZ+Hj92cItP29lygsbjKB2GdZsrrtjN/mgwtl
 33cIU2nIU0g56Wgtzk8jWrLcRKe1rlB6PIAl+PMxcYy3W/sHV/mGt41EpewlfxcwQk6c
 /heRqt/BEulquIcHPFnIO5jBkU1EXIur6GhCyBNmzH35GVibBCEGnKS/XDxEw2JNS83J vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c82vgfdn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB0ALjM178474
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3c5hh638b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgoFQeVgwNG+VTvIaZGXJlljasYyRQJy7MfD1HUN9K52sGmc+7w0cnCGdGmTCkQP7UrieQ6fb7SQMYed8+vgYj9gP4QDEzYdLXo/m5HhXs0i0DzQXPY59EY0NiLeQLZgmCQi2sG2B4lkZLEOrTbZMPuIjLDqcI7EoB/NyhdFPKo0LbRuU4h+MFLi6luGBL6K+Y0yG3+SeHjXLM8dGH901Gwo4M1idz2OjLSp9xi+aeaZrp92I9MguiyQIzeWN8X5lItv9gvbsAtG+uqrq2Rdf2U/BKpvwwrmey0myRA5jrFiL1GPOeC6ho2vNLFs9RboZVpBW07ocoC686drwzTaRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+3K3jCEz3SStteQGIQ6n//lbOCYFqUA6YEMDn/sK7c=;
 b=QxK8sLRGcebrgA+pjgE1u39gqO6+EfbT9HIV4QI1fmZDPeRHjVzr5R3ftJtHZgBvH488n+6trryQkjr5r3mVcFga9nQWfVaKD6O7o5jOLDsxIIDctOFaKcgDPK8rbbgN12S1sgewzygJuR0ncN3ZVxqgYDQWmZONeDPcc8JZIwZ8e4asEc8kpLU6jkUo2LCiFIMhZjrB3tvO0S+dyc62unydLRPqqHaoJ7/8a5LfylLxFQvThqCd9dJHuTWKRA3NAfQ61NrvUEU6hkIN8LPMjC/kWgGiVMiT9HGdV0YMC9nOoIY//7dCGqvelh0NvNP7jCG2Stn5iw9ZfJIl1Zb26A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+3K3jCEz3SStteQGIQ6n//lbOCYFqUA6YEMDn/sK7c=;
 b=QJxE33CPUAvt2bt3m2gtp8dVsN5xLLmT69mtl+DDrSafHa/f6P8LLJx+sAKZd/Td/WZkE5YDxPNDDeXO2AOsK760MprnspOrtjMwpBk/+w71gJ95x3sEuBdCjdG4SVld/m5elja2b1TIqEoHZVymcGmqhXyHOL9R2dBIS3DLY3E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2889.namprd10.prod.outlook.com (2603:10b6:5:64::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 11 Nov 2021 00:17:22 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:17:22 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/2] xfs: add error tags for log attribute replay test
Date:   Thu, 11 Nov 2021 00:17:14 +0000
Message-Id: <20211111001716.77336-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:91::39) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL0PR05CA0029.namprd05.prod.outlook.com (2603:10b6:208:91::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.7 via Frontend Transport; Thu, 11 Nov 2021 00:17:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1642d15-f922-481a-ceab-08d9a4a8a169
X-MS-TrafficTypeDiagnostic: DM6PR10MB2889:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2889F08084AF60DF1F0DFBFF89949@DM6PR10MB2889.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbtOXYkTTW70qmGpqi7fkGBarlyABe67gR6CE01ZjHHMRYFmZNa7vGW5W2uZWvhN3QqERtsw6qoayovuuXe2iwwEs6WY97CmWMuH2gPuE214N6IAKt6PtbyJupDhCgW1tFCk/j0hMeVj3ly8aqEu19WJSrTEPlI1QLTdKLblWqezcq39NEvkiPZ8Y9xku2is8E/xvmhsq8p7wyPDBWJ5ltCCLYfnwnqS0xFRXfoJEpemqE7fKD2cQe3U+RUlZ1YnQuncTyrjax5CMvMdDVesrv4YuoDxHbjbY32vYBYjW+dbGuUudYTtw8WEyXfBVtmy6p66HR0fpjHKaBSviWiiukeNz8zsxoH3GJromYZBw1D4Gur/usztZbrm3Ma1dFP/6r89/21Chkn1ZWcA+LYOTH5HGMo9gIZFe4sIDm6MGwq3FIRmOrG3KXvgynfBrpL0E2t7Kp8IMyM8ioXkmxcjxQiqvzy9s6vGKwlJtDZgxuXtAi4valU4Rv00BvjP+ta0VH1/5jB3GklJaP7ORfyQXF/7lwvSqjT7StbKi6AtJBDMBgXHkBHG5Gb3MrvS5TRJTtbHsn+Gm+teNVnqAmSobJFRXKGNqgVDM9BMDA3NtnEI/Q9nWvVvtmQAynR/6xb4J8DNlBTGuPBd+fCG3aYl+UPl68/M3hjUvunhZ5v95KPJjYlX+2gWQXoK7CKYmKu89W2aG1zBX4PMpoxPIhsecxErnWXcYPlBoJetyPVDpiglqxIFr/bcar2pFWw6YDDcBvX3/kFYW5vV2OTYtLLhwcfkvYNwEeA1omlz7ngLV5Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(66476007)(8676002)(6486002)(36756003)(66946007)(1076003)(966005)(66556008)(6512007)(4744005)(5660300002)(186003)(38100700002)(38350700002)(86362001)(508600001)(2906002)(52116002)(6916009)(6506007)(956004)(44832011)(316002)(6666004)(8936002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWc0SzhIVC9RRndNck0zR21iSGhPOWpjdEc2WlRteGZOSDhkSzVTQlBDbVJB?=
 =?utf-8?B?U0NHSFBydVpXTmNoRlpVcjE3UjRmaEJ6cEZQZk9tUnBFa3Btc2puVVRQcXJX?=
 =?utf-8?B?dit6clk5SnMzOXNmd2lYWk5uOHBUc1RQcUt3cUR2dThGT2NCd2ZHRzRpejdG?=
 =?utf-8?B?bWh0QjBqTmFlcS81bFByZEdWblFCcHZNdU5BZGgvSDJlQWxjMCtVVWVDeGg0?=
 =?utf-8?B?UkwzaFBQekpxZVBKVDlzQW1LSFlNMVZYTjJhcW9TQUttRkxuZytodlFpN2lG?=
 =?utf-8?B?ODRTb3R5cVpoamdJZTdQWTdWNzhLUnNONmpnbkRweDB3T3pjdDYvbjJaL3RP?=
 =?utf-8?B?VjlaY3ZXSEQrY21Bd1I1TFp1S0l6M0s4RkFUNWJSYWRJQmgwQ3RDTnd6dG8w?=
 =?utf-8?B?VTJiRWdscW81dTkwbmRHRkhuM2Z4S3lWRlBxNEs5Ui8vblBzckRMQzd6c2pX?=
 =?utf-8?B?RE82ZFdNNk1CWlBMczFzRDMyNEdTZmhaQ1B0Wld0RXgyNGtxVnZCY3JoL25m?=
 =?utf-8?B?cFdXUHBhZ3d1bjNMR0tzRXRDMVB2WkNlSlVwKytZQ2VwTlJYNk41TVFSZHFE?=
 =?utf-8?B?Ykx0a0ZqcHlDblRra2x5VnVhQ21RQU1TejIzUCtBWUsySVFtU1JkWUQ3SzNG?=
 =?utf-8?B?MjZxTFpIdDg2a2tOSnFpc2VjekRsdjRyV3VhdFowZDB4dGRBVEdTdzZqc0dF?=
 =?utf-8?B?WHUrNEovVHoxRHpMUnFrOUEzbmYybkpZNnBnU1lUZDhMaFVuRVZhcEpRaDdP?=
 =?utf-8?B?aTcyZDNSZWhFMTd6WTlGd0RvYzVlZm1CcCtFVzN5Qlk5V0k2WDdnaVRnQ1Vo?=
 =?utf-8?B?M1M0K3RoSzhpQmRtVVE3Z3F5TFU4V1hEdkhBaFUwQkE1clVLajdSdi9LQVZD?=
 =?utf-8?B?RVBsQStlNjBQZ0s2ZTNLUXM4OGc5cmorQlZyMlJhdUlNM1ljdXhtOVN2dFBH?=
 =?utf-8?B?SXN5TVB2ZGd6MUUydnY5cmhycDloMytFMkxWMVl1dFRiR2FEaHMvK1E4SCsz?=
 =?utf-8?B?S0F3ZkZwYkNjbkFNOFRJZ3dvWjdtSzgrVWVXc2orVlNUVTZSQk11YWR6VVg0?=
 =?utf-8?B?dDlXZEVManM1SWdUK3NnZ3JMQ0hGYXNwREpydjZuNnRXa2wyRERWMXhZUHRu?=
 =?utf-8?B?UnJDL1FNNHpsTnJkMHNzK3p5S0Q1YUJaYXhPUUNCcVBsRkUrSUlXSURvb212?=
 =?utf-8?B?ak5PSmdYY1p4WTN1VHFIOHdudU5uZ2psUkJmczJabkk5V1d6MHdha0psVjhm?=
 =?utf-8?B?SDIzb1ZXTFNKb2FUNHZqT2hZTFN3UFpVQWQxaWVETTZpcEJ6SlRha2x4dUVh?=
 =?utf-8?B?OVRQRXJPSHl2a0l1QWY1NHc4aWFLRkVuZ3ZYUU1BZC8wQVUwNDlJQmpiRjNH?=
 =?utf-8?B?b3NmNWJWZTBzbEJvY2tQdjRzNVVxYnZWczdtKy9lY1B6TlA4a0xlWFJqeXMx?=
 =?utf-8?B?Tk9hUEtXaDZUTG44ZmYvc3VqQjhlRzNLY3NKNCtxM09Pb2phdjNzMlk3a3VR?=
 =?utf-8?B?cXpaSjBNMXRVRHFjMmdHckJxeEprTXoyOHdyZTFyYkYvcXhKRGxMZm1ROVVB?=
 =?utf-8?B?V3lWd09GU2tBZ21DRURXSDdRK2U1MjViU3dRWnBobUxhMzVlT2JCOFRyRU8x?=
 =?utf-8?B?dyttMGtPT0s5bHJBUHZhZHVld0R6U2NubGtYYVpMWU00M3laT0FzcUtWTTdt?=
 =?utf-8?B?M2MwN3dTM2o4WDlXbVUyMEhLem1NTk04UU4yNFYwTVRCcXdNY2tnZERKR2tz?=
 =?utf-8?B?WXJxVjJMU2VRcHdrZUNuMWRWbHQvajQ2K3oxam1xRVhiNVR0OU5Ka3JWSVBL?=
 =?utf-8?B?ZkJPWVEzZUdrMVVJbGtxRXBCSzdmaXczZWZaRnNjT1dscGhMQlpNYitqV3BC?=
 =?utf-8?B?OWEvUnAxMXhsckRVV3lMU1hqdFdFN0UzVDJyaXlLdDY0RnRKNmpHNnlzbi9w?=
 =?utf-8?B?TCs4aWYySzA0T3I2WktFTy9TaWladWVpMUR4T3A3bHpwTHVRdXdoT3psL1B5?=
 =?utf-8?B?REsvOE5EWjB4TCt0ckQ2WnlIeUJsM2NhZElDeDBYVXpZQXBqQTNad1hPZXdV?=
 =?utf-8?B?MWxjWUpjb3BzTzFqeDBSdGpNRFZCYVUwbk9BTTdTNERVQVpjUVEySEhsQjhD?=
 =?utf-8?B?V25NeGRDQzF0WE8yQktzUS80SEJBQ2NCSHRwM1VoTnVQS0xibzFZK1pGaHlz?=
 =?utf-8?B?RFdtSzJidzlicmZSeFFZTUpPdmVIWU5qcUJMb0pIT0lRem5pTzFJczA4S1JS?=
 =?utf-8?B?RCtpWTdmakxxbzRXbFI4M1VrUzNnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1642d15-f922-481a-ceab-08d9a4a8a169
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:17:22.0581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xb4f9zDiZIxOEWefpigtbxzrcKWxT6iq1wCOGYZLPcs1wZNT9u69PpDsSoBKC2GqGGaTk0UqMD7ye5gdNc57IQj7gowK6y1CIbqBrrw4HYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2889
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100117
X-Proofpoint-ORIG-GUID: FAn3YrbD4FespiUNHnLWcFQtIdMqRokU
X-Proofpoint-GUID: FAn3YrbD4FespiUNHnLWcFQtIdMqRokU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the corresponding kernel changes for the new log attribute replay
test. These are built on top of Allison’s logged attribute patch sets, which
can be viewed here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v25_extended

This set adds the new error tags leaf_split and leaf_to_node, which are used
to inject errors in the tests. 

Suggestions and feedback are appreciated!

Catherine

Catherine Hoang (2):
  xfs: add leaf split error tag
  xfs: add leaf to node error tag

 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_da_btree.c  | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 6 +++++-
 fs/xfs/xfs_error.c            | 6 ++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

-- 
2.25.1

