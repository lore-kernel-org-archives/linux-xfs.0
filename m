Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F723B7741
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785520982; cv=fail; b=QXSVZuPCe/8y/B7EYsYocdbK7gPg45tGvrMDDVA8gjspgE2Ni9ZEjJPoDJuIqBEo949bD3UYGVpWlW84ju7WPsK7KVzYhGVt/SP/1rSbtLArBBTIejSPjxUYi604b0+dF7ZVxz3h45Q25WJNEI0rfBSCMmDugsJKaijq+pipTDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785520982; c=relaxed/simple;
	bh=ZLa1WEtawsomfTpWolpECF/lLFy80Ns2QW57PRBwNB0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SwmYAyVX12Z6J4/ymYo1Hx2e/LtzTR7fS3Bxk6OIC7FOyRJ38P/cJ1RdziO7GwO8xGUmlfcRLXvsAl564qPRWQRrnK5TBCRfJTuDsIJBaq3dHsK0iQAReqTpQU+dzXCSAiWlx/onuD8zhGik4spg1OlppdFpBHudSiDeJXpSRF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CoLv5Gog; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u5iGoYgk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CoLv5Gog";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u5iGoYgk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VGb7t6641504;
	Fri, 31 Jul 2026 18:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VnnTk32H8TItZIIzG79EUu/iQ8YFlhUFJ3TRWiZl6nI=; b=
	CoLv5GogVT9Vn1p7Orp4Rmsd5ITskm2Tewkk/OI4XkonRcmvRM5RKbNL5N0gg3L1
	ZDxp+7XvMF9FoYQHNvXlIQLmJ8sECmeqq918n/iVuMWEqceBCGtMj8ZhTs4c2Of9
	OIGEDvl9/fa4jdz6YYwPgj2TY46r993Ne8TdenNV2Skxf1QpUp9AGu8t4AaVd86s
	wol7PD/qlsiA3MVv7nolCZF877UpEg+BqG/b/ZuSOlqg+aAlOiNpy/CeM9fMHoZ0
	0pax5/jWfCg5B60EExZPlxC+nSngKTouUKAJBwhFezKo51gUY6IxHFx3mhZvFznD
	hfkddJ3Va8W/5H+r8gV4rQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyykmws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 18:02:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66VI0cMt038734;
	Fri, 31 Jul 2026 18:02:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8nk6t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 18:02:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FgEQ1MhdH9IUYvrm3z9GsgOirGIfHLLqf+dD/UNpqRwo2TtYJ+koTS036vos0bDlu9QdOg0Fxv+FmPE1wvHSWnMk5OgBcuT3oTQNaMHsp/gXUswHdVHZvCewbNimUG06YpJMp5mIfk2Pxd2rfI28hQ0jKezqELHTQfhPOJz2SI6TVDZeN8vuLVKWG6nY55BHKWSydm0pwLPcoJwsfv5qpG+qGb0wR8XFsDz3dQt5b2GcU8dO2D4tlzb7d8QXw6fl/Scjk4omsxPvr9nS1gLGxyfE64uIkrLvT/CFhGKgUM+J6XSMH+QpeBLGMkhv6Pei9h1cO2D5OV1Anl6TqpWS+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnnTk32H8TItZIIzG79EUu/iQ8YFlhUFJ3TRWiZl6nI=;
 b=GHJRdnRSZCE5yozJ5PcEgnYfAbkRd9zMTQhAPD6SmVKtOnDRxSV2RQrR3JRKG5V7q9aIMFyPEJX0VeW488vJwD3rnTj3dWAt4hECofDa4f0aC+0cTF+h3DstioeBMPJPxznEXhomTj4j64Vj8Th2sQNXoVg6cZg88liS2f7i1ZdIFe2dLKDHmgSabLdDu4x2C1gah2qYtD/436FfA5JpKrxak4NtcgYIGFxuWvv529ElydOoH+aQDAJzN3fvv8gxgwm4LW8uyEkw+XBEtthYrSXEYkZLfJE1n2Q80JLng5J1vjfVrSIjw0gj2MqZ68jNxNwE7pZVO52apW6+W3pD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnnTk32H8TItZIIzG79EUu/iQ8YFlhUFJ3TRWiZl6nI=;
 b=u5iGoYgkQFEqGy9AAbNopyAGQyQZrTszjt/tFrZ/lSFEt/8gEXlmQtvX4SV7A8ek5HqppvbApIxwUg71Djc8g07eCiaxTiX8GqR9cZCWlGoLjcQElH2iooopjaK81Uw1umlkLWJMLSlwYR88qu6OYQh6cbyvNkByMpDSO6ywN8o=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by BY5PR10MB4228.namprd10.prod.outlook.com (2603:10b6:a03:200::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 18:02:52 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0270.015; Fri, 31 Jul 2026
 18:02:52 +0000
Message-ID: <920b94f6-9d07-488f-9a11-7e00f7f6612a@oracle.com>
Date: Fri, 31 Jul 2026 13:02:50 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 1/2] xfs: set minleft correctly for sparse
 chunk errortag allocation
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
References: <20260731163337.152522-1-bfoster@redhat.com>
 <20260731163337.152522-2-bfoster@redhat.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260731163337.152522-2-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::28) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|BY5PR10MB4228:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b537983-0326-4ead-dac4-08deef2df0c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|10086099003|56012099006|4143699003|10067099003|22082099003|18002099003|18092099006;
X-Microsoft-Antispam-Message-Info:
	ZHtVYirjo+gSHqbamiX6Huk1k1+zJ9BPXciUEAtZQaGScrcIxlICVBhmdXpouQDb2EVs+JPp7mh2tppLN5pYhjSqTkdfP5Rc1mSISB7qB2QZE03ui8PTA04cTv5fU2iwEULFsOxgggtqkqgO1oTf2RdQNXzF3SW6IHLlbOV0+arLgbCZHeh7mwgew7BWKejCPHoWufWXICoexzjqmJMo0P2xb7VUKVZ786pCVmJD9Z5C8jy4+T85b+s7ubJAbXhFUYwHDKOVTErVPukSwPhk5DSyeLDvTxCgQWOfccV/xf4FgEdH3wzU2PU6BvXVMTWkHNG68/DDmPZ7VsbY0gtfqH6jrwdlCJOVcG+VJSG4RkSXIJ8mVaaRyA4cQGA6qxYy+ozimlfNFQfSucervPQ9zd/ifZSJWvvR/QkHOlMh44HRdXD2y18wqVLbrihyD5IZ83znEfJHsS1A00PgO1AhSnWnCJDKSXciWdOMsH30i8Ir1W0eSMwWRhHwGx8OuLuOf2G4xIQBY+ORGK8hfJQOIPFNVymS8DCQYefMC2ZCedSWr4mC5hu5MlP/LCpSRiVDhzELk0HEq0eZTJMYt1hFJjRou4J9r9srTd7GjlWrlbTdeG178X0d7rKMuOYOdt0N2L9CBt43iY5pABG2VQ1ahONySeaz+9jUUtf5RV4yzjo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(10086099003)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(18092099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVV5bDYvWE91S1ZtSHBnUC9DaGhvNzRsNGk3NDNpZ2g0L0kvUTVISWdydnFQ?=
 =?utf-8?B?QmNPZnlPVlROWUVVQXJQZDlGaVlOZWtzZ0lIMUxGYjBxTzhXdXZRLytVemxR?=
 =?utf-8?B?OTAzZU5YZ3VmdW1XbW8zcllJVXIvNjREdlpYamp1emVyT3RWdlZwZFJYZGJt?=
 =?utf-8?B?d1dZUEVXaDB6aTFjOWdIWEtTZFEzejRCU0VDQlFRQnFSQWY3QWlCbmVvOHRa?=
 =?utf-8?B?Y1FpQjdBZ1JyQUI2MlBNVDkwT3d2ZlNJQmtndjBhVVRzd3JyUW51M2VtVUFL?=
 =?utf-8?B?amczazJha2RoMDY3YlVnRzJFQ2tMVEN2djl5S2U2SElXanJyTTNvYlA5WkNp?=
 =?utf-8?B?bHZXaWdleWU2UkxiMThsZnMxMEYyYkRmYzVWNXdnRmtBSTI4aEgxSjFDUlEz?=
 =?utf-8?B?TVhzVSs3RzIvVW5FbjV1TVA1eE4ra3dKNmhPVG1rdE91bmhwV3Z3L2tOa09t?=
 =?utf-8?B?N1RQM2pwemYxcGo5dXVPZGFZYURIazJpRWU1OWppU1l4U0kvNnNwUGk2U3lE?=
 =?utf-8?B?UHlYaHJuWEk3MnhCUVJacmx4a0ZTbkhNWVhFbENSUGFLbHZnOVhoY1cwTVhV?=
 =?utf-8?B?MHVDcnJnWFBYL1hhbVFpcGpOcjRpOEZEZ0k4VmZWa2RIc0ExWEFNOEdBM3Rk?=
 =?utf-8?B?K1AzUGhPVmlyWVJXUjVCUzY0V2hFQm5QZmZ0VW5hSzBIZk1Wa0NVTFQ0THYw?=
 =?utf-8?B?MmR2REEraVhWRFJGazAwNDlUUXV2NjMyN0cvajBVckRBM1ROUU1KQktqOVFS?=
 =?utf-8?B?Z252Ump5UWxOZ2Via3dnK1dxbjVqZVduK3FvMTlBeTVuS0p5L08wSlVZYU1U?=
 =?utf-8?B?cGU1bmdVbWJFL0tqakZrQWRrU24yd0xaaW1DS2V3aVB2Y1k0aHdyY3NBNmR3?=
 =?utf-8?B?VjdLRlo2ZVJnb21UQjNhMXNSUWJjQmFZVjh6VE0zNld0RG5tN1BXdERvWkxv?=
 =?utf-8?B?SGZ2WE5ER2lYbndTeTRuRGViQml3SVFnVmV0ZlNWalpJS1lCRHR1TVdVRiti?=
 =?utf-8?B?ODhZcFpuN2M4NGJyZ0JVaHlBd0NibFVvdGZUNlRGWWpQcTJlLzc4Vkl0Y2tQ?=
 =?utf-8?B?VllHSmErdkZBMmF6MmRHeFRRZnQ2RjJPTzhQbjQyc3VuRW80NWhoVTgrdlk3?=
 =?utf-8?B?SCsxWWtkSjlZTHVWQWc1dStHS1NSQ3oxQm8xendUbkZta2ZYWXVjY1RKUFhj?=
 =?utf-8?B?VCtKTTBTYTNkOXIrczI5LzFoMk9JVUxGUkdYVVFraGdEODRtUmUyeFk5L1dj?=
 =?utf-8?B?QjY1S2pSOVErdi9IUVRyVHN5Q05Zc2Z5WkE2eDFNK3NFdVFqU1VpdTUzalpM?=
 =?utf-8?B?emZjcFBSREl0aHdYdG1Xb3lXU3Q1eURqRUsybXRveDVjcFVyL05XRnhqcUxZ?=
 =?utf-8?B?V2ZHeEt3c2tqY0FlVnlDTEdYTk1OcXlYQmZWN094R200US9PQ0pZSXVXZXR3?=
 =?utf-8?B?V0xoNit6a2FYdklMeGhxaTNCUWtqZk1jQTNyQ1hwOWZMOUY2elJRQkFkT0N2?=
 =?utf-8?B?RHc5TWM5TGtJYURJSTVUdnNCTEMxQzFDL0Ywb2hkZTNjeWppcHlsZGZpMWpm?=
 =?utf-8?B?N2ZqMythZjhsVkwyNDk2MTR4eFl4bU5sYWJ2L0o4a0UyTnlLOVN3cWp5c2FR?=
 =?utf-8?B?aGJmOEZxdXI1VjUrRHRWbkxXVzE0KzdLZVYwcHREY2JPdDdjRzdidm9selFG?=
 =?utf-8?B?UC9ENzkrTmtnQzBPZDVKWDRIdk9LWUZvekJadUZTOW5IeXJwQ0kyekxpd3JR?=
 =?utf-8?B?ZXFpUjBrWXh3OW54L0gxUkYzWDBrdnNnWWJHb05WQmxNaDQ4OSs4aG5JV3RC?=
 =?utf-8?B?MmNFNmRuaXBoNWF1Y1k2MlBmWGVkWE51RG1uQllxalZOVGt0REYyNHk4ZEJP?=
 =?utf-8?B?Z2ZGbWlXNStJTklBQ0VZaUJoR0tMKzlhNTNBYjVCYjk2NHUvZnQxOWdJdTdC?=
 =?utf-8?B?Y1hERExiWk1RcHNoWjk2bVYrU093aGlNb09ZSmNtT2NtY1RmZk9tWS9ETTRh?=
 =?utf-8?B?WDU3SW9nZEczNVFXaFVsQnBRamFVRDNzNEt1RzJDSU13ZmxyM0tOQWgrNkFv?=
 =?utf-8?B?bEFleTdSdjZoNFJ2bjJ6OFk1M0s3eENNUHV4eFlQMGd1V3FCc0VrN1NyRXpT?=
 =?utf-8?B?cUJnUnJEUXRDcGp6VU91QUhaZ3B2cUp2N2RGNnlsc0RrQVNsc2pJUWgrVnJv?=
 =?utf-8?B?TjJIemF3THVRcXF4VTllbkg0QURKUk8rVXhhd0x4V050ZTlSRkcyYWRjcU9w?=
 =?utf-8?B?Q251TVVkN2c2akVWQjRSNHA3VUY5TjBzUkUwZ2xiYUxGeURxV2FoN1Bsa1lI?=
 =?utf-8?B?VE9Ka05JU0h3Y2d6VG1wTmRQNy9jK0Z0bVppalB4NW54SVFxNTlLTGJEanNx?=
 =?utf-8?Q?/3H2UWOr0lTNUcoo=3D?=
X-Exchange-RoutingPolicyChecked:
	iI4c9mZlnWw0EITQCFfSMoxKdKoL55sMX5pm9zqsog+pzXHSv8xZe3laHUVbm5ClnB1GIJwaQVj6xhNmF4fD3TgaJsd6BKzis7sq+xhw/sky6sPAFNGCeMGr+FXjdNnMT05ZTBympbSJSSL8xPL0Yd1c/BlfYNcv3hdEnWYr6q9egAf2PyzG8iZYbTYLN0YMO2MntppaRGiVKCoMoMvL8rC5ih1HjGItMtLvedbEEzKeVVuvKe0viQlk8u7Ik/SWAMVGQs9E6Wrkw7yv8nWW/yDl2NlxtB7Uv8LBamfpDCAi8VSO5jYffx9XLYTefZTWniAgFtku6byDkNqFPaon3A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UUpREEkDTFH+2P0h9qBIApv87PN1HUGtkv/psCP76FdBTk15Fs8xWsoZyG16i6Q5uYLqI3IBo2r3yemP6UaaxV+9/mU8lw0ZggbfgCruQ5BuNOWmWVaSQqTrGLq3otRsfzTJL8VsUZNcwIg4kCFD8VulWKwIdpiROumwEU0jvvKHtUtVZ5azWggBkDhEuYeypGK/ka1yM8eMY/vBKX/WnNlzr2hI/RmG8MHlmjENzBrVYnu1rNK4r8Tg29TrtKaQeCCPfYXPWYpjoJngJYPGcwTKK+LWSUmq9OD3MnWzfhXEaJZzqniNaZ/3h8AWB6D0E0KSRkAw/aBu3i7L0v/o23t0HmQhqeKZk47MgdsaPhWz+BpH3Zvtt7/BDzwEt08X7tW+xtfIzE8PTQrQM9CPlIS18HcQuIyWINQ09cfMsEJ5mal0lrPOtvewJNyXrGLVzJcp8rWIuKZSlZqI7+5EO6RwueIv6JB/4yIU2Bj4PSgSNiPPl8P6O/iNV3/K/sTtYTkIf8BDQ71R3++J7GNvLiaVt3mM1NqXxDcFtyunUUdb3QDaVrW+pDbsUJWyD5S0P/p5bUs+wD+ToqqrZySpOE9z4HS7P3KgOn7QwjSenwg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b537983-0326-4ead-dac4-08deef2df0c1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 18:02:52.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZySrWAFt8j632Zc6TvdT70xpTXn5vqo+tPq2MXCaG6ae0ZOgJHAHa9KOy5rcPZbym8gwDj3j6rAMgh3dDMGV4boVUqsi9PwVYcF6cnP6jY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4228
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607310138
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzOCBTYWx0ZWRfXxM5qH38sRhFR
 d5UnGkVijLFw4al1RQ44tYdqGWbmifYOkvOFjAnUwKPUgbDQKGVvaNNQt875N1hTBAgVrLxElxa
 gWVk/RhJ32swiAfNO8PhjCBYkAFbwiCtYXXC5q3YNNAPKDJY0z0X
X-Proofpoint-GUID: ODuolrMzAlTJ53jq1MmNDTvA6PqOk763
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzOCBTYWx0ZWRfX0Y6wsCGzpd6t
 7PAOsBZoMmLQ0EXOqtCBVG/IDOF410qlxg6ay87lsni53HnKlZ1EMFOsV14pdMaehor2+A0kkl7
 VWwXgIC9yDxxbG4BpKlpYvn5e2W6FN9RlrkohXEpZG09MflMiywaSPvEgwLJ9NQPKWKpzRAoyjs
 tDB0ION2CaPwAphp3T+QU6JWyqHaEbPUcPJHqPyy96act5DukAL4wvgo+Oo/IQyH1pizyrUl4Nw
 /3RZHbWcj0DzB2gX36ScJrx3NM5QF6ZNP5sTDc2+cdM99dcM0BLp+dJo/Vaowyi0HSgg7TvWeWu
 y+Bmh181oB/EQYc3ePjrkROG1qL5jSI/M9aGJhhjQdko/5yyBPIXVFmZWziXbjU0xOLzFi1+dCw
 kjZiQbwP1tBf5WyEKwSjoYIzdlFvKlrTOBI2aLRFmBicWRBbeJJfoX2MUmf4WmGYx6CCXwLiow0
 lBShZgGFND8pC134PogsDMzeOU0n55wGfyQcAFjM=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6ce352 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=eb88HGBylcnX9PyHZ8kA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-ORIG-GUID: ODuolrMzAlTJ53jq1MmNDTvA6PqOk763

On 7/31/26 11:33 AM, Brian Foster wrote:
> The errortag instrumentation for forced sparse chunk allocation
> jumps straight to the allocation path without setting args.minleft.
> minleft is unconditionally set to ->inobt_maxlevels for the normal
> allocation path. Lift the assignment to the initial args setup so
> it covers all possible paths.
> 
> Assisted-by: LLM
> Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_ialloc.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index ffcdd1f691fd..633b2d6e42c5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -733,6 +733,10 @@ xfs_ialloc_ag_alloc(
>   							igeo->maxicount)
>   		return -ENOSPC;
>   	args.minlen = args.maxlen = igeo->ialloc_blks;
> +
> +	/* Allow space for the inode btree to split. */
> +	args.minleft = igeo->inobt_maxlevels;
> +
>   	/*
>   	 * First try to allocate inodes contiguous with the last-allocated
>   	 * chunk of inodes.  If the filesystem is striped, this will fill
> @@ -764,8 +768,6 @@ xfs_ialloc_ag_alloc(
>   		args.alignment = 1;
>   		args.minalignslop = igeo->cluster_align - 1;
>   
> -		/* Allow space for the inode btree to split. */
> -		args.minleft = igeo->inobt_maxlevels;
>   		error = xfs_alloc_vextent_exact_bno(&args,
>   				xfs_agbno_to_fsb(pag, args.agbno));
>   		if (error)
> @@ -804,10 +806,6 @@ xfs_ialloc_ag_alloc(
>   		 * Allocate a fixed-size extent of inodes.
>   		 */
>   		args.prod = 1;
> -		/*
> -		 * Allow space for the inode btree to split.
> -		 */
> -		args.minleft = igeo->inobt_maxlevels;
>   		error = xfs_alloc_vextent_near_bno(&args,
>   				xfs_agbno_to_fsb(pag,
>   					be32_to_cpu(agi->agi_root)));


Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>

I got the patches backwards...I agree we need to increase the minleft in
the other patch by 4 blocks (2 btrees * 2 for the level increase) but I
wonder why can't a full size inode chunk also split the by-count and
by-block btrees and the inode btree allocation also be short when fixing AGFL?
