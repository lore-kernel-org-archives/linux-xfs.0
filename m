Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C47C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Oct 2022 13:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiJ2N6L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 09:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ2N6I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 09:58:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAF127CEA
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 06:58:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29TCaCvx014040;
        Sat, 29 Oct 2022 13:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=faumjsFfZYQBcAD68pNkJn/eZ1iPtHPoucmw1LKVUS4=;
 b=xHqHlalPa+ai3L08JJlYKDFHm/0dOxv6LYjFNU+e8x2pg7h/HQtC8CJKTYn+oREZ5o0e
 /VI34KMRxBWutZsxH3F7T79e3gtX1hKAmZw8RP5GElIkPi1Q2wZD7zJjPJz+ARvPZuJY
 mUetoRHUWLEinhbJDzJzvJzYZjluO220m0EDr4n0QJ7gOXYaRuDdnHKyG/nexc9HFlOA
 Y4veBut9dQWpJ0UN1Y+Ccg08E9ZqjV11SOKEVOmO8jr7iMpp41vesvKYZrcNVEvIB+s9
 vHLPzexfBqU2zDiCkFWnOU4WQVTkG/OGSc2chEHDuBgRLJ53hRAlQFrqzZYm57NIzKHW Qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussgneh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:57:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29T90ReE023921;
        Sat, 29 Oct 2022 13:57:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm1v0fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Oct 2022 13:57:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8nN/096ID9/3jSjz4GsLNaL2cko3vvXX78Rk9EiRALDk7ZrVrny/f5lrkMdLGv5dkQc/5FVIFQY3AslWswtEla4T+WoVIzokclJUHQdC2kQlywo59GCbT4fWH4M6fLmXq7dplx5HdR+8n+HzcEvziJAQkHmcDnWYE2YcTtNVsarlMZ/p9/21r9VPgXM86AcIrtdOjq9Ph9d9GGbv/2Mhe9N3roDrYcGKtJZfUQ96YHdCZR1jqPm0UZBaFELwtgFPHu/p6B8pD/9Tm8NhuniC3AQeQV1fiKc9tyTJwu9uAoYtaoEX68QEsujVWmc0dBtVrEZVN/T4KYtG8gq0UXaEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faumjsFfZYQBcAD68pNkJn/eZ1iPtHPoucmw1LKVUS4=;
 b=lfilpr3bTe1/Mx+FSARkwe/qEfCLQxPefqzk0hQWe6I10rmdyUapNwJokxHyzf1cPLcDKF6BykxiY6xQcq8DL8hoKRoXuVmyljjmTe8TOKqe4l7a+I8ktPJwgpHe2VvekcO8kYOE7ob5eyX1xpRNS5hjBDyjmZgBBF4XTCM+dfnSdTM9UAfdz7vHjcuRuEYqXudRJyzAZKAJVw7YGopzdmfNRtdScFFlWOevywDjzR3sW3/kSP/vrJMjA/wiV+q4CVGIvuI6OsjKnFOXqarXyaZHW7JqUCYwWzCnjqc3Xx1CKuUFdLOLn2Gvcrh0gjOOTSTthQVjpbAMNvpIjo/9Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faumjsFfZYQBcAD68pNkJn/eZ1iPtHPoucmw1LKVUS4=;
 b=V38cDbI9VlbrWl6ww1hGib5haf+rJR83xdV9amluS+LrLgMxYYSYsGn0Jd//9konF60jotsZ75N8fHAOo5NlIpramNHujBOQqeubu345DKcmDHmDA+nAkhjX8HEoAaAvNBSx1G9+iGT5Twmqk0nXdnqD1pY2Z4IjySJwFSTGCLk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5843.namprd10.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sat, 29 Oct
 2022 13:57:52 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.015; Sat, 29 Oct 2022
 13:57:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 0/3] Fixes for patches backported to 5.4.y from v5.7
Date:   Sat, 29 Oct 2022 19:27:29 +0530
Message-Id: <20221029135732.574729-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0030.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: bb51e3b5-d646-4282-ff31-08dab9b59263
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cq13Dgld8DfZpXh6Bso/t9S/dtIVv08bF0AE4YKRzhQuEpPB1aYFHx5HSRcd6N192KV3F3FX9NHJsrRiQ4CrkaDP+MvOUIRU0Gv8C8jd52q9Tj7vja8GBvuRo8GM8FwrJq6i2LLa0HyN5SxBfLPqwiIErwhTGYvSYtD0RfEphGNGu1ZB4fiJxfCT6oR7yqyEqakqbe2/t8lW2V44M63I+AHqfkcacx/7x0ooOdyZ4iARUPAlmThIO1ma6gPgd7zxOZx4EguLkjUn7/3H0Qux9WZln81Qv36aZMW33J20lm6esHgvRTYKd2MpBBUlR5XmY848te0QDHeYjy73duU34dxD+wn1xLAJ98ZwwlXFFfaPIFcKuyfSe2sHGrGjKFb7FqdPMGVRnqKzrgo5O/yki9zazTxUveJKTCVtFcdl64LAdHEqygA40+EjedE0zy+RcFjUjvnpZzUz+E4nFQ95LgEh9hQHcMAGojtGzd82FdP1BoKRp6zpNJoeGgwpxbzLphvisYFSLFZrR5M8Pv+ChdVL2eN46aJoH2q0EqqG5EE9erBJj3/XuLpo1Xz8IIZl8eFwPofxkGq0aY1wdDGPyvcfv0n7MEa3D1g7pUJA979BrvE1B4DjYpfS2+xvfiHc2oJlIw8yp7sK4ieeGKhm81Z/LnF3ug+aneF0/WgB2KP8canCgugug+/nKdrGlrvnogWQSShyUIFYnJnlqX3LJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(1076003)(4744005)(83380400001)(66946007)(66476007)(2616005)(86362001)(6486002)(38100700002)(316002)(6916009)(186003)(6506007)(66556008)(41300700001)(478600001)(6666004)(5660300002)(6512007)(2906002)(8676002)(26005)(8936002)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?op/v23ImI5UAcqgNT/12nvLi0AMVwESB56dRnRLHAVBBgIXhbNTRhzSZu7qP?=
 =?us-ascii?Q?ZtonMIXCTIHIfdVM8hp/uViutB4R8xaOErsNCFzA+W9DgSRhFFUiYiJPxWuL?=
 =?us-ascii?Q?xxGeJRG7KYAPD5fHkR6936yBZYHRHrHEv7+QIQhD+HmLc1HNHDSFCtibEwCi?=
 =?us-ascii?Q?ko62LeVR1xoGlbHcUIZCYdjJq1o9oc6QP9At4yr42npr9aV376ZNWxq7W8y+?=
 =?us-ascii?Q?/QoCWiBmorQXGMqYaMHm7KAA3CeWhqc9FPIs4/h+jovgPRtgbMotTmZTiaON?=
 =?us-ascii?Q?Npq/SuI6Ax8TVczQDSCNs8j23GueRo9EVw49UF0Gs2cOXF+rhvmLivd19kPA?=
 =?us-ascii?Q?v3UbgCqH6vF6L8+6TGi3Y1kdxiaHXddpd7By2qFT4EgN/rVMtf3CfNAcxYky?=
 =?us-ascii?Q?q/Oap5yFnCdR5+HjbmSBGVFXlLckAVjGkQs8W4PkGP0pfwuZpjsYB33cLtaO?=
 =?us-ascii?Q?dG7GtQPOHxdbjT30H4+n0dvGxCyUovmN3aGwEkUYyNNetIeQwRR7WDDW5gOa?=
 =?us-ascii?Q?EM71Z5VD1Ka/z4m0QzEzq8ozjq2pqe3GaSo7d5PmEvgjMPdZdXlrTwg3e4QL?=
 =?us-ascii?Q?ROuyQTJDGibW3HpM8ryB1s4xL/ZmI/tv29b95PIZfiyCLxP/Q2HVU/GmXm/g?=
 =?us-ascii?Q?U7Tqd3SMJb1XLjIdPwP1+5lAAYslxqnnlsIUau1nT54rOfQV9DZq/2tn1XeT?=
 =?us-ascii?Q?+flHJOMPaBZQI9EGnGhtcuCAQB/NboJEuQooYwLZKu4qWc0/FoIk9I0rd3Ol?=
 =?us-ascii?Q?KjCAcw3TOdvou+if2LcWk9KqZE2fnWZ5oFJICEJCyYkluUntSbs1aHzWnaAD?=
 =?us-ascii?Q?+MWYFGm9SkymkIFJpV67mqq7YLEcjhckz1D5qDMfw379sQBee/5WsWNqfXse?=
 =?us-ascii?Q?QlVu4WztYSSJPgLxACBEliAN5wuMg7Ezz5bRqo84kVEexHwieZVKJiKqBLkK?=
 =?us-ascii?Q?FZ0pEEsVZLg1SR+1/YWGMqvmG/EII3VZKfs+iPODd1an+LKaMuPxzCIKsmNF?=
 =?us-ascii?Q?C1OmOqzuwUWpjjGre0TBLDeI3MIOKeMVbYy5i0bP3T+EyHxmFO2/UIOMem6p?=
 =?us-ascii?Q?7cvq+TWWY4OhOxNwNmuBQj7zFYGROdLKGuIjvDzbh/CYEuvQf9tBFyXpAB4q?=
 =?us-ascii?Q?RU3jzZQXpHByz/SYC+gjLnhpw9YgXrW5h1uqH6EaLOyWCcICxh5ifkZVmhIF?=
 =?us-ascii?Q?g3vCqvObORfQbz1/tvW2J8IIW/v8WOXOzJCugAAj0bQGRixXRfMNLHjw0JId?=
 =?us-ascii?Q?TJ4oDzNzhIsGuDIiXXif7Ce2xiXu3DdiY8Ize0gHYGSnoH2CbKo05DXFGbJ4?=
 =?us-ascii?Q?lw2oVleCnQi2oGcYO1j3USjqoZnRjQyDmZD3h9JvyqUTibCfglCfmhtp9fF1?=
 =?us-ascii?Q?E5ONjlnebkdRaeChTVlBduCjoMtG6HHjRI40Y5MVDRX9XA0lhR77etBVMyqI?=
 =?us-ascii?Q?3ZRlsKeFsEDZjc0Xi2gLoh+QYH0tVTb+RkWtq3ElxyfBlB2kF43IZDIE7qNA?=
 =?us-ascii?Q?CAdW+O2lxYYnVxNxWwHPAJTk4LtTmS/Q0S1NaK8gYn6Nfd9pXuvC2KOMJ+G9?=
 =?us-ascii?Q?ZWicTX85nA9cb0uOPovWe/M9PYKuTDx1BhdJVt23?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb51e3b5-d646-4282-ff31-08dab9b59263
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2022 13:57:52.3999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7zaF0OGGeyGkBilpfnAuw/IsQhYSwoyf3H/ug51dbEPM8nhPQPK1U7b1j79q6nMBZHwjy2aWnCdjiza4byfgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-29_08,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210290098
X-Proofpoint-ORIG-GUID: jf8VUcIMCLsUR2Gxp9vQ1bJy3RBouKuA
X-Proofpoint-GUID: jf8VUcIMCLsUR2Gxp9vQ1bJy3RBouKuA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Patches backported from v5.7 to 5.4.y had fixes from newer versions of
Linux kernel. I had missed including these patches in my previous
patchset posting.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

Brian Foster (1):
  xfs: finish dfops on every insert range shift iteration

Darrick J. Wong (2):
  xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
  xfs: force the log after remapping a synchronous-writes file

 fs/xfs/xfs_bmap_util.c |  2 +-
 fs/xfs/xfs_file.c      | 17 ++++++++++++++++-
 fs/xfs/xfs_qm.c        |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.35.1

