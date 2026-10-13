Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC95D4B7A4A;
	Tue, 13 Oct 2026 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884476; cv=fail; b=TcTB1JnhMEbfmP7Oyrjy4xvWyi6oEXt+sYu/nHeDN7FUkak0c+BSLXmT9cwcU7TfNBPozuFFoW/PbHT9E6zseCGLFf70Oh7mmsxe6OYG3BCKgbJd4ynsRmV+uIWp/ODE23Jg5CAwa52JcqBoax9ZkGNfBilq6EOGyTjnm7t2Sno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884476; c=relaxed/simple;
	bh=TYcSN5L2I0z031dsPJqYpx09TbeZsdA+QNfihtqDybs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s/gqIdJ5xjo7eLdDIAj1IBTVGSbYVxfERtYI90oBUzJI/NjMz1Myw8TNUYkssqn07cpHl4OYoi5n1EapMEceSeEfRf5SOfT4Xhn5RHa5b9aKblm4VC6V/nQH2HbN0sWIRaXgxCzttoZmG+CtNoaID0EQc3n1/+uolGAnbfrthCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KLNX7RNb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IFDiQoi+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KLNX7RNb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IFDiQoi+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D373IK3288508;
	Tue, 13 Oct 2026 09:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FjzJyrAc+L2v3cekUBG7b/K0eoBAA8gnGDNXdZ3VSY8=; b=
	KLNX7RNbSO1YGwoa/WyAEejbMSIqvhPprogSNu/Asg9s7CDnTwfRGTGfmTH+bcHz
	G/zSTgJ+jpY2Xg38JDry+vKsp1lH0rU0XPae5155PSdvvXoVECCiDtM3CmRaoIsI
	ITyBsO8vXVvYtilzcpeDGilXXAkRQ0iDawlOD/YJ8hXid57pNX25JP7A6LaAG3AR
	aAU977i3ZwQYfFRJ+JOCDZYXn806ald7SLpIxXTtX/bvgK/lR6xUuZkOwB0m3WoN
	64+VNCA/uX1TAK/bSJ0b9wEzXWzHY3ggQWEmyFJ9HvL88H28nCQrm1WN4s9trb7q
	t5/XQ/zOEm4JNxaSptJgpA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:41:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTXh010920;
	Tue, 13 Oct 2026 09:41:09 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d7be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:41:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tABwrt0W5oZL78EuXFdGxWpJ/sz5QXUQc75Cr7FwiiYGRkXWCC9cwQzuEHGiW6Fv8Hn2OlzP6QKdA05RYlkrR+CiwZGDl7CIo63/kZ3IQ1jwOwRht0asgmeGbKmqYRpb08avukZFCjXCAfcWwENXbqhTTa7wQEPNi5nzWFEGTNrzzSVmCgL7TcuBDFdwEZwZjpe32T9M2UZeYW+MQEqJOu+Jq39/Bpg+fh2X4u+Yzx0ZyYpMA/YkObEP+ZI1i3s/SpyyyGR6AH4cpA8hJ4cEyAErlM+rcfIWWrTgzMlLJRwDN7xHgsX/cUCUjcGTWwuirfPW3Yd9TSJG9OSZohX9ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjzJyrAc+L2v3cekUBG7b/K0eoBAA8gnGDNXdZ3VSY8=;
 b=fKPld4USn9adoalJ6eG3Ue46bWEu/3IId1eDooXwsAiF/AacW/E5bpCmOvzUvhhCGWinD6lBTmxeXQx7f679lGktd8j2aUm5ir6yTgcoXjIILEC4zd4ieXIm+Jk5+WnJplGS5l03vdqHPlGghQ9pCOPTcr8UZWabdjscD263L7dZAFocrQm801Kpw/lBckByN3VXMZj54Zky8GvmMfe/Uogw4/hy7ak4mZ08P+c1ZqZx+475WEpzbnDzcDAZb7nwXaj4VIC8AjHcGw178LXSqbT0Z1eTrKg0P7gzJuAPZluf5OBMkjuKZfIMpfhVW1E8WfoM/1AVTGMTwoNEr9IO6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjzJyrAc+L2v3cekUBG7b/K0eoBAA8gnGDNXdZ3VSY8=;
 b=IFDiQoi+eBvADcB73aocfDSdDbd1DDn0x+/gtwMLZPcxnmqWES56CUJiaMme39OgtMeAJXL+KKEoyu1LK2HT52AuHlDwkEyqe8iIO8ldqgkoq4t9k49WLgcH4PRO5bXx/6imhp+lHl836qhyBxb+19asR4eeXDOE7MeTG/a8N5U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:41:06 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:41:06 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 14/19] xfs: buffer pins need to hold a buffer reference
Date: Tue, 13 Oct 2026 15:09:43 +0530
Message-ID: <671f30fd39ca9070c7653fab351229af5e0b30e6.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN2PR01CA0135.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::20) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df83296-ce2c-4d77-8380-08df290e1ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	KYG48DPvFcq+wxMQXTgD+A8r6L4CXOJ9G/SiUoiNiI08KGy9DCe9k+mQOEERy1Z8zSmP/ipcnB/Kr6PcO7GCnC7yT2g6dLF2GO/xtsDdJ2j2xeyE4wgDceKudwtcIRFHmNK17yQplotQQeLnWKmnz+h548C1hFlkTY7lFx6U9DAoY+U4cbEDPQpLBxfPrvyFGSwLljKvuDZF8ojj+zcrMGSzsFBYINUa1BC3ATGFrHeY6q4f0nSI6Xt6b7pxcdqaOLvuWPfnK6lWAAYIYP+tJOdNJjMEOjIqzhdKO6Gqx4/MzrmuIUEbPWe+rGuRoxrd8EBNkJgZEsJJQM7TsGO0JLccxziYVTjRh4tp1DeJKfRpktxZXNwuetgpx/MkCyyldZ4YQEXUnIbyjAebZweqCzcIShYc0lQJcrkPoL8HfpD/Ax35e+mM0WG0NUIJOFf2jlU6TUEV4LTRqHCxCDaeQBGc/7c8gSzi/lk0a/uZrBK9ygCQHcd+PCo8145C90jRY03b49ls8sV4DjkrF4aAXnAhAAmX0oexOcGvbVI3DyZ/oil3IJ9oA+u8rgjJKPvKF2EkhZui5K2JS81fAkFky8J0eqYWfJYPkC0pEvFm7bhtoHdJ4Ai2wxDzUcdOIZU9PekQaCJah/UPosLd4MjuPA7fzDzZfbhmYZAppMhj6MQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?flg2Kza4V6KrFF/Fdbshb/nEIbQWV5qJR4/iCr8ChTF7ma+PL97lYlFa9BHA?=
 =?us-ascii?Q?9khkns22AVUniGP5LfulbdaOXrrZ0+/JicERXT2teRc5bHd46tVbWITfaSRF?=
 =?us-ascii?Q?F3Em0YJvCwPI9/5reY4XmMOq4YfrQJX1XXbsNc+d4Zq0loWkU2tgrDSVfasN?=
 =?us-ascii?Q?kS/cBd8UdCdMFx+DqzOB8ny235MBB+u25fKjVEEgfeFKCRwgKeko2tExF4Jl?=
 =?us-ascii?Q?AfDHJp2HyoedOU7UaeekTWS48d9qRENudBCD7BXI6zhsTob5k7JS9xqjxt9o?=
 =?us-ascii?Q?xG6OtJDb5N2Lk+lTdP+IMXDFDGlXBidEXXJ6Occ2m1TKWl2g9WpZJR7f++29?=
 =?us-ascii?Q?wYSZcavKwvDyFyAhKndetf4KmQGPODrbrZjThg5XzxlYqf6lmeLlMbM1TxMP?=
 =?us-ascii?Q?kSROJQZJrzHfRUVDdcg71BiLyaHtuW64t9Sux1rHDVW5N8K04r/Rj35M+nVW?=
 =?us-ascii?Q?awtjxPLOXFNlc/JiIwxk+EN/leRiEgvAC+IW3+t6PK7r6W9sI/7XXEBz7G7E?=
 =?us-ascii?Q?tXY9O2wp2g8IXpDD3gWtco/qFVe7Qro6rjoX2ea5xLoPgUj61ZraOPpexUlF?=
 =?us-ascii?Q?2xTd/ciS7CxL3slBlC/Vj5Ba3KQO9UbmYc+nri5tvJISozTSs0F/FBLT/ssz?=
 =?us-ascii?Q?U4JektG+/JGn6TeNMNlSgBtl5dxzImtNPinl3TgWcwodWGrRsmNStDtNXf/C?=
 =?us-ascii?Q?BJv1gyGiCc5JVDlkvnkJ0v2XcRrRIwk+7a8R67ebry3LFzhSV6fJcIe59ZLQ?=
 =?us-ascii?Q?l34NLpnSQGAH/Hx+M/A1zWsWJpjuJUIOFJVqQ93+UhpEB4B30qRf2/xj0DzH?=
 =?us-ascii?Q?k4pYPlpeqnxfkQqJ/sZ/LBDQOQCoSS0xPrSGFratrAew6R/2zpA4CxQzeDH2?=
 =?us-ascii?Q?BhnTZewlpKTD6kruasJYq7jL03z3kyT7qJvhPnOgUOkb+rk600k7c8FmonDl?=
 =?us-ascii?Q?Y6LoO0iU/gbARTRCEq3tdh6r0b1/uuZVGn6rzRP7qCe6kWJX2SArB1bq10s/?=
 =?us-ascii?Q?1ngvxdmss4oN0/zLbwWgiJoDg+F5CRr7LB/DBHfjALipeoIgOAvV938V51fk?=
 =?us-ascii?Q?ipTmWqpIWMNq4PV8dzdnnnpgY92IbnOjkFUaU8mA6wlUlRTR/HQafWP7rxcY?=
 =?us-ascii?Q?cDxVui0KSU7Z6hu84l4u6R/KKd0XzHG9i18pC1cjr/ClehK3E8pOgrGCih1C?=
 =?us-ascii?Q?ZcU2RqYXZMIw5gThJ9orE6BU1S+6V8GubvX/D1x3uqkoSZvS4nKbMaihEJXC?=
 =?us-ascii?Q?igkQFG+oUOyq8H1SrAmt7Ms7wSwWwQm9YVbuOajXGT8C/7gDay2TvKLLYpSj?=
 =?us-ascii?Q?saN/xPdeiazTjvkHxptjbPyN1B95ZcxTPAm/2QyEtYai/1utRPIrzQ3Yd5TY?=
 =?us-ascii?Q?ynQ3FABgGQjDGAWqhzCG95mn03cRFtRNPw/oMxS5Ub72IdPEsw30m2hi0TJj?=
 =?us-ascii?Q?/5L39vlkUuOIqhUwR+wPj6zzyldj+l6j8Jw1nJMT37ht/IqeuwfeI1bHNOM0?=
 =?us-ascii?Q?dxRQLjl04y0hHiN/h9JIzIX/O+GToa2hyy3ePMKbBj7zMvpftbUTP2M8DAYd?=
 =?us-ascii?Q?FJG3CAxdH+kNGA4WVNwE9miWLa9M9LeOUbPm6hCV3bZHwmDByN+/XVYYoGiT?=
 =?us-ascii?Q?0zTnirBgfQAWBwpBDg8eSYxFxcWInUoXeyycF3ZROE+sQI2fhXG9xb0YnCei?=
 =?us-ascii?Q?kV/6p0l3N11R8th6Mo8+DOgyK3NKgMAo31J7vIzB7YnP6+8MTSMtepSRL3Xj?=
 =?us-ascii?Q?yqJ/s+iN+I3XXI+NU0SFFKHQXoobVXCA1QcAzMFiKWgSPMr+LPY1x2kfG4lU?=
X-MS-Exchange-AntiSpam-MessageData-1: x0rDJrVjChAoyyqR0gxaBuMRJjj5uI7OuIM=
X-Exchange-RoutingPolicyChecked:
	HhNNo4gNCpXI+j2PSXGsnnEJLVBUClKkZmpVrhvrrCA9QbkrmMYNnVSQJY4zWCGUogRNkuC3cKxCNk8V7jZsXaPNzGd1/LMj0GSq0Eu+559JLAU/FLokLt8ZluZSC2djuQOLAQbwgWqel1Zkrjc8omjgXL9xmaulKHv4JtLkdSW0Yis+iNdstizTXjtWbdF42skfoqMN1082IC7esyxjT9W6uZqVZcZibEA7/pvcm3na/BZNVRtYjt+kRfKvnRWVUTy9z6mAALSg9d51LukHfzRNcbMrbxcgsJhmmrb1nWMYXl82aOhlfPfXQmWyrxQ1rOZMZvzn2NGLU4pkxjJqvw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VyKBLFNeveQ/jZHWvFRuCicjcF4hWAckRBXiS9594eCdjwrm3cO2WZEo5R+xgTE/oXYrLElaoyAqYaPU46ARRE/y1M+/kN3xWp8dYBhCnBBy1KCJSNfnQNyqBq/vukOwWho8VDbH6PvBrytHzDN35On8GP+DysoV24ZZgmxT0kd0Y0YtqCHS/92lPB+gugI6vcCvyksxZA/8KmdYwV6q9h62L+w66t8ckR+Lu3YLmkQPEwrwmc/YcajHwL9B5e4md88DH81PoNW8NoNTWBC2WwsdIfHXXZ4g/3I2X8bGWBBkL0LFigV9iEqL0fm+NDi14uWFCQhwwcWCdctuHOUPgK9+ySJdqbq2hVKqKVxbofevVKMvroXNoxj6CTbLShPxPqN3a/RLO6hWIY3lp81+Ex1Itup/8eWPWnIwW1DCBbBTQWcVqCKfl7U7DKSieht85eoiqCeP+uB0MLc65FrC5UtJNNSi3Jv+zYqmnssGmKMmikzDW/H6t1vAjAEKgtzv/4dWUUZ+4UzlYkeKgMYrRDJX8kJhfMDNU5BXH+9nouTWGLHpgGtzzgmo2dxgBzq/re7SqFQrqBS8TD7Xin8KqCxiOe2gWBN26ki3KWDfS6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df83296-ce2c-4d77-8380-08df290e1ab4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:41:06.7670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQuWt4WUH0sm7wUtuOatM7ATASDCb2a07BBkL3dA5bZaLEKffrFOQQxc085s3ul7Yv28eZsUfHWpUd9VX6mfVB5VouXcA/Kfhz47LcjYJpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7mOolmYXj4jb
 Nh6ikcSWJwzQnqkgGtROy7x0pjTffLJsA25qqTsTIwRavNnv7tFWkqRZv7768+1KKz69woF59kc
 skHsEnmODO2TMC03GKbOIq4MsC8lrPvwZFtjw4QFqAsNp9CTK3av
X-Proofpoint-GUID: 2sivKiHMWYyAUwBZPiphd2cobGwxCUG-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8o55kWym9q+j
 WLYBHO7WHyzu7LypmdPx1ylGa2ai4cfNZfrY13CQKJYnTDCy0+xx5TCbFSdz2ftkOaqJ660+Yjj
 2gsXvSv/Mv1O4mQno4l1JEeL4d6+he81VIfROQIEwDJV0tPdwZslIcGb3640VIFSEeKEh6wq3pY
 ayseCT1pXxfJxUxLDnVtH8egiaje/b5VirWe8ague0QlYX6WQPCdsqB10mydxRTKCgGSI/qWOt/
 tEgOIwcGpHR+ZOWgu6ols5g+5tJzCj27aLu/3vz9aBlChlAZIOQ9gq6Wo7KaM8k/WGYnbSwr69O
 ovLg+iMIBwnuABmQcTsQ+8bOtJgv2bsyZw+IdCpZZ9RewDyAECO2vd6h/31LENbpFMmvWk0abQ3
 YOyhu8m3iE0BV9sh+16qrb3wihLh1dy9jEJbb5XZcgL4ZekhtrIe3yv3fM5n1C5D7sQ+YAtAYPw
 rByD2GDqWTmT4gj4Gqw==
X-Proofpoint-ORIG-GUID: 2sivKiHMWYyAUwBZPiphd2cobGwxCUG-
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfcb6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
 a=7-415B0cAAAA:8 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8
 a=t0Y7tUnTQisWX057riYA:9 a=WmVTiCyuxqgg3mnwYu6p:22 a=biEYGPWJfzWAr4FL6Ov7:22
 a=Yupwre4RP9_Eg_Bd0iYG:22

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 89a4bf0dc3857569a77061d3d5ea2ac85f7e13c6 ]

When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
the buffer after we've dropped the buffer log item reference count.
This opens a window where we can have two racing unpins for the
buffer item (e.g. shutdown checkpoint context callback processing
racing with journal IO iclog completion processing) and both attempt
to access the buffer after dropping the BLI reference count.  If we
are unlucky, the "BLI freed" context wins the race and frees the
buffer before the "BLI still active" case checks the buffer pin
count.

This results in a use after free that can only be triggered
in active filesystem shutdown situations.

To fix this, we need to ensure that buffer existence extends beyond
the BLI reference count checks and until the unpin processing is
complete. This implies that a buffer pin operation must also take a
buffer reference to ensure that the buffer cannot be freed until the
buffer unpin processing is complete.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 81274891036602355e72eabbb5184490f354b506)
Stable-dep-of: 816c330b605c ("xfs: factor out stale buffer item completion")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 88 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 73c548d5b593..f864e0b8a805 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -371,10 +371,18 @@ xfs_buf_item_format(
  * This is called to pin the buffer associated with the buf log item in memory
  * so it cannot be written out.
  *
- * We also always take a reference to the buffer log item here so that the bli
- * is held while the item is pinned in memory. This means that we can
- * unconditionally drop the reference count a transaction holds when the
- * transaction is completed.
+ * We take a reference to the buffer log item here so that the BLI life cycle
+ * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
+ * inserted into the AIL.
+ *
+ * We also need to take a reference to the buffer itself as the BLI unpin
+ * processing requires accessing the buffer after the BLI has dropped the final
+ * BLI reference. See xfs_buf_item_unpin() for an explanation.
+ * If unpins race to drop the final BLI reference and only the
+ * BLI owns a reference to the buffer, then the loser of the race can have the
+ * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
+ * pin count ensures the life cycle of the buffer extends for as
+ * long as we hold the buffer pin reference in xfs_buf_item_unpin().
  */
 STATIC void
 xfs_buf_item_pin(
@@ -389,13 +397,30 @@ xfs_buf_item_pin(
 
 	trace_xfs_buf_item_pin(bip);
 
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log item which
- * was previously pinned with a call to xfs_buf_item_pin().
+ * This is called to unpin the buffer associated with the buf log item which was
+ * previously pinned with a call to xfs_buf_item_pin().  We enter this function
+ * with a buffer pin count, a buffer reference and a BLI reference.
+ *
+ * We must drop the BLI reference before we unpin the buffer because the AIL
+ * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
+ * refcount drops to zero, the bli could still be AIL resident and the buffer
+ * submitted for I/O at any point before we return. This can result in IO
+ * completion freeing the buffer while we are still trying to access it here.
+ * This race condition can also occur in shutdown situations where we abort and
+ * unpin buffers from contexts other that journal IO completion.
+ *
+ * Hence we have to hold a buffer reference per pin count to ensure that the
+ * buffer cannot be freed until we have finished processing the unpin operation.
+ * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
+ * are done processing the buffer state. In the case of an abort (remove =
+ * true) then we re-use the current pin reference as the IO reference we hand
+ * off to IO failure handling.
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -412,24 +437,18 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	/*
-	 * Drop the bli ref associated with the pin and grab the hold required
-	 * for the I/O simulation failure in the abort case. We have to do this
-	 * before the pin count drops because the AIL doesn't acquire a bli
-	 * reference. Therefore if the refcount drops to zero, the bli could
-	 * still be AIL resident and the buffer submitted for I/O (and freed on
-	 * completion) at any point before we return. This can be removed once
-	 * the AIL properly holds a reference on the bli.
-	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	 /* nothing to do but drop the pin count if the bli is active */
-	if (!freed)
+	/*
+	 * Nothing to do but drop the buffer pin reference if the BLI is
+	 * still active.
+	 */
+	if (!freed) {
+		xfs_buf_rele(bp);
 		return;
+	}
 
 	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -441,6 +460,15 @@ xfs_buf_item_unpin(
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		/*
+		 * The buffer has been locked and referenced since it was marked
+		 * stale so we own both lock and reference exclusively here. We
+		 * do not need the pin reference any more, so drop it now so
+		 * that we only have one reference to drop once item completion
+		 * processing is complete.
+		 */
+		xfs_buf_rele(bp);
+
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
@@ -457,16 +485,30 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (remove) {
+		return;
+	}
+
+	if (remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure. We acquired the hold for this case
-		 * before the buffer was unpinned.
+		 * We need to simulate an async IO failures here to ensure that
+		 * the correct error completion is run on this buffer. This
+		 * requires a reference to the buffer and for the buffer to be
+		 * locked. We can safely pass ownership of the pin reference to
+		 * the IO to ensure that nothing can free the buffer while we
+		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+
+	/*
+	 * BLI has no more active references - it will be moved to the AIL to
+	 * manage the remaining BLI/buffer life cycle. There is nothing left for
+	 * us to do here so drop the pin reference to the buffer.
+	 */
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
-- 
2.53.0

