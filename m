Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FA44B8DE8;
	Tue, 13 Oct 2026 09:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884487; cv=fail; b=Y+jCPcNASqbCGbRfovKFHyUD7M5GFcMlhlmICUvZgO5SWIeln7JJtHiu2MVU32pALAKUyqNU83qt4YnzcrNMwxkM54z8eMnxeZQqbMqTHXEG+xknQT26Hu+BqdGkjiRVvwbzVflTdqSe3Fr21Ons0sDOKx7p7uENK7btf38DTmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884487; c=relaxed/simple;
	bh=/ABxByly2xahCvxnnNK5zTV/rUW/CU2fb118Q//KZfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LGFdy8eawEC1J8CYhUy3fGqpHcHFWkGUJOJGKwoK0jLvynybcbkAhpGa12GDWF7CqJsrkoL9qlXC659Gk/OJYejFdIkUgOSFLeJf0sywUDaZTmLrBQP1iyhnGjSibp21qlZHtypIqPbx0zUlOHXKq2HDgJfcMbk9XvQbVxCIb1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OyBncnao; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E4okkiHs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OyBncnao";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E4okkiHs"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BsNu3030638;
	Tue, 13 Oct 2026 09:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1Z4IUJsZqIou8LEfjiV+wwFxe0ODmmEk4MjnBWvadgw=; b=
	OyBncnao60iT7kZEHZvPy00Es6sw9r4NZFRHqITgk8drfI/wKp78XEi6MZuFf5KX
	2BtA818Pg1XdQClGyKrpvfmwffG+7Io6huMP/D63OpjDcG1PJuIVnto5AYnUCaW1
	fZwVghxjyFFzgsryMwkhvRm6PM+YYkjI/PDyBPJfR1q/+1BCPOSaaOBkUVRwHT/c
	hHE2LvZYLrdJp8Po82FMr26XwUkqyO2i0VI/RYUKkuAZmSOLRe1p05Zi13Ehu8Ub
	Y1EmEkWrdYtUXIKjsPVFVjDh+CvJO/9z3lSRLRogEi580TObFf2g7lnTsRBE3p90
	BzgmUOrkVwoy29tG8GhG5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:41:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aSLc005352;
	Tue, 13 Oct 2026 09:41:21 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012045.outbound.protection.outlook.com [52.101.53.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2fcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:41:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nAw1EeyyWixSZUMdZCA0D+GpVSM2EDMfG0Qy9kDd3UBucJDdHBhUA6K8C/+d1vhAxpFQTCYLIHTZ0KM7bMiY9nF/7Fthcz3CjjHPf4dwQqNPJdvSB7BURoBVyLzEWWJ96ydXKzbAfPQ3Ttyszgtqz8FYkj0XsyXa364tPWbycVjFnIe2ddsi9gthAuBJeuYkRWKpjkS2iHK06E1vErD/d/nFzXCL3DvxZ9beIiFpT5y+Y88tZ1gQbE/LOs04rOe1tzPBjkQK1znTk2v3ucN4eGLhAww0vkLSsUp3eVO70/fPg73VOxXNF3qRcRezMiqRokNIcgZkaJCe1NcKfR8HJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Z4IUJsZqIou8LEfjiV+wwFxe0ODmmEk4MjnBWvadgw=;
 b=k2SNFrk6ny2SHsvn83nQwIQsW10CPO5SFWfnPJCucxaHWPMasfFjyG0OXQNYhzBu9uc5jPO4GvYio5xoG7mfak3EtranH+3AZtcFz+E0UAKCI45ZA2OV7NRGYu+VWdelkcMGU3fP7yqh5FXIpCda9Mih2PSZ4XwHSU/5nzqFvNo+hmR+rsuURMpC+ihiXTt4MYEK96Q5I6DMHe5vfpW4GySmN5uGAvUcC3+VA2AWxll19qIVll0BYym/TROdWcMgd4eYmQBJvX9Wu/VG239/SmUgZne+pRMT+aZ4OgmrGW6r+sz/x5Js8yBqt0Q0nO0z7Nh8ALTJz//LoyUmjbaRCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Z4IUJsZqIou8LEfjiV+wwFxe0ODmmEk4MjnBWvadgw=;
 b=E4okkiHs9vHOoAIyggwHF7MwA3+JZP4A5BIwU14Fb9ExtnJXsEhrKdOkPZ/EVk/ilflP8tFdBssh8xbXj47naG0Y5wboylDWHwGrRiohD7UIf1w+JtNSKmgSOTHpXpcvfe/5YlmUSBz6ZuTTNsONoA5sXkccHMP7EAkb6gwTNcQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:41:17 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:41:17 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 16/19] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 15:09:45 +0530
Message-ID: <bf150c7e5c060160c6c1f08eaf00f3c47f411ac0.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN2PR01CA0224.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::19) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 578aea36-f349-489c-8df0-08df290e2113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	eIzj1BMLma0wmD9NAaq8nv3TaB5Qu5xWp/7T6z35eS+auklKAnzZEEG9HdO3uPusM9RGKu/zEyt3gmumEbveR7eLIaBrEStCUiRp82hv9qPrNbcsfbqs5QlYdSXfU04NiNkFFUQopcChCBpDsAkb5sQDwurt0tUmsO3LaOTTQSMxtJXS27pBDJSfZU6PYTHARFvUvedRymtvikxHx/ABGae69ztuskSDiIcupbS6MesUC/BMNa1iN7WGSIPkyQzsGXSP5LD9nuf2iuYYGezW6u1SC/sHRbzjlE+Mp3ES+/gsdt0UIy+xq7MLd3YLvA1xmgKg2BNbrhOWdOmShXYtCFhF6L3LGA0E2ZbjHvISlqhIR0Y0GPWh0ACgFwcaT9DZhMplZDRzKVPnuG+3LJ30JVo40bNbsuSputm/E5sHBtykWAPMkMh1LKd4S+iQNhhOynKGq+8ZBz81p21GrQFOzp81yx/CWygeS5gqKr/Pi6MVt1aneFcNIr4pnbv2RWESfMNZLPuRoRioxRC9Teoa4QMcmKBBpqqN2W8+5o3c8UQLVlLFaqLxnBUoBS8uio/JHfVrQLZfAxl1kI7bVwrSAnA28oaruPE7ux2lHNZZgiUYYQfzxrV1bTmPnstYCmjbdBzqFUrt1fNxdRXPFBjRFiRLKBNNVVIAI9ZFd6Aoka4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L/2wkYY4iBFpGm4pb1NUSlIE+yFw4E2So5c1T1FrSozl+MeE6Sh70RSS+4bO?=
 =?us-ascii?Q?W0cyxFCNx9j8L+TqVKEHgx0CZ9zNiQdibBF7qj1rEfCzuOtmeqtifYCBrWP/?=
 =?us-ascii?Q?h3KHZeH6PWR4/lqCNbdNY+rmn3zp+FVE7RzF1OJCaoPvK5k2hhpHnaIFAqW3?=
 =?us-ascii?Q?PFfIvlI2FJ9VTgThL85cIEUqaa72M2QPf3OozQegg6oF4INaM7LyM5FG3wPj?=
 =?us-ascii?Q?AVpY3vLyV9dkl/lfeWZHAqz7UQfos0hHrJjFV+SPPeX1ZISfu7BfAGjys5d3?=
 =?us-ascii?Q?E+c5OOy4JWTlMx6sG301l8bjSaZW1IZkXzFkoxAnzZUG2xGeBK1+GZgyWVHu?=
 =?us-ascii?Q?WdI/RPROZxvZex0ZsxeKqMqfKDUYCOR2sId3wTQsSrMKUKbhgCE5W2IMCJ4N?=
 =?us-ascii?Q?w/gNLhxw5u0SKYomE/9ADuRszLszPetpjhaK1ScL3vdbbKUMxzp1cK4opSon?=
 =?us-ascii?Q?Ygzh9ZnIuI13xLoaQBAFt+TnEij8ZkcA6AV+/FS+NT7rZT/9xPrqKOY5oMww?=
 =?us-ascii?Q?zP16MJ3m53WLfWrZA9tzpjZIobS3clJI2T6aId/fxmrLwJ9mMhXUt66T4C3J?=
 =?us-ascii?Q?fjASTiiVNvSHQMLg4GaSs04AmhKxffQG6TCJV4G4Z9gyFOglpXlXwHwZZ2lo?=
 =?us-ascii?Q?Dm6uNA4Y4XbhE4TS0zGFAXF4GG+qeSpqWiUYvhAvqdz0NHmZRxFgNbwTtU2h?=
 =?us-ascii?Q?kKM19Dxhb3g/7jqrC4iRVW+UPBE98XaqPWt3gT85Mt6BXbrkLJxNDjw2DffM?=
 =?us-ascii?Q?8NqTx1myt+B44Wz+2e+gBMpmy20W6KpsyIj74W4gvDOAZalQ3qOrLJYezVnx?=
 =?us-ascii?Q?LOXY1bXpmdGJNU0DIeiYclVfeonFrG0I6hcm3GtLDxw7fv0yYEU0m4444kum?=
 =?us-ascii?Q?gF3XO9zMbJvVp4xu+W2wyEfEicV3/b8z6/sOTyAKZ2xkh2IQ0wxxSirBIg2k?=
 =?us-ascii?Q?dJPm7r/VaWQulWXdz7HqmeN+w1+gIBMGrJwLCZ0+SnmUDxtNd0zMNRqUiZZA?=
 =?us-ascii?Q?tjTZliUQMveGl230gDfurV4NdIzclyBqyEyLNx6tSknuO5vju83AhLL2DNSX?=
 =?us-ascii?Q?W7BCzw+JnYV152n+09i4NbImPRbIyd4R+9AWHhh5GI+KbLi1DktFP8p60b8f?=
 =?us-ascii?Q?a2UmNGJ+brRSu3pFvj2KGc5b9VhQCd9acK/5k5z4wqZCEUYCa1ZnPK5TTkWE?=
 =?us-ascii?Q?1qUDyYwv5HI9GO3q5w5HunU6bsQznsY9ZRO/xJBFEqgqe1DKgTCDAVsfzj/h?=
 =?us-ascii?Q?46P1PX7Lhp++H6aYdh25o828q6Ol5pkEiUhW25AV4O+FddHZrZTJjS1fd2a0?=
 =?us-ascii?Q?7y2EW7AubP3NKbYwjapYyEyls8vAhBKPjCU5S7fQ32yksnlxGBsjJDX64Qj3?=
 =?us-ascii?Q?yYpz9DBKkc46ms014a62z7qkYBlSuLhEpMfzu/k54s3xp8e8rZENIcgaV1UL?=
 =?us-ascii?Q?A/h2ajyWxxYSkhFFwZnyD991Rw73+m/L/c6YMSAb+l+pejqHnUyqASUCBcNc?=
 =?us-ascii?Q?n8nliJKf7Hy/rUij1ufRcXHza8ckZg7P2TQpWiQwlFxoJKB5nKAPolO1gffg?=
 =?us-ascii?Q?HVKtWRaTxLuiTkqITd1+oqPdhdaW5K022Bt4Svj4TJwtKUAetS5zi8nCW+Zf?=
 =?us-ascii?Q?gHnmd1ZxZI9UaPVbv9s5A0G+NmdXd3CTv4OhAZJ8g9wUSRnaRw4Q0BD6SUgG?=
 =?us-ascii?Q?vPGtknRtij+rRsfku2mj4Ie31mT4rjFLERLgxdC7k6Wb5jbace58b8b1gjBY?=
 =?us-ascii?Q?1qNTawuM/3fCsfBW03FunJ+L3jnB9sRE+DmoIdELnHZKDdGi/3xa/d3MqR1L?=
X-MS-Exchange-AntiSpam-MessageData-1: WcrMiR/ZVBBmgYAIbNNDEVBit+vTP1Rmy8o=
X-Exchange-RoutingPolicyChecked:
	rfZ+1NVNaacZWFmX7cCyq2PiOoJIbjQW5Xdche2vmATwImrmZR2XEG2leup2IItXC1J8kA6U5WUviX8xlWr4Nsx0IWYUMiNB/nCsPxJ13Nbr5Nu2BPif6KADU/ckOa0nK7chn9bjf9zSFQU4CfxN5Tv0opd6rOn1wYQnFHsgMJxRCf9uJvOxTu41EoWPb7KXpCUdGWMrj93DrqqBMJi9fm/f4VbJ5YN2L/lg2/CqmoEqkVEcFkR68x23m47nxzXpqxfYJ/3VbzVtmDaEx3PasYEUsgdvi1WJ0Fe/dytPCDANDen9VK68CORH4pZYmdo2d3yCF98qNGPSEIa99mS87w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IQnbSqBkkko+ct1ntCU5RQ8mf+QJeXXXboGGqPGQycS4Yc9sKIBMtEEzkWhH2HY9bOGS3OM9feQanD8LRl7okhFkQVKHx3m/yibJLnzFHMcR5TCKBSRTqeFgqZ2hdz+/jbGzFq0TgpZ2ZEsMOd6FnT84pfQUS8x3BejZuzIZ7x9xOZMFNF03/D4ILfOX3ZuVsUf82lnhYnLT8kz1rIG0sILlTr/OkOmBnMb9//wdy3RVvgeu2v5LMHvbXCqB4ht1zhAWttZq0YRFyWIBsdKRlC7M8NkSBWZlLxOKG+XR7Cysyh/ybzYQP4vSzl3NcskTSDwPGxWCxuBk2JOCA3J7cPfpzi12LLUuT5e4mxy/sJXWMGPYxY6SHXg2umxWQHHajwqh72lWyDmJEhHtDY/al+p3j75y670QYRpJkUbHAhVOrclBICG47XIOArhhqtcF2hGBr2m34cGw1Tvypde4zPiXTngzJFdh4EflLPkbf+nVdqmk9roJw2HD9sgYJz7Znx73oit7DL06FV4rYF77gwbKXyVc/ptDmXEpJKa02ME2599vm3E7DDpjgw9gWoIusHPxRzXdfi4fK3aDIMGSc68lrKlw/xHj45LN2rBM0fI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 578aea36-f349-489c-8df0-08df290e2113
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:41:17.2564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4PHBpFsuxN9goo9U8coOt2pPSoCWx5LiSDfi6/isPR6APhPd/LJrt+y6eF8bx2DetpajgZrbiEecGzISPizZ492QLGFvKG7q/eWL5ZAi7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXzAtxpXDfysxw
 pQMZhCvnhBIfccRNPH2IwMnFOvK6mP8sIwEtPA8tJN7YvENMADRV81aq90IE4jih2XGycuE/+ub
 HASoXIPGRbodngmXLcomtghW0ULHSYqbUuhvBhS0ObY154FvzT2bhlUeyxhkgDdS2XhvPUmFiMO
 UxUsGrpRbCpvLcsVQ5UfJu8nmq4iGzkS445yin/HDkcSVMKuF9Jk2B1sYH04TSTdeGk2FoeeULD
 9ZOiYupwA032aCSEI4mMyDfv3Y/caDnjGXPRcerRSOgqc0I2bhcOYUeUo0sr1KZuMXsq0VraulE
 OF8Mpe8bxqAllDFFfFq7T9L4ssFGPq4M+Au7PS6b8zs1huEUbhi5YH6J8fElHVb0nKsxTYkU7B8
 FPpIKvIIEAWwAnNR7hqMVZ6NtsA9hjvSNlPqpGo4XbO+2LpNOS31ujFvu2ScnFGCHJOHda5C+wf
 fpnnRm1KGUy0tUfcV8w==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfcc1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=pCazNFhamJdtUKLgDfYA:9
X-Proofpoint-ORIG-GUID: XamXQ0qIgHCIWTNoK7jh-gL2Py8nAuKc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXxyx93fIknlwS
 32OpjbBZ31vLh/BWknmCbvAgD0ZvevUjzT2ZMjuIelrpRv5alj51U6I6ZR4ctdzZmHEvS3vkNAT
 9vl9z9+sNcKnj8fuvBjBhSmaJ62d7JK4LWuZsmjF81udn3PmiOvA
X-Proofpoint-GUID: XamXQ0qIgHCIWTNoK7jh-gL2Py8nAuKc

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

5.15:

Fixed conflict due to the following missing commits:
	6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
	[Continuous range: a95fee40e3d4^..08d3e84feeb8]
	08d3e84feeb8 ("xfs: pass perag to xfs_alloc_read_agf()")
	76b47e528e3a ("xfs: kill xfs_alloc_pagf_init()")
	99b13c7f0bd3 ("xfs: pass perag to xfs_ialloc_read_agi()")
	a95fee40e3d4 ("xfs: kill xfs_ialloc_pagi_init()")

5.10:

Fixed conflicts due to the following missing commits:

fs/xfs/libxfs/xfs_alloc.c, fs/xfs/libxfs/xfs_ialloc.c:
        75c8c50fa16a ("xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown")

fs/xfs/libxfs/xfs_ialloc.c:
        9bbafc71919a ("xfs: move xfs_perag_get/put to xfs_ag.[ch]")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 45 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 34 +++++++++++++++++++++++-----
 2 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7cb9f064ac64..896cf97fa4a0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
@@ -3017,18 +3018,42 @@ xfs_alloc_read_agf(
 		pag->pagf_init = 1;
 		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
 	}
+
 #ifdef DEBUG
-	else if (!XFS_FORCED_SHUTDOWN(mp)) {
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
+	if (!XFS_FORCED_SHUTDOWN(mp)) {
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
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8fcb5c6810e9..3f0cfb50f61e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2034,7 +2035,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		/* 
+		/*
 		 * Change the inode free counts and log the ag/sb changes.
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
@@ -2657,12 +2658,35 @@ xfs_ialloc_read_agi(
 		pag->pagi_init = 1;
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
-		XFS_FORCED_SHUTDOWN(mp));
+	if (!XFS_FORCED_SHUTDOWN(mp)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	return 0;
 }
 
-- 
2.53.0

