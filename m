Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFFF5D737
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404500; cv=fail; b=aGgFEUhTdkm7l7JlnUvN7tbR61zuVyM/6gXuRaG8GREe2vgdNhqAqyT58SII53UJJKkpnERVZkqC21llHNqUwXF7953pwFkZxdAnFQOF/aREhZPT+pYZderMrGy75HS2LhD4H5mtDOPUSEdrOJDq9Vv2/DRrFt768PK3nHltylI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404500; c=relaxed/simple;
	bh=P28vyeU0MLzge3gUHR8nq+tcxE29uV1Ebm/ttUchGFM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MbQlXRLbJgoxsGfonENFexwWRT4e1SNoANLxYDu4aZv3jf7ZuuVNrrPYqeJxxITPvUq1XjFF15HYpbqvSPTcTARDt8WoUGiltV/G0BGH/rdkmUXoVgA4D3jR9SS7GkDazk5BpaXG9U6u+ZF5R0nv+xPPvX6Aq5SsV7MXUTnjqiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j5m2o6AJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s8ueIQ6t; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j5m2o6AJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s8ueIQ6t"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG6BJ019731
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=j92rUiRDuBMJaU3ChZ9N3Ma7yjzaZSXtNeW2Qt+8Kng=;
 b=j5m2o6AJwUjgvwsEFUInSSW2euz69NW6+Konk3D2Q+dcf1dK+ciSzhbG2Vn0tp+mQlOZ
 IfoiXQ6wVTsgRlFM4A8D+kuyoA0JUamhQRbOoRn0aqB3CJakCRBbql8h/So61RnKIEH+
 fZwHyLrK5IfTNipFFG6cOJe+J02d3MKhR9sb9pEDLt1mX2XkatkwmqS70HAGUkbDLrNp
 74P73o5ZF4LSCiyW5ny4Gq4E1XPc5BABDK4ctH/mFFg5mOsyP/mubuXnbq8McZXBQNZt
 567pbOOK4yffAOcxNYMiG7MSqUNJoOuHU8sC8mqrsEsqaTur1Udd0sVR211lNIz5TrGe pg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1ppukrun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PK5KkL024422
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:16 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17012018.outbound.protection.outlook.com [40.93.12.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhccqkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUvXUSuNgDD3VX5PZd9RXzlgC9As1ane+ReEDwQJ+ut1jKdPTu6dztfluLrnioCA4zl9Dk5GE0bu8s5j9HEv5fNbtvkFlmmNouUwApiUyXBUtlTNAdpKFMxjFNZsp7IdVrRnsy40RZuCGmLCk1b1L2C+E5LFX6HHfyHvEAEELh3c/dLvvcZm75vDAUwV6+dmtOJlAelIoZf262v8OPM8li4PJr+P6nNcMUyJaQXfTFy2VCl9SZQFcaYeIKqKi70kGCwDJALvrNs64iWNIZSJHoLyQGzp/LCHVfhzxjOuLaNUI0gCoGnPuNY50yEm++Mzd/6IPCTyyIHUsb0q3iGKfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j92rUiRDuBMJaU3ChZ9N3Ma7yjzaZSXtNeW2Qt+8Kng=;
 b=ZudnVxM+/moKPx9tjq6oi+T0tqowIuKgsNIiowDpqg5nDbYdlJXU1PtpIYYdHdAsMGURFbjw7i2EwlTVe2iYLp/jh5XzMsRu7IFiykh5sGCwu/MsN+Yt6ETjW7DfA4/+ZHaQrX4TeTND4kXueELord5G28HD4LSvl7xZ68uW0SrCV1ydjRHeqDbP+jkQDJRWRxvhBlHc2fifoshJxwHfa4wnOtIc8Wyypfnv+tHuMWMl/euQ4djAJ4hB+xusvCGEM61XZshz4sIPlz/8nd1OPvgrQFXObkKtH6eW9dm5PEMijYL4d0Y46LyUVVCMQDeJgboBB/4Ir5ObNxFsw3yR+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j92rUiRDuBMJaU3ChZ9N3Ma7yjzaZSXtNeW2Qt+8Kng=;
 b=s8ueIQ6tuPU3DPDlm7M5W4xOhKMZSJOXB2vd4X48HREFYBEZFdMMc9nd43F6UN7soBFDpRyTXSa1FiNXJGyZrmuCr705kt0oqoXQIjKNkrv8yxFjdEH7Uk2IMM67bNZYVQysFSw8Rl9I1yP7yM8CgALNNMi1wdqsNbf7tWqRPLs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:50 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:50 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 08/24] xfs: make rextslog computation consistent with mkfs
Date: Mon, 25 Mar 2024 15:07:08 -0700
Message-Id: <20240325220724.42216-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0145.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7476:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Sfn6lOktblqjHH3giKvbi80vE9WFiuK4HhBrRYbwQa70Xub6YWludAPiJWw7sHfjApW5p6gKjyJHaadYWCxBN2v7IMWP2f9j+QSxL/467mnjUjpLrw/tbRwE4kuUCFNrm2Iayi1BZ4cslNJfx5iOdg0QLx906YfJwtV9JUblFHUuMOqbT9yO7x2uF2jvnh/u+HbJ5P3gLPEhHryq/oCTJPLI8pR2tn9NeI6vyCoicl5csB24HdXzwqzb1HJo/6aC3RgRWd9h6RasSA6t7wwhSIL5qtEUIKbg6dk1DY7C/IsJjtkDfEqXzPVSCU5GRqOTxfR2Gt3IHT5l/PamLuNsiWwVr0qSIe89LKa6JKEQigHy0jd6lXRMMsIumL9nmPC42dhE5u/O+GSB7vdtx8AoAiS6m/8Cc06BlfeY9eNXReisYUQh8On74XO61iojiFMjIYJ7C6Xxx6fhnF7fBwRdJ2OTHx0zVghE+vsrIgldrsB2bKmJSttnUZ2r+n+/CzHrB0l68xUdhZV/BDLj4z+mWZDyPlcyQolT3oSLqr5dn1EN72X4uggdL9aqLsBC6SQyw9Gv0qTEA3AmI4YcJzMwla6TiFIb+avQGqGNj1YSipopzjqBiVcQX5w5ncCx7AZLRNRPXzhQshydYI9O84pwAUhkHvFQbPeutntep7UG8U4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?q9gkR0CJR/lsbdFBSaC6BBg0T10s5hczQqeVDCnLyBXpzVmVdW9Ngh7frmPV?=
 =?us-ascii?Q?T+9F6C9gC7lHNlew1WHeh8ExzShtX1NwDapEDERpUw18moFIgGJeGA0eUAJo?=
 =?us-ascii?Q?wrEYMMUSJPWRIYHFn/0XdweKZ6zPG0hvGlyfDat4hVTMv629A3xA4ZnweLq/?=
 =?us-ascii?Q?s/tMV3zExJRI00SdYG2Oo70y8vWPyNP0aCQtO7SFEniO/8kn5yAAQ0n/Cz1W?=
 =?us-ascii?Q?qdbLGCn1ieMnWZ/QXOZGcvosAW27jmmYi8f6yLnpNTJxxqj/1vvVjDE8zZ8l?=
 =?us-ascii?Q?4fKnwXQl3UWspGr5x1hSODWdX1o2ExzBumq3vu/AlPkf9ZauM9cJGrK0UKgP?=
 =?us-ascii?Q?l8hYAKHmlJVsvwiYlwlSHaYuTpeyMCGkD/jX0RIDdBx6tdRjO58NPoc30QUK?=
 =?us-ascii?Q?dGpLIGgAGmWV7WjjZz94aar8uAHVMS+dLpErzcDfipI0ETETG5xhTgfpVmVM?=
 =?us-ascii?Q?Av6qAlVeyvPjRLDDnFq0m7YGXiiUAdOETYt60z6l+Ne4HaS/SFyq/Qetwxe7?=
 =?us-ascii?Q?8QQ3YybJQdIwdXv6WqKNkq3U9juAPSeBBDgYZzDQsa6kneANHhik8KuMA3cQ?=
 =?us-ascii?Q?u/mbBJTrHbLRZ/8NHov2/8c+DYzCJ8Oqdc1sTP3elTeP4fR9cl1gUFKkhYjD?=
 =?us-ascii?Q?W9Y+hKViibZN+5hKwhphnT32FHXE/lXn+oMbE4x33b3Oc60XrwOETNptGCDg?=
 =?us-ascii?Q?eriXHw3E4YNaV+fJBxzRehHRRqaN2Dl82bHzSbDzxO+q+ovDtmBkDCSQWXyw?=
 =?us-ascii?Q?Le0nmWfTRcDpgBx7mI+IyYmhtCTm6i0kx+SydD5Jn71BwIeK4DxnYChyXESw?=
 =?us-ascii?Q?Guxmnth+LLPb4SFfhPHpHAqruTKjK0uZK77h+rXwAGtJjijH5pjkrA2rvSxq?=
 =?us-ascii?Q?oVnRvS8pC34YzbdhbnvHnUD00rgSws2cYOo/Ck7LJOoHxeubc/tS90iujReK?=
 =?us-ascii?Q?trKgKFQKnASn0ZKbQ+RAtH0BZfXMfVfPHinSufN/XkTpkt+1J0bYVs3+0vPa?=
 =?us-ascii?Q?AZKBR+9rs44If42Z+Sb60XBNBd7FPEsv8x6KdIyHWUTzduZ/xU1chShcZjua?=
 =?us-ascii?Q?pgmELvmfv8SmnnSKkVnfCze8dLYi3vBdcDFcnXScQkI83duaNKg/ngu+EzmN?=
 =?us-ascii?Q?/ASECBBo0juDTgKsq8i+sEGBt1XA318/AAvpzYfaavbSwcx6ZRjudEQMNLb7?=
 =?us-ascii?Q?h9WtuiSsNzHV9/IafL/whOVQEy+rN2PdLra7/SK5LHU29OOu9OCt0skZ/+5f?=
 =?us-ascii?Q?1yAuhylHsKvon/aUznabzsfiyZ1vLDzIXgms0RVUsVkOa0m/3T6vsFxXT9Q4?=
 =?us-ascii?Q?uduNGHSDfrlX1c9NjIKJIK/wUm/YMFbSerPeq0unRwLMqwWC7Z97o8jF9LGq?=
 =?us-ascii?Q?xkaf/3hRvXIuOl9YxWe5U0fAb9rA1SfDbkYc5xDl+rAQedrCUj/PJmVivr9U?=
 =?us-ascii?Q?tsy/ko1FU4xQyDKjZeljKtXGJnvK8guxh4qUTiyjfJF4ph2cHAW0qJM7LZBA?=
 =?us-ascii?Q?c4knbVx74sEiZDlY7qQy1IFU91/S3Ieoje6xR6WMqYJtun3vr+fhTw48NnYX?=
 =?us-ascii?Q?w3eUcDbvNWdAZrAw1RXRFr7L8hGNgTbtw91d9A3EBKMei7zOxAy+933shRvW?=
 =?us-ascii?Q?7DOuq56e4ZtpP9Dfd4eVHg0T2mxo+ruIcgd2Wbz+SQHdzQjV0y4t9melnEpa?=
 =?us-ascii?Q?rpoM0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8/l7JkDP/bR9+Jd2FEE/d/qyhjjgknvCD9oRsPLyCHUfzieWfXT71wbf1iKEgmNS1NkrarsbfhAgE1/ivSZDvpuBrAsUHSww3W6iJkCRs0Z4Lc24TcLE6j1RP7c9/jiDw0qbgmb1cLJ1LsEnr3f7unPTAXijQh2ChHUaHZFl8CQARyTVH4S1EAhRGhp3BfSknQKGPyA8wrq1NyLQbNG5b+GRp6BDMqJVfKvucxgpzubXiB+dS/k9ZMMWMz6Kt6rR/XlAND/zZ5vP6g5thmw+/TXatnohnpAU/YwNmPg+L3X6hBx+pbMxfyWvL0OM1Fbp9OenYlS77z+8s0lVLqGffVan71MkgdPf20tzO6mJykk6BvL2ReF3BmJ0rLru2cHAa2dsTMvecMMudHVd5P9w7tty9d2TJtHHt1RnGetRAK4XUNac/QbAnul++1yDKtKOM0Za3Ep8VOvQasZabHuZtSpavzfmFEJL0rXWoGWZjrG8UCUnyY95Ad44QqGOfHbYZVa5orIXokLSs1oysnvsHaGd9t6Xt+l62JQQXZM/eQn4bMSD1y4dZv+HRPJ2Vqec1QdQE2o/QDib76F10OhDGZshOHbEE7JKhz97snixtik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1b8d1e-f2c7-4b99-7795-08dc4d1802b7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:50.1490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6eZt+Cc8HinCQ1k6b3QzL9xCuE8DobhPv6aPSXO5ikEzNOr+GrDFRZtyKdZCgcclP7Dg6JIOd3tdHZjLLuw4KTPP6ZUvjeLx2qHONWe1OQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403250138
X-Proofpoint-ORIG-GUID: Nwt5gHzR_nj0arRWTD2uaP6sRuLxaF7x
X-Proofpoint-GUID: Nwt5gHzR_nj0arRWTD2uaP6sRuLxaF7x

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

