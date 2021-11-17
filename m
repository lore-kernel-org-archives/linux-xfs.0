Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B10C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4E2461B64
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhKQETX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:23 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61790 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232680AbhKQETV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:21 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH48UD1032014
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=S7i4a7gnl1/RP61BTIk4jNuwT3ZrKOd5k0mb3c/yokA=;
 b=jQRTUxiZFjNPD/UXBTdb8ZK/Ah7wMYvJvrvYjSF3vcANiMFeUvuXaFI05Bt2MtF+MaOt
 QY6jB29B9mDnWjn6tMseK+d1M0YGYZg8MVxocjcn30sZocZZjCDu5y5XTpNBKTHYQHaw
 9gRyRmoytAZoYy+4a7Vu4IdXSbSN2NvFnmJyzcpKmtwk0NjnD5mygR2kksJu80/UMu5G
 uYjdw2rkPVpy4drL/rs6b3WXeWBnYPznuO1CpAlCu6fdmMRWPakgnphLujV6+Ujfz10U
 ZCb2TBp96SoIwf0fCE04ePn7VbTqjHkaBMAJEjy3v7GCs69wjanvIuFldPjuvby3TjLX /A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv86ert-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKf180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVcg5o10tinuK/xv9kNQZ4pb2cBm1qVvU04M4wa8fqyrC4rwBdQNBaZETYHp+mJ63n4g2zwKhRz3YK+/1dQya90qT616NtWVuC6Qjo9ajJobglTj8HvhuWkqpW0/hE+GfHnyE83aL2hZRifJUqdEzZeGpOnTXL8XmKHF3RYFBNAaKNndA4MUnxR2/6IKDJy/jinV45ZZj8DmQ0zUsTY6UgsdsdMjVO5tGzrcDKk5swPhFu1m/xhQd0Yj9IKcxgRmmw2TUpi1ilqqy4DeCCxNJ9/OlbIMzwpSfPhayAO6IuXqnKMDCncwHkSfyo/GMXY+S3GJkslotv8DBehx8j0h/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7i4a7gnl1/RP61BTIk4jNuwT3ZrKOd5k0mb3c/yokA=;
 b=LdpaHJec3VcUrrBAZ/xqxEG7ESqyk+Ruc8FOuJOwzmOCWGyivkXrFT6MIm0c57xzMFOwUpNG8gMrl1HonUOEfHXaYUkVm8PeVG6tUBqQpNPqB6rmqJfZe7pbHT8GHcI1vAAcLosgChABQDGda+iEhrwV4Uv5wPG0MClVHFbeuyvrMGYu49wlGpQNCTiBbfoQ8QWPqKO1RcDg5bQpVOyjSAEgSNgzdpYlXplRcKlU9DFgX4pjOGMyBHMw84xrlRWbziEDxAvEmngKyNfsoPPBGHVmw5dGVzH2DO+8yeMHDIJLW82EgNPrlcywhW43thiEdBlaK6KHMGtP6uh/iRfAZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7i4a7gnl1/RP61BTIk4jNuwT3ZrKOd5k0mb3c/yokA=;
 b=WugZVTthVRSk5Au5hpJTk9z42N3v2yFdVHg5q0wm9ettrzUKhw8xZzzWaLgZ33u9LKSHG8noOJqpnJRzyFenHSjTAa7sH9ysP/IIrl8qFP/CrDA7axc22lE9b/3S+6i4aCsEII4yZR1Ul4DdhRDF7Zf10lmSndBDA2bwIyiXPKg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 00/14] Log Attribute Replay
Date:   Tue, 16 Nov 2021 21:15:59 -0700
Message-Id: <20211117041613.3050252-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 315bdbd1-ce20-41b3-2dcd-08d9a98101d3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40363F423C6DE8C0A2F64B96959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2LgKuhMkwvg3xDtW7hsngka/TtpiaK23Qrme6Ve7lskiuqv4wvGw8Ixj1ZQyunK1A+hTmh8QlBUxGphQwgZsVIuvvwR21xISRuURgsIDXlg9hs0LVd/bEDGwannLaEJ2n1jV5HTEn59iMRekO+tWK46+OvHrR17DNz3LGcsfOYNlf+HQXhT2rEe4KmzWyZLQIQb5Jo++ECf/vlRaEmnynWvDqts3Uuy4HsroSMlg2evGxYJwNatOYgiLBeRnQweKczI8PM9kaEUMGh+75siVDDl3cuTu1Wo+/PqubVjWC+eqQm3aQMR2h5Ze4f92jhVBVvgv3mO8Xk+TI4OZeqdqWOTkbSS0o40d0A8RdGWEKLwhTfmO7/wrJk+p1FFX9eUIu8J8ccUDjIkP2BEYJA6ald2oO8QHc7daHYF9v9TeX53FBn2K8H1oLpXxEFfhlBJYJjdcsdBO1nAAnr9q9/h3fI1J3n93c3jiziJEX922U6GDWlK+vH0+Np8ELdTnq2Vsw/wQSGbT7DEbs7Oyw23YxfrsAD5Yw0H14hiPn3FtDb2qvKBPyU4cN09pkqOBqckOeiwa8pp11NCITXXXFYBVEwcbv0Zvq1b/D+X1AilYcn/WcAwPO2Sqj9vNFEilJMHeCyDIWN+oh9+mmm0s0eIdloN8XmEB01FiveQn/CMPi6JLlNaAhPtJS6uOaiiEfXzijEcT0r2Diq5Tx4YAXJYlcDr1BkPGdXOEeOA6rBObbx+N0RBRQahHPkmGOT0smR+4ijpw4l/q0C7CeGvfS0MOmWvqLauV35lOqmTEVJTZijsbAZDXWl3jN+WuFKszYIaGg1uRA+1JzRgW9rLAt/aW1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(966005)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IEN4/OiGW0ZezFkZCp05QHWEJL0UTNQ9AOc/P1Nugvqt0I/q2jHYW5Igtc7U?=
 =?us-ascii?Q?JlHM06gWUb+QWdwjcPVVYfjgeI5YvQk6jp6fm5wCxsMAUnchZELAm5tl6aXN?=
 =?us-ascii?Q?VIOrk4v+GN8H++ka7P2rXMTcaTyMCtiUv7gV6WSwJiBhhtlv3cPlQIeAQl8/?=
 =?us-ascii?Q?v8qbBXo6gfTeMPbJbck9AHoT3xpSlvzNWvXi9IqxlmAIhXVKab9f0We5dI/v?=
 =?us-ascii?Q?H7z7NzOX27HSGLHeJHs89UXkc3ZTL2HhpjDe+PXuivDghltxH6ENfSz+H5Li?=
 =?us-ascii?Q?1kL1jsX3nV77rTG9GIGuITUxczB4vOB68uXwtrEW4dmBu3TEp9oCnXZWBiAU?=
 =?us-ascii?Q?t0yRK44Gl4DJyLJ55iyG735Rq8WfG5+ML7u9+7imB64Qx6UpiejKTaeXcJ5j?=
 =?us-ascii?Q?YtHPsgEScbBlpQYoZxgBex/SwVz7qoJ4wbAJto7NzMYvt9knmoBPsPekgE/1?=
 =?us-ascii?Q?maBDApZKQt4qz9OrjxWR20zFC/tAiwft59AemCPRphy4nA4NQiQTXdgt1/U5?=
 =?us-ascii?Q?QlxAYMLhO0pi/Ltc2YeMoA2ZS/jdHqpXWMw9ykztlzsoP+KBFaAphuBRe8iq?=
 =?us-ascii?Q?mHFwQAPj+PO5yxohy9jWZbfdd2KGdnaLl7v/BAHxedFrt3mQa/9GzSuluzBu?=
 =?us-ascii?Q?ledurcthheR87mE+yl2oPAZus78yiXJtr2ot97w/fHVslltwHpdlLuIwYQ1R?=
 =?us-ascii?Q?OMsShKIMvCBwTHGDPvRvYkmh/dF0sY9gbIV+6AKoPYgCTXFPH6ms3YWlA11v?=
 =?us-ascii?Q?XtrDFGomMOKJ21cm5qNGDT6k6pKhnZapxGAZDALjX3vApwuTqvzGcUNJ8iDM?=
 =?us-ascii?Q?7eLsWHrnE621atpewIXMQijvyt38w7XOC3562HiuLkfQ5RPWSZKR0sQQMFYg?=
 =?us-ascii?Q?TwAYC2xiojHw+FBlu8zwWFkquOqKHJhKp5zhp4jQw0xzuL6gaFplXrU2M19k?=
 =?us-ascii?Q?L01wp6vDHKBcvrPILq14qz6BUtrKqXPiHUAOOu4EzJZiiMFQsj5aLnu9uvHJ?=
 =?us-ascii?Q?ZzqM8Y0u4zIVqOpHtjXKO16MGVBSFDRzPeN+E+sQ7x5A96Uh776oKPlFpYvt?=
 =?us-ascii?Q?jTqQZvJyxsL8ufbAnZDKbrhvX7B+ghYAm9lMNCbgHIfoewpmKLJgXJ2iQXsw?=
 =?us-ascii?Q?w6AvCBLgeLd3UTmk3kOEcmlYbuf8/GLO5P4UwKkCd42GIyIGtSdprtCMVye1?=
 =?us-ascii?Q?sc/r+t2W0E7ECpKYF72e1klimCMT2osMNDxSbmWLqUlAJOg5b2TeFnEB14Ub?=
 =?us-ascii?Q?Vi2N0VIToVWzxkjt7Pz4gaKg4GNL2FhPKvPPN5qgC8OMbWT8wcZMxPr++t5S?=
 =?us-ascii?Q?WFIvzbv+ZqfOBFbuNZit+OA3optpFM9SHeNMGRp9pyPwLPP2GImLyptW3pJN?=
 =?us-ascii?Q?5xeYvvwvMG/F/TUDZLUzP3pd9BhpJhT+QS1jSwKy9FJ90VHBzokQrULI/lKA?=
 =?us-ascii?Q?iO6ZJs3yQlJwsCxGOAT8Q+I7wNka8C4edLhe/soCjRcbk85Sn+uBGF69AWlf?=
 =?us-ascii?Q?eqiAiOJiab1JcY+8iYAyTJeYnciMmO++4H+toLmqpGKhqgnHH2NTvUCru4dd?=
 =?us-ascii?Q?W2ZQnH+b4VC5bdL33BPqWS9puo+yzkWcPHaJ1l9k4Uj1932XZvP2QcHAfBX1?=
 =?us-ascii?Q?BR/tNTqtKTMTBL63oKCogHolrIeobnH8NVr6Q5zqWDv3l+fsWdUpwF6n6Qz5?=
 =?us-ascii?Q?Qpk6tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315bdbd1-ce20-41b3-2dcd-08d9a98101d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:19.7223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C737btav5Sna12Ys280PmA0RXRFoT2sxKZ5+xyXb1pePZFj4cFaGJH2oAZpoWQr8+WgQOHsFhfZ9rl22bzg2LYjcuj6RT26cSzQy+C6VVrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: rMuuJvNufC5CwIvbRZP2VZrmXkBtSlFj
X-Proofpoint-ORIG-GUID: rMuuJvNufC5CwIvbRZP2VZrmXkBtSlFj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,                                                                         
                                                                                
This set applies the corresponding changes for delayed attributes to            
xfsprogs. I will pick up the reviews from the kernel side series and mirror     
them here.  This set also includes some patches from the kernel side that have  
not yet been ported. This set also includes patches needed for the user space   
cli and log printing routines.                                                  
                                                                                
The last patch in this series is unique to the userspace code, and handles      
printing the new log items.  This will be needed when the kernel side code goes 
upstream since older versions will not recognise the new items.                 
                                                                                
This series can also be viewed on github here:                                  
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v25
                                                                                
And also the extended delayed attribute and parent pointer series:              
https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v25_extended

Allison Collins (1):
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred

Allison Henderson (12):
  xfs: add attr state machine tracepoints
  xfsprogs: Rename __xfs_attr_rmtval_remove
  xfs: don't commit the first deferred transaction without intents
  xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks
    to process
  xfsprogs: Set up infrastructure for log attribute replay
  xfsprogs: Implement attr logging and replay
  xfsprogs: Skip flip flags for delayed attrs
  xfsprogs: Remove unused xfs_attr_*_args
  xfsprogs: Add log attribute error tag
  xfsprogs: Merge xfs_delattr_context into xfs_attr_item
  xfsprogs: Add helper function xfs_attr_leaf_addname
  xfsprogs: Add log item printing for ATTRI and ATTRD

Darrick J. Wong (1):
  xfs: allow setting and clearing of log incompat feature flags

 include/xfs_trace.h      |   7 +
 io/inject.c              |   1 +
 libxfs/defer_item.c      | 124 +++++++++++
 libxfs/libxfs_priv.h     |   4 +
 libxfs/xfs_attr.c        | 451 +++++++++++++++++++++------------------
 libxfs/xfs_attr.h        |  56 +++--
 libxfs/xfs_attr_leaf.c   |   3 +-
 libxfs/xfs_attr_remote.c |  38 ++--
 libxfs/xfs_attr_remote.h |   6 +-
 libxfs/xfs_defer.c       |  30 +--
 libxfs/xfs_defer.h       |   2 +
 libxfs/xfs_errortag.h    |   4 +-
 libxfs/xfs_format.h      |  26 ++-
 libxfs/xfs_log_format.h  |  43 +++-
 logprint/log_misc.c      |  48 ++++-
 logprint/log_print_all.c |  12 ++
 logprint/log_redo.c      | 197 +++++++++++++++++
 logprint/logprint.h      |  12 ++
 18 files changed, 800 insertions(+), 264 deletions(-)

-- 
2.25.1

