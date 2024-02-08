Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF6C54BE1;
	Thu,  8 Feb 2024 23:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434494; cv=fail; b=Gmj/W4u6VsUfyHeYAiBVUM80Pl6/p+nOJMcWvAJWfhyOY0NZBS0IFRp60TivlKTymBgosJJStJbdFe/yFuYVsKxKsv3LtycDu9kIfhuWOu6Pqu4LvUA3ejlp0uwWfIegIcp3OS3vTcjE/IFtLwZOVxUMU5gJulHzYa4bMKijDG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434494; c=relaxed/simple;
	bh=60al6aR3IeqYn6BMp8i4fBsFK9rcGV6TnQtZSvQs/Bo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sB11BeTpSF5vYlY7LWeIBvZGbLQizmFV0aL7FNFRqOnhrfxiuU31OOBhULtJCsh9SUV8zgLCUnDnKPjkQHHu0hcJ/Sgjygdqfld4+D4a6CplQiqw/ZFNQaSG4v2a3PKcykcWDkWKOk8Lb3Ed75Ry/PUcwngjzyMOmNqQbdgzQiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IRiT8Q+y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cguztqya; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IRiT8Q+y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cguztqya"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSxbI019784;
	Thu, 8 Feb 2024 23:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=u0ClYQ06XNLo1CSQD37fKO9EGTousxX+6TVz2GY0UNY=;
 b=IRiT8Q+yWZ90XNUwuS5eLwk6IueAPgYPF5xs2As2MlAHs7hf6BI36cd9604GwN8Nvm3O
 rLjQEqEDIRUfttStp1nIarnN/mzKOkIm6JbHjh4QqudgcLDRJ2K4WmQdS7TX/dEeNQqE
 FNprMRlF0ZwBezl7rHlZRoddkmYRfSrqfjQWWb9je3oCfqxFy6BCfUQTeixLqSFsyCa6
 kqryYyqG7DBN6FFGrmN1IKMaoUr3aqi/VilCkXilsC9PdwVUEhRN65Yngu/TtdEXf4og
 H9qGcPsqbICFG9QHY+fFokN7MAFXprsioJAgCXRUYfPr+gYslOoAZzVeiQ+odq247QwW AQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwewx48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418Msnx5039462;
	Thu, 8 Feb 2024 23:21:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb4y50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWnGJaijK7WNhoUZg8if64BBR3ZRWiMTAkhiF8xYf+9NCxbjiPOFA8A4HRzl6OyX1GQpACzNdWJEx3uXtttA7JciR+VGVNF+k1eQXuEaCJm72ZsCskuxfWmDjvPVKDWbgD23WkOVbgltX7HOrYGBYyGUvRqDmSLUoeHWhbdtXV4ZUVRArpiPhFfw3ZVoZ51K+4NHOalbOsAY08gNk3j6MEya3xvH5ficbeveqk8wgYcd490luuUAn8qsyuHET7bfQe0yCSKfOEE1166kpxCT8J7RSkRZFxmwkmJYWA5tO2nh1M5Ah0eeyhyfLC2FDu9zDJDP5z4GM+G5wufZXtmlUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0ClYQ06XNLo1CSQD37fKO9EGTousxX+6TVz2GY0UNY=;
 b=lY7rjYfsKt8D6yhcN2voAaE5vydgKfr9CSTVxows1EP+oD1KKqZdNU1v5nCVaKCAmNhznrHmdGn0tmRyTheWYFI8Wfxy8xMRlnsAjZTIAj7jHVRJXEUiXgztWFF99DgDOA1lCfJyiOk0SNl8Hr8VHl7ek7snoG6LWoWBZD4IE2iHIihINDV4O0ih3GShs2kSte14txqOYw1wkW8PYgu5RW8gJw0cVBHxJgZjyMvOGf7RihgvvVjyF/QXzVDUXMSr3VZdzDFzobnnG+Sd3HXgDNCpyRn5tBFG/2yiFBw5cEKiBBvaqW5lisOPYZMoCSj1WqSQif93D8bUebWDfB1InQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0ClYQ06XNLo1CSQD37fKO9EGTousxX+6TVz2GY0UNY=;
 b=cguztqyaCuqVLQOVPmZXTI3tPR8uhBcM1q8ZThYNDQS2dHphPi7G5JxXWyVgJJd2t4bq3RDOYMpupsvfeyfh8Gp6up9+dtayqsw1Rg35ZA/6ArtG4Vf9KsPzz+za54u4NnljKAK+7MlwuDaknt57/PYQ3cUywy6wD2O2/noSaqM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:27 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:27 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 15/21] xfs: fix internal error from AGFL exhaustion
Date: Thu,  8 Feb 2024 15:20:48 -0800
Message-Id: <20240208232054.15778-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: a8218333-198e-4631-47e4-08dc28fcacd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	im36xvQUuVqYpgVh9sLK7uEUtRPqRJizuvdI9SIVcVLIRUKo7agCKIcv2g97qceY83ALJMafeWUmqwpPkVmJPcU/L2trRdeHl/g/IJj9IvYWYX0mxT9JctUKhNIq7wzd82xetVgc5Szg/jlzl8MdzsQ9IQvWMekPafRz6w77+V1sRxuWGFG3f4gLNMt9v8NkbxMni7qI5WX7CGrGcwarwkQXluW5+ppo74fxfNgf6TnGVjGIGXvVIJNXoWXyLLzFQ/8/6uw7EGCl0isQ9/iwbFm0WD1juv+uNLa2JU3/DliqMKN9Neg8ipaWxapnCo0oLcePy+w6d7FC67sg7tKCzDjfF2qwQSu+Rci9+MkQ72o4fmOMA9Nna7AI+2ChqDQyHudR4WmHeWaCmhbX+um4KMQ1C93WDigH4kczqukEZKLUZ9/NsgzJ9w6nVEgY+Rysmulm3YdyKdotY1DEVAXTFDqcNLZZKN5jdk46z4lC+Few027ot+4vTUFZMc97DvXuxt4qUV0yEC/zaTdRruX8ezRMTKAnc2CW9jwPhmcrM8NmYadq045cZP4FHiwypxYa
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?CK2RTt3+yxVJjowDu6RVAzwcLtdBBmaEB5ZT6/al969M/jq1LWZRh1Esg/zs?=
 =?us-ascii?Q?PUTmVbfWs53AfaitozfGITd8z33mmrpQKbfMui/mx6R5fnTSNbwiyafmk4MJ?=
 =?us-ascii?Q?YkRAzqtip7voiJgMNAQeE1RBtUjjmCCo5D8MT79iz/FcsijLpTCHI45G+MGn?=
 =?us-ascii?Q?eVUvATM7s0kaS6iQAsBFQnUEdFGV2TmW7E1VmGLVKlvL9LxTS4nSQiVF3gh1?=
 =?us-ascii?Q?S7dINMej5pjRD6kHiUzPcNuO/T8Gf2/r5kpk9bLn8vZ1ulK4/OQQ02Vv2K4b?=
 =?us-ascii?Q?bHK7tzKZBFuNGXR5W2/YnwLEgDNoqMlIiiw+2UZBqxQWkcxSfZvx/6J4ZblJ?=
 =?us-ascii?Q?unAW99Y8ovCZPe8ogeAWpp/r1qCSbpsTZy7APTTN3bVQ+7VPDBLBHuTUw2kB?=
 =?us-ascii?Q?0z3WK2e+Zv99Hlu1G1XCIPqdRH/y07TpTsMTOhxQEB5EAYLmi5rFG7c0lX0P?=
 =?us-ascii?Q?fP3qRFFvih8SWRF87xynvDeY12uXBz7AHsx2aLWEoEXJkexp1BWr8zxE93WD?=
 =?us-ascii?Q?PnDW5mmv289Ka7wULqQV0ZwMQ8rKrf3joqtnGAB30Nl1m9gx92XeLO92WwLR?=
 =?us-ascii?Q?UWNcSQwwNW1FsdpHbpgE3xS+MFJNA9zXqrzOq/oBGakhCcHMHGuXGdj0zzU0?=
 =?us-ascii?Q?ozfFoWqXN86vJ56kec+FKKLvMNhfzKz262jlLh6bRZ0iWe/Ra3TmlKvonhw1?=
 =?us-ascii?Q?max94nOLuz9F6Ku5agDR9fEBpjGdC1xP135JaI4I4/T61ULnAS+RNubBnfiA?=
 =?us-ascii?Q?F4YhHSHziOdwuues++ZZ2Z7+lAtswqtD6FyxJPJXqAMvvnx9nrohL/+5RNAt?=
 =?us-ascii?Q?/KmXIFTHNhA5gU7Iws6OB6VZwNB9ssB7y8Q1Ix1ydej/NoA4WmqDiglhHOug?=
 =?us-ascii?Q?EB/U7YTmwF11fGakUge8SfSbpFyiF27Qb+LzEdwjQmYwxheBcGNKlybZMt/A?=
 =?us-ascii?Q?ASZLcxqPWIYnYaesdZJBSnKanHapJWtOkmE0PWZVhklLfFuaSMv+cbzEVNlw?=
 =?us-ascii?Q?aT+GR3qHLtO+Pll93DpmGrZvEuxUW1tdpw743SoZgNB8mT3LXnE/8VoFNzl8?=
 =?us-ascii?Q?CIKJlzmlGu17IsKMOysw0BVmqWQHMIO+cjOXUXeHHCgUDfKqegBIVOUAB1zR?=
 =?us-ascii?Q?PWShWtZFsh8t5pBHKThxUbI8lXBopkF6oAZUNfKCdFl5UquPXFUArLIEk2Zb?=
 =?us-ascii?Q?wUuWowE10oDgNUMxak2AKn0rXdxw/yMi0RYAYIVJ8o8WpKCOZ4RRN2Azv14Y?=
 =?us-ascii?Q?iX45KBnox1eNsOWLj/FVnTEdn3fNKn/od4VffiM1cnqS7Z78tsjFynBRRlvh?=
 =?us-ascii?Q?M3coSo5VOBj6pcSeFItX/1GBWLhv1PMGTDUjHjrWlHCQBk1dr8P4EVrfzWCI?=
 =?us-ascii?Q?TsCBsVbCFVD5CRqxLY9GggQgYx19/vUD7eXDKpXDteG/U/gu4IAZ89NOPsWz?=
 =?us-ascii?Q?GJVnCX4B66pdKhmYqeJFUKklhY63Bk0dGpYSC0QrV8qgl652uyxdUK4lSYBX?=
 =?us-ascii?Q?fEV8Ez42XzynBiV/COqjm536YURNXBJWSfTmocNBbf0Xgx5kSYUTDL/gH8r9?=
 =?us-ascii?Q?omuwYl/LmXf/qlBb6CfmhgUvnzulVxGSHdFx0UdVuen7/1CgE0xhpZ5gFRF7?=
 =?us-ascii?Q?FOttzTBPKfTiI5sjJYb3IzaFP8ymx54XTDzA7h83KwZlBsZ0Wo6og5zHnPe5?=
 =?us-ascii?Q?K/1IXQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	l94NrD4vQhPY5b77hOIO6SU0IT02wkdUumhbCkOy0M7tIBF5m2FJRuJRjwuawEI/Fcap/TesBXIqIrl7jVHs5njca8+4MsIJ4IH+BPLyCS4SIxtJv5XdSCXQ8QjswMFWgnfgpPlEzyAPRiA+MUH0wBWrJFEFKK5StrNQOROXPs7KmUftQ5acZs4rM9SsIvnvC72uCmtV1G3A9XyRts2HF3xhyfuzr7QUC+QXjwq8TD6EpX5lMO9iyi7IZ8966mZmMM8qtNH9L4bMWABEHU2f9D4G3iTSXsUGtKbWBttA8bUbyZwIoZVa4zLM9YuTDjocDZ+YARrYBk4BWSI3EGStEmEwoKouex8rLH+yA97+UNOvEgQfb5Ky6ee0rTwYLTvIohZV8ei1pYN5t3mcV8jngeXS5Tzi1pOrzLRxHCp9Zeb0iLRbKExnqzvJzKytxnooOv6udqYc2pRc9Q+jWQx4gCwBavbSCj3mqEw3R9Tl7wADObmZFoHQjNPWkA7mzC06IpJRFxMIl5iXRFRfYAmfJ2HdHQhNGHDMfiMtE3V7cd6CHSocSmWklo3q5DKSSkEju6nS4M/+Wk6Bdzos1PIr11fdIL0jSsQvObyK/MrOWO4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8218333-198e-4631-47e4-08dc28fcacd2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:27.8161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTlNNwk4NeMvUQJ351VjpMaKf+LuISEDvMG5baBTfO/BNDmiBBQAvrTaRotQbJgrKl0mUC7u/vM17TVC+A6S1LWUSwUeNSJ/j13Bj2XnubM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: KI8kn8RBjg8iuUf4OB7qfhTMi0QwA0ce
X-Proofpoint-GUID: KI8kn8RBjg8iuUf4OB7qfhTMi0QwA0ce

From: Omar Sandoval <osandov@fb.com>

commit f63a5b3769ad7659da4c0420751d78958ab97675 upstream.

We've been seeing XFS errors like the following:

XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
...
Call Trace:
 xfs_corruption_error+0x94/0xa0
 xfs_btree_insert+0x221/0x280
 xfs_alloc_fixup_trees+0x104/0x3e0
 xfs_alloc_ag_vextent_size+0x667/0x820
 xfs_alloc_fix_freelist+0x5d9/0x750
 xfs_free_extent_fix_freelist+0x65/0xa0
 __xfs_free_extent+0x57/0x180
...

This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
xfs_btree_insrec() fails.

After converting this into a panic and dissecting the core dump, I found
that xfs_btree_insrec() is failing because it's trying to split a leaf
node in the cntbt when the AG free list is empty. In particular, it's
failing to get a block from the AGFL _while trying to refill the AGFL_.

If a single operation splits every level of the bnobt and the cntbt (and
the rmapbt if it is enabled) at once, the free list will be empty. Then,
when the next operation tries to refill the free list, it allocates
space. If the allocation does not use a full extent, it will need to
insert records for the remaining space in the bnobt and cntbt. And if
those new records go in full leaves, the leaves (and potentially more
nodes up to the old root) need to be split.

Fix it by accounting for the additional splits that may be required to
refill the free list in the calculation for the minimum free list size.

P.S. As far as I can tell, this bug has existed for a long time -- maybe
back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
...") in April 1994! It requires a very unlucky sequence of events, and
in fact we didn't hit it until a particular sparse mmap workload updated
from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
exposed by some other change in allocation or writeback patterns. It's
also much less likely to be hit with the rmapbt enabled, since that
increases the minimum free list size and is unlikely to split at the
same time as the bnobt and cntbt.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3069194527dd..100ab5931b31 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2275,16 +2275,37 @@ xfs_alloc_min_freelist(
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
+	/*
+	 * For a btree shorter than the maximum height, the worst case is that
+	 * every level gets split and a new level is added, then while inserting
+	 * another entry to refill the AGFL, every level under the old root gets
+	 * split again. This is:
+	 *
+	 *   (full height split reservation) + (AGFL refill split height)
+	 * = (current height + 1) + (current height - 1)
+	 * = (new height) + (new height - 2)
+	 * = 2 * new height - 2
+	 *
+	 * For a btree of maximum height, the worst case is that every level
+	 * under the root gets split, then while inserting another entry to
+	 * refill the AGFL, every level under the root gets split again. This is
+	 * also:
+	 *
+	 *   2 * (current height - 1)
+	 * = 2 * (new height - 1)
+	 * = 2 * new height - 2
+	 */
+
 	/* space needed by-bno freespace btree */
 	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-						mp->m_rmap_maxlevels);
+						mp->m_rmap_maxlevels) * 2 - 2;
 
 	return min_free;
 }
-- 
2.39.3

