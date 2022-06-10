Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E94ECCA47F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 08:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344096AbiFJIwR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241545AbiFJIwI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 04:52:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6969C240A6;
        Fri, 10 Jun 2022 01:52:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A7vnbn002868;
        Fri, 10 Jun 2022 08:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=SgThtAhtpq/ArTTm3uxmLn11KnDxMyVP9UN8k3tgRRs=;
 b=mXJ9rxOL/0rELXPsayvkVZHlGLwfNX5vuwpdAxIJ/bdgFfD+CpvYMuzm6GN8BD58yK5t
 ILczrcFLMBOWSeE7fPLRqxu4C+kPMs8huR8hmUiHQZDByCeJ5MZFUj/6t9kj1VAD6V7a
 aDyooBcnQ4YkLXQhkAHF+cDGCS827bpODlj8N5tmXPSdPv8qR5XlIl18hrWv15i9mM9w
 WNIG/tyHr3c6VfMe95OMh2WZt20tbhZYNraEDM6oXPm3tWFdpBiJsqnhjoyzDP63E2o9
 8nUW1UaPDfik6Ydy3nqfEaaKrtJxQMMml3K6Sc+poc9+HYmlFdCEIbG3p12YtAvD1MZi Ag== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsnckx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A8o6cd016400;
        Fri, 10 Jun 2022 08:52:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu5pquh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfI3SoZuilx6ngWslaNwcf5m8bzH3h+/zKOIORe02kjBPI9epd65Y1MpOyxQG5ebMZdJWbjr7FbPs96Yq+UzBmO5kxmjQ0sEFrlMvtp6QBcXQLgaYtL8wi83tSyq4C4JiHrtPHIINwPvZSqOzW9MB8L2Oy6H42R56Uey6JjT4ntZkOgrRxeTm1X1iniMTffeTE44wFYTTcmqwn8eJPaK8GIvghY0amumzYNyyyEBC44xiK6IvsUqnxqG66WACMzZMhxoZkZw63Dxlth2OUuVDOXVuneWx9x1ZmOn1RbrZ0GIicQmaC1lVcwtHFNmDw7cTq82fIEK9ZN4HXgX0dDQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SgThtAhtpq/ArTTm3uxmLn11KnDxMyVP9UN8k3tgRRs=;
 b=lHh87rZjgwUvqsZhxy5lCmm3dZqm1SHpvckg1yMgzBEz4ZaoK6a04cKcqcf+z1RDaNGX7uhQEsz1eyZLTjFqb40ar8BmT8hRsc+tBtp6jDhIPHj0S0hOtsFHL1ztuRzQNfj0+RZEyWKQhMbAPQEZd58ek4KUSTXxb4fYqGcI4KQubX6qZr5SOIXxMXuMn4vjM78ookMPNtWnU5uMEgcSPR2iw+N+CWneDakxFN2qYudMSvo3wyUAbXU4MNYaDPqgjk62mrLR7iaxi5eUIQQ2IJ98apAARQV+WND3OqwElNhi8RBr71iTz3rqIQGcSEEPW0aMdFcMZfVv0CRki1P1ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgThtAhtpq/ArTTm3uxmLn11KnDxMyVP9UN8k3tgRRs=;
 b=fEaDkCjDMZDTTupG9dVca54jVWzFFk/9Hd6NEcd8U2mWFfWHkLTLqmvsUlEqm0r0Qfu7WToQ6/IE/fNBnn8iU5s/ffhlo67YrSjxu4IQhQ7e4WMA5gL4Za13+4/6dWyAQzSEo2EMHf9cRLQjQejZPxrMMrzd5yOA+gH5Pk01/9o=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2854.namprd10.prod.outlook.com (2603:10b6:a03:82::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Fri, 10 Jun
 2022 08:51:56 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:51:55 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V2 1/4] xfs/270: Fix ro mount failure when nrext64 option is enabled
Date:   Fri, 10 Jun 2022 14:21:32 +0530
Message-Id: <20220610085135.725400-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610085135.725400-1-chandan.babu@oracle.com>
References: <20220610085135.725400-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0229.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::25) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0390e74c-f35a-4a99-a4d3-08da4abe78cc
X-MS-TrafficTypeDiagnostic: BYAPR10MB2854:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2854918120886B6B77B4B70EF6A69@BYAPR10MB2854.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wn0VJa/nG1WKge8u6qIA8AjSwPOGKJb9hcsHHNL7rKGRUj0tSPMkapisWjGnFL0p1wGBoAj1wdXIb9Q24ntA7cgGnc5dJT41FYcXi0limOwG30TrUUm2b1X7/2a/BrYhIo1M6PEYpc+/t44+1ZoLH4+iqLcLdzYqsVO0XUkeJrik5VrWe6jnb68qBuzIfFyY6iWOOWzxmmh18ovXGAeUBauLg5OiECip9mZWB+KFrs/TyTapicEVdRhEzclJ+MQLcE/cywKm17AmZ4YnCNDFRfnHrE1ThrfPRiPWUQUGWUfvv7C0T9FxYjw3nDaASTx0NVL1FUNEdu5rWBX2eN1DtkNrH4ff664q83cpLmj73HJX3IvqIE3z7xiSSjzW6vingIpTjEmpa/Hm4fC/ZkR9nNyP2c4PQet8/dHxcT+7YCYDT82p7gIQYpaGXsCfRg2nCUl4GOJu/OWFEcRByXfdPlo668L+HYElu84DB4dK3a4Q6ZH49SVgsWv+9O5IMl/SVIwBLurlb0g2tiugvbVgM7bZc26DPhvibIaZWzRxvpZxSThYYfdktTv8xf8VEeBzXnklq4/gduwbatywo3OouWVKdMpPf4foOSuouxropCpL5BDiCTUFq69/DTqsBzUZfjC3SnnYOmy/GmWbr7KiojG8hDOwggrxb2K6ILE1ipMJF4rc+AmSkCSVfiHpYp+/rzydShV09Q4tQjuB6ZLNhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(4326008)(66946007)(26005)(83380400001)(6916009)(186003)(5660300002)(8936002)(316002)(8676002)(52116002)(6512007)(66476007)(66556008)(6486002)(6666004)(86362001)(36756003)(2906002)(2616005)(38100700002)(1076003)(38350700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xSNt13bK7iiSUWTMSzkNogBOczIYZUz6X+/XQG6K/nfaxDUIhjT2I6p7QAjp?=
 =?us-ascii?Q?OS+Xok15DBFYnvoIU85Wcuqlnc0q29HITLwehoY5tNsaYzh+DNwOUDN75b0M?=
 =?us-ascii?Q?MRbWxq+XM0lu08pg6H2/gh7b/hG0n50+ekBZHajkK82Ds43QK/QEZXSOMmQu?=
 =?us-ascii?Q?ygUyH7s781XmTkh7/OfogbXs9n4ix1esTNIcysiuQnU3A7WQbGh2/G2CCQTY?=
 =?us-ascii?Q?w3h3Kb9WDczx+zMtEAYZikgvmqzh8TtP19/Tp4+2XXoxM3b9TG7gktk8p7Ue?=
 =?us-ascii?Q?4ih1dZTMELEj2m3Zql+AL2UTeuAH+6oQXq25horchsW9K22EJXI9EF778qze?=
 =?us-ascii?Q?knJ0LHNNnCeSTn/ILW/iAUQ5Z6ea8nIyGzzP+bwnmIDIfzlf+PVQXRsp7guH?=
 =?us-ascii?Q?ojTaN0b0jY/12ex8iGvIyr0ylrOwBN3ZF7NaWSMuEo1tPXeq+/gAqyEeZlaR?=
 =?us-ascii?Q?UlCF/J25jiAlQMoT1729i+Jwpday2kVlhXzWyDmuEOGmBMkwiBTs76UGRs6J?=
 =?us-ascii?Q?c7h9Zg7P9VRc7KCu6TImIW37eG96+8vXj/YlLX80e2+rTQvlr1dpfTrk4X2T?=
 =?us-ascii?Q?3s8AW160knXC5EOomsH+O3LEiBQX2DVnNQVPvL1hUTbn64ldnrJ0ixd/9dE4?=
 =?us-ascii?Q?4YWNk5Os4egPAuJes5+LKpoqEHlnvQ+itw4bLhw4Tk1JPmxeQVOt70r4G1Dz?=
 =?us-ascii?Q?QAkcQd0ieNEG0ajvO5E1PAMsyh+7WDcbLNuV15cP7LeEdeiNm0SIIiZoMRs5?=
 =?us-ascii?Q?9oEdIEY7cEXkp18fuGv6LXbIkpSLXOqzg5JIzUhHV0wlp7CLPj0o+DjZBvMy?=
 =?us-ascii?Q?DsomDPhKHhl8J72AWliXoe6NomZC7i52Y9suS8gUkvOD3Fr5QTW+FAiSS+ea?=
 =?us-ascii?Q?NG0fypqNrtSmHUFaDewHFdA5dflAaOtXfDyahD3ekthuywgTB13qp8FAwpAH?=
 =?us-ascii?Q?sFDHz1xI+W6paCUvT53t4MKNvIZVSb0G+aIZbSX0hcQy47LqgJaSADyGXYpG?=
 =?us-ascii?Q?67/kAhn1W/kZVKN0z+zceRJy2Xo3Xj6NjWd5UN27ulRH3ElBDXekG6t+6mSr?=
 =?us-ascii?Q?rX5cdc4lpYrDaWPZFmVX5o9TDSg+4UfnHiiBaIbDh3IPjqgSI6C9RF+HHTv9?=
 =?us-ascii?Q?qkeUatAA6ydDl+CLifEiBPZXsKrj+aScwYmYMnC9MXqmQC045zmsbekPYAVx?=
 =?us-ascii?Q?aP8zjma1OpKjPVy269UHA3mqYhLf5DdFJRNMvSxsRkVOrvME/nFIwmGrt+9T?=
 =?us-ascii?Q?aP7hMgXiMQCsRoyAuT28uunz8aHOu7UhD/Cu3dEUP3pqW6Pi09vq8iKLv16e?=
 =?us-ascii?Q?UwDfom7sfECk4aLMhTNCLagohYtDSJH3GeG/5rrrWOw5Gh9M/+kplB0e+xLn?=
 =?us-ascii?Q?/X6jIuQ9T5Txjv6elVL5AaXMYeIJbeABLfykTAwxyTqXny6agmr7ysZa+Fqa?=
 =?us-ascii?Q?5vuPbbO/rKXr5g7CZ8DPrjixua7vWJO94DyvjmBDzSQYYJQ3DDakNlAvde5D?=
 =?us-ascii?Q?oGhdWiFJdf550s5TfQ8Aaacwim3p0KaQPlMcLvW4gvyZJocDKwqKlECTucN8?=
 =?us-ascii?Q?04ATtgF/S+aVnA8l+6qZbLuz5IEJ1FBbC4I79C0sybJGFRb/MAH8CdkVRxkQ?=
 =?us-ascii?Q?ml8JoxDnnDhwjyIRXrXVUyCcRPKmPjorivcuLchkwt33kQByU0fKlqUdvi4a?=
 =?us-ascii?Q?uC0mpsH4INi8Cdjd5uHO16o7d+nYtV50ayies7nJR8qLA778tdNcMjIzFqJN?=
 =?us-ascii?Q?XO4KiVC3++yZb9tXwH4VNNahl4nJCvA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0390e74c-f35a-4a99-a4d3-08da4abe78cc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:51:55.9467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyQ1Fqmz0e+DMnPkzDvPiYtIGilJs5xS5WdvL6NuNpbM34rJ10zQeyZlxu5TXceNPlxNTb8zqkup1ox/XTDLOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2854
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100032
X-Proofpoint-ORIG-GUID: QR95SKAoJmSohCr8uypv87tsMacy2oas
X-Proofpoint-GUID: QR95SKAoJmSohCr8uypv87tsMacy2oas
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/270     | 25 +++++++++++++++++++++++--
 tests/xfs/270.out |  1 -
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/270 b/tests/xfs/270
index 0ab0c7d8..560401ce 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -27,8 +27,29 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
 # set the highest bit of features_ro_compat, use it as an unknown
 # feature bit. If one day this bit become known feature, please
 # change this case.
-_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
-	grep 'features_ro_compat'
+
+ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
+ro_compat=$(echo $ro_compat | \
+		    awk '/[:xdigit:]/ {
+				if (NR > 1) {
+					printf("ro_compat has invalid value\n");
+					exit 1;
+				}
+				printf("0x%x\n", or(strtonum($1), 0x80000000))
+		    }')
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

