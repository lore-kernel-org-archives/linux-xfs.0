Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7CAC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiFKJme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiFKJmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228A3CCA
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3C5AP024318
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=0P0zldecsG3JMjgYhwoUPvPxsQ8fei/A0B7D3LRpOUo=;
 b=YE5miFdzWBOfazkJRC+YVGgCq8wu8y3nsB/YYYMe/dNA55iGNKAImZMIvY6vt5vUZ3Hs
 UIZamPtlmuPaIDNEi+SuO4sLlZTQon5V2wxQ3sfDliQl4QPkiv279Jd5Oq1vSeJyqOdK
 YJxQ9enoJKWgG4C4HD5O5gKuMg6TenQoxVPVl2IrdFxfCu7Geu/SAuhNoozlZIR7Ov4u
 q6h7ToHZUZ6El4dYvIaHKUQeeh8CkwWmBwwaNDGRUjoIoL5xmOgTKGH4XCKecVaKI0ZV
 ne42h9EzWm+044Cr6/r1y5mNYX6BNpJqB7vEyJJ/ZjWFZqY99eOg7klqwMzY9mw9v5/h Yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx98am6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQH025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keahEWEj24uke4evzqzZyauIiuVjhAfAf5J2kZvk15z6MszObKVMmtShtvcVf+kq5Fjky1R6ybd82IJEh0kNusSy7YESCAKSjQxGoaoE4RvJQRHAAXtvMXeGJRUzOD2p6+uBeD0L6z8s5+K29p4IhqhoVf2LkowTWVJkL7TuEhCxyIQb4SetP1YcnoGtkPSnybTFss+XHqGFKlxrdC5D6hmiHA38eJOAx+HN6I9WRM/+JdHGTQAbPVSscUKU7LsA1AYquy8gwxtW+nwwWRaVd2DepY9ejuSjoGaNjRddwLJgkfAr5YEMP5NjbOjN2Uhz3D//VyG2fMJl8irfxKxS6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0P0zldecsG3JMjgYhwoUPvPxsQ8fei/A0B7D3LRpOUo=;
 b=kvHrcSucO6CwtYNu5rlBEI7Bc7hwANrr/RPjPlef+PgyaRA1F2AuPOcrg9fWohv/92yk6xa1WKuuKwUWSNaw2wR8ahOPUpTC/foQgxgao2KdyC2SvKGvPXND1vJ/sRsjTfDbwGhIzKn8Wn1s4VWGP/BEYgYGCgIhS1niCIIFEHLcN+Eh4X3W7nxpqerZKa39gvxQFwm3pVhM9XiXdCqwWUbWdVs+snUsoIzuDkgl5xegCVRg0IdilLb7opZFbqfv4uqLkg9oUkozlJXvuqscTciOtvMiMVVMwjRhPfkQTxVAgpfOu3H1FNdGkzrW/04tEXhmCVqQLxkw3TxxB3F2Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0P0zldecsG3JMjgYhwoUPvPxsQ8fei/A0B7D3LRpOUo=;
 b=xWOM4ls90zBoqXZRqwIWrrMDMVOI7CXMMVX59C5XEFyK8FcejQNcZEgWge8zHfblYla0VmcZpbi/UqRPvLV0Ul+A62CFEkaEjh7w/nW2nnFKpSroRJOjNAuvvCf/ln8IYyvJb27fpVQAU8fCCHtonNf3U/QD4v4xUvTjVyodm6g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 16/17] xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
Date:   Sat, 11 Jun 2022 02:41:59 -0700
Message-Id: <20220611094200.129502-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1fa70d9-2ffd-43e8-c1d4-08da4b8ea825
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46063AD4B2A161F09DFBB4C895A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7CR8CSlUnGcwwr0jTpEdmz8TfyonxJuWraSeVzdUrBpV056hSchMQjfGdbXvBUyumw2+faQLWtWFjhvt/FUGIGCFquOdVoBNwLGllTNcC6qLzo0SUtRImOpVf0lfCfEW7fO0LWg6NtCAXdi+gAkxIkz41n1tTZHRZ2WC7brWuxJVxDGOyvzEOtAGUKU+MFwZt+kJVtILRZRVlRvhNQqrw7aQoaG1i2gKd3xZ9L09vikMaLywU7n/OG4j+95gUV0bLEv3cnQTUCx3//kl1UkG9tqXC3wsC1UiTRmz4JxZ8dctU8M7GygbR1GUplLqV4GvamU5JAYYmPKJI93MunACRv0UsaHcJObE5uqSouQr8+25s1Z8RrAupHp7iAlI6HkhrqQB1fcAPKVdfTQQzM50P8I11ihOjdhO9LWhtBstPBOW/zQwD2U1+xs3TyUG621KrezEFO2BnYbXPW0519Est3mlkyBvlJRPoOMR7bl5CEQrwZjrvTTX5U0cV85WgMA3BWrZPG62Hgp8yiksjVrWuM1yprDHhIOi7euB+9UOksClctQgF5Hg04Lx108RYcIjtHNpix9e4KWMH26Ey3J3/tHzpecLvElG6qy+TJlehXiaafomTzOg282qYhcRgJPe+JUxF9Lo36PSca/WWiNgCPjqu2osnyNzpSQ7n7CaBWKF+/AKlWFf/M7dM8vsvBYbSeHbIbBv62+aX6HDnfQipQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(4744005)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BodboZEC/RtMHh9LlV9Tv4UYezT0xlg1YMdLEl3cdehQaAJ75q+jriGCUZcQ?=
 =?us-ascii?Q?KzLdlyQNENG5icKa64LVHVcF1g7phcFZYLUCSmVpONgZq7sk2EECI35q/0w1?=
 =?us-ascii?Q?uIX1uzOSHIQ3uJUX1xTqtwGj8Jd5+D0UEFweraWz11Ym+1l66I+aA0VbB64l?=
 =?us-ascii?Q?CtzNf0OUWvopuSLnsWtjzyp8+AqbdQvplW7E6QoXWnVvkPWkXr2VZpsozlGE?=
 =?us-ascii?Q?yuT0oUID0VyU2ZIuNzNViCUSIccWk6UMs5GqGc3j4OAjV+TefP7BWf71wten?=
 =?us-ascii?Q?mezRHZNQzyR8j24ZbESuFJrnI3xjH/+hh2QWExVPVEUG0Y8oKdy5d2jcYbZ6?=
 =?us-ascii?Q?AywrCztDODQBzAsqePoibQhdm2Rpt+qMLBem5dkHoMGYu1NsFwSJUYa6eb4J?=
 =?us-ascii?Q?GFWDCvRYvb5srmfUwxx+5Q4r0P3vMVaYMKYQFcl++p0PH2WeiRjZ3z05021o?=
 =?us-ascii?Q?yPp+Dst+fL6FEqJYpE7IcTge0BKNi/g7ccV/qr0cTeZeCgAKrIb2pcSUSyzG?=
 =?us-ascii?Q?uqZtVw2Rsa9euK6s12B+znXUxdXy5HOmUoaeyn6z5RqChoR0c5T+WskiHkLi?=
 =?us-ascii?Q?Hhjmq/ZXrC98LnNnb9jjlPjKagRMTbLudUWowlc6qo0GYwBBmG+1ueIAgZmJ?=
 =?us-ascii?Q?p6L/UzKaAaJllPT+hG/+z6Tiw4Z5d8hwWHARXccKkcQ11CZ6fuG7dU16GIkd?=
 =?us-ascii?Q?qnUb7+JxB4xpgCA8HswIs1jGCd692v/cQQHCnOrMh+L7VjStYAasQjjJT9RA?=
 =?us-ascii?Q?xBr2Jpw58EvF0w6Pp1qA5kodRPVYxYO1wlk8/HObGNzkFFzMPU5VBTbLvFCM?=
 =?us-ascii?Q?DWIB2tpk7KyhUqnTCfGptm6f6CS2gxZfcWGCyEB4mbQfHYZBI5/quq2A1Shp?=
 =?us-ascii?Q?wPzb10YGqND+u+jiH0m1rrodJIFf5TPvlUvoWw+gEtHwgalS6UBuXMZUfQGP?=
 =?us-ascii?Q?uZ86qioVmU2Eihl7xcUNMEq0ku6BGwvgSawY3YjpnWqM9A8tI7MLF6kIpFBj?=
 =?us-ascii?Q?o9Lns/UoNeTLXMJMv5GeRnYWcAzrCoL03IMzKJVmJKjf8qcemF9emqqIbot7?=
 =?us-ascii?Q?EYIgvuS0sv5UVKgqBvBBBKl6VEA3+3TVUy3geYGJZHHIQ7/DSlORT2ffJeQc?=
 =?us-ascii?Q?uOgt5mJgu/1yuBIx8AhAsC7ap70RrLte3Z1GcQTkFQQRZrHHFxsL4p98kfVG?=
 =?us-ascii?Q?d9arcuz0NeogPbUR/8BQcxt5BOCaoWnrePDtbutY0W3+TBouak7Y5Y3RI7DV?=
 =?us-ascii?Q?1O+l8BU4+TK1JzcXFeK7mCVuay9c13pC8MjEs/saCRGyfq900scVA2BbywnM?=
 =?us-ascii?Q?2lNAiccZM12zfVWai10XIz3DSmKOruL+rRiBZVnSqOWku73wFZhIR9OtWRXG?=
 =?us-ascii?Q?mw5qxIFYafhpky1eNluEIH/YbUX8v4lVhVG31PZW8Uy9PMtfJXfTbvG6Qvcl?=
 =?us-ascii?Q?9BGmeXU2KVQ4tKJ6Jy4g3N2naCOix/doc4A5091YiAoMchF9iAr13ibwa9/N?=
 =?us-ascii?Q?fq91w+6PF0oT62lSVjl3ic9nln/A/IjVRDE5uReeK4WO1Bf9TiGR+UQSH0mv?=
 =?us-ascii?Q?0jxKbkGPkLjgoFLdvSpr8dVSRVxko7+50dQpIkqQs/vakYHlLfDR6zAP5I42?=
 =?us-ascii?Q?h7K2nPwXiCLKfG8uurpMZz37ZPioW5QdbPztDoHdRY/WZANTlDJ71iuGx0mm?=
 =?us-ascii?Q?ji2UGbI3UDxo1+8SdzYC8BmOHXOpqv2PbKAPcixuB1OVP22+GahqLHuQhkzv?=
 =?us-ascii?Q?FE5peruSL2MMTnnTRwPSvpQzKPyn3Dw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1fa70d9-2ffd-43e8-c1d4-08da4b8ea825
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:10.5926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRfGy2xgRLU1U+i0XCtjuOqnEaQF5WguQBEYCjmP0Q8tpmGMMdBdzgOQFHZyIKqtQDo07EzkVCu1AAhPEAV1Otu0ukr/0zZaUVI7NxKbaf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-ORIG-GUID: _keuuUmzY1oIyUYksZN1p8glEU86zp8Z
X-Proofpoint-GUID: _keuuUmzY1oIyUYksZN1p8glEU86zp8Z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Renames that generate parent pointer updates will need to 2 extra defer
operations. One for the rmap update and another for the parent pointer
update

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..0c2a6e537016 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,7 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+#define XFS_DEFER_OPS_NR_INODES	4	/* join up to four inodes */
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
-- 
2.25.1

