Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF76BC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiERAMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiERAMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228D049CB3
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKcwet031717
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/n7iajgJHdtldH2mPcmRZnuDPYIHQ5tDZBE/gr1ak6c=;
 b=vvg03NnkaHLNWaQY4HN7mheSMJDnFkk1Lhovsz6OUYepYGH2bknAEYHT4xy9LguNxkNw
 VfEhdVvKHWPyKU1ZgzGBjj0/CbrpvSEWxpB2Qzq9+7it01COgUEra2eGYYbVaLYJE6Gb
 ck7n5M0q9Vzx5mak7XbhvIX2INxaQzPngV41CaSwphL4nSRCMjjkFykDG9Rn0KPZa790
 4h7dnsajvHn8WY4OXDgjVFMs0SF07WPrT7/ubmOZK2VIKFL3nLGcwjucRwso7zIJR+Q3
 s8gs3c/Ylu3V586ZL+Z0OlXTwJpGn/DiPAhWXG6r+2hmjoWXtIHlZ8vMAHrAU44uKntU vw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aafptt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BhWD008599
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cprqmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkMi176uO1U3C/SuH/W9w+cN9ZyklUBuDquRjZA4BPW2JO+EivLHpbb5NQ5BTn+pl2Jj/cbc25sCLg1YZGF0HMgspiuI1S8yqACMIviFnPY+hgZs5EQfnOQ7+GGtFIFrcTlftKWsRu5bMS+Bq+TJH0pCLfesbjQNsHmtyIxto7+X1ZFN8xqPIWHOoIvVStqLd11H+nYleEjMY0G2QuaH3Na9dbW/dOSCquR1dp1dYcKmnsnW7qYcqL1M2BhMpWXceOYFPhWBiggnKgacpRf26EQ2tmFS04na8UzSmBL3tOLqsytyTCsQOnhS5wYm5SnGoxRfjlr8e6tciP+R1YQvxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/n7iajgJHdtldH2mPcmRZnuDPYIHQ5tDZBE/gr1ak6c=;
 b=af9Kuv1TXwS2AuSDfQbp1PmqM8kczuZfXiFv9nYZvylNTpa8CzQLORTYhKsJLoqZX7TLYOc47jDfBSIB7UoQFJpFrdfOnAS0u3pc5v5Pen/iZpgMb/cNicyh2J6d/fJ4J4d+fIYcRBHl7f/lIVABno5Lh7FdbkX7GediBvlL38/ViJSb3Zkd/OaooqHlUsNKaQTDvzL8pOxuboclw6qH34MAaJx5poknlpZomMzBTXT/SK/0IXZb6/kKzCQs6fG5pg6PMr3sye76iwGGZS/rFfhz2wElagHpNzi8rwbE7X5K6t+hPnuzI6MzegNhEc5lpOGAS/VO6PHE+++zaotpcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/n7iajgJHdtldH2mPcmRZnuDPYIHQ5tDZBE/gr1ak6c=;
 b=npZnHeFuwI42tY2caQ9hc1dIT20zhdPg4x+9kLapcTdIxpQFOweYWGxtHU9phF6YnzMZdA8Ev279UW8b6v8hqHDggfExWWd1ZLAtYcI1yT1MUOVcSs4xLLuMk+20N/uWCDcVM5jx7DmHV5M06xblARBYWS9VkAqR8A04BmMhwu8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/18] xfsprogs: Port larp, enable injects and log print for attri/d
Date:   Tue, 17 May 2022 17:12:09 -0700
Message-Id: <20220518001227.1779324-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f74ad7d2-7039-4b96-dd2c-08da38631b3c
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528F8E04D4A3A6FBC8D98FC95D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6XYBPOxuNJ137gG/Np6kWtCsnCoeN2vs/HeGnVPBSDxqL37trjIusgzlWj6iEcL0KgSvt+8IcKDZx8FiM/EsCq4xDus7b7Bj5JCCuOpkawYZDssUdxSbT2BJ4OL+Y2u1tn2WV2FYqoUk3p6vwdiCuVnEGm3Fj+hxlE9ey4ReV3YJ9UZPTRi9n5RfQtxeFhiIhUL//lpdc7svRzrYr67x7BgqRrjomH8/QFMMsCAh8O0BApUeqrhx51BToSVedI2Jqi8HVWVgENRyY5fFXzwWZ8TAKo64Izq2SW9DXl1iKmHnsN5RVLL46xkH2dhW0WFlVxFcgR5cPyvNw9Tvm0zbv7OoAMN/c2i2V1tR1UsDBe4lCGbIWNGGkQqfhVSR2yHqmtDTzaKLSPw9XN2kOJTBhQmrCPz+98drfd8VZOEX7xhtwIRnXzfleh7/uZ4sBEYcDjPZ/WkmlslBDl9I+WOeMhcTXi9U4SOxoUL/I7nowLbAj83dupOn4O7oqlCoqZe7/vzf/RBbVKDRCNr4Q6f/CTy4zXODr/Gp9HJ+BXat8zVrJgKqb928jmG8gj7DEP/eMKcoJsUV5fkwS7J9DgCnt1QOTCf7rqTHgvNb2PygAO+CHfacWULVpwy2uiDmjksQYR7dMesirTTpSnHRURMhzZu5RSXQCbWbtN0+aUWHzKWpp1Hdt7jAAw9Qy2gNXQj097yWS1U4urobiYeXzThvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PVDq5yLvlTY9/0v/YsIJZ4vmpotqAclM97Zxqqr8N7l+HSCiDhclAOLs2rUJ?=
 =?us-ascii?Q?+Ljvd4dozku+fUOIPx6xYCwjvFw8YfPvh/Ck41N7wB++juxISvsA8ifuj5Rm?=
 =?us-ascii?Q?j8cszArqjNHqwBHIm22Pim3NPMuzkCXEe7xSSdra+DnQAsS8fRgc3hUWP5hM?=
 =?us-ascii?Q?TWeME1lNnQmsRtL7s1D0juiJOBPGvJdPH2AncwgMylOdclOMZHR9/xNNfiO+?=
 =?us-ascii?Q?ZVKJ/Qi/BA1ldC9u/0piQc1JVImIsEETPacF7566Vp4N1w9XnVb4BAEO90hR?=
 =?us-ascii?Q?wO58cn1oRt+rnlXZ4whPStLXY5tHwHsaMYLITRELAgVAxmjxljWBpFAOPw2k?=
 =?us-ascii?Q?ELZJ1aKtTtlj8W7vIh19HGHEF7ZXYuyKtcWQzRI+OqWABf9BIdOYnIXZoN1m?=
 =?us-ascii?Q?yJzwAXrg/XYZaKfG622G0jCAHaShEkdrhvwnaVHgNxFG4zl5vIWiLFK/OB5A?=
 =?us-ascii?Q?q0SJIi3DOMsgOHIOrn1QxkFMNOAL2HKTqMVdvEsnuao74ZKcLv2eNpOoM/c+?=
 =?us-ascii?Q?eCOVRvzJolyoRvmghP2RgCQKA+4NiX+QsvPgsF9VWyPAT5hZrxi3aOzttg8J?=
 =?us-ascii?Q?HAiNtkRSRxgCMWHcO/Zv70BeDzR4B8NodItU58Vu8pb0GdVchOJPLmC0r9MI?=
 =?us-ascii?Q?xWxig4ZjCvGL44qKrd+lNi+xMDw3Nn+4JIT1Yk8quQFrM3b95r3661awUD/D?=
 =?us-ascii?Q?anPE1/XBtz2Tq+MbiwcL30Yj0dcLqCOhTNGewkb0f5qTMzJhedZyANRoipBf?=
 =?us-ascii?Q?b+wOgLjgNhLvDj1q99bitceyXEibaWGzoH27RKW5ZcglPMxy+pdD273peiyw?=
 =?us-ascii?Q?53lFMfioneuLG3GozoRgwnyej20P7nvzPF+xcG8zbPTfe72Og4mWYrvNg82Y?=
 =?us-ascii?Q?dWSFoRJIYsnt0sHdhu+rhs78Hr+f6KiXgmPInD41mDg61TVmM+Lymz4aqcw1?=
 =?us-ascii?Q?jptu4MiJjvioI3bkj91Oe7BpbECOrPsAcFptH6LxRcijTp18acpEXDlxIkRO?=
 =?us-ascii?Q?KUmsnZhGCIAalAsoq2QvcMKfYbaWFBtVQbACAWEfU4NUlfmnEb+5MM1/I4Fi?=
 =?us-ascii?Q?50AP+WG51n+rWkR4QOABrRjznRrrciNcU+4uJElJ3vO2cbYEF8l6IT803/Ja?=
 =?us-ascii?Q?fFzglXHvSiuEUvTfyYA6/U1+IONzDbBXgDsH3GqVgWUGesepZOo4n2Gt8fYx?=
 =?us-ascii?Q?S9UbSWEI1cDj930MKN4+Dx863YYbNcjqnkaqA1QiNmf01EaEqKIslh4/qE6i?=
 =?us-ascii?Q?9shayIPdK/JhEteD777srsCZ2k2SBIFg6MzPpPpEQQVR7AgRmWn+Hj+CttRE?=
 =?us-ascii?Q?C2MVMBsTm/Yed1a5qhBgK+RZ9xPkzoE5elqopcOdgy8/r99XhDsvEaBDzww8?=
 =?us-ascii?Q?il2v52Y6e1xgebLavayEB0pN1eonUJUY/NEBXlrP4Sl/KWCAEoVOsYg4o9HJ?=
 =?us-ascii?Q?cvYh6YpqNKbM5ZXKpMo0QHkTPR11FBLJVgr5oJa+NxiAKHavWJqJJ+9Czj+H?=
 =?us-ascii?Q?7rPondTAyDJT9iuCXsSwgPq8FsWVwRZ3Ryz/Wd8vmhWO6c+oD4q7W2TbuBJo?=
 =?us-ascii?Q?J1YyKzJVSDjQz6n4TQGYFzngjkbqPhlrLp6br3TmgSe6zflxf7NooGDF6C6w?=
 =?us-ascii?Q?bj6atCI6tkOnVbtjvbPevtkrl6Ni8Er9uCQ4Pc1WJmz9KVIvWzh1kWNUpjBD?=
 =?us-ascii?Q?Gw+8RFbcQVgBksjQ+/1SGfU4u2Dllt1+wbc70w/jNth9GiKlo9C9wSfWChX7?=
 =?us-ascii?Q?RnkC9zFkYbHuGHRmSw1JJDa/0hkvD9M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74ad7d2-7039-4b96-dd2c-08da38631b3c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:33.7968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+6aD5toPoC3lJTjmyWZUed05lMomPmOlVSZtpczH5rv8djAPzsXmkSBV4IjjzagSajfOz5nqNUCnr08QgOtj+zl60yhJMh8+7heEtqq5UU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-ORIG-GUID: uMu4gQP059kOCqHiIDwjDuJtoyuqcud4
X-Proofpoint-GUID: uMu4gQP059kOCqHiIDwjDuJtoyuqcud4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set ports the initial larp patchs to xfsprogs.  This will
allow us to print the new attri and attrd items, as well as set
the error injects that the test case needs to run.  It's not
clear to me how or when patches are selected for porting, but I
figure this will get us started.  Some patches needed hand porting
as it looks like things that appear in the xfs_*_item.c files
are ported to defer_item.c.  The last patch is new and needs
reviews of its own.  We'll need this before larp mode can be
enabled in the kernel side.  Thanks all!

Allison

Allison Henderson (14):
  xfsprogs: Fix double unlock in defer capture code
  xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks
    to process
  xfsprogs: Set up infrastructure for log attribute replay
  xfsprogs: Implement attr logging and replay
  xfsprogs: Skip flip flags for delayed attrs
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Remove unused xfs_attr_*_args
  xfsprogs: Add log attribute error tag
  xfsprogs: Merge xfs_delattr_context into xfs_attr_item
  xfsprogs: Add helper function xfs_attr_leaf_addname
  xfsprogs: Add helper function xfs_init_attr_trans
  xfsprogs: add leaf split error tag
  xfsprogs: add leaf to node error tag
  xfsprogs: Add log item printing for ATTRI and ATTRD

Dave Chinner (4):
  xfsprogs: zero inode fork buffer at allocation
  xfsprogs: hide log iovec alignment constraints
  xfsprogs: don't commit the first deferred transaction without intents
  xfsprogs: tag transactions that contain intent done items

 include/xfs_trace.h      |   1 +
 io/inject.c              |   3 +
 libxfs/defer_item.c      | 124 ++++++++++
 libxfs/libxfs_priv.h     |   4 +
 libxfs/xfs_attr.c        | 484 ++++++++++++++++++++-------------------
 libxfs/xfs_attr.h        |  58 +++--
 libxfs/xfs_attr_leaf.c   |   8 +-
 libxfs/xfs_attr_remote.c |  37 +--
 libxfs/xfs_attr_remote.h |   6 +-
 libxfs/xfs_da_btree.c    |   3 +
 libxfs/xfs_defer.c       |  41 ++--
 libxfs/xfs_defer.h       |   2 +
 libxfs/xfs_errortag.h    |   8 +-
 libxfs/xfs_format.h      |   9 +-
 libxfs/xfs_inode_fork.c  |  12 +-
 libxfs/xfs_log_format.h  |  44 +++-
 libxfs/xfs_shared.h      |  24 +-
 logprint/log_misc.c      |  48 +++-
 logprint/log_print_all.c |  12 +
 logprint/log_redo.c      | 197 ++++++++++++++++
 logprint/logprint.h      |  12 +
 21 files changed, 833 insertions(+), 304 deletions(-)

-- 
2.25.1

