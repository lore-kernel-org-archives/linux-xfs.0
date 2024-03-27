Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3212A2A;
	Wed, 27 Mar 2024 00:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498371; cv=fail; b=DhRbdo+kDv/qAo2Kn5kwd0mp07KY6fYzn3nw4MkX7l/BlrunpnmDeQKqTlWgVBD3grRarbDj11uGzhef2m3BSE6YJTJnWIi9UD1GjVgGgWcBEsEkOa1XIyQQ6BWVCQmY73+C7s9mv0LZFA5H2elwKBksxfipHfBKVSbI36T3QqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498371; c=relaxed/simple;
	bh=z3x3D0uP5Uf43xzYr8aToVT4uQ6YgEwi1uR9fa/Nd3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sdwVM+tNI+ipY1TjeoUY5Ftg7mMPHSUMwWBd85X0qn8+88gdWuEQ2YionV5r5KoVPrTkxzNrQQIDXuaoX87PnbKfCaeHMffTF72CeLM9UTEprGzedsdqB4smpBmNxrF0acvdvCIFj9AOx40HyghaocSXrdlQg8WHAxdLtRVYWFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m9VMHur4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ECrJ5QDA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m9VMHur4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ECrJ5QDA"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLibh3032020;
	Wed, 27 Mar 2024 00:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=OHbepO+vOat9oHV3I0+C9Q0b7W4yYaoTObUT1FLVO/Y=;
 b=m9VMHur4HPK29MO445jNaWZJYEpaMHdoTp35dUo1fvQvxqf4w/a5ufWBQD3Kk/18jDFd
 4LHz9fzufZIHjnyLnKiKALEOM/ntUT99QxLsCwvbUCrJs578WMHDR4WsodKEzEOqGnKA
 7cYV9tgkm0HOrdpnPaTV0JH682bUu4RdaA2eKmNkAY6xJ4h6guHS9L+6JkKYYvW6hcg/
 lv7f6ccikUNA4NzfcycixAG1M8d/PLQdSwEpIi489NhIdFKen/9yaft3BcS1qmBHeXGX
 2ALIsx1UeFcMQc/P/XwPPocdyF3IemMHQkqI5wzGXpl184atYw+y4bkpchbXcutdS7I/ 6A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct5n2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R05Hv3004731;
	Wed, 27 Mar 2024 00:12:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh80hmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnZN3xnha8P1nm32shRZvoOojq3b1YKhM2ANGqMtaEqv8fTLtDjOrpKFeXXrYw4DKvknsittIJY/H7j+67Hgwv2wSxh7QCS6hDZxJJg6mC2xFLiHMKX2ZlqNEnjD/PA8q++OPNOuQG7jUKVtcXOXhiC41EUaRuo/HhNXRQGXKjrii2KGVsiO4kadJ03vCXrVXXdJsxt4C1ot8UZ06McKM7p21RPawhk/MrZHJ7qCkGmyMoqI/U84FufiDUIILtm2SbBR42KlJbFGzf+5SAU4IOqil6FN1B42ccB07SKHeHaWcZmZwEjFSVW7XyoiQCWwgKTNrQlneAk97bIEYOXyhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHbepO+vOat9oHV3I0+C9Q0b7W4yYaoTObUT1FLVO/Y=;
 b=Y1hriiTKavHI8LTXnZRB5e6CEhdT0eQgm7OhzROaqsSFS9RP1V70GBtTVTcgXYg0ZivxaCs3QM1JsvuvsowwRl09R5Z1lxI0v1bgXM3IN8ERZLWNBiZdHF8lseGncCJnjHUlJWQksgWPW301L4U9uGvHWt/6wRkQaQitYgWO/fr/4tEreK5yfgMIfX7EuR1gb9V65pKydHag0sB2u5fPnRZ3vwSw9WTObYAQ7fncOG9uW/ICaM8t5VGE4wo2BkwhUS4VANLsYIAjnZM73zTD6l1+GOqn+pc07z/wvWm4zv5R8/hsg7IQ+lm7dURwQ+3X3SdpVeBfPC3T+cpUjLZP5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHbepO+vOat9oHV3I0+C9Q0b7W4yYaoTObUT1FLVO/Y=;
 b=ECrJ5QDAsg90dFKn7PLSHQicgpFMm/cLzenv3VNmtDjPIhwz4cuF0FKcr8htaXX+0S8PrCZIq8ikl8+Pg0jrhK6KsDokLP3iN5GT4wTQ5Mbb5G/lmE4f3TZUVTe3UVe8RTLXbb3eN44vQn9nlkrog2lsTIMS5hw1oUdF+ZCBetY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6226.namprd10.prod.outlook.com (2603:10b6:510:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:12:45 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 01/24] xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
Date: Tue, 26 Mar 2024 17:12:10 -0700
Message-Id: <20240327001233.51675-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PM1XpvGfSp2QcGxWCchRDeTHXuzmW5n7qWyCB7ClZomxS6rRJj3g5R2s9MisD1CZXCc0g7mMEWpZxPFIzxZLKAC1PnyjkBqz2k7Y1SVXxGIwxpT+Z3+D7uS1c6zW7rugkzTpYwvi1KI/Uw2QbaWp/ZMYOknet8nUE2AI7orb516vg8yHkDtvwU+x8uLMGwBvJYyhVk3trQHGYW2IVvTh5qahDNT89saw2Sz+nKJDZ7Qv/Q8aZBxiMTg4G2bvwQ9Ydo/DjyhcOCFB0xv/VCFeWXXVpuz+6aBPtZp02Gel5Kan73vE/oz51no/lstUBtHk1jI3vHozvP53m0Ij+hqn16N6qDG9hugq33ysqxHnydXHXF/pMEm4LkwOvE8JBZs/1qLX68DADZTDTZvaYZQPhQW8JNE/tGga2UQ6zTdZWgRzC/GQQ0eH15273ndO5DatyFB/+pviSBud7vuG+julXKT2RXMKdtwdbtcTenulOVRWv/FgT8Pz1MPpxZhSVCfcwsaPFgiQ/eq+NqZyE+5RAYEHiOEZdpn8SiUl0+oOZkSqc0Y5mbsCci5qkPOduAVOTN63tjNJhhsj39PGSl7N12TbjuLeSOO2ozdRZqjmiTQM6wCbS6jrwa6TDoyBw6zQP22Qp4COcAE5aHbf5hZhHiqmAIOSrDeCd5QvS+9QsQM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wZPxBok49wT3cbsjw1jnLscdnJbwn/0QHToVwzM7/IntSM6Hk3k1QAFZYzrr?=
 =?us-ascii?Q?1YcBVJKQ4fMrmIWU1M5nI/Xieq0uJr88nJMpuFHA4SZWFnsZ7/tKZOF1dQDv?=
 =?us-ascii?Q?y0Ib6Hb+Zkm1VCtEDcLDGnYqJ9RSS1PXZwTWfk5xUzrT28gicVfZTloUTe5w?=
 =?us-ascii?Q?YmFtzm2q8JTkAS/G3Qq3dGT/DfAn/sJaPY4O95smeWZ3etgzDn9WePbiSDdr?=
 =?us-ascii?Q?f6/dbZLjdbeXq+krWbvN9E3/Rm907zNKxSdGx7wE+ffGap18BgH/dz6o4u5U?=
 =?us-ascii?Q?6eoZp1dZGZ6ZTK90FzNc9I1UCye4KjvTC5ZQvI9AzcVhPBuwD80oxszjmegL?=
 =?us-ascii?Q?v95ky1baFw998kLLAi0M+4pg0+WF7pwwFVNW5SnrQRaNx/XJUkzqDTLT08KQ?=
 =?us-ascii?Q?d3ooopbqQxEBS4ZyEgCmZ2OkXbcT4xk57sZHe1WU4GQgj+8fX4iVUFTzl6og?=
 =?us-ascii?Q?lUCKYvbQ4Mb7+hcuMAqG/Jghnz0mQ2t5m0pZy6Iim73zICtvTNRJt2FnWIGp?=
 =?us-ascii?Q?BbYMm4ftNa67DwBH5TTCPr21u3fcaxa3pxijRtjOtF1v1nGZSZ1YZZae6S3y?=
 =?us-ascii?Q?gFOEMZWvZ5MNZqFOuVSVSU0OV+Vobcy3n0xFHI+FoMbdCqP3tu+gqhRJxUnL?=
 =?us-ascii?Q?1QB/9NV1jRucyY/qBiml6pEFPNy2Y8TCaMgDQR+uiLCR5BdF5ybsWX+gYqwR?=
 =?us-ascii?Q?ij8CyK6wMVITJjPRmWstjX4IunsTQ+ncspxDo1lkzz/Whsc6dKBeFCX4jKT1?=
 =?us-ascii?Q?WqeppB5MOwbzorZgzJEEtJOlgL7MdcBV3iWDWNmlg0bQepaPsWXDuuJIQj94?=
 =?us-ascii?Q?SjQqh7lBJz4U0I5JYDLn7Tht/NaWZ8GyvOCytWPiv2Jy6MWgapSLY6EQ6Bje?=
 =?us-ascii?Q?hV6cegeYMW2qsA/QiqgPgZ9O929FI1hd2MER1867TW0Gq7HlHwa0gDLC03Rj?=
 =?us-ascii?Q?sfUF4I4/i3cpyhr0Ax1ARuc4LSdUEyebkEwPF0Yh7O1l2chBhBtjuB66uzd4?=
 =?us-ascii?Q?Rgv7CwUUWCuZ3z9EvaU2jLqwXVjF1iMur0hEpG0b4KCP1Old2nvDfpgWRM7j?=
 =?us-ascii?Q?MDJl21RL+WEPYrQTC1gHVQDo2b2uYY4UlSUKcQL1EO3FY4n1gSzJ8t1QAPB3?=
 =?us-ascii?Q?0B/YA0EG7fmtAq06zXGL9EfLpC8SvmvlnmgaHA7aKIJIkihHnfUNdp6QEslx?=
 =?us-ascii?Q?prQOUkOUnbHwP/cm3E9iJoi5G4ebr6BrmVQkuFvKpw2ton7UAeqmGwafQYJ4?=
 =?us-ascii?Q?4EKSts2XudEtUft9+/nEzUC1GylCvoHKaDpaokWrU152EAGx2S595DwlLLv0?=
 =?us-ascii?Q?yfIJf8IwZKqQ3+WyhvbEWyfnw5ihG7iA6056jM5fF5SpJeTltfcRSt1I9BFZ?=
 =?us-ascii?Q?bD5AV9oqwPjDpKuiXcMdB8bZPWEM/dcomxo57l9iEInbVC1zj+udSFTGUwlV?=
 =?us-ascii?Q?PGjEt+ORWPPrEWwqwBta4+CTSOp/6NvHdehs8i0X8ub9Q7E6Ben0Sa9PipcK?=
 =?us-ascii?Q?LmE831HqFCEyg8NKVbVaO0okhpR20Uw3Vt61MCeC+1BOvzg915GXkXqeOtTp?=
 =?us-ascii?Q?53bs51i7WTmC5CXDbmoJFGBttSqF9EUBnkmv14kFJOMkL7zJxEGGAw0r+RtL?=
 =?us-ascii?Q?oAWm7JtL+knM2qi3lMZQ8RnU1Mupv9/kYc5VtU5NoiLj/MO4toJW7Ag3f0V4?=
 =?us-ascii?Q?Lp3Glg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	N7rlVKitxw9yxuPRuEH7Qlbg7FLWlt8aFb2nAMhJ7DsNK0cHI5yFwWKGH196g0SGZNPN1/djDZie8kzxRXezOZcXr1pHvRpgCz/OxO13/qTRq4wpUoQR/koT/VLMgoHyndYN4KmpHxKk4Vqqqbb6Uhl4Y/gVoPnAyiB2wefpIA80AJAYcnKd8siYQPpt9n10uUR/kf/PKT8L/oZcLXO1USIDTkgXRDK/Zb33KVaS9DXbe3lDBlz1xER9Gyg+sFjJAUEaeThn9LjHkz8O7yXWnctANXh0DmJmdLWj0jFHyP1nEGez1RwrxvIrEcd/evLrRK7L5+BQpIUMQHv1DMIiZWfIO2xrutsLL6Sx8WWQkLD5wUdwsaQpUNDGwHG5ZcrZFBxC1VFG+MhkPcZ3joRiNLh6OGvLlBvQNSpWvJdmF1iTvF10SfRZR7woNbXjoRDcKA4BsCtHfD6FPAPG1gViVMUUDBrkPCDivK8qSw9XGUR2eCpNwIfUZZaFbiP2vDXJSpWhFJ7PkeFHImt8VqAiipxavlZ8xCWfFn100a9hfyoZsa3H1XnsjVlmj1RJSAegqb+UGyv+Os6BRDeUDpPzOhAlTt6sZ5ylYxlqaiwpZ9s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4b1af0-0e79-4be3-6184-08dc4df2a084
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:45.2062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMTUV6LCoUE32it8E3M4BW240gdolWcKXZmXNO6zWhiu1AIc4Zz/gjJ5Wi+UXkIbU5T6uEp22vR5OTTBwSiDgIXhMJ1S8zYp/5u5yyTTV1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: BIpRWHHL_PpyzyKgxZ9PjNH8C4AIg1Yg
X-Proofpoint-ORIG-GUID: BIpRWHHL_PpyzyKgxZ9PjNH8C4AIg1Yg

From: "Darrick J. Wong" <djwong@kernel.org>

commit 13928113fc5b5e79c91796290a99ed991ac0efe2 upstream.

Move all the declarations for functionality in xfs_rtbitmap.c into a
separate xfs_rtbitmap.h header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |  2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c |  1 +
 fs/xfs/libxfs/xfs_rtbitmap.h | 82 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/fscounters.c    |  2 +-
 fs/xfs/scrub/rtbitmap.c      |  2 +-
 fs/xfs/scrub/rtsummary.c     |  2 +-
 fs/xfs/xfs_fsmap.c           |  2 +-
 fs/xfs/xfs_rtalloc.c         |  1 +
 fs/xfs/xfs_rtalloc.h         | 73 --------------------------------
 9 files changed, 89 insertions(+), 78 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 617cc7e78e38..a47da8d3d1bc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -21,7 +21,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 655108a4cd05..9eb1b5aa7e35 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
new file mode 100644
index 000000000000..546dea34bb37
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_RTBITMAP_H__
+#define	__XFS_RTBITMAP_H__
+
+/*
+ * XXX: Most of the realtime allocation functions deal in units of realtime
+ * extents, not realtime blocks.  This looks funny when paired with the type
+ * name and screams for a larger cleanup.
+ */
+struct xfs_rtalloc_rec {
+	xfs_rtblock_t		ar_startext;
+	xfs_rtblock_t		ar_extcount;
+};
+
+typedef int (*xfs_rtalloc_query_range_fn)(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv);
+
+#ifdef CONFIG_XFS_RT
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t *new, int *stat);
+int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
+			     int log, xfs_rtblock_t bbno, int delta,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     xfs_suminfo_t *sum);
+int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
+			 xfs_fsblock_t *rsb);
+int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		     xfs_rtblock_t start, xfs_extlen_t len,
+		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		const struct xfs_rtalloc_rec *low_rec,
+		const struct xfs_rtalloc_rec *high_rec,
+		xfs_rtalloc_query_range_fn fn, void *priv);
+int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
+			  xfs_rtalloc_query_range_fn fn,
+			  void *priv);
+bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_extlen_t len,
+			       bool *is_free);
+/*
+ * Free an extent in the realtime subvolume.  Length is expressed in
+ * realtime extents, as is the block number.
+ */
+int					/* error */
+xfs_rtfree_extent(
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_rtblock_t		bno,	/* starting block number to free */
+	xfs_extlen_t		len);	/* length of extent freed */
+
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+#else /* CONFIG_XFS_RT */
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 05be757668bb..5799e9a94f1f 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -16,7 +16,7 @@
 #include "xfs_health.h"
 #include "xfs_btree.h"
 #include "xfs_ag.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 008ddb599e13..2e5fd52f7af3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -11,7 +11,7 @@
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 437ed9acbb27..f4635a920470 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -13,7 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 736e5545f584..8982c5d6cbd0 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -23,7 +23,7 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0e4e2df08aed..f2eb0c8b595d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -19,6 +19,7 @@
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Read and return the summary information for a given extent size,
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 65c284e9d33e..11859c259a1c 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -11,22 +11,6 @@
 struct xfs_mount;
 struct xfs_trans;
 
-/*
- * XXX: Most of the realtime allocation functions deal in units of realtime
- * extents, not realtime blocks.  This looks funny when paired with the type
- * name and screams for a larger cleanup.
- */
-struct xfs_rtalloc_rec {
-	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
-};
-
-typedef int (*xfs_rtalloc_query_range_fn)(
-	struct xfs_mount		*mp,
-	struct xfs_trans		*tp,
-	const struct xfs_rtalloc_rec	*rec,
-	void				*priv);
-
 #ifdef CONFIG_XFS_RT
 /*
  * Function prototypes for exported functions.
@@ -48,19 +32,6 @@ xfs_rtallocate_extent(
 	xfs_extlen_t		prod,	/* extent product factor */
 	xfs_rtblock_t		*rtblock); /* out: start block allocated */
 
-/*
- * Free an extent in the realtime subvolume.  Length is expressed in
- * realtime extents, as is the block number.
- */
-int					/* error */
-xfs_rtfree_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to free */
-	xfs_extlen_t		len);	/* length of extent freed */
-
-/* Same as above, but in units of rt blocks. */
-int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
-		xfs_filblks_t rtlen);
 
 /*
  * Initialize realtime fields in the mount structure.
@@ -102,55 +73,11 @@ xfs_growfs_rt(
 	struct xfs_mount	*mp,	/* file system mount structure */
 	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
 
-/*
- * From xfs_rtbitmap.c
- */
-int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
-int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtblock_t start, xfs_extlen_t len, int val,
-		      xfs_rtblock_t *new, int *stat);
-int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_extlen_t len, int val);
-int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
-			     xfs_suminfo_t *sum);
-int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
-int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtblock_t start, xfs_extlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
-int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		const struct xfs_rtalloc_rec *low_rec,
-		const struct xfs_rtalloc_rec *high_rec,
-		xfs_rtalloc_query_range_fn fn, void *priv);
-int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
-			  xfs_rtalloc_query_range_fn fn,
-			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_extlen_t len,
-			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
-# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
-# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
-# define xfs_verify_rtbno(m, r)				(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(
-- 
2.39.3

