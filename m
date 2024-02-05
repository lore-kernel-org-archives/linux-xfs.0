Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3065A4DA02
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171655; cv=fail; b=ES3gNWikCnAvn8evmBgiQN6cmE53m7HpMARYYoIs84MUSH1PHCbPy3BguKXoi/EcGxZbotkqgQzs9o81tUj/dDOrEUjSnGeF41gs7RqH2mdTRu7xp7mE+lqE9Essp8Ria4534mwPgLHLFyOJG6xqGV/Idgx3huT6wCsVNcB7I2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171655; c=relaxed/simple;
	bh=aLjFHEdhfDp1snEEA6bJMvlFHVX2iUg1BibARViqJ0c=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HSGkoRSs9iJ67KuAJtl2anLefWF5K1mhuBzUR6sevLmPml+FGowSfiISALA0OPkgYrb+kpXVh6VTCVj+hs4WWMtXa9GCpal3XaIsc7K9HfKpzrWTYvbyG+kaGT/cvpZyw2p4InGlt6Op33GEXmquybQHYvg0C6vsuWhzc0eMaBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CxYTKWm7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v4zxAAg1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CxYTKWm7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v4zxAAg1"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFkeU024990
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=0KKVZ1caTeQqLNoRwTQXdwZybi+h6QhSESfBwIlbIfw=;
 b=CxYTKWm7DuWCuQW+C/vB8ZpU8Tr01k9c5Kq0oh7ck5DAyXOGS9KhhwVbGvS0148UqyBU
 2KpebKWpwhb1fJTsBfA2BxMEL9fDOGkh7wqt0Eag8sd1fzboPR5TFgjAVwPd/rDjFQ1x
 NU99svBlshfySlu3IF/nr+nYVBBy2irtOLtPxoCijuDTttTI4fjjSUSHQPuutvLtVL+I
 cte3UNcU19vK36cLk4//quAp+BSR8jMu5SPDlHH1p9AS80zeUwk7O1qZXaeXoWr7+Uwy
 MCOoDUg3SwfLR/3MYMaGRicKqEFcCxgrJxTBANr255RoKGRduaGnxZpG73VdseUsvttK 5w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32naby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415M6cc2036747
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6e1nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGpLYywcK8JLAjTT6mP4qM+sX1QgR++wg/nv9GEbbcQhQlMiww8WHSecu/JMpjC/n2KbX4ExHX8ZJcm8wgD0PCkP4F5IkQY9jbjyGGlXi2GiSELX9SrtVlPOlwPUm1P2vE4VsdgfUzemekQphglb0rrEoQL0pE4wg6NVbuqa7CjII7wXrgMx5e6t+ji5UxKzWJ00pVRGz6WIOAaO+w8R4fGGTLUo7qc4hPv5f2oWyp94VfQki72V8aVyQKFL7PmR6X1B+E04O7x4ufXKc6Ld8AfFKkHmm8EmOu8Z9VV2omRMz1TQ0o1jfJkHlZH23STsaUPtS8gEAQv4hx+KAvgjNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KKVZ1caTeQqLNoRwTQXdwZybi+h6QhSESfBwIlbIfw=;
 b=iuoVvgvp9NmU6pyCt9+i52BKaPwBLVQe/DX5yVvj5jo+s8c8Aa2yK9mBJc3YnZBoOghKyfvJhqKH0YGL1WVxGncZlnt/4f2LpJQpxgYiCcgrePSiPZ3LIgKvDDMJdgrP9SxJoODemx5gTURapAs/5RdRepta41c1PbI3pRevB/6VpK0OsE7yPLdB19UCLYAtHBvdelX+KLjPFjSXmOYid7Z1Wt3uyAFyvRIoh3R+X7hj8JtgLLmzAh5gr34c/hF6+ZwNZikXvZqYYB1VXJFjEGbJza/lg2KA5E4qbRwoxh8vKOgRidhqnjRka1bLEFWuvF4TqSaLXXfUsvHWJi80Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KKVZ1caTeQqLNoRwTQXdwZybi+h6QhSESfBwIlbIfw=;
 b=v4zxAAg1Kn/ajdkyXFPhhLBD3NOQ0fl2SULoGh9OA0zqKazq3dCpM/qFCu/1F9i0gGX1bouyrTU4DEDv/prVNpeTWJTaydDNEWdTtIEV0wz79UcBDMOWJ7Dj9DBxZMMuYs0v29rgqMl70S2xP3EKRSVdmlalTsIDB4zr9VDq8J4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:48 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:48 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 15/21] xfs: fix internal error from AGFL exhaustion
Date: Mon,  5 Feb 2024 14:20:05 -0800
Message-Id: <20240205222011.95476-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 56efe0d4-3752-4d6f-5cc3-08dc2698b489
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LWYxxl3gcasthJm+ZwgJ6dyK6riYsu5H8rNlrqYsROuL+8EgQktvJpa3szpMIc0SLbXi7DZ8xOGujC0zkCrQamKJDryw7IG9Cu0uA6jqfv33uhRJvfrc6ZU1+a6hIfty59JK98N01P9zJ38iWi6ez0Ot6QRsvWSkrgVCfMr9OGX7HoK0Bdk5IZclrem+LV+OlFLNo0AoXmAtjuWVIgULqdBY4V3t81lw/WmyDT9nl9sZj1DdaWUz+8dM7Gy0+m+/BkjJaiBWElAOSFN2AjS3+ZelfO3OWUt/B3OlPdP/g4tomIqwhbl50ft3cXts3RBknpTF4MOe6T1pagEByTMH3zYpu3N1bBCHk0OlKFa8kpMOgbCca6/3qwF4wdbnzQA52dDyqwz1I/gNW+K0RncGCHRxt5WrfVpBV8tMba3ugaKk830k0WG/Ra9ELc4KE6vq0uNu+DAXvZaIULYNQi1fOKu9a03VltcD8Q06AUqrxKmcWcSeYyBrP6V0Xbxsy2TIyWqwRaNopHwQEXcTX+A+pCaodxWPr0FDGmV60akeMjVDS4fXdzGDjKW54zNsaO6Z
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?rCkm2D4WRyQ2QCvgPSAIMYKbiOmUgnYkhrW067i1yx4I2ZRsgY82Sj6rYTvR?=
 =?us-ascii?Q?wiBfGD1aTsv29Utk+n8uE+fQqPmBsSLB5xYHtsSZ5mozcby6tn3heSwaYdsD?=
 =?us-ascii?Q?PqxuHoX9mOaXO+SFWcUxVkdVlnxFWWgUHCW5Zrh3AU+WuEyir9Pr8w+RzVVB?=
 =?us-ascii?Q?2tloDsPb3cA+jAz9PRdRQcSGZaB5beJ3eS1bdPpju7sc6Eu7brLdMTy5Fb60?=
 =?us-ascii?Q?GMN0oACNVHuIdG5Dy1OFZCaDPXJaXdwtpijSlLWnLv8DcyQvfUwAXf8zDRS1?=
 =?us-ascii?Q?qPfYzzLpxg/IlMZpKEkqQVcCUSVDFNUiD08SWiYJEtXCHzs/bnVqsTYXiPOF?=
 =?us-ascii?Q?T/ylGZMqVj22Y3xV1fVKrY5UuVf04q2IN4UPQ8WcD2amy3b/KSzlYiA/+npy?=
 =?us-ascii?Q?47pXTN7j7QHeoo/b9ObnxuXg4h/IbIfLkLJw7F8UuraOwGQXVqDWdcNdt+6I?=
 =?us-ascii?Q?W+2xmYmUjX/C+WksdyZFrKuIrSAled1rO4b8x6WZEEB2MHerDWguJBtBdiEf?=
 =?us-ascii?Q?DuZlWgl0UqmA+4XxGvy425PkHa3eoTfc9gm1OzuEnfV5kcXTlYocqwAVm28o?=
 =?us-ascii?Q?8PjKhuMBumd68DM16h+R+5Jn4iD6QU4DFwpAR5QKrDIXyFowaxeQnvH73HvN?=
 =?us-ascii?Q?QXengKHua5LCdNpgX5XBHXGueUNnEpibEwHpmUivqWCXOejdUx+/GhQzcjGz?=
 =?us-ascii?Q?Lip3M+5u8dwWqBntXyzDFAguPTW8cNHt/4XwRTV4OA3RBMOoSdvs3/c1QcOe?=
 =?us-ascii?Q?NAt/YorPxLCknNh4zdQS0fArhJWQ/MVFXZMapq5Y7BJOPkZj4UBtJLSfxgJt?=
 =?us-ascii?Q?wMXg/iihJUsU0Cdc13jTVG+4BRxJ6htlCEHEgVZkjLdjm+D1s5a/QyBJSneT?=
 =?us-ascii?Q?QIvuada/A3PRdNGRFwGosdrn8KAZdffxKA2ZNf5Jsr62wS1FbRUC6A0Tc10W?=
 =?us-ascii?Q?X4MPUXmQwzDVdT33bFF/JLfRHTpQeBDKSpCAqUPjZyjzRgU5a4uZbeNczkc8?=
 =?us-ascii?Q?ncgvkUbANCCmouxcongBcf0N5qSaJX4yHf4wtQFKL+EFMPID5wZDysWrcnvn?=
 =?us-ascii?Q?JeHV6WGuiJlXEO9EUknaX16MS71tzZl/Rzl1dkxKR17tdi40yVigMvu7zb+F?=
 =?us-ascii?Q?4sbqaJFd0tqVhJTd+e2xo3vZtVIZZIT4X43zhhT+yx+oETvHV9BTDkg5CPm6?=
 =?us-ascii?Q?yDDohFbIF2XwGBxcy535ZDLhrp6h+6XFsNd+DvYdqVn3VTETGu/i7AjZO2xW?=
 =?us-ascii?Q?ptkEh545E7xgHH+9OCDfb+4ZKnBRrL88V4pykgvpX0TUCZAsGko7TOBR2gDc?=
 =?us-ascii?Q?v7dHArNGJhW4G0rOcrY2/CMHZyNGZL/IJxxkJr/T9A4iC/bNPLGhOEIg/RW8?=
 =?us-ascii?Q?DMRwJ22uhME6LKXAoA9I7aNDePYjlD0mCpMfjwqGWe7iBOsP9mPxykjJkKsW?=
 =?us-ascii?Q?dvi7rP0hntNVJAAO/M6wXvFWLoGizs+G1DcYJAoBXX0rzV46TacccodAZj/+?=
 =?us-ascii?Q?7FbCNLWQCeLYc+KAv7yhZ7Sed8xLJrLi17C2IwsRAhWXOTvE0kIOlERZnQ/E?=
 =?us-ascii?Q?n6rdqtSOVyqcJdeLNntsriGtX85l2JSxRfFnczYCM4B9WhrPT6yWH8evd/85?=
 =?us-ascii?Q?FYoTQ6z+uZkcfO79kD4mNx8LJ8WpSeTCapHbaRG8Th8Rh/K8OpcgY7aX8QfQ?=
 =?us-ascii?Q?uiS/vA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eFDkcAMaX1ELWfniuU9dXDlGNxOFvF4PJVWd+LCXPhEdAwl1BNHQIC5M6i+XelKfUYbFOwej1s62psff9g5kvwXQ5EhZ91469lEJSkYzmK2Xetmh0vqcbVfeMic0a7+tZrgdo9pjnGPoJ3AF74wWKkow6O2P5nRIv0pVCE9FoHzgGCgc8XZa2AXDM/2YRWSouHFIo2bYoyOMzd/244qa3ZBDGRggwImGkZqB28CMsLJTT5eboU2g7/wf+zlQeaselzZmpUfYpF5fC/uG81Uubpe9st9mq69acT8vtFZk5MDSSHCzchXb4n2gSiY3nQgYR5NnLkX+l+PiNtHJ1UhknZJb/1eIDFjuH/nm0PWUN/qOAGw/uKTSUuZLxNwiMJ2fF+yvrVCY9Ha+AG3m+GBdVn9ZGQFKKiybrAuQyZluUYOC5+wis4uGBoL+4RplVYMy7QRY9j92BVs1Ox4+Y3zvVf9N1omzjVVjFHZiTFBQE0vOM2R2eQGXUxJFXYL0K9Ink9KvuDAPoAwBudrLbPpO2FNd6b8LF93g1Ewz4yjsDp11NSO++jt3+O5/wDbejuuZpWZ3nKaphxZI1/lWcllBzJlfL/m8WYZHh/lg7MIl5XQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56efe0d4-3752-4d6f-5cc3-08dc2698b489
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:48.7003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2OfLc99MTyOLXE/5qbd9C2ZwKMxqBEIIl22mMz9OaZSUoMwxCBuIWO2WnlXHpR0NHzrbA6lG+mFPfO7PVu2BXzAbxThJBZdbsPQSRTsuUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: GnoG3Tpd8N1mx5_5DSJPSiX_utWo6ID3
X-Proofpoint-ORIG-GUID: GnoG3Tpd8N1mx5_5DSJPSiX_utWo6ID3

From: Omar Sandoval <osandov@fb.com>

commit f63a5b3769ad7659da4c0420751d78958ab97675 upstream.

We've been seeing XFS errors like the following:

XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
...
Call Trace:
 xfs_corruption_error+0x94/0xa0
 xfs_btree_insert+0x221/0x280
 xfs_alloc_fixup_trees+0x104/0x3e0
 xfs_alloc_ag_vextent_size+0x667/0x820
 xfs_alloc_fix_freelist+0x5d9/0x750
 xfs_free_extent_fix_freelist+0x65/0xa0
 __xfs_free_extent+0x57/0x180
...

This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
xfs_btree_insrec() fails.

After converting this into a panic and dissecting the core dump, I found
that xfs_btree_insrec() is failing because it's trying to split a leaf
node in the cntbt when the AG free list is empty. In particular, it's
failing to get a block from the AGFL _while trying to refill the AGFL_.

If a single operation splits every level of the bnobt and the cntbt (and
the rmapbt if it is enabled) at once, the free list will be empty. Then,
when the next operation tries to refill the free list, it allocates
space. If the allocation does not use a full extent, it will need to
insert records for the remaining space in the bnobt and cntbt. And if
those new records go in full leaves, the leaves (and potentially more
nodes up to the old root) need to be split.

Fix it by accounting for the additional splits that may be required to
refill the free list in the calculation for the minimum free list size.

P.S. As far as I can tell, this bug has existed for a long time -- maybe
back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
...") in April 1994! It requires a very unlucky sequence of events, and
in fact we didn't hit it until a particular sparse mmap workload updated
from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
exposed by some other change in allocation or writeback patterns. It's
also much less likely to be hit with the rmapbt enabled, since that
increases the minimum free list size and is unlikely to split at the
same time as the bnobt and cntbt.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..100ab5931b31 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2275,16 +2275,37 @@ xfs_alloc_min_freelist(
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
+	/*
+	 * For a btree shorter than the maximum height, the worst case is that
+	 * every level gets split and a new level is added, then while inserting
+	 * another entry to refill the AGFL, every level under the old root gets
+	 * split again. This is:
+	 *
+	 *   (full height split reservation) + (AGFL refill split height)
+	 * = (current height + 1) + (current height - 1)
+	 * = (new height) + (new height - 2)
+	 * = 2 * new height - 2
+	 *
+	 * For a btree of maximum height, the worst case is that every level
+	 * under the root gets split, then while inserting another entry to
+	 * refill the AGFL, every level under the root gets split again. This is
+	 * also:
+	 *
+	 *   2 * (current height - 1)
+	 * = 2 * (new height - 1)
+	 * = 2 * new height - 2
+	 */
+
 	/* space needed by-bno freespace btree */
 	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-						mp->m_rmap_maxlevels);
+						mp->m_rmap_maxlevels) * 2 - 2;
 
 	return min_free;
 }
-- 
2.39.3

