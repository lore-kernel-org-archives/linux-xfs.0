Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A83E2749EF;
	Wed, 23 Apr 2025 08:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396785; cv=fail; b=KG9rYxeLesy7+vF99C0vdBIxHfBC8PO7P8RVZBnqJMX6owzHMQKPTV6A6/iR0XZ41FZRUU6qEvHzIInO1T8zp7t+6rX9W74uV5fLYD48o/q5gfu7i7lXQVBfBdQNEOY9KNQnnv7+k+9bFsNCdAbolcs0VRbDbmiz9yILE32SItg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396785; c=relaxed/simple;
	bh=S0mhuP5l1NMjpszzNQqoB9QCS+ARHCl8nkN3o8R6RN0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=juvb+Y05GTYMocLp9PhTMvPJW6sXuH3zEfyw1U6nt9ACD4jOcFskHmbu7+jvHhZVD+iWk7+PFOgrz4cu2rA5ah4a2aVkmL3+hdWFpMqx9f8rO+Sc9YQQSCJf6CJQjAUQfIRVpZEkgBsPGoEC9d+uXVNEcCUWJL6a7Ds+cQdtUHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N5K3VK004418;
	Wed, 23 Apr 2025 00:45:33 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2047.outbound.protection.outlook.com [104.47.58.47])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 466jhareqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 00:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gg934j3uPUkvvgeNb3pCFwI/DCdIauNWECv4uq0fqIkLHShXK48W8OBMFpSqSipc7tFKB9hE36jvLXvNLp2ZlmANjZrCan+PET1KHUuST2D+OX9sjAQnesB6TLAGkfgRdQL3wDPC6BhDw9YutzAg/rJXY55B31OY0vpZOX3Iw5mT+uxSb4Pjpf4NLsBZ9iaWFsP1vra/qXWWawZcsqiojkty4ZL5D0/0+GEm9Y87kxlsGlz6ce4hKqv1fB6RsYvlzLDjm4DzXsHe+lrBge0p+L1hqFkoutoj4DqmrvGx5NFEjWdkawLxDpnGF28jr3b1RRVUpiyqThXC1DiZfVaaRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbvTRHEdvqHCqNcnQ49fS21FySz21doOLFXJQ2OHW78=;
 b=QwUAuvAC/bxx6UoSVSfiV8kgoFmH0MqjFdgbAj0DjsguvrKHAhBLQZt1AaPR2UOtUU/MSaKY5iUaeSwp6KrsT1vRf6Q5Qvr6zoej1UkJSxnk6FMIhAhtLh2axhCp1SW93sw9mN/ypZLXNpgxpZWg6t/24EZC3PAsxdL/n5wjt3QLyGOzkHLa499tL2ykHu5MSgNOAasps5k7ezpWy/Zmu1TNc/Lm1Eqboa/LS83N+8/REQ/0igKF6bBTIBjVjyBvx/he2Q90qrsRd1OYYs99wwOh4a/uInTokZ6NpqBg/N2BpKjK7ghFX64fWGBd8nmKAUVQm0BU4LWA361WJp/B1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM6PR11MB3324.namprd11.prod.outlook.com (2603:10b6:5:59::15) by
 DM3PR11MB8758.namprd11.prod.outlook.com (2603:10b6:0:47::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.35; Wed, 23 Apr 2025 07:45:30 +0000
Received: from DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039]) by DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039%4]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 07:45:29 +0000
From: Zhi Yang <Zhi.Yang@eng.windriver.com>
To: stable@vger.kernel.org, llfamsec@gmail.com, cem@kernel.org
Cc: zhe.he@windriver.com, xiangyu.chen@windriver.com, amir73il@gmail.com,
        djwong@kernel.org, dchinner@redhat.com, chandanbabu@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.10.y] xfs: add bounds checking to xlog_recover_process_data
Date: Wed, 23 Apr 2025 15:45:13 +0800
Message-Id: <20250423074513.3861455-1-Zhi.Yang@eng.windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To DM6PR11MB3324.namprd11.prod.outlook.com
 (2603:10b6:5:59::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3324:EE_|DM3PR11MB8758:EE_
X-MS-Office365-Filtering-Correlation-Id: d925d592-bded-4434-6c52-08dd823ad1cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?be2U/xcatKTqfguKh6xgqOtWqrsO7mON7VUC3NvGv90DHzSkpxQttZ89x+t9?=
 =?us-ascii?Q?DzHRAuE78wHvy19XPAnilj9mnQurOsP/cO0dVOL/hhZoLM6BbCTFq+SHmU8X?=
 =?us-ascii?Q?n+7Wj/mmTL3ldGw5M63lYpw078i4AqyW4oLZsxA53VairCVXEZ+E0Slp5JLM?=
 =?us-ascii?Q?/HbyG8OBkv/EtuhPhkl5+HnqkP/Qa0uiAlM0Fazi9Ni0Jg37533wj8w29ZML?=
 =?us-ascii?Q?rZJNyYAQ5Dgyp1e3r2CktbMxUMPxKG4Phbn25ZTDBpFfeS1KFtKlqvMuxdcG?=
 =?us-ascii?Q?KXpXDBXYSkSHWIzb2PA3r5I7HWir29+tUATIUQqFy6bpbJOkTD4HhlJGGBvD?=
 =?us-ascii?Q?SqOPlA/4nGv6pGtxGkFvFkpnomZJFOlB0C6JFfgjOkOfVmIptpV4rEe9VIst?=
 =?us-ascii?Q?kWcLhnij54VHPQ4z93+oRAtXlpvVbiHsnBC0EsXcM2Ehfp97ObuI0oXk+bwQ?=
 =?us-ascii?Q?ajZ52c+r7lejNg42+v8zRUp5mUdrh+AuBJzAwAF8/hbJC1S57cW0ZaTmCh18?=
 =?us-ascii?Q?AJa1aGvYyyGH2xc6BNbsL4dyVU/cP91N0wP93GZ3Jw8pBm5nrXVt12AaO+hI?=
 =?us-ascii?Q?R2S2guCNPfSyuw2zCow5BLFyw03wZGjkAthZJCYJppFybxs63rmdaUGzG2ZP?=
 =?us-ascii?Q?0iImbR+EX2hH2V77Q7vqEy96XUt08OXQXnQZGdFFmITjcNkbEnKVwgot+e64?=
 =?us-ascii?Q?VGBaJowLu4y7d2NgPyjLS5p7z43YIlVwkgiPWYK+mW6foi9J5Neh7j6vXkvr?=
 =?us-ascii?Q?t2feUGgrI0sF429Nc1qH8GvTxdDJCM3kgElbssVE06131HmXjfT2cUds0BV9?=
 =?us-ascii?Q?uyaWOIkTQutUJAmNaZoZDOZ0slvkT2vmDgW//dGOvPV68ZqKYpL8grD6sGBn?=
 =?us-ascii?Q?3DiDrBSBNKybPKx0IH4t7LfNtRSzcIP5XMtXg6W+Ec2zAPrMn8RjvMZ/+tJ7?=
 =?us-ascii?Q?foA437uWr7Cr70J+lh+tA5w66c9hrpxNHg28wlFULRT2LDt+kE4qZymWYZfH?=
 =?us-ascii?Q?azsrzdddg63Tvi/RuxIPkuFXie1e81py/ILSv+DxyJUrp4QSh841p29ZCkR7?=
 =?us-ascii?Q?nJ2joXGW9goPpbBEOGq4IsbIFlCU9ibME4tHetZzmTZ2rVhmbsyyhr5L/Jit?=
 =?us-ascii?Q?8wMZod8mqhNwwwTULuwoyxvRQykieX9RZAtw9WbL6xGirolndtMD5+BIbdU3?=
 =?us-ascii?Q?VJAXqOm1FFWPAsL7YflKS29g0d2dh2SzJPm23mSM/l0nd3VrKY+WUZHYA4kd?=
 =?us-ascii?Q?dW/3dst90pu/dS9kq8GV2FQNJ/4AzCOT7KE3yoZxqUgame1y4I99pcNDJxg1?=
 =?us-ascii?Q?trZfIkdRPwg5lNr2dTHHjloemfh8AoMHybmD7UJLCWnrsUvDaMyqAr+R37c6?=
 =?us-ascii?Q?jZXrImcexnLgnXaQwD8oJw54xFbN+U5o5CuCgiZBDZ8BbnmcsBB28J5iv+BR?=
 =?us-ascii?Q?HnrvLrxBOZMCKI8uKiQIK0GPbpBOpll+cgl5Qhe6r0S5mQwG+PEqkA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g1OH1WnbIhCj09iKRzYuyFHFeQh3/wHbr9vASLth64sL3+o+CTsfFFg1qcA0?=
 =?us-ascii?Q?qaEiYJGXhbttpWNxRVanGNelv7dG5IpTWvS7vL+8NW7rBQMmqL2BUnfsPlWU?=
 =?us-ascii?Q?DIKlJFe522yCeCkEaDsFz/24pwfo9Xu9CaLmdl/fpNWzhwFUcDeZpJbftScL?=
 =?us-ascii?Q?jHBVEXF4Q5exyM/W7nVZxh6kF1y7YpKJPun69scqRW/HayPuJgSeugjQoruW?=
 =?us-ascii?Q?b+UMMd/7VL4KYnGyIz4tuTsKdsb4OQRo/+WZFfxonMD8qlbjONKB6ruoJthp?=
 =?us-ascii?Q?8ypBe6NaqqzTxZ8RiQHdIjGo1nT6c3TViVuQ+rqs5WRCphegaL7TECCMRjP5?=
 =?us-ascii?Q?1LfQm7WHvlBUxsljJE1SiI7Wt6oun+de5kV6rPZgznKEwdmazSM/nmN+1zCa?=
 =?us-ascii?Q?PULN6S+7OFzRSYTyGg+LXndnrNh0doweaM9H/R6iTwJLFW4PCXaZxq6elRkK?=
 =?us-ascii?Q?i5q3vxE75zasWKYADwyTX1MMnhk3C3a28aOIK+Oy8KodYxqVImlWHBrfKi93?=
 =?us-ascii?Q?RJmza8s5yd5YGgXOhfX2Hv1Uy6vk6jajZc8a3zkzEaQGrkJW1KBHYrV8bm0d?=
 =?us-ascii?Q?bPR3GE76MRD3ITMpzpOTnFDncEtBD8GMsSPwQUflzEQmMGvN7Dn/clmPIyf2?=
 =?us-ascii?Q?x1ljPKVNL+Jg92Ojvn0/k56jQsjaLZCtzo58X9MniuR++YsZPybyIWVdtEFF?=
 =?us-ascii?Q?KXIgALmWL9n6GKuLjDqm9uXFuIYYOhQ0EWDq3a39mJgN42jAVgiWE4WxpsnT?=
 =?us-ascii?Q?u9Ww4zIE5Ys9kiba/SfaxFEI7boACCUJrSoDL8fFqX5+y3FThJkcds1CKFsO?=
 =?us-ascii?Q?4AXHORdCsQUmLZmTespDj+NZ3AOwpEaGuXUMUXC1A4RWjtl0aINbzXEM519j?=
 =?us-ascii?Q?DyRoB7sAVBLXrRk1Jba7+LkLB22HJilVfTXYM5jMGZrQHljNrqJhoFvcdPaF?=
 =?us-ascii?Q?QOJPkt1YxaG/9qR5JDWqAoyrcI/T/kNceQKlxI+qOwY7ytayLqHC94oPN9ie?=
 =?us-ascii?Q?Qef7ino6KFFDQqb5SV+6TAdccbs0+7KvIXWXDriPfqJ5xRCy3+P6AnlbZHB+?=
 =?us-ascii?Q?q1xHjMWTP/+fy6Ksuz70pUyc1L/GrxYw819mK0d0euiDI8HlZrWW4XSWcPSK?=
 =?us-ascii?Q?Nlk4Cwsi1fdFh7s+6Xzr1WZdOZVrbCsEl24Q/F2wbvo9RF74Elc0eML21FD6?=
 =?us-ascii?Q?eeIdoaJMHWOb7o38UNyhvAr99JhQ+PPtat8BWZ4KWH6T6Zg158keaKh0ftdx?=
 =?us-ascii?Q?sjbCU5hVvRl0LO0myb3uxLNEvuIKEhmN9LPJddEjBDWwL8vav6fN/eE6mQKW?=
 =?us-ascii?Q?7EUIvErv6OBwqOZqEj0+B89LjVrVsn75DS2BUdI1xQfbucfGdk5RM8xJ4yki?=
 =?us-ascii?Q?F7Cm1fVjndR0cpH0SoCQ7hrPlqdUnjw3jphNzvYTyAdyIRbduMeygn05LtMj?=
 =?us-ascii?Q?6upl01LT4EbUw/5a6fqfWCNyJ16iplYMTIJ1/0CEp6iwtXwPMUQoIJzdbkXf?=
 =?us-ascii?Q?+Rvzy43WAoX2WCOe0vNXUQ1pLA4zEoD4wiCB2ZQRcKTltejBBVRPX+o91hHL?=
 =?us-ascii?Q?itATS1b8JN3gWxjI5p/uS0x1wsZEYkfdzh/xvoi1?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d925d592-bded-4434-6c52-08dd823ad1cd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 07:45:29.7735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJ3ftEkLs5AVSwLhNmAKLaEpbx+gTyNYZ6JTA6hMuk/p7d186lsUUkTCxYc9BBre6lH7t/XAJdyFelKmfA7cBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8758
X-Proofpoint-GUID: RWZvuRFvcW44QJ_8aWt89m2H8tWTGiWQ
X-Proofpoint-ORIG-GUID: RWZvuRFvcW44QJ_8aWt89m2H8tWTGiWQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA1MSBTYWx0ZWRfX6sM/ZY+cT6LX 0/MItRPySeO2roXeOZIGC17icBWhFq2iRJIJKpxCP1v9656dkkdbMsexwgscCf/HKaaDlbch8Rh caG8Ar2ZX7+nWl/4XWEdwCiV2nirIvkQ+ozKx7tHKVu/YStOo2Jr9yFNkHd9H69AhNK9Ctlj0F/
 CBbZP4D7SwZ3RHZprYM86pmsqOGBWUsWTTrcUC8ilmqzBqQ7b+6igHrGbEPjdG6Xw1Ap6UuKv6h 4GeRXV1DwSjpLquqcFO1yDLXYCmPff9Dxlfoxb6hRRCOd7Rz+OzMxPk/G3Ii6dR5rLIK+hmg+Ly PK97Ut+kFssROum4L+fzNn/G/2Dl0cd2ZJCQGfv7dLxS8qOUYLgmqMvmMAIZ6jbzP0p+F++g0qp
 ZjvPwlXhePiDFsBLIDFXzEZ4HEklcSVZgO0McZaYzDumQKyWhNNCdrG/BrPyP9QB4u3wBw3x
X-Authority-Analysis: v=2.4 cv=Sa33duRu c=1 sm=1 tr=0 ts=68089a9c cx=c_pps a=zzjaJ2HwkiRAih7KxKuamQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=gZ8OVRd3LIMJ4GaTPUUA:9 a=FdTzh2GWekK77mhwV6Dw:22 a=Omh45SbU8xzqK50xPoZQ:22
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_05,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504230051

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
index e61f28ce3e44..eafe76f304ef 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2419,7 +2419,10 @@ xlog_recover_process_data(
 
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

