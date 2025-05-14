Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237EE20DF4;
	Wed, 14 May 2025 00:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182570; cv=fail; b=I6sglISzBxpgcrqpxneh44XtUqG7/aW7EGj5waD1zepn6eKujxTIu9104HK3Gr2Qa7PtOVl3ohKYiyW2eOWD+I3Sfwn8jj2kJRNZ86OXmZvP2Y2fD5a/WcIsKhzHXhrvKkOj2YhabGD5V2STz5pcy3b2NCgvNp/iXzj1rKNNEIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182570; c=relaxed/simple;
	bh=p6RFN+hns4YM5b/RNskvLqphUldhLqfGWpnLz6lBnJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J4vl+QrCoA0migTtKSQZkIkPX2Y9PrKB7rTXDYLiawyo+AvrBAkucGX4hylFjvbFoQoxFyFKhrsX8ZxAsg4nTLRivedJPhcDTMo1H+a7RWyTrm6uLXtlU6YIf4zzV88ygQAlUrBmqQZVBk+XnNQ8g7WG+kF4oIl63Rpg7msq1X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FMvsw7Iy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JnB9D5QL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FMvsw7Iy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JnB9D5QL"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DL0jp9027385;
	Wed, 14 May 2025 00:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mMoM9ILunjoYAhexTBOxI9S0bVJ8qtWjogPDzo2zNuI=; b=
	FMvsw7IyBQg07/jzk8ySJU0wOMVWsmENWDGsJBzapvj/JRct0TfqqnhZv//6lElq
	kGpifhxnWPXEzn5ZODk4WOt4xwRwudrzIl+Eknlq/f8cXW3WG7DzVfutw49e/anb
	wVQpIkF/2b7p0An6tuLovftODaFwSZuRfdSj6y52j1NfV6UGKlbuD5SVRPfRKE9y
	/S35PptHajTpI/WZGSYsP4RwmpcZKH/A7WOAaaJvB24NV8/i2hFMxlw78E+5Gg0Q
	2/RXWb3D9/JtSpKwxGY7BIfkGbWWlGocWf4X0snKep+bepmXlpkeOXkAyWtT6YTz
	suLIxfDSDR9FX7Vx4bNDKw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcm0g91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNo9V0001808;
	Wed, 14 May 2025 00:29:23 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011027.outbound.protection.outlook.com [40.93.13.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mc50131w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PL4A50H74T7f7dURvVYmLCINvYTAsYvU7252jRJMZ0i+2xIrVtyz8TRue0vTKAAsP0S98DsqSM2g+dITViIVQPgyui4QrLUz+Or0PygE+bZCFzWuGGNSzyutNd+fSb+eSb+ihoSM0w16JHZWlFB6Z6HVb1pOn7NCDUQJhgHo4bAPOEP3/0o3ITUlWzksOSPQfISv9C45cB3WCMj8620ZMkuoDmBgdLcxyeA5KC9tg/Is63ja3t56VMgOEnFXuFX3MGotRKcHk5XuVRNdDcIaQI1BmVeCVp9vZKT7b4iv7zIIjKo4cOQFp6ToRVr3V0ysQf8FNEWzx207Oi4NdIXiPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMoM9ILunjoYAhexTBOxI9S0bVJ8qtWjogPDzo2zNuI=;
 b=iKXytBqoU4HCPjaYE9oj3m2AX9IpspU1s2Nfx4HTpcdPoXZB7QFU7/jgpxz9LdnP6g/PAa1pnyDmbxGTOq/3155jYvEP9dlvDEc/F3/8UXgxRuhOf/m8Hws1qZuj9hyfnzqQDIP4r50Y/UHWwekDqI3stEYF7fcICWKWs+BycZJ41nlax3TrP9+vzjuqyaz4Rn+d2OnPU8g0XyIx8A9+kgUvYMSjBXbIa8zwP+i39N1ipgrQ2JyJp9lf3hHMmgz/H98J0QIV0ZmRRJpTsn/lJMXFCI85HP16j/7X+k2++utzpeDB4M+Wi3FnpC6NZhxV/BF6bEzUMxY7C7y4xcJq5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMoM9ILunjoYAhexTBOxI9S0bVJ8qtWjogPDzo2zNuI=;
 b=JnB9D5QLsB2r9CKcOLtnbSx+YHU1U6+3G7cRihSyBaCLoYdpwRvq9E9bOOzWeCHkNqmYbWA5UoiDlLbJXSrEqetv7tZOpH8G6B74RgDPwLjy5JZ0f3WIhiJvhV1EFjt8aMb0g01Gn7YfJhDaiHgNKj/Oe1Y2TN2tC0IqCFW2qH0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 00:29:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 00:29:20 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: [PATCH 2/6] generic/765: adjust various things
Date: Tue, 13 May 2025 17:29:11 -0700
Message-Id: <20250514002915.13794-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250514002915.13794-1-catherine.hoang@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: e4759635-bc40-4bac-4938-08dd927e5e9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KVsxAUDcekk5SIk+kL7/vu0tjlVMv0y92kMcmyH2VXk+9oGjcMDYxoA7vFMq?=
 =?us-ascii?Q?7K9MtK5+2ZpO1xNzRc97x3f+cZ4St1VWK78Xty9TNAvbE/LRqv6jM89sbFTK?=
 =?us-ascii?Q?02RgoNj38JSuW3/AZ77T/WT/lmaXx1P/0T7wiDWHkuyiVJHiPokzL3OJEDFn?=
 =?us-ascii?Q?Wcv4f6BVC+J1eCxOkHY0nTmmHw+4dR1ZThcXj+3E4i564Z3a2ecGnDzfpmBz?=
 =?us-ascii?Q?VMJnKLPHBx1UFqggPac864GdYOd1RhRgCXLtxFC0vjo2Lcq8u98GiY65xGS0?=
 =?us-ascii?Q?U2Jjr25XhQLiEkAFLQjif2pFjquIq6Le+z1Clr421p4Vfp765ynohCJtcNe3?=
 =?us-ascii?Q?auuUqoIYsLnnIK8WmlO+43KXW8zKdeo1isfS4pMMMTsHTWBCwBPpQXApOeD4?=
 =?us-ascii?Q?CX0uwCTy9Yk5XOsne/6oxdhflst2/BR9G/9mj+06LTUYeUOkQrpX27rcmbKR?=
 =?us-ascii?Q?xftlI4O1wphbYebntzwE23q/4QmjlhK4SPLPccC+LqsIH3KRRbMIVIY4sQJb?=
 =?us-ascii?Q?zfiVUuPXQyMte3ddsX96EsrsW8mB9/h1z9QA/Ije2u7tFufRh9zvjKdqFxr/?=
 =?us-ascii?Q?pOhIC/XGEWpoQFcnZrmsdM9EtvrPW0+MRfWdBOFCJq82K6NtVcg3otMYP1tK?=
 =?us-ascii?Q?haImhq3wfrK44CrJgIJr9mA9xpw+iL9DL4mkXdM8WJH+EYq4tvyHUbcwDWRX?=
 =?us-ascii?Q?82i7HBGg2K0FuuZFayPCMH2UeApNsJhvOsODfR+ZiS1o3zPJ7m+fGRD/8hyA?=
 =?us-ascii?Q?qWcmkOeYisDCNJss5FKQCX+Akh0PxUbdh0IJWiwF3FZAqiSqwjCPbRLB1wN/?=
 =?us-ascii?Q?fqRBcLmQuDBDnW8KwUoiZQCCpdSBILy9ho2pnKL3XrBajqNfffbTtpm3QNpw?=
 =?us-ascii?Q?JfWr5vuilSygb13K0EWVWI3YN5d/rKUQggOMVPY8hZLszSWm/VFCEw1EtJ7Q?=
 =?us-ascii?Q?lffOZj2TaI6w76Ouz22KgKRV5u0ypRYEPLoIk06AkJ89vGbrRlZq/F5zxf21?=
 =?us-ascii?Q?Ww8aawjeOdkJW05k+80bN0ofBbC9DuKGPRWJQlyasfJ+TLPEUfz9s6NEtJot?=
 =?us-ascii?Q?Yf8Q4LOHnT/W1QgzaahGmUhgtRUJDUwwKz2gaNRpQHLTC3GbWNGrhOYFE+1k?=
 =?us-ascii?Q?7G2DKGUKFY0xp522BWkeuwAWBIm/5+PNBi/86HdmcRruOseV/EFeshofkuoR?=
 =?us-ascii?Q?o5NPpI/nHU6cubIJFGhkWAl7aGEXNQGfKOPfrBvTx4P55aSOyP/HMANv8MUZ?=
 =?us-ascii?Q?2TMZoC+kmQIysmnrcHt2nwJc7bNd0KPdXyYAopYEBm7alS50oM9r7mVy/P4F?=
 =?us-ascii?Q?5bR2qODADHbE0o0IjT/iRivZ9264zd3KNvsfJkC6K+9yyKgrn8DUt/7miM+y?=
 =?us-ascii?Q?LZn6KjfDk+TQsr5S2j0ms9taFDIJNpV7tJtQXID8mlH3AsbaNI2NYslhsE0+?=
 =?us-ascii?Q?jkpdwf5l+3c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IfwFayv4A1jpWi7qz0DqEvIH3xUaN/SGhRxKjVVHdF6NYuuLsRz1IuleLF/m?=
 =?us-ascii?Q?gT8xBmoqBLC2nwzDYbLDAJ03RM99gJ1yFyB3aomSeiwi8SjsA1FKoki6gO6f?=
 =?us-ascii?Q?xSmK+nXb0V3PS/5fYHCPsNpB6eDNOJoaYxeJ3s05iXWBCSzXnzgX5RD9lajC?=
 =?us-ascii?Q?LwMDihOISLz4VeI4DtWYbbpJCQKPZ1IthjTwajHFgg8tF9PrmEh8Ww/7jWVe?=
 =?us-ascii?Q?0QOa3IjPVDFm+3oDicp7CVgXe2wdV2UFIhj/gkPVR3yAuTXCqPY1aebh1nDE?=
 =?us-ascii?Q?PIQgmztTQxju16AT6Ql22h5KMpLxXfprVcVkckFCZDtet1ThGW0EMlOeRhzG?=
 =?us-ascii?Q?JSvtBymnsWLFyzQ4a1gFb0IOY0hMTQzDCLkjvMgLxqHVo8QgeInZPwX8E3us?=
 =?us-ascii?Q?0v0hnnCkYtWGzmBDlxzZEai6ZPolXeumYuYNqcPlCbCxo7bbetqF/EJKHEaS?=
 =?us-ascii?Q?bx5fmWNfu5QfJtzvJeUBpN/f0WDxYaJ7iwn7ojSk0l7WMuCfr6GJghGuPYxv?=
 =?us-ascii?Q?+2Limkkc0PhaKMCqbH2rXg5SIhw854hfO9eAx5pCDR73eycZ88A6FRHfW7KK?=
 =?us-ascii?Q?nzge68e7oRmJ0D+eKF3SIUDuK38hLD3mVnd855ZQ2LrII8kSntuK7jB/OCAQ?=
 =?us-ascii?Q?w+ImRYAwzXqQt98gV1ivEPirJVos6iSxDPJ0wxYNbLxN77okhJPBfuxO9Q5z?=
 =?us-ascii?Q?HOMudZCmJeMIDC79Op3b102lUTv8OomNKkH2BzoS4vAQVYZIVAFtdBoaoEtH?=
 =?us-ascii?Q?3Oeul3as0jRCW+6rRzs3CJjbuC+dTF1bcKRv0SmLEtgVKyL1ovGXlS5RXQn3?=
 =?us-ascii?Q?mATPnuB+H3XKdaP4m0XgHKlF0Zfg7B0fqsuY80pUBweTttlMyUGx2kqntX6m?=
 =?us-ascii?Q?bxD8YLzndJH/Gc3U/grTin8fZT1PmkpJME3nGtWD48t3bqgFphVH8bwW91G1?=
 =?us-ascii?Q?HzmPQi09XqqMoZRZsMMKBLwATO2/XedLI/K6yFRKIhX3CQVkORQ/s+iHf+Am?=
 =?us-ascii?Q?DP5frdKvPPck5rhos/PYFYfOlCz3i00YxyqqJmOgJTaeccJqBzvwan8aQKWj?=
 =?us-ascii?Q?Kym6n5eJv6vM3z+JD3hW6C2FTjcyc7rXZeujKLfocTR+wcfzONIfMcTVry7y?=
 =?us-ascii?Q?Xtgaeo6XnCxNEdFiNy9xqN1JvJvgpxKn+2nbS9X7CEdHd9xmf6D99FxIuRsf?=
 =?us-ascii?Q?E0JE+KiuanSgy3MYJlYtX5AQDB5FJR01goZx28gqC6w3hwSPiODdtnsV6Zdu?=
 =?us-ascii?Q?kVYvgZ8O0vMeeQZCsUOh6LkAN5yGjq4LSuBewgGh2uPZq+Q/AdgVPHksODJk?=
 =?us-ascii?Q?SmguvyYbFyBCz7C4UMxmlLQAW8oSAzl28LkzwTItak89S+34RwlcaDFc+tWl?=
 =?us-ascii?Q?5pOU/7FMMstDVydAUEAiFsSCOsY/6oGdRHMqruw0lRaqjJkX52PfcBlrxLan?=
 =?us-ascii?Q?5X1FRixHUEcj5CezlWMxJF1W3LKTbAjR/syghy0S6J3S+hji5CQYICdXlNcW?=
 =?us-ascii?Q?XmrhLvOlfAVJHi5x7WAwxmh3GQkitw6BaHCiTyg5C7F1ACLiyHEPzvSjenwv?=
 =?us-ascii?Q?da+Jix5nuR2teW6zmSHuOq7kXlmA8XEq3OLPvKcG6h4FD9oJ/2lhuAxuwxmN?=
 =?us-ascii?Q?SUQnJ3fdZzla74ZrU8Be9QuQw+73vx5DDFv9o9EG19UJ0PkzhGe36oJZN9EL?=
 =?us-ascii?Q?a7FRzw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WosYaFbbXkU9ngVgylHEsechwTcltspYqgrOv76DXj3i3ZG3MRWukrqudRlusDy5y2ZjkagMLBuTkCc4fBcU4vcH6arJjSd28esXRanJCwiDK/HoQEWq4khH+B/qqpPGmnknuW8M/T6n4kRaG+gA2CIRbG/KN1h4mG597tspmf2oX881OIa4MEgqnTZt/KFgO19f3nqHNgQSqNhcGTElwQP8Hw2HOVGWNkBPly9mLGBQ7tWVVwaMPOYf5gAn1CAzr3RZ/p9/slH1OzskJJpXFRMX2Amnwf+CRdOaSu/HEyLQfV6nDyv3ZLLiRVdTd1V3x1HyGpzSy5WLtFvesHI3Z4eA35UGDwPM6jAGM5/CzYbDD7G/bLcJIS3AmKTzjZIj9PANWbAuJf5pqQAvx1KwrpHbNLIEuS8F7B0GoD2uAshQzL+8MuHbDT679vFLya4GvacEDIsvgbFwsgyshdM1tEwIknvUC2nmj+jcFzz7JgYfx2T7m/KETSZLZ3IzAmtpAt4usvQZj5kGHDYniNtw9PMxjkIo3s4foAQ5yst7mJQojkHrIE7zXdj7rqhGXrdncSsOaLJ6oymXSfsEDo+6eM0h34u4SUVMrbxR9kMP1Ow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4759635-bc40-4bac-4938-08dd927e5e9a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:29:20.8655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfvmTYFR/tV+ARYAhorfBVKmTXTYd0GXSTA8p8YC09PVw6NW5h2awV/ZNvG5rasBu5VuBA3Vcg308sFuxlHZtLxDYLbWOKYQxJjSvGQg8io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140002
X-Authority-Analysis: v=2.4 cv=DZAXqutW c=1 sm=1 tr=0 ts=6823e3e3 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ZHJybXuDlUOdVKnBWFoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAwMSBTYWx0ZWRfXyX6ljmyMKa0I 7Ft9xo8c+C8RGSHCcD1wmXG2eHtHDl28b0X0jrNlpmc+EFg0DhNpZUrHIgCPiVGGnne6g5dvN/a FpANg8QTAHx0fgDsRqyYO98t5aML2B9OSbqJnr14M+Xz5aGRYhmSh31Wer0bIE/HGHK92DpIEIR
 RK+O8bFTWO6oyRrNukD4unsrtDZwfVP76GAx+gFLwF+ABXFO5JmaEWOBqwc3QcZ/HmOh9MySMS7 ItToTeXtOjzC6ad/YBRlTTpzlm91oJ+HQIXiAdgAnkkMn1zI1XAbogH18A/tPOVTBegkMtr9MEU QUa8y76cT3qeQUs0+6oV1jiur/f/RB7tA6AofoKOYXquBFtBDYMKJ5PIPlAGtteoDZ06ss+Brem
 5AIwKT9AtGU5XsH2tGZrKWpEBWrHLd+8Pir4c3wlD+PZZaZYsW4Xv5uQUe0kZD5Fkw3ijvqV
X-Proofpoint-GUID: KJXcCSrN4LLBQQ-nR7s5sHrRZ_nY17m6
X-Proofpoint-ORIG-GUID: KJXcCSrN4LLBQQ-nR7s5sHrRZ_nY17m6

From: "Darrick J. Wong" <djwong@kernel.org>

Fix some bugs when detecting the atomic write geometry, record what
atomic write geometry we're testing each time through the loop, and
create a group for atomic writes tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/rc           |  4 ++--
 doc/group-names.txt |  1 +
 tests/generic/765   | 25 ++++++++++++++++++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index bc8dabc5..3a70c707 100644
--- a/common/rc
+++ b/common/rc
@@ -5442,13 +5442,13 @@ _get_atomic_write_unit_min()
 _get_atomic_write_unit_max()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_unit_max | grep -o '[0-9]\+'
+        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
 }
 
 _get_atomic_write_segments_max()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_segments_max | grep -o '[0-9]\+'
+        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
 }
 
 _require_scratch_write_atomic()
diff --git a/doc/group-names.txt b/doc/group-names.txt
index f510bb82..1b38f73b 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -12,6 +12,7 @@ acl			Access Control Lists
 admin			xfs_admin functionality
 aio			general libaio async io tests
 atime			file access time
+atomicwrites		RWF_ATOMIC testing
 attr			extended attributes
 attr2			xfs v2 extended aributes
 balance			btrfs tree rebalance
diff --git a/tests/generic/765 b/tests/generic/765
index 8695a306..84381730 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -7,7 +7,7 @@
 # Validate atomic write support
 #
 . ./common/preamble
-_begin_fstest auto quick rw
+_begin_fstest auto quick rw atomicwrites
 
 _require_scratch_write_atomic
 _require_xfs_io_command pwrite -A
@@ -34,6 +34,10 @@ get_supported_bsize()
         _notrun "$FSTYP does not support atomic writes"
         ;;
     esac
+
+    echo "fs config ------------" >> $seqres.full
+    echo "min_bsize $min_bsize" >> $seqres.full
+    echo "max_bsize $max_bsize" >> $seqres.full
 }
 
 get_mkfs_opts()
@@ -70,6 +74,11 @@ test_atomic_writes()
     file_max_write=$(_get_atomic_write_unit_max $testfile)
     file_max_segments=$(_get_atomic_write_segments_max $testfile)
 
+    echo "test $bsize --------------" >> $seqres.full
+    echo "file awu_min $file_min_write" >> $seqres.full
+    echo "file awu_max $file_max_write" >> $seqres.full
+    echo "file awu_segments $file_max_segments" >> $seqres.full
+
     # Check that atomic min/max = FS block size
     test $file_min_write -eq $bsize || \
         echo "atomic write min $file_min_write, should be fs block size $bsize"
@@ -145,6 +154,15 @@ test_atomic_write_bounds()
     testfile=$SCRATCH_MNT/testfile
     touch $testfile
 
+    file_min_write=$(_get_atomic_write_unit_min $testfile)
+    file_max_write=$(_get_atomic_write_unit_max $testfile)
+    file_max_segments=$(_get_atomic_write_segments_max $testfile)
+
+    echo "test awb $bsize --------------" >> $seqres.full
+    echo "file awu_min $file_min_write" >> $seqres.full
+    echo "file awu_max $file_max_write" >> $seqres.full
+    echo "file awu_segments $file_max_segments" >> $seqres.full
+
     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
         echo "atomic write should fail when bsize is out of bounds"
 
@@ -157,6 +175,11 @@ sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_un
 bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
 bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
+echo "sysfs awu_min $sys_min_write" >> $seqres.full
+echo "sysfs awu_min $sys_max_write" >> $seqres.full
+echo "bdev awu_min $bdev_min_write" >> $seqres.full
+echo "bdev awu_min $bdev_max_write" >> $seqres.full
+
 # Test that statx atomic values are the same as sysfs values
 if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
     echo "bdev min write != sys min write"
-- 
2.34.1

