Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5E121325F;
	Wed,  5 Feb 2025 03:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724918; cv=fail; b=fow9QEGmwzL9qIkKYHtilzvwPIrsvhStXfa7uG6090/dEZtHoPjrXyP10X0G3TRS781EfuxJXwnKLSTXel9AhjUy2K6Z34/SdYmAFgmYJkqLtu2K4wKhWjTLe1ScQSQm7Q3minJD/7HE+EhQSJN4F42ZAMvK4qRn/Pz6pIwxok4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724918; c=relaxed/simple;
	bh=JCK7cqLPsmpN+q8urATOP3ILlbqMBDcfefGlKFa8RCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lYI78CW3rXMtORHfa4X9mr+1vDncOKPQXLx5MyIXaXFdsp8DA8PVje90s/8FIiltLGyTD/ZVPn3hv+o+dELDnbaCxJIM/NF/KlYzGuy40DMKaxuu7sPXpW09nvItARkVCnEZzAdiJMoo+/2NpjN/SVfLA6k0F5hmY+qiAMF29Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RSbli2hl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IWhGsjTc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RSbli2hl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IWhGsjTc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBrk3003156;
	Wed, 5 Feb 2025 03:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=m5YyYJsZftiOAmgupCfmlOuseoNjRe/sAXXIAccL4LA=; b=
	RSbli2hl7pSXrqzd5gbeKAwi/kqmfFN8WAV93RAC1UDoQS/cUGj9c5dCuRfk1BEq
	0TboKS+OwUWbmJQHXChLv5DQD9vfyq2cLO3BFkSQX+seVJD1kIGXJEkxGK1eiyMP
	uf+XvcPFlN7ALaNqpWAa1D8AkzfF8KZNeSXwOLW6sqdDwcLstZOpzaXApWK22CC9
	NrTcGsD0drAiKySXuAvuGmm5Sv0forGMSjNF+uN5JwAqn+HkjQZc/LVFrND9Er1p
	2OyQB76RmnLyr8eHE3WsbpdCWLtRBIWAiRLrRBthEKkaXrOqC97oSeZkWq0s/jxn
	pmk1q2YSSrWlG5ITOv6nQQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhsv6a9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5151pVhp004939;
	Wed, 5 Feb 2025 03:08:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fpup56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AwcWCbrQhaPev0bZ66D4HlmqKcIh2c0tWX6hKuNiubCB963qxwGMY0EOEVb6RRdC9y3vps54Xy9zgEkzLz+SFRS62AvLick4zL7szagGKR12n9BOWOCzQGNVrIGJu0qUZWxc3ju7XnP54/Km5eeW7o0hbTIkbAi7vtWC/JER7t6vSD1DdA9NwNexcHRPJtwIZ1jrqc6TZyaAc74jhQqz+T7DqoVCV+I4kgctTEvJUbrEqZFjusgwKKCDoXF4ljGfPGQ2tpRS7X3BrFMz4DXwDqNodmq8SDq6y3Olbi01ExzyS2LUM4aQEoqC0YycQsvTF/XHFDZuTkNQHcIjVfLQXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5YyYJsZftiOAmgupCfmlOuseoNjRe/sAXXIAccL4LA=;
 b=kR2xuleNDR1yJBxfN/Rs/GXVAMamsHYyeURwU3K+SLxzR6W0tKQgMQdijIwnu7tL2vQ8zVj3ZPxvwR/a+rbiMcOR8uwNl5HGHxcCbWp4fnp7+8vJiUX8oX3uvq2tBm7tyP7geXIxOmn5v8K4RR9XKdRrUzZ4SMrXre/nXTk48/7Igv+KlRktvg5aHHjLxWJfNaPpYUBcoel5jojsyCcDrdi1CjOciT/7+LpLQrgh0K8KGLO6PQivDmf2rVg2gHNMWQOs68EJs0GY3lIwNVWjn9KbsUQqyo2jwtsiWhccp3UJGmEMPFsO9pg0Kvqac9g9oK46JUdunVmzpRaVlWpVTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5YyYJsZftiOAmgupCfmlOuseoNjRe/sAXXIAccL4LA=;
 b=IWhGsjTc3zpsYglRU4s2fH3mQAnha3iDL3GMPPa8eDQxsLAgvBL2gU7lG3zNBEsJGC/diEzKyrfvL+ldxM5jT9qu2Rvh1D/iEETqpwwi8+Khk3WDzX10kCeleh+Nos1KiuH4ueeKBQyqhziIQ/PXhvrchpCHB+MwKLjKOcYy7yc=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:32 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:32 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 21/24] xfs: update the pag for the last AG at recovery time
Date: Tue,  4 Feb 2025 19:07:29 -0800
Message-Id: <20250205030732.29546-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::16) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 26e2c0c4-6895-46cf-8e75-08dd45925f8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5pyCMqDwG3L1ap3Iwg+ByNiYN54xHEAu1D4M2Dts9wjUv6QhTBgFZHUybzH7?=
 =?us-ascii?Q?Kzgy1JYDVpAw03HYkjKNy736gTn84YrDuGmOd1R5GwBBRwtBsJdO0XghHxuf?=
 =?us-ascii?Q?3dIgtFKP956psmoKD5nH6cOUNYyj6YJP+ikVJyBxQ1qmb4rUveBJEJweD+pR?=
 =?us-ascii?Q?HYGfgBDnpQRG0le+v8ECPgrptLrEJr0Swn9YyOLPsn7coKaYj/vdrxJWlw8V?=
 =?us-ascii?Q?JMPPkG8jK0lLiOsu2zqRJvTq+sBcVHyRLmefAWhJTYWTjRbo+NgznJcljO5t?=
 =?us-ascii?Q?wHu6zVN7+Boj2nhNbtT9Ud+0YUAnZvpX+zVOVkIqWeLgjWXCyGJzdGOKRZpE?=
 =?us-ascii?Q?pQeIxMQ66ErHQALbeYjrFxXrX278Mj5C8P5dnUsxRwbMo5GMZxAvKAoy22pp?=
 =?us-ascii?Q?qhlma/PeNvHVG8oOl1I8pULU4DD0IlLhJwDO3rSMc82LE87xb1yFhitKMbSo?=
 =?us-ascii?Q?UPzsRiF1eb0t2pVzJ5HbA0JfwEQtM0l+36U5p9hy+QpyyAu1+Z597js5YXzb?=
 =?us-ascii?Q?aOcCCxtpMIhZnswf0qjOVadLTV+Fm9jY0hLgjbVnW0LsKkB+wk/LgqbUwZqq?=
 =?us-ascii?Q?1u/TWIyEHgKZFsRGZEyzkTp4GIKBYTbBGyxx7rx1jkb/tV6RfWKLKQoA/7lk?=
 =?us-ascii?Q?nYGSRcWv0ah9WA/4PCVwkLI/61b9A0vZ21hBId5t/NwvSJBo1VLvklE0JCDZ?=
 =?us-ascii?Q?kHmoSOnww8s9xViZaso8U5eS2zhIsTZQd1mCzmdYahFE0RprznNmwiW5uoN1?=
 =?us-ascii?Q?XuimGb6cwdlORkYMVoArYmIPeNx11a+EIM5qZRMGewctbZoD08plCjR6X0g0?=
 =?us-ascii?Q?uBKQIuSdoKUI3Hr2ZRDRxh7eCniWMoxeDqwDaZAszDWxtWSdM6P9OJjEkp5c?=
 =?us-ascii?Q?b4T1FWYsiKAmMNXMBJKKuPJueNcIybnD7YqkYb+ncuLMmrEVuZiPW1NXkk6C?=
 =?us-ascii?Q?SMtV0IAC8BKJLmVHxmOgISlznA6cGuwZAIRSfari1hpq1uuRhHGkpl4bTfnM?=
 =?us-ascii?Q?EtCvkNj4LEvHRF3X5kNuoKmAlQSH9ojlPC5i4bJd+h6OJxZJ5SAdpK8y7olC?=
 =?us-ascii?Q?jmXfvwigw+S+qW4PlR98NLuIflyO3IM8LWvJj05WB3RFOqji69eCdRUPDA6X?=
 =?us-ascii?Q?1bnrATLiIEozdP5297ws9K8dyiZlvBK7D4Oy080XLd7sBn0AHCM6c0x4zzw6?=
 =?us-ascii?Q?EjvMn7+22gzl6n8Zayq8JBwTUBIKm7xs3yc0rIOuBCgpND5WjrU0AiEMUHIP?=
 =?us-ascii?Q?xCpzzm5f3qAQNeIkvcMPak2XN1f///lsXfsWh9wPyzqf3x/58CDbSLxaBzze?=
 =?us-ascii?Q?Y2c3bYIeIJFE6XyoAEV/hBu6UObRPQ8ir5Hs1/BoLZ+q2k8ofW9sUfE10G+Z?=
 =?us-ascii?Q?hxjNFevBxYfErjYXc24Ixrnk7n8d?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cjvHNHA3JVjKQpDpwFKxQVs5LP/PGSLtNRlatdxxm4hTcpupMMrfPU6d84GY?=
 =?us-ascii?Q?DV78mgXoXAM9pJ5VlfqnYeZYOM8V9jkbZ2aT4DUh8gJA/A/ccRHsx3draonE?=
 =?us-ascii?Q?AqAsneak53QKohjRVdBjeGhRnvrdYtu+QuXhTUalClLA7qEwbo3MraWkcipp?=
 =?us-ascii?Q?vOPgy2Z5ivvzczY+Pzd+00bSu3wut21lIqOcsxkzmSkkpNOzYhvDy5Uf6QsU?=
 =?us-ascii?Q?THu8+9WHR8vip0WoBbglwc5J1+rQ/N5ovR9xVWENvlYJXgAfataQoujy7E0/?=
 =?us-ascii?Q?SVmZkkWUhMCkiJ8KKn2TwTGPvZ/EA5egikXkCr/oqZxDq9rkduK74MtVB0cf?=
 =?us-ascii?Q?LuWHOFBNsTlvtvQ0+V67tFYk5lZYhEBYO263IfALeztzmRpuevWgsfMZueD2?=
 =?us-ascii?Q?C489UsgTEyN+DF85n/DvLDqFc7mNbLASiBWS3YvONc8YK+hfCO3VXXma9jvM?=
 =?us-ascii?Q?9NRvR5cDcZRbPrsN8eyHzI/y7X0JPZn8eDYKHHhQOmWtgNuUhFhQD47XtX/O?=
 =?us-ascii?Q?opioG4ycU5dBzI3+FhWN6l98cajFQUboGEfb6cIWeLWmP2P7gowz7aeHsFjC?=
 =?us-ascii?Q?DH4vo05L5TEtBTjz2KHFhz31PjBWC7bgfGaanq16PwM6NBIS7UIi3mgsSh2X?=
 =?us-ascii?Q?DzLEryB6WNBFJbD4/cf4TI8yrnwKwemcqW1O47uUwrhhJuxA30aLTxsQ6MIt?=
 =?us-ascii?Q?7Tm8QSEcF3WGBi84oLwcHXTLUeDzch/XbJQzJyM77hR/g5eruW037QwwyZCI?=
 =?us-ascii?Q?VCMTfWh7n86WRnaFmr65VrR/1IWIQCb75QJ6be1bewdFihBbhWHIWKjPdm6q?=
 =?us-ascii?Q?hNsmMwLss0QIg5vS7hHrgGlVCl/Xyc7l24CGBeyAh4uOvXAWRbYwXAiDLesI?=
 =?us-ascii?Q?jRfM/Xik59yno4ymFxSCRUu8v2hMSD8SiNYWo1LpORXF34MQcZULuBUKYKzD?=
 =?us-ascii?Q?htuOF4240xYSI/RSS2c2C9fnjngO02k4UckU7Zp95AWMuZzjt5sXd9IdMNlb?=
 =?us-ascii?Q?vvvR1/BIqsRri+3/k/Ad+aqab0WASXFRyTHDp4fGjGdIdByuVS963MlPkdqJ?=
 =?us-ascii?Q?hWfcK2f5DWfEJQffnVmHAoIY4o68irEnQbtPFooCN//cVilNgVzQmD/VJhWQ?=
 =?us-ascii?Q?r3ft5dmC/I5uEXCCmYVrJLbsLLZC56ASbt1AxPtrqqsPkjWMeGFHS6SrrRYd?=
 =?us-ascii?Q?ILT1XrsleYs5b2C47CcDJJjAQ/tGAzZfbcD+WwnH76J7Ip/vWmw2TfoBot+X?=
 =?us-ascii?Q?u/mDnvT0pou8fynr6YscivRICgx86kN6VQ+ah9Zv2Vg7w6me0oIVhRjc1EDh?=
 =?us-ascii?Q?ZbQac1Z45Q2ylKasnR+rEcJVY28EkAFf+nGAKL9X2b/JAzWhwZjYVgPQCG6t?=
 =?us-ascii?Q?OoPLcAL3x6OIn2LcfwG29P3hMh9CX4ewph0IQ9jVDnafaKRv9wvzL33FUiTU?=
 =?us-ascii?Q?IAzSpHIviWtGxnRN9wJGYRlE/w5RUnQkThNQt5AWAqnguTQaoyGlFoEGOl6f?=
 =?us-ascii?Q?fBpMReltqmVlgGhIS8tPE/AwCk2lDomqKzI3dZLOUKeUp2RLtkNBxMmePOq5?=
 =?us-ascii?Q?D+puGHMkbiScFEy0rFTWkoZaElvZRLIHxJomikU0Fz/QHQ72LbZ77h0OQ5aO?=
 =?us-ascii?Q?NLgklrrSsv61ON6BLATU2AsBKHUwRD98sTSexht16wBQ7zpDyvGmDs9UwcEV?=
 =?us-ascii?Q?wwd6ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u+HeE+zwBozF8jy/WPmD8rev2wmSiF6IpwmUIN4+X4Nfgpt290h+8tRHuSUAq9GJkIRga7rrDb8E/GfO8jYmDTC195IFQCRznaSyZBnJchLR9G7XH5Yu1Wf10hhF2tGoi3mpp/TS9OO9WvNEG8Twh+JUS7RblMHs6h4yWTFO/p6F3PP2XmrG30lf6xFGgPhOdjIutw8qSBPSCSERUDMZEmBQ2WZNGs4gxX252VwQfK4CThezlbGGcWCtBloeIChrw/SdmOGd67uMZlffQO0aYTF5WJgnJ96Bqv+wxWTtNtM9IqH0NJoeclBitzyzNZ3iJJ18lzkPOAumqA51YmGx6vwDTTgVVi4EPd800BZPXm3yMocL3UggqTiCUUkBMVstN6SVSqAKMkXTj521kpGs8xy3NC0qPUmwoRZIYqGYeZ/GQUE4/+LJSK1lIEcUktsuUfxw3dwfshmk+JkToMnK+b4xS5MvK/+UFd/egujALqe5H4Od1qJV6Tc68Q/yrOmgPdCIRiRttndV1YetfGeuzQZKmABFcUbVQJKCKi5ny7lrya2dz+/OC5E30jbu6ihCWINLO/bwW23t0bvwdadnIF8FlMmBVFwrKSU22A0s3L8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e2c0c4-6895-46cf-8e75-08dd45925f8b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:32.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrnNO+bV07UI46pv8TNgVNXU6008Jw1unCJ1b+DsXLnf/wVLUWDwnJ3QdORH2VfhgZ4pbp520+PEBBB7YIwRRj9U8xWtOp1bf6zO/1+8tKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: 7halVdK0lap62nsuia33BF-2Df362q0p
X-Proofpoint-ORIG-GUID: 7halVdK0lap62nsuia33BF-2Df362q0p

From: Christoph Hellwig <hch@lst.de>

commit 4a201dcfa1ff0dcfe4348c40f3ad8bd68b97eb6c upstream.

Currently log recovery never updates the in-core perag values for the
last allocation group when they were grown by growfs.  This leads to
btree record validation failures for the alloc, ialloc or finotbt
trees if a transaction references this new space.

Found by Brian's new growfs recovery stress test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c        | 17 +++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h        |  1 +
 fs/xfs/xfs_buf_item_recover.c | 19 ++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ec875409818d..ea0e9492b374 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -357,6 +357,23 @@ xfs_free_unused_perag_range(
 	}
 }
 
+int
+xfs_update_last_ag_size(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		prev_agcount)
+{
+	struct xfs_perag	*pag = xfs_perag_grab(mp, prev_agcount - 1);
+
+	if (!pag)
+		return -EFSCORRUPTED;
+	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
+			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
+	xfs_perag_rele(pag);
+	return 0;
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index ebebb1242c2a..423c489fec58 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -140,6 +140,7 @@ int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
 		xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
+int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 66a7e7201d17..c12dee0cb7fc 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -708,6 +708,11 @@ xlog_recover_do_primary_sb_buffer(
 
 	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 
+	if (orig_agcount == 0) {
+		xfs_alert(mp, "Trying to grow file system without AGs");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Update the in-core super block from the freshly recovered on-disk one.
 	 */
@@ -718,15 +723,23 @@ xlog_recover_do_primary_sb_buffer(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Growfs can also grow the last existing AG.  In this case we also need
+	 * to update the length in the in-core perag structure and values
+	 * depending on it.
+	 */
+	error = xfs_update_last_ag_size(mp, orig_agcount);
+	if (error)
+		return error;
+
 	/*
 	 * Initialize the new perags, and also update various block and inode
 	 * allocator setting based off the number of AGs or total blocks.
 	 * Because of the latter this also needs to happen if the agcount did
 	 * not change.
 	 */
-	error = xfs_initialize_perag(mp, orig_agcount,
-			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, orig_agcount, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
 		return error;
-- 
2.39.3

