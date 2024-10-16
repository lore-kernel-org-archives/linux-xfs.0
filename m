Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49114A02;
	Wed, 16 Oct 2024 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037553; cv=fail; b=L3XWFy7O4esElLGf/aIFz6cDEepdP9P+ZiIyXwvHJ4JV0wo3CBxv2UzkBw1eU74GpZXZOUKk9Jr7K9BRJBycg86lnRGMrRAaqFEACW6JZvPE9vOLbcBUkSL5do2b2WL6jPe404dxW4PrYYscV0O+Q1c6MRJRiear/VpzBh9mLS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037553; c=relaxed/simple;
	bh=bMs9POWWT8A4VqPY6+TEBD4nLIZk9Dmbb+DFLgl0R0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LIKkYKycC67L4znQIM2OAsOyYxJX3dE8GTB0MPxFK4EE6mXGrrMrTlS5DQJp6yTXNHbUtktW0BqM/d1b17Pb57YZ88D1yq46IPVRShyR6Qlc3SHj0ohVq415JtmCiHrcJ1J/+DPpnKH2lRABVvgmNwo7avcn8xJAvcr7TIl39nI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VSzkn0Jb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WGUA8ByP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VSzkn0Jb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WGUA8ByP"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHthGk019386;
	Wed, 16 Oct 2024 00:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RiQy61cg4IOXscrXaj2B/dDq1lsiNj08aDRoY+n+3Po=; b=
	VSzkn0JbvoaYW2FCPXrewgF8WPeWjzQOoBoGlGusYbVGUzF0Fk0TMFrpRi/bunuW
	OLSoLwZugZjnjR/BJEB/F7aX32HkPPuM4kZHp3MLMesY1JULKEgTSY0pci9cWhH9
	A69tGc3fIL0MqBO0FP4AmDIXkCyjwnnKtPx6JE7HKkgESaq7/bpLWsKG1CsanthU
	JfEcHb3S7/zVjSCFgxjkTwYEvVkGDmPBQCHhUdPxpnhyL97Ko/PUG9FI8ArS8ITR
	uX7o4hpN37Ig7amapaxnWUusjbQV4NTpfNMIaYmAnTCM8PUT7rtxh2s/9SiDr80x
	TKNYcPWe0MPa/BKBXPZRog==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jhqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLkLwD026369;
	Wed, 16 Oct 2024 00:12:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85aps-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/UepInOFNM+0AV3De3t25HgEGkWvbIChQvlNH4NABy3cdk59z65QxdMSqsxB72N8O7DMdpZjqugZZ5ROBleMd+f4oZIaqQyg3t7F+A3ctCuRRnztYdeC75xkdF+r5zZwojLSVpCkri6GjeHf1JPVK+yyABG2ZsiodyA7dGFB0EDTz4C7D08HgIvtRINhy89SoPbQd0A2qjC5JwZ6kIdPzNZIUd0hqjnUUzC9vAmv3cHUyb7WcakwJNoiFA7yOQ02edZWLKh4/UgRbu/SQR/+qNkq1hNRiYF78YyzG6QCjRLL141rwQ0iJLi7hT37mNT7K7wtcwKm02pL+AtY6veTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiQy61cg4IOXscrXaj2B/dDq1lsiNj08aDRoY+n+3Po=;
 b=Du9MuwTtHNTs1IWfjBbQa8p8Nma/lfTV9oQpyfR66ncV+P+FMyNThbRrcl2wiI0dteoIHGXfQu0H/oiWfNVxFS9uaClGZ3gbFJaaz2FjGbdQOIGToevLG8FCVXCcnEaRVEkvI9e0ClDDMLTqn/SzWb3nY4AJazqjVW1dURaxYYu/HLpCiEflySPUEC4SbCGi+ZeAw8qoSJTrUMBBWzboCGObvJzOpRy7eawpNLA6R+1c+bZ0IdZE3/LaZB044a5MU1ITB+8RFGy+nq0/mGnmozz4HIbeHGjFEdEXfS+UvCMcaW0Uj7vhKZ/Dip0V2V4iZK/MnEhIav6X/fPkGIinaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiQy61cg4IOXscrXaj2B/dDq1lsiNj08aDRoY+n+3Po=;
 b=WGUA8ByP22+G1s+qNJdxtUYikaIOkw0QTWXB+1i+Fa46pHJ/T3HEX6ERMTS4a+5xDkIWtwN8oPbGnWhxUXX0nveY2OtzgLbEE9aGjWlqOk+SQrmNnMj5yv11U/l7lWCOLFm/pS5qEuHDZtgmIlK3KlbohkhTruTXoCQ9LAybeas=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:12:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:12:09 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 21/21] xfs: allow unlinked symlinks and dirs with zero size
Date: Tue, 15 Oct 2024 17:11:26 -0700
Message-Id: <20241016001126.3256-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: e4eefdd7-7f07-4805-fcb7-08dced772d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p48IadxsqXjdroksNRkJIHXLXhydZxHY7m2oxytqs/3eoZXHGFT7nEa+S00M?=
 =?us-ascii?Q?bwaZuSZbIpK6krqDCY7EQY2LQZUYsG/sLDSdlhNApb3sH82WQVrijg7hPVY2?=
 =?us-ascii?Q?rpnxb+Fj6SwcIIflMQ3/PEMZz18uNt05+3RVtf/co4JETJepC3Z3TtExGDaB?=
 =?us-ascii?Q?hrzaifFYubvEk5VIiuLYCqknbCtZ1OopXjIlJ7hcZIWD3P/er9hjQ7c4HlpO?=
 =?us-ascii?Q?jNitXdgXRTfut2FpU9ZOu1kg4NNb4DB8SXNqLvEYVBLpaZiqr2Rxf2/9FeWI?=
 =?us-ascii?Q?YQ3OEx7dzgUyJG2x1YGldLmKVsCY7JrjgCC8wqj1l6MNuHxOK5alC5ph5MqZ?=
 =?us-ascii?Q?vYMKM/Yz3C1DgC4tO8/fchLOJPAJPQL/kagzMpepfcnJ9m6ChfwNBOz96ysB?=
 =?us-ascii?Q?6bwpM/DGOrbx6T4mIfSfqzH4TnQSrH3d0ngeTFx37mYt1wlD7pooIt4kiOpk?=
 =?us-ascii?Q?Cxza6OAsjo5dcpTbcAjP+9fv5CI7/65VKoM4PzM8vNTj2JLEA1rqNwGsjLmp?=
 =?us-ascii?Q?8VeoOvS5d8N8Ap/HqZloSXn6h5nF5enSJeKcLKgKBgNWHbF+pHkTKRica1r2?=
 =?us-ascii?Q?d/dh6h20LPatvRX1/kw+KvuPEOTvHgpt3nYzEsoCLIonwUlv/fQq7RMKlvu8?=
 =?us-ascii?Q?x/AilJhy4+lPbjXF0eUeesxE1x/mQfTpKAPj0hkLuqUbyxz2j/Ygsur+yvwu?=
 =?us-ascii?Q?jEy7wmh1IAHBb85e37b/yt3ITOwEUsGd2tFl8JTJz8RMJpGCnDZBW94cQnOF?=
 =?us-ascii?Q?ObWVQcqmSqVLgVV+MPQt/80kIN1e5JIYrl/ZjgbggNL5fepTuZBOzcN2PKfw?=
 =?us-ascii?Q?FOZU++EMBYFtuHlUd7utlNkG9yemfoUHyC5zwBTOvYewJ8Y4QfIwi3W1Q99f?=
 =?us-ascii?Q?zkw6ThK6VSrwUKvti7HnLQXQyaeXQePp2hZjRfwjup8OeF1r3h0pO8wEeXYu?=
 =?us-ascii?Q?2u1abMLk4ncO0tgMD+x2KuJr+EJXezacgT/XfA8alFyr9SIDgmZ5hgaN3HeP?=
 =?us-ascii?Q?+7H0XHAM6/Gwr/1qtC5AWIPtUwuJI9WkgZd4WYyazNRp3KWFffB5PpswSp+x?=
 =?us-ascii?Q?G/dUlIqOa9wBWjKFGl+jYp6UxyCzHMkQls0m8W8s2+MA+Z5C5ahohScnflMo?=
 =?us-ascii?Q?cVVuBNZN/PtrTytaLkJS2TMAXceY++G/06uDYu+wLSLv5FHcRxM2zgQ0FDyd?=
 =?us-ascii?Q?RTP821fBB9+AZQWrGnIfs71h+wzCwGaQ4znIB3agNq511JNeg1h3WFqC6R0/?=
 =?us-ascii?Q?USc8ZGE+PlBcB8vD93rYojAJ07LSK2zjhcBh1/n6+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oOtPnDkaNMGPBJyd0e7chrBbavlXDjBw//Wh3wBWInB7vwANQSzqujobg9ng?=
 =?us-ascii?Q?y2fTWk1OzzgBl2tayT6bEycBtZEY5jj207UFxUVgsYU4PB6tpWDApH3Ye3tZ?=
 =?us-ascii?Q?WqnlqjnKPeIGyEi+X1GUK2I269PmHfdaqigOwxlX1/AGpRYS4fi6XtjyiJBZ?=
 =?us-ascii?Q?GK37fJ1bZnCc9ZqS4u6/tmFCCAJdVBIChW9EJt7ejADbm9L9DdNIR+W+W7S5?=
 =?us-ascii?Q?Ip2oi0roJJRtzpVSJ3/KBY/mYByqhhPDPpv7REYWXH35ceLwbMzZrIxwtNuR?=
 =?us-ascii?Q?tjNulBST7WmfVVlaYhrVdM2vQOiej/VLAlljpdT46RWttZRht+LYwd4aku0M?=
 =?us-ascii?Q?BpeM3UeEuhDCe0OC7pRwV0yX5v1P1zRtcjg/ybzMyHfqTsSu5hJbbnFyeqn7?=
 =?us-ascii?Q?OLNMLsKzz0d59fTCdEpmdZ4irlKSExGxxe2+Phr81alF9L9l2PA4OvosXBsQ?=
 =?us-ascii?Q?dd5PHBOfTTozdzRvUsO8LWUMKxc8aXcfZyY3IwXCYqV3S1PviwBhLdASO1us?=
 =?us-ascii?Q?VOIl4Oa7jLr7KW8ijx4z+DfRm5xs5bRj3WyWPTSc+QzwgnPRqMASOSsD/Amk?=
 =?us-ascii?Q?lj+Arhor7pXI+gkomGEunnJBGnzXDCOwnBKiokHHPYaLyGkh3UfqgXScK6fz?=
 =?us-ascii?Q?MIHfvCHScliS64epkZPJXMG2FlXyrWYuI91zMlcAbEHdFhRbxZuBrXdSfKpv?=
 =?us-ascii?Q?RCq/f4MdmYRgUeYC8wit+FQRCx9OjADihxGmwgOy9ofVo9W06O6MQVNN+jCh?=
 =?us-ascii?Q?pj/qDqCKgq8driAhhi8dGdXVDIKxjcJViAE+v4EM1HyiiPI/pr5sIjUlixuf?=
 =?us-ascii?Q?xGLODR17wIgwIwIEYQLvYbheHFu2c62GA5mJ0oG8bD0xNhSu5Gb7Q5XjwBrr?=
 =?us-ascii?Q?hp8PIg5se71g9BEDqbquDQCq/79rJmLHZaJQJx1O69Aw/u1pRDHRdwLt4Jvm?=
 =?us-ascii?Q?rQvnf8hi29Nb8j/vf1p+zw3HAoIqwMqaisYonrYC8SGYrYftebzv//CLylj9?=
 =?us-ascii?Q?Wc4uh4EV/0mz25pJpco/CbVneNKfbAjZze1rTTj9Gn9IGFzsyvnDv6ZkTzid?=
 =?us-ascii?Q?1p+QhIi2lvK2B4s0UKktLoe+lwFBWZ6a+OT1yjssI5Hjpwmvs2iTEy58hg29?=
 =?us-ascii?Q?Xcdhw4C6F0psmwzuNsNiyilj7p/DOYB7BWJ+3K1Cw1StZ3lLayq3MpZ8JOgJ?=
 =?us-ascii?Q?6988YDfCxqirJJ7hYRb8PwvsqoyO3WAjXNQvMbCHGSaKqYZ6+e10frr1GNYA?=
 =?us-ascii?Q?CVwTYNfEVo6VU2ZAKUtkFs9fuSdYEwYaHPUHHDO8Q1chfQM9u9UdMFrfg04v?=
 =?us-ascii?Q?lsfAk5UVdJh6HMyW47UMl+J5oz0ohUwLJATGnvrYYePKAgFe7VprNDOQOjk8?=
 =?us-ascii?Q?Adn/Fe9pT9vcEoh0BunhH/FVbqEHnA6/ZxhjSnQlADNj/vc0DUfUHmJQF7Qn?=
 =?us-ascii?Q?UFcpiXWejqMWfADTfT0ftdRGFCek6XXhglDzJLZfbhCdlpgqGAzZ2bj5W2jw?=
 =?us-ascii?Q?8CCW0d2R184IZoBE4K80X83XbLJ3h+iLr++bhQSYaAQuxo4kwCc7p92LdTkZ?=
 =?us-ascii?Q?lksm4yEkh8D+siw5WemR6PeO/vlhrPDuB+t1uaDI5YnYU1uhU1vsVbZxVbeN?=
 =?us-ascii?Q?czI950o3texIDNnvbNPLfCM56vF02eUHloKstRJVB6+V+GJvGt9k2lsCGvXa?=
 =?us-ascii?Q?ReyVeA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	htxsM+BidPe6HKaQgDAPU10uh/cTPqHRxu9pZHpoK09X1lTF17BSbXRt4dydO8odbOgwZObrLWWT+2qeDdUGftMcXQGvoI74FUrD5LrSoFZ6Hkp1wjEHt6LeOH6lzrJm10cIg4Qdvq1tRPk5Ir8OAoQRZTRLIx2U4u+hmf1EDVID1ETCjoLehcfdoa0TlFh2vOVE0l7HOQEquwJL5gxEmEzZRZQC50v0A3c8P7L1mNyxLOLSgmHUaVM6+fqO1sLGncDTpXL6i5WNdCtiK0jF9ktRCDXSdBWadvNMuIPt90skjAMk8RA7kUi7WSPSxRSGR9vk2FnVsyk4z8EUhy+/GzAkyAibISHkEDDz+80nh/4ZLRuR3REPs8zEL9F2q6IbTb/aJgVnQPbAzfDMBcKW3NVwzahiewk8ZYo7/OZKSybupfxSiYytJOY/BaEjTUBdks+fL5l+2g3DQ3DzE3g6ldsoG7mNopX8726iZBw6J+wODr5O/EywuSSO/XI4saixkp1KiyNu9/jxSSk8nnnS3flTJwwdAGnl3RsESqtjMll+sRyVFegYJDQ3QqJ8j7SKVxFQCfEjbPGxr6K19i5OpY3vK5xKMphb+C61n2sv8W4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4eefdd7-7f07-4805-fcb7-08dced772d0b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:12:09.3966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsFBhvKmeJ2PpRFe8eXROVkwUHMWfbHaA4yoU9dmKils/4VbNmR0bz7an/LVkiPErfcrN0aDovXRpg6y0O22AtAa5EQLkU+9ElEUrzpLmXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160000
X-Proofpoint-ORIG-GUID: 0EUpfKVqUjQFsM_qZuIRn-E6fQe8KvqK
X-Proofpoint-GUID: 0EUpfKVqUjQFsM_qZuIRn-E6fQe8KvqK

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1ec9307fc066dd8a140d5430f8a7576aa9d78cd3 upstream.

For a very very long time, inode inactivation has set the inode size to
zero before unmapping the extents associated with the data fork.
Unfortunately, commit 3c6f46eacd876 changed the inode verifier to
prohibit zero-length symlinks and directories.  If an inode happens to
get logged in this state and the system crashes before freeing the
inode, log recovery will also fail on the broken inode.

Therefore, allow zero-size symlinks and directories as long as the link
count is zero; nobody will be able to open these files by handle so
there isn't any risk of data exposure.

Fixes: 3c6f46eacd876 ("xfs: sanity check directory inode di_size")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 51fdd29c4ddc..423d39b6b917 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -371,10 +371,13 @@ xfs_dinode_verify_fork(
 		/*
 		 * A directory small enough to fit in the inode must be stored
 		 * in local format.  The directory sf <-> extents conversion
-		 * code updates the directory size accordingly.
+		 * code updates the directory size accordingly.  Directories
+		 * being truncated have zero size and are not subject to this
+		 * check.
 		 */
 		if (S_ISDIR(mode)) {
-			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			if (dip->di_size &&
+			    be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
@@ -512,9 +515,19 @@ xfs_dinode_verify(
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
 		return __this_address;
 
-	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
-		return __this_address;
+	/*
+	 * No zero-length symlinks/dirs unless they're unlinked and hence being
+	 * inactivated.
+	 */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
+		if (dip->di_version > 1) {
+			if (dip->di_nlink)
+				return __this_address;
+		} else {
+			if (dip->di_onlink)
+				return __this_address;
+		}
+	}
 
 	fa = xfs_dinode_verify_nrext64(mp, dip);
 	if (fa)
-- 
2.39.3

