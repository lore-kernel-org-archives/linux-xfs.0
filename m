Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2761012A177
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488086; cv=fail; b=XytvpAQOl6ycuzpgKzuaD6QVP8feRijdABjcppkUix5rSOpTD2OKWAzMFHT7wwJ8Jfmrot6LeZb6DvKxxt4LKEPOKBmXshe05DgWru46guDCjeqVDWSG08u+7VW4HeI2q4yP2jXpd02sQe+aF+caZhT2F2a+cX6P0eoRmHxFX84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488086; c=relaxed/simple;
	bh=Bl9vQLixQbGYjg3bheoU0hwC/N3PPhvV8OCQfWOoeR8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VBRBEKBZ5lWYD2eVDJznYrzWrN7BzNayP7yPVDX5jiI2o2imAw4wFpy838hIH5H9ZaU4k11ANm81R8AA9nAHlfkCaLgW+137UDepYfhRDfG66NyPOj3vTmBWHE53dv8KMoIQLu+roNbVDLb60sH3nC/j5Lh08YHmYMTVHBVEQig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aWOTUtWZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XSasdMzj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aWOTUtWZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XSasdMzj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BqCx004607
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kX9kk+0FdbMtL347JKg9cA354fRVX6xXm72n9Te/Ksw=; b=
	aWOTUtWZ2F/bC9pzpKAz/JPgPhHWe6IvGX8OzENJAWZUqQK4rOwniGXy6COrLY4n
	OFITGcOyUn+sh5XuZq9hDd+v2usUU2XKOBRxmq52NMiMAgJSkDyY2lJG5UAP1HXP
	kdPr6N79EwsGDnG17b60V2+XIY6O7HPsfjtOcjIn26NBqbQkDzR2ULTJrhcBVWFR
	u84DKDMHTyfyFxBBhGtN657kXpHhU0azif+lX+7Q05UbuLMoKow2zRUhDKathTdY
	e9jcEQqwGoOSDpMgN1pcMFuw99R9lxG1xFhxb1Y1W13tT5va1xm3sEeD4Ywz4XWa
	VVZfxr+i9ZZOHRUXbdFTzg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43jaj5db9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI0TkbN035729
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f97yhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZyChOL81GVeekvjcF7UrnGwUrb5f44botoZ++llLhmxTAVljSkwKX0aDhzIYqMoCIgFcKynRbLRY/Psg5lsc33oyW5cfjIcwlIt+djNwWB7ih1Tokbf0h+2h08ztbQNnDWGKfKrNAO0X/tSr8/0jpZLNRzorHhW7pzb+yikMoXHkb6lVHYR0xcndQJjOFtJg/9pKHToZgkfZevpoVDmmiq40GBjgkJbMzLZDlnjdmFEG+kDk5Hb8auGn7938v3Nli6xVdXJwetm9ji/mJ1iCj+nEDG/JFXIF/loArcuAMvtp/z9i+sSjr7Dm2LV1OIR2HoXlGvRaWMK7tVTCl7cSJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kX9kk+0FdbMtL347JKg9cA354fRVX6xXm72n9Te/Ksw=;
 b=VCONfY35SFSVKQrLlhnQATftVgeVSoxcqSsLtkbFaxF4biqaBbSR9JwXZqRMVSN7nYoeXKRoyzJqvxY0GYAHkWFxW5yXsCM0exZmfwBZf1nHh+b80uBm/rPrmySQFz0rqNGirEMBL992+e7K1yZWfxk6inpZSozR6SIsEH64t3Lj6YSd0KxEHgQDuOM1h5U/EMpBdAtulpRKXXowDChu172rDhCRGTK4CCilWBNMm/uDhYUl8wzfkG+/4SPXVDh/DjDlKXPOLHwA195jAg6I/3qQjxGHm/mjreU1PpiPUjsKQT6qCzeadM4UgVMD/Vm5B+jcgdTjYhaU2bwRSqlT7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kX9kk+0FdbMtL347JKg9cA354fRVX6xXm72n9Te/Ksw=;
 b=XSasdMzj+90bmWtWS2hbtlgMf4pExe8TSPe04DCi51Y/yOtpXilMOMr258ZXMLl2cp066N8wqImpbBQP8F1tmjZTNsnRKY7DrsZ2VA3h+79Pw+8lYv4NUCwUqDf0L/o6k/lUOLqORn/++vdcwksJE5aZinbD6ACp3qbs3RSla8E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:14:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:40 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 15/18] xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
Date: Tue, 17 Dec 2024 18:14:08 -0800
Message-Id: <20241218021411.42144-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0207.namprd05.prod.outlook.com
 (2603:10b6:a03:330::32) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: f78cc294-0c5f-462a-589f-08dd1f09bace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3ciYYAXnloYQvzZTHY5QrO8Jb4mFTtKsPos9yvPrwxvToJhwPWqn4hMITitK?=
 =?us-ascii?Q?ANvF9grcUaxvWalwNaX27MQolbvwX/TZmswgC8EPDCotqyEnu5h9PTKW+972?=
 =?us-ascii?Q?W8BURD6QL70t/+2+vO9pLJDoClEsoRQo6vJ098qo71Z5l+g/keqLrK0EK8yP?=
 =?us-ascii?Q?KJyOVwOWMfETjfm1+JfENPNzywj8YfvhpjLbpdTQ50BLcq5gaFt4ms3GUG6t?=
 =?us-ascii?Q?e+fjx/h8VPt4ogxpTnEmkiHDFELKUnKBmBml7RChT3kBShwQ6YaanBQVepv8?=
 =?us-ascii?Q?evBPSU8mpvsBkegZJJ+5PgDzYVS1PUHFxnPqAxxYdOrfiB2NXUZ0EGzq433c?=
 =?us-ascii?Q?ZA/4nbFHz4ZSRC0UelDq4b80GeTiOiDKTNJTMnUDpIgEfK86K/6gB40g/jYC?=
 =?us-ascii?Q?PIbfW1ZcwbTOc0CpZA9Wyu3f0bIGamdum6vWC518f6/uAZdAiJeLwT71K3d/?=
 =?us-ascii?Q?ZSG7b/+XqB+AZ1yA5qYLTYC1glUzxlJhC3/ymVp3aRBVVlivruDhkb4fLgLO?=
 =?us-ascii?Q?OLp8qzj7PcJTu/YZ6M7jCYTDf8sWQ6rzZ97aTEFS1A+Rq2MgsO/OP4Fl7B2d?=
 =?us-ascii?Q?XJlanN09UYyoFFXKUAeV3tuWgMM/AispDtmOpEBYFEsXbqXYo1yMxiBNkuF+?=
 =?us-ascii?Q?6VemoTKCbVIEo0qn9bifrRANNDLLTbs83pIk1q7c2LVxsOjCE8y1DHBZZPDB?=
 =?us-ascii?Q?I2E5TrPO9vsWFvgsIxvtx6d5VuTxrkeqvGz8KvxlxoysAutI1Qj0YLZJJCJ9?=
 =?us-ascii?Q?KbSdFPswJpT/yW8Vm8/n+FyCtdEyGoK7sXuKH7DJH6Rb2EN99tu1X5nMXgTG?=
 =?us-ascii?Q?adTju1uIm327qBTz8iWH/N2VGV6pXTJYOzikqOLnUlTkpq08cpgIb/S1iWHB?=
 =?us-ascii?Q?4HHX+dBa2Dr0Ja7uQZrGDlcJL9beHawJWIGS9IKAFKladX0fqCjHsW4TM2dJ?=
 =?us-ascii?Q?zUv2uttR0xjS+kIuBauFcxwS7NiruXOVZKDQs2Bsp3jEI2xVI9HLWNsn4Aq4?=
 =?us-ascii?Q?rSaSU2KEFaqH2qkltG3jTa0F4MZ2ivdAMSAc/JGXTS+MKxFjL1VNwgSwQIFc?=
 =?us-ascii?Q?5S3y2LnNlA4hcTPFMeJVCUFAdXitPgHwQR2xW/woDcWJZpo2UQ3VAZ7U5dX+?=
 =?us-ascii?Q?UuVKi7qAqvtrRlm7Scba7gd5MyRLZI7QlpCbdS204W3UfN4xlK3CVfqEOpoo?=
 =?us-ascii?Q?IQGOJiIhuCvTFkmFbb/VIV1OHNphaJ8W246MsKbxtlb7AmPpoj3dP2MM/EAM?=
 =?us-ascii?Q?IBLzqNhpDh9pkdLUf+ZNXoYgQ1Y5t2wdIWpIu5e4lm8uSZb2OhsUT0ecUUfx?=
 =?us-ascii?Q?OCqUNtvXsnalz6MnBIW8ZN5ut0iJShQ1g3kqruDjYZjYK8Id0MJ1So8IoiZ1?=
 =?us-ascii?Q?IJmKSu+VCBi5NUQpMXB91fK98/He?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/d/fH2D5PqSQQiRgabZgGM1GJ9NwUF9cr+KAX/PuAh2UGeM+BwFYf5jFIXjU?=
 =?us-ascii?Q?cgS4RZ4EofrW/m2asrhw67KIVZFxIBxqjrvNUGIJcOCKVJC8GU0jQ/3yCOYa?=
 =?us-ascii?Q?AfZmjcIpDL85EGc5fzMmv9qFE0NF5Ja6V00fKS11/2vWI3OQe6Z+I+wnusBm?=
 =?us-ascii?Q?EgxjIDwUCvIfUEmStt+CUzaNlcYUOmsSBf6qhEp9Y3Zv5XT3CA9yWekj5dtE?=
 =?us-ascii?Q?h4hglgLlH18Kwzjz9l4aMe9ZnbSgSQKOEQmVc2K0tyGquZkr7Fy5v3wseIP1?=
 =?us-ascii?Q?Jw4s2Gr9E6sj51nYRnOJRLw3dmk2pBONtuAYU82TIfjp5KHZVcPDSbYXCCsf?=
 =?us-ascii?Q?VgJITkjhPAkrQiLMAqfXTr7YJVq7GAiv844FaXB1IPoA2TpX4Ell2COnIUbB?=
 =?us-ascii?Q?fJUa6vihdLejVvRhIbnCIm+YXOy/icGpRbxu5/lLzkBRqAJlKTBuQWS7Boe9?=
 =?us-ascii?Q?8ytYkHQpihrYmTAEwcEpMMCqP/a+wQBNQFm1tH09tmEKqoINRi/gRa+qdm3x?=
 =?us-ascii?Q?O1wFvU73ITVo+wzbE1VODqad+h/71mYtqK+iBay6FRsWx7/ktOZ+9KbPmQpR?=
 =?us-ascii?Q?aU7b+vVSxCMEpB+zIm8jcQh6XuKCbHZKzQ1PeJnp3IWuogq5+3NIsXNmvTkn?=
 =?us-ascii?Q?tObvC2JJko03Mi7sZb9YXXm8E7JdO8X0s0TfTa6KcimryfesAC0SQIOrTbWq?=
 =?us-ascii?Q?g3YfK+r/pkruVNqi36UrDieZQkjbu/F8ExeTBnPMe8FrYrecKkHxyzWm2Pji?=
 =?us-ascii?Q?jU1o35RIk2hG2yZNUEka1lB8aOd5q1MvuPQ/fyiMcKQD8VuQCtdkCZZVOpoa?=
 =?us-ascii?Q?DBfQ99U+BOBgbHSdx/7UKd2PqVmqURRh20qUTYQunVXb73KgrZgjk0O3p4wl?=
 =?us-ascii?Q?ARfZ+o3wC+FupReiWWl/vq1r6m/mu9C4oxJESAv5xaOzcN3ICTLFcu15bwDo?=
 =?us-ascii?Q?csWRPwFO9M30K4sDuClEfW3OoTqDAO992POZgxFvzbz/BN7v8bjzJPzzdBzL?=
 =?us-ascii?Q?WBbTA6ZAm03lkuXzqBbD1XBVjdI+nzLax8T8IIHqSxvmRVtX8JYboORfioVI?=
 =?us-ascii?Q?I3j3bRL/U967oiYQwHJV7c3JOZQgx+O6qdK++Yt/soJEB2cnKeQcWPfryYre?=
 =?us-ascii?Q?rCIwoz2Si2c89VZ/TlrUWjeKaiNQypIRMJrYg18m2T0oQUev76AvtvvxmzlY?=
 =?us-ascii?Q?aeWTnRbOev530JuKOgN6A7xyKv03xl0QB3SfLUyKSPpaMlK/bmU0xVZVf0jL?=
 =?us-ascii?Q?2+lt2F1LpDvY4WhtStu1IIyz81fVg+t+rwcGglBXv73m6nnbLY/8J4ko+uYL?=
 =?us-ascii?Q?0hw5jFilgVbKALcDBSODec0bRn9+ovylySG6nslQ6MssdrlYXppzQZ26TNBD?=
 =?us-ascii?Q?tKyjHnjeKBDR4Rbno5BeIANEE4jOf277eXP289dAtEv9FbsKQkLq48dHhc5i?=
 =?us-ascii?Q?CBZGQT2lPpJkt81NT9yBVsTfg8+9dD8xUBsYz65QBpamYQrqltM5oCqyHIYK?=
 =?us-ascii?Q?9x2+CTVG0bWUeFQ9vTkClfpHTdTMX99F3ZLCp1+TuaEn34NVkxdVh5aNmFxu?=
 =?us-ascii?Q?F57oTE8xM08QfNFymcSXBBdFK9CE+chGYREq9/gwaFMHlEEWP6LSdH6hvG4J?=
 =?us-ascii?Q?u0YJ2bVFNRKFUfR5WsNxa742j1DLMC8JP+j7xJvEj5PB5TEw1/+jGKrdHjH9?=
 =?us-ascii?Q?QTP0pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Co3/BxK4Hmls+P0mgGKMxgz4Ock2jrxA02t0/P4f4ZxHKJcNZNGuj00nEC7GdLFnzQAium8axiN1IOfHnPIFAzjPNimYKPQ7gUIuQ/TmUrvggWuk7nsISR9zGTrJTyqJlknZ+GJ+bS6z4HQ/BsqTdxXoG5Q3CQ7kQCNqR/FlzEjqttqpc+LBfmRGDLL7CLC71jgPuOsNre4VJB+FON5vsEbfZODmRDz6i6BKCd9yDj9/6BTgHOWs7RqhvIf441o2m/LNMxJtT1eLGkFEo+wTVU6JEgNzxRByWE/epahcf+7qIg0Pvu/Fv3PCFGGrngs3xwYDspfS5w89PRe0RyYGetNiMtIpMeYp1kVuJp4/SvnEPiZwKSfyuno8GMbitt7ghz5LmcCxVVj6rPF9hGLv6SXzcQU7EXpDJevdE+cQ85HVvNC/QrvjGgAQvxpytSZsxMvXSUVSaj2l5jYoGh3OTI6f/Se0idJM/Q7/JDmNzRc2WRXgHXxzl2tpGLjPbViaDqbWzXl8Td9ztrYBwUQUCO/LiNnjCrlkuUU1hM7Ql4W72fz+rX0XuYghmwJVdohXtAa8UkzLtdRkcsCqh029TeOr95ShxW0DfbIVg7xIxVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78cc294-0c5f-462a-589f-08dd1f09bace
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:40.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bk5bSULPU4F40QwF7i4GBCMz+9de6sNWwsCxQi6NyfvaCY7+QlDrzb4alQ57AsQgD5aSU+g0iT8DMGrfiaB+3JKL+wXwKUGPUU1pmV1lul4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: IA6Ml7m6P9lB3AsL5GPFqB9GvyN9Ycfn
X-Proofpoint-ORIG-GUID: IA6Ml7m6P9lB3AsL5GPFqB9GvyN9Ycfn

From: "Darrick J. Wong" <djwong@kernel.org>

commit 6b35cc8d9239569700cc7cc737c8ed40b8b9cfdb upstream.

Use XFS_BUF_DADDR_NULL (instead of a magic sentinel value) to mean "this
field is null" like the rest of xfs.

Cc: wozizhi@huawei.com
Fixes: e89c041338ed6 ("xfs: implement the GETFSMAP ioctl")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 85953dbd4283..7754d51e1c27 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -252,7 +252,7 @@ xfs_getfsmap_rec_before_start(
 	const struct xfs_rmap_irec	*rec,
 	xfs_daddr_t			rec_daddr)
 {
-	if (info->low_daddr != -1ULL)
+	if (info->low_daddr != XFS_BUF_DADDR_NULL)
 		return rec_daddr < info->low_daddr;
 	if (info->low.rm_blockcount)
 		return xfs_rmap_compare(rec, &info->low) < 0;
@@ -986,7 +986,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
-		info.low_daddr = -1ULL;
+		info.low_daddr = XFS_BUF_DADDR_NULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
-- 
2.39.3

