Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAB0FA3741
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 21:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJ1V4R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiJ1V4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 17:56:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DA61DA35D;
        Fri, 28 Oct 2022 14:56:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKxPLC013278;
        Fri, 28 Oct 2022 21:56:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=2pk9oIZjl0RbYWIj7E/YK9M26o2ql180gA426aEeMIA=;
 b=lvwQ3D/eouGs+oo2ybfbBUMFjWl+jtVkTE7Bs0fnlgwR4thAqfHHA6c+u/854xiZMi7L
 9U0vbMz8TegQOklPGA4/RieKxr8iDKb+/gSAvQE5zCY8agXVc/o/Ex8Wd67vegkCYIrl
 OSUVuMxBdvOWYTW8S1/IOeIuv9526/qyuyDr1v1r8/98GDEbfq2LIwVkugNgL0pZAxsw
 hgdqPCZZKj0aUGwV9ea6wzQFq2vmC0RNLfGuKYrVKkG0CkSdzhxNIvkQF0sTREwaH++8
 R9nA9CVdhco0dbYm7xE1MD1TJNRrdiyvEi/RYrHfw2ul3bg5m0x3r4TkIFGaOfl8sxs8 xA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgmsd8dey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKmHV8011657;
        Fri, 28 Oct 2022 21:56:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagsge71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZttMhzIcinQTQ6PR/B0BWYxM4EkjygyA9J8BPShjHBIf0okkYcNLFr4fe9O5mlfXT/b+BvfJ68oivUrSQ8aVJ/PjGKrvB6EraHufpRDI2U3zDrQqT7L7gZYgs0JcDQ6SvLRfs/O7BKl5cvc7yuSSNkNFDyAdiin9xsoeODYX+rAby6RmrudjM3L8aZVgJjRq2WRAM0ZGLW4UoGJzLp0crnW+lylzRlC3++Ci0rA4pnkBaPtB0EZuHoKfl+CXh4ciEGKOW82KjYGx8y8LrslqzqilrQuldjXTz/Svb0OA005sg8+iSj7H3GOGe0rSjEzQ8koeMKIktIAU9hFW6ExAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pk9oIZjl0RbYWIj7E/YK9M26o2ql180gA426aEeMIA=;
 b=Ux591F4PXmpllSthCx3Dgk2eRZgk2C7Fhiyjs0Hsggjg7c2VgWwO6AUOjiwuZqzNpNYOaQWrpsGlycp/DYtJUYeCWcnxgbnkEf3kvVmLyB9GXl+A12yxRFxNhjI9edXdxezDkQ/uxk5L2SGBymUF9EzvtD4GaxsizboAALKGhJzVRIOqL36NeQGru4mu1fCufWdUBhwZbMNSs2tSOsVgncl6j2YkVDOjjAesp+5IVHAt//DuGzp3R7RYMUuCnPHtbVbh8Ko3SBj7+XSZIL6D8pgpd1ltTiVN3Ei2QSQu8QvWqTllvfFjUdKncrQtPptyOZ+oci/3GrSDQ10tvc6yBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pk9oIZjl0RbYWIj7E/YK9M26o2ql180gA426aEeMIA=;
 b=ukwOFNlzt1NztxDxhVASRIhMpMx1e2owfLSIH+2mIF9FWwToXdJEcgwwoPKuwTSCDpWIS/yJN4yAhhdmz7BEHg9Pd7/MIpd+e5ofGi5E1zOrY2A+Ie21GfSxtvAus3HenjqmLGovrqI7ssUpzif9S2ZhJmr8XsWVy60v6aKhwLw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW4PR10MB5702.namprd10.prod.outlook.com (2603:10b6:303:18c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Fri, 28 Oct
 2022 21:56:08 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 21:56:08 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 0/4] xfstests: add parent pointer tests
Date:   Fri, 28 Oct 2022 14:56:01 -0700
Message-Id: <20221028215605.17973-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|MW4PR10MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: da83e98b-d28e-4251-d0cd-08dab92f3803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hw4Qh257cPb+Je/C7/tc8fzrDkd4lzQKblrGmzRQQDdqWua9v3Gqbhr2n+nM+nU0ufm51C9sFj2kE6WndhNjsxnk++fXDrNpWGCJjcXA9e8F+iSygAC6CNbnKNteGMrDRiL0YIQwAk4cHBsRQtQJT7mDPVaiWmtPeJLAxMrvbd36FiuFWN6K8qy1e0pWY4KXfp1sUTKcP1Ma+CVulAG/Xa9MnqJ1liYrhUWZNADVoVsDvmZ44bW5VqPRh9X2BsPz2Bp6h3idQtdtPC+8NJtmobLSmaKQxYzOq6lqNoxhdLR//NSE2ArOSILPdBjiAUF8o5tBI4rvLPrT2diNbNBoKl0J3AL/0hADQtrnpa6VHiVIGSNX9qpAzbVGgSdNldcmjGQy4PdWnAcncpJGj0WBS0iYpYZDAhPR5Cw4Ha2ST01vTDZfM4jyY5x6EyMwJJUm6Y0RNoQ/qgvLSpcBedZ2fyab3ToZirFGO310AMM6wSBB93wL+P5HKTmzp+hOTqLeUCzg1DVgGG94wLEQ3uTKDTgZl/8DvDZkJfdU56Q8qyayEWysoNMhhVSFs5L+gYTVS0YbPtJawFPG+KX2uNqHVGYWYF7TsNyVQyu6f4qgBvmkzHfkBoWqzNORZj+yfklp66gIH79MMmVDA66E85Y6cpGAou+OzHLGtJf4IYA3Hpdqpda5UXZ+vz74+Dt5tceZcs85JqCPhaRtD40whMmT1aLdTHFn8aULN0oPqyaCvic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(66946007)(66556008)(66476007)(86362001)(316002)(450100002)(44832011)(8936002)(8676002)(41300700001)(5660300002)(6512007)(478600001)(6666004)(6506007)(1076003)(36756003)(2616005)(966005)(38100700002)(186003)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DO4qzhaMXMD4R/adA2LHkf09G5gaKpYgUc/68ZP85oYPHWit1W78wvNDqCQo?=
 =?us-ascii?Q?P6BnRuSxRbtRbAKMr5GgfnurXmVlb0jixv1BMrfO9jkuVC208IqwrFD0z6Yq?=
 =?us-ascii?Q?192z9NeCJ+QDSO2TjPbihFy9tkj1DPHrg+mc3ZeT1CY2tuEeDiEl4jrS1yd6?=
 =?us-ascii?Q?udZWI3JbtX6Cl9UXsJTMTMGuDgVOkbcuUKhOimE8C7NNqFNUTr6JHSu77dtJ?=
 =?us-ascii?Q?xJUJk/1l/AlERsP/AkWRcSX0dqK4I5CJIFnbrKyJPzG2Zf+Lf16OJGvFvSEY?=
 =?us-ascii?Q?B8jfRghy8Uzt8ZVDiX2IzRJES5lsDZzeyXqWksrq+eQQgfnICrr3NaUH7ZaI?=
 =?us-ascii?Q?lg57xiqSTwSEZaaSWM4LzB5X1E10hM0sCEvv7bD1DFSCMY1nschM0g724osW?=
 =?us-ascii?Q?lZ2t6ilnIp3lKutXpmU5FoYj7G0Eu22tCQN00qrq30bZZfbhvIkNj1/vt9Ve?=
 =?us-ascii?Q?HxyWis/l4MhfZW1zSm8edjnVSPmO1oAcbLTy7Rn1LZTsWocb4zNmQcSaCQdE?=
 =?us-ascii?Q?Iu6vbnBI6jriDeqUvnWMdUiRr3lQ1kXAZhexOYgDhsqITkXTT2hWKRc4ONKq?=
 =?us-ascii?Q?E0Fucpy4lrnmT7vqzNJJ3kG22+b3QcOzhaDGlyXa+Wl2x7cwVxr+kDYoRTXj?=
 =?us-ascii?Q?wPJFVH36lHmmlbpCTZjgQkWwEa3lTFpXLHOF45pDdPkCVQJxWfSE6pN1B58D?=
 =?us-ascii?Q?aekLDDFxnhomQechjh3W+5njzuK7ikEWylMGWVB74C9iRoGCHCp4mEvtmvE+?=
 =?us-ascii?Q?lCObONfwSKTJvAnlqLWqWcPoFATBbc2YMQn3oSaUj0lKxdjYXexjDY9ev2mG?=
 =?us-ascii?Q?7sDrIGc7voaqKFsY7YHbMxBI47hgd1Oe5Ot1GWwZaFbpnTjW8hZErc1HGiuX?=
 =?us-ascii?Q?kPQWnENc+DjvuhYLFahQcXXUNAT+X+NFVvN4akZJK5l3UMfty4PMEeF2RNmY?=
 =?us-ascii?Q?UsAf72fd0JvBe1lUIgawIr8t7ejIRh9BOgOwiHahnjdcGXbJnO1/q5elWSKK?=
 =?us-ascii?Q?DVdFkmGKt26LQORAAKh//C4bEKam1IVx8tcIA2JOVPY6mQg9jpNqbUh4m67K?=
 =?us-ascii?Q?RUeR4XMPHM4NAv1ojvKcVf2r4UAoCvqMqseA3pF9lfapayhca2WHO6cTleQR?=
 =?us-ascii?Q?2FSWEUjFXrjmE65QDNi1nYkMTfxFHAkFOYKzgJeKIdeyvLlenveTsSv9NNfB?=
 =?us-ascii?Q?oZMOy7nqfYPZvCq2A6iVTLiMwQ8bzMm1tr1jqGLPo0siZrMCvlGk39HrGzNn?=
 =?us-ascii?Q?v2UzwaLIQXyAGS9rrX08e1SO8vSukmBwq/CyneScoBqYyBoJrCyGhI4anBJd?=
 =?us-ascii?Q?yFNkn1R9QIWw09XGdT5rn6UsgvTeckU7BceSazu5TnmKu/lK3l+pmceJoSEj?=
 =?us-ascii?Q?K/D+bIZX62bxyq21RGQK9XUcrSY4YC60rmlLXIHSrZC6/6TbWISURgdXuKkE?=
 =?us-ascii?Q?etbsUP+0tlHM6QuMRfo9T+LQt6Zd5YLRfkRoAxaRdIFokx//C/pWOtckFqQd?=
 =?us-ascii?Q?HwsLRWLN8Ahabu7qn5x/WyW4UksC4YT6lT8WvzFOdpgEtpS4zVQoCO8WTL8e?=
 =?us-ascii?Q?ZmQoMylTmU5UK+z61vY/GzRZpvktQVnCxXcZIBtcD7A/FGgRm8Im7PNfPJDq?=
 =?us-ascii?Q?xYXr7iSOnOUiHvvw6TLM03GzA2kYSenSvJMNBFjE4yBQBIQTGRGmY6/oAOZ4?=
 =?us-ascii?Q?OWsfTA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da83e98b-d28e-4251-d0cd-08dab92f3803
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 21:56:08.1815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dz7/9OHfHpzsYsWCyxXry4djvv8JQjw8Jd1emO33ZhkpclcPnuaLWTz5GCmD0NTfuQCG3HmNw4bEJRa3Yq/yUrW1a1/zLYWhHtR8q9/9gKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=942 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280138
X-Proofpoint-ORIG-GUID: e-2uqNZfECBE7CmRV4Rtto-UerKAa6Kd
X-Proofpoint-GUID: e-2uqNZfECBE7CmRV4Rtto-UerKAa6Kd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the tests for Allison's parent pointer series:
https://lore.kernel.org/linux-xfs/20221021222936.934426-1-allison.henderson@oracle.com/

These tests cover basic parent pointer operations, multiple links, and
error inject. This patch also adds a new parent group and parent common
functions.

v2->v3:
- Remove old helper functions
- Clean up requirements for each test
- Let mkfs handle protofile errors

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
 tests/xfs/554       |  101 +++++
 tests/xfs/554.out   |   59 +++
 tests/xfs/555       |   69 +++
 tests/xfs/555.out   | 1002 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/556       |   85 ++++
 tests/xfs/556.out   |   14 +
 10 files changed, 1544 insertions(+)
 create mode 100644 common/parent
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out
 create mode 100755 tests/xfs/555
 create mode 100644 tests/xfs/555.out
 create mode 100755 tests/xfs/556
 create mode 100644 tests/xfs/556.out

-- 
2.25.1

