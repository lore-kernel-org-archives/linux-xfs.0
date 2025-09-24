Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A8E23D280;
	Wed, 24 Sep 2025 19:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758741537; cv=fail; b=JXqq9QudtU5GmDUIs8QRk6dkusxhbVQWVBbgFKwKMOC1pf10/T0MvF2a5eADIiOEXycKepG+UZF7mHS8w4Xeyhy6hDPBrvVyUqbsOAWO9/wCCZhjv/WvQRtbM+2qRYIaJdgIwhbieISzwP1aHiSoIeHEPdeDkl+lPF4HdTSaXrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758741537; c=relaxed/simple;
	bh=bq0y4mgRjff1sQAWmtd+uOPPelvTLTD3eWtabF5XSHw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fqxkyir5Ubl6iAVZvQYQgNe9bhclrZ5FJM5Tp5mVWTf58shEXQZBguvaYSGkgbAsSpAvqtK3v5vyr9aGWxxuaLckluSFuInz1J4sjkQCh25jE+JKgZ3ikbRkZotM07mgpA4f9bCq9uyKjdc21IZ7mhnysKzKheaqYY5wZiV0pP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YtjcWeaq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XNr/Xf3U; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YtjcWeaq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XNr/Xf3U"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OItrNk001285;
	Wed, 24 Sep 2025 19:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bq0y4mgRjff1sQAWmtd+uOPPelvTLTD3eWtabF5XSHw=; b=
	YtjcWeaqSgZwxKosqE3DaBbacIVvPHjIIP9ybZjdTUA5Z85/RfnKBW567WlMs88s
	JB0iHMQSLsKam4Gg4aDOqjSVg2m8rS7ESDGc5O0s8yzKFWISFFsqM70cVR8N1MVH
	E+tiI7aAIWLODhDfG8Viv8A2HC1SBNHezhZa7IrRRURrNm625rPBSRivPV81GkgX
	7KSdCl/0CSQRM0nfj3B/HvEXyzoEip0vElHhYrdddL4DxnEYa668cjOGBYNcZTK5
	XgjGuceNVT7C8RZuSExQ/3iGOwb1F/Y4+/FOvb+QY4fjdWDqzg40FX2puYgwYVth
	QXJO15hUuhnTOnX/mCNBiA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k23ggvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 19:18:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58OJ99ag040813;
	Wed, 24 Sep 2025 19:18:45 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqa12j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 19:18:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xELSj0qBMNdApJ6sBWufHZINIWRdiOxVwn0zo0/Ix/GNdkPIJRFke+lFj7rs2Wl3bg07AAJMTOaRFnIYgVtDB34rYQnvzEn6SzRF0lGqoybmac8FGUEsCtNBHqI6E05Ig7ZGALNhyUcyMhL6sFjcTfn2BksfZjJ+kPIrUzWw2NMDRRx8oIc5bbuAlFDc0BAzZaSPWG4UaBxWe3KAemKcUaKuAeUGFsZV/LsK/ehcZpZcvooAcAosxBsWLwUnKBi+4652jc3ZH+V8klpaNwg6pfHj+F7QlMLEDLLRkSw4dxTepxsIjEVWGQtzAzqzWbd4QlRk+1yYbWy3l9xtummr8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bq0y4mgRjff1sQAWmtd+uOPPelvTLTD3eWtabF5XSHw=;
 b=KeF+y5Pv8M4NJHWd9w+PSA5ACW7kQGQJkTUskvTjHkFWYYOZ59qkjASkvr6ASVppTiR7dJfagGDqQQsb6nWjF56VcYWXEffVzVN22tO3YbMsVEeHmZiQOAaoZapTDFQX1CUxB4JkLl1HomuVkG3imSZyh//NT+9x/26PHRwA3kIAQnHQkgFgNASt5MojFrnKAhnb+w4W07HWQZeoeBxSmcA16h/Qu1IPQu1n9EdsCrMnVkTssYAJ3qULNhwQVbLlejLWomsAg7hDka1VQjdK9lMLVn+wFv6lEOBFWaihY73/NOCDNtboIJukqshrItVqZXJyG2ajjyS7Df9MoMVayQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq0y4mgRjff1sQAWmtd+uOPPelvTLTD3eWtabF5XSHw=;
 b=XNr/Xf3URfUrv1bXFgiQxi1lY1jPDNbYwwCqqBvm+g02q67Odz1MqoDCs7Arb7AVXjzoLSjgVzTITrpFdA18igsmSj8af2TTR/tpeJ22IGuIFCDugCzHT8TZfXjKzyStjXBS/XLt/QYQP/ZJFW709R52NSad4NKjiNsXUYuWuk8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ5PPF0995E25F6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::788) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 24 Sep
 2025 19:18:36 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5aab:b005:15d0:d89]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5aab:b005:15d0:d89%7]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 19:18:36 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: Amir Goldstein <amir73il@gmail.com>
CC: Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong"
	<djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Carlos
 Maiolino <cem@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Greg KH
	<gregkh@linuxfoundation.org>
Subject: Re: [External] : Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
Thread-Topic: [External] : Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
Thread-Index: AQHcLWo3Eyw/UGGM2Ee0yOK4KJ2jarSitSuA
Date: Wed, 24 Sep 2025 19:18:36 +0000
Message-ID: <962C2157-0791-4F8C-A1C8-64CEB3195A32@oracle.com>
References: <20250913030503.433914-1-amir73il@gmail.com>
 <CAOQ4uxjTRC_xYriSrSq6aF4sCjX_5xPzX5Lw_opW8RHJiHsrCA@mail.gmail.com>
In-Reply-To:
 <CAOQ4uxjTRC_xYriSrSq6aF4sCjX_5xPzX5Lw_opW8RHJiHsrCA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|SJ5PPF0995E25F6:EE_
x-ms-office365-filtering-correlation-id: f2234c60-17dd-4bbf-b366-08ddfb9f28df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?S2pPaEVYRVJTbzZOeWlZVlpKUXBNR2tpUFI0bkkycEtHMW1aeUN6bXFKbWlK?=
 =?utf-8?B?c1VKYnpvcERRTjZxZWhPMnJhU3JPOUdlQjBVQ3lXNlB3WThMWlBqeWw0WkRI?=
 =?utf-8?B?VU5LcEEwYXc4bHBTdXR1bEJHcmxEL2wxblFscUNBTDAyczFWdUI5d3hGUXMv?=
 =?utf-8?B?UE1yTzNMMkdDZ3R6RFV3alF1WTR5cW5lbldkS0JJcllaVWJ0dklFOCtySHNS?=
 =?utf-8?B?c05LWEhYdExSODcxSjV0OVh2a0lpT1lqZk5Fek14RXhKWEZOVEhYb2UvUTZm?=
 =?utf-8?B?Y1FwdnN1U2V1UmxpU3FCV3Bic1ZSZHdianZTUm5tN0RVR2IzNDg5bmlaUThy?=
 =?utf-8?B?blkwRzdMU25oUWh2T3lmeFVON1hwOS9TeW5LT0llbEoxWnNMYjRoK1N6YXVF?=
 =?utf-8?B?S2FMNG5uWEpXWm9hMjRlYjI1T2Q2T05ZeW5pQ29tZXRTemp1YlhXMjNaNEhv?=
 =?utf-8?B?a0djZnlNdUtXQ3RPcjg5SkE2eUY0VEZZbk9iZUxEa1JGcGJOSFRSZml1NTJH?=
 =?utf-8?B?bEdhUk5pWjJwUkxleVZsTjRGV1dHd0crNXFRakErTnEzVUZreERuV2F2QmVl?=
 =?utf-8?B?KytsNEV2a2daRjQrWnphbnF6NzZ5NGRRRS8wKy9RL0Q0SkxEZFpIaFJmN3Er?=
 =?utf-8?B?MjVjV3VXT09yMGVqT0VjVlYxckV1ZFp1d0RheGgwZGMwVTdCRmNWcjE3Rmov?=
 =?utf-8?B?K2NNaVpJWG9DT2gzU0pRRGRiWTM4K3FqQlVSZWd0RGRQb0ZyNmxSUy9seU9h?=
 =?utf-8?B?VWF1K2hhdmR3YmhiNFp0Ujlkc3BZeTdsbXJ2S0dja2t2TTMvQjZtSDBvMlU0?=
 =?utf-8?B?aDlESlU4Y0RneVpaWlp2blRWRitCOE5VNTF2Ly8wZTdUdUdqcjFZakdNNUhL?=
 =?utf-8?B?U1RFNTVBeHhLamZMQmcvWnFoK3FTb3k2c1RaSEdqcnl6UVRFUStJdlFnb2Vu?=
 =?utf-8?B?eVA2Uk1NLytIbmE3Y2lYNEEzUkNSZFcwU2NTTkQwNE9YbnhNMzZaZ0ltaVcv?=
 =?utf-8?B?VHVIb2VFdlJYa0k5T0NCOENvMGNFS0xlenZ0M2Jyb3ZZV0Y0alJkOW1CNlFO?=
 =?utf-8?B?dkk3UlFnT09hd2RVSVdLRG1jd3ppUDJhdU93VEJ4NVNPeHpKYllHby8rTkU2?=
 =?utf-8?B?QWU5bmpKUkNmWDFaQXhLUjI4a2lULzNWWVhzM0MzQUFoZjdaRE5OMzl1TTRp?=
 =?utf-8?B?ZVhEeCtwYXk3N29yakh0eDlDRU1UM3dONFRlc3h5K0xRZ1NPRXlkQUo3WVRk?=
 =?utf-8?B?Q015ZmtOczhWQys1dXAxV1ZnKzlqVUExRXAwY0k0Z1hsVVlOU3FIVmdadits?=
 =?utf-8?B?MEphM3MrQ2R5ejM0WjNPamFTSzBmZTNzSEJuZmkwR0orN2lDTWt3OEdncGdm?=
 =?utf-8?B?a3RJTUhEenlSbGJ0bUloU3NUZDZZUU5FWExjUE0zVWt0T3N4Q0pWNlZNVHZk?=
 =?utf-8?B?KzUrcEw4S2wxcm1WZi9WRzJHQUcxV2xhZVhXVUQ0MjdFUTYyQTR4Q3pvMHFS?=
 =?utf-8?B?YjR5TjVCUDJxczZGWmhpdTZWL3hpbWJ2dS8vdFUyMUVMV0dZZy83T2tZYnhE?=
 =?utf-8?B?YWZJWXJmK3FzSzZzMWNoYnZKUnNMNkVTSXNIU216MGMyS1Ryc2UyM21sdHlp?=
 =?utf-8?B?UDBxb2RSZEt0QUhveGY0VWdkTUw4RlZDbU0xdXE5cTBNS3V3Q0JKZDdBR3pF?=
 =?utf-8?B?Z0RtUHExVmI1YUhHZUVZNVdGUndORFdmbDRIMDB0RHdDTjZjQTgxKzdTWG9l?=
 =?utf-8?B?Q3M0ZXRWU3ducEpEKzRHQUxtWnN3aEJrWUFjVTNrVE1TNmY1M1VDYlU3QXFx?=
 =?utf-8?B?Zmk4Ymg1dlcxaklhM2xVdXY0Y2habWpOd0J3WFZSbVJqcC84cWpGVUtPQy9v?=
 =?utf-8?B?eXFwUjZqNDBkRUFxL3FoL2JoUDdlK1UrSkZpOFE3aFcvdmxxVC9waHlDMkR5?=
 =?utf-8?B?RlNqejVHRVB4MlF0YXhWSDJRRVhWeEVhcXkyR09XSVFISnpDVm5iOEp6R2My?=
 =?utf-8?B?QklHUDFvK0ZnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YTBneWpiK3dxeVJwdWpWRTZkU3J6cm85c1kyaHdvWFh2d2VzL3hyOGNVcU41?=
 =?utf-8?B?eHhFd3cvWEZCaGVQTThzQVhTWnRaemZOQUVRZ01VSzZ1YTVIVC9WT2tRMWor?=
 =?utf-8?B?K0Q3bDYrVkRKSlhmQ0loN1ZYWWJUeWhZT1VDQ3ltR1dGWmMwUEErVFBaS21u?=
 =?utf-8?B?aTRQWW5taXFaN2RRWDRQWDNGZEp2MWpFbGxZUm1CbUZmMFNyZVVMemxiMTA2?=
 =?utf-8?B?TkY3MXBIVGxSSEZrYWFUaDgxNTdHS1U0cVhuNnZUdHRteFFLc3BrRjN1VWV1?=
 =?utf-8?B?Q0QzNmdvZ0I5L3JxNFJBK0NhaTlxQXBYN1VmVlhUVGQ4b0RqTmFLVVd0U1BR?=
 =?utf-8?B?c2FaaEVLRk5JUXUyMEl3VVJXU0FPS2cxV3M3NFFwUG45RHRxdXgvOVJwL3JI?=
 =?utf-8?B?S2QrcDc2N2xWQk5CNERFOGdwNHhva2JIRlhidmdzVzZpZzNRQXdSZXIrZkF3?=
 =?utf-8?B?OXhWLzdybnowR3hwVXJyRGV6OGZXUmRqUHZNU1I2N1Nrb2pXZEZLdWZQRHFl?=
 =?utf-8?B?M3lDU0hiWE9JcmtrQkQ0ejlCNU9PUjlXT0g5U0t6UDg3R2Q0OVFvK3VrdmdU?=
 =?utf-8?B?cE1XRGlJMUZEcEdRWHA3Wk9UWEZpQjFBZEJpdDg2cFA1WXprUktYcWtyYmVu?=
 =?utf-8?B?VVJZVXJoSmlML3lwL09xbmRNRk5VY2FCNXNhalQ0TUlEME5lWXR4eDJNQjFY?=
 =?utf-8?B?MEpOMTVHWFFGVWNYamdQUDZoRnBub3RvZ1cxSDJCZlR3ZmFPZmozT29DWXQ0?=
 =?utf-8?B?Q0M4dzNFZm0xR3FmTGZ4Y1FLN1F4ejV6S1ZGd1BZdldlOEY0bkl1WW95OG5j?=
 =?utf-8?B?cVEvckRtaTdRbVduaCtNNFVNdk9mdGFVZTgrR29LU3cxcGFzeXFKS3NHU2lX?=
 =?utf-8?B?Z1BSdmJEb2xBY1k1enZGNEl3ZjJxT2NnK016MlhUWFd5YnVUTDFDZm1MTU5B?=
 =?utf-8?B?eTVaMzBldEpZY25PRWR1VkNMdGF0Yklud3BycGRCdVd1TC83T3pPekJ5MGlw?=
 =?utf-8?B?YnN1SzRPK0tVWFdFNTc1cDVrQWVONmoya1lWU3Y3NGJmUmw0Y3FCZHNXQ29L?=
 =?utf-8?B?S3M3eHc5NzZkZDMxZ2FEeFQ2SE0wU3hjczhlMGRCa1NocHlmMXlLWDViazJD?=
 =?utf-8?B?czRIbTVWeFhacUlnUXhMOUtsR0Y3RXRUaGFRb1kyY3hqSFVHSlUwby9qOXNq?=
 =?utf-8?B?QWg3eVE4THBrb0Z4di9pMnBBSmdydXFHUHBvQ0tpVHYvbTU2OUZSeUplOHFh?=
 =?utf-8?B?WWdVclUxbDhtSTlNUmppdWMwazU1aUVyNUNkN2ZLYzFxdytuOHIrMkUxVEJR?=
 =?utf-8?B?czNnQjdFTFEvcjFBQW1DVzJiOXJvVUJqU2xyWTFHVTFXYTJabjZYL0xZTmdq?=
 =?utf-8?B?SG5rNlJJMmZaQ0ZSSnZ5emVUQjJ0dGluZTFjWFYrMW52KzFFK1RGZWxJVXNh?=
 =?utf-8?B?bXlxaUxFRG5EU05uSkZUd0pSWEFOb0ZZOERqdlVZVk9uSlpmZEZVcVIvUUhT?=
 =?utf-8?B?eStxUFZVWTZoeTBOWHRoMmQ4YlRad2dUb2h2L3lGWUxwWG1abW9aTXVSTnlu?=
 =?utf-8?B?N1Q1djZ4MFkxMXJQZnRwUEhvaDBranpiRnBNQkQ5Y2xjTmg5NEZlNUdCZXYy?=
 =?utf-8?B?QlZLeE9YVkpQMjFoaUZUd3J5K3NwNVpnOXZncDBhcmpHT0VlVW9RcWx0Snht?=
 =?utf-8?B?eDhaNCtXZGczN2RxeEFtWWJXcE5KYW9ZSlBSM1Y4dnptOFowWjVKOGV1dWtl?=
 =?utf-8?B?SnI2bXByb2VPZEZsdGZmWW9vUkFFb3YvWkRrZW1FU1Zjd1ZncTBQZDJ6V0pL?=
 =?utf-8?B?QWxTSDRZdTYzQnhVem56Q0NQT2ZOdFphdEJmUUs0Vnk2RW9Xd1lwT3hoZ2hh?=
 =?utf-8?B?M1hHcjRQc1IwV1pPVU5RNXBzK3RzZEpxK0RYYmFPZTBvZTlvS2pPL3NHVSs5?=
 =?utf-8?B?NnIwSzJUR2RyL3YvSUFzYUZhVkVSekc4S3NIQ3lnS2I5NzRKcmZRVWtxZDds?=
 =?utf-8?B?VXV2SnRyaFp4ZCtPVmdDdktVeXJDTEU5RkorV2FRMUMxbkN5bmEwT2dUN2l1?=
 =?utf-8?B?bDZEcUZZdmd3am0rT0NYOE9RWmd2MWlYbytGUjJ6ZlBNVzBNMEs5cWhDQmpz?=
 =?utf-8?B?a2h4RFo5MytBeGJOYm8yUGE5elg4cDhHRFNiakEzZUFxb1VqTW12Q2l2SUNO?=
 =?utf-8?B?MzliTnZoRW4wL3lualp5b1IyNThqQWNzaitBaWtXelB1Z05lUzlOdmJDaElB?=
 =?utf-8?Q?OoiJLpRvlJf0vc8K9F/pqba6psheTDc+YJqfr9fQMQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63B44058167B5648A9DA8442EB8BB1BF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wB2fRO0mcCG5m19HCNQnDV2EtxmT+kSwM6PuB4/Toc6lA872Ow6ljiUnoHleKshRA1Fy8AZJY6LO3P1Kud1tovgumGERx+A2gxbODmGAtN/OgdFRnOS4iGtAoBNTzK4P77wYU7RWmYmz/1bbd81FIH07AmYuxuEhKWPAuPXkivkTHSiTdzlrB83gXhIuZTddXdsLdPagY78uWoj4OH+FmUhWy6vVCUjwaxB+rYt8AcnPuPc1QO0gVcFaawaRqB/TgcnPNhszNpjgyDUPHt6gLDxJRzOziNyAPIGviEQmhsehJAhOQ/aHkVE7hYtqojxpgTbKklifNEyqA3SZ457JHf8S4GdWDYtHlTILQ/St/QQaLfFOODThDGT6K6Q9y+rCjN5AChGmpyE/l87i11Fvr33SRs2NROLGru4PkfT3+sXLh9y5lX/Y6IXIR6M5p2j965GCz/2ftZ3Z7Y6b6gPU46VnqAbJGdMDxONxZ90DnBrkjChqq1cREKcpWwC20lFCYpfcIHe1C4YibIg2pHi0nKx4fkQxB+qlXGbT4NiUBmEvU6EdECqo2kMHMe1ePkFGqj+11CDhfucuhjThBwKPWwJHBVS1JF6DKEQjIZF7TDQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2234c60-17dd-4bbf-b366-08ddfb9f28df
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 19:18:36.0538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KIP3lECSbNyOe49+MsJM6Sx6x6hjl1M/jgl/eQGAAkWGoc48LeMzf4PfpLlREeid5jVaXLifn3LxYXz1m94WGANSFcTmdV4uItXqkpe3jU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0995E25F6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_06,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509240168
X-Authority-Analysis: v=2.4 cv=C5XpyRP+ c=1 sm=1 tr=0 ts=68d44416 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=TyyRbFsuskegGI11J-YA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mBXr4_ociUl745oQQYxbsHFftRfBCMbW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNiBTYWx0ZWRfXyF+oMeBqFmlu
 6HwdlWibBYh00NfuKPFDded/6EO8mJaXhzWG9MLoL+NrUcexIiFkfJCvKNLaw6c7PcKgisHXpIq
 8TwacDwLYkPM5U6QEJE6pU9ObbTeIctCZ6lGk0mjpqYu9mJ85ffrqyJDkiakI7gXSHdcl8LpD0i
 OlTVeBPY9KYIJ31bLu3+q332zkKymqcbKK78UHraCOiNGYdYFvHL33/o2K7cHC/dqJIBZb2AkoE
 cYxvuVjkGQg5VreVDocQizUiMxnpA+fkmZ68HA2uQ1ozeLQpZdtfhfXDyKWo22+eUI3hf2IkBhS
 pGPycBKpTSUvDKCI3UAuJeeMDYeaASfLeZ9icQI7DNMv7Ht6JvLifXGTr7FBnqlkK7GNxQ8aKcd
 9twLib0V
X-Proofpoint-ORIG-GUID: mBXr4_ociUl745oQQYxbsHFftRfBCMbW

DQo+IE9uIFNlcCAyNCwgMjAyNSwgYXQgODo0NOKAr0FNLCBBbWlyIEdvbGRzdGVpbiA8YW1pcjcz
aWxAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIFNhdCwgU2VwIDEzLCAyMDI1IGF0IDU6MDXi
gK9BTSBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPiB3cm90ZToNCj4+IA0KPj4g
RnJvbTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+DQo+
PiANCj4+IFsgVXBzdHJlYW0gIGNvbW1pdCBmMTAzZGY3NjM1NjNhZDY4NDkzMDdlZDU5ODVkMTUx
M2FjYzU4NmRkIF0NCj4+IA0KPj4gV2l0aCBwYXJlbnQgcG9pbnRlcnMgZW5hYmxlZCwgYSByZW5h
bWUgb3BlcmF0aW9uIGNhbiB1cGRhdGUgdXAgdG8gNQ0KPj4gaW5vZGVzOiBzcmNfZHAsIHRhcmdl
dF9kcCwgc3JjX2lwLCB0YXJnZXRfaXAgYW5kIHdpcC4gIFRoaXMgY2F1c2VzDQo+PiB0aGVpciBk
cXVvdHMgdG8gYSBiZSBhdHRhY2hlZCB0byB0aGUgdHJhbnNhY3Rpb24gY2hhaW4sIHNvIHdlIG5l
ZWQNCj4+IHRvIGluY3JlYXNlIFhGU19RTV9UUkFOU19NQVhEUVMuICBUaGlzIHBhdGNoIGFsc28g
YWRkIGEgaGVscGVyDQo+PiBmdW5jdGlvbiB4ZnNfZHFsb2NrbiB0byBsb2NrIGFuIGFyYml0cmFy
eSBudW1iZXIgb2YgZHF1b3RzLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBBbGxpc29uIEhlbmRl
cnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4NCj4+IFJldmlld2VkLWJ5OiBEYXJy
aWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3JnPg0KPj4gU2lnbmVkLW9mZi1ieTogRGFycmlj
ayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4NCj4+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4+IA0KPj4gW2FtaXI6IGJhY2twb3J0IHRvIGtlcm5lbHMg
cHJpb3IgdG8gcGFyZW50IHBvaW50ZXJzIHRvIGZpeCBhbiBvbGQgYnVnXQ0KPj4gDQo+PiBBIHJl
bmFtZSBvcGVyYXRpb24gb2YgYSBkaXJlY3RvcnkgKGkuZS4gbXYgQS9DLyBCLykgbWF5IGVuZCB1
cCBjaGFuZ2luZw0KPj4gdGhyZWUgZGlmZmVyZW50IGRxdW90IGFjY291bnRzIHVuZGVyIHRoZSBm
b2xsb3dpbmcgY29uZGl0aW9uczoNCj4+IDEuIHVzZXIgKG9yIGdyb3VwKSBxdW90YXMgYXJlIGVu
YWJsZWQNCj4+IDIuIEEvIEIvIGFuZCBDLyBoYXZlIGRpZmZlcmVudCBvd25lciB1aWRzIChvciBn
aWRzKQ0KPj4gMy4gQS8gYmxvY2tzIHNocmlua3MgYWZ0ZXIgcmVtb3ZlIG9mIGVudHJ5IEMvDQo+
PiA0LiBCLyBibG9ja3MgZ3Jvd3MgYmVmb3JlIGFkZGluZyBvZiBlbnRyeSBDLw0KPj4gNS4gQS8g
aW5vIDw9IFhGU19ESVIyX01BWF9TSE9SVF9JTlVNDQo+PiA2LiBCLyBpbm8gPiBYRlNfRElSMl9N
QVhfU0hPUlRfSU5VTQ0KPj4gNy4gQy8gaXMgY29udmVydGVkIGZyb20gc2YgdG8gYmxvY2sgZm9y
bWF0LCBiZWNhdXNlIGl0cyBwYXJlbnQgZW50cnkNCj4+ICAgbmVlZHMgdG8gYmUgc3RvcmVkIGFz
IDggYnl0ZXMgKHNlZSB4ZnNfZGlyMl9zZl9yZXBsYWNlX25lZWRibG9jaykNCj4+IA0KPj4gV2hl
biBhbGwgY29uZGl0aW9ucyBhcmUgbWV0IChvYnNlcnZlZCBpbiB0aGUgd2lsZCkgd2UgZ2V0IHRo
aXMgYXNzZXJ0aW9uOg0KPj4gDQo+PiBYRlM6IEFzc2VydGlvbiBmYWlsZWQ6IHF0cngsIGZpbGU6
IGZzL3hmcy94ZnNfdHJhbnNfZHF1b3QuYywgbGluZTogMjA3DQo+PiANCj4+IFRoZSB1cHN0cmVh
bSBjb21taXQgZml4ZWQgdGhpcyBidWcgYXMgYSBzaWRlIGVmZmVjdCwgc28gZGVjaWRlZCB0byBh
cHBseQ0KPj4gaXQgYXMgaXMgcmF0aGVyIHRoYW4gY2hhbmdpbmcgWEZTX1FNX1RSQU5TX01BWERR
UyB0byAzIGluIHN0YWJsZSBrZXJuZWxzLg0KPj4gDQo+PiBUaGUgRml4ZXMgY29tbWl0IGJlbG93
IGlzIE5PVCB0aGUgY29tbWl0IHRoYXQgaW50cm9kdWNlZCB0aGUgYnVnLCBidXQNCj4+IGZvciBz
b21lIHJlYXNvbiwgd2hpY2ggaXMgbm90IGV4cGxhaW5lZCBpbiB0aGUgY29tbWl0IG1lc3NhZ2Us
IGl0IGZpeGVzDQo+PiB0aGUgY29tbWVudCB0byBzdGF0ZSB0aGF0IGhpZ2hlc3QgbnVtYmVyIG9m
IGRxdW90cyBvZiBvbmUgdHlwZSBpcyAzIGFuZA0KPj4gbm90IDIgKHdoaWNoIGxlYWRzIHRvIHRo
ZSBhc3NlcnRpb24pLCB3aXRob3V0IGFjdHVhbGx5IGZpeGluZyBpdC4NCj4+IA0KPj4gVGhlIGNo
YW5nZSBvZiB3b3JkaW5nIGZyb20gInVzciwgZ3JwIE9SIHByaiIgdG8gInVzciwgZ3JwIGFuZCBw
cmoiDQo+PiBzdWdnZXN0cyB0aGF0IHRoZXJlIG1heSBoYXZlIGJlZW4gYSBjb25mdXNpb24gYmV0
d2VlbiAidGhlIG51bWJlciBvZg0KPj4gZHF1b3RlIG9mIG9uZSB0eXBlIiBhbmQgInRoZSBudW1i
ZXIgb2YgZHF1b3QgdHlwZXMiICh3aGljaCBpcyBhbHNvIDMpLA0KPj4gc28gdGhlIGNvbW1lbnQg
Y2hhbmdlIHdhcyBvbmx5IGFjY2lkZW50YWxseSBjb3JyZWN0Lg0KPj4gDQo+PiBGaXhlczogMTBm
NzNkMjdjOGU5ICgieGZzOiBmaXggdGhlIGNvbW1lbnQgZXhwbGFpbmluZyB4ZnNfdHJhbnNfZHFs
b2NrZWRqb2luIikNCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+PiBTaWduZWQtb2Zm
LWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPg0KPj4gLS0tDQo+PiANCj4g
DQo+PiBDYXRoZXJpbmUgYW5kIExlYWgsDQo+PiANCj4+IEkgZGVjaWRlZCB0aGF0IGNoZXJyeS1w
aWNrIHRoaXMgdXBzdHJlYW0gY29tbWl0IGFzIGlzIHdpdGggYSBjb21taXQNCj4+IG1lc3NhZ2Ug
YWRkZW5kdW0gd2FzIHRoZSBiZXN0IHN0YWJsZSB0cmVlIHN0cmF0ZWd5Lg0KPj4gVGhlIGNvbW1p
dCBhcHBsaWVzIGNsZWFubHkgdG8gNS4xNS55LCBzbyBJIGFzc3VtZSBpdCBkb2VzIGZvciA2LjYg
YW5kDQo+PiA2LjEgYXMgd2VsbC4gSSByYW4gbXkgdGVzdHMgb24gNS4xNS55IGFuZCBub3RoaW5n
IGZlbGwgb3V0LCBidXQgZGlkIG5vdA0KPj4gdHJ5IHRvIHJlcHJvZHVjZSB0aGVzZSBjb21wbGV4
IGFzc2VydGlvbiBpbiBhIHRlc3QuDQo+PiANCj4+IENvdWxkIHlvdSB0YWtlIHRoaXMgY2FuZGlk
YXRlIGJhY2twb3J0IHBhdGNoIHRvIGEgc3BpbiBvbiB5b3VyIHRlc3QNCj4+IGJyYW5jaD8NCj4+
IA0KPiANCj4gSGkgQ2F0aGVyaW5lL0xlYWgsDQo+IA0KPiBEbyB5b3UgcGxhbiB0byBkbyBhIGJh
dGNoIG9mIGJhY2twb3J0cyB0byA2LjYueS82LjEueSBhbnl0aW1lIHNvb24uDQo+IFdvdWxkIHlv
dSBtaW5kIGFkZGluZyB0aGlzIHBhdGNoIHRvIHlvdXIgY2FuZGlkYXRlcw0KPiBmb3Igd2hlbmV2
ZXIgeW91IHBsYW4gdG8gdGVzdCBhIGJhdGNoPw0KPiANCj4gVGhhbmtzIQ0KPiBBbWlyLg0KDQpI
aSBBbWlyLA0KDQpUaGlzIHBhdGNoIGxvb2tzIG9rIHRvIG1lLiBJ4oCZbGwgYWRkIGl0IHRvIG15
IGJyYW5jaCBhbmQgbGV0IHlvdSBrbm93DQppZiBJIGNvbWUgYWNyb3NzIGFueSBpc3N1ZXMuIFRo
YW5rcyENCg0KQ2F0aGVyaW5lDQoNCg==
