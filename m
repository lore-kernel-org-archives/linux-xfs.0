Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974C34F5EF
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171667; cv=fail; b=NGSqf5jhJtJgWcSh/zhTeb1vlZwSmrdf2XUIyLzdrZfMCJYX7aKvzK3lHE4mqwqeYoU8PongdDOcu/XguzJzuQvTM2/cuo2VXVu96SDgw1A38TwszAKX85sig1vpw0qPwiEhWAPDzeaCx3Ub7IS9T1iWIIm0FHmVV+qLALL1cX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171667; c=relaxed/simple;
	bh=odIrb+HmPTRyFV5+wvPWcOq/omezCj1/ZMo28wLuUgY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mgFt5VRLMD2yBPaGhyrzlLmPbF8WiWCMijJeQeJozqjrEJ/sn+J87DXNgKqciAjsxoyFcrxeEKcqdCh1H41O047TUoz/cI3Y3WQuSTd55XNLFtQBBuxHj3W8uHEEk5VXLqXF/TLnsUmr6KtPE7SvYd83DKnU4l87zIEOvnDGs3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WAAuL+G5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XZu1OPhY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WAAuL+G5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XZu1OPhY"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFkAa025006
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=iKFnNVI+opeXzHnKtzNXirHXYKNZUAr8FJmOJXYFdRw=;
 b=WAAuL+G5L+m8+V9t7zQuwANHZWHZJ+B6RNifQNzAF3AKpjxgtAdgWHTHPFeFO4o1GMW+
 wujiUHSJmOgEd6/sQAtMJ2kynxW8rX4RE0VsUJTINUh2/PTvxoO0vzOq6fGkQuPGCD1a
 10MTgwT5lh+JUL1P+ORjDzlg6XMR2yCY+GdH5UvBz9XQEjFMgMtluH75YEm3bjDZZwGF
 d2Ih88IaMCk6SmM++blmePs+5xhMgvf7DcCGIb+BJq0z+emEWuTwx9ZZdxznU2sy6Gtk
 0JNhc1nCoMB8zWHV1mrddNjMO86skRvwAaXq71OBvJIfmHkSPaSQXYsEHoQVFqRX626b MQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32nacs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:21:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LV0FY036845
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:21:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6e1vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0bxUuKE479i5UuJeH5T1TaPkmK1SZ8KQOxO8WyFumtiaL+AFFbquFx31dUkEUoU4y1PiPdD4LpQigJRaLcRE1znoeOtX1dwcpSKHgV1ZJmISy+H+ELhTi0w2vdOangQrNqz7V3KmugZ+vZ2FRKXZolpIivgK3pAbrnR91BuCeCOmoyIzpFgnLbBunt+tRXZ8QSgtuFwldKhrLvnOeMhpMQ5iUWo9zPWDxeM488+c/ycRxDWnjk/rWk6gQELGZ7ahcsIlcdNIaWUJo2aOhOUHDZjPIVWb9j2GkgpZIlTTm1m+CDd7agPxvFZpPNwZe6OXCRyeAmKKyJm/0WglDwp3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKFnNVI+opeXzHnKtzNXirHXYKNZUAr8FJmOJXYFdRw=;
 b=elYOCJp/Nb0RP6SSVyeTIta4HHNUEmwR7h0pcIVEAW8s7kBZNRDvUdJCks8cAsNvMtch4fOZVhxZh6pOSHGrFiWNZ/2z1udUWpj8/2HHUSzreWFhQniADun+f3mU96v9UKU0o/d/qR2YmfmkMWSQBpE+f0dlTnmU2TtoXHlUHcAGLOObbnnnTqFXry5+LmZe9UsnERf86RWI8TwZS9AHOhAHxM7GhQmJTC0IAp0BYpo2DVVDNyk2P5O0RhDE3RZujH6KP+JoOYqTCY55S3CiMFzCI7wQOc26rV7IQLjwriYeQwsutgpAIzYL0Hg1XsFTMXzkXSqNb9U647akKvrV7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKFnNVI+opeXzHnKtzNXirHXYKNZUAr8FJmOJXYFdRw=;
 b=XZu1OPhYEk/hiFt/E50zgvZO7oPUEkkz/RQMHeuGhiBepgnCeDYntM6Sbcmvf7+uEqHp1XPqzE4psuC1Xn8QoUsynk7RNXxE2cShgNgcwmq5r0aKQR3vxLsUfN36xV7I6sP9IozHYfqMkXobuQc0kfZf8hmXjAfQPOGgkTJTchI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:21:01 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:21:01 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 21/21] xfs: respect the stable writes flag on the RT device
Date: Mon,  5 Feb 2024 14:20:11 -0800
Message-Id: <20240205222011.95476-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:74::37) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 59d199de-3906-4e66-c15b-08dc2698bc4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	NVGrcSV3laj3P4xsfflM+nBwtQBTlvQ2GLq3axIa/1HwB1PtDElTfl2x3yCurXIjCmKlKJPhwlwgIU54I1znKI8t7oqEVcKW4JvQRLwMROYsbVRUsLpoyUCo5lRq6ADSvK/BqNKb4sqHBa3o4VZ/vcMn7Auz2CzwVgALWrnvR3nEMjT0/F1KrQUXqpOpH7vop3GliRuIooNwnNBXg8nB7RfOmXnNYs3AUfhYib9fSdBwKdGDl6+L9uIQZQrNh/EKMHnfZmK+SYh0VNsaqcxnSRrNvQutjUih73f1yA3JnMAKiYePDUSWNig9xzpFSbvA5K3v+yWoLacAL8a2s8TEiSkTcwAHnO/M3BUlzKxdLV+GCo+kdw5yUvwF4eQ6XrhfZpRPA3ym82yhF3tmjVAV4mstUKwRsunFBb8gnC/OVs7oGe8BbBJQ9ANZo4ThkZJgy5ls2GzO/yM8Dq6TCqkAZrQze+cijLf/EZr0mmzhkr0lXiKS7F+Rzg9m3DCYIaQaTa984aH75uaWHxzBKUEWto+eR9YsJquwbFUyeeD/Wu0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(966005)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?MPd6J6D8O6A+sBuqpfwR+hza1l8itTMS/PMFgjR7oC3OeehWeAVTyuGoNzPG?=
 =?us-ascii?Q?7ITPkWeZ+woSTpEDmZukeFtUeP9MS8Ck1v725GarnHI/VlU8ovpCtZTM2yM4?=
 =?us-ascii?Q?87E1uk0lx4Zk84/5MLm9EsRvOWVYZtGPqJVLzxWAB5oePouRlXkwJV8yz0Sj?=
 =?us-ascii?Q?vDjErxoX5fwO0YLXFGZiYyJgpjCYen68+YCBa/+YQbYLxY2x+4Lkyf6zD5dG?=
 =?us-ascii?Q?5SGurvcHBMwh5ul5EM48tVAel1IhE+ZogaoSXc+mo4leSJ5EAOWZJNFwh2BN?=
 =?us-ascii?Q?+WA7MSzCkTCbwQtgFQ3zJ+I0pm+ATw2qAQ6DmacHQ5Romns8gbMA3YcJY6Pc?=
 =?us-ascii?Q?rt/lpYJmVmUDuBgR+ykZwN7TQyf9oQFgj9woEz7sBAyjO/V116RRQ7Wtnqlg?=
 =?us-ascii?Q?1hC3LGd0ezgoCc3ywNOHHxgOW+3tmXJ1D/EaGAeqyKkIRfhsyhKNBjETVpdl?=
 =?us-ascii?Q?D9LGyvsgi6kdjOdDPj0RDZCCGe/+cfqzTcSuHWxfJlkFwtTIlI6zFCBYyMct?=
 =?us-ascii?Q?lrxLJPhX33aKF90UsHwMXkndmIrTeyr9ghnUdby0tHyVApRupctCWcLtaoHg?=
 =?us-ascii?Q?dlFaBk1nCXc5uhDZG7udLhaUFV4uCNa+SRDbpaqKjbNoHaJ6BlgdZar9msKl?=
 =?us-ascii?Q?KauKbx6fKB8ojCi6ELq78yVCkjVvaTAcgaA6lnJO3gEduajcybNkrtYSOBwp?=
 =?us-ascii?Q?DrGvf7D76V+/Sv8MSliBftzooPKn4QNNo5bMGrGoD+MlF28NK6lW5RSFgJ3l?=
 =?us-ascii?Q?KkW3BFeCFCfgKQNdQdVEXCq0Afab4p0K3Cw9caXM8C4rc70dpWBVAwlNjGF1?=
 =?us-ascii?Q?xfl5KsrFnqtGywBShGyQ9jdc6Ju2sjE+IG1g+fLZLgZO6pgD5afkJuT50xWi?=
 =?us-ascii?Q?jsuKTT4QOVbRYXD3HKVzCtfp6MRpF2kYHDhqOaA0qNRWf5kxKk6J9LtIpCtz?=
 =?us-ascii?Q?dOA3+t043ITlKl818xkYcbMOItHIJRjI1IH6kHK5dpbgmZHOz7cve3fPgV4v?=
 =?us-ascii?Q?unhn27uJ2J4Kw0Z2SrYrRT7CEeQBvnb8H4EFhEanngCSoHqUfNdKxWfweGiZ?=
 =?us-ascii?Q?jdbNRl7caSLPknBVkGU9LfzUADogNidkGxLbrGfg0glbsyEwprXIPeq1SCxf?=
 =?us-ascii?Q?giLjsr4CGfb+ySs8rKfW5Mc1PV217RoSXCHSIw5KYPaRj0GvHAZ1rFq6Q2hS?=
 =?us-ascii?Q?ZYeXYVBHHbHdMYmlGNpi4zf0Pkm4tSkpvvvkjNmT9CvKWw6AublWHCvDuK9u?=
 =?us-ascii?Q?KVSmpLIEmHO/WjhuktTfUEygfZhyn2MgzZ68hzYSJQ7DAO7fm35Oijtqgpzs?=
 =?us-ascii?Q?oy+6Qi/trHKSu+utFsN++XV58qGs/3S3KQHd6gnvFst85ezby4Vfq7Rvfzuc?=
 =?us-ascii?Q?sECH47WWCYze5JYHM8WVDbr7jYknQj/graBmTVrWaHm+fFsVINfFHbPtsQ6M?=
 =?us-ascii?Q?QXisE+FpK/3KjJ6oiIbEz8qItDxGlyf6HzqqSUx5dC1mmi9wHwgEWPBOLWsw?=
 =?us-ascii?Q?ZH+MbSNr2qmInKpziWKnhqEMTQ6mgZnES+lK6ROhbnDBUa/XLrjlfl6GxlCu?=
 =?us-ascii?Q?grExuNGk6YAUF8zpVQ1NuPx6pBZHjf5d+LxOPFiQCvgk8X0vJbkNJYZO87lk?=
 =?us-ascii?Q?BfVCPKljRuWg6sSmKxauL8GRYJbZSJMT2x+Yf8s4jP/0K3103ZiYZzxRurjS?=
 =?us-ascii?Q?FPGWHA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	stXEwnnYyPIxXyMG4bLgmUbQPu+OQQHBZ84YbMeYOIEpe6O0x1HdGLwNDPOFsdW1z4QHktmKqsl9jua4m/kcQtDAflVqQgqwbbPydukJo0xCjL1VfRuAlynAf3PHkafXvxTSvNVhn4T/xqpW2OlorvLrufit0VpjQqpzu7V8qIRFG9oHI0FpYbIwJR8yFG/EutcIG9CReq0MijVU7pAeA2XbApL66W/zgON6oyqSho4na0vkmFse3rkAjt9U6fAetmT5J3hM176AmH+X/+wufVo2/tamYxOYfJZq893MMnozgdIZMSCRTlaFsxVL59CHXNSfaqli1tzxl6QC6VCEeI4FXGXeP5J1N8zI1y0NMymcX+hrbL+pRcrSzMzxVVG3iEPSBxcvwLze4aJY21gFsSNOPjQIGv0OHwHYQU1Rh4T1UwX1sBLkwLtgRj5IMY9pChxUIkU8dbJkXIq77X98ploC4v7b+5+tkEUvSaYpT6jaSdPxHnEtuFqyZ6LCqeAT/4C7mXtvPRzCJZ/VKxiKNTl7099Hjdi7Crm5i21YusHLktLF3/eYqmQ+Ibe/zZ3wFCJrMBtwKez74phAa4r41FlGU1LFBJi1GnBb820PGUI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d199de-3906-4e66-c15b-08dc2698bc4c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:21:01.7636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHa2gFGEB7UxOIDg9WvVP16kWIsWTK5L4JKCL06SJHs/rQi0znlTAGpobGsrztp0OR4OGNHuGdCZ4aceQ/VMO8wDLKbGWXYiyEsLZ6EeMj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: ytDtmOFsw9NYrnuT9RQWLAD4LSbf7Hj3
X-Proofpoint-ORIG-GUID: ytDtmOFsw9NYrnuT9RQWLAD4LSbf7Hj3

From: Christoph Hellwig <hch@lst.de>

commit 9c04138414c00ae61421f36ada002712c4bac94a upstream.

Update the per-folio stable writes flag dependening on which device an
inode resides on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-5-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.h | 8 ++++++++
 fs/xfs/xfs_ioctl.c | 8 ++++++++
 fs/xfs/xfs_iops.c  | 7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3dc47937da5d..3beb470f1892 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -569,6 +569,14 @@ extern void xfs_setup_inode(struct xfs_inode *ip);
 extern void xfs_setup_iops(struct xfs_inode *ip);
 extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
 
+static inline void xfs_update_stable_writes(struct xfs_inode *ip)
+{
+	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
+		mapping_set_stable_writes(VFS_I(ip)->i_mapping);
+	else
+		mapping_clear_stable_writes(VFS_I(ip)->i_mapping);
+}
+
 /*
  * When setting up a newly allocated inode, we need to call
  * xfs_finish_inode_setup() once the inode is fully instantiated at
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index be69e7be713e..535f6d38cdb5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1149,6 +1149,14 @@ xfs_ioctl_setattr_xflags(
 	ip->i_diflags2 = i_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
+
+	/*
+	 * Make the stable writes flag match that of the device the inode
+	 * resides on when flipping the RT flag.
+	 */
+	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
+		xfs_update_stable_writes(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2b3b05c28e9e..b8ec045708c3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1298,6 +1298,13 @@ xfs_setup_inode(
 	gfp_mask = mapping_gfp_mask(inode->i_mapping);
 	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
 
+	/*
+	 * For real-time inodes update the stable write flags to that of the RT
+	 * device instead of the data device.
+	 */
+	if (S_ISREG(inode->i_mode) && XFS_IS_REALTIME_INODE(ip))
+		xfs_update_stable_writes(ip);
+
 	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
-- 
2.39.3

