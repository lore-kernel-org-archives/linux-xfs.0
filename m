Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9A01B85F7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657116; cv=fail; b=gNguUPc4Eidf5UsWHF9mF2Wzm3f0Za/E8NwCOoGROOO9fGS9XA9/OOm4ailiQIkgiaKm/DVQWurIRAvOQPq4D9mFJkkm3EIp5r5QF7eUpB5ByI8pYjl3F2FFxWglH+W7Iyyf6Qp0hM+st4Ceao+r1+1IH9dMcu1jIKt5n0b9Zx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657116; c=relaxed/simple;
	bh=KSjrrTGrhQiHnnlmkki1cmNpGsCdMSYJQT7e8zwxjNg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RNKOOedU79b1RZ3mM4N+sTwwda2XQOm2fbgk5DB9PI8Kg9HJSVVT7sK4aTd7qbZsnRo5IA0XBJ9Fv5EA9GXh3zs5u4h2e+l7ZJWeQFirK6kHDjkzaVEnStiCxY2SDfzcI+9DaoSRiktiZAd/e70S2rvesqfY53Dzkw9uSHHVeG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HBO4S5lI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pJj5Izc8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HBO4S5lI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pJj5Izc8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXX0A010226
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=hW1UoPWZ8Y1G+XTsn5QdpDYFaW+S8YoUPr86Rd1W7JA=; b=
	HBO4S5lIFHvZds3qyourLKdQYIz+9Cmb0tyR4GcEj1iMeVb/3Y9wxSMY2NsNyXEF
	ChyB+7e/CUX/QBdvTNJA206ewPudY0YBPZCPA3B4yDC0Rge+Mj5CiyemhZgwMbDY
	Xnr+AQFsawTTjyuC0Mt70JWWSG0znYR4gz+AkT+4LPtVr23j2GMTJuxUYVV3NXKu
	b27uULFS6c+v5aPoXMBWj5CClj7jp1ppHg15xrlz4OXYzHHLJLOqSD/Okhd8qqAp
	7g7zW58xmAcpQTpdiHoyGrWC/cHklMSnCZb90rFuhsKMtBWLnB+FybYHDKn2iNyv
	H1T0GY0KyJS6Y8KSpvlJqA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwjjmsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486Jk7gB016238
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjeyu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDCD4ZkVer2vkUk61n+IIWuEd+e6Cem/wI1BYGHk2TimuBZPo8OHrXRQzesXhtNSCACpCxrAvANG+X2LYUtfXc+iWLuWtCkYy3ZkRyJ/L2vZbOdmidapgqc0z78JPvS60j+LI8u1GXfKH4qJXFddb8GTL4lbB7wO0dd/8XGh6MWWm/YHWuNywU0c6BCdAkMZLv5LLWrZcdK5f6lKfPDq5TPUkT657TaesdA0SLn2nmbT0MZ4cGrSm4ZG4qd19JuEcqP3KmgwIaaaoHIL/vlN7OhbEjvLTl0USZXr7eSdW44wDbT2wvjLUanLrSPH7Yg5Vj2y4U47+5OUU+kjMFlDnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW1UoPWZ8Y1G+XTsn5QdpDYFaW+S8YoUPr86Rd1W7JA=;
 b=n1vtExj5rRqpeOSv2w1GRvm3AAHSn7NeGmeCYJ/Jr6ItyZMb7aDZ2rfGmBHjNu7iGEm5FmNF+LFZt6jEYO4bX5u/VLR/GYOcSNijgmx6gHt0gVIJBqUUsr2QZuNhgkB+FwRpdc2E98KfcdE8OjgGWt6HB7vsZXdtIO1BeIc+5SLaBOL+++gwh+BJC7k0gwlD+rbpxdRZLI56GQZKZABMdQCBIpJhq6WrGCxs0BawdlH4J7Mz+6uPwXjpNAW5fdNYKvauFkjZDpzVObs1R+mQKzQLDqWuwboz6z47+TN/teV0TXJzeUM7bTAuYSELEOkfk+SAQzt4IGyoRfztnYpYjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW1UoPWZ8Y1G+XTsn5QdpDYFaW+S8YoUPr86Rd1W7JA=;
 b=pJj5Izc8LrFXT7ZeIJe9s/Ow3AFxCuPUVfAZdcM+W/9SLHdZlablBfGJJ4Dpc+sFgiJ+cI3cmSlgTgW1cvys072n++YzutdDfCzivRhTOG8/wQkRTB8PDYUjoyskl2bigNLbE10106Sb+CEyTLA+kd/qR64Bs+steqQmUE6t9LY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:51 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:51 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 04/22] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Fri,  6 Sep 2024 14:11:18 -0700
Message-Id: <20240906211136.70391-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0127.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: d57694f8-1fb8-439b-d62a-08dcceb886b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BJXBJRvWxd8KBWtVuOiCBnFxvM5jEGpaN1NbGAOVLJqXXA0EFVkIIJBITIlU?=
 =?us-ascii?Q?Z8rlMtW6WDHuE8e/F1wAWePyC3OUEn56E6tR6A87zc5BhXqReS7jikjyE3n1?=
 =?us-ascii?Q?9r2F8RgcNK+z9DyYd9YiNEJzT5sX7aPF9h8KxVH5M+XxgOacxPlZ2hq+A/Yr?=
 =?us-ascii?Q?qmuApuKiLDXOuaYkplo8hfc2kcyooO5adf/SrgrQkXe2+DqKBtlaXadHAFve?=
 =?us-ascii?Q?zcGIouB65Xa2n7R0eMlcLqFf7/XL4w0bA8vWartUKX0lq+gDnT7GHUqlX6su?=
 =?us-ascii?Q?rZefZIiTw+CORrrVBf81V0sBJBE3WX45C0AU5d3v3TXAUMau6k8EQ6CtIAi6?=
 =?us-ascii?Q?iqODvvrZZUS0MF5t1HYlenEUwYYVwL3OmQ2oXW4uukL709cbD3SaDYZ+SBvK?=
 =?us-ascii?Q?zYTxtPh5h8Q47w33powge7kyrENHb66JBZPLnUuCJv7nY23dqeKnFUFAHqg6?=
 =?us-ascii?Q?PRcLxxFBLwhKNbJtozHe2k5bW2uiv1B8DtJkEzHXvzEkJ1RiL9KBoK8JvW10?=
 =?us-ascii?Q?QS9WlQ/4pnEMipcbRiNvz3MON/8mJjIgpve4wrJnSiYrbvS/tpBmQZWjo2Ha?=
 =?us-ascii?Q?EuWRxWQx98cmVA35cmmrBOsjT9PguPclItyfL3cB0ZmlwW42V205G1n1f5gX?=
 =?us-ascii?Q?zvHo2ta55CXnhb804FmLXwnwhFqxz4exHl47Isy10i9/bTHTCXwnN35LaLRs?=
 =?us-ascii?Q?aoy8XFk9y2JwxV2IFySYX9aWDL97Xq1FjaSClYhGNqLWIBOC2gk/MFNBS1Sd?=
 =?us-ascii?Q?ctNoIKHIzpQ8dP86O3jHD+q8c0D5PX8q5nMfdFQ8zhIyXDv6cEQMz3t3wbNC?=
 =?us-ascii?Q?SaN/cykap6C3FOlomd+8MORxYI1TWU3HMWm4T6s7PIL4lZOtd7lWflMtlnxX?=
 =?us-ascii?Q?+ngkL0qowzb7I24A6BbIxqsplkySBKMxmodRSwsWnOy1PFP71nn6RA8VP2GH?=
 =?us-ascii?Q?HuKU2xK2lTF84EtezxHllK1qpo6nwOyF4suC6RPcsBKlNSrJZZ9k00NWrp6M?=
 =?us-ascii?Q?ji0wvQkFoLvdvEOYpbHqJeodu81nTnfxXPVIjQcx0cUeGIdbw4fCx9VxgVpY?=
 =?us-ascii?Q?bpEXNGrpDQkmK9LVDjNKnMkmLx6ZWr5dttOPowIYctX8m1OE5x8TB+iY2iu3?=
 =?us-ascii?Q?7C/w1wfCTIei78j9fvPLvCbOdL8x1+r4d7dkId1TZqUpVCXcMNx7eWUzev6i?=
 =?us-ascii?Q?BNXgrpvB2gva9qn+qPAsG97IGyC5De4jyJsIE9a/alLGZtHhYmy9nv1jVIjj?=
 =?us-ascii?Q?P4mTHx+zFqmPHuua5QtapKaBB1pjlq6i/tGsdUs0ZrxqoNOEE4EYm9sGJNpk?=
 =?us-ascii?Q?eTh7veeHIcU6dZO7M0YV37q/kGUG0EtvVNzbE3JLaK3w3Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jZ7oOGpYrQdAyucRq7TEOZkyd2NkD/4yUoSnw2r0cM487P0YC84nGGacJUAC?=
 =?us-ascii?Q?vfWJ56lC1URhlHpcl5LlHjjrOh3hJ/ysUalTqgN445R1kJEtCgG66ZvQoadt?=
 =?us-ascii?Q?gJM21i0EF3i+DwVoSfEq1wo/NfbrTMmcP2U0ko68EHZAHwtqDuej3Uixc3qs?=
 =?us-ascii?Q?0dQTeqZk+k2WhWuDhGHsMjxApP9qfCEqK6/Ri6/dH+J8/NWW/VzkQxc78NQI?=
 =?us-ascii?Q?2YMS6/1kSAI6OAFyEU93CpRyhYPI/Zy32cNI9ww09TmmiRxE8gOG37w+MN/1?=
 =?us-ascii?Q?owrIOHwEdST3Z/u3kfSHNjx/iPT6cOs4ULaBgDsvra+eV0PoYbhNmToY53OU?=
 =?us-ascii?Q?uCzRsLoauZGehjWKepgXcBw1vYHDpTjLo/MTVKy6lss9glLlrLLwez27ZEu2?=
 =?us-ascii?Q?9RnwYkxNYkkQqfRQ9i+hxecyqBdf72qO+lI03T+LfOObfSzY6X7+i0NjW/9k?=
 =?us-ascii?Q?Id+SX+O3CzylHTNNGHwGtEwzLiqXJikYKmrEt4k/LWRxtuy+gZ5hZFjtbGF4?=
 =?us-ascii?Q?wuf4ln+NAlxO8ROyHRWmrAzXNC4EqLU9sdIJotZisE6G7IurvSVTfxtBfOqV?=
 =?us-ascii?Q?p88xAArRA3LueYb3Xqns59+ZNCTTbdn11PmgHde3IWEI3GLktIUQlgWdJ/Fa?=
 =?us-ascii?Q?nQREwQ89xT+/bTFrfzG5sGQm5xbog1isxyV7eR8z1RWHpSns2iCsSy7zz4Ow?=
 =?us-ascii?Q?oUorQ++BMhoh7uGRyhvLUvYyZUZRAiXavtA3LPLq/QRRPYDdsG7w19QDRyeJ?=
 =?us-ascii?Q?KT8jSLiEqipTHLdg7uhSwM7OwvGjqdGaxwg+wAjLCIgeYQKqkvVuT3goT+lT?=
 =?us-ascii?Q?bgSdPy44c/NTlsb4MO3LU4fD9+FkqKr5gppE7EPopiSeehPdCbegnY3DOTUp?=
 =?us-ascii?Q?Ppk0x8koK0/T2/O1DShn0NajiA8LuBiXne0jjICWmwCmbousE/E4jkuTcnGV?=
 =?us-ascii?Q?bURJjioekU/36zIkUvvwWtDJ8s1d+Q9HXRU5I2J+BYpHk0J1fIiTW5/CvxUb?=
 =?us-ascii?Q?cIf1MFLexpmxZkhjAAu2y5wQdqJZ4ZfSksmf8qlbUQd/+25HyIMheh6lqRQU?=
 =?us-ascii?Q?tx52EhMLBqiXT1Ho0I8/TjZUMmwl/rJ8SenUYGFb4bBonbP1alh5LfJJp2Zp?=
 =?us-ascii?Q?lzNU3p00qgQ4zwSdVrPYTHX5O//TUbw2b9Os2WkGY0np1eejt5d/MY7ZnmYl?=
 =?us-ascii?Q?EwxxKiTtaTpusUhhUmlaZXFeuezv+H6useYfMtirw9xkYtWUIsPrFDfz0R4c?=
 =?us-ascii?Q?X0hGVH65IxcyNxn9Pz1QgCgkgVZOs7DdhQfh4ar6uUkEwxJGLQkZ2ZWBwd9J?=
 =?us-ascii?Q?B3q28WjH+HrElP2huQNjh/SDWDfvw/6EiMIdxIzOMnHo2ajfmMKAhiiSHq3I?=
 =?us-ascii?Q?SHIdHP0FXWniMwzRktonwT3o15Q6Hi7kk965FtWlW8KMfj/zFcvSeo0jv8bF?=
 =?us-ascii?Q?qF9JSe2auHyDS9InEBnxgSAwPDdxlpc5Hh78HlekDvt5ssg3kjC99OPzkaOf?=
 =?us-ascii?Q?T5Hw4/CSM2o+4HT3rxAfpT+1/dxteNGoS2Ycjmnld8vBVf8IbhCLfUARjVrk?=
 =?us-ascii?Q?g1H+HhoFtild/OvPziT+oDRlzHTna9yKL49kKiBD8AptdM3OIlBV8VyCASrz?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	++vto+1cbukx3RYjhk5pNUBZnRhb3Xyt6RMbZPTREWoK0wIfTWdZY130HPcITqATCA8SbGtiKF+ohMXc7bUrcKp8htGt17nAugn3YHXtH7zWI1ZxuAd/uSqq2S1RvtGHGAFGxysNKRUo7bwv9BYxRqlujqQdXx1AAJMc6F1fA3QeayY3dw8BYc7xT4ajQfWfJ9KSnFiCK91bZ+lYHYj37tPh7zgLS8bw7lyHaaJ9LlYruc7zbYj+w6Kw9HmX1EnFqVj//4ygU97Tr8L+kRFAA3b8A4E5dBgcVv+If2OnHkOha2s05b8noEe490+beSZvslBb9I+kQ6AQqnXrOT9TOO2/Bv3ILl1n5f3A6/dYdZ5LO9zFQkJuSRICDNeR/3P1XHj2XoL6MFdfPyxikO11hXwU3azoAdYE3GIN6FvTFb4dN2rai+roqiNV1EnB7/WWB0UzNJaJ1ZsipBWLZMoq7ZOmggi7QsfZ0nt345QVpV65DO44d+9txe/nMjNXMNeKPNyNJrCLWB6t3KEvftBb5JXq9HtSaSejsHaBOqlTrjs29gBNWEtqZ72rx3FWhcynrcbtaxvgyJNpU4lGd+wSZmmkNT9sUoTlgfBx2/3rM8s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57694f8-1fb8-439b-d62a-08dcceb886b8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:51.0284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYdSwLPTbQhmCvs6slEUNFBygI7Wq6IGVDK2yk9sxgCxL2g6ykHWA4YoD0fDq5c5Wcy1eA6WQMpV6mSb6r/uXPutKhpAkJSi/K2hoW8cF8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: 431ZKyb6P0rgPPFHGDm-2IV3LiB2uWe5
X-Proofpoint-GUID: 431ZKyb6P0rgPPFHGDm-2IV3LiB2uWe5

From: Christoph Hellwig <hch@lst.de>

commit 86de848403abda05bf9c16dcdb6bef65a8d88c41 upstream.

Accessing if_bytes without the ilock is racy.  Remove the initial
if_bytes == 0 check in xfs_reflink_end_cow_extent and let
ext_iext_lookup_extent fail for this case after we've taken the ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_reflink.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b8416762bb60..3431d0d8b6f3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -716,12 +716,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
-- 
2.39.3

