Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA500D2FB;
	Mon, 16 Jun 2025 21:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110754; cv=fail; b=NWm6QSHAgxip8TznD4VYsedWKLZ66B162vBR6fOjw5UqKvUVF3KXnPcybQwkmiUQAS67LVec/M858Q7kfTCvbSzlusd0D1OC+rEs3U9XAi+moN0y0qCwdRLZnMu111WttYnO1EYmTBo6oxt9WGzdzCKDwDhjfImWOuLl6OOerKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110754; c=relaxed/simple;
	bh=jH49rMY7rxi/Vyt4KYzVWIrQQHg2ppbwp9i4DVqGyNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WAH3+rEM5zFlaNBDXNN2qfNGRdTSf5Ut7ipCiqsF3Mz/ofuz3n3RmCTljWHOmRjRjoxuXHKnjYRjCbiXrcGGDam+UW6A/C0kSm4mk4OTCZn2unoPASDmvtyKpcDpQAUcQxy0NfMcbn/IiOX1skRurjWgXAPdoZL+w3j2eb5Wt9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cGEPjNol; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Od/zTpff; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cGEPjNol";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Od/zTpff"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GL9P7X027758;
	Mon, 16 Jun 2025 21:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=W7bW1z4T/i25/S/FBZ1HGVzJTr/tTM7QzpTC5nF8PAI=; b=
	cGEPjNolMsOSVbVRPE99fs45XtlE80DYpARYdWFY8N42dFBEzQvn+JCtty8NXPep
	i8Qfiml1Fce4GvLJ33DplrFdaE68iMUBY/LLroak+UjyYe5rNoJISRqU2zG4O+6m
	+p0Ng5/+wSc/cOqsO7tone56qLmQ0ypBLzHBn9lVVmLoo+zpreN1MKb7N5XKgUAW
	hBaHpPDCS47JzycpdhD5jq2jQCxLRFlge8QEy3gjCUn577C9aWGGhVXfyHmCbj+W
	31msz4Lchekz8vqIcGz5UOq60G8XNnpKX8fzBYBdNmLb5gpcZbYJ20Q1uHL0bDiN
	S+U4kTYps0wJHpMbEcr50g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4791mxm3mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GL6LpM032037;
	Mon, 16 Jun 2025 21:52:24 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh8fqf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QXzeo1OF4n0wMmZ3e/V6hINwJd4+SlAGZ3rMBPcaDSxcNwuxmt+Wr29gZwUjl6yiOHowNncmY0NqyEN2Ff8D5oOXVzgTzKI4NAFSpZEnB/EPBE4w4eIdSxWnkRJ+u5UkWuKwKORknx52T2ytioaj3dZxGpKd2EOjMBlqufNRl8AWalSTm7XsxsXY4NzpcCXi82fdtM/HOKgoFYhZwKGNKLAiJosEBGW0X7FGVFuYaHwys4oqMGXakorRhahqJBtYABhTPSHWKQq0wl/lc0QDy5nkR1rSEt9+5w9MGeR2eUvWJV4ozkuiTddIQPBTzTJnjLjEgTwG6r4PplSsXoRYeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7bW1z4T/i25/S/FBZ1HGVzJTr/tTM7QzpTC5nF8PAI=;
 b=D0EX8JMRM3vShFVuOpfbT6kCDFG5PCe/G93V47fUT2kr9GqQdXOM5rCMAcqHRpj6D/qgMbfZ7KnGq8m9wpEMloRjFGMrPzOOvB+b9tC0uNAhTPYC/zZsB/91zq6UPhVAPn4PB2tjHRgEP8W3qc35v4cqeRWq53c/N2nY/C3qIOv6AbN/hjqGH4OHA5gorha4amq3cJ6gWNCnhb92OPjuB1yaD8KGqxA7O9KloYfpMQRkLAYuoLUasGZ/LRrlD70O2jJ24DOYfBTHE4IJ0FdqxohPpapBKTa0RWPMCmp0WcoQd8yb7uuOCz791CngUZhXus9WuQ6HbhhpQH094cYdtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7bW1z4T/i25/S/FBZ1HGVzJTr/tTM7QzpTC5nF8PAI=;
 b=Od/zTpffh/ikMQL5dF+uS8iTQE7IF7xwMaQd97lL4Falr54bPrxLj+X6wx275gPpqLsZTZf4wvyWb5o+g0j1YzhB6/phPkEeH3I9jfzdIe+L8lJY23vd/uj63SXuzeKqOgLRV1c/1C5qKkD0cWgFuNo2o+diLcbgjdyfpmSyarg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH4PR10MB8148.namprd10.prod.outlook.com (2603:10b6:610:244::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 21:52:22 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 21:52:22 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v5 3/3] xfs: more multi-block atomic writes tests
Date: Mon, 16 Jun 2025 14:52:13 -0700
Message-Id: <20250616215213.36260-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250616215213.36260-1-catherine.hoang@oracle.com>
References: <20250616215213.36260-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH4PR10MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: 610a73f8-1413-4035-7636-08ddad20129c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lRRZPYi6lsKZEiuB+inOvK9+FEh4Sf36uWuMnLcRE+VJL+z5FDnHuX0RASJM?=
 =?us-ascii?Q?80jiHzUtta3fhd/S7I2cfgEKjzFXhgDaOxIacFRmPl1EVnPTfUE/S66jP2nG?=
 =?us-ascii?Q?7EJub6jDFK5TGltkG1MPqIgRpOPlnezqGnnUT+sBC1H79lmNX9YRKU/ZLVBc?=
 =?us-ascii?Q?Nw7WTLLrHkVLs3Ri2C37nWA5upZoLaIBZbZgueT/OCU064uL07PQY4d0qwGi?=
 =?us-ascii?Q?iQza5FNqFtVak6sfksBRK9LhlYY5QlY9h2PLrJ5BS6vzohJH/HdGDPQQ7JP6?=
 =?us-ascii?Q?7sah+ITRdZHnqOxtzb53Jn2Gvp4cQMW5PCqDqWEkYVShAW/SEQf/QEXD3hiC?=
 =?us-ascii?Q?RO+xT8SmwF2UyXnjV8oD+TFf64fgq+hOWQoDmJ4BgcV0L+i+nw+zb4FDmZDN?=
 =?us-ascii?Q?lByh/oNpar2j/vQj56KAzan58dsUCOk6Ke9nAlbFwmwRvyC6H+DW3eF1Nqls?=
 =?us-ascii?Q?CU3vFmdTX9iuZBvM11sst/cZ4PchvTriLBe5aWV+NpOpuUUI5eEjjrJo3JxH?=
 =?us-ascii?Q?xAo0f8oc/7dc6bHAEfaOt6WEe2bC3/X9wBH1wgHLscN/VVBhzwoU1f7ILIAT?=
 =?us-ascii?Q?8hqVa+WG7OreRn6oBLlVLiWVrHW4BDJGS/r7j1Hdj2azFucEVugoAlpbPzJL?=
 =?us-ascii?Q?W82fC2vItNuyLYTb8bTBFlENUjwLYVwgk6MnUHUTH3sPzn3TtXUA5d8bvgwC?=
 =?us-ascii?Q?c8VhCTLTISLo8fC0Dal/3h04N5sKQ07ENx0AIZRZqeXdMuGHP3UsPsyNrk8L?=
 =?us-ascii?Q?ywR6SRVfNobH6WZpVeiDqJZQW544jAkDzB4GjvK5mcwDzfplYxU9UNMO/9c+?=
 =?us-ascii?Q?8hXqPpNw9B7QLStNPPkkPQiA/6fyaio1m+LFiU2jkzfccwc7MVzDYFuT19m4?=
 =?us-ascii?Q?MRJNhNlV+nXVLNT35KHNPx5Nhy/cnos/eSjGGMIxticMdbSw6lsZ3wFrx9D8?=
 =?us-ascii?Q?Ehy/C4VKe4/GpvZ7aAjWeH41g61iifhrxcTTH/fcqeZKO6kwwVTpp8ifZkXk?=
 =?us-ascii?Q?5foIJiFVn4Sh7kt4eXFUIE8J43fExAMRAW71AVvSrq6J5X2ZmXFKYr1pcWG8?=
 =?us-ascii?Q?SITXWunLLq24cdlKdG3l+v47U8fBKFLZGYMEhmpN3hPVLoB1PLK/W4qzknDU?=
 =?us-ascii?Q?U3X1OfBhw9NjC6Mak1g1K3gf1ZNnyFTCq54HxaSRsPUH+IY8UibEgC4IBvM2?=
 =?us-ascii?Q?mtugwStXJSNKJzyTmm0++NIMFNlXsFAAtvBpNmPFL9SwqSLGXhelaz4tzv3F?=
 =?us-ascii?Q?jxqZPE1N7Ns3oR4yurNBG6nr5Q3wlj9cOZYixcUZueGCcsXSSkUahW7itfk6?=
 =?us-ascii?Q?ipRK4LWQyBlNNoLKRXiZNgsZY5Ora9AmPGcTf0goCVachgZFuLknNOjnVyKW?=
 =?us-ascii?Q?qZYOciCgQs2fXPQUD1XDQq+lJDIhpJiJT8DKY4Beok0UMYPeECB4VPx5cx6K?=
 =?us-ascii?Q?vh6sUZVWHjs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7CDpLwyu7e2IHnpeiv5p3pI4YimxaEivN8kgPyYPier/Rsq8iMHghsh6FEPN?=
 =?us-ascii?Q?4EcjEeJm6RoOsQLX8PRalGGzMC+G4+egcx2RBWeXuD+IXHdzVb2l1RXIjs3r?=
 =?us-ascii?Q?JtusTSIT+atNjjjPKPgCoWBxlo3OMMnGRm4tUf93CR1aUkLSLOGgzODree91?=
 =?us-ascii?Q?7mbane6kUlOPf4iv6E8sRgp9cczWVkAvTSEimAb04nl2Q8iwlpr229qFF/13?=
 =?us-ascii?Q?60uE5qfKMgqGpoY4uE61wToSDVlZc6235zNKcpYeCUfzXYUzkr+d6BsLQGIC?=
 =?us-ascii?Q?tvAeZI2M7gftf9EF7iMClgw92a/shO2enWIXGXobU2nbO6w5TZfRJmsBovDC?=
 =?us-ascii?Q?P7bA0NcA/GLmIJAcGldRPEYJTi60dX7fzu2R+aaT9XwihOv5SfCAIJ4Klu8l?=
 =?us-ascii?Q?hKdlElNghCV0EKGTjSNJQfPmdKFHUAA9TaKB1wipAPQSBWllLHiW1LsqDf4Z?=
 =?us-ascii?Q?ybRNpgy5vk9UMbPCAz0Fro3jAn7YRPpJ9xpkvVqQCSJj5Uxl/YFfBTf/QP0Z?=
 =?us-ascii?Q?iMdoRyZuR+0Z3r8xEFHz/szCq+34WvLVoHde6TLKot4Bbj+xUqrKvuOy9fga?=
 =?us-ascii?Q?/kpMwcGW5v+a3UJkWEs7DHH0mLVye+yGtUpbKwmopswrQjhkLFNYQC0EOteA?=
 =?us-ascii?Q?R3chA3d1w9rR99WpMqOzfYxS3/4kNwGxUjHniO4JO0+d5dBe72CgF9TSeHcH?=
 =?us-ascii?Q?+iLGFSef6K25oXP94G/drWkXfn6UQqtFEaHU5QxDbhJyedej4ApjQtVR2nyx?=
 =?us-ascii?Q?vhS/fQpzKHL10LWfztUiaXXSBejqc11W0Y59hGhvJbUOvaplJw3mrECTj77o?=
 =?us-ascii?Q?nr0+b7zMTu9ZWzZcuPy9s1Fs6xZCoACjnDHc/6ONCDyS8k+OPvBqcuHrOYbA?=
 =?us-ascii?Q?dydH005HXHVfyoHp2iDQcPairwtVDU/pmHMF2BnnreToWXhMR3a2RC7Rq9Mh?=
 =?us-ascii?Q?l2QJGQvWjAOTfLzw7Z4f2LEYo69LKE/PD3oeZ9tOTzh6AtvLQx95SY7t4sRq?=
 =?us-ascii?Q?rt51RcpiofRn4l0nN5dOl3GRPaCpuv9J96xc//TjLapz/hIbQmBxR50a4Hv1?=
 =?us-ascii?Q?KCSGWY42jZ15iwtZEvPQE39GreQHrYall+wb4q70SYiaayckSVMs1f55Ylmf?=
 =?us-ascii?Q?OBGPbGQkrZfS9m7Oz5LDPkp/xMSufgAu2aMAT9ooG8ykcIF0KEyXhSY/vV3c?=
 =?us-ascii?Q?HDYtI4s6z9hRrF+RTrxuVeSY78Xj4NA1lArDO/eKTyeu4MZ0hMqgTzEwgPfA?=
 =?us-ascii?Q?4k+dq92D4t5XF9yod9XgYA9nz5pKbdzBB6JrJqpWaao14X3RxZjEwlZpLbR5?=
 =?us-ascii?Q?9wWkAfqPvREPRHjd69qI8q+rT/GAmIY3G4axioZNkVjG7U7QCNnNTdgdtLcr?=
 =?us-ascii?Q?9lAGEeAz1+faQURsLKmwPh3Gub6mjDsuQnCsCzapcPOCRU4r2ABhpK96+BTp?=
 =?us-ascii?Q?oVWseYAVmhnP9674uHCvumIwwkEqyu4fXvx10zR5tRKIAF/aJqiiXARfnuWu?=
 =?us-ascii?Q?vt8E5pu5dbbISynavirBfruhR5/stb7DSzwsNDqrdr2yTf3UOYplzxZhCAGx?=
 =?us-ascii?Q?9pdPhi2yCpgJ1NyIbnwDAZsYwqkxb0a+mDHCVCEllM+cAutVKrxHAv/a/Wtf?=
 =?us-ascii?Q?cLT8/NGjL6UNdUCuy/ACDQMvI9nVmz/14pGKJFFmKDiAPzwM9I9RenxkBSJ/?=
 =?us-ascii?Q?7aCPlw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fiU50eOFdDcCZthEF1Gj51V9ReDZfc8FN3Mxe5d1qxZOgrrw5XdNXTC0FwYNyxXjPRW2yTn1jKF0Lm9khny8lzXMW/Yrop3E1zb5FDg+3X6P5yYK5ASkbkdLiyW+bCQs5ikog5lLC1EM/iUhzwSU280L1dQexOzNRKyniXGqo5zjoR2CgrtTOrtLAlsxkCeDTrHQXRvsokSLEYa3ywbEdUFe+YWcOl8Z1YpbLPMrnMPSUSElEtnvE8r5sAGmo5YkQhoU41GJc9rrtAic7N+teHC1Pg+RxbVQTiUM9Ws8wdiYgCZWoqeeTAuLvT4XX0bRj45LU55WBdm3HPGy1PXCBHXgLVRlUwXURmz/8O9yX9GRM5Uf5FOqCxwEvvz3HMelORShSxVWQAxBWLeeH2PEw8jrmOS+AfNAN+I4BH9jloK0o8evXiWjtcRHtFOh+W9azP6j1P99LbEs2wYLW8ctm75WhHBTN+m5utjHg3oW9I9fe4y35Z6qWB0jtfS54rQ8U1SeK9NwSRnIr2GYaiahod/657Jvoe1T+itT1qIpqBOraGSOEyLtJNz4wcCaQvtZGM5rLnVzgaAmlBt8WUqMWavDn7QDXOy1mmOObroM0rA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 610a73f8-1413-4035-7636-08ddad20129c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 21:52:22.1466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czCRLZW1DYm99ltFlrVtdVBEhPQrGZpB6oTU/uFTyJq9pfLDRa/7y3Qs94YGt3dEWCiXSlaQ/9/KHf6woiYDddo4R23TP1jx1PDiIyTyvfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE1NCBTYWx0ZWRfX5PPqRDOEFBmJ 78wKmzvJg46lbFMEh0XzCBVR6UJb2ZscIqlPS4XWOSXQ2X0Y3Op7ReoxzZIgjMit0X4UAUMYHTl Zbvm5iHEMkVQ2OyaaGlckePjnWryMqT6xdG0tSefFQZDBVAJ9dkso8mHRra1AlEJxKZjhHy+ClV
 gDa4ZLrZJyFfZVQ9W1aG61H465Kh4qfSHzsvdZf65dl61IMw/AA/uKqZV9fqyh/8lgDioAUUtYE e9orHj0XbTGQWMFPqJvZKjBhMpqWASaNfki1kx3CO2Zgf8srdxv5mtHFYnXZd5NGGblqI3zIOLa qLtMP/TQA0eHGad5rrJjku04OLC23Tqgt6ZWASpu/0LYA7ku06Nnv7b9zWyqtoxZ4hkDc2B1U2R
 EF8oODouXymowrGkuJAR4uNrwxjOZxctY8ai5EnlXM6+tWed9pSmmDAytIzVn4Byz1TMRljw
X-Authority-Analysis: v=2.4 cv=HvR2G1TS c=1 sm=1 tr=0 ts=68509219 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FPzu-_wniR3LNvefyx4A:9
X-Proofpoint-GUID: Oic_WZpr3EKlB64KoQ6T5nNhUAuifub8
X-Proofpoint-ORIG-GUID: Oic_WZpr3EKlB64KoQ6T5nNhUAuifub8

From: "Darrick J. Wong" <djwong@kernel.org>

Add xfs specific tests for realtime volumes and error recovery.

The first test validates multi-block atomic writes on a realtime file. We
perform basic atomic writes operations within the advertised sizes and ensure
that atomic writes will fail outside of these bounds. The hardware used in this
test is not required to support atomic writes.

The second test verifies that a large atomic write can complete after a crash.
The error is injected while attempting to free an extent. We ensure that this
error occurs by first creating a heavily fragmented filesystem. After recovery,
we check that the write completes successfully.

The third test verifies that a large atomic write on a reflinked file can
complete after a crash. We start with two files that share the same data and
inject an error while attempting to perform a write on one of the files. After
recovery, we verify that these files now contain different data, indicating
that the write has succeeded.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 tests/xfs/1216     | 68 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1216.out |  9 ++++++
 tests/xfs/1217     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1217.out |  3 ++
 tests/xfs/1218     | 60 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1218.out | 15 ++++++++++
 6 files changed, 226 insertions(+)
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

diff --git a/tests/xfs/1216 b/tests/xfs/1216
new file mode 100755
index 00000000..694e3a98
--- /dev/null
+++ b/tests/xfs/1216
@@ -0,0 +1,68 @@
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
+_require_scratch_write_atomic_multi_fsblock
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
index 00000000..f3f59ae4
--- /dev/null
+++ b/tests/xfs/1217
@@ -0,0 +1,71 @@
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
+_require_scratch_write_atomic_multi_fsblock
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
new file mode 100755
index 00000000..799519b1
--- /dev/null
+++ b/tests/xfs/1218
@@ -0,0 +1,60 @@
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
+_require_scratch_write_atomic_multi_fsblock
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
+max_awu=$(_get_atomic_write_unit_max $file1)
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

