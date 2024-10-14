Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2238E145B2D;
	Mon, 14 Oct 2024 09:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728899859; cv=fail; b=nbzv/kpi7CxWAvsIc8T1l2hS0LmA3Jp5qOZeplkPaESdTVRgdcurXh7qGYa2CHOWc9AKve1YTUwIzZzeQ70ANUqXj601yZ2qCOv+2XBN76/j8ACAGdKewiU1lX7AT4lk118hkqLjVLNkmK5+PS4ZB4IJ+9d5wpq7bUlMUH9vPV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728899859; c=relaxed/simple;
	bh=MWBFQuEM5nMOM49bt9c+oWgnInykPLTYW7gusvZOREw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bLP0RS6aAf1ZFFro1rqhq6QScR0Yi3bPxXnH1sHGvWqCC25kKugpleS4e0sYYRk5zKru0JhH1tOGvRTQ/A8NhotyVQF1LZ1fJ38m2+6lKAy/VDvre2ao6oi5Wwbg23z5DA5yHYgFqQGShFOnMTdxOqiHVZ+puRKJX+ZZtP3TYZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ctzxp9Cy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t22Qfh1D; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ctzxp9Cy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t22Qfh1D"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49E9uCrN006629;
	Mon, 14 Oct 2024 09:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PshMXJ2gnEyz6H+ZF9Z9YI6ewMTvy/gnaBlGA0Q/29g=; b=
	ctzxp9Cyv7h8w2Zrc7quXH1RrxP5cEIFrpYZWWAL+ugINT490kkpqZ+RznbdAPAJ
	HNHIx1VZDsUnYtb2WiL/+XvuZ6LvryJUDHhPrGdT+dhbJZOIFb/apR03zv3C/G/T
	WVAlMuYYeZFMr0jKLD25wbXX72jMrUxVi36D19PCQN0JCYLcSYGrtfBsauC4IWKf
	fiLkC1I9x6KVoRoux1aPEXdbCa0SQGuoHMaCI4BXTfsxeJTF9QUrkVkEf6dB7LTg
	dWrlzAdh5em1Z8IkrWHkLXecOVjkGh20c43tY0Xn6uOjv0Ja0kDCdDfGgc07iE7V
	qJesVSAuK0X6kz9JinOzOw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09dkgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 09:57:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49E8tlep019863;
	Mon, 14 Oct 2024 09:57:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj5vh2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 09:57:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7BEyAk8osxtklNbSl60XfCaan8x/xYSMUwZd35AjolN0ff/y5viUZoM9yZpeA4tLDt9/QI5UzIXbuKlShhB/eHekzOHDK8cBSG/cQYNRz1/NhGXzZBApsLJcP5oLrB2gOPhNTK/G5ewYpaYEEaZteZQeQ7Oe1Ho7z/MnQOcb7T42UHToJS59t69v3oQaFqiI5ejhzvL5jG4xFAL5wnOHFtv2GDYtHwqK3NwKNzwha6HxBXcxU7OIslsUjp36TeGcFBc8M5LDmaVzt+oh87shEZNRebPuiX70SZ9irrAZWI6MKzlcm8LTeG8LOM7UsaIK0EUMjESmluN7xTtQ9WX5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PshMXJ2gnEyz6H+ZF9Z9YI6ewMTvy/gnaBlGA0Q/29g=;
 b=sLwRrMIbY+razDccx7piT1FpvPusWcAVE0OJWYFF/tJyPZet4yzxeH71SAkzsbjMJiCczCK+CUeOs4NU4T4d4juIydBzicAinq0JXWYpUUdGpSndYkpPdjBVr1xelweK8KzzUNVJ7y8p4AFgB0qFdbRfsel6RUYEGPFUvGULPX52k9ZJ53p2p6fggPfzOQUJX2eWDZtzlC32pHqGe49oWs/iKQ2CrTvq+EO8152e3ReiLt3VWnARo666oYBlmfRNyCUzIy2fLp88O99hK1GpJXFKkXVRNWe1FUlewQZRP2K42U00eQ1ojR4Dmhp3UENGW/BaoikSbmliHdY1ORd+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PshMXJ2gnEyz6H+ZF9Z9YI6ewMTvy/gnaBlGA0Q/29g=;
 b=t22Qfh1D0f8xhxQLqc0+p3SdgQE/CTknpK4vZ9/8xYYYZAJW0jBEliP9k0+GJBr/q0eGYgenQ14uLTjU8nBiMC4QXCmZrurRU366JuSn3UTNYj45MwPEfc8tB6T2kdq23SrXPs+7EC+KrtzYGu8Bg2pP6OroJGJNR4bpneXp0S8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 09:57:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 09:57:01 +0000
Message-ID: <a940924c-5e04-43f1-81f9-1d164fd384cc@oracle.com>
Date: Mon, 14 Oct 2024 10:56:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs: Check for delayed allocations before setting
 extsize
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Darrick J. Wong"
 <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <20241011145427.266614-1-ojaswin@linux.ibm.com>
 <20241011163830.GX21853@frogsfrogsfrogs>
 <20241011164057.GY21853@frogsfrogsfrogs>
 <ZwzgFTX7H35+6S9U@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZwzgFTX7H35+6S9U@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0096.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 188b3e98-8f00-43d7-c81f-08dcec368c7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clhOaW84bldCNkNYZnhrZjVVOEhOVWNndjQ0cVp3S1JSK3piSU1uQ2wwMHlI?=
 =?utf-8?B?cWx6U0Q1TjJNdXZRSmdSKzRQM21nZjNjaHdoTklrRHdtUHM1UmkwY1FRNE9Y?=
 =?utf-8?B?RFFibEhhcDVvNHc5TFFjTjMvclAyK2xFWW9yV3F0TUptY2VPcjVXVkovZVlO?=
 =?utf-8?B?Z2YzYmpIV2xRNnNHUE1oN0JqL2ZZUERSMnJZKzgxOGE5SDErTE5xaENZREZN?=
 =?utf-8?B?Sm9yQ25jcWZkcXdiQVpCTHduZkF3RFo5L1ZYRGZLc3Z2d1FnMGJFYmUrMElX?=
 =?utf-8?B?UkRKRjRoNk91Szkwb21CZnpjenVZZW85UHlJVnVQeWlFY0RGVnNCdUlNOGQz?=
 =?utf-8?B?bjUwaEhVd1lZZWpQd25TWG1kMzZtc01CQmJTOGFkZyt1aE12ejBCSEtFTHRH?=
 =?utf-8?B?K1dueFUzOFNwTElFOThJbUJsS2lRdWNkYnZXWmVLYXQ2SUQxOU85b0tpWW9M?=
 =?utf-8?B?TnoxVjRpazAxcGpXMnJhN0RwOXU0eG1SVjdSNVJDM2RpbjBwQUdZN0cxaWNr?=
 =?utf-8?B?d3BKVndyU0FTY0VQV1pIcWs0R1V2V2IxTDMzc0xLSm9haFNucHFLSXJtSkdz?=
 =?utf-8?B?NVN6TVRBbFBLazlhbUpNSVRRNGFZR1VSK3MxcitqWkxQeTYzU0E1bXczWXN4?=
 =?utf-8?B?eDVYQzA2RE5kNlNQcXJQczl4cndyNFBTcnJhZWtHMkxwQ2FQMEdzTWE3ZFE3?=
 =?utf-8?B?cWhXR2M0bUg3cHdTeXVMSUwyL0JiSzM1WlFJN2toSUxuOUJRaTFJRDhGOXlh?=
 =?utf-8?B?bUxXTXI3VGhyT3RqNUo2aUhybmswWE5BQis1cE13anEyOXMrdjJqSUQwaER5?=
 =?utf-8?B?U0J2d3lTMm1vNDZRYUxqcXRtWVlkSE55aHlvVVNUcWM5c0pNSUVGVmRTY1RD?=
 =?utf-8?B?ajJPbXR3UkxTSGZPc3g4U0ZWZnRzZjZwbEhBMlVBdHlSTkxoZGloQ1preEMy?=
 =?utf-8?B?RklacjMxTnAzeDY5dXZmSDRnT2orbXB6WGhCc2ozZ2FrT1pxUHN4Z2gyNlox?=
 =?utf-8?B?QjdwWVIrNHlNcWEvT2FUQ2pJMnFJb0trL3Q5QUhtaXB0MVBYOEk1UkRvclhq?=
 =?utf-8?B?eERYTWI0Rzk0UUJQRko1Z0hVUHVmSDRXYlBJbkZMRmh5bjFxaFoySkJsNi8v?=
 =?utf-8?B?d2xFZGt3L3E3czBsRktJclJsL0JrajNEUXp4U05xbDk2UWxzd285R0pFYmZH?=
 =?utf-8?B?OGtMN3JkdXRIMXZRVTZ5WS9EVjdvUUowMlhKOEkyTkhvWHNrcGUzczFiYkox?=
 =?utf-8?B?a2lPam04RzZUc2hwcHl6VlhJbGpRNERlbjhsOXczaFROUVE2dEJHZzFKZHhK?=
 =?utf-8?B?bHJDSnpiZ2xYZkdaYTcvRTJQa3h0bmFaUGhqNVJJMFdBSHNxV0pOZHdiQ1dl?=
 =?utf-8?B?emQ3dGppeEhpZERqK3VvVUdUUzBYcmU5TTNsZ1NpWHA1M3NLc3I3VE1sVExE?=
 =?utf-8?B?S3VvUXNSY2NEUkF0QkNEWEVNeVZYK040SFlLWVJIQllDb3FjMGh1UjQxYytF?=
 =?utf-8?B?K0pGT1pEaWJEeUJ1YjBnTU1SQ3BwYzVjaXRwT3hnUmFLeVlITHhJSEZZU040?=
 =?utf-8?B?TjMyRnJNcDMyUklzbXZrZUFRVGdITmp4SUgzOE9MVFkrYzhhOC93UTlYKzFY?=
 =?utf-8?B?Ukl4emR1cXpVNzdxRDNUeGZqV1NaVmRoNnZQeGpkNUk1Zk15ZCsxWHIyRDFQ?=
 =?utf-8?B?M1RpOFAraTZKV2lOSmQ3THU1bjVscllsVlBLTkVjdzc4MTQyQTBQdytBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVF4MURjYnN3NkMrL2tOVXdSbFZnMXB5b21qQWdLSTJVT0k1WmJoYTB2ZmJ0?=
 =?utf-8?B?bDdpZHh2QWJtNEUyZS9pWWJsT295enFRcmhST3NrbmRNNDluenAwWDZDOVlw?=
 =?utf-8?B?TFJrRFZpU21jdEtYSUtLSUw4UnlNVkQvQzdYZmNxV2JuaHRDaXhTcFR6aU9a?=
 =?utf-8?B?VkxDbTNvdmlZby9jZ2VtNzZSTGw2Z0hvaW9JM1hpbDRmV3RvRGMxTG1vMDVZ?=
 =?utf-8?B?ZDhVRmxGaW1QZTNRUXR6dDVtaWJhakdmbkZTeVhFNm85VUxyOGR1V1ZpaHdY?=
 =?utf-8?B?MGw0QjJGck1sdXd2NHU0Yi9NUmQ4ck9FYk1IZk5LeVFYcmhXZEtucDBEcDFp?=
 =?utf-8?B?bDZNWGt1YlpOVERBV2JoQ0cza0plR0dSRzd2ZldyZFhXbjdCZjZ2SSszVVZS?=
 =?utf-8?B?dlBzZ1JlMnFQcDY5dTVwMjZMTk00VnNFU01uS3B2Sk9xVWtxRDlPdldONmsv?=
 =?utf-8?B?Q0QyUUFOMDBKVEczYVpoV1BGRnJTdDdaOXZ2SHRTY2VFVGJJakJzL1JqK1RD?=
 =?utf-8?B?dkhMblcrdlAwUDRMWWJYZ2kvMG92cWhmeWh0ZTJIS2ZKWm9tUW9KU3c0T0Np?=
 =?utf-8?B?SFR3SUtyeHlLR1UyRGhCb082OWFWOWpJMFdOZThFRWg3eS9kcXlJMndrYndz?=
 =?utf-8?B?eDVYUXdLb3lVcDMxbWJ3SWFYQmxWOUpxckZpYktwM0M5OTZRWHVKT2FnWVU2?=
 =?utf-8?B?K1Z5ZUNMbllaRlc3YTM2VVBIVGpUd1hvN3dTaTEwYmVYRHZJeTZWMlN4VWZq?=
 =?utf-8?B?bndiRE1OOFJNRmMxUmcwNEdKazN1S1ZMU0VqbkYyL3FZaUpjcFZKUm12cVhC?=
 =?utf-8?B?eWY5VnVVWXVZcGVLN2NUOUlZWXdWT1AzSFlEWi9kdVNWaU1EaDFxL3pEVGJn?=
 =?utf-8?B?TE1tTmlWb1QrK08yVWlPRnhVNkx1dWprYXRhTkREQVE1ajkzcmZ6WWxqMnp4?=
 =?utf-8?B?cUVyRHJta2xkem5qUmpEWlhXdy9neGN3eC84UTFsRWxYT1h0b2tIdkdBTy9j?=
 =?utf-8?B?bENTQ2tVb3lZY2pkM3U5UnphUTBCL3hFWXg4UHg3bDFKa0JmK2hXMkFjNGtM?=
 =?utf-8?B?TXdVTzhRbDZVZUE5and0NFA2bUhrWERoeFRLK1ZScmdmUjl1TjJqVGM3aUps?=
 =?utf-8?B?MFowQWVMUFpOQnNuL0hib0VabHltd0J3K0t6ZThqeGN6SEtMejlLQVp4SjFv?=
 =?utf-8?B?K0xjdGg0eGRBcGlnNit4U1pLWFhqY0JuT2xOaVZwRkppWm5jL1RTODBkQmJl?=
 =?utf-8?B?RTErU2V6SFdFZFQwTTMrRnhwNVFVREZGWk03SzBGeHZHNkdrUU43dUFMNnZJ?=
 =?utf-8?B?YklQZHIrRXdsVXBQTy91aFIxT3h5MkM0UENoMUw3UUpXQ3d6VWFSZGhhUXVi?=
 =?utf-8?B?R1dWZHNLU2ZlVXM5cnB6YmkvK1pYQWlnZTE2Y1FjdEJiV1JwYTVZQlZZZ012?=
 =?utf-8?B?ZTFrRHdaMWRnUi9Kakd0U2J1bEVsSHFZdFRZbG0wL1BsYklKZy9Fdm9Jdis3?=
 =?utf-8?B?aFZmNmtkSUlQTUJobFpsNDNXVnBOc2owTFl6eG1qOEI2TytRcnJtTThWNnhY?=
 =?utf-8?B?RysrSk90bE4rWFNJYmdyTm9QWHRTSXFxN3h6OHE3ZmI3OUYvRm5aNDlCRlR4?=
 =?utf-8?B?bGgydmp3QU44L3VjSkNzT1ZScWx3Z2R6ZC9vYkZvOGFYb1BFY2JiUWJ6NkVo?=
 =?utf-8?B?WDNUc0Vxa00rMEpxVVN5NGtlVDdzelZzYzI1eXRRVi9Xc0RoZkNWK0lHQnNp?=
 =?utf-8?B?dGVwSlhkRmxzc0M1R01Sa20yMTYxOW1BakMxSVFlUHhWZ0wxVm5vcVFtZ00v?=
 =?utf-8?B?OW1HaWlNMFp3SlNIWUhiaDNFdnFvY3dOMzloN0tHU0hRVk5JTjVUK05XelFu?=
 =?utf-8?B?M2hheTQ3VkJKdHJIekpMMlh2OHF6Y2tDRGwrUVN0bUVLV3BEaHJRQUlIWHF1?=
 =?utf-8?B?NFM5UTVwVzRITDZjb1NsNVhDOVEvUk9nUHpXMGt2bGRLc3VKQTFJTWFWN3RQ?=
 =?utf-8?B?YmJlQjFTN1Y4VTlMMy9rMjhqUGY3UnRia0RtRE5Vajc2RC9tem1UNHZCQTlV?=
 =?utf-8?B?OEdiU3VMQVNTWmJNblM2eHM0ZUxWTmIyWVF0MnpGZGh2NWZRR2lobDZqRGcz?=
 =?utf-8?Q?dN9hCBd+2Y2kjXVyDzlgCgC45?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4HjsPk3BpmgaFnJA7G+iMRlYNUzz9gzaIJi8gEex6//tomgVjGRZeqWAVwtEYNuri5eC6o0xepCl7hDPsx3412xf70daA+8Y9clIUxd8fruZteUWVl28I7eThMZT0mMWkvRpmag/5XNkhpWvp2XsUx3KP6pXONmVz90bzBjWNluzhDnITnoAj6/a8h37M63B0FmGGoyrvQb7TnrHLTEfsVlG1ocLOnvqinEeOzsoHkYF4ctEki0ioDFH89HqJZqwWTK8KdI0ikby9YvVYR0agN6LOI1Aorkv9InX7xnLIVcBjrY52nNvOe0s3R5p99xen3SZ3SgvHUYdYy/NLqHDtoSHVJ+tTDdGrF7HOD3ztDjVIaQmaFowzsBi+HiVZWpvaqHeanBX8B6H3Fae+Kh3IL8ns0zzzKNNIGwTFafUfWntB6R/oe1H0pPnuV3Q9Z5ytMIX2MnSCTjKkpagTIOEn6VFVjbJuhoH1c0VZs30AL4tOn/mI8PJPEx1oC/KNYVwG6F7oxfJ1qPyhoG56pV/iR5eAIgNSI6VBLaBqqPY0clmXCvo6k7KA/ftmVXmcbL2DtHz0pb3RjeqwMai41XX7eeb8MV6XU9gE1Rp6vrdxkE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 188b3e98-8f00-43d7-c81f-08dcec368c7a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 09:57:01.0999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7Iry1FhlILqXsHeUxdO4NmbO3GgGf08zv6b7HdmAbpaeVOIk9CYj7eKPI8CK3NCqcFvKmBr1yiQkcczDFn+9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_08,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410140072
X-Proofpoint-GUID: gwZR90p_bXN2qlB7NRRmCu7zyFXMMb2-
X-Proofpoint-ORIG-GUID: gwZR90p_bXN2qlB7NRRmCu7zyFXMMb2-

On 14/10/2024 10:10, Ojaswin Mujoo wrote:
> On Fri, Oct 11, 2024 at 09:40:57AM -0700, Darrick J. Wong wrote:
>> On Fri, Oct 11, 2024 at 09:38:30AM -0700, Darrick J. Wong wrote:
>>> On Fri, Oct 11, 2024 at 08:24:27PM +0530, Ojaswin Mujoo wrote:
>>>> Extsize is allowed to be set on files with no data in it. 

Should this be "Extsize should only be allowed to be set on files with 
no data written."

>For this,
>>>> we were checking if the files have extents but missed to check if
>>>> delayed extents were present. This patch adds that check.
>>>>
>>>> While we are at it, also refactor this check into a helper since
>>>> its used in some other places as well like xfs_inactive() or
>>>> xfs_ioctl_setattr_xflags()
>>>>
>>>> **Without the patch (SUCCEEDS)**
>>>>
>>>> $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
>>>>
>>>> wrote 1024/1024 bytes at offset 0
>>>> 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
>>>>
>>>> **With the patch (FAILS as expected)**
>>>>
>>>> $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
>>>>
>>>> wrote 1024/1024 bytes at offset 0
>>>> 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
>>>> xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
>>>>
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
>>>
>>> Looks good now,
>>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>> That said, could you add a fixes tag for the xfs_ioctl_setattr_*
>> changes, please?
> 
> Hi Darrick,
> 
> Sure I'll send a new version. Thanks for the review!
> 
> Regards,
> ojaswin
> 
Feel free to add the following if you like:

Reviewed-by: John Garry <john.g.garry@oracle.com>
