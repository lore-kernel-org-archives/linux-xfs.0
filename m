Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D767EC41513
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 20:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjJQUMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 16:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjJQUMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 16:12:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579A56FB4
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 13:12:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HJxIDG018416
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 20:12:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=zdDFPVr7Z6Khbiqut5OOKnAdBF/KIMHLI47jVPD6Jj4=;
 b=RC9+FtquD0Y1jFDUoh55o2qkJTjX9j0DX+B0hn5qeEjrRqFloQhM+tPA+HI/AOoohzOq
 bIaS/cFx95EEkIqUyMp0YP7h3L7meCUge8XxcencwGsK3aMJgSR4Rl0DL+biy/VWaPNr
 CIRaHyk+B6siTjAQ2/PjTZi178A6Sx/ZU3knTYiw8bL19IxU1pu3XLA45w97biXM+bWh
 tQLasCcluKFIcywj1pJPMwmqqAEJ4mzURU+GxaBibe+x/Ih/LDygRE4Nyyu3hh2DuJiu
 7i/0/B4aIbKdG6NPewaT1AF0fpFIkNW8gOMWP5R79dL7nBPl9CREG+gUe89GXxtmNBu+ +Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu64px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 20:12:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HIdsmx028231
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 20:12:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trfy43bj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 20:12:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7q6Ee/qHeWIhxUBeLpPZYb9PMWp+zh2Jjaw6tImn+qSD6lC6pGqsWjx5Eoni7I/1Y53nm3l1vj2U8zSYpYIDMRP7i6knQUI1WRNHqiEafpRGbajwNHV3dc+nKA4iLEIBIMDSx2nHoEXKpI3lskIEheBoSShk+ebmG7SLQehK3FRM9qj08hobMiXlJb3LB7d6ZMGqqb3t6nVTcv9LwynRn+xNuugBdSjyTwKu5vWN1zFbo8PyEKprNPFSCmIC0NxhcDsRpMzF6NKRDk81MN79w3jXtw48sCjUpTvGE2g7e6cvsG055eJvy4t2ImYV0N5tDeTihP3o0XSy0iBVvaO0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdDFPVr7Z6Khbiqut5OOKnAdBF/KIMHLI47jVPD6Jj4=;
 b=TdoAqyb0MfRvXur7o9WNfD+UuDuP6Kf484XDBMyCRHoqx4/VTTIHyE8b/fMR075ibZxP97yq20nwOhYnyG/tesM7KJtlzMG0oJNRQ5SF0iLu69p9/1vztGS8TEECEhkhnLf1RVcvVk6tDMYbD2uvlhpgwlcRdVjIzm2WBmHUY0F/h9aGIp5YteiULe6rKVFQQDjDTHQjbyCnub2mAo1eORikv4iQzLUvhRTEYtkPg2/3X/zy9AlLOm3EpdUH02jqTRaI3PjipP1ka7qDqyaJdt4C1YAS95Dbtg61JPSqwQojnR9kPSWPt4vWwr/fNn9VNIzNG2oPVf4pkwl9mE1fGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdDFPVr7Z6Khbiqut5OOKnAdBF/KIMHLI47jVPD6Jj4=;
 b=aAP1PcR3+9JQ8siJlp2xL+r9v3WfdtbYE/+YreTs/y8W+1kWisxPcVLWZ5IGkAsm1mZY/erzTEKqquprDxo0XCvVnHrD7wGFLNuQ8fq3422zVSId5xxTA8MqA0XHrPb3IQeWla4n1S0o9rdLeCNUs7yQk2O9QSWGxAJXRQZaeWk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN4PR10MB5573.namprd10.prod.outlook.com (2603:10b6:806:204::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 20:12:13 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::7747:3fe:bfb4:80f1]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::7747:3fe:bfb4:80f1%3]) with mapi id 15.20.6907.021; Tue, 17 Oct 2023
 20:12:13 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Date:   Tue, 17 Oct 2023 13:12:08 -0700
Message-Id: <20231017201208.18127-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::42) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SN4PR10MB5573:EE_
X-MS-Office365-Filtering-Correlation-Id: 92ce19c4-6ebb-4f47-542b-08dbcf4d59fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3YRa9lHWP0xcxzwO7N+4W51vpQXPblB/GhIJ1ENrbiOORCr2kDo7V8vd7kutqAy4mFgfUhoyHgm0DLkCooUYsUHgrU0znj8D3FgDqjkMDJcKIvbnYesQVciaESxoYiFqgBMsqPsCPYmcMNRE1X/I8Jtd5M48ZycMyf8LyOTlrSBUul1ABnHnXS/CvOh/2jddSgIWMocUyXy/FAP4i+3yBtcYwbDdWCb1YMA1Kd27gIY56/wUfmsGX2uf/utbjHgIAMBsB9kfYZKgwpXfGDStvEfO7JaGFbXELrLQHi1apSpE5AQ0LfgFZNLo0eqXhtt2ABrJXumN3Bv7lj7SPQ9eeuKFo89gmuhqFKT3uBrKITytwFQNlYcZm/9W+NMc/DwqM4q/vSiDUrBXvFPAUp2pHTPudzmo3Ljfzwx4iQWg96RuKy6wvQZ4QoFtowcYElPG2R7QMwtms1Jek81/Pxh70axOkRed7/9p/FjPcQvnQXc4r1woliAwdjhycY9pqMcYp31LNquIKrSTjCmxac14qmzlZYfkZ9ZzA7S5n5Ub974=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(39860400002)(376002)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(316002)(6916009)(66946007)(66556008)(86362001)(1076003)(36756003)(83380400001)(38100700002)(6512007)(2616005)(966005)(478600001)(6486002)(66476007)(6666004)(6506007)(41300700001)(44832011)(5660300002)(2906002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QKA9TK+O4YsOdKKKG0njOb7kK8K83CV68gn3cN4tem6RlDLkQ+7L9LCvqOTw?=
 =?us-ascii?Q?MWHyCfPPy24lBHLQlCdIk7VeD1WP9P8wdMXyjUHaCM/QxmKydSnGEdCXksMv?=
 =?us-ascii?Q?qGPPsNyqyP3vLaLWIWk0PWm/Q8rVY0GFYg3nuq6hAjaAH8ozjg4Sau5ZUeLo?=
 =?us-ascii?Q?a8TInFDEdJV4gpnH6oyTVrYyDFxoSvKu3LxyKdlqgz9XWTE+Azy0aCrhhTDf?=
 =?us-ascii?Q?CqGjbNqJCcKqFrjII+qOsytoq4GtUlXIU7Hb8z1GpEj2jdWwvD+5pK1fqwRf?=
 =?us-ascii?Q?f3EPdvJUxUxuZkifStYj4uV5nv1DeGTsSLWxQdIzMa5Q1iM85d5KLdX73sLS?=
 =?us-ascii?Q?RMjyWyFxVhssoEMVUoZN4q336DIZiPUvfXYsFvNBuKIoPm0pDl18i6HL3xHI?=
 =?us-ascii?Q?m1A7p5+Y+B+RWfLKG6YZ8SIjY42OD7BDLXo0B/e5J72yhR1TdDXcsINzqlQR?=
 =?us-ascii?Q?P+HPS/Yt6tob9iP/L9bcePdzTf+pi3LYG1z4sGQmPACjeSkGWQT6E9wPaLDc?=
 =?us-ascii?Q?E3KMP7scUM6W8Qj5MrQKar3f2zC1jasfyDVKgNsLxtlEHmZwhgHlWWGvPX1W?=
 =?us-ascii?Q?EOcOgvO+kMgVSmGc4ImGk7acwIrkt2l6Uy2KU4iya6Py+upViL3orBZcgoRM?=
 =?us-ascii?Q?hHRj5KkgwWhG5Tsh69IqjxoTi2AXOfRdWuCbzYcsY+4DopPjysAYct7CQZB1?=
 =?us-ascii?Q?AqAy2jfA9/qoGqOWHRGNgDLWNJkTy0W6ZD5UZ4tLWYPOMTbq7PgmbfiJRiLf?=
 =?us-ascii?Q?QIq1C+qP7WiLkj+aEYOwz/QUzC4Bs+T9/qQVHUW657WaS7a3SuKeG835T5ao?=
 =?us-ascii?Q?a4Jno3mfohc6T7/MY9JFhBLuHzp/rOmEO+jgzgW4HKHnzfq4LpRwQEHG4ROU?=
 =?us-ascii?Q?ET4/Qc1ddhg5caoAGNMCvrdzeHRtp6gsMwipiHW9obUMEWWvcUqlmmRypFgH?=
 =?us-ascii?Q?j8fJbkGIvB9BrTsdjO3nHzBaPQ8w3WbhtvcuesYHtOaRoRX8HXfV0IUo/tCZ?=
 =?us-ascii?Q?BTE4NAoONu7rKZrLO4ThPMZphaTEuJUK3fXB8ltHvYq0sQunQYYO2RD0kkBa?=
 =?us-ascii?Q?Kj/9kM+QoiknRNKUUycG0hxHAKoAkDAgfWnzRu4cMgezC4TgbbXiIeElxJvr?=
 =?us-ascii?Q?OtDqCpwYdZ7239d8hVVR30kL7vSK2GbD2T9sx1Wsbrve9pfW1cTJLt1kcSTP?=
 =?us-ascii?Q?42R63hvavcwd4Ct+H3Ny7A/kpCVUxg0YT3FhGPx/sDga9PGzlmlusAEagkpg?=
 =?us-ascii?Q?LwFSTK5p97wV1kuIkEWzL6/iEvUMEp4PrspGmtpoWGFe/4yNw3GDLtKR01d9?=
 =?us-ascii?Q?O3d1oJHt9fxZVcu7Pti33VlFv9tx36g8Th/lG0l0+EiaRoKWSJJ+y9N9n2Sk?=
 =?us-ascii?Q?VSerVl4BlDtyOMOnRRTvyUniYCM6SPQaQFxHK83/DfRxsjJuNtmrwo3Jd5oP?=
 =?us-ascii?Q?GbuI9rC/I+nlvti5el/JVQiu4QrxqYQ1uisAjruBmxRkPpO8kCJR5Vg0Km7/?=
 =?us-ascii?Q?DY3BCH6FIzSwKkbQkCmAtA49BBwVRQmgYKWUVF/MSeyp3DFY1qSM+zQKNs89?=
 =?us-ascii?Q?OEKCug/re1DcJpvR3KIZHukpaGn0juYC+UMjBoIznsrNBWVnzxUIIrZ38Rjr?=
 =?us-ascii?Q?nWHiPLnPqIz+LMBcT4KQa3x7yu1tF9QvftKPc27vfj7HD+j3CkQtO8Uy+tEZ?=
 =?us-ascii?Q?pNrXlA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R3Wf1/KIy0EZ3pu87bUhLZnSUeOdc/WAUAk6ZaiUR7kyoyGZxxX4O3hAviBhsIILwcJiDeplR7m7fnCZWnqgD0uly7G6H7KnZLRpbQBryir8zczA/LMbZwxFzADqfgNYMLbY2eksBo9v8UbOc2EmRdw1keCRQPwJQxki32Bnj5DY92MHP+uHtKQCt1FYXxWn7ON13QU/KSbqNTlFImKKT6ZfApOCPYqr/23c/lHMJMgz3qk0KBva/CwiUACCfbxCngNw3R/Zhby8NoHyFNSCCQTgmMHH1zWPVS5q9aKPv+AD7xLOUesB73HqB2rMzdBvt//KHJgh6QDVgqMcjfqIrTQnvUv9BLeBhKVY/UOzzvEJKNwBAFB3QD1BXtJx08NSxsKgrSgigkklp4cn5ATtcdVaUR3ohfQGB/XkDUi8igP4mqbSXmk4Mnh1c8/K4NWME4+MyR5+MOfry5bwNBsVYk2W+w3notwRXTiBcu+Bmu7qxdrq2bfAzlQ4xe1muCXTx3A0B6IEnj52C/+i/ABbAteRndfGHbKCSmHPBqA7TurcbCJNfAGOlkumz1Lgn7llTWuXLS9aJP+eJo5Dij2N2sgInRhbFIYReG2D9+B79qiXj9BAmKEJVPXSeAnZsgwlcLS9cTePJ4ZQzRAF7CLd3fvTdEtpOTsaREZmlc1a9P38qks1CUXLuq3UsuUcN0HIAsCfS1P/DkOq7fVtiy9V3LAVrl4nzrRHojR1vWHc5auSVfF/A23LvamnKSLW0V4csQzep8ucjfi+0IG9Pkk1aQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ce19c4-6ebb-4f47-542b-08dbcf4d59fe
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 20:12:13.3850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jJltPjDV37Wt+E19ZPbkWDRJnVLmd/TdQxO8p3VJW0EjlXO9ZIC8PZeyx2QWUfAh4cDHoskPuI+DD0uOgMznty9UpgdGhRSy2UJtvFi2qE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5573
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170171
X-Proofpoint-GUID: XDXGfkp9wotcgoudh_Q2fa969oe7ESVX
X-Proofpoint-ORIG-GUID: XDXGfkp9wotcgoudh_Q2fa969oe7ESVX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

One of our VM cluster management products needs to snapshot KVM image
files so that they can be restored in case of failure. Snapshotting is
done by redirecting VM disk writes to a sidecar file and using reflink
on the disk image, specifically the FICLONE ioctl as used by
"cp --reflink". Reflink locks the source and destination files while it
operates, which means that reads from the main vm disk image are blocked,
causing the vm to stall. When an image file is heavily fragmented, the
copy process could take several minutes. Some of the vm image files have
50-100 million extent records, and duplicating that much metadata locks
the file for 30 minutes or more. Having activities suspended for such
a long time in a cluster node could result in node eviction.

Clone operations and read IO do not change any data in the source file,
so they should be able to run concurrently. Demote the exclusive locks
taken by FICLONE to shared locks to allow reads while cloning. While a
clone is in progress, writes will take the IOLOCK_EXCL, so they block
until the clone completes.

Link: https://lore.kernel.org/linux-xfs/8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com/
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_file.c    | 67 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c   | 17 +++++++++++
 fs/xfs/xfs_inode.h   |  9 ++++++
 fs/xfs/xfs_reflink.c |  4 +++
 4 files changed, 84 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..3b9500e18f90 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -214,6 +214,47 @@ xfs_ilock_iocb(
 	return 0;
 }
 
+static int
+xfs_ilock_iocb_for_write(
+	struct kiocb		*iocb,
+	unsigned int		*lock_mode)
+{
+	ssize_t			ret;
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+
+	ret = xfs_ilock_iocb(iocb, *lock_mode);
+	if (ret)
+		return ret;
+
+	if (*lock_mode == XFS_IOLOCK_EXCL)
+		return 0;
+	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+		return 0;
+
+	xfs_iunlock(ip, *lock_mode);
+	*lock_mode = XFS_IOLOCK_EXCL;
+	ret = xfs_ilock_iocb(iocb, *lock_mode);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static unsigned int
+xfs_ilock_for_write_fault(
+	struct xfs_inode	*ip)
+{
+	/* get a shared lock if no remapping in progress */
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+		return XFS_MMAPLOCK_SHARED;
+
+	/* wait for remapping to complete */
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	return XFS_MMAPLOCK_EXCL;
+}
+
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -551,7 +592,7 @@ xfs_file_dio_write_aligned(
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 	ret = xfs_file_write_checks(iocb, from, &iolock);
@@ -618,7 +659,7 @@ xfs_file_dio_write_unaligned(
 		flags = IOMAP_DIO_FORCE_WAIT;
 	}
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 
@@ -1180,7 +1221,7 @@ xfs_file_remap_range(
 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_iunlock2_io_mmap(src, dest);
+	xfs_iunlock2_remapping(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
@@ -1328,6 +1369,7 @@ __xfs_filemap_fault(
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	vm_fault_t		ret;
+	unsigned int		lock_mode = 0;
 
 	trace_xfs_filemap_fault(ip, order, write_fault);
 
@@ -1336,25 +1378,24 @@ __xfs_filemap_fault(
 		file_update_time(vmf->vma->vm_file);
 	}
 
+	if (IS_DAX(inode) || write_fault)
+		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
+
 	if (IS_DAX(inode)) {
 		pfn_t pfn;
 
-		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, order, pfn);
-		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	} else if (write_fault) {
+		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
 	} else {
-		if (write_fault) {
-			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-			ret = iomap_page_mkwrite(vmf,
-					&xfs_page_mkwrite_iomap_ops);
-			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-		} else {
-			ret = filemap_fault(vmf);
-		}
+		ret = filemap_fault(vmf);
 	}
 
+	if (lock_mode)
+		xfs_iunlock(XFS_I(inode), lock_mode);
+
 	if (write_fault)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4d55f58d99b7..97b0078249fd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3621,6 +3621,23 @@ xfs_iunlock2_io_mmap(
 		inode_unlock(VFS_I(ip1));
 }
 
+/* Drop the MMAPLOCK and the IOLOCK after a remap completes. */
+void
+xfs_iunlock2_remapping(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	xfs_iflags_clear(ip1, XFS_IREMAPPING);
+
+	if (ip1 != ip2)
+		xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
+	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+
+	if (ip1 != ip2)
+		inode_unlock_shared(VFS_I(ip1));
+	inode_unlock(VFS_I(ip2));
+}
+
 /*
  * Reload the incore inode list for this inode.  Caller should ensure that
  * the link count cannot change, either by taking ILOCK_SHARED or otherwise
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0c5bdb91152e..3dc47937da5d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -347,6 +347,14 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 /* Quotacheck is running but inode has not been added to quota counts. */
 #define XFS_IQUOTAUNCHECKED	(1 << 14)
 
+/*
+ * Remap in progress. Callers that wish to update file data while
+ * holding a shared IOLOCK or MMAPLOCK must drop the lock and retake
+ * the lock in exclusive mode. Relocking the file will block until
+ * IREMAPPING is cleared.
+ */
+#define XFS_IREMAPPING		(1U << 15)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -595,6 +603,7 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
 static inline bool
 xfs_inode_unlinked_incomplete(
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eb9102453aff..658edee8381d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	xfs_iflags_set(src, XFS_IREMAPPING);
+	if (inode_in != inode_out)
+		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
 	return 0;
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
-- 
2.34.1

