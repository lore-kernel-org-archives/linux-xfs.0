Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616C2C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBIICK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBIICJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3B526867
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197QKZQ012373
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=2mD/+w/gIEcqSKEpz/PYuGTNBS+UC4p44L++8n5sVQ4=;
 b=TR/cPW/RK0UAkoNooabojAw6PALFiJbvEnhK/GwBmaDxPhLYPlrS5fg9oOVwwEs6OLQT
 tmMqtiKSvmsw7kcXQnFRKD6Pm0xnDD0SZCVedL5mGbZT0AAPExDGqQMN87YsYq79mLzF
 kK7Ycnjg8c0g2iiJglbfO5J+8tfDXw07OGGoVMPM4auC7M6TTbnSEyJPMw+fGyaE7/F/
 riTsJFFMh/oQ+j3JxFsKHBWltUyGisR31Gmd9WnnIYYAZH/2IvoItpuxzxWqJEmmK7tD
 wdrCq8sY/xJ+WmDFuO6i0xc9tqVp1wkpYlFhuVoNkUflUIoAfoe/eKv/JOLymHo2WRmk iQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdt4a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196eRNY035966
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdter8ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILdgbvoettXSUziwJj0ISGeGUCUVeUoz5BQVepbJS4dxefrKjY2ncQrcYejn0uzRffcRGfcg30ySerBajxjP6f3nKVDanKpxDj6bLVbLTRukjP4WvxWg9q0sLnY9HcLarbxCxTy01hnR8OJ+STUiR6a+39+aY/zgdA8DjF0vGDOdDsEYSsSiIRv7cpRdFfjliBP87/BByo26Dg9CwsA7k8mCoTU+uUliLbgCP5mFOdzo3r5n3KU4zjRzSKy3aOZUy8HqMWyHteC9J4O9s7pm9LhqTQfqgucf+MkeY3sUJ8ZSgm9/uN6ZohxfZcM/CMCYKJH3DxVf8oReXTg4Xk9BGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mD/+w/gIEcqSKEpz/PYuGTNBS+UC4p44L++8n5sVQ4=;
 b=n6wzecPqYlSnAJVFlz8JdimfEUlg4LWkD0NYyHnspR2kyEKeuAXe8b16QmjjZT6NmVC2ETMcPZaZ2Kx80ILFvjLrtpKP/2C3tBpS/Z6MW6MhLKjkgm8tXER6oEqFJm2av6tJmOjngs5gJgaaC5KqBWI32dz0U07xfAIxDKQcMikhbzgX8zGSRmmFkWCIS8d+NzxXCIeYgEmpBQJqHFRMRALEOf2Q94VxuIkY+GNiu2897hGj2N5HRB77cCrAIkuLNWqcQ8bcu2Vm3EVLNGOL1jbrAnLFtws1ZB0fCv6h8FKOU5Jaj9BBRxYnChfl8xDWIoWHYoFFrXHa/WzsROkR0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mD/+w/gIEcqSKEpz/PYuGTNBS+UC4p44L++8n5sVQ4=;
 b=ly+VAS/GrzRekGrUYO98kv26i7RO9sVQsyEGeQFav9e6teDT16H4wXYBTf8QWm3apXag6wm58CyVadtm77zNaFACR00evtqOt5RTbiX/kPq9UAsdlcwTN5G+w4AnQb0eL2VtA39aVOdRCh+0LZ0uBlynuukDkA2QITCY+iOAZCA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:03 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 08/28] xfs: get directory offset when adding directory name
Date:   Thu,  9 Feb 2023 01:01:26 -0700
Message-Id: <20230209080146.378973-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0383.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: ba504d60-fd9c-4fad-071d-08db0a73eddc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4E5cLmXWldPJOMWfR5eQ65L1V1QTBwutQmRV3qdkTY7LzaIzNBfSfcOv+dzHEs9TNiZAyn7GwkEM8oXNkJOUzoSBHTRB65RKduAQF1jMw9uRytVTWlzJ1SgDK3xAxBEpk7d4SRfJeJgofgKIKziqElayKY7vjDYcKUXvN5IKeliOYv6Rz24Me+ttrjOR9DR4ou0ZQmWiAgZ9/878c8T5dUYlGFSgRIMwFFeJyRZivb4hn7ddtxYtWCEbsuP3q+5PPDEFpNzePS+UeFfQMPydsnEzCV0IDSLU7zsjj6jUOa9MW0MKA4EgebDI70zrvNGd6Wx/fwDCZd5KeDDxFapVzZl/TXdAAlcNWpOclUfXJlpqnZGTnK4X66NPfe4gWmVq/wRT7z6GXJYXM8U1iW16BQS/rTNH4U4ZUbGxmA+IG+TjSE9Zd1oEHNNeAcjb61drUe1HUnmFiZgqbUA8OENLnffgsyuFDJ848JGy+hdpUu3YS+XCgw66vi5bA1cpjbssUNghfF+3Q0DAJL8vD+Q+9lhR208fDP+dSuADrGE8BHDcpe4KD/+buSwmlgMulsdxwifLaUceZVm0Ncl0VW2Uk0R6lhrYkGxoEJ7+v+Ei2kBAy2Q72HGkZLPc4aqUDoDtCGHLmpojUNMwXSTFD3Q/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OM9vVJfT478CDMJMPhmoa3d/ZvKQHynfFiHS9tTIH/ED02y/HjjdjnFMGNUD?=
 =?us-ascii?Q?Ol0fP2mywzDZMGURTpxjbc67FB//Mjkfc3uAJYTNuKTaogfTtJVxxZdaasER?=
 =?us-ascii?Q?K8mOJqg6rqbbJxtA7Bjr/HSWBIdUbwlon9IEoOJ8yF4EkQL0OCty4FqEIIz2?=
 =?us-ascii?Q?vlY3QfuyzVpO0Ct9lhBsn0NjaU0pglWy+RCRjyook4KmcEzy6CKZEQ+x2pNh?=
 =?us-ascii?Q?aPCTISv6haJFVXXEnCLPnB8GBDUoxnBJei/1McEtcL0HgLbqSvKBKo5mhUSY?=
 =?us-ascii?Q?nzowbYi/yj/SiUhzLOFHv1TnlDskhpaIGRCuaNVvfsxp7GDExIXaGk1l08BG?=
 =?us-ascii?Q?pBIHQr5pnN6PvkQpw/2nsWsCLWH7GWC5T7Yo9xRT4jpWIlyXAT/4uytcoiB0?=
 =?us-ascii?Q?8FHEMDfPWPCgspbMB2ELaVrPCa274U6En/U3P3u/nxTlvAtZitDhVbhkXsLQ?=
 =?us-ascii?Q?Z5tzFTVVjBUtOzlEgQaAzzFEYXX/4ZNXKBvV5cEGIgpJfuBOx6NE0BxKOBHi?=
 =?us-ascii?Q?fVs8Q9p5W9uU6iVdeDLNkcY5chFF5VyjZtyRjiqBaRX46x965jx6/CKajCmI?=
 =?us-ascii?Q?wa2UGjsxwukJL21J2dkpD1XMbuXFKVhLKWQuq5YPW39xAlw2jFx88/NQiVzK?=
 =?us-ascii?Q?QEpshzp6zYVakXLrBPORJ9M2aXCa8iKEk36tRPALe6TCsJCI1Usmc9Ev6qpc?=
 =?us-ascii?Q?FoFH8iJkNTVMCNtfBxPWXXD0vJXzUgTIR8Z31DYFqiPF1VA0EHb5ouQxAq4q?=
 =?us-ascii?Q?U9mdOKiQxaq0cLXOeogshJBq2qv27kcsXKoRoj/+51rE8l+NiZI58t+GRy9c?=
 =?us-ascii?Q?drCQentUoa4C/AXd5mTDMaF2VpbMp675RmZvP7Mbaf1czfulPcFqc/Cfwnqv?=
 =?us-ascii?Q?G6D49Pa1rE/IM1SQrydKdFaCryIgufzkrAWewXQSQOlhjCpIUCX3cCLxkCDC?=
 =?us-ascii?Q?IzoTw34ArXw0eUs1V9hDQiOcBA8Wu1xgQokzdSn73pPM3TNCHV092iExJEPq?=
 =?us-ascii?Q?1Ofx7W+yiq10G5wepmTYPLj0X9gEpnZkyzi8l8SHyXIGg7mN4a8xjCC1pvhY?=
 =?us-ascii?Q?sXH9ntj+0bdrnDPHI61GkTuKriA986u4k3pnCloBlmmqawHwiCgj/gcXnpwc?=
 =?us-ascii?Q?siasdRy9rbM+kXD472NefdJAWpF+PgGd6xFSW/YNCCh+rNrp6+TovtNiOYTx?=
 =?us-ascii?Q?ecxCr8Pqu/Bw5gOhDXktEUxI9tzUEr3Ph+WZwhkjLfLbGhWxhf+EhO4ePgUh?=
 =?us-ascii?Q?q1WnzdOZRLDN1xsRRSjMWUVwVCmrmyRpZ1j7oe5yYvRJN0fOEncGpu6fAbGR?=
 =?us-ascii?Q?ldQO8I180W8vdOL3X3bPl4smNMJk+lB2d7Y4v8OdcQSDcWTCv+9ds7/DM5tb?=
 =?us-ascii?Q?NrHTS1IGV1vjXmYzmMDeS31M05AuXzUAt5o5TRv7UEjUlyXooYCJd6mW81hN?=
 =?us-ascii?Q?LR4CrCg7HEgSEt3W7C+0ELVEv254G2IaCEzCWE5yJl4RfuPDyBOGXNzsy7H4?=
 =?us-ascii?Q?2/R68m0FdgIN6X2lYrFh9wPkgUSpC8iskky0iPCcuhG2eXIZnyyW4KR6OGGj?=
 =?us-ascii?Q?3uLwRRJHJDyZmt7SW4jZeVOnOi+Z0NMCg9mCwK+GsmKS5Q7ZXd6S+FHJx6S0?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kJfkRdDVaqlUDGBnzIzHHhWhsP1PKHKWJvnonQy16xcBX/AdUug/HdfHkgGwo9gZOdRRQpsSFSViJGXDdUyPmEetrQdhK9Tq2iJszUzzjtujEyJIzXednmgwYjesdWNLtLJTpIaGQjK9StRm7Y/bjizdb5yox84Lf9K8HxlRd31cISgEvhurM9D/Bs2eiHFur4lIZTT1QE1DADG7qwE+t8ARh0g/Vwi32veR5YU8YZ1nHM7FJ0TG3fkDV6sfCdkhi0/BQmMivO3/9SzpydMmgeXDFV94Tc0kHclbLoQVuQrsFa0OOwky3XVXinaCLf2lt6kzKBvAVydw4ydpQvKRr4o0uD/qbz1dP31YjtLPd8J2ir38TeQ1aHIBLh0H3DZYYinalPiWMl7jLQMREZgXhawibppLBDMaGQA2IYGQC/NaMftMQfIQIrbJwA7VHfbCkDe5o1d8fdRJYC9ap+pdm8aRC5MWv9DZ7WuCxYfSOC/0Sglrxz+1Jsr0apQ3OL5eAPS3g2cbb1+Kz5YNW/ZLbeNbI56wau82IBhVm0lm19nKqvm8HUmJenAfQHI1ozU95IIhnAnh0bvWK0iCwW1DmJ8Zj00Tyl1F9P/tUonhV9dHd/dCO2mQKQUQKYsuOY4/CIsfXVJxwskNYQB13fennGqaKQqhpbPKMIwA7IUZL2ewwDF5BIBDwDn0vBctdy5JJrltoE0U5ZNPlwrDe+wp4WaG3oHi2eki4VfcXTjdnSJCaZw66ZYLmD3EsqH15shc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba504d60-fd9c-4fad-071d-08db0a73eddc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:03.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GYdLtHIK7j5Qm7XjFrNuM2OZwi7Zpw7QVFLV3xuTpWsgFn7zf9HFfZd3T0+g+nN9cJfogEPCDBM8yxLl/0LwoAGvdmwOS5ppUG7Wui0acv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: 8bn4ZqrKF3fM_WaJswi0EzzMXfNBZsre
X-Proofpoint-GUID: 8bn4ZqrKF3fM_WaJswi0EzzMXfNBZsre
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..69a6561c22cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..d96954478696 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d..9ab520b66547 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d38..44bc4ba3da8a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 267d629a33d9..143de4202cf4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1264,7 +1264,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3001,7 +3001,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

