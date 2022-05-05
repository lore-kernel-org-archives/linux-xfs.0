Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221FBC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 01:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiEEBWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 21:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbiEEBWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 21:22:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAF054F8F
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 18:18:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244LGQOx026110
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=a7WNgNfdbnKrn/XtAA960ubHvpdTpQLXEbQr7+tZXko=;
 b=wG/by0heT3nA5U9JydeJNp3XSLLOhKkL+Jqz7zqVPZMp6wSfdD5MHqDOc5h8DQ94ETZm
 ZkVNF2+6MtqaG9C2DlVS+2U4RbHVaZVAqf/8jZ0UsA97hv2LO9UdpaPw8XVdXGeipqnd
 hRFrZIdBRLN3GsZaPY2RSo0r6h8McyIs5EFwvyq6150aILsr2SKl0c4EscT/4A1nzF7U
 UAsDAAawCFnH3zwUXOJasQ8XSYIZ5IfueahCAQro8KmE2Cwr+LBr5AA6BjsPkH3cTsHh
 f66nwXMkYlv4rcOU428HvzKjO8yzaN/EaGfdIa4Wzsc9zzwGrJz/N6kaSeseYoxs0Nxe 5A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhc9uv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2451AgXP006894
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus8xd1t6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRgD2xr/8W0giXgcBy+OYr++XQKdEg/wKasGxDzoviThH48DHbEQaYtk1jFeM95qWo94j5wK3BREfREwb8pb9yMtb0bg51YA/ct+a7AwGgGa0vvHMrZScDyw0bsA42S61iWnp4ai08gE1VmugOjNT1jUpxx2bowyNRXoY15WGDsRW1TuT9kjCOXwVIOorbcsqgafvvxhHhUXiF1/dfgVDxO4UJLSK7gmG4ZaPSQGtUY3b1X/iXsuyPb9/OI/ns6EsoMJ0XgmIH+CPWqm9knF67Xxyd0Warq7lU5+TroJhxVMwZTuRymA6waj4fLumG/2vxtCz7XI1NQkXj26Mk/P9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7WNgNfdbnKrn/XtAA960ubHvpdTpQLXEbQr7+tZXko=;
 b=KPHJE9tPFMz9/7Z/WKgQexu7jOJ8jc9rem5cw7To6/uJOXpMO05QPRtwqDYO8F4xdnf7VLBecD+/ZA3Uj1F02lLpU12R1jP5UDxzabMN0z8aIa6RpFT6FDL6ceAgZbs36QFJGwVjD7XEw4ahnBtoRQ2PQ9EXbLsjwpGCFhKhaNRWjAFh2m6GAxNEAHX8MphBS1RtSmJS/3eNJgNH+FFJ+RfJyiQfPhtYAlh7l9c08CZsK8hWKC6vS+lD8V9WMZTa8GN3rwsbG02u3fSTEOZR/8mbzIX/wKIEtC5NptNddnCjhVn4MvkJ/Dg5GbPsUFgONalqF++zI0uuZKetkMPbJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7WNgNfdbnKrn/XtAA960ubHvpdTpQLXEbQr7+tZXko=;
 b=hnaFzpzl2RIvWxw4gzaTPGNpwEXzF0lmISgJY5s1YbSpV3NDnZONVrfStfG8YpZTZffSlKkRF6C+2p2i5yOGCXbwvvSQEzg3upN6pU/F8mDAp9QoNqap39bW2cUzci/rLjBz8x92AZLgrgDQFYuwaMUd4yw3wCK7lMXATj7IUxA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB3193.namprd10.prod.outlook.com (2603:10b6:5:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 01:18:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 01:18:23 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/3] xfs: remove quota warning limit from struct xfs_quota_limits
Date:   Wed,  4 May 2022 18:18:13 -0700
Message-Id: <20220505011815.20075-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220505011815.20075-1-catherine.hoang@oracle.com>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:a03:333::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8ed4ce9-c12b-4d91-bea2-08da2e35262f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3193:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB31934051B345CD23440E657D89C29@DM6PR10MB3193.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: noZ4lD4IlXCUnQFdt/CgefrsNCso1V61EeFLZj+zpcyzPH69O4ObynEbH6qQYvhXOI7v+Qinj+nfE5xybKCvL007zVpTSuga6/uDyUL4aCYRnG70sjV0J+Eh0G7eZRATWxigBZzrWrPyGdjyeKb45/76D4oPI/F9WqoJu9NtIGofpn8IH1tNPlg9ODpIAeVNSZVMOtjkMGzBwprnvttPWcjcZ+fVlQJxUElsDogCTNBRKWLQENNetOxYye8gmPR5Uz4qGZ0KgI1yfszivaRdMMtvmNlkmFcOYUK94Wo+cJ0icvurKtdgXinbpBwSbb/SdeFG00GsNBDrV6HD4umU9zOI/Bo43f6g4vY8eza8MFNrT4MdmMfd02A1Mcc6eQhFbbCC9hIKF79VBWHqfempE/IOU6uag8e0bnsVOx6f63Gn4ci8+YHzEfY0wtyqgfHdqkIF2ZRrb+z4B9gcsF9jUAw3EzyKV9ig1wY8X1h1EeN0I5AlKfi/Mzn3ZFke/v0SzwLpfqvILTqPP0WiDvB91K5y5wi5/yANXGW4kR6TqcAgSqSh+nlLkNN7avGYDOWs1NeW1IvGATT1dC3FdFBO3392eYDWu4zkqqpeoOajpAIgnxV/Nfi9jiUNTr3NOYmAfePUFV3mtM31s8BCNesfMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(6666004)(44832011)(2906002)(38100700002)(86362001)(52116002)(6506007)(508600001)(316002)(5660300002)(83380400001)(1076003)(15650500001)(6486002)(2616005)(36756003)(66946007)(66556008)(66476007)(8936002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFdNemhqY3FkSmc4QzJJSXhlK2FVTWlGRmFBUzYydTZHVHc1MUZicE10ZTNE?=
 =?utf-8?B?Z2Y4ZG1nZjhSdVdEWjJ2VHk2Z2s1OXd2c1p4V2tCSTZaTWEwQURRanNPb1hz?=
 =?utf-8?B?TitGU3RXR0hSR2h5UjVkTHpob28yZmJqNGpEWXFOamN1cEVaR1dhdGVUUmhT?=
 =?utf-8?B?RDBwWXdYTXlXMW9pWTZDWkhoNlhmdFJTT0RGdHN3aEhKa3EvNkUrZThVcnpu?=
 =?utf-8?B?YWp3TEMzd1pjTjd6dmwwMC9GQUhraVBDYXdUZUdnR29PaEErejFHSlZFRUlR?=
 =?utf-8?B?SFh5Y2wzL2I1cnp2SDJGTjZ6RDNnaW1TT3YrVERMY0k5TkdDWGcxanI0R1p4?=
 =?utf-8?B?eE9yNHhsOStmaVovcFRVMHVMbjFkSUZXTW5qdGhIeUN2WEpQaHZiT21zL1ZS?=
 =?utf-8?B?dkVKek14eS9UWnBWam8zR1NTZ0R0QTJlZXlGdzZVVjMvMWZLVlBQd0dQRGFX?=
 =?utf-8?B?V3VSUGtKZDZORWp5a2ZiTEw4NkY1TGJjN3pHT2ZPK1FySy9lZ01IYjhXaERU?=
 =?utf-8?B?aVZyS0FKR1Boc0RwSGtZT1drSUdhbFlBa1Q4REJ4RGVwOEt0V1VrRnk4L0Ju?=
 =?utf-8?B?SWJVT25lZFdIT2t1YjM0MTk3amEyYkREU3pNKzNGSG1ZMld5OGxLcEpQU2pG?=
 =?utf-8?B?dW5kcGlqRDkrM0ltWGo5ayszczZTV2JMVWwwdEFtSDhtUU8xSDB1R3lCWVpl?=
 =?utf-8?B?SEl2ODNwVzFMYU9KWUY4ZVhHdXVUNEtrVUNUc0Jrczh1UjZyY2E3b1pQVDdy?=
 =?utf-8?B?YlVyalBLODd0TkdacEJXa0RVd0FZYzUwcFdXZkl2YitGOUoyNjMvUVdld25q?=
 =?utf-8?B?bnJJMHVNdGkrQVZLTTJsbXluMXR3YkY2L3BtaWJ1QjFvdXJhNWczQ2NPYzBS?=
 =?utf-8?B?TFBIN0ZXQlJXWWVGOCtPV1M5a2QrTkdiQmZ0WndRQTNuaTlSc2ZVMVhpcXlm?=
 =?utf-8?B?L0w5czZpVysvZzdYaXJPaVBvNnhUM2NYYlpST3d1WlM0Z3grZXVramVraWlp?=
 =?utf-8?B?NWlaUWo1VHE0M0FVd2IxU01tOEpEazc3TW9qamFORHZkVTlHWGhhUzlCeUpB?=
 =?utf-8?B?WVdweWlEQ2JsYXl4R3FFTmxnQUlHZzA3ZnNENkl5Zno0dWFqSk50ZEJra2Q0?=
 =?utf-8?B?WnNHSFBZT2xOV09pSEszak85NzNSZFhRa0ZTYUxDTnNibmp6VVZUcjJ5aEFh?=
 =?utf-8?B?Ukt6cVQ3YUZUVisrOWJSdUxYb202VTUxY01RN3lyUTI2NC92QytJN2haQi9F?=
 =?utf-8?B?SGRVZXd4V2tvMEdTakdkWmtPcTZFVTd4Z0JlRlRpdXJQOHk4RlFCR1BUcWxx?=
 =?utf-8?B?Qm5RVnMvazU0R21EcGZwU3Q3bGU5dXUvVGVtTHE1d1hWL3lMaytiNERoSVZa?=
 =?utf-8?B?cTM5SFY2bDlPc2VibGNzVWRkMllKVmZxWUlEQ0FGQkRPYmNoK3BzQnNGNW9V?=
 =?utf-8?B?dlhyR2xaNDZ4VmVaRHAvK3hUQm0xaDM1MHRSTitBRFpaSnJPUThJUGZiN3BE?=
 =?utf-8?B?Y1VjTEtYTVBKLy9oeHBoWjBBb2RRRlc0SDZQRFZFNm1kc1ZxNEpjV2lianl1?=
 =?utf-8?B?Y3V3eFNLUjBoRCtLK2Uvb3lPai9GTFJJZWt2VHZ1SWIxVlZ5TldHUGwvVTN2?=
 =?utf-8?B?TEYxUEdKMlFqU1NHVHRYZytJaDlqRkdRVzdBVDVyelBjN01Ydjg3aVFpSUhY?=
 =?utf-8?B?eFpES3JwL3lHRmV0VWc3Nkw4c1ZCcmYxM3pJZFlSRGQvdmRyeDgrblpKaHNp?=
 =?utf-8?B?MnVCVFY1eHJwTW5oM3pGL2dTZ28xeUJ0ZzZ5UmRXMUxlUkdGN0FZSHd4RUtw?=
 =?utf-8?B?WEUvNFQrbWt0VDk4NDFSeFZZa1VjT2p2bkVlNG8yRnJiZkh1bm5Tbjk1OEUw?=
 =?utf-8?B?Uy9uaFNsOXVka3N5b1J0QUl3WFV0R2c1TDNmSHdhRHBVdUl0cy9QUFVMTU1D?=
 =?utf-8?B?VXVCTXRNWDlBVFNUbnFEQjZQNklibXhjc1RRc0lPREplTmtRUXVDZXFscEZW?=
 =?utf-8?B?VWIzaG5UVXkxQ3RGenFWdFoxU0tBa2t0T2FaYTZ2eUZ0YnpCa05vTWtrMlgz?=
 =?utf-8?B?UDl0Q0U2OGJkZUNvdEN0YzFXbGt3d2k5ZHFXUEszNThIRndNNlZNdk84Ty9Z?=
 =?utf-8?B?bzV1L05Mem4yUHRESW9iSS9OQ0pPSkdUSUFmK044bjlKR1J4WGEyeE1tRms0?=
 =?utf-8?B?WlBMZ2VCRDhvMTEzTWRIREJ0THlLS1NlclBqNzEyaVFuTWh1MWY3dm4vVk9x?=
 =?utf-8?B?S2VITVNzc2UydFU0NHlHN1V4MXc0N2wyZnJQcjd0UUgxQ1N2Wmg2SjZXMnhC?=
 =?utf-8?B?VWxnVXdFdkltZlloYjlmWmRUUkp0czB0QnBaQldYNWpaMkFjS3lXMkxRVENt?=
 =?utf-8?Q?O1RH1hLLMaqvn2tOjqq/ZQC4LWQYakgkPym3/0aTn7l63?=
X-MS-Exchange-AntiSpam-MessageData-1: +uDKFG7Ok1TUow==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ed4ce9-c12b-4d91-bea2-08da2e35262f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 01:18:23.7354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsa1WdP0E/6vpaM60fGWb25pZy7hL+ORycVTuDU8cku6LAg3AVtBCvKm2PzsgeaQIV44WlRHJdIm1axOLI8vTJvRVlXyCataOcbb+JrIxoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3193
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_06:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050007
X-Proofpoint-GUID: PH1XHUq7pKpdMfkGZWK__yyQwwebSrLj
X-Proofpoint-ORIG-GUID: PH1XHUq7pKpdMfkGZWK__yyQwwebSrLj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Warning limits in xfs quota is an unused feature that is currently
documented as unimplemented, and it is unclear what the intended behavior
of these limits are. Remove the ‘warn’ field from struct xfs_quota_limits
and any other related code.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c          |  9 ---------
 fs/xfs/xfs_qm.h          |  5 -----
 fs/xfs/xfs_qm_syscalls.c | 17 +++--------------
 fs/xfs/xfs_quotaops.c    |  6 +++---
 fs/xfs/xfs_trans_dquot.c |  3 +--
 5 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f165d1a3de1d..8fc813cb6011 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -582,9 +582,6 @@ xfs_qm_init_timelimits(
 	defq->blk.time = XFS_QM_BTIMELIMIT;
 	defq->ino.time = XFS_QM_ITIMELIMIT;
 	defq->rtb.time = XFS_QM_RTBTIMELIMIT;
-	defq->blk.warn = XFS_QM_BWARNLIMIT;
-	defq->ino.warn = XFS_QM_IWARNLIMIT;
-	defq->rtb.warn = XFS_QM_RTBWARNLIMIT;
 
 	/*
 	 * We try to get the limits from the superuser's limits fields.
@@ -608,12 +605,6 @@ xfs_qm_init_timelimits(
 		defq->ino.time = dqp->q_ino.timer;
 	if (dqp->q_rtb.timer)
 		defq->rtb.time = dqp->q_rtb.timer;
-	if (dqp->q_blk.warnings)
-		defq->blk.warn = dqp->q_blk.warnings;
-	if (dqp->q_ino.warnings)
-		defq->ino.warn = dqp->q_ino.warnings;
-	if (dqp->q_rtb.warnings)
-		defq->rtb.warn = dqp->q_rtb.warnings;
 
 	xfs_qm_dqdestroy(dqp);
 }
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 5bb12717ea28..9683f0457d19 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -34,7 +34,6 @@ struct xfs_quota_limits {
 	xfs_qcnt_t		hard;	/* default hard limit */
 	xfs_qcnt_t		soft;	/* default soft limit */
 	time64_t		time;	/* limit for timers */
-	xfs_qwarncnt_t		warn;	/* limit for warnings */
 };
 
 /* Defaults for each quota type: time limits, warn limits, usage limits */
@@ -134,10 +133,6 @@ struct xfs_dquot_acct {
 #define XFS_QM_RTBTIMELIMIT	(7 * 24*60*60)          /* 1 week */
 #define XFS_QM_ITIMELIMIT	(7 * 24*60*60)          /* 1 week */
 
-#define XFS_QM_BWARNLIMIT	5
-#define XFS_QM_IWARNLIMIT	5
-#define XFS_QM_RTBWARNLIMIT	5
-
 extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
 /* quota ops */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7d5a31827681..e7f3ac60ebd9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -250,17 +250,6 @@ xfs_setqlim_limits(
 	return true;
 }
 
-static inline void
-xfs_setqlim_warns(
-	struct xfs_dquot_res	*res,
-	struct xfs_quota_limits	*qlim,
-	int			warns)
-{
-	res->warnings = warns;
-	if (qlim)
-		qlim->warn = warns;
-}
-
 static inline void
 xfs_setqlim_timer(
 	struct xfs_mount	*mp,
@@ -355,7 +344,7 @@ xfs_qm_scall_setqlim(
 	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
 		xfs_dquot_set_prealloc_limits(dqp);
 	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
+		res->warnings = newlim->d_spc_warns;
 	if (newlim->d_fieldmask & QC_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
 
@@ -371,7 +360,7 @@ xfs_qm_scall_setqlim(
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
 	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
+		res->warnings = newlim->d_rt_spc_warns;
 	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
 
@@ -387,7 +376,7 @@ xfs_qm_scall_setqlim(
 
 	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
 	if (newlim->d_fieldmask & QC_INO_WARNS)
-		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
+		res->warnings = newlim->d_ino_warns;
 	if (newlim->d_fieldmask & QC_INO_TIMER)
 		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 07989bd67728..50391730241f 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -40,9 +40,9 @@ xfs_qm_fill_state(
 	tstate->spc_timelimit = (u32)defq->blk.time;
 	tstate->ino_timelimit = (u32)defq->ino.time;
 	tstate->rt_spc_timelimit = (u32)defq->rtb.time;
-	tstate->spc_warnlimit = defq->blk.warn;
-	tstate->ino_warnlimit = defq->ino.warn;
-	tstate->rt_spc_warnlimit = defq->rtb.warn;
+	tstate->spc_warnlimit = 0;
+	tstate->ino_warnlimit = 0;
+	tstate->rt_spc_warnlimit = 0;
 	if (tempqip)
 		xfs_irele(ip);
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ebe2c227eb2f..aa00cf67ad72 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -597,8 +597,7 @@ xfs_dqresv_check(
 	if (softlimit && total_count > softlimit) {
 		time64_t	now = ktime_get_real_seconds();
 
-		if ((res->timer != 0 && now > res->timer) ||
-		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
+		if (res->timer != 0 && now > res->timer) {
 			*fatal = true;
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
-- 
2.27.0

