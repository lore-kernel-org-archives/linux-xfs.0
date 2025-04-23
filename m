Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99222701DB;
	Wed, 23 Apr 2025 02:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745374434; cv=fail; b=W5BmKGlKTBYOG0FxcDHixUuqkzHw00QXgMIMN/+3xWqtct6NPfmQ+fEXsQOzdxrOQ85AsI+kG1s+UaDyEik/i4P2iy6/vqxA991tBrsakNlzba0/wkCRciH2nr4moCqfzhiAIRTjR5sAmqavw29uv6JbeNHmyWXcAeEEk/b6wt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745374434; c=relaxed/simple;
	bh=S0mhuP5l1NMjpszzNQqoB9QCS+ARHCl8nkN3o8R6RN0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=VHE4blP6tVWlNNbMP09t6aVtTYUTdkU61+6B+9tzGGJUZLgPo8ZkXrBbzfgzBSl43sE1TY6oQdbm4DBcdnwv1d5JWY/B8oRBWE/oFCeg1gLHp5MwcQqhBQeMg7cy3TMTpYxw8iBx/Hgjug2PY6R6uW3S5I6OMKQ0d4sAX4u7GH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N1UIBo018305;
	Wed, 23 Apr 2025 02:13:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 466jhj87nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 02:13:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHFhY6AH/NHMZb7rMMf347dURmDOmvikuF2EqW8kcdDB0i4n+1MQKpm/L+EWdLqfZG2z+DdKWxms3U3DJSp80OKmtXCZfW+65BqS6FKNb0KiH04P/vTIecJs7CONOrh3IbC2Y6vKXp7uTcgOukgN76cLtenljSLlRbw9J1qdm6N1jgQMsZL39UW9+LQhw2iN5QQo2lKl+29cnwjTWSqp5RR1N9BemcsI4TBGESIK1kHdB35lZJQTTj6HC7PJ2D/oj4DMKNCIWCHFGbAsoQNaYHw014LXFaHcU0jPRgJawdma+uUhzGJPE0dSD8ziHewlZ44IFvGPzNtMho2pLGtfIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbvTRHEdvqHCqNcnQ49fS21FySz21doOLFXJQ2OHW78=;
 b=QwjMvsPwbMtZO5fqDdkLnuJv0bcOf1mZhiskXAo2RsvDS7740o6ly5Sf9IjuD0y1LCkka+d5pGpxg78IrKsxWiklOz5gW3wtN2uiJaUoKu5sBzwHQFo4Ve3b4WsP0akFY5NOi5lJYGZZm4cBhq5DUe5Uo44gBaOeKcRIj8cT4BcOkVGdmYVnzKAj5dl+fJxw0Kgwp7YYmDDD6/qS1tx9eDWYJPaR18q21KDjBS1TQERf2MZJQ1BDiXGSWTTsE4n4IOSMMvuglBXu7YO3FxlZVrdi2DrWl+g/L0yPcGWGylfhUE1OI7XbB6th25qMpV34cvWQ3jZCVX2Q05cfT6BLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM6PR11MB3324.namprd11.prod.outlook.com (2603:10b6:5:59::15) by
 MW4PR11MB6864.namprd11.prod.outlook.com (2603:10b6:303:21b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Wed, 23 Apr
 2025 02:13:39 +0000
Received: from DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039]) by DM6PR11MB3324.namprd11.prod.outlook.com
 ([fe80::fd0:4a9d:56d7:c039%4]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 02:13:38 +0000
From: Zhi Yang <Zhi.Yang@eng.windriver.com>
To: stable@vger.kernel.org, llfamsec@gmail.com
Cc: zhe.he@windriver.com, xiangyu.chen@windriver.com, amir73il@gmail.com,
        djwong@kernel.org, dchinner@redhat.com, chandanbabu@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.10.y] xfs: add bounds checking to xlog_recover_process_data
Date: Wed, 23 Apr 2025 10:13:25 +0800
Message-Id: <20250423021325.1718990-1-Zhi.Yang@eng.windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0139.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::31) To DM6PR11MB3324.namprd11.prod.outlook.com
 (2603:10b6:5:59::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3324:EE_|MW4PR11MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: e25b8116-229a-495b-71f8-08dd820c75f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZQK3FaEHNOhpc4pBLn+kqluzKNR7ccAq0/sUG4xhqwKvAQ3nzkPHsrCg3TXY?=
 =?us-ascii?Q?CbkStnIataE2lSZIylusgX96fu496/oBSG8lUY1HAmzqdXQKLo9EWyn4WqI1?=
 =?us-ascii?Q?F64vOZPcD0V5DpE0qoxZmw4klony7Z7MXlL05EnFY4H7mff3vJ8Kq2JwFDal?=
 =?us-ascii?Q?5UeSzMd7R82z3CLxote2+uyAx0KgyHODhp0GvL/EN/rLSnJXW2PQlO7Oh7fv?=
 =?us-ascii?Q?vrybsnkXZ076S6qQqeIqT+YTjFIAoppdFvrSXp7SQnJKShfid5IcuQDrUtKm?=
 =?us-ascii?Q?+5QwmawVTD12bMHAAAxWObMkpdTc+CoGWvOE7EK4rcgY2aUP64x40ro8foWl?=
 =?us-ascii?Q?rHFxdml8x9kjw/R0oXZrdiqZlsnqw7oy9TZ+LGTeWhEvp01TewAteWwUGwG4?=
 =?us-ascii?Q?JPIv96yh56X+Yo+/3lnZApOlH+QqPgcsHza+zydjTFF5VliU3nJZifjd5/sJ?=
 =?us-ascii?Q?0Z3D5h6zrLCFuXWAuR3xQvZFEaG7kIGskJiR3/uuIzy0yT/drbziQ24fcQ6F?=
 =?us-ascii?Q?UfPF8qqKrLosiOZfprc9hEXibzqB0SjRezHVTBMgZKMWkM+7GohfFMc71xQ1?=
 =?us-ascii?Q?TQkrP0kWTZYmYBhHXlJHrg8eRzMkIHxn+hWPWqj1gwGaAU4NFH12NOn/m+7T?=
 =?us-ascii?Q?z7oppPF1tw1LaD5JI0H2gkLChLoQRCpvZzRTtvJB6au4+bXUWyRKYgA7WYEn?=
 =?us-ascii?Q?VmsZq98O3qAhEUplj6SU/GS0kg3CBjlHnob8r46FSx2sh9HrBToGgOSTg9DT?=
 =?us-ascii?Q?yVpxaaLm3kSYrbQJfIWAilL3cUckL2xRM0A+XM6HJyYOh7CW1ts8m57ryWjE?=
 =?us-ascii?Q?oXdbnhz32ZTN+xYONaelmf/GX5Xf9C9bn81WORQTMreKvQiQH6izrqjLxz1v?=
 =?us-ascii?Q?DRBbQfw6eLfyPr1hlI/8UZ09JmED9hSaUvHgAQfLUpHFYw6AJmEPqJciNhOH?=
 =?us-ascii?Q?DzfWK24sxyBE0I9XPXpe463fhqRaNkU5vCdjieM64mGuEx11/xvGzASCMo4f?=
 =?us-ascii?Q?ACBWXRdqQJUX7bsBeWpEi8Jwhw+D/ElZJrJodfobS/sIH7WjPi3DD4LqtE4c?=
 =?us-ascii?Q?CLsIiMGMhsuAYwqJwI1KQVFEqz7ybBddZIBVO0TBooBO/EmtCmA7rfiaNE4L?=
 =?us-ascii?Q?3liCcCYlqtG+09xuna/moReBS+JmLKhcXleMPigDVfgb1talDl4Uc2oS104n?=
 =?us-ascii?Q?SMDawjBz0Y0fGP1G2Ews7CfKGJzmGlAmwi0dY5+D4g7yO4dBvGnXcV4eh/Qp?=
 =?us-ascii?Q?u0geKLd13GbpXSYa1s9fYjlD7n8VZzK7gOcwvk/NDP3BpsNQxcsZLqUg2EcG?=
 =?us-ascii?Q?58w2W9NSUmASpjD9R1f9QO2NFuyKFf1p3rhcxDYGA9w0nEPD5nrPGrGqeQce?=
 =?us-ascii?Q?5TTsAAIdtee69DWzXUPc3yNazce/s5NgkdfO/7FUDaI/Vobwyy9MMKIYpT8n?=
 =?us-ascii?Q?4HCdtXVKzpRrs5iyMmUXgWmKucYuJPA0lfjAnVTVtkz4s1I3CpSF4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3srkJKaH6XE7/jKe99UH8fI+bz/bQdjKIa9HP07Ir/vYVsLgJEcpg/hf53DI?=
 =?us-ascii?Q?r2EPvveDO2ubzIXr+R5cYy+Uu4Qb9SM1ZIft13/oVsOHTT/1K2y3+ht47oS9?=
 =?us-ascii?Q?vRPVrVzhkvI4HEWGHYz7RsFk5um6IOjbEGKC3lhCfq0Cv2bT1sQe07zETryj?=
 =?us-ascii?Q?gbObMTciCOR8asPonlXb1b8pPwcLInZpgNbMRXA97M4V4LG+ysujuXEZgh/9?=
 =?us-ascii?Q?7RzrEbaQwtnNGxhHC87PXRL11Jp0kjP5t8NhluvfbR+19qLlbUUzNveM+YX+?=
 =?us-ascii?Q?77dAafzeV5og8XqiblutKTZPeKFaClInTuRdOsm3ptIzWZ5mL+W53kSyi1HX?=
 =?us-ascii?Q?/ibSbS1SFhMcaRm7WST3b7kJ/qcjJ9IFbewXJ/DThhHh72vhtBiMol+CbWRx?=
 =?us-ascii?Q?2yvu657x647YMLsa1BwitxMJtBdi5KYQ+M6ShK50fzUqVZiJNCgBqx4fc9wc?=
 =?us-ascii?Q?UMcNq+zYr7LsXysAEZcOPdGuahkkyZtKxl3LnKVTHZKINtLhi/EqoqGCGPXJ?=
 =?us-ascii?Q?S4IcGxekhd7OvUgg3+Fyr8cScYL6yXVFgSzAevV99KYNQmrLhMM0Xz6PAWSc?=
 =?us-ascii?Q?LlXKJ9fpGjUSwAwHxb1YFEFWB3B7cFe/8PyJzOUIm0wVs6ke5c1bm5oO0ecp?=
 =?us-ascii?Q?Fd7Ma4NgPEMNZzTUQ/yN/ZCELnNPK+nz+d+4n75QuWe5PsVyj8jh2gWfk5rf?=
 =?us-ascii?Q?iQETx9i/c17Kz8lA8k+z71jOHIs19Ae2uK9jK6jxc11Td9yVAzDm4u2cI/LJ?=
 =?us-ascii?Q?vXHx26vjUmEqG3O66jrDVBiOMQFz8xMzUGWlI2l1IVF4qE1huky1IvJEbTAF?=
 =?us-ascii?Q?QcU6NhRp1QAf5+4aF6bjTEfnZ+01SyM+CJrm6B7iTYvnNPVYlQTGYELmxxtH?=
 =?us-ascii?Q?RJ+vdjo0NM3S+BPBWr3FB44+x+MVOEJ5JLjeGTbiwqAktZoCDaMoR2oIMtCV?=
 =?us-ascii?Q?cIBo92voYz/wTRf0YvkSe42/NHglzD4fImwbXHzutyZwEgvAS+rd7Zv43FQJ?=
 =?us-ascii?Q?EpXd6OiwQWVty4pVBRqhqKbm01iHb6xJvWzuU+kYiM4GIsUSLWpBPjQ+lTEw?=
 =?us-ascii?Q?IQTqggE2gzrcN/vYhO9cTJO+5Cc6Kuix83zaNlr1aZMcO99PQc0L1TKlBOD9?=
 =?us-ascii?Q?3m/uJjaAm1zua8AwXdyaPoZV7vMx8eKKxG0taNRcGFZ4dKzZc9jszCJKPw9L?=
 =?us-ascii?Q?abJD4ky/tRy0nrIOkAu6O5IlzXNdXjXVzmcR9WUFNKdZdsIm4hrtNFQ0Z79G?=
 =?us-ascii?Q?8NMg1bEXUCHuLI4Uc2WkFSsaPnbtYzBAJPmwwwP0PlL3KURyhrLQH/q6U4FD?=
 =?us-ascii?Q?FXCY82sQ5YbaOOtFQp7xsWYjbLQznM0qoT0EJ1ogjaZFWWuO8pXCH3qP3rFl?=
 =?us-ascii?Q?k5KT/2cpbZbc/WmKRfxrFzkuO/KaFxYrdbWuAgeyD/CbhRIFocS1svA+QJrI?=
 =?us-ascii?Q?YR6jvBFJ0dAdQd4V22SOE68wA/EqukiCTZgM7wSkpk2aSnXX5hRQ4h6uHEKM?=
 =?us-ascii?Q?7y/5XXiDQXpyQSQnm10NGz6pxUQyfZuaY0FoFcRBIB2o6O0nXeD06l/7lAwZ?=
 =?us-ascii?Q?MtXtVhwNaHokso+YPEtTRlkm92+/jTKsFSS+qj2T?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25b8116-229a-495b-71f8-08dd820c75f1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 02:13:38.8305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lXLF1n6xbQU7VOe8NpG+8bY1wkR91M2XDyqlH/2de/ONvkGk6Cr3B5HK66COj2baqrhjanxMsiDSBUXP8fByig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6864
X-Proofpoint-ORIG-GUID: tZVX9SW2jb9aVDoCa_DeHA0Np25oK4zn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDAxMiBTYWx0ZWRfX8OtfacuLEjJT Evj+sQ2pyfUvIPdo2zIbE4TqmAgYD/nmnPvzKjNdxixmJYM3Qo69WJu0XKul7yqu2jlDjZQ/nVh a9ZWk6vyPFobBeIEZwvoxaJo5Z/sdiANk4fW3Qkbm+FluVxNpdhWmuZ9692TR6p3O8mwLGNuwGy
 jUaJCz4FZ6ZyOAjyCh7o3iO135nkSI5cYX0cZNpxVV2Mn82Y8WhmRe5zX79Ghn2fM8+DVzS6P5E FjEdonXuhTSnTqcRxyiYXrzQ4tIXHlCpXD7RxJM1BynlgI2pyChuasUdrKDmDav2dJwfrl9opnC fhbW30H5pZFxHu230P/IULfWxMNQyw4wQOf3ZW4+pYFPwjcd5k2Ru7Gd+dfrGUOn+Pp1arMpRfT
 eM3ay9hZ9OWw917bf5jGlFGx3s6WMDnfg4Rsg6tKU85ye81ZHmx2vUuLVUayxhLb2t9FzAJt
X-Authority-Analysis: v=2.4 cv=ONQn3TaB c=1 sm=1 tr=0 ts=68084cd6 cx=c_pps a=o9WQ8H7iXVZ6wSn1fOU0uA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=gZ8OVRd3LIMJ4GaTPUUA:9 a=FdTzh2GWekK77mhwV6Dw:22 a=Omh45SbU8xzqK50xPoZQ:22
X-Proofpoint-GUID: tZVX9SW2jb9aVDoCa_DeHA0Np25oK4zn
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_01,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504230012

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

