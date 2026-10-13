Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E3425882;
	Tue, 13 Oct 2026 09:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884297; cv=fail; b=SSw7LrfRu9CBrk6WD4zyDM6N9yvUKx/MYmMKNmBOQSo111myybjlV5dhOXBlh74V7QAJ/aS6DjuL8Oseiz3pnzAKNCZMSlhWCNGGzmWujj1Slqo+jC9A76pTtSRMrWDJnpOJglFDuQND3FnOWDAJllbWV0qHEkJSNvYQ1Ipj24E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884297; c=relaxed/simple;
	bh=CfBNZe18GdSgjGzpV5R1FibdKxD9l8H50rJKm0H0Haw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MQmjoD158qulaJhTQmzhStY6TJ2Ztg4bsDDflrh8NnDNLik4V2B8Pi4FAhTkde6UXWEjd3T3Hpc1TXckBOqN9E0VQzF4AWrQjJwCqJT1oBMFgf8QhaaNa5uw2UHqKZlK38LjDTrt7reSoXspbvL6qNTkAMp0ez33mrb3a0whGuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gdxqG6Hx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VWsKLelB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gdxqG6Hx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VWsKLelB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bpsq3197994;
	Tue, 13 Oct 2026 09:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=yO5dSRia7ZIqOUr1
	xuYwO+SDzxrJoGmINuUcQVUjGMA=; b=gdxqG6Hxvr2uWFsFSuEpCqJzLT+MQ4Gl
	XcTH+sf1ZwmnvVYRN8AY2P+wilswnSc3JnmbmqR9DnNCaDmun9nPvqIhdM6nsEd4
	EvYpoiN23o0YyaHR9rlggC/xQMKWhSv65nBOlbGp/d510J3Rx4+GoHa1cXoFsNQi
	x+zzUDbiuzcBVWr/Dnm4lQtIb2cozh5i5whzdH1qHD4PuqlSckbosmkIfrRVNHrk
	KvoZPc/J2h4eDUvohhQ9P09h43h5M6xmoNa1sabsRb6Ze5mfwR4OlsG447nQ+79u
	79GrORbMJON0lwezELC9+2grSpOEztnYPfZzeRHrir+kdjVAyKnRYg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9afZD016078;
	Tue, 13 Oct 2026 09:38:11 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012038.outbound.protection.outlook.com [40.107.200.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp151k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vA6C+5FEx8XMUFT847yxWk2m9ecGVe2bFhw6dcFah8s5SR49MAHv0sfE9pzpI/G9+SF1joaq5PZe2YIrrAqDGxJtIgs1Y4zEmJxCtz0LjGfhKNYaxxjuQqFGz5OxpAv3NVUCh6IUXXth4Yhf3qanUltVQU7NLKPVRbu3XKwx+q6GS4Xqdr2Ut8tWuxyd7R3DZ1spq9s+fAS2/vYGcMfUKAznmNO/ptBYXr9dK4jJaG8eTtY3TsZMGCUVRyw1uKP3VEPGuS5oG/TeUgCjX5W26eEIue8XkIAOXREnztpM7X1FVZcAOtZi+76/HjxjvPc54+VNsoRJLXzxO+mufWoy5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yO5dSRia7ZIqOUr1xuYwO+SDzxrJoGmINuUcQVUjGMA=;
 b=NzApQmaJOiiEKahiEsWLu+E66HW3iuM77ysf0s7jWFKBWVEN3hkx1HkjJhkfbzpWD6Nu0TWP/iDZb8h+yHPX21jTaVdn1LJesTHw68xZAjZd9GAEoRoIsO2xmtRMpSFTJmwIepJQJ1oQE4HTM2f73erGtU+wYTbYj4KJz9nH0rFEgywfUkQY62988JU2mkf1594mgVYQ9vcc0g1LrFxeItp6RutO/uZF+5LmONuDDPljp6oOxWjTpuVuvhcPlzDDEpg05Ek1wXWNE+HWcagvt0dQu+aDXGSjsshd3dxOAlMWx76MMle/oTS45zf1bUkOpUcqm61AjNVoa76DcJLLbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yO5dSRia7ZIqOUr1xuYwO+SDzxrJoGmINuUcQVUjGMA=;
 b=VWsKLelBPGWTrsON1doQwoUTz6sTcpGR34QjTxQPLsXFH8gTRC3Vj90jbuVsOEfx47xWdJwGvhBE8elMCR9XkggPrvp/8wyTr9uirL9IEeFz5+CIPTduuDVGTX2U0GeAp8CECDm0+58TUWhTSFtx4xG2noq5YCw78d1sVHoJHnc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:38:08 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:08 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.6 v2 0/5] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 15:07:59 +0530
Message-ID: <cover.1791883285.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 931c0067-ab7c-415b-96d7-08df290db0aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qQSIUYZk4MGFlGm8Y2fMYWl8Q16ZqafYbbIwE0fZx3ZJP7kLfjbdFyMFB2y/GIBDPztuL3boo6ZlTkqdml7ZDOcFY3uglCh8td2bmcTFDumhW/CfyzX+oWSzbhzC9nY76lu1Z/TgwwIU//YTsN0G4AH0sA6Cuc/Jn/OmenYk5cih3GV8sDAnu9SlqTlG9q82LTJCWTiBOB2ELc6RcDaW5DEA14sJQ9j3LwpYxKgq88DdRB0NYi6PJVFBjU1R2OmnfvZceaf8gB34NEXjy2csNcakoHh3UL8s0FhZ687cr4EvfKDfR+VML4/OR0AY+9LqmkRzBjqwRkkPsgidlvOXV5x47Rjj3zXFU/BTHpMS2A4GL7KE3lhDN5Wk+TUjYbEa3b6vUageu+m5mJDRzW1BXYYHqEjPR4mfkiu462Kjh+pnFT/ioGUmIzCuluvgzcqwGHhg2Q5E0niqd1Yaw4xBknxf8XZAOA0oQoxPjgzrVz+dbpioDZuDuaiYlaFoEjspXNQ7WnVTDOTOa5Lux76rX7Q6k2+6ynWYNO1VSH3QmXLOS6hejoBHp+dbok05UfKnmhZQ0PPfOXGbh1YFJOu9q4DSV9k6qJAe0tUEPt46Fnu86p/TYSoNdNCIpYJFXPJ3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dto9ELnWv7kmXLS6Rp9DtUgfx5gESzbiqeilgjsZy9ee1vX3yW8E5IlpyHB9?=
 =?us-ascii?Q?ZxZ8LdlXi53KnHQOHGDhmjV8V7506BPbIRFf+Edr20hF/zooi2QReBCimMGD?=
 =?us-ascii?Q?H4xx801+TuIKZ3ZsgPLE+SwVSwfaxBKHio3JUfoYy6mLF1kSNvqPjUf/2gXy?=
 =?us-ascii?Q?4LNwDBNOFhdye13e9PAGQgkpKN++mn7BdyeJeEGZtOhRmfGGmAAlFBBUOGo0?=
 =?us-ascii?Q?CIiHuPCg5aujEI2P6iU5cwYqJ0NNnwFx6SRCg5lHYPKWreOBa4p+16gqhMZi?=
 =?us-ascii?Q?ymDEp/lrvSIX+PUahorlusHuyYAiHNl19NvC7VweP3E2g/hfJH4xbjjBA+4P?=
 =?us-ascii?Q?aEX1azGvfiNBZr2nlOImdqm/a4iTbcVlUY1EqmYWsOAzIHEZ9+5qY4wDLhFL?=
 =?us-ascii?Q?R0K0Tk72fGZJLhz9v/2oBCvKBjGFe+jKT2hC+VMbiYh6N5jQ1+N+fnSQ9oG2?=
 =?us-ascii?Q?Tqnks/TgXutEWgxV0BqKV9YsmGKoYJYVbzyvlmY0ZaVEBJ55Z7x1Mf5QTIVk?=
 =?us-ascii?Q?mlFIvlJ8acJdJ+P6BZNJQEbs+fy9w82d34mdM3VeGYe3FykwEoY4gf35fgbD?=
 =?us-ascii?Q?drVr28bIur0g5XpHLECpNltsNEDiBAi8F8fAUKSsYBOaEyjNQ3ylGoQMThDM?=
 =?us-ascii?Q?NiPieZrzncO4IHy3m5xKkuYwjhFW9VkUjHUhIlK5+jlxZIhX5BrhvZRFs5IP?=
 =?us-ascii?Q?5quZlQ8Zol345qH4AokzgGCD3bPtoRRpf5KbqLQErGqUQSNFSSsUiwrlQ+u9?=
 =?us-ascii?Q?KUT75nYWLbKvOPA/0uYWJBH5wz76YTZTsCjRaWfb6XJHqa5GDkRv6hEFj0xI?=
 =?us-ascii?Q?jNaA9if1GCb3OoHN6BqvN+BopljjQEmRzC8NRFecTNevvaZ3//9+4+S1GOvT?=
 =?us-ascii?Q?bKdxszJf/vLMOPKaRJLBSgw7ngSXCZoD6wSaPIQSF4HMqzEt5rCxoGIivmUr?=
 =?us-ascii?Q?hui3QZd5hwW/OXIj6u8iXEE8iV+BrbJ4YSwsSHSe/oEYVcv2/v/MCxhsJLyU?=
 =?us-ascii?Q?h506i/ixTan4tbTBCPpZkXRuwngQ9JhpARTeWmbYLwNWde1ETZQDamMN3yJF?=
 =?us-ascii?Q?wONIKcEqJnxTsB9uGPYR58v2HxOfQFYTBzlLJLJTtDMJtEHrPUM6dsnxIDOI?=
 =?us-ascii?Q?Cd1QQHbhjdcz8chOLwdHtec70tnk49MSk+NLrYGfiGWmKSnnywgITynAlZdQ?=
 =?us-ascii?Q?7oqsJKuRgiewv0luHh8IAKIfJ1ydvHFi06H82XxyoPbrGMUmh1cN/sjFi+fy?=
 =?us-ascii?Q?mmshQ+WQ6H52s4Gt/fccq34ezpu8kjfl3i/H8JplgtTWjkmadu/gwyGLAgDL?=
 =?us-ascii?Q?IUSHWIWjLbN8yvmtXnMQmnAc2oG0St+381duQU0npnUOOiICYM7KquOnT4uY?=
 =?us-ascii?Q?kq0q/l6HuHvdQp/gnZAg/GaB75zaivwM+IWpKTV1SHPfPHT4aaTLhKR60JGW?=
 =?us-ascii?Q?7WcKVKW0sfTft5uMGhv2X5t0nbrMghN2HUim975c2mpXwoWr/IpY2o8tzv0J?=
 =?us-ascii?Q?RbEquHbsK1l6rI3JhVnJokD49WYZ6WkhNKX6bonvbWJWkxfy9rgbZhfQroKW?=
 =?us-ascii?Q?54nmzyMV0AeymluQXemAnxJLdZ7QYsR1EPA9ufLTlO/ZssuCJnxORq9CYmT9?=
 =?us-ascii?Q?bwFZwu8JHuKZYqS+hkuXTLVVZs1D7+90ccx08w3Mn1v0mCLhgdQALfRC2/xO?=
 =?us-ascii?Q?OYq9lt+YbcYOiEsROlE0/9s27zXgKMxUhMhJ62csAno+jezD7QjbHYrE6E99?=
 =?us-ascii?Q?8PhdiO05wytbLcTgv1dEodNL/ddc4sfxeaxh6nBeQ6jFwWhq68VKN2d3Re59?=
X-MS-Exchange-AntiSpam-MessageData-1: fyabI3S/cGWX5tWsWP3tPirw2lbWKs4oNGg=
X-Exchange-RoutingPolicyChecked:
	zJd1inuJGTR1u9K8pCoyonxqI9S8BRHkG1ygVncbTNXXthW+zBC/00+CO9r4+G9NaICQphYhNoGn/EKeYguCYH+H0ex7LjnYDB0/UpaJibkWDFxoJMoS+0BPK6TUwe0nYjOqUNCG6LUA5fftXCSMwwafgg4AT9hXSuDK8ZU3ziZsvBj//5WCUlPJmPBs1IRUpXQ7D/nIkVn2OP1eF0oiWUDpO1V79r5SiLxpK63PH1w4JJEs5q1fUfO2gWpxSDNeDEuVlaJ3ZrjSXm52dD1F+G3BhrJafGllWBTBYljukjkWimkWn2CoJoSQHzJ3rriLJEGtCedufTHkPjRpZ+GnOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LKHhyIVT0G5KE8SM2VGLpO4w7lhwe4ZKIC+fzVotcy43kipnO9Ihkp8D97x9hAPerE4plHl3NWBcqt1Oa2tWZSij9BJ/DREi3zXPgGJsOa08f9Ihfe8GcU9SUcbzAOjfoQ/9xyXnrCJ0XkZvkALjlGUvtDhjLS3zrX+AvpXDe49AOoUxvUkXe/Q7CX7HvuWUuPZBTjoYJ95nVu3hhj0QCSr9hfBxIB2SaWXgFthHsEbmsNToSWCc/rqTo9GeMTXCKpSFPgVfrLK70wpCdswg0BgMeezbe1FQI4cHX54jR0z5GDtGMl+tRq4hYCx61rrpKZ302YYoYNiXFxpxMwNItk3VQO7yuMW+w2kIhwgKbDvaANCDYHOcOZGP/SSgG2+DbMM4cQkprg/slkhd/9NMjlyWNGQXbZqqTPc0tpABFOuvDzlCt4p8uuCdrEOEy62aDaFoFCcUzhCfLOoQ3ZNCF4yYXAFxZhXpT1m3QZbOVNUiMEsMijVNLrHhFavGVi47zsUNojiNNiUTJwYkX5kOVtVppl8a8FdisKNvV7hlaE4DFDUtv39pEBsny/6VwzhRZwofbp6V1m7OQVFWksqAYTx/7BfRN6A03+C8BnEW8ag=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931c0067-ab7c-415b-96d7-08df290db0aa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:08.6304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHqTZ+jijvAuy4sDgDH+Jp0gIv9p31Zy5W4DbG7uYSQeoXQ5tEzTAof9SUT11JvADsOeLhHYdmSrc1mXgQHwAjeILwOUeSLumnplWp78a38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX1amtT6+CC5Ok
 F6aVz/puf5fWIPyMIt22Pp/W4LJsxxGAO14wSyPVFsNJgqoTZBlheLJUhjnu5thhrmkpW6ODdzZ
 L8N6potzln/yzYiPRUypqad01ltu75ROcEIZjCgt7MGV99ua0Mla
X-Proofpoint-GUID: 5Q7e8NjfAqKcdwSOFzrcyizrmQOT9E2F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXzt/9Qd2VlxxD
 lDsFj6KeRo3e6jtVeR7kZBW0xS/Y3bI1pbuIvHguTUJZCzK8zPX44cpAUA7GSS8VD3w+IOfvrA0
 zDVLeR8EpQkGP6k9CGtNNTXqd0ra4bq2ZClYpho+jOzYJ+uswKgdvveZfWhWaDd31PFIsB+SBVZ
 22xLzR5I0m/0wA8VQDLzQGShUWWzq+cwlOMX1j8ro+TVOc7kx8UeCWFZYrXAZFFXuLEKZs9z1D6
 r7lAaMnlQ3ALDUUrvbN40ZAYAV48RIZkwrcYBM3qEQ93QEXB29V5ET5MPD5rVPBpYVv9Tj/Pr4V
 3VgtxWETas7wG6Jadgrm7nZUxdxyt28jRJaKfXmV0eLoFr93Vt0X7p201K3qwR6X1M7LNFJz2I4
 8VDM2iPjjTUB2LyaW2F2KD2zGctMGlNtn/qBuPiotZKTYM6Wb6tpASNZKeAljQwSmdWL1U6KGQ8
 VcnoIKW+Zw2ob8p7GKp8BoZTggYpK/QMPuy1H4VQ=
X-Proofpoint-ORIG-GUID: 5Q7e8NjfAqKcdwSOFzrcyizrmQOT9E2F
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfc03 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=3OcxSVRvUSqaRT7DloUA:9 a=biEYGPWJfzWAr4FL6Ov7:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (672 tests; gaps)

		Failures before changes:
			Count: 7
			IDs: 363, 365, 633, 645, 696, 697, 753

		Failures after changes:
			Count: 7
			IDs: 363, 365, 633, 645, 696, 697, 753

		No new success or failure after changes.

	XFS:
		Ran: 001 to 789 (311 tests; gaps)

		Failures before changes:
			Count: 1
			IDs: 300

		Failures after changes:
			Count: 1
			IDs: 300

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (5):
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

 fs/xfs/libxfs/xfs_alloc.c  |  46 ++++--
 fs/xfs/libxfs/xfs_ialloc.c |  32 +++-
 fs/xfs/xfs_buf_item.c      | 299 ++++++++++++++++++++++---------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_icache.c        |   8 +
 fs/xfs/xfs_inode.c         |   2 +-
 6 files changed, 256 insertions(+), 134 deletions(-)

-- 
2.53.0

