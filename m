Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1A37708
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658281; cv=fail; b=KMHPSH+emaXvGxOqAOJZHkMRo50Qw0InFh3xcjvF2bcXTZEXOjMobbZI+mGPl7U8SBF1oM1XIWoXf9fKtgB7xlfj0MfAw9E/O6HqutjR+y91lTnqQkfs6l7Mh/I/UEGCv2UdB9Z09CB4rXX4AmFHTjkEsHGCpk9k2+nRtCNJ5oM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658281; c=relaxed/simple;
	bh=mEraLLdjAqgQt8UqpWEOY7nP6XS/EykgEkL/tLOGET4=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KA2wkfyVgyTG/TkdOsG3KK56SsXt5wTfnPyEK3koVHyRKd4ulB6LgiNBgd4OV1Cd1Uj0dGVA2xM9p8irs+FkVkQ7BIfxSETic5B0I+eYV/mnuDqTWJUe7cStP8uiah2MSuCIqX4wjq0Ek1wkO+3bjIoR/Dw4M0COrC2aMgsoYQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CyGjjTyv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kiMIQuI/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CyGjjTyv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kiMIQuI/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxT2G025999
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=bYI+mZNChQBgr/ucopMGIvCAUQzi4CBOh2pHbbZN/vw=;
 b=CyGjjTyvZ/iJgI3HZnw4ISIH44o5aI0wK/qatLfrz5vM5p3EqAqqdGweHHCFFFkdJFff
 ROEnMegGMYCgI8eCpUpjIRef454V8QT8nG8x/++cWVffa1DEiTtxz20lsLiC/Cskl6L2
 5NIH/z4uU2vnSqzjJS57CJ94qXutG7YLvfOyDhlzSVmjpePSnaWeBc/4YvvuydewDDGQ
 hAVUcp85a3tlCJCDGGp3rJPaZ/OjOkaaZP+Pem4RMYFKxtMzS9/qfDNl+MRHGVI97QoA
 kTZXCYjDpHe+Sph3cdoSKeqn/63C76/n/y33dLfbTmwF1r+A400RdpeJVBPol7ZRg/D8 Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcghkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM7lKf014564
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9800uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5xH8RQC7M0PL20jEyzBiPzukaJuR9dAnhHUcl0plazvB3tSURlL5ag/ci8+kGUW0MbATunDfUJcSTGKWXvHMI+I+Nxp2WWoZBI9ynSqD3epUDkusM9J9DtnL/U84ID2reaUXLTbelG6c/l5a4uNG+f3eswqszvelUYnTFTRVkideR3UyAZsiZcWJ1PxluX1eFthfh8rx3BmQBfRjqhaxVvA+BjFnvZjz0LT1+HmwbAL0KTFj2IGq/ezp9yum07PYfAgzYVp96L+W2pLzz84eOsJg/M0bO1s29mkF5yPTJfpDDCjQR5d87N2c4WWSKOSYPNe4kIYhF1Apk0o7a5YHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYI+mZNChQBgr/ucopMGIvCAUQzi4CBOh2pHbbZN/vw=;
 b=EZKl2+z0R/YQqT8tkZlNSi0EZ0owgJrFb/XpzSWWkFeE46dOdjTgvW3cdvAcjMlxkY3Q3JyrXFovmyeq26XMhtruGl58wqsyG/3fj1acjiG17P9+9Y52kvDvnoY1OJOGoHQ/0wRFthXTOcEyjaFxSWTGyMXPoDlech4SdhNKcstOPZkm4/7MJLZgc5FZc/czR71q3rD5ydQqj0E1/tKHjImmzugknaWIqUqnp6qggLDrn1Y9ur2likmY3phqinLlfOKFKxHzawr0fRad0J3A6rXr2zyVaJDGOt2olN/lib0S9h/cHnzZUvzgeopeIc/ulg8sYqu9b18n8jldpQxsHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYI+mZNChQBgr/ucopMGIvCAUQzi4CBOh2pHbbZN/vw=;
 b=kiMIQuI/FTBRFmLYJEe8UXSmDtvkcdXusNq/i3qOZW2dFXyAgaBkjUOPKtvHbqC+iEOsq9UuaqEE3gANQ25UAdPHZJRyqK+0A9rJUBe2ehB1Z89tJnXWT3RdjaXOZds1B9PezLyryfqp2YWoet+CUxusS/P756MgrVXt/T1fNnQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:31 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 04/21] xfs: rt stubs should return negative errnos when rt disabled
Date: Tue, 30 Jan 2024 15:44:02 -0800
Message-Id: <20240130234419.45896-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:a03:114::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 0495778f-73ad-48a8-869f-08dc21ed67a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4W8JTiSSgEo8VPWgjVqzLs1OBZ842CyWBN2gXA7oD7FM/kBo87iDqs03wC8+a/jGxz5R5dIb4Ko8xn2FuDiYgypxbEDMpwbtTbHlUjQqXOHaIEjX5qUxCZltI48wB8ASu0GqHWJRgc13IcIbqatKP6bNLr4w1SBCOVAkeeyqFnbNlOL/gjZjxz3gx8AuyBln7AbHfQw3LXSB5aFiQBoXWWo+OMA1dkf+4H73IRh39Kw/l+aJ9FIBfs+/ZaCAVNJlUkbSagY/E0JV5+COc8GQh/P5YdbX4i59uxs8O7tMz3uPRnws1K0SjoqbdoQLQ8SLdN3KyYII3CRbOXSnSlkjE6hIxx1F0yNU9XkS8TlbdJ6SFL/pM/aGcfVkcgvuKJUANeJxxhfXV/6HFvlo0M7i8EwoWbWE5t8T4bhH3d2y9ArSp6VKvl0naiA/1QHfIm4JCfo8yr2lTLuq/jOxdvo4vYduzxFXgZJjouuWGLPVygi1B35TrLFLGwXl7VmYtUzFY9m8yJZrJEAOsZoyqbq8t8hcIRWjcd1XeziWYI63C76jqqNVUJMrp5XYj30S603r
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6Hql0+X0ljnF6sF5vvg++JPT9wxKbpX4JlPxLZ4yUC5QiD1ss/q+dW5Ku37e?=
 =?us-ascii?Q?J6oArAtre83dz7oDYUcdEc61uS6iNo3A2J8LyXwWVMVb6giU2+ogXppD1v+/?=
 =?us-ascii?Q?dn0h0u0F6pycBWIfg3baS3ivilE6nWfn97xZafpsaXU5xF72ZkMp4xULgD3B?=
 =?us-ascii?Q?FtTmDuk4IB3yw5aPjLnaLSi6rW7izLG5M0xm+FjQSGzmn9slVCG6Da04z3az?=
 =?us-ascii?Q?URw4I5sL50yXNmAon9IWrO1Qdi9Cq3s1pKR8INooYzryJvUZTFgVBXKmF42c?=
 =?us-ascii?Q?PJsYLIpVMijLu1lh/9TtbfnRmJu5Ge3X9eI861iyD2FvjZvZf7ExTs/SelBc?=
 =?us-ascii?Q?zsT+QnL/c9Eb9+Sah8QL3tAijKfY12kzHASIuuTbdjxf+mIWYcnxSncLhEgu?=
 =?us-ascii?Q?qkoTANXhJHopTSuX7i6xlwnD2nipBpNtOvY4617RTdMlR9zCtLy2JjocKbtf?=
 =?us-ascii?Q?7n0sCJGfxc2hFq/L6/iT9opQkltrFl/Ix6aYnz0HhWPAJYunlcB6fAyMZ1R6?=
 =?us-ascii?Q?K9tA0VN6BOKaOCB1qlTXHBGEb0c3+6873GKbSSmwV+5hyYmWdD8MzIdQWlfW?=
 =?us-ascii?Q?eSl38lTdI+Q07PcZrrMMC9zcMB17KEasw7y4OSDDGSC2LS3LFRAuf0+wyJFh?=
 =?us-ascii?Q?SeKLWJvXSCVox0k9wJMhMa6MvN3+/IUWNKkHjKYji8R0d+e3YPFOiUGWSB8D?=
 =?us-ascii?Q?jC3JWpNZ8yDiOyZ2rOj320d3DIMgNDPwlRaMNJrPET/kzwsTq2l2tl6v4Zg2?=
 =?us-ascii?Q?Xdn0k5jJihRr0DsSZkG5R7HRkaXa7A38a89/uufeOLuYHYfHwcfyUf8ELpoU?=
 =?us-ascii?Q?KA1nSwhE5gM6rgA/C+V1gM3+ZcihFjkevKaktymFfMdKNmTGzqgJHQYm/mPB?=
 =?us-ascii?Q?75zMGfqPAuracHkqBkEfx8sHYvAHji7mmMc4Re2L78c1Cy1dOlaWcGxPDQVo?=
 =?us-ascii?Q?XLSeL4GhlWhNBbJ+bfDeiryFDzvLfiVgAH7JhKvDW1n9Dg9VkWW9SQHMPVwL?=
 =?us-ascii?Q?UtkvNgiBBRUM9RE+mLY6rYiBSjyaQZ7ZaU/RSH27Z2YSl8PBfzf5+MDlcK2H?=
 =?us-ascii?Q?4QnASPodW4SmqK4JExDrtfhTchAI9kicb1zkeT+2nQywd3Xbj1UIKCD6o7DN?=
 =?us-ascii?Q?3GJeStp6exQRebyhxUfLFzVjLOHcwTZWoY2s6DFoZJsS52bCh9007XGGQIko?=
 =?us-ascii?Q?9mnZjXKKYn1iSCBSgBL8lfEeflWSYQlTnibSTDHgqnBAVk2d35zPBTHRVhYa?=
 =?us-ascii?Q?sXXAv3vSWwnoPH57IkI+gtt+31hKFgGKJEGZTcPfZn/3oB4mREPUqihH+dcQ?=
 =?us-ascii?Q?8Hv8ASEgjgm7aDo8gpnlDdLWq4+NGwX15cdcgnBAgWW6X3GTS2s7dqPcDzMq?=
 =?us-ascii?Q?riFp54/tLYPQVN5o4pfIbq7Xp7rcm8NBGf/XrLmlDjDICTu9tBvt8uEYQksg?=
 =?us-ascii?Q?k12LwoDAGkGsg+0LX43UZcD/vdawjpvTDaa7W4WOIG0rGVEq3QJZkW3oFBos?=
 =?us-ascii?Q?NtDYWnmOMOoG/7rw2wrXSxa33r2T7Eyc9Ov3pD0/29VRitSLRekA3FcZ/6ci?=
 =?us-ascii?Q?HI7axOlS6a5PrxV+pQFF/jOhwD5ejmGV6iGHHGC/CHABduUh+xufuI7KJhO8?=
 =?us-ascii?Q?i2wb9Pnw7aKyu4+MaUC0feFvKBDodx+ISMpwF+Vu+I9ArUgTls6REbLh84/E?=
 =?us-ascii?Q?18SiCw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	C/qgWrb1sFdMrGrMJCCyRmBJV90upcPJv4u+KyZliA0s4lUmYEol2BTBIfBM6amuQ8o4cBY7HOE+V8Bs8C93DT68B6kWPPZzTckmRx7nGFc5QItvkkBaDnjw6X98XdZlu6WVgKHc49uG9VOQzoNvwGkkIG9oAlK5VQyJDcM5Ix3lwKfDeEd1TjHySKXnkAGPO3UFy+ZmEHvXZgr7uRSTdTrUY7Esu8+H0Y70dG0sppuXK9VTrwgEruhdOOavertWAIvR1hccCzwTQ8/bKFZ7grfQmxjXAhZ/3zM4tTSorjh3cr3P6zot3Th1y6SBnOLAVD3cqtMby/0iN4Se5U5ji8HqzlBRxpwh2HEz0skueBZYcFKVMxS+qaBFOk48bZ1t+2N2Bn6P1whHdvuBfpcI/u2cpeNRcQ9nYSUlfayJtz+Qc9QyaCmXKwsN6dq3U/+PzJIU1PLjd7IZyambNBixKGlMrUhmIB4xzjjt9IMEUk/E95TLJpAEehl/A3Ipfi4XVFPoUielyyoUZShO2LBWhmrqbnGwk55rN5VDMfqLGY1J40jYtiA8UfrG13JSwxKSCf/YgDxvzYWFhKivs5yC3YhCMadXGNKVNxhIZP98gng=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0495778f-73ad-48a8-869f-08dc21ed67a0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:31.0840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAPl+e/AhAVn9wBNTgG5GguO9vc/RM34+5zv1Aa1bkHDUSnm0zNx1e+L/2kUl+XxEW3YYmV7MgYBaDcJY7E8cr54BWU8qS32lMbJRGhiBhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: tSblZflADOs8nTRcnq4uje0Vt7ngehmr
X-Proofpoint-GUID: tSblZflADOs8nTRcnq4uje0Vt7ngehmr

From: "Darrick J. Wong" <djwong@kernel.org>

commit c2988eb5cff75c02bc57e02c323154aa08f55b78 upstream.

When realtime support is not compiled into the kernel, these functions
should return negative errnos, not positive errnos.  While we're at it,
fix a broken macro declaration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3b2f1b499a11..65c284e9d33e 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -141,17 +141,17 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
-# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
-# define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
-# define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
-# define xfs_growfs_rt(mp,in)                           (ENOSYS)
-# define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)                 (ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
-# define xfs_verify_rtbno(m, r)			(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
-# define xfs_rtalloc_reinit_frextents(m)                (0)
+# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
+# define xfs_growfs_rt(mp,in)				(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_verify_rtbno(m, r)				(false)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+# define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
@@ -162,7 +162,7 @@ xfs_rtmount_init(
 	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return -ENOSYS;
 }
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 
-- 
2.39.3

