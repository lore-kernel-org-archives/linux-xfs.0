Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49D222F76F
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751367302; cv=fail; b=I+CEV8J1LYNlrUq+fl/IQZiYcmYyD2WFvdUPuF1+AxVtPcsYIsveUS0nrQXm58vEkKApFnNkDz/8ujxslrfRrTPaI/ACNyO376CrQcLqsXaO125s0Ojl2CiCcR/Hn0MmPrDU3JZAslsq7BZGJdvWbLJwXNKAvbWiwZrwF5CCKtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751367302; c=relaxed/simple;
	bh=7tEnSUWUFSfjm8YKui89CPop/9AmetCPnqFMbtdvNl8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oouNZBeMjfCZ4bg7KjDCNnZe4zI3MaxXyB34FV8nK9OpVtFvAHnACruQffVcsdpRWz2qU0mu/nX0x0U84bhIo1RxTsW2rEd3HIcLW3zcDnHhDDFecm+KjmGE/0YqX6WCdXCQY+tvL0m5a36YIOQPf+UV9s4+eQ6U98Cub0NFrAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fcQx2CVe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DDWot9MT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fcQx2CVe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DDWot9MT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5611NnEd004499;
	Tue, 1 Jul 2025 10:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ipCOcZz4pwmCYChmMokpHj3HDH4c368e5Z6uNMpSDHE=; b=
	fcQx2CVe7oeq70L/L7LuPfLV9pViwkXUz3Y1mdA80ES3ePiggU4Vb4g6CzL6lZAN
	rdvES4mALohS3P2XgOxqhVZzfTI/xcoaXIaQLaP6ZS3gue+B9VNvpnWJ48w8Cws5
	noWtCIJj8Y+JeuNkVX3zTSlrbG7Q1w/ZVEsyNS2CRrErrB3ONHjeW6Tnx6U7GuKh
	/VxfZLzTq7rCfic/6Wttlt9LxUwtsBwe/hs+46OkNhEOgqdff+hMm+kqGjltJk+R
	oNiZcAL3JmxvPitk2tm3iL+RISCR/DhGtbav05UYetVpLbZ73+1ISyAL+XDMK9GK
	jsfiKijnKxyW9hYne4U4FQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j80w4fup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 10:54:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5619G4RU009289;
	Tue, 1 Jul 2025 10:54:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6u9m5q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 10:54:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMbZy1OqRaff5IVT8NqvtitPrWojpE+UxiLCizSK6mrTlmn+aFLpRJb0hmEl8oK+BA8KiEz7As1Ev8kEl4HfyWH1Vx9pEFm+8VLzPJ30hpcZRdzz8Eqfh2NMuiNtsY/YvflaBmCdo+qdp3psE4C6ZWca4yrCQI4fEZivCNylKspv9SpESOEJ9uEzS80dJECIQ+j499iH0qsGyottz0wbpmHFANVtjWorcGScWfoBy+QfNzplJFq+320ThirsmQVU1sTLAIB5/grA9EIUgY86zMaxLZPGv7xzTD65AEaLsgm/aJBP20U65sp0tUqI5M/OC9BBHVqk9oyctRDXlIPRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipCOcZz4pwmCYChmMokpHj3HDH4c368e5Z6uNMpSDHE=;
 b=lh7cbnSQOr1yAQumVcVmuNrsdEIm6uILrGLo2Y6FUG6Vrbmmb4Yk5d6dA1w3qJt86rKiFplFc0NIBwo7Hxdqh6heOdL5c3DJ5jWfund9qNZRM2N/zQdn5gsaknlQIwquX/dvpaZeUMxkfFtS86wCbC+Vr/drL0BpMS0SNIAEkq/5JpjddaB/6ejE7es72Y6PsCkucT2FR1DOl+vpALyEX+NF2F4hE3yJFp55dK/6Hl0sWDIfEIvzeYe7jTyMxsPfSqVqop1FfCi3wEOTkQPm3S8tjWK4CheRNcsQWpj/mR8GET/tlr9GpEzY46zrQAeYN7h2hNBWM4W7ST3RiD/w7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipCOcZz4pwmCYChmMokpHj3HDH4c368e5Z6uNMpSDHE=;
 b=DDWot9MTYRxVpS0j9umUkOzIT0/fIVPAD1roJfkwCep7SDD3tyboKSmRMwQyLVRRZm5B7oINKfi8rmeS1dCdBi73JM45ewryJQYkKSGkpvny+jTSy4tCY7T5JR9uMsCUhHb+HpdKYD9bkkXxTtNEJoRU7DphrOgK6+k/vVy9d6k=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH2PR10MB4359.namprd10.prod.outlook.com (2603:10b6:610:af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Tue, 1 Jul
 2025 10:54:50 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 10:54:50 +0000
Message-ID: <38bbf048-33fb-4391-8c76-22992e522b21@oracle.com>
Date: Tue, 1 Jul 2025 11:54:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] xfs: rename the bt_bdev_* buftarg fields
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-6-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250701104125.1681798-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0316.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH2PR10MB4359:EE_
X-MS-Office365-Filtering-Correlation-Id: 82014e24-810e-434b-af0a-08ddb88db3e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OExVSFFBRnNCMnZBVzBnWnJTUDJyUzdlbXZybkRrVUNkSGd1VXdaSXQ5UUxz?=
 =?utf-8?B?ay81MnNGUVdlVTB0bjRxV1hFdjNGYU0vWGViUmo4NHoyclhxTis5ZVNHVmUw?=
 =?utf-8?B?VnFtV29tSVBKNFBydThsUUxpVCtiTDhSRWtMVVBLZjVES1Q1d2VaQ0lyTTJq?=
 =?utf-8?B?ZGhydmdUYWlUUGdUTWQ5MkNrTzNoRXBFOVBLM3hTZHA5VDAwbERqb092Q1Rq?=
 =?utf-8?B?MGhCWGp1cXN6SVhjNEs4Q2JsYmw3OUJkZjg2aHprN1RNL1kwV2lJdmlUV2ZL?=
 =?utf-8?B?dVd0a0xuUVRDd3J2U2dpd0tiY3R5S0plQ2lQNDZNcGxoRm5tTkR2TG9RWWJ5?=
 =?utf-8?B?c2M3ZUN0aXJsRTR0TFhLWW11NVh6em82SXZHMGlpeFFyY1RaNDZvK1A1Y1hh?=
 =?utf-8?B?ZVlPWlpSRnUrUDZhREFHZk5mZStDTG9IbFFwVFNwOE1YQ3kxanVuQlV0MFBs?=
 =?utf-8?B?bG42MEFQcUxkSzBCZE1xNVR4NGdyS2VsbWlnSVJxeG1sa1h2cHJzdnRJQWEx?=
 =?utf-8?B?T1E5MGxiclpoMU1TZ0dhcm43TVNza21WNit4LzlvUjhPS3BOLzRwbVhoQ0F1?=
 =?utf-8?B?QTNmeU1OYkcvdWsrb1M5elVhWXh1V2s5U2R6WTRoTFZkMHFRYmFudWMreXJs?=
 =?utf-8?B?OFZtQnBsTkdyWWpNUnZxY1lxa0gwNTBJRWUvTmlmRmJWc1lpTDJQRHRoaDVZ?=
 =?utf-8?B?TXhCejVlMG5oM1BKb1ZvajUyOFFBLzJFdkNQOHppU1ByWTAxK2FrSXhCakli?=
 =?utf-8?B?Y1FIVXdHTWZEM09VbVRVY2FFbmYzbUZKblRtVFFkMHExK2ljdklkeXNiZGhp?=
 =?utf-8?B?TkZuRE4zWTExMm1XSUxRNHZxU1dtMzhNSjd1aC9ubWYvS2N3N3I4WnR3SU1y?=
 =?utf-8?B?Y3pFbllTays0ZkY2RzExaGZ0R1V2NDFJYTZZb0hLRmQ1blJwalI3aGR4QzZJ?=
 =?utf-8?B?RWJjQXI0a2E4a2s4TWN1Vmh2Wm1ud0ZxZStQTGRhWVRhSkdKT0gxQ29hemVw?=
 =?utf-8?B?WVpUWmFvU1dOL0w0OGJzMU93bmFvd014L096d3hSeWhwbjVyTkhqUUNoQ3M2?=
 =?utf-8?B?WE1CUVVBb1ByVHBwMGFENFAxYi9PT0h5U0hvL3BPZFk4L1BjSjlKMWZMRnM1?=
 =?utf-8?B?Yjk3V0NEQk0zSXZSUjlJZEV0T25pWnhvVjBINGhiWkhqOVdDOEtxSVBvejlk?=
 =?utf-8?B?K1RCajJHSWFhQTFEdFl0dXl3SnN4Q1RRclhrTittZGNjTHdBUzFLTURRMkRL?=
 =?utf-8?B?V1BnWWFISDRwdUpmRnMxNXN3N1kxUmhZb1RnYUdBSk1zYUUrSEwzUnQzT1d4?=
 =?utf-8?B?dkNvN2hOcHhTOEZNSFNHUzMxQUJiSG11RDFvWWNBcHR5TTllZXEzaTBvUVlZ?=
 =?utf-8?B?QWFkNDJTQUpqZThJMXJacGNEMGhxTUovMC83YldoTi92RGVmUnF0WndPREgw?=
 =?utf-8?B?dEN6SlVrMmpYdWhna3dobXhaV2x6Mko1c0htZHRzdHI1dU9vRXl1WEZXcTlF?=
 =?utf-8?B?SHVoSDMxL3hpVWUySDQ2TkhpeHRnOW9JVzJQWXRjSTNOaDdTOTN1TEpxZ1NY?=
 =?utf-8?B?VHc3L3M3ZEs3WVdCbUtMWlo3RHBDZVh4YUtlUXl4U2RnOCtSNlBMMkc1VW1p?=
 =?utf-8?B?YkhBQWgyaG80OFZUdHNpUFVIT2hBU0twdzNKSzFiWURDbFJwNXhjVjVMS2k4?=
 =?utf-8?B?NEJZMExwRkU1VzRDbG1PQzF1MXY0a1EvbklxN2ZFaTBHT2NlWlpobHh4Mk1U?=
 =?utf-8?B?MThPdkR0UEN1bjBQU2tDNzFwbVpoUnFwTUJJS0dqdG1hUWh3L3lYekR6ZWpt?=
 =?utf-8?B?d1JPOTUrY1Urc2RvUWVVMkV2RHA4cE5EMFVqZ1VOdG5ndEF5YUZMSFJPMmR3?=
 =?utf-8?B?Qnh0SDIyVWt6STg2RnBoMlBLcFVFME8vVmRJa1ZKMEN1VHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGFVcERVeG1OZHRKZm9kc2ZZRzlNUkZCdURDYUUvcU5JUkgvdTlITWZlMEtQ?=
 =?utf-8?B?VktFTkt6S2Q3U1UrTHR2V0N3NjVNZURnNVBxWUVGaW90MEpSR3ZzNEhZckRi?=
 =?utf-8?B?b3pUempvcUVmem16WmJWWUVKZmZYeVRld3VRSGFKUXVKWjhha1RsVDI2d2w4?=
 =?utf-8?B?V0pxdlJqUEVOYTFmd3dwdWFjR1NHWi9LdjlwOTAwR1JzejU4RXZWOEh3am93?=
 =?utf-8?B?eUtjR0VQZlVGazlGWHB2ZDVYaGxEYVJmK213S0gvQ1k2SjFGeldVMkZMNERH?=
 =?utf-8?B?VjVZdEVqNWlCMmkwZ052NEhZcmg2OURhRG9BTzdxVjUwQmlDRWQ0K1k0cGJJ?=
 =?utf-8?B?WDdmTCtyY2E1N2xWaGdBbjFMV0ZGWVkyem9BVnR5K0pFUjJIOERFZDVlL0dp?=
 =?utf-8?B?cFRaZnBZQ0JreEIwTlhpamM3RXpZNEVzV0lraDM1aE1zcFhCMUxQdHdjdG5B?=
 =?utf-8?B?QUFkalhJVllQb1FsMHRmeUNrdjhpclN6TThrSnpJL3I0WEswWWFZbGJ1eXZl?=
 =?utf-8?B?ejdlOVcrQUNrdldHT05YMXFPd0Vvd05Fa3NzRnVjUDVTcGVhZlZQS0tPQ1Jw?=
 =?utf-8?B?ajRKTmtIS0ljd1g0RktLZ3ZhNlk4VnduSUdHZEhseHFOQ0QvczRNbzdCU0o1?=
 =?utf-8?B?bE1RRElrNnpWNE9UNFNmNk9UQTNYVzNyazNmZlI4NytoTVA3L2RJUjU4UTF3?=
 =?utf-8?B?cDdlNElkT0lldEh1aXRqYzJNRkRjNGttZDJwSGtHSnlqbmNvc2l3SGpoZm9Y?=
 =?utf-8?B?Tm5KM01NVitJQzIzaGQ1RXlvU3ZkQzZwdzliVktxdXJYU3ZvMXhLY3VOZVpj?=
 =?utf-8?B?MnJsUm43RjJLZ1RORVpaRmJXL0svdlljcHQ4b3Q4STdRYlpsakhDTFdMWWxM?=
 =?utf-8?B?bjI3T1oyeDVTdEljZmhJZHlkV1VPUjlVMDZ1emQ3djMwZkVJYU1vR3hJUE1Q?=
 =?utf-8?B?OUxhKzFlenBrcHNyWmpZVXdvYnJrMXI3YWdjMFR4Mm01Vkt6b0RWZ0t5V2hF?=
 =?utf-8?B?N0dRNU5KLzd0L3QzSURPQmlZN3hDVDArL25EWFFDTnEvNU8vZDZPWVdkUlZ3?=
 =?utf-8?B?QXZvSUNzbXl5ZU1yRnVDQ0ltckxjblNvcGFSWFZHbzQrVldtamxtTkNuajJk?=
 =?utf-8?B?WjIwWEhEVXQ5clVFYWZmS1JBV05kZmtsMjhiM2htZXEwVStKMmN4aDljVnE1?=
 =?utf-8?B?ZEtndVJWblRhamZUY3dmeENIbDAxbmhmeWxFR0pVaGZpQzJ0OHR3anUya1NS?=
 =?utf-8?B?MlVlQ1dIU1NuMytpa1JiSmtMclVFZkJwc0ljalIvSXlBQ2lOZGF6VkhYUm43?=
 =?utf-8?B?ci9kK1JwSE5rVzNQNkczaFJ1UDlNUFVmL05jRld3ek9uYkNveTZ1SE1iRisw?=
 =?utf-8?B?ZnYxNGI2eDZyVzV6UHRWRGVJYmVRZUhlQ2xZSTM1WCs1aUx0bVA4cW9CemZE?=
 =?utf-8?B?aTFhNEhicytmbCtVdDUrMUEwblNVMkJCc2JsVlFTYTg0R1Zza1V3SU9QeTYv?=
 =?utf-8?B?emJhdlNrSVZnbkF6VFhJN0pEelFHZVdkVnV6elFFNE8ycjNLUUNLTUZvSkZi?=
 =?utf-8?B?cFFSMk5ZS0ZDRXUrQWd0Zzk2YlY0cFhBa0htNHR3aG9OK05zZmJHcWEzVlRH?=
 =?utf-8?B?R3BtdmdvK0NnK1h6U2hLN2dRQmRDR3M4QXJQYVlnY1ByM1IrS214ZFNKT3dD?=
 =?utf-8?B?azc3QUROb0tIZWhMTytJTUN1WGVvdzFUY25NWXJnbXZrMmJmRWJHRnhQS3Uv?=
 =?utf-8?B?R1BmOS9ldURUT2s2SFVJRnJZa21DQVAzOHZzMWhycUt1YUxJck9wVzdFTGkr?=
 =?utf-8?B?TDdNV1Jyc3QyeDRBeGhUVEs0MHlUVHBxaXJVNjdVRFljajgxLzFIN0ZMekgw?=
 =?utf-8?B?dmMxTjFwSXIyNUMzdDJCQ1VYeXhTUWhWZU9GUk9KdDdQZ3JSRGhzTWRlUFpl?=
 =?utf-8?B?RXhrL3NTMEExT0lJYkdpbEFaYnY2UWFBZk5lRnIvZXVuYmpVc1FHbkFvdTY3?=
 =?utf-8?B?TS9WeS9ZSWtsdi9qZnp5RkwrOG8vdTlFL1BOVnJyd2hlMUhsK2VtcmREd0NK?=
 =?utf-8?B?WlJNVXluRkIrbVJ2aHdQUFNQVTVwbWxqMklFL0R2bEVxeWxjS0kyRHpudU53?=
 =?utf-8?B?R2xxZ2pGUlphZzRIV2pramVNWjlsY0hNTkVsVHVIQkpUcWc3dENOdkdyRVhM?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0xAh3dMr9yxQBnhuy0i3xpsNu9vUk4kVjJKkzYM28p60s/jgetvYURlQA42IyFbHOfr13c/7gwZtiLexspSAZ6Qr3XUHqOba4vPQz1SQMG3c2WwXWJjpf1/28Y0O/BZsSYzHJbQU2SgvYVo1tb7Xlbo/1SW/ABFwujCFvuVk98o8GNa7NT0J5ED2iNRc+SQow3+qaxyZBqPxV30zF0F4+e3thq4llOsAF9NYk3Pf4sxE2tzWVfnY+92Q3UqrkR4XDwYSKdovGaHMZiXAhf7Rl6tAHdVOTFTC88eZErnaXCAAjrcNqMvQf875ZzoVTGQcKNQGYr37mdlIL7xqpGYqBsocIojBwiE/HwEXA7szK5r3zn1h/WocI7A6hFkxo1l8SanVJam13Etresk8x8gBXSpbtwDUmK7f79Y0ZaE6j5qFRNVtm20iiWQNS3KLnjt8vyZFWxQzGfWWs8qWyuOG0qwOJQ0Da6Tc+9QwabmaJYjvweM1+I+ij/UY9q1ZEfkS6z4eMXs/Kt6iSTIR/0V0Ajk2ZRvYkdxhR2QUoul1eZ90b2uRoWHS+fhC8ElpB6CRqHepLmljnIXEdNxe0k1KYYlzbD7GDK6QcrrPaf1YB+o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82014e24-810e-434b-af0a-08ddb88db3e8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 10:54:50.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1sjpCYA+BVc6ZTOKs1RTCbA/u+X9yopXilk4bZ1MJk8rVPUbcabD8W/iu07YVG9DEt9mTLu241aJNLz3evDcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507010066
X-Proofpoint-GUID: 6tEJpc-LrgvLWQEDo0eu6btRGD-MhFR6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA2NiBTYWx0ZWRfX1TpkRRUuG289 NfBeJ8FiLfApYXVn+49ynm4Ge+CN/qMVeAd3HZLu9B5on5yAGoYIXsWPWEdjJNso1q9YJi3D+q4 WJicdrAS6tefUszSnXlb6wh0/9HQRgMB0xtZXuZEZhIMp3aCXBdygYzPs2SaUMcZZwPauBb1IcH
 u6xIUp06aPiwcWoVXuL214ONzdZEaOFRrqUZkUwZxnHn61jjzZcCIrKpt9XVy3TD0dmgWCVDZSG bmekY7lcTvgjk6zx1WsBusuw7CW5b4LPN56VMDNI/Zfkae6QgVynrfTsuVzbKD0Bt5BrRDNfOAP BZrZDkKUw/pJqR12lqLbMZhciDN0klh0O31s3XB0iAC8EOVZtHfydIXNOMFzcHhxjykH6MHRzWM
 uWJRWIOfu/D3GNV0+Mf2TnX3NFp68nEBKc5uh/eLp10j3KIm3fjLswJvu04YbR5wjEF9e7Cr
X-Authority-Analysis: v=2.4 cv=D6hHKuRj c=1 sm=1 tr=0 ts=6863be7e b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Tt6O2dfJa7HvfynKMQgA:9 a=QEXdDO2ut3YA:10 a=UxLD5KG5Eu0A:10 cc=ntf awl=host:14723
X-Proofpoint-ORIG-GUID: 6tEJpc-LrgvLWQEDo0eu6btRGD-MhFR6

On 01/07/2025 11:40, Christoph Hellwig wrote:
> The extra bdev_ is weird, so drop it.  Also improve the comment to make
> it clear these are the hardware limits.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
