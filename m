Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235079953
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658292; cv=fail; b=p66bYgkQVs+0A9YEtprvKB7mBmEx4fpMPEIe4U2OvLNsLLywAXv2HydyEsWHghIZL35dkbdPPrJsNFvTCrPwp2s1u2C+c+J+6ywvkzy3BwAXaD1Noriafkwj9ykGkHMcTBTvWORIssWc/Okbl9uZuaYCC+ntg/BOvxZMzagOr6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658292; c=relaxed/simple;
	bh=QGNaP4SUinhs+aAR8gx7RywonLkJKijV3dp3+AJOmhg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sI0PbiGWHYz8IhR26lMLBSlEoXRhGEMAbrsBHueIvw5yTm4Iwt/PFfzsFwlgAS2RIzr1SxkRXQPXfAQM75AwnKr8qRLfNuHcNrr/qqpK5/4nJcIjJqu5BWIzTtmayzT8Rpvp2hsGVaquOMNr8EpTA2+/X6rgEkecdmPWjUM5yDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eUR5Qs5A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vBuYwiky; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eUR5Qs5A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vBuYwiky"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxubE030724
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=3C7l7KSxJHeafQcIe+0S/PSdCveKAoPeYuysjY9HKYI=;
 b=eUR5Qs5AJrpXN6/RliBu9BbgT4bS8Nl2dcyI/CVdZ6m1sxWkWYGc8zLjes6B31bjxiEo
 R4OkoCbbKL0hGljR0nv9RTsxUZoLOrasC1PQUAwzWaBs7mx0b67+IpkxXMZHXEod8typ
 40rZfsW15ipA+8TJN0hCtr4/ildeMjghqi1HHtZzyZPB//gY5dF6fsWmlXqJhvK/hchE
 P1eAohdl6pvlZddEftbjhRyCZwMrdUoY4eiFPndUxyGBhCzmAK7+jnHyzdvfiHZDw0sw
 kaiftq7S5ApYJ8yFYIxC2PW5pSw6Y1PPydzIAbO8CCdtrOToO8wBd+YUZVKM+OY3786F GA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0d1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMhiqZ014647
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:48 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e97tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljrxXv880YibfsEsQghLumcSwPbtWSuYNspqezK5l4iV+mmQkEqXMLdJ2DQmnb1ZILZXGCBc4JRudps6HouhNE27Yg+cPbjXNylZr24GZ+bXIoqchbXd0JFYphYNV08z73p2bF9EE3Rw7kBkgRN7nkIfHBeYvPhDt5Wrg7UXdjIxh0WLdkoK4wBQAE6gzLHkmz65QgGh1C5qpr/pI0x1+5RHykSP2Uco8h2POMVhGY+fbPnpnLQajKaJcrb3oBz9jTzGRxcAO3IJdF3kDf6CymZwLETSPXRTThvQnui+HTOw3YrxZstQORFiwqx58C71yr87hhfmt2lBaBrTsVY5Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3C7l7KSxJHeafQcIe+0S/PSdCveKAoPeYuysjY9HKYI=;
 b=Dnv8700iFrawOLZwrB9FJV44FptE4NchKq5vX17MJ0sV1Z2r8DkheX1Yn7J/a0+nqWZBUTx7trM8dKRShg9rHBX5SGaLSYq06u0NhS8wO7ZCF6txByxc//Ctk3+z1zN9nS3IAoK0ZJN2c4qqaDw9RIfIgOQDiaq+U6DIwbwYcbzLex+ws5eOYt0mFANhsYEsnrhzwq4Co4w9qdx7mzA//oZevJYbOKWCLr3IuDbOXHwgCYx1Uy8/6lFOvYf9cnVzg4TdeZ3/FugNYT1wQgFfQmUhc/umgtGatgNRcyACE3+IPulxr/iRHm9moz2cCkdLY8/Y2dAEins1vis7JyREkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3C7l7KSxJHeafQcIe+0S/PSdCveKAoPeYuysjY9HKYI=;
 b=vBuYwiky7xJ0TVdnRzHDliWrv2ofgsCMHwq5Djkav+vjKd8d99ecFsYVTf752Rs66RgC+wGEu0FhNTaTb6BM+paxiksmAlXOjbKVDz6livLxYREk7UO+Iu239NADvkZ7xmD+x+kmn9vBDiYoF2JoWx3bjMMBY5UNrhFzwmZ8ieU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:46 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:46 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 12/21] xfs: only remap the written blocks in xfs_reflink_end_cow_extent
Date: Tue, 30 Jan 2024 15:44:10 -0800
Message-Id: <20240130234419.45896-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:a03:331::24) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a73be3-1c59-47ad-16cb-08dc21ed7108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	fKCFoI2PHRqCUnG+yZOvjZdxU66PK8iJrr4taCIcVKouZD0UeVHlVEAuBmnl+uINDbhRTpbbGhq5BvkKAcuhu1ZNlXL8OxpA7dLXnN0pBbKmbXcYYKWWhTXUSTJZ8Mw3JwZyWGdCk1zu65/6/QqS+SXg7S6UqLXkwylcCPAFlZlpVXvZIe4rXVcPWXacDwBxMKQqCV3dEfY42R+gRQBIgw2lyCHZGw45L2LOV645dVFlqdjbIPmD/xy01GhWQiMe90UPwE5pwMj/2Ac+QYIS9dbHKalAVBvX4sL84ntahdeJSagaev4wAJPT4CjQSAihsVGCyGHgDe3AHIROs4as9SPrwB8fDRFFyao43d4jkrvNYVCCY46hidrmJmqN+rSBzVyPhH6R1z7Gm5lpF1hldy3CWezHkuFK//8ob1pBzcSYqDpbc4K94HEm/vwi9OMdgVLVOE6ruOk9AV/WE+IkkV0LuCXD8rTLpmEMDiiY19i1/Q6Drb0XLPYjL659Oowbm91wEnMa83eK4gTz6LcAo0D1+EtMnjhM3e//0WUoy7gSjJkw9rEKYtNtk3KUnck/
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?DbSgg3y3iCUC3ImW1X7QcpokpShmNF4OZ7+FX6iN3J8seUS7oxb0+uaqmOtG?=
 =?us-ascii?Q?a0SLenNbjBZfR6SL/NJQOISmciwZoZWCDoD5tuXMzrbFsA96OsLT4PYCBVV9?=
 =?us-ascii?Q?D5tqzhv1ihot8XyJWddZ1fq/X1LerB7UJbzdNdjwxl7kKh80HNR2l0kTlG4q?=
 =?us-ascii?Q?YDTLuVs7GhlDJ/hZr7SWvMRgnqKOK2oMWHXHsUn9CVoSXdYo3zeln9lRiTqj?=
 =?us-ascii?Q?KjaHXh9FWm6AV6rmyzjlJCOucpqBzlr0zyVCPwA97ZyYU80TOtLnE+nfpFIp?=
 =?us-ascii?Q?6ML0BLwDAynJK470lcbv7UlmEjlE/K7bMCAYL/ASNiYABl/vVkmZjrLyca1m?=
 =?us-ascii?Q?UvSixKL8W3nZ3I5wQnvXUjUCZadwDi+50e32Hx/MucVxh8/KgrjWmNT4Ptzj?=
 =?us-ascii?Q?MldeY+Bm/RZoQjorlIe2W/PQ8ERKr/aeex9F4kFNMu23YIOsPzBV37ZQqJ2S?=
 =?us-ascii?Q?5W0mQYQLw3ROEIPIJsShOIh6M32IxKCHQhNgHFTO18MFLyga5JRWMyKAO80/?=
 =?us-ascii?Q?v5IrZBUlgRSN18EOve+yAwhtisxkvIhiLrlm1Cn2dLoP+M/4YNalvi0wPjQE?=
 =?us-ascii?Q?BQm0YfzNuzx8NJEeXRbwIbZpH0BpUveohWa72dHKgTKa8VtHxAIlm99ySCbw?=
 =?us-ascii?Q?QID1SqB+hO9V4TvXGrJha5WdwQBZeaY47V9l6IiisxDtgckP/aUdogp3Mjra?=
 =?us-ascii?Q?pSvj6SgZkrXkswRff1wUjI5/TAWqfHCEfUtEFbOc1H8AnGGV37W+Hs6e6bNy?=
 =?us-ascii?Q?Lxp+lpzYj6vduJEMu3ACSZRxks64DhUGQ0H+FtHgZlW1ibhETyZLZAyJUQUC?=
 =?us-ascii?Q?eftIghl8kuxomUKWHs9R7GHCfmo3r2frdnMhHcRkogzc56hDolcjfjQLy8uz?=
 =?us-ascii?Q?0uHAfDNtZQjyYgIiOYCQ3MUiPhPezvncAcBKnaQ+PgZ87VfS7LYCNurNTzhP?=
 =?us-ascii?Q?pf3ZSllFHw8ViFbOni67KFC1c2PIIFNw42TDhzepIDT8PbYTER7N/cCJyzQm?=
 =?us-ascii?Q?TOZM++dyU8uuFgKJixhTx3aNjmlPZLjDIYHYqHTHC8vYiPZrCfQ8A4SJxTf1?=
 =?us-ascii?Q?Uy+K1elBCDF/D6/aahCsMwjfkCwRlbwu5v/7U0Nl/xcsdjSRsn1Be8penxdt?=
 =?us-ascii?Q?jGpJjvWY4K5YFwE7020eyFPs9cONRyWEBdqZkcKL4nJK1aLUYm5yr7ScrDqY?=
 =?us-ascii?Q?QJ4mLQ+O+hPK1C1V5LXtEKAXL4nS+4daRDSSd69UKchKRfNLp9MnzUVNp0BS?=
 =?us-ascii?Q?O0WLUjHmvZWwLTDxDqv1UsLWdl3B27kEK1bFdQxwyQ9BhhU3P0xJddXwlLQi?=
 =?us-ascii?Q?Sn/9sq6JOK3+6i6m6lr4nmbSecjh/5sNmfjWTnDtZdmR5O/ciOlPkBbG5zCP?=
 =?us-ascii?Q?Q8hjHen3vIivlWLXF4b7TZLD0MsLnSDbaaoJiQhvWO0PbHWwUI2euyRKky9P?=
 =?us-ascii?Q?jxy+ikhzuTH99KbCkbPNDvP9zzQrtxO6uRmozHPCocJvd5P3SFbjFeE7ywnQ?=
 =?us-ascii?Q?Ra1AzVGMZS+f6yHbUHy6MaKtrLcww8a5CKaaDkkRVgIxYv3PzPNhoPOmv5zL?=
 =?us-ascii?Q?sMh63dVn7HzLHRzzEnuzzCB5uxn/vD2xjzT/MKksXGDlTa9VY0m4Cl02Txfv?=
 =?us-ascii?Q?KzcsFqqDQyp2oCTNq8GIPLfgRD+T/KX/OsMUuBhATyn3MXDQYAnRQhihO4x0?=
 =?us-ascii?Q?HQrE3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8wNBByzdF6/7dq/V6EeEJ463dDx6NsUhMtJvrSA32eyj/mWB27xUME8cO50qZJe0uA21F2DmTZu6bOPXyCWXjlfPDn/nM4+v2dYz3IlluvWZax1fuk6wsIjeSEkOqKrK5k3f3vpRM23RJJa1WZtfUzuYYr1iaO8y690Dqz45+swgcUY0K53bPhvJJhvHubqm1go4Z/yzI3iVf29bggfgfNXj4qZEN+C2Lgb7fRdv9X0p6RIZIxVZySihE+HfbTuzvvjPD4SV5CuOvhq8S+ngecE7A0+EOP5ChixkelkrmkQ0G6WNp0TXgTPKTYYFoPtABrBefKoc6N/kNiKheF7EkkqRGxczC925OqUm5XJoFNuSIuWT/64tAfQA5xGA2ynEywwpwVf4cwWRi+tWUgf9JbfSLzB0/lwULlg3EtcMs5fuNTjXQsUhx91mPYOYOvMOpMxgABvWAB+qLS8DGE6tB9ZSbuaSAQb9K+IQ/W9e3BE1mW1JwlWJ1wreX5NYgfQs0jJu4M9K/K/ZOzCCNavh1vaScpXPX4QaRrf0NcZOESEWQSoDsnYtbKlWwMh0vbaM0ckO0kZFLDwFmo90G4548Bu3PQaSBJ2WJ3zVGHwc9xw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a73be3-1c59-47ad-16cb-08dc21ed7108
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:46.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BhrhaikdqG/duPuJhIq2+824jHGNziCZmhoagSRjlCfdezwCEVJAqPCshDduJtrC2gDzmaPDPp7jx2WQZj65lOMuXqbCqevPv3V0S+hOYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401300179
X-Proofpoint-GUID: KCPrr21YFdxFviyo9tXhK4Uiqfrgxaam
X-Proofpoint-ORIG-GUID: KCPrr21YFdxFviyo9tXhK4Uiqfrgxaam

From: Christoph Hellwig <hch@lst.de>

commit 55f669f34184ecb25b8353f29c7f6f1ae5b313d1 upstream.

xfs_reflink_end_cow_extent looks up the COW extent and the data fork
extent at offset_fsb, and then proceeds to remap the common subset
between the two.

It does however not limit the remapped extent to the passed in
[*offset_fsbm end_fsb] range and thus potentially remaps more blocks than
the one handled by the current I/O completion.  This means that with
sufficiently large data and COW extents we could be remapping COW fork
mappings that have not been written to, leading to a stale data exposure
on a powerfail event.

We use to have a xfs_trim_range to make the remap fit the I/O completion
range, but that got (apparently accidentally) removed in commit
df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents").

Note that I've only found this by code inspection, and a test case would
probably require very specific delay and error injection.

Fixes: df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 658edee8381d..e5b62dc28466 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -784,6 +784,7 @@ xfs_reflink_end_cow_extent(
 		}
 	}
 	del = got;
+	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;
-- 
2.39.3

