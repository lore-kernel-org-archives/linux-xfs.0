Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA50207DF3;
	Fri, 11 Jul 2025 08:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221417; cv=fail; b=aKGFf427y0PGVwm8KrA91bJ1m44wJuCBoReeqNKV9DLH7GJ3ubI0eY+cG1S/lI8ysLjjeEKiLLGZx6DE+NNQGLUGrDEAlWhR14CYIM0FTCDUfWf+xAHk9yfaAL/LY44zjFOALaC8RvquiLOQ922/lsj0ws5dbHynRJCQW1VwS2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221417; c=relaxed/simple;
	bh=gdYZP/Nfd1l50NAIbZBCTu78HTnTS5Kq9bOS4MLtnNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M1Hfyb6zqDlHcUCkVerptp9r+Vl25/lh454hm+eQScclQ/ug484Fcr3+X0tkHsHzqRJVmuyxgnrtWJ4Dvdw/2ZuakdtHLf3fy6MY8o14mosYs807DqTh4eREFcP1h3ZcfddV3ctYPpz0Qb2ssbcsnm+udQoZhduaoCvnude1po0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rgg5nkEx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WhCAl9+6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rgg5nkEx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WhCAl9+6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B87JA6022769;
	Fri, 11 Jul 2025 08:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=byuqvfeJ2zr46d8K7LWTS+eB8OGtxMd+WzNuHztL7eQ=; b=
	Rgg5nkExxRl1gVSrS+mNnyGf5N1nx9DpvPaIoGD69RG3hV4naBTUjQcy8g+It72C
	T/xgDHVymbHLg9SsLo3uPLI92xZPOzzXaVmBb0+ahHXmKQDHf6KJieceOXnPNr8i
	/otae1vxwBRbe/2MDoLnOmeRCYDN/1ZpYe9HEGtrlY72cQan7vCOi0ece+wctTxy
	2V0ulhX8/w8wbZci4n0OLSfdECehyBrVD8CdiX7WiTXeLQPzrdGKfYWqDtLJxNF1
	cHsP99YUa7oNsjlY1OsF7DxZqVAsHia8BVX2MPA7smK58ZDS01hpe0+zmhpfqv44
	mQwG5A5W0X3CVpBeZqqo9w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47txtn002k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56B7Z1bG027371;
	Fri, 11 Jul 2025 08:09:51 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012035.outbound.protection.outlook.com [40.93.200.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgd9k57-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 08:09:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMRTJYysVfDzTwSL9GbPUITHNJSRpl/IA1xK83hFqzeq6+sfpEgrjWps8j0XgGPAiKJ8h1xR2Ms2SfG2Qnc5nocba2nRZvADQ9MnzlMn58P7s1dLhwrVqHLebtGdA3XyaIivG+/BOtvfFb+9EFjZ2Pl04nGq1fwP+shldW1/+NhZnk8x3z2IbaMXqaYbQCC71Pfep8dEaq35DpUInq2yQdSLae9+RJDZXC2rMucmg2ztGWTip58yuwtjCe8HbJ3pxj1Q8YYBUAxZMEyoh0j8zCMmYKqW2rJ7us9smNnEefmRrsq2Y55zfKbRtsQe9LA8SSakxdmklMrM0QF+CWEGgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=byuqvfeJ2zr46d8K7LWTS+eB8OGtxMd+WzNuHztL7eQ=;
 b=PCd+Wnj/GGi+X57nm4EUdoSLjUiq+tiToLDV75toVp4MDDx8kOP/KrG7OCfyj0BvvYHN9nOm9d4DAVZXGQheUucqNg8vGSBSWqaE7InNbpLPELBOvidqJSwrSTJbubHQXHTuvVAmSdPp/eIPdjcWdWFLUKelbGuEe3AujPlGC87ioPfdtQHcKNGQPvcj+cJVcB4VQz3sLl7JsegbaPyM1uy4PjFzzYrdteB+VJD4mRRkLibAxiZOh5AnPNuq+2PAQK3mE8TPXjwIEYupig0jtkO0aPUn7D+mJwhM1QCUtwjJE8QS1RA/z3uykwlmkrvv0EyzGM5d2hql5Qbfd348qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=byuqvfeJ2zr46d8K7LWTS+eB8OGtxMd+WzNuHztL7eQ=;
 b=WhCAl9+6LL9cvglIxiDKVwON+0JAPmqFVF0/1J4+Hbf0mSoPBHVDonItQMmfjfVLGhTBV63H/KFWel8q1V6MYka5vAVjLatw03OJJxIlKw1QwJRaXFWnsmL+FI+6kzx+ftl2fGt4rDDiK3he0v33Q9seo44I0CWftIgnlhBDw48=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Fri, 11 Jul
 2025 08:09:46 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 08:09:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 3/6] md/raid0: set chunk_sectors limit
Date: Fri, 11 Jul 2025 08:09:26 +0000
Message-ID: <20250711080929.3091196-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711080929.3091196-1-john.g.garry@oracle.com>
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0033.namprd17.prod.outlook.com
 (2603:10b6:510:323::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: 89554c4a-f03f-415b-b53a-08ddc0524cd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JRGvgmdatDWbzWu0o7eHfWAgqSCkq3JT+XpRdKoFBp0/xa7PWfc3KAaVfRUD?=
 =?us-ascii?Q?KANO5t75WN26xMghqh3sHXvrj/yPVAqe09fDPE1VmFH4Z0dLmy0/ofEKLZwE?=
 =?us-ascii?Q?2UMRPxw0jcf00jlxdx1IlYClJiM+VTM/dqU0qxRYgw2ubMVSCv5BHdlX+pkk?=
 =?us-ascii?Q?fR+E2hlpAaZTEEzFEOpb1HPVkf50GIQoj8xkyzrtHgjInwTC6+YroynjaW7S?=
 =?us-ascii?Q?fUVrEAARIqKS2vFa7alvjvQZcxd8ch0geKoDHHkYfRAC2rrTRzCgg0tgdm+N?=
 =?us-ascii?Q?k+dPjvM5u5jGCBGG46rXgwr0UppOXXQE2tN49izBewiNCIKbkMpWS2+FM4IA?=
 =?us-ascii?Q?akNA5IKCju30+O00hTHIazxxs/jIHZOGxeRPwLDYKjM0ii1ygODIf8w/wdHc?=
 =?us-ascii?Q?PD0ZJaECmD0QikvjqvjgjNeL73RVYzUusztGCNqeC2bEPGHdCsQ7RKiDRQBv?=
 =?us-ascii?Q?LUO++d1OThvZFmKjq0nPAaqOBmDdlblKucJIKlbSPb49hFfeZYz73uMXCIGp?=
 =?us-ascii?Q?LNuxCz0FXMc4lCsvl1bXTtl2N7eELPaPhNDRfdBGm4OfT1gHkYhpwP0sKx6s?=
 =?us-ascii?Q?g+AVQlgzpzifqRkMS+1aDx29aJ4oPQx/DmkdfH3uJ03f6DTzRGbWAlBADI0B?=
 =?us-ascii?Q?cU3fWCNATpfDI4EXowDlxnakDMebuOxIE1/awRWfoWR8hIZBZSUHWiMsJoOQ?=
 =?us-ascii?Q?ZXdJcboIC01N2IpGxYNpzVeWRdcmweyB9pAYYOuyieiirHtN8VxGiBFs4uuT?=
 =?us-ascii?Q?RjCR/KEVpFNZi8UpZ4kEneIE9+MUdkzFODEmtvuSPg+MvSRiJxTtnwrHlomm?=
 =?us-ascii?Q?8ppviL88w2lPCYSjqK0lI+CckEr1jZevLJ8n05r3ZeIAMMhYokEgO8EFeCRS?=
 =?us-ascii?Q?VeiO5LIlmBzYmHRJdKiken5HDXMz680hk6gARM8XYj1bu8Ia7WLRLkpSDT7H?=
 =?us-ascii?Q?jXZvRhxhRBa9Mjyrbt0dadrN7aH58OZNKzDJZQOtsoBb0qJfzq112nUifBm5?=
 =?us-ascii?Q?jOol+N0RAyNMqmJzq/0bKdTRfbPWdr0R/iKQv76RGw5hflypTI2FDBWRDZBX?=
 =?us-ascii?Q?qB2W+PGcbsi0WRKh0Ko75vQ31ctdh/SH8ByVQ9VM0fmG+fALQ3H7/UharDZn?=
 =?us-ascii?Q?XqesYHf3JI97Sy2kivApUrEGEpoG+wVFNOL+5YS+xhLjz1Nuugis4kD8cAS2?=
 =?us-ascii?Q?QFUEXGEqmT0ALn82OB/2q0dZjM5+p/62hJjgqdG7ZkZKDRQeLc1I4hEMqmEg?=
 =?us-ascii?Q?glAkfQrAUMrbp9l7eH83PgZjnXo8bHy70SM0J4ELi2FSs0MDAoCs7aKkf0fx?=
 =?us-ascii?Q?oNYO6pK7gg2J3bGlLr1fEIA4vZ6c5ll1YUV3TaY/KNMy8j+AN5e7LUryQiOj?=
 =?us-ascii?Q?S6ZGsEAjY66mCMUzURPEINAc1PAcMHss7r5Bne+C1V67mGvxNptSQXe3R5Ht?=
 =?us-ascii?Q?ovur2bc7cRI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hlx6T1BIKM6r44RF/Ru5I3VaGyXMXcM2XsdfuUP2U4nA3IREvdnq50SuXiF2?=
 =?us-ascii?Q?beSUKffX3F5qCooAe5RQYJu06ZwGS4mo0BMKziTVnfMM8m/x4aKKa+JStmAf?=
 =?us-ascii?Q?6SNJaFZoe+lqdNIH7DYDSIZv5/hZnhcinJhrNEAGScF6g5iU5I13UDNiZSDE?=
 =?us-ascii?Q?Bwt21m0ow1eQjaDru/d2Oo4kFotLS1ONEIYYaSAQTZc7F53hNNghy7b/aCcN?=
 =?us-ascii?Q?KaxblCI3ocAUx/aGhqTv124BGmcw2RkDQ4Inavmx0ef0ut7ZesbWZR9LHz33?=
 =?us-ascii?Q?qioxcQhBdp74W0JLl22s1h2B/wkCNfed1iKHaNMzreoZxG1Bl0ppU/t6TJiw?=
 =?us-ascii?Q?k8lKWvegt59OXrReNRRwZlI+ws07Cq1FhYoaY9+k36jdTrFlAT1TRgV1MMEb?=
 =?us-ascii?Q?eUaBGxgw5ZYbXRcSNvf31EJ8ayZfcn6/F6nsiBeJ9ty5EawF1Y0izjXK2Yf+?=
 =?us-ascii?Q?D9j114n9CkgcXNICYuO0c1RIKk0aQtYOM+PKTmMj+MuxUiE32ix/dor6cq3D?=
 =?us-ascii?Q?gZjZvo4A0T4S6sAFeHFwq+Ecd6BToTSODPlL7wtTyItpvBIwQHL0gIVnrVAj?=
 =?us-ascii?Q?N6b7q1M8HRsAiVPvYfDHyQynNNsWvUMzgUAIoVu3l8Pa33TcuXTHFdL+oN2n?=
 =?us-ascii?Q?vlnTl9hW3vwWvZb2rE9sylcTvhQ5Z2XgxapK6ESIjbG7lkhUMd46lvCKTleZ?=
 =?us-ascii?Q?Vr84vdlcK7D4/5TuAWLaCJRrcSVtAxcmJthrZGNPGLlS7ZaJQres21nZJWiW?=
 =?us-ascii?Q?esRSeJ75fOVWoktRSFA3H9/KDxeRKeR9qj95T8CqHAJL9+lQ1mYfH181pgwd?=
 =?us-ascii?Q?sfsQGEscbb/f4a+oU91h5LBPWoiYQvLFxC71yJWxyJP0J0kjMusRy2lbo0mG?=
 =?us-ascii?Q?LmxUc0CNnM0Ti8TBensF9qhskYnFFd4LWfPXZTgBCMEg9y+FuIycff/MoVYJ?=
 =?us-ascii?Q?6KcfsBL5rtQX5Jl/YxYSwyDOgFakQzNryt4YgnPWT6s7DO/vri+vtpoNuoWH?=
 =?us-ascii?Q?LSYvbmt5L56qDE/KJW6Li+x1H3Pjdk/w1XhMez8LJf/tGdEGSldd6Gal8cCz?=
 =?us-ascii?Q?842ghBUzN8TBnXYMXo4+aVQbo26uaoUa+fpyCGlhu/Euyg9qGENb0kXpu6Eh?=
 =?us-ascii?Q?JLPBptfYM934GTteKAkUBDCMMjqZe80bIROCuUmjDGKs7KmiirFs4hyvMOaG?=
 =?us-ascii?Q?ItylZ7b/7mZaK9yO9g5bZuwS+fWY5wFXFpoCgVuUD5U5SYqHOJG6ri+0xhiK?=
 =?us-ascii?Q?ZCRiX+ZmoBhPlR08ClX1aX0O9Vz3xu/9Qx9wi+5utsNxYtVWLgz+adf3X8LU?=
 =?us-ascii?Q?WWtYOLp3K2zwjBfFSXTkjS8R0b4tat8ylGUapremaiE0V4kp2mMn9rrOoFqs?=
 =?us-ascii?Q?41LsyNoHRLEB4C+1FQyJy0WwR1868DpNyGwKt9rPvZOxpUB6HR7Anuh+Cusp?=
 =?us-ascii?Q?I3xyI0BQobXQouLSuCPMczlxCKJYbSG2zQEvTAB1l5WYmp6asAwHQHVZCfvZ?=
 =?us-ascii?Q?lPb9B/PIuYG7/tRVZaEUemsKrIkB2e1ZgmL9hGzAChHpheGD5DINF8kmVgun?=
 =?us-ascii?Q?8UP16tCBBAOb95TRBt4k/8z3M0SGHWKYDCoovxe3GmFhQ5pI/Y7uSWvmpW4f?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PHErjrAQfsG0486Ncg77pMX0rljMwhtskcAhwwTPmSjuPS4tzRdBCLNjtz14a4JYaxNigIft4ZkwJ5z5yBECcTaJiPsmqEW8Qq3XY+zCFsRezeKaG/mePn3PAdsOkpBUU4l74xc7nhhkYjdfJUZcLrRwVLu1f7QQo1oecbbpXGsc+FXdB4cKJYguPz2b3/sm8E+1VHRcMnIyX713iBOgcP9aa6lArJYtAKM4Uq1dJq6C/2iTLyzsJQuahpaMHrhggFo7IdjyBLoC3eHTMUrVFgWxK1I5YeQ77bJWXN86nGGwQ9ab4xjmKJwJfLNtDUsAL2ziCBLn50V3NxZnOlEtcrf3ANXgUZhh3U60tpam+uQ4k2/jTo+S1ZVUo1zbTXTODVBC/k6lvqtWjpyGDRD7x+6eZvWT9F3UHE7uk+W9H6yAVP7eowil0mh5OPq6TRJBlHFkxvOujodlWyxaB8aXFZHB9DtKZpGHndJ/FQYVZpCco0F50sm9l1Qkzwa4ttPS4W+fBlN4YbIVITMxxjIGW/MoKF40FeIWgHbYdNjAZv4pukEM0N6dezm/6tdY3Nf39vXfCQ+w6sJOH7b/suGUVmKticTn8URyj8Hr8+VsENU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89554c4a-f03f-415b-b53a-08ddc0524cd1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:09:46.6473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5lGQKDOwx18KedSjs10GkOEfSMYs37RqJlbqvWhXSuhmfJSWjaKM6RGy/pYywPPTLhJnfN/zw5Wr9T8UdSpYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110056
X-Proofpoint-GUID: 0nVeLl6VubFEJmVWS1ioqqCKbjRmAQCF
X-Authority-Analysis: v=2.4 cv=FucF/3rq c=1 sm=1 tr=0 ts=6870c6d0 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=oeePQw0IGsqOEWDZT9MA:9 cc=ntf awl=host:12061
X-Proofpoint-ORIG-GUID: 0nVeLl6VubFEJmVWS1ioqqCKbjRmAQCF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA1NiBTYWx0ZWRfX6F9VRvnZD5kQ siVXpcjp054SAHGyNL4WDzV13WNIZrfR6U3qhow82gFpnHwAVCfbINlegJUFZ1p0y3rWUReK30T N+j8lgRu81u5Yfd59eoLxQjX1goNx2l1JC9fJmvdiqAtqh4bKzkjni6YIlOhTFu7rYFSXw/7xp3
 w22kSNZCNgi1x/rT1m+oM025E6+1g4e2zXAKaSIvwIVtd9tjXgGSRJrYv+k5ChGIjV20bAmGK6F 1ErMfgKBXzsc5tk6ZZ2YqvhyMGbZZGrTlANgJAgJhWoPiN57y7toAVJx2CqJxyhaaIGEtis4/ID F6pljPafZ+fyJxYghdGm1OORohUVe3ZNRICz9d6iX2m6o1MlQRLqH37BqtuHDV4h1nkE1BWR+12
 7U+JMN3VlgrjfBNCqmGDLEyb97/sXEtgCsF0C4+RjTnDCRCsdr0pY0V6x6hMQ8VsNNuDuxtD

Currently we use min io size as the chunk size when deciding on the
atomic write size limits - see blk_stack_atomic_writes_head().

The limit min_io size is not a reliable value to store the chunk size, as
this may be mutated by the block stacking code. Such an example would be
for the min io size less than the physical block size, and the min io size
is raised to the physical block size - see blk_stack_limits().

The block stacking limits will rely on chunk_sectors in future,
so set this value (to the chunk size).

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae123..cbe2a9054cb91 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.43.5

