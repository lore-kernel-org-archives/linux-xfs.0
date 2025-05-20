Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB8254B1B;
	Tue, 20 May 2025 01:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747704867; cv=fail; b=DVcMU16i/qmvNTQL4K6GmiPraDMYnbEeGonrJwmUvER0yOlB0O2pt2AclhPtdVp0GOYjNdvXHiudTXT9tBk8mtoS8oV2jeoGfcPefAkKDgdZmtnH+UszaFS4Vds4PTQ3kaLFw67l0vy4tmQIpM6PFp4ZoM4R3le7qjCF5P8+cuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747704867; c=relaxed/simple;
	bh=AcMdqMAfsLxhQdNDKcxLnuUAYYbTkhUDlGt8xw4t+6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CZ+PDgyNMMWFZT0ttI+QBzVmox3VVfesCpBYhF3zaHJUHOwm5UUEZvdQmlCeZG6CF+QRdUQLXIOom9RdWYyJjRG+nnyUb9WydG9GGMJkIYCFWVv3AQiOBQY2xQXMe8JeQsVpNm+S+mz7FOg0XM1hFLEL81wfV5XyEZ6/Ndj1WCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FM1GMGHR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ICYw8u25; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FM1GMGHR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ICYw8u25"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K1NZKg002010;
	Tue, 20 May 2025 01:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iVmysyIL4hqhsvkzZpKSKkTfQ8j8E0/wZLskEA5TrP8=; b=
	FM1GMGHRzMArrKaQ8u5MmttircISzlBMF9RPbKPc9iZI3QLqyp3Es/QDjaO9cV9Q
	2h9y3aSmIgEOsh5E6Ehpz2Hp/KQhKFRfjDHXfjICKnKkTvm1Ck458TeiPyVP0EWR
	hnRwrvHhNg7/1I5I3hb/bfBIAb8xDxm1V9ayJxf/BNX7sqjpbytg6X0GiYLYFkHO
	ngHWrXM3Ml6JmHoQx/f/2hl0c3sexWgwZ+Oxvs4tSsQ5AvcbY27Lic7qxwxI9CS8
	QECGo1smaI7ulShJynZ2elJ+D10OLH/2z9naeKLSsysF/c8Tf9UrSp3/hpREckSv
	ACZz4N7y3TlNpjoUaZ2ayQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rdtj852j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNYvEC000806;
	Tue, 20 May 2025 01:34:19 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010018.outbound.protection.outlook.com [40.93.12.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw7d6xq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/HqatHwHn4v3Toro1UULUqOj9gqPAU/HM/i7BmWwG7hP8zEzG2FncdauPS4DHbTZgeRcKGpVJUubh1yyR5CDf+cvmdDfQEUa0uoiF7ZWMzZzmOCv2DnEsR9JvdBgK2Ly0efYFAHG5ILf3cjhF0ZNCwDOyNlx+69u0XiEOmc3FloC487IymkQiyifmm42lmFn9ZweAF+JDVEOVDNflO5ZS1UCLRtNTBwZmezBYEZBnSipAAcGDt0ym4Nd3BgV7K0QNH21emaO8yey1HmUXGrpLt3YQCXPyozwpuuGwhztNX95A9ZH8TWVw7deg1PoQWCE2QgcPz3MPC+OkmbyHFcYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVmysyIL4hqhsvkzZpKSKkTfQ8j8E0/wZLskEA5TrP8=;
 b=qjNu2u456+NBR0Izni0kwEP14MX+sPg5tmIVgf/TtIgAi0kSWqyhs6cuV78CoYk4G7fum/X8A+V/5kYtectjhn41vW5Jdg5OZG2CeYvmX17PyyjUOIWyYOKRFCMAATiUhH6ZnLqQFqvtR4Q+m4ygX8klhrBwRTurAYIzFpFcllQ/cOVNvwqCW6dmyQSnrtJXH+HaBwEvXEgOUxjFEdA43cyPpV0D1ga9M6PSyG/22fhEacS2w45tSCvqRlVyGgJs51PVMjWdrhWEw1nz3MMIQxbP7bcIbBi1tdwpsF8nz3r4d4/xCRe2Le9uqWMP9LhqfIER3WqwnZxgW/0qIe46vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVmysyIL4hqhsvkzZpKSKkTfQ8j8E0/wZLskEA5TrP8=;
 b=ICYw8u250nrU4OfYN7KYWVPy9YADYFY1dGUmk3rQuzMr9I+enIfVhPbR+U7Vw3PVcEeZiRBCSbmyKDDDDd58Dy0q7WuSbZ2hK4RliJPO8Cvvv5vJm50j2tIJ3vIlxbUBD9R7+fFmG+938EkW7aUD/opcVMygU8b0akvccKp5OfQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Tue, 20 May
 2025 01:34:14 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 01:34:14 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: [PATCH v2 6/6] generic: various atomic write tests with scsi_debug
Date: Mon, 19 May 2025 18:34:00 -0700
Message-Id: <20250520013400.36830-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250520013400.36830-1-catherine.hoang@oracle.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 00ed9c3a-7e46-4c42-5b33-08dd973e6d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+uLLYrR+a1jWrMhvk5cP5MuxG/UNZ2rfGVrvDyOCRUVe+UNvTKMIwKILTGWG?=
 =?us-ascii?Q?5ByUDs4wq3yga27JNq8BhwM5pZVDTDXL5VdhFmZL0xrTv3AKeXaxROkjwpUo?=
 =?us-ascii?Q?2cihFfWyz7nolsYeWAAAtI6px1mYMm2oFEKfTHMOTR6K2WwlM1Sxq46OQ0QM?=
 =?us-ascii?Q?m+VVSWhH3bJzidpSb042JNegp0Y6ZCnu2oynqFeDENeU4cM8DMSzrNUX4w4f?=
 =?us-ascii?Q?GD25vSrhAIb37b9lyq4lLWfMsNySzctmzrBzu0/ceqboTbRQZhmyN/R5EC3a?=
 =?us-ascii?Q?OlOTQ5s2HV/qmUp12/0R11si+z75HGrxUMF+PJ+IwSzQnnD67fJQVnaOw36X?=
 =?us-ascii?Q?7Q6GJRgy0Ivylr2IDreEr38oTFf4Zvp5BQGRAh1v9SFQXi5kZ66tlnexRAa2?=
 =?us-ascii?Q?tDohrUC6SWf9fAnW6y49GD71ym1nEUTDeihB8vEk6c40nmLzEDILWIKmRg0b?=
 =?us-ascii?Q?FwY8ilkX6z+D4+1oEMjBtAgowz+5loDHcda3GQyytfD+7JQUa822CzO8S4/D?=
 =?us-ascii?Q?bQnOqWbjS2KYhDhjUSpMSVYpOWsbz+jcTcx2CLVBIOs/pImL9JI9UVMPoCJp?=
 =?us-ascii?Q?6e92fvKQJGute6sdrvx8zNsnVGyWXjYwgCpLxauGGIzXW5z1L+sLFFltlRtE?=
 =?us-ascii?Q?SdHFdJRwfOdN5394oqmfaqsKyUHPTK/iV1vnNGcI/oZYhtgLVsnpakvM4k1+?=
 =?us-ascii?Q?war7e081kWCcqoLAzeFQasVBogDL5DqsPWfr1qSasOeyOe3BMgrBtaxqnc3F?=
 =?us-ascii?Q?YSHW72jcRPKhdm/2F2Mh14kW7pygiA+iZA9PnSlPXcfKu9jlOUm//pKLKjhw?=
 =?us-ascii?Q?f3ZMToNIN1zrDMtCtBzNrATKxswE5f6HxeUpSE8v2EMzvn5PQGExiWt8x8xr?=
 =?us-ascii?Q?I53FZy1TSUbd/UOA7VJSMw1uklL4GyoXjhGaxgNPPOD0jZuPfiKU42k84rXH?=
 =?us-ascii?Q?1qzw3X3yIclECfXNOs66FgvK1Mr3flAzzhwuSNQh97gtIP+yoQx1aPCz54PP?=
 =?us-ascii?Q?GbnrQjoometn0dRgHsvjap0qCixvQxdbpgUUTdIYnwlid+JYULvkbSUI9LYE?=
 =?us-ascii?Q?SW1lbgdBOL2Ji+esh0USO0LARAJ2Qrj3n/mIScv0OzhXu3BKxc3SE5gxlLvW?=
 =?us-ascii?Q?S1EK8cu3AWQ3Cw3ULw68u8GOOsaZ4fIz4N2SmfHVlyOZxbfjOaoKHevihErE?=
 =?us-ascii?Q?53AQ79ciN7GKKYU01r+PBMTSOKEe1p73KwzWSgabzx0/Y2b5YwvwyyBC+Lxa?=
 =?us-ascii?Q?BIP+CxweEaPejV6xyHOng/fYJ+6zL2Dsk5HPfzahWo4xMunTJs0/2BrkVp+W?=
 =?us-ascii?Q?xwbSLUtj3yUk/BdHuF8/abzZ2ZIdaQZqa7SotgstqyQuFOjqtwBnLNH+cwp2?=
 =?us-ascii?Q?s2a5vL4m53D6FWiDZqUIDjpzsDixSEoNPU9C1w4tyoQGOnAg2cYXcECUUaq9?=
 =?us-ascii?Q?9d/A9tLLYrQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+aSp8vTdIA1rhi6qikPLIUD17sYgjntv5iQ3hNpkSY9xdwVzNS+kzfvgpC6y?=
 =?us-ascii?Q?qYimyEVA6ntch1l5xVe9IJW6t/NFrvIiHRbynvFq6fnXi065IGP6M9k/zaK9?=
 =?us-ascii?Q?ZTYqCx5eBj9h+zVPTu+gcix4dSNvg6TQn1xxUdPIE6GSAzXCvatQ7jVIw5zx?=
 =?us-ascii?Q?yhx/4yNMcI1UkefyqzESvajdkMcIIKIQfO3R3uC2Nd9Y2O3bgnuz16ctUjNn?=
 =?us-ascii?Q?G6vtDjGZLnm1Hk5gzGKvAUf56GgiO7WCqPdfzmqaw2CB7LpSUYLMXyp4Mkci?=
 =?us-ascii?Q?hXfWp3L5GBjHwNSHKm5lAbKQOqRtC6wBUrUPCWhBIucon69ayuXvnxUD1/PP?=
 =?us-ascii?Q?barJTDN1hiodmhUiAr03PHacyJzdnkXUN8WTM4kojitgX5AnYWyFWMbeU8gb?=
 =?us-ascii?Q?e2z9LCXuNuxcHtsGHI9kXZ7+Snj2d4uif75PcV8AAvHMQRfT/00rdjeqDKpN?=
 =?us-ascii?Q?Ii76LM28bfqKfYQsGiMIipkNaR0SCZham6HOr6I+c6EE1GP/Gk5Z+ukmQIXj?=
 =?us-ascii?Q?DK5NNeie5OiPVEdLyBD/7hiA31w6pmGYIUTaW2xcpRYKGZv8Yhzs767VUiJF?=
 =?us-ascii?Q?OzJ2FlczDIjSnsrU1XuPUg6SR8tS8jJ108UIDDZR44e1mgGAoyZ9Qh0RhHw8?=
 =?us-ascii?Q?uyxSKxcE1T9BKVM2Ra/7UPlRcVxyAcyspdkgB5wEYlShJPllA8++QqDvqlkk?=
 =?us-ascii?Q?BfR7PKtPYuOtvHGJWXI5x6Ra/+U4tiiYuLCUo1VGKa/l9wFoV+zv6QmAIW5b?=
 =?us-ascii?Q?uBjdpBQz/qusHs4IRXN9c53VyWfdQ9Otbcjb5j9zlBgifUEAr7YoNyk1t/F2?=
 =?us-ascii?Q?Fynq5bsnOa/9i9yFcD6q2JhXjaFY/hZEUYXdrE9v32h+2TCL3mxgsYMhNAYo?=
 =?us-ascii?Q?07JYcGNBdQAvTSQiNgfcwlmbM4Cr/T/1vc2UKoiGIJhgkL3AcYmDaS3VWHrt?=
 =?us-ascii?Q?USkSwiAZMFpMw4lZFhzq1rxZyUn6yobZgbxQ4IJ3BukivxGOZ4iaQB52o+2+?=
 =?us-ascii?Q?t0ITa3dvzkbaeO3VEJGop+ZBVuvoL2adApx7hDTjopA7EThlgI1wfJk8U003?=
 =?us-ascii?Q?IFpIG9OXXhreFhBZ2iiMRU8tSoCc+F0uAykLrsCIIA2KPZX7J8jYYGPk+QES?=
 =?us-ascii?Q?HQjsj2dZDqsbyl0CwqqXtIl/4c6AEYPXfu0pl5p8/GvJZfoubtWRhYYxTL7U?=
 =?us-ascii?Q?Vbl0rLfM5fJNyIiyjavsgsMGiHUsv2G3w3xy4LNrcgN52pOQhgyq+a97Oez7?=
 =?us-ascii?Q?R6HffQe+wBemK1XHule+AlfOhxSuRpPMbsNILyeq0tZmXRvL2glta5WzishA?=
 =?us-ascii?Q?bP8ppp2Ngb2unQbZyS8YzRAOrHZf7Bi8Ie1ajnjV37XblgwACcxuHFXO1UuD?=
 =?us-ascii?Q?e+UGNwpII6la2TqJzf8BOiAd5s2NC+ZL0EYf4TK1Jmm6UmcbyAVukvRvfbmv?=
 =?us-ascii?Q?iIAztKhder+k6A0vnCw8UlNXf+iCuQunY11hWQh9zH4UkgyrBc5UNlDGuVMt?=
 =?us-ascii?Q?NHVlCWb7n3cAd2zKIu1oLp5RZoroHpbX2tsKNw0bxg3XoXZfNnvjAEwc+ra/?=
 =?us-ascii?Q?0i3DR4hEUmnFkL70PCdl0eRjxLZseznEcUd647mdkPLlzOO5QK05lmB9YEWy?=
 =?us-ascii?Q?v9a7kwz724WmzJvYB1Ebt/PRiQeWWdk2vlQEDu7U4LKD9mUzoMj6DiX1en0v?=
 =?us-ascii?Q?7QH+Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xJq0dd11ptCLR4AGG0IVhnx8qrSio32oBRDKAgeTzvihHMiBmKRgtg2hjzYNMRF6IxKq0oOKYC2wPTLS9Qyatn90rim9QTpDOfbPoSDD8PiYOp3k8RmQWJWnADabYMG7p0M41mv6NKUR+P+SHLrQ8N5P3dUEjRmT4Zx5yGy4wb9IMOnOZzIlq8VwOpFmVfqosBMYGxjZkTa6XkpY6YpXoXg8+NT6tEu0OQo2lbhbJZWZYnffvk2aCYOXeywMesmQbgusUIqE/RB9bGcoCAM2MOjU944HZJ9GnPatLnq7blmHCTbMGPScP+WLpte03ZIGeqbV0ughP7xTNPt/ZuqpEd0znf370GnE8JeLS26JYJx+jrl3fO3rSguV1cNUxVp3h9/vJRVxtcoCqsfO9eOFlmfIhEJ7xYscqeWt71hctW372ckdQICXscIhOEmLqqyy36eGnt/7CiIcHRRWaN26BiwVgPRoHCSH72a646FbR95ATDC9VzhgIKz2MWACTnjm2YhYBEaradG8KkSWfZJRtzgRntS/P992HPDLugfCXLCJl4OhRaRBa3SBqk3BO3PlogOh14BFieRL4s70TNbPoSbaCiMdDa3ceYtRTf6yTgc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ed9c3a-7e46-4c42-5b33-08dd973e6d9a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 01:34:14.1336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPjii1BPFD4VdAaexEBXm9TjuG7RZhE684DSvO+aGkkLLJUs0x+kpqH5obN7wNmb42NJefcrwIORNsL+w/dID3NCC4q76jgvv73CLodHRDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505200012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxMSBTYWx0ZWRfX6t/Fnorr3TVD 31B9RgxA4+2bVNAYobwQNgce96i8ncunaPUcbWSI9j+WOv3konSagTQifknfLgOXcw53drYtRLt pxyvjUDuJYzZ2bBFWhH32evaYOAq7xaGGCBmiRF3AMmaVjs3DODsUjcLWinUncy5KhDQDmBPOGe
 zLDBdiireDue8JUmg5inFDi5CvcAeNxarA77SbUOzdfsZA20sDi7PVmEc9y80JnuZQkH5fLBA4y 7OeXHZybsJCpMMV7y0ckUYsBoFmptPQcAlwEsf9+AB7a9q3O+KBjq2yo/lomOsKTMYzEryb9qJB hu1FhG/zEyjH3Bd4hX2yX77Sg2hSGDowHDrEuIETu1Tjigv4klbtttAGMZo/cL57Wt6NHRIuivg
 pzt7NSAZYQtO/iPdQ2ildiW6GwKNZPLVxJyofYBBHJv7NATgUhajeAYZDbJmz5U+kvls+pTT
X-Proofpoint-ORIG-GUID: X6IfPJ1Jha_zEBhTWatxAQQhtU06vIL3
X-Authority-Analysis: v=2.4 cv=D+VHKuRj c=1 sm=1 tr=0 ts=682bdc1c b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=swJeIeA6nIzyhUFMZkAA:9 cc=ntf awl=host:14694
X-Proofpoint-GUID: X6IfPJ1Jha_zEBhTWatxAQQhtU06vIL3

From: "Darrick J. Wong" <djwong@kernel.org>

Simple tests of various atomic write requests and a (simulated) hardware
device.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites    |  10 +++
 tests/generic/1222     |  86 +++++++++++++++++++++++++
 tests/generic/1222.out |  10 +++
 tests/generic/1223     |  66 +++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     | 140 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1224.out |  17 +++++
 tests/xfs/1216         |  67 ++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  70 +++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  59 +++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 13 files changed, 561 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100644 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100644 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

diff --git a/common/atomicwrites b/common/atomicwrites
index 391bb6f6..c75c3d39 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -115,3 +115,13 @@ _test_atomic_file_writes()
     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
         echo "atomic write requires offset to be aligned to bsize"
 }
+
+_simple_atomic_write() {
+	local pos=$1
+	local count=$2
+	local file=$3
+	local directio=$4
+
+	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
+	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
+}
diff --git a/tests/generic/1222 b/tests/generic/1222
new file mode 100755
index 00000000..9d02bd70
--- /dev/null
+++ b/tests/generic/1222
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1222
+#
+# Validate multi-fsblock atomic write support with simulated hardware support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/scsi_debug
+. ./common/atomicwrites
+
+_cleanup()
+{
+	_scratch_unmount &>/dev/null
+	_put_scsi_debug_dev &>/dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+
+_require_scsi_debug
+_require_scratch_nocheck
+# Format something so that ./check doesn't freak out
+_scratch_mkfs >> $seqres.full
+
+# 512b logical/physical sectors, 512M size, atomic writes enabled
+dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
+test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
+
+export SCRATCH_DEV=$dev
+unset USE_EXTERNAL
+
+_require_scratch_write_atomic
+_require_atomic_write_test_commands
+
+echo "scsi_debug atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+echo "all should work"
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+_simple_atomic_write $sector_size $min_awu $testfile -d
+
+_scratch_unmount
+_put_scsi_debug_dev
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1222.out b/tests/generic/1222.out
new file mode 100644
index 00000000..158b52fa
--- /dev/null
+++ b/tests/generic/1222.out
@@ -0,0 +1,10 @@
+QA output created by 1222
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+all should work
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1223 b/tests/generic/1223
new file mode 100755
index 00000000..8a77386e
--- /dev/null
+++ b/tests/generic/1223
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1223
+#
+# Validate multi-fsblock atomic write support with or without hw support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_scratch
+_require_atomic_write_test_commands
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+if [ $sector_size -lt $min_awu ]; then
+	_simple_atomic_write $sector_size $min_awu $testfile -d
+else
+	# not supported, so fake the output
+	echo "pwrite: Invalid argument"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1223.out b/tests/generic/1223.out
new file mode 100644
index 00000000..edf5bd71
--- /dev/null
+++ b/tests/generic/1223.out
@@ -0,0 +1,9 @@
+QA output created by 1223
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1224 b/tests/generic/1224
new file mode 100644
index 00000000..fb178be4
--- /dev/null
+++ b/tests/generic/1224
@@ -0,0 +1,140 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1224
+#
+# test large atomic writes with mixed mappings
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/filter
+. ./common/reflink
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_xfs_io_command pwrite -A
+_require_cp_reflink
+
+_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
+_scratch_mount
+
+file1=$SCRATCH_MNT/file1
+file2=$SCRATCH_MNT/file2
+file3=$SCRATCH_MNT/file3
+
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
+
+min_awu=$(_get_atomic_write_unit_min $file1)
+test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# reflink tests (files with shared extents)
+
+# atomic write shared data and unshared+shared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic write shared data and shared+unshared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic overwrite unshared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic write shared+unshared+shared data
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# atomic write interweaved hole+unwritten+written+reflinked
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# non-reflink tests
+
+# atomic write hole+mapped+hole
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write adjacent mapped+hole and hole+mapped
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write mapped+hole+mapped
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write at EOF
+dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write preallocated region
+fallocate -l 10M $file1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write max size
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+aw_max=$(_get_atomic_write_unit_max $file1)
+cp $file1 $file1.chk
+$XFS_IO_PROG -dc "pwrite -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
+cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
+#md5sum $file1 | _filter_scratch
+
+# atomic write max size on fragmented fs
+avail=`_get_available_space $SCRATCH_MNT`
+filesizemb=$((avail / 1024 / 1024 - 1))
+fragmentedfile=$SCRATCH_MNT/fragmentedfile
+$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
+$here/src/punch-alternating $fragmentedfile
+touch $file3
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
+md5sum $file3 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1224.out b/tests/generic/1224.out
new file mode 100644
index 00000000..1c788420
--- /dev/null
+++ b/tests/generic/1224.out
@@ -0,0 +1,17 @@
+QA output created by 1224
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
+93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
+27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
+27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
diff --git a/tests/xfs/1216 b/tests/xfs/1216
new file mode 100755
index 00000000..04aa77fe
--- /dev/null
+++ b/tests/xfs/1216
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1216
+#
+# Validate multi-fsblock realtime file atomic write support with or without hw
+# support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_realtime
+_require_scratch
+_require_atomic_write_test_commands
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_RTDEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+if [ $sector_size -lt $min_awu ]; then
+	_simple_atomic_write $sector_size $min_awu $testfile -d
+else
+	# not supported, so fake the output
+	echo "pwrite: Invalid argument"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1216.out b/tests/xfs/1216.out
new file mode 100644
index 00000000..51546082
--- /dev/null
+++ b/tests/xfs/1216.out
@@ -0,0 +1,9 @@
+QA output created by 1216
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/xfs/1217 b/tests/xfs/1217
new file mode 100755
index 00000000..0816d05f
--- /dev/null
+++ b/tests/xfs/1217
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1217
+#
+# Check that software atomic writes can complete an operation after a crash.
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/inject
+. ./common/filter
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_xfs_io_error_injection "free_extent"
+_require_test_program "punch-alternating"
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# Create a fragmented file to force a software fallback
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile.check >> $seqres.full
+$here/src/punch-alternating $testfile
+$here/src/punch-alternating $testfile.check
+$XFS_IO_PROG -c "pwrite -S 0xcd 0 $max_awu" $testfile.check >> $seqres.full
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT
+
+# inject an error to force crash recovery on the second block
+_scratch_inject_error "free_extent"
+_simple_atomic_write 0 $max_awu $testfile -d >> $seqres.full
+
+# make sure we're shut down
+touch $SCRATCH_MNT/barf 2>&1 | _filter_scratch
+
+# check that recovery worked
+_scratch_cycle_mount
+
+test -e $SCRATCH_MNT/barf && \
+	echo "saw $SCRATCH_MNT/barf that should not exist"
+
+if ! cmp -s $testfile $testfile.check; then
+	echo "crash recovery did not work"
+	md5sum $testfile
+	md5sum $testfile.check
+
+	od -tx1 -Ad -c $testfile >> $seqres.full
+	od -tx1 -Ad -c $testfile.check >> $seqres.full
+fi
+
+status=0
+exit
diff --git a/tests/xfs/1217.out b/tests/xfs/1217.out
new file mode 100644
index 00000000..6e5b22be
--- /dev/null
+++ b/tests/xfs/1217.out
@@ -0,0 +1,3 @@
+QA output created by 1217
+pwrite: Input/output error
+touch: cannot touch 'SCRATCH_MNT/barf': Input/output error
diff --git a/tests/xfs/1218 b/tests/xfs/1218
new file mode 100644
index 00000000..f3682e42
--- /dev/null
+++ b/tests/xfs/1218
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1218
+#
+# hardware large atomic writes error inject test
+#
+. ./common/preamble
+_begin_fstest auto rw quick atomicwrites
+
+. ./common/filter
+. ./common/inject
+. ./common/atomicwrites
+
+_require_scratch_write_atomic
+_require_xfs_io_command pwrite -A
+_require_xfs_io_error_injection "bmap_finish_one"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+echo "Create files"
+file1=$SCRATCH_MNT/file1
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $testfile)
+test $max_awu -ge 4096 || _notrun "cannot perform 4k atomic writes"
+
+file2=$SCRATCH_MNT/file2
+_pwrite_byte 0x66 0 64k $SCRATCH_MNT/file1 >> $seqres.full
+cp --reflink=always $file1 $file2
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Atomic write to a reflinked file"
+$XFS_IO_PROG -dc "pwrite -A -D -V1 -S 0x67 0 4096" $file1
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_remount_dump_log >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1218.out b/tests/xfs/1218.out
new file mode 100644
index 00000000..02800213
--- /dev/null
+++ b/tests/xfs/1218.out
@@ -0,0 +1,15 @@
+QA output created by 1218
+Create files
+Check files
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+Inject error
+Atomic write to a reflinked file
+pwrite: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+0df1f61ed02a7e9bee2b8b7665066ddc  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+FS should be online, touch should succeed
-- 
2.34.1

