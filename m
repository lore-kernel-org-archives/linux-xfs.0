Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A5C212FB9;
	Wed,  5 Feb 2025 03:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724897; cv=fail; b=p9RibYKMuFXci0b/BmSzjpMUsK19WGY69tK2yIGHm5x4MXFQGu1o28/k1TEg7aYldOy6+eYRUAwVnxNoobTr4evGAKf7WpXmgxPi8HdIYldm3SLbWCtMyLqlpuqSN2+21pfsDTFkNi/sy0NWbav/fLDPNPILlPVkkU7sOXrLofA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724897; c=relaxed/simple;
	bh=MxKq03efYUxoTnHwV/dLVu9V4IhG6fmmex32Wk55p1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iyv8DLqEbyJd7Pl8drSaTfS3aTn7C4GEzUS0sMmrful+scc0dt9m3LYmpXaS+KWM8Q/aR7xI7qBwnkoe+oaA589E5oQEEx/VwzYSe1yAKtMy37wZtMqPBSbD+YWVac+j6QE7ea+houZbQhiP+FhOg/TcbaHnPtDtKVjaHfYmkHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RwiBKTPa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wOjZO03P; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RwiBKTPa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wOjZO03P"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBsak027389;
	Wed, 5 Feb 2025 03:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=7Ekmo2+/bSllVxPx+2loiRokORX1yXmyO+ieWpdTjuc=; b=
	RwiBKTPaoP/EK2CZUjCkDaniLBup4rDw3vN6aCmdarIPQ2XyjUXuoyAhxc3a6hDz
	tg3IRw1+yoN1x2A8U+Up5bSY2FeUMoDKdzm3Mb3y80pQinLsdJuftnd4O62gIXcb
	RF7Ayz2+mo6NEUDdTQh1GK9UQizxcYt8RyRSRUotCejcAc5M9mhzjFOsasRseKuN
	K/vCm0ZZnzaSTJxY1D2/6BMgi/qc2GiVKGq9z6bu2u7JInh/mLV32gtFPoYyKCXO
	/nY1h8CG16F0+vZhK10Lq+69L+H0u1SluakG51LSandp1n9R1beSqg+YX/BcqTK1
	9ntOtsL0VNQvLLROgaUpXA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhjtx66c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518ZsT037739;
	Wed, 5 Feb 2025 03:08:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LvVjlMxm+c9AiHOsexG+lualxifHK77FSbng3STZIEntJRNBhHIXAjkNrYXWfOpk1RVkvccOagtaJHrv7yW1zLnNAI07iJFwFLS2k7Xkm3GNjEXKMjb85k9PL+udYgXuXqT0ZfAIX9M0Bu9opH2u3eTyvjvRZuuAV2q06NzPEnPTGuUeS1biK8RVCzB0ZbLo5TLFipZoU6/SxFFF3b75IV+nxCCoooplxiA5DjpK7SzNPTBKh7Bk23SENT/SXSYxLFCmLBesDe384VRoxNQQGV4JPZ47ST7E2r2Ab5JlPaTVQhDP4OJx384OpOkqdoN2vbRONyWmvRDyOF/qwdrSAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Ekmo2+/bSllVxPx+2loiRokORX1yXmyO+ieWpdTjuc=;
 b=U6wEVztyMDzH9T+C6sY8amZ80emuOeq6VeuYLNntGKNCwofpfsXaVOCbgzStCW1bmjKkH3G0hrOV/A89gFaUMpNgqg4KlC3dT8eXN/wGKEdriUEv6GQO7ihWAI/OsAQQOX0JPhAcdtEozJF5e3iaxOL5Hw68GUbdIKRO0k5uDnQzAi4ESUz1cySx5CLbTynWsA12cAEp2nUu9fdZqxgfS4WyywpnasecgFTp6Ilb/Z7rgUhtp6N4P/L9cYaMze3Hk2BjEoHSlo+GCWmmseS1Ewuy6n9rDen7LycCEumD4HG0jf54o/LwmIw6VaIPJJOilh/pbx0prSZaoiqKeCfiCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ekmo2+/bSllVxPx+2loiRokORX1yXmyO+ieWpdTjuc=;
 b=wOjZO03PXKMtIiyIXJ/nmQsOI8Z4zLI7AcluHHrXOZGV2rv/C+wbzCbz7rm1gVMFxJeerSHLQXTWfIIVJ4UQZyTFxtSYK0c7+GmYzJ3FRCyBM9qULxNqM9wh90Hu+kAkqYyyun3e2qW0UrP2XW+q1lmx9VSQ9lPaB04he+XV2Ww=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:48 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:48 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 08/24] xfs: return bool from xfs_attr3_leaf_add
Date: Tue,  4 Feb 2025 19:07:16 -0800
Message-Id: <20250205030732.29546-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:a03:333::8) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d22f9d-d039-4bf3-00e0-08dd45924533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+/qbGqgMSxZqejN+p9qKl2qiUqh+oQ6A9jB2C9GnxMq28En+z8hSumbFpZ3x?=
 =?us-ascii?Q?/HVXMaBpsJxglvnKXFaTK8CL4ECBar7DItBJQgq3m3fqBOuiumnXLwT1LrKo?=
 =?us-ascii?Q?2pZ6+/QwOrOTK5GVqI37esV0hbgJXyc9F4OlKmZVK871rbqIFw7BXZIiARtC?=
 =?us-ascii?Q?YIzhxKwSLsNbPwcBjYzoMulwM++2faOL8qqyJl91GOf04WGI1qJmB4k16IbO?=
 =?us-ascii?Q?GNSEFz0vqLe3Hi4wQ6y2l5QNQwg67NYJwFodi8FG2vfUEwp5nw4smXMAHSLY?=
 =?us-ascii?Q?DjqhEjM/q1bjHfr5qVnMIIsxAM/8Ht0wiosm8wX9Gj0MszPilXCv1Wfge4iz?=
 =?us-ascii?Q?Y67PS0P4ycwfon2PlUCo9lfnDHPe2HSeWkJGgskyoSe24Q8YBmGkpLyjCCIr?=
 =?us-ascii?Q?I82Ucr898nqAfAnIziqPfnjZ0OrILfm1g3OQQeye7HfpmEPXpFDulE1kSiR/?=
 =?us-ascii?Q?t/N9qlZPHJPDJwwqyoS2lEGw6vSsfr3dfudHUsDVBF286DuoouzkgRdjtAib?=
 =?us-ascii?Q?/iguEYp/589QwYdUAUNActKRkh3Q7V+Tk0PovNuec5zyaG9jKIkDhj4P8VQq?=
 =?us-ascii?Q?toUZ7rlFN53ptzskhVqxU6e5SdkKeq8Fr6zbIXGzzhPS4pNUmiDLfnt01jPM?=
 =?us-ascii?Q?5sc0g4qpGsnN2EXSsbsKKd4Q4YM2u/XeJMs0orFQuX0BawK9Y9ad4cSgw6MZ?=
 =?us-ascii?Q?+pWqfGUnsR8skz/38p3vIpwVVuPKEXGkr2LoOBATgbkaeAOveCWZyS0IyxDc?=
 =?us-ascii?Q?sk8e4YAt8Yk10yrcsS50YeRadzKADcOOah02JWKu7FyYjOYSazMorFBiNKfm?=
 =?us-ascii?Q?YMY2Pw00WrH4oux9Muakrw5pPSYLZQXYU0RBDZmDDOyZ5iNs4WAHgmb6N3qc?=
 =?us-ascii?Q?Y4uiIia8rbgMPmXV5oomG4FzZ9cqjxhFslKOrtaIEmF2gv2Y0qK0AfkS5GU/?=
 =?us-ascii?Q?QtqyU+BiYTl+AvihRDbDT3zLmEoKihEWB9NXSoaqFEkSfV6c2hH78EYKiCxH?=
 =?us-ascii?Q?zkMybA1z/LGbKNPaR2FV4MQLDF4gTwAA/sca5zYGDuFLkzRaHgnPw8Ex8/BT?=
 =?us-ascii?Q?jFYCRuwoR47g8NGOr0Ijc1t4Unr450uZhl6z63pfTv9gG3SHWRJZbiiASAqZ?=
 =?us-ascii?Q?6OmJ3CnTSEIg8sa/vZqhOTU9Kd8jKpGDtwHgy1Y/HaXPTdNsGuVZZAAUZCZI?=
 =?us-ascii?Q?utEa0jke8NCd3r0DedBWgP8rm3v3puP/MorK2cPw3U6DAb+oeUYoMbwbJ1aE?=
 =?us-ascii?Q?I1G7x1Hh9LhDGBPVebPO/bvK975HBp68IArsZv7vp3959BQiusZ6xBlRM/b/?=
 =?us-ascii?Q?iGmMJTCOwZQlmfLEQRsVBRK6OkLATuMeXJNa0TZMdb7bWhLpfuX8lHbB025E?=
 =?us-ascii?Q?3eY7RL5l+AaKzW0dDZCE4ftbphEA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HTUVru75JmUikTvNuxHURLMlA0G9GKcNejYg9Tp0Kwbhilo+KX9ZQYc03yfG?=
 =?us-ascii?Q?ncQcTPTN6RKW3uDHyHgD5lTuZ/vqjbQynUYICkXMEz7hZMAPH8z1B40Xyhb5?=
 =?us-ascii?Q?iMcpkE0C47QVJVg2mJtiGwTCu+zaTdtjFxWYqdJBFUKrkW8ZWN/2q1hAwSl9?=
 =?us-ascii?Q?2rUjLdn9peaDbKzMIfeKQHgMupdeiQpO03UN7/Pcl4iIEGornhA4c0UL5L6U?=
 =?us-ascii?Q?PevJPwwO3kgf9+mhNzsMcXYj1YZExKZ/7JllVRiWy3aTYssXxflsi/q7gEks?=
 =?us-ascii?Q?Mx1d6Hb3o4UgkmtX4tGppQUQKVKisTlwEDJrzsm6qh2E6lUMZp1tfo3WbYni?=
 =?us-ascii?Q?vX2TXVRfmojq7eRA4s0av1RNdUC58isNCxestuW9iJA5D3n5UsbJAJh4kdqc?=
 =?us-ascii?Q?Oe5f6gsP2B2fe0S8GpUQ5iII7iAGUHb/pwN6dymMgRUQ9fwHpQ93s4UlJ/0L?=
 =?us-ascii?Q?bWc8xo7g79YnyuMWUlRmNaIIq3qRSsHaqlKH3H7Wsu7+L5Tab/J0MLbnEs3R?=
 =?us-ascii?Q?YyEoz+F7smWTMwQehksPaYid4JLQ6ja0aGB1K7urKbjKyDQNW7mR7ZQsn0v6?=
 =?us-ascii?Q?3LkpTbR5as2Drt90W9VUrda+B+3W9VkSBeps+FFVYlRISCaq8hJTGeC2KKvH?=
 =?us-ascii?Q?h+CYqzSiMli/SU0RMHuEm1MaNVV2HHObwNVCmHSqXeiysxBuwhEQfk9q3VIO?=
 =?us-ascii?Q?rCpv0vYlBL7O11pK7B1ujn/ZUfXLsC+++8m20Y4aOrqD0oOx4iwH+gDxDtLe?=
 =?us-ascii?Q?0ocdMWlLWPCXZeTy+NWlvMOGRcBM/wXTG3IO3ojcnyq04aQX4HfF0bK4Q7Mo?=
 =?us-ascii?Q?Gx0cO7ikLAzzPyiOmjIdoUsgAwzbCEvp0vfxggMH3utJUouAdQuOle7OjkEw?=
 =?us-ascii?Q?eiXzQF49yAGGLb8l5ETa8/mNc0yBlDF59MSI8ud5vx1fMCkw4nddgJCi2FRC?=
 =?us-ascii?Q?ei3ZuDkChcYIbtBwVKc+6HyjXSVd0cOSUhY9Q2l4xQrpPiKu+dND9Hlb1TiO?=
 =?us-ascii?Q?6EKGQ15vRHOGM0QwDWzaATnDPVe2k/0hHDD+1U25uAutis+BtRK06gAst6D/?=
 =?us-ascii?Q?NrUPq7PeTyy2U9NEQ7rM1RCKqxvvWkW7GE+EnGu8dZjcaluudxatrAuBLySb?=
 =?us-ascii?Q?G9F6kMH4+lfkOzLFj83eGj19/KlR9b5bQDLTbtjbqNOAQs9LVn+bbH/T/ice?=
 =?us-ascii?Q?rLPMRieq2MgGKwCNBkJWTsMJwb7EETzyTgRL1ZCuBC8/a1zRGOHPgVPbGggM?=
 =?us-ascii?Q?N1fG2xifus2gviLBzkvBxPhZLNWrLHBvGJ1HJ30N6AZ+e1iHXmszrVa//6yx?=
 =?us-ascii?Q?o7wS+KH267vH7ex5hDjOI005WNb7zNuU/fOv7+P3sOmZMXQ66hciRILbbS/6?=
 =?us-ascii?Q?ird6P+uJGqlGga4AuKlaah5CNFAmq+QrNKFTPouGbdQuTwLlBOp16zAjOv1L?=
 =?us-ascii?Q?10kK2pM0tD77PtwJiel6akQQxZDdDOOEuWTQ9oHbnEnl2pKGsVusYz23CTF+?=
 =?us-ascii?Q?7ekrvBD4qDH6m06tXYnQQvwRCFZYRKbNQBKaZrvwDvPxw6ZWBDPy7e1xGjtr?=
 =?us-ascii?Q?UXHNk6lcmFcvXftvTy3EjizUuAkUxi+EIFvgpLk+2o9NKyHy+c1UkgQETB4Y?=
 =?us-ascii?Q?GnAC8k4CHHAXRG2QY7840YV7gAIJ+dfu01QQFTr717juLowBebbeCR3IzfmN?=
 =?us-ascii?Q?Z6BMzQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AsfbzwKOswMk7tcgNzFbTdecZFUBeSzHmvY6YfVERx29P37NpSoYXeCbX70NaqXLsWTCdw9Iqq6PRhyB5zC2uqWhD+1iE7VVCHqVzLMXGIRWVZwy9uOdBGqbS2z8NCOH3Q/QRBYTy1CX0Q1+BsYILFQDo8K6Rrr0kcGCK/W5Li8YaYNH6aQpztGQ9jAiqjfpxSoT4cJQ1uH9ENhXBMxP39CiSu6N+GvnrT8ghyzQQMQ1pKBFOEsRSjwVKgKPRAdsqOGg0/c2WavFmQN+UT3TvyZo57H8YhIjiYkKhnAG79f3NmVHSgTGQTU+AVQBrBJ8S/v/6GNeaWYDB5DdbfxqI1tcmMn+jMKFGGtIww4UCrBmaoq+2p7Jr5CIge1eXHEXV8zv28bvxb0ZYU6TmRte0n1+pd5eI9sl+hZTp3cWw6KMq3XXlXAAJw1OpjKePry+LkumUjHLxs7j6svhPgVYITKtvvf+WRDH0ewP+llDCLwLGNykJOjiXxmgaU5sqYzbSU/s9aZKC8Zzd23uEFKRdWefG6Og1b4hyLI/QwjGzXwlH/p5GvukT5zcGEjl4GndVbymOMrGpuW4AZHzwxdugm67x8vPOIQikA819uMtpuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d22f9d-d039-4bf3-00e0-08dd45924533
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:48.7021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iO6ZPA/dDXUmgUxrehvUFhONWfTU3CrvCRM4ufwvx5VwI0PTAHSaRjk949NgSeeU3kqFbXD+lLrSdCscxmC/QHJyJ/q/X3ocoeplhAS4V30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: 5vAEqqs9ZrqJTX2RcFwU7DSMDSJYJ2v4
X-Proofpoint-ORIG-GUID: 5vAEqqs9ZrqJTX2RcFwU7DSMDSJYJ2v4

From: Christoph Hellwig <hch@lst.de>

commit 346c1d46d4c631c0c88592d371f585214d714da4 upstream.

[backport: dependency of a5f7334 and b3f4e84]

xfs_attr3_leaf_add only has two potential return values, indicating if the
entry could be added or not.  Replace the errno return with a bool so that
ENOSPC from it can't easily be confused with a real ENOSPC.

Remove the return value from the xfs_attr3_leaf_add_work helper entirely,
as it always return 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 13 +++++-------
 fs/xfs/libxfs/xfs_attr_leaf.c | 37 ++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f94c083e5c35..1834ba1369c4 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -503,10 +503,7 @@ xfs_attr_leaf_addname(
 	 * or perform more xattr manipulations. Otherwise there is nothing more
 	 * to do and we can return success.
 	 */
-	error = xfs_attr3_leaf_add(bp, args);
-	if (error) {
-		if (error != -ENOSPC)
-			return error;
+	if (!xfs_attr3_leaf_add(bp, args)) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -520,7 +517,7 @@ xfs_attr_leaf_addname(
 	}
 
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
-	return error;
+	return 0;
 
 out_brelse:
 	xfs_trans_brelse(args->trans, bp);
@@ -1393,21 +1390,21 @@ xfs_attr_node_try_addname(
 {
 	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_attr_node_addname(state->args);
 
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	error = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (error == -ENOSPC) {
+	if (!xfs_attr3_leaf_add(blk->bp, state->args)) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
+			error = -ENOSPC;
 			goto out;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 51ff44068675..539fa31877e7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -46,7 +46,7 @@
  */
 STATIC int xfs_attr3_leaf_create(struct xfs_da_args *args,
 				 xfs_dablk_t which_block, struct xfs_buf **bpp);
-STATIC int xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
+STATIC void xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
 				   struct xfs_attr3_icleaf_hdr *ichdr,
 				   struct xfs_da_args *args, int freemap_index);
 STATIC void xfs_attr3_leaf_compact(struct xfs_da_args *args,
@@ -990,10 +990,8 @@ xfs_attr_shortform_to_leaf(
 		}
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
-		error = xfs_attr3_leaf_add(bp, &nargs);
-		ASSERT(error != -ENOSPC);
-		if (error)
-			goto out;
+		if (!xfs_attr3_leaf_add(bp, &nargs))
+			ASSERT(0);
 		sfe = xfs_attr_sf_nextentry(sfe);
 	}
 	error = 0;
@@ -1349,8 +1347,9 @@ xfs_attr3_leaf_split(
 	struct xfs_da_state_blk	*oldblk,
 	struct xfs_da_state_blk	*newblk)
 {
-	xfs_dablk_t blkno;
-	int error;
+	bool			added;
+	xfs_dablk_t		blkno;
+	int			error;
 
 	trace_xfs_attr_leaf_split(state->args);
 
@@ -1385,10 +1384,10 @@ xfs_attr3_leaf_split(
 	 */
 	if (state->inleaf) {
 		trace_xfs_attr_leaf_add_old(state->args);
-		error = xfs_attr3_leaf_add(oldblk->bp, state->args);
+		added = xfs_attr3_leaf_add(oldblk->bp, state->args);
 	} else {
 		trace_xfs_attr_leaf_add_new(state->args);
-		error = xfs_attr3_leaf_add(newblk->bp, state->args);
+		added = xfs_attr3_leaf_add(newblk->bp, state->args);
 	}
 
 	/*
@@ -1396,13 +1395,15 @@ xfs_attr3_leaf_split(
 	 */
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
-	return error;
+	if (!added)
+		return -ENOSPC;
+	return 0;
 }
 
 /*
  * Add a name to the leaf attribute list structure.
  */
-int
+bool
 xfs_attr3_leaf_add(
 	struct xfs_buf		*bp,
 	struct xfs_da_args	*args)
@@ -1411,6 +1412,7 @@ xfs_attr3_leaf_add(
 	struct xfs_attr3_icleaf_hdr ichdr;
 	int			tablesize;
 	int			entsize;
+	bool			added = true;
 	int			sum;
 	int			tmp;
 	int			i;
@@ -1439,7 +1441,7 @@ xfs_attr3_leaf_add(
 		if (ichdr.freemap[i].base < ichdr.firstused)
 			tmp += sizeof(xfs_attr_leaf_entry_t);
 		if (ichdr.freemap[i].size >= tmp) {
-			tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
+			xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
 			goto out_log_hdr;
 		}
 		sum += ichdr.freemap[i].size;
@@ -1451,7 +1453,7 @@ xfs_attr3_leaf_add(
 	 * no good and we should just give up.
 	 */
 	if (!ichdr.holes && sum < entsize)
-		return -ENOSPC;
+		return false;
 
 	/*
 	 * Compact the entries to coalesce free space.
@@ -1464,24 +1466,24 @@ xfs_attr3_leaf_add(
 	 * free region, in freemap[0].  If it is not big enough, give up.
 	 */
 	if (ichdr.freemap[0].size < (entsize + sizeof(xfs_attr_leaf_entry_t))) {
-		tmp = -ENOSPC;
+		added = false;
 		goto out_log_hdr;
 	}
 
-	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
+	xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
 
 out_log_hdr:
 	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp,
 		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
 				xfs_attr3_leaf_hdr_size(leaf)));
-	return tmp;
+	return added;
 }
 
 /*
  * Add a name to a leaf attribute list structure.
  */
-STATIC int
+STATIC void
 xfs_attr3_leaf_add_work(
 	struct xfs_buf		*bp,
 	struct xfs_attr3_icleaf_hdr *ichdr,
@@ -1599,7 +1601,6 @@ xfs_attr3_leaf_add_work(
 		}
 	}
 	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 368f4d9fa1d5..d15cc5b6f4a9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -78,7 +78,7 @@ int	xfs_attr3_leaf_split(struct xfs_da_state *state,
 int	xfs_attr3_leaf_lookup_int(struct xfs_buf *leaf,
 					struct xfs_da_args *args);
 int	xfs_attr3_leaf_getvalue(struct xfs_buf *bp, struct xfs_da_args *args);
-int	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
+bool	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
 				 struct xfs_da_args *args);
 int	xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
 				    struct xfs_da_args *args);
-- 
2.39.3

