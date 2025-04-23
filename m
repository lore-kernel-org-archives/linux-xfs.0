Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD254A3E;
	Wed, 23 Apr 2025 02:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745376048; cv=fail; b=a4IWu8ucZYC4vKP74IBaZifB0hVKqPBN5fkytGoFu7L5QeA0s8/efs8ox8geldTyUmdwA2DzVyolKbw2uo4OKFoH4y7D2283UYnZDilIify8+X1qQwytD9M2rG3UZb98a+itxvX6ezTzfNaTkdeCpxmQa9kIq4BRheQ1z4Owqu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745376048; c=relaxed/simple;
	bh=a0U0M7pAWZeQf1JZWiqknq8EISqZ3aYr5V9acDxCxzg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=c71Ag+03d6pUE0xnwC4SvWeCdFBMyS6khhPo2UmEOsfCRHxzivXhfwvDH1p9AbDJfOnsPSP3NsTBme4VOA3ubThqBo7pPg44bySteqlPKa2OewuvH3MJ/BJ6Rg6g1chtCCWdcwPRzFLX2E4ertCQZFJqgMVBj0wp5pD5fKAjGQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N2KDjP013506;
	Tue, 22 Apr 2025 19:40:33 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 466jhd07t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 19:40:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifLJGphG668fDETQLUG8p7d4u6wkHFi3STks/fpWdK9FMxPgEDawMc/ZikRCVMoORtZ2CIh3wFtMzrDaIjDUOwrEh22jkDnlkO4dxdJc06ufNrtuf4FF4aEFm0gLRZoekCb+Q8A6INMw+LRVMoOkcp55Cwfj97A5KszWAe/TLYFNjiLrQmDkNlop0f4cgrfv0aQSzKHaTwdXyAMuDk4uhFCwOz6d78InqfaOO2vAyXTek5JShEy6jxq1yfT6aCZtMX8r6TBueK5WfxYddAqHmetPCxHEzgLi4Od7ZgHObw/oaxAb1QIIHYy6r0UahwMLgNgct7lhpwhnJO+v3btMXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeOUJ6/WP8kDQbbXap2fy3y5PS2q2V1p1+RkAW4822o=;
 b=ZLXMieH/MlxyEw0z34yKVMouIj5eN1E/eD108sz7y0jX7zlNh5QmVaoMdHPw8vnveHs1ibnNo1BdMBsfNBUfKuQ7WuR1SYiossVQaFd9VqQppiRr5LmsQ9XPqWUG33P1wFU2ofCqpeqvjTP/olZwwR5td9AEqsQ+Vct4xdS0AkAWvtJ2jEQo2+bAORESneNK+ODevI77ofNoL4OJSM6igVJrxN15wiRp/q8R+HWuHka+agbStqjEMXestUXZS/T321qkeP4D6bAzEnFDQteFk/8dexMi5w9uPTReHtzb3l2S+ieEPf1ddqOiULX6Bs1Z7j5qsYSspbSsyazSy2sFBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM6PR11MB3324.namprd11.prod.outlook.com (2603:10b6:5:59::15) by
 CH3PR11MB7914.namprd11.prod.outlook.com (2603:10b6:610:12c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 02:40:28 +0000
Received: from DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039]) by DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039%4]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 02:40:27 +0000
From: Zhi Yang <Zhi.Yang@eng.windriver.com>
To: stable@vger.kernel.org, llfamsec@gmail.com
Cc: zhe.he@windriver.com, xiangyu.chen@windriver.com, amir73il@gmail.com,
        djwong@kernel.org, dchinner@redhat.com, chandanbabu@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] xfs: add bounds checking to xlog_recover_process_data
Date: Wed, 23 Apr 2025 10:40:08 +0800
Message-Id: <20250423024008.1766299-1-Zhi.Yang@eng.windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:404:56::27) To DM6PR11MB3324.namprd11.prod.outlook.com
 (2603:10b6:5:59::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3324:EE_|CH3PR11MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b65e23a-c94f-4cab-c2cd-08dd821031ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j3VrphVjSzcmn21ohjH0slAg1Xenip3j7dF8Xa0M06Gmm8kq/lXJI9wko153?=
 =?us-ascii?Q?0e/Sq6YR+bZKQkD/ETuXFkvv/m3/HpikFuR76nrkkhXOMN7c/akvu+vU00rj?=
 =?us-ascii?Q?2UCnL58xzUlghYYKnYNBKzS1s4k8eKwX2RgFzb7xmHD46RmATaVCLMTg4E0T?=
 =?us-ascii?Q?Vapfq1+2JiVK4EaRZQjVsk1C02cDpbSP5C4sWXoZJSIzmDJ7bSHRPbTPLdfS?=
 =?us-ascii?Q?Z8UFnI0chIGcXIRfv+23Vfv7u7envKYmqxUZhnCcyrqbyk9/tqe2NEExNb5b?=
 =?us-ascii?Q?2oQ3lMDK+2lG1eJvacegAjhEuHKfOEWndPlXgESujFL6l1Wtrd6qKcjQRu+A?=
 =?us-ascii?Q?3sXM9bu6hXBgaEeRwvsR9O6XN6qThbenT2yPqAVHnvYdHXqEVB/z+uop6CO+?=
 =?us-ascii?Q?vjqFXKOzvZSaNBA4j054sem4VS7Pzu2Kaja9S1xUwV3cgNsZYz0CfQhgEFPF?=
 =?us-ascii?Q?xXZ5SlSF0C4qGpslxd2TOAN35jH+YK/1W/AYyhr7rf7ddoXUTXEc7hH/VAcf?=
 =?us-ascii?Q?v9IgoOUrUQfLtcYjlvNdVqpaHd4UbkqI2VSMqkM+IJ/4GQ3gnhQ4Cl4uzs4c?=
 =?us-ascii?Q?ahmJi+VAjyYWfPJ0Bs4qp6C93iYwtJAJOJKrE5FeGxwQpV+fCdRIuBAJhzEx?=
 =?us-ascii?Q?PKzWRU1M30g4d2L/GrD670aNJO1Hu3Nq4pRpSRCdk5Y3WsewG5jdALHu2J2G?=
 =?us-ascii?Q?dgsHmv7sXjRQVP6pI8vbV831w336EZvwvRf5lXyICnvT5S4RC4J5RGwOsjJ0?=
 =?us-ascii?Q?l564w8skC37y3+1JCjUXbEwyawnyw7zBEs6E9+yydCIFpUrkU0e9j36odTj2?=
 =?us-ascii?Q?MQDGN0+errau3O8JT/+gF7fNhlKOZnEa/Q76+dj6iuAC8uCPpFN2mWlyvDH6?=
 =?us-ascii?Q?985it3gDXlpL6tBWerR1FpENbjukjagmruU5hSCQFxv2tgvHuNYOZSsbAcJU?=
 =?us-ascii?Q?pk3lEUjTeE9ngd/P1pI/TOHsV9bFIsTUIf4OZEIBeFIqKmk/TeICNtUc6Vrz?=
 =?us-ascii?Q?UHDjr/S+vPYxWF+hrBV6xdEdibMzZk6M8UZ9mivyCqK+Y/8o+QB6mxq6tJh5?=
 =?us-ascii?Q?HrXACundCwEjMB8SrGuVzzaanBjY9vSiCpc1Pc7+F/MPsXJ0f5EA43L11EsZ?=
 =?us-ascii?Q?j9ju+uQ/9DE5vy0iEK08hz7HULNa2+s0KIYkULabHZZD7Uy7FdSZ/9vxoOA3?=
 =?us-ascii?Q?HghjAHBWGgTjx+hjYKvFrMN+mtUvrcid++21ei3NCvxfrVc92v+mJS2ssZgU?=
 =?us-ascii?Q?jSoTiX2LKq+55EqAWf+kXkV4SxDhllpQUm7CleWE8EJV24OmPoRZ1ubBtgpK?=
 =?us-ascii?Q?Ggf2e0YCwjfPpSShZeP2uqFhJplqrcGF4+TSG1M1/wZ0FaHpITxjSL1qNsrN?=
 =?us-ascii?Q?62CqJk8XbarJExzLBezKwEAa1M6tZOZ4EJMJU/mknFcK+lnSA9A8HHgundKp?=
 =?us-ascii?Q?3hizZTwDSgMxbN+zhQBQYHYunvKT56B8iIwrH2JHaLeaSbiQ5jUjxQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kq3/+wqIsYx5yFtPodZ1A6KnqaLUx8MRyz9Lbi5JhkroEWihryyjb27jdmwt?=
 =?us-ascii?Q?zsSfVhyFpc3xL+ZmjGxOJlsIS0hGNEkWt3RuqgWoDgr/61qP2x67DZrfebzQ?=
 =?us-ascii?Q?LCSOEENYYRXAlGsUvby1yG199mX5EYHvcscCpuptMJ2k65x8E9i9+aFMuJlP?=
 =?us-ascii?Q?lmC0PElY9WrEnrtc6zt9c/tu/HSKgDbozRk64V7NMVRxiAsPWL0Nb9OAlD9n?=
 =?us-ascii?Q?JM9oCfOaLb7O6fODRL+wiRHRuUvhwcUK87v8MklAxNUUnRcNpq3KIz4Vm2FY?=
 =?us-ascii?Q?yHqs18eQJfqghbCApHF0xz8VcQ0xLwW+mFmFvMRv6fbzyLDru27REjH9STs4?=
 =?us-ascii?Q?S4axwMqY6Lm5xRJ/D457TW8K+jfpZhymva8/VHxLAwljL+pZoXxD45wkGb0J?=
 =?us-ascii?Q?eLjjYugu439gSvIi3/piI4Pnel+tkKEQajnPUjESCJansOyl3JYa6E9ar7zc?=
 =?us-ascii?Q?OHkZHEcOW3A/qTCe0d6G5/IzbQogBUugjT3KbR4TIgthMW7wKMFwnZNJnGbu?=
 =?us-ascii?Q?ONAHTlZ1llyi3Cl3mhw3kGE/n8PKsZN+IWEcQO03d3tm1oQZLqw0+AbFNg18?=
 =?us-ascii?Q?gxpz4hu/cNdJB7dAoKu12CThPKmt8ducTe9aoX+CATUsNWnDUOr0EAglxMXV?=
 =?us-ascii?Q?2b4EJTNyDqb+WPE4Uvrqhgn9W75kQOvwVQV61s+pyxY6/OUT0z2ZFT+52aff?=
 =?us-ascii?Q?Jj+Pkjbz4F/AhYeHzpdZUgTjTwDkl5lwQuxmpJCDjzM3Czc5Yx/LV/ChEIaq?=
 =?us-ascii?Q?US0+uE1nM2UFK2jyMDdKiY7Y2oLuRZZXKLV4EmMcJ+yutdUUUSjC5p3RheYC?=
 =?us-ascii?Q?PSirfftFfZc3cGToWZ327Q5KTeyegE3cEylNmQdZg57jkBI6G/Rk10Ea4614?=
 =?us-ascii?Q?5APdE2hqdSAt8PlEzk2R8hV0q2Z/DdhBfT7LNxihPbQX/ns3qjltaHBylllz?=
 =?us-ascii?Q?CHXI6+dZgOJ1hVU1DUoX5+zFQXEVliY/K95zy9OtqKU6k3KL8E2PdxinLFeA?=
 =?us-ascii?Q?SGqYVrJmZxJEGHwc6P1HoL6FbKStkTlFZ9UEaKjbog94Vg5OOmS6T3CLplz/?=
 =?us-ascii?Q?clxbJnRIazm0YpRJAaDfypLlgu25jIytw/o2KVFNEtggk9qrXstIn87z8ohQ?=
 =?us-ascii?Q?9gNzFJT9POE4eeJb+oBoDOSePEqoJ8nNL4QF/mo1lNs8d91vkmFWfBXC4vze?=
 =?us-ascii?Q?DSgHDuHZ9Trb0ZzxhyWPi0ffOipVpXyR9EYC3922evtd1f0oVSzLfJNtIn7B?=
 =?us-ascii?Q?IfBsCNBfQuINuJVUqHorIV7FdTBt71whrY/mvkvnNjeeyJacu1vkxtvMepKy?=
 =?us-ascii?Q?V2q2Vb8H3M/eyaR2yaf3Vu4HTs5VPQU0ftZbVY6hty2SDDTnqSDUcXqetGmS?=
 =?us-ascii?Q?6wyxZ3BEMoEqPWR4cvq5EQdIoT6K9Km+qf5mpUD6TG6Mf/Jlaag7PnKpdGEe?=
 =?us-ascii?Q?HYZ1GHlVF0UOkjeMSkvfzk9TMkN+Vkpy1BRnMXTBkM2bAqbCffnK6idvSidO?=
 =?us-ascii?Q?kRPI/PFCmiwbUkjWFJg7fF6iGKthhD937HLj2+TR69k0Wyokdaflbv4Vo5lm?=
 =?us-ascii?Q?neA1yjjSsefDuc8Myl+KKIZ4Z1+VCL9/PsVaAzH4?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b65e23a-c94f-4cab-c2cd-08dd821031ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 02:40:27.7332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIhuBiEJgqXd4jPam3O0X7k8jy8Gqqt+zC3oCJ7Qi+HXF96/XloB0GE9ob8pxx50xGJ9ERKHBptz2UjdZitrnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7914
X-Authority-Analysis: v=2.4 cv=ZNDXmW7b c=1 sm=1 tr=0 ts=68085320 cx=c_pps a=XlWNgFwcAB8XWrBhwjv7Vg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=gZ8OVRd3LIMJ4GaTPUUA:9 a=FdTzh2GWekK77mhwV6Dw:22 a=Omh45SbU8xzqK50xPoZQ:22
X-Proofpoint-ORIG-GUID: Y9vRASby-uv94wEHOVinHW7-0cKXILHn
X-Proofpoint-GUID: Y9vRASby-uv94wEHOVinHW7-0cKXILHn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDAxNSBTYWx0ZWRfX/E9bhmWnweO1 W2RE4QvKZVYjHgZ06SIcJRUdHtsNug947QCZtBEi5bRQ1/OCgugI5JCD7ujKhXd3S600c5EMrFU R+n8wrDfuIX+UiuI2RzsCV33cW2TOPQFEWhOIcido3c+ADOLnl5CQelIRPy2KwgA9Y6nXV6r/Ic
 RaGMeZsbdXc9P/JjUocA0wc5mGJiF8h+3GmNu7fI/bWjXWdMqPkPKh361dl13Xxgo5WwG0pPhmv SpImUGqePZ2XA+w8LXEL7+DKRxvXwrK9GYprMhO7JkJwNVCuZTPxkYlhVxIhJVogk1wNJJx2CjA OjJSLPokjdBnndJ1Oduj+GNqhPsXThyZY/RzmiwhvOwTmuMQW3lgWNi7i+SSZZ4esj9b6ztzUHx
 F3owUOR9acUFnzsTb07rYuRcTjILUEQSbufV7jatuqREbAK/a5WjQfyExM6WdSFQko9pQG/d
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_01,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504230015

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

