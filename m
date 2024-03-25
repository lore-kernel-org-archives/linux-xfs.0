Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88F271748
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404505; cv=fail; b=tA89W4HdUzVSQTQCiX3Z7I3mw9+FlF6JvucN2UtKxlfyWU5jwpmUYtuWrDxw969FHxh0eZefqYPp0z4kLWIgaqNf08zH4cxCf6nKhaswvfLLFFs/45Z2FV6/3rqJT89qpuwyqQrmazYtbbvA169O6jQWd2d2Z4zAH9u/vRwB3AM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404505; c=relaxed/simple;
	bh=pBwuuBzYyeVhx4sUi1veE4RJuereL7PI11ExiH1C4NU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ihtHaMCf64775X37LUDXsywYzCc7dKAAhjJyijRkDrzdCPIQPZ3YJWAsLjCaJuRlUA9w6tBYrJbywESYsIpxncW+ExGY5MyIZ0qpuKnSjPDJxWe816yfWMlO4MvI2OfUMWJ+5BzCkFP6tIoMlrK+JueAvt0+A+W75fcpL+StIn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dg6d7D/r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YkqmTXD2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dg6d7D/r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YkqmTXD2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFv6v027167
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=fdP7Mh8b3yzecDMP/bpYuTG39mjzD1faKDskKQrtWzc=;
 b=Dg6d7D/r6q3iuInjJHyb+dS3vlWc0gxKv2WchT881R5qj8MhOOm0Tymus3AQwuMOKBdI
 P54ubKwQat5TEqVjXp2pRYZKYvic7+ATUinNjpX8uN+ZWPypURAlM2VMty54CqTqhDny
 HFEYzonI9Y5/KQ4gNXYwC+464Lsw0t3hlPRVHwIR+n+67xh4PzQNv/GMJAFDBUAAxyZP
 Kn+bXI38mBJwn2vz1J8bZPLI5apSivkvs0modQ4I9IBMV03gUL6uAqQk2kQLBzq7fzXE
 Q3KI0eGYSFxBm3UXEv//+zIqUYK+RynyBLaJmUAuyHrCPfSIc/AycKX9Sp5DzNJXRiE5 lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkqjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKNtd6024519
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6ccn9-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9DeKGhHx05gYP1onIUdstfa1Yo8jOEn17NCOddfEPd8yke4j/5kTjIzh2dA8OplNVshZqrqKf0AlYPjwz6+kE8CRfdcgiJOPe+gyYTy3ntWUgUsD3mdzzqzSWJ3ghqgE/AKgUs9YSFa6Lgq9AXzN9RWEB6OGb31z0vmWoARfl7ow2VMhEQ3V5pqYTvQifXZX/RMAM7aivc0aEZwjQ42BvhkgU7XlCV6Z3iWvHYcAup9CD1IsACBOrNQa31t81jsSxgIfChZB2As1Q0SdHcKd3jOolAwMOstkqS0UpILPE1FzqjJwRA/qXhElBlhJPkVOPxSBdvoKqeRO4lLP3UE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdP7Mh8b3yzecDMP/bpYuTG39mjzD1faKDskKQrtWzc=;
 b=N8uve1GS31J8mE88erJRi1DaTG0TpfSLlhKz1lQH2Pn/1zh+FtbhYsq5o66jQR94K7X7WHvMOvxmzuKXeWOg9L0fcjBRqHkWoSMwgk/GpJYWxWYqv8CaCNZMtGw0JopPxMC9crLLXoogE5xzF3bE+eWmeDxZiEByRFz9kZhP6PS0IwHdykCxqpRJIh9qgTFE1NX4k66FO8K1jxaxcPas+zLkB7wkS48MyPcL1BiFc8muQNCgnXqlOLVXu1J/hl+umKyjcgayqKah4SKGVChPgM75vEF8LFZtvbAkg+5CVBh3iOy5xqjp5iiat12oM7cUomdcsErZ6TywND5Od5YvWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdP7Mh8b3yzecDMP/bpYuTG39mjzD1faKDskKQrtWzc=;
 b=YkqmTXD2EazB5CeFUhKEZqGh9eBe11XY5fO2xsaPVjeh6TjGyaWPvZ9RhDyNPtW4s1r7iITGCcmGLWFpsFLUdiFKE219ok/8gr7/6l42AyFRSZ9BQxzxiD4a0ZEKLDYgbY2sA3Bio9QS9C3UOU00jpGxh542sT0MS4myTaqvpaQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:06 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:06 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 17/24] xfs: initialise di_crc in xfs_log_dinode
Date: Mon, 25 Mar 2024 15:07:17 -0700
Message-Id: <20240325220724.42216-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	o5tHNOlk+YcoHI323/BT7e3SEYuf/n/bQz8mE+jmVmp97i2+lKTm91Y/0LELZhnvmG3sDr+f2W1a92K/unbYmrKD6Sn3iC1Aj4mPSxXhYiRHZ5Cmm6pITcqHup0GlFYimgOysd+UzHzmicne8VKb0R7yz3QQutIu+1SONFTW4d24iC1jhwTcwV/FWEqTygiGgIv8DViqM/iBBs3ZHRHYN3yXYUhHuPqOucQaAJrvThNH1VQBxs5VAxAU+dZ14fJVUd5a07vkqemgbSGDLkyVbItYoKREIIow82AkGK0SzaEALnPZDWtZw+81cx+LCBTPdbTxNrB+gEooVXPuII1bxxi9DC+8A1p6Brc//kdtYre0vYt6+VHAodLVps1lndyEW7CcNCjjtltBBF8SgDiF1D5PiQ27JwnPJ6Cak3OAnL9jrL6CnV1Mi6D97KfUlU4H3b3fTZiWPRuXkHdUKxWeUVV31bp69xCcm4lsUxU9k88nj/98f90XzpN+w6kgOxM2VDT8cgewCk6ZhAiriDBTFYzI/T1y68X9TC8TyEXk4CZmx2PIYGUIJB68EFXhzladlc837NXvFoF+5syDkzL2rWfox2YV9gio2pH08pypL0mNgR1g4mEyxyU1RiiVX2twC2VbgZqQPPP4scceXhxEgLqcDOo26AsmwcaH0N9lfhE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4SVln1IAonwudP+SwzZTFKj/wQymfliPIlv62GHTxF6Lf1KnwUFMogOu5vuK?=
 =?us-ascii?Q?5pNB9zebXlNRuMlFOvLqusBeqHxR+8HLCO1NSvnJS3NRO1n0oF8X3zpkZrMG?=
 =?us-ascii?Q?lieoRXaZhpbOFS5WggkEJhaNW87SMHqzOW71n9aU4QjjfQx9IlCPEg1AzAcU?=
 =?us-ascii?Q?odj9KEKsPPTgAOSt/6X9D1pJiUIbYDNAG3b3ewfSSGxw0TitKMvTK1L6C1hc?=
 =?us-ascii?Q?0BU8bNgj3/IsI6rHn9w3jjkYv6GQXbiSDCAuIWuZiLb/PimwbVvN+5GNasSF?=
 =?us-ascii?Q?6pz42TwCI9aUbJLmt5KaotgQ0lgToaUVV/XypWm+3EY6owWPJjFoVjUirTOX?=
 =?us-ascii?Q?TfD4TstJ5TXCCx5dBceFnuXxkMS/FPvChC5oSCnXzZBIJKJvgo1CEZHaDZ9u?=
 =?us-ascii?Q?hNgtjXT7CAzrjqkOWW6CJtBu/chCrtYP8JDM8Lj+Y45xPnKATzLCUTFZz/6b?=
 =?us-ascii?Q?WWB+nq2i71rqyhaFE9gGMtont1fnL93j3HkiiVc5Z6/DT2M+lMejkgtWoyys?=
 =?us-ascii?Q?WPI24jdSQDe4W6kf9cd6D4R0Ahk+ONoUqmE9C+IQW3J9JLrVq2eXeqe9Y5Vk?=
 =?us-ascii?Q?XNqjWhcrFD8iZDWkrt3YajSoym4iIJkgFDjhSgbY/YDZ8EX/NSrT4zUrp1P7?=
 =?us-ascii?Q?ezQyDmSVykWHM9WcG5Ftme7/zT3baZBdF0S+PCVD2JQ/7lYmiMwKP+xzRpVm?=
 =?us-ascii?Q?6ddwV7ITWHJZvOEvrzkxAefnitdAd9XpltprrcBTuaeAwg4ZJkDUC/KwhPZ0?=
 =?us-ascii?Q?2A3SWT0iPCYjjQxg8Z2S5GO1lkoa/4fJHG5yAnoUU2y+e4DXMMWFAzxZB40s?=
 =?us-ascii?Q?c0/UWQwcItM6QChffAfG1W5PWBDzZgmgYfcgLRf4EAOUiochmrhwPLaEn4OE?=
 =?us-ascii?Q?+Po5HKwqkzz2Iga+uSdAhqoozTYbhPVHC3iSBv9qXY6VQKSHbJ7jW3YOzU6a?=
 =?us-ascii?Q?MC4UKybJz8mLMIkD5gQll/oETvQkQhc9kxSBNHhMb15Cm2g/PcO3knT0pC0B?=
 =?us-ascii?Q?I1b5E6OfJm2rs70kHdEkvVhStQdwbkKqCQ4Fw6UX2UxQafBFoXZ9JDhYD2p1?=
 =?us-ascii?Q?7/LqmAXONSIYYr7NT7C3DlHx0xtRRbSGeSi4/xaf0e9Gd4H3qMsKPFG9ja9d?=
 =?us-ascii?Q?oXe42/pf26QOGSGacyA2rzz/deYasVWIsnGTupuIwtsz7HaEW566AypbgkRC?=
 =?us-ascii?Q?jWJEhn7V5HH8Crozw0VftF1nNTUG5tIkWTbrqm3E7LAUVF/abczgdwnVk0d/?=
 =?us-ascii?Q?Im3Z2qXHYdi1ZX4zTcr17+kGU2jEMW4hhvyyU0oh/W6+6r2VtZnenAdokquv?=
 =?us-ascii?Q?s5neKZuobaiQplB/HKkqPPmQy8Id4nEuAMcuolQOCxgcjPEei05nofuK1dBm?=
 =?us-ascii?Q?8GNiySqnewNHmnm3vo60iY53yeq20MCKSdfY2dxZcKQ3PeUZqVZshjvCcdEa?=
 =?us-ascii?Q?or+pwIK2z19dxkzRtG/SU8v0i7cNCPgR7A+RmPXV5wC8XDjWOgYiB9c4j512?=
 =?us-ascii?Q?Y8Dy1fPaToZr8qxGZEcLeAyusurXMf0281vhcDadLsyTIGDloQ34kIEm1g3S?=
 =?us-ascii?Q?FaTKB1pHt8V3EQU8HLEqgcxqReTontZ1oFrNtczNQz63zpiohyyMHdCr8gbU?=
 =?us-ascii?Q?YW/VLf3IX9BQGezu216CHgaSeMQeYm3cBtsqDENpgDzoE7fxFO0iD/HW/kKt?=
 =?us-ascii?Q?DDx5Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UQYkGsun7CsZc7YcexnMpSgZ1DRmCjHz2lwTRq/e6MysfI4xTwX9WSvDE3u/am+mcO7dKLoQZ18noACvDZ2s3v7DDAGT07ciPH4M4AyWA/Tr2oI6MF/pmiEVT2gTBkJ6fT0lmd1WibJ4hrlMr9XL2eUAVCuD2ydGtTaJ9u9O2c2DTrQEccWLLQwb7UduE7XajSn/5jH8UTv5RBi6vgHx2f90wy5jvTi0bvK8zYDFapivn+6likVReX0SJr73jR4uKMcJ05abX3sqr8h3H3HU7FslV3iGeDMHeFZQJWf+5HdeGvaCZfupe13JKaK2ZHkz3SaQyu3SMb3ok7h8/0xPsrW1HZkBmW/kNM1T+KY+KrqaV4amDyP/c9PrF7Du5RyeVIISepGW0eDs1p47SVOtPGJsOLlqHUlAz76/J8FvjRgVX/xCj0Kcilw/2eyKgBsEgswHvZKMC43L4B/ROXTKJaG7ssn1EgRdfb6gCTNpQAv2n04blxkk3YgHxnfVrFzcKM+Z0DDgl0BXO+NgOGIXadUV+V9BVICsKQRbueXKPhz+24k48js93WShme4vPL6EmpF8W5FRtpJyj7oUiyuMmLtr84SKbW9D98obXlgTp9Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15d9951-c973-4626-ea82-08dc4d180c87
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:06.6103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hB/w8VoH/wZsW43NzL2nXwu4iV/QXMh5ee3z+IjPSkyNxqymOpA5c4CNW400T4Br/wHHjjKG59TCfgxYFhdqFEqGlkyKq6X/fdNTKMwUmB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: Tzb7B5XeGpjPjsiTxVG58wfefTV76BNE
X-Proofpoint-ORIG-GUID: Tzb7B5XeGpjPjsiTxVG58wfefTV76BNE

From: Dave Chinner <dchinner@redhat.com>

commit 0573676fdde7ce3829ee6a42a8e5a56355234712 upstream.

Alexander Potapenko report that KMSAN was issuing these warnings:

kmalloc-ed xlog buffer of size 512 : ffff88802fc26200
kmalloc-ed xlog buffer of size 368 : ffff88802fc24a00
kmalloc-ed xlog buffer of size 648 : ffff88802b631000
kmalloc-ed xlog buffer of size 648 : ffff88802b632800
kmalloc-ed xlog buffer of size 648 : ffff88802b631c00
xlog_write_iovec: copying 12 bytes from ffff888017ddbbd8 to ffff88802c300400
xlog_write_iovec: copying 28 bytes from ffff888017ddbbe4 to ffff88802c30040c
xlog_write_iovec: copying 68 bytes from ffff88802fc26274 to ffff88802c300428
xlog_write_iovec: copying 188 bytes from ffff88802fc262bc to ffff88802c30046c
=====================================================
BUG: KMSAN: uninit-value in xlog_write_iovec fs/xfs/xfs_log.c:2227
BUG: KMSAN: uninit-value in xlog_write_full fs/xfs/xfs_log.c:2263
BUG: KMSAN: uninit-value in xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
 xlog_write_iovec fs/xfs/xfs_log.c:2227
 xlog_write_full fs/xfs/xfs_log.c:2263
 xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
 xlog_cil_write_chain fs/xfs/xfs_log_cil.c:918
 xlog_cil_push_work+0x30f2/0x44e0 fs/xfs/xfs_log_cil.c:1263
 process_one_work kernel/workqueue.c:2630
 process_scheduled_works+0x1188/0x1e30 kernel/workqueue.c:2703
 worker_thread+0xee5/0x14f0 kernel/workqueue.c:2784
 kthread+0x391/0x500 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242

Uninit was created at:
 slab_post_alloc_hook+0x101/0xac0 mm/slab.h:768
 slab_alloc_node mm/slub.c:3482
 __kmem_cache_alloc_node+0x612/0xae0 mm/slub.c:3521
 __do_kmalloc_node mm/slab_common.c:1006
 __kmalloc+0x11a/0x410 mm/slab_common.c:1020
 kmalloc ./include/linux/slab.h:604
 xlog_kvmalloc fs/xfs/xfs_log_priv.h:704
 xlog_cil_alloc_shadow_bufs fs/xfs/xfs_log_cil.c:343
 xlog_cil_commit+0x487/0x4dc0 fs/xfs/xfs_log_cil.c:1574
 __xfs_trans_commit+0x8df/0x1930 fs/xfs/xfs_trans.c:1017
 xfs_trans_commit+0x30/0x40 fs/xfs/xfs_trans.c:1061
 xfs_create+0x15af/0x2150 fs/xfs/xfs_inode.c:1076
 xfs_generic_create+0x4cd/0x1550 fs/xfs/xfs_iops.c:199
 xfs_vn_create+0x4a/0x60 fs/xfs/xfs_iops.c:275
 lookup_open fs/namei.c:3477
 open_last_lookups fs/namei.c:3546
 path_openat+0x29ac/0x6180 fs/namei.c:3776
 do_filp_open+0x24d/0x680 fs/namei.c:3809
 do_sys_openat2+0x1bc/0x330 fs/open.c:1440
 do_sys_open fs/open.c:1455
 __do_sys_openat fs/open.c:1471
 __se_sys_openat fs/open.c:1466
 __x64_sys_openat+0x253/0x330 fs/open.c:1466
 do_syscall_x64 arch/x86/entry/common.c:51
 do_syscall_64+0x4f/0x140 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b arch/x86/entry/entry_64.S:120

Bytes 112-115 of 188 are uninitialized
Memory access of size 188 starts at ffff88802fc262bc

This is caused by the struct xfs_log_dinode not having the di_crc
field initialised. Log recovery never uses this field (it is only
present these days for on-disk format compatibility reasons) and so
it's value is never checked so nothing in XFS has caught this.

Further, none of the uninitialised memory access warning tools have
caught this (despite catching other uninit memory accesses in the
struct xfs_log_dinode back in 2017!) until recently. Alexander
annotated the XFS code to get the dump of the actual bytes that were
detected as uninitialised, and from that report it took me about 30s
to realise what the issue was.

The issue was introduced back in 2016 and every inode that is logged
fails to initialise this field. This is no actual bad behaviour
caused by this issue - I find it hard to even classify it as a
bug...

Reported-and-tested-by: Alexander Potapenko <glider@google.com>
Fixes: f8d55aa0523a ("xfs: introduce inode log format object")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode_item.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 127b2410eb20..155a8b312875 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -556,6 +556,9 @@ xfs_inode_to_log_dinode(
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_v3_pad = 0;
+
+		/* dummy value for initialisation */
+		to->di_crc = 0;
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
-- 
2.39.3

