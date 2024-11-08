Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA359233D80
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 19:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731092607; cv=fail; b=g5YMeeUpQrDWjSATwkMX0OVeOJAOdpCo5ox9w94Rhon0gqpUiP69OQr2oON7KRQtzdOGW9DPiP+nDANPQsrv2P7YG9iSK1cbYRe39iZ2z3P22yANXrQGpbYN7YkdC0aGcdV1m/aCoBhSH47Cai99rFyEZ9XHFPt3SZEnBnfaQo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731092607; c=relaxed/simple;
	bh=nOgx1ea8WTi9YxbpoKHZ7ZAkWCH1/XIvFrKT14qAT34=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=jR/AwtS4j9KXLVzSPE3WTCC9T8IbU/GquDQK582gHzq6yBTiWp9BUTY8WXYUP3CV8upDrjuFlMGTtiYszZQGPZbMKRSzz9rJwt2k7aTZ5Y7FqBtb4DF/1prkhzsD8rM6REE5q6mhDw4AxuFTW/w2pjiNIUufhFzOAu9+3F0hblk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cCg6an1X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dya2jx7J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cCg6an1X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dya2jx7J"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8Ftj4E001747
	for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2024 19:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=aCkYdjVHY0IUzQy2
	olYaGR16f1lQ0OAdJc0fJihvnNI=; b=cCg6an1XIuMXIeBMLG3GTGAxI0co8w6F
	nnPRSljTVBgCe1wtujvXrHRopqOwfTqDiXT8jdAvsdGo4qYuJegMVb7uMTaqXiVI
	akcTBtG9evSSbxGF3MStx2NXJkmJ2fqELVHvrhXhtQLNqhsxrQ8rR2ZzjqWKSTqf
	HO6xk96PwlJ0FtgL0ZEy/CMT9CzRtmL8MF7EGccR18Scm1vKx3w6s0hle86rXxT7
	ILV1ng2NDIazb+6CCYlMNYJZg5Ra8YzED4kNVHBp+1BGCU+H7FovYtQZZWF0m0yc
	0gRTSqabclsIoSclgU1xbG7hB3BjXaGSFRGIEmUw/mQbXg8Yni6J7A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42s6gkj85e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2024 19:03:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8Inexc003505
	for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2024 19:03:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42p87f6dsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2024 19:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ko16E8xjdNSYsIbYh7ExSnQ3PmleZhTyW1+PNZCKI7QjiVmy8vCc9oTM9ydjwfjvj0mzJkrRL6pEEAKodBI3qd8Qbu6r0Q39Kbc59qwlgyZ0O2nmDylj+eh/LTXZCzLOSV85fOYwdFei9wm0n914xYEpgIDP9RvxBDisB0OE0p8LWM9PwIp3F5SnOL8kvh0VdcfyduhvMuHx8zpvn39fCMQ5cA7Cgmr1or9W6/LzjmN5LMH9H/b96/N7JKQlsMWMJWpFZkHR3hkPvCsDYn9G0ANZAgvHT8fQzQVH6+c3wnznVvXv4CHpHV3cZiIaR+JLkEkY3ffL1ehCwObaymIwgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCkYdjVHY0IUzQy2olYaGR16f1lQ0OAdJc0fJihvnNI=;
 b=I+xGkjNpdB/v3xOEXi80VX3oVka1BfjdvZJKcIgaaPhvpdu3B9PoKXFgZnAox+i0es+xnCnndlBtDeP9Ii5LOWhcZY90XTUkMd3D3V/+nak3kzXJVhH/H5d9V4EN6mT80yvsY00Yecl99YYqnkOefCaEV04b3DBekiDgTrhD/SW3vgoZqd6BkLn0Zozgs7ZN8dy1D2UQJXyYpDrHNinTKo8FmeU+i1OIj6kVTkojMVzKQk+dUpZUxn4xwgfU6XBMdskb3SCFzVYQKE8RHhCT3T9SMk15Ki9mPpdIpOdE/0pGLhFh5hGFwcG/GVEPLv0d7ZvKKs0ENHLDzIGzEqHrBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCkYdjVHY0IUzQy2olYaGR16f1lQ0OAdJc0fJihvnNI=;
 b=dya2jx7Jt9WLhFPWXvjo7NfSK4rnK8xG6qi+5vCAesUo75CCavxRrp3qqtTsGpuoqdn7hKyQSyK8nWMImIp9D+6GQfMemQUmjXoUSNsLVTn4jbRErei+eAjww03tbkz74XweQYSxaJ0HPS+j7HD2IeiiWHfksdVGQ4sCLJgAYDs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH2PR10MB4248.namprd10.prod.outlook.com (2603:10b6:610:7e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.22; Fri, 8 Nov
 2024 19:03:14 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%3]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 19:03:14 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v1] xfs_io: add support for atomic write statx fields
Date: Fri,  8 Nov 2024 11:03:13 -0800
Message-Id: <20241108190313.40173-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::24) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH2PR10MB4248:EE_
X-MS-Office365-Filtering-Correlation-Id: ac9eff0a-6f9a-4efb-41d9-08dd0027ff7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CbnU6/PyE9c9oFphXaeJBtOY7/KYp3YhAU5HAKjFjhlrE4U/VtIEeke3hD+N?=
 =?us-ascii?Q?+T3CJj56pTmwvnkBsZyWEPNNBsyC4LOwWXXkxGvQ+bbFoqXSRZBEq/IBN4QT?=
 =?us-ascii?Q?L8yHSXai2aiI1BYRJpfQ75W9fOtHHyEU76JwjbwhWVwFJgTvVbLFTYrtq1zj?=
 =?us-ascii?Q?CUaOuOD3bDYwpBfl+Bi/HhPI+Ju7mPQMlL9OhR5wLmVE+XCHiJbWrCAnkzeP?=
 =?us-ascii?Q?yIjmfZqslsL6j3PnKwA8kZK1q4IVuUCz7Ih9Ck/4NOZRuncNy0DSXrKA9Cw4?=
 =?us-ascii?Q?G3V2c9la61pxtbOG2bJlfv9zFEr79/BvVEce4vcIqE+cH2RnGpwDmo3a15UB?=
 =?us-ascii?Q?5cEIJOM3aEyM1DAcnTStw4yHldj8Tmk+oBGcy1BOkgbL2jSlfbS6fV/oeTwA?=
 =?us-ascii?Q?YRvPm2bCfM3VwCHegOBrYSv5zsyHmdQ8LYLV/m2DB7g+jwxig2Ci9aMpCFZ7?=
 =?us-ascii?Q?nBgrOqDylrBN2cJwc8xkyC/6jnhur1MuSbCpSg8qm6but82t4QIBsPuWA9Zl?=
 =?us-ascii?Q?n7JPMDsIaDIKxem1q3z9pHL9FfThBF5xpk0oipwNsftj7QfGp/XkInpP8ims?=
 =?us-ascii?Q?BqB1cVXuVTwRyWoSEDoBKd4GoImIQ3RMSMAETYAJQ5hB7Km9KvPsquhSAlDx?=
 =?us-ascii?Q?mKkPv/lwm1dSexSk+4kCKK7gACgFe5hTEL7eXfe9BRn+qcHfIMCUlMgpTX0U?=
 =?us-ascii?Q?IJL6iZjIFjj7+qJVQ4G2OCiC4NsWH5QEA7agIcDZ02ir8p65uvgQ1i0C/o4G?=
 =?us-ascii?Q?/9i+hzPMOn0L1KEWbEqmwLuFeQqZ0RLSsJ9C1dDo1OJT9oPOg1olwzvMP7AG?=
 =?us-ascii?Q?/26M51x5v3TeMgvlCCm0a1APqOdF+akfT4v6iVaV/dup9lpIbSPVezgfVbc3?=
 =?us-ascii?Q?mOtn4fVL9CxeLvO9zoMouUgY/CUOOcmRqqfTwLb77C5CS2hKUsBYsuBFlIPY?=
 =?us-ascii?Q?q4RhO1PMytcVNno8l46Jz8HF9f/tCZUANwJ1Fq+B12FlNeotg9A4xHR0Kxo0?=
 =?us-ascii?Q?xCK25M4oAfFNudwC4FRnMtelqIXQCpBiwZ/NVivuYg1teeki5ZJrLRJ1ele+?=
 =?us-ascii?Q?DdEUzbyUjvXBPicQzZXBUC82djdoMrPvBJQM7tchUTiAd1/DFx+WvHcwql1m?=
 =?us-ascii?Q?DT1wJqylwXa9omeuviaX0RPdU7zvGhgJpqyZSX4nLnP79fMcRaW5W3/Cz8uw?=
 =?us-ascii?Q?aJHW02lV3KmGW4cFpZF5KmQBqNWxBQz5jbDABwJMQc4JqC+beJqvmZiQirt/?=
 =?us-ascii?Q?moqge1tOBp5bvOd0ThzwG4IQotKtWDuYLNbDffA7nzm//d73PkOoYMEITzKJ?=
 =?us-ascii?Q?FhgpPjDwteTwa8QOwK46SwGq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fB2LTRZL3QtixTUg6P4UNYLVufcLSt7lLHCmPyGhVZSpHuqHrwzIzMkZWa8P?=
 =?us-ascii?Q?0enGR7k+BDLbOk2TpqSA9FXnBx7bssOWmZb1kRR/9kB3pDxxNAiDondydLRB?=
 =?us-ascii?Q?Gn7gAzQ0GL3WEoDiSSVNlPRdo6JYvn042owL6EDQqvk8ICfIzdJjzTXRBlLw?=
 =?us-ascii?Q?0bCpdUCvvTm2dWBu542tMBSagbCYDbuCG/7k8y43/B++YAOfD0oj9VVQ2csj?=
 =?us-ascii?Q?eR4nuayqd4thOkKEsp+E4oNwWw4EXc4fyxvRwrdIwCsehw1qfsN0OF4bLnmy?=
 =?us-ascii?Q?JzU7nn1OGultnQMF+W3MA4Y8mbs14eNIxnJBX9QvBH0mGlx2hRk9tYaPsSOc?=
 =?us-ascii?Q?WTKV43FT6yiKbPdSNPQvRvCISzlmVJZrWnmgTFzj3rni+NzCOGnoPwtLgt8L?=
 =?us-ascii?Q?pG1LXTvfshkvSKRWj690E33Pxr+99GEWU5JO1oBYvPZF5Vo6gVtXAXwxe7Z/?=
 =?us-ascii?Q?hfWGj59wEpHThbV0uyGJ9x0nE0bcBrOn3nmEow1a4u9KiVdrWS+bZ4gxNbxS?=
 =?us-ascii?Q?/GWB+9km1N+OlhcTsS9FBB09nzUnAyT9rN0MPzdAtG+t1HsbgP0DdHFuMN6S?=
 =?us-ascii?Q?D/6Zo4MEQCavdceyjCgdA6r/VCKBkR13USJCILMWkltbpy3l6P1tlubZcFFi?=
 =?us-ascii?Q?Uf2Z/ezyNP2aD7H3A22/6e4dQVWA6tRt8LKc0gcF9oj5bV2aLhTksurQ9ssy?=
 =?us-ascii?Q?xjtijcrsNl0rj5d/PyjL6V+l+0/Nt5ou+4lGNt8MH2U9LgL7Mslz9mmDWufF?=
 =?us-ascii?Q?uhBwCQ2Qu0YD46cUtK+drGVzX5GX63UZRl9Lsb6dqo5xxDg2FtZ9p4WAC5u7?=
 =?us-ascii?Q?sXilNF4Ao21LiOo9yrLUIQ9/w3CuukfKq3NiT6jljsBTbPoy8X1bXucfdrsE?=
 =?us-ascii?Q?q6wbh572pGHTrbOHBQuoeMNCPJsiloqErK0MJH5i65jyfFZrZ8EIeZ1lBIX9?=
 =?us-ascii?Q?9Lb20xXkbqY9/WDHixiPy4007/zSoWlrOsjeIP6J8avJzqtyPtVxNbgvCJel?=
 =?us-ascii?Q?7HCkebwqdfesROMCHQLOHoQwOyxnZPf7zYc82nKxWbC/6KfKEokW2pjC/qSG?=
 =?us-ascii?Q?Xa3TWBFIqYo8TOVSn0oDLkVnIf/hjFmYfO7a+NPEyidFAwj75NTPVPhBFOT/?=
 =?us-ascii?Q?HnayqJbRxMIcJFmQMoETwVsI8ePbbpQ0TYfX5StWRiTRn/+1n6MxqgQD1evS?=
 =?us-ascii?Q?Z9yNFLgZt2s/en14OliEhnHtEj2eE/tCCevBnoheNrjM1oWjrjJzSaegfxJN?=
 =?us-ascii?Q?rJ8fc/ULhFLnS9Ho9JypivF32IzX5ZvH6xrHRd5wtQ+Dw6Ja/vPG+2ln8LHn?=
 =?us-ascii?Q?0wTS8CQWKVf2QEI+3H3G/DbGF1GRP4+ahVkZ0JVMtgcixIqCUGjYvUhpOZqI?=
 =?us-ascii?Q?hmEJnhrLaZzIOznmshBg1BF++6iGSdsUuGe04aDDTMjS5VF/Iu2vqcINHqQl?=
 =?us-ascii?Q?Fgjiw4vztSB0JV7dEdLtIUonlBC4jiDIKPb1aWCcrdg5XSZgsKHrMj5aE5SC?=
 =?us-ascii?Q?VXtyu10RzSnjssgzy+ha5z09PTF1XW+1a8FuPD26cUS/Bkcv/HRDZCbegdHb?=
 =?us-ascii?Q?+UOd+hHt3lxL7RiinIFMAn1008MrJRuWlxQaRilMeMNSxBaPgWUZhWgAcBS/?=
 =?us-ascii?Q?JVQcbg/Bax2hg6upxqnq7r0Zy5lPzdiYfyVpcamPTkniN3i7PuUtanf9RTVs?=
 =?us-ascii?Q?ag4EQw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9MyDHkNADN21SbexCrC92RbK+yUv8hfyMVIs24ZFNyIGGnUzDDjHgi1jWw/AI5rLhnzlIjqA88cjoEJ6YmLccWiPpcitrv5hbrHID9O5p3a+SiJtKZUYmGlJ1ANaEhVo4t+aSVtHhryutotKtGLqJA8sNoFfra1zdcmGnk6Gqhy66hFDrLkv4Q0gVAvMN0x2G/G21t/oKUSUh+33y9NW5yv/x1aXqESez2qM9Z0s8QLdwdQE1Yzw7dIxuBM5qY5hdhBl+ovtAUPrsWgmHjx06BzisJ33HHrFxObK+DJ8GJZkJblAbVmqqKRIatSUJ4y8GAuEbS+t5Q8/TiMUXbQ9S/u1dVgWas93HurilKPTw2akeWoGuJ52BVpriYwUEpFLmByQtApg54AOV3xntPgHX3JGylFss/iSUwAQ57EVz9+ryLbCOdRnXvHx3AdLcpdb5DV6aZRugJ8sc0QVwafuvpoBNG10SHeA9IRkD6+1gjeIwQD6jrCh9J9O9nSZYTJQ8TuIMH/RQxH/HfZFN73oIUTS0bbPQit9U2x26RU9tLG6Y49f+H8Snu0d2HfBL7RwBsxP4Rj7kKuX2/KAx+Y3CmUM/HlzpbU14GEcN4m5TeY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9eff0a-6f9a-4efb-41d9-08dd0027ff7a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 19:03:14.8286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LWL9KCnH/vdFwkEsQm5FtYmrFvAQcjkkOs1b2wHrUWKZI8UaUoIvNatAcFBf/rYrLNTvNdIHdSXc++zJwQKETp7vyAIUr/qeMlSJQvnpAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4248
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-08_16,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411080157
X-Proofpoint-GUID: vKMMf-B3Z3jCJ6HmpL873sHhaIhew3pm
X-Proofpoint-ORIG-GUID: vKMMf-B3Z3jCJ6HmpL873sHhaIhew3pm

Add support for the new atomic_write_unit_min, atomic_write_unit_max, and
atomic_write_segments_max fields in statx for xfs_io. In order to support builds
against old kernel headers, define our own internal statx structs. If the
system's struct statx does not have the required atomic write fields, override
the struct definitions with the internal definitions in statx.h.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 configure.ac          |  1 +
 include/builddefs.in  |  4 ++++
 io/stat.c             |  9 +++++++--
 io/statx.h            | 35 ++++++++++++++++++++++++++++-------
 m4/package_libcdev.m4 | 14 ++++++++++++++
 5 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 33b01399..0b1ef3c3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -146,6 +146,7 @@ AC_HAVE_COPY_FILE_RANGE
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
+AC_NEED_INTERNAL_STATX
 AC_HAVE_GETFSMAP
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
diff --git a/include/builddefs.in b/include/builddefs.in
index 1647d2cd..cbc9ab0c 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -96,6 +96,7 @@ HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
+NEED_INTERNAL_STATX = @need_internal_statx@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
@@ -130,6 +131,9 @@ endif
 ifeq ($(NEED_INTERNAL_FSCRYPT_POLICY_V2),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSCRYPT_POLICY_V2
 endif
+ifeq ($(NEED_INTERNAL_STATX),yes)
+PCFLAGS+= -DOVERRIDE_SYSTEM_STATX
+endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
diff --git a/io/stat.c b/io/stat.c
index 0f5618f6..5c0bab41 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -17,6 +17,8 @@
 
 #include <fcntl.h>
 
+#define IO_STATX_MASK	(STATX_ALL | STATX_WRITE_ATOMIC)
+
 static cmdinfo_t stat_cmd;
 static cmdinfo_t statfs_cmd;
 static cmdinfo_t statx_cmd;
@@ -347,6 +349,9 @@ dump_raw_statx(struct statx *stx)
 	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
 	printf("stat.dev_major = %u\n", stx->stx_dev_major);
 	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
+	printf("stat.stx_atomic_write_unit_min = %lld\n", (long long)stx->stx_atomic_write_unit_min);
+	printf("stat.stx_atomic_write_unit_max = %lld\n", (long long)stx->stx_atomic_write_unit_max);
+	printf("stat.stx_atomic_write_segments_max = %lld\n", (long long)stx->stx_atomic_write_segments_max);
 	return 0;
 }
 
@@ -365,7 +370,7 @@ statx_f(
 	char		*p;
 	struct statx	stx;
 	int		atflag = 0;
-	unsigned int	mask = STATX_ALL;
+	unsigned int	mask = IO_STATX_MASK;
 
 	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
 		switch (c) {
@@ -373,7 +378,7 @@ statx_f(
 			if (strcmp(optarg, "basic") == 0)
 				mask = STATX_BASIC_STATS;
 			else if (strcmp(optarg, "all") == 0)
-				mask = STATX_ALL;
+				mask = IO_STATX_MASK;
 			else {
 				mask = strtoul(optarg, &p, 0);
 				if (!p || p == optarg) {
diff --git a/io/statx.h b/io/statx.h
index c6625ac4..0a51c86c 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -5,6 +5,7 @@
 
 #include <unistd.h>
 #include <sys/syscall.h>
+#include <sys/types.h>
 
 #ifndef AT_EMPTY_PATH
 #define AT_EMPTY_PATH	0x1000
@@ -37,10 +38,10 @@
 #ifndef STATX_TYPE
 /* Pick up kernel definitions if glibc didn't already provide them */
 #include <linux/stat.h>
-#endif
+#endif /* STATX_TYPE */
 
-#ifndef STATX_TYPE
-/* Local definitions if glibc & kernel headers didn't already provide them */
+#ifdef OVERRIDE_SYSTEM_STATX
+/* Local definitions if they don't exist or are too old */
 
 /*
  * Timestamp structure for the timestamps in struct statx.
@@ -56,11 +57,12 @@
  *
  * __reserved is held in case we need a yet finer resolution.
  */
-struct statx_timestamp {
+struct statx_timestamp_internal {
 	__s64	tv_sec;
 	__s32	tv_nsec;
 	__s32	__reserved;
 };
+#define statx_timestamp statx_timestamp_internal
 
 /*
  * Structures for the extended file attribute retrieval system call
@@ -99,7 +101,7 @@ struct statx_timestamp {
  * will have values installed for compatibility purposes so that stat() and
  * co. can be emulated in userspace.
  */
-struct statx {
+struct statx_internal {
 	/* 0x00 */
 	__u32	stx_mask;	/* What results were written [uncond] */
 	__u32	stx_blksize;	/* Preferred general I/O size [uncond] */
@@ -126,9 +128,21 @@ struct statx {
 	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
 	__u32	stx_dev_minor;
 	/* 0x90 */
-	__u64	__spare2[14];	/* Spare space for future expansion */
+	__u64	stx_mnt_id;
+	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
+	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
+	/* 0xa0 */
+	__u64	stx_subvol;	/* Subvolume identifier */
+	__u32	stx_atomic_write_unit_min;	/* Min atomic write unit in bytes */
+	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
+	/* 0xb0 */
+	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
+	__u32   __spare1[1];
+	/* 0xb8 */
+	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
 };
+#define statx statx_internal
 
 /*
  * Flags to be stx_mask
@@ -138,6 +152,7 @@ struct statx {
  * These bits should be set in the mask argument of statx() to request
  * particular items when calling statx().
  */
+#ifndef STATX_TYPE
 #define STATX_TYPE		0x00000001U	/* Want/got stx_mode & S_IFMT */
 #define STATX_MODE		0x00000002U	/* Want/got stx_mode & ~S_IFMT */
 #define STATX_NLINK		0x00000004U	/* Want/got stx_nlink */
@@ -153,7 +168,11 @@ struct statx {
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
 #define STATX_ALL		0x00000fffU	/* All currently supported flags */
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
+#endif /* STATX_TYPE */
 
+#ifndef STATX_WRITE_ATOMIC
+#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
+#endif /* STATX_WRITE_ATOMIC */
 /*
  * Attributes to be found in stx_attributes
  *
@@ -165,6 +184,7 @@ struct statx {
  * semantically.  Where possible, the numerical value is picked to correspond
  * also.
  */
+#ifndef STATX_ATTR_COMPRESSED
 #define STATX_ATTR_COMPRESSED		0x00000004 /* [I] File is compressed by the fs */
 #define STATX_ATTR_IMMUTABLE		0x00000010 /* [I] File is marked immutable */
 #define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
@@ -172,6 +192,7 @@ struct statx {
 #define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
 
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
+#endif /* STATX_ATTR_COMPRESSED */
 
-#endif /* STATX_TYPE */
+#endif /* OVERRIDE_SYSTEM_STATX */
 #endif /* XFS_IO_STATX_H */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 6de8b33e..fd01c4d5 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -220,3 +220,17 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
     AC_SUBST(lto_cflags)
     AC_SUBST(lto_ldflags)
   ])
+
+AC_DEFUN([AC_NEED_INTERNAL_STATX],
+  [ AC_CHECK_TYPE(struct statx,
+      [
+        AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_min,
+          ,
+          need_internal_statx=yes,
+          [#include <linux/stat.h>]
+        )
+      ],,
+      [#include <linux/stat.h>]
+    )
+    AC_SUBST(need_internal_statx)
+  ])
-- 
2.34.1

