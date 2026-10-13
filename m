Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A44CC269;
	Tue, 13 Oct 2026 09:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884412; cv=fail; b=OoBxDygQVIYPPmWxlcpKuajxpdjymONTU4mmcQWRDrWMVc+Ir/t7/CEauuTw8imUKo7+DxcqtbMQQeA+0r2di8uE4HwZmF3dwPQqvgyUhl7Qy4tXG4Qou0mg5FTuJNU7Scvjgcv5LJspZSTRwh31r/Hg7vYgsaBKjeG4G1oAiY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884412; c=relaxed/simple;
	bh=nXnaWiMhrm3ZxgcvIq9cijtpK2BcssziuPFx2OQqc9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M7cq5srKVsC+gazCNnz3tGXYJFNV7DHR13O8hCpv4dSS6OOMrLKTO3ULSmhoYDVL2lju2xai4fcEvK5Cn8i+Sg9+dWNNQ9RxENTvj18n/sbLOttqTu4Tao1OIZ2/QQ6CzryNu6CJxtZytchVhPPHpGKeEqICMcjH/5q0Bho8pP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M79JOJ3u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eJCQ31z0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M79JOJ3u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eJCQ31z0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bpx7678222;
	Tue, 13 Oct 2026 09:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zQiAUrjCanqx/q3uMtAg8xUAwEeSX3fhwvrC/aSGxFI=; b=
	M79JOJ3ulBfnzQYvLuwpHTXY2Ve3dGm4PWc2dSled0VFyVyJED8VKSln4CvMtdoB
	EoFdzo7JH0crrsSs8SVCPsejhnkCbRLCgwhuuJ+eDAI4GxeyDMNh84l7w7xZFPS1
	1TksHuWu4p7ee0SrQmFN3kjOYSNPAZ/GrsvY8ePzo6aerF41Z/kn/e5Wxh8eYc/+
	j2y/ty2k5XSyvuPrJccqCIyF6bu7BhhXDPCSb1U1NAmF4CZbRXjNpUeZURJPmZsB
	hiFNIqvpzJiN7dKhefuvOL+H5GFJFk9szW5tQZpht8pM0OZjTBnwYGraKpWMeAbu
	75zVTurw/PX9Dbzc592C5w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddusc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aIvN026166;
	Tue, 13 Oct 2026 09:40:06 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt927gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r01QJi04yMElT1LcbC+toeq9zPMLpIstLPR1hZqDcVlGpyyo0LMPAIo1JREaYq9nk9yNKxNJymSaM7O2Acb8XDuhB82422xuNbbk3JEL8T5g9yjrFRmT6Pw2T2xmh1A5qPnc3F5G0GD/WgPqBPNpfHIgoqC76Gpc0Wz01ULl/uvXK/TpoN4iRSXIFF4oJr5iW/QsN9iG1ZuFOEn5ySnG98iaG5j9b0x9+Cw+UBuaEbSNW0Vr4kl63j1WbDucYlXnhKmui1pl8QVPzRW7G70+SWjorE/+Ryx6P7ELCjXas+PT0cY273YR9u+xNlQuRBlHgTMmu/eLq1x/yz338kczHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQiAUrjCanqx/q3uMtAg8xUAwEeSX3fhwvrC/aSGxFI=;
 b=eK7KkYMZ4d1ug4TB/kTm4QR3vZDp5quLTOwhhxi/SKNHz2sMBM01VNXbgVIQhdSSEaNubImgK57o5oSeqhesFY2HhDSumcwjkSauJ8M0JRgI62yxmWs3SsCnN3tymgBBc4oSozVuWk3V/2r5f/EZ3s+1hg9Q55EaSc18KbqIP0YO4DqkAj4CMtclcwBHEcPoReSpWQDQAhtXirvv/QnOtv/uEXZ8/huEWg9lmbaKrXle8Gby2vu9Ce960+WZwTlYzSoKx86MFG9KyJfNTlygdQuxFE+tPVPOMRnOZAp0wGB1bomybDmwN8bmwDnSV/okUxfRp1SVLHZXwx4pscgB4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQiAUrjCanqx/q3uMtAg8xUAwEeSX3fhwvrC/aSGxFI=;
 b=eJCQ31z0Rax5UKpEePkCZPmWuc198Y13wJE8Ad8JzYoaMSLEN7DTU2XFllAG5turUBKBT/4uoyv/36FxNnskorZAoNCq+U81ltZOsDTkUjVjIufBAH6Q6ftO5R0Met6mhukJB9e3i2HBnz9u+52tcJcOh2vVaowpstrolvYgKM0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.14; Tue, 13 Oct
 2026 09:40:03 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:03 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 02/19] xfs: improve the code that checks recovered bmap intent items
Date: Tue, 13 Oct 2026 15:09:31 +0530
Message-ID: <f7f261c7d47f6aef6ab7e7225825211bdc719b7a.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4P287CA0115.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f525935-7b15-4be3-bc00-08df290df4d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|23010399003|376014|22082099003|18002099003|261009223027099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	D0BX8JsVI80fIqX1eQi/0CuZt37aLJ7+lDWUQHkYslUzsiWq4gtZyRXsMcgC686XWigLcBxNGUCZmRcgJMd0f1At6/NCvk4BmwxWYDwIziOBRb0B6ZK2SkN80jfY1A8RzZcrNQb0jxAzartVBOZ3JvAz5yxfhWB09RAG611skpw9hLUcrJocGIuGpMiqdkBpDz6GFFMI63wrEMGdAMx9xmjbH4eNE55dd+sLdB0oK/55BHxLNTN70rZA2t1lzMBjrQk/7JUNi/5SNP2WPa+49f8CGMxNrRxVl0L5HoQcgbYkFDJ3McrhN4KCe0SAsFh21XM7zbJjDNBd+w5BmVIdee+Acby1G8IPanylpnc9bD0p0jKQR6xwrTdAyfnbYaXo2NYZCdkucMW1ExiFxYf1MEkwZGC0Z74TBUQgCEvCuysh1ICdJbrMWhN5AjjlAr0z9Xu2F4VgGR1wbIxkOToJdDJCXHKzXzoRn/PlrTg77z1FUvL1YAGmqxIeA8vjwqPOZqPDNyeeV6X0r2cBIWclYSUl2NSaQrwmG1GUKzOCPT//cFJS3O96v6E6Mx8hbngqo+sXlXBx9zV5iiBdEgmezbnN95BJJAHCYk2S6v8194UHxuqgfuBSOqF02azXS56EFV9vCoTJty/p4wkmTfRPvWsG5ihT39Z3UaXjblRSOVc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(23010399003)(376014)(22082099003)(18002099003)(261009223027099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uGhhPXy2PVdcISBN/ypGPVh5s2Wf7vP93ZLNofUk6yAspOSmXP1akxxAnnLy?=
 =?us-ascii?Q?Mm7LWsQcHJQzYoD/D4LfBCezBqpRqC1AYsoutX0J/ha2zT2IVPQXmqm3TxsH?=
 =?us-ascii?Q?Cpt4H3iWpEfkGJLH1djmZFDWStS94FSwetVfWHDACTlKb3/bNNoQDGRKSlNS?=
 =?us-ascii?Q?cHBloG0PXwMqMv/6AcWrDRmUy9RAkbTJOMEDuSPOFUt7CkWUtT2YahsQee1+?=
 =?us-ascii?Q?1lQgqlgGvxJu3ne2d9UFV5hyjwBSz4199dLVfUjENYqNU5MUienJZWD5gQp7?=
 =?us-ascii?Q?Hf8FYlawytm/pS/pcxkEXKdZNttDp7Fza42oyySnBNCH+Otfyyer1kDA6BRZ?=
 =?us-ascii?Q?IzGJvSCOGFcKpQc7XOC+u4wtsysUX/eajKtZ5iap3LdkRxB45XIstow9n5Om?=
 =?us-ascii?Q?HNdU9A4Jhj0gOSaOUfxacrVWh5GXqZTagisOQLLD1TB8H+e8xk8qDZoqASXo?=
 =?us-ascii?Q?L8/jNOI9HlBmnvaKBWtTYHdsyjy/Fq9k3QEUtLrORvDEIxSp3x+ApP2wp8yQ?=
 =?us-ascii?Q?Mp57fJHDDvTNo+lKkaEwDBNCJQpmldqp5u7RyNN6fYs2LTELTteCu+CCjm4T?=
 =?us-ascii?Q?Gz8UAbl99ksFdhFRmeRoF8x0tdl8Tisq45RBhCWPDej1Jbel5gXRkSKQacGL?=
 =?us-ascii?Q?Brua8pKZaQkDO/FV4vYJM0lE3+Kp50Jb+Ttsf42D2I+GBcr9Zk7Z+9rOG/TD?=
 =?us-ascii?Q?EFNCvRsnYM1GEQ5ed19DI/MXqLFQGi9SAN/i06+qzusWarfw2TGbJ+UdTNSx?=
 =?us-ascii?Q?V+Ll3AkJBQYytUGPBRmXXtE4HR3LQ7Zzt2oqNpZffe3PJYG4ryiYCo6IM8rV?=
 =?us-ascii?Q?2b8uBlnbSrZb7uMyBD7n/biwK+b+kP07uTdfTkjUR5ebmXpevS7MbtUloYbY?=
 =?us-ascii?Q?7cJg9fclXXoVBEHPlfpsY0KvxwWvCzD8qd2H9F+DwrwIfW+yOilKsHbOQd/l?=
 =?us-ascii?Q?pL7hUkBTwtlvSkknUcJDdDlJyW5JHr6ct41NVfwSRHAxbDrprmsXT45SDEgB?=
 =?us-ascii?Q?qjJwh5ha3HvxKZuWPhxOwdwBkrMCZzUGgphoZg316GkEmdfuIrjG7FLv4Hjm?=
 =?us-ascii?Q?3AhMSP/UZAnhn5ENm7uNy2GS+ZpFVumN9Ikt+zFZR76hLUsERPqVjN9suCCm?=
 =?us-ascii?Q?yqwbXBQA2PmDdGgfSHPYv+/ubN2U1Pgi5P36wP7vxQG77HrLUuQ2nPayM8jy?=
 =?us-ascii?Q?YwDdtYODW7mZglwm9t9uJcFaK6WuoHKmSy4hlkEd5+jpZudVt68+qxZRbTJM?=
 =?us-ascii?Q?tq7FrXNhGtwvY9lfwnboYEKX1Ud92yASZwFNzhKCbYGilGcMT1iE5aCISb+V?=
 =?us-ascii?Q?qxob/0fFunBltJrmZzb2aan9Z2S/NQPZu6/e2V3dz18J0wfQzTjdaYYLNY95?=
 =?us-ascii?Q?KM+WvLgpRr20FYyGaelCGo5CqL9FaMdubXrwCMmJJ0vY7/CPza6K3q5pTOfG?=
 =?us-ascii?Q?qckPSJDy36SNKwpyCBZR9+goBWWrscTJ0033ZbJXbiqGrAM8ZkQCqGyksS9n?=
 =?us-ascii?Q?t2ip0rcEd5k5baitI4p2m0aBTKKIT7KPVrQhBnv2m1hvB8l5MUR7a37fPeyo?=
 =?us-ascii?Q?padqts4bcmyUXklAdnWkH5oC0TCff0FB/+R1oNtDHxXXTJlkPf5ysiUOAEnv?=
 =?us-ascii?Q?+TbQB+rtzXU/tTahCnvLIn77Vq0Boy0UWJbqAqek8+k8FaKBNzDWTYk9sM3w?=
 =?us-ascii?Q?ugIDR1AWheRhJJwVdoLBsOOa5+r7SGsGx5FIncPRgrq/VFDBaEOFJMQ567ng?=
 =?us-ascii?Q?5XdIGnDtjTMWq6Fngx1sMFWJ/VrrH06I7DXGGqM8YRkIiLDtm6TliqrTlE8V?=
X-MS-Exchange-AntiSpam-MessageData-1: IpQmOt6snx6lMPPJR/TFxes9XJUFltHhaEw=
X-Exchange-RoutingPolicyChecked:
	woL6CQOdhtHRiUxBnZijmKT19OTiG05YMEfsU+56eKF2q3Gc42O+AF/xI7HZCghP6EftbSzEeBx1ok7nO4RtgHQZ5gnODeeEbyO6ZH/z7UjuK2E8wkwy5ovT4yP5aq9QECHobAqa7VzwZKR/yLFc3mOj06ZbMrwPhOT2lBoB1XLffDeVD4yllpgOKlZmf7d/2kb0dMepuXqjRYk1F8L+iMpYvzFbYy/sc1gd6haxJiZRDHsdseCAckiC07uj8E5pjNvWDKtmiECzMgkps3EU4tPw4tXCJXQhopPbcpz8dD/pmRsbjpwM+3QHC8u4EwWWWuLF08Gcidh/mcEa5a45FA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S58EgUrWAyXmX34NqsJulrimNoYwl2wpQKrI64nPf6ImhOPwBmmfUwC90Hykbkv264d/JWLKy5vN9TtaY0dyZQpJeuGMeI+o89hicI1welo9T4u4nI3vPw8/iMYEWF0pqCmqWoF3cqhNXP8aaSrwnd4V+xHm8zA4IeHdnIPmLwQsoAf5h3IO2ImnGJXmIjCXcF5Yw6VuajTWE4nKjA3GwiUU9DjkcSndrwUPdVhtCnnBHBQjGKQT6mAXgyLCvKAeUwklYwZJZ+CBauo+1lAIpWITfTJ/stiDI222GeYWe8BjyXr3ayMb8oRhg26qsZwEnOdkqDTsRISEOk3Q5QCz1jfT153QJUTOUVMaQNDNnu/khDUw0QRPYdoNDRvevpDu2NzxH3txbsxY/sEubxPZQQVLJm9tOr+DNaUUXISAWof6AQOQEMLF0C/4W7be3vnCu7KzKfRLAec3YXOqZvQEB33aOM8IXCGn9CMowBlc2ZOZ/SmO+WleGZPHNsakQbJZyBOBsdru6cjxHiEr7C0FNMhriqEAGc7smACAOAbfWkfO9Mh8S/rdFLYvP8xk+tpDljxcICERMbmzqLRBCvaHMnnBiJEqKo06rhljU7U3xq4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f525935-7b15-4be3-bc00-08df290df4d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:03.0134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r12CSyLIDLFju/cw0MvUYGW6rra18WY0SQbjtG+1jhWl5nWb1aBr4sjUcPVDBdt9MKyt+zq7VwnxaBlRljtOW1xzABP37w6+xnWvFtpRhFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-GUID: atv6dY2w3M1fRsK1ES2Q4xMIxcKa9_iG
X-Proofpoint-ORIG-GUID: atv6dY2w3M1fRsK1ES2Q4xMIxcKa9_iG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX9tL8AuCfNpBt
 7YnflTwgyYXMTqURTMc9Vpn0PAhyzUfOa1eBqgKEQ+EzzPOClBsFBfDBa27/GzpwVn0DOSvGyeG
 7kPOLa8PBwGo3A2qK9RGSnNEgobjuAdWRrtllsJ1ZcTAXn07XG8s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXwBTdNSKJAHCq
 zcggxIeUVSJ1hh3goHIOO5QFEJ2LZ6hGyJlVtlme2AIdWkX2iyM1t+tCcpKYfKfjp45U1HyFddO
 2yW7nDVx4kY4bacSQ+CP0IEGOkJtWnt6OB/CtTnrhHhWRiffPivjmKucnqW8PlJy+mofRUKYYil
 5pv8FZlzPKbnzUr0SjoZgkOyE2m58iUnj1RtU2sHLb4m06Z/UkkCdBhyt+lY5uWnERoJNwsvhV1
 UWff3vW9hRb09CmzcLDmlzGk65hzREHxcRlO51C7jwphi8n6dRZQsN+0/WcyFJlx0xlMhVr0GNC
 4ksvCFQ0fvczujNvwWy4oTyKMsYIjpxQrqy4a0jTUKvvyKDvO4nAAwEDgO7oAhpAOrtMvhG1k78
 L19tF+WLQPUNw2YXMTalfuair2hakH4MtldJFR9mcilY5VplKRB5aQFaTcDnX59LyU20h+Rg77A
 vH0X8Vy3WoEm33EUMZg==
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acdfc77 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=Ye-bxb6B3qct8UqmZkUA:9

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The code that validates recovered bmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit 67d8679bd3913d2c4ec5f32ade778881b93af766)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_bmap_item.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 88d28a862f52..5f1c2fda8e4e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -425,18 +425,12 @@ xfs_bui_validate(
 	struct xfs_bui_log_item		*buip)
 {
 	struct xfs_map_extent		*bmap;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
 
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 
 	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
 		return false;
@@ -449,13 +443,19 @@ xfs_bui_validate(
 		return false;
 	}
 
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+	if (!xfs_verify_ino(mp, bmap->me_owner))
+		return false;
+
+	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
+		return false;
+
+	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0

