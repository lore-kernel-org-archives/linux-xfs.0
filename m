Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156E158524;
	Wed, 18 Dec 2024 19:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549459; cv=fail; b=cuf5nhlL0TA3hSqTBBPwNbpmBlVw/p06Y5E029CJUWeofG9R05ZnVb9aBb2M43d9meHHpHjPzLYDAStMQlXIouIGGcnq03lGaaJ4LTYEceN10SETjwNLLZSvoSWCJ8/egc78s6Wk6XQYdw1YN72fsrex3YUtwty4IXdP9USPp8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549459; c=relaxed/simple;
	bh=bpLUzP/Yun2w1ARujcKzU1SmDJiQfjH2GrN8iT+kTF4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sxOnOE81qG2lLSnXHP6y4HNODTrcBS3JfRJNwJB7AiBbLL0LSUgZlzSXOskfHD28Z/Vlv4pmZ4gvwGtVzexpFdjTHCGjO55o24ZXnra3nZfnrGma8Z6Wv8nU3CL/YZ+AFMcdPYMEhGOrimtCKdYRuBdzc7Kn0CKq5IDQ3nzIEsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SK4umoBr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i08FsZnZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SK4umoBr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i08FsZnZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQeLa005634;
	Wed, 18 Dec 2024 19:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OCIDXfKUkdKdja0w6WSKUv3xUnJSw2u1VeVFEDGDJPk=; b=
	SK4umoBrmP6hhpr/fMyClCwFXpmURS+0qYUyk4c89nXzqvJE30Kc8qAgPB6h2sa7
	gGa3hBhGQFgTOGpGIK3KDqc4BVNWn9o6VFyBZCWfpD3bi8cjaI1N1aB5H8kQC+JB
	rY/32pQzeWVcmO/KnmFbXHY9INKA7f/y+XxiX9sjDEpCxanmU1jN3QQVnaPms6sS
	5fH5FH2m18hrRVRwd/FGMxVztq8CN2aDsYo5PUSfWHvdigs/RkgBLj8vZqHbp8bq
	u0K+5IEbevDRQu0kB0LNTnJv8hUZosxpF1QuILT5Kb1UvR4Xv1y0oDeZleqQOz7K
	nZ6TOX7rDMdmY26ym5uWlQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec9bu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIIBlkp035464;
	Wed, 18 Dec 2024 19:17:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa8g1f-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gb4QZaandHeuX4bIhPUJo+qGFKAL8M73ydV5pXLivIhlLJmsU+v/tgqrV1KNeYfMGFB9GeXjjxVFLgLLCbnfbBAKRKFcFfQ09/kMQmKnqW5IP4eG01qrsezUuQK0Q46SmPalM5kGeZw+23Qh0jWPc3cqtWgpEFCOsKPhf9AIpLHgJeYlpE5/S2cnvF9lNXjLhvFSDVqz4YNpAIqQ9pbl8XtfXX57Qg25vYTPbwAfikN3NxVRYKjMI+b8JC9BLNnx1r+GpdAA4TUHOCFqnH9I5VHMFPwiK3WsBcfh90m3YCxGax3NW99sWYx94ZxbtojwgoS/hU/fQ/IEj/BgZX4z+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCIDXfKUkdKdja0w6WSKUv3xUnJSw2u1VeVFEDGDJPk=;
 b=pO2wP6dq5jP9FijvJVnIK7AzZlr4UCfgE5a5sC4J5QZ/M0cgmorw3imLGkrc9/mSfGydnfmaka3B6vtrZFpk0YDtHdHsNXsocqemcsuular61Q6xuEkJtBKocM0OAp3A0OnfWwh+JiAaYm8AedcL0tOQNy5GFIZvSCRnYVGrlSx0idR/sTiMgYFBnEuxf8waEi6jRUWukGRkaRk3smfEKpXhPR/xhPsSDhQA5cSj+1CRGTIZw/1frpnFbvRIcaeSC9Tpw5iD8lQquVRAeM+zD+gkhiXHsXJjyYh6lJhT5aJ7FAJIPq6zEzwQYlfPyFxLej6d4m6eemwC6cxB6CEkqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCIDXfKUkdKdja0w6WSKUv3xUnJSw2u1VeVFEDGDJPk=;
 b=i08FsZnZU3VvoDGoFZc0RFlrbwnJF1EazWded+qwlGpabr7Ga/ad9bE1hTc5B+8KqZnQmRh0p4N9hydElaOZV0Pq+qu/ogqm8Fcqi1EE9Swfl+cDGqrz4PrwpkVqEJ45W5mK67ARruDy43HyVF7vRJxHs5lXT60HBeZDm653LDY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 19:17:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:30 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 02/17] xfs: verify buffer, inode, and dquot items every tx commit
Date: Wed, 18 Dec 2024 11:17:10 -0800
Message-Id: <20241218191725.63098-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::9) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO1PR10MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: a206ed0a-cd50-42b5-bd4d-08dd1f989e41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J44QYUYHcmW9c3+gg3qpCjeKjVfqPFvhIHMNJ7YabrW0LXU9lBYXMsN15WAr?=
 =?us-ascii?Q?yqI0CdlGXSeAprsuDrhBjv0k+m4EV5KHY7gewaY3FisPrkrXpxdq7TxiTdJ4?=
 =?us-ascii?Q?3wrPfqYZGUP6kuVsVXhhpb+51CzGdsV2oOZFHIr+EEQYEaqBMr5ZpspmqBxX?=
 =?us-ascii?Q?JEW3uhsOUqsl6lORKN2O/8sUVv+o90+qUOisCGccZWTXjLRlLwIKAW8ziZuT?=
 =?us-ascii?Q?5mboE8hrYP3XCq+IwWnav91WkiHTng2t5ld/6xVIBH/zQXkppIxUPcAetJTP?=
 =?us-ascii?Q?B+L3NWCAvJK3uHyiSfVeqZBDZvqwk2D8gaOPgxbBZaiBHnHy27C95fLA2xN7?=
 =?us-ascii?Q?g6oEN1ILTJB5OMTeK+DNuXQWuYaRVqeYRYz+/jhcQNteISZp/HWeq0YZNi90?=
 =?us-ascii?Q?J8mrGw9YwfjYyBQCGFI4mcEVkiTDkdl9rjHNF6y4cDr/2ZDpZhReRF2OS1TZ?=
 =?us-ascii?Q?+xN1/HxY8PomfINTEJYyDq5ENLxEo2HXGT3fQttHrqWmORVxd+1X2ZeHNYZn?=
 =?us-ascii?Q?jgG/XL1zao4gjI/7ozA8LI3LQiEJzkEd14W4SWrsGlMReXa1RUPNeoLPRXdm?=
 =?us-ascii?Q?RVpPFPURv4QdhQPCu1+RV7qh9EWdQYkuv75I1ovevVAOG9IPsHReyQKwwHfi?=
 =?us-ascii?Q?odNlNBd9tIn7E/tEBgMyyvg0FUotoq96tDgNz7U3L2lzrNUN+wnpbf0T7RtB?=
 =?us-ascii?Q?i0uboeK5v6bwqXwXPvZ5fEOah8RTQjSS2neEesf7CZ4Rmm7Av7jdXC8rWK/K?=
 =?us-ascii?Q?RAPS/iB3uamUW+Ept8W9wzYyxR/nRbD6Tcm+qkELhXMbPGsStbZhOS/Stdjo?=
 =?us-ascii?Q?txLyO85vtv+G380GlzU4dswCPFhKkqczRM02BBE4ztb8e96kMQaKpHU+ViXU?=
 =?us-ascii?Q?i5sQ0Yn++cMQIvnsKgOtugBaBnrkeKQtVBxC8MMcTiJHCeJ06nBxDGEvL7qy?=
 =?us-ascii?Q?V6HX+/Nuhlk0VvJEkzYOsU2in0UetTcmam+gb9GscrHTChjRSzC76FHtlWIu?=
 =?us-ascii?Q?WMxy3KZNXjz/QfmJ/RgGOEzndBwUSZebzizos4GNZl2CTxLbxKe3K7gUa/pE?=
 =?us-ascii?Q?5jwHPT+mhIHOWbRYaTUii81GZA8q+lY9rRICi7aiQtW1B9aVVhGBGVfH06tK?=
 =?us-ascii?Q?i8l6UCBTfyQdnnvwYaeYL2MdmNrYXQpUTjlsHA5Fj5PoZvGD9Ds/6LT6glAo?=
 =?us-ascii?Q?uvEMUEg3ZnQawtjXmWlcooRrqJRXKDIeOmvyiyy25jU3oIK6llccrLNuKgNF?=
 =?us-ascii?Q?nhKsy0uElhLAPtaP1yhy2PwItaMvukE6dvKIqpft9eblMxNSf3HWb5mqxOGb?=
 =?us-ascii?Q?f2bw9R/lSlIM9Qi5jHnlAF6I5g9FJ5ZCn8DUWjEq+xcum2HG1rpNx49jLdrP?=
 =?us-ascii?Q?XBhAhiaGUQpkaiMmBUWbsBCWRe8d?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SuJVFTTYMeE5BY1a0T1iCP96YVAGT8qA7AjDrym1jRRQ2vn8O4tD3rusTqh8?=
 =?us-ascii?Q?1zrI1MkZSJTkRNKr12yMOaYr6ltEhMvdcPrbE92lgzBRXoeMQugPPcZ/mqQE?=
 =?us-ascii?Q?VZED6siyrXICIXFymzgihzC/B4uJMUFtx3Wdjj1Xw9Ke4J0mDxmF9wyZuch4?=
 =?us-ascii?Q?JA/cfrAPArTKd5g98HfNZ8UCGnRCOmEpE7XOpjF/afq81zp5ecPrcvagoYvg?=
 =?us-ascii?Q?jaGiY8pdCu+H3u70+k19+wlaWoIFIaHp+b9XAVDC/JyVGp0BNTByJT7RfS3o?=
 =?us-ascii?Q?CZg/H7+K3SYFQnZzYIJLcysbPzLUeRr8tJ/o/+bfjWIX+lFHw/LR0/Bj0rk+?=
 =?us-ascii?Q?aphVpOQbRBlTbCfym4khPyR/H0Jzze7z/x3lZVhkCiqRDA8Er1VPw5WcFJMJ?=
 =?us-ascii?Q?b/8J1G9mL7UVlEoAYHkHsBWdG9FFNLnV7aUvOvspqUeiv7uJ22QpFQ93XQKt?=
 =?us-ascii?Q?0WSvERx0FkOTlydn8A5TAEmYlZdr2E3coZgmw6Taz0uvtmf/mmoOvYtMp0cj?=
 =?us-ascii?Q?Gyk5RzxeJkThARu/3ZEFoLyL8LgUQ9r4wU1v2/2aU8TZS/ZcqA8FzV9vMNy5?=
 =?us-ascii?Q?VKWSvxB6a09gmahEO7l5sg+n2NGt8EzMJ8auExLb3+YzVmnN6/Xo4X4IXzEo?=
 =?us-ascii?Q?q/15qSTWmdokw7d9h32QGSJcQhgZGAw7PN+bleYHXwnnBAYWXLsJGtkdMaVE?=
 =?us-ascii?Q?WHyB4v14iag9LQhv9xt6xRfCAu8EDlmtyk6ZnoEIBtNodNdnPEv2y75eF/O7?=
 =?us-ascii?Q?4WCMcQAQQa18yVQFfxXuytpLM3LSpDcSXd8a+POf69Vmv8r4WasO3c4um+eu?=
 =?us-ascii?Q?xU9RSFMqtrq07znSc79EAhaUVR46XQMTZN/4odZuP7U3gFFqaXyWYNMpwYnt?=
 =?us-ascii?Q?XKITueAEVpGvnItguTbq8vvJRFldwxTTAoCZZg3kRsXPlc3ed0WaDDfAhUQF?=
 =?us-ascii?Q?fZ/F6w7CCFkRlquuF79PrVAGD5tuYU9ys9aZUf9AvQdu7pNOfYdpn2ZmGpZN?=
 =?us-ascii?Q?8GTSCphaNxKard8NHRuzZKyJntZAzy8CVLgUO/7joGYvyuNXeyRuOWGHCxqL?=
 =?us-ascii?Q?F07xAiz4SMqWwDK9qmZpWTsJ4EvIXLAtYMlCoVJC/0pnGtIavVVQ+EzNPdXk?=
 =?us-ascii?Q?u8zubous6PscOKlIM7B167SHawNYCD+l2brly/ft5mjdXsXYbcmMmeHEQG4L?=
 =?us-ascii?Q?g5xVx2vZmlukbp1saAeuKc+0SuDYteQsSIHKMekebF1Ox0915edh08WolKMh?=
 =?us-ascii?Q?A3zhIH5xIpWfxN9bq3b9JiSk5jruiY8D4fMtD3id2xATXpcd1wZ6nOF7VKi8?=
 =?us-ascii?Q?LJf+H3BusnEU+rVomhm6+sDLqYKv3NUMRCCcUBIbF/kgOo516Jr9XXbEra+3?=
 =?us-ascii?Q?TR/QjjoyYnaOg8iutrOetGE/V7VVVUA9rVH5rMCHxtGq+0tRPFA3icIK1dhB?=
 =?us-ascii?Q?qZa5RNbN8gMKZcPMgge3FvGA4YDys/ZMEtU8BE7/hOQjrlCo7thUGcz9ueAl?=
 =?us-ascii?Q?Jgf7tNP+M196aVChVH0mmGvwIe/SFZqRxTyVgD8h72uDC0HMwRx/uG/rNwvU?=
 =?us-ascii?Q?niBlbmm+URRmbBa/n1La77H1t94Cv+b8D/CHwF5GkJX5HDQOqYfvnsGMWYOE?=
 =?us-ascii?Q?LPPEEkJPHtnhlR8DFKG+Eiw/+RyMfd90rykHuK9JMh+VLNoj1HMFo5P4V72q?=
 =?us-ascii?Q?rbpSYA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+6tEjfQaxtHv06SIP1z+B6BBVeGRtsuCndTfLvjA5RmZCpxsu4XyoX8JOu9XHkVxYMPRO7LByjzJohCEp7jSa/EkwqmgwXbA+s0pYbq9JwddCzfLjlozh3vSLsUiqHOyemjgUXNe2CHg70N5g7QKcOHdiZYoM+M94kHnI5j87J8obhULmx1vi5NqqMt6bZpiRLd/JmTPqfmjsP6yeVzxnvpbj8MSF64bN0s1gUuQCunAiqYpes8j+/BB3saUdzl+1cI8+L64LJRfSlKcaf2djbvafK8prAhnaHC6J5KKD4u76LoQRDkZublEBmU3R2MZEMymgoiGDOQBjyw+GLeqLfgHKr0jqiOjcE+K/RqLyr+28yhp1/wSFbjjiyte+09IiyE6UGRzzNHHhV+GFjJoAAeKdcYMYCfe/M/1uaJ/UNgZIgq/IMoh5Jjx2ZpxJ596ZBQ4RqLm6uFVsfxepIOEozDIcifJ+S3L94TA8lptUKLOrX4b516Ux82Ar3mj0SwnHex+MteiJbocLZ6FjqmjwPdIwVCw0c2boBBzW00w7knqn1JqyVJbGzE6gOrWmovqANuDUnlofEw/uarAdOk87JCx3IlpYn6TGXrzQ0xKNMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a206ed0a-cd50-42b5-bd4d-08dd1f989e41
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:30.8585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vni38/BH9wvw1oZmC6PdXebWe+Exhgdzmk3w7VkUyRJAt1/qEmjB3MUquvtg9kZldClCcKOar05hVpul8FngpHj+K8fqLwC+paZwXWhvYFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: PZ24DuhiXUecq4RKi2MnoCiJAQzV2_1_
X-Proofpoint-ORIG-GUID: PZ24DuhiXUecq4RKi2MnoCiJAQzV2_1_

From: "Darrick J. Wong" <djwong@kernel.org>

commit 150bb10a28b9c8709ae227fc898d9cf6136faa1e upstream.

generic/388 has an annoying tendency to fail like this during log
recovery:

XFS (sda4): Unmounting Filesystem 435fe39b-82b6-46ef-be56-819499585130
XFS (sda4): Mounting V5 Filesystem 435fe39b-82b6-46ef-be56-819499585130
XFS (sda4): Starting recovery (logdev: internal)
00000000: 49 4e 81 b6 03 02 00 00 00 00 00 07 00 00 00 07  IN..............
00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 10  ................
00000020: 35 9a 8b c1 3e 6e 81 00 35 9a 8b c1 3f dc b7 00  5...>n..5...?...
00000030: 35 9a 8b c1 3f dc b7 00 00 00 00 00 00 3c 86 4f  5...?........<.O
00000040: 00 00 00 00 00 00 02 f3 00 00 00 00 00 00 00 00  ................
00000050: 00 00 1f 01 00 00 00 00 00 00 00 02 b2 74 c9 0b  .............t..
00000060: ff ff ff ff d7 45 73 10 00 00 00 00 00 00 00 2d  .....Es........-
00000070: 00 00 07 92 00 01 fe 30 00 00 00 00 00 00 00 1a  .......0........
00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000090: 35 9a 8b c1 3b 55 0c 00 00 00 00 00 04 27 b2 d1  5...;U.......'..
000000a0: 43 5f e3 9b 82 b6 46 ef be 56 81 94 99 58 51 30  C_....F..V...XQ0
XFS (sda4): Internal error Bad dinode after recovery at line 539 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x4e/0xc0 [xfs]
CPU: 0 PID: 2189311 Comm: mount Not tainted 6.9.0-rc4-djwx #rc4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x4f/0x60
 xfs_corruption_error+0x90/0xa0
 xlog_recover_inode_commit_pass2+0x5f1/0xb00
 xlog_recover_items_pass2+0x4e/0xc0
 xlog_recover_commit_trans+0x2db/0x350
 xlog_recovery_process_trans+0xab/0xe0
 xlog_recover_process_data+0xa7/0x130
 xlog_do_recovery_pass+0x398/0x840
 xlog_do_log_recovery+0x62/0xc0
 xlog_do_recover+0x34/0x1d0
 xlog_recover+0xe9/0x1a0
 xfs_log_mount+0xff/0x260
 xfs_mountfs+0x5d9/0xb60
 xfs_fs_fill_super+0x76b/0xa30
 get_tree_bdev+0x124/0x1d0
 vfs_get_tree+0x17/0xa0
 path_mount+0x72b/0xa90
 __x64_sys_mount+0x112/0x150
 do_syscall_64+0x49/0x100
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>
XFS (sda4): Corruption detected. Unmount and run xfs_repair
XFS (sda4): Metadata corruption detected at xfs_dinode_verify.part.0+0x739/0x920 [xfs], inode 0x427b2d1
XFS (sda4): Filesystem has been shut down due to log error (0x2).
XFS (sda4): Please unmount the filesystem and rectify the problem(s).
XFS (sda4): log mount/recovery failed: error -117
XFS (sda4): log mount failed

This inode log item recovery failing the dinode verifier after
replaying the contents of the inode log item into the ondisk inode.
Looking back into what the kernel was doing at the time of the fs
shutdown, a thread was in the middle of running a series of
transactions, each of which committed changes to the inode.

At some point in the middle of that chain, an invalid (at least
according to the verifier) change was committed.  Had the filesystem not
shut down in the middle of the chain, a subsequent transaction would
have corrected the invalid state and nobody would have noticed.  But
that's not what happened here.  Instead, the invalid inode state was
committed to the ondisk log, so log recovery tripped over it.

The actual defect here was an overzealous inode verifier, which was
fixed in a separate patch.  This patch adds some transaction precommit
functions for CONFIG_XFS_DEBUG=y mode so that we can detect these kinds
of transient errors at transaction commit time, where it's much easier
to find the root cause.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig          | 12 ++++++++++++
 fs/xfs/xfs.h            |  4 ++++
 fs/xfs/xfs_buf_item.c   | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot_item.c | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_item.c | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 111 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 567fb37274d3..ced0e6272aef 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -204,6 +204,18 @@ config XFS_DEBUG
 
 	  Say N unless you are an XFS developer, or you play one on TV.
 
+config XFS_DEBUG_EXPENSIVE
+	bool "XFS expensive debugging checks"
+	depends on XFS_FS && XFS_DEBUG
+	help
+	  Say Y here to get an XFS build with expensive debugging checks
+	  enabled.  These checks may affect performance significantly.
+
+	  Note that the resulting code will be HUGER and SLOWER, and probably
+	  not useful unless you are debugging a particular problem.
+
+	  Say N unless you are an XFS developer, or you play one on TV.
+
 config XFS_ASSERT_FATAL
 	bool "XFS fatal asserts"
 	default y
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index f6ffb4f248f7..9355ccad9503 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -10,6 +10,10 @@
 #define DEBUG 1
 #endif
 
+#ifdef CONFIG_XFS_DEBUG_EXPENSIVE
+#define DEBUG_EXPENSIVE 1
+#endif
+
 #ifdef CONFIG_XFS_ASSERT_FATAL
 #define XFS_ASSERT_FATAL 1
 #endif
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 023d4e0385dd..b02ce568de0c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_error.h"
 
 
 struct kmem_cache	*xfs_buf_item_cache;
@@ -781,8 +782,39 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
+#ifdef DEBUG_EXPENSIVE
+static int
+xfs_buf_item_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_mount	*mp = bp->b_mount;
+	xfs_failaddr_t		fa;
+
+	if (!bp->b_ops || !bp->b_ops->verify_struct)
+		return 0;
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return 0;
+
+	fa = bp->b_ops->verify_struct(bp);
+	if (fa) {
+		xfs_buf_verifier_error(bp, -EFSCORRUPTED, bp->b_ops->name,
+				bp->b_addr, BBTOB(bp->b_length), fa);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+
+	return 0;
+}
+#else
+# define xfs_buf_item_precommit	NULL
+#endif
+
 static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= xfs_buf_item_size,
+	.iop_precommit	= xfs_buf_item_precommit,
 	.iop_format	= xfs_buf_item_format,
 	.iop_pin	= xfs_buf_item_pin,
 	.iop_unpin	= xfs_buf_item_unpin,
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 6a1aae799cf1..7d19091215b0 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
@@ -193,8 +194,38 @@ xfs_qm_dquot_logitem_committing(
 	return xfs_qm_dquot_logitem_release(lip);
 }
 
+#ifdef DEBUG_EXPENSIVE
+static int
+xfs_qm_dquot_logitem_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_disk_dquot	ddq = { };
+	xfs_failaddr_t		fa;
+
+	xfs_dquot_to_disk(&ddq, dqp);
+	fa = xfs_dquot_verify(mp, &ddq, dqp->q_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot during logging",
+				XFS_ERRLEVEL_LOW, mp, &ddq, sizeof(ddq));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dqp->q_id);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+
+	return 0;
+}
+#else
+# define xfs_qm_dquot_logitem_precommit	NULL
+#endif
+
 static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
+	.iop_precommit	= xfs_qm_dquot_logitem_precommit,
 	.iop_format	= xfs_qm_dquot_logitem_format,
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
 	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 155a8b312875..b55ad3b7b113 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -36,6 +36,36 @@ xfs_inode_item_sort(
 	return INODE_ITEM(lip)->ili_inode->i_ino;
 }
 
+#ifdef DEBUG_EXPENSIVE
+static void
+xfs_inode_item_precommit_check(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dinode	*dip;
+	xfs_failaddr_t		fa;
+
+	dip = kzalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | GFP_NOFS);
+	if (!dip) {
+		ASSERT(dip != NULL);
+		return;
+	}
+
+	xfs_inode_to_disk(ip, dip, 0);
+	xfs_dinode_calc_crc(mp, dip);
+	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
+	if (fa) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), fa);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+	kfree(dip);
+}
+#else
+# define xfs_inode_item_precommit_check(ip)	((void)0)
+#endif
+
 /*
  * Prior to finally logging the inode, we have to ensure that all the
  * per-modification inode state changes are applied. This includes VFS inode
@@ -168,6 +198,8 @@ xfs_inode_item_precommit(
 	iip->ili_fields |= (flags | iip->ili_last_fields);
 	spin_unlock(&iip->ili_lock);
 
+	xfs_inode_item_precommit_check(ip);
+
 	/*
 	 * We are done with the log item transaction dirty state, so clear it so
 	 * that it doesn't pollute future transactions.
-- 
2.39.3

