Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FA02AEE1
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 07:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760684946; cv=fail; b=Dx4LdoDFnaiRTO4KuaDrXC/XF5BmbxufTC3EmeojluDzRjUAcLaAy7cDzEMfiFxFZ+wwwnvoZU74cYZ/tBZuBDMs0rGFf2O3tFKl5daXMLrI8d/0TnhS/R0OFNUYZYhV+9cwWMQ2R8xUXyAOYAL8CT57ycpoETmI8NxI3R32OuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760684946; c=relaxed/simple;
	bh=getp33Rlq1adF3lDRNyY15pmMa8b4VgxcEgbvpVy2Zg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fSek2oqattu9mKijjcdSKoImKWdCVugCVfDAMLs3V/fMWREpA9nRhUo8ypYb8HVYMhMZImpHDf5n45JjkoVGEO0HtopVaNZ9jZDYIpnR5n3dGbI2lD95CtdF6EisfGE2xRwejqYmSnmKOIBCPdkneq5hr8g9MhCwGkiChz8zCTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YkaLDYGY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=u3IY2wK5; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YkaLDYGY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="u3IY2wK5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1760684944; x=1792220944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=getp33Rlq1adF3lDRNyY15pmMa8b4VgxcEgbvpVy2Zg=;
  b=YkaLDYGYqLnEAh3f3G3XUKi75qCo9GhZGcrjc9pGNtXPk5N3WN+2udJP
   ywcS6g4pctfZvTCpapvptL95yI4ytbYv4rOBjX1iVhLhf098HSH9WVnuv
   8UE0uQ8kGy2evFDP8Df57zZbkYPSl1PqGwtF0bO9WAh1GHWmNO3wNz80Y
   cfzFMwfdr4Ewr4+afzzO/8f2D6rDhDKm6SJdbBGL4RtD6gw9j0y3rgkrU
   tEAIhuuYOt1C+xr6qpNri526ypf/Ivq9I2jK5adDA06CBF4hmWpTCca0f
   h2Pn9/WLySZjh41TRYWBzFGIANDEtPGqDSHa2/1Ngf5ZyZdckGkHV4I57
   A==;
X-CSE-ConnectionGUID: yqItJI4bSyuQGeoHUWtyng==
X-CSE-MsgGUID: shNdrI9GSN+21dtJJYdT7g==
X-IronPort-AV: E=Sophos;i="6.19,234,1754928000"; 
   d="scan'208";a="134637376"
Received: from mail-westus3azon11011014.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2025 15:08:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dr9jTb21p4nzeqT4+P30k4I/msjr1jilHwoSKhWKxb8R+y2BET5iBbHTu9fhn549XrjiYY85GxFtuRkOMHR3f/9HaUoTBMdYBdD/nL2+JSvCcpt7ZnElQGKS6xrig7nZg+Oq45kIb4lhSZkLWm81yXmhwtt9ljOBk2WYnHy8yUYAhnbC4aRU6y7P8rPJiU1xhGrOhWYi9PJJRser9Ni8JnIvrl+NElmmYvttZh2X/LicsKIZKieS+ASkbFsl0mFbYRByXCX4aMgBSFVm51PanPdXu/R50NxM5qT5P1628QL63HpewXeIDzwl8YgUfj25RnThD/FUdTi12aWgxNmIMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=getp33Rlq1adF3lDRNyY15pmMa8b4VgxcEgbvpVy2Zg=;
 b=XXHga9gowhdRt3Q6gFv1su8leyLyBgcyrsI29OrctxDQ2r4NAQ0swl7yLW3za/yemMMOeMkFw9S59510TM2GkmdI3BuScLoi1aEB3le+HqFp9eAo2f9Rsy1xpGGfahNlnItEjS9pnUso7gB5WSSGaaoblC+AqKVcCiBxB7agMqUqpHR2D1Q1ngCKffqfAbFrN2XUuyq7d5KGTFvi5v7BCIjySsrkeDVZyr/JnuNwqUTG1xb48W7kog/86FW4ROsR7vG71lPdcNLmOw2yStA/mgpryK/8ThLSgDHMM5CHz0TV5CaO+9cMWn6NsfD4xbTuOYj2E6QLta5lNe44SP20AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=getp33Rlq1adF3lDRNyY15pmMa8b4VgxcEgbvpVy2Zg=;
 b=u3IY2wK5kWg6l4jbX1+/jGH+BnssbWKxQUAxZbqkTtbwm4OpMuLnPO/wVKCCoJ6BqFjQzrHc94GcaJZiOAm1oP7Fi5jNZ7tbTdhsDTzBo1Jbk/REPA/bunQvWOyWWk0vsl9P02Odl2UnoUcMla5ZCMALv2dfp+c0hDaH6JCAr7s=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN2PR04MB6704.namprd04.prod.outlook.com (2603:10b6:208:1e0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 07:08:56 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 07:08:56 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid busy loops in GCD
Thread-Topic: [PATCH] xfs: avoid busy loops in GCD
Thread-Index: AQHcPZ0UA1xN9MakcEm6sB1rLDYu2LTF7pKA
Date: Fri, 17 Oct 2025 07:08:56 +0000
Message-ID: <27d0cc6c-9aec-44b7-a3b3-5bdfa4801d01@wdc.com>
References: <20251015062930.60765-1-hch@lst.de>
In-Reply-To: <20251015062930.60765-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN2PR04MB6704:EE_
x-ms-office365-filtering-correlation-id: 194bd698-cb65-4160-e4f2-08de0d4c09a3
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YmNndFMyWVljYkI3VTVJUUtobStYWlMwREZVeEZXZFhXN1R0c0tpa1hndElx?=
 =?utf-8?B?VGt1YWhiLzZzaHgwbmU5UUZleXltU0hvdTJZdEpJM1RZSzJiTVV1ZTVpRlh4?=
 =?utf-8?B?WU5VdWpWZ05YWmllWnBzUHdXQmNycXd2aCtkQ3BRKzVTOUliOHEzRU1WZjBn?=
 =?utf-8?B?aUtmZitlejZSRmxGNk5yOWRKMjVtbk5JUDE2U0t3WXY3OTNCbWE1bGFTNVhC?=
 =?utf-8?B?dHFCajFJNUJxeXhqVldxY1QyeUxXZVJyZ05ibzRPYUtxNHJFczNPb01wNjAr?=
 =?utf-8?B?bWdrSWZ4bnZjem9jMktlMXNrRis1WHVRM2NlTENvVGExckg4WEFibURid3JD?=
 =?utf-8?B?endBUkFqM055U0RZSVBzU1BNR0w0STZBdERqWlpUbVBsOGYweFcyaG0xSEpo?=
 =?utf-8?B?aGRVV09YVnN0NnZKTVNSMlluSnNab1ZkaUZ5cHRrWksyUmsxSmZPa3RVUEIv?=
 =?utf-8?B?ZnY3aVdNQVpmaXh5dWx0NFZhMDB3cEE5aXZLYTdzQ0xtSjFIb1IyMGFTWXZp?=
 =?utf-8?B?TERrUlJQcEtMQlhoK2RqdzY0VDkrdGxPZjN4RFh3TE1sWUcraDZBeUxsL1Vx?=
 =?utf-8?B?L3RYTkM4QjRWRXhQbTNoRmVKTzRHYVUwUmpFS1M2VVJNVk9ySG4yVy9TbU9P?=
 =?utf-8?B?RnNmSWxOd2wrblB6MmIxSzRRRDQzTHFGMmFCZUx4VmhobVpXUllpMVl3blRr?=
 =?utf-8?B?cnRnc2sydnF0TnllOVFoYk5nc0ROOFErVEF3TkcxYmFtcUkvQmJLNW1mZWJH?=
 =?utf-8?B?WnhVaWpOVmJkUTl2WlZ6Ulo4SkxJdE9NVzJSbzk3bWNKOHZDWXcrK0I1WE1o?=
 =?utf-8?B?VWN0NGlpWnhkbWpNT0V3TW1jNjAyejJjTDZKeU1ySHVQcVh6QXZDbnFTVHJJ?=
 =?utf-8?B?ajJJaG9IckczZlMxdHZ6M1dGMm9HWFFpOEdYZlhXYnY3T3JqV0lPYlpwQUVj?=
 =?utf-8?B?VmYrNURJMFNrcHg0YnhaMHkwT3FQL0FGWmRmNHBSQUZKR1dsSm5tMkVKK1NS?=
 =?utf-8?B?dHBCdURWMjVTWHR2aVRZeG1HZXowaVlRR2FPRVhFbkNWcEk2Yy85V2xrZExO?=
 =?utf-8?B?N2lTMEU1SytpU2tNV1lVRC9DUjZIeWxWSnNtVHN4dWlUbWNmY25yaWtQNW1s?=
 =?utf-8?B?QlQ5MVo1UE1MWVdUM0FibWNnODZ5bFRyck9YZFRvcklDeVVJQ2RkMVJUNFFw?=
 =?utf-8?B?MmZ4M2lJRTRPR3ArWHdvcmFjcHIzYWx0R2h0dEF4aUJpL1dhYW5kVExHMHF1?=
 =?utf-8?B?bk8zRFh6ZjE1VXVCMTMxV21lNW11MGU2Qm1HKzFUUDNiMUNGc2JLT0l4UEJt?=
 =?utf-8?B?Ull4elZyTHRMZ1FybFd2WXo2Y3IyRDZIQURZcVZKR01aTFYwcVF3YmZINENx?=
 =?utf-8?B?Ui82cnpGRDVlMmJxSktOaEhUazdkeXRyODAvRmw2TThwdW1pamo4SURMSnRq?=
 =?utf-8?B?SS95dkdmTmhrY081bGdraHdxRXZrWkovRERiN1Z3bGt0QnIzeUtaRnVHRTZp?=
 =?utf-8?B?UC8xczdkdE9aSWtlS290RXQ3WWpZVzE5N3Bpc2FXZVNZUGtZUXFIem9hNFVD?=
 =?utf-8?B?S3dwbU1OTkdxVmdOMDVTd2lrU0JPY2dVM2kvZk1DSXl5LytocGlpRzE2N0Jx?=
 =?utf-8?B?NWJtMnRGbHBCTzJaR2RBazlHSkJnYi9uc2o2ZWRaU1BJazAwTDBLK0hIZWM3?=
 =?utf-8?B?TGxKWWQ4RC9uTG9YWWx6bFdCSG5IYnpxWTNPSGN6SnVkWXFPYTh6OHFTUy9O?=
 =?utf-8?B?NEkxVm9wYkt1L0JZenZuSCtsV0doRisxL1VUN29YbnczZ2VYYmtCSnVBSm5Q?=
 =?utf-8?B?Mi9CMGdGR051TWdscFd4SGpkYlFBNlNEdDE5U3Z3S2pEOXU2SEU5b3NCbDlu?=
 =?utf-8?B?bEw4NGkxQzEwR1BOT2MrQzhoNGNiSW5TTHJxL2hPbWwzdVcwTC9mTXVzUTIv?=
 =?utf-8?B?RXNPcWI5OVdhN1BKeEVjVUI0NW4rNHV2Ylo1eW5NT09oTkx5cDR5VzNXOXZD?=
 =?utf-8?B?N2hpRkZLUEY1U0xsVFRnSnd4M21NOWp5eGZvWXVxMWFpamZGMnJKaDh5S3po?=
 =?utf-8?Q?ajkdFU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1RDVkt5cnR2ZmtZTXlJQ3F0K1kxejdWeDZPWXVsekZOWXA5U2xrN2prUUxh?=
 =?utf-8?B?MDVTMGN6TWkxUFE1bHBRNWt2U0YrVGZkS2hvL2FCbmlQNEVWZ2I4YUlCRkxD?=
 =?utf-8?B?QWlFQXNRRUlNRloweVVZR1kwRW9BWE9HRi9mZDNBdmNteFQ0YTk5aUY2cDV4?=
 =?utf-8?B?ZzJoWFZDQnh2TXJlU1I1SDArT1l1ajIrTS9PNG5ObzlFd1FoZDFJdVZyRG8x?=
 =?utf-8?B?QmdCTDU3dnZZT0szcFpEeFh1VjFEelgrMDZnNHFNNFBKVjUwaEEzUDBZd2Z0?=
 =?utf-8?B?YlRhTngyOHY2SUY1bXNzNjA0VE95UVl6VWxZWTY1U2NaeHVtcTNCSTM3Zkt0?=
 =?utf-8?B?Z2h3RTdKMHJBSjJjMlVzUnVMZ2ZYRkFDakxIbXI1VGVhbUtnWDJBQ1NtbWlY?=
 =?utf-8?B?cDNMa2VyRG5UUnBZL3JuaUd2RDlldFFPSkFWazQ5cUFSMVVPcEdQR3BSK2dW?=
 =?utf-8?B?Z0c1SE16UjhTMVhQbytTTXM0N3VCWU96YkxBem5IZS9pV2YwNFNKYTBwUUhL?=
 =?utf-8?B?Q2ZQVjhTWTJJamdGRGYwSzBzQkQza1pCSVBuZzFjNC90R3NZbVd2N2w1bUVT?=
 =?utf-8?B?RDZaak5CNE1ZTGdKL29qaldwNnozTTlYYkwyTFFCSzk3VkdDQ0MxK1g5RGJk?=
 =?utf-8?B?ODdSQnhLTXFJSkZhVFBCVjlHMmRONXhwUm5qU0MyMS9BVmsvOVdGT01JTFdz?=
 =?utf-8?B?Y3JMbXQwdTNkU3hwdjYyMTB0K2hrZkRaZ241b1V1YklNTHZrcnkwenBNTXFT?=
 =?utf-8?B?MmtaZFh0bS9nSE0za2E0U2h5R2RISUhqbVJ6eGlPQlBqSFR4VXUrYmpYK0Ro?=
 =?utf-8?B?b1Bocm83N1IrSytwejhuZU8xMTNJNVpUck0xMzNBQXU2Z0JkVFJVcXBzZTd5?=
 =?utf-8?B?cCtraFJ5eUJxcHQ3aG5CV09yOUo5WFpJYjN1dU1valh6cEc1Qm1KVnhHTVNV?=
 =?utf-8?B?amxkVDI3MHphR2lIdUFnRkhTaWxNYWJ5U2tveVVhc2JaRWIzTTBTbStaWGJS?=
 =?utf-8?B?V2ZFSWVSNlRQdm4xM1Y1ZHhxUEM0SlA1V2xTUFIxV0d5b2FnNTdwK1VFTGU5?=
 =?utf-8?B?NTlXYkpxMjA1UDRXelYxcDYzN05PcFMyRFRyaEs5RXA2RnZpY3pYMHZ3S3ZS?=
 =?utf-8?B?dDZCV3Irb0JUamp5c1FWZVRFOXpVd3VodFZrQm1BdDlFalA3QU5YVjNzK3hR?=
 =?utf-8?B?YUh1TnR1d3Vvc3VCcFlhYnRJbWU0RTQrMnVIZTRDaXkrUnovblRXTHdHcm1L?=
 =?utf-8?B?dlMrTjM2MGl5bjU5U2dVZmo5N3ZlSmtUNGRiSElBV1hvY3RMZVE2K3o1enBC?=
 =?utf-8?B?VkVVTk05b1J2aVZnczJTOTZpR3AwdkwwUnZhbng5WDVJdFJXRGxkUkJ4akdl?=
 =?utf-8?B?UHdHUXZNa3RjQ2FRZmdzOTV2a1VCU09zbENvVTUrUXYxYnpmTWUxSHNnY0M4?=
 =?utf-8?B?dDhhRi85OTJubDRWcCt3S3RZRkNMelNCeXhhZTVQdzhJMEd6NmJGVC9uZkU0?=
 =?utf-8?B?b2VRUXE5TldXNWZibjd1TnUyZ1VKaExwWVZMRFJhbncrUDFTT0hXWGhvbHlJ?=
 =?utf-8?B?OFJnU3M2UlhERTFXaVFBZzQyL2V6UVd4dUI1U2FPSHZEclF2RmE5WVRZUUU0?=
 =?utf-8?B?SzV2NXJUdUtxNHJFeWVOUHFRNGxFVGtBa05ZS1RRNy9OaDF0NmRMRm5ZS0sz?=
 =?utf-8?B?SjFaZmo3QklzaEhFcjVtaHNxTXpSazFCWDI3a1VyRmR2V2pnbTRFU0wrcCtH?=
 =?utf-8?B?Z0FDVnFQb1FweEZnajh6ZXdVbVRsaDRsZjRha2M4Vk9WK2l6ZWE5VEliaTJi?=
 =?utf-8?B?Sk9YbXJ0cTM2QmlGT3lCMktxSUJ2ZXcwYlM0Z3l4RHRQM1pIV0srRjFTSWxE?=
 =?utf-8?B?Rk9jblFQZ3lLamMwcVBxWXJXQkh6dFVtOGFRa2VOajN0K3d1dnBnbFMrandl?=
 =?utf-8?B?SFI1U1ZZQU9uYlNpbTZTbitVOENPaFFHWHlHc2puelpuL21Cak5IZCthVEVE?=
 =?utf-8?B?QVJVVWdRcUdaeHBzQUJQcTdvOTBjT3RSYXZlVWVCdU5QNTdRa0JaL25GQ0tM?=
 =?utf-8?B?QnE1Rm90L3BWS1BsZktESUxmbGJXVjdMb01lU3JlRFRpeG9oZWxyVGt3UlIx?=
 =?utf-8?B?MFNNL0hxbk14dzBvK3V2QmlpN2c3MEUvWkwzVVMrVmlPMU4xMjhhclVRdVdG?=
 =?utf-8?B?Z1pRZjh1VGtXbWZmb2t2Q3krMXhLM1ZyWmJGL0pFYzNHWkNKeXhHR3U1Vktv?=
 =?utf-8?B?bjR0RzVGM1lHTXhERS9nMDFZVEtBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4450476E074B6B40BC5D87F6B842B6AB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DrulKIIkPbs055WceFu02BHz7UaX0rmO8TkqZ3Uhe/dAhEflWI6yY3u032Fen/npU7zxQt4U10xhRuOYaCjrnBuIcHfnF4NvS+UgL1i2q5pm/o5LwQ8oQJXj9yb0F653Gx+Pf90CFJ0htDmp5wVILFWKaWs89FaVVPDmRMrN17EDuHllzS2p0AxjkDPAi/tshl04W2Myw6lSJnKv//vqnngvcFmmJy+OccRbpoZACoJhPQz8pNe0xiZOXEVXEH/UTglemKr+XJZbElgYkI8g7VweAwhBYvgUy7xglE99rcUhKWgtAMMGRV0nAcCHDb+fK+XDWVVIUTb1gmbmHgvqG6pXaU1BFq6SsSFbvsb8/Wy4XncMZpA/85iydxjr5Seb9qi6fZyMpF0zxT/LUpI9e2o8Yxc1xEJ06h9xb/aEMTe4ZHHq/fUW5P8OkWfCkwYRTDilD3g0+W7H8enDcQNSBEKi55Col+ggwP8Dael+lQUaCZRzDgDQcrhNvrezy6hiiuJ7tSDkklOSr+HfPED2oUJZdVQKD0hV+KMlxZhhUhcPADbdQhxJ4i5adAjWhIib7FyEKC+x0FM4xKTYq0YkTy0Id8Ztbsv1uNGp6CBDMGPCswThIyiPXdifTiJWQd+0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 194bd698-cb65-4160-e4f2-08de0d4c09a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 07:08:56.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oTK8bHtyl+kS+07idwS4RtphntAMpFKbUP5WAwiXrBfHMo61E5ZI4+ezDDfv5xi9ODOQ6oO5wuIwIXKhyvU7bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6704

T24gMTUvMTAvMjAyNSAxNToyOSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdoZW4gR0NE
IGhhcyBubyBuZXcgd29yayB0byBoYW5kbGUsIGJ1dCByZWFkLCB3cml0ZSBvciByZXNldCBjb21t
YW5kcw0KPiBhcmUgb3V0c3RhbmRpbmcsIGl0IGN1cnJlbnRseSBidXN5IGxvb3BzLCB3aGljaCBp
cyBhIGJpdCBzdWJvcHRpbWFsLA0KPiBhbmQgY2FuIGxlYWQgdG8gc29mdGxvY2t1cCB3YXJuaW5n
cyBpbiBjYXNlIG9mIHN0dWNrIGNvbW1hbmRzLg0KPiANCj4gQ2hhbmdlIHRoZSBjb2RlIHNvIHRo
YXQgdGhlIHRhc2sgc3RhdGUgaXMgb25seSBzZXQgdG8gcnVubmluZyB3aGVuIHdvcmsNCj4gaXMg
cGVyZm9ybWVkLCB3aGljaCBsb29rcyBhIGJpdCB0cmlja3kgZHVlIHRvIHRoZSBkZXNpZ24gb2Yg
dGhlDQo+IHJlYWRpbmcvd3JpdGluZy9yZXNldHRpbmcgbGlzdHMgdGhhdCBjb250YWluIGJvdGgg
aW4tZmxpZ2h0IGFuZCBmaW5pc2hlZA0KPiBjb21tYW5kcy4NCj4gDQo+IEZpeGVzOiAwODBkMDFj
NDFkNDQgKCJ4ZnM6IGltcGxlbWVudCB6b25lZCBnYXJiYWdlIGNvbGxlY3Rpb24iKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94
ZnMveGZzX3pvbmVfZ2MuYyB8IDgxICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNDYgaW5zZXJ0aW9ucygrKSwgMzUgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2djLmMgYi9mcy94ZnMv
eGZzX3pvbmVfZ2MuYw0KPiBpbmRleCAwNjRjZDFhODU3YTAuLjEwOTg3N2Q5YTZiZiAxMDA2NDQN
Cj4gLS0tIGEvZnMveGZzL3hmc196b25lX2djLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2dj
LmMNCj4gQEAgLTQ5MSwyMSArNDkxLDYgQEAgeGZzX3pvbmVfZ2Nfc2VsZWN0X3ZpY3RpbSgNCj4g
IAlzdHJ1Y3QgeGZzX3J0Z3JvdXAJKnZpY3RpbV9ydGcgPSBOVUxMOw0KPiAgCXVuc2lnbmVkIGlu
dAkJYnVja2V0Ow0KPiAgDQo+IC0JaWYgKHhmc19pc19zaHV0ZG93bihtcCkpDQo+IC0JCXJldHVy
biBmYWxzZTsNCj4gLQ0KPiAtCWlmIChpdGVyLT52aWN0aW1fcnRnKQ0KPiAtCQlyZXR1cm4gdHJ1
ZTsNCj4gLQ0KPiAtCS8qDQo+IC0JICogRG9uJ3Qgc3RhcnQgbmV3IHdvcmsgaWYgd2UgYXJlIGFz
a2VkIHRvIHN0b3Agb3IgcGFyay4NCj4gLQkgKi8NCj4gLQlpZiAoa3RocmVhZF9zaG91bGRfc3Rv
cCgpIHx8IGt0aHJlYWRfc2hvdWxkX3BhcmsoKSkNCj4gLQkJcmV0dXJuIGZhbHNlOw0KPiAtDQo+
IC0JaWYgKCF4ZnNfem9uZWRfbmVlZF9nYyhtcCkpDQo+IC0JCXJldHVybiBmYWxzZTsNCj4gLQ0K
PiAgCXNwaW5fbG9jaygmemktPnppX3VzZWRfYnVja2V0c19sb2NrKTsNCj4gIAlmb3IgKGJ1Y2tl
dCA9IDA7IGJ1Y2tldCA8IFhGU19aT05FX1VTRURfQlVDS0VUUzsgYnVja2V0KyspIHsNCj4gIAkJ
dmljdGltX3J0ZyA9IHhmc196b25lX2djX3BpY2tfdmljdGltX2Zyb20obXAsIGJ1Y2tldCk7DQo+
IEBAIC05NzUsNiArOTYwLDI3IEBAIHhmc196b25lX2djX3Jlc2V0X3pvbmVzKA0KPiAgCX0gd2hp
bGUgKG5leHQpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgYm9vbA0KPiAreGZzX3pvbmVfZ2Nfc2hv
dWxkX3N0YXJ0X25ld193b3JrKA0KPiArCXN0cnVjdCB4ZnNfem9uZV9nY19kYXRhCSpkYXRhKQ0K
PiArew0KPiArCWlmICh4ZnNfaXNfc2h1dGRvd24oZGF0YS0+bXApKQ0KPiArCQlyZXR1cm4gZmFs
c2U7DQo+ICsJaWYgKCF4ZnNfem9uZV9nY19zcGFjZV9hdmFpbGFibGUoZGF0YSkpDQo+ICsJCXJl
dHVybiBmYWxzZTsNCj4gKw0KPiArCWlmICghZGF0YS0+aXRlci52aWN0aW1fcnRnKSB7DQo+ICsJ
CWlmIChrdGhyZWFkX3Nob3VsZF9zdG9wKCkgfHwga3RocmVhZF9zaG91bGRfcGFyaygpKQ0KPiAr
CQkJcmV0dXJuIGZhbHNlOw0KPiArCQlpZiAoIXhmc196b25lZF9uZWVkX2djKGRhdGEtPm1wKSkN
Cj4gKwkJCXJldHVybiBmYWxzZTsNCj4gKwkJaWYgKCF4ZnNfem9uZV9nY19zZWxlY3RfdmljdGlt
KGRhdGEpKQ0KPiArCQkJcmV0dXJuIGZhbHNlOw0KPiArCX0NCj4gKw0KPiArCXJldHVybiB0cnVl
Ow0KPiArfQ0KPiArDQo+ICAvKg0KPiAgICogSGFuZGxlIHRoZSB3b3JrIHRvIHJlYWQgYW5kIHdy
aXRlIGRhdGEgZm9yIEdDIGFuZCB0byByZXNldCB0aGUgem9uZXMsDQo+ICAgKiBpbmNsdWRpbmcg
aGFuZGxpbmcgYWxsIGNvbXBsZXRpb25zLg0KPiBAQCAtOTgyLDcgKzk4OCw3IEBAIHhmc196b25l
X2djX3Jlc2V0X3pvbmVzKA0KPiAgICogTm90ZSB0aGF0IHRoZSBvcmRlciBvZiB0aGUgY2h1bmtz
IGlzIHByZXNlcnZlZCBzbyB0aGF0IHdlIGRvbid0IHVuZG8gdGhlDQo+ICAgKiBvcHRpbWFsIG9y
ZGVyIGVzdGFibGlzaGVkIGJ5IHhmc196b25lX2djX3F1ZXJ5KCkuDQo+ICAgKi8NCj4gLXN0YXRp
YyBib29sDQo+ICtzdGF0aWMgdm9pZA0KPiAgeGZzX3pvbmVfZ2NfaGFuZGxlX3dvcmsoDQo+ICAJ
c3RydWN0IHhmc196b25lX2djX2RhdGEJKmRhdGEpDQo+ICB7DQo+IEBAIC05OTYsMzAgKzEwMDIs
MjIgQEAgeGZzX3pvbmVfZ2NfaGFuZGxlX3dvcmsoDQo+ICAJemktPnppX3Jlc2V0X2xpc3QgPSBO
VUxMOw0KPiAgCXNwaW5fdW5sb2NrKCZ6aS0+emlfcmVzZXRfbGlzdF9sb2NrKTsNCj4gIA0KPiAt
CWlmICgheGZzX3pvbmVfZ2Nfc2VsZWN0X3ZpY3RpbShkYXRhKSB8fA0KPiAtCSAgICAheGZzX3pv
bmVfZ2Nfc3BhY2VfYXZhaWxhYmxlKGRhdGEpKSB7DQo+IC0JCWlmIChsaXN0X2VtcHR5KCZkYXRh
LT5yZWFkaW5nKSAmJg0KPiAtCQkgICAgbGlzdF9lbXB0eSgmZGF0YS0+d3JpdGluZykgJiYNCj4g
LQkJICAgIGxpc3RfZW1wdHkoJmRhdGEtPnJlc2V0dGluZykgJiYNCj4gLQkJICAgICFyZXNldF9s
aXN0KQ0KPiAtCQkJcmV0dXJuIGZhbHNlOw0KPiAtCX0NCj4gLQ0KPiAtCV9fc2V0X2N1cnJlbnRf
c3RhdGUoVEFTS19SVU5OSU5HKTsNCj4gLQl0cnlfdG9fZnJlZXplKCk7DQo+IC0NCj4gLQlpZiAo
cmVzZXRfbGlzdCkNCj4gKwlpZiAocmVzZXRfbGlzdCkgew0KPiArCQlzZXRfY3VycmVudF9zdGF0
ZShUQVNLX1JVTk5JTkcpOw0KPiAgCQl4ZnNfem9uZV9nY19yZXNldF96b25lcyhkYXRhLCByZXNl
dF9saXN0KTsNCj4gKwl9DQo+ICANCj4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY2h1bmss
IG5leHQsICZkYXRhLT5yZXNldHRpbmcsIGVudHJ5KSB7DQo+ICAJCWlmIChSRUFEX09OQ0UoY2h1
bmstPnN0YXRlKSAhPSBYRlNfR0NfQklPX0RPTkUpDQo+ICAJCQlicmVhazsNCj4gKwkJc2V0X2N1
cnJlbnRfc3RhdGUoVEFTS19SVU5OSU5HKTsNCj4gIAkJeGZzX3pvbmVfZ2NfZmluaXNoX3Jlc2V0
KGNodW5rKTsNCj4gIAl9DQo+ICANCj4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY2h1bmss
IG5leHQsICZkYXRhLT53cml0aW5nLCBlbnRyeSkgew0KPiAgCQlpZiAoUkVBRF9PTkNFKGNodW5r
LT5zdGF0ZSkgIT0gWEZTX0dDX0JJT19ET05FKQ0KPiAgCQkJYnJlYWs7DQo+ICsJCXNldF9jdXJy
ZW50X3N0YXRlKFRBU0tfUlVOTklORyk7DQo+ICAJCXhmc196b25lX2djX2ZpbmlzaF9jaHVuayhj
aHVuayk7DQo+ICAJfQ0KPiAgDQo+IEBAIC0xMDI3LDE1ICsxMDI1LDE4IEBAIHhmc196b25lX2dj
X2hhbmRsZV93b3JrKA0KPiAgCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShjaHVuaywgbmV4dCwg
JmRhdGEtPnJlYWRpbmcsIGVudHJ5KSB7DQo+ICAJCWlmIChSRUFEX09OQ0UoY2h1bmstPnN0YXRl
KSAhPSBYRlNfR0NfQklPX0RPTkUpDQo+ICAJCQlicmVhazsNCj4gKwkJc2V0X2N1cnJlbnRfc3Rh
dGUoVEFTS19SVU5OSU5HKTsNCj4gIAkJeGZzX3pvbmVfZ2Nfd3JpdGVfY2h1bmsoY2h1bmspOw0K
PiAgCX0NCj4gIAlibGtfZmluaXNoX3BsdWcoJnBsdWcpOw0KPiAgDQo+IC0JYmxrX3N0YXJ0X3Bs
dWcoJnBsdWcpOw0KPiAtCXdoaWxlICh4ZnNfem9uZV9nY19zdGFydF9jaHVuayhkYXRhKSkNCj4g
LQkJOw0KPiAtCWJsa19maW5pc2hfcGx1ZygmcGx1Zyk7DQo+IC0JcmV0dXJuIHRydWU7DQo+ICsJ
aWYgKHhmc196b25lX2djX3Nob3VsZF9zdGFydF9uZXdfd29yayhkYXRhKSkgew0KPiArCQlzZXRf
Y3VycmVudF9zdGF0ZShUQVNLX1JVTk5JTkcpOw0KPiArCQlibGtfc3RhcnRfcGx1ZygmcGx1Zyk7
DQo+ICsJCXdoaWxlICh4ZnNfem9uZV9nY19zdGFydF9jaHVuayhkYXRhKSkNCj4gKwkJCTsNCj4g
KwkJYmxrX2ZpbmlzaF9wbHVnKCZwbHVnKTsNCj4gKwl9DQo+ICB9DQo+ICANCj4gIC8qDQo+IEBA
IC0xMDU5LDggKzEwNjAsMTggQEAgeGZzX3pvbmVkX2djZCgNCj4gIAlmb3IgKDs7KSB7DQo+ICAJ
CXNldF9jdXJyZW50X3N0YXRlKFRBU0tfSU5URVJSVVBUSUJMRSB8IFRBU0tfRlJFRVpBQkxFKTsN
Cj4gIAkJeGZzX3NldF96b25lZ2NfcnVubmluZyhtcCk7DQo+IC0JCWlmICh4ZnNfem9uZV9nY19o
YW5kbGVfd29yayhkYXRhKSkNCj4gKw0KPiArCQl4ZnNfem9uZV9nY19oYW5kbGVfd29yayhkYXRh
KTsNCj4gKw0KPiArCQkvKg0KPiArCQkgKiBPbmx5IHNsZWVwIGlmIG5vdGhpbmcgc2V0IHRoZSBz
dGF0ZSB0byBydW5uaW5nLiAgRWxzZSBjaGVjayBmb3INCj4gKwkJICogd29yayBhZ2FpbiBhcyBz
b21lb25lIG1pZ2h0IGhhdmUgcXVldWVkIHVwIG1vcmUgd29yayBhbmQgd29rZW4NCj4gKwkJICog
dXMgaW4gdGhlIG1lYW50aW1lLg0KPiArCQkgKi8NCj4gKwkJaWYgKGdldF9jdXJyZW50X3N0YXRl
KCkgPT0gVEFTS19SVU5OSU5HKSB7DQo+ICsJCQl0cnlfdG9fZnJlZXplKCk7DQo+ICAJCQljb250
aW51ZTsNCj4gKwkJfQ0KPiAgDQo+ICAJCWlmIChsaXN0X2VtcHR5KCZkYXRhLT5yZWFkaW5nKSAm
Jg0KPiAgCQkgICAgbGlzdF9lbXB0eSgmZGF0YS0+d3JpdGluZykgJiYNCg0KTmljZSENCg0KUmV2
aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
