Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A067EEFD
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658308; cv=fail; b=PS9N8BLgnCKbR9q1AqWRHLCGatuZd7CgSI3uetU+/km+edBbNUL7s0gvj9hKIxqED94tckQKhYvk5rm25XXsT08v2MWgqXzjmX1i9zgzMmxCDpwktYJZk89sZIK94r3VvaPZcyluTyOlmrNzUxOcBGk/JYCWL4calDF7SQ3h978=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658308; c=relaxed/simple;
	bh=odIrb+HmPTRyFV5+wvPWcOq/omezCj1/ZMo28wLuUgY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QoQF2U540EQQDsb8+pCRK1Vb845OJC76J/RpNZorkfwQ9qeLlflsUnWOwQvhANaFUqzGgSsqq//FMO9kuOXGpm/QfkCaUnJXscBALc6EZ4EwqIfJl+2nP65AhgTc02lP3sz3XzMXJ+hjoLPT0dc33Yca3i5mNOudwz/16YqKmko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bmng1rVT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VpHKw69u; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bmng1rVT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VpHKw69u"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxjqL030541
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=iKFnNVI+opeXzHnKtzNXirHXYKNZUAr8FJmOJXYFdRw=;
 b=bmng1rVTsfEVfn6PwHuJ1L+Y1C9KNYdScRyQwWxu97DeT/iPpvHInTCN+tHsI7rWjkPt
 rqzTzSxf4IdWqJn6D4FbDB91bNyVHb7x7FpmR6K/8QFus+BH7YnlV2dw8m7x08RAEygA
 soT3w6kRWe3y6/7yZQAVtlZiRtwknEacoUeJaqtUdw/8lDvHBCvjTZalUS7r9/dqpymH
 RYFUFSDUuP2G9y/YssjT8AddJLxUqi4lWlOKjL5evr7GTW+oWnlGXpWdzGxrG9e4YWqT
 ZySkjC0HQwABgLWJdy2zbikcQWppwdsSLLvsCjY4e2Kqg9HFkm2+uD4p/ih593w3Ce6T TQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0d26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMke9j031487
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr987uur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBBvuP2aC45zl8p78oF2LxCqTQL554MZNypKo4QvOQ68p1jonFYgA0klv7ZvJaTZLLBlapiXRErSOGVpfJLvGCe8jwTLldQFYcxyrhzCCdpKerqeNyW8RImWstiX4tRzPNYn0/JoLsqq4gIjZ0rCCQuyjf17Yww/9I2b6KEr+zYGXkRz4FObuRbyquJklLsV3LiFs6bzJnkUyp00o8jakAmIliCdq/yPe3DzSLkx+g6SSNZP9rHXYoYGBk0veunJp7i+uKJIoO2MF2Yz9l7iB7sQBc4UmoZ9LStJJMhJX3/dUyxqeCHdwbuKzMfO0In3Jrlw8o+6m9eVvlXWirI8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKFnNVI+opeXzHnKtzNXirHXYKNZUAr8FJmOJXYFdRw=;
 b=HpaXwCaE+EzTThRYmVepQ9TIuNmjT7xVvZpca0Q5eeryMVofFsjE6q8RTRc+VAJTbzkSTUZbvfRlv/iHAm0ZOWoizNRs8IDfa4YLJRd8l93PzhvZE9DLA/RO67c46QGwUOHeytUepIv62S2EU+EW8PCnShOJQrOib3XTtKXF6uj86IggDwmh8cw/e4cn4LwR+60ZyA89Ezq21OD7PoMLCH1tRcm2o4kEcK2IM3Cr40+Ak7tJLf8u7qyonGSqFVzSLadce2VDZH28KgbFQxz64ZPT34PukfuXAVrKgHfS1UDiC8RrqMUQfCHxFa5L2CNTypH9xGkyvkHnufA+oF4iug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKFnNVI+opeXzHnKtzNXirHXYKNZUAr8FJmOJXYFdRw=;
 b=VpHKw69uwYzqbjn6Pz4blBfdDsvgxS7e4ppc0vbsEEMTzXrD33CfAvjmCcanRaDLqli6MUGYRinI7G6CccSp/jl0vtDeng30tXnjl6EB0REAWloMW4LeWQIEbdBdpEFl4UaiQ419zrhgfNrz8Uxgun7bW1auPqZTkLIMrbtNafY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB7279.namprd10.prod.outlook.com (2603:10b6:8:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.33; Tue, 30 Jan
 2024 23:45:03 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:45:03 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 21/21] xfs: respect the stable writes flag on the RT device
Date: Tue, 30 Jan 2024 15:44:19 -0800
Message-Id: <20240130234419.45896-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:510:174::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: a177437b-3e8d-4cbf-1ed2-08dc21ed7b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2GLUSQJECWmCul0rnM4RktPlzJCA2mN+pJ/DE8cFQx0DS+nGONOYihefjUZK4qzo1P8y0UHVIricfUOk9wjUimj+JzcLMooI9TEakzA5u/ORD5+0v4fRZjmTu953gMODnlvIQtXKhl37xdgGJylEYYu4rYSsu6+vJvMga02af9M3N+Xnj9cvfeiymJhbrDCe5yVtuSvprAYomhu2wbf+BnOTMKjhvPNnbSfi+BtCUTNPhzIl9HuM7KLDMGMAg8w2Jq4h20Vr6W+RIM0NOAiljeNqhFau88C5zi6P/xGZS7DTw815FE3OVZgEZ3TepwUBPTZ1v/V1mk4oqDdc2ZVr29nmwn8iUJ2HCRJlOvbH94tbWKrX8qADdiqxlxbkUdHteaYr9Xr/udJqoHPXKySnVdYjrzWm4nC5FPAnzlfiBU7XC05gtNtcdFHX4o257P5gLxvbIqu/iDvafJlKS/AS8V0PqNnzF5eOB7YxHJOv0l+YmOCPCgnH8Uyv1g5EsN+gDB7LcnV0gIvKOIsoL9kEDLYpYETrxWjNVX17o7TuGGU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(136003)(39860400002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(86362001)(316002)(2616005)(83380400001)(6512007)(6506007)(66556008)(66476007)(66946007)(6916009)(1076003)(966005)(44832011)(8676002)(6486002)(6666004)(38100700002)(8936002)(478600001)(5660300002)(2906002)(41300700001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cQ+oFAfcAAXZ/UbTCXvQAz2eDlIJuY/Cek3k5ssHmRnAbUmV6VRDc0yjFq0A?=
 =?us-ascii?Q?U+hXVek8tKf6UYdyh8VSinV8JTcFP/CjT/vwm8AEq/gb80T1J9NKlGMGTBGm?=
 =?us-ascii?Q?T//3LN/600rgczT1/thsTw5lZ29xB/NJOMjsimQYLZXMpL8Yn7BrnkMYzQPU?=
 =?us-ascii?Q?fK/2LgxnKgcdpCrwbUYiouOJHPcfu33BJPJwQu9cEX//csXtvWucLCeuqn/3?=
 =?us-ascii?Q?8Lhjr0Bg658XOf5ljVub7cUFp+egYHQzWTZbh8bPsZKF2YmBpHd1DdXfGYjh?=
 =?us-ascii?Q?FSg9HHWVKwPVj5Ow/UjB6obUezMpybVeJk0TXVDbCx0EoHB1GQHlxbQXeEQC?=
 =?us-ascii?Q?kCyLmC+6xGpPfycO1cJdcaxCzX7VuAXku0xg8m2iep/vpXXI9JIQf2n2gl1e?=
 =?us-ascii?Q?KvWcXYaHbhfQuy9LDc77Q+gKiUh+bqLSnKiif6wgwCuP2eANHJ1S4c1fH84l?=
 =?us-ascii?Q?nMT+ZlNW65FguHnKgmDVEXFLDuyenXxRFW8J+WenP5VQmi+NQ0E9F1vwsAtE?=
 =?us-ascii?Q?8JANao6+4zGHURUP7B5AnohugWp3zGwr4Gd3HrMgzLhqaPJWEQhlBbJpFzHc?=
 =?us-ascii?Q?gwKinxHoeQ3zGOLLec5xWzJZCSUQ613ESGW0LW9e2qCROc5MYoFpX3BZMnoh?=
 =?us-ascii?Q?2C1756rgkppItx7Hm2TAeibB6sdjOXGr3f62XHnDQogNt1Zmja06i0HHXJqu?=
 =?us-ascii?Q?micRfdt5ceHwe7uoQ7oYUHf4DY/v+3iFkvLYgf8kTW5VJ+4919+Tz+VJOjIE?=
 =?us-ascii?Q?PgqDOe8iMPuO8/aL2IYb0PT0scJxxmz9DzEhtz1+hTPpGtdDOUKmFUmnfIK7?=
 =?us-ascii?Q?SyzW91IS3tI2nz7UUKfnaPfl1ohMhsZQqy4J+x79DUOZBNwAh/uQU+JPPX8+?=
 =?us-ascii?Q?QvsxS9SvILHcyHVpKToxukk5IEe/8vQWYJ5bpQe7jS5ZCCISP1xWnEd6krCQ?=
 =?us-ascii?Q?XHIppahRyQon0dHJVzV51Xgx4q7UMX6wws53eaTQWmiYc8oI6F4VldvXN5Xp?=
 =?us-ascii?Q?vu6MHSPCB8/Zw4TlM/L2feBVsF9yLjOYVWhzjh39dutCiL9GtM2hYtdVug7d?=
 =?us-ascii?Q?swUlmQ7jW2+B7GRBh0x0kEnFXb4WUTkzE5XOmtGXG/LZKfm5F3GtBvd6FjZM?=
 =?us-ascii?Q?90IyDMlPIvw8U+qVcwisX06wt1g79t/Uz3KqlafdHu4Zyrr/FPIVKydjjpwQ?=
 =?us-ascii?Q?Mbx16B6p9iwlmKFouatZuOZQPPg8e/xmnAPMtxk4kuxgv2vxToqkNlixJdbU?=
 =?us-ascii?Q?+J05wkhfLTt/lVapfNLKNgSOCyKbt4CCu7+nBCxuu334+wwl9QRYH9l7rYVm?=
 =?us-ascii?Q?bPMrSkTjkXhT/esLMx2EbE+3az/f4rctuNONV+Lprte/0Jl0BkW+X9sH36Db?=
 =?us-ascii?Q?Bz6ziHQsJbqRTa0MMOU6yGcJcNaXHuWmuPcQu/pOPQJHDxvcIZ1VdaH2YX2U?=
 =?us-ascii?Q?9DfehMzqk+u+er7wpuZyqnzwJrhe51ailG86MvtFMmG/cHrqWeK6PUFJKvCQ?=
 =?us-ascii?Q?Z/IRQ7DCTeyY3XLASh/CtQhwHTgTwgQSvtU30c2s2EwYQw4KLbYDRiaJcLrR?=
 =?us-ascii?Q?vyZMTD5XQAIiXrybJOXgXC6CnYfuaW0ujDDOUFFaX96HWdoqqLVySnntJESe?=
 =?us-ascii?Q?DEz8tY2q6ctDxIt2gq+gNgrAOWISuUCeQDr5RWXMkCHzelmTUMxY51c2QHIF?=
 =?us-ascii?Q?YjBC6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KL3mbhUG77x80NIM4/1fWDY+FM1IPcWodCZks9xKyhp9HWb+6Mo1SzmBpX1IwrxIt30UnLM253qzUOTsu2F4ctqb64e0k7yMYCB0+kRPcBuhMt/1GyoV/+dGPUKcUEJuCPrbYR0/1AGUoovY8FzD00H1jKtGqjJecn/r6mpUjbulu+3+1/W/T9fRAyypp2fqVuEhqfhT29yQl40P4C/V5s524c2XFAgtATjQl6mlzGdkwOD+ph06pFD7BBUjdsWEibHhIPLfmO1KvRqXh3OPsPL3iOx1RqhlyIAzcOmNJusUsGpnXMBVE2HVVCEBMixngfv7oFLLPpNpkkBKeJmWqXcHwCHWbQDbGIkA4YlhjzERrsU39vjeYkt/kdnUchnGxCit5HO1AKcQ7aQH8IazFyb4/lUJ9TRJTeG6P4MYMYkeqNqUUVKLN8VPidH/8VO8HsAMwRmEyQ2NWlPosrAfjPs8mpZCIsApEhUC2gsxm0yVGxmz6Xdhf/tKrESNEXY3YDVTbsZ5lYaRadMfSDp5voNZEpP1yh35gFWSC+pgTvwIMZUfbM9vsT5e3QtjFeutzhHqXZa6ypTyaUpCBawBP5jIIZBNMuLT+LhvedPQ6oI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a177437b-3e8d-4cbf-1ed2-08dc21ed7b0b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:45:03.6193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XUwIDfua/q0N74aqrt3SOMR8vd4P5CtrLPj6Opz1ThzRhzoS2Heoz1i0vlN+5zhyBEdl+BIkByA10lVsT/tkOzMhjeGDEexdha84WgijKtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: 0cd4Tkk1hk9J5gFqv_KISFiLHvvP_td-
X-Proofpoint-ORIG-GUID: 0cd4Tkk1hk9J5gFqv_KISFiLHvvP_td-

From: Christoph Hellwig <hch@lst.de>

commit 9c04138414c00ae61421f36ada002712c4bac94a upstream.

Update the per-folio stable writes flag dependening on which device an
inode resides on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-5-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.h | 8 ++++++++
 fs/xfs/xfs_ioctl.c | 8 ++++++++
 fs/xfs/xfs_iops.c  | 7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3dc47937da5d..3beb470f1892 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -569,6 +569,14 @@ extern void xfs_setup_inode(struct xfs_inode *ip);
 extern void xfs_setup_iops(struct xfs_inode *ip);
 extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
 
+static inline void xfs_update_stable_writes(struct xfs_inode *ip)
+{
+	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
+		mapping_set_stable_writes(VFS_I(ip)->i_mapping);
+	else
+		mapping_clear_stable_writes(VFS_I(ip)->i_mapping);
+}
+
 /*
  * When setting up a newly allocated inode, we need to call
  * xfs_finish_inode_setup() once the inode is fully instantiated at
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index be69e7be713e..535f6d38cdb5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1149,6 +1149,14 @@ xfs_ioctl_setattr_xflags(
 	ip->i_diflags2 = i_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
+
+	/*
+	 * Make the stable writes flag match that of the device the inode
+	 * resides on when flipping the RT flag.
+	 */
+	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
+		xfs_update_stable_writes(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2b3b05c28e9e..b8ec045708c3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1298,6 +1298,13 @@ xfs_setup_inode(
 	gfp_mask = mapping_gfp_mask(inode->i_mapping);
 	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
 
+	/*
+	 * For real-time inodes update the stable write flags to that of the RT
+	 * device instead of the data device.
+	 */
+	if (S_ISREG(inode->i_mode) && XFS_IS_REALTIME_INODE(ip))
+		xfs_update_stable_writes(ip);
+
 	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
-- 
2.39.3

