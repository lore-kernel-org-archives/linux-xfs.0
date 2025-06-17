Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9041DE4F3
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 12:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750161752; cv=fail; b=GyplfB1m98oHQUpWzyv4Qfcu5qTuo0YxY59djxs5eTsGqzDzYJqva/yGAh/Sl6vFuTVoYEZF767Wmc/vEl565bZWL32du58ywZlvboNbOs3OaRrSqIIchuOx6SJhCrCPQDJ0SpER9uoN7KjTLKFj4GPK6dyV9HqvQBuiVoC16+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750161752; c=relaxed/simple;
	bh=cUC/ktXvx5it3+hxZ3ebdClnXqbKBxmplOrGpr3yDNY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XIaDRcBLNOKFvu+MZmau8qAHKh3yeT7J7vAmlK/qntYiYRSM3Eh+ESjCZB2nO8Cqnn7qF4gL/YmrxOlNH7CJpSLfSZI+M0DZegIFrFmdbPKPE3kDwX2kW1lrW/wqmhuYlamKNr8kqS05RQOGAR7HvW5dVmdUOxY/FGEXyixdsTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KVhXYqu+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MjLwwDQT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KVhXYqu+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MjLwwDQT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H8ta6X015465;
	Tue, 17 Jun 2025 12:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wKBKnqCTF6jL0qzB2KopK6ECORvINqBy+q6VepF2pTM=; b=
	KVhXYqu+hhboFaGj5xCErZ8V3cOtpKHxnLZrLLKnUCTlxylHaRMMV9Ca/BrDguHi
	q1GDPXg86W1SwPGV30G4yGeoThYlkFaYymHGvmWGyAmr6xqlhrnpVyMT2s9Q50UC
	l84VTHBpuKKNC5N9ybq6VdIUDV5TUQ0O2p8lN/7o8NPecNkEYsnfWpPmwNc8D5Ad
	e6ER/4oP+zGadFGLnoPD7WeixloovyzaChcg8kxpIELO12W0ynIKoiMvHXsOzinF
	an1um/0bhS38nxm/yemeyrayz7lJESquNReL2t4fASx04NGdizOsHjqI9LffdlAc
	vtywCL2MVPqZSMqM53pOZA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479hvn4gv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:02:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55HAMxkW034385;
	Tue, 17 Jun 2025 12:02:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh8w45m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ICX6Eyc5taKTlpdaBOHrqvIpqo+oneAbkKqsCQFpQZqHYW985i4eX48eQmWElRIjYZVLM7eWbDLmrZfuQ9BxQis1oYRol8y6mxrBkykRIoZ9hZFIbXV5s0i1+GQu2T2c73YfknwzKDUQHwjoLOSSW8mpYw9nfqLGfzyT/AV5K0MtGBBcYY57rph5axgnmQQLI3cA8YvQpun9BIGcS4NAnTmpApi/DcK0cHCpzlNIRL94sDEOoqoTaLE84PR5AlAAU1xjJtevhdxnNLCkEDhoWBLUlri/2gXJigAii/OG5qV1QAOtNcoO+CNqrex1IR1Lq9kJfi2VFVnyyasgXdpFvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKBKnqCTF6jL0qzB2KopK6ECORvINqBy+q6VepF2pTM=;
 b=Pk0N+eLV7ov449gRF/jIkPiYSNgTC1TnQ3xNpzaiK2t/fqdx2bllOT1ju00CkknGhS+UXfQPjB1IJemJysXf1ogVTwVjOLMSahun//Vybp/6Eb1c/lJSPx7PX3WASlFbZsuokaRg+1KRFP5aWxUBeceN5wIphUhjTeYGEVf4MTKy7oz+ZQs19lcZi3mRGpIN6a8Bo7mjWp2jXhpBwMmflfQFaR4gqPewsBdBf1lT4jsLwUhDrFNv88uvxVn04wJLXb9VQzXwrNq44qZPEQrNBt1GVi/Wa8hwd0UrHONUrfT+Ftv9QLCDMFzefUnBvkYFc/Ej6gU06aqxZge7piubmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKBKnqCTF6jL0qzB2KopK6ECORvINqBy+q6VepF2pTM=;
 b=MjLwwDQTnBnhc8YFgp5dqChmYI9kVkyzeY2BhKrKjZyAUo2+ceEEQs3dqkxZ50s83N2nZSGTDF1+DSj17Ru1pW4r1cyLdn86YIOOeYGBf4T5bPQY+tHgw9Q/XY2CUIGBhH7j+8uy8CkMd/1GH+TAaiEzMyy+gZadZf50+2FlqkY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4467.namprd10.prod.outlook.com (2603:10b6:303:90::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Tue, 17 Jun
 2025 12:02:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 12:02:19 +0000
Message-ID: <1ef589fb-a8c2-4b2c-a401-a1e2987d21ba@oracle.com>
Date: Tue, 17 Jun 2025 13:02:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] xfs: rename the bt_bdev_* buftarg fields
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-6-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250617105238.3393499-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0319.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4467:EE_
X-MS-Office365-Filtering-Correlation-Id: dd987427-b521-4953-df33-08ddad96cf6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlUzaW5FazhtVGtkR29PVytPZ2RGcW5BTzBTakV5bVZtMm1reGQ5RnloTWJC?=
 =?utf-8?B?RkhtcG83N25hbnJDM0dDeGFwMWpLeDdHUlQ1WU1mcW9FTmE1RUtqZXJ1NS9M?=
 =?utf-8?B?bHdPSTRmMVY0RFJlZ2YzaUVuZEl3ZDYzNW9YdUU5RzNzZGkrR3pmOEhFMUhj?=
 =?utf-8?B?MUxQaDVwTFR2aCt3QVpLWExoeDhKKzllVXFKWVN0cEcvOUhpejEyYk4zaTh2?=
 =?utf-8?B?bUdCTkhKa2kvdk40MU11NGt6eHBVQXFxNjJPWXROZTcxcGJzK3Z6TkZrZ3kz?=
 =?utf-8?B?UXIxNTd0NllMTzE1U3hiU05Ga1RMS3luaDBtMkk0UU1BOTB0czgxYTZXTmVK?=
 =?utf-8?B?SFdYWDJ3NnUzVTNxQkQ1NWg0VzRmazNnL0FkQ01wdng5WWE2WWNFZEJ6ZllB?=
 =?utf-8?B?amY2ajBFUUtORE1FL0RaT3NYK0V6N3lwWWhpa0gxWjkxT1g5NkoySFBJc2RX?=
 =?utf-8?B?UUczWlRob1dTMS9vc1dMcnBRWFJpYlNKckF5UVBqUXgySkxobWY5bSsyaHhR?=
 =?utf-8?B?T2xHMUNuellYaXh1OGtsYUJreEJjR29vK3RnbWJpZy9tMnM1N3F5b0VnNm5N?=
 =?utf-8?B?SEdHNjh4eG52UDU1ZHRCUUZDRjBhbEx3ZzJ1cVZ6NEI4aC9EeUFZdWRhMWVy?=
 =?utf-8?B?RVUxdXdqQVZpZ21pZ29GMUt5UE1oSGFueGxYblJsOTJTcHY1aS8vZHhmTFZE?=
 =?utf-8?B?V2tPRkVyU254VTVRS0Y4TWRZNFlvaklhSDhVVHFhWlYrc1UveVhzWFMvcG14?=
 =?utf-8?B?aU5iVkh5WmNTM01LZXJaV2pzczJHZFQzSnQ3dnhadWgvYTNlczFmT28rR1dt?=
 =?utf-8?B?cmJKbHVyZnJCNkc0Rk9nRVdrN0w1WTVPeVYrUzNTMzFyWHJ1MkFacHBiTUo2?=
 =?utf-8?B?aUFkdy8zMXoxSWVEMVlCYkdac3FGSXlSU1ZzYStJMXNSVzhRZVY5TzErZUE5?=
 =?utf-8?B?V25KUU5pdzdma2RrMVFLVnhadm43a2p3dVJrdVZWNHk4cUdTSFlUQ0tVZFBm?=
 =?utf-8?B?bTlCQThaWUsvMlJKbVNnZndjUkF0V1ZYQkxLdVdrQ2dNak9FWGhRaHJhYWlP?=
 =?utf-8?B?TUdYVHY3Q1ErdjFWbEVYYUtRbmpUWU90d2ttc2tDdzNiRmlMaVdaenpwZXhY?=
 =?utf-8?B?Wnpwc3REVndVRndUOGVXSmVUTERTRHE1Z3hNdEcrZ25IZ3lwYXp0WUc2aVB1?=
 =?utf-8?B?VnRMcFU4MTFjaGlkTXFqLzRCaFpaT3N2SmVSTEZZdEsxaERjaXNhZjY4NTRP?=
 =?utf-8?B?aUxtYWRhRHF2M3JWaXV6TitHUnYzZ2NNWWI1ck9ENURuWWxCdlpXMHY3N291?=
 =?utf-8?B?OEdBV3ArY3pJdUYvcEFET2cwc0lZb0ptdUx3OUk4ejRzSnNkcFNtNnFGN09N?=
 =?utf-8?B?S3d1YUQ0S3NPV093M1FsM09ydGZ5M3JKZFVrVWJwVWtaM1BmMmJiQnZWOTJ6?=
 =?utf-8?B?Q1lWZlhXY1JYKzRYbmhOOGtRVE96a2FXOVZUZjB0bmNYMUpBK1NLaGx2VitV?=
 =?utf-8?B?TFdNVEVVeHJBdTNKeFZUT0cvTHdIWTRxZTRBYm9OUHptTW5WYnBEK2tKQnFu?=
 =?utf-8?B?OSs1ZEFGVVlQbDUvLyttMHhZSm15M1ROeHlJdCtSOVR3bTE2dzQ1WmswcHVT?=
 =?utf-8?B?U1Ywa0VPeXhnWkhJeUJ0YVFtRHJiL0lkTFpvQkY2emI5dGZOaWYyWThhR203?=
 =?utf-8?B?Y3dldFpRbkdBT2Iyd1RlQ1FyRUE0bCtlZGpPRi9DM245M3puQlZUUFVib3Q5?=
 =?utf-8?B?TUloZXV6R1B4aXVPMjczK1Q5SlMxVFVPSDBFTjlBVXl4YWFEaktFWnBOSzdJ?=
 =?utf-8?B?aGJVSTRYQWFDamVPM1Y2NEhnbEtQTEtCTm9KMnJMb1BGZWViekY4QTBjMFpt?=
 =?utf-8?B?SFI1b3RjK01oamozaWtWTS9QT0tXM0ZZZ1didVpkU2k0RlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OThveUIxVnQ2a1gzc1laYU5GdHpMWnlWQzJzSjJqWUhMTzZSbzBVbWxacGJ5?=
 =?utf-8?B?V3d0cVFCZnB5N2FwakczcnFXeVFnb2tSeEJUc29WdU45M29MK25rUVl6SFUv?=
 =?utf-8?B?NXpuNW1oN0UzcUVlMUlhdHZPY2ZjeU1BbXUybzMzY1MrV3Y3TktSUVlaMTdN?=
 =?utf-8?B?WTEvWWN2SGV3S0hFZU9IUjRWWjd4MjBxZVd2VkVKcTJMZlZTV2U4ZVRrWkZl?=
 =?utf-8?B?ZkNCOE12dnFXZFZST2ZqTm0rNSs1UVU5Z3lTN1FTWmsxZXlSZE13U0lvTmhQ?=
 =?utf-8?B?WXJpVXNTVzd3dm1GNmg0a1NpNmp4WHJaNU9CQjJ5d1FJMnNmM1VWUmRHektF?=
 =?utf-8?B?MlNJLzI2aWx0U0VyczdVN2hKVGo5N0gzQlZRZEQzKzU5ZEUrZGZ4ZlA4dERv?=
 =?utf-8?B?MUorbVJ6NThYaEFSV1JPTVpjdG1jejdvMDZESE9RWm1XZkNOaE1wWmxWWjRP?=
 =?utf-8?B?cDlhT0R6L3FyN2hzMTd4bFpncmhWWVUrbTA0WGloRVE2NDBTK2FjMUlWbFBM?=
 =?utf-8?B?cDdyNzNMQ1BKWFJ1L3BGSWFMbnEwVkJZSTNBQzV3U2s5SEFUTkRmZkl3MldK?=
 =?utf-8?B?dUwvdlFiSmczaVZQR0FFVXIvQno2SFFxUnVMTnhXb1NraDk4aGRCU210a3c3?=
 =?utf-8?B?c203RTQ2NWExb1gyMFlZdml3SzRqaVpaZGhKOENWWVZZdVlRTTRkR3hQTkZQ?=
 =?utf-8?B?Sm1VR0luVkpOQUw1dHZ5VW5LMjMwcHM2dzJLRk5BaW84UEhQcm5QcXZ6OEtG?=
 =?utf-8?B?WmRXcDRkQ25Fa0UwaGZmR09MeHZ1cDk5UnlPeld0bXpxQ2hWb2RmOEg1Qk5t?=
 =?utf-8?B?dHJBOE1zNXZ2SXhFaVZjUzhxWEluc3pPNWFrbHlxTWVFYmVtZ3VUV0R5dlZG?=
 =?utf-8?B?ZnFDZUlEVGV4eHdDb3dKalg2eDUxRmVTMXlmRDZlTU1NMTIxd05rM0w5NktV?=
 =?utf-8?B?aVAzcUlIK2tRaWUxZWxEQitIamNNWEhoamxPS2grZldPL0tFdmcxOFN6dlZU?=
 =?utf-8?B?OWlEMTVHSFo4MnVTL2hGaXRLK2tQSHFxSllMa0haaWRWUTh0UTdBY2c0VTQ4?=
 =?utf-8?B?N3R4UEkxb0ZwWFVRS0UwVTlVMk93R2lpN3BWQVoyT081WHF6OXNsN0w2YlZC?=
 =?utf-8?B?RGRNckUvWlhEZjhpeUcwVDBDSHdyL0ZjSFZkUG9NOFNzOVRscUVqWWR6b2FS?=
 =?utf-8?B?Y3FZTzlYTk8rQ25Pby9Rb1Rpb29CREM3RERQZUJuRHh5UG5lUGdoNlJMU3Vi?=
 =?utf-8?B?ZDFxU0VoUENIUFk5QTNzb2UvSTUzSlYwRWROUW1XMWhLYXBac3NRV0xQOUgv?=
 =?utf-8?B?akNGOTlMRXZzRzVleWsxVjZiQ2V3QUh1bDJPdkNUNkZod3M2K2liMHNBK3po?=
 =?utf-8?B?aEwxTlRSdlRyQUU2K3dXSURVZVhqR250MXpWUFpPd01wQ3pPU1hFQ1MvTVpv?=
 =?utf-8?B?SGJLQTJaNVRZb0tYSlhNNWhwaU4wVzhYbmk4RWRXZzNqdnFxZno4cURIVExW?=
 =?utf-8?B?b0FocHRaKytoc3dpRlI2c2NycDREQzBqa0FRc2RqN3UvMTFSV2FCR2xETFJ4?=
 =?utf-8?B?TlhqeGU5SkhMenM4VDUyT0xqdUNyKy9lSTNlaFlKYmVWSzVESUtyL0J5T08z?=
 =?utf-8?B?QUdTejNROEZLUWk4SVB2bGdBKzhvZmV0ZThHV3FzYVJZNkFRSjB6dlFvdHZu?=
 =?utf-8?B?ckwyQXdEa2VWMFdpRmpyc0NvVWFwR1FkU3VLa3Zmdll5MThMcXpHY0RqRnVa?=
 =?utf-8?B?Nm9Bcm85aU5MbXY3ZnZYbW00dUpkRklxQ3NlOXh1NUJnOVBneEdHaWJ5bTkz?=
 =?utf-8?B?cWk4ZXI2cXdEem9CdzFKYlFLcmlLeUY3emVTSHd5TmdWR3Z6ZkxYaUlXTWZV?=
 =?utf-8?B?Ky9LbThGMjhaSmdFYVplUTE3UXcvb2dFbnJUWWZHQ3pSQWdBZWp6ZDFtd3lt?=
 =?utf-8?B?WDhzTU9VUGZ3YUJVdDBaOSt4VTA5SjFLakFhbkVWM0ZoYndoOXVxTFY1VnNz?=
 =?utf-8?B?V0lxalUxaWh4bGVUTHlEeWNIdTcrU3hzUjdDNlZHblJXSGd6MWlkUmlWaEhC?=
 =?utf-8?B?UDZnZUFyL1FEYnlnTHB3MUk4bUVUYVcyTmM5anpqUGg3MGhhYkI0ZFpxOFZa?=
 =?utf-8?B?Q09HNUtkZlBYbnNZUzFPa2xHNkVJVTQ3WEFJTlFqU1Z4N2F5SFYxcDlvekN6?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KoHsp04v180MZIlU7aTUVfDgT3t6GdmOqSIxTN2C15qPxWXP1b4hnTz1npZ4E/lLdaahffks+31JYhKjpBfw38sJZLnLrRQBmwQ4dTHPK08Hs/axxf8ztKcSfQIORXRP5yARxKgsmt925uRgdHBY3AvqCOhFu1UHo6IOIdZPTsT7+MU8HHfxRbKrryL6eeEbkVBFBNaZKb963II0ypgbPNXsglM3K2RDuAJ1EELBaQbhqvZvKmo+UN5URfZR3TviZP6DAeTq7bfPoiTxQRgikmKhxZi52y+vSjBGEDXKymJ8wnxs7fbn/q+tzTgFzVyUJOuRkQmX/juzzdhBpKAsiLLrpeosQDWFPCL7jCR6EZZBPut6w6LYg2E1BtDg3Udcl9AVZqKojYoACZ8xmnw8Q7VnAoP/oVl3Wzwdk0H40/EeyATCVvjS+1H3MxMx8VfD8Ah+Ab8qQcwCHDqc9Fq30gSxOfqknpxZyKKmYmZuo6VnP3ZSn7/9assqvcdXSYTRjjebYh5F/Ce0oFQHABs8bmTtMlco7l1uAyZF+x8tMuJ66wSXk8ZWPDfDY0xJFmfTA9DeOTH8P1NhJeDVjcXx5gXitGD3CI0E/OyqBjc4woQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd987427-b521-4953-df33-08ddad96cf6a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 12:02:19.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYJgcGUwSPChYRf1ly9qoCQZP/3STUmm1VVU2mS9E6JgnLT3/9YoAZ5jEY1Qvmwk9gZ9LbDLJWOaKboddW/lkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506170095
X-Authority-Analysis: v=2.4 cv=XeSJzJ55 c=1 sm=1 tr=0 ts=6851594f cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=JSc41u3GlQv8eGceNjkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: boIjQ-91xe-J8WTr3sTLxchUvoY2xztS
X-Proofpoint-GUID: boIjQ-91xe-J8WTr3sTLxchUvoY2xztS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA5NSBTYWx0ZWRfX0+0ov0BXq7XG /OuqWHX0nlT1JyfRqt8txUy+jZmUzaZ2v47U1pK/faQBjIP+RFw+4hWfuBggpt78KwG2CkFfzA2 b7qwtwrFtcMMUN/6zWlaZlDljEIAZHkKjmWHSD77YHoAnk8eclZxP24JpBNEoKRJ7D98go0unfC
 vTdXKTREVCTsV49agFfkS48UnBajBdlRWHCkk3eLPQ0e/wZah2IgB67dD0KhBNLb0uF1nWMyQP3 sU8oySV8Hvr67M828RLPBbEZkFr3+PPoX8ZAalk4Zywvor/DMy9Per9qmwqXzP/yQL6tdslVsVQ MD4MC1DHrpcRru8j6VMqMjwxSuLTwEnT/FxojHwCMc9opLwE80V/nejV1r9Y2BCUbDynQ5n1aSt
 gNChteRm8BGkRhPbdWUIhr5uVysIwbBeYjrldhI0oVGWuMQX3GSwOERk7TlOBiZbJauea2dw

On 17/06/2025 11:52, Christoph Hellwig wrote:
> The extra bdev_ is weird, so drop it.  The maximum size is based on the
> bdev hardware limits, so add a hw_ component instead.

but the min is also based on hw limits, no?

I also note that we have request queue limits atomic_write_unit_max and 
atomic_write_hw_unit_max

and bt_awu_max_hw is written with request queue limit atomic_write_unit_max

But I don't think that this will cause confusion.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/xfs/xfs_buf.c   | 4 ++--
>   fs/xfs/xfs_buf.h   | 4 ++--
>   fs/xfs/xfs_file.c  | 2 +-
>   fs/xfs/xfs_inode.h | 2 +-
>   fs/xfs/xfs_iomap.c | 2 +-
>   fs/xfs/xfs_iops.c  | 2 +-
>   fs/xfs/xfs_mount.c | 2 +-
>   7 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 0f15837724e7..abd66665fb8c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1712,8 +1712,8 @@ xfs_configure_buftarg_atomic_writes(
>   		max_bytes = 0;
>   	}
>   
> -	btp->bt_bdev_awu_min = min_bytes;
> -	btp->bt_bdev_awu_max = max_bytes;
> +	btp->bt_awu_min = min_bytes;
> +	btp->bt_awu_max_hw = max_bytes;>   }
>   
