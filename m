Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C70C15C0;
	Wed, 14 May 2025 00:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182564; cv=fail; b=aUv6+Crmgcjtpn21gOK8ddNMbm3a00Oky6jszRLEQqf8xXdAy91Js819jF8VFHTvXd5oPqUTTVlaTKfKtfX+zjlrPqmChzzt3BeEstgwlAKI6ILzZrF4Q6qOKx1fDrsL7wLwD8cR07LstMr69uJ6dO1svZqDdvj4n8yjoznuyZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182564; c=relaxed/simple;
	bh=DtMAf/ry4dlmFA7B4dQpxY7UAcLkleYjmmc/1Qulkwc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ralnEsF+uoGenCFiMQcz9n6qM2YAiy/H3AflkCLw+ntmH94Fp8dZg/RO2cVfLcNZOTmN9zbHjmGXYfH4AfexzILiUgB0iBqm78ECVX1abQt7iY1gq7/Drw4DF/qCUuWT/rfBrxyKf79rBWv5cqA/Us8krdtNG8zWENiRM3bgNr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iX7+27BS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HcDGfad9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iX7+27BS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HcDGfad9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DL0jKT027390;
	Wed, 14 May 2025 00:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=5++ECSCv+HmTjUpQ
	cjyuf7y5Ml5eUBl1+vam78RvK+o=; b=iX7+27BSsSfm2EKXgG5X1kAgFgJZxfP8
	uTjU0WDVNZ1r7Ju6UE+zi0iZWtTEcVsGxPZQpFLOEVp1C2isakaYK3mw73HSiso7
	1kmmsZ+dqWyzRdUU1HynOfDjdpx5Z/HkwzUa8JHluCBLeIr26ndq0TF8lyljoxyZ
	1NaKVxwvT0yqWJCsDGW8NnA/a0tZ7tNnsQJ4SE3TWX4RIjNBj87fF+8ehdtvDER3
	nUmg0c1xKoyc3d2Hj+3EOPgUsme++/9rEQjFoApDWXjh7JcPDeQMEwFzP2j2iO5k
	UXOedZYOF0o9olRatHv2LDWR0f3hODyoGSwZIBoSEFtiyDl66yRBMA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcm0g90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E00lLS008922;
	Wed, 14 May 2025 00:29:19 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011028.outbound.protection.outlook.com [40.93.13.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mc6w0y57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OUbfmCBN9O9gQpNfPx6EUxvNpYmzub0e65DPw4vC0X3qjqcXDVHKjkUAcaSDgeX1Xtt+lAHdxH6d6b3J2pHPzpHZ4kRZ3OhnW/zDVeCECauv4v2oOpd8jsfMLZVYTAjwbu65f8k2t1l4w+jjnIZgAVli+OASvkCZef2KNq2ke3cDPqSxfvZ89yiV9Mv/RELgut+aoPNP2xrmKET7G2tGl74SoM26DCJmQcxc2cA6yBcyCB+6O0Ph3EsSK9JYrAwusuoMDz6G3A7In8BqvpriWd4cyHbpJJky4E/8R/4yzLX8wul2V09Dfs27G85wv/SsCY2DLdxevRLTIuQZfm7Nhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5++ECSCv+HmTjUpQcjyuf7y5Ml5eUBl1+vam78RvK+o=;
 b=O2GpFdFqGxKSQUelfKqCYnljYpJ9liyjTTiz+uOLtZFKheawKIIusLLTlbY+oMVqqJNwU1Yrlcx3j21tr4OxQXcdxLtCUJ+/vxLbL59p1p+aocUqlt7DX/ncmUXlR1op6gq6PZvSg/E9cdMSbJyoxYuuJ8w6XynDLSJr7GJW7D3O+MEqPkkLVHujBMRr9VTMhyV3MIuptcSDpncCJ2IBSmT1ec+ifINhXKzGPhdH5GrHyjgkwTXocaO5pFpj5r6Cqb1z5k4vEE1maCYOmn3R0h8xieHDKZWZfCIuFhjkhbczfhNRfrthTX4BVR0F1GUVL7z2sbYIUk0KCNBGueFKyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5++ECSCv+HmTjUpQcjyuf7y5Ml5eUBl1+vam78RvK+o=;
 b=HcDGfad9ra1GaFYPP/hgX8H/yLnts/icrAnOckzIf3W+UsIHYDwJBXLhkV/uM0aydWNX625jVegWwD3MiVoPlU1gcG6vrGY7oCSmQRmB5CWc8xxhi0c+2zA6Mhh+1cXBpOyaC+4+bHJ5lnT4EEIUhfE4ETxDVUlUJJZ1MfX37y8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 00:29:17 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 00:29:17 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: [PATCH 0/6] atomic writes tests
Date: Tue, 13 May 2025 17:29:09 -0700
Message-Id: <20250514002915.13794-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0374.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: ad0d102d-9bd9-40c0-639b-08dd927e5c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YU72Zk4ccneLRy/kt6LfyiPlv/jU/81Z0DXy8Zf2R0MoWQZJvDzfuRTVwkOI?=
 =?us-ascii?Q?crq+4NK5jsB2GIAeL7is65q75dp1sl1EjU0OVKEXk5F9drcZesi/gBPVTukD?=
 =?us-ascii?Q?iLDdIFEWb5YvY4GtHe6YPsy6WOky1vJgCAHiUbC/Po0c0nqDJl49TLjzVpw7?=
 =?us-ascii?Q?NnPUMUGy80gX1EVGyuaaw9FgMVSuM/b640Gtv1rI9nVKY5JzV1dNRK8Q9YME?=
 =?us-ascii?Q?ULKjt6DpYBvtznz3azesDBcJsp3R9rhyTncT0wC+fWYPIvCCGtWS6j3Vz3Qu?=
 =?us-ascii?Q?uOZb45I2y7gm/2w367odVnqoI7v883VWvFHz4cSGOBSwE94NRdMuOWxYLRm4?=
 =?us-ascii?Q?pNqte85q3CCVCk8w4HhPXYN+uPtcQ7O1G15/qBdDpIGsCND9nUp0JcP8eW8p?=
 =?us-ascii?Q?38rZHiQLLmiDyhz4kKqOHH+EHpOS2eHbRxF/PrtZyVHxZtls7eocKxyRC1Ft?=
 =?us-ascii?Q?iI0iX4/A4EAN0oUUoHK/r+onu/XDlKHAObCtq3U+HhyflvpTFgEneH03d94A?=
 =?us-ascii?Q?NK8f2GU93yP45sORjHi9qwgIiOhSfGlzwwQgPsnogPOYu2acdm3fr1YZ49Kt?=
 =?us-ascii?Q?ANW/pQE9DXSlfO8lSxHBK68hoyLCQSiE7USGT30bAalgHeMeQHVgN3abitaU?=
 =?us-ascii?Q?tenSAvtLsKVaEe0/APhWbUx3TPfIMEmqD9uqYTe6+nIklP40ZKLggXXcsJmE?=
 =?us-ascii?Q?ydATeKtVOsKxoHX5ILrQYQf6krXWKB0BAyJashVa3S2ih18O5PT1duulLWAM?=
 =?us-ascii?Q?txwXWbpkaYZI10qy77pUUDu5H4M1pTphF4job9C/nnVsnxXLNm8uYArjIwmp?=
 =?us-ascii?Q?04YvKRqGnWji7YvDxoDg+VFWXOKy6/VxLRob32/VyS/wXIPgel2Sh6tnRFLL?=
 =?us-ascii?Q?Geb871848dA2Ke44IviXhqHa4zcmLi+PEowTPxC7C+nswfMfqAgkTdN/BG8r?=
 =?us-ascii?Q?T7AHkOyKUH3fE4zk59gmk/GLcmUXW9pLj+Q0M7k3Y3FMCPASjyd7IAkkPDbA?=
 =?us-ascii?Q?vVlZLgzjE3WLYt9Q5VNkt7SWxGmLknibt6orsUMBj7wtEd0LkyP9n5NLlHsx?=
 =?us-ascii?Q?Xz79F97YavOINVFhlSZno7ihiim31RHX6ThQKNPulxb31udktcMfRQVFHobt?=
 =?us-ascii?Q?Xmh9ETkUl+WHT1I0qma5QhY9vzEe8BZPbuvxVm8Jg1r9BIbvJs4DNp+F0ruK?=
 =?us-ascii?Q?GZGrOToxrl86y85QlmcJgT4mc/GGuVWfeHTENB5FGFUmSzwvtqJqqtEqyP/N?=
 =?us-ascii?Q?nBuvynUex7J6io9zCpl64SiHI7109avIPqFYGpESsfBfnkhcJVy5yucUfCsy?=
 =?us-ascii?Q?oYUBltjve9A2nWlWoRQq/MZbCvbHLpfKpdlGD9/slKnPbXbv/KUjkm6oNTBc?=
 =?us-ascii?Q?ID+gGBn5A14crOv+h8fH5ZpkrVaXRi4QsdNQVpz5GlZYqDz9oRCx5RotVyOB?=
 =?us-ascii?Q?iDehX28L/T4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LhN5VMHPT27/DXbIijzFSOCDKfaf/TBoRL5WvatJY7T8BmkNY9ooEAfgQEnB?=
 =?us-ascii?Q?yA3U9gfqR5dv6SxjmmybL3fmGzOTrJ7DJO5LTlhKKcRiHK8O7EsaBiATouOV?=
 =?us-ascii?Q?VKlla+9M/Q9SZJ8Q9t3snysk4m2rTa/K2PpD1W94uMo91DcYS4tzGg1m4CIF?=
 =?us-ascii?Q?dzo+QBRzH3pVY6KlbJGeemD4VtiondiIuAV9RJPYnvyQTR9/L46RtSh0wIr7?=
 =?us-ascii?Q?kF8uiWEycnC3sVCg/NpgIQgbEJqjD1+Y3scRjz5Vkc4LkCAVTee8RHuj+xD/?=
 =?us-ascii?Q?sDpN2+pa4clTCscKwj9t6jTBE7kzpVXaQGf4GCExjjB8PbtIdRAEfUKLyclR?=
 =?us-ascii?Q?Kec4H1dQep+BBNCU585koIkYcR3+kW6OvBBsIZJ1isgiYd3fXW2S6dOumjxu?=
 =?us-ascii?Q?Yag4tEOXS7eEoL7pKRpPfIVoIz+WYOM+cRGDjUIKN0h65oc72oS7dOZBvaSK?=
 =?us-ascii?Q?Jpej/h9/LDpLvLUZJ9FQ+A4uD5pcgTSOlW2sX89lKihOHMngPJ6GM7BS7GD7?=
 =?us-ascii?Q?C/nEr+opLregoacFlrddN2T6gWaXBqBt6dJADR/vzFLUxxVVyRZYSi98UEFz?=
 =?us-ascii?Q?xP98UhX1rNc9uWUXRtXKYO9X3Sdrbt1d6V9UpKK9ziiCTsmSsV2kwrdTXwly?=
 =?us-ascii?Q?bb2BkI3xYHkrsG4vAXCvJ8L7nfS32ML9dKk7HEoRzYrACFeM+D0wMlymBFEK?=
 =?us-ascii?Q?gklXJS/wLAHMNmhAWF0hN7d7SZia+Lm9bmw7dpi7/2fNuQSazOjavAd28ODS?=
 =?us-ascii?Q?Q3rbJf6ro/avSrKnd5M7VPU3TFZo9uxGcmHkmK26V60DUMcUAXLV8r7E6bin?=
 =?us-ascii?Q?cfZ9AZnZC5ZwaFfQWUPjct8tY9n+thRXC1xhZcqALqyaUokjlfPOCtOnQ0xg?=
 =?us-ascii?Q?7+xH8HhqaIbZeVjW12XmrQ2Lct6pQbSsdzzVxw91V3rhcHJ8QHgFa4uIPkk1?=
 =?us-ascii?Q?0dfxk5ZuffKm5Gsjsd2ctn0hFgew2v4paizjklV9sabT/NzVGJsGb6daE+8c?=
 =?us-ascii?Q?5a8tytGWu9/Tx3CvdETdmbSEZk3gbcu4VgdvvkQO0BNRj4gUMyBl2TbO+XmQ?=
 =?us-ascii?Q?DxWEq9BEWH11nx1XUTjYpM7DdJ1RkZYn3fcOmP8IJeohJFtck/X5JUI7xfPW?=
 =?us-ascii?Q?IWJ8vYKO02gpf7D/iYea1t9lxZB6TupXuyyPO2YnbNS3BfZg1iPN1sxHqAKE?=
 =?us-ascii?Q?x45uffTwnNSkjm4/R/WRwcH5SS4VTLAWUNV69igNjhOxKIfNRFqLj6jREvem?=
 =?us-ascii?Q?IB/DV6L3iOcxycnBWbjeTqFP6EMW2hY003yt+tR11yDKDed1+OL3RWKc3Vlu?=
 =?us-ascii?Q?PKPPvlxBTlDlLSCjV0o10AMD5V5zlDWFW9MTRj33Dr9VUCLczRu7S2WcGgT+?=
 =?us-ascii?Q?AA6pbwhEwndfEv7IVeRlYKPrhMeYStfO+GoOvSfmI7imfBu3O7RDTqBfvlWZ?=
 =?us-ascii?Q?NkD8JcSt8sK0e9sOP19KpYSKj/kE1mxfbTWa00Q9ZCku8xJPEi7OpJa3djjf?=
 =?us-ascii?Q?AAbQrtXEkbXFrkP/T/pSm2ucm8RMRxwKbIqx7Tx3iyVHN9RzChfo9sETwuw9?=
 =?us-ascii?Q?u6enNAG70p/7y4HMNTZqqexwdHW+iQ1TlDslhcQrG0I2niKuT8BnCnGbk7Fj?=
 =?us-ascii?Q?sMU7PdIUo379ER9LDVG7BolZbky4GQFQkrYO6H1bZdixlgTdQQLZUEdoZQE4?=
 =?us-ascii?Q?qm2/+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6QvQ9d9NxBYqyGhCaWoLwE8n03krvEJ+eRmbqiCJ8VQiVFXSR/N+0029mMmnZUTzOrRYN4pMD4Kv19vUIk6xhv6bILMdyNkez7BHlbJGP/4Lr6kQKbN3Ku86M5EpcBpeqSCZo14iMgLrpHXU6gFjaydKVY/Vtee4JEtctPY0jWK05APt0j7Ia0/OB7coc3ouYAlb36zK+NOEPyTXZIbbyR9v7/64O3B13j7ucTZsZFj/OiX3inruiggJ1L+Pif60Xcfy2LlUzWK3cPoEdn1ULFsg9a/AzWjPurr+O2hf1flWeBX7t7770DA9AVUdBvuE1CUdD3jxz0LJ4eirvuD5LnALuXKXfUWqU94WOkX6Ex971+OHePZmXYYH0raiQDtDLqGc/AlWe/ahgUmfZozWiBYyuvq4w6PSQ3D+kZy+iaRI2A8JBs4miuKm01MIXCSqKG/pPj8PRn9STbvaT3FiDL6iWnjtvkFfy/Xxmg9O0CKxcJnFg4hFi1wE3UBJw7NGkgmALAlmLdbEvcUxT7GszW9mFVNKQkkvavkEf+Y8Len7CvclvDsDGZqBLTYOs32KnJ2n8LUZEhQ7CsdMa9LFV7z2UWuLi8R+Vvh5nn1WzfI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0d102d-9bd9-40c0-639b-08dd927e5c48
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:29:16.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KQZEy/T8641/jARSZVisRIyzToiGphhZKjY/vgSCDOWB/vAf2KqKK7Y0C0AZu4LTy7KtRKhPsjCfXTAgdW1SWB7VdKIvq8ZAatKAxakA050=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=741 spamscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140002
X-Authority-Analysis: v=2.4 cv=DZAXqutW c=1 sm=1 tr=0 ts=6823e3e0 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=w8cynbu-OpPHUjKY4DMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAwMSBTYWx0ZWRfX5fSOVmizwvRW o1TMM9Q6HXYdatgJwjabq+WAvx/UpCLg45CUL3MxAcLX2QBh/Kr1GAmTIDiKw990algMQ1N5EtS YEI9hvJt+rVAGU0esZnUP11xrGnvsnfNaG/msEOnHQE15Q3yHN8EOxCWTayGuUbPev9XZi2Hacr
 k1xqHmliZeUU0IzPrWxA5gN0KKaJyuk838c7l5vDmlH+bH4PWTlpJM75D8Fc3qF3J9oMAOSDxAm wp1His3AdyLUa44JuEwtJ+ucCAfHowq5M0mUTbIYK6TIADGxByDRXmHCYBrEUj8YGcKR1b1Ta3B Rk2t2zSREOgYo+g5a0B2CfdXoJ/z3Lm30iVbOI3/xXwbTUfaKL2HuqfcWST2vfJkqYMCvPpmdAb
 Z8IHhqyqNGDCa2AK/uOr9OL8J3y6k0JJLCCv6XFJ9aDGI71gBsma03BrOdHxueXUpdqfuKfe
X-Proofpoint-GUID: UFP47ExTiBwFi24AWBthWRGDlymjkGzM
X-Proofpoint-ORIG-GUID: UFP47ExTiBwFi24AWBthWRGDlymjkGzM

Hi all,

Now that large atomic writes has been queued up, here's a series of tests
for this new feature. The first few patches make various adjustments to the
existing single block atomic writes test, as well as setup for additional
testing. The last patch adds several new tests for large atomic writes with
actual and simulated hardware.

This series is based on for-next at the time of sending.

Comments and feedback appreciated!

Darrick J. Wong (6):
  generic/765: fix a few issues
  generic/765: adjust various things
  generic/765: move common atomic write code to a library file
  common/atomicwrites: adjust a few more things
  common/atomicwrites: fix _require_scratch_write_atomic
  generic: various atomic write tests with scsi_debug

 common/atomicwrites    | 127 +++++++++++++++++++++++++++++++++++++
 common/rc              |  49 +--------------
 doc/group-names.txt    |   1 +
 tests/generic/1222     |  86 +++++++++++++++++++++++++
 tests/generic/1222.out |  10 +++
 tests/generic/1223     |  66 +++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     | 140 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1224.out |  17 +++++
 tests/generic/1225     |  51 +++++++++++++++
 tests/generic/1225.out |   1 +
 tests/generic/765      |  84 +++++++++----------------
 tests/xfs/1216         |  68 ++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  70 +++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  59 +++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 18 files changed, 763 insertions(+), 102 deletions(-)
 create mode 100644 common/atomicwrites
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100644 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100644 tests/generic/1225
 create mode 100644 tests/generic/1225.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100644 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

-- 
2.34.1

