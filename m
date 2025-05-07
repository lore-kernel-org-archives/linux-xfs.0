Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB9E25CC41
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 12:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746620647; cv=fail; b=RbSVS5R53l5BNUmjMffwrZzReR6jYKeG/v3yiOmmom+MvTR6xaj/TYrE3wY/r11lr3Xi8BmFrILVTvAll3qgwCqA5JwBreadjohtMr38Lov0wag6uzTJ14jbIXRe7tPagGQ7eGeD6H++RzqwIYnV4OXtseUZMQX2onFpayta4T4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746620647; c=relaxed/simple;
	bh=wQkYrpacS5ZRJcau61ianSqUVq6xFiUnAXv3pH0PGQE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iBF1ggPTJ4VnoKvLVCWqbmDG0IZ8X/iZ9jYhwI3UNYdCvEPr1C098Wa3vHXUnaRHdONrNYoTHaL8BMU5XMCK4q0Qk8nKffIkpCtQuxpE1s64Va9EMf11oUyqZR5lKgpI0cJS3oVsdwUK9KkAu5VlgJjaLf0cgoVr7xDDkqjGXtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Flg8TvwT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yUtwtvP3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Flg8TvwT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yUtwtvP3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 547Bw8Di011127;
	Wed, 7 May 2025 12:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vjk+nUlzZgaAiSLC4xX0xzx8DXkx5NONyzQQrH7+e64=; b=
	Flg8TvwTpIu2crTetjhU/it3jVl+tgapz4KIFm/omHKH7/PxvSYfjylK/rAYzY2+
	8MYxjQ7beXiRjoLVgl8kVnnA6mzY41qKhZwo1RQUM25VRicCeUPgMtIPkZmqcf7y
	uX13Wn7vUbqfI94Lc8rQfYwtJ6ooAxgyC1KwDU6RXO0wJF2WUwafLlojazApSVbp
	wv6uF1NVxhSRxEbghl/MYYyIULy8aM3cVqeW1EPIDlgyEC8r40kVjXcXDiI9RlZz
	r8nbi7mAgt1+7m9fTR5cszoORi2gzlq+oTYF0GbwWrGH3boD7c+5W4OOzQyx0qvv
	Kg9m0KAtU/F3M7eb613yFA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46g73jg20x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 May 2025 12:24:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 547CA2on007326;
	Wed, 7 May 2025 12:24:02 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013076.outbound.protection.outlook.com [40.93.6.76])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46fms8x4kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 May 2025 12:24:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PVzZw/7/Lt1B5b+FngnVLLxzOLAwJoq7RivOt0S/TOwCWWPGsFbYYjXY9HDxe6AAaNAdQDgV9tuwgvZiZtdy/T+qYeKrF0SVnWnbHMnEETuZB4d4Rj7kSbgQ6ea91o2TJprfGyvFtIgnDxHLBkwiFm4q6QR/3NqUtfYGmX9v5TKA+LJEd1e6shxPI63j5GHtI5VQ7Hzo0AJFShw3QaB5MP22CnS/XIvUa2CD90qFo9RuWT6b5s/c9AdqHMoAgOevw2sQMYzmPlNeoUE2/iqRL64L4/SUu/r7FiCIaykJfz0vKh7uEyt6RuVRPc2WLm19MhLz5fMbqzpT0yiH4mY+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjk+nUlzZgaAiSLC4xX0xzx8DXkx5NONyzQQrH7+e64=;
 b=xQKzOdWW0FCxSarjcirWSZvB0wrlMLOm6q7V/USt3h6ayOHKBw0EC1vvaQC4O+/BWswZz+WeYOOrGCX3QZlDqIQgZI3qiJls3rsixiJrF4RbwTXEDR9z+oyoIw0pKsc39rBfTMt8B+ZIhzHVQEDymEC3v/V4Nti62EMeVgDHQOFU0cyinYhRVnUbTFLAEcq+mFj5v8UiAkmmPJOdBx48Zk8wi5dnEHiEXdxJUgU9wYcl2n+Al8gejRlmugToPo0oKyJnzCnuFRd0YHO4D3abwE2MinBXzL8g3StRggjBJgHqHhXruqkFs+censnxvr8MCWo8+rZJ3vmvmSnWBU1Mzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjk+nUlzZgaAiSLC4xX0xzx8DXkx5NONyzQQrH7+e64=;
 b=yUtwtvP3oLgSCAeamXR5/zN62eeUnvdwz+XZJuV1t0q4jC3YphEj4rLZxa+jygQkk13p0aqZs9pJu2xNmfcu1e8nTQE3nW1oWMPq73Ph/jo8wBSnavTeESDqR+V0tVNSKPF+WNl3UCQj4uBII9ZWpSlP1ew2JJD1hVSddklR5LU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN4PR10MB5655.namprd10.prod.outlook.com (2603:10b6:806:20e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Wed, 7 May
 2025 12:23:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Wed, 7 May 2025
 12:23:53 +0000
Message-ID: <431a837e-b8e2-4901-96e7-9173ce9e58a3@oracle.com>
Date: Wed, 7 May 2025 13:23:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] large atomic writes for xfs
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
References: <Na27AkD0pwxtDXufbKHmtlQIDLpo1dVCpyqoca91pszUTNuR1GqASOvLkmMZysL1IsA7vt-xoCFsf50SlGYzGg==@protonmail.internalid>
 <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
 <cxcr4rodmdf3m7whanyqp73eflnc5i2s5jbknbdicq7x2vjlz3@m3ya63yenfzm>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <cxcr4rodmdf3m7whanyqp73eflnc5i2s5jbknbdicq7x2vjlz3@m3ya63yenfzm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0089.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN4PR10MB5655:EE_
X-MS-Office365-Filtering-Correlation-Id: 356e4568-a6ed-457e-9d66-08dd8d6207c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWFjUlFhWXBHYVh5YmU5YVl1dUhMUVhrMmRYWjBSZ1FiOHhLT2MzVG5MMElP?=
 =?utf-8?B?b2dzcGdwQ2lwaktqdXZWR1ZzeEVvbnAvMklOcGZ3Wm44TTJDRGxuVk4rQjFa?=
 =?utf-8?B?SnBwMk5DSWRPZytKMXFWNktvbllQVnlZRUphcERPT2Rid0FKbDFSUjBTUVdX?=
 =?utf-8?B?Uk1pdUFBNzdReGlEOVBZL3lvSnU5eVZQRVpOZDBpYW4waEhiNmQ3YzJiNnp0?=
 =?utf-8?B?Z1NTaXpGRVNSek92dWNrTUtxL01xY1VkWTN5b0IweFN5YVBMbWx5WjdZc01x?=
 =?utf-8?B?d0pjUVMzQnVmdEs0aDVOZHZzN3dKaG5JR3BnVXpCOFZUNzkzb0J3dHQwYzBN?=
 =?utf-8?B?d281UG9tVnBDZnd1UEwzQXR3U2tRQWlPL0RQQm96NUx2RXlSdUowb080WUYx?=
 =?utf-8?B?N0JnZUp5WC9lT2VDd2lIRmJuUzlkSmtoUng2QjNXcjlhckl4UlJYOCtZWnpt?=
 =?utf-8?B?MDhSbXQzZ3huYURIQ3ptVTJrNEM4emdMbXFTMWUrMXo1bkNiSk9hbFNEU1py?=
 =?utf-8?B?ajJaNE1wVm5FSk5CU2hGY2NDTGhXSEZ3RnZ1Qm5Nb3RSZXQ3SDFTZkNXMWpL?=
 =?utf-8?B?L05MbXB5eUZrbjlYN21MS0p5Tmp3Qm4vekwvaGREN3NLekRuQWZLOHpIdTBJ?=
 =?utf-8?B?Y29QazQxdFhWUEhJWVlMbUZCa1M3TERac2p1VUhGZXdMZTRZNldkeE9COTBv?=
 =?utf-8?B?eWFzNXNJNDlEMVNKN05pbGZ3S0hEUm1DTFVIMHpzMGVHZk5sL0IvWWRaS3Jh?=
 =?utf-8?B?MHkzT0F5N3ROK3dJU3RRMlpGZ3o2QVhsY21nakxyK3I5bks5dXliVW1odGhP?=
 =?utf-8?B?RmhRRjlkd3pWR1RST1JZakxpTVBGcDdqVjlwY2lKYVZkNTdaQnVHaklMTnlB?=
 =?utf-8?B?aDdlYXpwR2JYcDV2azN3bzlZT0pQSTdTOWIwTHVCS2lWTVdhRTlHTEtxV2xY?=
 =?utf-8?B?Z3ovWjE4OUV4QUlNL1ZDbUg2aTZ2Rk0wZEk5YWhORUZjN0JPdEk1MkwxY2Ex?=
 =?utf-8?B?eEp1aUZJZmlhRWZSVUxPZS94LzV0bXd2RTVzN2Vab202Y3o1K29wLzR6MVMx?=
 =?utf-8?B?L1lXbk93S2dGY1h3Tkw2VGFwZjMzY1JMcGM3d3dxeDVWLzdLTEZ4bzhJcFR5?=
 =?utf-8?B?WmUySFIranVmakxKUWxheE5kRlV0djNpQ1RTR3JTV0pjU056L2p1QUFrWWhG?=
 =?utf-8?B?dXZGN1hWRWR1RlJpSUN4NVVxUVE0OWxVZm11V0hzSkhncmJYc0JrWDBIaWp5?=
 =?utf-8?B?WVI0aEFzWHVUQ2llMFEzRlJBMS9FWVRaUWxrZ1N2Y1RQa3NZRk5YUisyM2s1?=
 =?utf-8?B?SU9ISkhtaWJzLzc2YmxkWGR0UTJZcERZSVlXeG5lOERKdWh3YnFkKzBYRERr?=
 =?utf-8?B?cExXdWRvN2pHQTlVbDUyVm9IQkxYSW90cmxjS2NaK2VPb1I0ckllTHJvM25r?=
 =?utf-8?B?YnV6ckZoeGp1WGNhaWFVZGpkQ1FMNmtNbS9lMnlvYlplS1dVODhiOFZMSGhu?=
 =?utf-8?B?ZGdpVVUvMVh5SExxNUlKSWVtQmVHZFlqRVpUdk9kejJ5MWtOYk5tSGQxMFFJ?=
 =?utf-8?B?bmRVakg2VEY0TXBXOEEySkVpR1c1T2QyVU8vSXliSVFMMi9QMzRpUEx0UDAx?=
 =?utf-8?B?ZlRHdnRNWVdZRmRMZGRVYWdHRGNZd0hzQ3JVN3NzaFAxTDV6dzFvbTNUdXlh?=
 =?utf-8?B?cUlwQTVhaCtPR2s5SkdpWFk2VXNwSWwzRW01NmVxWS9JTjNJK0d3ZHkxbHR2?=
 =?utf-8?B?Y2JyWWZrbG5aRHl2eFNOTHEwNmRYWUk2d3N1ZGhmREZWUU93bzUyWjVQdjR1?=
 =?utf-8?Q?8RrsTnRX1zKQgTTlZF8uJ8Ni448LT7yjX2ILk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2VOYUxMeVh1bEYvcHIxajZjaEZDcDN6VE91NXIvN0dnRjFodHpUc3pVT0Zr?=
 =?utf-8?B?bUJZY05wMCt5RlQwR1grVW5mUUJyQldHcElKQTNWRytZS3RLZjlHa1ZpNWcx?=
 =?utf-8?B?V2kvSHR2VW9QcGsvQktwMGVVOTFySjJJejVWVEg2ejViWjlxMDZXSDhFZ25m?=
 =?utf-8?B?Mm9JMkxJRzR3b0tSZnNsbmJxSVQ3d3NCd2JaVGVGNmZveml6NUw1NS84bEhl?=
 =?utf-8?B?ekM0bWwzd3I0Q1B2T1Mwd3hjR1lrZ3JtUVVPT3pFNitGZXg5UTZWZG1JZVJw?=
 =?utf-8?B?eDJPVGJFdGU1d3UxWEtMMytITVMvRjg0WmM3S05tb1FyNndkWHJRaHNzK2Vh?=
 =?utf-8?B?QkZ0djZueDRpWHB0VUxJMDM3aENpckY2L0RaTWNqdWNmQVJMSHc2ZXd2blRK?=
 =?utf-8?B?aUlrc3NjQjFBSEpTZVpvM01mUTZRZ2JrVDhzcWxYbEhRWmRVNElrMGlLTEE1?=
 =?utf-8?B?OFdvcEYvRUNUZDdENFhPWllkd3B2SVlnZERrVlVkaURUU1BieWZVa0JIRE5O?=
 =?utf-8?B?elU3SXdva3R6Qm9tcU5ZRE0ybnQybHE2b2ZTaXB0aXhRY1JmRTRzb252RG0w?=
 =?utf-8?B?OGl4VmRLbjJ5cFRzaUY2YjZtVzFjSXRLV25YZ1lnZlFLcjVnQUxCNVFnR0s2?=
 =?utf-8?B?QXgzRElkVTVobnVHSS9OSGdOYWF6V3dVVzhkeWJmUStJdG5kblh4V3VTSmQz?=
 =?utf-8?B?eXdnVGtmamdEenhjdkZnSDJ2dFRlZG43QTg0TTJ1cndpU01JZTE3TWwzVXpB?=
 =?utf-8?B?eWZRdXBaK25CTzJWUlZ2OGVNK3dGQXBvODM1dmlKOUVCM3dNenFETjB6V0hT?=
 =?utf-8?B?Y1ZnNHpKNHJ2cTcyOVlrWHFyNmpCOFZuZEpoZFZCN0tuMm1GeU01NHNvRlRW?=
 =?utf-8?B?ai9KcmpMOEt5aHlZNStUT0dwTkFHRlhYeXRjZUVoa29tajFOSEFvdmZPZ255?=
 =?utf-8?B?N1RRZlU5WFlJV0I3TEF2VXFCcXo1eHE2bXV0M3VWQ00xaTZEQjUrcm92eERa?=
 =?utf-8?B?TDZtQnJTcSttZGNETDc2clM2ZUdLR0FNa2NYb01UYTRFV0FIV1JWYlg4aG9t?=
 =?utf-8?B?SzNVa21jWHF4YUQ3QW1nZG1FdFNFcXRxempTemg4Q2lMcUVqMHdaeG90OTAz?=
 =?utf-8?B?a0czNnZVbXdidWcxc2Frc2tIV3pveTVBS2pIaithS1BJZmErS2RUbVBZSW5v?=
 =?utf-8?B?WXpOdkNyYmpYTzVtK0RuSTVjZEdOSVlRb0xxaG5HM1c5L0tlV2hiSld5elYx?=
 =?utf-8?B?Q2V3bmgzRzhPOWlGSnhkdG9jWUNSeDRRaG9WU202bk81OTV4TnJBVzBrSHRy?=
 =?utf-8?B?V3dQNjdldkV1SnVUOFRVMzh6MHdsUWVIbU16WTc2NG9VQldyejAzZW5NOGdQ?=
 =?utf-8?B?TUdsNEFua0x0RTRwKzBla3c2OXJiTEl5eXYxL0JhWEpzVmNZeFFwYzlGd2xp?=
 =?utf-8?B?ekl5U2VObzRSRnRuM3V2SjFUUlNPUEF0RUJVOEk2NHNJb0xCeVhjUWlMcnhM?=
 =?utf-8?B?d0NMTEZBWDlYM1kwTmpqWUR6SUw2UDVDby9kKzJBQ3ovK0I0WllZYU1VQzZP?=
 =?utf-8?B?aWl4SXkzcTA4VDk2M0VpWWxESWdzN2NWOVNNMzJOd1RBYWpPWnN4U2ROa3ZP?=
 =?utf-8?B?VkpOUkJZWWltMkFIcUtWOTJHbGRVQVVyRllWSXBIcXBnUWdwNkc1OWZ5MUVm?=
 =?utf-8?B?TWNadVd1ZnBSdmFDdHFIdDg0YnRmY1pYUkk4R0kzMlN0YmxnU2VuNTd4TVF2?=
 =?utf-8?B?cFVOcTRweU5qUGRLc1BFbVdHaitWZHIwMzdyOTIxVXJoUTVwSVptYkY5UWlV?=
 =?utf-8?B?SWkyNjgrN0pGaHl0dHJKQVlNOUV3ZE9LMkxZb2srb045TTVxU3F4Z002RWJn?=
 =?utf-8?B?KzJtWGpaUVRML29Edkxxb2laVVFOZmQwUFZlR3dZdjRpSysyT3Q3TGU1YUpu?=
 =?utf-8?B?YURndjVGRlBvZVlBUHlRQTNmdFVCSHZ1ZUJqNEdhdzVSMktzYmplZW5CSmVy?=
 =?utf-8?B?YmNNZk55UDRvVDUyakNIbEwwZGZwT2dlZG9TaW1PcHRiY2ZNb0ZWa09DWVQx?=
 =?utf-8?B?TFJ3R2luMHhsSlovYXVxb3J2S09keGtzVGUwMlpIWTRzeHFwdmVXWS9EMWZK?=
 =?utf-8?B?NlpML25xbDdXS2p2S3BxRGtlVHc4Vk96NWR1SnI1ZEF6aE1DOHNGeW1CMkUy?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mO8HmpUad3FYbReiQmZ8BEqK1JjPKUqJPd5yghuoQcRAeRYtbpP+2sDveOZMiFUQTKGBVQkzTuKxL0SGeZC81JDx2X354yGpEa6+wUDtG3947sHzGyv2WP8GyjJHQsdJEzARCWap9u7mW/osjsu9xWrJfYInh7TStuGVCYqD8CwRNCybxnSHDNRCj39ayx5rddrW5yxWwufQ6xKmq97hsGu5dNmU0y7XEvRIDKm9lWR/ZVNTdL2ZwDM43yxGD62zH+QutwuFF2e2nkGFAmSRI4hXKqNCrAWtOjgM35Wt0s9s1ME4aaGcMjBGKqYE23UmRoEsTwSsHvXX1Zgb12QuXzzQieFGQXl+4rB243xYNXyQ8KrfH2lPjibX3779Zf2ajCE1bw38naW3KKbIjfkVmsaKvauIzMTmgfZMgj3bL1mPMloKsta9ORfrLzI2CVQQ9zAsArSKZlB/rFv4nXszPENvZf+WXIZJAAQSrw5Z3vsf2bPbiPFyyXwmXp/0vezL4Sn0KZENNLdC0u8pG35aThzuqzcXYumx2Nnwrcw6CRmrSft/Op/1TlybgPKmT0vHLPktsHNGoo+/aBe4Cnh5R5vlmpE/KMelcs7jSOZye0k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 356e4568-a6ed-457e-9d66-08dd8d6207c6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 12:23:53.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cz3b0LEoqmVf7cCf30/P1TK8JAex2Hrt9ajfGKzKwIv1Bc8J3fPC8UqqtXK05cvfol8AslsccUf/YWX7b+NxSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5655
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_03,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505070116
X-Proofpoint-GUID: 0VoEmJOjT3fbSSiabNl_Yghu_85fLCEi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDExNiBTYWx0ZWRfX6Aw5YctpeY4P xczfuTmt1dV/ztYzfbOzM9qsWO7YUyDa7huPvZMGVQkpRwPzZ7t/a22XPpUpUTknOvVuuQL+G0a nlyEujXvyyQFmPayPBrDcWZi76o18fbAjsE2VF5nHGugwNy2nJjw72jzeScTpR3lzJfNpUMrrr7
 NfSfggNGA2Uw9XKYAOEKbYcETgZ6eWH2rI/3jszmeCqORZs4RXK79chc5DnLtlMj/hFAV++qakY FofU+heIoXRm/un3LNMmRpXIVCNLuiQWBMZbKbAbDDyGiA7a4MOvmASKR/kV/Qrz5o8Wp1BWjv1 4VQUzINbP9qsg6b/xNGOgGt9U15ShCljsF7tY5kTbS7Bp1F4Dy8Zc1iFQO2SUBtBthI+dYg+vji
 0XU0i41XnTKQrwjOyqrI2fC4LAscZaL4kR14Y/7MtrDFtMA8g2/KViO0uoUw5y5zuO2tKUHj
X-Proofpoint-ORIG-GUID: 0VoEmJOjT3fbSSiabNl_Yghu_85fLCEi
X-Authority-Analysis: v=2.4 cv=B8C50PtM c=1 sm=1 tr=0 ts=681b50e3 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=NEAV23lmAAAA:8 a=mIr4kLEhlV4t150zHkEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14694

On 07/05/2025 13:14, Carlos Maiolino wrote:
> On Wed, May 07, 2025 at 01:00:00PM +0100, John Garry wrote:
>> Hi Carlos,
>>
>> Please pull the large atomic writes series for xfs.
>>
>> The following changes since commit bfecc4091e07a47696ac922783216d9e9ea46c97:
>>
>>      xfs: allow ro mounts if rtdev or logdev are read-only (2025-04-30
>> 20:53:52 +0200)
>>
>> are available in the Git repository at:
>>
>>      https://urldefense.com/v3/__https://github.com/johnpgarry/ 
>> linux.git__;!!ACWV5N9M2RV99hQ! 
>> IVDUFMxfAfmMgnyhV150ZyTdmIuE2vm93RuY0_z92SeHSsReFAeP5gbh3DA- 
>> iow80_ciEVx3MhZ7gA$  tags/large-atomic-writes-xfs
>>
>> for you to fetch changes up to 2c465e8bf4fd45e913a51506d58bd8906e5de0ca:
> The last commit has no Reviews into it.

I'll add it.

Thanks
