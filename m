Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCCC1D174F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890901; cv=fail; b=VECWlVCwcbx1hOLlIBkzVRkPHMte/BMN/Ux/UjQU/yV+OiaplvkbMmwuesTCyyB9GUZunDn0Mzn2PyrllA2bOM1nhy5n856m/6ujvaJoPDbXi4uhCt9IYJ1I4x0Yt93rfdHenI7btnqQ2fueWTJT0cpYQXaITz8WLCF/gIthe4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890901; c=relaxed/simple;
	bh=KSjrrTGrhQiHnnlmkki1cmNpGsCdMSYJQT7e8zwxjNg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mbEZ9DZXrpQ1bIVW1UOknq4oq7xwGRX/qUF1ka4TZ0n8NDbXlGV+YdCZc9XlPGkZ2XGuKvtS0xikojf87QjU7JY+R3wkj4AX2vOzyTklBqbVkESMDbnH8IzHFksV3B912Y85QdAtAQmK3SZQmQntpNxdx24txYC2ZVP92ny1E2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cAs+G+ni; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UJbt3rhw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cAs+G+ni";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UJbt3rhw"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfcNX025762
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=hW1UoPWZ8Y1G+XTsn5QdpDYFaW+S8YoUPr86Rd1W7JA=; b=
	cAs+G+niDvlmNvgjl3UJDbrVUfec4H9x3K94woXsOYby06rcNTv8XrUZIbi5Pdtg
	FD9gbhTnB8L18rVp8UZQsT51v4h3UWqX8OmDN+4ZVhTYrqZUbYPPbCdo/eYJ1oLj
	Bpu9eOhkd27/8o/vX2YE3ToDWQ8sJcgK9ElyPpK8Zch0s9V25W2CZtHev5EaH89m
	D5/DhbC2TDwh7f8U+hquaHo2C+kHTeS99ZNoOd5RYnJ/9kp7AvWB3kpSUpTb33EM
	5Tkr+yxQNuZr33TfjkpzU2E81xVbd9KbJknRgr+BG6q8GQuoafI09Qzcdxhpgiiu
	4PHGoX0jL6HHmnBoSssQgg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8qba83x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GFKLT026202
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x8897f90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFdwsk0nl18qaRVIZONdkk3FSQ7CiWCapDLcios53i08PVypGEO16XaEfwuPqK3WZ2KPI6aigZtYtojeHwYzubQXAAayCdungRkioqPskMXcPrVHEIV0YsLCgchn745A5WCi4f1KjtHd8zE1hXjfClzbbKQipbZ3UK8bMZytx2T+jWdwpsK2Wxxe1QKFkJ47QTfBRQNPktHsyF36B+iuh70OYUDfTVmfj1BoEEHgSJjclUDGt9bXInRTnz+8tnubheOOap+tY4S+TuxGTDt5yDAo6u2VqaZkvNiXJ9jWjopD5/famhbYnER4QlDZmHPgunhwbnqPd6X/joUAbAgheg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW1UoPWZ8Y1G+XTsn5QdpDYFaW+S8YoUPr86Rd1W7JA=;
 b=bpSbwnPa8WuxupwwbYiZLUvJwvPZ3aFIi5TQV/kMlBpupGQbwaeGQrcwEPYjZBVS56NizRccWZ0wtXGASTxUn08FCoEzVth5rsyIKgnY5ilHbbtOSDPfma8KE00UjguQEtgq2ZFoox2qBGerqESYFPLcdd1udmDEuqL5e5ghGxX8bulGCt+M4rYKz/OP3ZcCSkVIybxuhgTf2t2toZGSBfOgoO5WK/zpIWCH9RENIBiQB00dkdT0Dwolt95/2uWYkRUEV/qqtqeCbC6nAyI4TZgYokL9MXO1k/TYSIAb9fPRfqfFB5UQUjv/2A2MYLbTmwjFT529R6sFPep5/mdA4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW1UoPWZ8Y1G+XTsn5QdpDYFaW+S8YoUPr86Rd1W7JA=;
 b=UJbt3rhww8CD3qJANNWwN8ptGRVilKN5Wn9xgrvD0bs4fo95R7928V0fjWVRcI/1X+oNvqwPqciFQso/fFq7IuaF1iU6oOsCWSaysov13NvnKhhJ1WpmGmibfEnkaGW1tHzePhkk3jGvVfousgyMGsyO8fodjPHmztmv+iYLNM0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:18 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 03/21] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Wed,  2 Oct 2024 10:40:50 -0700
Message-Id: <20241002174108.64615-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:a03:100::39) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 09dec03c-246c-40e2-cc47-08dce3096c1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m5s6Z0umMplyFu0bboV205uKNxkdnpfzzjdAmkZ9YbB8uq3VHg8kPvz7O3/8?=
 =?us-ascii?Q?Oh8HoS36EGVoeTUCPCDuO0cdQhF5kK0wysj8lYXGQ2U6KNO7aI5kuZgO+Bqz?=
 =?us-ascii?Q?mBKC5HwnY8C5mrRKTrPGuRWQXZ4oOGz/OtZRL6IJ9NipRv2gAlD3/kStrj3+?=
 =?us-ascii?Q?UN8xe5hcmWd+XaS2oieM84S0bMWX5K3XkT2h2h3/3nWLJcFgJLEqA9YXQDls?=
 =?us-ascii?Q?WS5+A9T0qMX/1zXMPFnWjmcB6fasVyJ17yRHWtLrpXut+NXKBOTlZvOyQrUy?=
 =?us-ascii?Q?8pdG66O7Moro5VK9z7ARm3dbktd0fY7dJIq1LepDZKs0ZSL2P6b2UgXu/oCC?=
 =?us-ascii?Q?3Cu1YJ6ZBVu4DtdrPbS7XUYGjUtbFf9gFG9eLA4/90V448OCd9vNIeVbTOzl?=
 =?us-ascii?Q?Ogrk6rqPkkp9LT1NTv0+HxQ389wWud9dTJ9/5MBSr/APAQCuzKzkwbceR9eW?=
 =?us-ascii?Q?KaNgOkxODZqVV2nvzweUo63ntruKVbxBMcGxB56/QhZOCF9DS6vxra1EPvdl?=
 =?us-ascii?Q?5oSwBsBb71ldcewyCEEGEPo0vd1qAS0fkzmVfz86mw96DPmFPwiiCPCGYC80?=
 =?us-ascii?Q?02sq/j2yWUbQNHbzQcgmume8tbbTaqpl3lPKBCIO59YSd/rL1T/+SlMUh8ea?=
 =?us-ascii?Q?FzQFOkb+3HVjXET+5kGsaZBiILnhhINP13xP63cAts6a/lnygI/lTt09kX1w?=
 =?us-ascii?Q?SOR6LpUB6ZsbcpcLPZmVYrnwlMWA5NSKg95X3/8hPoCJ5C7rWnRmDDViitW6?=
 =?us-ascii?Q?5RqJPonHQ79xZZrfqN2qPEIY3qjdS+1S65bxeeiXLIMPGaioNSH3BKRxJBwE?=
 =?us-ascii?Q?wyM/fUkd0kVRoFmjDQCJOJjNJbXMltGXUxv06rUPP+odCGTC2EJi8Q08NV5t?=
 =?us-ascii?Q?PHjMSGPCV3MchEgBgNmUBfQhbhCXp5fwjNf432aWH0DRFOlj/rIpo8H+5f5g?=
 =?us-ascii?Q?ghdc8DovQX9cVI5NOAeftTD9rGN9z596D/5CWbcGQQcHmdYaVNgxry0E8nFe?=
 =?us-ascii?Q?DmJOIvcnjP3vclsXBON28rAvtRwmylkonJjRPrI9x/8P9t2AJFiN6EKu/Wey?=
 =?us-ascii?Q?MXIOop2vqRar+F/6qTKTJWrLwDOxGDijHsKEAIv5ByLlhLr7BBLidBQeoX9k?=
 =?us-ascii?Q?vsoiIkFxdnJbzlySfCyrg5B7CtDRycqev/bijbYkpkb5E6lPH1aQJG7GvLTg?=
 =?us-ascii?Q?vH+mAk+x1WtjItubQDukLVkERjxhq4jYUw5JdhBugzTphaI/qB1uMu53SfPF?=
 =?us-ascii?Q?fVOu0jhnuM/+7Ov9HwGol1lLxJARnuRadVHw+P6TFg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y5oQ+nOcYGk2NwZaebgpbxyjA0j/8q5rSyb4um5Nvhytz08VrCTnajq1bvjd?=
 =?us-ascii?Q?NvkQn3DTnZnhuwkUZ2Ca7BYUjXNQasnz6k5+lAbnZaNP/oru4sZNumilJ8CW?=
 =?us-ascii?Q?Z2e9awl1ZGTvsS5dG3PktjVj6TaHqLX0l3cEig5DvjL1HhCWIatR4BfDSHcG?=
 =?us-ascii?Q?/jGDKnHYK9jhK5cExb28Pn13Q2BQEMiGfVSI+P1y3x1vME2iMNcUpjiF6Ygd?=
 =?us-ascii?Q?EUyGnHV4SPbTmDeGao7S2/8NVa/FLuqjatBPM2Js0G782j8IkuUpdTuUMQ/v?=
 =?us-ascii?Q?kRBhhh8/x0vYA93bwB6rQ5e0CNmLJgjnLIlvIUulKUfvIM0UTxSs4iHb0Hbr?=
 =?us-ascii?Q?f6oKc0ZBqJsiumpsue5UlXmrmaXu/ZuLD+wVACK4Qsiwbpe1D+vRCNfm2Hql?=
 =?us-ascii?Q?sauf3PYrG+NFR/UzvHgpQT8i7mIy5kGdZKR0lXZBgj8qhetxVeCFWcM3YMnf?=
 =?us-ascii?Q?eIzoZChQvXEPOmRM6un1oPM6KUY3JI3GNkjxlilbXMS1Kob19UeusJQJCChj?=
 =?us-ascii?Q?6oPDFWlhNsvCnjOGBmW7s644huWI59zjBmS1976FVhkCDCYHBkq2sDMrDNl+?=
 =?us-ascii?Q?4KiAro/m/qTY63WWMQaiIo02DJPl2wfNlaYCaQv509VZ1/8afhnruglKkdBR?=
 =?us-ascii?Q?zTUtzYcEtEr7EwmOgIf75WGOUnjafnbzKbRi/fPuGKp8l7UQggPiM14LYdQi?=
 =?us-ascii?Q?btLTOJU7232Vhts+0gxKYnaxIbN08LhMXYO2M67te+9vI/A1IFJdJNykQ3nW?=
 =?us-ascii?Q?1ndW7cXluTFwwDAsuEsJ722QfAXPMJSQ7LQAk+q8J7WU+I14UETye05YtCBb?=
 =?us-ascii?Q?1fXPF7LFt9MZgypSDyDzHbvJ9BZT0tQL8vqCSW5Uu2UEilHWK3KqrI9wW6B4?=
 =?us-ascii?Q?orG9hrWswCWDW5AEBcqWZU0oObcLUmfslxA4br5C3J/zxbC3XDgKngfO6Zv0?=
 =?us-ascii?Q?eRouswQA/O9fRTgUWT4noeKncWzZ/DlgZX4p1RQJyMSmWl9tekDtbmqTTRyd?=
 =?us-ascii?Q?o1e59IPOxRlbqjkg9cw7sB8WrvotiZHXeZn0oIs6nuOkXohum6EbUYrfPMUS?=
 =?us-ascii?Q?LMeBWf6ggs6jfO3tFpdxiPCp2UgGn+7p19N22SDxks5bMKt6T1MLEodr9vxq?=
 =?us-ascii?Q?8V1dWpb4IhuMuy0C1RtujwiO4is5Z7m8eUcoo+cumDlFnfePQwCFcvIWzR2W?=
 =?us-ascii?Q?TRTjAd3cdV7NCeDqhk3jyZTdNndHv47aOGOSv+/216oaf9xx0mnIxgtZlEgn?=
 =?us-ascii?Q?FM0Zv0SHc1QmU4MXBMQrVrfzP11ph4SvrKl1VJzTy2Fz8U7qPK2yhM46Zpmb?=
 =?us-ascii?Q?f/JksqTjN3RSJVRfUvF6gnXmd0DEmFMW2Qhuw+CUJhXfW1elZVxFice4WOvi?=
 =?us-ascii?Q?qireoXWa+aX1lVd5MiQ2lDXwpOcz9M+TTaOm3LQVlMbz4bOgjBqFK9gQsbaM?=
 =?us-ascii?Q?Cq6njhrjFkCy+YAA6xEqinSSyVYuP//Q100X9L6fnuLKSvaHHxyhjcuHozKc?=
 =?us-ascii?Q?3N1Z5mm8Xc00u67faJ/pKLhGbDuI3IeXpgI9kq91Ik8lVxXszMQOonUKqFoF?=
 =?us-ascii?Q?uCq83xvUTZjjE2uGfrvrFc/D8vpQxZq3YjG9mqMrJWUbWuAZ5LXrISS9S+BD?=
 =?us-ascii?Q?+A9YAzCYV48WgOSg15fd5jA+D7mmBABFPN52t0H/1vrvHwIwQ9y3uhwK3KZ5?=
 =?us-ascii?Q?FOuPfA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FyLDbpsnLIrDWSyTtZJQb0jx+yTPa71QxFtGWqGkq79FBwotfsFka9dGesv9XbtPIjXSuNrpysIJ75oCRDh6iTQ8CbDK+PXsYwWHQ7u6Q+k2BqEXuBaCMdDy9f3Jv6UxdPhr9ulEBHrkQ22jAGz4glUXz1Sv6fc8lJKNc/oqMgX3SHKO0mKb56YrctFjGenkseDTxuvCq/G4iQCBcp1BTHIAcJ5npN4L5OqWS33Pey3xSn0aj0+piEPfz/A+dM3UFGxp8oRY5rAnuN8RK+PZYvLhQN+ASmI4DMkYjuT3Bnn9B8A9NKKQ4F54+VWRjl3SAK6LfeHR9fWV9RwzA0IGDNLv2NQpBkLDXR+Jhc0lEVPPKp25ZtlgkpLOaBz7NvwxotMn2GCtRR8ULch5ItDf3ggYcr1Ci3nj/NDCjPkDP5jGbRTula8hB6oQen/VX+QofgpbzZiiRnDMs2Ws1YtWg6JrZOCz1Zs/KAZNkQT5qgKDvrQZLwh00luLm3ntgRPNmwnLQwCjZoska08ZJ82fVjEwNUqpBfCka3RpB/XfZ++qV/ILT2B5QxuOGFriTqOj59XnwCyFR9VdaesB2ykA5Pdk2lG6hz0DbbsCoar+O3A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09dec03c-246c-40e2-cc47-08dce3096c1f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:18.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wZEA6c02gWjtehDxk5cEr0NysQpSHbk+JNKzIgMNrSgUuBl6xz+gsLKA3RSO1b1XMn1ueEhhXZH8uUEhW8FcA496BYqJprOGfKz/BQ3TOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: UO_MchnrbKDSNIQ63e_wOPoA370uXTpi
X-Proofpoint-ORIG-GUID: UO_MchnrbKDSNIQ63e_wOPoA370uXTpi

From: Christoph Hellwig <hch@lst.de>

commit 86de848403abda05bf9c16dcdb6bef65a8d88c41 upstream.

Accessing if_bytes without the ilock is racy.  Remove the initial
if_bytes == 0 check in xfs_reflink_end_cow_extent and let
ext_iext_lookup_extent fail for this case after we've taken the ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_reflink.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b8416762bb60..3431d0d8b6f3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -716,12 +716,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
-- 
2.39.3

