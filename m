Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674FC1D6DA0
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657126; cv=fail; b=ba3frJ0WYzhad6hi7jpVJsVLh5iC//frRxzxnK3IsMdJdMztMk6mtQo0phg/2exseCeITkjtGyuDShQ6+A2HOp5R8Vmb9z1QJ6T64mgo19gwgcaWE0tJQlotLJNU9viylAaMkbi913oI9DBbnVvDT+mu0GXcom/UR3cnOyJP414=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657126; c=relaxed/simple;
	bh=GO/FDL+UYj3uZlQGMrB/2CKdekfe7KyVHKMCK/eZz5E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lh9k49/tDFh0m/Hrgtt7+kLcpDFkmZqHn/lFkGvTUcZRkWpvAt34Ch6Mxk1MyoUnjgZKTpsvd0kbol3Fqfni2YCOKL9izmHQveaG7qKOhToT6D0vociBdBob5B5nYoeXbMNW22C0ul3tMx/OaFv4dAmvwv7aCLqWvRgcGbb0t3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y8vhC+C6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U/orUzpD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y8vhC+C6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U/orUzpD"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXU2d024511
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=JfVAJ1s4jlNXvn5O2XfmUxuls4+9rdmfFiV4N2Pn/fw=; b=
	Y8vhC+C6xPxZ/68ZxASuADazGvMMVIkr49yW1KPJ3Um5xBltu1hNCfmt3HJuSJl7
	YNMmceGGhl+VXJH7MhDp911gHzHeKarjJ38T8SZUPGPYVcWYN2iv8dRgbEZI2O0J
	y1/8V/lsyJKM9CHjR/6/rF5Sa04mBjfvYmp6YBt94H8savFvvkLN71sn6qBHRi9U
	r1wE9OX94LcDdTBKZqnN4ox780I5gN63rTliwPt0XQ+KFU3+GvjVeNcAQBwkJU4N
	85Ew5wZgT7BN+71fIbm3vU0kKRBygSb2uUPMXFIimlsvA6ivGqhVjZHxL2nXzRid
	0AHwDDLNiABPwBbCdfBozg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JUFKm036958
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyge9sp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+Cp1QXrOps24zivk2n8/QuxXMz5Fn/jHXV+7hiUavL5vt+1fdU5CfCdcip+HBLDZFz01Nveka9wUt4ftjc1ulfVMjouEzuKhzOGDeU5hu4GhC713fXdM+nZ/FQiblKkptES5H41e+nFT+8wnWn9lpKKchfeX2u8QkjFRcyavFFtjGPM2LDZdveM3gyzrg2kRQSS12Y+70WS9uwyLyfAeD/92nEwN73O3oHRQ8Kx6JnSjIBdsVWs6sqIw51Exb7yG47FKSkDFRopZRv5DVwVFSfNvzxA5Y3gGc2JJmMEJRFt/bGSLdwE43w04F/YK/ZBglM7R3PXM2AcLrjOHQIQkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfVAJ1s4jlNXvn5O2XfmUxuls4+9rdmfFiV4N2Pn/fw=;
 b=ht4KFYmOpuf00GEJnfTj6vNzGtKlAV85LWAFuZs3MLYiE4hnkNTvjj/gpvVWlkbR5mKF0Om2dUxmvSHZ5lxWfWwqV5juTEjk31GclEI9PJpcq+fVnqUKNxBtgF0usqxDc+i2rl6fgdoTxlVfHsXx9Q++q9tpR8RNh5e5zlNAcitd76aXHZvkDZGy2eQXJNxKiEKJX3/Mhb4ySOf7og7SqJmZNzu8DDOnvR7P+MwD0b0tEZgKxCKlQHVnfc6koWhWn3/mRTM5f4tKuIzMX1OOIRscqkYBf5U3MCd9WJKgqhAdafHhQ9ryItYHKyJP9Vr+nxCnxtHoGdh2B8tDi5FFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfVAJ1s4jlNXvn5O2XfmUxuls4+9rdmfFiV4N2Pn/fw=;
 b=U/orUzpDckkOJaPBrHg43dqrDdLlnh+tqwv1XKXRi/apVX9g4f3ZUWX2aA0UMLtoexd6kxDy+fwS+fipdXjRzVrErvT5sdZSnPJpj4ikO3ejrYUyqsuCfTBHvHMaJ5YOPaYsRNQ7U1xrlaUqYd+d06c4PI2dC/azZsblyViWTMQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:00 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:00 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 09/22] xfs: validate recovered name buffers when recovering xattr items
Date: Fri,  6 Sep 2024 14:11:23 -0700
Message-Id: <20240906211136.70391-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: f2023ff1-500f-4685-cb57-08dcceb88c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iUlWhkOHYGxB11dml7cFlC3ZQkuL8EOX/TDDMqlJk8e9/OxehVp29Vn82XrL?=
 =?us-ascii?Q?fVjeP45tekJ7m8SeLdvKWLRI6inrSLSA+O9skr+skoMkQ0SBlLipjpUqSXSD?=
 =?us-ascii?Q?t8dHpmItkn0hBaHXUV12petjta010SVb3piRA/n18aC+vtgesZI69eWh/PH5?=
 =?us-ascii?Q?PVW2/ScU8UBzD4utjYZk/VGfqP8dPGAC0wS28/5LX1Li2mKbX2BdjzApxzia?=
 =?us-ascii?Q?aqqEIYdbFnM/4mp5N2LHJl3zzGi2zV72wTzMDSm7BC9aDFFGBElMpl5N/uzs?=
 =?us-ascii?Q?EQsURnl58GMmnx3sTgsUhba0nTyDl3ey54bvUoZCpFR3BUy897tr46VJzHXq?=
 =?us-ascii?Q?kKE0oOMUwEIO0g+rWPeHY87IC2xP/dSaMT9CPGOkX71uEuHOdQwRBYX9em5V?=
 =?us-ascii?Q?QGjimVe1J8UCgwuOwEi+wfKE5ouh2GYd4hebPJDSzBbmXnR7OF8S6Lm5h/1Z?=
 =?us-ascii?Q?3Zx3MleAmuVpu6h0kScsAu6Bh1+oun2UVFED4RWdCT1KkWC8uaB+ffDKt8Uv?=
 =?us-ascii?Q?aGV/EKPvDMAUuoJ8ZErqlYUkrfByxo6EL/YLk7+1qNwgrw1N5WedaRZDA3zP?=
 =?us-ascii?Q?ah0NYEKj/X8+dvDtypQxh0rHz4LTztQKNxtfeczw2XPVVZ+BmXQMawfrcKsj?=
 =?us-ascii?Q?pqIq4DjvGvARhgzliJIzeRRBqFbDpExzL4D1SH8Ib+zLi4FitO71dfjipz+U?=
 =?us-ascii?Q?pBpOMWEih0XFuNwMGYuw0ZboWUzZs5CmC6mjLo7NgSMvKI5d6Kit3KLH3epW?=
 =?us-ascii?Q?vkJdaSk786JjDzxTjf5T/FhOEouaQT62rtGBnw4ihFHLBaW4U6fxeZ8y2ubK?=
 =?us-ascii?Q?a6PESL0CjyqMhcMaRLb7KZ+pLhXZaBidANJLI+za/WFDinE4mgKXWWS9a4D+?=
 =?us-ascii?Q?qCV9GHMFozw/Vh7xPj1uY9R/CpSZTw02IIpIKLdzd0eAItyCFjXmSl8q5D+o?=
 =?us-ascii?Q?wtIBG3xtKRXdEt9c7Xz7yuulh9D6UcDxEQ1+sAum63b7gsKUQFXy3Gyv5RXX?=
 =?us-ascii?Q?zYS8qE+SnV32YeFn4mU3hXPKlFUi325dMOeBgyeSaBqYL86+tNToYVz8ZpuL?=
 =?us-ascii?Q?xfvijy8mjJY8eX6GOXTTdeh59DeY0T+0pFB3gD28O8eyVTBtbYNx47z7KPEf?=
 =?us-ascii?Q?iJvyFg7gzWwGBdoCXRP2UG3xZe8/5L1nYPzk3AAtajvcR1CQBg7Eub0ayimP?=
 =?us-ascii?Q?tJwgHhDgXyRENi3sMzLz/YdJYTafqnJ0TGEqzc5a/V4o3eBMNAYcBFLHg0Xl?=
 =?us-ascii?Q?J8sANEPDYS8XNmMtv1PMJnds6P78r4lfxpbKLwuMeCuUWJaBml0ZMRvu4iDX?=
 =?us-ascii?Q?9N34cGCVxHqj+TjmkODDiFPOqpMGxnMvlZb1dljM1qra0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dUJST9WKByOLoXFSIwajp7ZwDsS1VjxbfVU7KiB7xu3qowa5kIrMGprFpLU/?=
 =?us-ascii?Q?OXtvlu5TojySjh/KdjMBEfyuw+yMgSiwFL35of430+/PLcW3KOTldXSWA5lj?=
 =?us-ascii?Q?wNh3+QlJj9HuIwRkS0xtHdOH8AmHY4cqsKLM/wVIcYpmMKs1+dapxZQpGL+B?=
 =?us-ascii?Q?qimufUWndD92hDUYkfHOmconmyQsWCCQWmdIjaCUwcrunZMna6UE4ZslobwM?=
 =?us-ascii?Q?wva3MhIYs7MFGg2ozYgP+W64nuQ0NJBEzSvyuCP/l5dOOZnoa5l0m0tRGypH?=
 =?us-ascii?Q?mtf22dpEqLmWUP9hMVgQN+r2Qw7Y/hom6Mxcop6qUa1hpsT7BWY59LnBmJ9u?=
 =?us-ascii?Q?AC0KPA3AdcHioYNQxc7QRbIBZcCqe/6lcuF+lY7vfS/+E+O7hUW2iLzOjnkB?=
 =?us-ascii?Q?HCez/Cyy3dl95yDHLFd8n6bMrCia9gIc6j6bc1LZNxCvvZ19aDUjBS3bMvR8?=
 =?us-ascii?Q?kcQTb2+b0i44P4JloEJwLLVwM1d+gHRx1q1LQn3TYABjKQx0O9dq97LHh2bU?=
 =?us-ascii?Q?fv0snFACICNskBjg/80L5vkTR4SQibApK2zTVm2VS02g5dFbvumkdc6xmaOM?=
 =?us-ascii?Q?jSflYBdY6aqCWpqkJvDc6KLDn767Og0FMY2XEDewHungwfNkFyXFpkxuyAcb?=
 =?us-ascii?Q?f5QxuhfdEIkRIuPRGd6Z8ZRMplo2DZE+/IBa+xQhtbvz+eQZktIsPRMZi+fX?=
 =?us-ascii?Q?t7ziDojI7JSIKP5X6hJ9AMOPdwkjUa0imW8oqqZuA0CRgCYwIsxqp2kW/l5x?=
 =?us-ascii?Q?v3+MLmr9VP+Sq8tyBY/y6Rf2l1BBFCMlZj1klokomrDb5MDI062Blyx1iooa?=
 =?us-ascii?Q?H4Z7cR8ItLt7RBeQt5a6p/wtWu6sPyaCPMAJ6txihk+4y3AH3sQKgn/Chbcv?=
 =?us-ascii?Q?gshAn8xA+N2GfcP3+XlycWZMc7LjPTvKImJfSj8xnjLGWCg7kKpukp5fiXJa?=
 =?us-ascii?Q?y5/2U4ORh9SHHhr8T/cphHLz41ij+0KZF39PTXF2vrD1xtHeo4hfIf1q+mwS?=
 =?us-ascii?Q?6EkDadXFl9mWLaWiZo6TFEqrne5BKOgNuVx7ZUN3iOVnBdUqsXMGPmAzbZMP?=
 =?us-ascii?Q?uVAG8cYS8YWDnRiIrBn+jcNwTTdrjkXCVZ84BQ+1gFjnx7vgLEmkmQvYrriF?=
 =?us-ascii?Q?K19Oj1DrPOsqoEP8R99x/IsbyQmYyBpK0eSj7uM6NfVW2NFfL1GJad94mOLJ?=
 =?us-ascii?Q?yib2UlgEp3nTsYP9X1Wh3Te1aGLz7JLzvVlhubrVgn8ynSXFkJCxwiR37zvv?=
 =?us-ascii?Q?pGpnTCeTmS4Y41A1uF4WdjJA6vPhNC0Gh7bFkAvUlyB1ho8Wjw+4Zf62T0LL?=
 =?us-ascii?Q?cefbHg8jJVgB4ibUuLFc6Y0TaY5DazjpOdY1ufA9DlvMELwZuYwd+VJoPYE9?=
 =?us-ascii?Q?bVOaRBoXCSanFQCRiok33k8B+W7M6iwsYvDxIecIiKYiHnqTJsM+hxowUAM1?=
 =?us-ascii?Q?AtmmiRS9yl0wClYO2Do23c/Ufdo/vxNDBL4tYfuTJToK1aaLlMvpnrgvm2/J?=
 =?us-ascii?Q?rvCE2jGybMIhPRf4rykaYzTzz7O91fI1/GD7uYXtBKu6ffyGyvh1DHtp/Q9y?=
 =?us-ascii?Q?K/K74qK2/7JzaVhJpeEC/5VcYWkBLjRRMFFvVDmxq3mwnbuZ22PJUQryVJN2?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GYgm4MJvErsXdWoU46nARbPPS+hAAdIVBXdzP7mmuSNhCf0M/nmZEXXGUU088SDjTSIrGeUYdpTJk/j5fNloZXXaK87GfbU+i5MVV3IMzewBN8JcDOCeNZ7n99wCJxGMSvNJ3B9vb8ZyLy9tOLsKaAhO2V0sdqypySWf8CBstwKyksbngtrlnTD049ipKQdJa7TVEbHv8Ax0M6jbSgSSDnFcxp7Sd8thrmGjDvZzDG56WTZk2DAeVmqVS8d//MGezKV71hxramkmFaVD4Ay0oBOAYLFf39A5PR+5Qt2A10iHoLA5yWp8FO5+uvhamQKQBrSQ3As6GH7d2ZY0RCxxbhYyYopbernUWa1fs/x1D2CRkIwbYnnX+2PjTy+22/EnbqZw3S3wWyTzw764VAEAKgivLLnqqE01P2o8KWS95YmMGiWRjELcoRIaACK6bBaIQ7QJQkB5hI2pYqnpdZ9f7feVd06mSFivuTn/wVC9xn/YNgJyJg4cIsDDIDfs1SKwjyJYCbQ/HXFJ3vVxphGCYMydA45Y1x3cMgjXuemhZBE5v310gtcCtzwm2dt0YURvASG8qQNm/IqBPG6NQq2k7evfEsbDnMDwtTkCETH837E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2023ff1-500f-4685-cb57-08dcceb88c0b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:59.9934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsONzHPR4uVHW2F9k/k9ThpFgn1WwXIvklVdjTnE1MFpvPW2YCPLUxx6oN6tI/Zs1dcstIeXjtZiJTkVUycRWwTeRT6z+fMQC2y68rNHqbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: uzao9JgrP-T3Pz6D7lWWBqrX9piN_5_h
X-Proofpoint-ORIG-GUID: uzao9JgrP-T3Pz6D7lWWBqrX9piN_5_h

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1c7f09d210aba2f2bb206e2e8c97c9f11a3fd880 upstream.

Strengthen the xattri log item recovery code by checking that we
actually have the required name and newname buffers for whatever
operation we're replaying.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 58 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 064cb4fe5df4..141631b0d64c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -719,22 +719,20 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	unsigned int			op;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
@@ -763,31 +761,69 @@ xlog_recover_attri_commit_pass2(
 				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
+	/*
+	 * Make sure we got the correct number of buffers for the operation
+	 * that we just loaded.
+	 */
+	if (i != item->ri_total) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Regular remove operations operate only on names. */
+		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/*
+		 * Regular xattr set/remove/replace operations require a name
+		 * and do not take a newname.  Values are optional for set and
+		 * replace.
+		 */
+		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*
-- 
2.39.3

