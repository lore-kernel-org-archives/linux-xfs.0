Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951E4C636CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBMEGV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBMEGS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE858EC59
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:17 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iQwk028487;
        Mon, 13 Feb 2023 04:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=zybiaFhdstfZVltvLoEsI2kweZwDOLwa+Pw7XrexuyY=;
 b=g+5uGSaCnnIk22k4Wa6WBm1kW0S5JTS3sWbGWW4tPINe3tBi63nLzWgBOUU2eL0hrqkV
 m0rLFJaYrkECOSxozhkW2YdvkpN597MGBnjK0C6rOK8G51inX8GZ0MJfnauwcUVHgPEO
 sOcWfQ+YuEpE8Qorm21q3m2SRsERuFknBmW8eynMkgu9oTu5War7tkJ4lhw3eUNO117e
 pAnXFS7I7kTA6S1PNL0YlJU8WRt5qnwPlZ45ErMdxt7ZcFqNs0G7m6Vd1Bl8YsIf+0St
 SCtcav25NxtWrQS8ZDMXRgT3eDfBixdYArCDSJpjC87Ak0ovr+L/KSsQvRfGMoXZ+qcH xQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3jtsu9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3BBRl017984;
        Mon, 13 Feb 2023 04:06:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f42946-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9lwaOjo04gF1+1whIbRVaKFmruc/o7Cj9R6S/DDbIrkOscM2VhzflSVCVwXu0u+/3G5iolEviDZDien5KmZpNUZt7c4buajB2XWYFRfUcl9+lF0WysQNiRIjHo1mbcJaFL1LWBtniUoHXx9GT41ZX632KRrtutcixO79ocmVgciuv+4LvDYr3Ft7YFvQ/WzrOXhCXqmIhnFhFZuzObCDLazGcUmshrzpbjjAoW+nBfV7SO/8eghl1/Agk6w9pvI697v7+1WDJtFUw6jDryveUHrwPFXDh/4ts7NHqG6lqAoiwSmKHcBFmbX2GdBdHSyN2Nl9nEijXJUXAfckIQP6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zybiaFhdstfZVltvLoEsI2kweZwDOLwa+Pw7XrexuyY=;
 b=WSr44K+wmW55vcaB5agZjnrUQnnGr2zvuUmUiIXg9qiWrbrw1qcA01XD86xySo0eWG4fVg4YSZXtwv8yYdZKBrmhJliOPK9DZRzshYI2JhgpifPMai06mnkH9TJhrYZ6E6aV74aRwrIwDEvauOEgeZrajn4truhiqZpHNGETVpF/ZHqpuMltbUaCjKkTTYYrAwmg+ftWMNJO3sRVYuj837G9idIPGyCvcU22CfvX794D/+vaIg8smY1yk+Qn7XzKl55RKgOC7e46pN67umoaRiSNM9rDZ8ex9yTNK9bLi7A1Ii5JFL1Dvb3sQ/a/d4eYMGFHfuDwbpaghClfOS8fvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zybiaFhdstfZVltvLoEsI2kweZwDOLwa+Pw7XrexuyY=;
 b=Mrztvt+DHUiSG9TV3wJhyqAM9n0/uRXQwT8hSZbC/3c51Oc/4avz4ZsShhXFg6NrA/M6tMEXQG2mC02XH7UJTfX2GQvkQAfkzSzdXlRL+6kRGjozJK51dM5g6NYeo5ePASx3R9cWEuwlE2rQMg7Q6LXpU7xAkuUllWuOMgE+6Jk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 10/25] xfs: fix finobt btree block recovery ordering
Date:   Mon, 13 Feb 2023 09:34:30 +0530
Message-Id: <20230213040445.192946-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: aabb313c-a597-44ff-bed5-08db0d77a4b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Q+B83zvA/hg2Dd0r0WqxfoDIPopdVVi/Ec93O+RJTlPQNKD14mI93rp5UoZaD6yRorZQb3IRmegk3pUCkJp2isKOG+todG/7iic6tbYz6Eb8iSyKfIr/a3n+AkMbZgyFhMxfB7aYfik3JDhXEUBcLkIUvRo+M2Nojx6brY06k2uZsmG12GJZymGX514OUxUXqrs9AEtmeTT4IA7Qo3v8bM1io7Tmu/tKlZ+sU6BwBhsTFKTVAdepr4r15APxcTXSe6NRJSavWJsjYHMFShGS2EUQJiWy1b8anw6vpccXp2mYdPWzSrDywPU30Fyq6yAEEn1Szo0lfvmHAuldmX7Ze2g8dori5hlTU3PMkCF2VoKO9yeWrOdlJ/nn2lC8rSfH0HAkI+al/HsRJCQ/OPfVsIFEhTe5Ih0QnFRLUvAYhLwFAeLhvbXpwFWlC7TTAROJgroCLMMocDPzHjSVATOuytr/VVrTuqOMS04D8uSSSws9zCT+ZzzwmwyZDYvu3+aY5frp8bT2EyCuS83rFZbTfv1RlISE2jkWcMWtixFYq2RAH8s+3Sd4cdofdmx/ADuzYb49G+HYDtmffyApfd3yWtV4yB27Cfh6qzJKIhYRQGiuVwS8g6xqviPjLCoowWLjf1+n51Upj2Y3d4VZlkAqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UhInvgwAg/9fVkpH8qUhRqloaqBxCngpkm0aqc51ke1DfEYplWKGmufbKPcL?=
 =?us-ascii?Q?NKz/vsnCaTJwlLwkHTOgQ/9CM4GA8OxnhO2rEgtHArUAEtjoS3XZfOpkJeXb?=
 =?us-ascii?Q?VD78GE0u21k4WiYDsFaKW1UqiUO2hlh2j5WhGgvJXsep1iOHV+l9+9+4tJp4?=
 =?us-ascii?Q?AF7i8evPrm15fXi2qbflp9xMVlUi1aMy87FnIsqtLaZYEFN88l311wX59cLJ?=
 =?us-ascii?Q?UGj7+mS8Dm2ET++A3dsnF6GzY6gTPnMjpROR2W61hz1mwVmguEM13z3EnuNi?=
 =?us-ascii?Q?Liw/nYH13OyZNdvwMok9Xh28TxZ6bVZoXy5CxX/ZKQrZr9fyim0kZHKqIYdB?=
 =?us-ascii?Q?fRF9giPfQysAegiD9SkjWDxSJtZ6oCe0OAYjEYpHgwQsXXt0IWxrNdverEIW?=
 =?us-ascii?Q?PVvLGi8O1zJCE1VTx6CWhPw4RPzhgmR2/HtrDKkWIjsC5Ozs5dOz8GaBK2l2?=
 =?us-ascii?Q?qf0Sf6qoMVKsUWkLGVoPSGxbYbiyl1zL3Xxtv+NMYSbFVLTwRUb1CBqG6FJ+?=
 =?us-ascii?Q?oHPv1+3Hiti0qv32BM2Zy4pg/k2HeGtDAixL1Dt+AO3CU5jVCPt2/3DuIwRN?=
 =?us-ascii?Q?wEJKQrt3tP6T1y3lGph0tCtKfOnyvFh89b7uDxzTQ4CYEGtKzHSug5t1lFDG?=
 =?us-ascii?Q?W/UC8JDqTruoPVEVpnQ4Poc0RVVXFKxMBuQT4/cZOqTmL0jJwPNoILy75Wbm?=
 =?us-ascii?Q?jZzNIbbXUlCkI6Kk7WxdGi0SEd+dRpJpvF5EVvEPM9MM9219WvV0iv/eLtqr?=
 =?us-ascii?Q?f5nl3N7sKOwcAswdCvuJJyOHKR83/+AlUt57PTfAllusKZ8fCVU/RIm0zQXl?=
 =?us-ascii?Q?r7N/62D4zJHSRwr1AZ/dxME08Y2CoUt2zS1R71x7VwzR2aj1/pYnBuXue12k?=
 =?us-ascii?Q?yg9zPcSo6Kyg3BeHQpDIF6q3TZM6wEAH4QjNpfXNkoD/Fz5/0cegLugpg+b9?=
 =?us-ascii?Q?bc+IhrhYzCKCNlyipjGkvitBZW1wzjFNWz4jpN3L/p2NdpG0EYXdCHPVAVZJ?=
 =?us-ascii?Q?mBv+7UXocp10YIDVICuXoWyKNfNdheFRAIclVaDvLnYyvhaO7OAeuJmSlNF7?=
 =?us-ascii?Q?nltMEDNj4mQDI2EV50nmpByYItPEUKUqeE3v/iP6k+GdDDY+aDlvw7cLI3fr?=
 =?us-ascii?Q?T3l8RAQIr75oTF8q7TuZHR3O6suc1XbdihEvsL1uSFIgSU3wJlbH/2JXdbES?=
 =?us-ascii?Q?I5n0cxq9zp9UFkHAcuLfn1aKrnslSjQ66yB3ixcgkRqeL4XmE61bnENN5OP3?=
 =?us-ascii?Q?rJOZcTkYrhEHN0XctyCgbRTm1fBpjFaH+rI/rtfHssNJPMsuXvyP4ZgGqHqu?=
 =?us-ascii?Q?xHeYVHWY/ctodQwmMG5JZJWy/cpOr+LvP/+9UIo/g4aQjWnn/NwlnXULSjf3?=
 =?us-ascii?Q?ljPQ35ae7tkisPqPE7bxZN3MJDDAxAeSJlGY3Rds2zObDrLLQp0FEf8Sxk/+?=
 =?us-ascii?Q?d0Vxfc4Y/0UwKM+aTHSsm4I3hz+v+XDZjXXa1N/GihbPUodBMsCF8MUpvWqw?=
 =?us-ascii?Q?89ecaSygh6S1VR91jCYxfEkiz8dhsWT644RTsY7fYNGjdO4VYHzZMQV6BfkK?=
 =?us-ascii?Q?rJzXgWvBe8sXJxfxOCXDONGamvl2LTxOFnGFGJt36MCgdygT54s3Ddf4xQca?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GfpxMkdGx4W4J4hfZ2bfqBaHp+ch2z8E/n+ODOMxzi85aMhdky5Jrm/Khe5/FzMOVeJme0yznGdD64g6iyuF1e6/jregbi67X+g2of7dxZ5SHhsljNk7pbaR5VlC6/JRj00+bwC0nWX7E6DPYpLy2E4EJIKMzbPKFC317UHYHeG4QepPjMMSxCFRKxRIHv5fZwMJGJJV/9ft6FpWoij/l/DayEw1dnxS0czSOFuff//ecGjQy/XktkONQ1ouhaGFvz37eV++fz2ykxyO4fxhIFAVKp9AXVmgnftVDPvQaIVukqCUIp87e5VXOsU8YLGZuZDygJI3trCZWfWtyL8FwqhcseCXAaOt222dh0uZqFJtOPOtsa9pzIpAsSt+ecHM0PGK/zhokl9yz9HgOBSzCO1CBdrawG/Mrxcw+jHCQzGTkjmykONfOk9VFvHYDamUHJtaW34SYXs6bV7LiuG87NjtNsixUJqsAEO6bKAjCJm/3zKizXiHfalHVi94QstERZjUUGOZ3Xz7BfjzmwN4yHmUQrtWTK/UmBbmyQ/UUPkAKHJxRwrSFgfsC1tqXotbfT3+WQJnLXvw2z1RGwnJECkfueBFwCCLYz7Q7Bdx15UKEGI6areJkbGRpUG+vbeniabJg81s3T6Jjhylu8EaDeKgW83Yhhpypfe+yQ6CnY03J9cxub4Wvo1Cqe2TmS62fANQFHJfT3M+WOi+Ac/PGttVLXRX16YUHFqOCq5RN8p1SLUIJPfI569CWSGdyuk3b7Sz0Pw1jOxgtWU1mDpFw0c/siskzwGXRP/CQO+bngwnkh+gKlMvzSoCUFVXPioF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabb313c-a597-44ff-bed5-08db0d77a4b3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:12.1381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnd0zNOMTlnJEkzBJaEk+RuLxrixGlnhJKbVDMZRfCFvk+llwpeEzp/oiwXPKXJ/ztLFB69Ca6I0KAQ1l9swxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-ORIG-GUID: zRtcPTeVxBYzTZCyphbkmJNVKrbcc4QR
X-Proofpoint-GUID: zRtcPTeVxBYzTZCyphbkmJNVKrbcc4QR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 671459676ab0e1d371c8d6b184ad1faa05b6941e upstream.

[ In 5.4.y, xlog_recover_get_buf_lsn() is defined inside
  fs/xfs/xfs_log_recover.c ]

Nathan popped up on #xfs and pointed out that we fail to handle
finobt btree blocks in xlog_recover_get_buf_lsn(). This means they
always fall through the entire magic number matching code to "recover
immediately". Whilst most of the time this is the correct behaviour,
occasionally it will be incorrect and could potentially overwrite
more recent metadata because we don't check the LSN in the on disk
metadata at all.

This bug has been present since the finobt was first introduced, and
is a potential cause of the occasional xfs_iget_check_free_state()
failures we see that indicate that the inode btree state does not
match the on disk inode state.

Fixes: aafc3c246529 ("xfs: support the XFS_BTNUM_FINOBT free inode btree type")
Reported-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cffa9b695de8..0d920c363939 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2206,6 +2206,8 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTC_MAGIC:
 	case XFS_RMAP_CRC_MAGIC:
 	case XFS_REFC_CRC_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+	case XFS_FIBT_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;
-- 
2.35.1

