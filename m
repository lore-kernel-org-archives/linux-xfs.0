Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0F6CCA47F
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 11:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiFKLLS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 07:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiFKLLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 07:11:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F60D25E0;
        Sat, 11 Jun 2022 04:11:14 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1VdZO004513;
        Sat, 11 Jun 2022 11:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=0PNaPE0pawrFPLKHZmMxU6GAPCV38K51uZiYFfCkJW4=;
 b=aLC6Q4apcGC30afTGPbUXdiWrelSosGft8tkua2g3s3dnio12ztYY7Qp9JDG4xRu0BpS
 GtfltvWQJeQj760AtjdboRIEs+QoqkTyh1BXpdb5gifdoWH9EvUjOTcjT5guT9vvZSh8
 jTIctSmloTG/1GILN/uXbtIAXd/nsg3pCfGxfVzeTL5m8F+certHfqjzGj0SdNXsqO5P
 UXjrYGgC8m3Y0PSSd7Je4x9k5PEf2MPXwiQdGkg73eCfPi5ikyfk2TwlojRTjw0tKxE+
 D4lYBhJwBTuC4Z2OcO+0rJdP1Tzy45K2PqBp/LTbCgnvGG+B6eJ2VJIaN4WXb5Au202z Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfcge7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25BBAeHw012939;
        Sat, 11 Jun 2022 11:11:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0pgff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpCpsOZSp82E6ynbKk8oHcMjn5Yl7wfFkiV5mGvjnxMH77RlJ7CuZdzk2xwB2WmqN2XtY3Z+sDo0zmxtSp7ZaAQli9AdIlN0iWxCaRJy0ZFn6d+lhq3+9rbp37qZoICWyTx3U/vPKKvE6mbb7uV389Ez2VbTRFyVggO2CywIrhjER0Yr8p49RCcoQqja0+72AYhO5cfdFGLRlc5e6TybJjpvJNHQKKVh7qDGRI53UmcAk+eHSZK9gCKzHzkSdYPy03Ed5729eIijcDsjeTRFb4+C/ixVVuGs0jENVM5TkwHYzw5Y1pFWWeYsfgWXOqTUXR8wCzG2AGUKGe2U3vxyfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PNaPE0pawrFPLKHZmMxU6GAPCV38K51uZiYFfCkJW4=;
 b=gxbRipiT7AYSU8aZaBxGqv7IQiUuCTXQ1X1C5DIzyNtDAiXXly0/SZf9hoXK+JiqicjTTcRm7C95ILayGzKtnJCvNrohP8HXY+4rq9PhSRu5VTdSJxhWfkHb2SAnOQ7HfYkiVHmQUTyZPS2WzdDMHHSsaCiaZctI3vQhWxZayYb4fllr+/cRBtcHykitf2nXGosyEX0/KDjTuc91D7uNxh3MY5yr0X+adRvq3bnSENpChgjaWHI2ZBg13xRtlhUO+8W9HgUTxHEgbGlr8plsqEZjPAxNW+uCg+FjNqY8bJgvPSYu/GIWwpQ0oCgZ546P9J0kpBTu+8ZD1e4F5ftxIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PNaPE0pawrFPLKHZmMxU6GAPCV38K51uZiYFfCkJW4=;
 b=hpPL5DdnYYJvWVz/36Kd3hc5NmUSnNMoHfydESjKKIQCeGLo2Mkw5hU+iSze1j0DI2ClvXULaZp0LWWg7gKZG86YMiNfuhk6STc6yC86hiyUisD7JP8RkMLww0RC/autYJHIvQipKN3OCra7lGZDJ2pUH+Am6CvwyHrrlTHoYgE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3313.namprd10.prod.outlook.com (2603:10b6:408:c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 11 Jun
 2022 11:11:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 11:11:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V3 1/4] xfs/270: Fix ro mount failure when nrext64 option is enabled
Date:   Sat, 11 Jun 2022 16:40:34 +0530
Message-Id: <20220611111037.433134-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611111037.433134-1-chandan.babu@oracle.com>
References: <20220611111037.433134-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0014.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 097a6b2d-f27a-4a9c-34a1-08da4b9b13a2
X-MS-TrafficTypeDiagnostic: BN8PR10MB3313:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3313434215163AF880AC2DB0F6A99@BN8PR10MB3313.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2D3banXemBi84WxRXKKt6Vx9AU80FHayvlE3QC/j8pWpJUOiVXPTLW2WgzS0uZo/AswcCaeoIK2up95ZnBURD1XJsSH/I9DyWnCLzE5L+1pMjlNndjQUbP3Opkn80wqY5OgpF3yKEVqNMkHvwdvEBw23Tt4Znrpybfd34wXrdAiG5vX+0wTIuvs/lb6ZBixyXIYTH3T0z4rRgA04QppwbVaeeLwSQpC2iTzMSa0OShF6RfOp3VmZN2g57P9g/k4agR7NFPGPVgOKlZBm0rGA4tSzljvVxpAti47Vi37xXBp3L1q/UPXlk+XGICn7fuvc/H8LMfgynWW30zs5CimCo+/QIEUFzyS5hSSDBhLbt4xulangYfnFbrspyjB1dHC8xvYFNaV7Wepk6bMBHl7rWEVeg48u+9N16QvEU5hLpPcPzOh+JEOj0+Q3XZ8ZeolGi9AF72JC6QLc1Xvmcw294Kb1aTtvPD32oAFwoWs5mfY3VNOca01txUdo9oGO5Z2ATSzDV7gENPj4Rjj1bn+P4ppjjFONikj4S8rc+cFj95Kf4C3ZxtWqS6T6OIhzi+4PnLoPRp+I95aj8xD+6PtDsLjqPx+p5g4Ayi46/2bfrJTf0rREBhHC96ZWwHM+UxcI4ToqLe4Sth2HzSpZSXy4UtOo2FrofuBTdbBIEQr6MGoZyv48z4jU900a7pu8iTdR/AY6GvxzIyF9UX/KH4oodA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(186003)(2906002)(1076003)(83380400001)(6916009)(2616005)(36756003)(26005)(66556008)(8936002)(6666004)(508600001)(8676002)(4326008)(66946007)(66476007)(6512007)(5660300002)(6506007)(52116002)(6486002)(38100700002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DD2UFThec7D2i9m6D2DLC0GyBhTCJjMX38Q9NdKnOLnh41Ps0Rnc8cp5d6m?=
 =?us-ascii?Q?l77kauN0O0VXnCfFoStbhhfAxqznk6U6YOpzP5YpAiupd5nIErNcJ7MOCmR0?=
 =?us-ascii?Q?m78pfbHUARlV1aupDHnkjKtH8IAo9Hs7wnk4B8D9+3V58+o6z0gs70kD4jF5?=
 =?us-ascii?Q?sENM+2wdYRYEouu38Er/74X01qmX5u7kPHFOBZGtxQdUPQ5C7mXB0X7SQs2D?=
 =?us-ascii?Q?oJLtyuSzfuDcXqbGiHFES1tRo/KWR2+MRL1lt++paxr9X9KWf1IIwmojOFKA?=
 =?us-ascii?Q?zWJt2SL6n5RUVrM5uMjVrrk/SXDjoBmN2jBxOs+YDi7DyQo5hCeJupeLCcor?=
 =?us-ascii?Q?NRwm8qtdWuSXICet8C7TF6D+GPBsY63vSd4iZbWoW9ik4jRwkUzgPTiEH9h7?=
 =?us-ascii?Q?/+lS3FgAiXBzqFf6OEu9Os8pqBfJMuQhfKROvy/qrnNZ2kvFv+xi9x5PxMNR?=
 =?us-ascii?Q?q/tdiuq+5P1C1LlcMpAzmIVeKt/bgupIpIexBrAN5tVeMVn3wnMQ9VMUKThH?=
 =?us-ascii?Q?gtENE77KTZpmREA33iLt5wDBAvucwtLOJVAjD71HWROWF1uKbGzXOsisE+RZ?=
 =?us-ascii?Q?fh6XIklayLDuQrjVbIVsg6RVPgXzflw0Z2OZkp8IRmbtX+lWF7dtsdGiYrAx?=
 =?us-ascii?Q?8AeHSsDI8OZ2Us17r6lDbm9QzDIVJUlzqWQajsVEdK0q3QIcy6RPmNo4mGp5?=
 =?us-ascii?Q?kUmS8STdDusRV8tnjcCS+Zr/GglrnGL/+9K7wkTKlq/nnlYQrmgmwIrcYA9z?=
 =?us-ascii?Q?xC+HMPC8OyNGroADyTLeBuF7D5YcgL8HEyAL/e2vsZ6zFvhWtBz2EkE9iL5z?=
 =?us-ascii?Q?6yyigd+wthivOYwg+j9fR4D2GPJyLUYsr0NFt0x4128M95399z+/utqJSS7T?=
 =?us-ascii?Q?6xeBluQ2LQX13QkLnVbx+RuS+vflUgKq7Alc16xJKHa/gHfmMRsjagR4d8t2?=
 =?us-ascii?Q?OfPuXMC+bA8sMAfjEpMW86MCxJHpZPnoSDgzzE+yKl699926gDxU7ft15X0W?=
 =?us-ascii?Q?C9zIjWFC2ezWkHEsu+3kcGhmpp0zS66NNB1OwDFoVrQnboSKWdt7RfQXEQ/7?=
 =?us-ascii?Q?+HrFItUcFv41CQtKnqiuHI4fhFhlXpIxEFzkHNkFI+6PC1D287YCIs8zxAVu?=
 =?us-ascii?Q?v1s/KadYtT1/HB6Lf5g1imBjD/1G9x4NAMXub9QKmlG1pcQRmglZ6ARN4ygg?=
 =?us-ascii?Q?E14IAQJREbEXh55GZr8VxWszcu87A1rfpEFBt2TZZg/6lkgJqKA9YLE4uGYZ?=
 =?us-ascii?Q?8lUGPOpdwzVuwurjU05H/xqRbJcrWcclAgw9Njfp4hR+4zyelOw3UiTLwNdz?=
 =?us-ascii?Q?mS/l84Ft4aCYmHdrQOFRDeTFDu0fx/G842Tu13PCgrkwjPmtDEpKMAjM9J6s?=
 =?us-ascii?Q?y2rAnM8IK5OZ8cU1IJPqbI1CnvZjC93JyWtpXZjQ/pKhG25bIG3gG3RBhOrI?=
 =?us-ascii?Q?pAZr//L3lYCek9583fYVhIK5htVAPlneh9PS0p+MJYXxgnE26ovUtsV0zH09?=
 =?us-ascii?Q?sczd+1t1HhBm7ePA2GbVSY8C7kvwcz7TfnOIR4oIeq0Rvi7komuuDCDemIl6?=
 =?us-ascii?Q?yf4Dps9TuVHPgdKsqPg9Sx7JnCTzzC1l+e2sxU8zeMXVlJxtXlD6aisAV8er?=
 =?us-ascii?Q?lVsqvBic/8aWUUsQWJpOQs4cB+LX4Tg83R1doESibgZTjM9wB6JRlgqUpHf7?=
 =?us-ascii?Q?PkFd2uhGenelGdXIFGTRNTnyCjSDVAYYmaRU0IW3FAlNdmQlUIisNZLIzdqg?=
 =?us-ascii?Q?jtu3/IUpIqVKVVKUJPU5KqneJ9WRZRo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 097a6b2d-f27a-4a9c-34a1-08da4b9b13a2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 11:11:04.9946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IaHLhGCG1bly9eE67v92uyAK6YRpsgDjpPR5Ldsed/xv50NlnuxmG5Yd/3/yg5qjHxiFgCE+Gvm81DUzGUTzWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3313
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_05:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110046
X-Proofpoint-ORIG-GUID: f43iSZZUrqbRTmX3div0HRlinaUnSUuZ
X-Proofpoint-GUID: f43iSZZUrqbRTmX3div0HRlinaUnSUuZ
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

This commit includes changes suggested by Dave Chinner to replace bashisms
with invocations to inline awk scripts.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/270     | 26 ++++++++++++++++++++++++--
 tests/xfs/270.out |  1 -
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/270 b/tests/xfs/270
index 0ab0c7d8..b740c379 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -27,8 +27,30 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
 # set the highest bit of features_ro_compat, use it as an unknown
 # feature bit. If one day this bit become known feature, please
 # change this case.
-_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
-	grep 'features_ro_compat'
+
+ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
+echo $ro_compat | grep -q -E '^0x[[:xdigit:]]$'
+if [[ $? != 0  ]]; then
+	echo "features_ro_compat has an invalid value."
+fi
+
+ro_compat=$(echo $ro_compat | \
+		    awk '/^0x[[:xdigit:]]+/ {
+				printf("0x%x\n", or(strtonum($1), 0x80000000))
+			}')
+
+# write the new ro compat field to the superblock
+_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" "sb 0" \
+				> $seqres.full 2>&1
+
+# read the newly set ro compat filed for verification
+new_ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" \
+						2>/dev/null)
+
+# verify the new ro_compat field is correct.
+if [ $new_ro_compat != $ro_compat ]; then
+	echo "Unable to set new features_ro_compat. Wanted $ro_compat, got $new_ro_compat"
+fi
 
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

