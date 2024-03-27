Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7BBF9F7;
	Wed, 27 Mar 2024 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498385; cv=fail; b=hIDVl+LIu6SDloeHTieae938gSeV/cqErn/NUppt+MIK2urZwTSbsI+ZxH86PQDYQzWcNOONPuQ9zlNpwMzLQRpLphXbuizm+UjI5bKFw0ICpz78SQ+qGPUDwNOcuOlQ/D9SO+nhtXSMdG1fgdo7O/57cFdyRg3k0J1ggIZtleI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498385; c=relaxed/simple;
	bh=P56e9wUWb+5TuOAKoc7i8mLclTtdZMEarJbuYo4ldZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jnV34EJT3OrsEeMwY/jr6AC3izGEOJdDALBEh+5/2E/QYGh6zK5EIY5j1oLTfkMBLPjEgslOTxXOnkxFTBkqO5CUx0kuriWmBdlHW0REFfg4LJS5OBuf5oYXScKrmB7pdnsx4gwJN8/Y3EMyAyWe3+lqJW5OETwLXV/kdm+0cHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g1WBFN/K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gqay1COG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g1WBFN/K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gqay1COG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLiWHY026015;
	Wed, 27 Mar 2024 00:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=dEcEmkavvpGIX+egnpbq8AxzdGe09ZfX27BshcdsfHE=;
 b=g1WBFN/KK0gDgRrDE/gUE0mQt9U9OgBFY92cR9Gu5eGQuz/OnY5yY9+o+BHedPeQkj/e
 vLe+CF8Q9zXzYGTA9wn5xn2/+C5ektUR3mjialZRoxYSpWCSnR5SE7WAx8x0lc2xMTPe
 a8dJEkTKpMEkXcYoK4IyuvPO6p1TTwHIfCvuwD2EZF/jlhLhmRRc2TqDuyZC1gGkBbN0
 Bo+maxbefQwPTpUVOEkw3DiyqW9Q4Gyj74DzH8bKQ9yMMc6Iai5EgCg2zwXkmIR0D8xr
 z/vBuZmYN7/ldg+AWQq3Wz60AC8Xjoh02Qn6F5rdB1zM+3GfgcYcnGhZMnu14Tuae09E 0w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvscs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QNj9d0020716;
	Wed, 27 Mar 2024 00:13:01 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1acr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSho9u5+jNi6w0pjTtlMhInVRmuimQEwLZReFBWsAEAum6qmj+IV3e0/6JBHO78xc7nD4ZvRmRfKlMWYq29pr2dn0tUMeesoLkUZrp/J5xlhkFF4U3XCiG39AW8ewbXRdaPwh3yBV/PWRTgci2KhTfkpXJfwQX7Bry5914CvtzCwKGLpN5/4IACcS8SU1hKo+FiSORDPsX1AT1wuDO63AlTVvohA0IklglCw0Fc05Gf5KRNd+Ckc8AWy/SiEoVy/Q9ijLEW7M2OEDSXXct0s8ELH68xXz0+DeuXDJJtaj6GR1So84ox/KpkbYtAb5+tN0lMUYknuGrTLgs9MfJSLWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEcEmkavvpGIX+egnpbq8AxzdGe09ZfX27BshcdsfHE=;
 b=BdDsIeqZLYNh2oKh745R/vt2Chm+rR6zyRcdmdq2zJO9RRl16kpoTnN1DgTma6rMf3ep/C1KWr5nKs4P214ES5ztoT2bPqOCYC+1E2qnv3aBWUbk9Dt5NSoqNTIBX9n1vS90UF5NgltHcBwbuvvNeo9Z9kqIwrvfakXu4mdLrkE/sn8qWP87cTx2jKMFr0IFaDALXPuVpWshsOo1E8ePcsrCi7E+pKo+R0jjZWJin4ijKNTHF+2hSz07RVvKxo39qiTKeW2LndZjFE/8TClGOmmxEcMOIwoMNk38fWnMl6tszlwDRqtYHXWkBkBXI4spwNMONJPXzZt/qkMeb/dl8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEcEmkavvpGIX+egnpbq8AxzdGe09ZfX27BshcdsfHE=;
 b=Gqay1COGANLrKz5UicUTPfbAIa1hP8lvMEm+flY1uQz7rW2jt51kKnTB9/e7EoOTk+hq3v9cAUZYMed8XLj32GYDGhUI3uIZ0cW0N2oyARA8lEVb0tdMXLY0FBKp9X3j1vVgBgwWLepgd6dw7xIMROhx+WWdeWG2Xp/I1+EV4OY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:00 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:00 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 08/24] xfs: make rextslog computation consistent with mkfs
Date: Tue, 26 Mar 2024 17:12:17 -0700
Message-Id: <20240327001233.51675-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Q6hP02cDN11Rz/SY8N6tX8pOKDgmCbyqfLylMtBcHQjOY6C2MOYRAle4pKkWme8n/ID+QtLoKVPOapiF501TxhNwhbhI5jmFnAY3l+XRdThzSSPv6/xO/u1W35NmPsmdSa7f06NIU5JjDecbq4KZT3fkfO9tPWTUWs0l5IwAmtvILhHkY4+uQDoKpUlEdpov2JDTfzj5RKy4b1nBSu9Vhf9Krwh1ApXqayHwv7oDDnV1q4Byn1rCkfNJQCfHki0MApfA6O1+86x+XFFOUwMfenUhgxHKUXByx57wQqvERf117PCwKQi6YU7XOQKA9DVQVy15uIFq7S08q/BnYpCpUamovompp/zudWO6jXixjRRHSBxTKwF5YRSRoLSAxTzNl45A0iPqOFE995f5Tx007CtHc2lM5afLN+fPmzhI11WJxzEEyk1oYcqYRaADrGqJevSd/qM9TdKAhhuUQkxG/g3oLI0uQcitSM+24Qmt4GIDpY30F3JpfG/tebtbTJmkuVFN6jaD5o1mWa0wJl8KytTDYkud3Ylr+Rlzcr2mvIerLhqCesFOA0r+2tdGfEuHjzk+LFELb8EbBkYVWaV5hTSrCC0GQuepp/COJpryi3u3tO6/2vzhNwHhtyoh6nbekUG9CpSsZMeh9fyhcmOQz1ecBZfpwIX1atrwC5vBtUA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?xuit76/3+UUT+9Kd3FoZ9p3DzUHJGIjVWBQ5Z327Yw2safWEngWkR61lExr1?=
 =?us-ascii?Q?DUOk2L9kgS7/jzXU0nT8yXx6kyZHFtdirE6VPHZt83cA1b/F0YSUDty4LimM?=
 =?us-ascii?Q?UCEgC5iPQaX2OEj74BfPaNzaCBXcUfoNVRaej6h2Nk1F5TeFwwps7gARRL13?=
 =?us-ascii?Q?MifDf20YvLpP3KcqrhWjcDzFJ8udjqTa7VDuMeqpfTYYjxDR4pG86KIPQz4U?=
 =?us-ascii?Q?+HLp91Km613ssjKcP9zaNk+E0y/mQ83JDFoUAVQ4Wfj5yEZQHoZYaeCI8xYy?=
 =?us-ascii?Q?wVF+5lwGqDoLA19skOF6cUQAaXQraiWbNXaGygQHLlY181K3cZ6m8YbQr3nk?=
 =?us-ascii?Q?WH2IXJuE6y8ejbeXjeKHj4SV6vUEzKQ79tgYD5PY//oXyr+nWxFzxTIp84Jf?=
 =?us-ascii?Q?/9uE0rM+7l4JhBrhRhQK7lmPidR6cacB+s0Ts2Nv6W7cL3gMw1T9yp3Owpib?=
 =?us-ascii?Q?bOCrkiJWxK6VphOhdalaarE2BY3jnkdNTnnnlbozqSRhpt8PfNcBaymroG84?=
 =?us-ascii?Q?ypKkdCdbS8wLCfLjI/d7xc4da1EAIMCR8jsWJmuYyrdTFavnX5tbqPSN4UYC?=
 =?us-ascii?Q?C1PhmXTBRul4gxXbTN46ii8YLRyj3CI0KgF+xW4C5ZJgU7XmbA4zVcSYH8pL?=
 =?us-ascii?Q?LkFiBBi2cLlPzpMixGM1bbY5IPssTt9PD7Ze5LRWWaHoB5F5s+hHPRUn0Q/g?=
 =?us-ascii?Q?PKgJpyOQoHmUTvUGGY10N3mtgID6BV7Z2q9IWJeHbwQQ/qIZz5Q9inYrG/+a?=
 =?us-ascii?Q?+arJQhnZBKvSWek6pqXO0e2x25zoBLWTbrW256CmP4HYubesbFC2/o9BLxO8?=
 =?us-ascii?Q?NmAvg4U/TBOzZ5wVQjgcQ7MpyCd0AGitMoiMVLBXro42IaXa57jKtaiuuZvJ?=
 =?us-ascii?Q?ei9MsJ8U5TR24f6tY4S5LB5xkMad8+wBoN3OzZlvgLRnaCX/gnwVmS2VBDKb?=
 =?us-ascii?Q?5J0cEDqll+5CpFbvjf4z7pnEejyckkKKJpTxUrEiAlKVJgaqiqYP81AS407N?=
 =?us-ascii?Q?W62IGmLYSWY8oZLnpkg8pEaQC9E1gjL0UAgQ60ZCkJr1Ix6NmpqE15BWBC6J?=
 =?us-ascii?Q?0aHybz3o+u6kDe1jmGRATBHehYeng7uhzJO1kp46srXHSd3znUjhhbfgL1NX?=
 =?us-ascii?Q?peNR/4MfJT1wl1umyH0LVCUUt3L4ehHtO9AeJn1jLvkNccHoUP89uxZvPxcO?=
 =?us-ascii?Q?y0qMKKtF/B3iSE8lxmu+Ggu9Qxsb6I7lqEgpCExAi5neAR/Q2GzCkEhGQ5uD?=
 =?us-ascii?Q?oux6vDU/u2jE8VinAiJwfbFjI+Q6vce6kZ1aSqWjAK8t7g8pPNgbPSR/vdy/?=
 =?us-ascii?Q?OXVmQMeRajSRkXpyMmnd+BIa0/C9u0Ic/a4PpEiDxliCXzNKU1m9YdkXBo0E?=
 =?us-ascii?Q?QUxMiqHW7d5LSOr5WsX8HAVB3j5Xn0PWMJDHPx4fPSO1IygBljob7MbDMtVZ?=
 =?us-ascii?Q?Ur2ylfg8YZL9X1QS9RqYq0VVEKfq2bZTlBy/qCbK5wuBNgcKE/OHK4EZUo/T?=
 =?us-ascii?Q?ZOnPmDTy6EyoOOmcSCg61h4jeNDIFPgn0xL4z28S6ftnnjTFCTmOeMl9+clR?=
 =?us-ascii?Q?S4yEOZZ5D7N/YOjNRpT4oXww4MbHoVhUpc2oMQoBwZ+hgosdEyxC6I5G7B9D?=
 =?us-ascii?Q?jNn56fZHsvfw/Y9uGWOS92aSayy7qnmGDsigtSFzOPSMr/f/bqCCqWc8PLL9?=
 =?us-ascii?Q?OsiPWA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KYzqhJZue0s9rD/+85h0AVAt5+fW7UVIYhrYDGJuT2wCSRjpe0e12t2S7+bdTYfTxwmmA50fw2dFt91TlcIJjuTNy7bEu9ph4hD6198F3WBVL6vNHlZOxJdZ02PXqLiFNS+2xqR+5RoBPnrex4OXBprcG4yhfrk8vJr6Z/YvinDlI2eEMJEPzZ3kwU88kRo0FPjLPLwbMg/fa1LYKkBLMQt63kwFVtol5ws3NfZ31YhGtndkJzubHRWndFH2Rdatzv+ovq/dHSGNT8n5RXlMmywvtMV0+pz2AtaDWUufGGnLlsYVJbPHT2s9y0fio++Wfr8EyLTYKdQvFzBu0w4esrVSRX1yUldhPMSSBJ5qZvQuA3W8ACsHugmN2I9p7IIJjVtvWic130kr8BaUPApuIQ3TkVu73KTgceFZtHI39uzJYnnE/Te2/jGF9unC8NO6olFQWo+9RbGl5Jsm6T2BIedYJPj/lLiqwBX/IiInIVjASXSbMQCmxWZmqRPhWYVbN4dCB9fb69aVDw/GRBa+GO9Kib5Ic+835GjkF+YqYxwKYozTVAzBjcGVsU4AyaWERQssUi8SiI0ArQLDpf7auKzdeQkzSjkPIV8fcoBfNpU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a845086c-f3e1-4186-47f6-08dc4df2a950
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:59.9750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NqKhu2IIYzhTiVVBLImqP79fDnyfaxY/qK5q2z4JZE8ZRI9yxg7hPxJoAkURPxfHr808/49l8vlGQEYlYlZ29U6BD6EhJ03QHbE3FuOPNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: Du_8TEpmrHwdmkehrRf6Bflovzs34o_1
X-Proofpoint-ORIG-GUID: Du_8TEpmrHwdmkehrRf6Bflovzs34o_1

From: "Darrick J. Wong" <djwong@kernel.org>

commit a6a38f309afc4a7ede01242b603f36c433997780 upstream.

[backport: resolve merge conflicts due to refactoring rtbitmap/summary
macros and accessors]

There's a weird discrepancy in xfsprogs dating back to the creation of
the Linux port -- if there are zero rt extents, mkfs will set
sb_rextents and sb_rextslog both to zero:

	sbp->sb_rextslog =
		(uint8_t)(rtextents ?
			libxfs_highbit32((unsigned int)rtextents) : 0);

However, that's not the check that xfs_repair uses for nonzero rtblocks:

	if (sb->sb_rextslog !=
			libxfs_highbit32((unsigned int)sb->sb_rextents))

The difference here is that xfs_highbit32 returns -1 if its argument is
zero.  Unfortunately, this means that in the weird corner case of a
realtime volume shorter than 1 rt extent, xfs_repair will immediately
flag a freshly formatted filesystem as corrupt.  Because mkfs has been
writing ondisk artifacts like this for decades, we have to accept that
as "correct".  TBH, zero rextslog for zero rtextents makes more sense to
me anyway.

Regrettably, the superblock verifier checks created in commit copied
xfs_repair even though mkfs has been writing out such filesystems for
ages.  Fix the superblock verifier to accept what mkfs spits out; the
userspace version of this patch will have to fix xfs_repair as well.

Note that the new helper leaves the zeroday bug where the upper 32 bits
of sb_rextents is ripped off and fed to highbit32.  This leads to a
seriously undersized rt summary file, which immediately breaks mkfs:

$ hugedisk.sh foo /dev/sdc $(( 0x100000080 * 4096))B
$ /sbin/mkfs.xfs -f /dev/sda -m rmapbt=0,reflink=0 -r rtdev=/dev/mapper/foo
meta-data=/dev/sda               isize=512    agcount=4, agsize=1298176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=5192704, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/mapper/foo        extsz=4096   blocks=4294967424, rtextents=4294967424
Discarding blocks...Done.
mkfs.xfs: Error initializing the realtime space [117 - Structure needs cleaning]

The next patch will drop support for rt volumes with fewer than 1 or
more than 2^32-1 rt extents, since they've clearly been broken forever.

Fixes: f8e566c0f5e1f ("xfs: validate the realtime geometry in xfs_validate_sb_common")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 13 +++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |  4 ++++
 fs/xfs/libxfs/xfs_sb.c       |  3 ++-
 fs/xfs/xfs_rtalloc.c         |  4 ++--
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9eb1b5aa7e35..37b425ea3fed 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1130,3 +1130,16 @@ xfs_rtalloc_extent_is_free(
 	*is_free = matches;
 	return 0;
 }
+
+/*
+ * Compute the maximum level number of the realtime summary file, as defined by
+ * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
+ * prohibits correct use of rt volumes with more than 2^32 extents.
+ */
+uint8_t
+xfs_compute_rextslog(
+	xfs_rtbxlen_t		rtextents)
+{
+	return rtextents ? xfs_highbit32(rtextents) : 0;
+}
+
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index c3ef22e67aa3..6becdc7a48ed 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -70,6 +70,9 @@ xfs_rtfree_extent(
 /* Same as above, but in units of rt blocks. */
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
+
+uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -77,6 +80,7 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+# define xfs_compute_rextslog(rtx)			(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6264daaab37b..25eec54f9bb2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -25,6 +25,7 @@
 #include "xfs_da_format.h"
 #include "xfs_health.h"
 #include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -509,7 +510,7 @@ xfs_validate_sb_common(
 				       NBBY * sbp->sb_blocksize);
 
 		if (sbp->sb_rextents != rexts ||
-		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents) ||
+		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
 				"realtime geometry sanity check failed");
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5a439d90e51c..5fbe5e33c425 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -999,7 +999,7 @@ xfs_growfs_rt(
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
 	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
-	nrextslog = xfs_highbit32(nrextents);
+	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;
 	nrsumsize = (uint)sizeof(xfs_suminfo_t) * nrsumlevels * nrbmblocks;
 	nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
@@ -1061,7 +1061,7 @@ xfs_growfs_rt(
 		nsbp->sb_rextents = nsbp->sb_rblocks;
 		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
 		ASSERT(nsbp->sb_rextents != 0);
-		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
+		nsbp->sb_rextslog = xfs_compute_rextslog(nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
 		nrsumsize =
 			(uint)sizeof(xfs_suminfo_t) * nrsumlevels *
-- 
2.39.3

