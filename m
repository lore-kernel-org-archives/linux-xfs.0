Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A087714D6EB;
	Wed, 28 Aug 2024 08:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724832389; cv=fail; b=bld6V57MAyAekFzuHWL3WIQCp/2YqJN0Nck4ibhVEbl93qw6CgUUPopLO1RRYlYMRI+UP1jfyYYP1qCJiaI+GCnQP7ugsdc8bgrEKbfjKGvcV4LnoQ6OYaW/My+3rgi4g90AnT7QIMp8GqhlE4mtJiJMph/k7ifEosT1mDg1d+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724832389; c=relaxed/simple;
	bh=ivrATA5hBpyjNplm4QBw9msVbJAG14PKP/L2FNHA5SY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uJl+VJKSHzl1cc9U4/ELvtWyyg8TPHriyqJ7N1q+qTPF+/KKBQDbMFZ4NDxl5sfWBSAl96q18lKoxzJ0v4YlQBtOuQV+dUJDGKgw4YSNZWZS3CUZCxWiu00sSSqxkL00I95FTphXtDed5HFWtp+FsnFMxhLu/Agk8CBMPkwlDPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ICfP4qsm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hRB5we/T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ICfP4qsm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hRB5we/T"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7tTRH016534;
	Wed, 28 Aug 2024 08:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=ua3+OPo5/D4Aotd2D1XKtMa7Gc5kg+tWRR+Nz0dGleI=; b=
	ICfP4qsmZnA0rL6D/cg2ALr2M91qSOaFOOLvkJt39ZB6FFC2UIEJL1jgsYIEsM3C
	et5dB/77VSQa/HbixVDcGy3J1JMKFFqXgPGKt/GqdgYbsdApGoOuylEeJNZfMuih
	tyI9NNIxwy/ltsv7tDM6sCGXlsuQv0GSKeufso3M4tZdygh0HwyZjTQKgV/D2V2p
	G0ZO0pCrEAtZlNmoNPQKmHHvkR1cYE1R66HmmhYC4uc/cn6VR8VDzQ8O1l11SOX6
	fuecfar/jlNahi/CVAke5MGLcu//Bon40RGbTc7MKPrrbEsvD20P9paSBQrH726X
	pD2GAGgSYH75E1Py5tFNGw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pwv0pqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:06:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7kqrr031745;
	Wed, 28 Aug 2024 08:06:16 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418a0uyvnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 08:06:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rG1X5c2JyVuFF5HZnkSGiZ/ejcHdOh8grZaSmBn98tktE/meTiv7fMXpa1Kd8u/UIylxMKaowfW57YMd+G4eFIGKrbELHC4nlRFcCqKcOdc4KQQEQ1YOSMtxwilsme9dgJtv9RmMiVOndV2/Q0ju5qMPZ9B8Mmh9L+p4xhz20koC05GQapvcd4Nf3BL6o6R/UDUhV8v0oVDyZleaSvm/ULOpWQbmq1hsNo+WTvpitDhGT1M0dqo3PJOYjuYXsvguk2l8OnCGFhQbyRcerG5/mTYaGoVywcZl7n9b8RefDztQTftindNNkfpJrpgOFEqn2gxnp303DG6A48la3RgXsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ua3+OPo5/D4Aotd2D1XKtMa7Gc5kg+tWRR+Nz0dGleI=;
 b=sT2wB9uaow9D9H8mVza4V7wI/Qf9HzShXuFeIL5DfV5FVWYGVRdun6Khn/iBe9x7yJBt2XwujXfGS9yPqygTUfdgAFY5yUtybfdHAVAZzdErhKdDy3/uf7+xfABFfbsnu4kMlEO9iHxS+UyPbh1gxpvVSqrMqlHfdw0R1b5P0UsCkvcbP0lDvF1vAG4zrg7EP5zEW979lfv3nfozVq4Q26AnoCk/DOYlDvgQ98oy7S93gLw+jQd/cUHP16JMYHLDp/MSlCvxXlulPKPBaXH/kHY85iRvGC5XPnJz/2zs7mmf+16w+QIoPvoa4V/80u/4SzFgG4P/RAOTmyNRGjB1ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ua3+OPo5/D4Aotd2D1XKtMa7Gc5kg+tWRR+Nz0dGleI=;
 b=hRB5we/Tzc8W1Zcut6FgGr5ekwRasOMuH97BQ1FQk9JU6Myg+Dt9sSw0MWcQMD2EkrttzQ0lWKsyr7dZZnFjpHSwJjrrTypGFPiDStj7u0M0DDiRxexh38hzpaB4H136v9tjgv4+BMFrMWziglm0yzYegd6x1SZyIQJOeOs0TOk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5846.namprd10.prod.outlook.com (2603:10b6:510:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.14; Wed, 28 Aug
 2024 08:06:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7918.006; Wed, 28 Aug 2024
 08:06:15 +0000
Message-ID: <3a7958be-d3e2-4438-a221-ae7b2cacacd3@oracle.com>
Date: Wed, 28 Aug 2024 09:06:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: fix detection of unsupported WRITE SAME in
 blkdev_issue_write_zeroes
To: "Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
References: <20240827175340.GB1977952@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240827175340.GB1977952@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0011.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 36ec7222-a69f-4b68-f944-08dcc73849a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFdNT04vSmkycWpubWZKWEdycC8zS1RZUjl2VGNnYVU3T0tsSlhITHdwUXFu?=
 =?utf-8?B?Z1h4STJjNm43SURiNFZsUm1ETGZGSENjU1RPVkJNUW5pcFp1Z29IcUZySGkr?=
 =?utf-8?B?Sis5T3pjU29KQWxqOUlHMGpKeVF0OVI4RTJ4MmhpSi8xK3gzOWpUVitNRy8z?=
 =?utf-8?B?VUh2SE9hcm9QbFFKYUhPNDZHVDBYS1lVbGZyTDM0ZU1oQXhudWR6Tm5Tekdk?=
 =?utf-8?B?aUxpeW5WbXRDSkRzR2IycE16RFB1Wmc4ZUhkMFNvR2lWb2hWaEQyU3V1bEdJ?=
 =?utf-8?B?UzdRUFByR0tUTEJjc2FnQVNUVkFuRVRnejVHQnNqSWZwbjM0V1R4b3c5dk9M?=
 =?utf-8?B?NnBsS2ZKcWw3YTAzMlVlemFsSFRkQWlrdWoxS2owekQ3N1dvaFNVOWlwU2Vp?=
 =?utf-8?B?YTJ2RFZzbCtaaVBwajFEL2tYdmE2S3F5SlU4anpqUzFQaklhUFplZXF4dEhu?=
 =?utf-8?B?NDlsV003VklpYTdXeUdaakVGdy8xU2Urbm9oczRUa0lUUGlUTEw4em9mWVFB?=
 =?utf-8?B?UWdXbnp4RmlVRkdhNlpZQTVpc2wwKzdHUlhjZWJxVGIzdXREYXM1ajJnZVZE?=
 =?utf-8?B?VDZMZFlmMnpUREtlc3kwbHJWY2VsZnZKdFdUNUkwTGVvUjdrc1dmNDQ1QzBH?=
 =?utf-8?B?S20rQjM4QlZTQnFoUllUNU5NaTRaZWFJODczRmk1SkZtejFzMlpCdGZrWmZp?=
 =?utf-8?B?Ukpabnkvckp1TDZITzB5VXozeXMra3JPRjY2TWZkVVBGV05QcWY0RFZsNXp6?=
 =?utf-8?B?SXp4b1pYMnFRWi9QdjFVbXNvQ3ROcVkyYWxUMExhTWdSOGRlNnNyOGhSRFVt?=
 =?utf-8?B?UGJBSEt1L2FZUmd2RG40SFdGS1U2bzlMSFRsbkwwUjZuVDBwOTRaMUdhQVlE?=
 =?utf-8?B?a2Fkam1OVmd2TXBKSDQvN1VvaGlJR21NOUZSVDd6aDFYYmVxU1FHa1NDUE1Y?=
 =?utf-8?B?V05uaVcycm9rWlJiMTUycFI0WW00TU5aYlozeHFMNTVadGMrZ3NqV2VuS2Nk?=
 =?utf-8?B?YWFGTDlmc0UyUmhETFJjTm15SDRRQ1FNd1ZzZm5pM0FSUzJINzM3bTdJV0Fo?=
 =?utf-8?B?WkJpV2t3RWFjOEwxZVlxdDJiM1hQOHByOHBzakdkM25aZmxSbzU4KzdaSU94?=
 =?utf-8?B?RUxoaldCWGhnanNGZENNYWRwY3lTYmhMbGh0YThOdE9WY0FuMTNuTlhHQ1lj?=
 =?utf-8?B?Z0g5QUxONGZyYm1KMUQxTW1VbU5rYnluQVpZdWdtWTBnUWNITWY2aUxTbXEx?=
 =?utf-8?B?dXJReXk1bmt6ODZUQ1A4aFZSY1MxZmd2OE0wQVJ1NWhpT1lRbTlFQi9udEcz?=
 =?utf-8?B?M0ZKYzBSalZOOEdkQ3NWbW9EZnJ3Smc5MTJEelFpTVNFdGc0RDB1OEIrM3dL?=
 =?utf-8?B?dUo3cytlM3dHc0Y3aEQ4ajlFU1F3SjBWTEt2ajFPZHd6RGNwTVNNUU00NjVP?=
 =?utf-8?B?Z3RsejFtNE9DRFdhWFc5YVR4WDRseG9xeGRGaXAxNjV4cThxTkVwREUreTR5?=
 =?utf-8?B?dVpjcHRRZ3lHZVB1eFlLalBaZVRqYlloYmNuTjBRRFowVWJKNi9pa0tMNi9V?=
 =?utf-8?B?WjJYMHh1M05uZ3pDNlE4QkhEVnVnOUI5MTJDck4xNVhDS3lXQnV5aDV2NU5L?=
 =?utf-8?B?K21yYUh2U3p4RWhleUZZNUJzbzZrQW54M09XdXoxTzZrdDJ3Sk80d3JVV1NK?=
 =?utf-8?B?a1JzSFlpaWM0dW1EWU55Y2dYSWNKOTZnYk1mZlJyZDhwSHpUL0s1bi90SE5J?=
 =?utf-8?B?UEZxTjJOK1A2VXhlYTd1bE9vUk9Zc1NDOUVqL1hHejFzQUMzVjVrcHFZTmpk?=
 =?utf-8?B?SHFoUXdrM0o4RjFZcFlkdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0NEWXp6MGNKRUdHc01KWUE0TWxCQ0ZsYUgva1pOZzRKazR3OVFBZnErczJB?=
 =?utf-8?B?VEVHdFhodEkwSGNabWhvbzJ5YU9vTXBQbHFDWnNOdXlEK0ppQ1hNODhJSGRz?=
 =?utf-8?B?V1ZhdnFvQWdUYnNPUWxoVjBxeDZyTXFGUDhFbTFBV1dQeFVxaXpPZnJ4TGlF?=
 =?utf-8?B?bFd3SVpSK0E2RVJldjRSTUdxdEVRcEFrQllJc3dXOFJyei9rS3FNV2lFNUcz?=
 =?utf-8?B?TmlPYktCSVM4aTNSS3M0K1J6ZVJROFdaa0Q1RmVwWDJnbURoZkpaVS9OaDJW?=
 =?utf-8?B?Q2VaQ1RVcGJIbWk0dmxnb1RJc1hMWDlTMkZsTzZKMVBPVXVWb1pVcUU0NGFa?=
 =?utf-8?B?WXN2T1ZteVJ0SU5hUzd3Tkl1Z0NycURsS2lKQXhPc2RSRFdvQVprL0I5NjhE?=
 =?utf-8?B?UnJobXQ0b2Y3dG93czUzOVAwS01pVVJ2czNFSzhWWmlmU3U0S3dQdDZEb3p6?=
 =?utf-8?B?UndrdEROYTF5N011bU4xM3VsTm5uQisyb095Ni9CZUlEU3daRGZBRldnS2JZ?=
 =?utf-8?B?M3QyOTFERUJrekswWWhYaG55eXB2THAwS1F0MmpkZEw2dU91WUZJck9nWDBR?=
 =?utf-8?B?SHB5UnFjNXFWSTVTNVRaYk1iYXpOZERYSXN3VUxncEdta2hvb0NJOGFUdTk2?=
 =?utf-8?B?UDZYYnZLeHdjTGpDT0toZmhITmNndkZ1am1tQmtBNkNEMjZxZUIzWElaTzZ0?=
 =?utf-8?B?Q2tGWFFCcEl1b3p1ZjhxWlZ4UmpGV0NSa052SERCbGFnUXZLQmFrcEtuM2FJ?=
 =?utf-8?B?cUlBc21kaTlGejlNOTVZVTE1ZFc4RFlyR1ZhdHB4L1ZnZlBFU2xVeEdMMndN?=
 =?utf-8?B?ZUVCMmNQdTlybzBjLzFJN0dZZFBZYWZ4a3B1TVJwL0JkVHd6OHlVU2hEQUtT?=
 =?utf-8?B?K3hPRUdEYlBRNlN1LzBkaFRNQTBJUmJJTmhpbE13WnRhaU1SSmdQa2I5MWhy?=
 =?utf-8?B?YitXM0RnSGlXMWpIVmVOWEo0a0E5ei9ablVrRWFXd1V3U3JxMnhBL3BZUFBO?=
 =?utf-8?B?UnZKbXNCaG5lY3IvU1hPTUx3RDY0VTBFQlkzMVBFOC9iZ3hCVE5uczNkTjcx?=
 =?utf-8?B?R21JZVRPL3dVLzdQdG54N1BRcnROa3pNelVBdHZLblhEdHcrMXJQbkNzbWpj?=
 =?utf-8?B?ZitDTFZxNkpGOG1mWEVWQkwyeG8wLzlCck1iS1IxYnRNK3pWNEFHNVl1ZU93?=
 =?utf-8?B?UHFMU08wM1hoWk80UnFoOUpJd29vd2pGOVdZSisrNWdBOUU4L2NZam5rZnN0?=
 =?utf-8?B?SW5aZE0xVFJVaTZmVFR4U0hxR0dXUTBteEt0TjFhVnNJc0djZ1FpUjFiQ3A4?=
 =?utf-8?B?bFpQcEUzcGlscGdQb3I3Q1BuR3ErTllub2lEWE9td1V1cnFuWEpUR0lxem0z?=
 =?utf-8?B?dGVKV0xVb2ppU1hIb1NXZmU4U1doYlRUZFYraG5ZZDU0SlY4d2ZoL2xNSVdO?=
 =?utf-8?B?NUVaMEFONCtpUStod2hxQjZFbjdtTE5MRzJ4UVN0Nm44QUVZVyt6d3pqVkt0?=
 =?utf-8?B?VFRlOGtpYW1nRHpUUjl4VWZWbU42OHoxakx1NnVOdzBBMjBZUzg4TTZHTjUz?=
 =?utf-8?B?L1h6S0dGbENmQ3RDZFhrdWZ2UUlOWVVJNytscmZ3K21zNDg5U2ZVeElrZGpa?=
 =?utf-8?B?a092ZXpBQXc1Sk4wbWZnNHBhVmdLTHNHZWJEWTdhOTA2RVRVWEVWNk9EckJ0?=
 =?utf-8?B?VFltd0k1RkNFV2dZalFwSXoxbjNsL1IrZ1lJWDFZanlHUDFCeGFzK0V4Wmtx?=
 =?utf-8?B?N0lHMWJ5SFNiRHQ2RTJjRnUyWU1ORkpQYTZGbW5UZm1QaEU2QlFqZk5pdUxC?=
 =?utf-8?B?R2Vtd3dBMHcyMjZXL0hVVjBMeEthdWRpL0ZOVlNSaUlZWmZPUkxWKzQ4aSsr?=
 =?utf-8?B?bytnM0pweVlNSEZCeHpyUFZqWWVXV01yMmFNN1FNMWJ1R1BVd1ZSNm1aK3NK?=
 =?utf-8?B?dTBxK2lmOEE0ZmxZWnVNeXZ2MjRwVmdTbFJJR0FLT1FlVDRORzljUEdDRDM5?=
 =?utf-8?B?RUVoSnNYeWFVY2NmZEZqY2c5TkRpOHpRQUFQT1dGaUtJcWp5d3dvMUprM2VB?=
 =?utf-8?B?c0JEcWI0TDRVa2VJRU0zQUhMbnVPYW5SSWNtM1FRQW5jdnBaZEo4bm1GREdp?=
 =?utf-8?Q?3cckasKHpqiudId3C0h222i5K?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c0+WdkgofQ9jtgFORbX9dvuZcBgtMiyKE6dPNInm+OetllqKSdg9MHcTijebs8UChVzgM5eyqLiAyDivhOx8HW4c3c8iptIK4aNJhLixzoYG5oMhB1mjgSB+DZc6OtA8qAzEQlC9TSaKZBa2LqEmPtUcYsatUtdkQ70cVTXoR2K18RI1KdmIz5uO6IkmgVMAUHIFxNqcPtgcsBJykBZqumOUAtuLP9LFvcL0zXwJRnJhsIJIJ0TDmuTEmFJq+GquuE9QAe43trl2oC89mGE4k5PuxPnyTT4KoQ/O3zruzsiJjH4ESBVoXAs0jy+7fSg34QkKpwkQHtcVO+oV1saVkTmJa/LGwKXG1HjxLFqPWRbNdSrOfVNzbHPcJ7ZwyL11EHwBwfn5EbjoI6H4KtPQTb1HNZgm+wAEU7AvmEccVyMF2EZ5X/xXKR2sXwoQlvn34tMtIs4RW74wkBFEK4wyHOIK0ThOg85Yz4akqZfTd3EjPuuswkBPoCTB+LgMwdF1br+B0OvwHc/gZ3hwq+oDsju4Pz/5YcWop4RB5a3ICdNyyHXMsiE8mpb+uyMzphhT6oQbf+lYO1TfcVgJYHsZcd6vU3n9PdP/S8Ef1e9hO5g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36ec7222-a69f-4b68-f944-08dcc73849a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 08:06:14.9863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/zKRX/ztHX5tLh/+o9Dj6mxb7NuN8QHRSFceUOmxTldOPQFETQ95Jqy6HGDnXarGFYcMDlIxcxboajnWylCKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5846
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_03,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408280057
X-Proofpoint-GUID: slxvMlVPVuikuv7xxSTG463aKfq5Mj4x
X-Proofpoint-ORIG-GUID: slxvMlVPVuikuv7xxSTG463aKfq5Mj4x

On 27/08/2024 18:53, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On error, blkdev_issue_write_zeroes used to recheck the block device's
> WRITE SAME queue limits after submitting WRITE SAME bios.  As stated in
> the comment, the purpose of this was to collapse all IO errors to
> EOPNOTSUPP if the effect of issuing bios was that WRITE SAME got turned
> off in the queue limits.  Therefore, it does not make sense to reuse the
> zeroes limit that was read earlier in the function because we only care
> about the queue limit *now*, not what it was at the start of the
> function.
> 
> Found by running generic/351 from fstests.

thanks for the fix

Reviewed-by: John Garry <john.g.garry@oracle.com>

> 
> Fixes: 64b582ca88ca1 ("block: Read max write zeroes once for __blkdev_issue_write_zeroes()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   block/blk-lib.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 83eb7761c2bfb..4c9f20a689f7b 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -174,7 +174,7 @@ static int blkdev_issue_write_zeroes(struct block_device *bdev, sector_t sector,
>   	 * on an I/O error, in which case we'll turn any error into
>   	 * "not supported" here.
>   	 */
> -	if (ret && !limit)

I don't think that we still require local variable @limit. Actually we 
can probably clean this up later, and Nitesh's suggestion on the 
original patch could have been considered more

> +	if (ret && !bdev_write_zeroes_sectors(bdev))
>   		return -EOPNOTSUPP;
>   	return ret;
>   }
> 

