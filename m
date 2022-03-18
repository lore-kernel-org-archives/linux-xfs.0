Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACC1C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 08:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiCRIMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 04:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiCRIMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 04:12:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DC725CB8D
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 01:10:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22I3GrTJ005308;
        Fri, 18 Mar 2022 08:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=mRb43Q5t9RNgj4/zBW7Sieu+OzZrKHGuwc+wfRFticM=;
 b=wkV8m7pHifevMrIwR8O823FjMtkcZ3FVrYQ/gZhV3LVQCC6B4/7fiIXLt39SHOpQ2MmB
 rPgvO8Z53pPY2uMgUHBfzEAw3Bf78fdI/oK7T9nPmCOHYvukBzYizhRBKXEmebVyMA+l
 MFYvcFaaAcSaR4zg6ViW4wdcERAg7DsPMW0gp/4c1oqVMoOSe8foJrIWI7HXI3Mqdn4U
 n4RafMg+2YrnzZVgRwqDSj0ej47DGs4l9DERn59r/4EZL2e3JyNWA5240nrEwEvWSss8
 fgBH3gjITaXj49GsQyV7C/KmeTlBICxUtsviNpBb8/H8isSviRx62Y5JJ4nzKGLynNPT sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rk3g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 08:10:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22I88RJr053912;
        Fri, 18 Mar 2022 08:10:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 3et65q4x8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 08:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mh8jV2Y7rbBtRjQnQWRbo5uCU7zRlKfdAqx/rcZwjJ/3TxM9sfx0TI2FR/Plq7QAL+CGhBo5tL9crm1E0uupi9t/knAf8JRNU46g2Keyq1wAgWkx6K1PfOvR6hxzZ4bPl8q+lafuhd8QJeZTSiVI759vJlaj06TnHz5LCl9bdUsDZCbbvaTcWtBu4g070t5ufI14M6MU/AW14s+KJFEK9kZTh4uSqZdr78Sa76x9ljM3DojlRQYo73oxKjATYjEh9PY9ApbaUhhW7P0ze40YIVP2xJbJW26tBGlwzzNoxn+Gw18UWN9cOv7oR47/fMwvjDsVBkujknhwiG9jMBHJng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRb43Q5t9RNgj4/zBW7Sieu+OzZrKHGuwc+wfRFticM=;
 b=D18+A5KNyNz2Wjs7VFcC6v+mIRKow5n/gFs8BVu888llGSqqrBEKNeICVEYszwHNHbZQ1Kuo41s80zzH31LUZcyropcAhdr9qPKQ6tN2Umoq2173cizvby8jiKKks1NCVWtXTE4nKVUuVimuYTuDMYHliZQMicRMsw+mlO12bgxTzLYRSssIyBoqEVhv9jPmH0OczpQeiGLT3cw4SHXvVycSls9DltR8dPvDkZxy2rP6CSxdaMZm/FHoFC0aAtRRPsUYDojpzoiJllRK3a4QZw0pgE3B/h1Lt3iX01cWaLQjPxMNiGab26FFRRoJBJhmxC3UAMjPhowRqvdUI7p8nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRb43Q5t9RNgj4/zBW7Sieu+OzZrKHGuwc+wfRFticM=;
 b=nbpWziTQFZWUraH/3hedakTWEAP+phr6TbOZznNYk6cNqywLpcE76h9ZPByuB8Upnf+rk8EMcAwS6H4sfcR7es9ONiCRMadawoeCBqPDt/iAzGy2KoLgIROcJ8bbVFvvUzuNiw4x/WOW3RKCyRQQQlD+mFST+KGWCieMFffC1dI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB4688.namprd10.prod.outlook.com
 (2603:10b6:a03:2db::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 08:10:40 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 08:10:40 +0000
Date:   Fri, 18 Mar 2022 11:10:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org
Subject: [kbuild] Re: [PATCH 3/7] xfs: xfs_ail_push_all_sync() stalls when
 racing with updates
Message-ID: <202203172212.pRLbx3jA-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317053907.164160-4-david@fromorbit.com>
Message-ID-Hash: UCCQLADTZ34WE63V3D4ZZL4PL6VBGHDX
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50c1ede8-f1a3-492b-d609-08da08b6cae1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4688:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46887F978D3D64985B2713818E139@SJ0PR10MB4688.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWk17rv3FdwAV1Ll1j6DD2KrSz8rf42T1gQ2+ojvAq0OYE/J6NV4Qm2XkhBK6eKs1zLMH/+OQ2vQ8btb23II2bNKXVHbmclcNWe9gzplHyMw7gqzAxgM02tQPyNh48TRZu9y5JjaOGXj3Psn0rxAqcvO1HU2KmTQfOy2gTtTtubvXp/gT5GDXrMvLPZkIErckXpKHvTCqppoVpdK7HvXrxhFru36gnAuh/SvguJSmPDEapXJIMPjhXGLqCVzy4FIW42NayIokkJt4BO4uJRMRVSeJLTqVhWJpiGphFbMKZbe2dEXbTEYvNVWZheK20NQDIYeFabycWk5pb+W6hxxPlsT1C9E5cAbwDl9pKlKmUxMQK+Sq3+NuY2DhfFqVI+QA2TDJaRFyIE2GWn2bxhZgnNHMhuq2vT4bHhnDS3zjSo6b9T8EOge1wjrco0HBsXYR1XFQBEOplMbVmKhAraJ2D53LzPfaSHzMBzN/EAsfdG6mWjaxznfIoygU6VS6hex0P8QdkZyi2c/zrOCszKS7FCARta9MYc8TQIr9niZT9dYf65xvpKY3CrSKgMlbjHZ0Ss+4x3cJdqTulrZdgcVHsU8CHUa7v2EqYkBaLJ7VmbvByrR55i8DUXcerwEjzUtCSjlo7pdbut7VnQxb1PxQNa6c4wT3yWfnsLp1gsP7BL7eO0XbPWzIbFBwiVBrEhEN6b3qCfYS48f3HaD2K6cHTIxFhXu3wQo7uXZCP0Q0AI5KlfMLz62O0Js3wuSFs/Td1NAsxT/7OGBEm0JYX6n0ZDkWzu3E/95zuPilrzV+iZ5MqSBTbV406hDzR4lw1/bRrQ/HAZL4J6EPnVCpIsbEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(8936002)(4326008)(5660300002)(316002)(8676002)(66476007)(66556008)(66946007)(86362001)(30864003)(508600001)(44832011)(6666004)(966005)(6486002)(6506007)(52116002)(6512007)(9686003)(15650500001)(4001150100001)(1076003)(38100700002)(38350700002)(186003)(26005)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ge7Vti0Uzb21x07qIuXgVKQ0/i5NdKhLV5qLoE3SierpuUa0ugpC5MoyROrr?=
 =?us-ascii?Q?K7DdqGALQMrwclGyTjV+sO7TxOl7o1Rx0rNAis0wdxAy+jqtJFltLzyhaqyu?=
 =?us-ascii?Q?b9hSdPlCxXfy6FM4EEBKA+ifwcuRoVZYPvXs2FX9Tv792vFOJZajTjONU3Ch?=
 =?us-ascii?Q?lkae2la9HFzBhXAmo9HqJg4k+VEpaGQE9z1QVDz1r0pV6lHvnL4UJZYR+Q1N?=
 =?us-ascii?Q?gQlwn61FSK3IgaTCvbsV7Atx0hAD/d19vBAp8Me7+TLxBi1aoX3B5qWNCLc0?=
 =?us-ascii?Q?BlhFMvkUozjjODWYlZ4oF2NUA8nvPL83fgDedEauYNJ2Jdtv4EH+vfIaa7jY?=
 =?us-ascii?Q?oPaLBSb2dytvdMH+iIaWNLiKXXdXXocG67NWAaVmt+D5fC7dbNzQFSC1mln8?=
 =?us-ascii?Q?CH4hYWwAr6tiQhOgmcM7EhDSTfrgRimmbVAQNUgQ/J4GGDJfKsOzCZLX1yIY?=
 =?us-ascii?Q?IGCu2+FSAeQ4tsTja5XxOWIL6N8Zd2n7mbLyxhiK9yEkHLBRKOSmyaUvkhee?=
 =?us-ascii?Q?F+a+uWcBVjEn6qzFMTspK8TM2i3zOb39G7uZyDJ7mMbhU40h/UWNxldxpWq7?=
 =?us-ascii?Q?9dzJgcWaTKmH+g/haddT2KDLRAKfstlbmwLG/lNlxjnrUnEodTNTNHIC59wk?=
 =?us-ascii?Q?JwAXWaMNVBv7bnThcqO1wEsxGg38txFrGFaP6WIt/ZxIVRH0Wn8FrxmZkK+F?=
 =?us-ascii?Q?hjggl99kkZ2nYHMkiVWFQBi6XgvcNrR71rGd623pN8mxTIGxsFkHTovbR6TQ?=
 =?us-ascii?Q?bwwTfczfZyIofCfvzWXUlX9DzAOZGM9kMwfbj8ChCzBFEQRVVN/XGufKdv/9?=
 =?us-ascii?Q?prQoX+F5xaOaVQ2dwQ94Q04zEP/ZdX2QNbCLRJVY+zlxXhojllNRC+naOhM6?=
 =?us-ascii?Q?mtWIWL6S3/3GGRcOCtwAmDxbfsFKgZ8qr1+ezRNXx6rnYTR62Q2aDwLk4S0Z?=
 =?us-ascii?Q?uhBDa3H0tTaekHdhQ3+Bnmz2EWqHCfarD/nDeEc7A/0DZbV3INt1hey6vj7N?=
 =?us-ascii?Q?X/k99AzT0BkDUkp1O4DjRaUHEL/59MbGVYcbL8oIuQswtNnBesFXqVhZNWdU?=
 =?us-ascii?Q?BbOp4/J0qxPNX8AnGivbv662aG1xFL142B3T9OENRMDOY5OfyOw8k9ZeYSPR?=
 =?us-ascii?Q?/okz44rL2b0KdL+jNafHxlrz0XsZwOBSphXacgD0E8R8TJl4zynEuf1QpP6a?=
 =?us-ascii?Q?HfNDanVLrX2T1KjIuXzt0yHpbSDz0Lh/oK8NaBCmzlqkMZm84s74d+V9IXCO?=
 =?us-ascii?Q?gPEaK2pb18lKRnxyXc87VkfvI5IDFbiXxN8OdFHP5WZiUTLDqElvHN7adWP1?=
 =?us-ascii?Q?j6ndhT4BaaACLEPl9dQe9ED8PGYwQlCh1rffr3MAiI+v9TzMPZ5lSm0bVzny?=
 =?us-ascii?Q?OW+ZnRU5q5qpjLPyyzFer+c6aTNnkjrCQZRgS5zT7KDlAFweMTkT4/61+S8y?=
 =?us-ascii?Q?MuoyDbDVH+AlUCa2SxKBBV+lLHaYBkDyVue206jDNQIm/QH6pagDhQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c1ede8-f1a3-492b-d609-08da08b6cae1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 08:10:40.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FkwStPDzMaF+byfnvFvm/Pza8pYFBPfMADwU5UdeqiK1I4r+Er+kXYkFTZSBAkCUycZM/TlYo9c0NyUWbfxaBx1tn7k2uQGiVlEvJxEmK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4688
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180043
X-Proofpoint-GUID: MWB2F16tUWmHOIJ4oxll7zQtKd0Dsrjx
X-Proofpoint-ORIG-GUID: MWB2F16tUWmHOIJ4oxll7zQtKd0Dsrjx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

url:    https://github.com/0day-ci/linux/commits/Dave-Chinner/xfs-log-recovery-fixes/20220317-141849 
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git  for-next
config: parisc-randconfig-m031-20220317 (https://download.01.org/0day-ci/archive/20220317/202203172212.pRLbx3jA-lkp@intel.com/config )
compiler: hppa-linux-gcc (GCC) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
fs/xfs/xfs_trans_ail.c:476 xfsaild_push() error: uninitialized symbol 'target'.

vim +/target +476 fs/xfs/xfs_trans_ail.c

0030807c66f058 Christoph Hellwig 2011-10-11  417  static long
0030807c66f058 Christoph Hellwig 2011-10-11  418  xfsaild_push(
0030807c66f058 Christoph Hellwig 2011-10-11  419  	struct xfs_ail		*ailp)
249a8c1124653f David Chinner     2008-02-05  420  {
57e809561118a4 Matthew Wilcox    2018-03-07  421  	xfs_mount_t		*mp = ailp->ail_mount;
af3e40228fb2db Dave Chinner      2011-07-18  422  	struct xfs_ail_cursor	cur;
efe2330fdc246a Christoph Hellwig 2019-06-28  423  	struct xfs_log_item	*lip;
9e7004e741de0b Dave Chinner      2011-05-06  424  	xfs_lsn_t		lsn;
fe0da767311933 Dave Chinner      2011-05-06  425  	xfs_lsn_t		target;
43ff2122e6492b Christoph Hellwig 2012-04-23  426  	long			tout;
9e7004e741de0b Dave Chinner      2011-05-06  427  	int			stuck = 0;
43ff2122e6492b Christoph Hellwig 2012-04-23  428  	int			flushing = 0;
9e7004e741de0b Dave Chinner      2011-05-06  429  	int			count = 0;
^1da177e4c3f41 Linus Torvalds    2005-04-16  430  
670ce93fef93bb Dave Chinner      2011-09-30  431  	/*
43ff2122e6492b Christoph Hellwig 2012-04-23  432  	 * If we encountered pinned items or did not finish writing out all
0020a190cf3eac Dave Chinner      2021-08-10  433  	 * buffers the last time we ran, force a background CIL push to get the
0020a190cf3eac Dave Chinner      2021-08-10  434  	 * items unpinned in the near future. We do not wait on the CIL push as
0020a190cf3eac Dave Chinner      2021-08-10  435  	 * that could stall us for seconds if there is enough background IO
0020a190cf3eac Dave Chinner      2021-08-10  436  	 * load. Stalling for that long when the tail of the log is pinned and
0020a190cf3eac Dave Chinner      2021-08-10  437  	 * needs flushing will hard stop the transaction subsystem when log
0020a190cf3eac Dave Chinner      2021-08-10  438  	 * space runs out.
670ce93fef93bb Dave Chinner      2011-09-30  439  	 */
57e809561118a4 Matthew Wilcox    2018-03-07  440  	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
57e809561118a4 Matthew Wilcox    2018-03-07  441  	    (!list_empty_careful(&ailp->ail_buf_list) ||
43ff2122e6492b Christoph Hellwig 2012-04-23  442  	     xfs_ail_min_lsn(ailp))) {
57e809561118a4 Matthew Wilcox    2018-03-07  443  		ailp->ail_log_flush = 0;
43ff2122e6492b Christoph Hellwig 2012-04-23  444  
ff6d6af2351cae Bill O'Donnell    2015-10-12  445  		XFS_STATS_INC(mp, xs_push_ail_flush);
0020a190cf3eac Dave Chinner      2021-08-10  446  		xlog_cil_flush(mp->m_log);
670ce93fef93bb Dave Chinner      2011-09-30  447  	}
670ce93fef93bb Dave Chinner      2011-09-30  448  
57e809561118a4 Matthew Wilcox    2018-03-07  449  	spin_lock(&ailp->ail_lock);
8375f922aaa6e7 Brian Foster      2012-06-28  450  
29e90a4845ecee Dave Chinner      2022-03-17  451  	/*
29e90a4845ecee Dave Chinner      2022-03-17  452  	 * If we have a sync push waiter, we always have to push till the AIL is
29e90a4845ecee Dave Chinner      2022-03-17  453  	 * empty. Update the target to point to the end of the AIL so that
29e90a4845ecee Dave Chinner      2022-03-17  454  	 * capture updates that occur after the sync push waiter has gone to
29e90a4845ecee Dave Chinner      2022-03-17  455  	 * sleep.
29e90a4845ecee Dave Chinner      2022-03-17  456  	 */
29e90a4845ecee Dave Chinner      2022-03-17  457  	if (waitqueue_active(&ailp->ail_empty)) {
29e90a4845ecee Dave Chinner      2022-03-17  458  		lip = xfs_ail_max(ailp);
29e90a4845ecee Dave Chinner      2022-03-17  459  		if (lip)
29e90a4845ecee Dave Chinner      2022-03-17  460  			target = lip->li_lsn;

No else path.

29e90a4845ecee Dave Chinner      2022-03-17  461  	} else {
57e809561118a4 Matthew Wilcox    2018-03-07  462  		/* barrier matches the ail_target update in xfs_ail_push() */
8375f922aaa6e7 Brian Foster      2012-06-28  463  		smp_rmb();
57e809561118a4 Matthew Wilcox    2018-03-07  464  		target = ailp->ail_target;
57e809561118a4 Matthew Wilcox    2018-03-07  465  		ailp->ail_target_prev = target;
29e90a4845ecee Dave Chinner      2022-03-17  466  	}
8375f922aaa6e7 Brian Foster      2012-06-28  467  
f376b45e861d8b Brian Foster      2020-07-16  468  	/* we're done if the AIL is empty or our push has reached the end */
57e809561118a4 Matthew Wilcox    2018-03-07  469  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);

"lip" re-assigned here

f376b45e861d8b Brian Foster      2020-07-16  470  	if (!lip)
9e7004e741de0b Dave Chinner      2011-05-06  471  		goto out_done;
^1da177e4c3f41 Linus Torvalds    2005-04-16  472  
ff6d6af2351cae Bill O'Donnell    2015-10-12  473  	XFS_STATS_INC(mp, xs_push_ail);
^1da177e4c3f41 Linus Torvalds    2005-04-16  474  
249a8c1124653f David Chinner     2008-02-05  475  	lsn = lip->li_lsn;
50e86686dfb287 Dave Chinner      2011-05-06 @476  	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
                                                                                         ^^^^^^

249a8c1124653f David Chinner     2008-02-05  477  		int	lock_result;
43ff2122e6492b Christoph Hellwig 2012-04-23  478  
^1da177e4c3f41 Linus Torvalds    2005-04-16  479  		/*
904c17e6832845 Dave Chinner      2013-08-28  480  		 * Note that iop_push may unlock and reacquire the AIL lock.  We
43ff2122e6492b Christoph Hellwig 2012-04-23  481  		 * rely on the AIL cursor implementation to be able to deal with
43ff2122e6492b Christoph Hellwig 2012-04-23  482  		 * the dropped lock.
^1da177e4c3f41 Linus Torvalds    2005-04-16  483  		 */
7f4d01f36a3ac1 Brian Foster      2017-08-08  484  		lock_result = xfsaild_push_item(ailp, lip);
^1da177e4c3f41 Linus Torvalds    2005-04-16  485  		switch (lock_result) {
^1da177e4c3f41 Linus Torvalds    2005-04-16  486  		case XFS_ITEM_SUCCESS:
ff6d6af2351cae Bill O'Donnell    2015-10-12  487  			XFS_STATS_INC(mp, xs_push_ail_success);
9e4c109ac82239 Christoph Hellwig 2011-10-11  488  			trace_xfs_ail_push(lip);
9e4c109ac82239 Christoph Hellwig 2011-10-11  489  
57e809561118a4 Matthew Wilcox    2018-03-07  490  			ailp->ail_last_pushed_lsn = lsn;
^1da177e4c3f41 Linus Torvalds    2005-04-16  491  			break;
^1da177e4c3f41 Linus Torvalds    2005-04-16  492  
43ff2122e6492b Christoph Hellwig 2012-04-23  493  		case XFS_ITEM_FLUSHING:
43ff2122e6492b Christoph Hellwig 2012-04-23  494  			/*
cf085a1b5d2214 Joe Perches       2019-11-07  495  			 * The item or its backing buffer is already being
43ff2122e6492b Christoph Hellwig 2012-04-23  496  			 * flushed.  The typical reason for that is that an
43ff2122e6492b Christoph Hellwig 2012-04-23  497  			 * inode buffer is locked because we already pushed the
43ff2122e6492b Christoph Hellwig 2012-04-23  498  			 * updates to it as part of inode clustering.
43ff2122e6492b Christoph Hellwig 2012-04-23  499  			 *
b63da6c8dfa9b2 Randy Dunlap      2020-08-05  500  			 * We do not want to stop flushing just because lots
cf085a1b5d2214 Joe Perches       2019-11-07  501  			 * of items are already being flushed, but we need to
43ff2122e6492b Christoph Hellwig 2012-04-23  502  			 * re-try the flushing relatively soon if most of the
cf085a1b5d2214 Joe Perches       2019-11-07  503  			 * AIL is being flushed.
43ff2122e6492b Christoph Hellwig 2012-04-23  504  			 */
ff6d6af2351cae Bill O'Donnell    2015-10-12  505  			XFS_STATS_INC(mp, xs_push_ail_flushing);
43ff2122e6492b Christoph Hellwig 2012-04-23  506  			trace_xfs_ail_flushing(lip);
17b38471c3c07a Christoph Hellwig 2011-10-11  507  
43ff2122e6492b Christoph Hellwig 2012-04-23  508  			flushing++;
57e809561118a4 Matthew Wilcox    2018-03-07  509  			ailp->ail_last_pushed_lsn = lsn;
^1da177e4c3f41 Linus Torvalds    2005-04-16  510  			break;
^1da177e4c3f41 Linus Torvalds    2005-04-16  511  
^1da177e4c3f41 Linus Torvalds    2005-04-16  512  		case XFS_ITEM_PINNED:
ff6d6af2351cae Bill O'Donnell    2015-10-12  513  			XFS_STATS_INC(mp, xs_push_ail_pinned);
9e4c109ac82239 Christoph Hellwig 2011-10-11  514  			trace_xfs_ail_pinned(lip);
9e4c109ac82239 Christoph Hellwig 2011-10-11  515  
249a8c1124653f David Chinner     2008-02-05  516  			stuck++;
57e809561118a4 Matthew Wilcox    2018-03-07  517  			ailp->ail_log_flush++;
^1da177e4c3f41 Linus Torvalds    2005-04-16  518  			break;
^1da177e4c3f41 Linus Torvalds    2005-04-16  519  		case XFS_ITEM_LOCKED:
ff6d6af2351cae Bill O'Donnell    2015-10-12  520  			XFS_STATS_INC(mp, xs_push_ail_locked);
9e4c109ac82239 Christoph Hellwig 2011-10-11  521  			trace_xfs_ail_locked(lip);
43ff2122e6492b Christoph Hellwig 2012-04-23  522  
249a8c1124653f David Chinner     2008-02-05  523  			stuck++;
^1da177e4c3f41 Linus Torvalds    2005-04-16  524  			break;
^1da177e4c3f41 Linus Torvalds    2005-04-16  525  		default:
^1da177e4c3f41 Linus Torvalds    2005-04-16  526  			ASSERT(0);
^1da177e4c3f41 Linus Torvalds    2005-04-16  527  			break;
^1da177e4c3f41 Linus Torvalds    2005-04-16  528  		}
^1da177e4c3f41 Linus Torvalds    2005-04-16  529  
249a8c1124653f David Chinner     2008-02-05  530  		count++;
249a8c1124653f David Chinner     2008-02-05  531  
^1da177e4c3f41 Linus Torvalds    2005-04-16  532  		/*
249a8c1124653f David Chinner     2008-02-05  533  		 * Are there too many items we can't do anything with?
43ff2122e6492b Christoph Hellwig 2012-04-23  534  		 *
b63da6c8dfa9b2 Randy Dunlap      2020-08-05  535  		 * If we are skipping too many items because we can't flush
249a8c1124653f David Chinner     2008-02-05  536  		 * them or they are already being flushed, we back off and
249a8c1124653f David Chinner     2008-02-05  537  		 * given them time to complete whatever operation is being
249a8c1124653f David Chinner     2008-02-05  538  		 * done. i.e. remove pressure from the AIL while we can't make
249a8c1124653f David Chinner     2008-02-05  539  		 * progress so traversals don't slow down further inserts and
249a8c1124653f David Chinner     2008-02-05  540  		 * removals to/from the AIL.
249a8c1124653f David Chinner     2008-02-05  541  		 *
249a8c1124653f David Chinner     2008-02-05  542  		 * The value of 100 is an arbitrary magic number based on
249a8c1124653f David Chinner     2008-02-05  543  		 * observation.
^1da177e4c3f41 Linus Torvalds    2005-04-16  544  		 */
249a8c1124653f David Chinner     2008-02-05  545  		if (stuck > 100)
249a8c1124653f David Chinner     2008-02-05  546  			break;
^1da177e4c3f41 Linus Torvalds    2005-04-16  547  
af3e40228fb2db Dave Chinner      2011-07-18  548  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
249a8c1124653f David Chinner     2008-02-05  549  		if (lip == NULL)
249a8c1124653f David Chinner     2008-02-05  550  			break;
249a8c1124653f David Chinner     2008-02-05  551  		lsn = lip->li_lsn;
^1da177e4c3f41 Linus Torvalds    2005-04-16  552  	}
f376b45e861d8b Brian Foster      2020-07-16  553  
f376b45e861d8b Brian Foster      2020-07-16  554  out_done:
e4a1e29cb0ace3 Eric Sandeen      2014-04-14  555  	xfs_trans_ail_cursor_done(&cur);
57e809561118a4 Matthew Wilcox    2018-03-07  556  	spin_unlock(&ailp->ail_lock);
^1da177e4c3f41 Linus Torvalds    2005-04-16  557  
57e809561118a4 Matthew Wilcox    2018-03-07  558  	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
57e809561118a4 Matthew Wilcox    2018-03-07  559  		ailp->ail_log_flush++;
d808f617ad00a4 Dave Chinner      2010-02-02  560  
43ff2122e6492b Christoph Hellwig 2012-04-23  561  	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
249a8c1124653f David Chinner     2008-02-05  562  		/*
43ff2122e6492b Christoph Hellwig 2012-04-23  563  		 * We reached the target or the AIL is empty, so wait a bit
43ff2122e6492b Christoph Hellwig 2012-04-23  564  		 * longer for I/O to complete and remove pushed items from the
43ff2122e6492b Christoph Hellwig 2012-04-23  565  		 * AIL before we start the next scan from the start of the AIL.
249a8c1124653f David Chinner     2008-02-05  566  		 */
453eac8a9aa417 Dave Chinner      2010-01-11  567  		tout = 50;
57e809561118a4 Matthew Wilcox    2018-03-07  568  		ailp->ail_last_pushed_lsn = 0;
43ff2122e6492b Christoph Hellwig 2012-04-23  569  	} else if (((stuck + flushing) * 100) / count > 90) {
249a8c1124653f David Chinner     2008-02-05  570  		/*
43ff2122e6492b Christoph Hellwig 2012-04-23  571  		 * Either there is a lot of contention on the AIL or we are
43ff2122e6492b Christoph Hellwig 2012-04-23  572  		 * stuck due to operations in progress. "Stuck" in this case
43ff2122e6492b Christoph Hellwig 2012-04-23  573  		 * is defined as >90% of the items we tried to push were stuck.
249a8c1124653f David Chinner     2008-02-05  574  		 *
249a8c1124653f David Chinner     2008-02-05  575  		 * Backoff a bit more to allow some I/O to complete before
43ff2122e6492b Christoph Hellwig 2012-04-23  576  		 * restarting from the start of the AIL. This prevents us from
43ff2122e6492b Christoph Hellwig 2012-04-23  577  		 * spinning on the same items, and if they are pinned will all
43ff2122e6492b Christoph Hellwig 2012-04-23  578  		 * the restart to issue a log force to unpin the stuck items.
249a8c1124653f David Chinner     2008-02-05  579  		 */
453eac8a9aa417 Dave Chinner      2010-01-11  580  		tout = 20;
57e809561118a4 Matthew Wilcox    2018-03-07  581  		ailp->ail_last_pushed_lsn = 0;
43ff2122e6492b Christoph Hellwig 2012-04-23  582  	} else {
43ff2122e6492b Christoph Hellwig 2012-04-23  583  		/*
43ff2122e6492b Christoph Hellwig 2012-04-23  584  		 * Assume we have more work to do in a short while.
43ff2122e6492b Christoph Hellwig 2012-04-23  585  		 */
43ff2122e6492b Christoph Hellwig 2012-04-23  586  		tout = 10;
^1da177e4c3f41 Linus Torvalds    2005-04-16  587  	}
0bf6a5bd4b55b4 Dave Chinner      2011-04-08  588  
0030807c66f058 Christoph Hellwig 2011-10-11  589  	return tout;
0030807c66f058 Christoph Hellwig 2011-10-11  590  }

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org 
_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org

