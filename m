Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF5E213222;
	Wed,  5 Feb 2025 03:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724899; cv=fail; b=rhgvrHxpW/hP4ObpdgAyA2Hq3dKWcdvfdugUyKACcfmeYDC21gKoni6dt1mfX3mSuOEYB7AXXQj8j9djULCSeMGyXibWHd+KbZk2+VZN4dFZvxJjDpGNA/8/eKSc3pfYw/2oa4s0ljqdqYGzwBRrynIfZF1pqS7p/nGyFC93j4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724899; c=relaxed/simple;
	bh=zdvQXwKKT6Q8y4Cni1KoiWuTgBHrvVk5yP3GmCBuYew=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UfmzxIL0TeEOMPPuUus6530YKzEGYP0h3VwQJjxEEc9KewYk1cA32H4BSQotjXweEy4hZRScwlvLSC1EN/kAYclYmUWaQ8rUapApwmubaRWRM9k+u7v7qCNGBGJTxbBDpSr3Oyz47QUFLsAipHGx/6eNKaVNGao/0aiZHCg/AgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NizTjTi8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tirvc7Oz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NizTjTi8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tirvc7Oz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBp99031273;
	Wed, 5 Feb 2025 03:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KQfbjoA3STEHHDNWmun/UZIGxYoK4GHcUBHbEW2Nshk=; b=
	NizTjTi8hzFcGBJr4Jwiq/DZ1qnjRlzfBqxhE+BVn4XFwiDIAtrqr6dFOG82ITnj
	0KTh8dLWPXBz9liwijmb+zo9JOutG/60s13T4/mxrT2hg0BfIaTuLSCF1Gfr3sBx
	8KeOwMtqPK70AKGPXdusT+p8Sn07wiRvrrSarm0qB2JB9P+KahnadXDoV6TW7H0M
	ANGdH3WmHbZYUnVcKRERh4zixgIQIA5W5f9z9pcrkjOpu8JeIbXoTtQTPGHKPofd
	DKiqR6yYL7jB1CojqL2pCcTqhH8X7jf8ShDk76il1rZtgAs4nUD+eWLIUT1wfXHc
	NhAiq7b8dhF/ktV4Tk8l5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kckxj3r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518Zsb037739;
	Wed, 5 Feb 2025 03:08:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AiwCwnOQ68MiRzGhuE23L6B9efaBtkzxtcyZoJuL03MMpFqzN8uD7MbLfII60R796YGYvzc8Kets22+XHGZn8ZXQh5rjTjWLNWos7emi3U98VgDRvooDDWO5+XiA5O2tT+YIegDxvvBz0T4Gj0kroIxYU2bLJeVWshS9XMNL5OTArzhme/RLp6GC/dbgE4PuqZnAVMzuERNRfG23CG2vhAiotedWVRCbVrPNP+tjW/UnkXAEpsjEPtVcgPcgHcS62lU8lRT0KEdQUFIe8QIixoKpMua7x9EThzKevqv5e9/nLvhQlEo+5PJ7iERxOmMPM51zlmTjTRdNlBQvhtt4Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQfbjoA3STEHHDNWmun/UZIGxYoK4GHcUBHbEW2Nshk=;
 b=Ulpig1+682JoOPj438/Do2dJriLaOMwzoCe0W+0qEolmZNKr2VSVV9vCy7Ofx4iH68jvpsp8WA88kVJDU7aIXgBt5I7lA+qz4PLU2hCfuZbbuir1InW7FAfRkwxpYuMYSXRozXYhaVfLpfF89OSSdCa3CZIzTzVOKFqsfdQ7oGpGDDoMaBZ0pIqKgPCI9TQux9BHBTs/LqF4+VBmgPPCnmNIoGc7YGAxJpjEIWYZuomnHwU8HapcMyVcdeHxSY+cGrUPPbpcVFGbGCotVCAKXHuW7DxaN/1XmU5B14WPJND7WAobXFRoSu9/pRKWbLBdbpAW1tbgxWYpTblHlbN3OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQfbjoA3STEHHDNWmun/UZIGxYoK4GHcUBHbEW2Nshk=;
 b=Tirvc7OzR2is7RnOfkS33x41ESOpvRy84baw+731z5VX0ipLVi4hy+We3IFYhqrUb6L6Sn7j7bpMT+lBDM0weiMb+wZTqhkkNOAqUKAlhJP3VlXHcypTe2LDYMtUGx8g4Wr9MfGUDpQd+Psud6LW1pTX+3ZA48avNDmvcOM85qY=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:58 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:58 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 15/24] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
Date: Tue,  4 Feb 2025 19:07:23 -0800
Message-Id: <20250205030732.29546-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:a03:333::33) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b67ccb2-7285-4dbf-bea1-08dd45924b47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r+rgoE/HseT1S3wyzWWe7E2KPFARsifd/INii7gQoEhOVRjbAKyF4sKcFm66?=
 =?us-ascii?Q?8P4nd8o5lDyG9nofGFEQnguZ1eumpyUlmoaDPPr0r/YDUhYg3vSzKNqBbyRf?=
 =?us-ascii?Q?i4K/VnxZKyUyZKxcSXQPyyABO23rvX8XTx2lB5moTw3H20UBUeKSUN27sZP4?=
 =?us-ascii?Q?lfOSNdVYvAPwfKhM293+Nbcvq0jEW1APZvmcGvTJDdSHCBV4z2GwgK/iKeWW?=
 =?us-ascii?Q?0UYNAfDt6yJ/I3+gffezMUvIEPhWHHh+LhJM6xPIRNJEsQoPrLd9pz2Rhg+F?=
 =?us-ascii?Q?XNid+r+3ZQL1FaUlf6MhabcedC3SFNxytiMglTHDZXOY5N3n629rDLWwbmgz?=
 =?us-ascii?Q?fyZAMaeRirPg1klp0TrsbhBJDity13x1tI1rEysUEim6BCJJsQBlJJ7OunjP?=
 =?us-ascii?Q?BG00Skq3zt8zz0bVX6YY4FA0LqzyL03TAMlWLhLFPgKj62iCWIcLI664Pb9t?=
 =?us-ascii?Q?8Qhx3CtBtWofPwZs6YAhCtK9nssz+hJCvHyDatPVhhLqoF9mRirDyoLdDMkj?=
 =?us-ascii?Q?eChIwAQofwPnPvlkrCgHRWWhu4j4McNnL6hWfW63wMVGAMItryF+QnYfl9Be?=
 =?us-ascii?Q?2A2vJY8dfzaq7a6HApWXOwp9Grt1rndbnKsfXUY3So6H19CdFnVmaqmRhuE6?=
 =?us-ascii?Q?h9f5T5opI1pJCVEneoJITUcRaUI/3R8583rHDaEaZ+0ZZ+UdPsykzghEJPrt?=
 =?us-ascii?Q?HpNoUdVYjCOlhXSrt14s1m0bzAnRpBXqNVCcLWN3qU2dClaBr6ibvJaJAW1T?=
 =?us-ascii?Q?TxOUXojpIFW+WGqkqK5ujxu22MSm3ICqvqarYZdPgF5cwnmJFOm8OqJWFd24?=
 =?us-ascii?Q?mfKrauUodwX8zpPHyIyGBGz53HbSkwDEN+L2OB32QH2SOc8EhNYfedaQXz4v?=
 =?us-ascii?Q?I86puefcjBzSg3ez64ZkqWKrrx9AcCDdugUtBWywKz/T6gcuePrlc+boJU9J?=
 =?us-ascii?Q?cchbFSsm6ydUtq7DlWSnk2Q2g5Mr+unZDYreYMeTudRjKJvFF90EmMOPQZ8m?=
 =?us-ascii?Q?0JQTrIAQNMUBeQp4ijhWkE5he4yW58cuGu5CJbWIbF+IOKm1AKAedu6z3JpL?=
 =?us-ascii?Q?2i2Cy7LbHJAlx2k5YdZL9KyDupy5a4wMehjBVr7kXe1XZ5G5SN9DCPvRiwRL?=
 =?us-ascii?Q?/Ao1c/hlSB4DlfqQI3fRCq1yb/lqyEZ1W28I/jlqrUIit46BnbnTlzPxaLd1?=
 =?us-ascii?Q?nbDib/z3SzlxUAn156EtVsAVTtO/Bd5EszC97KlzBLTBpIEnXmH1NfHIaGvx?=
 =?us-ascii?Q?ebBriF0lIebhre6C6hlpMf/q3iXIlKz2seka/GYKcZPKvecavQddITJOMEum?=
 =?us-ascii?Q?45tVKgOjLG5crCbSTzwheKqyQwp99P7zQtpdq15VKo1lPkl42awxvLsk2aoo?=
 =?us-ascii?Q?Uku2AmNLbjEcRKbS3/ka1z6tnZju?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pjC1JyBOPoeoibOvCqL8OLI4QhEG/cgW2L+9lYCV6ycgyMYV6SyUEqzs4ySw?=
 =?us-ascii?Q?sGc5EgX6ZonlayTDBL1a6RegtpfexKlpV9NulBzuPSs13156FVV7+OevgK2S?=
 =?us-ascii?Q?2vS61Ujf57dxAWHmERIGvnYs6/tKC27arWKlzUKhnR5OekXMWQ/F0c9jbr4g?=
 =?us-ascii?Q?YjRp+rSgB+Zxh5vQNGNWYf0KAghp+oYZTA61keXNCtWrMlVIg6g7RRxYYMNJ?=
 =?us-ascii?Q?jj3tpV2eZdncvmWEanqitURiMuQFiqTs7CtcB+OfGqmGGMGUev5DXa2uPlaw?=
 =?us-ascii?Q?R1dLGuKezmUJXb3ZRrY5+Xu9tS/fz+7iLMVnp+qzoaU1yCdwoRrSA/3Xs9d6?=
 =?us-ascii?Q?iWGQQ36hPvBCE2JvU5T3P3H+C79z8hgQsXi9akK9ALvmLOTgZdlikCPNCIBW?=
 =?us-ascii?Q?P9zwisla6TT4jP4Rgt7txRszTFnabUOUjDeeHUjLArZzukoNkXyAFmzzdT/E?=
 =?us-ascii?Q?Jb8xLlZEr8GS/4ayqYHnZA1KF/H4Sf7U9GnrRvZWISN93CLRcnC9U4rTPHhz?=
 =?us-ascii?Q?jNA2oUdG1xq7TLW5N8I42LMeSjP+kLu5WpWsiyLE89kFiyr3oYJfjHYbE9LA?=
 =?us-ascii?Q?tG3/5JXSM0XQ8FfH31TG+qCMXcYwAMwAreXNtTSjapXCLA5HnccYc4L9R4MT?=
 =?us-ascii?Q?oezt0Dk0iBk+yx1/63ESrvaBbvu9IHhM0Cwuh2N3UNGLb9zd4cvlem3QeFxr?=
 =?us-ascii?Q?MkUwcsEaa6k+Yd5Py8mmbDEaDZQzBXO1/1YROEPzx2QGfq0hRoAXXKnw8hf/?=
 =?us-ascii?Q?cSwXNziUlfxAAp/bXJG8aYPKKSStdMmTAtHFHheGrUr+GDMEAI4BBS6qHq+7?=
 =?us-ascii?Q?AIP7tcwSBVRuONvrICFpLOz/5Mt0znQVWZlsgn5IuAI9CAk8qXgYQMq68gvM?=
 =?us-ascii?Q?KikbcsVMS+cT13xx0SG31eVw6JqtaWGaEWGH5alU6nvxo/PuWPXQlhcdR5O4?=
 =?us-ascii?Q?PA+LyayklZWeJcseLghekbcJ6wKs2BtaQjIb/bch11yiY5uFVb12uVSr0jvq?=
 =?us-ascii?Q?sqMlbt/CUmoQEVuzSf0mXKhlYDbM4UuMBJeQ7J66NEj+NKZa7XnJhz07x4s4?=
 =?us-ascii?Q?iP6c9+uSLBx+a6KB1xUzb4gyT6Fye9gjtHCxq+AArq9vyIlhPI/FC3sgEjYg?=
 =?us-ascii?Q?14S46TuC2ROhA6YFCoQ0/ljICWrIkjOA9OIbSw7kVQtkppZtQLSEcOjpb0wY?=
 =?us-ascii?Q?09PLyZEzzDKLPyWkf99NGez4hMN/4kTHd0b86zwCNU8u9Ii8w12MwrG1worR?=
 =?us-ascii?Q?WxscFlWh1NUs72HqFk+5qwMJfjXL5Mp5gKGlGW9OX6mPWkCwti3AQd/AHIld?=
 =?us-ascii?Q?YS7eBIb3/vAuQPYQ7FKXUP0vk2vd6YwUvuHnYn18FfRnlT1fRfBNPQPln4zw?=
 =?us-ascii?Q?/W57D2Ec+FCmWjmsLitlFiJW+SbAUlgAce65xYMW2QmoF/A6HeJHEXJdjQ9z?=
 =?us-ascii?Q?3GG1P0D3Y/m/WoCAnRKG3ZOyym/XUAF1rdSx6Ai5iwP+JGtYVpRiUxe2JPNo?=
 =?us-ascii?Q?/hhO3VNSjg6kAkV/fY7g6Yb/TEKS7mL4LhAblKgsYfGxlMljHs8GhQguxz0+?=
 =?us-ascii?Q?tEi3GiDv6acPhCzZvwK/zO9mVvCqXvsNwg0mGZCQWm/eWdr8m3bB6LzOQ9Ij?=
 =?us-ascii?Q?OZdIEOG8tNrJF8E7mqUl2l6gskWQ/+VgM8ysku02gSerBepGftYOKeggnQB8?=
 =?us-ascii?Q?eqoiQg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hjG8batEEdEmCxiBfxogVF1Pv8mXBSKukmJL5t1V2nY2j958NxaTrluIOJvv5zmsSpruW+nIY5tzoQ617xSa9RKnlTlKGfLgazEe4hsiLr0PQB0eygRw7h73/EzLsIUuw+vpV0X4QbuguXyHFmn5hOf0hdFdu0ebJOvyTYJKimu+yxDMytCTbh1jzWqj2FKUgIl4RgYJi1/HIXzPAk7NOH0ICSQk44vU1FrCFeXCgP/Md4WBQ02A3MWEfnEeOJMnlixP9ImpuBf7PJRF2nE8XItJI3Qj70xgvUbRN1XyH9P3L6J9QgSZ7AVnoIXI86thGnyBIkvjZRAKr2Fgr/dQeIQ8/zL6VKFxH7VrL89msE5SPV/ZRavGD7uwMsR9bt6AXnDCVLYSiYqOW1aUUmlVJvhScYBMASTOBynzyIhpMsdTEauGdut4MYy6NAG3dqUyHMfej7Vu8hqO/j4ig9UOu0CB0sc8APJQ+sxM0ovEqcYABr6hsgyZ4Fxvabmzaug+38j1NeyrzcbP0yTF42tkkDG2zSoZq2amKzskEyW6N/uWM57SuTu/frpGA+P9aF+eLYk0aXaOOtiDy/AToZMZchi2f6jq33t+hUyu7UJaDLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b67ccb2-7285-4dbf-bea1-08dd45924b47
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:58.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOF23O7NF5P0H5cXCJbLbPjhhwpzLrJFDMZzz1Q/K/dsi9dIg8Ef35stzn5l8iDpr7kZxWA3Ao9YX318G4nAwnap0egBweWC0q6PF9W5Sjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: NVomD3dw-nUf6FuZDaYPori4AtprDXbu
X-Proofpoint-ORIG-GUID: NVomD3dw-nUf6FuZDaYPori4AtprDXbu

From: Uros Bizjak <ubizjak@gmail.com>

commit 20195d011c840b01fa91a85ebcd099ca95fbf8fc upstream.

Use !try_cmpxchg instead of cmpxchg (*ptr, old, new) != old in
xlog_cil_insert_pcp_aggregate().  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg.

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when
cmpxchg fails. There is no need to re-read the value in the loop.

Note that the value from *ptr should be read using READ_ONCE to
prevent the compiler from merging, refetching or reordering the read.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_log_cil.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 67a99d94701e..d152d0945dab 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -156,7 +156,6 @@ xlog_cil_insert_pcp_aggregate(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx)
 {
-	struct xlog_cil_pcp	*cilpcp;
 	int			cpu;
 	int			count = 0;
 
@@ -171,13 +170,11 @@ xlog_cil_insert_pcp_aggregate(
 	 * structures that could have a nonzero space_used.
 	 */
 	for_each_cpu(cpu, &ctx->cil_pcpmask) {
-		int	old, prev;
+		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		int			old = READ_ONCE(cilpcp->space_used);
 
-		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
-		do {
-			old = cilpcp->space_used;
-			prev = cmpxchg(&cilpcp->space_used, old, 0);
-		} while (old != prev);
+		while (!try_cmpxchg(&cilpcp->space_used, &old, 0))
+			;
 		count += old;
 	}
 	atomic_add(count, &ctx->space_used);
-- 
2.39.3

