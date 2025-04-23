Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5701DEFE7;
	Wed, 23 Apr 2025 07:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745393298; cv=fail; b=a92pNohRAyW8qt9DzUBFeFoi0NwBVtlqKRKfkXNKASxQoXciefrhyiiguq8oped9T42JK8l4YH1NjXoQsebp4TcmBCDZnUd5UgpaViE6tYRzD2DdZ07LLYTx94pvw3chYN6Yr/lOoVqAZk8FklD0VQhwwioS37c+dsq+iBNICDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745393298; c=relaxed/simple;
	bh=a0U0M7pAWZeQf1JZWiqknq8EISqZ3aYr5V9acDxCxzg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dZyMp2S/87Afizj7vdVkXE8U1c1hTcijHsa3yPoR1fxkqbrGYhTOCWrHlObxDAFn1IYY1TlMOIn/v3xvcrX+0mahW6NZMXUPK3sdQTyoCDgk7RVeW1LKzY4apkIG9bAnmulUNJDvwHz52n3FNXv/fAVqRJc8D0UGITkfVRpWupA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N4Pigt016671;
	Wed, 23 Apr 2025 07:28:08 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 466jhj8ee1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 07:28:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WEGM2xRETan39m6ZDjGmoSQduaX5QFF22TUqFXXCXhvPNgHyACWtLKLXM6QmYYo4LtPxoouEYdeGogXLlZeRLnBsE2oAlLcfaDaIjxlxReRAXM10wxulD1GspRdfxdtN6tJvrE822/DpA3OBZhWUGJgtykNfczCAyteMc9jhbHlE/n+kBVZH8yZ8QaLel+2euFhKLnxpdazKzlJZzAYb4IzbtFqU3wjJgOqNEE5n+HsZyrPNuVlpWILwvdnm9z0QtkVmYCnPAZFE/1HKEjybf7VXdQrakvUk0F8qZWgpwKlUjxmXJ35IHOiaj1M5yDowvZE9ddv2GHrtekR8orHHuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeOUJ6/WP8kDQbbXap2fy3y5PS2q2V1p1+RkAW4822o=;
 b=R3tbGWwa7sTFv0o2bnnOdbRT1FF7IUVneM4qORq/629kUiPfzAgRrmfPV3585zB7JbI5G0QRXh38C21bECf3S4KrppjD5kySsXZYlJNRHYvOVyPEITT9jLApIZ/+3wMqxdT7PiG+HjNOIyWsufIh4odG0dNLfxbCcOKcrwLiD6AZBYyq61Mzcjru9Kioe/sSgukMMvda/CDIVgjuht3trTI2BGeZB621lcsECDwDDRjLFpyYg46hlM5AkS75ZUES1UBLuvGzRYGDZU3iri0NNCog4u0iUpV4B1RpJ12pQ7JM4uYywr/XDqDXU4DPrh2sKj09NGA3+qReRG844r6MGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM6PR11MB3324.namprd11.prod.outlook.com (2603:10b6:5:59::15) by
 DM6PR11MB4562.namprd11.prod.outlook.com (2603:10b6:5:2a8::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.37; Wed, 23 Apr 2025 07:28:06 +0000
Received: from DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039]) by DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039%4]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 07:28:06 +0000
From: Zhi Yang <Zhi.Yang@eng.windriver.com>
To: stable@vger.kernel.org, llfamsec@gmail.com, cem@kernel.org
Cc: zhe.he@windriver.com, xiangyu.chen@windriver.com, amir73il@gmail.com,
        djwong@kernel.org, dchinner@redhat.com, chandanbabu@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] xfs: add bounds checking to xlog_recover_process_data
Date: Wed, 23 Apr 2025 15:27:50 +0800
Message-Id: <20250423072750.3369814-1-Zhi.Yang@eng.windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0250.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:456::14) To DM6PR11MB3324.namprd11.prod.outlook.com
 (2603:10b6:5:59::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3324:EE_|DM6PR11MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: e6ede3a9-8163-4084-4c6a-08dd823863ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0XFeKGgpPoei5UBn9X3hRwUtm9RE2SgTCCtSG8H2UaSIlDQ7C7ysL75eUF5Q?=
 =?us-ascii?Q?TuklJjGuIMrHkSoJDzWlr4k09n6IqtGVFvEsm5EAT3HLuL0Sizi7wOYVAOpd?=
 =?us-ascii?Q?ODZoaKkbfwDhpYcAiotbNHuTgZ/+BtzaY2KwTHjsUdf0n5jBI5zWVL9lWeMK?=
 =?us-ascii?Q?GG/rHi4Yy6PZuQscPdvBfa78HhiW4YN9qA5JLatX3JaQK0Z1hAQ+GHESqDZT?=
 =?us-ascii?Q?lQicX3jH8K+LVGTP0NGfwQy0CYAKrTHXhrCBAqoCs2NZqIuw9afiX0rNIota?=
 =?us-ascii?Q?/3B3j1fK4ltBZijcXAE8MvnaaHTw9pWOGcyasGG3px1NcAKqsD4i1dXatcVP?=
 =?us-ascii?Q?hujX6IkA830AVPHBKqNFksK7xt6pdBxVdUVlvYhTP7s2BY1HoN5Zk4uhbpKg?=
 =?us-ascii?Q?kMz3YDMno3o7FNFLYH5ceVj4haPrSgGhILQmYTMTMxxRldqXJZN5/S8MLZoP?=
 =?us-ascii?Q?MCV+86tno/92WrQ+5owkf5xDkKLRKVyBn/MbR6FvYo/QGNZJ4llyqjl/QmsV?=
 =?us-ascii?Q?BEK2MK70EI8hLC6XaWQcwfxSdXwtUL0k5ArZQxdIDUoG9TcT2KUut3a3EsHR?=
 =?us-ascii?Q?AoI93qhGTq2tA4NAnJnHri1kfWhOTLSH8WMYk2DyejJqCtMCdHijen3DdhqX?=
 =?us-ascii?Q?DqnlB7SHMrttzsMZ1MVoQ6UJ8t/jezQUrj0NXyS8L8y1XOtCNwAic3FiMoBa?=
 =?us-ascii?Q?xYoaARSrLIEQ7fj1nrdfcDRIGcMQZeEwW6KZbbepyxpmrQBWn6GMDTcG8eyG?=
 =?us-ascii?Q?gsRuJm11bktjDxTGiVDR/BfmWNuHxHS2LFcCZfF316mflCq/s8CvYOP7cLlc?=
 =?us-ascii?Q?tvXObDMxmZD/cBbipo2D3IZyK4pqwmTr7pN9s15xS07xp1P+FkM7647OzdOr?=
 =?us-ascii?Q?F8DFUSIN0TbWbIqnn+5UyHa0TCxFgYQzv5w6LoQ+De8SPjpHximHM1JXIgcK?=
 =?us-ascii?Q?U+giqpb8bs7t4jlUXTMqrj1PsLxYwzlVU+aPlKQgRSHHndEmblFIBmB50N6j?=
 =?us-ascii?Q?ApacOc43ZPVmnNHYc6SZ9cN3sBuVDecRNCdmDvn9d5dSvO9u6Rq6slSIU0h8?=
 =?us-ascii?Q?MgDdNvTf2IK+BCgeh7VXYb6cQifHwZgst1nU7hjjDzwkPOri/fLxxUTykYGh?=
 =?us-ascii?Q?TNLBJYd/emsURfpPBQd0RTRby3JMy66WTME0YYvCAVRNdIjUZtyn6LaaTFis?=
 =?us-ascii?Q?Em+gn8WagunLUjy1ob496B18h5h9XWayXJkzq4AI5JxlsAjiAoZVhXE3758V?=
 =?us-ascii?Q?y2m5ExY60tvFx7sdRRI2SrIpScrJ+ugEBcOBaZBJJrJbIwiZVjUJUqbW4CCu?=
 =?us-ascii?Q?bM9TkB7UiwKTg8YLIRnX7vWxr/XFAcUqRl5grQ9x4t7tqpgNqzCfCQD7j+uQ?=
 =?us-ascii?Q?LydsZpBzEJAyJXvpO/n8gMM/PiP/2zNI1WitP+u4kD4lmh0yWf8Fw3rDxfc0?=
 =?us-ascii?Q?1y6KIoQqqFpEr2nFbPmThbCZ7NhA2zo50bv2bcp8joRKRUG8jmoiQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2bKyafN9qwq3TTEOPHZb9g2Eqr83h4f/jTLPsDSWzbOIY6ttb4UUkg4cobJA?=
 =?us-ascii?Q?0RBuq+NZpK71orN/2bauSqfioCZYlHMoboqvbBT3YkIhDgyTSuURFlwYo//D?=
 =?us-ascii?Q?hUOu8rSoR/VkWbQgGEGjBVEcKiIwU2cplWWlRcdz2wlwMs0uOwHSa0wMFfku?=
 =?us-ascii?Q?BSzXzoWPAU/dQ5BgPEpAjvTWUfz/QT4C2pWeuIK+g3Pf47nQyES2u08SF9vs?=
 =?us-ascii?Q?d/3g6ZL7wQeVtu2qOGcrIdaV/+UV91cnztmDejT3ZK1Z3xV39oe8ruu3w6zn?=
 =?us-ascii?Q?2wjugYhAoEE43VmdP2H2s3TpV0PWTWUc8ibxoUjaH++R4fIJXG5nEs3193kq?=
 =?us-ascii?Q?A3JDIPtoNPwKflMYz5UiA2AkVkuB4xcYdge0HJPKjORKI+KUtKlYjrX/D8WL?=
 =?us-ascii?Q?A7pWBdGZtxJGbAmGwHomkJiGFM0Is3En6mPhOGOqxypsbcUQsfTTZ/eJxjWW?=
 =?us-ascii?Q?7i5NGhFDYTEA9Ntii/zzC3Ar+J9e9YAdf6LjByF+6/hm4/M8NjDPFMiQyaPG?=
 =?us-ascii?Q?6vZkOmCybvFlzQQ35xAM0v5oaB1qW7F3+fDEmP8L/uQOWo8XYlX+zXUvTAfR?=
 =?us-ascii?Q?gR64WkSiYuztahHBTn11m84f8T89ZFhkvLzPjIkOOVAw+i+oBVPOKqpgDAtF?=
 =?us-ascii?Q?tqCE3clAXpAvDbKbTE93SR47P2eGbKkEA7OevqMdUsxdKUg9cfqiUxOo+Qib?=
 =?us-ascii?Q?P5eDyhxiRKyBjD4ugvYcXTD2PgAJfAhWE3CbjdXky5NwITMrpn+1gwTR8c+A?=
 =?us-ascii?Q?8FDbB+2fZiWDGl9uCT98oT7EJ9PY7Ea8FNJJOuC2uP2nP1TGODp/BvjeTGvK?=
 =?us-ascii?Q?lg/OfV8yoG/X1DnmWSFAQMmUZmzuOog/BLnmanEDlFLUUEzoCzTLHeYxu1pW?=
 =?us-ascii?Q?S4YTctUN/Iu9GomD1jQQniW2fM0LdqCDxjvciSeGzeeW/CZ6AfCDG+RWewRs?=
 =?us-ascii?Q?yMKuGNu2rb85FdSsW8UY05mMZHDu+4YVrb1MZDgqsSkJS6NO0vM/x+V0iptF?=
 =?us-ascii?Q?mnkMCyMDFkG7nfRqe62mBwvwt3K8gsERg7STNoFdN/icTrNldwPjdBOoNOqi?=
 =?us-ascii?Q?AyMe7k092/RpRAiQDB6HmoGAOtSbvEOqMLeXc0+PcLB/txMc2cAHQgj8vHtz?=
 =?us-ascii?Q?uTDpitvHWoqeKhd2JCGTdFxDXyA0wMVv1mAuRcsymZr2phAWEOXIhzeMPY8y?=
 =?us-ascii?Q?Rrcy1PKlYN+AqZWvfSFk+nOOVcRarP2asmXWXYfpfhKiO5tT92WjJ4PIcmiz?=
 =?us-ascii?Q?dgi3EqCqFD2LXdviym5fzGkIeAc6MtS83DUBN16bzXwFiNGhQhv43wwMSvia?=
 =?us-ascii?Q?Kkgq3m0YEzrWgflB+k6+wvku1UVTJRpt2M8DRMORincpCRMCwPqLT3BIBCum?=
 =?us-ascii?Q?gos2gIrLeJslE0AyLBKfZZclRLQs37NGdCoMGIhnmZiYIQN/LATQzU47/HxZ?=
 =?us-ascii?Q?rebq5yBeKIOIrjEpJeCPOxAK3gBhfr4+Fws6SoA3DajIK3CGD9rOqzhJXWIw?=
 =?us-ascii?Q?12tGONrylcRJ+3giqNYnTblBSAct7gMFZUdPbNirxJ0CEtPtMF32I43oG26H?=
 =?us-ascii?Q?hGaE6cqhpca4MbX5pRIPXRJb4Q7VOGUmT8ZeLIba?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ede3a9-8163-4084-4c6a-08dd823863ee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 07:28:06.4783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bOZscKzCw4JLWOBhJFRB1Gf3oLaBDUNprfakMxoDDwOQGGDfmd7Q8ucqzDDlQG1ucE32iTOsxNB1yC38EzxHbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4562
X-Proofpoint-ORIG-GUID: B0QDSzWQ4u4JydMCnR7nMKHSPIqCLz9q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA0OSBTYWx0ZWRfX3leCzmIz0CYi fYK8I6jufwywWlhQSUcD+RGS5z0B++F8aPI0YT3PEF+LlPO98QWa7I01WHJLGb/KR8UfaAUJKQy 4dwjXMaWboxjQlUf92D1v7i1nxPjlUC+R8RS7VnuhwbHx5g1uCmhpzybKC8cMOoPDVYmtizVzpp
 46KjMj3wmtfR60SGVoSUxbXtsOYo/pBNFU8FD25BqufYT1m99YztmpgZshR2bicClkQdATZZKfl BYuiJENX7Fh6U6TQplhCUNTWFrMK5xmOOfMxsAKGUoziklV6Hwy2UEiqQKJVXFaaCibNGHTorod +Z1CF0IquRPCjUTUGQnFnMWZaYwbcwsGI88FiBimU/yHZwKC9O0tzUmEcgNec41cQJnYU5i9RAn
 2BGtFNJaqV0Z4mgH9Y4Glx0hrZk/x9LmHhLnJgcxIepvIXuBbSF5CY3GvfpW3sS+JRY/251Q
X-Authority-Analysis: v=2.4 cv=ONQn3TaB c=1 sm=1 tr=0 ts=68089688 cx=c_pps a=Od4c/DwoOySOAFy+VEE6lQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=gZ8OVRd3LIMJ4GaTPUUA:9 a=FdTzh2GWekK77mhwV6Dw:22 a=Omh45SbU8xzqK50xPoZQ:22
X-Proofpoint-GUID: B0QDSzWQ4u4JydMCnR7nMKHSPIqCLz9q
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_05,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504230049

From: lei lu <llfamsec@gmail.com>

commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 upstream.

There is a lack of verification of the space occupied by fixed members
of xlog_op_header in the xlog_recover_process_data.

We can create a crafted image to trigger an out of bounds read by
following these steps:
    1) Mount an image of xfs, and do some file operations to leave records
    2) Before umounting, copy the image for subsequent steps to simulate
       abnormal exit. Because umount will ensure that tail_blk and
       head_blk are the same, which will result in the inability to enter
       xlog_recover_process_data
    3) Write a tool to parse and modify the copied image in step 2
    4) Make the end of the xlog_op_header entries only 1 byte away from
       xlog_rec_header->h_size
    5) xlog_rec_header->h_num_logops++
    6) Modify xlog_rec_header->h_crc

Fix:
Add a check to make sure there is sufficient space to access fixed members
of xlog_op_header.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Zhi Yang <Zhi.Yang@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Build test passed.
---
 fs/xfs/xfs_log_recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 705cd5a60fbc..9eb120801979 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2444,7 +2444,10 @@ xlog_recover_process_data(
 
 		ohead = (struct xlog_op_header *)dp;
 		dp += sizeof(*ohead);
-		ASSERT(dp <= end);
+		if (dp > end) {
+			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+			return -EFSCORRUPTED;
+		}
 
 		/* errors will abort recovery */
 		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
-- 
2.34.1

