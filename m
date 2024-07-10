Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121E412DDBF
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2024 10:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720607499; cv=fail; b=oRhrmcYUClHfHwRU5fdS50JIlc1b5fdYMW/8WtACN1lXvFNBgAfyUNS5Tv6nAE0YMJ6iLTDvI62p+qG1rk0tuftbQEB+QMee50wACsGMq0C+isFaNjJt6PCDwV7UVnkjwddHVvXJHFuEIQuNysdXGyUb77aQWHKm9SxvakejJBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720607499; c=relaxed/simple;
	bh=bT2+WoN7SYInAKY9pEdEueIvoi/O78PlQ+MsiYb8Zys=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=jWP8JNQQ1yIgsid4+LGJNEtO9/Us8yfJqRES/3AEnYh4gDUAt0rWVpwtLI+TKiEXjiZqpJnAQHHpj0VzH10HPO1jHV+Vwzs8Fw+IBaguhaIMBHfg4UXGO9q5SewzsypQ8pWgyPUYAJ7cJPHMWeg4d6qvQC3Lc59rWzyBWmriI44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VspZoyOr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y078c9Ug; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VspZoyOr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y078c9Ug"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A7fWqE012133;
	Wed, 10 Jul 2024 10:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=ytnLMXmfQmV0DD
	p7aW1NUJHzzRzEq1uqN6YdDYOO4/g=; b=VspZoyOr/KvOh7y1p9RGO8eiyrWrDd
	221dkyRaSHGTJjM1/JxrWvUbP0DFz/phpoxXmIjt+//eU3am5sFYzi4E3HZ+zHxs
	4DNQy+ZUQr7hKYpbyI3MDQx0vtt29T4b3S0E3gTfToS5Ifk4++L11P8Yf+ink+pp
	e8PJwk2GhMJ+ahMQS51iIgmT3TYTwxDDdoZjujdLpMggmiNqkgPObUEbOFzrm8fa
	QLVhblmCc+VBfkABm823btfzWdEwmUUZcef0zFq0vtE6kViLYQ8b8VmdLIyx1Sim
	JKe4PgwzKe0kB6xKsEh8dPcIaHyNXABCWf9EuNwdXUc0/j309C27Ky5A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 407emsxb6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 10:31:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AA2IQP004951;
	Wed, 10 Jul 2024 10:31:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 407tvf0rbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 10:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZ6Q7VjkCN/8hWCzrePaT6Q80t9iMJ9s1I65QbkWdSvr+LVofjQsAmVq2r/tiKwFuKQ9QJzXzxIGdFy8JcPH/TpIjsVIIuL1XC1FUkl3txgpdltwMsJcmRLjqGPOf78VCX/2tSvLa4ftMeAwFOHt0apf2aukgV4KdUUNqvZz0Hg6g6HlGG4bKWZafbHld7UestmwDnVj+lMS3s63O0dMRfnIjN7WWvKe23RcP5tWPsWQhJa9PSWMv16GEBjOKBMyE4HpUZV52zLZUHXxNSPVQvf0Y3vBqe9PQiE90crBd0zPVs6LOZtD4ZayrDGHNrZAeJx6qfR5Imz342YqtMcqSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytnLMXmfQmV0DDp7aW1NUJHzzRzEq1uqN6YdDYOO4/g=;
 b=ij6r0mEDuKhQtcy1tpImtb6ymCSnNMIiYvv2YR3MO5S/IznqqWj7wdXnlsXJ1PYsgffvbvlnzWGTGzmsd2UJ42bCP2OW0cZprnke8DD4vxKNyvlbxuk3j84x70fE2wcGrmNHocAPCwisbRubqejYa/Y/lZ7G/56mezLWwdORdWYo6uJicYAaXtW+NOrWuJslcdRlJQcQ5nkN3VmXIKHeBRRW68h7cJjSPhd1KRjTHZcPhOjuH8Ck6eYuPT35iY8kDgjMRhLXm6DzdPmYY8dyGE79pCUDXPfEDm6nN9r+wA59kWH7bOgZwyPMBm9FdU1tXkeqPqXeTx0Hw7OfgZ++Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytnLMXmfQmV0DDp7aW1NUJHzzRzEq1uqN6YdDYOO4/g=;
 b=Y078c9UgFrUnVDQ0uZXltM0Rr1m3ZOq2PTqFddZSKwPQZ+Scdfz7CVazGzTquNk/4+/vdJl4rf5IgIhV7npxbDiSkAUemddimyqQVPsArf7SEK0G/hB8IizuY8wG5SwSHsRMCQjK6NiZE/8EUpgRSoaxoXVcGL0GOkDIflec5Fc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6033.namprd10.prod.outlook.com (2603:10b6:510:1ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Wed, 10 Jul
 2024 10:31:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7762.016; Wed, 10 Jul 2024
 10:31:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] xfs: Use xfs set and clear mp state helpers
Date: Wed, 10 Jul 2024 10:31:19 +0000
Message-Id: <20240710103119.854653-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0400.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf221b4-e5ad-4c97-c7dc-08dca0cb75e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?uO1DS2IvQJ/9V5fxdtzeEepjoa/Fjy+aHPxJyAfrRv4Bn02s3FWKLZ6O8KV0?=
 =?us-ascii?Q?nXS0twnwXve+OJnAXfekQONrCADcOKp3cJN+WDPQSbGbZDJ6Oj9jKT69llq1?=
 =?us-ascii?Q?7w6sNPlWDgjg/xwLNvLWlE4I/BUSNwuM0dihtShGaRRgcZhtjUyJ778c4doq?=
 =?us-ascii?Q?iZiEf6J+tHzwKB8MZCV9jjS8q4HUiuzbOVFNgh0IqIzPwTyW1HlczWfUTOmc?=
 =?us-ascii?Q?tcawtYfbeOmn2DL+qm8sY72eMTktP4xS9H/Rc6wLvzJJg8ZG+IkS0KOIsCav?=
 =?us-ascii?Q?kktpnZuhVbjIOwq89adNdlPkeC+5HhJIb/fbbiwQ30qKNiXYZSw8TOuk/WSu?=
 =?us-ascii?Q?t2xl0f6//XMnNTnJrLpPT+/wD3a8TLcAg/d+QGpdiMcpLaXpIaHFbJzIYTmV?=
 =?us-ascii?Q?p208yW2lop4aCh3DT55shEOyNBEJPmc7o/omMp7K6R98Fp5eUTKOfx/T8bZ4?=
 =?us-ascii?Q?Whx3Z+AUNWwqJ+rsIhFKb1Imc3jsKd3Hiq89Fg+Lj+Yv/yeFw7/HXK8LheJZ?=
 =?us-ascii?Q?FULd9xq332a/oHjSK8JOzGpJyJxUAs/4Voq3Sr7ciR03fqYa+CP5MnNsQVnu?=
 =?us-ascii?Q?l0rnomQV9n8NVHL3WQ3f0bpKT0Bzgqh9M5uLS7yaX0M/duLpOlRyY6HoRMZC?=
 =?us-ascii?Q?eKvNMQ2w8+pa3h7UOoD39MhTYJDWWjPIRXLOmB54atg8tiavuqcNhIIyUxpg?=
 =?us-ascii?Q?KNz19GRLea3MLYQ48bApMizArs++X0Lx075IXae9cdroqaUVegX3ZKqeByt4?=
 =?us-ascii?Q?jxCtWANERIbcy3uzGPFtn4aIiyAhfMpOZD/Sc3GtTQizxe/AiCwiH75nD4ZN?=
 =?us-ascii?Q?BDp5VXB3O2c7788g8PhY8PxwOu86JBznSdU31uDZQH0AHYkBRDnnhWgTw9Tw?=
 =?us-ascii?Q?9P6/rW8Z8NgQF7plJ3xBHkmo6PiNPeMvLoqb8/ymqLJVqF0cYAUOJVnSWsUj?=
 =?us-ascii?Q?XW+4YijXEy9qstrduksfbhE6TYd0c68DRigV92px0OX3f6fBJ26Vtoyw0rhK?=
 =?us-ascii?Q?Xrm6Fw8M+Ra0t8Zp7mfN6SDbAzqAHwzV98p5WfoQ9EpTvL5MDoe8sJD+SGAN?=
 =?us-ascii?Q?0R6kjnRp/0iOoe2eyMkwEcuvQ7Z6fl/DF5B73BDwbNhAXvBVkWGVPb58eFvf?=
 =?us-ascii?Q?NAiH9Ub3iuP/v7tBlP+/yG4nmwIoyW3awSJWN2X2VRfmpjWJ4TU5Frr+lh6d?=
 =?us-ascii?Q?b+S/MjR3ZHLoRC6EztEQNmGARDqRnkoLVcgcANPNrWZRlusRW7xqE8h3+XUr?=
 =?us-ascii?Q?JdrQp6+9j6CaMPTRlAuUvpJrSMjV5bbnL8IScfyvD0MgYE5DalocSKVcqDyv?=
 =?us-ascii?Q?oJJu96pTQDoXe9Z9IqaYwxn01xV2U9VtelWV+M3R7tkzJg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ER07AvxYCvkJPdPjHKtJL2xyX3qpVX3xQw/VQ8Cnk91swAw0mnnjuEfbW5y/?=
 =?us-ascii?Q?KEXe39i3HlLfCe3rWPMfhcK9UJmZqfXqbkCifC9GCudb+zwlyA9CQwM4rLfT?=
 =?us-ascii?Q?qK0DAdYezwCyuVnO+0iEvTTQF53E7XJl+tBVq/UlSs8P7SKt8zfOP5XhlLrl?=
 =?us-ascii?Q?7SMyydh+D7FwnivW75RXACJtctjD4WcFbOgSbIGegNA0MQL6IRI0Mf6TD4tF?=
 =?us-ascii?Q?ZLqWDu25mxm5ZS8ve6yElGET+nhYuQCvlQcPMARYxtpd+cp21PYiDyDviweF?=
 =?us-ascii?Q?tNOFfDemzAcEB4pZ9YABAVggs7RNv1hvts2KTIp8rrNyZdrDfTWihi8FZF+E?=
 =?us-ascii?Q?yu71Ydm8uU1q1RVrZsD8a0ZCpXZ2Q9vC1L5eX0LaHnCvBfpHJzwaJwKjkbG1?=
 =?us-ascii?Q?kPSGiV0JdLwWyDbLetTuZKAyPQVlsF7ZlhPvAbi8/Ezc200b8qpGUEn0rRnk?=
 =?us-ascii?Q?nn9d+TwoZP3z8K1lOA/0wA/wajSNPGL+S2zCFxL5cu3Qv5Q0W94+js/8W5Sf?=
 =?us-ascii?Q?N0tMQ7BhCrh8wbJYUaNqhB/Ia/pdE26THfUXTHUuSv5zPuJg2dGA3SFBdV5u?=
 =?us-ascii?Q?LiRqu1aXfwjKQ1qYY107cYiVb1lJmQn8J2aVDqULnFDLT1bIeo/1vZgnHST1?=
 =?us-ascii?Q?kRXnpTZExflsdMfWU+BbnUxv+4GAqwhRDHVmLfrsRbjY33x5A9u7VS+Z7PEg?=
 =?us-ascii?Q?o2ifMYgzCKHw5Pz9JOj/C7TOGTcC8l4UzpRtYjNVPftH45RBtZpI/UxttqB3?=
 =?us-ascii?Q?sBBsRbT0AEGYHMTovrSNJaXPaZQC5zTtljZOFtp7zY/cJzBiVaWl4q+jfCMQ?=
 =?us-ascii?Q?JTSRgwKaFhCNszSB6WF3Lnb2aZ3zHozh0n6tvKCiCE3xr6Yjv06b93w+Oech?=
 =?us-ascii?Q?yH4my2Uo7Ndpw+xxviaoahG/Z805+hMjHs9TfswlThUlPWaJ8bNjHXIL+31/?=
 =?us-ascii?Q?HHw0bzEDgN3x7sdEhoibETC0N9otYGJ+0kjVP3bYv7g3SbTnZ7qHwZNx9zkS?=
 =?us-ascii?Q?MvT9dZ5IaOBGqCMLA8JLeJ0CewF9CGhO5OVOeIWdHRlcnYHvqGsxndV1LVdK?=
 =?us-ascii?Q?XLXzf3rgv7XSdXiKe1yDppgluDHGeIUfvZ0FW05itPeHqAID30GJfaZD2efn?=
 =?us-ascii?Q?23+64eXwy2M4oGK32HjatMTzGgq6r4rGZkZ/7US2xVqGi7p/jqF2Tikcudki?=
 =?us-ascii?Q?yRZWihPWB7B6M+UVtnbEw1bU8Z4BHDAIVPEWqt13D2IEuOfvC/MDBG+M/5U/?=
 =?us-ascii?Q?S5pm7dK553w5UWeLDj5a52DCwr2NMA7SZbBTDdwciLteCaVFJWfjPZ7ojQIy?=
 =?us-ascii?Q?m0oKov9OsT22irHWzh5ZPfYZMzyVleYI1gMXMcQnTSIvdsdQo6NIdEzmoC0s?=
 =?us-ascii?Q?Gn4+68qEUskHG0Y4UKTQ+8u624KzCBp+DxfiDe0im3GlwppPIslcEA5RIV2s?=
 =?us-ascii?Q?N5Bzfs9hL3pk/R/KjZcxm+MUWeAnYvCDxnJfaRb8NmlccRgxMIziODmZ0Mul?=
 =?us-ascii?Q?LZZq5NkjgS0hn+X/UkAhh1hbXbBXBj9bGZPQKxjbChafC+xkO5BEPcNIOz1c?=
 =?us-ascii?Q?P9yxwCNLM6sKAyoHYvsa4ggrMOuXFRm0V5oMjTN4MSO/4+gDoLkoMJKJciri?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jhEcGzEiS33qwL4jHKBwj0yLRtAapAeMWmWSeLhH5MQCB4SZ4n9/O5QDofPT8fYzJ7n5BcsiysSKx+EqKMCtvBkMKnoNviubPFGM89ABQg7HTPWx0Le9fR1FZ72wONTH4P6M8gzPMotUk7j8fI5qSNQhUy9RZx6afi22RbMAGNgjstTWZb5sUpRy5TzaXaTmHbItqsz3TCYlwlT5GhFnOV1Gmxvk5DqGuR5JLLTfRqehM0axTlFJGBuwPkcVROOsw33Xe4RRLweN6j3q9aXBVEqxDW7+4rkRoFm+sn/UfW9ZU1lks2U5qHoe9FV8X+kjLrnZNGF3DNUIWzMJGHFoVcAW+vxH0UXk2mgFhC264W7je+X0tHeKc3HouHBgjJCaM746INjC+2uoDIQrsqyv+YvWAlnYnXVpDtk2t1l/bWa4iddIrAEMfTKJRLBgPBZhfQBgvHzOG6c+n0ker2m3LNO6JzB6QPVv+tCXWnpf6iOB2EEmtWHmKULx3EbzRqD4h8dNKpxzJCWRNEE2GsVvXE20FshG2WkByvmVoeJ9KvF1utO5QRs7FKtaB4wqVF1JvXLR4rMarwY8bWERsKbVZNawrH3ds+SW1rD68RI9z+8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf221b4-e5ad-4c97-c7dc-08dca0cb75e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 10:31:29.8274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pL8b2eWIf4VOwgbQvtxcq5ZV28LSWfe88deeOrLi18RXP8BojhqfbVED/83jksyon2SZ+QvszGypHCS+qKH9gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_06,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407100072
X-Proofpoint-GUID: CmlzNMRUQGR3swgOc1wNHgK17aATaw6P
X-Proofpoint-ORIG-GUID: CmlzNMRUQGR3swgOc1wNHgK17aATaw6P

Use the set and clear mp state helpers instead of open-coding.

It is noted that in some instances calls to atomic operation set_bit() and
clear_bit() are being replaced with test_and_set_bit() and
test_and_clear_bit(), respectively, as there is no specific helpers for
set_bit() and clear_bit() only. However should be ok, as we are just
ignoring the returned value from those "test" variants.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c211ea2b63c4..3643cc843f62 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -485,7 +485,7 @@ xfs_do_force_shutdown(
 	const char	*why;
 
 
-	if (test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate)) {
+	if (xfs_set_shutdown(mp)) {
 		xlog_shutdown_wait(mp->m_log);
 		return;
 	}
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 817ea7e0a8ab..26b2f5887b88 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3495,7 +3495,7 @@ xlog_force_shutdown(
 	 * If this log shutdown also sets the mount shutdown state, issue a
 	 * shutdown warning message.
 	 */
-	if (!test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &log->l_mp->m_opstate)) {
+	if (!xfs_set_shutdown(log->l_mp)) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_SHUTDOWN_LOGERROR,
 "Filesystem has been shut down due to log error (0x%x).",
 				shutdown_flags);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4423dd344239..1a74fe22672e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1336,7 +1336,7 @@ xlog_find_tail(
 	 * headers if we have a filesystem using non-persistent counters.
 	 */
 	if (clean)
-		set_bit(XFS_OPSTATE_CLEAN, &log->l_mp->m_opstate);
+		xfs_set_clean(log->l_mp);
 
 	/*
 	 * Make sure that there are no blocks in front of the head
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 09eef1721ef4..460f93a9ce00 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -595,7 +595,7 @@ xfs_unmount_flush_inodes(
 	xfs_extent_busy_wait_all(mp);
 	flush_workqueue(xfs_discard_wq);
 
-	set_bit(XFS_OPSTATE_UNMOUNTING, &mp->m_opstate);
+	xfs_set_unmounting(mp);
 
 	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_inodegc_stop(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 27e9f749c4c7..904e7bf846d7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -311,9 +311,9 @@ xfs_set_inode_alloc(
 	 * the allocator to accommodate the request.
 	 */
 	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
-		set_bit(XFS_OPSTATE_INODE32, &mp->m_opstate);
+		xfs_set_inode32(mp);
 	else
-		clear_bit(XFS_OPSTATE_INODE32, &mp->m_opstate);
+		xfs_clear_inode32(mp);
 
 	for (index = 0; index < agcount; index++) {
 		struct xfs_perag	*pag;
@@ -1511,7 +1511,7 @@ xfs_fs_fill_super(
 	 * the newer fsopen/fsconfig API.
 	 */
 	if (fc->sb_flags & SB_RDONLY)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
+		xfs_set_readonly(mp);
 	if (fc->sb_flags & SB_DIRSYNC)
 		mp->m_features |= XFS_FEAT_DIRSYNC;
 	if (fc->sb_flags & SB_SYNCHRONOUS)
@@ -1820,7 +1820,7 @@ xfs_remount_rw(
 		return -EINVAL;
 	}
 
-	clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
+	xfs_clear_readonly(mp);
 
 	/*
 	 * If this is the first remount to writeable state we might have some
@@ -1908,7 +1908,7 @@ xfs_remount_ro(
 	xfs_save_resvblks(mp);
 
 	xfs_log_clean(mp);
-	set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
+	xfs_set_readonly(mp);
 
 	return 0;
 }
-- 
2.31.1

