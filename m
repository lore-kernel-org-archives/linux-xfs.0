Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733091D0F74
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890879; cv=fail; b=V6sphahTkndzWvzUNuQO4MzC6p/YzqlJfFLZMx2MeUBzxwOsP+4hw0ZZ8+1btx2sR9QgAHgwRpcGaE3rgF5Udsg74sbo8ufitmS5ljFkhp2NXYVuXjqw3ibtejoZQmxRUacfOky8J2+WYF4oNXKVPdCro6Vufgx56CD8TR3kRKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890879; c=relaxed/simple;
	bh=hZq97b5PFFau+dF2K6PtompiVyhAXKEdfp7x70hG5bU=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=MB60SVMibCRK6qmNroixSC0qBQrPfBnwaq7gxRsjE4OE+cVjjv4E9FGrSLVxShSwqPeXDVj5Hdk6lnqLBd6M4r4eIcplQnsGN5riygjupisovSGAG4OUo9Y9lPVgM4DYyJy1VhUt0eDYv4s9D2nA7bdaehJIHK6RejUrI3GcVrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HMV0H7+b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ta3YbY39; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HMV0H7+b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ta3YbY39"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492GMWgi031358
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=corp-2023-11-20; bh=R
	Xs4W4N2QZJsWLx9Zl2XOEQ/PS8Rn/n6zJy6keU5ikE=; b=HMV0H7+bsg3hVGWWs
	lPe0EW3FVtCj/nsWg5AzQO9ZpmshyZoe8JI9rlzpGzr8u6zCbb8XANlAR8NzSgvW
	i3V0RIeNvgPAmugGue1O564N3RR0gCTjM5dasqG2v1JgrMHFsG0OUCWLDnXe5tKg
	Rkit56hlx+nuOb3yfiz31BAtuhxXJt1PO/0GcXCaPSwCzTxCj86dfzBYoPCwtLnS
	tFVnwn73JLvIjvwYlidVr0RE30Nvl5y7fs3NU1vnUUdyYHm8WnnKj2YtToHt7w+F
	a+uM6Z1c4BoX2H5DcL8N8DwAFVV4Awbr5IrTmM9dNKUDg61MtWSISb+trm4bVDyS
	hI+Ew==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8k3aeaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GpEQ1026224
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x8897f6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kl3mORxEUz5iGaWl/iv3cKzvA90OJNQJpjjLyZNeUjD1Yg7oRst+GaBLZ/6hrLxWFceKgmAaT7Ag3lj/75Qy2VSOaLW7L6cfkHr0h/EZa3F3XVJq1bY7jZLCsEozcJWy+z/5bmi2nP5f65r2oWaZ/gU93JXS9k8sQ7h+c8oMkjHXvoSnZb++NAaEnh6IiWEDYED1Z3s17dRMnrTi62nlDwkISBb0kbcHzI+jNLqZqHTFQzLXxDn5tAdyiGwrABnbc5FBULPQya8BwINZUF/YtHKCi3WPJWGcVTpLND4vRwGvsHCMakQeSfXx9f4xpxcGj4NS+aViHfHu0XNjT2kEVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXs4W4N2QZJsWLx9Zl2XOEQ/PS8Rn/n6zJy6keU5ikE=;
 b=c4K0zz9YBclZwMAYXmrDG8N1mPD0MEE86CjERqZuAlDuklB83dAs9vlhR4YnISfhi9V/ABmwkTnMHuY/5ICIRZkZcYb8Or2xVsIHZHIVxJ7ubiQRL03vAFqWpaycoscdshGjjl7fWt5UcVfLLQevKHD9a8X7lLEtVzIGt+AjCqMD/Pn7Z3oqlohqtl/i7waqjhOwfGZ3mc28c+f0vRYp9UZtGugAkAOycrAccCp7RQpM1/jE28J8WkTKGW2R06R7/fPCqL3tlqfXSxhn7a4pU4S8PmMaWYAh5b6cP9FZg9R7hiZsGjrDPswe6TuYnPDVT9x9NXCqqDGphp6DCiloDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXs4W4N2QZJsWLx9Zl2XOEQ/PS8Rn/n6zJy6keU5ikE=;
 b=Ta3YbY39OZWPJ14rHjrwPCR+5hURHTvv4sJBD73JWjiLwktdY2Qt6UrUohCgEn1cV3Pl4f17c+gEE8LpSct1vjRd/oShTi0yz6clVQECEZTCkCvPFycjdOHTqJfuYuZzGG30qJO5mdrJBZP6neXdo/ZgLwwQRQxzhjJ23h+DzzA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Wed, 2 Oct
 2024 17:41:13 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:13 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 00/21] xfs backports for 6.6.y (from v6.10)
Date: Wed,  2 Oct 2024 10:40:47 -0700
Message-Id: <20241002174108.64615-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:a03:100::43) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: edd635c7-c927-4f63-020e-08dce30968e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnNRQmZRS2FKQXRDTVRIdno2elJBYW1ZRTFZUi9VNmQwdExzS1ZIVnBmMGx5?=
 =?utf-8?B?RVM0N0xTakluL0lZWE4vSmJMS3M2bk00NXNoVGNtWEFxY2VFRGpEMWhGaTFP?=
 =?utf-8?B?cUQxa0ltV1l0TVZpd1pXaDl1TDFSdTZoQ0FzU3l2VDVRQ3JEUk9BTjJhODV3?=
 =?utf-8?B?Ty81bXFmak9xZnVpL2NBWEtadlJqTUZmSno0eUxOd3VrM0JiSE1sQy9xd093?=
 =?utf-8?B?MjRHVTZNWUtQYjZ2NlRqZ1ZXTmNscXpNUUFDK1EzN1UvdWhxUFNBa2F2ZWlZ?=
 =?utf-8?B?eTZLbjBnSjZYNFJYdUhnY3Z3U2Mrd29RMkVqUkptMks1Smd0V2gxc29tcUla?=
 =?utf-8?B?aDlydEZIZ2RwRVd5M0RKYVk2ekUrbEJtY3oraEFlNHJSUHdabVFsYXpVeEQ3?=
 =?utf-8?B?cE9SL1BVZ2NLZ2s4aVVCdXJDemRtdzlvTlVua2tQR0dma1hQUG1BTFcybjVC?=
 =?utf-8?B?RjFqZjllSXAzbEVyQ0g1UnYyeitPaGFQZExDZUZrK3dzVUlFdytHQlEram1Y?=
 =?utf-8?B?QWVnbmR5aVkyLytSaXk0T1NmVjJMNFBoQzZmM05HaVRvSVJZUHJYclVieVVH?=
 =?utf-8?B?TlNyWU9BeFVuT0NpNndrQkRFSGdFU1ZkSVRUT3dnQTB3UVVsdThJanhsVzNj?=
 =?utf-8?B?WUVlMGNMZnJhR0VPc3NtNVBUT0dDYXlDakJLeHo0QmVoWk1kbktiR3B1Umpz?=
 =?utf-8?B?UmFubzdOYkFqYXFneXJYWGZYQnpCcGc2b1U2eDhUY1NLSDdaWitjNThjNFF2?=
 =?utf-8?B?UzRob1lKSkpBR1VlLzlKWndST1g1QUtQaHp2cGgwSGx1TDBraXJrRG42YTBx?=
 =?utf-8?B?VkhyRTZGaHhvUVpoa3VXZ28zbEpHZlNVdmFPVW4rMGpRbGc3NEhzSDE5TDBy?=
 =?utf-8?B?UW5qdXM5V25GQmExNjA4MWI1a0FTMWxyQkl3ZUZoTzFKZ1pxYVhNeU1vS2Yr?=
 =?utf-8?B?VGJVM2NneUkyOFQ5U0cyWkF0bmkvUDFxTThVejUxK1A0Z0dJaEl2c015SXdB?=
 =?utf-8?B?M2lrbnhQRFUzck9pWGZlcFR1SmtBNDQzWjJvc2VwRE85LzNmYmY5WG9sUWFl?=
 =?utf-8?B?MGo4UzhkUm9vZGM1S1o0TkNDNHhyWXdyU0lDR2w3aU9YN3RMbjM1OHVJR0Z5?=
 =?utf-8?B?R1dwK0RudndHV1pIUENwNThuQThVYXhIMThFYXY0RkZ6NWVRVXpUS1lHTGhQ?=
 =?utf-8?B?c3FabFp2b2FiSmFCeU5hdnlySEsrRnZFMTJIT3l1ODBNZHd4QUNFNzFYV1VK?=
 =?utf-8?B?ZndVU3hjTTR0dVR4bm44bVlLTi9iQVNqR2RLUFFTTUhLRTdkNURURUJ1UC9N?=
 =?utf-8?B?cnJvczhyNXkzbmRIdmt5ajd1S1k4REJnNElvVkl3MUlZQjZqVDhPNVVrTXlx?=
 =?utf-8?B?RVdJd3FnZVY1b2xTWmVJOWVxZEkyZUtKZHA1aW9RRWEvZzJpTVV2bG4yVC9E?=
 =?utf-8?B?QVdSallueUc0SkhpczhKeHlsT1Z2SStsWjVqNm9uV2RQUDNzazk5M2pqTldX?=
 =?utf-8?B?KzVWb0sxWkwyTHV6WjVKaWdsdTlIY0MyMklpb3h5WWR1MHNnaVMxbjhCWWNk?=
 =?utf-8?B?OTljUnRqZm5EQVhjdE00VUloeHR2b3A3ZjhZeW9Ya0gyVDFRK1Y5Y1daTGFs?=
 =?utf-8?B?WHpNdnJjdFB3cUxmbitBWUplRFFGL1VFOEF5aEl6ZXdIaU5WTUgreEN4WW1s?=
 =?utf-8?B?UExQRm8xSmhLZHRiQkVZMFpPbnVIWXZiV093blgydTdYdEEyZXJsL09nPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjMxeW1VL09HcW5pUGR6ZG9DV29WSU1XVFFwMHNMRWEvV1dqV0JmaTNLZk50?=
 =?utf-8?B?OVdEL21SSGIxVmVIVVloZ1YrU1RnWDNSYmJjN0ZOby9LVTBzNEhaZzZwYy9H?=
 =?utf-8?B?WEl2ZE9scHE4MUQrUlcxUVYrVUR0S2dDbWZnZXE5ckJRN2dGMHZKQ2Zpak5p?=
 =?utf-8?B?WmppdThzS2VxeS9TTmxidHBLZ2llQXh2WGhPZThGUWd5MEZwSGJybXlVSjRu?=
 =?utf-8?B?Nk9UZVhKZTJicnZiRlBKTG9TR2VkTlQzR3IxUkhxR2JIMTQ3ZHNKSWF5OUwx?=
 =?utf-8?B?UTBSOHo5Qy8yRWdiRGw1SGsrTE1HMno3OTBvbm9KNFRJUEpqZSsxcllscUJa?=
 =?utf-8?B?dDZ1YnZXcElOS21lei9hK3Q1dEFnalZseHdmbXRBMlVMN01LOW1nOEVWOE9k?=
 =?utf-8?B?LzlVbmNpRnBreU5LakV3cm1FOVhIQ0dsZTVFZmZQVHNmZEE4OVV2dkc5TXpC?=
 =?utf-8?B?cGRkd3JlYmRxdGVNaDkzRWFUalhwRjl2eGVYM25WL0M5RlByRE4zYytydDFV?=
 =?utf-8?B?ZHFnVGw3WlB0a0Y5Q2YybWgrYXpCb0lHNVhCM0dPN0FUUlVQQXRiOUJGOHYx?=
 =?utf-8?B?Q2ozcWRtSW83bHNKOTNnWlRZSjdBMHpRYkFDcGI5ei9STmVJdDdXNW1KUHAz?=
 =?utf-8?B?U1Z3b2MvUktoUDd5ZUt5eGFNSGFhK1FMc0VXemxBVURoaUVNb1pSTHp0RjEz?=
 =?utf-8?B?R2pnaDZyMG1EbDgxd1hBY1VRL3VveW1URy9meGhTYTZJcTVkd2dLb0pqWmND?=
 =?utf-8?B?aDZuUlRySzdKb0Y3bnd2aHBaaDc3VnRJb1FKK2NWQ2NCOVdyTlFqd1NWZUxB?=
 =?utf-8?B?NWZtbFlDM1E3RHF4SU5Tc2lwczBGTUlWVjkzTCtCL1g0Ukd0VUFzb0tiY3JL?=
 =?utf-8?B?RFpJekZnMkJmZkVvb1Nad1d1dXQva081MXE5cHl0QUpvRkxyQVBtUlMrRHVX?=
 =?utf-8?B?S2FOQ25ZenJiYnJyUEJEZDFTT2JxbkhpYUtxQjVyNEVRMnB5Q1pQaCttbkxI?=
 =?utf-8?B?VjZJRjhzcEdrbVlBVjhwbk90cUdMT1IzZUw3Wk1hcDlUYjMzV1pXdU9rbC91?=
 =?utf-8?B?V0NWSHFOT3FaRFdIWlhUOTFFWlVZUlhRUE1QZkhVUzB0ZWNjRDg3c282cHdq?=
 =?utf-8?B?UDNkNk95TzRRenVYdWwra0ErVFhXa1ZuRW4xQ0Vpc3l3L0xEL2VKUmNiRjQr?=
 =?utf-8?B?SWpuUldtOG5jY0Rkbk54d3kvTS9WS3Z5V0Flamh4MkhlTDd4d1RQakRBOW9m?=
 =?utf-8?B?VWttbVI4ZDRLTzkzcjJreHhWODFwM1JTVWF5bk9NekxRV08rNXFjR2dtbWMv?=
 =?utf-8?B?djN5WE5ONE5ITXpyVEM3TUlHLzFoSUVremMybk1BU0lmMlhHcWNYRUxQNEN4?=
 =?utf-8?B?ZDRNeFRMcDRubW96V0xOR0RVak5HbUhEc1lQNmswelhsUHJQUkJPM3k2U0hs?=
 =?utf-8?B?NG5EZ0xFTS9lcGU3b2kvQXB2Q3FwTkdHME1PbmZzOXF1L0wxeXJRTFpXR3po?=
 =?utf-8?B?Yi9sRVZuTWdPS0FOWHVsbzRXSkpRekNseWRHNXRlQmJWNkhBNjdWN1BzU3Ba?=
 =?utf-8?B?eWp5WWxtM1hnUVhQaWdKb1NlaC91bEFsaWFPV21TYktSYmdIR3c4clFJYVZi?=
 =?utf-8?B?anl6OXVNNTUyMVFrRG5qMlpUVU05ZmNBL1Uyc0xaeE04K2pobDNxSUhDQmhu?=
 =?utf-8?B?a0pxZHJrZG1NRWlsZ05HL2Nra0lKNDhRTFN5dStEcDJXNk9BaXE0RjUyTFlB?=
 =?utf-8?B?c283bmFqYUJhT2FmdGNlRjJqYXltdTAxWUEzR0FDZ243NUMydWVNM1NrNklz?=
 =?utf-8?B?bitvT2dianlzYjVyNEtwZmJ6ZUFVRGd4b1plY1NLOUhyQkQzWDJ3UmJhK25o?=
 =?utf-8?B?LzF1ZVlPVHpHRHlEUWNGTFVCUk1IOFEvUmtHZUJzcDk5Y1kxUSt4OXk0NnlT?=
 =?utf-8?B?MlV2OWhkWHYvb2VlMlJxRWhSWm1VMWdzYzVLMVJsemxQOGRFb04xbjR2R1VK?=
 =?utf-8?B?MEZDK1psdHl2S3lwWXNTb3dzM1lZMExNeTFkcnBEYW5mcGd1emp0ZDVJTjRx?=
 =?utf-8?B?YlN2b1UrQnBQbTZ2c3JUN0FXOEdCYlZiL3E4c0tOaUV6c3ZWVDFTSWlYUlBr?=
 =?utf-8?B?QzcySFp2QXdsVEVCdlFlNUxhZmwyWHRkRXpwN0FXNk84OVk0OVorQ2xObThI?=
 =?utf-8?B?K3gvTDhhSHBJQzhxVjRnL2ZIV25YeW5VZnlXWEc0ZzgwcGdwbmtGQU0yT0VR?=
 =?utf-8?B?cnVMcUZsVzVPM2R1c3YzeVh3RDhRPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tWUeyeSYZQPMnHER+iBqWGUAz6tEdjGzXdt6f0fF0vXiZJrk0h+ar18Q1D0sRVpz4s3pD/nfVC2jB0nuVeeqqQBbRE32/AQpC8i7d7z+LfPAovDfo0YxGvR9+UdyqM81Pbu/t0ySVzlrZZzJYhTVL4G8drX7CJBr9CrzZ7uf1umFt/dHmnSFYDIgZIzVQLXSJWRUV4azwflRgpN3SvmeAmjLi21M+sv+hC5XDYOFC4BQxtX4PKK0zsMO9ny8zVGFwY0JfeAFjg8zJRG1NlGhyVH4/nb0nAcdZiUl0hTYBqeuvOleNBGgTD5cwlVF7yqv8c8Xg9PH9mo8MJ4edfzhKyLn7buGqOLDXRkVjKlTO1sEOYxdGb33Hj/4WPRTpMQbG85y+ysLW53dOQA1o+xKzR9sY3CcvsF0JTN9jOWftQZsPA8fec1HH9wW+goImePrgiTJx/8OzLTrhxJKL4WPJm5teTH0N5WAQhs/E6Cib+a25GziyYtvC/O3dON9mbkhQoY5Ltkr4UB2KGynDU3YeVgPD1/ctpvLK+v34vysjXw8Ka9oAJW75pQFNHv1ZEbai6Yxo8SusNcnMU+ASAFF/NUQpokTeugDnubPvci7e+8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd635c7-c927-4f63-020e-08dce30968e0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:13.4256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CId/JxsZ0uCI/SHAsjEemCPKcDJV0RZhMsd4tqYsqVtkZFSKZJJyGMCUbO9/wEbAWCD8zepZAbo2P+6pONl6fB0XFOCI6XyKXXIVhvU0AIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: 4gUX7rBwdZlO-0V4hKbU_GYhyERTiSno
X-Proofpoint-ORIG-GUID: 4gUX7rBwdZlO-0V4hKbU_GYhyERTiSno

Hi all,

This series contains backports for 6.6 from the 6.10 release. Tested on
30 runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1K and 4k block size)
4. Reflink without rmapbt
5. External log device

This v2 series has gone through an additional 3 rounds of kdevops testing on
top of the testing already run on v1.

Changes from v1:
- patch 2: update last argument of xfs_mod_fdblocks to true
- patch 3: remove "xfs: fix log recovery buffer allocation for the legacy h_size fixup"

Christoph Hellwig (4):
  xfs: fix error returns from xfs_bmapi_write
  xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
  xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
  xfs: fix freeing speculative preallocations for preallocated files

Darrick J. Wong (11):
  xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item
    recovery
  xfs: check opcode and iovec count match in
    xlog_recover_attri_commit_pass2
  xfs: fix missing check for invalid attr flags
  xfs: check shortform attr entry flags specifically
  xfs: validate recovered name buffers when recovering xattr items
  xfs: enforce one namespace per attribute
  xfs: revert commit 44af6c7e59b12
  xfs: use dontcache for grabbing inodes during scrub
  xfs: allow symlinks with short remote targets
  xfs: restrict when we try to align cow fork delalloc to cowextsz hints
  xfs: allow unlinked symlinks and dirs with zero size

Dave Chinner (1):
  xfs: fix unlink vs cluster buffer instantiation race

Wengang Wang (1):
  xfs: make sure sb_fdblocks is non-negative

Zhang Yi (4):
  xfs: match lock mode in xfs_buffered_write_iomap_begin()
  xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
  xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
  xfs: convert delayed extents to unwritten when zeroing post eof blocks

 fs/xfs/libxfs/xfs_attr.c        |  11 +++
 fs/xfs/libxfs/xfs_attr.h        |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.c |   1 -
 fs/xfs/libxfs/xfs_bmap.c        | 130 ++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_da_btree.c    |  20 ++---
 fs/xfs/libxfs/xfs_da_format.h   |   5 ++
 fs/xfs/libxfs/xfs_inode_buf.c   |  47 ++++++++++--
 fs/xfs/libxfs/xfs_sb.c          |   7 +-
 fs/xfs/scrub/attr.c             |  47 +++++++-----
 fs/xfs/scrub/common.c           |  12 +--
 fs/xfs/scrub/scrub.h            |   7 ++
 fs/xfs/xfs_aops.c               |  54 ++++---------
 fs/xfs/xfs_attr_item.c          |  98 ++++++++++++++++++++----
 fs/xfs/xfs_attr_list.c          |  11 ++-
 fs/xfs/xfs_bmap_util.c          |  61 +++++++++------
 fs/xfs/xfs_bmap_util.h          |   2 +-
 fs/xfs/xfs_dquot.c              |   1 -
 fs/xfs/xfs_icache.c             |   2 +-
 fs/xfs/xfs_inode.c              |  37 +++++----
 fs/xfs/xfs_iomap.c              |  81 +++++++++++---------
 fs/xfs/xfs_reflink.c            |  20 -----
 fs/xfs/xfs_rtalloc.c            |   2 -
 23 files changed, 433 insertions(+), 233 deletions(-)

-- 
2.39.3

