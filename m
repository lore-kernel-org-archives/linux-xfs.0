Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8214FC001B0
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 00:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjGRA6n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 20:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGRA6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 20:58:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486B3C0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 17:58:41 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HKOLi4023703
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=JCI4uVIfPeG1GXSZdmDIZW1voCkIc3q465OonI6frOA=;
 b=yVu/XHwkSAeerHmX18gZanYD00tIxHCUJEKR0PeIG9sgBvyoMMh+C058HMX+8UcpQpLY
 ETkwtKWNop6CVo50dRpENr1xWzdSIneZcx1hLtVQxvZ+kXtNstqM1bGwbeDT2a6icq71
 VH2wFFr5kzwkV2Fjbqh5WQx+oJkOqwT+JrlCG2m0hjAXLrre/0geJ+p3xlBDEmIlBm3S
 E/xKEcqpJlE+ZJcH1CYMy5rbg2yia4xLsUn267atmDRVSzALMvv2ntSX5VMoQuNOhseH
 cjsWIy4E6UDBMdqxW7Fnx+wfVRaXcSfLRl4raWu4VrhOYp+0QnqVlipfTiY0Y7ivvvAO Dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88kyg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HNkg6f000870
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw4dh4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 00:58:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pi2QylZ/YyvB7MgAy5chzbAUsaOvtNf1IzC1jKps/QKs1XTzD9W66rKONxZGuS8opuQvR5uUdlOgRYkycurQTgP+JdDQnq9IDzcP7t26QW+WzNxBXLMe5aLipozBqlKp5qlJQCpYuBfN6SvpkZvGgXELD0vN9OZJng4UwfxSxvo316CqDjnHYn5yC3KQxA2oyIwyuIvm95lJqTpguKZhIc3sL8Kvw1IdqBiXwrS0zFf7hjaXtlCbfydBG3nvRCACoqiYBb5t2ivSXJFsI8L5Xb7avyJ9FxN6dVl6nM95tKVD821J5hDFs3lI9qjO5Hp+Q/0QKEaChIPmwG7yi78leg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCI4uVIfPeG1GXSZdmDIZW1voCkIc3q465OonI6frOA=;
 b=gYdbFRUlFOKXW0EvWiXyWTaypO19MT6DT2KPth0aIe2RYEk5/sSGgqcZwa2xTBaIhynlA7kHLR2Re5y/z5KlsbZuOdnNeSsbvzIJ5j9NrvgO8S/v8uab1WsQQAkB/GC60l3zg4ZFg8aMxKMcy+h9GfPIsTbK6wOg05QzwG9i6vu3a8TSZ7rU+zy4KlSFPGQh8/LbsD0ykJSfiBOsU2a9UUUxZTBC7lspa7jUhHt5V87p5ZM8uQ0Cbm5XTGUtdJ5pb07LkIkRATBT570GRKj8FQ/mac/IsQFBk5NWqr88g1NBrHrZe+AP5S2Ur0bb6gH9SJMl19nmpwuEIQt8I31WVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCI4uVIfPeG1GXSZdmDIZW1voCkIc3q465OonI6frOA=;
 b=DhRDhxQUSoNXGjw1dyfuWLik1j9nDuaVS3kiUA8c4RCbkgW3qEyo2JFk+2h2IWAAMCEjRT+Ae+leIv/5gDXdFlQbQQ4jh/75QZxLdIFs6aZ0ykMe9uPsvMeJra/HRn+bW9U0qp/ihkfTnfker/ARwkobbiCRbo+SNweCC8lpsDM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6012.namprd10.prod.outlook.com (2603:10b6:930:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Tue, 18 Jul
 2023 00:58:37 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::c1df:c537:ecc:4a6b]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::c1df:c537:ecc:4a6b%4]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 00:58:37 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 1/2] xfs_db: create header file for directory iteration code
Date:   Mon, 17 Jul 2023 17:58:32 -0700
Message-Id: <20230718005833.97091-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230718005833.97091-1-catherine.hoang@oracle.com>
References: <20230718005833.97091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:a03:338::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ae8cc8f-813e-4606-0e7e-08db872a1e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGPDrdXvfC+rc1h0VIzKfhh2oz0Zf92fL0kHs6mW0Tjjr0e9fHIRzaMbQSQLaBuL8WT0SM5Ya2jjqTRAiwfTTCXXxUjhovYpoYOgXFB1q/HrEs0FCWTlJ/NDx9lCGiCHc0OkB8uofHtCKN5PEiy0LjpsBEnMmxzo72O8QC+0asdG36UGk+kTAW30YHqCAoktnfDNaUhJSphedmIKk7j6IIW2pVKpb2nIauepk81dfRbx9m/T5EOci0DBZr9lNfLiwsO8LJFGDC5i6Z0u2ClLZzhxrkMuMswCq3XqXz/hPnDaGwbc+Qw9m0QgkGjr3zItfhrw4R5yURlD0R7sSjSwXlRvqHEGrnaqNpqeV2l38tZTlWU2UaaV8G6SrbpQuTPGvfRr7fJmSrfqY80k1abh/pnAblVSKHk/IBXjt8Twre1AAK58gCoLrDFz3kci7BYHJ6siPaB4v7fTbj64m+AqNwrtQ5JHpsu7XoYVi2+03iNwO84QTtEzppE2LSeph+40oTquulbwW5nMH+266pVvKdmPK0RUev4Tz2rVlr94UhJXTIkypvV8UsiwlyBUVVx9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199021)(2616005)(316002)(6506007)(1076003)(6512007)(83380400001)(186003)(41300700001)(6486002)(478600001)(6666004)(6916009)(44832011)(66946007)(66476007)(66556008)(38100700002)(5660300002)(8936002)(86362001)(8676002)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oNCLV3QOyvxOgztQrukHb2vpKWahbYgSQYxPEQdx13hy0nj6LdTzE+VteQTT?=
 =?us-ascii?Q?xcBZ6LJM0G4e77TzrVKQFK5i5EKhalB8+MwObMAJvi/zJg8HBT7bNHvIDkPW?=
 =?us-ascii?Q?fUMAnToyIEIGAZgW5kFVzs0pjt5za8Q7ofowBCzluTwMK5Zqs3zff9GGCHb2?=
 =?us-ascii?Q?mW9lqz4DAq7XZTZ8bce3GDCl20/Zn2UC96OlrHVrOu2W5YRlhIy3nMxv3PFM?=
 =?us-ascii?Q?hI7ezUto+Anh0hSmYv1fy0KDtJMh63Tjpfte4yBMMVbmJ7WU1oFI2F0fscEE?=
 =?us-ascii?Q?glsnRlGgZBhjeTkus4+XU/uQ5PTni9kPozkMz9zmCepH9PImySB5OjEG1wN7?=
 =?us-ascii?Q?CR/RhRyx+lKxgpwZOOqbE1XnxNvtbCKHWZf3tDWOOYvgSP1Kp9iGxavawY6e?=
 =?us-ascii?Q?V3KVU6R/ZllI+kxJmRcLewaIzU8iudnule5x/vm1GJXtUWB2zkdo5j+vtwot?=
 =?us-ascii?Q?2z6w/+EYqZvgbQvJF8sOgyjYEm+rPCd8iqjK12tD4wL3QwgAiuK/aL15OEkd?=
 =?us-ascii?Q?wrk7h9SgrLKr9FkFQ1KgpahdO3Q6naM356xyE1pBq6xaGuCyN09aMGr6yLYh?=
 =?us-ascii?Q?iiGNf21l16MO7dIi7UBj8rUTOdtLZleHg0cQLzpInZDaWvIqq9qLhQ8XuHH1?=
 =?us-ascii?Q?/bHk2eolR4xT4YSIgZB/aht9/SfdhVC2SWF8qsOs0n9VTlm+Azj7WgkoN2pW?=
 =?us-ascii?Q?57ImG8/Ce2EILZVMVO0nW70TBJo2jTGyJxKpt1bvoTeT5pwV2S8cq6ChoFsW?=
 =?us-ascii?Q?71AfRllQ1F4VXSIIjuravRrTbbJTpb8Gdv1pgGtgPKSpzlVFJ5HQHzLFwGkM?=
 =?us-ascii?Q?U77dczm40oUcN3dZhhNnkaQbCnBTqL/cDo/+31HFG9eYd3BJiH+mHF66JeTo?=
 =?us-ascii?Q?Bc9QMAXo8j9zwkq6Btf+NJZkMBMnRg4bvx3IhjR/I3j/2cbBvFHcDSgyZwXA?=
 =?us-ascii?Q?wdK9k4xImMH7M4kjWX66w0fi2A/zfvuQE5+K0cWMvxGHuHyC8I+GueOhI3xA?=
 =?us-ascii?Q?Z98wyS7Xr5HNutY9SjT5r+EGTXAibCTMqAP/Md38A8Kk9FNflHnrUGx1ooCg?=
 =?us-ascii?Q?QRkcH9nN+CMy56OLcCgaBt2lPglHicVoqF9VHGvhL3GwEN/quio/Dhr1LZgO?=
 =?us-ascii?Q?eNJ/jo1TarIqZuMj2QGBwiW+MJMFXuo/CrMGxaS3V+LtBvsSsbsTxQCGSW3c?=
 =?us-ascii?Q?lH/6ZJN07eMNzw6v6OKnXfu7Au0l4W7j3N/WsfM1HU/9t1JjBfJefVonseSw?=
 =?us-ascii?Q?ieg1xqZNtiM28lzwEoepfIvp3feAf4HtYEoKT3DV+1z5kvroykgK61j9XylA?=
 =?us-ascii?Q?2sVjYM2ZO0X2TEPH3MH30eirV62ZWe13sDxkS9bYOmj0IoVC/nMRaTaWbiJ5?=
 =?us-ascii?Q?/y3GTDf6FfiUtTC0nzzBcWjlSKzBf2VKIIpsRUmd5eCcyJeLnnahx1PZ88I9?=
 =?us-ascii?Q?pn6iVevMnt0z3sYaEq0kztaAQDgSKGhD4vJ5WpvN2mkeDzt37dfXSPsUP3Jg?=
 =?us-ascii?Q?pJ5kbj3ODjqBdXDHeDKOIfPbVBJDEOJR4ZRpxET6MrwyrXZSWa9PXHu92bOu?=
 =?us-ascii?Q?fAvZBV9P0qxWIrj3HMHHJLbGAFUWE43BOHRZFHHEJXy+HUuXFzPxd5wwP1Sk?=
 =?us-ascii?Q?hzIOcniqhcr6B3/9E2JDshbPuP/QFp2FRo658eyioZjmBg6GDI8VRThfE0EA?=
 =?us-ascii?Q?wqkjkw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KHtfm+3sy9QLg9HZ9dS1QHNzjFLlmwDKEFaRndU/wRMW4dyGWgo3xrb8L3sY/sBeyQO5WIqvTcj11rspw//zXXiKwih2HdZVV5tex9RtdocwLNzJt81tOC+2I/E4Jw9V1JNXh7B1cD7YAJPRJ74uLaMwcxpJlVPIFN3M1SLiaTrm7R49IijTG5g2j2tqhr78W67sJ6qrHlAhUKnIl/XU3olDe7d/IIYC5efQd7cFph7Df2jOwA+WYTl5mwSVf5Z0MHJLBHW9eOWZZPTaQO4bALuETxRCgfRTg7P6A4fviyzva3sryCKC126OS6jcSQCl0/MiUpq2kgn/c2qcdZhgtTc4JBf0e2FSfftRw5i4NSmg2ncTAwsxoz5wPzmOb9faBxHfLWTE5aRAcS2PvN2ziALwlLIxo0XqCOqsW17SOL0MMzvascNbjX+xVHA8h24RdKel7HlYX/qw3htO9XcIaEpIgkJUgPDqQs+fpXsteS2X6w5myt4Wj81OhM8fV0xvahSt7CVRNwrGyvzpYDKE2aPY5EejZZyDA/1AmREgwu2aVpwNqKJAIlabA21GBycoFohiOL3GK4G/cEHRUyYvZqmC69QrCvJ/f1YVMRXnGXH/H5gatQkPELFgdtHujlmWqEk0T/JyeHoYUdvyr1rag9BAkMhK6LtmFM5SQU7zUd9BQXKf2m9OUwARMZoF3NlQET8k4cTcRM6CGXxdi0W3pvdI9zAFWVzBeCNWhfECTEd59y0Jl6PAoGJp4Gm93lyxqhfRqRa1owX1BAixzB0l0A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae8cc8f-813e-4606-0e7e-08db872a1e99
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 00:58:37.7799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hK/xPs5zI8JENudEuMSpKBBoF8fqzNGNK/UVLEvkCdmm03oxJUtUwf5YJcookS247U8/TTol2v54ADrq50TDbRBpo2KLJN7ygE19KO5h+9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_15,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180007
X-Proofpoint-GUID: xpXAY_2h0J0ayAHUuUFogshuk5UgIM21
X-Proofpoint-ORIG-GUID: xpXAY_2h0J0ayAHUuUFogshuk5UgIM21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Create a namei.h header so that we can export functions needed to walk a
directory. This will be used in the next patch to recursively list directory
entries.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 db/Makefile |  4 ++--
 db/namei.c  | 48 +++++++++++++++++++++++++++++-------------------
 db/namei.h  | 13 +++++++++++++
 3 files changed, 44 insertions(+), 21 deletions(-)
 create mode 100644 db/namei.h

diff --git a/db/Makefile b/db/Makefile
index b2e01174..07f0b41f 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -11,10 +11,10 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	btblock.h bmroot.h check.h command.h crc.h debug.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
-	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
+	io.h logformat.h malloc.h metadump.h namei.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/namei.c b/db/namei.c
index 063721ca..765f6838 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -14,6 +14,7 @@
 #include "fprint.h"
 #include "field.h"
 #include "inode.h"
+#include "namei.h"
 
 /* Path lookup */
 
@@ -137,7 +138,7 @@ rele:
 }
 
 /* Walk a directory path to an inode and set the io cursor to that inode. */
-static int
+int
 path_walk(
 	char		*path)
 {
@@ -247,7 +248,8 @@ dir_emit(
 	char			*name,
 	ssize_t			namelen,
 	xfs_ino_t		ino,
-	uint8_t			dtype)
+	uint8_t			dtype,
+	void			*priv)
 {
 	char			*display_name;
 	struct xfs_name		xname = { .name = (unsigned char *)name };
@@ -284,7 +286,9 @@ dir_emit(
 
 static int
 list_sfdir(
-	struct xfs_da_args		*args)
+	struct xfs_da_args		*args,
+	list_dir_fn			list_fn,
+	void				*priv)
 {
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_mount		*mp = dp->i_mount;
@@ -301,13 +305,13 @@ list_sfdir(
 	/* . and .. entries */
 	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			geo->data_entry_offset);
-	dir_emit(args->dp->i_mount, off, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
+	list_fn(args->dp->i_mount, off, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR, priv);
 
 	ino = libxfs_dir2_sf_get_parent_ino(sfp);
 	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			geo->data_entry_offset +
 			libxfs_dir2_data_entsize(mp, sizeof(".") - 1));
-	dir_emit(args->dp->i_mount, off, "..", -1, ino, XFS_DIR3_FT_DIR);
+	list_fn(args->dp->i_mount, off, "..", -1, ino, XFS_DIR3_FT_DIR, priv);
 
 	/* Walk everything else. */
 	sfep = xfs_dir2_sf_firstentry(sfp);
@@ -317,8 +321,8 @@ list_sfdir(
 		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 				xfs_dir2_sf_get_offset(sfep));
 
-		dir_emit(args->dp->i_mount, off, (char *)sfep->name,
-				sfep->namelen, ino, filetype);
+		list_fn(args->dp->i_mount, off, (char *)sfep->name,
+				sfep->namelen, ino, filetype, priv);
 		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
 	}
 
@@ -328,7 +332,9 @@ list_sfdir(
 /* List entries in block format directory. */
 static int
 list_blockdir(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	list_dir_fn		list_fn,
+	void			*priv)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -359,8 +365,8 @@ list_blockdir(
 		diroff = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
 		offset += libxfs_dir2_data_entsize(mp, dep->namelen);
 		filetype = libxfs_dir2_data_get_ftype(dp->i_mount, dep);
-		dir_emit(mp, diroff, (char *)dep->name, dep->namelen,
-				be64_to_cpu(dep->inumber), filetype);
+		list_fn(mp, diroff, (char *)dep->name, dep->namelen,
+				be64_to_cpu(dep->inumber), filetype, priv);
 	}
 
 	libxfs_trans_brelse(args->trans, bp);
@@ -370,7 +376,9 @@ list_blockdir(
 /* List entries in leaf format directory. */
 static int
 list_leafdir(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	list_dir_fn		list_fn,
+	void			*priv)
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_iext_cursor	icur;
@@ -424,9 +432,9 @@ list_leafdir(
 			offset += libxfs_dir2_data_entsize(mp, dep->namelen);
 			filetype = libxfs_dir2_data_get_ftype(mp, dep);
 
-			dir_emit(mp, xfs_dir2_byte_to_dataptr(dirboff + offset),
+			list_fn(mp, xfs_dir2_byte_to_dataptr(dirboff + offset),
 					(char *)dep->name, dep->namelen,
-					be64_to_cpu(dep->inumber), filetype);
+					be64_to_cpu(dep->inumber), filetype, priv);
 		}
 
 		dabno += XFS_DADDR_TO_FSB(mp, bp->b_length);
@@ -441,9 +449,11 @@ list_leafdir(
 }
 
 /* Read the directory, display contents. */
-static int
+int
 listdir(
-	struct xfs_inode	*dp)
+	struct xfs_inode	*dp,
+	list_dir_fn		list_fn,
+	void			*priv)
 {
 	struct xfs_da_args	args = {
 		.dp		= dp,
@@ -453,15 +463,15 @@ listdir(
 	bool			isblock;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-		return list_sfdir(&args);
+		return list_sfdir(&args, list_fn, priv);
 
 	error = -libxfs_dir2_isblock(&args, &isblock);
 	if (error)
 		return error;
 
 	if (isblock)
-		return list_blockdir(&args);
-	return list_leafdir(&args);
+		return list_blockdir(&args, list_fn, priv);
+	return list_leafdir(&args, list_fn, priv);
 }
 
 /* List the inode number of the currently selected inode. */
@@ -500,7 +510,7 @@ ls_cur(
 	if (tag)
 		dbprintf(_("%s:\n"), tag);
 
-	error = listdir(dp);
+	error = listdir(dp, dir_emit, NULL);
 	if (error)
 		goto rele;
 
diff --git a/db/namei.h b/db/namei.h
new file mode 100644
index 00000000..2dc81d33
--- /dev/null
+++ b/db/namei.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023 Oracle.
+ * All Rights Reserved.
+ */
+
+typedef void (*list_dir_fn)(struct xfs_mount *mp, xfs_dir2_dataptr_t off,
+		char *name, ssize_t namelen, xfs_ino_t inode, uint8_t dtype,
+		void *priv);
+
+extern void namei_init(void);
+extern int listdir(struct xfs_inode *dp, list_dir_fn list_fn, void *priv);
+extern int path_walk(char * path);
-- 
2.34.1

