Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F07AC43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbiFFMlj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237504AbiFFMlg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:41:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E105261446;
        Mon,  6 Jun 2022 05:41:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256CRpoE022494;
        Mon, 6 Jun 2022 12:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2/xjn5/xokuNuo095WveON6Bnr/1NNaHur8zSfnU6Kg=;
 b=Q7TgfRcSFRO7rGIG38lwY+jriGghHIDlg3ld+o329llTPLZK38WwpVZbFpgeTVcqDJWx
 mFk5WNYcS/Ktxw/J1cgTQjV67TnqPPTn0j2VYJzAA2BmkColKTftbyIHFMWblI55Sozg
 l0+GYNagSjpWUL8FUU4a0YJT1OxiuLHaOF7urdBbdFSBLv6jKe3tkTEwOQ21UxsZryOk
 APz9EzlXc03awRWGlmqp0O0zCFBZppAlQ4zuzDWOWDQlnRkSuprX3r4i8hTF7dHGBqBs
 j6jsNtXYIWuINnyP4wul4NGG+dLllop4+XuAieKOCuFxrYSEnm4+rNzKqjwUv0fgDpOf XA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmsdtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256CeO0f014072;
        Mon, 6 Jun 2022 12:41:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu1f0h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDoeu6tWyUYd3vyxNdsSpyEs3c4SReZmt90YImscXrLj1NSTeluoL/WZ3EaaOBTqN051s9eCJ3eJRW8hxhlgcVtOT2lonATO0KeRAq4nV2OdSVb6b+pgiJA67aGNJQ5CQR8CoFAo0h1GqGq5dQVVW63/CVjSCuOj+I154zq2JV/HGOubobrApRJsaj3dwJ3rVWQCJHUbXQXCw6TYzvr+9sHUGVqCcqy/Ey02i/cGqZWpQdn1xpH88yN93IdFvztxoQAPq61TssEVBdtYSM7osNc7291CU0StEP4dhYyq4/kFR9sskVYOlGl06yqu3A+RgIQwTsDDTq2a2159gADHHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/xjn5/xokuNuo095WveON6Bnr/1NNaHur8zSfnU6Kg=;
 b=XM4g5KaYarvYBWBZAFg9gydDzdU/gVx5BQ4tkQrPxnuN+myxOW0IT2tAEwOqYCKpHc8ecI9nkSS2vCNsMNLdtD3vH2hswMNpUTu8GOs4Gk06uL1j8brvvXEdH/WwvdIzwRRCPyKyFgSUx/k4oA2JihpcJPyW4ezRuPRpmNXrMuZgY5MDI10piOOxYShxiM7ZRKl+jblVaqZj600tO8TtPqMyKCG3bgY/KimadOx/KsTSMNs39DozO6kf1OBBRXRgRPQXuXlPAwiYDLRek7F1ateIAtazCtnrYyF6XHaBgp1Y2fiqv34QfDp3un5WzNfTPF7u8CAuOKT7wZOo1WXBXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/xjn5/xokuNuo095WveON6Bnr/1NNaHur8zSfnU6Kg=;
 b=U3weHxEbdrdO0A1EvHZPQsiXoon0UE4nSsUnIjTzaV645Fk1fVKU3Zy2AVjrE6vhAV5klMu+TMjzn1+c4s8U4cJFw4RKWFTwBMXaa4IcZoDRaImS03I3/eOQnzwNzNNWTZtII8kascHras/N/h8notKFl3gkSfJwYC3NmfywfxA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB2523.namprd10.prod.outlook.com (2603:10b6:5:b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 12:41:23 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 12:41:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs/270: Fix ro mount failure when nrext64 option is enabled
Date:   Mon,  6 Jun 2022 18:10:58 +0530
Message-Id: <20220606124101.263872-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606124101.263872-1-chandan.babu@oracle.com>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e51d70a1-eae9-4b70-01bd-08da47b9dd3e
X-MS-TrafficTypeDiagnostic: DM6PR10MB2523:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB25232D2019E8F09240DF769DF6A29@DM6PR10MB2523.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EcpKM649T6m3n4eACjTvQ1cspt3J6iIElpzmifTxClUfj1rp7MqphQOPtujoY6MvfaxsjLnRJx9uEC451+hAn32xXbhLEnCo+2lU8V0aUNLppN/GxEMrm2KRqxRXTSrZkpLYnKI5VYZXIUl3DwONjuqoectdYG6tUA4FldZ0QPQnRbBu4riIL9igN8mEv5xM2WKaLb+cCC88XhW77+ctWaHOCdr8G8SRiZu8Srj7jqz/tXwuRN0upITsdudCFsa5MIzU/hKs2K4MNyPCrPEXEpwzH4lm7EMZYXzOlD/fFMPnEbJ6Tk3c4dzLLsdGcNUbSYAR4Hf35ebVEiFZ5t3/nJMMFGoC2gMCOH1HKlT4NiZIiA1qTLNPkHO+MzeEsC/NRD52vyIAlJbYAYPCq/OW4MOyRag6wDLtzsQiXt83+87L8bv0Dp99jsi2o+TDz63ZFvFspGlErrVYQIuNOnASYXpl0Z3fF3+SKnsJqvUFF2dMQfd3S/9/gvfqK2GfVOzTDnK/Vk+ud+EDyBMO62K4XK6fIwhBWUzG/+6M5ubnTEHJQueBeg7uwBl+Nf93vVztc3qhiVk/Ys6H93u7yjY0kHXdUOh1I7hqbus3lUBKVXLTxFFRCpR9x/J1vtw5hwKzvPzeVOZ2DLBmagne3sr6VFn7hMKAOeYeLfUDpSgxTJYEUzBs5rHdRgjZZr3xaI/shVWq2tN0FHcGLwGfQugY4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(6916009)(2616005)(66476007)(66946007)(66556008)(1076003)(316002)(6666004)(6506007)(2906002)(6512007)(83380400001)(52116002)(508600001)(36756003)(8936002)(4326008)(26005)(6486002)(5660300002)(8676002)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLxgP6WZWzQj57miVlP9bZaxvQs8Xop9/rXABuMvNSVCgvvk4GKxM+Ph0LOX?=
 =?us-ascii?Q?urQGqksrCDmMDQZEs//LyFRaSLN+YVfGdOcRnGTLpp2UQuZWykOvJ6Tdh0sk?=
 =?us-ascii?Q?YYEJiu5v6f30LYsiqpjdyi9Xd1JqBI41SCODufoWHbC6gSXXXaXiohW0voNd?=
 =?us-ascii?Q?dwOJ/Z30MvjUyDJN1PKaPmRTZkb8ktr6i1g2CQ4xxMB5NVqap0imjuAAjGJ9?=
 =?us-ascii?Q?tci7uYupEy9t1/LndoUPU8YOkkuUbYf8qoOJVXwxGTGTtXi/gYgl6kTwxH6M?=
 =?us-ascii?Q?+rJpelmHl+pw3S4Pc1TxTIhjmPuqiJcgJ/H2CaPrCSK+9n7Xxa59XZtWOrDb?=
 =?us-ascii?Q?yNG8Ubw61A0kWNLToXka5VLKIIyUwfIR/JYAiuIlo5o5qhtJQzq2S9A5+b6g?=
 =?us-ascii?Q?mSJvudfOyYTBNGkfE5dISBxbgOPlc+BHK4lBo+VOoEBR4uFgKWj6lErL3V3y?=
 =?us-ascii?Q?TRfzI6GB+hvpx7g8aj74wliEXxgB+AHtHjdmx0jcxKzp4bP4qGw0ffUseHc7?=
 =?us-ascii?Q?92wPEe7l+LNsEXVx5/+ehOo8pklbzvh5qHKXrhu60GOyGQ8J0As95kcQQK8O?=
 =?us-ascii?Q?9iqXzCiQqk7fyHtakWlG6uFDm6j5E50wPELcCGbyjcIURVls9r4KkQiI6Dbt?=
 =?us-ascii?Q?yKmCgWj2Qb1YvTchETxOnQjJXFKRZUxWlLLxTYintF8k/Cf6Fl/ztVRJmj8/?=
 =?us-ascii?Q?B//iPtV8Ab5nwssi+0g6b4cS/9KsqOb++2b1+j2QIhG1naQOxZm8fckksSL5?=
 =?us-ascii?Q?9o8FiJ9A6UZaXhqTUse7984hDeRKfa/slL7blrWdfOSya1/dIMdAE61XdWRJ?=
 =?us-ascii?Q?YHRaWRo5L/ScLocs4NDwxTiIblQm1hRIeUIWBBKgF/aWANpBevjPpVdpzdtZ?=
 =?us-ascii?Q?aoMbx5Wyag64oYZb8qQ2cJmo/fqBp7+t1uJ7CRMmpJpbu0kyYFDUWG8FUouK?=
 =?us-ascii?Q?99vK6mRfMMZBY/g7h6yyQ00r/WGTh9dFQ/iJzWFjQRbXlmlpQ2fupk4nMxFD?=
 =?us-ascii?Q?PXZ6AfXSax76hxHQQ2kEazhjtz2h9qJPItCZatz35F1uzr5d24GogDbB4Oux?=
 =?us-ascii?Q?ak8DGtKmu/CEEAvTO4b8LbUaXcPBx3EF0Ao2UFLzTPhh5l+V5yEj0LJsDTAV?=
 =?us-ascii?Q?PaLZjI5rFUhIjPOCTVyHeY+Q8S3P++FE9C8WI3DsZsvE0uOCGZFGfhxr3Q6F?=
 =?us-ascii?Q?wX9nTB10BJ0gRWE+UTEP5VAnGjYyBf+WgdV+16IxKiJwNS12rR3YogzB6KQC?=
 =?us-ascii?Q?gnI/jBHI+tNeI+tucUxOPdvlaoAeWgUFNMGVDocgvsP4uiLJh+s7mB5zVeL4?=
 =?us-ascii?Q?a7HpThuApf1kj60TsKtcNeOdv1LQzyPWFUrm/w94Yr2nSx+UbpW7X71PiN9p?=
 =?us-ascii?Q?i564mdgL6AUBcgLZTlf2V5Nvsd/IZGdgif1AJ+vTMjsUyWOpFble+REydAjx?=
 =?us-ascii?Q?GFf9Ew11U9XvmFWkDm5+p2VJbX5MWOMzafJq7jmxTRmzWlUw0Dwvjpj5MGE0?=
 =?us-ascii?Q?S3V+D5OuWHpQlIS9P3Dq4/NPuERKcUn/rxqiEhn8bu4KdW2U0WyFjeArjyrP?=
 =?us-ascii?Q?eB3ze5JulZ8ifgi+G0LnWg63SFkNL9FV6aMzvvQJqCAcgWDDYY8o+N1lPtdp?=
 =?us-ascii?Q?7iYEzeQG4KEtUd597zHuWk1omZnj8Q6g9Y75xT4e1y/hue9JXFNQmOMB87Q7?=
 =?us-ascii?Q?s2I3v7LEsSaUI0Ou04lPxrEKDfVSR3cRjC5rEYFih8EnfABXmMnb+uTeCssh?=
 =?us-ascii?Q?HotJJ83Dn+ULwiKT1rpYbByEcFVpb9E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51d70a1-eae9-4b70-01bd-08da47b9dd3e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 12:41:23.5977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eA/stGKpvO/OjvRE5lAUSMmyyFIijCu1NhPbr5iKPitCqhD1KfF6NkErlF/OTeGXhx7nLs4g30rajKBBojOSEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2523
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060058
X-Proofpoint-GUID: 1vhCSPHsL0Z2jpS7oADPEATDItA8Kp-d
X-Proofpoint-ORIG-GUID: 1vhCSPHsL0Z2jpS7oADPEATDItA8Kp-d
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With nrext64 option enabled at run time, the read-only mount performed by the
test fails because,
1. mkfs.xfs would have calculated log size based on reflink being enabled.
2. Clearing the reflink ro compat bit causes log size calculations to yield a
   different value.
3. In the case where nrext64 is enabled, this causes attr reservation to be
   the largest among all the transaction reservations.
4. This ends up causing XFS to require a larger ondisk log size than that
   which is available.

This commit fixes the problem by setting features_ro_compat to the value
obtained by the bitwise-OR of features_ro_compat field with 2^31.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/270     | 16 ++++++++++++++--
 tests/xfs/270.out |  1 -
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/270 b/tests/xfs/270
index 0ab0c7d8..f3796691 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -27,8 +27,20 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
 # set the highest bit of features_ro_compat, use it as an unknown
 # feature bit. If one day this bit become known feature, please
 # change this case.
-_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
-	grep 'features_ro_compat'
+ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
+ro_compat=${ro_compat##0x}
+ro_compat="16#"${ro_compat}
+ro_compat=$(($ro_compat|16#80000000))
+ro_compat=$(_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" \
+					    "sb 0" | grep 'features_ro_compat')
+
+ro_compat=${ro_compat##features_ro_compat = 0x}
+ro_compat="16#"${ro_compat}
+ro_compat=$(($ro_compat&16#80000000))
+if (( $ro_compat != 16#80000000 )); then
+	echo "Unable to set most significant bit of features_ro_compat"
+fi
+
 
 # rw mount with unknown ro-compat feature should fail
 echo "rw mount test"
diff --git a/tests/xfs/270.out b/tests/xfs/270.out
index 0a8b3851..edf4c254 100644
--- a/tests/xfs/270.out
+++ b/tests/xfs/270.out
@@ -1,5 +1,4 @@
 QA output created by 270
-features_ro_compat = 0x80000000
 rw mount test
 ro mount test
 rw remount test
-- 
2.35.1

