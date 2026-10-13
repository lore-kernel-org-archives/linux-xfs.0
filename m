Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D894B38E5DF;
	Tue, 13 Oct 2026 08:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879238; cv=fail; b=lY1GMMFxZH6x5SahJ9URMbjnlNNMpJogrgkn2T9NcODT6mHTSZqr5BgF4zeWF9hNY1/smhjLQqh8KlCoTSGpVErD8KVKwe4AByHvAT+WUMXuYmQB4pVOdNbLyuJ+WkxIM1C22GUZZgp9vTIJ6g1WRxgUmVPb06e8xmXvSZkm3tY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879238; c=relaxed/simple;
	bh=G8LYIQwIf35zcCyXfy8Jkwp9L4phUuIpyvkzwx495bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QMjjoN7YoUpJ3FJXfSv8Zp06va8+Yy29jA1xL7AW0RUKL71/v/3WHFu709AVp/Dt4+jThZLXoRDeYoYOUuctueCpkYfVYfF0Xu42i0HoGYgov+X17ZWelUMujWGvqorPLIRm97834fak2kqH2L3FbsKSsspvQAYflaMyr0DHdoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kUfYBDW3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l8JgXUc0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kUfYBDW3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l8JgXUc0"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D3Ct3436329;
	Tue, 13 Oct 2026 08:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=; b=
	kUfYBDW3Sy9jjh4o16jJqWUQxpFx5fg864U0o5c2FPYOAQqwjK75BqTQmfCkI21/
	PS1u9V0Dz36Jwc8prC/0BMFWKKc6PHXqHenNgGXIpeTRJg8VGLG+jlbau3tmpGh4
	M1fxxQiWdIVd4JmqgEPQksavgBNGsdJxNvaQug9wwDv2x5ripArQKTjn28Ndg2uC
	Yz46tJp4Y+y8hi/qHmFG6cJCE/dnWkFJOgIeEX9gBiZqRjljEMpEIbXXkIZkoSEq
	K5HS82vOCZBJjuXIqCXldwQiUh5d23xoTx4MrG11RGfwVKIr/f5mNi80wlV5S6dr
	zbXOKYV7eMEkqgsjHLfGYA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86ibj020844;
	Tue, 13 Oct 2026 08:13:51 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010015.outbound.protection.outlook.com [52.101.56.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjseyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OoU0ntlYm3AQRwEBKv2bjNs0mbCRZRkzKkc5VUfG9ihKIgQvMNEFPOUnMjefRH9D49Px7ny9QlvTKh25lWKGhV67Gf/vuP7z0lcdT0jbw33hWVhBg43UrVCC2NHp8xmgWfEnU7txhJnobcAMacxCEwHLPTBeFVVoHsq5G1MkKZyEh9l1TuSVEgNT7y4N2uQnGU22RNEg4rrdWrRq81FNREbkAqbWc31IZ6dv/45CCwvPRRODuSv86gHzLPsokdaNCtV9uvaxpaKq2axd9gGggqF65ATUuUWkg66g7rEabJuIOtB4TRutf8aBZZ/gtGQ9egmWQ+EUiXN/t5tziuEJcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=WRGm4Inghy0Cq+lT506/8lHJZuMt+fKAfgOtqaeANzZZFtLesGtFufXt62HO+A2uvggxoXKN6SLmKbDVLAvspBx/IK7MufoE7oZPFWOUVfmbah5wf/LL3UVH57P1E4X6aJUfjyK7FpFe9FQ1rKaoBdcHQlbz780Jm0VrQ/DDPeAqznhFFkLfV1ItxNLFL6mHuRhDVKGeqkv8YtokSrK6Y4R1laW5XngEsA6GmC5UUUrHU59lYDRRNvX0riEsgC9ajnrkiE+WbfQKc0ntp1q+6WiEL7LxcIRkQBmu6Wzb+Y3OpIB9TI4DNIRoxlAsOznRTDmoraTtL2T6atXjXLNTWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=l8JgXUc0GGANRhaABjf75bw0+K4RwztQHO2nk3W9bZJgZOPyaNn1Q9adVBnWcyOIEm6JgWC6+eUtf3a/ruStzXtEnJfDCVwqQHc/8z82nqqSiYQ3/D8W9cTGh/pVDwv4I6fBFzgBEPUDur+j3dzlNcKIdl3jcfRFbNXMlYcBSIY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:49 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:49 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 v2 5/5] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 13:43:20 +0530
Message-ID: <28bba5cac186ebcda7922107ea63b0c8cce9101b.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: c33dc523-49d4-4b84-36e7-08df2901e8b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|5023799004|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ZrE23WVqN4Euj+BFxVCrTbijmZblQ8rfH5fnBJi6GGjKpn4HRvQYykpM37SS0dxz6dra5Z9CeK+SUoDGGuEp4Awa+4Sf/4v4rRGPMd1u4+GzaY4zxwJty51ujY6H6XrWkALqzy+KxlrlM/XnhIwmCmS76l0/yhuhIEk63pY2rc+gvori9mmqW193QjrPL65bGVNGWu+hGAV4nXZ73XqdRA/PFtoqIxrBmCFKl6TDxRUVxIi26qwTW6iTxl/YYoW68GOk9hDGgfUM+jicsm20KnG8YMijO5FS7lEZKFURWYjED26r9sVgPkZPwaJSi4bSTx8MXZWB7QPlDTJivF4q+3zZF4DHhUx0YebO0Uvcw4mNaB7+4QjUlZZDTObhZz+8GT5eQqKmlr2XWSrlOD3RIbyD1lXEYmfRwNN2NZvDPTPEEuJAs9BzP1M8Etj4XRx9bFmg1RW2UVq7qJVYXAPza5xxBGH2nKVaYvU6kgivlrH9jSUrJU9et6ngCUM8D34lSLjhd+MRERyxZRtwPVEWKq3fuJR6Z5XMmv965XvBfvvGWZRw1GX9xkvzl39T7MbRcvqv/kL0I3SO/NO1DjDY76US7mNaAOeVQf4wzXrHXZuW/9z8c7mxgMurltvRpPrkZbkmLWUHucVsKsc0EQPIRgAoajDh9cutdxAPDeymq/w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(5023799004)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Greddn384D/se6Hw25r3OnAeXxq4zSP+Rf/TTjSg2m1CrSAa4WiMkeXfJMd8?=
 =?us-ascii?Q?PftAMBIpL4yZC66tm4xroHEh5r0MlYA9ibuqQ9BENfkXFVTg29yMfngp00NB?=
 =?us-ascii?Q?555ImXeXbcAtF6N/QN0JMEyiiVXK5MdchmPvj2GQ89jAAf8JKodz2/7LVv/l?=
 =?us-ascii?Q?9AgBp08Y0OdF5Lb6NaqV/oM36F/lEx2NuSBchHXY1tgJPhDo+WljrhD7z2+f?=
 =?us-ascii?Q?Xy8YPekkjr95lmrBGSvDIepDN61Q4QiHmEoDX8DihfR1YqBwUuL9vq9RYHt6?=
 =?us-ascii?Q?32XHvbr4uOmopFLV0VKCduLAUDjEx+O2BXSXwjTRl3j79ZiuycXXbtqR7w8B?=
 =?us-ascii?Q?tDCe4YnWLOwlFJoaqtHpW4VRYrsDjJRd/wtCifLowhRX1VrTsGCX1rIhrCmq?=
 =?us-ascii?Q?uCL5ce3qmyusb+t0wB8zZKQVggb5CWrPtE7a/Javnd9vD8GGZPpNFu382La5?=
 =?us-ascii?Q?DCmdvRIo98AufSKg+RB+xf+sudZdwV2ysGMMrJ+M1OAJb0TZLi00WRwAXGun?=
 =?us-ascii?Q?c5BnvZTJxMmPHILmBvQaHE6fZV8TF5uAhmpUpOwGN5d3vzq9f2JJzv91UWgi?=
 =?us-ascii?Q?YpplGo5D+iv22YURJr9FeWP7RDk22ByQzkVcuQ80it8vOas5hgG2mUn/gdwe?=
 =?us-ascii?Q?RPZxm4HUpZmR46RWnzgNl78llgrZBRQg9AW545fWSv+W0fnSFvDFyI9/yAUX?=
 =?us-ascii?Q?V14J+3o5+j7L8W6zzNodpLcFl2UyM0jHIx/GJKDvgMDI/5akcwRAME8MOlNU?=
 =?us-ascii?Q?w+p5MzTQ8u0tCMLCkWHTkDOmxCn/BsyRVJfrBE2zmLddFJi+KE/4y2/o5G2P?=
 =?us-ascii?Q?ia/RGx4padfPO/M4sLqHp7VT1yVXid7TSoLEBI/yHvTnxta4aXX0QCdxfsBq?=
 =?us-ascii?Q?cZ43XUMOylpoB6RC2PSpH4615DB2GLlZjD2bRzPvTmZtlcrE0bt2Q8wQwD8I?=
 =?us-ascii?Q?+5d2asILJRAfMo+mF7/tAFogDOH3AJNbCKmKTwWPOMlk1PqkO2TMnnBdLrBC?=
 =?us-ascii?Q?2ZOpazn+F1zsrzlYqty0PQupNvPYCexjg1ozRdYibo1KIYJXNegM3ArxBb1u?=
 =?us-ascii?Q?gyezBF66vxe+0iROLrp3Aat1sgFno3FsCUJFcfTMeaZYxIIRcDkzWJudszfZ?=
 =?us-ascii?Q?34cO5RFum9JpZq1rXz3labCYahkVli/GbZp8HzSLzzdtG9XqYna7UJdOSncB?=
 =?us-ascii?Q?chkEsJgHrMT0V/rS9GxDjABrzQRCTELn/lOt5MPIJX71RFYtHOp+f7asqQ4a?=
 =?us-ascii?Q?Lj3NgVucvZncVAEQRGVuQw2ZvBEemkIcWlbVqnLQ4CJ0naSQ/sRkuYd41KhC?=
 =?us-ascii?Q?ZgwENXLoSkFL4BhDyiV7PWNUJqX8mKJVOh71bNrq6W++mw5N6PX9oJ3xt2VQ?=
 =?us-ascii?Q?BMARtfTSZOQgyao5NCYHS2OPPXsUIqitYW0wJfH2/no01GieTwgeRCpQacku?=
 =?us-ascii?Q?phWs/RJs9nvb+Y2B1gKlmUO5F2EbYljPwkTZffFHGZia/g8/YoAqO775+z/0?=
 =?us-ascii?Q?lk5Zzayj8O+SCURLTJ7H27/paIPwHKnCAjp8XEVDlMf967IdRxhONmVXyCFI?=
 =?us-ascii?Q?IpWLnS9mbiOpGTIXNg7+icoSQiAxfnuoSs/CL+LH5MHhX51iK9lcmzKCwBic?=
 =?us-ascii?Q?BvLLSI+ZrNoCesp+8HkFbzunRpt6N0Uag3oK0CjmnSnOX2kw7Je4OdXv9NTk?=
 =?us-ascii?Q?4fSGLhxJd3t2Xgtvt8DRBmNEEGLs6eVJL+ibwWz4NLfdJcpCLdocnn/r86Yf?=
 =?us-ascii?Q?Ksz8ZWsXJxg7NSCiMsaogq5xJMbm6kg+Rv5O+nKMnL9DR9kDGvwAlN5gWmgI?=
X-MS-Exchange-AntiSpam-MessageData-1: opuqy3ZnTnXwSNOpDIUW2ejrzdfmnHuiPjc=
X-Exchange-RoutingPolicyChecked:
	dyQM/G7JCJ/ymg713V+0cn5KqhXirxWdAI03FRwcgzLbok7zmdyJFxT2tmf0Aaq18JsNEtaLEp/UVQ7Flwl/aJr3Zqn+FTsQ3R7QV68Ajdqzox+gopqBKLaKzLNTK8mFa9X2vrFfY8qAPMQXcny/OD4kzRaeYY+NEe6317N5blOj4lgCd+OHmXQJpzXiATgaZjTIloWb6XnDaVDibV+8UHmjNOMQaJ6ZXVPkKiG2SSFZ7gqrMYPOLEiAx8fIvXyCtxvvRWNZu6i/3jLLAAKaaAPGgqI/F1oGs5oWR/4yDb/1uG/JPXW3kQR3QR1U/go/3HGaIa6QY6w5s9bSN2iBtw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JULDWLPWqo3wdVIPthxxilBeAwfDRfjHOXw2I+JmC5x5Zcbhod+9pcn2jyE+o7dgIiZOMb7oSg819AqYn0zXX1WF3XVpncUy2WMr3we8j2Y+MY/hjkKJSiM+edWfj4AjWw8mAUug5OD6C0vYpwIQiZRjDVRxwITHjFm2OdOJMINLeJtwoR84zyg1WXaIE6Mld22LyKylaY8KYdiKfzImWmOG81bw/jr2QJ3aAWmqnHRJmYdPNzKVZu2ZTdMEbmqW+KH3bf93py7ecyEQ4t/MHhVXEvd1bu5M4Z8XD/YCHfDM19mdm/ZjiOHjfyeOj9op5Ue9SevrLr8Pj5Pbk4AzQXYCdQjoXhuqUVIS3NUNd3fE/P458rnT+iZXAwd9AkSJk0SNVQ6ec86g1eZth8+X4y2VZGMWExXymFF+w55k6tal/BoNJ0IiWRBph/aZvKgeJNatEsO5S3FFph1zdogQ6YF1lsDotWRhhnKhWZ7ZaQeY33jR0BTsfV8XjFYD6gmhJziwWTg9pAeCFCv0zPPK4yG4yqrjQCwUu6TXrK8Er+fGhbPwSwduaHbF5zTXIKjNkZoUMYusw5F7gBk/b0MF4FWab8aRkGgzpYVcMBGf8Gk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33dc523-49d4-4b84-36e7-08df2901e8b9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:48.9255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTspyUs7ZSOR0NM6EoW9y7y4Qf9sixR69Y+NY1vRwikgw7UP7P1S4FSlkeMtOERQyXKKXO4QItWirA9UcU6uKMmAZgu58pu9BBDNJxWwn/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde841 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX2v5E7NvUEIwD
 GZomTkFh3zs0J91wi2GYZjzTmvXLCfyCEv1evtFL+U80X+J4iX3D+gZy7r9Z7kBbSH5mkhGSwX1
 xJISZ4qZwmUKOrTHJ5CS8CJ35faMXhYrEDAb1+CgIFSVbFQ1H9dM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXwnA6jfzeZ0CR
 BFgkUmosHKZ/N5pDZt/hroYmMVOKFanf8g3ohA+CZmCyRyYW2AGFeoVNnPmVdtEKgqPZew3KiC6
 /GJ2eW0KN9mHXlJrrhVZHA0fD++tdw2eN7sTCWbTC+INEcVKoQVvlzEzUk8Udbkob18BGBjaEbd
 m/VKn+mWxElX4vpp5UNlfoVHAS89duWvXvVKx0sCA1QBwRnpz30yo/Eaw6RaMAD2AUlnVicYXOz
 101MBjucdmWKy29HYfEOg+bDEa8X0Rf7mjnCTbQ6B5ZoW77YmcqSAtjvlMbd/8zajiNqSpU9afD
 Av6OcaHNMYZD2phXfUAv/MyaEfYy4RW3GsWrtLC/3CjDf0EpsBc2LkyJwfoYIPYqC+wXbJMED/O
 4XXRw9iRkuLlb0wRmJB6jZ3k39nuEidM/gpsY3jV6eH830NZksosfwpXmeug73SWTURRrwaOHfz
 zO5S1T99Zic5YdKF8suVaUZhRO3sN7blk7YJzF1s=
X-Proofpoint-GUID: rs39p-j9JesyDLj4GVrdidT8YnLqpmC3
X-Proofpoint-ORIG-GUID: rs39p-j9JesyDLj4GVrdidT8YnLqpmC3

From: Dave Chinner <dchinner@redhat.com>

Unmount of a shutdown filesystem can hang with stale inode cluster
buffers in the AIL like so:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

Yet none of these seemed to be occurring. Further tracing indicated
this:

d) Shutdown during CIL pushing resulting in log item completion
being called from checkpoint abort processing. Items are unpinned
and released without serialisation against each other, journal IO
completion or transaction commit completion.

In this case, we may still have a transaction commit in flight that
holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
e.g. a synchronous transaction will flush the CIL before the
transaction is torn down.  The concurrent CIL push then aborts
insertion it and drops the commit/AIL reference to the BLI. This can
leave the transaction commit context with the last reference to the
BLI which is dropped here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

Unlike the journal completion ->iop_unpin path, this path does not
run stale buffer completion process when it drops the last
reference, hence leaving the stale inodes attached to the buffer
sitting the AIL. There are no other references to those inodes, so
there is no other mechanism to remove them from the AIL. Hence
unmount hangs.

The buffer lock context for stale buffers is passed to the last BLI
reference. This is normally the last BLI unpin on journal IO
completion. The unpin then processes the stale buffer completion and
releases the buffer lock.  However, if the final unpin from journal
IO completion (or CIL push abort) does not hold the last reference
to the BLI, there -must- still be a transaction context that
references the BLI, and so that context must perform the stale
buffer completion processing before the buffer is unlocked and the
BLI torn down.

The fix for this is to rework the xfs_buf_item_relse() path to run
stale buffer completion processing if it drops the last reference to
the BLI. We still hold the buffer locked, so the buffer owner and
lock context is the same as if we passed the BLI and buffer to the
->iop_unpin() context to finish stale process on journal commit.

However, we have to be careful here. In a shutdown state, we can be
freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
and xfs_trans_bdetach().  The existing code handles this case by
considering shutdown state as "aborted", but in doing so
largely masks the failure to clean up stale BLI state from the
xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
whether the item is in the AIL, we must finish the stale buffer
cleanup if we are are dropping the last BLI reference from the
->iop_relse path in transaction commit context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 7b5f775be14ac1532c049022feadcfe44769566d)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 123 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h |   2 +-
 2 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ade89a233e68..a5f3408e213d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -709,43 +709,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
+
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
-
-	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
-	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_relse(bip);
-	return true;
 }
 
 /*
@@ -766,6 +765,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -773,18 +781,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -800,16 +809,56 @@ xfs_buf_item_release(
 	bp->b_transp = NULL;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
+	/* If there are other references, then we have nothing to do. */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		goto out_release;
+
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * Stale buffer completion frees the BLI, unlocks and releases the
+	 * buffer. Neither the BLI or buffer are safe to reference after this
+	 * call, so there's nothing more we need to do here.
+	 *
+	 * If we get here with a stale buffer and references to the BLI remain,
+	 * we must not unlock the buffer as the last BLI reference owns lock
+	 * context, not us.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (stale) {
+		xfs_buf_item_finish_stale(bip);
+		xfs_buf_relse(bp);
+		ASSERT(!hold);
+		return;
+	}
+
+	/*
+	 * Dirty or clean, aborted items are done and need to be removed from
+	 * the AIL and released. This frees the BLI, but leaves the buffer
+	 * locked and referenced.
+	 */
+	if (aborted || xlog_is_shutdown(lip->li_log)) {
+		ASSERT(list_empty(&bip->bli_buf->b_li_list));
+		xfs_buf_item_done(bp);
+		goto out_release;
+	}
+
+	/*
+	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
+	 * locked and referenced.
+	 *
+	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
+	 */
+	if (!dirty)
+		xfs_buf_item_relse(bip);
+	else
+		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+
+	/* Not safe to reference the BLI from here */
+out_release:
+	/*
+	 * If we get here with a stale buffer, we must not unlock the
+	 * buffer as the last BLI reference owns lock context, not us.
+	 */
+	if (stale || hold)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 8a8a46e698be..141c3780a36b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-- 
2.53.0

