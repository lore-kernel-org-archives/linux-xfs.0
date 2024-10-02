Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B554F1D173D
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890900; cv=fail; b=VC65a6ugAX3XiXNA/UrTH3qvYIkp5n3EcUM4kploiwhBPT+mE2doMwHXW0aIgxJR+T7vRhwEB4F2j9WD2oWnh58Lm0TIt5B6Zsnr3kZgXOvpeeFWEPiRAm2LFxhr/XXbAsxpT7aaWhtGBjN/n2G7+2fCQV6koOeHsCyi7lx2Dbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890900; c=relaxed/simple;
	bh=q1KYDJ4Qhh0l202v9P1rrQPA/UwJyuvLLDKrkFTvPBA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ja5lx+nkyvRjVSZMZXhj1c1xd6DYZTz+cmXX/t/1+598e61X4wjXWYSfyQoX4ECoGJuJTr1zIfmKVnpFMpkDLqEu+TpkLVJR77szDU1KBmrXH6a31r9zBPdWE4qdY6H+OWts/Sz8JJuG6kiaEaY6drpbuvZLT3SJGSh6g44ytWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nAC0HLlM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZWgYv9wX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nAC0HLlM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZWgYv9wX"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfbnC027433
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=hiWHMHNsG3ZBNMvlOpBnBgXotx9Rm/EMcIDZTYzuxFU=; b=
	nAC0HLlMdLwcgFjlLMr3RkmUbuPgs1jTrWmSI4bv3WBdjGPunKUvhFyTVCX0pcst
	p7yvvSZU4b9BuWhA3ws4LcVPQrlxwj4Bo+GsJojcG1rmMnkDG0wBz20gdN1fy7v4
	r8sIoN+++i6oIN2XPzV6TcIk65jJzJotg0lc/C4MIMxmTiA4krCoqVozyhP4FGiu
	pNC+kxy4Ec6JCWw09svF0plq0VgQKdi1f5+YWDU1BXYEn43uUlXJesTPwQHvOW6A
	afZQ99iBrswyX8CC9mC80wRr+sPSz8Ax30cWIR+h1J6HzglJOwdboLBRzAotYHdp
	Yhs399NH2QdKt6k8iSg0DA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x87da9e9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492HUb1C017337
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x88951f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ySvL5KNp18/gY/Ry7Mhgd90JcAthLy1dM+eMSIDlF5IDKU16DQ2CRCkiAjhZiWVbcfSe5YOoJeOARPbTka+nLvgBxyRzWWYKBYFibwZFUPtJKwgkLbFYr4W8QgS6vooeS2cXwV+j9LY7Q2A20cFz/Lu2yIa92wQ/1mhHOKfqmnGntjHqH850+VCXQiOgkEtfRUVYEO95qOEAC7VAtkiVPWeWWrsGBRJ5hC3XYW5PBfbE3+3SLcyPDq4AxRrSGDtYCSk+tFyL//0bdm7QkA+jPcadM9vFjlp4Ks2ffF/XkwwJ/Cw4/nVJ8/kV1i9aeeBYUV5IqjD9UNJksy7UHxMk3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiWHMHNsG3ZBNMvlOpBnBgXotx9Rm/EMcIDZTYzuxFU=;
 b=jflI50wG1jYwPtUZCODxm5zHZifTMudfhCXglIdsnoRg5gsWc1WwzHIOTPC3Oze4tXpmHa596nFbihhQgZF7fjAokFh7blzhuXw41wFxIw8P+rnx0tgZYnYd9ruiRVq1U+k5r/zbQ1wH6DdF9Gb83hm8rlF/+QZKGbk21MbYUfoS/wFNv0HChB5qfC3MeS8NfM2lkHLQ8uh/h56o3WE4nS5gwHEtB38aVomKoTwa/yp9LeUfBN2YLsinPizUNEnQqVCTfCjE9u7IaacjOhvoD8rhRbyI+QWkspABCx00Hb6x2XNsCeJBWBN4zjBjYLWojUpPYmquq3X2eB1BSSqzMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiWHMHNsG3ZBNMvlOpBnBgXotx9Rm/EMcIDZTYzuxFU=;
 b=ZWgYv9wXE9Fxkwg7ClPjHzfIKBzbBxK4Qp/2NuamrsBsKGa4aa84E5f1NcMsbUnQKlT0EkzQfepmzHCpXDynUW1AdWJBKPrcmoXlpsvv+lwig3I3iBwcY8uoIP8p2Re68uRv/zj01zYo3M0MgMOXp+wUxCvATWHB8bOM0oLFaag=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Wed, 2 Oct
 2024 17:41:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:23 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 06/21] xfs: fix missing check for invalid attr flags
Date: Wed,  2 Oct 2024 10:40:53 -0700
Message-Id: <20241002174108.64615-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0032.namprd08.prod.outlook.com
 (2603:10b6:a03:100::45) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 109cd6d9-f346-4926-0c0b-08dce3096efd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pcMl4+OctMtbwTRyghL3S9WIrtghdClrl6NO6Ap8b6xKJoBKxDUNXXdQ9M9F?=
 =?us-ascii?Q?vpmqnKp0ZR0Rt2QW3Rp420qXLdJHg/3MjU3g1GBEvZfsNAeSNhGbCCX0drtH?=
 =?us-ascii?Q?lweirW4Koe4dwpE0NA9CGuPRsVLGGEn645YEE4NeUGaQqtp49aH3OQuzqX3P?=
 =?us-ascii?Q?bvQXfvFyDnoRraW3kucNANTRTLy9dL84yVOXAqA7V0RbrD9Lgcwcv07zDsU0?=
 =?us-ascii?Q?hHvWkGwJFY7ZwLF6q2vgFyGqK0rbebAlHyYFZ7m/AdgBeYZu4KJ9ajaA9zJ7?=
 =?us-ascii?Q?0xv3SUCvzJyamR6ToxpmpWOnUsBXVBmPw6qnWH3mq7lDOFcgfdli6CaVtR3e?=
 =?us-ascii?Q?u2nESyhRx1qvN8fWDa4NaMJvhaTbBUTtArezUedwxps/X84dFB9w9A4m9PCe?=
 =?us-ascii?Q?FgfRFS89xbfr/2jc/HRblNkCydXDVKi845X0cFIVK/Qftv+mi9cWhQKkxSwQ?=
 =?us-ascii?Q?9JCAyMgn+fwNbwzaikmjhyxEXx6dvLthgNJkqsPehrv4AS5VikLmoP6GfPEp?=
 =?us-ascii?Q?9KYKfyGn0GbbBDZjIIpw03jMJPs3NmHaVyUIJ8HR8AG2xATrTK3djhZWyuso?=
 =?us-ascii?Q?EdVGoR499LV/3QXaK6y1La1e+ifBhx1WGw9ldB1QwChoXy6dpES+VsooiWfZ?=
 =?us-ascii?Q?sBCT4oYkLriJqLa9nHKGS3rxNhYTISspFaboEPr0PB4hF/uWG3yXRQCqZteE?=
 =?us-ascii?Q?X7cqNqCCRpHdhXdnu0y2QljBZS97TQXpJH9/4dZ1ZGE6caPoZIUVMoWsJoDj?=
 =?us-ascii?Q?CU4xbQSLXfmuxVxJRvb+AWGNBfl+3wCvmFx+9kJ9NG0sZj1ANcZAuNRbjdry?=
 =?us-ascii?Q?57J+E/SEkCVGpCqZywdUGi1efMZr87JHR1qzyVnGZr9Zy36mYMqBDx2JjKYC?=
 =?us-ascii?Q?c3yyuZqGyXqfehby11CMnoqwGwtiN1SjEke0zF+l9GQ7NBzgsHN/4KYHyHKa?=
 =?us-ascii?Q?FksxvIZYPYFpp1E7AeOwqV2x522dHapute+eTKS/mYvFeWV7ZvJQj5+UJ6T5?=
 =?us-ascii?Q?LXPoCGTUZcjLZPgc9Ic8LQlRVsO75Qv/HbCZqgRsj+9Vfg04gwcTqlKkzkqi?=
 =?us-ascii?Q?wNyNxpu8uZnZvpCCRKldHvXihqFMZ0E5LwPKECGdXhLKamRz3KTADkxJxZFI?=
 =?us-ascii?Q?2HutBpfOChSf9QfJJWCJ9DMmuezHUw6TEpoVnbQAnl/aPaQRPf3zSe8KSqDT?=
 =?us-ascii?Q?U498Gu84E7CmiOwAYUWcM90t47uVgfkai/0evh6HetxljpSBzcLv8uApUP2n?=
 =?us-ascii?Q?HRBuH8iy/+Pe3U9FbLcSM1D7jO5XvNp0GGgczEx9wg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9kS6NiUusppa8bNWtXbcoxxClGq76ATU2Da3OaTqpJrFGX9ObYjt6Um0gJkY?=
 =?us-ascii?Q?kWgQZ/speeoixBcsdLvuHQ4NIn4xyU13wt+Ro5RJ5QGw/8ZXolkEz3FQ1zk2?=
 =?us-ascii?Q?ZE4Zhwgc6IITsVcmd6HN6lc/4Hfg3YcKH8CuF5KHJpKqudd8527R8CVDUIzO?=
 =?us-ascii?Q?+necdxZR1eiHcnMqG8XBhMyoT2yYw8FiCe4HP7+QEpXCrHOOWX8gbN+H1mER?=
 =?us-ascii?Q?zCB4EItf9VoPo39OZOzm32K7ubyl8xO7Raf+RX686tb4vVqbYeuNdg+D543p?=
 =?us-ascii?Q?NjoIFJ2rDonuUQ1To0L1VMr9ijP92M+g8Lzy3afedg8JX2abGXOl2LKCohHQ?=
 =?us-ascii?Q?RufYtvSrWuSimWyHB+fNkvihdTJ0FmulQVsAQRgd+dBMLZymzP4xqqYISYI+?=
 =?us-ascii?Q?z0lt+9jm1f18v6pRB+7Spd4QS/IOdKYn0Awn2sP3dtm5pTngbdwqo9IK2vfx?=
 =?us-ascii?Q?o3LRytLQ/Qi5dl8i4PZEkN9V+/qTKusEci5bUyWRVJvkecyqxx8/hagVceAg?=
 =?us-ascii?Q?WvC2JVhdmGtXS5FEaURMU82OnLP8L3gscorcyARxwyorZRF+i9gcosv0x1xL?=
 =?us-ascii?Q?TSA7RtcvFp3GPNjSrkKo8hEPM73O5AQ/T6gCX8N6R1BVAJsdegiham0eYzY2?=
 =?us-ascii?Q?C9njRCugi7tqA/qT7PXj6htmMQVAzpDAokdO61WcFHnsoe0jnB161WnHHnE6?=
 =?us-ascii?Q?fmgMS5xF+V1EXdlDoAu6SAzZEuztldaEu2A+I8GtfX8xIKfOIjWNXbYYaHTO?=
 =?us-ascii?Q?hDZYLpaYqzOG3Eo/Od+b8Dddp3iHPdVethiznokShQivBx/+cbLhRxckrkNp?=
 =?us-ascii?Q?NTE9cOOs3U0uMN1N9PDrESjh3LQ7D6qjkLVeMdJiJJG7sRpsobgKRc4Z9gdn?=
 =?us-ascii?Q?7FriPhY34In1TJlTuth99omlY1GIN7twGvEuN6bz76Bkt+Sc7mZ7Ws6wK837?=
 =?us-ascii?Q?I1OuI+7+NOItnpwiP2ox8qW9lOlMK3MHoOpolxZTVLp40DCZ/DR+E8HZ+lDr?=
 =?us-ascii?Q?bSnWo+u9cte1PTZ4lkCEFPeFFcoxLa6hAc6Bso1USCvnXUnufLCAXBlZQz5o?=
 =?us-ascii?Q?6I2vAQSmg+vFKvDWFLoQW+9cUSxzjdpQ5g/B9eZNjkA2+qIcdg/WN6V79Lyd?=
 =?us-ascii?Q?3hJz9dcxuZNmwqZlboYLNM4LoAPku11UhjX/Hr+z/ZHU5kx0yuFpBnK4dNB5?=
 =?us-ascii?Q?r2V/QNoT9wa20jRQIHCyfJmsEt3RjHCF2F2uU7td9U9ApMFjAvQYTiuM453j?=
 =?us-ascii?Q?oM4oW+d2GTyMGbCtHRks/3IBeKbEKEOl2yKaet5Ur2nokWaNUfAr4roXvV6c?=
 =?us-ascii?Q?FUsgy4VYhn9KbWDbJBMWpBeqyHxDN9K7PBs5Dn/5mmuU/ChXFqBw1a2Ue9U8?=
 =?us-ascii?Q?TeY/ySPavgIkteJ9HgAnVctgHHjFY304KuISw0JiFtQV17okyVzP0RxGjs39?=
 =?us-ascii?Q?fqmRSUkSWyxxV1ZWSMudL1/1yJ17FWiM+B5cBNtQ15fUS926gyvxNkEB6lE0?=
 =?us-ascii?Q?yJ9hDPNZ4z7ABIU4mbIi1aARz9SGZneQVGZkuIuAQrkPwss+wzSH+8CDTlEz?=
 =?us-ascii?Q?ERM50AiWpDcV/ndFENu3jEiP7i6h8pY2gUD07156hD/x5iUscDYvZnXPHzq5?=
 =?us-ascii?Q?x2cAlT5Cnh+vJGdy4GoUNxLNCI6z/XzihWLCt/J/kGKnF2n3Y9BzYka9jNb2?=
 =?us-ascii?Q?8PmK8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RIS3I7tIaSt+Igk1GZNsMZ6QH48P7vNrO5FxBOsEMHQ+D4fjBb9pPL6UIdiZcGxHCb08hIl/NiWVNoSGLZJ0Au8lOBTic8IbycSvNwzNPMZSNfd3luSKKObIxVUiWXNZxvBB2947PFSG/zT89o5jP7i5yT2/MWViFqJWxD1O0qlWI2R7aFskC2q1z6YHislwYTyvE4jf/CIt68aVxbRiqH+vBHDEtU///z5jwoUqUJKiqlE6clnTP4nOA855wExXY31HbH1TtP+ctaroM2a+s3dK2zvsKHdv4KpAtD9tPSlNlVwme292aY41wC10kpnYFkoSb026k1M8K3lDNgNbj7WSS2VxSFSExmB4BArx2377c7y7pCx3rDRsBCSeZ3zee/Z3ku8nK/cYUdfcVHI0+WyR6FQ1p1LoMphXqJtzyomevt5ctdt6CpdHNVdOM4jLDAKOgJjKf1ZEAMF9AEsVMi7owC6Z4iOXFIX9EkEqtn8mLBR8jy4Dtk2pBGE2DGQTRa7lPgc9Iikw+WjPELbVDYVg4CMBUywysJYKdnS7118vyU+Zx6jUTg72ktK6kYLItbyxhKCIhpbpX54cqxAEOseCs9BZuvYh1VvaQvcgkKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 109cd6d9-f346-4926-0c0b-08dce3096efd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:23.6821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy1+v4FOudN28qy7e0SmIHF7fqc3gEaM+ic3DVa39rkYQdcI+11k9KZg2CJDRiCBfBacDBRwZZfNlzpD4ko4Xeezq/MeSJ/XNySEFTSKsz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: 6ouCSRm32hhwXAS--vNnPIvjEnz0JHp8
X-Proofpoint-ORIG-GUID: 6ouCSRm32hhwXAS--vNnPIvjEnz0JHp8

From: "Darrick J. Wong" <djwong@kernel.org>

commit f660ec8eaeb50d0317c29601aacabdb15e5f2203 upstream.

[backport: fix build errors in xchk_xattr_listent]

The xattr scrubber doesn't check for undefined flags in shortform attr
entries.  Therefore, define a mask XFS_ATTR_ONDISK_MASK that has all
possible XFS_ATTR_* flags in it, and use that to check for unknown bits
in xchk_xattr_actor.

Refactor the check in the dabtree scanner function to use the new mask
as well.  The redundant checks need to be in place because the dabtree
check examines the hash mappings and therefore needs to decode the attr
leaf entries to compute the namehash.  This happens before the walk of
the xattr entries themselves.

Fixes: ae0506eba78fd ("xfs: check used space of shortform xattr structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.h |  5 +++++
 fs/xfs/scrub/attr.c           | 13 +++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index f9015f88eca7..ebcb9066398f 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -703,8 +703,13 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
+
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
+				 XFS_ATTR_LOCAL | \
+				 XFS_ATTR_INCOMPLETE)
+
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
  * there can be only one alignment value)
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c16d9530cca..990f4bf1c197 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -182,6 +182,11 @@ xchk_xattr_listent(
 		return;
 	}
 
+	if (flags & ~XFS_ATTR_ONDISK_MASK) {
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
+
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
 		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
@@ -463,7 +468,6 @@ xchk_xattr_rec(
 	xfs_dahash_t			hash;
 	int				nameidx;
 	int				hdrsize;
-	unsigned int			badflags;
 	int				error;
 
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
@@ -493,10 +497,11 @@ xchk_xattr_rec(
 
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
-	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
-	if ((ent->flags & badflags) != 0)
+	if (ent->flags & ~XFS_ATTR_ONDISK_MASK) {
 		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
 				(((char *)bp->b_addr) + nameidx);
-- 
2.39.3

