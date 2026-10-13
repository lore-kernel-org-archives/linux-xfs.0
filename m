Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFDD3EA97A;
	Tue, 13 Oct 2026 09:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884305; cv=fail; b=fiQ21g4iiZ030GySG12cW8O90AeScaeHgVt2/5fD9AJjlDZGdag0pOaNkD3HabPRz30vPoNS+SIe7Ul7Xp3M/Mg+1KH6VHdv2zEASahuaClqIWSXlVm1CRryl5gtGmRBA5TMD4VL+c7xXNBYFq9UuqlHaVoDYD2rHtqDbMTQtxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884305; c=relaxed/simple;
	bh=EZLf5iAL3/bm5+d0WEKpXwSMZGoP/gjk3JPgxbG3Zb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IP/wrMVvP45i4IUxh42EM/WrmXz8IeD7QxG5MREzNUshybjfkFZ6L3LebWb0c72hJRyRScTNLW/e46F95H2ivNWCKlFQ7LV+DkRSBLYR7CTmuDe4fVf6dM30UI/6Mbq+J2hsJH1Lfme2tegqR4aogN/qvjjRt4OSLMIv7nFmv4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ki6ryIjX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fKy+S11N; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ki6ryIjX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fKy+S11N"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CSL73434527;
	Tue, 13 Oct 2026 09:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CNOw+JpAMJq4r0RRIJzsCzcuJps3xdxHvWn07qbQvPQ=; b=
	ki6ryIjXkwh+M3up6LHxCkZKDkrXlcyp9mnIYE1HmV/qAKxHlgQCTCrIbjlhSjDo
	UEqi5EE/KKOsIdqECrKnNnwvCDGqh844/z/oY6u6l484G33lyD+uvglfhuGVCMvD
	E5zPH1PY2ufYe86OC7iJ1aOz3G8NmGnitsncNCr7tmY+sRscE9giqzRJFzr3mj41
	QVxOnT4HemTc5YDMmEAeQgq4CWBjtAcm4CG1GzMOL21CsVktTGjkOMMvDZTwEZ9T
	MyIZ8E/9X/kP7JfuqOtKPdGQt0C4AnnyoNkKgqknXuarcrbAq7/zI2LnmXG2+ift
	5oVeOow/NFgBdTeX82erEg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aIIt026144;
	Tue, 13 Oct 2026 09:38:19 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt925pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ykly+NVAvETQIaUi2itBTJFk5+X3a5lQsKL2qXM/HaZDrAqCZcqJmM5ZvkwLoU+aJNV2zmcFTI/OrSkZe1gTGoE7tur6SWJ7ppkpoL2rddSIWknPW+yD79YqW5BtNOWshOPNqVTPNbnDABCzPUU2MEWohXPG5grhS/ldXkZI5AbHSfwmVxDLHOiORJ4azvPqkr/Hb+PK85OZEiEB8dsJBJ4slsbXmnyMuVaCu8pTrniSB62ua4VOkYbOA++vnKEopQ7trnjwsJ8vUyulVD79LencvDF1vDEjlX33AdfqkFiEYfBM8vdJeL0zl3BOTWn5r6F0sg4TwX5XuEoIxwQSMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNOw+JpAMJq4r0RRIJzsCzcuJps3xdxHvWn07qbQvPQ=;
 b=d2W42/VH1S4FG+B0OFnL10C+dWZmZn1zgRKkmuVmpuqnMCc8JN+QMTgpYjCR6f03liMe3dX2iJMY32Rfg0G4LAZECYgpssjKMMggNvQyQwCathVUZywU/NNsN5hUR3Gi+loo8e3RufdvbQfY93gwlrP8+0R7izWnD7vdVAlgIuOxZPDbF2J4IVDZin8KMnsjGtpjbG4dpR/GA0vMbX5TepAC82hbpV4nneMwsA5GqGmUF5xMJZTcIT9J4edT0l65SS2ibbFANqAi5PbUO8N7JQJ0imEEu4yXDUCx8voklGIYfOpDQJyvDJM3p1dpng0RQ1gQO/ugsPaIQcM1HhjBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNOw+JpAMJq4r0RRIJzsCzcuJps3xdxHvWn07qbQvPQ=;
 b=fKy+S11NAs54PzYI5s1/QjOkyn5LLoDotY2i/Cb0p8m/InaIC3GZsKmWjDnebsvYerd/6qMva7uWIynz4EwDLeyzwfauRwEfCWXdDHsZ5uY748/hphqiU4q9bUAoxGD4Lr1qBePv8me5FKNmfpL1saWrLu7ZGDGV9aLHWhdPf2I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:38:13 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:13 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.6 v2 1/5] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 15:08:00 +0530
Message-ID: <38cc6761de24babc5bc43083a234ef023ec41a80.1791883285.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883285.git.siddh.raman.pant@oracle.com>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::12) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d114e47-0d56-49b2-244f-08df290db376
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|3023799007|261009223027099003|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	9YqBxCC9NAm87Q/HEWqLSrb+knxZQyyX1JWsv/cF8XMBmeaEq+JlTl7oNARkDlRbdu5qhwws4LsoAObhPxoapDGE7bYBLSuwAm2wuyysqqxTDSKK5C/PpgYxu6mAFKe8T/klpC8W4SejEfm5E38H8flMSZKs4eryOK/bvHEywuY2ETXFRTTaFuQ7GqwOuwK2LegTQn+z73Hs24oX6+KE9unaYJ0eIOqYxhjr9sSPyVwFC3NeSfuvTEHEOTn5PNaFajxosuuZC2uH/EXPUzfN54qZPXV6bTzhfMqoCMx4HBF+T3Hd2mKtltfv4g/av2RmJhm3yhHFK9gvHILskdo0G3ZoZDfPGn2urlfZ5pQsuyCBLIV41gPaKZdHfD2XbanA0X/Q8j0+4r0gqc591gPBtuaM9pfTjdd0oCXY8nsgcWgF65dhRz/kZpgO1QROjPMZK6C80noAu7QZRRDqX+xne9Oj4I/1P3GgF2opo/GczdSviBlUTIxC/TXrWHONv3WnltDAJAWy8qx7IJ9KSDWh9bnGhxst3hgtfeU+12NQwPT1TGyHb5ffecXVwTFti84RdBhc5JjIBlggeK+A0NDtv0QBxqz98Nf3eL3fWOFKIsqNEOGgV0T9vyKUJ3cmxYO/Kr70yzebVaI64N5E+lbICd9X0gK3+4ojN9zMC4HmY/U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(3023799007)(261009223027099003)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZhQMjqfS4/IPGwWPZTY1xU+kKkqtXXdl2S9vicrnjy/osPe2xQPYZ9woVnRp?=
 =?us-ascii?Q?+vESfvZxXgFvPhOsJapFNuxYExeg6pgjfKW1puV1390gjUr8iVbUzyp3CZ6f?=
 =?us-ascii?Q?eqpYCRn0Yknu0CRadKEGUJmM0cXX2s5gFLCkNnrRo5NnCCTL+LhFJCyUXSk2?=
 =?us-ascii?Q?9bAJB22QCuqjqB0waDfjipVD5MRT62U5qdVt/wGZdvbuVFe6+sVYcuggrV32?=
 =?us-ascii?Q?fNkTTYIm8ApJRWeMtRa0CPGPS2fwwCQNU5tWBHya0f84Fn6MI/giwYyGfoIU?=
 =?us-ascii?Q?zr0mzbHb9aUQ0Y/SzGPkwCkJQEoY9OlMv7QU/NZo6li7tmPl5+ejrLwPR8Uc?=
 =?us-ascii?Q?2hmhCAIAymEieAGAfnqeblPzhHoHrzh0S8fYJa0fvlwy1LG+/6GQYKzjNGPr?=
 =?us-ascii?Q?qQO/LXx3XE0KXJ+n+eXWVyL+RrZPYOUlhUSLBG3CNL9Hs9g+asWe5AIwoSL2?=
 =?us-ascii?Q?Ai7uXkyk/Z/Qr0cS54yUavFTtQRpa8SbrReaemTiSGALLwx+qUkin5hvlkzD?=
 =?us-ascii?Q?fyuURk29dUMNml5zR6pH8PIcs14EXls5/hL5Am29/BRgFlMHr40bCEhB4ifB?=
 =?us-ascii?Q?IgP9NwzQXcc504z3YkISXrge+RKDuXVU9y1hVHtA/5LNYnL8TOSZ9irwXClQ?=
 =?us-ascii?Q?PvXspodAclBM/H8lbp3ian4/Cifa1nKyK8jAidbfVrdNQXSl0Qo1/l8uZctI?=
 =?us-ascii?Q?kMLaVB2Sf0Px0eySTGZ6fhPWioE3H8DQKPdtvHeuIoFpqbWwJX5Rik2oAxho?=
 =?us-ascii?Q?S/QdWA++zu6o0+/lVNP/Fym2AlRcHXZ8U7el7uJ2X3KCR9+U/0rMxMqHrmL0?=
 =?us-ascii?Q?jUmdiz+yWBvhObs8MWyi8wIY7NbVqgpEzLytLvYh2NKicc6TkKjD4CZcbGnI?=
 =?us-ascii?Q?Wp4AuAuDhw4D9lTZyIxVXdAI0jK3Nd2hmKKq6dFRcM+t98keCu0w64pYuGl+?=
 =?us-ascii?Q?zD2NuZo2loQpPVq/mMKFGXhpOnMQWeksA48zVAnmwfX/JEfpec6UtkCeozVi?=
 =?us-ascii?Q?0QvEVcY/Pranix71A3HA0HMAukzsvv2Gl8KSd7Ek74JtTeMSuY6IPpY1Yxym?=
 =?us-ascii?Q?efXlYc1hZFFR+YO3ycahYtA6HDVD/R9Ae6Mfcm1EwOwYomX/gfdWItU/ejZ5?=
 =?us-ascii?Q?ez/kEM0tSbq63HrG+VCuuf83m78NJf1OFlUfOHbf7AN59hekJzsuLbnlrRcH?=
 =?us-ascii?Q?/jglNecD54I9iJ7ErkrXinT7Z9e4ZAjTCi2ao6JmaGXccSh+IAv5+3uIlFxx?=
 =?us-ascii?Q?UL6wDSKL4bMJ7tOgepTnihaCVZ9N4ZgWYoMNSQFMTzrfPr+eMQ/aFkLCjxId?=
 =?us-ascii?Q?GkUX0UPTe5+rJHXxmuwewrBV6Ao6gqlw6i9BtO1nvl2iGqg6+CL4Pnn4Q7dX?=
 =?us-ascii?Q?silv+UIe7ZfguRk4cBQ2NChqlZNX1vTbJGpT+p4w0Zk97LyKd0mW5O+dqX8O?=
 =?us-ascii?Q?8tw26d/fD/p4Q4KWRwL0UjMxx40MHU81/1wd8U9yR8JLMCrw3QzXdDdQYQfd?=
 =?us-ascii?Q?z0MR5r47GnG09iIFfKmc/fnJjQkwQdVKk+Gz46eOTJs4iGI33/3TWxZuqyic?=
 =?us-ascii?Q?Tonl8KFThacLmGQODYa9Nw6fwlqEjwNJPlRpWJdx8ctYZ6EYMEMsmGCcIYPs?=
 =?us-ascii?Q?UjGVR5ZRfiogg5DTOWLNUh3K8Ii9Zkd8Ti51yw2GK6aano4mN6PeUBtEG569?=
 =?us-ascii?Q?J4Kk7x/8KjCFZSAi+RXIQohIsZcdK5NcYLy9lTCoAKe0emsfplJaTRADOIOV?=
 =?us-ascii?Q?OQtfDpBaLMqp6GcVA7m4rBf7qzy1bQBZsI0g8MzEQmnMzdPCckGLsTEDdSm4?=
X-MS-Exchange-AntiSpam-MessageData-1: GP7VbztrJ6otN4LWvadhP0Lo0VbUjhbE2G0=
X-Exchange-RoutingPolicyChecked:
	cMdAZPuoL1L7Yp7zHcV8REfdpFWqpoWYCZmkFZemaanxEVNKSrp8rEzcrQ25H7ot0z0tL7aPaZWYz2O4lxJokW7g2cO651aqTAFlbxSpU727nUUesLII7P/JZtjps+6GX44pH5GwF5q3/qCNRdDPQKlkZwjTeHfdi3M0LFFucFNOBPyc5kLU8vFluQnFlZM/TNxv/mo3B/Z++BYYKNUWfhDXsTU6MnUE6akBwqc77I5iGXUXIyskgecjJxJiOLVESHL1cJ53m2R2zkncPU2pK/YWsNxoXv4SDtOxOw9iWttsojYL99mmkdPnDfOc74r1hjPTo06akSdkA9sWP+NXQQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+uv1F2AhhLRmvptwYmZkrMDeu6EfKD0oAi7a5fJxj9/ykoR3jWtTDAvtsHNZ1gKpB5l1DBBkB6H2qrDAv8Y2o9rjSf5MaR2jm15lvyU4qW0B9gwrSrsOuhYSJbkak90TPihBqst7OHNDCYwjphZnqpMHTA/41w7FvFSyjJUg5tW4icKsYTauM8WE/P28ejC+4+UoSld2V+YVlHJOGODf/WKxLtE+2U4ZLDJszAnkavOnDzi9jGj7PlMGQAyQuAL4+Cx4oCf4qCN8sS4J3RQx+XljRAPuesyBQLKYodccNzBXpm+vgkq6Kb4EtD7OnwBqhB/BqMX6hksCp8735qLnU6Vre5UBE040AlKoaeKpxwvvYzt55OSDynAFdmj/p2Gbaa6xBDRYHTmN/g2c7dh2IXowBG5ZyHi/5JZ3JkHJWPk5rKykSG8/ZaxzvLjzm/fPJQ1JAxMhpDUwfgBFwBg3CkMdg1Edu4XoIXTR2jJ1orQFWGCzct0rju8HFHKui6ithoii7UunhqLRieR90k7CUTxyPHF8jYkG0oYXDh8yWW0MRSjfqtwPiYG6Tc+Wu9JHmdlJGhXjDuzB3fKB/Ho4icOhKHEd9A4iqWeXTJBfSNQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d114e47-0d56-49b2-244f-08df290db376
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:13.3809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +NjBxSSNVMiE/JcEjJAl2svqiJZ8CHXsTvXJw0DXmrCKolfcXuzSdf7H1OVhT3kSJzvJOKsrRFsx8snKPgQQbqv7aAbcf/lt5UTutEUXT3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc0c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX3XqSqVYs6JdE
 7YrQAD2PxnARHCDtuojkrtrXbS5jd2iR6ZnVndgRxkbnwejmaILP0nbTfl93ZSiO2wLYtJ+ZAzO
 j7FXUDnDPkhEtqtq3WJeBp3waM4ebLXhSaoS6Z1Yp4FqaipI1Omp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX1IqUdvMHlUC8
 obuUfGwwL2VMrTxqGKF85BzBaAhUeqzpommbMv86hnKFcmfz+Y7Cf8YMSn1rEwBewgN5yZpLjwL
 R1UBodxA6LESDmDBtTeTbV07UYw9VDz1TVzOeiaI6X/uKv+cnOFNSitfxETEyNeozHv/egX/6Lp
 RKpivVtvaky+KMG6TggYhV4N3Mu0fhYL1lGeh9jV8OS+UWNYRfBC6JGgDJ4EJl8VnSusFLeZE+q
 2PxJIt30H2x4uEXUdMDIEabkguMdaqdCCOsYW4PEYFDG44yMSy39IiWZUB+xyoLMsb0HTdU4C21
 MnTuT2x7aX9PMhWX0kJzAYX2Mkk1ZC9SWOavuE47aGJZtymJWGCsThS3iLLrcU8o46vOmh2exlK
 sV5So9IXpNDwHYaxYkwPY5strBeOdUK6B02jiWB2RfpHBkQ2Kh8nai89yFrmMhWrw5pJ7cDmK6S
 zeNqYCGO/ZyijMZl0NQ==
X-Proofpoint-GUID: u0An2FF8ZUfl0vD9nHJiw8kT2-i2p2Xb
X-Proofpoint-ORIG-GUID: u0An2FF8ZUfl0vD9nHJiw8kT2-i2p2Xb

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index be44c7477c16..ea743699ae6f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -879,7 +879,15 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e1adad91dba6..a9fa5b1fd208 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2235,7 +2235,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

