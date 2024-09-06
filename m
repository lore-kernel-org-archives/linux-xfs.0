Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE31B85F7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657142; cv=fail; b=LLg51RxYd4Nu4iAfM88yMNHSC67/nhj8QlzkGOOY2VKj2ccDjVhaPjFTpbamfl+I5HFpjrdE8KMVigaV/I4Blr4CqbTEUbJ1sAUGBuY0HGvWZKILaKgyadyhhJ3NpjIe18+J/C9dY27VfCqdIeBOtm5GdC2MuQ7d64LCBj3pGqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657142; c=relaxed/simple;
	bh=M6DL+ZjWoqKVdhXdC1VMwi4eKdfrkr92ytMtejOkJsA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PtCEz/cufEMaOpsbqbKgTSXbmRcUjilRUf8mq+SQrHvVeS3gy2bWaX8Ow/m67LPH8brdWW/Zvnbcz+rgH2GBj9IiWTxfJRhbZNv3nPSpTIr04+iIkMXh8vrmib/7VTghaV/Q4NZWsj8Y+J6z1QKlAFtsmuZj+K1Wwj+mOCCEOvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VWYBC1aD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J5sh6T/I; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VWYBC1aD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J5sh6T/I"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXVCc011314
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Uatsv3U4h//Lyr+45u5swhKlWe9gpm4sjgpRpFqXsrg=; b=
	VWYBC1aDACSMiz6vVFNfDtLX6EhwHf8F/keyMxwZ4oMWTviw0HChEEo5TT3YbvwR
	fs07nFc+O5DlojnZPf0VcwQN1YQNt/+bixM5lxqsvxKkhNTV9Upm8vOdNtp2SPfu
	1hgZj69ioC94VMyje6nPw6lPNn85fUkDK1xpBNQOKQMGaUh2+kqThq3P3l2AiNCK
	Qke+9jz9Ksw5OA4Q3J+yfY7NaZ2jDnrD0GAjffTPfdSm2AXgBk+r64kyKlhpclZe
	bdX+iM0HQc76jJC3CncQ2q350/f54iIxnmSQpJIs26eSFq2cafoK7MnmDyLBUUm6
	RnfRIsaHZ16Ve8L2hXHcUg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkajbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JYu9w018017
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyhf3y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TSCNkAEoHdQxR2PJO1NJzyoqfzkXH5J6ZHDalLaoLK43/IgiAj5g/gusjEIZxTxt+fizCas96ozMHj3Ij51GppnnJgGbb1OFdRKRnRHrIuBC0OMfNejC/ltJm+qwek1rbvAL6d9rq0xamLn2ERiQEkY3m82LpWNgsPwipyVI8vuIsmF9ZhL5lOwpNASqdlhEsI5BpIUx04NCqwtzRHpMP2mKJqG0WwMMFUiaC/F6BybnY9NLaiteJN++CERmV2tZnP0029Rs0Gaa32IyGbG/X1YBAKGgKvuO1ysKmYvZnhbuGXxRxGyZQRuexAEg08c3s8AMigRSgM8VJ8b6DDXdVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uatsv3U4h//Lyr+45u5swhKlWe9gpm4sjgpRpFqXsrg=;
 b=GjUdb3ulhCMjixcjb3kE1HFSm5pvN1HhI0ZjxF7vw6WnJEtTDQAMMmecVLPt0yl6mUuTQ/ncbEim+a8FLKBfCMr23lioOk26wEy+opjCHBObz6eMG46E45ouV9OmF1p5mNwnBQZh4o5nap3sqzhmriShn7Bz4Y7a9q734txWxNDiGO71r13HsjQ/Bln6mli8/qgAehwbYBgpPMfMwTxQexg1MvM508aRMRCmYcCpSAv4rBvUE8fPF7nBoyISuJjtmSt6ulRQ1/odnt6v58HIhgyr68Pz0+HtS69a+C1lzC81hA42e9TkJ3irBXwNkjySuQK/dAkWf1RnNesmoQj0Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uatsv3U4h//Lyr+45u5swhKlWe9gpm4sjgpRpFqXsrg=;
 b=J5sh6T/IYRIXwAwWmncGjZJbyeg3s+SM5DmB3eV+kyj/pwq+MZnwEXthQbLtcWjJl8bQvzFYSKaVMKFWT4dCHrVF3RTtjKC0Ddp65iKso3GSP+GsVbrT9zx5r4NfX9wrD/FawFb4HR9tF2ZVdpRH1wMPzUfjkNUAr7byNZcjdPQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:17 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:17 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 18/22] xfs: make sure sb_fdblocks is non-negative
Date: Fri,  6 Sep 2024 14:11:32 -0700
Message-Id: <20240906211136.70391-19-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a90f2e-eb49-4d4c-1235-08dcceb8963d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4OU2haUy2CBVsoBwpMZbd77HSTti4AFnEOl8jJPBRueJ7EQG1dtq42rQ1CA4?=
 =?us-ascii?Q?DQKTHnmXPFYlUWkU1R40KrVQp404JIRZ8S5GCjLz+WmPmA0TPQVW5FmvjJAX?=
 =?us-ascii?Q?7BZw5tiN+AChOJdM6iraETXtdfZkOmIpjUDGjCVHKGruMJ62syvC3TqU+1kc?=
 =?us-ascii?Q?6YSMXNLzselpVA/J9K5XUItWjNh6ykiJAONGYJnH12m4FBci3mZzd1dgLG6y?=
 =?us-ascii?Q?CtyVvkY0NNnJOFbAt1AzBPoaUmERR4u94CxWRoGIZuW+EgQWfFOLg3OzIvvN?=
 =?us-ascii?Q?xCgqfQFW86aadmUt5qHG3bMAZ9xIswbLaFpkKprZaORfWHqpHXHuQ/n2w5pM?=
 =?us-ascii?Q?KFDxToTe9Q2n2xxsE4oSDGtIigk0XtRL++BEpZpJH6Y3y+jKJ3czHNPXfsF7?=
 =?us-ascii?Q?ptvRcXRuuGs8OprzBn8lGpfOpROds7J59/EH/rmf9DlyzXrMw+D6tt/LVfaQ?=
 =?us-ascii?Q?ujx4ZnJJFUE5WJDeQxtSWDJaZkQgLKcsKBm9bI6XRk7sN+sBC+nasgLsr4OC?=
 =?us-ascii?Q?weXQ8ZDaLe4TYhZ/Uv8Nbk+etbpB7QFZsWo0qi2kNuKMe+Uvf2OWyhqS0wY0?=
 =?us-ascii?Q?UFjQ8uvv+EKgPaKZ3G19vZE3W6pIw0qSSuelOMJz+0gqgg3zQ8ojc3/XzfdL?=
 =?us-ascii?Q?ieaJRn5rmA93g8V35bd5I0iJ/7Hn/AT2XDNndTQLrJszLdxukZ83WcdH4kl9?=
 =?us-ascii?Q?ZgZq+AqeURVcyHi6qutoZpgeSomwP9S5biTjRl7WcEA4hBJpkgTpKEiBrVyV?=
 =?us-ascii?Q?T3vStN0t1xBiFOe1qy0bC1vxQlIlH5lEUdczYqA0FvXaj7A9VJX01O0ETGC5?=
 =?us-ascii?Q?VxWQDECQQ+CmYqXM6VK5wBPmGG94RX6jM4CGhCj9ElxeBWQqcKYsqJfqnZKc?=
 =?us-ascii?Q?186Liwo+x7kUKSTD0QRbh1a859KQoIM+4Z6g30+c3KM2FBpItkngLB8JIGrY?=
 =?us-ascii?Q?qoPSjeZILY3jPJzdviAwRvoEsrgvPK0UAb76QOZjewLKbfQfxN1X9pDUlU7o?=
 =?us-ascii?Q?KzNjF72hJss1g2APN+V8LzxbB1AFhIGi1N2wpsuy+3IPY0Qiq6FA1gUHKDqp?=
 =?us-ascii?Q?az6FKROnMI3fdpvp79XKedsdBR/hNC8ua0J2Vpsl60JyYcsFNNv6Y7+GNtZQ?=
 =?us-ascii?Q?SUQsz4dqLY+/H3OAfxLc9MBaagSSLyqsw9+Th2974RWXffYELNWXOvGNvwq3?=
 =?us-ascii?Q?7FhkTzAC/2ZczR0JRlNqaQibK1yUgDxdFZEVYJHLxGcU6g5x5stps82csISY?=
 =?us-ascii?Q?L63jGmA1CmF7vmhHCSRE94hZnGjqxTUhu5KRl3ESMErhIvx4egRl2/ZujFHP?=
 =?us-ascii?Q?h/SEaOdj4nHbCOBhZVtF93UpmX4ti+ailNPUVP4oRc+mMA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3w1AYC6cTVip8F2uwww+Ube225BaMfGtt6vpoZObtiL4es+LV80dPqIA+pWi?=
 =?us-ascii?Q?xLZch8++x3J5cNL5WkXo/vqh1Aul4kwqKjvHzrTvytSJa7cJl+6wtqaMIJsn?=
 =?us-ascii?Q?ApxaPGsPwoE7sTSAPbqGWHQnHkI6z5WrAFsk4w7qBSZudGUpnaUWVDHwvkH8?=
 =?us-ascii?Q?HpEXdwv2rPQC8mb0FSQcFae/5m9F2EGue9lHhexPzDIL+GsH9CbdVP/nU1Ps?=
 =?us-ascii?Q?U7hW14v1IKuczTusoxXXTb5CzkU7QAhftRbhNnfP6HOSIwdQWGj/Yv8lK6JA?=
 =?us-ascii?Q?Q7HmsZUwSnTFsH41mEkEehK4Xz+TCdkD/Iw3sRPhq9M+9SB1Qwzu4xJ2qyy+?=
 =?us-ascii?Q?69XU4h3o8Yn9gF+xnL0uKXIFmjjyC+5g9KUlx9+mYCIIjhWuznJAQhpNP2FQ?=
 =?us-ascii?Q?HjWAcHvFcRMnXLik5d5cmIxGvA/mpQOXEO57fgP5kAnFIICmmMCZcOozW1Uc?=
 =?us-ascii?Q?39M3dNNmWgtlwhxGxHN+zKzlb4TGI9Neu00rO7Tzs4DbIozuQggVuI985+Ix?=
 =?us-ascii?Q?J5jMvhVBkPlslPZPTNqI7br7rLsk32WWh1ds27Fw+NPsOkoEmYxIG6x3E+1l?=
 =?us-ascii?Q?0c2FZshU87kCag41JY5IM/IVlOp56//jgd8JgiM75E23KqN2f5QCyTsgB4tk?=
 =?us-ascii?Q?PE9R0uLcHg7U2TCYafVpYfKOQ2z0iU0Ne9MIlzPHWslYmtqezYUXXLOzqPlq?=
 =?us-ascii?Q?8zgdAjjrTPqoEGyDBBvde59EKjpExU5YEZaZyMSKwmJEQuer4Fd44lShc3uJ?=
 =?us-ascii?Q?DTUKA5fboDyKkBw81aeK4xk5dsXxLZWNlJ4qtYBg1GNsKtztNnQ90B0ig+t/?=
 =?us-ascii?Q?Ma0UL0HGkJa8DVSQl6kPKb+tQc7lBwHT6l67p/vAySz0lsMRUJQU9UVT49FA?=
 =?us-ascii?Q?HDCL2ZWVjN3ngH8wgH1ls1w8nIkgPCvJBPgoExY46sPClnCHWnbz3nLPdrf4?=
 =?us-ascii?Q?xf11dK7ICbZr5jLo/W/SgwwGQkF4V3taq6D6DebubNSo5LCIi5V11Ul7jhaQ?=
 =?us-ascii?Q?w6frNH/cNwqHoDEebJcxfgrsEWml1r7TQjMlJT1IpyR+xrBT4VWKbhg3GuLy?=
 =?us-ascii?Q?VwcOkQ7MpTkTdVk9l+9vEdWkajeVHBuLES7fA/vl/XXyeh5jqlOQxYreooAU?=
 =?us-ascii?Q?QKbubhhHSEwsah2H2pRPYo3eVOEgC+Nm/LXSxvlw2xlozyd40vZthpnOfiZ6?=
 =?us-ascii?Q?T4P59mtW8VlXf2TLGABuPpqRRSQUrKfQZgPSntaBhnjwzUWuEVD79c+FdNuS?=
 =?us-ascii?Q?zwAiD+V7moOtOOafXzAHRig5z57FTosGrbgUNXi0yBgh4m/h0/YXLj4JvJMj?=
 =?us-ascii?Q?48cjRoCi6EV44jvDRBaJKLczFcS6YC61S1BVxwFgZCXx5EwQyaiHTIhtq1lu?=
 =?us-ascii?Q?xuiNcpQli8Rsf1K1Yc6GGEOvGrm3+AUPNBR7j4vIViFmP5kOUWC6ul5e2/YS?=
 =?us-ascii?Q?R4ivRNygDUVMWf5mZb2nWmSbTcvzMWAjYoeN6rCTQnWKmiXZwPjx+YQhDmG+?=
 =?us-ascii?Q?7jMdVXgF+jm+fhJlcTg6vs/sN/83dU34Y68WdtB0qw/LyxIXuQonQE6Yw3su?=
 =?us-ascii?Q?3dkYf2PqHyVKqJOZbRMyDwA5I9FJToOnu8bzwI6lgElfh62HrBLG1FYd+ACG?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PwxIxFsEMe+N6a/uI6VTQz2XkZcKSDrTsxP+S3dn7oXY1vK35INpoNU0jqyFA9mVHI/fY3BCt1JN5noACnElfbpwg3U4KPpDKm3FXsywux3nNyC/jiux4V5GCDV/nyoL+ZwGf9E0EMElK1oWVrPlpoipGpkV+aBlA4MLpVRQohvwlvKgAozQpRzGY5d1+nJV8+Ucm0eMX8Hs4c3H8OnhJyZELyJmbcht2m90vdWYfEiasUYfCsMWtYICVSChmwKHevlE2siQYL3OPY7+De4hgA5LK/h9v7c3SsJsBJH9xQ5/xVTw/6iiOS6rO8liXHF4DLWTwkyd8cp3TjWK8tkM5qH2fniLfL5v+SUMF+NI1jKD/7vY74AjTTPBYTY6iHyHWxHwrjfOKTa7wZi17f3OCB4FrpLD7GZo4gcXEqMh3ZZANFLFRpufxVdGUk2H15GCeVPc9KebZQzRUEm8JzFeiGFV34wqtf5dj6ddxAKstpI3gn0kVb25QT9QbhVVQW4/k3wsck0jY9MtYMgPJ+rRARcSpPOC2LGCz/IFB5iQwyvvzaHC2PErCgoY2yGjv7DeLsRBxQiNUsv5UJTbVbKtFYDN8ktI8RT5MYeoNHajktM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a90f2e-eb49-4d4c-1235-08dcceb8963d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:17.0278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vi9br39kzuouQrw6+fTp6tp8nma69cXST7WhWdKHSdeWA/mwavPImj6ugaAlSw4pwChYZY3zq2BYD8NCxF3XrEUek3ycSe0B3/tl6rE8svY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: 5d1mwGNcqHsgjINnSXUQWS0Jj6WqXKS_
X-Proofpoint-ORIG-GUID: 5d1mwGNcqHsgjINnSXUQWS0Jj6WqXKS_

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 58f880711f2ba53fd5e959875aff5b3bf6d5c32e upstream.

A user with a completely full filesystem experienced an unexpected
shutdown when the filesystem tried to write the superblock during
runtime.
kernel shows the following dmesg:

[    8.176281] XFS (dm-4): Metadata corruption detected at xfs_sb_write_verify+0x60/0x120 [xfs], xfs_sb block 0x0
[    8.177417] XFS (dm-4): Unmount and run xfs_repair
[    8.178016] XFS (dm-4): First 128 bytes of corrupted metadata buffer:
[    8.178703] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
[    8.179487] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    8.180312] 00000020: cf 12 dc 89 ca 26 45 29 92 e6 e3 8d 3b b8 a2 c3  .....&E)....;...
[    8.181150] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
[    8.182003] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
[    8.182004] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
[    8.182004] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
[    8.182005] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
[    8.182008] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
[    8.182010] XFS (dm-4): Please unmount the filesystem and rectify the problem(s)

When xfs_log_sb writes super block to disk, b_fdblocks is fetched from
m_fdblocks without any lock. As m_fdblocks can experience a positive ->
negative -> positive changing when the FS reaches fullness (see
xfs_mod_fdblocks). So there is a chance that sb_fdblocks is negative, and
because sb_fdblocks is type of unsigned long long, it reads super big.
And sb_fdblocks being bigger than sb_dblocks is a problem during log
recovery, xfs_validate_sb_write() complains.

Fix:
As sb_fdblocks will be re-calculated during mount when lazysbcount is
enabled, We just need to make xfs_validate_sb_write() happy -- make sure
sb_fdblocks is not nenative. This patch also takes care of other percpu
counters in xfs_log_sb.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 59c4804e4d79..424acdd4b0fc 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1031,11 +1031,12 @@ xfs_log_sb(
 	 * and hence we don't need have to update it here.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
-		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
 		mp->m_sb.sb_ifree = min_t(uint64_t,
-				percpu_counter_sum(&mp->m_ifree),
+				percpu_counter_sum_positive(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks =
+				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
-- 
2.39.3

