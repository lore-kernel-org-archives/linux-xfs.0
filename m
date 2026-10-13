Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687844BB263;
	Tue, 13 Oct 2026 09:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884495; cv=fail; b=qsGgRnGlgbs+3oAqaIQgCQYCISt1Zg/JadBqXhiFSZOoAKGDaJwpPQzOvl1iq+k8Q8ov291KS9T/+4Ci5RSPysTqFQwsJNXAFEPElEYCV/rfgHrTf20fjNBBx5sd+1qxMPsnVXuBlHhAWQDw7jXUbHDK5Lo47uo4dcao6LYZyAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884495; c=relaxed/simple;
	bh=nX/INH9j658EDkDGURREETAmdH1H4/wtpkalM9UeJ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lQiF36UVkckLI/euJN8dKUGY9HO0QgmGwMtxI4RBOoiw/esqdXu4UBfqkJ2M1oTp5yWS0rbSO9BSmLhGWFYnal3k5Lrn/nckKaxHIEBO13vOr3UQXLByBwdo3lwQfjWOSOpVSYa2y8//+cfVN5ZoxqX1DJaJC3bwZxraaL8Qxy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QSvcUjGS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kf6Vri4R; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QSvcUjGS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kf6Vri4R"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C4Y53198230;
	Tue, 13 Oct 2026 09:41:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OjzuJgWTDYcTfpIzqhuJ0/QLdD2na6oBcYPRe4DCl8Q=; b=
	QSvcUjGS1spfXq2AUg4zFwt74DNeLmqww24AptC/LXNVrFxhWK+iu8PLPHi73dbk
	qboRNnlHzoCwUHpa8UVk/X+5zWDWCFeCtj6ofICOFkga5XkoGOKJCL2WqpoOoXOK
	59emZTYmLLjReznqhlkMI+/EYdOnneNmAP4xbeFrEnqVUvfX8WhJrBmzuwi/5ClS
	mT7TEa6Xur5aASCc8AkjNNCPwThQzi8yJDPbzFsGHADebRXFIB46/QPG0lpnGmLR
	q78L3AoOOd4D4hg4gg0oidH1sLTrugROGlFANzlTv+DrNPFtRzsQ6TbQENcrr91v
	36hNrbRQJSRYJx0HbHB0eQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:41:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aUuH005460;
	Tue, 13 Oct 2026 09:41:29 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011052.outbound.protection.outlook.com [40.107.208.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2fj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:41:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JefH/e1Xqh81WKibGqmgB9uhPA0XnaD2g01CceRDwuF61Mfvux6kvVHmihFaH4VfZBjvTR8tPQMOMVVkHoMRZWibaA6s8nFVfVDlYP3pCcLjLPayA1FWHLLeHRFdgWEAH2bm/RjokbFwFIg8ljD1bNEs8CqIYlHB9GHt/q+VAMvm7dhHk8hdePSvTWXvWiHg4IfSwBZOhCl4/RcGuqKFv3HeEd5zzszwu/KjMso5Z2JdcR8C3Tc6ROEoS5LteWGEiVzBkKP5jk/wkABQgujwvCs/RDWjlCZOZVTN2sJu/Qt9av+TyppEHNYDODct3V/ylQ1dsTmR8Ckxjte06DPScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjzuJgWTDYcTfpIzqhuJ0/QLdD2na6oBcYPRe4DCl8Q=;
 b=SI9UW9mIXSOxQk6NdSrcPDVNEgjFv+EzG5PH9qzqgro5klWJSTYTdqKbdJNMXZ7HPkUQIiC5Ev8Pf3+QBiBtb27Asbu+Yyl6toJJDCkIVPzliaxO7Y1QF1INr4a6kzoBTlZBrEz31lb8Cvalr6ybez3DyIE+UzO2PJ9KUmnebBHoWrjUn4Rt6Bk1gHGTue/zTWju84ifMwVgT+BN6Rmz0njo10PiNr/EQ+10oOdiL5wnAK+k3qOpzGhP+mJ1LBq9ZNWAbzZk5H47IApMDIN0w5VJbI51YtyFz9+hYPgChFniMg8DL8W1/eE2Eq/STlvGBh4ZE20iM3nX/TxdoTPkTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjzuJgWTDYcTfpIzqhuJ0/QLdD2na6oBcYPRe4DCl8Q=;
 b=Kf6Vri4REx6Y5Xr8mpLRmmKwSUUh7y1eM2SNSWEipRjq9expfYJ0sHq4Nm1ckKThtp3KBmLeiv+jN0goLZt1mxeaci/T91yfeCIIZ5QpSzWffm+QQOtQNICQGL0EVk9sPGiuUCiOxjc7I/4UfdWXz589+CQoePCrM3vG06vbPcQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:41:27 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:41:27 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 18/19] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 15:09:47 +0530
Message-ID: <e20a4c889208bf5271a3f073ccf0b4ce0adf1b65.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN3PR01CA0027.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: a6e8b07b-5988-43ab-37df-08df290e2739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	c7vnFs8OQbXpS+C2hFksptWUSmVH6L4vOBn1VvcPlcdqKl3ZK/QNs899lXNstX6dPWeSXLkrqwhhTbtDKLhT0Re6Rppbb+3ne4SIP4NSSt0/WK7n6dGdelwQHe7JUIV85Ypt3yluFa8vSral9fLC3zHYHBubt1xVxaopMZSNLH75vX00Hc7+rFF4RGFbDdT+jzBp2B5AGhfx99BjNZMO4ePzNM+EYhv3RQdwOWUVA4PNZD85y3O1ruyeA3Yk0ypXucA/LZWKhxtNy60Ixzh+L5t9HhDIicpEn7R9ZtzvGFPD4IEMj2mk9RLKHJHeE8dA6K4sPOtdUV+1txCPSZ9F87dPRGwp3ZWEnoc0eWgfQSqemdA/QROyAJNOEOhF/opbsidoOsuziWdBmqOsRtQ/2Qyd2X7ggc+W6l7sJDEJH4oVTfYPBfvWWmm+KoaLABKZM7qTA4pfZgIAzSyCdWOzPaD4Dt5fw3Oa0gEU43y8bSAydo0yMR8lfsuKFHUgi2O34q73/uHaNCGnApnq1P2mAUazJiaYHagjf+Y70ZY1qI225EqEkrDDVPEZAwQhAwoWPny5LIv9HJwch6ZOKVstv+HlaCkjtsz732i1ZfYOmOsxRjqhSo1IlvB8eAZYkGU8x2SXrQkstLFNUVcL7rrnctII5lbi30mCj4F8/rtRC7U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oerMjRR5wQb3YbAZFl2uwkRLPsi8SR0P6/K6WnoMxN9yCMrweV1/KbdVgpH1?=
 =?us-ascii?Q?gQRim9P9nHU0HEaXugMEKRg8BAt9Af8/t/8sLgmZXyZ8a2L/e8JLPHQiJRBg?=
 =?us-ascii?Q?zkOz4ZvPyhU6XP3MSJ4KuFeePQpOI83Ah/ajb3enrfTYFvOCCfFmeltFtDph?=
 =?us-ascii?Q?c3uVkAGSPWT7l9YDBixvkjRyCO5V098YV8N6FKLrwRsnfr8+govjaRNCucwt?=
 =?us-ascii?Q?jHQnTYLhH7hJjXEsQ5fpYPdhhktzxfIGqRxz5LksWhXHo5aPn4h1fSuKfzhR?=
 =?us-ascii?Q?CborEX7rP0thST3uPf8oiQHG8147RcatIJPmM+g2LV9x9fACljhInElLUjwa?=
 =?us-ascii?Q?dRd5sOOcfZXBl9klVzGqk+vkqmLa8hzA9v1xdV0d5IXJ5wm5o0e3c1szc9WB?=
 =?us-ascii?Q?qM2t3xnqvpJ2vMF9t8W1CqezdieGKS7Gyz72hfdPaxrjpxQYEVyjcduxll9Y?=
 =?us-ascii?Q?1DTfuCNXPuRzEWTk0687FpqvO6LcgYyO5FGzHEuuBxLJLmC8C5YEpLeps7j+?=
 =?us-ascii?Q?tKIA+OptS4b5GXeyoAkrXbw0X03uvGFlU5ANN8SEK+1rtM8R3fXD10WXH8Cy?=
 =?us-ascii?Q?uwS5hpYwteivUJIDWy30qcG1zqiN+d+ixQD5brurCIQbR7WnKJ433ffPsVbi?=
 =?us-ascii?Q?rgDY3JR0ZNl+HASQowl5MYDbfQh5i9LRdGqw7yAMRg8rQfaRL6dinB1lAs5J?=
 =?us-ascii?Q?lRWLl2obO5wfqEScTEfUnNmZ/Jv8/NN1BmY/6OTTuZ0f6HnD3Jmo03mcZvH6?=
 =?us-ascii?Q?sFRdikS14DlxrEQVE/EHumJ8X96Ql5bSMufaUPuJspAWARgSIYB/PXwT2kGI?=
 =?us-ascii?Q?IvE0Bk4KWplbfyh+ZWp6UBc5pUpG8aqJcGAuxqVFIajaREBSntTRYxwBaByG?=
 =?us-ascii?Q?CKLo6YzX648g/qE9Afi2qv57YEg9U7Htp/WZQH8Iyj59eRMh75boKtu/+yNg?=
 =?us-ascii?Q?Ndff7ZV7KI9jv+3fkN28+awxdzK5vztWt8RgtV45Jtba+r84rNsevDJVclEK?=
 =?us-ascii?Q?dA489S3ls/+3NyAunpxFPRSKEun36Ba3bgOF2wiQbAmGuDyMXI4GavwIZEy2?=
 =?us-ascii?Q?WR9BPno74/O3oqmlwfzoyAZgTz7B7g7xwNzaqtkPhcioN5CQtFECkS9UxVSM?=
 =?us-ascii?Q?4tzBS+jdk1OT3HShIrWpjPuPyMxoNhtEZ20EEYhrT8AsobcD0EHh+/wd73uV?=
 =?us-ascii?Q?4wGR9UW4kR+C5tudqE3Z6ka3e5o/FiMDjEdWJ3nhnIoZQarRn6gN/7IYVKtB?=
 =?us-ascii?Q?Lr9kLKjvOs35BcQVNeSpjRh9JkFn9Isi9JPLIzamktYQnDom0b5JafRFD5Cp?=
 =?us-ascii?Q?5YCILukW+Moq9gwFVm0hFvYBm7UTwNmLUSd3TRtr7YCYgIlmD+9hbmCMT36O?=
 =?us-ascii?Q?ACu4g3gSixx+Gf7EsT4yBI9ysocbDmnthTuhMfmGXBLQUJR9V4PShVp3EWto?=
 =?us-ascii?Q?VLWp5dFKpztjI1e+mEvLzn2cOJTmljWVgQ7Kq7+/yEzFYAtjWYzz184vBU6t?=
 =?us-ascii?Q?z90LFY8eOgviDzoak2ChTdS8UtEQHb7etfcH/NuZpyUL5USJv4qvLgsLW6ag?=
 =?us-ascii?Q?KiEnOoOtlScV6V2oIBufFcdsfvzONBfhMo2FO39qsDMRYXdeRMFrNcj/EFEn?=
 =?us-ascii?Q?tqL5pWf5gfpLTWFQp6+wH7cxUqT/kljToNzqkGhuNxKGw1Z63Axr9Z+nIaZU?=
 =?us-ascii?Q?XPnYt3i/+IFf7obbklWW6qQSd7dTyA3f/Ya2q49fKnqflv2Wkj7JqETBRimq?=
 =?us-ascii?Q?GH0y1cdvbit50LW5mPKbJDy2FwGwPjxZpVPn4iwv/8BK5uc1LBC+kZMWo3XJ?=
X-MS-Exchange-AntiSpam-MessageData-1: 6qzBVR3zfI4KUTo1Fe97ti7hg1yHgr885yA=
X-Exchange-RoutingPolicyChecked:
	lCKbSfefRuKJ/erS4/OzUqXt5wDxwEf//hIHNAz8HYEpi3j5U06bRoytnvzTrsd+f7Mkgx7zjn5zMoVsFQpPcwAeTCAg8MRTQ3D/OQKuQVKetZSu0ry9cejgaBCN4Oi5ol7wdW79dghfQuIx7patr8jYgGddWq1XsBzFBfVGozRXdheP7wLmfxHSQtenFIKgv91QxWo0j7eiIluJiuneIW4L1ge7PhnKDSS9vn/eDR+q/q8x848Du3m+ggvCsQ8kxf/mCqIWSZz/TFHCxriFpVxm8JHV5iND/WAmnOe203H0uUTHiJi7CXAe9tKf5m6IZWDqZTUAiYtE36Ll6ZQrSw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	++xdSFSnrNMMVJJVD2mJonsaDy1i0K+wZ7r1uhRfcY2QC0JU4hM8x/D+Bn+kK9AJ1cDkVaKyjqv5vXNgyZGjAOtJ1JX7q4wvIY9CvNkZGEMxALk2XyhrjZAbF/SH8v1OpRRVHwqekEH8xUVbxhejnYUwioyX4+4/ikG3k9zRHIAVFbzatxxRu7AU9ZNXnfVt4zren1oJXyoFZG7pe5Ej+1LBZYnz/8KzzxFOnsplzjIFmsLYg8V6eUxtfg6qPdRozNnfpxEz4nT1F26f9jg1l7n/q+59vPtHHCzpUJNLqm19X0hJTzW3PQlvlojml0lP4W9E8WG1NVbrzrqg8zfg3rqTQEYp7pHDKAbTbu6Cc8jArcdhHaT6QWVmuJuxWQrp9YMVt03XAfr22brgIBicAr3p8cIX0oi6Xuh5ZwngtJ0G1xZpMPPylU8AkbjAxIOVuR6JlQ8k/ZUtsNl1HvH2UkGmmmvp5lT121k6vUnq5t0YrgOLF2dQsIY6ZxxBWQ0a6zCtkRL1MjSeysxGucvriyMtpqd9JVqAf7cw+pucKpxeIVUHOAuZOananakLBFYwSaGQjYEKvZIPcDQeATg05XHV8sKbJynqZ5/U1hOhSLw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e8b07b-5988-43ab-37df-08df290e2739
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:41:27.7937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fgxD43DpfPcf9ecM/9zotQ4xCUTxZ1XSLZDjUgU2jfSjnPMHdWjIKae05hMyiHcSoFQOi7i8yMXlJkAKWdVinYRBLk1Olujimw9maqN6r2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX727+gEYvRrp/
 3UGuZKxMIe8aa+eavKXeLMNLAEbVdc2gnCNoJRuidHk5hAyztOx3Ei6nIERMF3euIn1X+riA+Oh
 irV0tfk5VHoaI2PXGz54sc2d69Pm5Wk6iuBsZ0XyhNsg6lyFCxZa
X-Proofpoint-GUID: -g5mikbUUgIQWVG7AbJXJ-P_sEBqblWu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX4fqn2xCXVW0n
 9ukpteeYhOVTNq2H+BD/mxpH35S6tGI9lWekHGs8idMlJCH8KWTN/EUDDH4Ht/cScIhln0x0Q+l
 hd2WIJuc0F3MwE7xFUHutDp+sJZKiHENDCxz4TFaJjcuR6vgLlJHB23CzpBcmi3Fw/lJmd7gj/D
 JVGVrJTpGfbFpYuB9b1fbTHB63l5SrORRt1HiPEL++RABWSPX4A6nW1FmE5zko7vTIsxDAn7ASO
 HzkUYIsHnt4mMkRWQLAxJe36l8773mH7qs+oD/XeoPL02SkMiHK8A54QMdzn3fA0G9ao2ctDXsy
 woIuIWBFHvJ0LjgYibvfu0C+/iQcruLFRiNFQJFs56OLhVEVbfwWK6bC0cl8cUpAxv88xQusIKY
 S/am+Q/Vu1koR7jQhDoi2CHGCBsjJrLMrTWeIgG76butiR1LUpqMBJN/V0mrflsGwu11/M8siSB
 uri9DcOT/SAJv7G7+zw==
X-Proofpoint-ORIG-GUID: -g5mikbUUgIQWVG7AbJXJ-P_sEBqblWu
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfcca cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3124f96ad6b3..3a96279f97a1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -459,6 +459,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -508,13 +544,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -525,22 +554,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

