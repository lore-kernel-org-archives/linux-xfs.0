Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C8A54BFE;
	Thu,  8 Feb 2024 23:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434497; cv=fail; b=QeQVDmctz2r7co6UybiA4fgnhWCO/MVNobTBN7shCMCmDjncONZuDt6HRm7BjzAujoqmdubG4UU6XLl/VwjhA1fO2AsBNAhYq116BetjzoUD1v393ct4vXozb5WCLviZwCyKYwXrOwBTnrqhpuUa2ABSJlpzEqC8NzOkDvk3JVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434497; c=relaxed/simple;
	bh=/24lZmlBLV+qs2iERihT4Cu8f0ruopzRJTyR/mqvn7M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hvUseqGYuPSFUY6tz0gw2yCHorzm1qPe3HaVKDsc0fqxBTe5FjKBg85bcKEzCjPC9Id8Ya7XSyOgQugPVvlE6Kg8KYW1yxbw9Z+1nxojCjm/D51vvI1Yo4tYaMiGb3QV3xS7Zby2VvJqgipSMyJ1Jr6njNSdOndUwaJ0WkZ+EtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HEysAHmB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X+mmNo6q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HEysAHmB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X+mmNo6q"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LT9EQ024397;
	Thu, 8 Feb 2024 23:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=26JkLk5sUbNb3YyTkOHV0cWS5H7MTEJ+82wEAmuWtMg=;
 b=HEysAHmBedbMSdzen2F6xOPoG0gugbTcGGhV5+ZUlxVAFm3ab61TZHerIusSxCEqnaVL
 IvZZ56HFXvn1VWFEZvOxAs1D1qfVKfrSmQopoa2OpNQQIMVn7CxtE1jS4H00eUWgDuWF
 IR64RpZte6BnE4nKokzk3jDRdPGnhuMMOdP6LNgNR41Ikn+isqs4GtA9lqBo+f/E1fSa
 qBiPDWm/9pdaDSPHE8ojtyNbtzPk2tBL5QXKl10WrFL+GHPleRE6h+6N1N/plAqAxXIF
 vWyDZUUad8A291uGU4OXInMUQoLG1RUHSt+7BYrpzT2FT3j65TjVkKq2W7hEI/jMS3aS 2A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1e1ve2g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LXe0J019719;
	Thu, 8 Feb 2024 23:21:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxhq59j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVPb+aDC+lCgJHgiCz3Cen2qd135ChjF9kV16ZzmH2n/5wiZr/MaYACxups66cBnKSIMYnfudfiXqFgIykJW8pZsa2SrGO8HqS6lRRoFEheXgXiiFS6dVe0LTTGssMz4FCvB4Iz5VYqlMfLUa2Kfexh8k/jbwI5ty9J/yKfMrpsDnjNchg8Sni4Jjl33vhC09asPKOYIT2myZPrOmAwbwv1Xk9SPCfoKF6mYrm926j/0YrJmLO8C9AiMB7J7iUfAdom73EF5I+ZPk6P4aU/B6Zn2M2YBX94jL87mAkKbT9gfGtHxcI39tE7x7af8AN474Fwfrxc8Zl1ohmlXYzW72A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26JkLk5sUbNb3YyTkOHV0cWS5H7MTEJ+82wEAmuWtMg=;
 b=gecy0/dIOYfMN5MdQhU/eI+EloY85RdB777QH3j+oo9yEV4wx5hu7RaBoGDHgTx4VPFSvJu/5tPWRUw+CkRDRYnEecQx1nQQdteW1cWuOzoipTCfo0kuLm2qljmxuFsYI26o816oMk+RYHc7bgMMTPWiSPBfxai9iExyCqESmZ0b0kQFumwyIIpiYsbHsKvrz2TDiZODpKF/sVtmugIRV+mkozIoXAXxMcCwz343Da8Sd0evE4SBm4qDMpal680/ppBYDHGDkcM7T+7APRjVfO/Kn8lr3GCD8qZ0hWsgMxtlfwVMfaOwy2Hu6JOM8STzuxZDpGiQAce1ZkwnNLCyhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26JkLk5sUbNb3YyTkOHV0cWS5H7MTEJ+82wEAmuWtMg=;
 b=X+mmNo6qghPU0lmeI/ej8G7hQovKL/eIH0+PycVGXyXEm7i1DoumKBKz+BcSSYd8yxdBMKTH8ZWHB6wblzDsGjL6z213DkobjbWivSFPA2kbK2NAF5jqnAb/GCJ06WlKgPEqlRofV0EE5ooJs2wYNZdulH45Gp2gjqWHU/UKhpU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:32 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:31 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 17/21] xfs: inode recovery does not validate the recovered inode
Date: Thu,  8 Feb 2024 15:20:50 -0800
Message-Id: <20240208232054.15778-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0060.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::37) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: c707851e-6998-494e-8b92-08dc28fcaf47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	H3ps9C1LMod1y1mfNPFRJXXpeQStVLJJYvZEB6yNA3vCPnyBNTviZL50oM0DEzcCSR858JdgSNQyJ/r9YPGXRUChrXODGhKO2LlXsvtdIOvOuTHq7Uf0VYhlCCSC/tIVpgUs01qsXqSe+PJKyFSF1ls4+BOgp52/0AKrWwIByycNb4N5Gno2+URugIF1PGKcS739f9QUlhkzo7s6dYS34Bm4FyHuZhC5bSLRM0jgMM6N9mFkPuDFmQw/yjEDfDi13EssMn+WIpANukyDpd6PcNU7kDswBY0E0008QEflP1ckylk44BVntrQWF4lqdOxMwCiyOtXBx7CzDvZR+hd4kEjH23UOEE6LW/5C+lZhdQqGCq1NB8qYbgr1w+Bs/ID5nEznlpQm9HNKExdr+db1cZgvSqk1/fTW3tRY20GK9CgP9KDspTbeS/l37y00iZtyia3EU+WFtPaNPd1WhwX4HEIZa4rYT6n4/dsRR/haRAxAXdVAcUbGZ9wfuTtzc+lywozycZT9jOQSo9qaRGm7oInG4e8kgZHRWY1diNk+pPYkS/f/jcjnf5FxMX/gH04w
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(15650500001)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?jJVMNZrRJmSZ3leS4vXa45L7fucywwXkgtt6cfFIs7fuMAjrqU4eO+wIyykL?=
 =?us-ascii?Q?erwWbCWlXJrJ7k0CEvKDh32KZCig22nIcdsjt5PK9Oep1C6No9IQk12yX1eO?=
 =?us-ascii?Q?SpOpgGJmFP4yxkm3o4Fe5m3O/dc2G3m+LpffgJslv9YTZvfQ92mvyR4px+1w?=
 =?us-ascii?Q?4E7rCJ6o9Y9N0Ph2I5S/w9eBuRd+dN+l3faO5jDA2N3rF+pFQBP9Mti3cX8y?=
 =?us-ascii?Q?L0VDMAP+ACDAettIvSUgvNmXeGWGQS+hvfbbIBRS0gU+XAuPu6gNIR6FE+Lj?=
 =?us-ascii?Q?t+Y7zcf9fACRcsNq/e6H/XhlFV4hVg85nEZValzaXh7dufapfq8vH4mC+0cB?=
 =?us-ascii?Q?HyqO6uOdAIgVtf8w8EGTePF3OI1VvN2SNKqt4ISxHYoSeGqgyjWizcAG0PsU?=
 =?us-ascii?Q?7yNE9+UYzM2BpNw3DQbppb+rvf4MxEdYCKqxlYC8cRUTC0cTx1AE46crDSnZ?=
 =?us-ascii?Q?3Lh9ozhi6WKn8+CUP44FcDAEOOSZJt1K4gMx5h5+jjvuCg4iTP9Q3eePuPLP?=
 =?us-ascii?Q?TGHqRkZK7oM9BapMdHDpAucDNCMz4fqjnfr5jH+8NG/ktTO35csx0dbk8nOP?=
 =?us-ascii?Q?Q1lYVr4ho7g8lYMSeti+7yHmh/bzUPO9/JJVMM5cFec7s/sN+TPiVrKIL8OP?=
 =?us-ascii?Q?fl8VhddFC5ECd5rqd7ntLraASugqPB0boa16yp06ig/DfrlvQjAAgFRHMWfN?=
 =?us-ascii?Q?2zDEIRml+oqVSOCjVbCCm3zV2q9wwRbxZYWzWERmiqJlevf+J0hGlhNvH0Mp?=
 =?us-ascii?Q?vhZfrWzJ2+624vF1rcotukZRd2W25wFA8DcS/Uqx4iIqAylW1tEKIE6m4cbQ?=
 =?us-ascii?Q?7WbMmY5orz5HjX9Hx98JXbgRSteDzqnBYRoZy+8qhtnZ+ITE4LRKXWStZSXC?=
 =?us-ascii?Q?H9fxlRCY0ziTDYxaYgufFEbbcYcrEhrROcTMga6Z1JBmxtD38ZhZur+s/Dm7?=
 =?us-ascii?Q?otOizFDnpXlw4TAVLL0yxE6BcA9OrpMoDfW84pF8gqH7O3B3XnVQIfL9WHUx?=
 =?us-ascii?Q?HCK7lfJev0t27e5uydhSxjgWmbOK1Py7KeDW/Bt0ZWMf4DFOGLVMu1/qYZ7S?=
 =?us-ascii?Q?7u6LSdbvcrQE9mdKXDbqda8F8G1HIDmpjKvKB2ZqNrG6XN3esZnQ74IFgH0Y?=
 =?us-ascii?Q?vMewPl6e85JwZHKHKolV8EYBAuyrsDvkTGzYQKXY0RobeyPvQYY2Q49AlFx9?=
 =?us-ascii?Q?RZ3KbLnrLZMMMJLMqpSHcIorC88YZOT5fwbYmz8OZPA8mhX3BH7ZRE/ZXX9c?=
 =?us-ascii?Q?UnbiXLZzqAb7IKAxvgFsUjT1rQYOBv1lHz9IpC1un82H6pI/PnbXy5evF3cY?=
 =?us-ascii?Q?XL6mFNhs+ha2PhzMWVGAOyEVeM2CNV/eKiLdklYwFHZTjwllg04VJk7z8Zyc?=
 =?us-ascii?Q?VPx0qGvubooK6oicFjWueduqkazZK9HNkYdqat4AsIBI+Ryfid1IsXET9e2O?=
 =?us-ascii?Q?CWcSsjJ7hylmOT9ltTjkXESR9+M3eME/qZhIxsX70lQeS5mGYnUAK1Oep2YG?=
 =?us-ascii?Q?hY7llQK4MSTPXCMeBtKVcBp5lIaemIvvJlA0YFsC+tt00lT0d3X0LRiPq/rC?=
 =?us-ascii?Q?soTwdbrRzVZ5giXzLKFLcsUkv2j3UBUb35Rj/XrrjU1LWkNcYZcInGQ4GWZw?=
 =?us-ascii?Q?zpyVb/JnXh1KQg8gXShbwOHXgpub5N82PluoOyMHIizvXprzky1jXt1adIYr?=
 =?us-ascii?Q?NtCVDw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iU4DKw7T1h8FymII0RyK6IN6v0Zdnze+dcEZZFT1L7/VF1Tngnv9WmSyBdkU5dkfmVqwHCeK4FaLPb58IwQWAkleZnPPgn7qekWq91AVvBN2b0RNkYBunCgwHRkk49+qXCXpECVjL1W5xzDo4JjUO0wEm8eb4CkvfBucOdptMNziq3nkHikfRLleoUHX9R751ZzBXYel69CSe0Gdagwbw1T4naVRFvmfgc++v/I3AT8uioH/rg7gus3XY2pfCD/+zovuf/QOxPpK4WLaFSXmmKSTuR04DsmEx4CsEf/pgKU6inZMTtx+nCg1NfcKTzzN7cXZasitO3YHLIZgKIQ3bZn6ZeutKofdgU8e11TDZf5Jbk6MUmj87qx4iss7fYZ3P50B+5DlhiGJDMNTQhVWWrYHPGGsb0m4UwbEJ/jTDhYrzFXYM5PJaf8LatFvQ6WUMg27GViPTU4puvpcVCbmBFATYPm2D16PURlBOkZdgcaQGEKO50tLfjjAyqkYvTOS4vKIkJfUBY3vDNl0Qy7bBaOQMF9VyaSfs4446JBdbZyMSdSfa+4RWYq9t08aROxL7P7P0FyvlIezOP8uW74rwrVafuZdr+cjbQA61iykFXs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c707851e-6998-494e-8b92-08dc28fcaf47
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:31.8980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vTmitepBPLKCQkHV/ANshmyB1/ptC5wmYtHLdBh4AGz72zxsjE3lVjBzL4tGmaol1juvgUDcAO9Xgw0HCicg0Z+FsdFETFizaJSSJmQYfvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-GUID: witK5DnCh72d_baf5lObYMk-q-9kZ_ub
X-Proofpoint-ORIG-GUID: witK5DnCh72d_baf5lObYMk-q-9kZ_ub

From: Dave Chinner <dchinner@redhat.com>

commit 038ca189c0d2c1570b4d922f25b524007c85cf94 upstream.

Discovered when trying to track down a weird recovery corruption
issue that wasn't detected at recovery time.

The specific corruption was a zero extent count field when big
extent counts are in use, and it turns out the dinode verifier
doesn't detect that specific corruption case, either. So fix it too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a35781577cad..0f970a0b3382 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -508,6 +508,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index e6609067ef26..144198a6b270 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_log_dinode		*ldip;
 	uint				isize;
 	int				need_free = 0;
+	xfs_failaddr_t			fa;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
@@ -530,8 +531,19 @@ xlog_recover_inode_commit_pass2(
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
-	/* re-generate the checksum. */
+	/* re-generate the checksum and validate the recovered inode. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
+	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
+	if (fa) {
+		XFS_CORRUPTION_ERROR(
+			"Bad dinode after recovery",
+				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
+		xfs_alert(mp,
+			"Metadata corruption detected at %pS, inode 0x%llx",
+			fa, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.39.3

