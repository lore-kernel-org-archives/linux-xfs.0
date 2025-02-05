Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45879213245;
	Wed,  5 Feb 2025 03:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724916; cv=fail; b=S9CT0KLfUI6YcaTiyMrmfDhfMIAjaWi9REj0Vbjo1fkOEuAzPfNrKiqUafR1fYG0wgf5lk1+qP944uCyrogH8VF72Dxx4JXzKrJ0tseCXCQR4TnbDcHtf3p5FOcl+jUvFTq6xwTbIq1npUL6onX9Rw74ZPgHG9hrgQB7MBYISQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724916; c=relaxed/simple;
	bh=wSfx2pLMQ4skAVPchNOaxdoTpCXhOdTFmJ0gD0suNAw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AO7KMDAEBNpbyocUNn/wk9ItpwQfX+59mOjKuNbZjbnTlQ7Dgd5JCDmZSxM8XHelKMo4ESBDjwu8Na9Qj1UjDc+fUxfh2X9YKY0f2VDiHJQrd1bUlPmh37RX86enls3i+Qz6tYHpYSIRkAUjadcYmcA52GCXVOZyymqVGSN+tfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=euAKraUx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UV8zOQ/D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="euAKraUx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UV8zOQ/D"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NC24T003319;
	Wed, 5 Feb 2025 03:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5ZMmfIN/TaudPO/xY2evXqqQEUzGxfH+3wF7TJpGRug=; b=
	euAKraUxyPF1RDJ79EnTP23kV5iN0kJEaiauwlwV2OHdoTPHy8ZixVUFS7nLW9gp
	rZ2WBM1RQUgFV9PEda//D8sgFbdETH5Tas2iA3Ob/Ec24AUGRtHwNJwmpI5dQjzc
	DG2mK2C6Cl1NpyWKLGL86dc7QLwRm2qzy9t1UCY9z0oKV839ayU7DLWPvyCA6c2z
	Co4/w+5mlEneZAnSGFQUfN4IaYX/eLmgugQsFBcP1DeGu6oFVxa0zJvx5kF6hbUd
	0N+KTlfbrrriVgqeX77J1UVE0kkHKsXa+pdpSEXf32DBHVnxc8yEGBicdbeKHkrJ
	Y8co5zCOhy2OdILfle/N9w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy863jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51513YxA037839;
	Wed, 5 Feb 2025 03:08:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsnev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tmOQt3wr4L3wCr63Bl8HkC41NsTpOGAvMvAZD2LJCNmfxX65UKcEOMrV4ALKIKjhnjCZaz7LLMy35qJPpeEIG+e2wiif1spvg42uRry14x3NicLBipU+QptNYp0nnanfX2AQgXj9Zb8pt437e2suuNb3YOTbFLg/WB9RpFa7YSrGPsh96pBo+Z5lwFl+UFBd49piowaeqvVIWJ4J8b7ZAMdpbh/rBvILVbNqP79xUmMIQRu5tTC5jjXx3+hz+xJAtRKzYPIJhDs6uKaZAnzQ+c6SC3Mx8BGE4wU2M3UYLurGUt9c/Q7K7P5DMRNhdmvZE+V66hk12pHelS9/cV2JZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZMmfIN/TaudPO/xY2evXqqQEUzGxfH+3wF7TJpGRug=;
 b=tmDwv3sJ+0Xk6wnjK6Dprbbs4Tb+4EEPVaoDKwqWSbQ+7PtNOhtY0mfllYLc4QUKL1IqyzIpZIq/1R2J+jLNJ9PAVvhZPN59xICbDgmH7eqNGEVq7kp3hzRy8Sc+nEhqUaUz18mCL0yPzKaW2KXpJaggQwcff11Xv35lAK3KN446C9oQirNsRgWS7omMilEESeQfsTTl0KCMmcTICcmEeot6CvWqE+AptjvMeT/Mec9i7wAemXJIz/3yfFtUK1dD8vI3SdGyxmiAEVcv5MPStnif8isVlN4Rj/GMialrwrlY3NtpmX05JoIJ0MVQgY0F+FV95DSCCtWVW5fRzGc+7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZMmfIN/TaudPO/xY2evXqqQEUzGxfH+3wF7TJpGRug=;
 b=UV8zOQ/Dw7gXXONgyC+nFRTLIPIf1ZS172272G/WbbAKY0Bzp4WqFVp0TQnN90R3vWLXdua94Ctlw69qY7CZY1FpQPdz68gJsORPxT/GpaPVYN2nNyaBVwdToExZXgvl5JDgYMlGzBPR9iKeqtheWF7Z4dLAxYnjlEnB5v1ceVI=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:30 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:30 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 19/24] xfs: error out when a superblock buffer update reduces the agcount
Date: Tue,  4 Feb 2025 19:07:27 -0800
Message-Id: <20250205030732.29546-20-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::29) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e8f23b1-c312-48f1-6aec-08dd45925de5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4p0I9jE88PH7EcZqKHs84t4p6KGiiFTmLfPZ/Z1DBIfwqTPeJO3eXRVPhWrW?=
 =?us-ascii?Q?DzgHs3mdjUAf6Ixv8eGlmaDhdvO8vTjPL0lHwRltUQIRX9gSYoMry+z8TaOT?=
 =?us-ascii?Q?y8MVh6eYZh/maMaVgow46OKdXsLKlLbP4G6KFPuR5btolSXXqb1ffrid9Jzo?=
 =?us-ascii?Q?c2E/wnte582EvB7Ln9RuVqQTUna0MxbKdzqmT+fdzSjgE4bKXkCjinYCQJ35?=
 =?us-ascii?Q?jAt9WQc57MgS8bsgqoW5arLcnAkZpcE6bSxxjdZmVPySMS0aR1TnMGHzCO82?=
 =?us-ascii?Q?jhBCPuT6GP5sjiTJfOd+Dd1HMu2X39UqQL2lXmyP5dTUqkOvc6cocHwOzD4x?=
 =?us-ascii?Q?QwNAx8acL5xrFR+0REHxeZZoCEJL2QSbpJUGwKTq0962PhD7fRADYYSOxa+4?=
 =?us-ascii?Q?Afmlli1jw2xry8aO+riFJuEs7msm4hbow1FXtdihl4jti+6ps5VC1dbbMQ3Z?=
 =?us-ascii?Q?+x2LGj4D1RTkEQ+yOM+Xl0fu4tzgg9qSsN5DhmC0VoDQwvVofh9flc+isvd4?=
 =?us-ascii?Q?Y+v+Mr08ot3Wc63wo5dZCK9pzQ7/kmWl1h7Q+fHwxDNdCrgoe39bJljHHmZz?=
 =?us-ascii?Q?lcvPnKbUd1UiF2gG0Wzd9mPOa3lVGB8XWYxTxHLefS682Z7B0ocrmzpTrSla?=
 =?us-ascii?Q?rLkKXTYdgTJTLZ73Z0+9qT7as5x2nTfrLqjLs3bNI6z81hoZ1zE1HXqTHK9J?=
 =?us-ascii?Q?76b4SWdEXXJBW4I7PMGWkX6EIf1qiWHVIWIEZJFTS6ljfIfk4QawKqfUe/3S?=
 =?us-ascii?Q?7A8GqWj2fMrrMm9g2ywyHBJLLjNZH+HqZz3Q1thzfrX3LtdW75iBaQmcBfIo?=
 =?us-ascii?Q?ZZrghPr/7vKZoNwqMtbUdMrc3tqa7vs99WJ3JKHBdkW3mrTjJb0phvKhKSfw?=
 =?us-ascii?Q?I8BJ3pWFHtEmGxRLlGMUx44wnRcCUTu7Jo/hWyCB2xcvRrj9pZTVl+lgDaax?=
 =?us-ascii?Q?OD0TSTtEgqDoVO4fdREL7O+qOIGZOiC/7KJg+kpyO2ryrwPsX+wbeHq/ZFZR?=
 =?us-ascii?Q?DqitaAQB5zKD1rZp0mJllWxpdUWraZc2bwupFa2dwbjHRaaZl+M3rGCJFyEc?=
 =?us-ascii?Q?Ta7u1SeV4smsUMG48YkdtUg2blCKh4GlMdl5O0s4FN5iD3gaEHbw6gH/yalN?=
 =?us-ascii?Q?9FAFUqkDN0bmQ+kkfABfRFD1x91edbfwHlMunezHD5AIYSlkVVjWF3qhyi+0?=
 =?us-ascii?Q?mkJGvvQXwaUiOXXgeY21HH1xw/Lruhv9cg0XSuNczOv+ZeytdmO4Zso0yyWW?=
 =?us-ascii?Q?qMH+/sVcBnM7CB1QHFafpLQfBeseu+8sZVLgQpc4qrImdzvvUU1H9WMQ+5BB?=
 =?us-ascii?Q?0aKffsKEK3v/SprY6ZYfPTlmnvLRH1psYwlh8tgsGZBOxhA8dMO3cv/ijRWg?=
 =?us-ascii?Q?ZChOoTgtDv451qtQnoRfIzSloRSc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jq2f1913t7Cdk2RyAdd2jcClO6vPohvfS2OJgKGE1yr8WyKPHF7XRaFNCSHe?=
 =?us-ascii?Q?vO4Rl+E+sC03X66egX+1YIUkVm8uHt/okUs6xzKRI1llLKRVQjwKKGC+AYHl?=
 =?us-ascii?Q?yXr26llw5OmG4Zpf/SEJXXdSkI1WgOfDo/TL0j/eVk8F0eVuD8uIQYCvtXm9?=
 =?us-ascii?Q?KrlvtK6K1J04qP/OQbqfBkyuMhtvPiJsnSWm4JFvI7dJlSW8YST4QUC90P8m?=
 =?us-ascii?Q?VcFgyFox+dfvc2oDeSh3q6LufLYCEVVSuopH12fk/hUem8dqDRqW2Aj82t9w?=
 =?us-ascii?Q?5NdBHc3a/QqyjeChEWMY6YWJMzEu6s5hVqKaEf3gwuz2/0mOcSlrMuXgTTsv?=
 =?us-ascii?Q?kx1ooZ3X8stplErkuOeEWouLoT6vEh+5YeI58ZX1TpDANMZREpfGqDc1VB7h?=
 =?us-ascii?Q?W+cZO9sFZWRDjbNBQ+sRZkU9xXUtuw/otihL0WNvExrShIjDk0XKDM+cWhEK?=
 =?us-ascii?Q?IwMQkRRuenZWdV25lBclEJ+2fRmazL7UY7eiR3m+h0pTk8i7LuRGB/5L9dM5?=
 =?us-ascii?Q?8EZGi9aSMBIeTpgRHJ1vUgbggF6YSFRvAB3uHEzHhEnnRN+gx+sL5ONVP6O/?=
 =?us-ascii?Q?J82XNPpV8J8zjHd9gGE6xld04jvNeOXFeElkpZTGX49njmmLKXZbRPyJbZTt?=
 =?us-ascii?Q?9c1jSyeZVo1tSro9FVVYlH1rLrCbqztmIblGaFV+S7UCK+Pzpczq4J97V+ZM?=
 =?us-ascii?Q?DF3ePk0+j3z29ilhoGdFYIKG0c/5YuNPt2Ir+2e4YfMhbfZRN+p62G24LsC5?=
 =?us-ascii?Q?NzBHj4ZjRCNy5Z2BcUmqwiB5blujHy3imo3xn3/1zURaLla4elebWQp3BFQu?=
 =?us-ascii?Q?5O/Et/+KCW3ZYQJvNnYCogo4CL+DvwNiGARNz72PJ4fIocMkyFVjQx0+winP?=
 =?us-ascii?Q?thDarpWB3FoO0IzMpkKpeKR+um0wHZNNLqrxzjSdkx5PnHF8+r/gadg2nE7y?=
 =?us-ascii?Q?VirYpu+3ZGQRUSpyW2O2HycSfvKr4XtWqxnNwYmjfMNrC9sCLvzNxMkYVvI4?=
 =?us-ascii?Q?c1kU4z8B9CzOgxLhrS8DaOtBdSE62gv++drCXu0ML6OA0AHfyV96aOFVO7/A?=
 =?us-ascii?Q?/4i901df4s1fQeLSDQbu8qKMS2UjXvTvw6Pq2p04YlCPCM/XyBxAbWhYcgLn?=
 =?us-ascii?Q?ya45OGZiq2ddf0pzPKXnv/D2oqZEGMCkAqdH+genmWmbYS4Ms3zbhNBX5PMe?=
 =?us-ascii?Q?yPpgeiUYvCJ8jLa63m5WZ1zBh2FMVGbuRv6EXzryO6XoTvIzd7opI7DmOQw8?=
 =?us-ascii?Q?xVqjHnfoh+aLSqOhFeWSoosW5ZRTQRQOdujkkGIPoegJJbdNAPkT8oNEsUmO?=
 =?us-ascii?Q?qSbxWxUftvPd/HqfjcfaZ0ioUXKY9JG4FrUII0/1u2ic9QG8iKz8NTaoYDY5?=
 =?us-ascii?Q?fN9ZVo9CZYUfX4i7RTBmyP/w+amU2cav3IBAAh3ZXKzNuKXXJWLLD0hs+UBl?=
 =?us-ascii?Q?1GWx0odN6h9WOQ9WYEpixc+8gxi7pgAn+V3nT4JWF+e6f0nYrlscXonKxo2g?=
 =?us-ascii?Q?TY+/L+9oPzWZ1uVTMjwCA1QnGUzYxCWb3Oi6fg4q4irhTjoSg1ExtCxJ1fiO?=
 =?us-ascii?Q?sw0QR3zpm5gk/X3meeYTVXQq55Gam9mUhmdaOA8SpBdjEgD8Z5FeEBeJgW7g?=
 =?us-ascii?Q?ZgtOHkcElcKZaTbRitELPhzm1g8IroSVlGdNQqZvEr6n4jQKLn6pNEa3zJjF?=
 =?us-ascii?Q?0G7mFA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5+arF93H7nfVkIIemotYi5pOBVWbssRGFV1p2gEc+RiWuCtMu2P/iS0ChpJuLHbWk6QDbI2lvAMWoSK9rkKt0WuAqxgp1M2NWS0nByG8Fgr80fGrImoJMzx1kPcm8UC/7RnSBaE+I7wAAkJ4aAq4SHrZDieo8v8FLOnwYwomJA7aD7elf2FJUXbMBrhepPx31vg9F1qE1PGfO7XiDJBAHpXBIIl18SS5jNXJTrJwP+VXAhzNZ/qAyqzdTsMqrVMdJXl2USOR7OmIKEJ5GDevIb28/LrLyVr55mLdYdXd20SbPQ4R+1NubXAUukWjXUc6ixzokwE7G0mHiZV5T6qA88sPVZbv7ELdqwavEyTBERw0CgLNIwHRIoxV91DG3Kz9zNGBgj56xKpgEWa51wGRmW8zdUmdKhLuIEYQSzIkG6X5yv/7i3v9QIz66Diw5Sqp7Rtymgzl/TPtnm9A/E2hTi60exTtu4BqoJ+48JYkbSiBBbZiU31dHzJhCzkYLF5EjNc1Ob7g5b3zzSRrumIhleNU+tKijT6t74UQ8/4vffW2w9QCOkAg711lgHLmq/bKa1Rs0KhPT2iKL29yPJeh+QMn7HMsLlyBBKB+h7Q4B74=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8f23b1-c312-48f1-6aec-08dd45925de5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:30.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBxgCOCyNIUC09aV77F28Zp/8zFheN6es9nYPFKbA5y7bsD1KZy4/OfivxupsUgH+sJcvS0qUuk4M6XhPC5W5VKn+Fbmio4/JnsQIB2lnoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: Dy_Jt_fs5NPgAjpqad3HwACFVU1CCad5
X-Proofpoint-ORIG-GUID: Dy_Jt_fs5NPgAjpqad3HwACFVU1CCad5

From: Christoph Hellwig <hch@lst.de>

commit b882b0f8138ffa935834e775953f1630f89bbb62 upstream.

XFS currently does not support reducing the agcount, so error out if
a logged sb buffer tries to shrink the agcount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_buf_item_recover.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index b9fd22891052..66a7e7201d17 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -713,6 +713,11 @@ xlog_recover_do_primary_sb_buffer(
 	 */
 	xfs_sb_from_disk(&mp->m_sb, dsb);
 
+	if (mp->m_sb.sb_agcount < orig_agcount) {
+		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Initialize the new perags, and also update various block and inode
 	 * allocator setting based off the number of AGs or total blocks.
-- 
2.39.3

