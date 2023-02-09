Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 173D9C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBIIB5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIIB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:01:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BE51287E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:01:51 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PfpY003363
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=E6HNTp+A4KbWfc3L4OYPLKn41itTnC1y3G+YeKx+fmE=;
 b=hjdvnNVAecDxFxYOacBXbGClFy4N2Wz4SAFkUI1J/8DabP7Kl0jhuc4okN/UBGK29QFk
 TdjJ97ktTzzlCOURUXmlz/do1I9a9PmQt0Hwxw5NWoijcDcaAmShXOFmsCF6GzLzSTOt
 rJd7cA5kj1J5J3sdQhwJBONxP5DGeenaNGPLp4Fmt/Lf9gJR3tU83Fe2ZctOGkNsEZFt
 jYtl8Y1N13XPkF8ObUx8fm3MZcNELDGjpHDPjA2rp2pv0/p9R/Qawojctmm2ZIV5qcWC
 GrPBA08zxIzBRTFQm2tJWw8ngDuPJeDhPWjQ8A7WoPLRBwy4ygyayHUCM9h3r6S5OTly xQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8aa43f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31963fLQ028465
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:01:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdteyf4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3HpNGQ2h0yJ8pnEyBeEUbI+fBIScj3BKC5l5GLFLZpMyoFOIME1QTiazFTW7d1D1IV0O49MeBx9TffJcD9Zlhm+rUTdoFc2AkAh9hM01iot7cxbIhT5xMMnWLZCSmmHbPGB66zp88ejNxpPRCsJtfV+tQqazk76d7J2bq9MVyZBPf3AjO+px01mxUu32Mh0232uTuvJ9UMQboXggwgZOoXYsWacl4czZl8pQBV5whxOc5mXZMSKjXN5qWebIKEWaikk6AqlZhEoikNtyaWe01iGE6VIMecF5u+uRyvxSZF/6EVNhxQPGcGprVDericu6udsHShN1qOgr+1HPx36gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6HNTp+A4KbWfc3L4OYPLKn41itTnC1y3G+YeKx+fmE=;
 b=YGZ8rli//FtXh3UaBJ9d9+vLlXR5P655+oGEMoQXoT0K6oe2J2X3tE0A2xFgFr8RSc+NJtc0OlufEDTfJ12BhLLDY05kJIb4PsOsArBYYVLhF3krtuejOVthV1GzDGg6NCIBVVA4Gaq39FxfRDHze1brB8NqCmlMN73y5r7SHbCpYsOX+JP0nz2iH5AlFC6/APZsv/OLXXYD6xK+4fL9UPbna02sTmqWz63HPsMtykEpshuoiZ8WQ2ZW1uc6xQfcWeOSyrFUwvMtqnuObgJBIIiT0AZaxnElcRTy7pBbn6bf8hsFtosIFFKXJpXKN88z0HQMkcYnPDbXrbUep0/ZaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6HNTp+A4KbWfc3L4OYPLKn41itTnC1y3G+YeKx+fmE=;
 b=N2c+Lnl4I/mMID/CdY6/J3vGsRcz/vucYfPZuB24AFxvNRwxPLl9+c05sDlh1dzM8Sc+LYiGHFZUM//bVCNvsijm5MYZHHcA6zVvfr5UbLrwO6Dv2/su9xdRhcUlG8SKUrkb4Sa0UeqdUat1iFlXtTF+UVHi1jIvsLLyJggpSZk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 08:01:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:01:48 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 00/28] Parent Pointers
Date:   Thu,  9 Feb 2023 01:01:18 -0700
Message-Id: <20230209080146.378973-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0382.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: c4248aff-26b4-4c42-a7ed-08db0a73e4c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jr4Q5R7j4pg4oZUl2EWXFeJYCSYRfBujKy0TDtwhT3b9zjWW+F210fm0nxlGchLSLujYWanmVP6VKdhca0KIdh8PL1j7hsJ+sHRvBJAZckxB7ORs0bX1Um86FftAejxsTfp8FAfhvjeH9pTWSkJoeppubG7NuUhdGyQI47OiRn9Bb8JdmJPX/VYAsVRQuTo7zUsXzJIWv+KzSimieHU+QHAm38pkGyOrkxJcR5HEPu+h2rz+IxdUPNUw8m9RVLDxMuDyvbIBF6+RJgQXEmwULH563AqhT6lIDM2fjLBbvhfP+JRgGFqC5NML6eYPL6EwaugFXp/NyfPGILCR7fHKEZG/3ivY5rlP8ZI74QiEDGSb0F+cG5n+nrWXI+3oaxk2h4JvZKHui8sFaPDeGDeN3L4D4ydq2zV+V/qgvTqkZfoUxn7eRNGl0BAQouki2eaujkPgQqsJpTq7oJG+k+lzRV7I5/ckuj2KnRjME89/7sZwTXZatOPmlN43FpOSElLxcpsGZhmmbU2MHEUdkgBucjnEWFxkDKcdYZE96+CZiCCic1jrUWAWUjLDXfsZfN2VN/UCpD2dbUsEB881He2hSOv4hpUpJ9dLOHWMy3RLPxumAFDhhnURpKwzNMht0z875XdM5esGWstOAnvN0z8V2/n3wyqN+7MMwzD8JFcurgGwJ72TJbsCZzWhFTNN305XLGsl/12e4OR0y7CGCesS1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199018)(478600001)(186003)(6512007)(26005)(6666004)(9686003)(6486002)(966005)(316002)(83380400001)(2616005)(1076003)(6506007)(66556008)(66946007)(6916009)(41300700001)(5660300002)(38100700002)(8936002)(66476007)(8676002)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?df8l674OL6j98DySrbNqa4Jtma+fjSrjSfi4YZulBBwAXFaprbTiS0UvHN6d?=
 =?us-ascii?Q?QVH3EdTUXLaXqYJMFqd3TaeboFwD4glSxDNVPTwttcqzqY9PSLgh+2YS/ZKS?=
 =?us-ascii?Q?ckGKDIUeCliGLptsZTcXrJt3wndKDuoRRGWp6j6Md4WbZl7xuTxcyucKpCJN?=
 =?us-ascii?Q?/T+lQ04AFoQcrP1Uloolry+JV2w/rAEtXVGI2O3pHQYHFqZhIZc7B8f33V33?=
 =?us-ascii?Q?PTjZxwIn1a30ifQTnEG+7jwlp/NJXHsa0WsGCKerAqKC+2IgmYXIHJd46sfC?=
 =?us-ascii?Q?PHUkxe8fwHwsGTVLMgHIhqKnq9rXF0EmpuYN9HMEkxPxLcOBg5JrOynKR0eB?=
 =?us-ascii?Q?PbKXUGRXBxdqAApfKjM6otdFQmo5jCetS3EORvOP6o1IBfo/puurW4Ge96WR?=
 =?us-ascii?Q?ON8zOYFRDGr9abhRUN6l7NRV0WUm3zv95jxztuwPAIrnkvpItKB0XmgrpdJj?=
 =?us-ascii?Q?NfTwrA6lVr9UwIpyjHcpUvC9aauq0EeiDRN88Ar4IpwpIAjUlNJ8ooqR7dyD?=
 =?us-ascii?Q?bxC0udEREgIFWcNIFD0nKflzLLqH/4/CSQ7gXYgEi0tZ0RouDk/0yIaqVESE?=
 =?us-ascii?Q?4SsEI6bCT4FrUsJDmra5c9wVUqMWqjP7mfyOASl3d5TVmCUu2jT/+68NF9HO?=
 =?us-ascii?Q?0n5+ZqPRLfi+4VUNbWw5Lwj4MIMHPH9hUgqnxPslYWrafy1RNatahaWz7m5d?=
 =?us-ascii?Q?c4O0HRBQbTte/58IKNt4/hiUQOThI+EQsahXTIAbOZZTVO1tpRwkPY90B+Zs?=
 =?us-ascii?Q?EVh2z77Zgkg+1IOBNCtnH7r6uj7BnZGRryGcgupLmkolonQvmDiDnnsKPU+N?=
 =?us-ascii?Q?P9Runo11xs9Eb3sQjFbr7j43+K2Sd8zIjQA7BCvarmHTVWQXMUmKvx6J39Wt?=
 =?us-ascii?Q?oZ8Jo8fL9K04hfmSdsPSuRcRzAphemaiczvEORuwAhdDGWJdtIn/2afRPDk4?=
 =?us-ascii?Q?joWWtU141g4irBIGmtgdFtwJ6HYLBKKJYgF5+5Xao7x0oxe5nXbXUy6XULrW?=
 =?us-ascii?Q?MJLXJHBRrEwT8+Oh+9SsvaD1TVlUwpolxkTEtCbNHTDaUAX0ELCznJ6afKcx?=
 =?us-ascii?Q?WVFl7X0Zva5tf5ImbL8ftxrA5XpCPy/BZXOcG3m3LnTeiSZJ0iUrZ/6DMLL8?=
 =?us-ascii?Q?dnePkB+OKmKaSNNsw5yMWj1hYaN33a+0SPiJbat31CsAuXxUq1TAV1FVnl/e?=
 =?us-ascii?Q?vX1qKZvuPFU1rbetRfuDUu0hbZo89VIiRFFdn1hncp92uFznoFut9YYne1dz?=
 =?us-ascii?Q?e2Rj0GjHCOkRANay06hhKZ4RHalUG8jK2/LeZu1I+I+utjOAwqF6+33OUWI8?=
 =?us-ascii?Q?/t2wTWOXFwptHDfDs+J5/8Nc0UbHDH/l0uuou3JsjXC6Fc71gt6zxaeTWRK7?=
 =?us-ascii?Q?J1h3YTb3h5glR4htTJUjQBYOOZZE4XX5LCVrF5KP4j/3tYD6hgeIP8GdlPnt?=
 =?us-ascii?Q?e4OMOAafNTsfuxw24jWXsbOh5KBGB9tGtbYL/l1MN34hiSG65Na1tzFTk+mf?=
 =?us-ascii?Q?nXmMton/1CbGq5K7YeJRSQ96cWgbiHLw5FCTLRtyWh6NQg/K5YdHcvMhywtR?=
 =?us-ascii?Q?h1QHs7lfR/lyPErclid0nqBZHYT8NASFRL8S1j32DzVH/K2pmUx/1C9/AMFJ?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2t4Iif1SDyTPlYhz7pi5JhVOErtMzKvcjsYpNwqmFKZbL4e0kvi0bsv6nw9tb4ZhpIEbD+uk4I0skKa21WlqynOLxVl1E28L63qHC+JfkWGTVtr7c+5Tbq2DGOeBAf6n74yp2/qVYSCi8nvsLLjaGzSqp1Tjxv3hZuYq7ta0FBjO6GZFXaXDo8QE+MbAKPSxZb3oYDxn3wn2eE2XTFH2Mp5PG9q/1BjJlBAgMlxevsWsRhfLG0k/0zb7N62KmfNNdVK7aHROkaPE6GU035gO4GR7a4bOCpFmOR54lulScKa1zpMnrFbSXJYuPuicXbf2QfjTY7VUgEB9W71guBM74g+BGlU1NhmKVDkJ97VsfbKDE3np0x8YQkHSKkgrpJ3/i/g6s5kKJyFxaXiwHCeLiMsSe8Bj2swYduVo+QXQEE9JMm//R+fa5gDC2/wkrMVnGIU0odETc5K/ipnXMEhIcUDcmt+51ig68gx538n4m68Ni4YKiqnhZ82mTDqYOgPkg0Zh9KZYaww6dGY4QctoYgqEH4nkfwgVzctvhDuOCH1ovKYNR8HLxnm5daAefGHld0kxLWVkBFyvK72rscNOL98yAqcqUnzWdZZjyWAuBBiB0o3mCzVDb+CFgmEunTnnXLFAT6wK4IvmagH5dO8HYXkhtVs/ARvLpKZ+H2fmIKPPY2t+uV9/TPYZIroNJu11LJin495KyviGqORQp0n56/mSeT5oQ61dRjU6FMk2HHi6U0PLeqUnuIx4wuCEq9cQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4248aff-26b4-4c42-a7ed-08db0a73e4c4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:01:47.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3ZaYOE/EH55aS+oZ94Wn0/ExdeFhKwERM3qSLF5Ejm24NlThXiBZsjG9zJ0pGpZqqEB6d4opcidTnqet0J086z4uLaqBtW0nlsU+hXJesc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: 0kexx700ORh3B9SW70e04yGzlOyoHFcR
X-Proofpoint-GUID: 0kexx700ORh3B9SW70e04yGzlOyoHFcR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, shrink, nfs handles, verity, or
any other feature that could make use of quickly deriving an inodes path from
the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv9_r2

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v9_r2

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v8:

xfs: parent pointer attribute creation
   Fix xfs_parent_init to release log assist on alloc fail
   Add slab cache for xfs_parent_defer
   Fix xfs_create to release after unlock
   Add xfs_parent_start and xfs_parent_finish wrappers
   removed unused xfs_parent_name_irec and xfs_init_parent_name_irec

xfs: add parent attributes to link
   Start/finish wrapper updates
   Fix xfs_link to disallow reservationless quotas
   
xfs: add parent attributes to symlink
   Fix xfs_symlink to release after unlock
   Start/finish wrapper updates
   
xfs: remove parent pointers in unlink
   Start/finish wrapper updates
   Add missing parent free

xfs: Add parent pointers to rename
   Start/finish wrapper updates
   Fix rename to only grab logged xattr once
   Fix xfs_rename to disallow reservationless quotas
   Fix double unlock on dqattach fail
   Move parent frees to out_release_wip
   
xfs: Add parent pointers to xfs_cross_rename
   Hoist parent pointers into rename

Questions comments and feedback appreciated!

Thanks all!
Allison

Allison Henderson (28):
  xfs: Add new name to attri/d
  xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  xfs: Increase XFS_QM_TRANS_MAXDQS to 5
  xfs: Hold inode locks in xfs_ialloc
  xfs: Hold inode locks in xfs_trans_alloc_dir
  xfs: Hold inode locks in xfs_rename
  xfs: Expose init_xattrs in xfs_create_tmpfile
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer xattr format
  xfs: Add xfs_verify_pptr
  xfs: extend transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: add parent attributes to symlink
  xfs: remove parent pointers in unlink
  xfs: Indent xfs_rename
  xfs: Add parent pointers to rename
  xfs: Add parent pointers to xfs_cross_rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Filter XFS_ATTR_PARENT for getfattr
  xfs: Add parent pointer ioctl
  xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
  xfs: drop compatibility minimum log size computations for reflink
  xfs: add xfs_trans_mod_sb tracing

 fs/xfs/Makefile                 |   2 +
 fs/xfs/libxfs/xfs_attr.c        |  71 ++++-
 fs/xfs/libxfs/xfs_attr.h        |  13 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   3 +
 fs/xfs/libxfs/xfs_da_format.h   |  26 +-
 fs/xfs/libxfs/xfs_defer.c       |  28 +-
 fs/xfs/libxfs/xfs_defer.h       |   8 +-
 fs/xfs/libxfs/xfs_dir2.c        |  21 +-
 fs/xfs/libxfs/xfs_dir2.h        |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
 fs/xfs/libxfs/xfs_format.h      |   4 +-
 fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
 fs/xfs/libxfs/xfs_log_format.h  |   7 +-
 fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
 fs/xfs/libxfs/xfs_parent.c      | 203 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  84 ++++++
 fs/xfs/libxfs/xfs_sb.c          |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c  | 324 +++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_space.h |   8 -
 fs/xfs/scrub/attr.c             |   4 +-
 fs/xfs/xfs_attr_item.c          | 142 ++++++++--
 fs/xfs/xfs_attr_item.h          |   1 +
 fs/xfs/xfs_attr_list.c          |  17 +-
 fs/xfs/xfs_dquot.c              |  38 +++
 fs/xfs/xfs_dquot.h              |   1 +
 fs/xfs/xfs_file.c               |   1 +
 fs/xfs/xfs_inode.c              | 447 +++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h              |   3 +-
 fs/xfs/xfs_ioctl.c              | 148 +++++++++--
 fs/xfs/xfs_ioctl.h              |   2 +
 fs/xfs/xfs_iops.c               |   3 +-
 fs/xfs/xfs_ondisk.h             |   4 +
 fs/xfs/xfs_parent_utils.c       | 126 +++++++++
 fs/xfs/xfs_parent_utils.h       |  11 +
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_qm.h                 |   2 +-
 fs/xfs/xfs_super.c              |  14 +
 fs/xfs/xfs_symlink.c            |  58 ++++-
 fs/xfs/xfs_trans.c              |  13 +-
 fs/xfs/xfs_trans_dquot.c        |  15 +-
 fs/xfs/xfs_xattr.c              |   7 +-
 fs/xfs/xfs_xattr.h              |   2 +
 45 files changed, 1782 insertions(+), 253 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

