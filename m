Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AADC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 23:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiCQXZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 19:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiCQXZh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 19:25:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD28728AC7B;
        Thu, 17 Mar 2022 16:24:19 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22HLYD7P024696;
        Thu, 17 Mar 2022 23:24:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=rPHQPFP1op/SZHHTw7OjhY8lM7fXzmzw35x9mcn5VQc=;
 b=q33wsvrO5qxjGDQlEH5Ul8xC2zcm7AKQ7DhWOphA8bP5Dj4A7ws+us6MSdaAOFtqL2Tc
 iVi9s1M92cKp9C/mepoZ7rRKtmpCBfuiTexbwDZcy9AJL00Dr8sjytqc1CUjnsR4AaYM
 kSv1ERjyxbPpPCIiuBO1+cH3O5sOd5Vgf1qsOVSh/RjZq/RSYHKhFghJUsxMVQzil1wX
 TN34nOJbdC3U+X/8oF4ptiuqfWhBT27V+CRr0lSBy80WTAKCD2latqwSayXe3L4qnGY7
 mgdTUvuOB32Tw84uiGBDx1yJmWbWeULdYL6f6bV1wEmGghhrqFxIiM7pEnbJL2g0KgES 0w== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6tthv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 23:24:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22HNGqWS031456;
        Thu, 17 Mar 2022 23:24:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3030.oracle.com with ESMTP id 3et64u35qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 23:24:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adHaFGSDQxRBe7dLrqIET9QBcV5AwPElfPskZ56nAx6Hck276NzZkGsVfg55sl2Qom7lsTrxiKbhqbr410qfMz9ihsktTvHi9ZXvA0CMR4YI9obboG2UcpcUlyZti/irxBMgA83gFjnHTB03Bya/W4yRKgECgJ9i1396uTXsEwTLRVpDXCbH594JtYePv6HS/lEAnZwq/26B9dAiquyBkuVlu4mP1dbBQVYlZbEpkrMZBr7QtLYhZvfFjheKnFGxXPfysjLBVGg6iZYEA9JIKLh7/37W//vxUbwQW0kluwD2Pf/VFodfdk1OdyU9ttmT/RuOMvvIwvwDMQkXCOSNcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPHQPFP1op/SZHHTw7OjhY8lM7fXzmzw35x9mcn5VQc=;
 b=WQtm6uvD5pQIn/pa2bMGwY+CEhmK4e/Q5AKlHJXhR5mGAGg1pEAs2xF84LbFXfXFd83MsU6KmfDn1sq8XLN11vdH9mBF5FNURfjXJLTWwiR29IAZ7PI+CwnpwdASprstY0UR5ITqxeqp7w2MIOGGdgFOHiOuD2HihOKpgloBc+J1V5lSA3nCCqEuvfnShMrIJx15S274Hb/Fn2kkFXroMoN53eUKuYiMprANMyVwNGgWVMzkggkjHklQ/g+59UifqTjpvenTT3iuRhXIrr2tIhF0diQuc1y1LnfOyg//r0BG1L+EDpWNYwKQObsGwdokwBILlEukR3hcP6UT899r7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPHQPFP1op/SZHHTw7OjhY8lM7fXzmzw35x9mcn5VQc=;
 b=gboJE1I+Q7qAvwjgiUPSgWw8Krqt236dzuqgCME3mn3YRHss5RjAjbnCdvstatvh5/DfW/pS4zPzjlRAEoQegonG2cC9OR9he5JJb20POHRwAb4Oyw9rY3exBlUmrjE/gSF65cfM/F3hDr/85nKQz110V+NC0gAR+CV1OR1j8tE=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by BYAPR10MB2951.namprd10.prod.outlook.com (2603:10b6:a03:84::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Thu, 17 Mar
 2022 23:24:15 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::d9b9:bcca:5560:bbee]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::d9b9:bcca:5560:bbee%8]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 23:24:15 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v1] xfs/019: extend protofile test
Date:   Thu, 17 Mar 2022 23:24:08 +0000
Message-Id: <20220317232408.202636-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:208:32b::22) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 780fd391-6f85-4448-471c-08da086d4095
X-MS-TrafficTypeDiagnostic: BYAPR10MB2951:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB29512C32F7E8705A80C79B7E89129@BYAPR10MB2951.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWwMnoVC8aZqAtxQLij/JnRA5mVQPiT6cnhsu7vfL+nGv7aq1rsTfiafLOxPKUyimEZOEU6p/zaeBodgNZ8TOQKBNi+2qt2VsyWeynCdaS7n8cDIuBSKMFMU/m9KlWAJWezj+djlHsY4W3sYV1AycGqnKIKSthOTkXZ3fPRgDq88byLscJkzDlcXvlOrTiKU15L+HrvBTdtzIxxnnQm+2LCQOP2dAlBTUUOyuXJCS8LGMa9a+L7ywv8Nz+6+yq/jb6VDg378mpL4F68xkZVrmmTQVzjFE3AgtEhwVaH7MX4OYxd5xNU+dAjs+ZMxrcC6ka3PWtQZ9tVT7Jx4ir/uSZdWKXj6UQm8ZDPQ6DLOPmkze2Dk7MDNFNSls3OO2yc6NR0LlLKIUyTeWbrrqHJSxTZSg2pvqUCx3B49sdE/iy2tELlgJgBg7SQSFeTMpfn/9UW+A6wH1puVdPnjkZLkQGzso86mo8CYHEWfL93WqXWce+tqDOauZC2hPhoxRWsRudPwtMzDR5tQklCHXWkcZ+qPGEiDUHz2+XTyzZeFOa8jikyNVctylpsvMm9KE1brbrxT34acuf9CicaiVmiKSfz/POljaDX0+9aU0Gk08xrtdWiR36fYhvicztI/fFdctkfbWmL/3xyfbjjR2CdWvmIsv4a2RARWf53CVYOe0cMrGQ2T94zPoipLl0b+JSODwqtgeYB6R5YOpX71N9a6TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(86362001)(508600001)(83380400001)(6486002)(38350700002)(316002)(2616005)(5660300002)(6666004)(44832011)(6512007)(36756003)(6506007)(52116002)(66946007)(66556008)(66476007)(8676002)(26005)(186003)(8936002)(1076003)(450100002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2prbXZmclp4K0xkdmVlWEpPcytrYndzUXVBd1NSZG40ajV3MWs1NlhlUmZh?=
 =?utf-8?B?OXY1ZTlpdEpiaWlGVy9xNHAyOS80c0N1RGFGelJiUDRMSDFVYnJBeUdPVERu?=
 =?utf-8?B?Vkt4QzA1d3h3L2dMNi8rSWs0eTZmUlhmd3JqQ21KY1F3a0hZN0FLOEZ0c1A1?=
 =?utf-8?B?VEk3YktmNmRiRXpiUUxpd2pZbVgvVGk1cUZjSDNhV0pBanBSRGFZQ3F6MnBE?=
 =?utf-8?B?bmFuMkQ5OFNKcjh3UmlFSGRQTUx2RlJ0YTZ2S3lyQzl2dDgyTUhPcnJlMlpl?=
 =?utf-8?B?SjVkMzJ3UFFzOGIrU3U2ejJnODFNME1PY0lIS3BQTHEwcEhLOENDMjVMajE0?=
 =?utf-8?B?UTlxYXZnNWthQjFBYkhUaVRGT3Zla3dERXVYZW5Na1FSeUpYbjRaa2pHU0Jl?=
 =?utf-8?B?Ujh3VEhpZmRGSW9mTWo0WWFMVUhvVVlqSWN6MUFud04xcWpVOWd1ODUyZTV6?=
 =?utf-8?B?Q3ZnSWZmME12UCs5YU1uMmU2VG1rUDVUOFAwWnJJcnkrZU0xaGdFcjdBK2RE?=
 =?utf-8?B?d2NUZ2lQbG8xTnNzRTFsWXpHL1poTG5LdFZpejczckVPWFJ0bktQTG5CWXJn?=
 =?utf-8?B?SlZMMm1ENVZ0VGp1d1B4YUh1Sm5kRGNRWE1JMFdBeUFleHVVbUU1YTVwM3do?=
 =?utf-8?B?b0xZNldobzB0eWFIT3UwZEFCU0lFWWpwN25wUFhrMTVMeHNjdHFmNEsvR0Nr?=
 =?utf-8?B?Vk12QkY5c0laMFNlaVZUd01YY3RES2ZwSlJXREdQbWlQNUpkcmlMUVp4US9z?=
 =?utf-8?B?d3Ezb3JFRDBhSk03ZTRZYlphSnp3WHUwQTZaVDBpSVpadXdOSkNWMW1GTHhj?=
 =?utf-8?B?VmpHMVhZc2RCVUJXdE5nN1hZWWFoTzNUTWc2enFFbWg3ZkpBUHdiOEJ3UXE5?=
 =?utf-8?B?ZzcrRXMyc0NIQlJZRUtteUVOZFh3dm9jVTZRcWU3cDFzWSt3TU5ObmJGaHdT?=
 =?utf-8?B?MFRycHorRGtkYUM1ZHNkWk5jRE11U1RSaTlKZUFQbUhwUnV2L09MdUJYZ0Nq?=
 =?utf-8?B?Zi9Id1FOVGFoSW1wUUQ0a3lhTWRDTEl2Rlo5eEZZSDF1czEwQm5nUlAwN1lW?=
 =?utf-8?B?RUtVb3czL2F3bGZZTTJCY3pBSTExOXNSdGhaQzFHQ253SXJ6VE82dlN2RldU?=
 =?utf-8?B?dnNqYVVvL3p4Qit0TGRBVkEvM3pxbjRSRUh2Rk44Snh6ajhldDBmZk9nSTJp?=
 =?utf-8?B?Z1IrRElUUlp3b2oyVE81NDYxUXJWaWVROHQ2YlR2L1hGRnJiNG50bGVCTU5p?=
 =?utf-8?B?WlVFazAzRUNrcXpvbUNvTWNZVTFhUUIrTFRkOHZuYk5RdHV4blQrYWdMSVpw?=
 =?utf-8?B?MU5Ia3NweVQ3U2dXY1NCaTFRQXJTZUg3Wnl6RE1UM1dPVFpVdm92UXluQjFP?=
 =?utf-8?B?REE1Q21YdUxaY3gzTmlRUFNFTEx6djR0c1hZOU0wV25BMjE0cEp1Mk1OaGVt?=
 =?utf-8?B?UWUvajBVY1R0QzhBYlRSQk4vQjFYWHJ0Mks4RmwyVGxNR2lPN281MTlsNUpK?=
 =?utf-8?B?WFFXaGF6SHBLUkFoWE04c01xUXdaOTFmTFVYeS90K3NsKzh5WTdpWWxmWTdY?=
 =?utf-8?B?MDJiaHdaaGNLbnhhbUtIemViYWw4RVNEQ3FzV216V2llQWpkWnJkR1pIa3Bj?=
 =?utf-8?B?RmdqS1lJVmZjb0Y5cHNtazhVZ2dJVTdzWXRnL3BhUVpFblNWY1dWMnAwSmxW?=
 =?utf-8?B?YmpaTVY0VFZaT0ZFSnd5bTZFQmN0VjdjcmlIVXcydVNRK2xCQmdqdzBMMXVP?=
 =?utf-8?B?Zmdackg5eEhuSlVrL2YxQ0RIYUc1OWtkbUVWSE1kTTU2MktRN3h4aHhRQ25x?=
 =?utf-8?B?RUZhcnNWRWxsTjI2ZGZ2QWFvL2dBcGdpY1VaN0Z2MlpFaUZmNzB4akVoUTR1?=
 =?utf-8?B?dWF2MHU1d20yL1FyK3dQV0lzZUEzREZNNWRRUjN5amZBbEVIbURFYTg1TCtV?=
 =?utf-8?B?RVUvQytvMSthQytaQVRUemdxTXhoYnZGS2RhWTBWTDFKbUhHVUtxN21ZalNI?=
 =?utf-8?B?cDd4RWxleGhRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780fd391-6f85-4448-471c-08da086d4095
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 23:24:15.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+GFbLiugo4OfnGLYepqnBhfEjjGiVVb7DLMbuvaMzHWANrbptFUjoAPrabO1811TIMGME98VGkQ1QJOiKeGm2AX3Qy0PFoqqlx54gcdVro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2951
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203170128
X-Proofpoint-GUID: nvZvTUocifybEdKsbNn6wdBK7dJ4_DxK
X-Proofpoint-ORIG-GUID: nvZvTUocifybEdKsbNn6wdBK7dJ4_DxK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test creates an xfs filesystem and verifies that the filesystem
matches what is specified by the protofile.

This patch extends the current test to check that a protofile can specify
setgid mode on directories. Also, check that the created symlink isn’t
broken.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/019     |  6 ++++++
 tests/xfs/019.out | 12 +++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/019 b/tests/xfs/019
index 3dfd5408..535b7af1 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -73,6 +73,10 @@ $
 setuid -u-666 0 0 $tempfile
 setgid --g666 0 0 $tempfile
 setugid -ug666 0 0 $tempfile
+directory_setgid d-g755 3 2
+file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 ---755 3 1 $tempfile
+$
+: back in the root
 block_device b--012 3 1 161 162 
 char_device c--345 3 1 177 178
 pipe p--670 0 0
@@ -114,6 +118,8 @@ _verify_fs()
 		| xargs $here/src/lstat64 | _filter_stat)
 	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
 		|| _fail "bigfile corrupted"
+	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
+		|| _fail "symlink broken"
 
 	echo "*** unmount FS"
 	_full "umount"
diff --git a/tests/xfs/019.out b/tests/xfs/019.out
index 19614d9d..8584f593 100644
--- a/tests/xfs/019.out
+++ b/tests/xfs/019.out
@@ -7,7 +7,7 @@ Wrote 2048.00Kb (value 0x2c)
  File: "."
  Size: <DSIZE> Filetype: Directory
  Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
-Device: <DEVICE> Inode: <INODE> Links: 3 
+Device: <DEVICE> Inode: <INODE> Links: 4 
 
  File: "./bigfile"
  Size: 2097152 Filetype: Regular File
@@ -54,6 +54,16 @@ Device: <DEVICE> Inode: <INODE> Links: 1
  Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
 Device: <DEVICE> Inode: <INODE> Links: 1 
 
+ File: "./directory_setgid"
+ Size: <DSIZE> Filetype: Directory
+ Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
+Device: <DEVICE> Inode: <INODE> Links: 2 
+
+ File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
+ Size: 5 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
  File: "./pipe"
  Size: 0 Filetype: Fifo File
  Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
-- 
2.25.1

