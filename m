Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A450037DE8D;
	Tue, 13 Oct 2026 08:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879192; cv=fail; b=B9Nkp89/Itu68SbgQEhSGOW2K37KBP3/Y+0AHfuLwt6yEX08Yd2CSblbHKYcmqodyCe1kMxz+ZPlnOYDjtSM2TQCpOU9eZI3P6q1wzTpkrUy2P6wjHN7F+HQzJ+e1chQjHOwNCyTxeBU6GLkjivym3knEQgoHi/1kQsNrw80MTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879192; c=relaxed/simple;
	bh=v2gaA/nmcFkyKoRGATkxEMl6GCwSnOtjSchQRyc0aNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B/gIABkshnaVWeIi7TZzQVM+0vD6kbZthzwRQCasskyaCAxvRxqRyXsRq672sAFL6FIFrvG0uO9PZszer+6NASifadyfzTlkb7fQ3x0wi8YZmjGgEgaGZoPwgVYh39OXKeVH59+tI9TmT9BewTIW4UxgN57gmlpN8Qk3e6LiKFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QYnqcsPo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uMecg9/X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QYnqcsPo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uMecg9/X"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C26X3110881;
	Tue, 13 Oct 2026 08:13:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5IhiBSH0mqjgVGuvity4z+XAf62pmU94n3AB1FgisjQ=; b=
	QYnqcsPoV9+aYi0sosqi556LAzVPy+56yYwy2L8S/E1MA0Qwnhg6+FBh6PCyxQuR
	+sjjYwFH/f3skIgU0B8yWuHg5b7lzZi/YrlbH9w6OUAJh18Nhg0yk4GWxoRF3xMd
	cGPrjewPrdRcBVy7yaYRRYMWxo57/6R/9Vi9dwuvNN1ZLseXmBnVVPdyB7GuKG+2
	KJqUIUnUgSLoko3wz1u/pYp0U9/q8uY16NDHtPUX4kNoWchJi36O+WXT4BnHhD9V
	hWEXlwGd7GqciPvlA+JnuZ4z0IQjQrrkkreKvPt77tGOkmo+s7tG9Q4yIu6EiV3d
	OtAvZWLAWUSh8CSRP78duA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkmh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86gJ0033467;
	Tue, 13 Oct 2026 08:13:06 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012034.outbound.protection.outlook.com [40.107.200.34])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxpxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gddUkUWG3TT5qlscLvlLHJD2lpcwmxpHYjV5RjMUWDHjPNt/hESvGVxIMmmvM6q17KJrNUVq8SDl5QMVmEfZGAuFSb1Nmvv4Gz5q1fADFzmyPbdaweBxTm+unfqRM3YIpxoWW8ednHuD3nf+urQm3MOJ826wJ2YUwYbFyQ+Rnq8kAPVA1iWa3o7hcMZwhbRtMX1bIFq6CL3p0QugigjQl5fBJiBi28+X2tY055AW2tC7Lh54rLNZ5ma4wPZxScrWx7nPdM6Vk0R9Id6fhMRXcSBIa7wvEIQ2SgrA+1UsNYm3SV2ZIVefaXb4sYLcrcm1uzRtM9nP+wIkjgJFufVurg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IhiBSH0mqjgVGuvity4z+XAf62pmU94n3AB1FgisjQ=;
 b=QBl4SqE1MctAXHBzRwHK+Ha8QwiJzed1wrWtYlFFpenguZFU80ynXoqUGujOZgqNSFYhOM/UhNcoMLi/OJHF8Qpur/ybQ0Pp11fxg2hxAvNtQuyncygum87/ZbP22SEzhGVfPcg87ifnMg3i6jb/6EYmlhdu0+ymkufn/o2qzlfDvINweeGLu8BiskTCqyFMxnVtNE8q7h+Su6Grrh+yP0graOl4YmMBHIPsYEJouV7EoU463FhTeXVVvu4QqJUP2cW+ZHoMKsQ3J8ygQ/ja7NOE1ZHeTVock2rlL2obTKc5WgSdRJ6EzGV+TZRgrQcqGCGGSwMH75cGv84dt2Ng0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IhiBSH0mqjgVGuvity4z+XAf62pmU94n3AB1FgisjQ=;
 b=uMecg9/XE7Iw5LLAgolwjN34LEGzfciH2dUYcvP7pvieIjasrnAuEu/KOJm6dQdVwcY3VYUBWzABEN0iddFsuq4Qb8KEi1q7hdeORZC2kU4LCNWkKnqKyiwipVWI6ayaWB8/0y+vHRDg5ObSE984b6x4X6Awl6a1al0If8Sk/gk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 SJ0PR10MB6397.namprd10.prod.outlook.com (2603:10b6:a03:449::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.6; Tue, 13 Oct
 2026 08:13:01 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:00 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 v2 2/6] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 13:42:42 +0530
Message-ID: <9a84b2d5f20ddb3a69331c553b3946f6c42d2d63.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0010.APCP153.PROD.OUTLOOK.COM (2603:1096::20) To
 DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|SJ0PR10MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: 18b48272-8f40-4b87-1bf9-08df2901cc1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|10070799003|1800799024|56012099006|5023799004|4143699003|10067099003|6133799003|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	pZBQIPp+jmdlviE1y7Tsje9Wah8LguRjilH+B3F3QAWldCb2+zA1VYkqvtsagU+TGjMcXbxugYZ/MVZ1zDXHI7cbd0nsjcXJUcbb1sFDMWVuec6vW1UV+5Lh7TUTNJaBOd5tVQUdInfqJU0ifKLW5+G7fRxTQw3nHYd+F123gLMsyRdtY0rHbqWaBKWY460VvFPHZVy6mEPlXXYtqgJrhoa+STNDtH4tB70z5BQxaq3/2BCd6+N8uFZWUpV9IX3x8xB0rauuefOhJ9cwugFMVXzjOt+5xV0veL7Y0O+GZGho7imFMH/QqyjqUucMYVyF/+S+8fgcYOKbTIqakXMPMZtAEgBcPnwd8Mshfc0LJ1jSJY6tJKlUxy+RzaswVcJYZmgN2dpxoS1/3DT1aHyIqOORQmmSrZr7mNK8CF08TW2DgQ1aQBCvzHqfJclHfwB8UWduScTwBtMwqGgpW/8T0KJYMD5M4vnTXjATfy5bnSrFDNRwYjGT07bFejiWA8+ZIn9dSkzp72Ec6ZTgi9omYRQ8lJhla7wSLUGaTjws2Q6W6UQj0hNpSwiuKBVI7T4fUO+Wc34a+NfUTc+8FJVZLi3NIMyehkiShsXqcQpbpKnUnvGpr0jrlPASj+3OPikW7jIPn8G/SJR89TBQAGYCPwjfnQSR8AjR55cy8L7t2Ls=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(10070799003)(1800799024)(56012099006)(5023799004)(4143699003)(10067099003)(6133799003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g6pVQNX6K3wLir8GMAwfabHLyTH+pLMgZYQLRn565/3BtWxTWh4cGJI5QF9z?=
 =?us-ascii?Q?/6v08ljSeArSwWEtTimsDQRNCJoGZcS0pRB4HShdFGCWq2QwiyyaVgz+1bzt?=
 =?us-ascii?Q?tr7DC8W1BKVSWuwlkV+4DFYz6WJvhXgmE1fYXZKdsMGYDVmQR9YofTbFzqP3?=
 =?us-ascii?Q?5bJ9erZRBWOFN7w/uWiGj4eTmnggDul+MHtoVdfDMn2vOL2u2YPR7jrprV3w?=
 =?us-ascii?Q?oHa6lnWn5RHm/BJ8GEaJgHQDLnafr/Ue0jRTN2t4ZPOdzuxtDiL6xLF0iD0V?=
 =?us-ascii?Q?f+4kvWGfheQ1QiH821dKiH+ZQSK9x3HLbzfk0yAdHeID0Wh2Y9Bs8oolYlM4?=
 =?us-ascii?Q?DO2wQbWTvRR39ONY9e1YBPmJT+ACgHf6QS+ix3WJv6Ik85xKxCnccpanPZOx?=
 =?us-ascii?Q?RipmEM6xv17UALz2GfSB4ewtsME6uxO/fKGRetwIFAg+d6yllD3VHc+PU1uO?=
 =?us-ascii?Q?BQMJ7XcKu1+oKNqtjqOstEG15ZNGYTHVGqDZnqt+H9FU5cAVgPZN3Y3+hoo3?=
 =?us-ascii?Q?eyt9qUfuD7B9ZC0kwCvukh1K78h2gBDIlleFs4DwHj4CxVRMqgNBQU1gItAk?=
 =?us-ascii?Q?Wsbil9tYLlX2tLMK7MaZQ8OOg9w0pDbhlHW1IRz6vgae4auZtMFs/b6y4DRP?=
 =?us-ascii?Q?EdeGDFBogL0WKCKkMlIpRorDEMHy35M4eLvOsscAuedRqNtOdJ9SfdLsWYgt?=
 =?us-ascii?Q?C7PVPVc04iduN1KXXHhxw5vm3Y15N8qQ4dnvF9Cf05GOZdDtsMp6yB5qsugR?=
 =?us-ascii?Q?o1Ypa6SgXywlfVhqU80UoAI8Shj+ErxNO6vR1vMXomaVDtKKh+yMFoyjWvrc?=
 =?us-ascii?Q?Y/sbRb6zwVFoB2YG8HrUNXVLlqMx4r9nDevDt1f6QDeeDaeyMU9bmM5KBLmK?=
 =?us-ascii?Q?HtsRNymiA+0PulvoumDSVommXo/zw31jJ2y0UUfXJrFSFBAYOUnxENF2n31o?=
 =?us-ascii?Q?LTfIBld3cU1BdZuf/KG3guP7tYSFYlrl0n8KDP/88rLhyGzArRnwFA0HFZMz?=
 =?us-ascii?Q?fhFUXd2DYTK8Xr8y2Ou+2zp58GTer/Rb0y00jpF+EzcJH0mTCREokaEYGVAa?=
 =?us-ascii?Q?zAJmUmPKIk3Sus2V5t2bzI1SmmVyWfeZVXgq+hDmcf1eHAsxZxleeB1ZaclK?=
 =?us-ascii?Q?1Ra9rKzXVyQSr4krKAWqCW/rs/EESQRRSiij2pAFUY8qB5fn549HZvc+KO+e?=
 =?us-ascii?Q?71Pi1E9NTeUFNNE7LYCuBZ9uRYc0D8WXQtHjSslUvckmb0lk6tjFYPQOaHjw?=
 =?us-ascii?Q?bMC1rWTd55UC28xYGmruwmzYK01TadNGWVGULY+AjNuiurBlKrr/Do/z8vgz?=
 =?us-ascii?Q?h2yv28yYj9ctX7WfalwcpdP6dkKoCcxhkAt0EZ5upHVp3ood8g+Q+EV7ZfUV?=
 =?us-ascii?Q?p+bWjFuu+ettaiHo9SpAHI+V8I8gn5GEG7tQ0EiMdUJu7ZmYRlrB8o6sP96r?=
 =?us-ascii?Q?G1bPbE6na99RMgGOk95/rt7ib20VfSFJWHNFoiYReAI1M7fjeUtkvIg9qMF9?=
 =?us-ascii?Q?Jw5k5fl+hzHZx2vjk2PaM9khydmPMer696l0Gx8kVNO05eSpK+6yTIwytxuW?=
 =?us-ascii?Q?96IfA+g8kOpdHg74mcRysVg53oFS4p3QwTr4cWwfs6v50Ebm11GWdLTlD1EW?=
 =?us-ascii?Q?jQp9F63SONpxXtiKut0oaI74WfcIK84NSC+r3fJyWYQ1TtVxUGIvTOYAj2ZE?=
 =?us-ascii?Q?DejlGDfpaVB8hlWOfVp+krSuypnSshG14nAwTTtA0hP74zhj5qV7Vxq5rjhc?=
 =?us-ascii?Q?wevAkVLDZbH3r55r5GUVfVx+k6YfaDzftdYpzX+G2G0Z0Biwd35y7ps+cYRh?=
X-MS-Exchange-AntiSpam-MessageData-1: SyDMqVaW4rxQrEWLN2vq+zJpse/1SQ26kJk=
X-Exchange-RoutingPolicyChecked:
	QULe6o8WwEfrY1eo6X3UgyMUhmACMES9sbTAg/iFnTux//W/kFzlD9GGqJeLo/1AVXbhdOrM53p3d6c/XE+6RaljuRtb4cZBD0UPmMKXhc15lMNhYttKjASEsePTZ+Gxu7+QwSA5908djQh49Mu+dVT8VYalfU98NkixS0rwcnvjVRtDEwxbnkJrTR95W13RFWdxEUIh1U+0f2E6ZAv+fqT9/qDaTgO3ojt+d8XCf3J/+7z7YONgl8nAtpGDxFxSaLblv/44Wo3bibqzlS9s+4zCcYE8SU/wF9Qf9G6Vre8VpglIH/B6GV3RwFwLg5Qrflk9jIO4Kd7kpXFZuzjRVg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ibEqyTt+VjheWPTz+mc2a9N3b9V2Nf8Eg/+2awxbdwmEchOnRrOfrmZVIUlCsiThL0wSfzWs/bH8oZlTBZZDLmRGJWPTOwaLOYRAV3tD9euSz/TGpTnEksTHSQsl02isJ8Gze84jyTUPg6C2fVhlvMz/Un1redhoAMkon1wOG9GVdexwXJ3PEQEtwliduhtBp6rNtlCx700OtlO3IclN7FnyFwhQiKnR/ezrZizKduZuOuu41Ei/fgxDrUK5XGzcNahAP3TfVSX/vd+VOPSvYui96mNQ+i1ASGYAL23sKylcKWLy6hTKA4VzoJJgBYiB9m5pAda6azNH9OJeyVBoRsYNyNGlWD4erMGHebuZNzO75BZLgskU0rY9/fDnEaZ9VlO9FcDk6FaFsPfJQz0hlZY94OqJila5QK1u9iTNP9Walk3X42TFzWTqo05igDNg757gGkZ/8xEagBeOt9iaGs3VlXECWC5oHgTeL0ESo7/BJv3V2Sj3H64KSP6xNfIE8MFgnDvrfYY2490vJ97fZeQDCMoMpTMj2rfWd/qlxcOGWkt01rBcpJTtpXDzLTDmGFRVoHv1YEcsFxUr9ZPZNMotbPwvVmnqFoGis3oDKIc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b48272-8f40-4b87-1bf9-08df2901cc1a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:00.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFzs965dZjUVCI9eN4b+LDtnZJ6DAe6wkHM6M84uznepOx+M3DLxlOfoA0Igqx/anj8yVYjnTPXnKSlnta6LWwEpbJAQ5CR70wZwTuQi8ME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6397
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acde812 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=2l8DqRWQ2dbnbHYYE4MA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: k0bmuz7T_CHb1NKgm84pmmIw9iP-r0f5
X-Proofpoint-GUID: k0bmuz7T_CHb1NKgm84pmmIw9iP-r0f5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX5JG0BTJ1y6ax
 BhlWuRugvN+kEp5HdnwNu0OOqv5OpgIRNyloY+SRuGVdrhdTLcOQRT2GsCZMi9Gmx3hLejDCrLU
 BDlquHWX0HAYSOehrzfMtO8vyYKI3x8Pg5UiZy0cRaHZEKGPtWCQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX5nbd+NRid7EO
 t5AbK0UiWtt+p8kqebINdhgs+5dZtNAtuDX84Lj7fprk5Bl1UJz9pBLLLqKgwcEchfFj7ytMBnp
 UhmprfE9HfbEraIDuEyNiNSs+188KKrJnA7Vh8pNfWWAlra+Mxh2zu4ZAnOwIhzXMocQhDSDsNi
 H+UOD1RT2NGtmNHdgQFyjPbFWigIQdL2HROflnBNvV+3I2SHA3aL5uO9LToMFqa+JE0wTgaIoIn
 utvwT6ZdO3DCPZL4f4gCrYh5ojtuwbCQ5AlkvUXhKafFO8VHMEVAsbq+2OKpvpsFzQzAYhBLdhz
 0drcM41/nABh/dqqfVxfjOADm6iOCJ6ehDmtumasFnwQB3Zc/nwUdtvw9vDgyart6YHY3E8yH8/
 yu+fU12ZbhGBTvJsW9ap+AR8j4Tr1kLNQE1w3EYSuw31poIhM8jmGC3prgsmBUpRoJ6SvcanVkH
 Aq0x1IpF5G8bwAnK3RiA+B38mCGRDuzHYUuky3gU=

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

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 41 ++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c | 31 ++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3633f4d28c3b..c9a211b7564b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3435,16 +3435,41 @@ xfs_alloc_read_agf(
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level));
-		ASSERT(pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level));
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
+		ok &= pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level);
+		ok &= pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level);
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
index 0fdb2a30e50d..482540a7e8e8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2785,12 +2785,35 @@ xfs_ialloc_read_agi(
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

