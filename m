Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA8BC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJLBia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJLBiZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:38:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5ACF60489;
        Tue, 11 Oct 2022 18:38:22 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BLhmJI023550;
        Wed, 12 Oct 2022 01:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=CNuFs+DtxIJ2ELqymW1Okf0JBQ7bf+OBpwI+f9PkDIE=;
 b=oTV8PoOkIWBYaqrH3pC3xZ+rIdcK27MpC8FBYaalSIS9qedHL7BfXTJLOOlYej/VQXg3
 KLyZ/ZtKSY74vDTMovNvTgbB5K2NV35R7eABcGwKkEr9otNYTMMMwoSLIYtK9sbGeSmz
 +OOMKPXU4uZ0OupQEjG+FiCikiljLsndWrgkw0Q8OQPPWaZsdrZLo4LmBj5A2l1FEEjl
 rRvYgE6Z6O6AY34Y/bW0wUKWc17MVaCY6cmkwd2HHViVvpM68B5ImarybZgQ80P8/toQ
 hHa+EJzWEX/HMMEm0XgsQb+zo3I0wAjgLwqsrc+NaWMv0FoP/53GXbpb6eH0nuGqkai4 4Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k30030ge6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29C1OZoJ021914;
        Wed, 12 Oct 2022 01:38:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn4mevw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPdgqWgb76NeJkZK11VPGxJEWfh+qJ4TOsQg1TQuTyvcc1DMrq7zNFwsINQ5nuW0BhJS2HJ/+dA7a7EuhrrR9J36EGlfvahGGrourvPx63KyxFmis5IDI+swhL7R30R2yPXjeNWkeZ+qDC4njtwgWlVU6Ki85HUfA1NxLrEjnBLXT4dc0W2M3cVvkGtLqLblLnf7ldvIrKC7UI1F9E3cihTbEcpqwuXKoly4c26FjMHxs70ckXQVODLn4r61jmiPhU8xAe0DZeOsa4sJpV4pqYqYk3dK3TZnCaMDrB4T2Ex9+ursGUImX9gpsnclvHaDwbanWvCzbBzQKrTdcz5LmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNuFs+DtxIJ2ELqymW1Okf0JBQ7bf+OBpwI+f9PkDIE=;
 b=g+xjb4X3nsJk8SeAu89j5G7LK3bfMCrMpFGr5IQ1KIVdTP+fS9ReoVH+U4Zhb2zAwWvjwwUN8tySw4xTen9Mrn4ruoRrlkqC8E1aNOuGh5EIqKIcmgC4wnEtpJJuGkCvGMkVcqe75+bXmCxMzqBDRQrSZ923/a1ZaXabWIeKJrz5demhBLwzIgvSzQuneqPHbHhGMXcu2znLvH1FbrrKWPWt/LuAAd+Qg5XixOnS6g4gh7AONEu/l1MThRbDDzXWgLjPBWVfcfII0pyjsKVk5fPMmjYnou2Z/HdN4J+3173TPRfoeKgw7uHc2HwCVyjdtV8mNzg+7Lj8tuIKKhPTkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNuFs+DtxIJ2ELqymW1Okf0JBQ7bf+OBpwI+f9PkDIE=;
 b=pAXfHz/bhDvFbVHDL5tDla1kGQMOtrUy3/jMNtiINzds68PzhiYY/C6blbCQGqgsADLh3jlx0nT7hDgZcOg81BFHwZj6jiFDhR9vPO9r0t0TOLjfFKVIHTOTJEdZSdcAjxJlfg2UjO1NOnR/DL0gY93mbYGmQ35PnXWiipu1NXE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB5686.namprd10.prod.outlook.com (2603:10b6:806:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 01:38:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a%9]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 01:38:18 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 0/4] xfstests: add parent pointer tests
Date:   Tue, 11 Oct 2022 18:38:08 -0700
Message-Id: <20221012013812.82161-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:40::39) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB5686:EE_
X-MS-Office365-Filtering-Correlation-Id: da9579bb-4a35-4545-38cd-08daabf27084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qpend4aC3BkZhShId+HT/z2QiCCWrqLTnz452+Ksa15IzEkZZ4VH2PLr4G31YBrlER2vMRLKoAVqMtOITroroEzNQZYgBR/yr3W3nv10NUMiQ7RIYmEx65Uk9Ofxjt7vTQ/SAQbBTOWKtpr0OfpPcqeuqXTK1+cQV56QCuQVKpjeI78YksvfmqB/LvjFJgoJcaI3dWNW5gNen3mZrFUmSCYbADrjFZDM8O456LnpiE3ME0ZZoyrom9FBoXKQgj+2eADG+sdW4uJRX09gBjdLJmD9E1rplfbYOPdwjP2HbWU267u398Q7OYBEYQ4kZFMLLdQLIeLJ4mKKw/JLx1i6jW0/WzMtm/AqsTTzGCF0HwiXe/pceaBRm4mBQi3AtAVbgEdBYFq71zamHMR2l0VmlKgl5MTqqFJCDs3FloTpTlPf2fLVX5+b34WC0DUjDUCJjp2U3lWlX1/t5BQs+vhOJ3HPnjXETIE5lnzEWqKf3t2nvkYaYx8cNbmCvZ2d2jzk+rxtBLUbvbojIT75/xR94PDupnesCF2w+WewPmWMPGqG54bsGYB+rv8mbU9H4XxC5QBDU1A7XQ1v7rs8TBo546XfLanWBtQ3ZredpSgjVdJAelDi4BX/kDGBqWTYwpOO/EuCGWPDc27Ubyj29kdPFU3gBU3iMkZBMT9yT31LIl8LosFluMZKKCMvS3sTwqDLZIUNxFjgeZFzbMnzMA407xCPcg6LZ64BTa4HjNDGs3c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(6666004)(1076003)(41300700001)(5660300002)(44832011)(478600001)(6512007)(6486002)(450100002)(66946007)(86362001)(316002)(36756003)(66556008)(8676002)(8936002)(6506007)(2616005)(66476007)(38100700002)(186003)(2906002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cJIiL4+SJFAv7LSjX1BiiwzgwrPwmk9YW5pKLTxXh4DbncXul1E8Sqau0aNX?=
 =?us-ascii?Q?f+IMwc/FMAAC1Vdfz4PZdNub301A+m+aR7Yxe8BOe9dQRA9gSN+SGGtEYG5r?=
 =?us-ascii?Q?ZkkL2eu5kN1USwfdjlblqgQEyzDOD6BFc9bd7mSMUlau+3vz6osaYUugFicb?=
 =?us-ascii?Q?JT1KnZ/AzJo3H943QN5x21q0EdC0RkrW/ZWsMOVjo5jtD8sUW5yrobJOZh/e?=
 =?us-ascii?Q?9Kx/ExP6znyA+E/vQF0/PGBeyf63P1UcZSwuXj98YbKGD+SGMXxWdSCQnflt?=
 =?us-ascii?Q?8Lyl1jG40ZLuf5r1e0gtcM+l/K0krSu12LeB9Uxg9U0t8jSINgjvO31730u4?=
 =?us-ascii?Q?4FdWZRKojuaajGbP0pGdy7OuLl+KM081OhUhnhwrzbDIs4o4SksK0OZTcm0y?=
 =?us-ascii?Q?ms5MkEkNMltSJDlZaGbmPgFDThcFZAmrmV/YwlBM64p7epvygcub2own2qdK?=
 =?us-ascii?Q?NELsVJxRTAl3K6FN33o9CewpLlhh9aBORMHpoObDeswdS4Id4lynGaHxQBTT?=
 =?us-ascii?Q?yaCQcW/7VsV+ZH74oOed8rdAM0AZj8pD4GzqIcnlA7zj5UcA67UgczExICqv?=
 =?us-ascii?Q?lIA7gIKjIFsvIoxgp98SUuke9+tgwxiTDdiBGQfma8ytLAsfRqYmwwAWJpuc?=
 =?us-ascii?Q?YqXnMMtenAya5lYrGr7UAofwWNsQ0GtCNr5uQfZUWawFjRWJRxABIeSNsaqr?=
 =?us-ascii?Q?KgQuapoN0mlk/TpFqye/Acn84fmyV2QwR9uxCjMrejlYoCl+E3VXkBS5oyAv?=
 =?us-ascii?Q?tn7xSBmhLCbEPIcxZODHl5kv7bULe4pPqezX4kb62dBMSBEEd6PbMe8CO+qQ?=
 =?us-ascii?Q?UC5BzyoZ3CUi0RlUcbjgqPROxgykjG0igzwUpYriRUYh8IuI8Ob+qAHOV2YC?=
 =?us-ascii?Q?9Hn+ry4xNCR+pLcFd1GodzwW0OIDruRvBdXDi8zkWu+/NzgjnIA2/TTAsgIW?=
 =?us-ascii?Q?yiI+P8rjg5bMoBZe3SPFc/R4AvyVwHNInwa+SVQ8nB4AHq8IrfQp4ph+e9fv?=
 =?us-ascii?Q?IOO8ubtWCqlMoCWzFzZ48GY7TCeZkQ2pTNx2gdQ8V4kmswBVSFeVhXwThm2h?=
 =?us-ascii?Q?6sD5mOpFu3nAuE/iv0TT8lCaobI0eFlp0z+wFW5T+L0QTEV4WmIPj183y5wY?=
 =?us-ascii?Q?+fsqh2x5OSDZOFgpQT105CgLNNzMLf9XE2c+QnBA2nM1QI+v6qUPj18zh/tC?=
 =?us-ascii?Q?pCZ6acOrNcG6jEt1iWfm4+w4f/hgLP/fNl/2NzwyOpNfkwgjW9yrN1XMJtkO?=
 =?us-ascii?Q?+deY1Rk1EXIsznYzuppspQKrD0CD8nK+mnd3NnHwZP4xr1d0c9hCgpKjSme7?=
 =?us-ascii?Q?LRBE4XZfOBe9MX7MHukCmDUKQ1cB/4EwgKX/Ii/ugTlHr4Z1lUhN6b/AX/FG?=
 =?us-ascii?Q?sIM3V4V+hqlOJmx1GC/keigqpckzmN8yVksiO4ThGB+Xw3MbFahkQwSzE1U+?=
 =?us-ascii?Q?l8kYNL6jpI7a+Y0xyDMPqTAo0zAnmqbovY1DNYm5/S0gQK2K1M+ZZT/ovJ+Y?=
 =?us-ascii?Q?Z85lVkS84G0FaNAg4S5BhD2tqTit5i2dD2COB0TjvSqjZkbUxtGRlXrm3F2V?=
 =?us-ascii?Q?oBNqxsGuEMYVSTgRibc+mh1t6obNxE6XGYpJTpxI4hTzDbCoscoGjUoAE3MO?=
 =?us-ascii?Q?0rzH7LsbYOyruNWSalYHnn/6+Y72xw9tANlNBx0taAO3cPeHPcV2dvNlDdZi?=
 =?us-ascii?Q?hpU0yA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9579bb-4a35-4545-38cd-08daabf27084
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 01:38:18.6370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlsB4xsRrFTFgRPJllGxQ3JpPMvSteZKaJMVLJMVece8hVTenTjQ3Uf6J12dzeZCIRntq1xZijTkP1VncLPICimKmES86w1LJdjg0fKz5Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_01,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120009
X-Proofpoint-ORIG-GUID: bt_iByJc86X--J0vJawZKgl6-2GQ2gCd
X-Proofpoint-GUID: bt_iByJc86X--J0vJawZKgl6-2GQ2gCd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the tests for Allison's parent pointer series:
https://lore.kernel.org/linux-xfs/20220922054458.40826-1-allison.henderson@oracle.com/

These tests cover basic parent pointer operations, multiple links, and
error inject. This patch also adds a new parent group and parent common
functions.

v1->v2:
- Print name and length of bad parent pointer
- Remove line that explicitly turns on LARP mode
- Remove unnecessary empty lines
- Split single patch into multiple patches
- Add _require_xfs_parent function
- Check that mkfs/kernel/xfs_io supports parent pointers

Comments and feedback appreciated!

Catherine

Allison Henderson (4):
  common: add helpers for parent pointer tests
  xfs: add parent pointer test
  xfs: add multi link parent pointer test
  xfs: add parent pointer inject test

 common/parent       |  198 +++++++++
 common/rc           |    3 +
 common/xfs          |   12 +
 doc/group-names.txt |    1 +
 tests/xfs/554       |  125 ++++++
 tests/xfs/554.out   |   59 +++
 tests/xfs/555       |   96 +++++
 tests/xfs/555.out   | 1002 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/556       |  110 +++++
 tests/xfs/556.out   |   14 +
 10 files changed, 1620 insertions(+)
 create mode 100644 common/parent
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out
 create mode 100755 tests/xfs/555
 create mode 100644 tests/xfs/555.out
 create mode 100755 tests/xfs/556
 create mode 100644 tests/xfs/556.out

-- 
2.25.1

