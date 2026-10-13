Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BF23E49F1;
	Tue, 13 Oct 2026 08:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879356; cv=fail; b=fIRJVLYOOt60IP1df4icGWoV0tE3RxF1OWBtVZu4QFqJ7WcV3EPENGvGyVg7cIGgRrHQJqgwvyHzABt2aiRmVGZaUl63LagLIjvVWMLXJ8hqCHsMC+QV0RGUEkjbctqFRfWcdu0wJM4VIqLrNDzIJQ/1dU5f9az7S20R1wvLiLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879356; c=relaxed/simple;
	bh=LjQxm0tFdlNXl7xZaUKn/m/kDGyXv3bhA4iQv7WlfC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I/JyB7+ZdCC9F7NkMEflxWiGnLMpZ6149SjT7ChVU9qBKifjMcX3eE/F6ef46tRxkKkzz5MD9PEGUVnwrJin4LBMt7/JEaQdsACU90hSpSq/mA8XaGzu3ypKLZYOnaststBCF/qZpF1QWkiW8qayTatnkOWJZh8RQi7SP3hEKjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K9oL7xFw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fKJPnvwI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K9oL7xFw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fKJPnvwI"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bss71439853;
	Tue, 13 Oct 2026 08:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TI6fPeo4uFVjGqM52F3EOF7wswHYgfrLi3ygYD4ltxc=; b=
	K9oL7xFwQuE8elee7xVr8I/jMB5GtugYAca8xx5msb1c0fsM+nL0bGOinfimIz5l
	n5M/xBMkz/SCYNBm1Xl2iPNKxAl+VvDKgg2ANhFEVQCwbQ/i8O4/i9Vzuc1FN/Nb
	A9YVDcJiBSkG9R/2u3xkNSOBANSXh2x74eiNq2nCWakmxaIgf0n4ClYvaI5yDkmG
	OKbMA0Yb5yHcr7LYJSs4Dl3yhe5lACOhucs+6pl5dZwa6PhdAwwy4ATLRU8RDfF1
	lAdXIkpRsOxqbNlR1TTQw1IjHqvV+V5Ptqb0kC7ASTYhmSoD06U7Byb14ZhEzdXs
	FgUiZZTYLLEW+F1jycG4MQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86kek020993;
	Tue, 13 Oct 2026 08:15:50 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012015.outbound.protection.outlook.com [40.107.209.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjsgvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E3FKRzTO9G4ImNd40KR9E3+75lYqHWeSRbIMk5t7mh59gS5JpesjFI2I/lScLKSJlZ3LcS4pTsP5PCKaoeCtZE1PAFYZNb208X7060kFetnQYNiSOSQReJxyWqDxzs7DhLt86lgO3ZglLpCXtAT/sSvpMnbEAfGBm0+d1dejavxSnN/z/MvPIaZgG8h3sBUzmOWO0qSFQHd1Eui1f0X58STKOm0F7hJit6ewumjmXgarzrDnRy4ws4yI7OUqPtx4j/NbKUsbbS3twGc5JzNiFryWAVQgtTNTrqup5z7xAhlbA71Ea4fZO6FrPMexxXHp34yPPiAAo7yWdqInKTAD4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI6fPeo4uFVjGqM52F3EOF7wswHYgfrLi3ygYD4ltxc=;
 b=sH8Ijjqe4yjTVh02jeQGA+heAPldHFSdIgvm1msfl3FTBPjfZlXUTkKuwWZxFdR3HOyIkXK/Tk7DlUHvvH6Oepyi8RAE1g9w3wgapkF9D97UiSZCu+9ZU3YA3DLkDJNDTyxg77S4dps0sJjF6C8rULJpIm3OEbldg5BeQaNUCSqa1pU5pspQhv9YVWgiPsqGMME6cU3ZF94yZaJuVxdQhYG0puAHNDtm7KYg7VtTmxrAuopF6ezZnuvRFC3zFCxrjz8UuYTdnjrbulXPl2IHWirCak0Cy2QoizJdVZ6v/cQqluJagdvx+8xC7BcKc5Rm5GrytaUhiF7iCMuwkOajEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI6fPeo4uFVjGqM52F3EOF7wswHYgfrLi3ygYD4ltxc=;
 b=fKJPnvwIlvRByN4dczqqXURDUfTvhtac+/1Sk6YxR7icpAwATE6Er3455Si8Iy5fFwAyRuVgHF0mFUx9rlUpqKUpe/xagjxi+gzp43+JstG8oMrvacygH8SrkiAu6nuGDkw2OL9uGJSRY/HdTNRnKsGF+HWraRtso7Ty2eSjXw4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:46 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:46 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 08/19] xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()
Date: Tue, 13 Oct 2026 13:44:52 +0530
Message-ID: <13b4cc126c442be27d657667dd674b5c3ba1513b.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0196.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::23) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: be3d1272-dc1d-4a74-5c5a-08df29022ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Lw0aFnMdRfh7BHG1Dt3hXTGHpVLQua/95dAKygvJL8bRCY6peLN1wIcERE6ZQAcZ2aiF+5tagq/T9xcCUWsX6dx71T7QBq7xpBbt4qfy8AFG55PK8VJEWTXhNKTYXR4tSgYC+MU5FcUftN5uvLaq3O1GzbUIK9jk4U5FJTf7YdwJKfWnPSHFyoES8WC3uIeaa6QLrPxSTch6GNZracN4g787C3O5CmaNnusur9uhh9PRGTQsrNj3evqfV0hm2B/wE8Pjk+Lqx8PWBMfp46fqljuKx61/AYyykqh1Gz1u5WOxG2/N7UsWCdQmDiHt3vVPxUtubn4ZR96Bf+TJxzFQre5MmdEct27vYtHX1SLAfo0rpxM3BED2cQqi/tUDnCBIhk9Y6f/0mMqGgwpxxO2tB4RukrVDTtRVutxFTnUE9Xeh2dxnYo1VCOEWGu4NnSSx5BPm5oUCv3n3+n45AS4vL1dognJxMihUdqfzH65EOrU8GDONQpl1NgFj/+s7Owx451zZCz+q9A+NwUlAsV7jD55KOJOiEoaAbzJScqskhBdOzZHOqcP/zIbywM3tdFiDrvTBXhf+jdgy04vDlw/RdvfjcRhn7N70AwzV6GvdZdVsMsa3mZhvhdeUKjtgDoAKa8qQ8NytQs/DYykOVtZzs9eDvqk61uZ0mw9cu4WZayI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VyZTpkGutWQf5mNWhJ7ppI+oB0S1XWQBnG2Sah/D0lvfQpOEPdKb3JxAcjvf?=
 =?us-ascii?Q?smpTIRUHPEV98pqspD3i4U7aBvfIjWD+VcdtcabN26Yn8Em/5vq5KDkbfdB6?=
 =?us-ascii?Q?GAIAub5e+DHXMdFKuuRFLvcn8Zw31wQYOf7Jgcqo48olJBRNKa9rrUiVe485?=
 =?us-ascii?Q?0obN2tKBxGfQa8NRRSA7QjUdQ/K6aSHVg8TOhArHH4zqDUJHKBU0hpXRhUEy?=
 =?us-ascii?Q?WfcH9Qu1qOLo2jccUjbbggyMRuGKgfmUu3SuOmkY/2Opy8OdFi5264Rz8E9K?=
 =?us-ascii?Q?MNytTis0+tGqe7v9nbCf4KDFtUezge4A+MERS9qDij3lF3yooYak/NOeoVu4?=
 =?us-ascii?Q?JhKoZR4PjAS6q212R+5fpxIS+z5azY5DQMBtVQ4pckXpfw4vg0rxFSAPHEHi?=
 =?us-ascii?Q?dO9QvUipdKH4KFAd9HTZFUnaaRpAofECsd6tpnzZka5zaCLCz5ylwhIWzjxe?=
 =?us-ascii?Q?qjCDlPQESH9BpA6K/GsgVtj2SoHF8ZDI5f0bUMnKfO5Eq+1KnngRTq7Li9iF?=
 =?us-ascii?Q?nU7k11H5Sm0PAyWik4e2v7GzHXLuYhkEDobxTsuk4BI+TGHZrqlRIU0ESqPd?=
 =?us-ascii?Q?2rEETG83kUZSDrVf1eTttPeDMgvaBo+GIzRx69C26OT++KPNi+SlmQrYTqAQ?=
 =?us-ascii?Q?5Jy9XCrZnbm3JkYiBY2Gu/iVkXHi/Cazm/7xV7KNazfFX5U/dbGGPhW+Rq8U?=
 =?us-ascii?Q?VA2oR4rCx1fjXwj9DC83DSHRldwT6QkehmjEVmtIR2TB0jnPlcrRw3FP4kIQ?=
 =?us-ascii?Q?Roi6rbheDLZ50nTl+t1MmzZAInMupdY5naSldG7kcxgA8vObZvfs0UwYU7Zu?=
 =?us-ascii?Q?i/xpDt96CTwywYGK7TV6a1K4OyQSetY1zn2YD9xaH+RRFcuPq60VYuPpLoHw?=
 =?us-ascii?Q?XbsoGnzr73GuKFksZ9URTUVasIroNNTgC3MfccdXkp9OjhUQy3adltd7HFpq?=
 =?us-ascii?Q?spt0Gd3/kAzC7T9/SRZywf2tFtxZ4MVipbpErrNq6ry6iYg5ury/Qq09dvKP?=
 =?us-ascii?Q?XivMKA1cGxXfD/LkTffBbZ2Q3KCWsHq/cxwMvmJHq47mIx8yw5J8hH+Fc2BB?=
 =?us-ascii?Q?6HyU93bIROn8x1uVD84k1MOB6aqWyMzX7sxpiNQcSXuUZX9K2B8PU726eH9h?=
 =?us-ascii?Q?Q/7lKS8a8+mIYCyd2Zzyl8Dllub0egMZuvNRAScdjiXjYgEIzdPZOQpP28WU?=
 =?us-ascii?Q?ab7m0eQA50UQPlI7VuxEgNDTxcKbLLnWihFY2A2YKBnzf/aqlN/rB6Xs6DpI?=
 =?us-ascii?Q?tOFIXK5XXKscsXxe9im1k2YbWY1dj29Hy+5YqWEdTuzAXlxxMuomBnX05yWR?=
 =?us-ascii?Q?Ww1R0xvBg101LYGM5WZS+EGBiaF1p/hQE6lW7wppT7ygsFSPKL4ZWP4crqJz?=
 =?us-ascii?Q?VtxLi7Hjm7Gq0TJXunWvKbVZaTWa3ctYiA5k14U0oCa4iyJoiF+Fjvc9ax2U?=
 =?us-ascii?Q?s7Hts9o0p1iG8BSTWjEL84XLQ0EXP+SJAG+7fgPhJl7opWd1hKhIy7qjAnDl?=
 =?us-ascii?Q?dlOYM1ChJKBF8ioF52oe7oeWaMc2rnENw05zdWH/pUO2pJ/pAz7wX/vmm8/L?=
 =?us-ascii?Q?vUNmLk7iArxlJ+UGLnB/UVIYL14w9vQEzmyD0aDulCiXpQylpg945VyQU931?=
 =?us-ascii?Q?1iVP+PtUI8fr/FtSU7RPhb1KK85sEgZJVzQ+j6KMnJUbI4hPeFKSvSfzLyNB?=
 =?us-ascii?Q?wJEJllchnNFFVztstKUcWcXeE4MUkrhc65vr1ZgVh0FaF9oZy9nT9VmO3Og/?=
 =?us-ascii?Q?TZ6p2k85p6SXRUYWYm+ihEdWEwgbaUlYEITKJ54oGoInwInyV9uK53GV4edm?=
X-MS-Exchange-AntiSpam-MessageData-1: U+QRF+HhU7JVfTOm9K+d7y2JLOSGuGFAa7M=
X-Exchange-RoutingPolicyChecked:
	Oje+wowZGDt7vSGhOSMdEW0HDtLKHh9uZ+Du1Q1Om9Fb7I2MUi81M481XrMyFvjKSDtEfHDnKU3n8qV+zzL42Q5GRQbIosy6XzBahFlzieoSrXtTH9+968nucKCD4+j2BhyPi2DbmpaORvt0ZcG//8IGOD2/XEG+08jFN2yPZURBCZJY0F8PgE2it4hMG7zYMePA2ZjilxSuR0Xr1B71lASBHSmwgzV3G3P/7XZGW8LmyM/8IkdRQhUZIkrPD8TQ5OEBo1Cw1i/7NnppQZ+FbmnzhGzjG4w3Q39f6WXQtLPKpuYKlUsPHUrxEqUF0e4Lo2VxHK6dyU2TV6PBqbO7lA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VpHLnRYEShJOhU96TOy0+ic7juCznd1qqOBxT0fAk2J9BhoNC4mVurenXWBYjByj5gVoU2RB/GJWkj3hPvYbY5NXV0PZ+PxNyzCYilsA8dpV1jOd2Rk4iYMH9qKm09ARJNYs9Z7zvaRngi93jf+3QSq8EBjnzxI72KMGxp70JP5tXXWunw5icnhvIz1OrkSYPQyd0kfSZ/CKuTqyCBZOpBQm5gB3D5h1BPw011JF2Ek3gSDKYzelgumi3w7F4/7aNDNYSmK7lP7niasXzNer6vcw42fU4gZ1lxwd7kHOGXgVFExS5Ned35RFaac7ciIyHsJgaFPC15UMC7HnmWf1dhYM7oxI7Yhw22CTd7AC8Vso630qfvDUwptWEWVIBrjXAG4qbkMRx0a+DX+e19xzg5t0ZRzJPdMHp51vrm6OEtF2p516zgfBYzFo0Nadu4wEm6QFT4ZwOflsbTnXt03G5CS9zwiLr5/WMTSbuXZtXZwbAxziec2FwcjsNi7OfpfPRfp7g/vasExsfnhpXvsSSHpB4U05BDPoXgiAygSLLz/c4jVMEdCrY6fgc4GWGEkF5G6Ga712AqMdrvayo7Eh6ph5QF8WzX1SKmJaR5uz4fk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3d1272-dc1d-4a74-5c5a-08df29022ed6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:46.5555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYPM5Ll4+NMOQLrPD0QDhFOTx0uykeQQWkxJvXaF57ekx1IE78STBt47Cgeb/jp7inac9FL3fFmHm7Gmxnr4rglYpCIzecWQZzq90YpEQsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde8b7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=28ojpAUaEbF8HSBGY38A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX4dUFGHyr2vsg
 8IEI2bUXweNWdFEjPqIgDX62ZRM7hlEyl5ns7/mfE2u9e1o92+G+zr3/Obav4bWLWDpcHbQ9CgQ
 49kqFEopaFyeSWkoLRsTem+ekeqmBrpiTc7LJ5oxcSPrTd5HNMEnOCwyiFjezErpn0HqDgObyZX
 JbSldWzD3L3Zm1+mbPg829CQ9quWPa5mm1FWsJLSaThfVamNxbCVK6/8VJ8nnJVWuswR3wJbOC9
 e12zEECgCdx9FeAhWpqUY4IEi1wKi1e+SiAFmIMVqzo7UrAHpNey9QhLeDTAjBsftB/R35gP8GU
 /8Hwy4pTbQDWypT3HvLre4rTIHgDee3Tk84f0FNI4LBLS0rLkNEd7JbKajKOHMZo6TvC4Xx+KdK
 bZtBfYFg8ZS1CVqzEUevUmo0FkJwrhbYOw0QPt1f/wfHFewir8leMVbw3B8Y9vlKiDTAPvWP2aC
 3vSjqh6p+wlQ2bDRDzsTU1AtYL6NXa21duMyWKLU=
X-Proofpoint-ORIG-GUID: 9Tyduui6MCqyi73nMKpISyt3PKUAyySJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX2l8PfxJ/7RId
 hI/zn7/C2/QcrTXggRdM3qp9QHGStdkA/nEvQEDPrpE+OYy+cwTyaNUCjfkvm8KJnhEb1KW1RHO
 3y+yOl6R4cgH0J7xfKfseVQw60lhkE2aQpEyDzyq8SJU0sW/Ss1u
X-Proofpoint-GUID: 9Tyduui6MCqyi73nMKpISyt3PKUAyySJ

From: Dave Chinner <dchinner@redhat.com>

Make it less shouty and a static inline before adding more calls
through the log code.

Also convert internal log code that uses XFS_FORCED_SHUTDOWN(mount)
to use xlog_is_shutdown(log) as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit 2039a272300b949c05888428877317b834c0b1fb)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflicts due to the following missing commits:
	956f6daa84bf ("xfs: add iclog state trace events")
	303591a0a947 ("xfs: cover the log during log quiesce")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_log.c         | 30 +++++++++++++++---------------
 fs/xfs/xfs_log_cil.c     | 10 +++++-----
 fs/xfs/xfs_log_priv.h    |  7 +++++--
 fs/xfs/xfs_log_recover.c |  9 +++------
 fs/xfs/xfs_trans.c       |  2 +-
 5 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2b83b2b7786b..bb57a125eae5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -244,7 +244,7 @@ xlog_grant_head_wait(
 	list_add_tail(&tic->t_queue, &head->waiters);
 
 	do {
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 		xlog_grant_push_ail(log, need_bytes);
 
@@ -258,7 +258,7 @@ xlog_grant_head_wait(
 		trace_xfs_log_grant_wake(log, tic);
 
 		spin_lock(&head->lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 	} while (xlog_space_left(log, &head->grant) < need_bytes);
 
@@ -361,7 +361,7 @@ xfs_log_writable(
 		return false;
 	if (xfs_readonly_buftarg(mp->m_log->l_targ))
 		return false;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(mp->m_log))
 		return false;
 	return true;
 }
@@ -378,7 +378,7 @@ xfs_log_regrant(
 	int			need_bytes;
 	int			error = 0;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -446,7 +446,7 @@ xfs_log_reserve(
 
 	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -794,7 +794,7 @@ xlog_wait_on_iclog(
 {
 	struct xlog		*log = iclog->ic_log;
 
-	if (!XLOG_FORCED_SHUTDOWN(log) &&
+	if (!xlog_is_shutdown(log) &&
 	    iclog->ic_state != XLOG_STATE_ACTIVE &&
 	    iclog->ic_state != XLOG_STATE_DIRTY) {
 		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
@@ -803,7 +803,7 @@ xlog_wait_on_iclog(
 		spin_unlock(&log->l_icloglock);
 	}
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 	return 0;
 }
@@ -913,7 +913,7 @@ xfs_log_unmount_write(
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -1013,7 +1013,7 @@ xfs_log_space_wake(
 	struct xlog		*log = mp->m_log;
 	int			free_bytes;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
@@ -1479,7 +1479,7 @@ xlog_commit_record(
 	};
 	int	error;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
@@ -1561,7 +1561,7 @@ xlog_grant_push_ail(
 	xfs_lsn_t	threshold_lsn;
 
 	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
-	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+	if (threshold_lsn == NULLCOMMITLSN || xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -2779,7 +2779,7 @@ xlog_state_do_callback(
 			cycled_icloglock = true;
 
 			spin_lock(&log->l_icloglock);
-			if (XLOG_FORCED_SHUTDOWN(log))
+			if (xlog_is_shutdown(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
 				xlog_state_clean_iclog(log, iclog);
@@ -2830,7 +2830,7 @@ xlog_state_done_syncing(
 	 * split log writes, on the second, we shut down the file system and
 	 * no iclogs should ever be attempted to be written to disk again.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log)) {
+	if (!xlog_is_shutdown(log)) {
 		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
 	}
@@ -2878,7 +2878,7 @@ xlog_state_get_iclog_space(
 
 restart:
 	spin_lock(&log->l_icloglock);
-	if (XLOG_FORCED_SHUTDOWN(log)) {
+	if (xlog_is_shutdown(log)) {
 		spin_unlock(&log->l_icloglock);
 		return -EIO;
 	}
@@ -3720,7 +3720,7 @@ xfs_log_force_umount(
 	 * No need to get locks for this.
 	 */
 	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
-		ASSERT(XLOG_FORCED_SHUTDOWN(log));
+		ASSERT(xlog_is_shutdown(log));
 		return 1;
 	}
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fbe160d5e9b9..407e80d06bec 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -576,7 +576,7 @@ xlog_cil_committed(
 	struct xfs_cil_ctx	*ctx)
 {
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
-	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
+	bool			abort = xlog_is_shutdown(ctx->cil->xc_log);
 
 	/*
 	 * If the I/O failed, we're aborting the commit and already shutdown.
@@ -827,7 +827,7 @@ xlog_cil_push_work(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log)) {
+		if (xlog_is_shutdown(log)) {
 			spin_unlock(&cil->xc_push_lock);
 			goto out_abort_free_ticket;
 		}
@@ -888,7 +888,7 @@ xlog_cil_push_work(
 out_abort_free_ticket:
 	xfs_log_ticket_ungrant(log, tic);
 out_abort:
-	ASSERT(XLOG_FORCED_SHUTDOWN(log));
+	ASSERT(xlog_is_shutdown(log));
 	xlog_cil_committed(ctx);
 }
 
@@ -1041,7 +1041,7 @@ xlog_cil_commit(
 
 	xlog_cil_insert_items(log, tp);
 
-	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
+	if (regrant && !xlog_is_shutdown(log))
 		xfs_log_ticket_regrant(log, tp->t_ticket);
 	else
 		xfs_log_ticket_ungrant(log, tp->t_ticket);
@@ -1114,7 +1114,7 @@ xlog_cil_force_seq(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto out_shutdown;
 		if (ctx->sequence > sequence)
 			continue;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 42cd1602ac25..6e619b34c6bb 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -441,8 +441,11 @@ struct xlog {
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
-#define XLOG_FORCED_SHUTDOWN(log) \
-	(unlikely((log)->l_flags & XLOG_IO_ERROR))
+static inline bool
+xlog_is_shutdown(struct xlog *log)
+{
+	return (log->l_flags & XLOG_IO_ERROR);
+}
 
 /* common routines */
 extern int
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 527facd5126b..46b1213e8ff3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -145,7 +145,7 @@ xlog_do_io(
 
 	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
 			BBTOB(nbblks), data, op);
-	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp)) {
+	if (error && !xlog_is_shutdown(log)) {
 		xfs_alert(log->l_mp,
 			  "log recovery %s I/O error at daddr 0x%llx len %d error %d",
 			  op == REQ_OP_WRITE ? "write" : "read",
@@ -3288,10 +3288,7 @@ xlog_do_recover(
 	if (error)
 		return error;
 
-	/*
-	 * If IO errors happened during recovery, bail out.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	/*
@@ -3313,7 +3310,7 @@ xlog_do_recover(
 	xfs_buf_hold(bp);
 	error = _xfs_buf_read(bp, XBF_READ);
 	if (error) {
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xlog_is_shutdown(log)) {
 			xfs_buf_ioerror_alert(bp, __this_address);
 			ASSERT(0);
 		}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 73a1de7ceefc..d334bb3ce643 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -901,7 +901,7 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
+		if (regrant && !xlog_is_shutdown(mp->m_log))
 			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
 		else
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
-- 
2.53.0

