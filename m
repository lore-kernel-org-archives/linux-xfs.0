Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA9718307E
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329806; cv=fail; b=QmZnVBqWgfAmup5i49QaJbP2KaK9DtQM0+3ZGtIaO0y1zBEQdj/tfePwT/C2XMlp8k1yKnNENmrqAWb1asikZruweEPUZGllTsNZGrydBog/8QXlm95F4JWYFeHqIJA23yT8M9c7U8M5atjiUxDxWQR3QKboUNXydUT4I7dJlV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329806; c=relaxed/simple;
	bh=h08h4RlV4yVXa7tlNzC2rgXcm2qixD0sig1lAOmQupI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hHGNJdYLBKzOs7L4Pc/l5P4BiHMN7X7wOMRXY52I7Prq5K0OG6q4BkMyWUz0mLyuWKLZYpu8TqmFvXHIbwGsbpF2hjSL2i3ktjNE4jIj6w4uuzC55XBrqYyIhPlzcwWnBrFAQzCfPH6bsrnrOYHt2XFOIe2Ktyw3nNSx+nogr9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G8t2AAQi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ycrrNqA+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G8t2AAQi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ycrrNqA+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fQgQ010212
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=j4AYwDEUk7A82tS7R/8Bs4kb3E/SeU7+3+Mo7cFQzSU=; b=
	G8t2AAQib/TkncZafr/xML9xjq/uPhNBuW2cCTCXVxGprK+zMLi7FonfLf2IBpnh
	zwBMNMLB6VVCnnO8tk51PLj56JXwL3yUQz1mhasjp+bDglRG/ywYBEyRRquEIRsf
	34Pe98jCj7RuGOKBA9YDJcmOI8NiHF0n+rFaNHuSlRtKReqOmo3prELR0Mbs5gc4
	GeEoRh0COrEapH1zXv7ct33UwYhI2LJjKisbNM/c3lZB1JwL3SPbG/YKtRIYqk0V
	CVq8oFYPZn/Zc8PivE6IcfdUcSQQCxs0/Jp6f1u9hHX6AMh/zggwbnO7NaqeHWjT
	hpWTQB4B63AU3z/xVIIa2A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1gjw10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DMsKU6021135
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncayaukk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZycfO6bze4H/P9ihb7RZ8SEP2fIS23FRZPZMhgKCJpu8u6tUvoMCGO/lKZ+MKV9bXpMl1ePj+QlQtwvc7gYa6Fi4hr2OTJxeusLnPbJ0KrKxEo4SlidnRZiq2hp/Q8KTG7jqDSE6DU6x4KyfwlZCObNdVx1Z1N8G2Cd/S4pdQvo7wbmsv2HkCqnCkrDokzVwSH9FJXJFHMD/awiOdYzNKx1SNMHeKIoOaULTI1guwq39CsXNfCp490WBz9uKPRaFwHz0iR11FNZpby4lFP99ATJl4FeYGp3kOUnSxNhMNuPeUS3HCGBA3PGfmzyO1sLnRrZ5hrF6kK/S5+WzDgixdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4AYwDEUk7A82tS7R/8Bs4kb3E/SeU7+3+Mo7cFQzSU=;
 b=DIdsGAP78DML1gjYgzJ5fkQ2VGNCivpckGQwvpl6qBYEuHClhzi0PPibRqnlAn9cCUyq64toFHI/K/Fsj2eJjq0G/fr+eSjTohKracitHgaCZMfR+noqCcezkWMGlaSp+s3VYaHYiO9D3w594ZZJDBwFAw7WP+7MvWUpFYaHq3xbw20uraYAPWdOtxnU6M2+NXVOa4kmV9F+51A71V2OnsihLgEYALgvLjdTVDJnaIM6HU5T1NhCwS1IB1DuI25H4uDWsr4oCEnt1yYfkChJ11FV18K0RGE8bwJeZUMYC218oATfLf3AK88q1ObkR9tLPab2yQhJDdQyMLGB5zfjMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4AYwDEUk7A82tS7R/8Bs4kb3E/SeU7+3+Mo7cFQzSU=;
 b=ycrrNqA+O7DSIWB/qdle7ScPubdIJ15uxcg0lQXSCjDEwWS2myEpgVLO1jnlEHwEyde3eNeqy1zZPx7UPRtTyilCi/PQidWGhgjhGoWdXguPe+D3hww7eQqhYBsmlFeuwx5HvlWGwm280aHF5Z4VuTemii9rdxMXj3pdstVyols=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:50:01 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:50:01 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 5/8] xfs: ensure submit buffers on LSN boundaries in error handlers
Date: Thu, 13 Jun 2024 18:49:43 -0700
Message-Id: <20240614014946.43237-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::20) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 38c266c7-e9f6-4d2e-7d69-08dc8c144dbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?IdgcSfFUDs0OZQLTQFFAu4WS4sB+SrhqyzPu/Ff/xaadDGIKjVCWVmywXNXd?=
 =?us-ascii?Q?UFax5q5zsl2MUc3wnler8dg2YfGasttpmgXpR67hInYfXFFP7iUwyVzPr6hP?=
 =?us-ascii?Q?9x4c4feMLJG07rlLYrvHTVwDPtQqQifClPziQjWwfuxXtx9gIpE+xnDLyPtt?=
 =?us-ascii?Q?bPkj84H/ElCRx1cQ0k6oxTQMuCNhOLfxeppnKPxydt0jl4nq0flJav5zmlis?=
 =?us-ascii?Q?qnGBPNjSbQ7gSI9P33UAXxtMs9Q+5INFPoV/mZ9gRrQK4u+YjNBLOv42RmCe?=
 =?us-ascii?Q?RjLam0xrpEOC3HdHzXzZEmB+W0BKtnqOXxK1KTfE9UH60xmzfwZ5G7Woxu9L?=
 =?us-ascii?Q?Xp8TrEdYHwW14OY5dPq5sbTFhJgF+13tQRd0TRPaHAK5XkC0EXCdyq83RjWT?=
 =?us-ascii?Q?o2+DzAJlwt1XDQzPZBBFLDarVf6PyDQFhHvVh0YXhW+05q/cBlUesq0z7TQa?=
 =?us-ascii?Q?0OT9XfzeZloiCXpZgzUbCQYQP83iLG8VEU5VbZNh+daXHcj5bxf5X/tci+X0?=
 =?us-ascii?Q?1MyfsQeVr3VMHuEOLzTI0lHErVfCEAUCobCLhTJ5P7bbYyLn1XWDRU8X0mH4?=
 =?us-ascii?Q?3fuu2/a7Z9vZ0eYgyZXrG3GsvvXXY2BzKiB/OA55VjQkiNZyg24IXHTos7OB?=
 =?us-ascii?Q?trh3ngSFW3x4b4iYqS2kr3OSBJj5BkiPF7sQwvJzSi1w5WDcukyz424Q8AJT?=
 =?us-ascii?Q?RrmJaexcZIZKUvW/WBDQBY4ZJtOQSBXvG4Ibwf9eD7PAT8qJSf2HhaF4XRIk?=
 =?us-ascii?Q?v6Dvj8f2zevLzxrRX7yu6yDuF6NpAbcX9GQ8tNdhXk5LUl7RXrrgk+URCrtU?=
 =?us-ascii?Q?K/ONhbxVY6BW/n9ey+8yrIbSugsUKoFo+fnqsMv8haV1qgMOlZDM8PgxsP2P?=
 =?us-ascii?Q?334Bego5w6DOjQc0zZG15i05uN2Ax7b0IQFe4ECZLhF/LEDXSeX23ateMrD2?=
 =?us-ascii?Q?bmhlQS8oyupegoFmFgzyM3KZTCNVhStzwYZWF4Np6a7ovt4I1GMwHcZjb8eL?=
 =?us-ascii?Q?+vyB6IVRnHceGQZXk35Mtces4r7yr+IB8dU/woE7c4mzAE+l6EePbCkirU8R?=
 =?us-ascii?Q?E5P/tu1arqGeNPUw1W4OwvhnXuTQ/siCRXLInNflUZsrpGXhOsqNaqmqMMIu?=
 =?us-ascii?Q?z+0f1shCb0Q75I8u13akopHVH1p17NlhCQrDrH7+Ev1sD9ZHd+ACVHnlceaV?=
 =?us-ascii?Q?b6HqOax/M3fnNPzaX1g5rGcw6DSfa+MMxCEB3oh2Y1DLQThi/bfI0DQBAK/R?=
 =?us-ascii?Q?kxC5YK81n6HNF2Y8oQLRcWBpJ6RWxuF5MKHrNz0LIWnNoHRz2Dd0U9F73D4q?=
 =?us-ascii?Q?285faIcgVvGKGflkrh9n6eXO?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UPfyTh0N1Hd6SsyH2SjzKwCiaQpGL8zcPsJdCSQ+HhFhXlcghSayr/LQfH0y?=
 =?us-ascii?Q?YxLm6pA7/K17PO6ssjOA3oBRr7cLT3ZYgds1upA9c/pMbtICfKqSQXPdkZgg?=
 =?us-ascii?Q?zOakx5524xeK/iQd7pRtlU0fqb3/RI+za23qqj09wuUQDsJ2v4tmP/s58YFa?=
 =?us-ascii?Q?Z0h5XlfK484Gpy4KkkRQ7r6X99UQPX72W/urHx+ptqOlWrFgHHLhmu4DU8IA?=
 =?us-ascii?Q?n+rsQSqspSlZiJr6xY/iKG6mUwVPZp8sgu13gJ2IBdr6Oqy8iJ/bLlgoDTJy?=
 =?us-ascii?Q?NMyQqHECeRM1fX7UwuFAAuorVzzTQ6JJ4AQnEWol3vxHYLdncUc8eHlhDbDL?=
 =?us-ascii?Q?mZHJgo7OYohTaIObkZPTcXrMFufnly5fdVal8aFyO0Nn0s8gNs6NNix2Atj7?=
 =?us-ascii?Q?5+V4MpLdyXq28DLyD2wgO/S5SpoYG2j6BhAmP78hWY8YWZ2slOtRtk+uvmQd?=
 =?us-ascii?Q?NWRu+KDL5eq/k0P0dfHVadStjvRT6HrbZG93zv9kGIy4gX4Ikblc7HrjKl02?=
 =?us-ascii?Q?EoYE2vzOYZJp5G5s8Tch0n4qe2kmLkswyMqZNKiNdiWtaIp4MiSTKdb0yykK?=
 =?us-ascii?Q?9GIpBMuYjsM0P9Vn3iIZsrSjTo/C/Ag+FxjY/MbatKXDYzr/NB5td+8bSbNg?=
 =?us-ascii?Q?pK1o/VXWX7/XCH8SvMye81OBOOmjIO+X4M5m0ps/YLfFvl15Hp8g72I7PPa1?=
 =?us-ascii?Q?D/yXr8ZW8I4O3qXc+IV3kKlJZCF+jSkKZPdliu3zCo3W1iYoH2PSj7fXXsnv?=
 =?us-ascii?Q?71tw3hwh39/MjbbLMhQd4E2lW/shQzM2Fovx8zDbdRcR/xhYee7LTi3Bgt6J?=
 =?us-ascii?Q?XHZaS4ZwKfbgvsojoHRP2fa8A7ri5kg5ZUljCU6qsxwLlgJFaOzqwwjNzgtr?=
 =?us-ascii?Q?dw8ceqs4q7a0dA60rTef69w4GUeUB1AxznyudpLi7TU1UspFWCyRUyycHPma?=
 =?us-ascii?Q?UDHV7I6k6kAyF6aPr2bjiIjy4P/KttAiKmS+x4mMNwHnPCwDi3olelTajs38?=
 =?us-ascii?Q?tPTdbe8ZkwM9J3y1y4Jo7EPy8QyWTstD6RAs0mxbDB6gclECA+o2BurXEkve?=
 =?us-ascii?Q?iDcUOlM9MEGc/FaXmfjIasC9/2dnjfX9PlI1gn3s6KB4PSo7Wi4+5HGKG/wA?=
 =?us-ascii?Q?n+/K1dWhiOm6zGy1EKi/JS9Y+i35765rZeMtUA+NJqPn0IGHcka9cuLN9OxF?=
 =?us-ascii?Q?ZFDmySoVciP8wFSMSr/tgtmOJuPoUGTpuIKhQMko30qXiNTRXan/CBGVpo7k?=
 =?us-ascii?Q?soil1ZPqvJxuoDaNv8CTPdZrG3316tdN40usJfGeXGyJF/2MAL4n0a3gUArj?=
 =?us-ascii?Q?mbmfR/1fcdBti4T0zLCeUr4o2+hkWRpIPNwPXHVp+6VoVvdFLPi3n7N4Z8QH?=
 =?us-ascii?Q?HQrVZQw3gmqvsOMrmtg18gq+meiLXbK//u12Ui2PatAk91dz+SA9n0WIBsFq?=
 =?us-ascii?Q?cJITVC48bAxi/Hq2LK/PVPaotboCE5A8g3aCGgB6hORCf+dW0oDomQiUyt6D?=
 =?us-ascii?Q?OpzjI+0DINJ0I+O7b3dV9QDnYX7RgSgQypbV64AJCzoq0/o0SaKNefPe8jM9?=
 =?us-ascii?Q?q9vhOLppknZnGBzlikpHKWg+JPYPz8ono4g8wWhPptMKn9y0Q+9LTJlwyIGf?=
 =?us-ascii?Q?4WH3rigFkb7uqAyOKeCOc4NZmDu+70Kw6UkPCZluVYohhsezP9B6D3TAudN2?=
 =?us-ascii?Q?UGNyAA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GyzkNp33Y/bmI+CpmHCCxgRDKIEzphBF8uotKUCF4ew1BzcufSBtW3IP3+gBOPgWXjIlEnkxaOQ3WOSbYQl2Nnx4iS6SKMQJXh7qjJaTWXI4AGGdkzdvRdE34Yho6xy3UrIkmaTOdN/7RJ3SA40PTMknDn6485SWiDSQNTjyKhtjaM+b0q5CVklJ82zdFp4hwUTG8p+N2ffsG4YcjC5NhYS0overo8EW1kE++URD+DDbXthumNPdm9xi+QNKHNJFBJqox//Mm68Bqz0HRxWFb0qPaMfd4JzbiP7AKZiTKvAe84FwM1rp2Cfalsap44c3/wroTJKEi0idd4Y4IEh+WgvdZ6+KsZbkuiSfZgpb7EiC10oni2gxg8mH/fa37TDnykGe6m2Jqlx7jv+PsxB+15sTTMtSbECj2KRM/Tuc8LKWPsLk8RH6HtIh4Ci5CGZcMr+0Ga3tuwPYfd5tB3prht/Z2K08Jdw7PxQW8iXvm7DiUnVkuCCkfPHIzMQQXThXN6vW37/jYQ/gPJJ35Bk1CDuxcTr5jr3pq+G3UfBthT3rbyexMcNbTXpVpsK/cYXkzthdk3S5fJuuR4DvPtXpdXd31avoPRhkVd5OT4CVsG4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c266c7-e9f6-4d2e-7d69-08dc8c144dbd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:50:01.2650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oB0ujBHLFNoiLtZJI2TLiB7rqLrwebJo39x+605Q4tRjVS8AG92GE2eGu7UkHrBphG2jP8sChUCCjLN2whQ0GqVo1G4AKSxyXqSh62yhmxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-ORIG-GUID: V3tVODC8Y-GGC-feYacLTfGuK-jdoptA
X-Proofpoint-GUID: V3tVODC8Y-GGC-feYacLTfGuK-jdoptA

From: Long Li <leo.lilong@huawei.com>

commit e4c3b72a6ea93ed9c1815c74312eee9305638852 upstream.

While performing the IO fault injection test, I caught the following data
corruption report:

 XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
 CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
 Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_corruption_error+0x134/0x150
  xfs_free_ag_extent+0x7d3/0x1130
  __xfs_free_extent+0x201/0x3c0
  xfs_trans_free_extent+0x29b/0xa10
  xfs_extent_free_finish_item+0x2a/0xb0
  xfs_defer_finish_noroll+0x8d1/0x1b40
  xfs_defer_finish+0x21/0x200
  xfs_itruncate_extents_flags+0x1cb/0x650
  xfs_free_eofblocks+0x18f/0x250
  xfs_inactive+0x485/0x570
  xfs_inodegc_worker+0x207/0x530
  process_scheduled_works+0x24a/0xe10
  worker_thread+0x5ac/0xc60
  kthread+0x2cd/0x3c0
  ret_from_fork+0x4a/0x80
  ret_from_fork_asm+0x11/0x20
  </TASK>
 XFS (dm-0): Corruption detected. Unmount and run xfs_repair

After analyzing the disk image, it was found that the corruption was
triggered by the fact that extent was recorded in both inode datafork
and AGF btree blocks. After a long time of reproduction and analysis,
we found that the reason of free sapce btree corruption was that the
AGF btree was not recovered correctly.

Consider the following situation, Checkpoint A and Checkpoint B are in
the same record and share the same start LSN1, buf items of same object
(AGF btree block) is included in both Checkpoint A and Checkpoint B. If
the buf item in Checkpoint A has been recovered and updates metadata LSN
permanently, then the buf item in Checkpoint B cannot be recovered,
because log recovery skips items with a metadata LSN >= the current LSN
of the recovery item. If there is still an inode item in Checkpoint B
that records the Extent X, the Extent X will be recorded in both inode
datafork and AGF btree block after Checkpoint B is recovered. Such
transaction can be seen when allocing enxtent for inode bmap, it record
both the addition of extent to the inode extent list and the removing
extent from the AGF.

  |------------Record (LSN1)------------------|---Record (LSN2)---|
  |-------Checkpoint A----------|----------Checkpoint B-----------|
  |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
  |     Extent X is freed       |     Extent X is allocated       |

After commit 12818d24db8a ("xfs: rework log recovery to submit buffers
on LSN boundaries") was introduced, we submit buffers on lsn boundaries
during log recovery. The above problem can be avoided under normal paths,
but it's not guaranteed under abnormal paths. Consider the following
process, if an error was encountered after recover buf item in Checkpoint
A and before recover buf item in Checkpoint B, buffers that have been
added to the buffer_list will still be submitted, this violates the
submits rule on lsn boundaries. So buf item in Checkpoint B cannot be
recovered on the next mount due to current lsn of transaction equal to
metadata lsn on disk. The detailed process of the problem is as follows.

First Mount:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              /* recover buf item in Checkpoint A */
              xlog_recover_buf_commit_pass2
                xlog_recover_do_reg_buffer
                /* add buffer of agf btree block to buffer_list */
                xfs_buf_delwri_queue(bp, buffer_list)
            ...
            ==> Encounter read IO error and return
    /* submit buffers regardless of error */
    if (!list_empty(&buffer_list))
      xfs_buf_delwri_submit(&buffer_list);

    <buf items of agf btree block in Checkpoint A recovery success>

Second Mount:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              /* recover buf item in Checkpoint B */
              xlog_recover_buf_commit_pass2
                /* buffer of agf btree block wouldn't added to
                   buffer_list due to lsn equal to current_lsn */
                if (XFS_LSN_CMP(lsn, current_lsn) >= 0)
                  goto out_release

    <buf items of agf btree block in Checkpoint B wouldn't recovery>

In order to make sure that submits buffers on lsn boundaries in the
abnormal paths, we need to check error status before submit buffers that
have been added from the last record processed. If error status exist,
buffers in the bufffer_list should not be writen to disk.

Canceling the buffers in the buffer_list directly isn't correct, unlike
any other place where write list was canceled, these buffers has been
initialized by xfs_buf_item_init() during recovery and held by buf item,
buf items will not be released in xfs_buf_delwri_cancel(), it's not easy
to solve.

If the filesystem has been shut down, then delwri list submission will
error out all buffers on the list via IO submission/completion and do
all the correct cleanup automatically. So shutting down the filesystem
could prevents buffers in the bufffer_list from being written to disk.

Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cc14cd1c2282..57f366c3d355 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3203,11 +3203,28 @@ xlog_do_recovery_pass(
 	kmem_free(hbp);
 
 	/*
-	 * Submit buffers that have been added from the last record processed,
-	 * regardless of error status.
+	 * Submit buffers that have been dirtied by the last record recovered.
 	 */
-	if (!list_empty(&buffer_list))
+	if (!list_empty(&buffer_list)) {
+		if (error) {
+			/*
+			 * If there has been an item recovery error then we
+			 * cannot allow partial checkpoint writeback to
+			 * occur.  We might have multiple checkpoints with the
+			 * same start LSN in this buffer list, and partial
+			 * writeback of a checkpoint in this situation can
+			 * prevent future recovery of all the changes in the
+			 * checkpoints at this start LSN.
+			 *
+			 * Note: Shutting down the filesystem will result in the
+			 * delwri submission marking all the buffers stale,
+			 * completing them and cleaning up _XBF_LOGRECOVERY
+			 * state without doing any IO.
+			 */
+			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		}
 		error2 = xfs_buf_delwri_submit(&buffer_list);
+	}
 
 	if (error && first_bad)
 		*first_bad = rhead_blk;
-- 
2.39.3

