Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7A4157E88;
	Wed, 18 Dec 2024 19:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549465; cv=fail; b=LJx506imboafNm6ajmgIBA5yfWxtBlE2q1lviWDwoDm2FmwWiOC6p52DXOfJ0mcJA1XzaRos5qg7Br07Y/c+7CsSSVzRFTwyZMveQtEyuFU8/RctPxkhT1IHF4FK2O0jMVuSSByviAs2umxOSrAH/F8+lQ1LNpVbl8MqdJ9LRsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549465; c=relaxed/simple;
	bh=pfmb6bz9MnR4h8q5mIhK6mVuuEfE5ON3zzLlI0On65U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PtVhA8YNBv2RSbEEUTU79ubRQYfOqoOGILQUjdLTtf/94/2+lvR1hIjQL/R4AjirN9OvCD8VV6A1cIEQ4/M34u36vZCeC+rMxKATjC7syxRCxAdhO697rH5gPbqbJ4VQ2WwHg576tLzHn5M/aj9Lgy9DYj0A0UschRvzlDQONL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MXw20Z5j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x2D7GMFm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MXw20Z5j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x2D7GMFm"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQc0J029546;
	Wed, 18 Dec 2024 19:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hqU/YTse1a9OGgiXsUWT9ptHR3orfDg1ufkcZIrcJ0M=; b=
	MXw20Z5jofnHYE0glagChzPwhRcb/bE8v4xVwDevdH2RkdoXWi06fEp/xgXAhcgH
	/n4cY/C9Z5Q9oVa8w8CjOT0pOf/OCzXn4v7gYPM5E27GdvZieyEMLO5jndcspWeK
	0SP4myIhloVMyqOauID9yS/pu5bIWsPi5jhdtIPpsdgOQ3AjnPlwji6RQGe1CGUc
	6D9Ba73oW9IO2Wrcze5y0N3Nfs7uoQEkY61aDkuZoiaL+QYUPiB9m410eCPX7ig0
	5AxQix2G1UPpa+ZV96JDx3DGYCwZxIzNCCbWSnxVRdmuhHC0yVlcrf4it3wAv2YE
	cS+YGsfemtb3hm8hOr1cVA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t2hcqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIILfBZ018984;
	Wed, 18 Dec 2024 19:17:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fafty9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FymqeWbPu7eGyLyF1Znt8C6o5XWHmLDMFeQBTokNE/u46XAtcn8bb9cU2DUoQThllbKaMjq8Vm4iZ+BjN074mlxS2D+yHICdNFVwsDN+wIbG46FYANArTGBpC1YDEoTtHrL3HYmvXR+HGDve+WAphtXBmANhGOCP8emkWiAKO6O/FJhgcTLQPRJBPLJl21YDPt4qi0grCGT/Igg3g3LIH5owO/vGZdUlUxPMyn+CyU4G2YDc8hFjd+v8AI6ZkhrO8JzVU9dv+zDKClnjB4KVqcroRfi8hPL8mUSIUcsXsnbkiB8bx1Wq1b34rkTS/9XHcER7wXZxcZulIvsE4L1+mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqU/YTse1a9OGgiXsUWT9ptHR3orfDg1ufkcZIrcJ0M=;
 b=royL+fRLjGXgHFuHipA/RCdd+1rj2bby14kttHSTB3ZxLu5eEYluiIAlad7mPTMifZb9K8qhHAUZWOXzkyRul0lkdG33MHghxNTl1WEDQpCzBP7T2gnaqWna3jGsC7tBqBcVo5AkXIkuu6/0KgrH0n6uFU7uPvRPXdQsS+doEoAsHP+LHzKWfPGh+hsnmG4c+deoD2srJFl83CaGR5qg7M6PI+YyI49UYDHvJu9wFHI77//klYMcU1de+i1clhxd0RSXHIZSvit2wlUlj5Q4rNgwmAR3tU9mgIpM9CHbS57g18VNGpI4Yga3pudWgxIZiYT7zXOKqHT5C1tQQRnT4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqU/YTse1a9OGgiXsUWT9ptHR3orfDg1ufkcZIrcJ0M=;
 b=x2D7GMFmP8wQGkYWRetn5069KogMSegQ+iQE1q7wysflUZaCwafiMkUfsTVC+XVOC+XBEzfs4H4bqx2E3ogOnjTxJFfNsHwPAI4N2Rr0cO5L+L2dUi7sd1wsjwNjOou4reRjtiTo8vN2LSGRLGcijB55ykjPY4xjBZp/xdvUKqI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:36 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:36 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 05/17] xfs: create a new helper to return a file's allocation unit
Date: Wed, 18 Dec 2024 11:17:13 -0800
Message-Id: <20241218191725.63098-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: b8fe09c1-5aee-474e-bff7-08dd1f98a18e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NWUt/EYjXBGJhcyUvHEoD0b6ggqBo4jzROh5ACHtPxW/I877hZan6ykds3IG?=
 =?us-ascii?Q?F9atHLdWpZnshvgXQ4F4fjHR1+zYO8q66/+t4Lo4HkXi9mpFZaJZVxyNDLvK?=
 =?us-ascii?Q?COWTp6aGEeYbIa2w4H86lnYW+tL4YA4gL+7MsZADowIORRusCI8EKqhkKvTc?=
 =?us-ascii?Q?rSwf8avPGOwOrbTdpopZTlHDbkH4G5xjojDp0jK1xZt6h85xXyjVizZvQrHl?=
 =?us-ascii?Q?/YKV+do7/bEyQvNxR3mk3V3xUaW0jOBQK9aOMkVFM1VQKzf3W0WTFiqImips?=
 =?us-ascii?Q?eLWYg4AuHl2APZmm0+hAJHqI2QrUeQ4bxD6CyIa/cAIcZqqXs7Yvbb4lXqTZ?=
 =?us-ascii?Q?cKGs8nyhcFEx/gd2QTFWc2hpv7L23QQL5AlBUuPB1rJT+v0q5UNBAqefx6o1?=
 =?us-ascii?Q?rV547YuP5RPUz4LSAOFy4yjndxh/oSINTc3Dm5zpuRpD7IRG1CjLgtk2zwiV?=
 =?us-ascii?Q?Lv4mcJgMKHpylF9VyBTXkru7X7H9k+R6pG+si5GFBxU3J1v+oPxBi0k+lujT?=
 =?us-ascii?Q?4ofquRFNRWHNlCIaDXCnhktrvJ1hxVapxDoUrLeiw9dOc++WHELe5e9Cref9?=
 =?us-ascii?Q?rv/HdbfsTHCU/KXaKqQIit3w++YN18Ly8gH456ma74RnWhFdrGviyW8q+M+B?=
 =?us-ascii?Q?Jx+FcdWCBB9NdBkWPCC4eOamqpjq/RmtEVkDNXpIbwkamxrrFUHWBxJk34FA?=
 =?us-ascii?Q?DnQbgUzleg26klrZHmWCFuWzMLPKZrMd4/7+yMWR2Z/7QvW9rwgltANcJwG0?=
 =?us-ascii?Q?t1g9QZYInAeeseWZmuV5H10Y4tZ11THeC5EP7i4WEDMSRF/lZhKHfx1e5mNA?=
 =?us-ascii?Q?BhdupxoXj1DOyFUdQF0MYx5bgJLjb7Qjro6J7ekg0A9eftzO4ggH1C5FnGGk?=
 =?us-ascii?Q?/KRz4NB8LU7VIiC6yZCuNLNSvk9mAILA1o8jR795tdmNW1pIpeQzaXqsK3KJ?=
 =?us-ascii?Q?ApVl2Hlx/hzqBbXeoZg3rZFiCd4z4lP7vw/iqEGSuIjyti7+pNxLHGaAM+mG?=
 =?us-ascii?Q?zZSXdxcbTyIQhJBL/0qC3jjU1+zbrjeJ0It0yQfvj6QHFxbvM/4OQwkylg5/?=
 =?us-ascii?Q?lKFhBP7+wO1+2Zl1R7HQVI2IJNS+R5fMfSI38YoG4xiS9NX7V7m0bfU/2AwS?=
 =?us-ascii?Q?6CFQHee0TuYx8yIozT+DzG+DU7gHFYOiHwmOwSchgDEeYS/4RuAcBR1BE+1b?=
 =?us-ascii?Q?Kc7CEpqHe5I3Z9mafI25p0S/H6MwZ7M8jpjgDkeaAcRBiKpohsYBnldOqCr4?=
 =?us-ascii?Q?Su8Sdaz7Gm6w288dMRlhJc0Un/zgU2x7MdeCb6Di2GHK3iVnD4VvtN1AszMu?=
 =?us-ascii?Q?Fqc1YEWeW/VGtN/T10HUGXC0BOUJyUL27RFQSjrXo3fQwf8L1Nbmlvb3sEQS?=
 =?us-ascii?Q?7V9qTdMe6iqwzMTWWVX0pqHiZpNQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4rvYdSDl6zKQEpMyO/IoLYA9TbVf8PldnWMhZZrWPZwbEEh+tmpxNLxyEWCK?=
 =?us-ascii?Q?zpYqFLo8oyTssP5WOLY2b3TOfnZtw3foFNJEzWwBG8tLTRcW6D5xznnnt3Jh?=
 =?us-ascii?Q?2dmbvUQM3YXlFW9tGd4u8g6MQTWNCWPVnieWCNDr+5g5LDUZph2nLx1Q4gxj?=
 =?us-ascii?Q?V5xUACgBLvVvYpMlpdGwzU3NMJe7ocAvSu3OmNPNqZGQV12p4L4/5LtT5vZ9?=
 =?us-ascii?Q?M58vKBcFgAkvoyK+hpWzGvGNFtGUjcvCLnWq2Qa33dju3jWoW3fVVVmDghis?=
 =?us-ascii?Q?d5fwH9wAnLex93snVZ+118RwxCzhNi1CK9Sj7TbW2PzW5pfMz9hhkBp4dwep?=
 =?us-ascii?Q?uAp5GRqwcacA++j2t0fOkdu7RPbR9um8mnBHK2qkB11pRHF7Q0OgQyV5gKHS?=
 =?us-ascii?Q?ymhDHc8Xn6ey+mzwkABtBBLgXOIM7nTIEi5mXzwMrFDWlh3wT+1DaiP5kB1+?=
 =?us-ascii?Q?O9fCI5gbaud3OvAMMgDmWP7eWsThIq3HL6Z0iez9c7eBNdRlbdN5Bq3Puxd6?=
 =?us-ascii?Q?tOw3/rXQLdks85N4oQ5+2UNKL1fAZRG0xaNNksfYy4N0/e9NzJKHxdQ2PlUo?=
 =?us-ascii?Q?/2GqbQhp8Dw9Mjgbn8s3tyODBmq60JgOfx15W+hd4wNO7DCMi1hN6eJ0kqrk?=
 =?us-ascii?Q?PEBCdpDHzAgyQ20m8Q7TJPl1GDLhhAJapPIoJi9jjBvDYDt7svqzA+Nr5Od5?=
 =?us-ascii?Q?JI0Zx8f2pf6tU4YLOUeWOpfTiqEWm8XFAtBrhubs2FpWu5tuLaXmzJIo1w8J?=
 =?us-ascii?Q?Tveu2F3LN844fD6odcRkZt7Zf1pcjGd5kNYrNQ5tbTcILv6uBHXDC6RLweQ9?=
 =?us-ascii?Q?w3a+Yf9ZwzlFwNXN6K8Ph/xvYJQLQ1AYQSPGTbqULTHHWv2FXvRe8nZY5oPh?=
 =?us-ascii?Q?yxQA6pk/D1ctNDo9bpB93e8l84oHRlyawujJsgFVyYkZ48TDQr0Vx8tS2aeA?=
 =?us-ascii?Q?4/2Yb9vPbLU6MwCCbouRtFL9EJ8m8Ff+Vu1Tqr5mFomthO0PaGJzlYaTc6mp?=
 =?us-ascii?Q?KIpM4qh5y2pZ3WBKyHdgsD352ROUskwKPztGhRGQx3d8PKWkTrZbCI6PrbL/?=
 =?us-ascii?Q?gEzjM3Kq1a2fDsw6SsE6SLYFpJttCfb+QTzCvkaVKvzk7hXzcjhRL1TCj4Cp?=
 =?us-ascii?Q?SR2jAKJDmR4/l0eKvRH+RPYPLfFPhkxX2lzzRHdo6twN+DHZah2LQOtRNRHN?=
 =?us-ascii?Q?V5mTgF/NIstHXpt/T2Ga374gDleNutrHVFiitiknuGZ7uNFvUikiIra0o5Zt?=
 =?us-ascii?Q?/ebEEQ4o6H4ig2KalPHSdCDrKj7ec6kE3L1NR1U9Ydb16R9lZRsnlXFdyZwF?=
 =?us-ascii?Q?Nf1yM56vmOMoAwaBwEATR3WeOWQn3S0FQdsr4a/lb4aFa23DN/umbewr8Aue?=
 =?us-ascii?Q?9/8P0YQRQe9Svq/7AmbrWNjZD/1OxCRluiiKukreoimpqE3e6i0F2Jm0Bt7q?=
 =?us-ascii?Q?OyzEGBpzQSNBFdB1q3D7qhYWjTSWUxxJ3Ze5JShlyVKEUPtkinh4Q2B/p/Su?=
 =?us-ascii?Q?30OzBA3dMdII6kynw9wO7PcAiMeJNMK+1ndB4rTeZmydRm+mEBILm5qUNSc/?=
 =?us-ascii?Q?WFnDR0hKuZ3LWNkAQmy+JfBmPb0LtNSFV6FU/ngQ18Zf7mh9P1bBcRZ56nYn?=
 =?us-ascii?Q?6rl3uoZkFSPUT2sfm4gaX5cGOgvupUrCQDg/VqJZWwL7NYs05gPt9QUnR9j/?=
 =?us-ascii?Q?Jcqr1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TKyboDfbJiWkWBTnXXlZ7Vn2xxz8/QDWiYLtLxbmT61drKCDCmT6ppMpoW0zo21RWMc4S/a3XOLHO7rzGFPICVl6mTrraXGe987y+/uBM99n7MVq7hDLdV1tNmVpl+RV1CLe7lwEv+S55y/cYdoAijE0RoByxP7gZ7hQq1Dq9A6o4RV4w10XqRTAaKz8uXsFOOspG8BxifguHMTkcOdPMYvtApo0KgMFoTl3gKKahaNErcye8gg+wHnyZ/2l3SAnaFcMVwVLU4Ws4BHtRjjpArf9w0jJv8TRyVNCiUTeF3s6cebwHD2Q8gARWveOeJI/WvrcuBWBtNP4gKOv+Z3MmJTAUBXRnpiUrR7RrYvTLfaFN3fDsVTrbzXu9+oT6XaXa/fcwwMbK9gtce2Q73Xhiqv+laRXjqq8cOxBy0GlBEwnKp4XVxkopNVdzxwckvqLQY0LSUjaG3enwg+i4gpuN+4CH+t0TBYJh88TJBTrsXCjiwr1Os3r0Ly4cr5a0GSdpGy5OHAPhz/vVnN4KTFJWbDxnOBOJeAXrWZAheH8T88WYmEQ7sjaZC638hii7kUII1f0p+R8Ni8Iu+MRGXEyCoKU58WSJZcj/totmihgYPY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8fe09c1-5aee-474e-bff7-08dd1f98a18e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:36.4280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IloTCGeqjh4f6YbXo+2tsOiJqfKK1yng9Uqz60plJ/qZnoPP6n48dmeeHg+lAKCp9k0PyCtH9Tp6H7oCYB7dB5Lr67ChH7bxlye0S0iQrm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180149
X-Proofpoint-ORIG-GUID: GuSaiEKTmJZn-vsDfx3bdnLXuXuWjNcH
X-Proofpoint-GUID: GuSaiEKTmJZn-vsDfx3bdnLXuXuWjNcH

From: "Darrick J. Wong" <djwong@kernel.org>

commit ee20808d848c87a51e176706d81b95a21747d6cf upstream.

[backport: dependency of d3b689d and f23660f]

Create a new helper function to calculate the fundamental allocation
unit (i.e. the smallest unit of space we can allocate) of a file.
Things are going to get hairy with range-exchange on the realtime
device, so prepare for this now.

Remove the static attribute from xfs_is_falloc_aligned since the next
patch will need it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  | 32 ++++++++++++--------------------
 fs/xfs/xfs_file.h  |  3 +++
 fs/xfs/xfs_inode.c | 13 +++++++++++++
 fs/xfs/xfs_inode.h |  2 ++
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b9b3240a3c1f..dc26b732aa24 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -39,33 +39,25 @@ static const struct vm_operations_struct xfs_file_vm_ops;
  * Decide if the given file range is aligned to the size of the fundamental
  * allocation unit for the file.
  */
-static bool
+bool
 xfs_is_falloc_aligned(
 	struct xfs_inode	*ip,
 	loff_t			pos,
 	long long int		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		mask;
-
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		if (!is_power_of_2(mp->m_sb.sb_rextsize)) {
-			u64	rextbytes;
-			u32	mod;
-
-			rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-			div_u64_rem(pos, rextbytes, &mod);
-			if (mod)
-				return false;
-			div_u64_rem(len, rextbytes, &mod);
-			return mod == 0;
-		}
-		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
-	} else {
-		mask = mp->m_sb.sb_blocksize - 1;
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip);
+
+	if (!is_power_of_2(alloc_unit)) {
+		u32	mod;
+
+		div_u64_rem(pos, alloc_unit, &mod);
+		if (mod)
+			return false;
+		div_u64_rem(len, alloc_unit, &mod);
+		return mod == 0;
 	}
 
-	return !((pos | len) & mask);
+	return !((pos | len) & (alloc_unit - 1));
 }
 
 /*
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 7d39e3eca56d..2ad91f755caf 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -9,4 +9,7 @@
 extern const struct file_operations xfs_file_operations;
 extern const struct file_operations xfs_dir_file_operations;
 
+bool xfs_is_falloc_aligned(struct xfs_inode *ip, loff_t pos,
+		long long int len);
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1e50cc9a29db..6f7dca1c14c7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3782,3 +3782,16 @@ xfs_inode_reload_unlinked(
 
 	return error;
 }
+
+/* Returns the size of fundamental allocation unit for a file, in bytes. */
+unsigned int
+xfs_inode_alloc_unitsize(
+	struct xfs_inode	*ip)
+{
+	unsigned int		blocks = 1;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		blocks = ip->i_mount->m_sb.sb_rextsize;
+
+	return XFS_FSB_TO_B(ip->i_mount, blocks);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3beb470f1892..0f2999b84e7d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -622,4 +622,6 @@ xfs_inode_unlinked_incomplete(
 int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 
+unsigned int xfs_inode_alloc_unitsize(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
-- 
2.39.3

