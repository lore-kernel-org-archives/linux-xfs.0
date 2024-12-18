Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CC4176ABA;
	Wed, 18 Dec 2024 19:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549478; cv=fail; b=iDwui/oJBIbnixeUvMJMiBiBbpJxbcgB60+GGv3upOPHnFsIYpX+HWULD3tK4p7Edh0YVtqBGBhU4FQbSja///1k1XPiIFKjtioBCFzYN9taxZFqRg10orCOPkbuQiKFtwmal5pt6Xpt4OITBHwsRmfoXI+fSGzvYOfM3rkoaVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549478; c=relaxed/simple;
	bh=2T4Ei7Wgs0/7OT+59xDta2Zxl8Z3BzZQWEQNaAQGToM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C305I6a77F82aFqXR43wEYr7Sz1HKXxODJGHiZXJ+BlDuxzC6RFLaU60pykg6UDpGB9tZWNwdi5IAvYLXl450aarc8zpkZNKNbEOzZIQ6260yAYrgRze2yKyQTFNYPE27ybGdQ9SvcCaE4VOGv3LzMery9IKq8wecLXWII6ff7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dv9du5mf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nmA2y49Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dv9du5mf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nmA2y49Z"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQleG004411;
	Wed, 18 Dec 2024 19:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1fxEN4VpKLKXrvHf6wG6daBykFCmmCHiUPRw6FDbAFA=; b=
	dv9du5mfkBDqeJbKXnLu/9zk8XtRPUUJcBINOvP4zS7cnTQu0hYo0UdxwG07jxRV
	zV1IyrBgd6ve1xbHY5Ka1zTeC93zzKHJLj00bbHum5VPp+8r2ctFfPMB13NnY5ju
	YAmOjbRjSXuLSFeJyzrg/RXTu3LW01jeD0j95LMTSxkmh3s6CuOaYKzkuL2Mv+a6
	aPck0rMo5v/8NA4Vh9cr84XlMTlS8eKamWbifQ/NKD8nsRTWmGHPhGbPpXQMo6jN
	FomzBG27tZwDLgReol7mqMFYySRt2xyKa1I2xy8npCYJtGrVwa2CZ2pfxpedPv7B
	4Q/Atk8r6sTEuz1UTrdLmg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h1w9hax1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHTSZB035463;
	Wed, 18 Dec 2024 19:17:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa8gj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gxz5hmLgDw8M/Pe2DpjM62kumdJh7MIRLu7Ii33L0yubmAGUxzE7GyP/sRcYbOqHLOwn1f2y5D1rwT5GTceIXIrBrPgvfwAavp0iRfpGxAjpNOI+xTj4uFfO5jzPC/MHIG5mIMHC37PeSofvBRXS6YYOiXCq2EU/Y4QthOgU4CcGN7Chm7Jmnj99Q8WOvcJWS4vkwPlev3CJvMUTGHXZySnZ22BYDAREA/N+x1mtdl/W2d5w4PMbCnsvEZPp94ZwstQmcs7DbegMbBh6/r97Ej5hzMF5jmV//pB/UjlNcwvBNsVzxYDM4OuUUpZfOob3ghtfAjQgK342Umx9sieiHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fxEN4VpKLKXrvHf6wG6daBykFCmmCHiUPRw6FDbAFA=;
 b=Ogvky92gXeJlArLrgORKznkayunjlo3X/9x9li3ctyA7hw4ljE6xmeWnyWmYds8dfec8395sEDp5Do/n65kt9YyrZPoNwkeCEHxD830Y1v5x4JEufBgYGVojMOT028GTPQ1S6a2qgb8yjcSUwhiHIdNe4OUhShHTeYH2Dw+Nn0iKGL2MAD9+H2KljifXNtf4KVSkZvuvxkM4HIjG6ZvEb/2oYEe717wPwe90RS5A2nTLhxqp3on9GZWlYqigizFa5rz0topTzQk1+4GX+OwWX5sOfBU3gvObbhPxL72X2RSrGOWFIRA7VVxL7ugmDQ+XgkfWDQbGcW1pFdz9Guvqpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fxEN4VpKLKXrvHf6wG6daBykFCmmCHiUPRw6FDbAFA=;
 b=nmA2y49ZyKKyUJsIxKBftZRqhxrY3pCwHkN0jG/lPT9qhOqevcSTkBg/vS7p+DFo0/w2jyLE+g5ALQddBU3rc2uG/MVsq6Syc8kLEzeIuGRtE1rNoi7kvaGOdpHp/Ux3Eqyppaoh+TPAQjQQ80mQsITDA+4yr2N/5ePrYW4Mmzk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:52 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 14/17] xfs: Fix the owner setting issue for rmap query in xfs fsmap
Date: Wed, 18 Dec 2024 11:17:22 -0800
Message-Id: <20241218191725.63098-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 53246d5b-bfa4-4a03-95e5-08dd1f98aafb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DZc3Zn3+bjqg1gLiqnIA45WAI08Xp6RSgK74DjdWo2Z5kx/3BZMQN6fe6A+c?=
 =?us-ascii?Q?cVpmFCjf+5xEnzWYkywIiycdhqeesbvNqi+O1IENX5i0j2077Gt5xnvpEsVA?=
 =?us-ascii?Q?mC9fRMD4LEtuiOvcnjlCZXdEbXz94z0g/9INEfnBGU7+pW17gKEZniINkB/i?=
 =?us-ascii?Q?49Kr2I22K6Su6JG/AR/zoB2bBhIkjtJjmtCDTR7cgLWfF/jVZJKArIPx5aes?=
 =?us-ascii?Q?XA5KvCbQUIU9EeszWkV1XgWj5ASvjSK2/EOmcklB1KUyhGX3jPNDUA9zLNb/?=
 =?us-ascii?Q?NRCxvm7ZGA8wflc5Fif5DP38KhngQ1Z7nvLxzVqsFwnN86q1cq/Ig2DNHWl3?=
 =?us-ascii?Q?sCL6HbX+8azbFgoHF1ntPxzS69h7DBugILrOhEts23pRZ8tU3mXqz5k5XkIc?=
 =?us-ascii?Q?RMVRu3TN9o8O8H1ZwtN44ZCJCkOg6F46nObVxTrcu2ep3ClhkFl0xpW9Yuis?=
 =?us-ascii?Q?W5c2zribc4HpbOjIVMZigHcs8MUWLndmyjmK/Ow/E53h+zYWAfS+USA/qeRj?=
 =?us-ascii?Q?YexThmHetTyw4izsjVJHaU517HLYdre1mRM211QLJupkpSUg7vdXidehfjue?=
 =?us-ascii?Q?WDFsq/fVq6Zqcom7vcFbPzYM7/tK9FfJz5Si9zbEIuatr7nC0gD2kXq2PGeZ?=
 =?us-ascii?Q?92gkBxV3rZiWrH5rK1JHDmKwXYZlFMcqySBKPt+pzBTBKVPOwocOyZ3vhjes?=
 =?us-ascii?Q?ZxT4ybh1NakJohuROKZTlaAWDTJbFKDTEvHBAogP6/1MUi+ipE206Wo7gSf4?=
 =?us-ascii?Q?zPCsfw2rCKAjICnCuVF+gT59CaEwWjb0hJgkm02LAZlmuL+wxetcSCCZ27Nu?=
 =?us-ascii?Q?NmZJuuFKnrR1zmYsxc7UNwYYRONsncrk6fqLakU+T8676/fn7XaYMNk6baAg?=
 =?us-ascii?Q?KVVwcmua+FTGyPkgBOFeTFZbbYm6i4tc9/OTvxs5prp1X09uPshaA+oPZ4yh?=
 =?us-ascii?Q?38USnXQOYcSXRrAuSR56kLlOjMqC6wRB58dRZFSyhCIztoQidPyqVzEW0vL+?=
 =?us-ascii?Q?HhyY8hnnMNYfqHFUOBBux8pWTfiGEqpGY1b+oLA+5ykctNm66sRJzLA050wa?=
 =?us-ascii?Q?cZBpkaK5VyaHNFHfhvA0DsURqgz0TrzphESJ0RHH/V9yKOgaZm14gKUPynb8?=
 =?us-ascii?Q?yp2dFFAMyfouUkclA7lUVRixyvLqlB9iW13BuyJbU4belXnB2dFAJ+KtKdj6?=
 =?us-ascii?Q?fcvrqDG01KyEIVmCPUoPV7PsQvr3EOVySiSi8gQIIyOhma8jKyAv1Ifzysnr?=
 =?us-ascii?Q?RoDpFrZ8HtICoa9qDkCuxxOMkZbNACJ0j66+ZcR2+0Y5mqJQorc+wNn0IFCp?=
 =?us-ascii?Q?o6p0hJiRNa5IAZVZDU9QB/3BQzK3ksm4/VExK3hS/h3hKa66xJRrNJ/G7HCN?=
 =?us-ascii?Q?LHPDd7fFk3Tib3vBEOs6+mwYqk8j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1DQX4piT4rjcjI42OJ1/GJXzRhD+pUrH2Bdle09PDi/KCUk5mWPkNs61xq7+?=
 =?us-ascii?Q?7IKbNisja+qNq2JUuOkuCT1/morNjFI2lvBVS3HvxzPwP2pvQubzLiE98SWJ?=
 =?us-ascii?Q?edFRSdcKGHy8gHUjzLffctu4GxNTP6A/EGfieV2pIeEGnCVwVZzx4WDKPsTJ?=
 =?us-ascii?Q?t+qQGGUodoFoQgHq5eQW1DeB9xbSOgoTsQVGlp8Xpxmmf05IdjMUCBEcO4Zv?=
 =?us-ascii?Q?Zngyxerc4Lh4HdLXyUIIhL1VLDXCQoJVtsx79bUFPT0Z4FRDESLsax7wctIk?=
 =?us-ascii?Q?mlgkzf2KF47UObnhFVO9QumO1c3LYacX9t4HXpKpvaLAxI7tQTeehmNAUxfK?=
 =?us-ascii?Q?3zK7nvuK1sg8UNuEBGCUHyhdSY0c0bRBuj8ygVG5oJ/fNlsmnEb0Qm1+F1jO?=
 =?us-ascii?Q?jQ5FEpzSaTH5c8lKWXEOdyMjS1xfec8+d7oGa0Yffj89xdjHf/OD31VvlLRr?=
 =?us-ascii?Q?MX585bVC/Cum04/RZKj7jlZUIGrtDZ5KHyW4I9xP/q8VsJRA4WgKBxFQbE+p?=
 =?us-ascii?Q?glBYsJPRhBTaz1pFIQKeB7b/s27opZPYRhfLwJW9n0RBixfqLaZ/+BgqwT/p?=
 =?us-ascii?Q?qQX28rs9Ma9aIwraxYg+qmyQFLm7t1fqNMPWLCE1Lia2XILDDAnDpDPzKGRj?=
 =?us-ascii?Q?tX1ygG3lw3ri7zRhUWSLdf6cuS9nBbJffN04Ay+BiQrrHkD7+euzLk0dbI2x?=
 =?us-ascii?Q?PXSGOFeAsFV9nvLm4P/HJNUO5qRePeR66h3XM1V1XYoEzgXHDPb/2jDEda/4?=
 =?us-ascii?Q?S1raKDRP3s9mOsQK/Ife5odjwf4/8koSUBJx0ppmuWASrlPp3aeBQl+n2pTR?=
 =?us-ascii?Q?J1hijSTCUISDHMwMLJd+Wu6soBfPs8Sf4eQ+rlQ5m/kky4Rb33Ph42MPAhUv?=
 =?us-ascii?Q?pwH2YrBhwpUBcQv6dpX4nCt/DWN2z0sb9ujVcrmGtqwUmsBl8suVgqi0Ru6I?=
 =?us-ascii?Q?7cEyrsNPrJMG4ByVc9WsUTnK+xIdkPUnbw5scYU2ZUbHNOH6uhHbqxRvTyxN?=
 =?us-ascii?Q?VSVa0vPAxLo7uy6JA069XVyrSuGDvfXXJNco57LtBgmeq7XeCQkBRzLU0yyw?=
 =?us-ascii?Q?Ii5h5tQxlXtrVI+EsmAA5xD5et3HZQs5t+R0xZxLlnCNtWumZw+4abRLlPRY?=
 =?us-ascii?Q?8fgBoSb7R0SUvzBVTakcTUVe9vNhSJc9wvDqKMIYLJVgEXJ4UqhmJQiD+Jgt?=
 =?us-ascii?Q?2+bUc72yvOzR9S4hHQs9Ogu5v8D3R07nB1h+dn3W6yLeWr/hB0Qpu522gIRP?=
 =?us-ascii?Q?A9rJm8d31K6wQZUvqymmz0Kt2Ft5T6n2HTvvwXx1puYQ9cu5g0geYsUrK1cw?=
 =?us-ascii?Q?AWJ3eNc+c+OaNMNC42GUc7oSfe64RcA/cYXe6mRhhQ4JTlf7Fni3EG7R2T4L?=
 =?us-ascii?Q?vZSYS9fRU4dsT+QIXOHYsJow9a6enwYR671U5hCl2D93931f4aqIZm+MXRJh?=
 =?us-ascii?Q?hVfFi1hH4SDPrLU514Xo25TfheZu2BSduA8M6BJu73bxNfttBLXxM1CvfYA2?=
 =?us-ascii?Q?lt8MdB3pbQY0DCqsAMlaCPPf1QqNQ1jfD2j7tjLIMgWOEIUItmVkqWBV/EyK?=
 =?us-ascii?Q?QnNbDYhf7sFoBhpgfRq2Igq0HwvR+aBasEaLQWgbBXI87AVx/Y4Uh/t/792f?=
 =?us-ascii?Q?PtMBThj2Zgu2DTgglGtN62zH33xCYLCPYUHiiyc7xsCPZKUNtxM7WXYYtcGC?=
 =?us-ascii?Q?8XBmxw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n+Qiii/MouKVYjnUc8+zUnp0diJxS9hGR9XuGEfuUZ52n6zVE/ThjOvvI4x0NA28isvwo7qEOK6HY7wV47zgfJRrdgLipn2JNFtg/4hMSEyZG0fJYXvyrfRBc+Fmpp9sVt1dcUtCSuR+SsJiJWCFFSBFwTCAQEPbzFd24G2ueii636C/CXw3+7ywwdNE7naXam75TB+ux4gQqVC58d2PbhLpTTHad3pe9Bzp7Tu2gKf+nlRkBVKienSTOQjbYW9MKGYlbBAlKL/0N62a9icF983GGHSuI7rCy0Nc6S0Sunrg3XXL+iJiEO5KAUT7+Pqi6RHBl95Kge94Mq+KNnK6ByhVsJvtGcKw7js6JobeAjgTezql2SjF3M6wNqE3nJoigPPx/lM/GmRHJBGwvZEOj03rBvYReSrs59X6+h27x5+oDbeN/kfT/PTiOcWVkvpoLoRAd6N84LMLxbD/AmzN/2rQq+ae4zu3EUKE6lx3fVVCUY3cSvQlkd7ep7XyhVOVX2uRtPKq3iswZIoiKOmZnvVKeU3RwS8a+x+efZTavC+T8frdqtfhxc76TRFulUeIIiXR/zmVjfuZBNYozXd58FTdeHbwLDkHO0bjxOwDS8I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53246d5b-bfa4-4a03-95e5-08dd1f98aafb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:52.2135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GH5BDAOMY4xkWIYhXqmbbUHEoqrKXwmMz7lY/AUP+TGOTXB9CeIPZa4KSsImw5/O6CyigdJUEQ/RVOMcLVSeHBy9NhccCyXYJ4TaLKz6Cl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: pHWJXNbYLqXrtivjdRKXTQdSe-gYJUGV
X-Proofpoint-ORIG-GUID: pHWJXNbYLqXrtivjdRKXTQdSe-gYJUGV

From: Zizhi Wo <wozizhi@huawei.com>

commit 68415b349f3f16904f006275757f4fcb34b8ee43 upstream.

I notice a rmap query bug in xfs_io fsmap:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
 EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
   0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
   1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
   2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
   3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
   4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
   5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
   6: 253:16 [104..127]:           free space                          0  (104..127)               24
   ......

Bug:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
[root@fedora ~]#
Normally, we should be able to get one record, but we got nothing.

The root cause of this problem lies in the incorrect setting of rm_owner in
the rmap query. In the case of the initial query where the owner is not
set, __xfs_getfsmap_datadev() first sets info->high.rm_owner to ULLONG_MAX.
This is done to prevent any omissions when comparing rmap items. However,
if the current ag is detected to be the last one, the function sets info's
high_irec based on the provided key. If high->rm_owner is not specified, it
should continue to be set to ULLONG_MAX; otherwise, there will be issues
with interval omissions. For example, consider "start" and "end" within the
same block. If high->rm_owner == 0, it will be smaller than the founded
record in rmapbt, resulting in a query with no records. The main call stack
is as follows:

xfs_ioc_getfsmap
  xfs_getfsmap
    xfs_getfsmap_datadev_rmapbt
      __xfs_getfsmap_datadev
        info->high.rm_owner = ULLONG_MAX
        if (pag->pag_agno == end_ag)
	  xfs_fsmap_owner_to_rmap
	    // set info->high.rm_owner = 0 because fmr_owner == -1ULL
	    dest->rm_owner = 0
	// get nothing
	xfs_getfsmap_datadev_rmapbt_query

The problem can be resolved by simply modify the xfs_fsmap_owner_to_rmap
function internal logic to achieve.

After applying this patch, the above problem have been solved:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:16 [0..7]:          static fs metadata                  0  (0..7)               8

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 8982c5d6cbd0..85953dbd4283 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -71,7 +71,7 @@ xfs_fsmap_owner_to_rmap(
 	switch (src->fmr_owner) {
 	case 0:			/* "lowest owner id possible" */
 	case -1ULL:		/* "highest owner id possible" */
-		dest->rm_owner = 0;
+		dest->rm_owner = src->fmr_owner;
 		break;
 	case XFS_FMR_OWN_FREE:
 		dest->rm_owner = XFS_RMAP_OWN_NULL;
-- 
2.39.3

