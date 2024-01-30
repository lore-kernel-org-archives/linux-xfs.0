Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7148B37708
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658270; cv=fail; b=tzojtNlcfXcVbM8yYvfF9c7Au6twSyZKPtXmKa5WSFzgTBeUsah0XsuT2ZS93tnUKHfAjkhf7EGwOFZPcw3yGCGVR/ZZa9teVRj8ofx6r2wOAQIE7WKKpgMUh82yyq9FbtT7c4/vGvrma9DShJsx+fJ8lx0+DI8EaX4yOn0XYhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658270; c=relaxed/simple;
	bh=eG8awgkBXJqira4uL1/ZlPFLa/Fs7ncDGlTeGM5stEI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vfai32vpx7mBpx5t1QabwwwWs567EqsFo0ZGGUojoFZlO4BQ8TvfCKrrCkuFLMqPPjO6E4OFG94+b5Kslqad7WPQiVSNgv/4jA9tfhPnD9giEXyvoFNqkKUM6lrQK/ZWqWVnd4Llgt+jA1V4rzvUREPPzGqMvsbX8SuE7ffmRmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KLsCIlXf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l5mQcAXE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KLsCIlXf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l5mQcAXE"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxSTD025981
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=WtMU5f9cz3oVb9hB8U3CqlFrG1In6pQNeER+/0nkoMM=;
 b=KLsCIlXfbkC8BDlS0AVL66mgL4DIP2ddHZujmYN7TKQjvibCQAA2kHJAz1p65fXIRku1
 JSBtWCariEkNV66WmRzpliiuoIar9fkJvG7OfEVCKIyElmEN7XNc6QDBNgiHUxk6EVGf
 3KdNQgYs7qOnQxK2bPwXBNMjPsxPE/S+PmZ42/cfIXP1vAwmS8MXRu4Ffb0fREf7GAWD
 tx482OO8/3gmDMGp11I67MpfkN1H6/8+djzIECimtDVFovL1JKA8GrD20m9eCE4ZO+D8
 ggnKUmHK50cFe6RidEQf7OOx7CEjAwnEBgdhDHLksmVUJ1LJe5CCmSuC69f8PSE2EGR4 Jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcghk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM0X45040253
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr987yc0-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXxM12iO2G6vVmmVcb62LTpWY0JMi58ikCIRCLaPzrWQepnDDkNaM6xWY6KGzP+Sob7u3zxl1JbByULfur6sGZE9/rHEguBb+vXlMXjdiNc14ca7jv60urFBPkbJscHLZeMZIJ1KGfxZqg0vvC7s2aESKUZx5uzLf3oecAmzAXSSJ/r06Qh69BcywuQC6bTSxJ6fjbFaEYhstKNuQzLfzlkAoFWLkDdJ/U2Kj38ELTKZOBeoxzNIH4nrAvOlzf2S+DNJRa4gV10tZlg/4zc319YBFzAhUEM8kni/5z5AsCz1an3x0e7t0BlHk6zbg0Q2GsXh2z6H4v5gJ7B5/Hnizw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtMU5f9cz3oVb9hB8U3CqlFrG1In6pQNeER+/0nkoMM=;
 b=ZSVvBPUbv0nD4rm8jSPLE1R62Teh45Q2OQJwukIMptbMveBUdO8CWc/gKQzLqIJfwMGTE46SD5p6O+jdD4U9LNoNFHteBSMXzb0xqZjbbG8eCy4wjBVigo+0WZIbdXwKAQ4sLJxxIeNqNSQ5MfnxYe+8CzyMNWM+/S46Xx7DyZr6incTXKQ8z+/RX4pA4TzJ7r9PyGKO7FkWm3haBKpxEvvkEUBcyDo2NwBFKFlg1/gVr2f8LzYslLMsR6g7lROKj45XzFHObpFleFS9aIn7ZiNd8mgpe2pHBNHpWRTgO17583YqILRxWsyg53IfVsa69vlLb9grGIWqnlj/7J2SwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtMU5f9cz3oVb9hB8U3CqlFrG1In6pQNeER+/0nkoMM=;
 b=l5mQcAXExJ72ocdn+E7Gn+krLRKmVfGF5bIEXDx4p1wWAygG/ZeLju3JzTp20mlY0gqEGu3hQ/IT5lLhmqrNKXzjJO5gOXKHlJVEk6zZetZtbR9VIeUWlYg33YOrL1eo23Ka7UOQyk+knzKhfyyhzMCMjaluvUFEs7hTeC7QKiw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:25 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 02/21] xfs: hoist freeing of rt data fork extent mappings
Date: Tue, 30 Jan 2024 15:44:00 -0800
Message-Id: <20240130234419.45896-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:a03:114::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 1915f5c0-85fe-4fba-4332-08dc21ed6416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pYo4lYSb8kv7/eA2LKsBRoMogzZZ1NEVonsmoWTscZCVL+vZy70LKnkO8KBJmHDegh5gOyqV7Sk4uW4EjuDTpJtiP8HvsBFwLERtD1piCtybOX+FPIUn3aA3BV7MmUwCWKQo42AqSLtxG/3mBgqJGbwsLwVzMJO9abPj4bSTjygzrqPYn0SMszm5a87Y5eW9Uo+ku+MYYfl8y7MHqIImWTLcxeNm2ME9sudweoqWsgLhKYmSPcoHG5BdDCm2YlT0im/0RnID+f9WPdBJvx53QCFYN2vdynFX29+pXXGLsetdArVXsYDY9TAdZeCQx82nBbi1k/uC2vNS+Zy0YAfdjMK7ejMOyngaN/0GVJCiTxvPi7iirf5sXTj+YOl5V/ok631sesDWWv/OiwU4GoYdL/MDZ5imEN6+nPBER6OkjXXCKXa2chiO9GH6mK13GjSLFll1YSMCHjTFWeH2IzvCNAegGqxPMMdcBBHgUYEtsfcLtIMHshyLs3T/3qLvrS6hvCjiIzdzmizZQOSj49LRmqTUf2rZIK0FXSVTmdRMpAADVE/jfkP+L0g0bN+WfPLP
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?EwaqaDfW7DdFnR43YUqLIkmQTWScWCaUoIqGQGbOGSP9mWfaXxaKyvbaXj3c?=
 =?us-ascii?Q?tsXk1CApJ9glJ/NY+R0a4k0DMec7RDXuP8PPhD5SRqmEP6hi9ecztSku0OLq?=
 =?us-ascii?Q?aLedi7HVjEuMLma1LT4A0/QbShvIX9uS5BSdvUICmu+p6LuoO8+pMo/8xUEW?=
 =?us-ascii?Q?E6zWkQ0dJRT8wb2pLr/nRnG3w414PNQ2EuDSgVN80ZtlezAdxKjk7UlBHcJA?=
 =?us-ascii?Q?Qram5LOmDMkHCQrITpEYcvcFPBylqRJ2bYskYZ0Jyd/9xIGPElyFWemWugn2?=
 =?us-ascii?Q?NezGbpQlT7taFKKMt+de2F5TtoreXNF7esNyrrhPpgg4qJ3QhxQbXFSmT8Ck?=
 =?us-ascii?Q?GSXKHTGD3pE1uCCPz3Jn3wQskJ3EpHHmQwupC/+H6H8kYkD2xQ7UorhKNkuH?=
 =?us-ascii?Q?SfYg6+HZgNNVGakfZmChVUN4lYEbde6Xql/HUMis0EnjGRF2GH7AWgfE/zHs?=
 =?us-ascii?Q?NW2ea8Xigm74ZYu/6vot9qZH4UadDl2T/REmsyQ8vRqUNTW+tPQzKYCxRfaX?=
 =?us-ascii?Q?hOEXUr4cLyqpBkj8ydyGWGj7F2HBINPsh8+3JcVX7vitKcWuUe/73Hj3me8I?=
 =?us-ascii?Q?ywDPpojTLR+1v0cPnAJUtElQs4h2vw8nGO/aeAAU8jVESkRkpEboLOVeNpv+?=
 =?us-ascii?Q?Ug+tmZAnhkIV50GeA3agZLhxgOBl9ae2f+SXmXKq/DhcCFLHEZXnzHj/uM8x?=
 =?us-ascii?Q?pcKAGRVshvKP/U73FKD/ldJKRUyKzPshqbbpmGXyAb0217H5MEEyvmmSraDw?=
 =?us-ascii?Q?D7JmeEAyttgZtO/QVtSeOk5bmstrfIz6zYM2K197wIaiwalJsEvwviF1j6Y4?=
 =?us-ascii?Q?aHe8ZI1B5TAPOF+Tyfr7qbJ8ATKMqQ/XFGjiNe05wuQ2DQlmVVfG+2Kh8NCi?=
 =?us-ascii?Q?6i6Eh1TYDBvbFPGhoUXBJmWqQ8cTsShIRy8LaZA8jDt0fWQtsJGjN3kQ+c34?=
 =?us-ascii?Q?y9Tvd7UINIsmHiUEci083TQT4hGOkDLbL2Y3I2Ag8s5UKAg6kowNpDYrz+zc?=
 =?us-ascii?Q?HocfwtOU55PVU6ySA1lgFlTu5ixlv+RZRmklFccl4D7vmb6U2qvtuMLCUK54?=
 =?us-ascii?Q?ddtUHL+6n1Guv4WCb8E9cBFIIZ6aF1+AVumvXvl94R+BDeUlS68aSBVNaYCN?=
 =?us-ascii?Q?CPP08Hq18iiKpo0bUklccrDahMvEsDulcMGUIncER6iWKBMglwrj2rNGaxsU?=
 =?us-ascii?Q?PY/CNYqWDyFV2v2JdO55PnAckIO4GsxPFHXD8EGo7SVKQt810yGo7Xl2RG+2?=
 =?us-ascii?Q?UgN/E3L9AkpyuHlo1IGVCgdp8qPM4V6uT0JfWxmVakwvaR8e1sdFUwQyOaEo?=
 =?us-ascii?Q?e4Nf9g8nt1hNsorbXSU8aXkNG+IiXAbLu4kV8vOWnu8FprtVhdj+VFBfHHgx?=
 =?us-ascii?Q?daqDGXDOsejHlgaqjO8XONkQrCpTzz608EV12MLExs2hMb/P5WcpX/xaV8d6?=
 =?us-ascii?Q?VwpFoTsrPV4vks1UYtojlbhqGHjDKwfkPsiNS7LhWnedWUoByGo67YmiLz5D?=
 =?us-ascii?Q?xneKQ6gBWGdQn5KWphGRy6+Zf6LJrjNBs+bNN6iAMbKBxeo0hxPpZpQyKG6k?=
 =?us-ascii?Q?PRPpAOlDQHNexaRmHKE1FP9l1QoDaHycCRT06nQkwmADdQ8iEHIKcbXbNA1g?=
 =?us-ascii?Q?MKAZCmBicWldTZ10l0VnNkijdQ5PrgKjVdwirNgrnnLuMhy7SYifFqgqIjpj?=
 =?us-ascii?Q?MQ68Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9WgrqxsvY0UmpInBj5YH3CDUe+oJBcAJQzjZagZmlEZAq0QgV5/cVnpf3nxJVo0jmAwiRTd+rEwauKt1BRI4Zn/1vQJL0TR7w7Esyb0OKJZuACVVPgSgstyE0s/wPtWK9PQs4yipjKh6w8psyvyvMKdKLo1OqFKiiykjKLSKUw7wuV9Yyc/8hRN6sd4TF9aaIlooUQbcTbsFhrmSt+NyAuwrEyKAN2Vpk0vHNcov1uQ3yDuOg50sknSk3iHo3+itE+GOVsqOAX6Ip9JH39AVZ/1jdZ40n86A5S0jJrz+IDiUcI4TE5uKeH9WJZSdDjGJQIb6tcDcgPCPSm0SzsHB+YvlSgww9ATE4dQF4B0hGzT5W3POB3pBErEoX06qvkNFCB9u77Hsp0Dau8lJAnZdldqrSi0Y3pSE7kAxmMjLnYNwALM5Fe7L8A/Nt8sWhpqxX+8HDxknMNFcUh+QEDB5t9BeYiK4bHporDpP/5hu7IbDZIRbfomKstnksRqEhzV9zR5FXJIaCviwJu9dn+dFe8G6awqTF3NsR3/b4iDo8pzPmlGF+HDiex9p1nUosrjl/tzyoziB7tQj9rcSH/1Y/9lkA1tvdamavFmJir9qlss=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1915f5c0-85fe-4fba-4332-08dc21ed6416
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:25.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbKtNKxsiDcYrMuJ9NwPTXScwxD9ok/IdM3iK1t0Mie16rUXIFioarz7oUnN1M6xBp0/L1/f6HTcXBWH9iT8KIEUg19aJjYLzhfu1p8/7nU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: RAVulrRPW_U7-E9gxsCiYuBKkUnt-M19
X-Proofpoint-GUID: RAVulrRPW_U7-E9gxsCiYuBKkUnt-M19

From: "Darrick J. Wong" <djwong@kernel.org>

commit 6c664484337b37fa0cf6e958f4019623e30d40f7 upstream.

Currently, xfs_bmap_del_extent_real contains a bunch of code to convert
the physical extent of a data fork mapping for a realtime file into rt
extents and pass that to the rt extent freeing function.  Since the
details of this aren't needed when CONFIG_XFS_REALTIME=n, move it to
xfs_rtbitmap.c to reduce code size when realtime isn't enabled.

This will (one day) enable realtime EFIs to reuse the same
unit-converting call with less code duplication.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c     | 19 +++----------------
 fs/xfs/libxfs/xfs_rtbitmap.c | 33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |  5 +++++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 30c931b38853..26bfa34b4bbf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5057,33 +5057,20 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_filblks_t	len;
-		xfs_extlen_t	mod;
-
-		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
-
 		if (!(bflags & XFS_BMAPI_REMAP)) {
-			xfs_fsblock_t	bno;
-
-			bno = div_u64_rem(del->br_startblock,
-					mp->m_sb.sb_rextsize, &mod);
-			ASSERT(mod == 0);
-
-			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 			if (error)
 				goto done;
 		}
 
 		do_fx = 0;
-		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
 		do_fx = 1;
-		nblks = del->br_blockcount;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
+	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fa180ab66b73..655108a4cd05 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1005,6 +1005,39 @@ xfs_rtfree_extent(
 	return 0;
 }
 
+/*
+ * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
+ * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
+ * cannot exceed XFS_MAX_BMBT_EXTLEN.
+ */
+int
+xfs_rtfree_blocks(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		rtbno,
+	xfs_filblks_t		rtlen)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		bno;
+	xfs_filblks_t		len;
+	xfs_extlen_t		mod;
+
+	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
+
+	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	bno = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	return xfs_rtfree_extent(tp, bno, len);
+}
+
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 62c7ad79cbb6..3b2f1b499a11 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -58,6 +58,10 @@ xfs_rtfree_extent(
 	xfs_rtblock_t		bno,	/* starting block number to free */
 	xfs_extlen_t		len);	/* length of extent freed */
 
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -139,6 +143,7 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-- 
2.39.3

