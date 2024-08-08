Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C582C7E;
	Thu,  8 Aug 2024 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723137168; cv=fail; b=X5nGq15Q9pZNepCSi15ZHPAijk1n9f4EHrO8NobomDgxrp11hjt0G3X+enFNVnoRe5ZngL1kKXXN56T78j9HJ5GzEzrqVL4t9gcdumtkJv/GeEmgFWzQpxNUrnTgho5Nc5esUqYyob0RwWV4u2+vA5kKnigD4z76qz9+Ywkm3JM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723137168; c=relaxed/simple;
	bh=DHbwkyc4EFb0jDwycI4IcqBeZgSymZ+yVLk5TriwsiU=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=UaBEI059TW8H+4aMMsLHUM66EO3IVUeVAAvBHJUjhoPajUT8oQvPGG2AHNthaxutj25+yIviHGZXZbSkJshgshHw4UKjd3IzhkXdb/62prjMhaSStlkYkbziD4d/5MHCoKn12wPBl3+tyOYq712qscXrdolo4Yrt9PnhzGcsQGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JSwbaq1H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qETvRJta; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JSwbaq1H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qETvRJta"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478AMcJn020470;
	Thu, 8 Aug 2024 17:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:from:subject:to:content-type
	:content-transfer-encoding:mime-version; s=corp-2023-11-20; bh=n
	1TPaGa2xqnWS4wStCenH763z0d7PDetQVT5EH/NS+Y=; b=JSwbaq1HF1dtLv+F4
	F4M1Txw5g5j9Cra5NTcRWgYG3dZrhoYOIfmbFqaM333QZAk0rlP5Zx3i5v2rI8o0
	A5S15W6MEBk7RmCzhQFDECsXg3SOGcMcpDXGnDrRelcTFI5vbohyZvOEvTgcD7JJ
	vVqDQD1NOiA65VAd2EjN7s/W4Eh/OeKhftSFU6Si0v1d+k+92mLGCPwwZTZ7GK0w
	voxGKLt2poJpndADypYD9bKffcR5Ha8iqsp4MEVbp3AhNqIt6eoHH8/H0W+Uzou1
	u4UOun2jrsfF2j5thHR1KzjPx6ubZNiLP/sDSfbUlKhWS4uFUYiDD2yde4FTUueO
	ecbpw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sce9a8fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Aug 2024 17:12:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 478FrTi0040719;
	Thu, 8 Aug 2024 17:12:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0c01gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Aug 2024 17:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQFXAD6OlcXIBuBpix9782hx8fr878rCrjSHo3RB54Zk8V60Pf2KmSKeFs5ri/nhb+EICXC5GbEQ0ytTcrWYX0CcrN3CJtqPIFUO7d57ZeGmjjtuRyG06UmUq/f31WxDZneSP/k6h/WuJZLYu9tes8VlUEjFnHcoieQMxTEbd9Xy3cFtGx1OKlqZ5hN4fWFdgT4pmE4VK2QqiX1TV2qIqH1S3eTG+4mMhGMFtAw2FYbBPkFmqKK7uvhrATROWuRs4g21vN18UDTxE7X3BRzCdgE1sQdTSiZo4qrswE00Uk14VFlAewiCHvj9Z7w5WFv67loS8XXifU8urh3e7VWxLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1TPaGa2xqnWS4wStCenH763z0d7PDetQVT5EH/NS+Y=;
 b=q43zGZcB7sugX2G2YuZjkjuMq7nZ0bH4gBuHf/IvqvKVptykFw9y7RkfOmaB7OwuX+cjlQDAM67JoLSFJlib6X7DVz4C+xjvnqJToqFuvdBD9VNN8qOGxKdt1ZNSV+ZaRD/pz4qLXpQh7eqvWmpO3P39IDooRtv/U7w4JnmvYbVgUyZAk0Z6tmOjNFwxnzuxe+GEVdq7Ua0A1vf5+Oyq79xxQB6A7znx6cFgpfji3OcLjTicNCDGn2VCxBGn/BVXqduSVk0RZfHkRKD+YgUh7B6kjoSwj/cHQT+3wXq7sYQGInfugFatejiDfK/ppK1BpbP+lsAXsDq09ut4b+Kvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1TPaGa2xqnWS4wStCenH763z0d7PDetQVT5EH/NS+Y=;
 b=qETvRJtadReAtzhv6Bjwde4zQ1cG6JEu+4b1HdJl3uTfEqinBmLCAlMuqzKu6iQp8pJRDbXy68feI7/UNoHg91rAUbJ5NjXWq8eziM0NWzjpQ7dtWsSRK03n0pTkr+REZupjVkdxPZSJ5/V7R6h0WEE7pzMfNYZxBvOS+KyNDsU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4200.namprd10.prod.outlook.com (2603:10b6:610:a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.9; Thu, 8 Aug
 2024 17:12:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Thu, 8 Aug 2024
 17:12:37 +0000
Message-ID: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
Date: Thu, 8 Aug 2024 18:12:34 +0100
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: [bug report] raid0 array mkfs.xfs hang
To: linux-xfs@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Content-Language: en-US
Organization: Oracle Corporation
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P251CA0016.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: 30cf9a8d-5492-4858-8f63-08dcb7cd4d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YklETjJHY3R5VnJtVDAzd2tuV3N5UE1lVU9iSGxSaDd3V3NlMFNPY1MwVTFo?=
 =?utf-8?B?NHR3TWZaUnR0WG1Xa3AxVTFmZ3g2V2RLVzNxd3hXdEZlbWpBUnM0cXJaVEJt?=
 =?utf-8?B?Mm5KcUpiMUdiMDJONmpTZ0FpTzlmbE93SGR6WEVuTGx3ZEVzM2I5WkhQbzZP?=
 =?utf-8?B?RE9yeHljd0pGcFkvZjh4dDRvTkkySm5Sbk9ieXJxOEdpYnYwR2tXU0VGZEs4?=
 =?utf-8?B?U0VXMTZ5dVRXeXNCZXh4RlNhUjJWeit4WXhGNlpnazdZYTZHclMydVc1Umd5?=
 =?utf-8?B?eVZFajNRNGNrcEVYNHp3UjRTWkNXYkhHdmpvcE1uSHlVWW5SZnd6QmVEL2FH?=
 =?utf-8?B?S3U5R0hrRFl4VVpEcjIvUjFCeU84RmlSQzVUSzFic2pLWkZUdTQyOTVsZzB5?=
 =?utf-8?B?Qk5aenhuSEFxSm9zT0huQWVkSHR6d2diU3JUOEVlL2hqaWsvZUh6eDh4THJS?=
 =?utf-8?B?YXdzMXNWNFVlR0JCamQ0R3FXQlZpRWMwYUhMMkFwRUZwdmk3RzcyUmlwVTlv?=
 =?utf-8?B?dmNmcW1uMStOSW5BSUdqSExMblVDZFpHMjNNZlJtL0E3dWc0aFZ2dFFyR1hm?=
 =?utf-8?B?QzhyaFppT3lENG5KS01qTzQwVG9CaHFES0pacUV1Z1BucjRNSWcvMWZMUVZq?=
 =?utf-8?B?WGordnpudTFUTUFIYWNYUkM5V0ZuTGExR3JFWnpXdlVFayt1Z3RzMklmN0xM?=
 =?utf-8?B?MFo1UVAvMXYvNURkRnJUanJXSVNsc0twWCs4dzg0S1BNVXI0SkZSdEVuR0pt?=
 =?utf-8?B?bFQ4OGZac3NMTk9USXRJRDFkaFZhMWVoNE0veUFmSlNtK2wxTG9nWlF1WVll?=
 =?utf-8?B?NU5FYVpnakh1UHFCMkRtSitDVCtGV1lNOE15bVVaNFphUjBibndHR3ZNT3lm?=
 =?utf-8?B?WFFtUW51OFpxZ2ZNaFpRUmtZMmQ1TUQ4RGxVa0NkWlo0VXU1Ync0bGhmR3VO?=
 =?utf-8?B?RFVHVkp5dU10NHY1MHBCN0hNc0QxVGVkUk1SL29UbWx3UnlnWU43TnlhRkJI?=
 =?utf-8?B?Ky8ycEFQRlc3b3QzWHI0QTJTWERza2N0czdCYWdOQUx1enhTVzNNV0JwbEZX?=
 =?utf-8?B?ajJnR3VEZUhwZldrQ2dnSE51cWd6am03WXdEeDNnd0JCRytLNitBZ3lmQ25T?=
 =?utf-8?B?b1ZEMWZQdWxLeXRySGRYazlubFdlblg3dG16NmUveis2Z2UzSUQ0QVYyY3dy?=
 =?utf-8?B?VUQyWEVSOWNPcS82d2RPN2JnMG52TkZVUjc5YmRnYWFYYnQ2UGFndTh0Q3d5?=
 =?utf-8?B?ZmErbDFhK3FBOEl4Z1ZsOW1KRFdZNzFyVWk4V0RkZldhdXkxV2dnZC9ZTzVv?=
 =?utf-8?B?V0J1WmNzMkNQOG1VSEZZbUdra3JoRk81eGR6ZFNNQy9jL2dUZGc4YzJrMzhE?=
 =?utf-8?B?ZDJBa2dXdkt3NjJLOVdYK1Fqb0dQNEhocGU1MGMvU3VPcEovaVZsdFpYR3Zn?=
 =?utf-8?B?WkoyWmhsalZleXV6aWlOQmk1ZUF5NTQ0YnUrb3lMcWJDSC8rT1kzZE1aMDhC?=
 =?utf-8?B?b0lLc0tmd1FCcndKbzdGQWczS2pHbHFkcFRONjkvbk02SGQxMlJ3QlVicEM2?=
 =?utf-8?B?Mjl3RzRkc2FYL1NXT3BPT3BFS3NmU1BnVXpmVUhQMDlONWh4cUI0SlJodDZY?=
 =?utf-8?B?L0dKdEhrYktqRUluVWJ4OFdKNEZmVmNzTm0zcXRpRzFrSEtCZy9hNmhFbjlR?=
 =?utf-8?B?aVJrVlhVdGhpODUwUFI3dVpmWTNkZ2FGUEZPdGNTRDkvbUdZUHJ6NUpoZUlG?=
 =?utf-8?B?Vm5JVnliTXBIZ1FzK1JNY2l6VndIS01pU1dHb3lGQW9adWlKWFlwWGhSQUo0?=
 =?utf-8?B?bmZSYmtrNEtkZXlxRFpwQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkJqMjhnKytXa1VTUm9wejM0MkxrMm03WlpnbVNya2UvaXBFbWlMT3RhYlo4?=
 =?utf-8?B?YldRdVRzbUNyVVlqY01hWE9CZDAxbTFNeUlId1AwM0ZsaDI3d290bXp2ZXFG?=
 =?utf-8?B?dmZuSUE1ajM5dHBidGtqdlpvbkFYQlIreGdiWXdjVU1IeUM0bnhKYzlnNWI4?=
 =?utf-8?B?VUxmV1FFbzBxZDc4cUFTVEVQbml4YmorY1VIYkp2c3dIZHFhWk5mRlNOS0pk?=
 =?utf-8?B?dE0vWTNYQTRiMVp4RnhkYVNRYXdIaTRSYXNQWWNoUEJSUkdCOFJLSE9KQ2dl?=
 =?utf-8?B?cjB1Q3VtdlNwWDZaL0xkUEhpUlc5MGJDbFREeXFlbXZnc1ljVXhPZjdYN09q?=
 =?utf-8?B?OGYxU2NyWTAvb2NhUm1qZXExVGcwMTBjK1VHWEMxRmlPQllSbUpLdFJnZzls?=
 =?utf-8?B?MWk3MDJMMC82UUtKZFQvcTJIWlpEMUxsQk84UG9mTXpPUzBJeGtnQkpYRmtW?=
 =?utf-8?B?VGI0RUlxRHhLWlNSYmpVK3dJQ25wWTB6VEovblJGa01CZEtQVTVOVEFqWmJ3?=
 =?utf-8?B?Z1ArdXpQcXA1TWNEK0ZFcy9tcXVhM0J1SW5Nc1Z1bllHT0k1bE85VS9LYi8z?=
 =?utf-8?B?RmVlUitza1pQK0w3cUN1Q2twejRCOURnT2lMemdUQzJpdHViWEttM0lkNUVm?=
 =?utf-8?B?NG1ZRGFTcEFFM3Q5NjZnNGxNb3dXY1cxWk5Pa3dVdWFwZ3dKa2lWNUR1YTJI?=
 =?utf-8?B?WElvdDhldjllMGVhRGt6YzA5azZTb01lVExZeEE5V1NuNWF3NWQzbmovVVFI?=
 =?utf-8?B?ZlJkampjOEJwTE1DNG5ka05YdXJVRFZxSDBNQkpaYVFjMjBSbGNiOFRORXBK?=
 =?utf-8?B?NlhOSFVsQTg4RUN2Z1NCbDR6L1BxUkNrMTdQMC9pUjhobTZrOTZwYjNoVE85?=
 =?utf-8?B?dlBCT1hrTUxReWJQakp4RFJneFozQTJ0NDB0N2dRclF6WjduZGIxdE84d0xX?=
 =?utf-8?B?RXRBN01iSEtIVHJST09oLzZrck9SVmdXMSt6cEN4bWtVNjRrT1plTnZRbWZl?=
 =?utf-8?B?Qk85ck9MQ1AwOXpuSXV0bGY5K0NHRVBIUExET1FvRTVGS0I2Q3JCMVF4cjlj?=
 =?utf-8?B?a0lEV3o2Y1lIL3VNK292RWc4ZVdzbEJTcWt4ODkwand4NTFSYlh3VkhwWDhJ?=
 =?utf-8?B?bzVFTVUrSGFka3Q3UXg1RUYwZU8xand1WENJZTI1ci9zSWVxM2I3aEVEenN0?=
 =?utf-8?B?cThBU0Z3bGVDbDFMdzltSW9KK2ZGWlZ6UG85NC9rbkZOMHRwbVBuU0JobXpt?=
 =?utf-8?B?b2kzQ1o1RUdTSVJMQzNwZGlObXlockdxZW9SUFJoRHh6ZlpUbnlYQjJsZmQx?=
 =?utf-8?B?dUZTSGlaNDBTa3hrOTVNSlZSTGMrMnBkbDVXWitZOWswWjdMZXY0S0Zobzhy?=
 =?utf-8?B?b0UzVVdDWU5vZmMwcEYwMmUxMDU5Ukt0VndiZ29LY2VKRG1mZDBacTR1VGVs?=
 =?utf-8?B?ZlY1cmV4OUk2M0pzYUpFempUVXRQaU1TaEdGUlBza1JiMUVGLzNIU0FjTHZK?=
 =?utf-8?B?Z0RIbTUxbTQ4UzJDZTZ1OW05Zk1lTHVXSTNQZFFNS0EyYUJlbHJ4bytVUSta?=
 =?utf-8?B?bUtpb1RjL0EydThFbk5PdHMvSWZ6VW1Bakh5aENXWSsyZVo2OU1SdWYxUU1o?=
 =?utf-8?B?ZVJRTUZiUElvQ1NjRDE3SlM0T3d2aDJtc2YzeEtaTk9CRmpJbWc5eDF6TGND?=
 =?utf-8?B?cGlqMWpUNjhleVhmY3pKZkh5alFOVlV5VVNsZ2ZMQmdoZlFBT0o5bUlSYVYz?=
 =?utf-8?B?d25DamFFRjhKM3YyY0xORk5BM1VHeHJrektvNEZEL3o5a3VRVXVuS0krTnV5?=
 =?utf-8?B?eWsvWmVTdkdGUEFGeXlaR3NLanFlbzlJMzVORm9kbkdjL2h4KzlaVGJtUitX?=
 =?utf-8?B?T0djRE4yOW5aU1JLSlBRYmRtV0ljeC9leTdhUm9XQkI4Nkd0eWR0WnBLaUpt?=
 =?utf-8?B?a3FxN1Y4SlpLeWhqaGIyT3NwMS85OHMwdTQwVlRjNTZKbUlMZ29CN1lmTENa?=
 =?utf-8?B?Z3M3a2xwZGhIU2x1cnM5OFJQYUVzYlpZTlNEOVoxVE9MT09EWDU2MjZnYWs2?=
 =?utf-8?B?eXU4ekxkdzF5NjNVQkxsSndiU1ZyUmZVTU1EL2hhSERFSXRKSS8wekc0VzZa?=
 =?utf-8?Q?FPIiPNilxet51csEhzKs+/rq9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XWvEn1Ulz/0kSRhSO8X6a8erLLFtCn2KvLXhJNsaP2w8ZRsPDNtQ46OakSQH1K9Top89PrD+vrv14gDcrUHry0vBeJzjhQFB4HkvQHoI5At3ZjvJaXI3RQqz2jPcWpJJOZ171iexvvag/3OLCQR/OvGFxadwCC/7aZdL/ae+fkCkcxCjmLzdTBBr4VBeMOZNVRblT9rL8/EY5dSUOx/tGUV///27pFoKzkQSxR+hfq3znWswIxzGWx55kGeGWxytSB3Mw87mN0/GoLT0PJfAhje7hdkQJHHRquyTRuFDZ1Fdp96pD5plm6ry97Oer7q2fIIQjlJk18kH/VSvNbhxFIpookTI9fc1WNwGiqjm/eiLI5r+h6pN8rxPlJWlmkxlreEWW6yChIWLbjKx1i3jeVCdpSAtTt58vX4TKDQwN+LOw1J9oZ6tQ3PfpPVRbJyuFfUzjFzU0SpCT36aDQcsyts4ehMzJz3JygOkx7QpcOXvTlLbvVanHPktrn6aSJ4AxrQbKLByx4WC3ZVVfKiv0aBL1SkpNF/41CdzMt9nQjyQ3KGZIBedKA8as4TLz9a/Ttum6RtKUFtIqUqAazM9P7vqBvWODjDeQc2wbnqzAb8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30cf9a8d-5492-4858-8f63-08dcb7cd4d04
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 17:12:37.0133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFntgCmAqp3QvGOVZtz5Tey4PXbbQLkCwFcyjdcV0/+5yCrn25NYEgXbeduNRwmhzGB1mCKVRHsdEmGvkgebSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4200
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_17,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=952 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408080122
X-Proofpoint-GUID: YtVFPCdRGLbC_JcGQ_gzbJhCnWmLuCsP
X-Proofpoint-ORIG-GUID: YtVFPCdRGLbC_JcGQ_gzbJhCnWmLuCsP

After upgrading from v6.10 to v6.11-rc1/2, I am seeing a hang when 
attempting to format a software raid0 array:

$sudo mkfs.xfs -f -K  /dev/md127
meta-data=/dev/md127             isize=512    agcount=32, 
agsize=33550272 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=1073608704, imaxpct=5
          =                       sunit=64     swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
^C^C^C^C


I'm using mkfs.xfs -K to avoid discard-related lock-up issues which I 
have seen reported when googling - maybe this is just another similar issue.

The kernel lockup callstack is at the bottom.

Some array details:
$sudo mdadm --detail /dev/md127
/dev/md127:
            Version : 1.2
      Creation Time : Thu Aug  8 13:23:59 2024
         Raid Level : raid0
         Array Size : 4294438912 (4.00 TiB 4.40 TB)
       Raid Devices : 4
      Total Devices : 4
        Persistence : Superblock is persistent

        Update Time : Thu Aug  8 13:23:59 2024
              State : clean
     Active Devices : 4
    Working Devices : 4
     Failed Devices : 0
      Spare Devices : 0

             Layout : -unknown-
         Chunk Size : 256K

Consistency Policy : none

               Name : 0
               UUID : 3490e53f:36d0131b:7c7eb913:0fd62deb
             Events : 0

     Number   Major   Minor   RaidDevice State
        0       8       16        0      active sync   /dev/sdb
        1       8       64        1      active sync   /dev/sde
        2       8       48        2      active sync   /dev/sdd
        3       8       80        3      active sync   /dev/sdf



$lsblk
NAME               MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                  8:0    0 46.6G  0 disk
├─sda1               8:1    0  100M  0 part  /boot/efi
├─sda2               8:2    0    1G  0 part  /boot
└─sda3               8:3    0 45.5G  0 part
   ├─ocivolume-root 252:0    0 35.5G  0 lvm   /
   └─ocivolume-oled 252:1    0   10G  0 lvm   /var/oled
sdb                  8:16   0    1T  0 disk
└─md127              9:127  0    4T  0 raid0
sdc                  8:32   0    1T  0 disk
sdd                  8:48   0    1T  0 disk
└─md127              9:127  0    4T  0 raid0
sde                  8:64   0    1T  0 disk
└─md127              9:127  0    4T  0 raid0
sdf                  8:80   0    1T  0 disk
└─md127              9:127  0    4T  0 raid0

I'll start to look deeper, but any suggestions on the problem are welcome.

Thanks,
John


ort_iscsi aesni_intel crypto_simd cryptd
[  396.110305] CPU: 0 UID: 0 PID: 321 Comm: kworker/0:1H Not tainted 
6.11.0-rc1-g8400291e289e #11
[  396.111020] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.5.1 06/16/2021
[  396.111695] Workqueue: kblockd blk_mq_run_work_fn
[  396.112114] RIP: 0010:bio_endio+0xa0/0x1b0
[  396.112455] Code: 96 9a 02 00 48 8b 43 08 48 85 c0 74 09 0f b7 53 14 
f6 c2 80 75 3b 48 8b 43 38 48 3d e0 a3 3c b2 75 44 0f b6 43 19 48 8b 6b 
40 <84> c0 74 09 80 7d 19 00 75 03 88 45 19 48 89 df 48 89 eb e8 58 fe
[  396.113962] RSP: 0018:ffffa3fec19fbc38 EFLAGS: 00000246
[  396.114392] RAX: 0000000000000001 RBX: ffff97a284c3e600 RCX: 
00000000002a0001
[  396.114974] RDX: 0000000000000000 RSI: ffffcfb0f1130f80 RDI: 
0000000000020000
[  396.115546] RBP: ffff97a284c41bc0 R08: ffff97a284c3e3c0 R09: 
00000000002a0001
[  396.116185] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff9798216ed000
[  396.116766] R13: ffff97975bf071c0 R14: ffff979751be4798 R15: 
0000000000009000
[  396.117393] FS:  0000000000000000(0000) GS:ffff97b5ff600000(0000) 
knlGS:0000000000000000
[  396.118122] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  396.118709] CR2: 00007f2477a45f68 CR3: 0000000107998005 CR4: 
0000000000770ef0
[  396.119398] PKRU: 55555554
[  396.119627] Call Trace:
[  396.119905]  <IRQ>
[  396.120078]  ? watchdog_timer_fn+0x1e2/0x260
[  396.120457]  ? __pfx_watchdog_timer_fn+0x10/0x10
[  396.120900]  ? __hrtimer_run_queues+0x10c/0x270
[  396.121276]  ? hrtimer_interrupt+0x109/0x250
[  396.121663]  ? __sysvec_apic_timer_interrupt+0x55/0x120
[  396.122197]  ? sysvec_apic_timer_interrupt+0x6c/0x90
[  396.122640]  </IRQ>
[  396.122815]  <TASK>
[  396.123009]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[  396.123473]  ? bio_endio+0xa0/0x1b0
[  396.123794]  ? bio_endio+0xb8/0x1b0
[  396.124082]  md_end_clone_io+0x42/0xa0
[  396.124406]  blk_update_request+0x128/0x490
[  396.124745]  ? srso_alias_return_thunk+0x5/0xfbef5
[  396.125554]  ? scsi_dec_host_busy+0x14/0x90
[  396.126290]  blk_mq_end_request+0x22/0x2e0
[  396.126965]  blk_mq_dispatch_rq_list+0x2b6/0x730
[  396.127660]  ? srso_alias_return_thunk+0x5/0xfbef5
[  396.128386]  __blk_mq_sched_dispatch_requests+0x442/0x640
[  396.129152]  blk_mq_sched_dispatch_requests+0x2a/0x60
[  396.130005]  blk_mq_run_work_fn+0x67/0x80
[  396.130697]  process_scheduled_works+0xa6/0x3e0
[  396.131413]  worker_thread+0x117/0x260
[  396.132051]  ? __pfx_worker_thread+0x10/0x10
[  396.132697]  kthread+0xd2/0x100
[  396.133288]  ? __pfx_kthread+0x10/0x10
[  396.133977]  ret_from_fork+0x34/0x40
[  396.134613]  ? __pfx_kthread+0x10/0x10
[  396.135207]  ret_from_fork_asm+0x1a/0x30
[  396.135863]  </TASK>
