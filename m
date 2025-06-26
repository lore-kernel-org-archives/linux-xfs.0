Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBB313B58D;
	Thu, 26 Jun 2025 00:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750897674; cv=fail; b=DWghYmQ868FwiD7F0d+AgSIuw9SwdxTURqwK4dLHYJvpZir5DfmUgDsW9ID05bn8gI5+3bQJxwCYU1//G1zoNFb6RtKcr5XQtsh2FRSlHzxJzppGCb4Mkf6AEdhpqgZRnWOaF/XwpVU4yFxizD7Ihmos4uxhcDzoknKsMkzq7po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750897674; c=relaxed/simple;
	bh=bo6ehsgL+7DOlAa39MUMb8M4fSO21wtclfZ5Dq08Sq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hM6W5it+p+JcUS7L8jNDwcnv7uPVaMWIYho78k2Rf15CIdFYFB3R6EjndsfkCVfLFj4IURDgFD+Q5kjobSuPLA/MuAquPCyydU701aFgc0CH9xeO1s2y7Fn02JeEqlnlLbv0dI7Pr/C4zfei2rjbI59XRRlaKGIipSs4D3OpS0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O1zA3n/9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yvLGY88S; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O1zA3n/9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yvLGY88S"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PLBaW0021545;
	Thu, 26 Jun 2025 00:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aN/UVyAXUDWf5NWbGPyX1ZofE0i5X2yPYzuPIrraFHE=; b=
	O1zA3n/9/0GVsnli1t7hKUhairB/tSyUYnZa5hCaB1ARhPTlpwp8GQ6SLltuUwjI
	5f5G5icEV3MmbzaNThdSLLWbdoY2rzYuK7JToA6w7SQFHYgSsUBMaKP4pBAvMgDp
	V7PKg2ShsUkdIXrwurLlCXBwDmiuGxH3oyyRDKVUAZDmdfLn1S4jDEPHOoeHQ1IC
	CUqHK/EK3dfpFHFnYWJRRkYCLDqurOQlTaPpAGWRRHytmu/4koPDEN9m7HI8R70b
	txpeZ9OLSs22e8ahQNoomIYGTuKvDg9PBJC7ng86S1B6dXIZGFF0BmmOUtTztZYN
	yMdNP2zBS8aR5wDuwPMc+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt7fk75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55PNasCr034501;
	Thu, 26 Jun 2025 00:27:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehps9xjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CV1uwyIQrWHLXq4fzApwG1hlBXvkXay8zh8PcGhUfvZ55qhmG4+PDNhvojOnQVeJOcnbkYvSKyIRsM079Ih7B0TRi3+Z90c3DVek2QW/ActPqOaaL5f3y1exm9hGrwxemMV/EzCL5k7RfA+LL0XecgoQ7sQv5qrs672F11D8tZ8F+BxCshPzSYpNgcU1Vjtx95/d1DSiiBflB1aW3XmLqJGMHZwKfzX8uP3/1LYC22amCeiNBUqyJQVLtKmYo0aQexHxqIl6OLl0pRQJZFU2ilQ/THCRKy4Pxwc3mANIg+iInAcptc8M/t7SgbbNICoHj8IlNlw3w5+iQ/g3wJZ1yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN/UVyAXUDWf5NWbGPyX1ZofE0i5X2yPYzuPIrraFHE=;
 b=sB4EIzY/kvjXoPud5+mPwj4fd6D5s0QHR/OoERu2c664prnnXSSU9eZyxUVtulqLsLEDpM8JpPiJtFvg5nz2ygS8yFdxMV2BApOFqDVRieRCbD+/HQHnqQxfOI9dQwNqMIV79qobdflo4SDDvbaJpg29Q2WD60Uz8YkJ8GysQOUf51ecAkhsaIopyv3RuOnoxsxyxua/oNOCfPeYYwF0Kl20i4yCogjinMlqk9NBvf23YAZzYkDb8/MXyn/+MHMgxxe8XWaCyYipychuPwLLuyUlC2HcvyvJOWEn4fTSgWwAHdB9B6s92qn3h3PcRvw642kensbvA1KF/IPZG9EK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN/UVyAXUDWf5NWbGPyX1ZofE0i5X2yPYzuPIrraFHE=;
 b=yvLGY88Sl9cqrmLSP2O+qLOESf049b2Akq4M5aiXJO9t68hLBBs6rzkRdzjnStRbL5GVCt6UOweQxd6DMzLk9tj7lM3LOnsbd/TAALVaNtO1wuuAxbd8hp0DW4Z0RlLfasFRxPEg4MiI2jinZeuB55jbnh8u0LCiTTWplLcXfBc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 26 Jun
 2025 00:27:39 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 00:27:39 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, zlang@redhat.com
Subject: [PATCH v6 1/3] common/atomicwrites: add helper for multi block atomic writes
Date: Wed, 25 Jun 2025 17:27:33 -0700
Message-Id: <20250626002735.22827-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250626002735.22827-1-catherine.hoang@oracle.com>
References: <20250626002735.22827-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::43) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dd296fc-49da-48b5-14a8-08ddb44841cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RxuCBPZ4rcjTHy0QXwtyLuay0M2ldSvn5d/U2zvwo8Ey1EsmwvyBgLqwbmsg?=
 =?us-ascii?Q?B/enXANU5NInlrYIvyrJEv42oZI0uULvveQcnvFnd6UIELFXJuaXNNvW0z3t?=
 =?us-ascii?Q?BBjDdSe8xVHscREsQJBjiR+9A7AHkXrmKIx3r9KEtMAXukSZEg+DCpl33L7Q?=
 =?us-ascii?Q?iWzV4Egw4cuneBRrjXJ1mk7ZOthQ69k2VKU3nMyDk8nPldP8k65n7LAtBhBC?=
 =?us-ascii?Q?72SPcAK4DKLQIvjCyTKJTPPRjqhrF1Bih8RsddNgdB5le/+GeKtdjizXT1Wx?=
 =?us-ascii?Q?7kVOGblODdiJcc0ggO6uGpw06XGBNxZmQZqCO+/GByH4GS4LvFANTyF9+XZc?=
 =?us-ascii?Q?XJIp2KTpOesw2FdnF/mdwCrYefZgoYtgrb9eaNz2Fz9e2QC8zMytTRpH8Hf6?=
 =?us-ascii?Q?sgWF+q/C2SAccEXZsMzUcCwREDWdjQwBjdCdUbhsLgLYLobjnRwbOLXxGdbo?=
 =?us-ascii?Q?PX5vgjz70P/QNwkGiH0qHjvFoOxqnhxOclrmfoRYSWL8W9H+xr3zB3pUcyBu?=
 =?us-ascii?Q?Z2EkPQgsajJDBZ/iRCG71+S8lkjSWLxgqVG3VM04t2Hrc7j7xFZFBwleOQ1A?=
 =?us-ascii?Q?VWM4Ky3j2Dl00GwH6ztCkIXWMRYb+Z6Puu6pb/C+P87XebM7BRBPCu82lq+q?=
 =?us-ascii?Q?9T15nQCs2EqbDAjFBzS8BJ4y5pCIEnUxfmFLyQpHozclUYDm6CMyqvmuLr83?=
 =?us-ascii?Q?LCqt2x1YsAYvvvFLAMQZi8ABMDJkLg+odA+CG9h4PqjSp3QMyY89qeg7WN/g?=
 =?us-ascii?Q?Q3SKUo6dFsSbNuMSA4dNwAsP6YhY71/aBRqqRhFFxugH1Xk37fhk+mxfUYB8?=
 =?us-ascii?Q?wiBt4SQIboQ/O56pi6wyJZZhuQqtbYxU9VWbLTIZSAbQORUG4+sSbUmiLy7k?=
 =?us-ascii?Q?6dfnn8pH3etDTm/3rocE1OhO+pbuxCOKbR+M+sJJZw5hq5cDC6l6GN7Gzk4g?=
 =?us-ascii?Q?K1gI9DRa+xW/rP5B9QPabJH+TpJrgf2O0h3GNWGMygKWzXEQ9Ux6aQvaxRyD?=
 =?us-ascii?Q?29IAy34KMMVdceTF1TMW90H7Sn/ZeqV4qiOi8Qj5CLO1aok4SzsmDg48EAPY?=
 =?us-ascii?Q?ByRGe9UHe/k876tn+QfPqL+yex2CBpZEqQIKmESITdE9addxn2WHnAUqqoPQ?=
 =?us-ascii?Q?cCW4vwUPJ69uxScGe9JbCN0eWTFm8E8y2+MxWxdt6K8PocqtECNzSoONlgEk?=
 =?us-ascii?Q?q2gLRguCtB7yrQCEUby+uLZlSSISdBkAAlO4DJskvjOlJl3eoMZROuMBJ4Rv?=
 =?us-ascii?Q?BiBsQLDEgu6WgiD/Qa0jX8CC+PIVLh+cU9X26q8xKBOHcXWq6MekJ9L7h2mB?=
 =?us-ascii?Q?L9Uu7TZv64m2RpKVV37CdmUUV8pQmAbPyGuND+k2CrBBld7dkqJaguemHSku?=
 =?us-ascii?Q?yH+RogsYEoKPU34kON3wNA1R+Eazy86ozh1klwqJ93mci9LKulCRtLN88kmG?=
 =?us-ascii?Q?IJnGI2WfeO4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q+nxryNoiMGLNRlHQmddWFMYXGoC5Uzu/6j9P3G6EJBDEuvhUQ/eu10pP5Nf?=
 =?us-ascii?Q?bQmUlthICw5vmSFkr+2PuP8c/dQyO3OafS8fTKmCKgE4YO35WfkOGlyRLZ1V?=
 =?us-ascii?Q?q+ZLmKYl6Vv2cQJOubrfvNuVrtl+1TDfJ/K4b/p6GgXkyF5okaBNWfQ6MY10?=
 =?us-ascii?Q?bhhflk1RCrbV+0auj2f6p62dmFsEoxjElYhz+vBoV0LyjMlShQT8hK+V/2Xh?=
 =?us-ascii?Q?mkH5/t4tY2Z3QALnisANaFGZ9dgUOuFmVZO7QawfM+zSxY1rfGg0K9QAs0LL?=
 =?us-ascii?Q?UXlfTkhA18XpG/BcsDQz6Kh4DGcOU8DhWSwfHB4c2BRCaWrCiTKAQOAlMmNA?=
 =?us-ascii?Q?CifLrL0W/6e3cXj0U7sQdTEtAZVZjFmu6MT3lLZWr393txp6ZTkHbNm3pU5x?=
 =?us-ascii?Q?AKjoW6nTSOp3v1B3kzrXsyc7YVjdCuCiXhtiGqlMoi6HjgvABDK3LAprifNE?=
 =?us-ascii?Q?WF4ZAF1hPf/63f8yeakjxkCcwBywfpav2mw5aqbR0UNh1yEKYMROh+LGRHL/?=
 =?us-ascii?Q?7QFdLtXlNHmaBeyu3BY+IqpigSsTEgVGNdDTFd+2zdC4abs7Pmz8L6DuE8ki?=
 =?us-ascii?Q?4I93eii1W5FkWj54PsYYiw71pZ8Ot3RFzM55ohVvReQi0nKQJSUEb91AzwTj?=
 =?us-ascii?Q?LDRcqlOMZl50zWTyQGnc6WFKGcbHze+6w9AFYn55YbnfOsuoyQMmuvMP0LQX?=
 =?us-ascii?Q?cvw6uIYySluYYpLmRH5RLw+sZBaWezSkksIIMOfD1ix3NV4BJ58jh6YSkP8A?=
 =?us-ascii?Q?0oMd/AGXeCtJgVsfUxjxvuj4KQdDeYROIwnvGZDa75eg9cSZ5pR4rP1AgN0a?=
 =?us-ascii?Q?v4caiUo0MowSmeJi89DCmWmyJ9p9hTDvvS2h8wEp1MLCrbckh42hoUijEdDT?=
 =?us-ascii?Q?vzLVh77eC5giGqywwDv0Jbrq/v1OZjso4hUQ9U2bog0BAtdhGQhkUfq116Q/?=
 =?us-ascii?Q?RGYCCJxBD3SaJ8uWOPGYGEqEROs/kZEHdKVZau/Mhv0urShJErHTJmy3JU2r?=
 =?us-ascii?Q?oOhPIBB+JVvCJfuaavPqQb9vvJzrHGcYwqiU4raDlMz6kgFnoKas5bTRJayj?=
 =?us-ascii?Q?mPwesHugfj1AZsTmf2Ozew98h9SByXEbTaip6rM8V6IjO8PflNonPnAc4kzi?=
 =?us-ascii?Q?TLPEGEp815jHfunqbEWg1Om+HoNd0FWuUaDiLYuz4HKqQrWp9TCrapQrgprQ?=
 =?us-ascii?Q?77hLjj6k+Reybj+/Eu8bHbDDxGD4F5PzCRtPxxnH+D0tB+rm4x+U4LzJi/AQ?=
 =?us-ascii?Q?a4FKPMZFZ1H1fgUShoQEiKHtMaE72c9BEEL332cYvIl3INbZOGAtu94GO1eU?=
 =?us-ascii?Q?oD+GI8j3Ts3z1NA1ee9HQXvm9/+GeeTi47UmCqo5iDHGwsTXNIyO7YoN2nAF?=
 =?us-ascii?Q?PoqUdx55rhkcA50q1foI/vBpu54c6haf6Sw5/3Zz/4lWN6JrKbwQOSOpzE2t?=
 =?us-ascii?Q?rDPLyfVnDvT1qDbu0Ymv7G1+wIC+nmVywctEs9Uj4FKpUWHPNVKybYgCEULQ?=
 =?us-ascii?Q?n20vGVC9E6jCSKQCbdNMFOuaOh4cNHrOJz+SeYoJ8U7V5XZxzqk2nbdpwPrp?=
 =?us-ascii?Q?aQv/tyTEgPG5+ztoZj2bYFOqE6u+wBq1k0wjHiJFE77Em7F7lg1PaQI5orzu?=
 =?us-ascii?Q?rWDUUQ+Lle3BYTvekz54to9elew6/FU+ETPS88+H2lykDqxHdK4cAGFsCh9w?=
 =?us-ascii?Q?qjhfVA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fs5vWb9pm+qR5TMsX7Ll0H5k2qaowGFzFGobqYbBLVRUMupGyXnH3+n4e9LKHJG8+qA7gD+xUuWjiTGkdCr0e+cEMUb9nMytbgtQN8YvgIEgXC/jCLufT6Ybb9b/+DUTtoTHgMXw+Goyl758ez9zWszHakys739HYFON0rDT0p1OKgBlBwKFeYq6Z6zlJbApFVxz5nPdme6WcHyXMRyv3KS78SnnvHh8p1dICPv1a72K8GEDFRRX3e3keflQO79O7Mx/2MW6sVOZOzCUYfoHJJYbDTFSS5+0jd/rem/kZbjOIzYeRHIS5VG4Vecd7GpPhDMitBHIUukr7B18DU/jYqQ5cdfnw+9yPtvzjYX/m+IdS4SjKWJTWgjdDSvQU3RCGLH2C+6+MSZ990cLj04gDNYOrJyk/0ATebRtD4ehxF7pGVjyTsg8Yre6sX2B1m7jl14TipqXPlBpmB+8u7eISQq8ldRXGs9i7q4sswYxCMGbHhgS47tUEr1WvmJKRzbN260pnaOeEykNERkptDfaAIXsL+easa+TuWDPqFPrERgbyaKA+ubvLsYkiNeRdnwtPWMxy1pg6yVrj/FVhrXXHw/fdwB3vf9Klc7tUHKMvZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd296fc-49da-48b5-14a8-08ddb44841cb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 00:27:39.3737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/ieMG700ArIen9VApqxIEPgPyE1VYCkmrlplJuKELcxdLUGV4R97aWsTeunCsi+BoBmxGRp3fNSKv427TTCZDqLV/1AcA5eh6ugY/+VJnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_08,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506260001
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDAwMiBTYWx0ZWRfX2IQiDuci8M+H W+PhEShaX1JU6rP4en+fc0KwOuUGez8iRByJekDeOS0tDl4m6YUMiAR9Qrwlzz0lkigc7AwnmNe 7igvMKVh2yi9sCpHCODA1JBcngxXWOSddHPWmAEOT5+Xm+uynQSRwyMizuJiOvsBMGKWVKXsNN2
 g2ktTwPh+inFetMvhJskN7opRiPKQCxK6pwnVNdqVochw6snJQKKao5BllkYXUSvBFgdQ5ZggWc 9xrvSWfYiF/KKG649Fs8v1Gm4ZgiJsu2y1sR7uwGC5un9BJUvBd74vCdDX1IIBdS7+mVe67herK rPErAblwmVEy0iHf77QhaiJNYTrPY9xf0DwkcntKu7ZW+vDMl3CQSfFoi8i21vq9ZiJwAkRIrC9
 upCQNMEceQlH5Rbsy6bJmpZGaOpPvA64bVGqrj2pGwWiNo644sLBW8uAdQf0fes8OqKjLqAW
X-Proofpoint-GUID: VdB3zFwJuPdyRyf1s1M678gLNSx_5hbl
X-Authority-Analysis: v=2.4 cv=QNpoRhLL c=1 sm=1 tr=0 ts=685c93ff cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=mx6Z5l6ODcrpD94SwjoA:9
X-Proofpoint-ORIG-GUID: VdB3zFwJuPdyRyf1s1M678gLNSx_5hbl

Add a helper to check that we can perform multi block atomic writes. We will
use this in the following patches that add testing for large atomic writes.
This helper will prevent these tests from running on kernels that only support
single block atomic writes.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 common/atomicwrites | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/common/atomicwrites b/common/atomicwrites
index 391bb6f6..ac4facc3 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -24,6 +24,27 @@ _get_atomic_write_segments_max()
         grep -w atomic_write_segments_max | grep -o '[0-9]\+'
 }
 
+_require_scratch_write_atomic_multi_fsblock()
+{
+	_require_scratch
+
+	_scratch_mkfs > /dev/null 2>&1 || \
+		_notrun "cannot format scratch device for atomic write checks"
+	_try_scratch_mount || \
+		_notrun "cannot mount scratch device for atomic write checks"
+
+	local testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	local bsize=$(_get_file_block_size $SCRATCH_MNT)
+	local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	test $awu_max_fs -ge $((bsize * 2)) || \
+		_notrun "multi-block atomic writes not supported by this filesystem"
+}
+
 _require_scratch_write_atomic()
 {
 	_require_scratch
-- 
2.34.1

