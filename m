Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1795AD2FB;
	Mon, 16 Jun 2025 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110747; cv=fail; b=BGeFX5uNg5RUnMD2QLAhcqSqFhRqp2WKikkWCvMAHS0GrO79UvLk/gP6jOH+b1CFveQ4Esa0qmOyvqZMcIa6KwUAFaLiwXIZOM+sI+SdEAa+QKAYDqb1H12x4YxBSZbB5Q1gVluONi/pr0xFCNxSKZfN2liWyZo5Bw3uRRqF1XA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110747; c=relaxed/simple;
	bh=bo6ehsgL+7DOlAa39MUMb8M4fSO21wtclfZ5Dq08Sq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T7E5yyCfVsK6oZtW8WOytl4A31lVJfi7HH++PePbcpwaksy2C3LV/MzzvXUTvGwIoVzReNEWb0iHpg3WSlkXqvO6l3u+FSvzsOwTjwHPCwo8DaeN2TqihaKsZZMmdcMJkzkm+Q+hNEh9vRZBMxQ+YTUiUJxTE76RVmFsOxv0dAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FQzpwtNo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xEbQbd5m; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FQzpwtNo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xEbQbd5m"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GLZqc4006564;
	Mon, 16 Jun 2025 21:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aN/UVyAXUDWf5NWbGPyX1ZofE0i5X2yPYzuPIrraFHE=; b=
	FQzpwtNoB0HLUDeu8bs0PIJHXe9t2sWAzaujkeUj71RZMWXQ+q4l4fd55LBoFUV6
	mn/WnwckR8J7seG35POCl9Y1+v1WmsM1RgXQ7LOeTVWHYv7qVsvbQKizRNVssMSX
	qbJkYk+Dsek0dhdl1NS9D0wMXCw4JpMwNCtdsIo+qaQi6VEF+qxTyfhRtzXed96J
	s16L5ucQDlu9js2jFMkDE/S7WQAW0qhAy8ml7+N4WkZRTyHQ92jNZJNYDw6Q4vSJ
	h8aXENLpVFkYrG6HAGla9kOJbK5N+nuT3XuXg+fM/JPSIZxQ50A21RMF4Sc/+vKN
	4haGZspc/IDmuuUTuF+pjQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900ev4bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GKUbTF032239;
	Mon, 16 Jun 2025 21:52:20 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012035.outbound.protection.outlook.com [40.93.195.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh8fqdx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXay4fgyePnaBN4dnwrUs+pn2qhapP3K9Bn0GJY5mF55ovhAE651a4gjwfD/k4F7Ovd5vTGcSznHFEJ5/ZfqyY8Hz1Wsyb2a+Ffo8eYd830gpgB/8DcGWBnxbWZXePYNhwWUXWyIP//ik+taqB8ayJTrxBvM6OmM7Zt2uNDxigv6AwglWoFaGGa9Vbd9HjzgvkljBSfiTkq8sc1TKC59NFyCx7b9IZ2oYBnhTl8nI9IKAwCBj3B6WtP6wWQ+5LHbx/ivU75cVlwQhHm6J4S3k8BOqVk8bgv1Fum8qWLL/X5oB7un/g0wYpRAEXP+/JnZtYR3VRp2Ff7AUSMBZzxNQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN/UVyAXUDWf5NWbGPyX1ZofE0i5X2yPYzuPIrraFHE=;
 b=PSwHJyK/Gb/zFDJBDGfa5t+OsuVQ6jg8NibEG1YwJTbBiPRbEX5B0KMreI/Ar/sNS268ivGuuDsnbZ5/AyK0xX1SNcvJWnfkJ0+FxTPlw3WPhD92mruA2WrC8KC+pHjnkO5jIg07HE6KZeM3lF4oUuQtUZC2RaEKZixEovbB9inHbo7/pT1oHOSG6fdIk1Qr8qLeoRahuGU56YGNMcAu1QE1wPQTh/vz+kg20ZvsT6t9X66DYosblUCrVNMeOQBlVjTc4uIDhc4d1EKn2MPqXQkIZ4h9zE6vKiunGz3nq7fOnS5rwk+Ch2oUYWbu5wT9CY612NfCBOboGTbElVc4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN/UVyAXUDWf5NWbGPyX1ZofE0i5X2yPYzuPIrraFHE=;
 b=xEbQbd5mLRWJhRoroRz3KfuyjDXabBLINZn9b0XizVYX+PbHViqjhuiEIYxW907RPiq2oYwBNcoobQZBod4WC3t9djGYicjuQpM1bMzEYxURdzjClD861EFyIbHMTWVUi+jkQUmSXRoUfRAs3hHSLfPRnhznp6WykT9Pn4lV3LI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH4PR10MB8148.namprd10.prod.outlook.com (2603:10b6:610:244::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 21:52:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 21:52:17 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v5 1/3] common/atomicwrites: add helper for multi block atomic writes
Date: Mon, 16 Jun 2025 14:52:11 -0700
Message-Id: <20250616215213.36260-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250616215213.36260-1-catherine.hoang@oracle.com>
References: <20250616215213.36260-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH4PR10MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: 3238c798-3e15-42a5-8856-08ddad201003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1X2x7fDj8VL65JoQuksT2UeurJc68YFt6wAxl82m5LaYxadk5XeF8p/ViAZ+?=
 =?us-ascii?Q?iEZKh20KECVUbhzl0+zWieUgeoFy4J3zxv8uFgKGy1g2dMfyUjkSXJHE8WD3?=
 =?us-ascii?Q?qdCNLM7yV9qk52q3NFXZwGDgUfAIl5O+OakYSNtCkPlSX4nUEdn5SY5sY+9z?=
 =?us-ascii?Q?P/W23y34sGPpaOLQoLkhEN8Zp7OH4YQ76ZhgNtvtnXf/lt+E6ung0MRD5KvB?=
 =?us-ascii?Q?4mx0qbM/knO0PAXdBkBAv/Nh/03RAYPCCo9te7YKWs0mfvoHQ1QP53QQ2xDN?=
 =?us-ascii?Q?aW18gBPqXIcL/aiczkXgdRWQbqM2HdgIweMfVEYo58rWIS/JQ20DwoDDB/BO?=
 =?us-ascii?Q?i8SU0zsTLOE0mwrbx2TQRsJfgFoDaPYo1hy4AOq9/GCX5rBRkBLVqHkdEbVi?=
 =?us-ascii?Q?UbFT66/+OoqsJ/1P/dcoooLM/Ldr2s1WgA+Go/+PpvVkAFma75RW2mfdBv99?=
 =?us-ascii?Q?Ct5FIeBuyYKuf07h50BXnjFZ2n6eVTvCIjUY1NuM0w5gpVal0ieA7pqCIYHd?=
 =?us-ascii?Q?Fr0VL+n00YOugI90XrpddsYCfjZA6SgcEYLn6OfDDnEuUyW9Iz2ompBxWRq9?=
 =?us-ascii?Q?OcFoExqBaxdZUVuZqJOd4Ve9XIpHZtAAzcmt/0yOx1xOToF/fAbEiYQOMONE?=
 =?us-ascii?Q?hR4f4X7yKUtzCvVKlOM2JBgydnPGV6N+4nQI3GQp5y3u6CAV8efRL3v1qcjZ?=
 =?us-ascii?Q?PJW+bqQTX7P/COhDvhFXh8rKdsak+1G2mrX+CbLGMErt+1E7vh78/5wxwqJC?=
 =?us-ascii?Q?eVxlNp2eWUW8hDmF1ARaOh+9a3kCCc/40OBDjULJuWn/0P7/8aIPIUNwIOz9?=
 =?us-ascii?Q?E3xV0hGsvpUme91cd4sEBCeEz+kHuDjHOSzfulsxNDejvDy5BtDh4kIOVc9s?=
 =?us-ascii?Q?WQvSUeOmJl6Rv0kHKJb0sQXO9520FLUZw5Q3xY3qBs63gVhrddcDUt5c2+/5?=
 =?us-ascii?Q?ruChTbbr+zlQaOE0HrZXImlHFN2mB59kd2Ub02kCtHUNLIcA4ZS9Y0SizCr9?=
 =?us-ascii?Q?iQCCJS+e3ALzxSblJNone4+qk90QdgVg+wYUE9UCG4PB8zTHQ1p4MITlZRAb?=
 =?us-ascii?Q?ejebJM3/9bOzcO+jC+F5JUe5ZwnYJtvOJNhFmQO3T2eR0a2pQKbjQ5uqmGPy?=
 =?us-ascii?Q?YRkp5CJsoZ+fEjPFodjSNBpX+yZmdNIuqOIY4TqrFa1lBYFlmAYiiwBU3GwI?=
 =?us-ascii?Q?URHPRq3Nd2SwD/yy9MbK+kRUZR3eqr17/I/LV3IZyRNjrqDGJ5x4H5EBPqDz?=
 =?us-ascii?Q?NOI+7gIl6gZEFK6Sh5L8xdYLjTH0ZBD0+m1zGHjLLrpF1xjcBSbKSf2MA5ZB?=
 =?us-ascii?Q?rKLW1isKvwGpt44JYoIpddNQVkCSH68Iw+U1UVJ5PPCMCv8HPZyUVw4OgB/D?=
 =?us-ascii?Q?vPUGsvca5kA+PPjEeDyIwodFJSGxxuh0M/XOMOmFeDeIdF4iNSexnNzxrU5g?=
 =?us-ascii?Q?YzcMLkIJ640=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EghIJJ/jwhT8rN8vLxAj8uKevhTBEBYa+Di+svxbqO6UeYUhlfsjOStoiAdr?=
 =?us-ascii?Q?TErpTim3khYYAFYM4xl9fY6ig9R2ZZJPxLUXqhpmTICsstcqn6Wk7v5vn9cH?=
 =?us-ascii?Q?cgwSSQm06um6CzP1V3DlWiC42vJAQBtzKyyjM9Qa5b0QksKfyiQw8309++Pu?=
 =?us-ascii?Q?GVvA9xC6iUWq+a3+IsxZZiqg4Q7QYB5DY9od57BSP646W6QyZrOPrB3Zcgox?=
 =?us-ascii?Q?34Q4ulszR2lJ9HlJyk0kXH2tNa4BZoZGuM+trs1ETw33840szQZqt5OGo9rN?=
 =?us-ascii?Q?56bgslA2hKxI9a+8nN2XDEIybe0i3mtQPo5pmKD41MmY6XrRcwGMBB8kpOMY?=
 =?us-ascii?Q?VSaE4JejJVtebQSYzP5iGmpiSf9FMQj99W3iwqotdlQ1hhwn3Y5KmOtssMZT?=
 =?us-ascii?Q?NoZ+wJ9gsY4byeuAZcIRFv1i8EFxdaIXrjtR6NN8QE6gvpg1Lj5biI4DTrgL?=
 =?us-ascii?Q?bDwwV40aoge2qPwz3N3AvwlVAXYqlycThpsc7FEa73vCmSPWKXlR0MbSW8nl?=
 =?us-ascii?Q?EsySTXlk+zZY04RxM0WR4qqIBrd+YtvQ6kAICICFqXpnN2Ylz5tEMF4NVWD9?=
 =?us-ascii?Q?BbisFCFf7AJw2tAfPzbCM9WcpNzyBBzS+EVlV7R+pzAR1FDlwG/brzmj213w?=
 =?us-ascii?Q?kz/Jh4Ki4mYXkh02eQOHy78vfGv7FQVPa70UeKJpAiD3BdJXFXn+fpG2HYcf?=
 =?us-ascii?Q?QC3DXfw5xRwlbZXTH5nQHFyjgrDgIe5f31iY3QUsBrohF2laL6vys6T3Gj2F?=
 =?us-ascii?Q?sYHoeExLFIER5P/ofnrcQbVUQkpLTGzz/GO5QZUyR79sPxuQ7lKNXd99HRqx?=
 =?us-ascii?Q?/9s/OkE88dF3QU0lYsRQZ8eideWDGfNJiS1dkzJd3sYqx/VWVpU2c/VqgR4F?=
 =?us-ascii?Q?mzEdMef6yX9HdDJWWETd5dkA8xtxp/MEqB4kimX4Gz40CXy9EYBIuowuAqZ+?=
 =?us-ascii?Q?IvEevqo0bayleKHKH6vkOcrFUO3fD+LgfZwQw403igTKEEBPRyI7q5pJc812?=
 =?us-ascii?Q?lJDfn6dgdSmp4T0sQbUERnQNZstMa+L4lVOXQpkxa3uMXpJSUwmTPTn7apcK?=
 =?us-ascii?Q?zcq/FylFMkB+CVcgb2NkP6Llc71+obAFo9Wa6mWwuBmYRwUj8ZyLpc3iylC2?=
 =?us-ascii?Q?CKggpduluGC6Rr3iTavKSaEN6WD0I2XcM2uK5px2IxjFGF7Rtp5pk4JU/eGC?=
 =?us-ascii?Q?JKQSdCpm9xjudMk+w2wL+L2fSjG5eQb+acb+KlEoX9EuLk/EXd403XsvtOy6?=
 =?us-ascii?Q?+3sadDWc/uMFpq+pzH581bSJ62+d2lY55URraZjwHjAcmQYpg+WRJi1L9e2K?=
 =?us-ascii?Q?pAPWB6j6gj7T5kfv7CPmiUjmZLcEfvVvMKr1H37+3WsFrltl0oiGVrklZNvz?=
 =?us-ascii?Q?wXmxNiGWDplmT4H7x0NKgK12qzUZ1KQWYkzEClP4OxWxN8VCPajEAPF+07pT?=
 =?us-ascii?Q?XkeLInQ5pU/O5jmL+BxmQE0JV6nQ0yTj6crtdXc/q7C8TbX1hoKMZO/f2yqB?=
 =?us-ascii?Q?ZPlJoUKD8HGi4jXMixlrJ/KeVDF1fIL07SnMMlI9mwIRi7WhE31naqT40XDt?=
 =?us-ascii?Q?Qw6nkrLc0SKujqgbGNXlM4i/EkxI3iZ159rmuipaJ9G9hYkj0gYAvzrVpUpl?=
 =?us-ascii?Q?ak9C7VbeuRjT8KSF1d0/mOFwDbk/w0CSr/dzoGAvM4y/A6LuglliaYwHVRY4?=
 =?us-ascii?Q?GUpsTg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	emC2jJq94CuNqhy120aZpQD7/dRvWgwRLiDSI2ZR5rQVMaj8WdTTzrPuldXz7Pm0Tf4JHhQEF8/ggjHelwg191DS7ZSfZALdrR9Rl/X9a37C0aVAfpfqWm9UMxT5dPp8bgD4XBddHrBF7GHcZT4LZLpuVKRKeSt/kDMMXr332wp3lbFOkRQ4D+Pi2ViUECBlRzd6HIycsjyZzYQlP8I6Kqi3WLw2iiokZAZNdkGZZA/d61LjqvvKESQknZ/Vmr8knyeRgDfG4D/4e+HiJAjsbJz6kz7O8hNV9kDn1IjzeVf4qjxZd1drpk00L4HY8+uaCzYgJkb0Krkaxrqyd6N23P++wS+1G+l0/m9O3TFzWXCX5ygj1W/Jnb5c0yOY/eeu+mrHgm7oL1fdyijcCLNtjCf9rVJ2t5+ywuljdKqzjIcUI2FiE01Oiq67XUuep22wRc78tWSVgfP7EzJeOb/+UYV/KByqDBe2yXxlFmJk8hzcJJb//1JSGhHxbazA4vmO4lMLRVzTonYxUj7AuCpAYOxu3UcLbSYzMhV7RcQzSUgpoJN8bDfr2Of4EtySOlnj+CVf+0iWZpZdP0rXFaNNLlscVTn42/6kjk9ESSPCe2A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3238c798-3e15-42a5-8856-08ddad201003
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 21:52:17.8971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7M5bRj2MOGR0zS/h1aAUYjJxBLnBdb6XtgjbofK7V2lRupQFbTmkOXOrKA6xXuXMsCjmgWQ9TtIWM0KlYlFa0+9V5iWt4AxLbzYMFgT/1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE1NCBTYWx0ZWRfX2i5OSxF9qQKD csgZjL9Ccr4503UtKNN+qinBgFXd4zcVUhMO8HeRVGhsTk1bZxVuY3kerTueDjaQx+GAsqLbhxp fVWV7+eIo9f6O7jeuR4n6teCT9NQIyujkQyHXXqW9Xvk4ok+Pwn+G9M8QLKWnjLqMYAi87gYpwN
 nRmhZUDw3Qqma0youPvM5/2ld+VLFT7tgzA7H9VVhGvIYDSLgRwFPRVHd2NWnzYOGS2KdX1JWr5 3kfOlds8OJcLcd7RMPazxxmwjNoLSsZRI6KjMAwKwRYhEAUbOoGi+1K2Yl0Z7oec5EZSizLhtyF NFgVeKXnZqvR1NQkEenemd8EnYJvoAksrDCJCv+qZh4QNvggdbudnQjKZeVJY1Cw0LYo9Qb/5tM
 AMg3YrjLs1Nj7fqgwXZNVmiV/1+Yjkx3623Xqi3K260tNC0t3kGznW1CvYDXdAzEJL2Pr7Ls
X-Proofpoint-ORIG-GUID: 482q8cCCJkm_1VQEq7f_kBLx33edo18R
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=68509214 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=mx6Z5l6ODcrpD94SwjoA:9
X-Proofpoint-GUID: 482q8cCCJkm_1VQEq7f_kBLx33edo18R

Add a helper to check that we can perform multi block atomic writes. We will
use this in the following patches that add testing for large atomic writes.
This helper will prevent these tests from running on kernels that only support
single block atomic writes.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 common/atomicwrites | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/common/atomicwrites b/common/atomicwrites
index 391bb6f6..ac4facc3 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -24,6 +24,27 @@ _get_atomic_write_segments_max()
         grep -w atomic_write_segments_max | grep -o '[0-9]\+'
 }
 
+_require_scratch_write_atomic_multi_fsblock()
+{
+	_require_scratch
+
+	_scratch_mkfs > /dev/null 2>&1 || \
+		_notrun "cannot format scratch device for atomic write checks"
+	_try_scratch_mount || \
+		_notrun "cannot mount scratch device for atomic write checks"
+
+	local testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	local bsize=$(_get_file_block_size $SCRATCH_MNT)
+	local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	test $awu_max_fs -ge $((bsize * 2)) || \
+		_notrun "multi-block atomic writes not supported by this filesystem"
+}
+
 _require_scratch_write_atomic()
 {
 	_require_scratch
-- 
2.34.1

