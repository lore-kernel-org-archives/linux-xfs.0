Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43961FBF6;
	Wed, 27 Mar 2024 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498397; cv=fail; b=vE2i9pyvw0X0ejpHCkTn9AeMPXAxNik3KmHzYxIeZcSylWA3Ji6vpA/G+B6dgUIAogZYQ9MV7hKXEavz9SfuTDIrYJ7FuIOJNPmexA/eTYURpuf+TJIN92Z4O+gZfHYR+I9NZMJkyJbR44geEGFrQ+HMxXuhMzSYelRZdjJrAiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498397; c=relaxed/simple;
	bh=Ellp+o3JOvLg3R4yqywS4n6oGThhoe/pGJ0OKs70SaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OYv5FRLpP2PqKT6Gbyvs8mITW26dTGWc5VVEA//gz3k6WyaXe2Lq/3GtvgpIdWRVXnJ8cmxoaGoV1aZOdaH2FZWrQ37Cnv6+8mPbXR9J5jrzaZCw0nnvgO6+h57SQ+IXxyIGAfJ4u+4zKNLRD/bk87co5jGLkVFWjcsi2ps4ruA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yi/YYi1G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FpvEK1IC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yi/YYi1G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FpvEK1IC"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QNnmdf008836;
	Wed, 27 Mar 2024 00:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=zxqqn4ZvmGvWg65yF7/F7PKhj0KlcSw8BUj9H1A0U4M=;
 b=Yi/YYi1G6tbe3r1XydgOmjzjNBvtv+8/N+HS6POEPv+oib00KcHc1C3o7DNuCnTjfsA/
 lKcC0G75E0iNegvXJQsroZ8gv8e39PtjZ7/geGJ/qSITcLVtqf9UBluGiBVVCa3u3icX
 iLr6rWR3ptaJDf/CWah3SpCFaWpULj9ndQKprmt4zcYj7mReqbz/HJ+2V4ZlABTbvRMl
 DlZRgf74TcVtiFLtdBinP7XM/5nUwBbLco+oyVklgl2f3saNO1BW4DyrUA8Dxk/aWJLv
 z1W7RX8S4kE+5dvRdFhpAMB5HO7dORPSJ9+WHNvchnKLw4YpNpIyLy1NZXbcndwWEjws 5A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvsd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R07Lra020687;
	Wed, 27 Mar 2024 00:13:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1ajq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzXNW6QkzDvatj608yeTstnq3uzty0X3mC7CqjjG2kJu8Ndcsmzu4xQXj+E3GkpoQxuY3Xy6Z+NXhczaoaAnqKHF50lFWlUKNuC9Elh6XwiH1SMw+1Nx3m6TjpR7tt2YO47+d1kxXxrrcAePCnm8jlztR7zA6UwxPwwATxejrSFsLarA3m0NMpMSxz5Sy9T8nOJzVEoP6eR/eM1E+woMZlf30v3NUpuGcVTtE8v1GFAJC43UYmMWSkePAXeeccX+5w6DU19GmN6fVlVz/NTVWOObwdR+8VaduqcTT/a6b7OPE8G7Qjdjx22gX+pDTe084fzjqlL0U7mg4mDJppiPhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxqqn4ZvmGvWg65yF7/F7PKhj0KlcSw8BUj9H1A0U4M=;
 b=BGCyotao4lS563v7hYSTBQYe+NmA9crwor+qt27sHB7JdBGO+7HDbG+Lpx62lAT06uKLst/XNfzf9qPTBcHmuXhFGewNov0tFVRv/X3C2OH6pnLymXf5N0e8RKZ4CA950Fa+JYbkobgz1RQImTzmUOsR2Nt2YLSr5RIdnKZHtLb3iPy6fZIc476l6boIAve5c1VV9MCf2cplG87QAsW1lwV46T/BxetDUwkFM/CPDEneb9jjdjXqtdkuJmSNtzEVON2pkdgeuiPYd9HqASH9XPpYtfNOF55kyTVTF3xh7kSR7Kyj7tLMcOmygKSMS8MQNjJ+wHns4M6/1IOanWOAlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxqqn4ZvmGvWg65yF7/F7PKhj0KlcSw8BUj9H1A0U4M=;
 b=FpvEK1ICOT5Dam0/9f745iLniFK7MAocdBZjyXNLXspBg5yR9k3zmgiUk0BkGd1iKvnBDwXGE+sqphsZiuXsRZTml4O57VNoVeL9nPJkz5FTWWcv78QM+E1slBmIGLo7gs3m1H9G2g8GuxCktkZmljucQRwv0xuTozxMym2MzqM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:12 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:12 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 14/24] xfs: fix an off-by-one error in xreap_agextent_binval
Date: Tue, 26 Mar 2024 17:12:23 -0700
Message-Id: <20240327001233.51675-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:a03:180::42) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hywl3L9XjGktGnqGrGBmByWpCZ0ZWXcMSl4J986eDDPFZXcUo19GbAkHKR9deIC8btFVqgmJEsbPm8hhVVaTBwZuxVUnB3DuovEk9DFUZOqvaPI5B+BnFxqczji1MWST6AiFU+mzdXhlfSJ1JBbEr/zG1678uyD1cDzuYsP9enoKA4jfA3zZS2IA2q3wI3EadZri5/KpfsADrPzd3s854/sXT/bpvq6JuUJmGbLO5ANlwJRHhf6IivNiMSQlTeAioXZz/kt2NcKr+54QSz5So5jUhanSNRN1zc3mIH7VtyHX2MLiT0R5slZl7t419tvQTwHUf+5K3WlYSl3rubHAYVxcL6RMTUSjllr8dbHvqmAgZxsK2v0ANLBcsbWVL9nNmO2R+3sFzqpw//2HxzQEEfVWES1mwMFSubh1U9nLed8NuLQaGy9NwsJS5Eu5+PD503k5pjmKqUIQF2mZK0mGtigsytsX8rb9hsSVG0Ao6EoG3KVVHIzcNd7KzalV+27XkB1GNYFdPT6+6gwG21/diYQoRrr7TaY1CNorDeVWbcEu6JBXTYfsvpPXkuK+Jo+UrqvcMQbZnv1u8Yfg482F9uV8bBj/gmPdPbXrsii1QkUOK9pM/bBwtbCCth2Aux5BVZV7Sg8oPGsEOzvC+rNUDWh7QERD5FiZKdoS4YyKjus=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nplVLdEAQyiwnThEa/wfYgk7ojqloGYfpeLARlRVWqfAOAKSpeUv4NOxhnZx?=
 =?us-ascii?Q?QBv7vKhHcX6u+Dpv3F+jiPJ5cL5T/bcZMiSQ3eGjyADlwh8UQFvvQhQuw6YE?=
 =?us-ascii?Q?y9XtxLfLuZcsf1obKUxk7MmCrtFuwZGGKPgMI4Hl0jUG/MTFv4oyIRdwQD2Y?=
 =?us-ascii?Q?J2j59zx5yyEZA1A3HsTpibCnjfXVOzWCpM/kkh9SiSFIEXrJ60lAZ1NH5+Po?=
 =?us-ascii?Q?hB5s/RDTDSM5WhF9u2VdqWoS+l05uyzw6+aE+R11KXtHdjCCnlZvje9bixdC?=
 =?us-ascii?Q?ZDPvpvFpXxLQKbzX/Jew9bePyHTi1ucLysXfBBxsaNMzctAR/7L1MXp8o7kU?=
 =?us-ascii?Q?TMVOff3eikYs6Qen98FuzNfWbu83KbCP1AnP1QidJE6dOW/V/Y9fYQayPVjc?=
 =?us-ascii?Q?34BRGtGaQbBLQ8u8viHoEN58LcYmX70HmaOuvwNTukbtsByl4gr4VgFOAspb?=
 =?us-ascii?Q?yhTZfjxbgDdKvCngAsFhFdynxg2/UsmMlH9/SLQXApKVs5JULjemihmwJ+Qp?=
 =?us-ascii?Q?sBWMQJG5d8vi865f3eLX9tH6fkDG0aU/OSRn1jpnWL/q2T+vZwbNNTf0RefY?=
 =?us-ascii?Q?+7XNu+MJ5KZDPexkg2Dx8dqHnxVVAIHDA98Mm3ku3PVtDe+CdaHInqMFP/aX?=
 =?us-ascii?Q?bcQlWowxPQsin/XEzx2LhS/1KQoaLdargH3Wd93sOKdbvCrLiCqGxHyQtIeE?=
 =?us-ascii?Q?Z/JKTCXLDY4Zj5adq/cvVtT1dPHl4aI2rxBnYaQu3ZKy94ENLDYuthoeDXMa?=
 =?us-ascii?Q?WTGinTiKix66OiPvzvx2xcWZjjk4un4jrH+gq2BV7MNnNG7HVlohdlHdVukq?=
 =?us-ascii?Q?ZwG5qs8f+en7KQ89WRl3F+yiSZ1d8A8reFQxBi1y1Wqf9VwciqI4SD9uR+3g?=
 =?us-ascii?Q?IbkRUk0n4JBxe4l+zMyd2DR+97jKXW8OUuc8e0ra08/4uS9hv9Da97Q5ml8d?=
 =?us-ascii?Q?J7jC5bxL4MyGV5cvb9Z4xD6t8eBGsdpiG2eG89H8uuNNkHvK6ZIW8/VF4VV/?=
 =?us-ascii?Q?WaPHY1j9RSAl8cec3NDYdpsGQoNgB64qO0R8dCzg24LBkoNz/DQatAaP+XRg?=
 =?us-ascii?Q?TF7EpgV1SuC7bkbmhYhPP10Gf64jehzr9VHY9Tur0TP4SFz8x4He32S/b1yp?=
 =?us-ascii?Q?Nu9tAxa4NTW7tKnEubQ94wZyaQp7Esm32mLWnstB3EO7V5TV+H5DckGYwwr6?=
 =?us-ascii?Q?+w8/wJrXMc7GscNumMmhvNLZP+c/Qbvl+geiAtO0NoPCBeGEmpWXvXNnh6TT?=
 =?us-ascii?Q?V4DvrSmtjU+fMcCK40RJJSELIsA7NZr7+KIFq9Y/O2mHEh5Yom5DGc2rz7YV?=
 =?us-ascii?Q?c0mIc60nar621DLKPjmSnlsTlljjMpF+vX4k1JbwVEAD1/zqb8NvLdYmc4B7?=
 =?us-ascii?Q?Lo4ij8Rb7CIc5JFQwf4BKWSMBCwD9Zpu5JdxzfDsPwHDfFuqP074v5QSoPhh?=
 =?us-ascii?Q?EahTVZSgeIrZVN1HfnwGMgw78TxEFJluGNsoQ6rGjDLK78yPm2WWW86t/BqR?=
 =?us-ascii?Q?KZykrGPbvTpdRhOK0SWF5MiUstoOKc3jWwT35OGa1g+vs3DsLaiwGe7S6S3X?=
 =?us-ascii?Q?PgHPxVysVtW2EOs6fO6h+HF2QLArM0xCvpmel4Acy00JQzv95ZODGnwOrxNS?=
 =?us-ascii?Q?urONS3tkxB4rJ0UIFjtSKIV2OAXEEaBp59bH/74HHuUdyaEd4bbC0JnlfxGS?=
 =?us-ascii?Q?1bd5JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zu+8CcegigVzjq8oKRSAEFa5csc1/dHIYNQIhGlB9QCZJbCc1o6iGlW15FXDYpwd+3md0dNcjoBTyDns2rv9mZYa/woDJWF5LeqxP0xFQBtx/JNk1O1XsefJrvwYad8BhS1xE8oNa1p3bGcBuPpeIPttFNo+PaJw1LChUvSgIXYR/tYAajtOmPRl/NQEBgo7ERgRWuNMuWmUZzioaVTa5UuhFVFkznsXFlRFEeiSsrO5iU8ZMLVEvPJ5R6a7+h3ZrJStW8hMJEv6eNrTec+NbsydoMOhbfIjweFg/VX+cp5W+v9WsBaewHAP0x11n8cGcpwYBE/Hfhy46+kIxrhndZ29xX6+sma9CzY5AT+p8eraei0e2HdOnAXbt/kRW9gI5cia5LX18o372uwYw3fYuZ4yjbs+WBaQCHb8Vfj1spuYxh2cpgZ9WctSZZP/MBxF6afy5BAEOsGqN/4HbB5ETqJ9Bm2WZxjk8TYTXrJRj+qV4HRbr3ypaxMOQk5ALAGEQc7OcslKaYr6B8tX8pvQBX+6SP1VB6Z/fdSV5LdfSgvHmVKT+H94NXPIUjaWtwioyfqY/zG4Mk2TrJjqY6Y3W4au4wOLiKP/g82mkVbyHh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac2c94c-0d36-4279-7da1-08dc4df2b076
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:12.4978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfgUOQof+VM8c7ofI7Vq4wmIkfMRodw6JV/Asep0Cg1gvvYrBx6ZOabR1c/IePX7+xwCYjTHNwulGdMxZ6AgWn+5n4C58UZIsjmzL4ClZzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: CO4CNwHpZoKHYsfKCOoRCCWUGD6CzM9r
X-Proofpoint-ORIG-GUID: CO4CNwHpZoKHYsfKCOoRCCWUGD6CzM9r

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0e37f07d2bd3c1ee3fb5a650da7d8673557ed16 upstream.

Overall, this function tries to find and invalidate all buffers for a
given extent of space on the data device.  The inner for loop in this
function tries to find all xfs_bufs for a given daddr.  The lengths of
all possible cached buffers range from 1 fsblock to the largest needed
to contain a 64k xattr value (~17fsb).  The scan is capped to avoid
looking at anything buffer going past the given extent.

Unfortunately, the loop continuation test is wrong -- max_fsbs is the
largest size we want to scan, not one past that.  Put another way, this
loop is actually 1-indexed, not 0-indexed.  Therefore, the continuation
test should use <=, not <.

As a result, online repairs of btree blocks fails to stale any buffers
for btrees that are being torn down, which causes later assertions in
the buffer cache when another thread creates a different-sized buffer.
This happens in xfs/709 when allocating an inode cluster buffer:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 3346128 at fs/xfs/xfs_message.c:104 assfail+0x3a/0x40 [xfs]
 CPU: 0 PID: 3346128 Comm: fsstress Not tainted 6.7.0-rc4-djwx #rc4
 RIP: 0010:assfail+0x3a/0x40 [xfs]
 Call Trace:
  <TASK>
  _xfs_buf_obj_cmp+0x4a/0x50
  xfs_buf_get_map+0x191/0xba0
  xfs_trans_get_buf_map+0x136/0x280
  xfs_ialloc_inode_init+0x186/0x340
  xfs_ialloc_ag_alloc+0x254/0x720
  xfs_dialloc+0x21f/0x870
  xfs_create_tmpfile+0x1a9/0x2f0
  xfs_rename+0x369/0xfd0
  xfs_vn_rename+0xfa/0x170
  vfs_rename+0x5fb/0xc30
  do_renameat2+0x52d/0x6e0
  __x64_sys_renameat2+0x4b/0x60
  do_syscall_64+0x3b/0xe0
  entry_SYSCALL_64_after_hwframe+0x46/0x4e

A later refactoring patch in the online repair series fixed this by
accident, which is why I didn't notice this until I started testing only
the patches that are likely to end up in 6.8.

Fixes: 1c7ce115e521 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 86a62420e02c..822f5adf7f7c 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -247,7 +247,7 @@ xreap_agextent_binval(
 		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
 				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
 
-		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
+		for (fsbcount = 1; fsbcount <= max_fsbs; fsbcount++) {
 			struct xfs_buf	*bp = NULL;
 			xfs_daddr_t	daddr;
 			int		error;
-- 
2.39.3

