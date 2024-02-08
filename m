Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0833C068;
	Thu,  8 Feb 2024 23:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434479; cv=fail; b=hjxq7JnUnj6fvJAEFe1WmfgqXA8K2mSp2HLdEFjx5VAwKELswuJKChMfrXwATbfoj42Rmn+eYGJu08UucphovCr6+Ef5BeG6MD7oz3F87qUoidpbM1q4WajItRNK662NYZJyrNnCRTfcdgrGfmuHyb126W8eaMoKg2q1/A+gpXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434479; c=relaxed/simple;
	bh=k+JvENtQQcJVdPJUvVsK2WPigpoI7NxLJEck4Ba40qQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AGI0UfXxHAXfCBs1xOtQtlh4NDxt2pBe3JMin58ibkhG8TWci5xUC6WkPfgrIY1YI5WqIWYLxcIWLqFEUz9JHRtChDttpbLNLimtkHp2o0r5LnPwdfCiFYiRNlRH5cPSjTOwFhaNvGbg2tYqtRwfLVWOh5d3BQwdz8l3ptbq8yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eAlwJW9r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PeacBW/W; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eAlwJW9r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PeacBW/W"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSqF0016686;
	Thu, 8 Feb 2024 23:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Y255iX+LaO4W0bfeZ2CjtqiCA/9ook2Xj7VicM72RiU=;
 b=eAlwJW9r3L5xeHt4pFIsUBTScrVJEas0BQGXA8smWUn5W4JpDVy4R1aqdznCMirPYj7H
 UVfY0A7ytmMdk2piRCV2NV1Vn4Ud5gGw0+Gvzt8guLB6rPmEb1cjP4dezPZDNe/v7LLA
 Z8nCZQmI/IxlyUWoBVbqUmSfal1zwnP52Z2wAeIdl/VyFFzksHeyXDgyyE2w/E0WcAUq
 YE+xV5shX4ihERDMgHBogOygQPpk9oGwnntrrRRAH3g1Dm4wb30xWMogjEPfZvds4ePp
 rJRwQoSkQw9BWV/NI7hyHOUBmIJGM7z9kEUa2+JIm0Crr7NZry4nPmFkviIngVnaQwEW 4g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1d3up3xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418N5dCJ019778;
	Thu, 8 Feb 2024 23:21:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxhq50v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKN79YQB83BEG2iglHy8khd8TL93oZ/vDDOLocxYLQdv9EQXUNe7UAUDcHHUmrku306TxorLPiU+me1XwRi/p4ru7qvma1SOC4QnQQYMp+2T1zoArMtJEWf4nkYoRXqyHlvZjrFEU40veDz8qRf5SaHwSLF1HCLS0rR9YbKjirHvPUweDItcGJuP05oXb6JUjkxuC5/ntHYAht4uDls7vgocuihW6p42fKaQXhkrS/LvjbFjUqsBFp7nfL2UfezM8wECIgomL1XlDUnHBGxCpXFcPbxcT7hTnC7SjvUF9k5y/hT9oLXd0WutTUM8TwtBOa/aWD80aITCVf3QXD8P4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y255iX+LaO4W0bfeZ2CjtqiCA/9ook2Xj7VicM72RiU=;
 b=afV/v/zeiyUfmOnzkQlCzr1AUur/vDsUSuYkjnJ2jkHIFybhqu4T20fWwF2ZBkdBuHjpXea+QirWYbt4Ix91XnihqIX9oPFBa2JE4pgtxTj3/ERh04ITJfBJqaKNRxczmI7xN2lIa1Zpex5G6mQBMf2I/4XVHK69Y3tCPmSoJSIGQGQTAmWvB+u2mm8qaBPYtxolCKrRL1vNPcaSW4VQ90I3ZJPbZgyGIC3fKhdfUUMffve9eDnGb942gt2gxyqhVNm+Dpiu6rgkcysCQO4kt0br2P+ydv/Eeg6xOZqvRMfa7GQ5OMVCTjr4zShWmMv+vrel4P3jZTL9S88um7r9Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y255iX+LaO4W0bfeZ2CjtqiCA/9ook2Xj7VicM72RiU=;
 b=PeacBW/WOsX8w557CtTm8myDZ/eUfsJBhCyTt5OCtyo63sJGRPg5IYLwPDBR2h4hcBYnueDdaknNijvBK1ZZJNUu5DPwLxuQ1TGvIkc+PJH5Kx4vLVPPUbnYw0WqCUzLDBILhUMmv8ORbPh/OqAOnuBLW19m+e+c1MNOYfEHLYk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.39; Thu, 8 Feb
 2024 23:21:13 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:13 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 08/21] xfs: introduce protection for drop nlink
Date: Thu,  8 Feb 2024 15:20:41 -0800
Message-Id: <20240208232054.15778-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: aa182149-3f30-4a91-84f9-08dc28fca439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GAAEAzm4Vt2T8FHr4Uii5U27vs59NDdGLN93K20qWYMZFfNwZHaUq4xh9cRT3ffEYYM5GPR7McGRoixzwi+H/1FrWhKjReUv/ic0ePVqrQQQ8KjtZVgDeQI27Q+IL1GW/43XqVVHpq8YHdx11PmjUCGNT+D1sK9dmuaMduoS3oX3Qa7hhlCxLORDVKT790NpvWW5krnH5qyyoXrX9iEX5N0mj2J/npvXzNmNajNXm6jvRO++HNyhcyBjWXxXwAiN95Vh0S7I7ppuZ0+eBNBhbpq8l5CQ4VSJmqr5y/eBHZUI+oNi1CiP3IBeCNQ+rMwXWn9k+3GHMYq9giJx2AtQurH89VxqkhZbd6cjlRGeWfNoPfmw+Mt1OdwuMnFSEPs+2KupRRdicinaYbvWZG4zcDFluCJXE17nnMY++PH1PwTOEuuXdSbOvmwSmj6zJiaIzBpuau4maad+mhVzEz37Lm19dn6wCPZa6orZBgG9IBm3H0Aewoxt4xYtYCd5QLNi5siBG44L4SzvBcqYXQzaMjkCuo62SKDEfh1ayHQy8JGPSBvTq0LyPR+VDc6XCV9f
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(6486002)(6506007)(41300700001)(36756003)(66946007)(66476007)(6916009)(66556008)(450100002)(6666004)(316002)(478600001)(4326008)(6512007)(8936002)(8676002)(2616005)(38100700002)(1076003)(86362001)(83380400001)(44832011)(2906002)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8rHHQzACPBwf/9QOfo5zrai6n8oCHgiYR+Qb3VuJfzHHZKGHapSLwn5KpuM9?=
 =?us-ascii?Q?alDQvE23pGJRPf5tHf+NBZZZwex9WQhNl5aB3SBLV89CMlG2giM9KUqQr8D9?=
 =?us-ascii?Q?HavFREt8fA1ob9HjU0BCgli+6wa159yKN5ppIcGM5C5SEcydIqKUq22mSgC3?=
 =?us-ascii?Q?+WrSwCKIUNCQXf/pK0DA508GNtMzkq+UCfjLXNEGwrILVruSDz0L8g6/TnJY?=
 =?us-ascii?Q?eWdzjzC8qpNdTGoITEc3yQTEa+Y6ZWpmcEt7ZiikZTi92EYB8CBB3Xm0ML70?=
 =?us-ascii?Q?kwm385XX9opsdCxmmrJSDTeye9JczNKMTc0hXSOFeGDtGuXYkyq2ObNkfhgd?=
 =?us-ascii?Q?sSjbFU4SGKLUvH9LoAxBm6lVvgdjsfE0PmtdKyzFrnVceA0r7u7pYqx9Q4DA?=
 =?us-ascii?Q?EvuCpPrMmAALxS62sbeuzl6EoYOVJCLexvnc2NTsDqwHYc2Gcx+x7FcMJYjI?=
 =?us-ascii?Q?dYXaxk1ebTLhIE7uBaYgTr9c9Cuj+UjKbZT576EwX9P0xhkrTi6u1855TjF7?=
 =?us-ascii?Q?2yqx/71sI3VPP+c1VzGdfrrILnP5jJ2TUN4SM3RU8iLAAkfeAa9IDgpXJ6qK?=
 =?us-ascii?Q?E5msGCwhbLTNnoYBrBeiuYyEkip9bFUtK15fbCHDw9JtQge1I8Fg8MLLOLjZ?=
 =?us-ascii?Q?zlpVxjVB02ym0TQaMq92KSrQTHOS/fL+uhYpG1bgF516Vvi8yoBtZHgzpFGX?=
 =?us-ascii?Q?qIJ4awySyqr66Huy2hv1rDjXIMBkU5vn4FDZr87FQ6P/rYkXNShK9q1E7eZN?=
 =?us-ascii?Q?fhmvV8nIpXJ5IiVdgQeCVmRu0vt5TA2jw6WKKVzJAigGzdZq7GZVGR25jb19?=
 =?us-ascii?Q?vkhLP3Pemj6n5igL+QD7c2yiwl4RTvqScZze8CRHvd0U1X3/Kgu8K4kEvdkA?=
 =?us-ascii?Q?aqPwS3IUJV4MTwDB9+jx7f82xsgmpn2e7rqprgtpK99xe74vgWRbZWpVa8qC?=
 =?us-ascii?Q?0lmjemPXEje/SRJ2sEUz7DnwyJ15NYPPxk/rSUHLMGM08yFqu6s8aFi0GtsW?=
 =?us-ascii?Q?2o5NOYkcHB2hnVhr2g6S+kDOJqHgH22wAYhq/V7C7Qlk9bjqlMVGMv3NeWcB?=
 =?us-ascii?Q?JJqlyhmNWoGxbAnoaCzZWun/g4Cvj5uk06xtBRxKmNwXLjLg8EhLxOqW+0OW?=
 =?us-ascii?Q?dK/k0cAEqSXoExvwiDuZEGWzZWxfKbQQijGwNlmJc2GtZ9jmvPbnmBIrRZHb?=
 =?us-ascii?Q?QuU+31vPUkDiw+2QlmGxTv3T3VZLOsTOLwmOxJfeaOCdNXKEQNvMNidiyZcj?=
 =?us-ascii?Q?4OlVP1oFO9Ax4mOU2r/Q7PGf0p0rDF2pdnvEXHH4uAJ1yc/Frp6qiF5lUrPL?=
 =?us-ascii?Q?TKeHPuI/WtL9v9BnZlWTKLZPe2HJZdK2EE8ma8HByLEzt0B4VH3r8ZvzgCpu?=
 =?us-ascii?Q?RkNZmEf3wFcCWWFd41c1CTSuvfslOxtSD7A6AUoty0pPqvflNUR/itaLjNIk?=
 =?us-ascii?Q?jJK2IyJDIQARm7w6fe5SitcwPdQdJP/lB8OyuhfQMzPhr+rVERd56g3Jdizb?=
 =?us-ascii?Q?UBEDMz746mEq5wBAOnCvOX20Q0QIBvnnOOTyeQIZNRz75tK4idMo1mvCvjeN?=
 =?us-ascii?Q?ySvOBs7sdhdOkmscKjSwntchS3mH1IzAkPQ63yEFfaevx6UbnFFIQbG7lANM?=
 =?us-ascii?Q?QxNcW8gFeyUgNX/YRrTBL43KEzU9QdKMePaiTg6VqumLhKx9N3OmJ+ABx9dA?=
 =?us-ascii?Q?aOtJpQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZNB+BRXfp0W4gdb70W51/KODwZtcB2gbUCchWsT4yjiNS8hGtKLXuSgS8bh8VDYAYt6N44YMN01aH7WUX/9By68wcVaf0bj7eYRAlcC0UOfqzs50jnR3n9l7MoDqgVv+aXchVyX0v/mv0rVeTQISxta39pKw4R8yoNqBntfEhqJMMHZs9kd9+xSc75jT8EBDRBpFkPw9e14XCQ0XafcI2uMa21PUhldu47CkgULvx8AyEmyB3rwxVP7eALWI6kwmxPP3Mf4BLD2tzCWlH5GQCRsnrYzkoXrmKwGXFlx+xj3n1/oJWNp0t6bFub1ODbNZ3KlMe6ECazh1y5dvc4yrfXBVu05VxKH27tkC0Q0d3g6sLNZhJydAvprEztzb6Naw3jIUmt53YGex0H33hpVsa8REmIzbRpf7FrdopNh7fo6REYO87gRiaOofTLym2UWGJRvDi8pAPdpYg5EcFut391OgTOKVJTs64CXosnvMkw1P4xjQYECVcegD476owUFhn1bjUHPnl9YtpmeXPq42jypV1xuWB+2FjH+YE/pAH0ZfFY6+sNyOhnIpnXDMezCpv+CBY0pCpaut/MPH4HvbWVcYbkmeroK+ObQ7Kw0zLsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa182149-3f30-4a91-84f9-08dc28fca439
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:13.2608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGfOBhFF8eaNXEN5rYfxQSYlDw+3XBskolyvRBKEb2HQDsqDWHjtEJPi1EM0PFO4gtl2IuMSbVMJ6qznn2oSK0OK9faSGSn2w6Tz421xqsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: YeWFuRM0r4ubIUTiDxJc875q2Hi1p2o8
X-Proofpoint-GUID: YeWFuRM0r4ubIUTiDxJc875q2Hi1p2o8

From: Cheng Lin <cheng.lin130@zte.com.cn>

commit 2b99e410b28f5a75ae417e6389e767c7745d6fce upstream.

When abnormal drop_nlink are detected on the inode,
return error, to avoid corruption propagation.

Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4d55f58d99b7..fb85c5c81745 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -918,6 +918,13 @@ xfs_droplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
 {
+	if (VFS_I(ip)->i_nlink == 0) {
+		xfs_alert(ip->i_mount,
+			  "%s: Attempt to drop inode (%llu) with nlink zero.",
+			  __func__, ip->i_ino);
+		return -EFSCORRUPTED;
+	}
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	drop_nlink(VFS_I(ip));
-- 
2.39.3

