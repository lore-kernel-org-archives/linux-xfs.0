Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A7953E34;
	Thu,  8 Feb 2024 23:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434469; cv=fail; b=hZ7Oo2He7HOo0EiL4Ronll9ao0lhfb87K3hQ7DBrYzQqYwOxNmT79KhzuEDb+3yEsNlSREWPh3vJvLoYij7wkVLxFN+HBlUH5gOa0UIlDyxX+uRZTe0nA4ngyZPW5wLnTymtPaPnnSUMydEJsQ+jkBKit6OHMoEa2uo1CD0dqOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434469; c=relaxed/simple;
	bh=Xor5VbRuI2glkmSzeGcx2vLEzcS9FfB8kVhOouEKwkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DODZ+NaqCfSjDBXtK6w40++UzVsKVccgSdPfLFt17dQy6RopVe965ca2tcujqEaiJqkhB4zQKPiQaGw8E0bH/cXtzCXqcYOmv9zeXhzqwT4gwc0QksoHqWklj1iseY3rp6Id0BWL7GosQDasTygUNMeePyiAef7+wP74XhvL0zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oCYbJYct; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u6yvBjp7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oCYbJYct";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u6yvBjp7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSjDv015690;
	Thu, 8 Feb 2024 23:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=EEwUi0PWIQ+gp08cQYI2Tl4PLxfFWBfhLfJsFMGt/A4=;
 b=oCYbJYct3OxKvnkeQ2j/4x7UU0OBDnkbRh+LZDBkAfsl0daUWVknO9U8YdkaWe0iDCLn
 /zbs6/cb9sCATMf0gUu+eOyrmMQqFIWe4vinT+3mL/v/UFx4YGf1NopxWqEnv+//HfuI
 CwnQM5DbN5d5RWcvxPZQMWC+fU+Gv2/vsBUNNDRZeP+ofVUWCsvulBlM4dcvgXg573f6
 33o71MB8US1qOTAaBNIrApv1L3x7lkG0BnuM5KFD+JIgP6IrnP2Nz5jRvRS+hmDoRbVF
 NB77Up76/JxLnZs3xse6qDPSPpYCWXqh8xImH6M3miNUkysi3ZkAgQZ76FevZwxbU2Uv bg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dhdp8yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418ME5NM019673;
	Thu, 8 Feb 2024 23:21:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxhq4uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MToS525qqv30oOxd0etp6I7/CvFPbN304z59kgXjDAhYJn8vv6mLzvabH9EOGifj2OsUtwterElWt4gArYWrATX2wUnpBNH57m2dl18f2ivCrk/sfZy1GEwBt92lLP3zg/wP0ITVqk4k4OvOD8JshqSZCVy4TF7BqWPp5dnfDQTcQw3C3RfZZlB8mutpP94G4BqSI7U9mKblhHzemvYPwjp70ZN3vQvzQto8sst5htt9Vqk5krz+eWz+GJ6JMB/wjYFMFfU7mKDxdsuTxe/o+WtymEj3QmYkl/keBwJH2qgnRvAhS/jcQXnQL/bWDYkrotkpH5aO1gv85wBgRsTIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEwUi0PWIQ+gp08cQYI2Tl4PLxfFWBfhLfJsFMGt/A4=;
 b=n8kH41isNkeYvgv6/ygUV6QWTkpn2+Fxh7pA96XFXUNYsoj36yySmaOSZ3NnAUwvgN8+Uh+hSCles16kz41wJztCk8XE04sT7ZJWzDLCwEVz+6qHyAcSZr1FxH7xxuO51lGt4OjYBWfwmAFSbIaXgFvBL66fuhFtkNsC3LqUUUJXHLEEp/MNok0Ulk/WbgihMaBg2GNj/wvbyu7O2K105vCmtZwsmnhMYwv+pHx3i+t9BruTA7WyD6Ps/5h5CWOHZTXA8/ur/hiYA98c3kOTz9FXEjmSz/z9gk5AnlDFofAcC3UOBjtgVFWDsKOOYfM65tQE5RVjr5jSAjAKmYG4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEwUi0PWIQ+gp08cQYI2Tl4PLxfFWBfhLfJsFMGt/A4=;
 b=u6yvBjp7KdoVipXaDjJhisqtbJ1/TXufcZf+tfpJtgl34ujmsxQ5rCKxSyCOXz67tHe1DmF4PTX2hsnz9E8Ifp9ppx5wkCJJKQ/lJyCgtKsAZ4gl0mEQJ7H0tVxeGkWNyEzTUCngii+Q+8e7Q+aY4fMYtItIiC5FuXYWBCvjV88=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 23:21:02 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:02 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 03/21] xfs: hoist freeing of rt data fork extent mappings
Date: Thu,  8 Feb 2024 15:20:36 -0800
Message-Id: <20240208232054.15778-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::9) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: e903fb86-4da7-41b1-2a1b-08dc28fc9da7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	YtV9rLL/qblIohIjklV4u2riBMUAg5SySUkIPah6Nxu3yZymThuFhSwb93UajN0qdVfDdlHkiK51rr+2fx+l6jBQEUusVCcB675ukyGa37pK57VVRaktIYOvjnF1//wIg2pILTYdQ4khnmBDr6x5FHbt+Yhe1sjrvym/C4KVVFbbdo7QrFK4uZzIgUta+5HQUDXptaOv/h5g3EkBaeADbFRSl/P4fYlqWQ1Uh4hcTaVTnlfcHgsrFlMCe7eL2jz/fyGuqSLNr3UGj63QuVnY3Xabbz7mEE60+mKrrqRPsFyzsXJoHxS+3dejrILYetE8BeVthZfkjMwReLN2prwoJm1RrCFmAcxCWyW6YEt4l//HescURaKdHH0CKJobZsQxxPsAmPQpylnDX15vfpI0NP86ML+de+/nz+uWOTQkfdThEk1fxhMXP6YrSMH/eLWh0tPrrzNjkzSpODs41fTJnLQUEgGMxCr6xzD6keNT+esrQO3GIWJRxOZ/NDPqxL7m5JLPlnbzNaQ0YKDk2wPEyymAS/k3we2WN2T7Rb//vSBaQO48JawkMrFhC3wFJNCw
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6506007)(4326008)(450100002)(86362001)(44832011)(8936002)(6486002)(36756003)(5660300002)(478600001)(2616005)(6512007)(1076003)(6916009)(66946007)(316002)(66556008)(66476007)(6666004)(8676002)(83380400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?K2YtBv3hzKP45UTRlhxHBoDS2OPwSIQXUrPnkwXdLK4tzf3bScWmDbo5DKx8?=
 =?us-ascii?Q?rTYBWEPzRKxqwdkbS+/O3wedE7HRYPMqo7TBXzLxgsKIw2B/oBfX7k2XbnDA?=
 =?us-ascii?Q?Uz1Qy645PRgp6gZn/pCA33RQDfiWOb22/hixvVJwnG9q3kb3UlUpxmGZVVqY?=
 =?us-ascii?Q?0OnV5WqI5xZZZ2RSS3JIihXAEyw/dlp8oNMEj1HZd3YthH/MYMfInJcU+g+c?=
 =?us-ascii?Q?Nv6EJv+jiKPXHmdhjKNOJoqSIJ44qtEkwrBFXl5hoqn9tC+5Oah4/7Bz1bfM?=
 =?us-ascii?Q?dD8JjfFiQ9p7q51HEXfgmShXeZWAJkJlvrIPAsnEMCSWzekjdv6QhPXhBucJ?=
 =?us-ascii?Q?ctLv4HIJZ803xVzQKnFUyNZKOd1zZ9b1AJ/frIMX9mMkqpUnxcuqzHmUa3QV?=
 =?us-ascii?Q?GBXise94rXUFvs2GL571RrbwJPsAGwGB9QuWyJEHKVok026PSSQ1aqPWLRzq?=
 =?us-ascii?Q?UNWH7VmpJI4C65KZlLE2hul22QVMWwty2aOqPtlBxNXti8J3GCNFLb1friOJ?=
 =?us-ascii?Q?GXTgsMn3Ik6eHfMcWfEmiN0eSV2xwP6z6gZE4jikSqo6yI4bJv47Qhufccrk?=
 =?us-ascii?Q?UdthVX8LUxuAfXl3rxFkO/l//KxYJrug8mtK0SeNNBHWWCfCVqMxrpIQLU/X?=
 =?us-ascii?Q?XueQbdnXe8N8apLqPkPhbCLK2rn95treLMh+ZTRusPZaIO95/J8jf07HcOBk?=
 =?us-ascii?Q?dpaxDzUSNKFY83IqyIfU6Am1MyQ6TB6kxxusU8gT/4t8gWoGoopDrNoWAsRq?=
 =?us-ascii?Q?nNxR8dpRdyd7H/keN1+esEZ7Ocj2tK5Vc3ck6UviO5SGuxnR8pM8E4sDUhF7?=
 =?us-ascii?Q?4kdP/hFymFdjPnh9TajFn6b8+XuvaKfJgjjHrmf6A3hXJUL3pq1S+bW210vI?=
 =?us-ascii?Q?kZ8tMPQmEvWtKKoz3DJs9fHYrrwA55M/lxw0jJHkE+ST0QFVV/YzBIOeTNQb?=
 =?us-ascii?Q?d326H+hjuPJWQnHqF946SnLisfrUSXrFeuMRfIn2GdwniRGzPjEWRvYrbNUt?=
 =?us-ascii?Q?P21/lxQV/bhvOzZY8H0kE+KbIwDN2cJKL9LDvjLS9Td2ei1eeXsESz3+q6fA?=
 =?us-ascii?Q?G47gicGhmJGwbym/tqhQR9u0DdcxikJ22LdViXl+DOTtXWOUMZ9v2pXRwFrW?=
 =?us-ascii?Q?LlBVL/u2eLAo6iV/ZNsxoUH/kkqwRBtXmDZMMa0ACPWM7+TGntdC00jZY8R0?=
 =?us-ascii?Q?6f6UccUQ+YQJPVLscbMXpVfDAzWxPTI9KHt75mUzQ9HE258IkLVe5dp8K+1B?=
 =?us-ascii?Q?KgGhppRUDFvzfpbsZd6GWMB6tFke5z5NWsqiZqZlyZBUsQwhFw0ti7SDqaqk?=
 =?us-ascii?Q?LCuyg9Qq2efiSDKQY8U/qDDqfPi53RchV/MpW0wiaF4KvhpQkg3k3TpQrIW5?=
 =?us-ascii?Q?imVtExbj3OamKLbVI5AwFEBgExEtNqwS/a3ikDXthMsT6E/QxWsu2rRHxYca?=
 =?us-ascii?Q?BZmTNngrR7mOfuEX7FouXcoL5XbiCFgWgEaa5snA0Rbw6z9GlHf28Uez4VE5?=
 =?us-ascii?Q?0PE7ftGkewTt5aS2jeNB/Vo1+kzYLb1nQ53rR7M5XhmLSiyscfGs6RBErX3p?=
 =?us-ascii?Q?b/+yoHwHdnlRTZ1fvEI0hKa0usG8xAbO9eXqA0y/9ioBySn0M2RoHhkRrD3/?=
 =?us-ascii?Q?AxtvJAgFTbCuL7/T++VAAY1xh+jlkX1Q6bBn9Y+u3LkaNOLgw+h02r7xbKGl?=
 =?us-ascii?Q?KIuViA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	O3fJts68Ty5H5VEVWnWYPF/u5KPM3PwBFZEfzX0/NtfERvuo/N28OgQqMBUxIdvlg7Us5iPrJFvS8cxGCRsMug4szmnMkizviwMG4vEFsPV0pAcPdzoQ63hqcMqstdixJV8vSjbbtMdL8wj6QYZehEP6tAtOpdr5zRoi2kcqFmiy9kLlXrGiWFK+Nn+RfxLGDX1dmog0Xv75M5FHxDAaSmog94s51q+7H0WQN6fYGwvuGFklnyOiXmQAxiLeH2e2mPAfdT0cAi9R546oRtdgvoe/nvfvm1akuLRB8J+Mb3wemrnAsJC2ZKPY2zmx3sY5Q4ypknBO+VVXcnNAe/LM8IaQW2zGospb79KyEHgul0ojqwUQi2ohc/3pe8Zkds+fRVRF6KDYgIufOS9lgSRJ5tiGCAOPwbyaEGUF8Z2nnBdIJ1XCOG3FYne/iO8Mpde6H0rdT0Qpq2jBuf/ZEshAsnBjljklmq4MLXvQw8d5WIjnPND8eR+vMsyBT/lMjq6cebhEZrJRVqk7/86kkjFoGR9LTCavk5V5PdbfMhoon3J2OjBvQ4vy9M6p5J5tNlCRXBB9A/8GBAmuS+A1UBVhItqpIcM05eroCbP8X+Qf224=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e903fb86-4da7-41b1-2a1b-08dc28fc9da7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:02.3288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhJDU9lKMY5+xlXfJkAp6hZSitXk2vI9Yi8ku9kT3OklVAHIGKm2bAbc/TxhpEGE+yn8PlnXxqbhlw9VCB105WgF4k9bWNGiQj30a5hKls8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-GUID: _ynG417OYN3kBKBMMZQlVcDsvDiFwiSa
X-Proofpoint-ORIG-GUID: _ynG417OYN3kBKBMMZQlVcDsvDiFwiSa

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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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

