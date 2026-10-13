Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07DD395AE4;
	Tue, 13 Oct 2026 08:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879227; cv=fail; b=UsXSn25Ig7P6wynA3oFE/dTXDPC5q8AXamssFO8NlM8uSNFoMyGIbpwb6TZIOUWCKA6vwGRfKYO8gR+8RTF4I20D5b9IZlnRe6NC1VDVjkc2XTQx/VqCDCFIwJ97zK4mrOVrhCy05HSe1z2oZtVIubkimigctYn7htsHUBjT4VE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879227; c=relaxed/simple;
	bh=Ta9C8A3fQUG9IwyVp5h7oozBz0YUdeRc/0tkVZ85EkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gg1wOPFUg+3YcFmPMQ5OwxA2aeu9axOGcK5cV75X81XQfiRzxRs7OWSAUvFExJojiy+2BcSlF7UuwK45lkFAU+ncj5Wd77A0HKCZF9mk3hLoAPt0hFYTX+HoGrh4gJ+3XBRGUsILPHwYYf/ht/jwyxiwlKqyTB8ze0W+CsnlrBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iQaiQlj7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=si6ATlgr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iQaiQlj7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="si6ATlgr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C4H41440146;
	Tue, 13 Oct 2026 08:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=InXX9gEgY9Fe1b2FBhTvPxEhzHF52A2U98f2CloKp/E=; b=
	iQaiQlj71oN8m34S2pG2E5JJpFDZXQTfzIB8qKssKDU64gad02RDSuxq+/M+vq7Z
	no7YD402/4y3FWZiZR2egJIa+P7dpt3L/yi5z9z3Epy1Xpmm5mO3Bx8eFB5VvMqk
	mFqS6t3ul5IyXwLWKg2/9ETk5P+axUU28okyIHz0Ha7SunqNLDXX/adcJt8hDI48
	CMCGuPW2qtf4CMk/Y0zmTvPegtT9lEnvKWyQ4URFKilKx7eBslWnItOXx7YHzZAh
	bIglIePuaGEBEt0Gne/6NCAR5RNKgB2EU/ViXzIwqvSL7OvBSSsRjtUWuHjCGoWb
	PzAvXkxLZ36cXGkAvAX06w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86j0B020877;
	Tue, 13 Oct 2026 08:13:40 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010025.outbound.protection.outlook.com [52.101.201.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjseuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZTqKKoI8+g1S3dhJ0NuUiiaisM+T7LPVLryQvXXYsA8rATpZtX9oWs7DTLD/IxLAfyuKOsW4+QTX7MtRj7dCKiO5LXv0UotQvDXUUtUww+N8gTcqfSz+qIeGVn2t2dObuXJeBoKHCySZR279BPORXKxovglicAqIwVlFKi+cu8gMOA7UN/1NnNzolOc1aIVvRfezFzITVOFwEZIO6UIYLj8Fx0Zuw2OSZFv1J2HUzkS8V5U4MKlg9UtU/eCsAkm/JeL1JTZ4Pyo6DPCuDL+jtD6Hb1f6bkCVtNaDuP16crD63ErIjgCWb5kdH4g91hDX1Bk7Bju9ZyFXqz6S0R5vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=InXX9gEgY9Fe1b2FBhTvPxEhzHF52A2U98f2CloKp/E=;
 b=yBG94zO6VfDuEpZC5eF+83/MsXiqwWQEfMSkHElTygXTLztgKLDIXXqrjiXJMhkLpE8DXTzMFJvhxrqZLx2ah5eGTOfA0tZ5/5tS4i7Pqwk5KH4tRIIgwLDBBfGLkJCB062IHZlw2wYbNzSRjQBjCLqSrJQ4o8eten1tH7U2CTey6WxhafYuEGPmEc/azzmiS9R9rlZRy/tFKL5a7Qc6LuohRcpqUo0OVxUQlmwWbfwWU9O50Zc8QEzo+6llzB59PRde9CEOhdV9I2MBJbyVHLFrlfUxEMkZQQLzyXw034rcfEg/8EsBgBtdjjV7lcLhcA8YwwYHYGHR5wmHLoAlKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InXX9gEgY9Fe1b2FBhTvPxEhzHF52A2U98f2CloKp/E=;
 b=si6ATlgrzNFBwFy52RgyH+P0tyXPM4EogqZR3JJdVt4WcLqLh5JSWwENDHPrTU7Tf6eB6F8d3m5LBZetR3lmljnJYQuJi1nvANoEZ2HcJHSm+Y2434jBXQXh06nlNPMKVFvSon+Mn4nfZoa0mv80lochajRC3sobYn9QrmkZR4Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:35 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:35 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 v2 2/5] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 13:43:17 +0530
Message-ID: <0986e23e93ebbc44fee07cf4822eeab6e67d2b3d.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: aa8df0a5-3f06-46dd-ff96-08df2901e04f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|5023799004|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Svpyhp4GM/tVghmZ90LsMYb96+PVpEhoxRg+ddpWmT463RIm5aq5cb6V+5jsXUCz4mGo0A1S5PFiFUje+b8yx4kihEZqFiTbBkcodGdKiKjyzDt2lziH7yBKpSxucIM8DzC+CZYZpRN1NFfn9SlmF4iSmhBPzkqnuOALZiNMs9kpV/MmpXGuKoBqbWsJy4siWbinOGB2xpQUzOmenHBHbDkJ4EjBF1MK0Dv9g74Cdauu7hwZD0q7ujejz3AE4LJd0FKLUu893LD4Tp6e7H/fP91GHfLmEM5Zyj7IhIzH8IwSHM2zNFzkQEywjL0XUisQtHOCQ15iLrVvQtBpg/TRS84AHAxydmi9PkPaSyC9hQVQE1IaXvnvMLbV1sa5UDT1fTCUXgXQEbs7YqxGI7pTC5XRYj3DDr1EGXlzRwR7fndYEcNgXT9Ls0mRYEixGxcGxQYnowj6LvKEWfKfcVjQaW0jSRNg9Sdd4x0c29rEcaz91DDspCSSCkqDJmg7ZLkBOLhHxnCFbvTXbUAMO/jW+Jttau748yjqbyn0WA7FP9Jjj4VqH/QzVvLP99c+PQknSyfFyxkOA8TLU3+2+41+MbaLncgAZTr5shV8WGHrYCwrPfqWieelS5Wy+6lbsegR7oGwzw12wWbAESG/w8+VGpKXvx/B28vXGAynlPDOvPY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(5023799004)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tu7AEFvSbvEXRyScvRWR/HrsYdqcPpF1kWqldZz6/67W0u6xS/cUtgCfTTGb?=
 =?us-ascii?Q?kBDFSsibLwnMFkfKeEoaEswoX0IIKbqELJM0EkFH4ckEF1EnhG/C43+wFla7?=
 =?us-ascii?Q?RP2SzQukdoVOcoj75JGF7J3kNM6zNgfssm76By5BcVBaK9TfICo5j7N+2v3Z?=
 =?us-ascii?Q?tlLgg/xwB7RaYQu1J5VrCb3Ek0V4AfKlRDO+uonrVooFhtY23v0aoCtzWr8x?=
 =?us-ascii?Q?ALsi217BjDnTYU5LXCxKhyu/1tf9U/xWaApw5b8ErFiRspod5Fb++gv9avWQ?=
 =?us-ascii?Q?V+Csh+GM3pksOkcpyjYC7ZN2P+uHVQVeHQFV77TY8BIWsdCQSN1hvHOc82+R?=
 =?us-ascii?Q?JHodzGFObak5n84DYsu7qfiCBYk2NC7luMxWYxblIlbBq5z27mL9MkPMlblk?=
 =?us-ascii?Q?QOLNzy0r+1dUUhICB20D284f10yr1MvpPj3NVInANPX+5L4bfUGgDJnlhnyc?=
 =?us-ascii?Q?tFIO5W2P52XEaOhOE+QoU36816L+NIh+4skDw1+P/3OIGp2uClc56KZyYYzx?=
 =?us-ascii?Q?xe6YlAZY8fK/jOWBjeR7iCEEWKpTC6f8ppEzLhv9ICdvJtuTZd5aUHNxwBNl?=
 =?us-ascii?Q?b6EYWO0B1WJweyAbPr8nglaFDVvokOorOzCbWeGELo9lA3isyM/LVRT060t1?=
 =?us-ascii?Q?SSqP67WBv3avevgpdDKmXRRIwTcvjh9wKjvBK+Pyb84MbO8G3UNHfyo0EKC+?=
 =?us-ascii?Q?t+jwDpV6LMPMQOfdlWYcK7UcetcBe7JBmFSIRFagAWvewrZTvpw85R0E3cKt?=
 =?us-ascii?Q?6++NiU9c7qG5TiecTFn2+4acRNx7bAovPbF5O48yQ/srolMqyKb2o0mmulYf?=
 =?us-ascii?Q?oY/f6/Bmc+/0UcVkKvBMKp41x4MyMJpj1UjNIR3+LmVxF2+u/lbYAJlgr+dN?=
 =?us-ascii?Q?UfrOFw8I5Ycjm9wjYbvNwl3FMt0NAf+dC+1sHq6zYU0Yk2gIko2r51Ra7ynd?=
 =?us-ascii?Q?GIjEV/1fhAD9xudkFUfKhtBjKlkyQlG3lhPvzu6DrrabkqhSosEpyyVplGvB?=
 =?us-ascii?Q?VbxngZr90s3fZxdapWjeQRfzvDQQKePi9+GODNrgbhDjMUenohRs4ACm0UKw?=
 =?us-ascii?Q?pOggWXy9KQU0OcLJJz+P7oDvYtdyjvQiC5/cuVInDTfRF97+9CYv2n3q7Igb?=
 =?us-ascii?Q?tYC69ji/8Tb68N0yUZRwcvvUfyFVK7VSUjPNuid1L92uxA2Nm4fr39e4V0NV?=
 =?us-ascii?Q?l4UAI191DqYqu3+/oNxOLVkCW1fUsC6mFZ61bDkS5YbVPRupQJ0tDit8s5HB?=
 =?us-ascii?Q?P24hIL9wowbyzfHJAN+48qGg4YCYgnE+/v67kDRkwWJ8bcp8XKtaveSC+PuZ?=
 =?us-ascii?Q?9H4fUvaOMJle+eFaunN4LpLy6W1DCiXggwKa4Bum+LWoJDI8xEEr2/MQSLC/?=
 =?us-ascii?Q?cSDD7wZxRHHVlGniRGACemtdWrQJ9GwCIcMUqaq3twrRGCSH0S/AfUVYTAa0?=
 =?us-ascii?Q?Ba97WCFc+fsohDkEvxP+PpH1qjF6uZCk+VWyBx2FLFwUQ/qryALMd72XAYhY?=
 =?us-ascii?Q?lkwZJXiIhAUW03X0Z/rSfUvxh8bbaEkVgoBw0dI5MUxRGsTn4ASP5Igd2h2z?=
 =?us-ascii?Q?tW4Nf+6H5ztBxQq54TwIZq2S8tMi6XBXt3CWwYW/vdXmsnptm8D3ok0V4lMf?=
 =?us-ascii?Q?gxGAt63kGHXzdPGOlzqKBCZ7J9wHbTlx6kawu509lpVG2f+XvR8mbBRVui2U?=
 =?us-ascii?Q?MBkbgJpxTI10DvXIIoIhPDs4oB8ALzJ8cbVgVmCp8qucjds56ztndSDGOVQI?=
 =?us-ascii?Q?lKLHLbfZan2ffiYsfXZKI4qDfwgaiZ7HSVES8U62VzLB4k89QmcotiYJPQSa?=
X-MS-Exchange-AntiSpam-MessageData-1: wz7Jjah0+50VRR7tGsZWOHu+iD738W+Ma5w=
X-Exchange-RoutingPolicyChecked:
	0KQkAMwI8i55Fa6bdymZ55Nx/OlMQD6uwbpVeJnVd2Z+35n/CbDjlNI6z8weWUrLxHTY4Gk9njtKvsrYP9zoU4kytSzLFdrKSjRR5/ELpqouT23J/tIFKAmbAyqbdI6gELI4Nsj4bB6figF0rzdWm6xxXflAVwGur84cB53kCS6r1sAb9a09fgcJuuOCDx1f4FOuljdH5V7kQg2yirwqK2Pxa8ZASfayqZ6Ah5wudRC9lvuuaCLK4R4y5XAPQxUsXyYylM0hW0Aq2wySgcINxUsOl9JNfYRm3M+i8xVGPCW8MR++E/jY6gS7tupfrMeYsLB/RRfw6ZsD81gLC/L/2Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+9qvIfyW+s9OWZ1a/ZwMEJ7ECGsNc/rq/kzUaLBsRT2GvKIOV+wJf6ilAj9xhG90+4J0uANZh7aG4dFccGzCddhEfu+kA7bOvFMgkYA1gEaFdweueFaWQfINzwrsiQyUlKb09PCzR9ayqhavH0Z3+f0R7BMZedfLGf/2uNKLXhkzOtF58nTdP4uxETfxL6J2nJM1BzdY58Fx8z1A/pSNn9McDa+nA9G5nbCasNpKac+VKlQBhUwyzZ3zRxrDzwsNPapK2F1bAl/mrQiPa2RNMTUUDSpvF7BNUxhmDEj9ZLFxmTtS1SuDEnxScP8E1WhA97FPxqAs/PDeKthde1wj/GSJsP2DO0jIr0kRzpFC0YveH1+tWKhl3bpDp3tchV0TS8wV51+E/0JERCQFk+VhOqTdyT0bQ3NV+HAEYbAhEGu+RvJgxb8xZ7MgGfBjo0VVMZ2iWD9qeQblenli7gToIDVGiHuKjIsNQnV4/HHVvU6LwdqKDIB5DbLGKNu6wMwsdIxVcka2bf0Bc30QWpqiZq7YZG/JsNfwp/Icq978izcIZ1q2c+erO6cdQL5t+2beWE2dH6xOBZAF7mWT+06ckfG2CBxm1p3UXccsrUTl1G8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8df0a5-3f06-46dd-ff96-08df2901e04f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:34.8136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMVF0kRoAaRa6a5GpYeZzaxl2F3kPz4PMc66FWxmaN7Fl9zFT9PEk94KDrgP1kEzCRnMV4xpyDYFkAHDkhF748u/jaJzzcjQ+vMA7f+E03c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde835 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=2l8DqRWQ2dbnbHYYE4MA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX8JeUEwvD4ifi
 W25xhu84BLuREWSH5rPfTx8J9cYn8qS76h+5tXsujvXJyrMKVA8fLf39ChAGq2nfbh2edJDXrQx
 U8rDDAYLAOpn2colziEZ4Q+gqsUyYg8G5o0eaAagDDEWaTQuWF1cKDkOaApcqsQe7AvFIjUxATN
 RiVrN8IWfNtEohd4S6z7DhNb6L4ZqDu8t9LAinmaYnBGQ74ntpStjkI0weV3WTs1YI6onslgqc/
 y0JCJWjY/LRKsS49NI/KgEMUZiUwkU87SeC+87viQa6SiY81hIQRhhtC2Rm9988NoEbSyDfdifx
 6iXbkE3xNcC0XrfnDCnx2FnbwKDl7XwCqa0iAKy3y5/46rNIBeFZ+8saddf69RELPvRcIit1kzG
 3oxR3WhDlbQ4FiT1ig5XLZ4Ulp379wOnL8CI85et6crJum2R336vDYHbCHo6WnruKOqejxXSu+U
 cl6TWWa1FFQqFiAS3NLw/LMurcLyw3RQe4ms4M7I=
X-Proofpoint-ORIG-GUID: PaEGTR3J70cbmeSK1DGlZhFCmuJRJkqA
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/O3eRrpp4Cqo
 6w5FmGqY8hz7IV7Uv3DctS57INdtGv2+VMurmsc9YUjEOoAiiOQ1wb/usb+rnd+g1331BI1tACv
 urXxYjbyTqgx559Qn+0kSPFctRTBukCzFm6ftx8+bgsK/aon2Lbh
X-Proofpoint-GUID: PaEGTR3J70cbmeSK1DGlZhFCmuJRJkqA

From: Dave Chinner <dchinner@redhat.com>

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit db6a2274162de615ff74b927d38942fe3134d298)

6.12:

Fixed conflict due to the following missing commit:
	e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")

6.6:

Fixed conflict due to the following missing commit:
	e45ea3645178 ("xfs: split the agf_roots and agf_levels arrays")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 46 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad2fa3c26f8a..0383216e39dc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -3240,18 +3241,43 @@ xfs_alloc_read_agf(
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_levels[XFS_BTNUM_BNOi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+		ok &= pag->pagf_levels[XFS_BTNUM_CNTi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, agfbp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
+
 	if (agfbpp)
 		*agfbpp = agfbp;
 	else
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b83e54c70906..dee46010702d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2634,12 +2635,35 @@ xfs_ialloc_read_agi(
 		set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag->pag_mount));
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, agibp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	if (agibpp)
 		*agibpp = agibp;
 	else
-- 
2.53.0

