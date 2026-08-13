Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EAB442B08
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 08:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609735; cv=fail; b=QdhnyGXDK2CH4B+lEFlPJtgRgtubYs8rc4JhXy8NWrJwR7JjByu3bnLxtS+rGskXLXXpDe481l25V/Kb+Hq0mNeOGDwCPIks43rdz47LbPJoue51/AHRMH00VPViAmqXMEVmHWWBQBEqVS1EhasHHniIbiARKptcM9K/YTLaRIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609735; c=relaxed/simple;
	bh=DhTVMOXJhRc1j4WEVDGWD74gxms/vyeO0V0hWpTv8f0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sI7QaCGpXEP1W3uo8HIGpsfwV7erdxXNetqoT5umQ4NWlZrN62WV7GMTgkhFglVXJhFOYGs4+28DisD6+WP/9OXEl19I3AcPjJvnvNxqolmDKOrF5dSR5IVcybrSRT6pP4h1dOnGjJEhej366S/9ZmxVgiAwiZu6K316obEmqtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZwCTIV8e; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=OH29to/y; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZwCTIV8e";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OH29to/y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786609737; x=1818145737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DhTVMOXJhRc1j4WEVDGWD74gxms/vyeO0V0hWpTv8f0=;
  b=ZwCTIV8ebgoWOXOOnMNBRvkpiiKkYAvN42AvejUB4qcBHYY5C+xdyM14
   ERd6Zor8x72WwZ/ubY3wei6l6ERYNLlxCZCMil+iDQ5v+uiBALJgFYTGx
   EVKP/hdrpr1pJfLwkHyDDNHcVcb707gYuz9EjNNR1Kk4OpLfxKh1xYZEi
   rcfnEKH/hON6hfFUc8FANxAAU7SkRvSZyMGIzBh+I0rvXBLzzBRiChyeQ
   f560cB1w1mEGTRwSqeyeRTse0/mhDyuLF/UhK5TxyHdhX628CEPDmdzpn
   z811UFjOya6HrBkF/wNDUqBaFcDTNPW1t/lITF1l/Drl/34DMuu7Z8BaK
   g==;
X-CSE-ConnectionGUID: 6us4uy+PQhOBo4t7fdAo+A==
X-CSE-MsgGUID: k27ClEffSB6hI7daoHC5Aw==
X-IronPort-AV: E=Sophos;i="6.25,221,1779120000"; 
   d="scan'208";a="148887022"
Received: from mail-westus2azon11010016.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Aug 2026 16:28:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wM1OYRshGgCLMBeOWzULmUq9gXf8EJ56qnSlvPXhRzixD5EadJ8cakrYMvOyaf2w0K50uh+VIsijEmUNN2H/uc1d/nLtVvSwOC/RXxOJbiPvuESGn9TNkd7pKUu9KR3CGtVkUcjUUjmqBQU93m3luFz0oIp20Gr3BXfPk3SAmunltzeXMkRFpCKKD5LwSxaHSPUy+KR+vDQdd4/9UQ0qm4RImATJZ0gq6NlRHt2788L/BRACVeqrHoUEw5PV9/IiFsmIJfu2w6soRA5YiBfaOWpp5S7+8Zf9btV4GFaHF6Zs7CiyGn6eWEJ3I2jmjRPwoNn199BuFlB8RFvYneBUAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhTVMOXJhRc1j4WEVDGWD74gxms/vyeO0V0hWpTv8f0=;
 b=SC5f5iEe8lHSw266n1T/BocqccZbPBIYAF0XW8XRB164vObqBxHxYYg5A0kVKMraaX/GrkHsdETRGmkyOZeEt+9XVvFxWAQMqgzoxQes+mjA8TAZN9+kZ1yhk88XKlqhNDPeY2mas/SprGNNp+GxaPao+s6Cxr37hm08oyHIkZu3lzrHheP0lYLRRiQfgW1kn+7zIXbB1Tt7Ng34LQJzXGfBORBIXHEPr8n/CiFPqsMZtHB+gK22+oDb1ggTMn+Hu0u9wrpFZlZWfjnqbvuSJ2QU5ZgE3pJjprak6pLUpfwaCUsxnOB1yIx3tGOLW2TVUckJRjlEUICEI2WDA1nVLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhTVMOXJhRc1j4WEVDGWD74gxms/vyeO0V0hWpTv8f0=;
 b=OH29to/yT/G7rGARkGstuFX1OVtas8uumSYhpjHmbRD52e2nMdose47ea91x4j0b64S25MKLaBP0+RH2K/Sc3zwwutvaATzl1+ItkhAobsmG0RESCAA/L+oC6JndZoeuXIrcEkInh901HcxAUtJv/Mx4kiELIVz1K90lujUNDrE=
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by CO6PR04MB7793.namprd04.prod.outlook.com (2603:10b6:303:13c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 08:28:45 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0315.012; Thu, 13 Aug 2026
 08:28:44 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Wilfred Mallawa <wilfred.mallawa@wdc.com>, Damien Le Moal
	<dlemoal@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/5] xfs: factor out a xfs_iomap_set_anon_write helper
Thread-Topic: [PATCH 4/5] xfs: factor out a xfs_iomap_set_anon_write helper
Thread-Index: AQHdKbGCZADoVqS/8kikxgen3o7p9rabqB4A
Date: Thu, 13 Aug 2026 08:28:44 +0000
Message-ID: <bfa0a72b-8f1d-4bac-9774-b6abfb455de2@wdc.com>
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-5-hch@lst.de>
In-Reply-To: <20260811164912.124416-5-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR04MB9269:EE_|CO6PR04MB7793:EE_
x-ms-office365-filtering-correlation-id: 4c8bb4a5-5c58-4654-276e-08def914e3c7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|376014|366016|1800799024|38070700021|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 c1K7q1dSQb8C3I/TVKPjQW1Q4rzQRMgt6C+h9v77uOIG7AWtwHtJYhO0xlv3Nv9psoBPcPi0/4dsUMHlaLZItxuGI+uuzPGPhiH83egXDhla4nXCubGCj9djvKat1t2l8ArEz6Ckcq7wwcCUiH+vTLtEf1a0bCwGohptIxGc7QZMepuls3dM8WETnA+/eA2Z7NHLu7zk1I7DxgtpDha+3JpJ/RNC+S9wDh5LQPKw13H7ZXNtGbbkl5UONeXqhPDd2zPjvoVmgnc8WoiiSGmZCiMjcDKJnStEP2XDEIHz+FrjRcghJ3ttborT1yh1k/+5safDE17EULci3gTdB7IeKc6u68w9QrAMKkbOxOeTgFnrFwyCgH10/s8hiw717HkWStGCmyjzu/kWDv0mKYS4LnF5gSHE8u8AoW/hUV/d++LAVEXrRJU2elDawXdJWpidtxmYuHUjZQ8FFJJ/NnF4xZ4c2ySc50Khk8SABvo0Ep5CIoUGHfO0CG+cyKhGDy7kChtr9Zu368Fjybc2+98kNtFoRiYQVmQONL2TxYx7t/+vyPEBm+EbuqyFTBN1/Ca3p0I5VJq0daAkrjUvmY1UW5WSVYlcCFIIOygqRBMmNIzJB+xtf+y5ZXXgauyzbIXrDkzn360cAIg7c/S3DEXAtTxlm7+d0BPGQqXE5VmuRu8jOwYw/9yqnx9dCfG8v4uTj9VR4wVT/b5h108FpD1CTZo+H264NyjToHrq7MoMJEc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(376014)(366016)(1800799024)(38070700021)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eUNLRkVhUjBoTHUxeWRBeTJ5SmU4NjVkeit3bkhsZi9SS1JjUHhwYjdZSW1h?=
 =?utf-8?B?TU4xaGpiNXo3Vmx3cHVyeDFiTkYvcXJ2NjMveDUwS3RPZUQ0akVoc2piNTZD?=
 =?utf-8?B?Rk9HSUVMZ3hJVGg4RWJrOUcvWXFFelVqTjNKTHAyVWM4NnBjNm5nR2JhRE5H?=
 =?utf-8?B?bDNnczk0d2lTQ2NuQ2pRdjd3QTFDbVh3MGZCcmIyaEw1UmI4c2RGREx1akdO?=
 =?utf-8?B?UkZMQkZkYzhiTUsvZkJIeTVRVlljZHIxMlhEV3BHRW9xUW4xVFRKeGxGeWdV?=
 =?utf-8?B?cVAvdlFyNE5oQzFueVBPRHhNdEVRbVp6a3N1ZVloU05tYVZtcDNLOXh0dmdM?=
 =?utf-8?B?NHFGaDdpN0lWSzhmd1pTQ3BjSGQ0SzV5ZjBITURqdFhpU0s1ditGYWR0cElk?=
 =?utf-8?B?V0lKSDU5ZHFzQWxSUVQrR2duUmZuMjFwbEVlTjJMSDRtSlBITXdKU3cvLzBv?=
 =?utf-8?B?WlBxV2VjRXlOYzM5MDRzQTlCVHU4a2R5a2tDbC9yNERjSEtzcmtsR3JnSjBu?=
 =?utf-8?B?U0t0VTE4am56ZFUzdlkzZlRpSlFWbzM4VzRFT1JMQXlKSGFvYWNqb2FMMXNi?=
 =?utf-8?B?RmwyaU9UZ2RHb1JTeERMK2puNEg0anlBMGhWWGdGeHpHL3JhSUtNVGdmb0ND?=
 =?utf-8?B?TEtib0IzT2wvbWUzVXhXMmlQV093aFJPNjhEOHlXbmZFVG1hZmd4aG5zNTNQ?=
 =?utf-8?B?VlRiQldoVlFZS3YralRvYzF5eFREQlAxTnkxakp4RmlEdnUrTVd0Yk40T2Vq?=
 =?utf-8?B?ODV3SVU0MVFYaFo1c2NqOUpXck01RmVzY0I4TnhGVVBwWTVIMXM3dW5JYTJn?=
 =?utf-8?B?SlJ1VlpMQVFnT0kwa2hWTXZKWmJaNmo4S2hzYW1IaGxNS0xGZUM2cFhXY1Bi?=
 =?utf-8?B?VERUVkpPcGUxNGlZY0h1WFRoZGpoMlVQMHdkVzBYaVJ4K3Jmbm9WdjVJcGJ2?=
 =?utf-8?B?ckdOdzd4NGJCTk9nNGlSV2pZNk42VTB0clF0TU1xazRMWEwwbCsybTJ1c0V0?=
 =?utf-8?B?ODRsNVJVRmVFeExyZFpzWTFOTXVLVGp0SEJXMDJGQzZEZ0NRTUFzZVFaVXhr?=
 =?utf-8?B?QWNsOW9PVGM0VmpYWkFaaDhnTENFOWFMaEFkVTVpV3RkTnJPQTUxYW16TDAw?=
 =?utf-8?B?UnZDT1hvMjZ6RFFLVUxBbldrbU41MGo0aGtzU3JXTjh4VXl0RVNIcXRvWjNH?=
 =?utf-8?B?akc2VXVqUUZ2RThXK2FHbWVJdEJMcExmL0FYRC8xdHdEa0FwK29BUmpCb3Za?=
 =?utf-8?B?ZXFCb3NSYjF2ZDE4eU5lVVZWaEVsT25GT0ZGWW80TGl2eGpCTmw3K0FKb1Yw?=
 =?utf-8?B?TGlaZlVNSVZEaTdXSEJUeC9zbXdTVVkydVNRMnpRK2d1NXVKalFkeXFBVU5D?=
 =?utf-8?B?NTB1YjN3a1QyVjFkeC9jakIrNEwyeGh0OE1oNUxPeEhIQ3NVclczajlrS3Qz?=
 =?utf-8?B?QnJ6cFh0ZFAwUmYzdXgyeDVMZ2thaTd1eDUwQUNOemRTZm51SEMxTXBkMHR0?=
 =?utf-8?B?aDRWSExOUU0vaStGUE1IU3NCMHZKK0lKNXFROXViYUhoWUNOSElnYS9VM3lw?=
 =?utf-8?B?dm9jVUVuTm1xZ09TdXhGbkl2RnNhNXlXNFRhcndSV2c1b0pRRFV0WGx2VCth?=
 =?utf-8?B?cWFCZys1czU3NHRuSTI4RnFJc3B2NEZJZTViN3Rlbmg2Smd0eVVJRUhNcWlX?=
 =?utf-8?B?SFNmS2l5eGN3T25UT3I5MTc2eEZtTCtNNkJXdUpFa2dBS3h6VC9ZdzcySDRH?=
 =?utf-8?B?MTNmQWJROEo2VGQ4ZVFDN1VUeUc0TmwrWDByY2tBeklZdy9keVZEY2N1NC91?=
 =?utf-8?B?RGd0b0s4dVNFanZvOVZqeUZhcy9IT0pKeWxPQndxSTJnL3IvcVFoUTJ2M3Fn?=
 =?utf-8?B?dmZvd3RrTmZtc2dDVnNVRGtscEh2R3kyaW51Umw1c2l4UktMZWxvcklsMTRG?=
 =?utf-8?B?dVRlVjlQRW8yWmNXOUZlaGFma2s2Yk5RenlodG1nVFRBOVJmTEkxcmVhRC8z?=
 =?utf-8?B?djVKbjc5MkNKR3o4bTkxWXE1azZ6UExuaWdLQ2ZDVFNBaDdtMmdJU0JRTXp5?=
 =?utf-8?B?VDhZbkxOcDNMYWYrZHNaL1JQNnpzVjRDTkR2d1RKRW1ESElvOWlmRVpKcnFN?=
 =?utf-8?B?ZVN0ZjVYVHpYNnVmVGVWVUFjcUVibXVvNDhsNzdTK3phcXlyN1lDMnRFbHNh?=
 =?utf-8?B?TmFTNVkxMnA3cDQyM2ZKK3kvUCtHS0UwZnZRZjZuc1BHMlFxd000dWhlTm9o?=
 =?utf-8?B?aG15dFZsZXBORVFiazhjQ1ZXcUlaaDFPWW1aOEQyZlFKMlMvMjBWOWs5Qm5r?=
 =?utf-8?B?MlN3QVBHWEJMRTdENmhwVXY1emlkbDNSa3QxQklLQWg1YWJmTzJ1UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52F012EF0B47B046A63CCA8E16A28974@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ZDcNS+e7VWTkSF7ZgQp1gRb35JXmGLWBg8uKCLTbnOWpF2rWiLsYL3uAQgTXI33SZRWXxhs3G+Mydun1bYccX4CxBhPK6fVfFhbUZx8SmE/S6N3MRzUc+1TnyDdEl1wq+leZZhYvwvGEaJGtKs281fA18FJ5Hjv/w1q1c4E/kZsM/CEY+tyXH11M/1emTAzACCjGCZUuSRjhv2WxB+qg+Njw1rHZwH3br2QncEfCZvcOkUgT9tWMdhtCKbQsz0b93PaJyyGwPr/YngSoXyvl3D9kjcMG/3zOTYNe6QxEkTFF+gqZkpCJArN7sKkQXju1Iwvr1168EsIaAWiU+NIgOw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SzEvpWpFPup9Nqodptts6iq8KQeT7BEPN3AUSpYTe214u2ZdXTb4whg04MrXcDzCP0CJUQqJFGOiTtJitbpGcyxbXU2bD33kvkGIWftxQ6HjNtOcwMaFRy4sk7+pOgDBJG5+H81h+qJ2Ea1y0WxeuEwqvwj3+lqw9DnBZS102qPY9U45PP9VSbzDdkU7RlsedukMqaEWSzf4OrbjdLILOlLVE/YAdrgVDmO2AHPjIHhE2ADRXRA1o42HjWQ/U7vS2GLwAtMZTC6spf3Qw2fy1bAOF3JMzXjHqposS2018G7zs4VBY0SZnGh/SDtY4g2EzaQU0/Icm1qdUNCpnpfaakgt69RplYNDBqa8Ecqqhm3mPY2rJeoQqyMc0W8CAqNSnm52D22IEFarNm1Qatzq1AmoMG5q21GNxqPyobna1ESSIRNBpAD1APuruF3PLzZ0cmuSQuhe60ZJPYdYJkRmijsYdlcyk2tZafjFqpLO6zhBYr3UBsDjQBrLwGwOLEU2cqDY10xd+XBzIhK4XkePp0Ah2C0VejJthiRkAXP/DyhS59N88mFzP9d9nExPAFv5Zb7dMIpGk9ccLnrH8Rqx1utMBqoeZekkRW7VOPXsytzYMpmAjQrKm9+ebYXJfQI6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8bb4a5-5c58-4654-276e-08def914e3c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 08:28:44.9261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /DkrRgkaiBgcpXqmFDjp/YtQoaR5dOCst+X8WuLZBadEhamH1UVe7qqx0abRz5JCBVLln83tiw5MTWLCV0zcFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7793

T24gMTEvMDgvMjAyNiAxODo1MCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IERlLWR1cGxp
Y2F0ZSB0aGUgaW9tYXAgc2V0dXAgZm9yIHpvbmVkIHdyaXRlcy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogIkRhcnJp
Y2sgSi4gV29uZyIgPGRqd29uZ0BrZXJuZWwub3JnPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfYW9w
cy5jICB8ICA4ICsrLS0tLS0tDQo+ICBmcy94ZnMveGZzX2lvbWFwLmMgfCAgNiArLS0tLS0NCj4g
IGZzL3hmcy94ZnNfaW9tYXAuaCB8IDE0ICsrKysrKysrKysrKysrDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDE3IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2ZzL3hmcy94ZnNfYW9wcy5jIGIvZnMveGZzL3hmc19hb3BzLmMNCj4gaW5kZXggOTUwNmNkOGQx
NWU2Li5kNDZiMDg5ZjAwNmEgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfYW9wcy5jDQo+ICsr
KyBiL2ZzL3hmcy94ZnNfYW9wcy5jDQo+IEBAIC02MzMsMTIgKzYzMyw4IEBAIHhmc196b25lZF9t
YXBfYmxvY2tzKA0KPiAgCQkJWEZTX0JNQVBJX1JFTUFQKTsNCj4gIAl4ZnNfaXVubG9jayhpcCwg
WEZTX0lMT0NLX0VYQ0wpOw0KPiAgDQo+IC0Jd3BjLT5pb21hcC50eXBlID0gSU9NQVBfTUFQUEVE
Ow0KPiAtCXdwYy0+aW9tYXAuYmRldiA9IG1wLT5tX3J0ZGV2X3RhcmdwLT5idF9iZGV2Ow0KPiAt
CXdwYy0+aW9tYXAub2Zmc2V0ID0gb2Zmc2V0Ow0KPiAtCXdwYy0+aW9tYXAubGVuZ3RoID0gWEZT
X0ZTQl9UT19CKG1wLCBjb3VudF9mc2IpOw0KPiAtCXdwYy0+aW9tYXAuZmxhZ3MgPSBJT01BUF9G
X0FOT05fV1JJVEUgfCBJT01BUF9GX0RJUlRZOw0KPiAtDQo+ICsJeGZzX2lvbWFwX3NldF9hbm9u
X3dyaXRlKGlwLCAmd3BjLT5pb21hcCwgb2Zmc2V0LA0KPiArCQkJWEZTX0ZTQl9UT19CKG1wLCBj
b3VudF9mc2IpKTsNCj4gIAl0cmFjZV94ZnNfem9uZWRfbWFwX2Jsb2NrcyhpcCwgb2Zmc2V0LCB3
cGMtPmlvbWFwLmxlbmd0aCk7DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9m
cy94ZnMveGZzX2lvbWFwLmMgYi9mcy94ZnMveGZzX2lvbWFwLmMNCj4gaW5kZXggOWZhOWFhMzM3
NDVmLi5lODdjMjZjM2UwM2IgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfaW9tYXAuYw0KPiAr
KysgYi9mcy94ZnMveGZzX2lvbWFwLmMNCj4gQEAgLTEwODAsMTEgKzEwODAsNyBAQCB4ZnNfem9u
ZWRfZGlyZWN0X3dyaXRlX2lvbWFwX2JlZ2luKA0KPiAgCQkJcmV0dXJuIGVycm9yOw0KPiAgCX0N
Cj4gIA0KPiAtCWlvbWFwLT50eXBlID0gSU9NQVBfTUFQUEVEOw0KPiAtCWlvbWFwLT5iZGV2ID0g
aXAtPmlfbW91bnQtPm1fcnRkZXZfdGFyZ3AtPmJ0X2JkZXY7DQo+IC0JaW9tYXAtPm9mZnNldCA9
IG9mZnNldDsNCj4gLQlpb21hcC0+bGVuZ3RoID0gbGVuZ3RoOw0KPiAtCWlvbWFwLT5mbGFncyA9
IElPTUFQX0ZfQU5PTl9XUklURSB8IElPTUFQX0ZfRElSVFk7DQo+ICsJeGZzX2lvbWFwX3NldF9h
bm9uX3dyaXRlKGlwLCBpb21hcCwgb2Zmc2V0LCBsZW5ndGgpOw0KPiAgCXJldHVybiAwOw0KPiAg
fQ0KPiAgDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lvbWFwLmggYi9mcy94ZnMveGZzX2lv
bWFwLmgNCj4gaW5kZXggZWJjY2U3ZDQ5NDQ2Li5mNjk3ZDdlNzNhYjYgMTAwNjQ0DQo+IC0tLSBh
L2ZzL3hmcy94ZnNfaW9tYXAuaA0KPiArKysgYi9mcy94ZnMveGZzX2lvbWFwLmgNCj4gQEAgLTI5
LDYgKzI5LDIwIEBAIGludCB4ZnNfemVyb19yYW5nZShzdHJ1Y3QgeGZzX2lub2RlICppcCwgbG9m
Zl90IHBvcywgbG9mZl90IGxlbiwNCj4gIGludCB4ZnNfdHJ1bmNhdGVfcGFnZShzdHJ1Y3QgeGZz
X2lub2RlICppcCwgbG9mZl90IHBvcywNCj4gIAkJc3RydWN0IHhmc196b25lX2FsbG9jX2N0eCAq
YWMsIGJvb2wgKmRpZF96ZXJvKTsNCj4gIA0KPiArc3RhdGljIGlubGluZSB2b2lkDQo+ICt4ZnNf
aW9tYXBfc2V0X2Fub25fd3JpdGUoDQo+ICsJc3RydWN0IHhmc19pbm9kZQkJKmlwLA0KPiArCXN0
cnVjdCBpb21hcAkJCSppb21hcCwNCj4gKwlsb2ZmX3QJCQkJb2Zmc2V0LA0KPiArCWxvZmZfdAkJ
CQlsZW5ndGgpDQo+ICt7DQo+ICsJaW9tYXAtPnR5cGUgPSBJT01BUF9NQVBQRUQ7DQo+ICsJaW9t
YXAtPmJkZXYgPSBpcC0+aV9tb3VudC0+bV9ydGRldl90YXJncC0+YnRfYmRldjsNCj4gKwlpb21h
cC0+b2Zmc2V0ID0gb2Zmc2V0Ow0KPiArCWlvbWFwLT5sZW5ndGggPSBsZW5ndGg7DQo+ICsJaW9t
YXAtPmZsYWdzID0gSU9NQVBfRl9BTk9OX1dSSVRFIHwgSU9NQVBfRl9ESVJUWTsNCj4gK30NCj4g
Kw0KPiAgc3RhdGljIGlubGluZSB4ZnNfZmlsYmxrc190DQo+ICB4ZnNfYWxpZ25lZF9mc2JfY291
bnQoDQo+ICAJeGZzX2ZpbGVvZmZfdAkJb2Zmc2V0X2ZzYiwNCg0KTG9va3MgZ29vZCwNCg0KUmV2
aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
