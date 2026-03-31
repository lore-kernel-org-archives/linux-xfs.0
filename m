Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05C73CF668
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 08:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944239; cv=fail; b=Wy8RlOkWWGI9Itw1h9bLlqoDkLURGQvOHTzZiExyVbPR7FU4d/glFrZJC5U/lF+Mlz797W8Yow0bQrac9FE2gzH1uzabjELO7ynfseV2UkfRNOBZ5YcJrjt5q7RR0hUzBaqixh1SGzesYBAl5PywdeuhLFiaZRw8S0cXkMOe3xQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944239; c=relaxed/simple;
	bh=A7+WC2nOxRedCnB06OfmlW0IvMHeBqIPL9l32LrPjDY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=orBTu5C6TYUFndyntz5FpdZewNcXY2h+xRAYJQnNlKwNkIDg6zpEmP82Ic4xBK/gWfmMRdOhlKUlBwCkaYRIDHWIAILK9Rzq+acwAuVZXF+L/INl2TWkkoEC71gPTwDcnCkUMSfJsuXjxowrsjabPHLlNoQxCt3EQmuttxgD+/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=p8ot17Ks; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dJoDVM/a; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="p8ot17Ks";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dJoDVM/a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774944237; x=1806480237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A7+WC2nOxRedCnB06OfmlW0IvMHeBqIPL9l32LrPjDY=;
  b=p8ot17KsOjCiCj54lY2rypCPnejMgF1m+jPxxJPXQJ3vuyaXDTzsLU3h
   JFYGh2ciw6V7OHspoIPavo8kBXeofLxNURCHqrNh7E5oGMAmgWlAv5T2T
   GSfKniLo9etIGRHiIGlG199kPnPy6Mw9pi4HY+9JFu36uE7iiFU/GjAkD
   BVkQ92TQuW3gAghmHTrRS7J1+ulfhhv7pUqujlaDNgdVMhchYwCCc+LLN
   lcjeCh/6H8oLG+2K07Ilf/JR9XxVoPurWYdsZGOtSvD6U1wsYZNtO9lPf
   a7hgmjV5eMeQ2iwDdDS6s0oEnCpg2d/bGAbX3Lroda9COvW1qobIHC4Pg
   g==;
X-CSE-ConnectionGUID: sJiSHaoXSjG5gkhB9jUETw==
X-CSE-MsgGUID: 1N1w9mQHQVWuWCW4ncUqNg==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="144724126"
Received: from mail-southcentralusazon11013049.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 16:03:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m4eVJ9zL060rVZIy85JgjmZcutWJYe0w7Wzs78oa8yGfrusasT1cZQyEQnOdsD6WYFTTYkfVaPIOhrXVApZnYW8o5gtFPULi4h88A+uuL0uKuC5SKVTDdaSxw+XRRWufvkHBfstQ/a41phxZKidM5vScE2MrB4BdUx1/L7wqYfBArtpfVVsfmgeAwkUx3NjbNurxSapA/sEfcXAXs+xBItSavc6CRNjmR1g0GvtQWfr7d8jKtwxN4vwQEaYsQ0PTb2aodaW/Lo3fCL8U8zNtjChyZz6e2DU2ajuAHNlpsZN812Bo023OcaJCtRvWCUhbPhxZ2iGrrNxqc+jgKhtYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7+WC2nOxRedCnB06OfmlW0IvMHeBqIPL9l32LrPjDY=;
 b=vW39TLNxQG5OI/Td4wBWRKLkTVqMmMqTP7ss6UZiSZ3p2731N+eCXGL7hcT+5MRwoNVft5sU7AexAWFVAF+t168q5/UAsEt2gqrFqnwzbQ0c5K18oTMQfOzEfzs1zATcUHDeC62/76Bd3lmt6bAt3h0wa8U/gY14FLa9POpaKqEry1X1ESdLsekiW6aahf+sjRU/3tQyOVoVJkiAFNOMav7DqjM05jCk0UdfmAIv+gJG5DSjoqcnzmxztSp76yCmShRMQZKdRIYZP8gIMflmiZrimEgrwU4Hcely+YO21pn8Pya4Qx93jreb59h4AZvzxS7HceU7c8P46Bmli9UMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7+WC2nOxRedCnB06OfmlW0IvMHeBqIPL9l32LrPjDY=;
 b=dJoDVM/a+6MviH7vPTrl+v0D3X+TJbJTIhW5hHW1nz7c1s2wJOSyE9C4GzUtYHRlcuet/EBrOt694n2rBr5uD6fAO8AIkwfpc+TfALjhEDZezLGAz/p0EDp7HJRfNTSDOM9AVNTkt/wyZ9rM8Ur4LID41Znjxkyr/LelQhKXRZ0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DS0PR04MB8599.namprd04.prod.outlook.com (2603:10b6:8:128::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Tue, 31 Mar
 2026 08:03:49 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:03:49 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/7] xfs: add a separate tracepoint for stealing an open
 zone for GC
Thread-Topic: [PATCH 2/7] xfs: add a separate tracepoint for stealing an open
 zone for GC
Thread-Index: AQHcwAiCJ6XBqoORI0GKRpIY5xz0grXISb0A
Date: Tue, 31 Mar 2026 08:03:48 +0000
Message-ID: <9d75ad73-f6e5-4746-902b-ea537dd8df33@wdc.com>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-3-hch@lst.de>
In-Reply-To: <20260330054533.3856339-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DS0PR04MB8599:EE_
x-ms-office365-filtering-correlation-id: 382a7a1d-01aa-4e97-4d44-08de8efc0a5a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 rrNMu3kmAqg3DCxTbjFKPwKaqwVfTPUP1dshAFyxZHzEB8i6Nou0MdVhzMqAnxLDealMwlSPuzyUR4Zw6I2Ulbc57crom89AFiGlnzXL1k1e3v/aKro87u7xBgqbK0+E1fGKfoJnQzezhyBBabBtZw/tZ3NzH2uc8ijVUIY1IanmucZwUzSbZw8EpOyb1ORL3RFmSCk9ttimPL6S0MFV/++c1NZQ0dP2mwBRXRjKy4QQUtw42GEu83qZGEPYsX2ccOAFTSxN+sVul79Z6rOg0/1nnoCEHKIT4leiRlYyWVAe6uDG5A3xhkZUPNExoo3a7s8dpiVdvSL4RwLG8jsk65prEJ2Kg5msc2ZP/y6vGnisKMq2S59Z93sK/xBUNTC4ZfFyfAjPZVdFKngjKp11Ht8oxv3YeGbnaMTg0jLKsQ9ILStyfBMMuSHH73I859zzWhLBXnzmuzkkeQE1erjU+5CdummEPk7Zi7O9Xo4beqeWBxyFh2Ec+Y3SyVe92yVfUxwydAJx3bycXbgvbjeXYdx4v3MY24unzaNp8xl8Px6JzCUUrFS2NZ0hcwNBjFDrDFFi3OGa8XCYMlG2JvecqAAD84Mx/0klR4Yzzdm0UfAFtlPlARQSypymDBXooyGITFeuYn+0moioefEYCWZ335GLQxGbEiS2g4EPDLEifRJU24C7Q0m7qZrB9STO57Vnx1kgBCbzxeJjq0+AFmaLhFxIHgsPMEIb8YqB5hJz0p3QU+QgEsF70XsyzOMd05WIFg8cKA0bMNPMyJb76n7G+4Tm9SHP3DlMcAQdr6MnGeQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WktXY1RQcjU5c0lYc09nRlpETlFyMXJ0dUJJREliazhwVEJNeEo4bmxGelFn?=
 =?utf-8?B?cGhJSUV5RGR5MDNrQTdSREpoZk5MclFyTDlVSlo5SitvajZlRTZmNFFncXFp?=
 =?utf-8?B?SzRHMGpML3JGWXZnaG0xaWQ3eUFhK25FRFVJVzFsNnAzMnNnVVdEUU1md3hj?=
 =?utf-8?B?ejZjTG9ESUlpdTRYTkdvbzdzSS9TZGlDYkxhQVFGZWhtQ044TU4ybUxHUlE0?=
 =?utf-8?B?WkZrMWw3ZTFFTXhyV3pqUTcxZVFSUlVrVkJxcTJXaUpxUlpyQitiMStOdGFl?=
 =?utf-8?B?VnhmOGQrS0RXelVpVDdaanYwM0hPUWZvL1c5d1BOTUhzY1hhdE9mZ3pZeGg0?=
 =?utf-8?B?SkQwRmZ4SVJJeVp5YnNjM3NxVS9wblFkYzFDd3FZNzB2TkJJS0dMVDRMQm5x?=
 =?utf-8?B?eXlHUUlvank2U2ROMmlnZkh2UUtvdmJMMXYzL3NLcTNaNjRtaXhjZTBrODdK?=
 =?utf-8?B?MnVlRERrbTErSXlGUVJvcENUbzQvWDBHdE5sbjVIT1htOWxmdjNqNk55d3Zj?=
 =?utf-8?B?VFpZRHNoSUp4QnZHdTAxVllMd0srcEZ3NjB2YUxhL2FOQzd3eXFJaDRVT0h0?=
 =?utf-8?B?dklTb3dmRVljS3NtMS9ORnRKZmorQTB0M2VncFArOTBWajJ1MDI1TFRLV1pB?=
 =?utf-8?B?K05aNkZBeDFMb1BXSHlpSDdYbmk4R3A2SkxQZE01aWlDR1BvdnBvamlDaGNU?=
 =?utf-8?B?T0tTekFmaDF2eXRDbFdpOEhKL2FFcTJ4VUd1KzNiYmpzZk5JVTh2Ly9jMDRS?=
 =?utf-8?B?NmFSZ2lIMk45WEVET25RWit4dVBtYWxsNmhXTHZXT2ZMWHhnUlhHWVkzeThx?=
 =?utf-8?B?emJjYlJzQnBRaTRKNCtsc0ZsNmJLUDBjY3hwSlhPWS9PRFE5Z3pzdk9qUDFX?=
 =?utf-8?B?cG94VGZzVGZnSi8zbEY1NU1IYkRLbFlacmxITEdSQ0VoYzlqMWlXUlo2V3Vo?=
 =?utf-8?B?ZWo0a0tpL2djK25vUW92SEQvQUpIazc3bldRbllwZ3RzdTM4elozeTczV0lW?=
 =?utf-8?B?YTJ5RThpRXdkTzFYYjVsSEpOb3Rpc21RL3gyNU9EM3U2NGYzOCswbE1EVy91?=
 =?utf-8?B?T2UxSDh2bjQySUZ2MGtVa05LWG1nWGU1RUx5cjliU05sNUpLNlBXVmVXYmdq?=
 =?utf-8?B?RllqZWtCWTdTVWxNK2xLRVRTZEN0c3N3Y2RISkQ1b1lTa2o3b3l5Nnhtc29U?=
 =?utf-8?B?TWZHYloxKy8yZXo1WFpRK0d2M0lqR0ptbDFBRFd2ajNISTVqNHEzalhQaVJz?=
 =?utf-8?B?dm5vWS8ycFYyMzMrQ2xuMENBczZHRnJsQzJxbkw0L0JqdFNhc21mNG1GUGc5?=
 =?utf-8?B?K3h5amxpdVJmVjVOLzNuWUF1Q3V5ZWo5em00NS81dy9UWmVQaVgzVEtQbFdN?=
 =?utf-8?B?S044eVlCbmdDaGppdWFPd2JRZjZVVkprSXZlMG9wS042TEIvQmVmT2JOZVZh?=
 =?utf-8?B?U0d4emxjT2ZOZ0NvbW4xSnV0YkxWeGRDNStJdEFvN0hLUU5PaTR4NTMrWkZP?=
 =?utf-8?B?ZFEwV1RkZ0FSVTJnb0lOSFI0UnZaeVpucmJENW9oNS84d3hWK3gyV2pBS3pO?=
 =?utf-8?B?Sk5oR2pWT2lnSTBHOEsxTllVZ1doTHlTcjRxSVhLeFBRMGJ0TTZXU2lUQUdj?=
 =?utf-8?B?UVZKWGVQenVZT2xIRFRCeW1jdjlaNlUrL3dNdzdzdFgzWFptcUE2aWxHZ2Jp?=
 =?utf-8?B?MnU0NEF5Q0RSZUVTZ0lSc1piWVVKbEhaK2dqRlk0V21LUDNKUlI1OG1WYzkr?=
 =?utf-8?B?Vk43ZUIyZEY0MXJwSVdhZXprQXMrSWlqSHZZc3E5OGhJQzRLbm1ad3I4TlR5?=
 =?utf-8?B?UmNmczlqeWJiWnBubWxXczdaM3JDdFdJdjNBT0pIMGZZQzUvYTNwQVlVdld0?=
 =?utf-8?B?b2hCQ0NoeU05SHkxRTNPdjRXeTB1UzF2WERkSXRUVld6QmdPZ2VEaHNweDJ1?=
 =?utf-8?B?UDRzd2VHYzZNMVJpT0c2S0ZXb0xFR1dVMGVNMTEvaTdFNjV1N1JIQThmS2R0?=
 =?utf-8?B?R2dzY0ZrdDd0ZG1KNEhJQWlmbmlxQ25GaWtWUysvYkFERko2T3JMV1pleGpw?=
 =?utf-8?B?Mlc2ZFVydFVkUXUrSVM3YVVjWTRSSXUrQ3lCbHV6amhDRjVialkxMEZWRUsw?=
 =?utf-8?B?OFlUbkJtbE1FM1Nybi9CbE9QS0dPS2Y1eUFmS01paXp1SjR1dU0wT2ovVG93?=
 =?utf-8?B?bkdielVMYjJKUS9PdUZ5R3o1S2VQamYwNHhZTEdXOXBYdDZETXc1YXMwK1Fv?=
 =?utf-8?B?VGdMcFhnSGUwK09XV1k1RCtPN3JZNWJBdW80YzZXSUZZS2NqZFdaVWZmeDln?=
 =?utf-8?B?TmtnNWRKamh2N0U4eDVxMXcyVG83SEZVQlliZEh5LzhmZ3RHNml5dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5E1DAE90974664EBB5EC1C56DD5F2E9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	BHh8NtwX1ytj9O68eshhqsiaj9s77s5Ywv2ChsEIdXNsOnmNj9o1ndayUCiPHpIl7Ur6gu1JOwTICTVwRJd15mbH1PSbr93Kfs/jghVUzIfpZ0+GHIBYys13S5Kiv93Q6xhZZd6q8IFUg99cC3OxGOth6wicbpVQU2eBFW1lbMs/+NSQ9PdboKX5q04SMNoZZAWXxXlt5Gy6tLMdLyRLwgd5WQTQJxYsFd8zTCgKycfNJkwZCTLNmxNuF/ojxOc9g64ZL/jPtyg8lyjbwfpED5JwQ1h6y8knRQdQ4y5JGQrVyU2HFZs+9BRru9sd/wuo8Fly77zUxJeeS73dVmx5uA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3rREmWmgh9eEQAi05q38Vgldi5aMBaUbhhbxViAusGVvmuVPn3L5HEgUqUacf5NzFZwRNVy7n2ZnWgBZGeHIDOgGJDVnzVVAyWGDUA3T/Mo9TcJWkmCoVm7ftBgq1jVf0Bsa68y1IxyYjx95lQTZdOR8DbwH3YkMcvAYPZWdZ+M8PWlrl01nsekdFRZTp2SMoFrqx70pXqtcdA7mEbEL6zQP4blZQ47RpHMGWte2aoRvUGYwzq2HdY5v3CMUT1YWoGaP2f7dCGNxCiKqQKIMHf2rWOOcrJ+hkkY0S1g4WWU1adAMANc2sep+0CFGVE6Zpe4xVh4OGgeYhhFAJHg3h2n+P4F2cQ1/0lz1UVPCkchZcLfZKJS2S/D28jCMUGOUtwwy8FGUe/0xYgnvauQVIUu9Sx6kGxIHvASsXFkhRQ2vpGZXErrUWcEHpitjz+cyDoQ77791Odm/Hd8rdalBvfw+Eyz9jWutjYxx7bcVEegs8OJ9TiGo1wRHyyTL9iQhNq+qvHXaKWAZeq8CtVhxxP931ODkh6Qdnv/ghpcyI4FewcUIqw80npQ9FbT38SdgtCGI4tvm49h4cJNmdST4zxvMT1wtwLoO7CcM+olVmiYDif2un8R5X8LpbfTEjqeV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382a7a1d-01aa-4e97-4d44-08de8efc0a5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 08:03:48.9150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HjKfyw21juXTd+KAvxpggwUYStYDxT3sPN3DeY1g+TV7/NLSxYpjBB/yxovPkbIrOM4kR6cR1bfi2TLaxC0AdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB8599

T24gMzAvMDMvMjAyNiAwNzo0NiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoZSBjYXNl
IHdoZXJlIHdlIGhhdmUgdG8gcmV1c2UgYW4gYWxyZWFkeSBvcGVuIHpvbmUgd2FycmFudHMgYSBk
aWZmZXJlbnQNCj4gdHJhY2UgcG9pbnQgdnMgdGhlIG5vcm1hbCBvcGVuaW5nIG9mIGEgR0Mgem9u
ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0K
PiAtLS0NCj4gIGZzL3hmcy94ZnNfdHJhY2UuaCAgIHwgMSArDQo+ICBmcy94ZnMveGZzX3pvbmVf
Z2MuYyB8IDIgKy0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc190cmFjZS5oIGIvZnMveGZzL3hm
c190cmFjZS5oDQo+IGluZGV4IDQzM2Y4NDI1MjExOS4uYzFhYTE1OTczZTc0IDEwMDY0NA0KPiAt
LS0gYS9mcy94ZnMveGZzX3RyYWNlLmgNCj4gKysrIGIvZnMveGZzL3hmc190cmFjZS5oDQo+IEBA
IC0zOTQsNiArMzk0LDcgQEAgREVGSU5FX1pPTkVfRVZFTlQoeGZzX3pvbmVfZnVsbCk7DQo+ICBE
RUZJTkVfWk9ORV9FVkVOVCh4ZnNfem9uZV9vcGVuZWQpOw0KPiAgREVGSU5FX1pPTkVfRVZFTlQo
eGZzX3pvbmVfcmVzZXQpOw0KPiAgREVGSU5FX1pPTkVfRVZFTlQoeGZzX3pvbmVfZ2NfdGFyZ2V0
X29wZW5lZCk7DQo+ICtERUZJTkVfWk9ORV9FVkVOVCh4ZnNfem9uZV9nY190YXJnZXRfc3RvbGVu
KTsNCj4gIA0KPiAgVFJBQ0VfRVZFTlQoeGZzX3pvbmVfZnJlZV9ibG9ja3MsDQo+ICAJVFBfUFJP
VE8oc3RydWN0IHhmc19ydGdyb3VwICpydGcsIHhmc19yZ2Jsb2NrX3Qgcmdibm8sDQo+IGRpZmYg
LS1naXQgYS9mcy94ZnMveGZzX3pvbmVfZ2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IGlu
ZGV4IGYwNzZmNjZjNWQ1Ny4uMjczYzQ5NmMyZjFjIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZz
X3pvbmVfZ2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiBAQCAtNTQzLDcgKzU0
Myw3IEBAIHhmc196b25lX2djX3N0ZWFsX29wZW4oDQo+ICAJCXJldHVybiAtRUlPOw0KPiAgCX0N
Cj4gIA0KPiAtCXRyYWNlX3hmc196b25lX2djX3RhcmdldF9vcGVuZWQoZm91bmQtPm96X3J0Zyk7
DQo+ICsJdHJhY2VfeGZzX3pvbmVfZ2NfdGFyZ2V0X3N0b2xlbihmb3VuZC0+b3pfcnRnKTsNCj4g
IAlmb3VuZC0+b3pfaXNfZ2MgPSB0cnVlOw0KPiAgCWxpc3RfZGVsX2luaXQoJmZvdW5kLT5vel9l
bnRyeSk7DQo+ICAJemktPnppX25yX29wZW5fem9uZXMtLTsNCg0KTG9va3MgZ29vZCwNCg0KUmV2
aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
