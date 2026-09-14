Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761DF31A572
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 14:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789396233; cv=fail; b=LrIc9X3u6XUbPT86tjbVF1EnjBWoyKkcWFTWwuysOcbaf38A/Me310/gqrrm6M/nuB2d1PfKEJaWmM1XX27Gk5EFR3U7jftcPVUSUm8OEusWdnwWuRkogKC7X3V+eRAZypqVkdyV3C1xVj3VnoLi6MHfV/EKmWJC/IOc3UXaFvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789396233; c=relaxed/simple;
	bh=m6SHcZza/Ifj8bmxmyPVh/2hBJULBllKK/+pA0//pPE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rA7ZcxBqPkBmMuReHAT27CEXJ+wUzA0c7gt06V53Ni7NZFTh5s5sBl2k0DwyMoR0T4X9PPWlnEvzW5hnhjsxn72mzyv5vEzuwvf/cL+wL8HIFCbv9C/o3IovUaqqOlce9hC/56GkIXM9Bi3AaEfHOugZT/q+6/51G9QvufDHiqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NTwqZxzG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=awmKR+33; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NTwqZxzG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="awmKR+33"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789396231; x=1820932231;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m6SHcZza/Ifj8bmxmyPVh/2hBJULBllKK/+pA0//pPE=;
  b=NTwqZxzGI2XLvNttpfWOLIwkY6Q3zOg2J+D7WqQCErvOaM++m9HNJzQ/
   QB4Au4hG+2oslwfvjBlVX8D0Chq7hZTY9IKh5cwMCYn1Ck7extP3mMZ08
   IjELeno5wdXeTR5mXRi7R9RFtnrXAvjBB+UAYnsHnhGdNNwGklHZ4Pn2J
   WwkX9+py8WY6U+Aw7ZuaVXg72AnSkxyvZuKs2+C+7iUGs6MTtww3c7VN/
   Iq4Tc7ucwErNkC469cSAVY02Ln9PrPIsLBfLP5avWe+Aen4IDgowra6b4
   lg96/D+8WnYWwhHTKiB0NM5qAcUqd/Z+8aDMfU3pF15P9/76QlCWNeuQ3
   w==;
X-CSE-ConnectionGUID: MvAnmi2NRN2sv17wMe+TYQ==
X-CSE-MsgGUID: ruo4yVG4QNGAXG3n54droQ==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="scan'208";a="154671964"
Received: from mail-westcentralusazon11010025.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Sep 2026 22:30:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UO86vTzhxDm74qYSELG808OVBW4AlR9gg30ON9Uo52jRQ80lio1DnaUSqU/rmsmdz2KNw42OJCTJnK0CPT4ShKW0U8+NQ21JktqAKzm7kJUx6s4W+b4p2LrI/dHkJCGmKECC5DwxThPqzSGzIvEG+8XRvbl0+ZyZTMH+JXOreIL44eMn4w98iVx05BOgApkaCjdffbLEZ6XwIf6A+xxziKw7kgiujnsUgnoo6HuYAmmda8TYivmt5I8tx9MHH5haMONpzzq5tLOYCvinwdpBxNlrn5Jyv1Lni7QZCEBsJiKnNM25Rn68dFwpjbYt9KS61ldY9f+4lo+8o7xYaESu2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfSEX1A7ADpWulxDSPQxxvTTYkq60z/dwdQ33jRgS3M=;
 b=geYm2Se3Z7azJPkFjxGHlnXo71Sz1d08VUHTcUYnug9HMIsxYOFufSI2IyzqoLyPLv9dBLqAiF3aH4SYkOHxS85VglXqbwAVHEVzKDIYppmWpOoVSC+6YLhP/+7CJhWuzc3qL4JLjEXHB0PYEoQ2YlS4C3frnE9BjD5kT4AsldxBH565wGleeI5sar/948m2VZek3IOXWe6Z640bJnPAVZcfKPlAjYML/gDGCt0qWwJPGB2/CZ0iORj2IEgbdY5plUYzLC/D2jHaki/45uhTnLU57OWcNrBDobKh5rb4CRp3VNjmZMoF3S0q64js2DpW7/R9Kov9MjWRz/BMUjPqIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfSEX1A7ADpWulxDSPQxxvTTYkq60z/dwdQ33jRgS3M=;
 b=awmKR+33eWXbRQebwgOKWRtbHJIQlMG1g0ZE06iH1i/DlELWr1yKOpo/IlDlD7MZ0aamPWTv+zlAEkDJebCvKhXxZvZ3ihvyYvCfPxQADEnT2ysrTGqeAqhKzoKrSmQJxDrJpLs0O/4mjRaJNdeUXzhOk2DFqZYFwcypfewlrZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by CH2PR04MB6840.namprd04.prod.outlook.com (2603:10b6:610:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 14:30:28 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 14:30:28 +0000
Message-ID: <89bf7740-c984-402f-b742-ff2a3345b768@wdc.com>
Date: Mon, 14 Sep 2026 16:30:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't try to get a reference to a NULL oz in
 xfs_get_cached_zone
To: Christoph Hellwig <hch@lst.de>, cem@kernel.org
Cc: djwong@kernel.org, dlemoal@kernel.org, linux-xfs@vger.kernel.org
References: <20260914113538.2448661-1-hch@lst.de>
Content-Language: en-US
From: Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20260914113538.2448661-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0075.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::24) To SA6PR04MB9269.namprd04.prod.outlook.com
 (2603:10b6:806:417::19)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9269:EE_|CH2PR04MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: f08b1e6f-affa-4f9f-e445-08df126cb8fb
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|19092799006|1800799024|10070799003|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	oI9OiEuJEr41Mqtct3s3E8qjCYtWBMxMORPWt8EtcUofRPxgkaOUxeUiQjrVWFT+hj7heCI4AxXtjlov7vYQ8cX4Ts1hZpQYAhazARI/Zy08qpK4ZwfgS1DksetNSXz6jNnL2RfS7RPpiM51t91XOvGicAnahoqwAgclR6bIfHoHwQ2771jZZS/tZE672wsmVQCXgu2MsBmN4gs+clLFOYFYwgUqYtsNGqN8HEm5zGN34MX32pIBZ5jcmpdQX8KNBLwvgCs9X6SgKT9kb7J4WTHrvMqDOcrv5XkRP0Vb2z7PvanPM1FxDiI+7KCYov/Fj25TJgR0odkhPEYIohj9qRoGwP5NgNO/5+dtF4wRqGWkQgTsdFcqzwQGpZDuFn49udh0EpJB6/VI6GG2IjZXfyw9fjOFO7WEFLcY+maxBgcrZRVtlteAhwauC5nOvRdXP8baKhPuHyz/MfQwW1r4+NnHVB0wxQFD6J2U0fZZ4261VRJPUOC2Ek1hsQl2zJhrXs0/TPFQ66PEHGUPOwrX4h+5I3C1GX05MuQmsx0hoPYK6u3YiN3pFgYqooT9d64QNLb8bsANCzM5Xsg8W77asGTI8r4W9TKuYWkOk+CTkcHQyAxc4bZ1uvCiXJmTa7WIS+3SZ701l6aIvFmpPA1BjnUtd9bgbHkuQpyhiWEtMcw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(19092799006)(1800799024)(10070799003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnliL3M4cnVXVDNtMmdhU0RNQzQ2ZkNWeEg1Q1RqVE5SMHNUY1ZDWk0wTHdH?=
 =?utf-8?B?dWd0c2JTV1cwczdEdVhYQU5JdlBEMmhYRWMxa2VTNTFPcWlPN1NDbUxBSzZT?=
 =?utf-8?B?M2puNHh6dTJzQVpjMnNhYzY5K20vV3pwbElEeDUrMXVWSWFOMTFCVFZxQlJM?=
 =?utf-8?B?QmFkOW5XZmV1cHVvOEJxd01hWmZxYm12Uks1VzlZczFFQ1ZNZ1hyc1Iwb2R6?=
 =?utf-8?B?VzJmRUdkSUQ0VFVVbWsrS29wNkFMN1NPQnZ2TmEvTEJUWnpyS0pwNlN5akhJ?=
 =?utf-8?B?YzU5NnJJMkRsSW1JSEFKS09tWURMaTNnRFdSamR4WTY2YXNmQTVqZW9yMjJH?=
 =?utf-8?B?eHV3dWMraXZWL25VVU5JOWNRYW56dFhHL3FHa2lWRVc2OTVhcGZ3R1RMNFBL?=
 =?utf-8?B?eUxKRHJFWCs4ejl3dm9uclNOaXhLQXNwWm1BVjhQSnN2TG4wV0lSNDYyYlhJ?=
 =?utf-8?B?eVJCSU1SSEl2aFdVWUcrN2EvWkIvcC9QWjdFcDh6bnNGNTJQSjRPYmEvK2E3?=
 =?utf-8?B?aHI5TTNrNU56clgyNUUyYXp2NGNaeEU3SG94Si9kNHdRZzZXblNxL0xQTmZO?=
 =?utf-8?B?MFF6VjRjVU1QMkkwbkVEcEc3Z2NZQVpVaSs0cTZvOHV4ZDlYWUlLLzdTZVA1?=
 =?utf-8?B?SHE2K1A2a2dsb2JNUTJnNGZmMXA3ZDFJc2l0VFBhV1ZhejhDaC8rYitqeUFq?=
 =?utf-8?B?VXAvM0NUdlZFVXU3eCtDb3ZTcVMwRFgzS0tOVjdSTkttalllL0wwRnVkM3NU?=
 =?utf-8?B?bGVPL1ZhVm5MK05FUVhVT0FXUnBKb2F4YjMzNDVzVitidklRamdnWDFNdzZM?=
 =?utf-8?B?ME9qay9rdzNCcGZabE16L1ZkK1RRSXlqT096Z3lQVVJTWUYxRElXOFFDYUxR?=
 =?utf-8?B?dmhCbUNLNSszNnRqUFUvNnpXcmlSdWFIanJWL2ZNaTBLZEF5MDVmcFJQdTVM?=
 =?utf-8?B?OXJDWmxXc3liUStSKzRlVWhqblp3TXZlNFBMMzJSU3lxbjJXUGs3R1E4dzJH?=
 =?utf-8?B?UmJFNGlvOERvb3J0RFpNL2pldXpuR1BFVlViYzYyMTJWZGdZMTd1KzhVZTVC?=
 =?utf-8?B?S1RPR0ZtTWVtVlVwWFpkbzdqWURpQk5jTXFzYVhoRkFnWGtKUmhrQ0pVVndQ?=
 =?utf-8?B?eWZnVURtMkE4ejAxaEJUZXZwZ3gwMEd1MGRJRjllVkR5c2RZOFVaMVFtd3pt?=
 =?utf-8?B?VTZuYWFvYW9ETUFtempwNkYwc3FQRDZGUFJWM3lqT2hnR21Gdm9qR01sRDM3?=
 =?utf-8?B?SjQxVUI1WDZjKzljRldmb2ZIcmtwZ2ZLcjNkZlJ4Y0JjSlpJc3FZUUNHVkRN?=
 =?utf-8?B?ZWE0QVBDRElxaG5OcjQ0Q3NrZDY0MEwvMlQ1bVRqamxJeG9tSE5IaEdYY3JH?=
 =?utf-8?B?ZjFQNGJSK1plRDdLQ2x5NXdNTWZmYlpLKzFIY3hlRk4vT3hTRjRhaXc1UVVo?=
 =?utf-8?B?K3lPSFBNc05uSWxvemlYK1lUV0dJWkZUdGNJWDRBQlNmUEM5WTJhdGsyb0Vz?=
 =?utf-8?B?Y1E0bGV5ZG1aOTFSK0Fyc0QzR0M2V2ZsY1lqaW9lckRPeDRwdjJFV0VKYU5l?=
 =?utf-8?B?WnlBRXV3QlYrdDlDeEl6eGxJaE5hSzNuQkFJUzVsYmZjcG8rTlYyZ3JpK2g3?=
 =?utf-8?B?NzBIY0h2RElLOWxwNE8zMjRQNUYvODRZYVplTFFPa0hpcEVyaDlXRSsyNVA4?=
 =?utf-8?B?Qk1GNm5obW5wWFVHbk9zVTlYWXZQNVBmQ0haL1ZiUWZTdGlCN3EyK3hHcDNG?=
 =?utf-8?B?RGdoY3RlNFYyVXlTRHlzdUI0cE9QTE9xSzlVek1zN2VPaFdPdTcxOW9DL3Nh?=
 =?utf-8?B?d3dXT1Z5a0dkVXlYZWdhbDF3QjhibDN3TGZvNlRoSU5PdkIwa3JLTXVqeFJK?=
 =?utf-8?B?amhQQ3dNTmw0MnoxQTZOV2tHejRMV1djOXhDeEJpckpuWW8rSVZnM2doK0xu?=
 =?utf-8?B?SHltRGdIZE9JZ204SHF3OGczNVZETU14Q0puUnpEN1ZuOTRjSVVFSmoyMU9Q?=
 =?utf-8?B?UkNDa1hUbVlPcGRJcVhHSDl5YmRyMDJBSWlMMElXM2pqa3pvazQydkozTlo0?=
 =?utf-8?B?NHFLeGlhN1RoTkxNb05HcGFNalB1R3R6WmNwRzRqZ2tMWmxYMk1hd0VkL2Ju?=
 =?utf-8?B?R2I5R01XM3ZydTFObzQ5MlVTMGhiZW82S2dNLzFuZXRMY3VEK1FyZUhtZnF5?=
 =?utf-8?B?MjdidjdWdmQ5NWM0WGlPM3RUSTI5SGFhb21DZlJzZkgzbDd0dFF1R3IrSEh6?=
 =?utf-8?B?RGg3SWg0Qlk2ZVpxOGorNDlKMXhaamxSa1hGcmNSaG5oelVwcUNmU2VTRTFW?=
 =?utf-8?B?M1dHL280Y3ZOZlNEWHZPSG1kZVBRc2REM2V2LzVLZkhYaU1sN0JneDRYQWZF?=
 =?utf-8?Q?vJP5vnt0WQxprh/vbxl4jwM536HmwjGh0XvV7qXEGspxU?=
X-MS-Exchange-AntiSpam-MessageData-1: 9Fij6cp7SyWlzQ==
X-Exchange-RoutingPolicyChecked:
	B4T0nc+GsgDNEHvHXQjJb5lzmr1Pw9oV5sLEHlx2MCaRrdFTrw+rD9WtoJSdAtij0L4hbWpvvvxKw1lSWN1k6dNesDffwmjQD5QzTFAMZ26S1zFPgtfW9MREFM0+mV/eSq6XjQUHtDSG8SxU9NrEsLGzYG2vEkNyJ4flZLx5LxyJi3Psw1Jj/wyC3mV09szUiTMl9RaAEr6vgnazcl2Ds8kC3FmjwXym87ONvWCjAARDilPPx1Z1WRxmmfBu0q1Uy9O60ALsai0zfhiiLOzUorJUjARkimzkPjtTBM+1ERzzbEarNrKrqafcyM7rlqHNor7HqBT8JnczJf+zWsDrfA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sTnwSHEF46oqUf13CMXDwiH39Wb2KRnsiK9KM5gHokZasy7yESkLp60XGvquXmgE0QW1A9odYn8tczHfIfwMslKpiDBzDsJX4L1BnlsX6Bm/KiNyWMq00WKOEl5VLYOfm4o6UqqV4Mlb7PLlqM3FdnfkeqY/xxZWnxflLWttbvpfRXZ1ry5Y4Hq8dKKI/CHPYQpa7rm/hJMi98/ewNHAl0CS08iPJo4hZ0BgXRwqZr8w83VXHUfn4G0paoDR3HNOq91WyjAaksgQeknEMh/lqeEXSwUf24xekPzYNyBMmpcd80kxJD8Cbb1/G4DLxmd0UGJLqHVNXBn527PAskaegWs8qO0I06OExCKCbT/676q3zzcOhPPEh3QJ4WKAvSVW11MzEcBlUoGryYYR3cU6Lyz95lZ3DjTB0MW1ZrZOCPtG/7y4/b7qHJAAS2JNbh6r104Fga6RHm4YHNI8Nvg2/5I1jk/sPfG28E4Jw+aBC1QYVQRj7EF+rfG7FwHNkkGaydZT6KuPhyxZwhbQBzRxHuxgFD4fQ9HT2uylmBS3OcHCvtLLxGMgV+sA5Q4EEhuwfkBt1GHqy0Yunb9BdCleFD5sMaD530HAP0w3zcFuayz5m78yPdQhxhWmjN1k1TuB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f08b1e6f-affa-4f9f-e445-08df126cb8fb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 14:30:28.2044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJIoEhPxFmMYoewi79sIY82fP/bfvbOQTxxX8MUmNnEEK1ePLEYpfOzZhYqalZOxX+Q7OSdkidOLxTmvLTY4+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6840

On 14/09/2026 13:35, Christoph Hellwig wrote:
> oz can be NULL when we resample it after taking i_flags_lock, so account
> for that.
> 
> Fixes: 2d829cc76777 ("xfs: fix racy open zone caching")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index bede79859671..8cdd473d8144 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -819,7 +819,7 @@ xfs_get_cached_zone(
>  		spin_unlock(&ip->i_flags_lock);
>  	}
>  
> -	if (!atomic_inc_not_zero(&oz->oz_ref))
> +	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
>  		oz = NULL;
>  out_unlock:
>  	rcu_read_unlock();

Looks good,

Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>

