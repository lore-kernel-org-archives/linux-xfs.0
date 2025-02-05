Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD6D20E316;
	Wed,  5 Feb 2025 03:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724925; cv=fail; b=W4wJb/FhL6PBgtROgUlhctjkMj0eSETvHpeyx7orw7SHcpibwa1ZzDBPS2a1RCLpVicI3Rr+cIKS8p+sz/NYEB4h5sGoRUBPqfr6bZOKd86asNKM9e5rbKyx2c0ohVX0uOAGjUKFLCMp+8V/eZX/rE2ilYtXFgRAMaLHJ4RHVo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724925; c=relaxed/simple;
	bh=VJvJSIwSzGKYsmp7JwtdHt0gs+BOJyXQ1rdYBas7fpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mqxksqBoktCl4KKoxGyS+X9Yzpp/x2/BYAlxxJ0OzOmZpq/jOxVGAthMWQWaPIJc/Guh2T2ZWi3dB0wS1K9C99yq6sQfIT2zHA7zwz7w2L9hlFjD3qg0+hThmNjmhtSCX0Djk09hkM7FiQPbl6fz8KHM+T5o1QRZZY+Dgb9Uk7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HI+r6TcD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pOZGIy8V; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HI+r6TcD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pOZGIy8V"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NCgiq004493;
	Wed, 5 Feb 2025 03:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=f9kodbMf//2n2Us8TH7I808umteBWK7dEAsf1k9BCls=; b=
	HI+r6TcDR/eP2oAK9kSdj75E3GNq8gW4iZJvgnlN1YY5v37fGMI2fjHW4ITKH6tp
	YEGCRfE2mijaUmnJqyZ4GzPlKHdh19jE43SsNGBAKjOMTlalxcfBL5+rw0YgR9On
	FdpxcExTl1oFDRPw3fz3pXE/D4o/r51vW0ItlnlqxKgXikT93P62FjixgE+w/Ncr
	iodCWnFZ7QbXYlqLsV52XV4764cnDLvOGRpiGtFTDFMsPLXA9aCRqhNed/80lB8N
	Wf32u0wu9tyLttLMXvZP/raGKLxEikDPb1Hn2IQrOM48rxJNU3UAoZJsGERoqQMN
	B0/YNMM4bGGKlT1xJRg8Sg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4sdb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 515149gl037964;
	Wed, 5 Feb 2025 03:08:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsnhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WRJMjh+ouH2WK7I+ywxZ1UAW7+2GcSSVTBYiPypw8L1NUdu7c9AGi3UnXDbNVnzp6nevVlx2jml4VTFdu5cLq2kaeeG0Yv3GhIqCHmqrB6hqmpPx3UIDXpPn7Mgqegr8pa05VTnoEJOkr5vaS37/M/kvea5i86GnbpAX+GAd2UaVX3sMu6gGfNW8dM+YQdfB3iHX+jAX0RnTJp4w7BE1BYCBSm/2LiASzbUX9JoG2Uwc8LURpTkOlgS84Y6VXFJAiutZu3v9iCGtmWW8UHtcrLGc8qNFUx+72NnFsLgmnvnKUVwx0wZwE3gwbpajujhameRTHqLGcusabtsoRrccwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9kodbMf//2n2Us8TH7I808umteBWK7dEAsf1k9BCls=;
 b=wd/ipQBi06DuiwGTcvFkovCxcSsKzP6RoyKbWvPlsQtWbh1W/A3C4bp7JTi1qRJI30fT7oy19kie7TZKaYqh1gb7+hGeKbK/n/eIahuuMP+n+jAPJX6xdRQ70bFxyNDjbK/cKi//6dNsTsBuglqJHcecqrQgzRFJX2538HZp8yjkwX3n+E9TNlaVjpgFWBlH68o3IUsCjCzVScZZ5HeejEeArIAV9FCianl/FMiR4OBF88/+TQIyx6/VudZGobW8cuopMqLG4bJL36A4V3kxA8q7ezxtvvAnAtTiIAJc8A8aabrsv2a1NLvsJKr6afGi2NKJTvkffS9kzAqqiXPPBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9kodbMf//2n2Us8TH7I808umteBWK7dEAsf1k9BCls=;
 b=pOZGIy8Veg/8EhqmOjrDVSECDz2KipRFdsLrgZzgAXkWXqowC0PAgked/z/uDtZG8ZYVt8wXUwWxMEYpBE4eM/6poB/1PiwVdbVHCTnbctLC/JN4aSbJJj9v0e3e1IHNiYava3uCCoIjNhaS5GJ0Y0O0DW7fZ8jRX0SDCfiD5Kc=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:37 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:37 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 24/24] xfs: Check for delayed allocations before setting extsize
Date: Tue,  4 Feb 2025 19:07:32 -0800
Message-Id: <20250205030732.29546-25-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::13) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: e9572fe7-4e93-49e3-a73d-08dd4592621a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DRHSuU3NdgzWO70UFXLExI2VjrifzbCGT5w8lRnX77RnMGkcfXpVD9lplo2g?=
 =?us-ascii?Q?RqkZ64F9wuAKGQuoMrxKQ7+Fzb4Rlt+KztszYI+Q/UKY+KMVFFluWZFeN9t9?=
 =?us-ascii?Q?/SYpXllNd3xgxJPGmjK6tJbrCN7mV8TzVD+ev1+drfWkbDn/Y2o+yDYJQQyd?=
 =?us-ascii?Q?L5JONvBnZpRC3MroJcfuxPvQNnnRqkYNNrJmWv5UkKbdH4vLkcFufDqLg/ZV?=
 =?us-ascii?Q?b1x07YQ0EeAJQ92n36VkZq/7ELypvIvri1rvhIK/r29a5Ink0U0Ra3sHhQd5?=
 =?us-ascii?Q?9CPpAINy/AxT8/UKlnI9oE2JxrzM/eSRDiiV/81CRZTTo8zNsxKgICg22I0d?=
 =?us-ascii?Q?/svgIodwqc41d5gt/zYWdnt0GH07hq8Mrryp8sDj+sZxHjox2MDKEUu8aSg6?=
 =?us-ascii?Q?C7OGVXMNKktqig8haL8LUT+XEVGxj7iRMBslxJ7a2liUKDmO56gWLKOaX5Hj?=
 =?us-ascii?Q?isJtCrVWYaJ3Yyc+BCYMkQ4VyqJ4r9yWIGMAjgW8l5W9c6mXjswebW3JH3LZ?=
 =?us-ascii?Q?p7J5pt5ac4Ya1e7iELTfg3HVrAvQ+sSM3eb6hgp9YdndMQwZK3xCWNYt+jh7?=
 =?us-ascii?Q?Uav6IY5iC3uHkOEqEyHB5NzaYTvIDsKJ62azIQE88nvSjM2axKIcnBi8Yleo?=
 =?us-ascii?Q?LOeoKQ8vD79tzE5BnUd3mPDmleh2xbHeSU4qwtUtpLl1ANVGCxaQGveKhUGz?=
 =?us-ascii?Q?IOBaVSgr9IFhQE6tVppcLM8tJm+JQTEZ4I0L0nIwSX7f1lVJSl2Beyk1ut1q?=
 =?us-ascii?Q?lPocU7+YFqUCgRx1W0m4bnUjmw2juZFFytyQtH95YNVDJc0eB03l1S5lrW63?=
 =?us-ascii?Q?22DpyQedq1s2By5NNQKUudB3SdyyS56HGcl+zHJmsGkeSkdEYtrzGuPPRMpS?=
 =?us-ascii?Q?lbzGrhXPkjqirs8m2LCU3om9mTuMD9M3Xp1XZdtA6qaMQEiIeRe2B6Vw8HGB?=
 =?us-ascii?Q?oE9fO8Vrm+xGYi1Zh3SfU9qRvu+qpxzxnlp/Zlu6SVq8i+P94ObQ8zEYQ8ne?=
 =?us-ascii?Q?2DcFM5m44SmeRhtOED4YPP87akuwIp2B8C5m+lX0Yry+plt6VEYzRvZSo/W1?=
 =?us-ascii?Q?9GRTx7wKwrQu37KONHVsctg4uOd3SY/8S4J4bUUROHKSbjM3WOnCz45JvssO?=
 =?us-ascii?Q?SU8uYdgxqykav/75IMDhJBwYmoYFH+oX41uZRH9xpk36C2VMZsEejwil8Gqy?=
 =?us-ascii?Q?y+mD4Zp3pWgWVxF4uv1G+hRSdcdsJ1gKQf6ClYfwD+9o/RKZ/5v7WdllO6FS?=
 =?us-ascii?Q?WZUlltbeM8DDFgJW4oX5bxDBKLMbLX2tBGS37kNIWMXdnRpQtCPJyUdxKYjE?=
 =?us-ascii?Q?osmNQ5MpP+bc6Hf9yMcJvGKys1eq29h7LovwnxLdgJE7S2h6NlYjxNQ++9hv?=
 =?us-ascii?Q?YZwvmqcBWPkex6Jm2e7TxUfE9EG1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dn4/nm4QTM1PqhNqArGlNE675Tk/uEMbGkWJtec1tWWDPSDvikyIQzn9KFk4?=
 =?us-ascii?Q?e4pBNW4VH7s0zsPnIl0mrM0OMBtw2T7Ri6jYlRuxRMbTjGP0xuS5qSKiqjNb?=
 =?us-ascii?Q?jRgrT3TKbVxspUqSSZcvzdjPh+ly/im9MkShwZsjFfqElSoZEds6+UWWl1pB?=
 =?us-ascii?Q?pEC4nzIcx+76+sHvM+8F2c5J0bI8n1RGWTWiYBCmvQsDm/K85N8ky/SgRVu6?=
 =?us-ascii?Q?bHuhwj4LszMLQEJUaB/zNyzoAaIWM1bjg7dxl3pVJnLIO8NT2prF3Fts6Nnn?=
 =?us-ascii?Q?2QsNKaXsfC4UOY9X8NqrGWUbEJlkM3zsZwE2HxDtLUDJ89XPIn9Ou1xqtEr6?=
 =?us-ascii?Q?W+mlBVcqsD8pmMmZZppnLKqOW5iDzhtc/g5J1iYrOpR5P5a77QiTwMvj5HVZ?=
 =?us-ascii?Q?SC47o1f3AIArvG5hbPeJ2/JRiQr+cBOhxhwF6ifd/JZARTGhvkdx/Iwcmn2Q?=
 =?us-ascii?Q?f+QjEhDVXrgH3psE1p/v+uxMrmprRxnIST2hvWr421Hqx31/jZ/M3Z6KD9dm?=
 =?us-ascii?Q?RfGwVZt58a6vla3wSF0agAcCBtFdcDllgKcp8vW6rEGU1seva9DYCX0kZAik?=
 =?us-ascii?Q?pnn/wNfQLkyonIeykrg6NOT30jBOw7KhrTNVvWeqqg5BO6UiamfkIbvITx02?=
 =?us-ascii?Q?lSxEEjryqN1jGggZDV01boW+8TpPjVt96gOkGoDzcLNf5VAsc42DB+RWpAy3?=
 =?us-ascii?Q?ysvrQQ1t7AH9h0imgL2vwmi0pgJiIRdWCpZo/7q3wRk7R6a/DqMoJly+Bhfq?=
 =?us-ascii?Q?x92sbHoQsbNSD+3Z4gVUX2A+rmBTNRjBEu9CyGl9044HDb9ol+AHAPvmTL5C?=
 =?us-ascii?Q?+JdBAUbacP/fX9+xJY1PB6UNvOF7lYJEsywGhzyQ6+rHA7cNlsq+A5tfckUj?=
 =?us-ascii?Q?xABeCH5b7Yh1G5bHcDhYeFuF5vay+eSOjZ+QNxdhyaMhv6UFHjkeCAGaoX++?=
 =?us-ascii?Q?ANyV2butuZ0kwLviJ8+eflZKYuu7MnNEReK41gU7EeLgWjktoUDJNo7kl/qN?=
 =?us-ascii?Q?E9poe/RxvfWLzlBWh7MJY29EcqUBD5PIF2AaTHSZvObCOw8IU58Nj9yqr4Gp?=
 =?us-ascii?Q?xMqi4qEDgzJ6qaPN0DntsqnQ7cP67YBzth95Q1o3L68cqhCMj2SKvV8zqLcy?=
 =?us-ascii?Q?C0xWQFCXq4RZ6dkRM1+JQ9yxkcznnbs44f+TZhl1z3PvxBxir0VtYYSYdEQY?=
 =?us-ascii?Q?6K6Ydjql77JHvIfZvC7oKhCtY4H/PSKxjOdo8eM9OPhG8A98RuAugUPkS7e6?=
 =?us-ascii?Q?P2T74INcisOoybz20kc0MmVXfjwYqCYsFa7fP4pjP0AMWqRyZmskYlkIWi2q?=
 =?us-ascii?Q?VK09Dqhd7mLCrC4x4bV1l3/zsVSwVGyHdjvCdCffqC4DKmRX4mcT18dZVfcE?=
 =?us-ascii?Q?/4+Vty5zKkUeO975fa2mRKZJ3EzqH2n7KDqSTgE9xqG5PvBL3RhTSqAjvnHV?=
 =?us-ascii?Q?fm3tC+2RooHIBoEnRp10JSCJEdeE/6OE3t+LtSTZHOjmk56ShjK6U2DCXd87?=
 =?us-ascii?Q?3LtdNL1A9zLRbAVW0eVG78aMYTpe6L8wkyziPZKC3W5RuSaWA/7UX8zKHVjZ?=
 =?us-ascii?Q?UZrc3HpjeaKOol42MRvOLMfU1QqNMupXCyAZPY7GG/g3P6nl7HgTuGvCDyGt?=
 =?us-ascii?Q?+K5poalyGZ3uo85OEJbwVl/lMiF3JHA02pPzfP7dtpJZsqK4RJ2qiZZ0tom7?=
 =?us-ascii?Q?dLF/wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5jRFcMo9kLpp9h9t75LPRUYAeZe2UkLUNhLFEkc6u6q5SEPPh5d8nsLBJMb6TYGEGlVPiU3tRfOTNyr/bn5nFLEgftx3OQbtXqeAH8qLzUswlycNMcCjfoK53LM/y1QZpu35iZvtE5Lknj4bhPzJsPrSf2aIojU+C95TpDRpKehdqkFq0nhkSEQWCkG4+fa3xazMJWsa17Uo1Z/FAPp+JUCyfvccwhglF2nKkmutxASFcUKWIr+sgXiUi7C542yl7ii7zlrz00I6EGnWg6tQeT0JBK9NjBbYI2xRHvg/jWnpa3Egh+1CnpUHBzbkAVIGiIWzoF3gVGQbAf+XSLCxIID5QUNxFzr4e08JqzYvnfgo7wOl53Vie+oLQk9rj1rHgh4jZGzHXjdwWcsE0/7TIKCwG2KBlnOn15vdXT3ndI4/6ziNWQ/Yp5ILD0Qzh0yfacPBtPjXQrFaYVK+uzJVYjDlech3Xue/9XVeXQIWN/zjk2BRs3XLzIZy3p/92EEbvLjhfiqGIK+Y7UqE/eXktk+W5Ia8XHNBVA5UbvATMCXQ47NqE587WoGACDHD8wJ15oNGrMgg++Tqwah6FYTY7KPJSAMyrdHra41O7+H1QkA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9572fe7-4e93-49e3-a73d-08dd4592621a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:37.1647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoXl/+uev8wGU00i+HZQCfdtoNd/F4UWo8YQpfOvYSLm3zl9kWAK7l26HiQiRrWlV8UAs/twbph9eFdPdNsNk9D7YSauUZ47d8ypTacrxhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: aUXxW8NEQr3QM-Nu2KVWZtW9bxoU0vNh
X-Proofpoint-ORIG-GUID: aUXxW8NEQr3QM-Nu2KVWZtW9bxoU0vNh

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 2a492ff66673c38a77d0815d67b9a8cce2ef57f8 upstream.

Extsize should only be allowed to be set on files with no data in it.
For this, we check if the files have extents but miss to check if
delayed extents are present. This patch adds that check.

While we are at it, also refactor this check into a helper since
it's used in some other places as well like xfs_inactive() or
xfs_ioctl_setattr_xflags()

**Without the patch (SUCCEEDS)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)

**With the patch (FAILS as expected)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument

Fixes: e94af02a9cd7 ("[XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not using xfs rt")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 fs/xfs/xfs_inode.h | 5 +++++
 fs/xfs/xfs_ioctl.c | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6f7dca1c14c7..62c3550a53d2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1755,7 +1755,7 @@ xfs_inactive(
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
 	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
-	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
+	     xfs_inode_has_filedata(ip)))
 		truncate = 1;
 
 	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0f2999b84e7d..4820c4699f7d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -286,6 +286,11 @@ static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
 		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
 
+static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
+{
+	return ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0;
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 32e718043e0e..d22285a74539 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1126,7 +1126,7 @@ xfs_ioctl_setattr_xflags(
 
 	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
 		/* Can't change realtime flag if any extents are allocated. */
-		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+		if (xfs_inode_has_filedata(ip))
 			return -EINVAL;
 
 		/*
@@ -1247,7 +1247,7 @@ xfs_ioctl_setattr_check_extsize(
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
+	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_filedata(ip) &&
 	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
 		return -EINVAL;
 
-- 
2.39.3

