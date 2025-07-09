Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDA028B40E;
	Wed,  9 Jul 2025 10:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055432; cv=fail; b=F3du7BrIv43yUvYI3jSCKOv2bhkOOUCl6jqtLExo14yE37g18p8tC+zMJtidJAUVUQmvLb1NPqfI7ZE762+qA7w8PFgaxhOE8RQe8Q0IFZx7PAS1JctKXRuS6x0lGnBUvbpsM/e9aoRnsTK+PvIgv+pPema+20vch5m0O2ubdo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055432; c=relaxed/simple;
	bh=FCEN1pczawj+2x5UuZHr0Km43itOqO9sUFh9gQctssQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rjT1XkvpQO7XIYQ/7qYKOd/URevdq1/73XoOE9rrlro1trKH8SnXZpPW0nirpgaiifWV9Qhmbi5v22+Wmsr2BaW2vhP0a0KTsm8KxaujJeJJF8Ot/dxiYfDEfcmyAmvGJ9eSELlo+p01GSKM08Z7Oid59Rkwt4CE5gwHW4v1Q+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Le7ZjpQk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V2vVwyFn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Le7ZjpQk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V2vVwyFn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5699YofT009116;
	Wed, 9 Jul 2025 10:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=; b=
	Le7ZjpQkUvDOlWJ4iRPBQTgVtWNFKneh63Ocfs07bX1AgBaXne75TlaumO3IGwD1
	yTYnJ2s2CrGFSEQZ+r1A6YF/gRknLs0cl6depMJG13kqmLEZr0cTNr5FFwuj/bI/
	YjSvtL4Fw6hNAcqzpuiOfYtV+2s7hN1hlgH60QAkM/fIH+AGBPviRDa4cpVa/UiY
	uXToMyEO16JNvNilkgytVHnMMPz+Ck02lsLgftLJeqEhCG+9/l+VOOsz5zhDaXKZ
	WEoVE+4h7X8vF0oLvRpD4+FbZ8gcE+P2/8H1nR+rMCIqr9OVOtLYQI3umbMvr+p3
	jdmk4RCZAA2iiBKLkuitUA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sm6d88wg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5699d9Dh014001;
	Wed, 9 Jul 2025 10:03:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgashdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wPDGqxtFwGRBUHlk24SUS08TiDG7+tKXGJEjzcUgaurvg5cjSYAh0yLFodknRBTLUTOEittxoHZFdTnjlaiSGEGEfXnXzuG/fh95aDrB0JidDz7Gu+J0tOfbKgzPUCG9n3zT06hYtSlxNhuxXaSzFvknU7DKdVWoPFw3wjlRlV5W91SUN99IxUvaB3wzckUG5oev6RJZzBZqngG9omw3IyxaII2ogmvlYVAMPsAj/mgamGxuGdg52QDIDMETBHrNu70MF3nNn+ThaKLOZXb0teo40Mq9MSinDrq068cwncv3iXXxD5TY4v2amC13pkRntn41ZLEp5QU/GPMmW7hGBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=;
 b=zNzhNeUr9l0WVcj3D6Hogfr794wbfssDGC5w7TEfHpECn3DxQO7p1XgQ19XlDFtPBgrO+cRM6cHY55iyj9A9PIlCYeQVXqA4bvjQtymyUEW392r2h8hJjpvUiD5aZ5uAs5oDlFF235CUH7XoX+Zf+osjCwfP7axHQM3UIR04AWov88Wmc8rH9T82B//NhEwXwN6RsrrdwsUxymH66KzhbFAADExO6MLr0VoJY77yUAYgCeJAy1oqZAsuLatmITowy/Ov+BEonYIXPxVQQHAGDDLKnSSgMoDIf7PWjIbn1CSaKK2200Ut/xbabNn3X2Rri4wnHCrYw9j6NnTYhqSkGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=;
 b=V2vVwyFnKxPHxocKxidR7Z/9X1bW10abRyJ4V1PNHkR/ESlF7Fw5bdQ4JczyjYhvZZnHxTcBOB7W5imFng72PA4Kv6TlAlucrCgw1A2hygy+ZSIWwUEuhdRbIrOUxaM0+N5ejuXJ5XKfhR+wqVvQMq5UhU40tKvIaWzSm3QQYSI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 10:03:01 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:03:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 4/6] md/raid10: set chunk_sectors limit
Date: Wed,  9 Jul 2025 10:02:36 +0000
Message-ID: <20250709100238.2295112-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250709100238.2295112-1-john.g.garry@oracle.com>
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:510:339::27) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: 8236c1be-f64b-452b-e278-08ddbecfca06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vPcm2OvhzndNt1+z28cvvHGiYcU2YYZUZxckdxg6otpKBEGuY09yAyjdr+Fz?=
 =?us-ascii?Q?NgVfPeFnnMSnCUqK0zUda3OfplinMjaEuQ+fm66L3K9/TFO9YJMqaegi7gML?=
 =?us-ascii?Q?Cs7RKm2K90cti6DeY/m8pD6bq4uVmfGGUjF/wy9NQXdjI+DqmOCzo2wI1f6C?=
 =?us-ascii?Q?qlTK9WSF+S0zSa56u2uYpXqtNI21t9iDE5FnK0h36gIo+stDHSdyUeByvq9w?=
 =?us-ascii?Q?W4vW9w3UfpFrZodDHi26iBWOCc0OM6Ebz8wlCsXXnyEAHGeIgIYfzTjVO56w?=
 =?us-ascii?Q?8hiGQdiQcWZYfaVoUndWwrFnsS488GYcbZCqz7EZc5NCLdFcBKD+d5ycaQUK?=
 =?us-ascii?Q?f0sW52xYMk6IhLy3tl9coczz63T2AnZ0rhre+D3JJCkkBnHkrdZmSDxoIx3a?=
 =?us-ascii?Q?tSirRzVMroKOBacb45Ec4juN73UcHWk6GYWeFRvizr83mUU4xK1WS8iVkHtQ?=
 =?us-ascii?Q?UuYFK2cC4I5gIH+dKY1w28iWMgDm4YPEffntRs3vL0p0FrePQCHMQQHOnLLB?=
 =?us-ascii?Q?IZV9QBROykEyJ4n8mqIr/RIVPKD0qYvb+0pxvy4He6L17nhJV+iHCB3Pc8Lc?=
 =?us-ascii?Q?tENN/1KHTjIAd3gSVjmoZh1HfswKjJS3l7itVEOP3aH1gMDlg/zAYAspeBy/?=
 =?us-ascii?Q?pnc9fa/0YisokD0pMv8nzOZEBf1VUF4FuB0hDTZvBTmAY48UCJOOZn1fKci+?=
 =?us-ascii?Q?6LcP33wK1yqOo/I8iN8DyImegha4NP+WzZr50K43gfdSKVqEKcL3+GBuRgd+?=
 =?us-ascii?Q?UucTS5oBlUhW6vR4v3d4DOv3oNOfZ+u9RecVqUtr8mPj5pouVZLHKo7p3+RT?=
 =?us-ascii?Q?JUqlOQeGFseK7JxHpCDnVLDuXyzteW66auIF/ndL5vBisIIZ5e+xKxE4N8Gq?=
 =?us-ascii?Q?mEnryPUOk+8W29G7QRX+BS6+K080QXHBWky9wUDzJYxFmpcrWNqmJM3cdA2X?=
 =?us-ascii?Q?V3q+uyAuwkfySq5dV4z55dWmc5wJ4Du1eoQdhX5WdyJye/noJdPPTEzdWscO?=
 =?us-ascii?Q?+bo5hzxDICEYVr5mjxEYl0GDdjo7OJbm+tpkQJk7+XFMfbzMGm03FSvFnSd2?=
 =?us-ascii?Q?PB8YbIPRE3T+AWHxAO3EUHCmPptgH5qX/8TyzbhWtUBlUcCvnLzNPG1mewbt?=
 =?us-ascii?Q?EMrrcak00jLWE/H0bnOPcom/4uXZnzQSuboP2zEENQfF+rTKmwyM/b1y3Hie?=
 =?us-ascii?Q?ozqetxxquOpUmriatq3xXPCpar2q9p7QboPyvtM/aiHKx6ToP4zvR6xrmfSF?=
 =?us-ascii?Q?pMsLZs0WVe4hzLGVFUFywQGlS9FuQxaVdehi9BJuNzVB6nrXVgRdVNPuDzKh?=
 =?us-ascii?Q?mrPOw1y2WU8H4trx/QOMyAXJQFr9wvYFSnYuIFuzNm7zg7+mXw09d8Lby8C2?=
 =?us-ascii?Q?6tAYfJSSxaPuhhXLaamN+dQlckrFJRbd8xcBhV0BbyqWOWmUgBATDpnuXN2g?=
 =?us-ascii?Q?jp5uO3Am8JQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sS1I9sdQ27zQOVyxtdFtHeVjPMzHebpKTJQh6w3qO7volL410ZiHsVnIWnjB?=
 =?us-ascii?Q?GP/R8VEQGcW9vShZ+gyJLGJeOWI511+/fW5eupY1mZCKQJht1FbGd9XHmbrf?=
 =?us-ascii?Q?E2cp35v5vZpoMijuRFlQ+wDYxrYZnAPbIC+FajhK56aTYiACT0H17Q+rbiBz?=
 =?us-ascii?Q?6F9o1ry105gy9QkXyC3TQpn56IU684VYBzgY1qZBZpxvnzZXyrR9QU8wam/V?=
 =?us-ascii?Q?+o6G5pAvh7hdnJ7Y342olsuFzDK2+pypIYRsISrSxiYa6CuyNYV3hqVZICHS?=
 =?us-ascii?Q?fF6uko5v2EinYWk+wdSCqZOzF1ZXLdyF5KTSNa+IkFG+w2wxwaz2RO0Xao6n?=
 =?us-ascii?Q?JF6Wf+YTFy8Arsv7CmV5SHVpsuxMmxFGeZ3mqC64sMzTgc6EbPdEVfkPnKv3?=
 =?us-ascii?Q?mhkHPW1nd9R0kqZ+99WWOXolFeVsJo1XZHIjU9e62LBghK2vJnMuDH4wD730?=
 =?us-ascii?Q?+B8MmNRvN6Yzgo0eqOXvSidagf1mATy8wWd/D/qi7xnYVJB2y/3u5XWnKju5?=
 =?us-ascii?Q?0VZjYq2JbfwmwLa0+tLgZ3kgoTJBjQxJvzbsrGZoaPfWwYeP/J2kpTT8+IwI?=
 =?us-ascii?Q?rhdU0j9HoGIcLrs6EeF/W9Sqc7+w5BmhdjJ8dsjRqWxHrTcHSuD6bIkz6lQp?=
 =?us-ascii?Q?V5CJkxQ+DbeNPXl69skySaf3HMrgA+ifoXtkq6bWLPcb38Oq+2Ix94nBbbmg?=
 =?us-ascii?Q?A5RoK+vFsYTtAncqix0U02XzxtzELTT4eOCh2eWtZqT/hbmNYy0K7WrDkGBM?=
 =?us-ascii?Q?cDuKgtlrBXSd/pKur8ZUmZHslABcg1rBCSs5rC0SQFB1IiXkHZKKV9XFYlLe?=
 =?us-ascii?Q?5K5t7BpbgBZtdShZ8czcuOi5U00qldQBD+vYwKu3szT2hM/JDZvPMURK9U/3?=
 =?us-ascii?Q?cjaOnx48tFc6ZjOUTQ3YoduI++0nFDgUhvaypQkgmN1QPPkbIm2+bqyrnWUE?=
 =?us-ascii?Q?aCVpWMjCqP47ShClmGJh7fncbVw8ZxuzA/4UenmICmzwGmkbvianCNSPkX7m?=
 =?us-ascii?Q?s+YSsDqO3ybWDLxa2FdTxs1o8VfQlIneU4qcYpJYm+wPEvxS+ZQ2uFGH9oaS?=
 =?us-ascii?Q?ucotAPqIwPbY2qCN5R+B43NmJXb5pokmUlSf7K55bxcRNS6JD0lK+N9lJ4zG?=
 =?us-ascii?Q?9DVQVK2Pj9aKj1Avo81aWXgBgeyObUpVcrlSW+m1YL3rLDJ+6FAbUnF/PN+m?=
 =?us-ascii?Q?1vhJt/eyUb468tCX/RQQoCfzr9yWHA0iYe8RRgKupGn/GNfBoCgIbHkf4EjM?=
 =?us-ascii?Q?SXnEvXDMOgNWPfBWMbTEsrPzTMs+AZfJpZXnZWftAekBV8vdFFUCFJxidIFd?=
 =?us-ascii?Q?Qv7lWk0382Piay+FX63dH1YVjui9g/kuh99/sLjLkRgXQZw1zECUH/s7mj0k?=
 =?us-ascii?Q?9rABwtBHGEAAQ5uFwJTgzQM6vBPYNgAXiMnC3RvNHuzdZh/m6sECNzjxORII?=
 =?us-ascii?Q?Ub/EY3BWx1SeFrDhaL6pNXL/XtXRr2345TYz2t0M8uWr4ebsL/S9nQ6CCbgF?=
 =?us-ascii?Q?uS9o/J4ABara7khkVIs3DWnwWYpOIyYdKTBq/ck/Vigz7/QXLxb8Xlusro90?=
 =?us-ascii?Q?JcQs0PP6xc1JfZhkd2QB+ZBiEmq0WZu0meMm48ZjM6fMYkdBHFbWz2LSeDpq?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j3hWpdnXwslIQ270M+FuN4BkqqaaOUW+7sHgs+XfrnVyIZ4/uHXnsohlSIYcoyTL4ywpIu9LHcBqans305qb1Wbp8ZnjlqDkter3Lw7k5NgmGs8eyHCWrC8/ZQnmLzxq68aNCXo5J3WO4JYzb1lwSwNOvsnHVR8X+cVE5OKP46ymXl25GWYQ5aTObWIsmOk3/cyem/dlRqMTQQjs+PeYIRQ0l+we0DTuzJwdkiKkJuQT2/t26nXMKpnNk19zUHY9TmQOzwo1NhHXlX7jyOlSpqXJinDTd528RYKydNqmjjYnC0oolo9LpiZxMDZ3rjv7iu4x27zmu6nVV8lg+J3tVPZOBJM4mhe1Y04gLiZCjWcxlYScyQa/vLE5B1M0Vt8hKhlzZSguSruJKuBj1GadwzpG68g74XNp2mD5kGorr5HW4qYhaEKT9AU0VaoWLlFbpuDmmqmwuoeC3cRL6YLFUR8UIRrmQFCacswmZ8GwexRLlwMbFNfUaXRzjWzwNWx0oCuiV0QBvC+aullx4PUYtce0MtdFCp/aOX9fwOw2xE4eTgV9A+gUPyx0fPrZmEMwuaHnQOqA+8+xR/tao9HzlVXM3lrylNfvF28p5PzGe4g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8236c1be-f64b-452b-e278-08ddbecfca06
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:03:01.6561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fupMuII/q4GG2/l51M1/lbSMv1+XS5VwKzkuNUoMXdrHQTZMXuWlGi8zuj6nn+eOoaifIxwAIqIoSoGwMg4dqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507090090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5MCBTYWx0ZWRfXw07VWkr2yiKO HujpiWAZK2I+WFwreBYjLCpqCjfQc9juMBXqGSOeTKSBWHZ/C8zH9pajssUWgk9PMX1cy5z8fRD zWWTSD5EwERxzVgzpjpewzQa+a1yce6+dBKu2LT7OC/l+9vZVet62aZtiww61zMeNQRpFqRwlcK
 vuPp2PYhMqugCDrWO7LiEFOOKhamRp5W0Ezh51HByKS49Vw3QEY1Fd0fyF/puHhhyWiSC/Zig6V vUwG0kyjBTA3qlyKml7AxSc7g5XZN/uwmWS+SxNtTNDUiflrX1/xnIIKr6ZN3dlSJvCEP0bOOUz Tm8qwfwjcHHqMpiYXsE6REaNg2H9g157x3coAhRzXqQXngFfxkk1lamZKPFPFk7JBNlQPtEBZEj
 VVeVPouf/J5MqLJ2Vq5jFWWY4fDjaYYF23xK9K213Nln2YpQVNr1pBBcb8a0lMkayV/8NZTT
X-Proofpoint-ORIG-GUID: 27mqerY4VMt9B_r0MWLO-K_e2SaB_ach
X-Proofpoint-GUID: 27mqerY4VMt9B_r0MWLO-K_e2SaB_ach
X-Authority-Analysis: v=2.4 cv=UPTdHDfy c=1 sm=1 tr=0 ts=686e3e6e b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=w2tMMWzikjCRSElI7Q0A:9 cc=ntf awl=host:12058

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..97065bb26f43 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4004,6 +4004,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.43.5

