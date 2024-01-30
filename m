Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B537EEE4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658275; cv=fail; b=ZEWKdVVO/u+QBIsaw8vXLxUbwB0d6Cy7VD62X+8jpqxSoFQ+pL4FVdIxwFdyVs0eCjqoYFzkSeQtYrHDg0+anfpp8hbPNIGDeC6BOXSy8S5G/u8p40E5Bx7+uTThYdRd3srzAR8pEMjposd7lfHxATeDa+hEh6uY+jZij5jaCB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658275; c=relaxed/simple;
	bh=lRpjgFQMQWbjh6ZkGtiVxygUvsSeURvFKoxMTZrCUvw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bz6FBsZz1iQ9mNdx0OaNa4lIn2T/N5+5fIWqXoCcr1CPBOH2lHPNWPoXwdBRQ7N1DWfshFFerPLYllOZN26DGye3aw7V+/Plh2G2ThI2rp/U6JtpxrOFKAOj6WA6F4WyA4hoiqntdQufKt3z8cKqhBbEoXlUzri80U34vqhW8aQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P99sgeEh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=irzS19yV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P99sgeEh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="irzS19yV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxPfi023742
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=vA8fwPw/gtnmEWpERlcWOfQ2TjQ36X+WkUwZvqYm/j4=;
 b=P99sgeEhPmYJ4hddY9E1oFfMeDCbAkC7Pee1JW5hEV6hNdtX3KIo84dN+x3J00FxWooi
 8tMvloCSsI7yFLHm12bNvFcKEG1Al8hVF41exNQ1NWWYCUouV+apc4ye8np3c0uSL0fv
 t2D7EUBT4hYS2HFxsniCRxtbTW0avljhe/XBvxZcM+Ij7ilLx8JIaWzXI9+E+CQObSLA
 AxxerRPiRG017dPOvFxB9Mj1VeG+B3k/u2uDB8241e+p6Zu1FJq2esX52IfFYao41cVo
 gs9wKfEmBweloQ18KCo74sPsKaFbVJuom6w3aQG5pk3qyNTs9qlZdSItXUEt9NHNlei9 BQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2gjjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UNF6IB008488
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9eh1k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iF6NgmzSvr34zEcW+zS5Y0mgga2XFdl4Bwj/QNiwCAiwUPrTlWqOE0VVqvsTcwRFuxmATb02pnh12JXfLPcCNO7IdUJSLiTLs4ZKgQSoXjsKSZ4ak0Gou90zWSda/6W2OOHultxtnDwTR/xwOKukNTAUQJ15B9xZA8pOrj6XdViWnK+GMz41fVgaDKzxn5nj3aEVLFGfLpf93QIJHdDPiBsy+O/YWob2RVl8A1W/oVZ+8pgmlR37C9JwVf7c5dqmokaxK8KRoRAWdI2nudEXTmWDRqqENvfy61B/h0LDH3SStd2bR0v7qwPFvjUYL4V/cHi14uzvoyl0gh7+yiZKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vA8fwPw/gtnmEWpERlcWOfQ2TjQ36X+WkUwZvqYm/j4=;
 b=Yu/DM+XrzB04O+EwY2iviYCeNQxHCgeHITcyyRpuC0Tep63bMT/I2m6Mo/XHPcsBtZFlGKtNf28yMfcu6uJ2MXR3fsnmpPH0Khe5YRu/srfMq6+20bJvpe7lodsJejt9KH2husZnamR5W0VinAIl7UxzY5d8zip/K7bk0ORIs+jdNgnyM8mB3eHAaqZIiwPsFU1EBOQoqCfnNpr/KA1crWOBwmylViQAKf00ZFpepJ7iSBo1H1OubUrGOexajtV9krvR3jivL35zYNPFrmA53HPOc1Xq417b9My2wIEQwLgXBlvKuxROkNolq4tLZ6d3ac5JX1bfs3887C4ylULc+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA8fwPw/gtnmEWpERlcWOfQ2TjQ36X+WkUwZvqYm/j4=;
 b=irzS19yVyQ5+zmVAQ2aiHDrNz2kkJHny4gprm/UFm2qs7K0kUmvwk2bpZ/ptmj4LBA4/o8Ta4BVR3uWWu4esBJQGmUDedWbRyG1bBDlMpV3t2YY1spvxVrJdz9hxkq6MO5FnUYgaIW+npdTOZpg1hqwr5ysrJfVK7WsXtZ9hapw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:29 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:29 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 03/21] xfs: prevent rt growfs when quota is enabled
Date: Tue, 30 Jan 2024 15:44:01 -0800
Message-Id: <20240130234419.45896-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:a03:114::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 44e20441-f2dc-4093-85fd-08dc21ed6675
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jZRDTWFFbO+ZNhfyDdnpSYKhsLW5rM83S+1VFKiX7Rbs7eFZ9rtltCLu4hTSEZU7G+ELU/H0Fb2EPH42LIOB2P2L9nOi5dLc+2cy+UDU9AS1c+o+vt3Z5UX9BVfaF83EgRdAKzWlHKfTgJxkWVqH+7tITzhA4u1v1cDDbFCi152SrVmXwjf3DxuFSmMJH5wobMZsrm/E8lrHsnzLOUwLWobL85nuczias2eUe/5nNzRbROWTa2rCV6l3XAhBAYbQ4xVnWHMyBlO1MpFZZixGSHqdV+y+bfpqXWhqmQxbgfvCIUsSdeLPbFjv2fFAxE4BmXqiJeQsjvhtWgG4T2eLdEbNGUTOwvWFhKhQaen5uoLI9rHBMPUFcBUtaDNNgcaZ7Dss+B0ytkkVqslziSbtUoUQn9xmxuoZnfSQij1pPC7eie5p3ft2hL2ojtl2MAw92LIcXDBtLVw5616zb2XLBeWKff92Qsp2fohAidTLftSodnHdbZquFGwymm1ci7mv13ER/901QLD+bncUXoDV+VFh12E1CX50MZfrydYIEWm0/9cFR1rnVr2YZZS52ccX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(15650500001)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SJQQ5NF7uNO6IH8XBPqMqaHkeumStvTmugGLDyyG498/wA93u67bHS55mwRL?=
 =?us-ascii?Q?m/6QtqucXlIrTOE4Jk+zOvdYHO+9H2Nb0EHPnyJ3julcSRNF7zhMWrtR6oRi?=
 =?us-ascii?Q?171/dgYXlIXEFX+UAC4LSuzTucLPWZQ9MH++J9qqW/8vd5OQSt7ZDHt2GuIb?=
 =?us-ascii?Q?w5+uJWfGT1y3VUkJUqMC3mTsCsS8C7oJCes2w3TXCQOx90qaRvmTErrQfXaT?=
 =?us-ascii?Q?/6nCF8p65ALLVamXxaxBhDQk2AMmO5lVKN0oTwEZ+zqqCKFa/mY1PoqH2dHx?=
 =?us-ascii?Q?OYuomBa/THs2sj60VpnGLosWvi0M6zYQjhRlbaG4ch3hEJ9F/wercHEtkAax?=
 =?us-ascii?Q?+qWzhSlh27/JsPUh3SJQSDMIP0541sBJUxeztUrgilm1wdMeinakftm6/+cc?=
 =?us-ascii?Q?Ra9RgWcJit7WtR32Vev9P8Xoxyy4FUwozIZnOypB1Yduplsq1DnmZkiXuyMO?=
 =?us-ascii?Q?sJCWtLlfU71AuGQYV9KuOEzyb24baPVnlpY12yCLATP+G+4I85peFQq5rJ7H?=
 =?us-ascii?Q?8n5XHksfU0pIa3+9HN1SPM9YfkkXezFZbpcbrdoVBhHNyym6UI+/iL3izNWH?=
 =?us-ascii?Q?0qGne79HfBZRwiHQviNDsAUEgXRTiuhjdIF4bElp+XVkhZv+ZpSppxbRqd9t?=
 =?us-ascii?Q?YonYjko4ZR/fdTNo/D1tVsVPwrFNwNp6AdgLYlQPXZM3ujuAoH7w3kKp85La?=
 =?us-ascii?Q?UJQHYYBlzkOr4usVmfLKZDDTp9HlGx6gDLUnKVfqm6oywcPmYt+7MK63iEZa?=
 =?us-ascii?Q?39JjmkIXsrMoaynG191yUDMPXo/g/B8Kdj03iuB6E68j9InJwwWtEJFAUOjt?=
 =?us-ascii?Q?rJlZeOH8ogqLXocnlOFTMOy2bv0GnxyXAuWPhvr50h4zbFhYg3ssp9F/cuis?=
 =?us-ascii?Q?X+YhS6SPmmCMyxkDML6/aLZoaCudp1Dbv2gA6qKOFR1VNeBFNmZRDtAl4ybJ?=
 =?us-ascii?Q?oVaLyve6ZLCdFJrpNm4Zfa00G3by0gJUaffL35iAanOWUqf0Zs6CB2Cm5S0Y?=
 =?us-ascii?Q?nMyah+hufkJ+TYEOV9dDvUXvrbzTr2qg6ERWHdXlLW0Kc+LSkCgT4lYao74d?=
 =?us-ascii?Q?O4DjpjF1ctQJzHmySImv7PS/Qyu9xGObGDPe1XOA40fRPN4hz4Fy6rnlroMR?=
 =?us-ascii?Q?yrAGlWE1VhLq1mvOcmJtzzBlqYNIOHcnYMVqFlYYTi2rHrJsx7SBOX9Oqu0s?=
 =?us-ascii?Q?loRdc55E95ogsxaVsQSpEMx6KQuXB145f525K/5oi4REtkqyjSVmhl5f/9HE?=
 =?us-ascii?Q?A2ZebEifKPkxW5FLyoH8D/vdE7DfHpT1Jo8n3Q8oEL4lHKzJtnaNonrEF2xA?=
 =?us-ascii?Q?nMoej60uafufhJ18qT+ictw2Y6xH693Fp/jtDnX5kZsAb00WOOWMjR1jSgfj?=
 =?us-ascii?Q?9xzoXlC91FBTG3QaLP4d6M0GYKaNzXNBrgSV25sM9odc9Ism7ZRJwh+AVLF7?=
 =?us-ascii?Q?CzRwWBf0xpXvU0ZHP6LUHTIUO/zDQ7dNke4/e0jHdc+Kn8cbUGlOeZxSGBtm?=
 =?us-ascii?Q?lQBTrJTJ0CU+HIY7CjljpsP/fggWXTX5s9OKsgw1ARb+r0gnnEkvQ1DjStxy?=
 =?us-ascii?Q?vLt9D4c9NMYiNm653YOWdnqWZAtQdshWDFz6NvEXi2b5etn1SHLy7WI47ZAv?=
 =?us-ascii?Q?Z6KY5pR6qUOg5UP6cQWAfZYzjRcWwnV97kGL/2ucVA12IwWi5yKst/XTM0n1?=
 =?us-ascii?Q?vEx2sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	qAp3Y6rQG3Zjm+q/cwUCmomZ5FlvvbmPAQrKD588aNMwfB3cFJ0PV2zpuQ05CdITE6y9ZrT9POrJKN5NsuVTxFiY6eFWFJPYLt9hPDE3Q2bWrNeNeMZtTq6S/8nN0i3xu3kWQ/2GYw8wfCBSp1w7YD+WVRTc/UDOqp3DcL8ZdCyjBSzdkIA+dqI7ZwxguVcXgP9+fmueOPgC0SlIKDkpla9x1wKnM1OkimSDM/8OuNmWPWZltqfxPR+PTUfpZbwm7uEX5OBll3A/uwbXNiG+tMFFJJZutyf/PTeY/Rxzkzs8lTyvK374qUJCC39KljRM11XWQm3XYSVthXYnD7hhAtOy7WF6gXluGObIElGbF/ofnS1s0JlBwc67jXTO6uX7f5Aw+QR/QVrbb0TCUetl2CioIz86/d2BrdGBp8AGb1RhDH8GPc+qQRp9js+kAqvYCnHDqdweRUFKR0yfG5vIFAvXQRw0DzeEy5tIowxfC5OPRLTc0N1dZzqeUWIj5ppj8F0Mlw/qSQDBu3OhXi/bV8HJo9tjKNtEquo6TUGSq4Wkz9wiFnysXoplaqWotCUPQPN7p8wNyC13W6f/PVsQT6DQvUcG+ngrz2QstP7qF/8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e20441-f2dc-4093-85fd-08dc21ed6675
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:29.0530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+BOvSghBE65kWmekb0CtZvTctkyZz8qdLkC6L23f3GFUlDfXGPMPfJbTnlUnAdZg15mXMPXdisZfYslIUV8jJFw6tv6g4Tyr41cO7HrKbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: Ck93P_YqWltDUF_Xspf5VvVMg2EPxmDS
X-Proofpoint-ORIG-GUID: Ck93P_YqWltDUF_Xspf5VvVMg2EPxmDS

From: "Darrick J. Wong" <djwong@kernel.org>

commit b73494fa9a304ab95b59f07845e8d7d36e4d23e0 upstream.

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb,usrquota
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..31fd65b3aaa9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -954,7 +954,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
-- 
2.39.3

