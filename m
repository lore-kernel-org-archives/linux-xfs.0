Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5CF35C6B8;
	Thu, 13 Aug 2026 08:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609704; cv=fail; b=ie6YtE/cR7MNCW1miYuaLuQJEFuCcQW7yjLHS9LUjXfSbQm2JAU2HtOBWkbpWdm7rVtAJiotSTRfMLDpEj0/RKKlbRRV39+XW58rvEoWmRvPugSB6lIsFbqVbJtDgVIkLttbXdaHkpyGMkTVeKATy8foEiWLEl6tWCBLgR/Hvlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609704; c=relaxed/simple;
	bh=Hufh0FbDUMlatlD+T5XnD54Gp1BhfSGmDToXAFVlKMg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VMouzCROUAPx8eUTGjqXRW4BFB855tRcefQmmpYTaQfcKIB4WV4fCenlf9RQZKEYTrqsYyng6h9GLnSh6SFNwdZbZ06ap0/ilUfK5rx2kQXIlmkF+x/DkNSgfNMsCMFbmIV3+zaixIKlf4wGH+1hmJVQYRwZI0yV8LVRuMvYqC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NPLspABV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=blih+Ql7; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NPLspABV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="blih+Ql7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786609702; x=1818145702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hufh0FbDUMlatlD+T5XnD54Gp1BhfSGmDToXAFVlKMg=;
  b=NPLspABVFeHOtplGqr3xorpK1x/6se/9NqCPBE9pv14KWM36Le0NZnKl
   a7wHeKaGWdXwLkPc/a0tXxoCoMII4+tWgFVPseh4NlNF379AIWzHItYKk
   9ysa0WUuHPaZ0PRqcUdBUjRjbpr/abEV9sHehDTgkmwU2y8W1uxTul4LG
   fFQP1Wk/4EmOq6dq/ocRFTcD1GsX5jpx0TPJIIxWxeiqG85zzGl6pTEwM
   i1B2KaK1nbK4wMBzhPaMHguZPu7ddxcA8TX4tYzO15lkGbduiPKT252Qv
   EH2TwNIk4+DP28uxCFGID/KmhX+aUmrIU1357Xa7ihoGhPnkxh7dJQpzd
   A==;
X-CSE-ConnectionGUID: smzD/iQvROywp3UoahKLBA==
X-CSE-MsgGUID: iKtYMbrMTBuhJXZuCjkzhw==
X-IronPort-AV: E=Sophos;i="6.25,221,1779120000"; 
   d="scan'208";a="152111057"
Received: from mail-westus3azon11012067.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Aug 2026 16:28:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ry0LFNLaDsYi/zGgiGeeonxEzBjh9SncC5J1BYSYzJmbD9Ya7Wr+jmi8a5jhiBMOB+UlR++gu8OJGbdKlRojz1vrAd3xsr0AvY03iYjuQ2zsLmFk5n8rdEnVmvTdkn0MhDNZdSoy+LjUtBqUR/6O7NhxYv+viiUxYVm9oiq1yRUftEsliRodPTf+MIr+zIy5dYAcdFVN+OyjBeTvOlAg6dRsDEsrpSfimvBSrSKRLh1SDOZKwrd6q20KA5vYe0YxV8OGfT8Ff0y5Mz6ACr0bVuKEWekKLfvHHw66E3Um8l7vtUTR0EmwwvUQ6bc1b70E1xZnHY20k6Ipa3ijEIVDVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hufh0FbDUMlatlD+T5XnD54Gp1BhfSGmDToXAFVlKMg=;
 b=KANymQtpfhfCH9qgILd2MPeuaRN8dTZtwkAz+uqLH7gYocOPx57A/unLwdUDJkAyZPp6VftqfXKQAyyTdnq0Sn1VV6//ir4bETsKG+skGrNumbplonDe0XHFn/9fzh2CLrP2xZ+UA/7YfnRAEULo9bRazwkQIzl3hcCojINYbVdmkUhXtt3TeheFfbo7KLFnn26OtGQ2M74B4OvSHZbE+Zwy+ncqqLh5PlnXKx5e1uGMj8+yKpXnAvG6tQ/ZgcGiiQekxzacf0kJmxlBczTDXQ5GxS/BHFvwConS0fcgGU/076hBDeyNoyV+02t5TQMFuEumbD9olBeRDTo0gMeVsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hufh0FbDUMlatlD+T5XnD54Gp1BhfSGmDToXAFVlKMg=;
 b=blih+Ql7aL4c/DOPMqiyUtCqJv+/kkmlZkdWstmE7OXs3lo7wbarQ8ihfY2X9U0vFCzDnvOLTMpqXcl/ISYr+SSP/pQkd7bIykiAu2KKi3pwvO4/UZ0Nz2daHxxD3BeKTKU6aPVafEhhMDaN3qlbkPRBI+bcu/M+jdPpSfsIWH0=
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by CO6PR04MB7793.namprd04.prod.outlook.com (2603:10b6:303:13c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 08:28:13 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0315.012; Thu, 13 Aug 2026
 08:28:13 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Wilfred Mallawa <wilfred.mallawa@wdc.com>, Damien Le Moal
	<dlemoal@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
Thread-Topic: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
Thread-Index: AQHdKbF7vi7fdJgYTkWHpU0c/W19k7abp/mA
Date: Thu, 13 Aug 2026 08:28:13 +0000
Message-ID: <569c7272-c9d0-4763-8c03-785bd0d2be86@wdc.com>
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-4-hch@lst.de>
In-Reply-To: <20260811164912.124416-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR04MB9269:EE_|CO6PR04MB7793:EE_
x-ms-office365-filtering-correlation-id: cba4695d-a2e4-4209-7561-08def914d113
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|376014|366016|1800799024|38070700021|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 fFsxuGumjNJHxVQulcwf0eLSuqiRDDT+aAFO9AKGvhXmBPViaTo2oqTlt8TdY6kDeFR8k5m8z9lJmLZff0TPDeP5KUohDHc3RoSGgx2Bj4rpDY3XNe3bmGVyrSNqmAzNTdOLjmQltprJB88YTKM0LGeh9B7QlMuqFejxfcl3RkV+6bBXAU9RieR3FGyKvMDXvZPhDVyNVLr9PXNaWVUGGHx8fGzxIwFrPWej33A2lkpaj5dCCGmp1FChwHQn+DslvxogGxgRitVBQWgS273wzZ7w7+Pj7kGPg4FhVSWppyzDzunSua7QNQQOmFrIhIzxjuOnoLDpXEJjkhWJEkjRfnnw8qMfLlJKX8asn4tahwknXhqqsMBvScv7FPLHOIGypWIW25rrHp57s90YfA9vMqzpVyFNtF6RcN7oDioZuqwTI73iH3aLGQCEK+7sV5y2/lW7DOLdVg/8I+lkHwmDz5A3raLFgi4bP1OoKHBYZ1sISNaEx4wnTJmpH9YLsjppuyXQzj6+ZmGQQMEoI8GON4TRwUT6xUTYNCJmg4wSFH2yrhz2fM5Sm/Q9oXwqCzBmrz3HapNPTMAQuqgeh0+8uq44b1HmqetWKYt5zy0n4o/qXl3Cme5j6aOzSJdfxX+HbeDGBHzk8gAF3Ea4udB0FYJWr6CGidnulQMYjipc9ZVAUyR73PbK2BJ5fLHR0xMm7PDMUaMFwOPTxwObvM8Y3v11P9jWknmqRU7lMahgmWs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(376014)(366016)(1800799024)(38070700021)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cHVWTE9FUzBWRkZCVVNtcjdVQVFzUE1FUmRhVTVqdVBiWWdzL0dxOUhkODZD?=
 =?utf-8?B?aTZEZlhRRGh4aURTVzJ3RHp3OFVYMEJxSGcyUkU0OWhGcFFCL1FGM3hkNS9m?=
 =?utf-8?B?M2pLUEFEL0QxZ0NzN1BIV3dlbVlyU2QrVlg2ZHZYbWpEbGRoYkV0NHpzb09k?=
 =?utf-8?B?Q1NxVENvWXdUbmlyU3gyaFRjZnVPWUliUlN4eENrTXI5TFpSY1BqS3pEM3Ra?=
 =?utf-8?B?d1h3Q21yd3BhOVlhc1NCNmt2cis3M3BYZWpnRWZTOERzZkF4cFBkVXcxSkRv?=
 =?utf-8?B?b20wMmhUUUpYLzhVOFlXbnJTOEM2YkNIM1JiRklNWDkzY0FBVVNyWGhNalQv?=
 =?utf-8?B?UTBTang2czJvY1R5cytqN0txMnAxTUpxVDdnUjJPZTZ2djdyMmlRUytxclRT?=
 =?utf-8?B?eHRadG5JekxqbzZHTXgyYXVPeStxaVptdHhockxINGZUZHpnM0hHdEx3aUNk?=
 =?utf-8?B?c0d2QkZpRVl3VUJobFBVUEhnUzJlU2J1V3hXMnBuTDNRMUhaS2xycUUrR2Nl?=
 =?utf-8?B?U0ZjcS8rU0tMUFpoWnA2SXR2bFNtRU5NR2d4WHk1Qkx0ZUtQaEE2Q1NTY296?=
 =?utf-8?B?YVJIRTJyMERsNUJuRGJZS1Q3THBPYktvZUdsWk5VK21FRmFkTWJTZm1tNHMv?=
 =?utf-8?B?ZDU4Q3BvdVVYc1RWZFAyVng4ZlZPcnEzTW5TQVVnMmZZV0VKcUhoMDlQbzBl?=
 =?utf-8?B?NUNiOU5ONVlobXIrUkpLTHRXN2I4cEJ1RDYraUhBRFVNZ09CdEJBOG5GUnJE?=
 =?utf-8?B?ZVRSY2Y0UW4xSmF2VHdNRzF2c1kvZG5ZakRlNFJzNDJPbG9EZ05HaWdrU2dQ?=
 =?utf-8?B?VTBSS2V1bGl2b1BIZkY4V0ZwQjIrNWpjZzZUMzdiS3dpN0lBaDArWmVoWGFj?=
 =?utf-8?B?WlNtK1JJY09JcElHd1F3TzNUUWg5akJPQ21CRXMzRjloaW9QWVF0QzlMWm1N?=
 =?utf-8?B?VUEvQWp6eW9IMWJnaWp2K00rOE9wMFdGVTB2bFhjMC9nc2kzUGp6MkZ6UmFs?=
 =?utf-8?B?TUJJeG9xdVUrL0k4MGdnT0d1aTAxVHdMVEtBSDlnZ25FZWEzSm5RTzBjTyt5?=
 =?utf-8?B?SkliNGxTUUFvS2Z0L0xBYzZScE5pbklMY09reXk5SzgrcytYOXZLQU00azlZ?=
 =?utf-8?B?Yk13VnhDcjhONVFwN0hIdTdCaTY2d3pwUTJKVDNjclVkdyticnZzZ1FxNFRj?=
 =?utf-8?B?SGhFWUhQQlJiMGFZeTBibHc4NjgxMlZteWV0UGUzYlNNSFlmUURLV1JaNkJL?=
 =?utf-8?B?TXVBSkhvV2YwUmhZQ1Y3czRaZ3VFVjZpczBQYlNqS2gwdHBJQWhvQXI5K3dN?=
 =?utf-8?B?czZuWmpWUnM0MzZwdXhWdk5DQUlOc08vRVBaaDVpQzlGQXRuQ3BBWUVCbjht?=
 =?utf-8?B?UFBpbzQ5L3ozSFA3aE1wMERMcWNUOU1RVGRScjlDNzJwR1RRSWM1Qm84LzNs?=
 =?utf-8?B?bjd1LzlCODllc3NydnE2N0ZjZVNKNHVWSkxOOUxLc2JRcUZ5RVNtVW16L1Vt?=
 =?utf-8?B?RlhoMk1rblRFc1NkamJsbXRZNFp5Ukx0OEpRVUdTbkVDZnlMQjN2SWNyb2Rx?=
 =?utf-8?B?QjdZRmh3dGhxajJNblpSQWl5WWVxWFdEbXZSck5QRE81UEN1eTlnRXZHOXpT?=
 =?utf-8?B?ZUdzdTNYeFh0bTVGYnNBWjlleUw5RE5Oc3VVVGJVbTAwZjhjZkMxaERwRFR5?=
 =?utf-8?B?eHRNNHFQbGF3RTlmWDJFL1I1cHFUaWp0VTJERlZGdVZ5eXlER1BtWmIzS3pX?=
 =?utf-8?B?Zy9sZytyLzNlandWd0dnNS9iVXJDRlU1eW14Z2JLMXVGYXJrM3krTjliU0lV?=
 =?utf-8?B?ZDFhdWYzMDkrS0FVcmdQMXIxMTBpdm1HZ1UwWFZZMUFRaDdsQ2ZycnJSdUxv?=
 =?utf-8?B?elVKTytBTW01bk05OEN4NjREWEtBZDBDV3QxNkdhZlc5bTcwbjhVZ2xpMHcy?=
 =?utf-8?B?ZXFHbDIzQUtTNEUzTGpRNHBId05JbERwVEJCbXFXLzFrTHBzOXYwRi9kUDlW?=
 =?utf-8?B?ZjdZUDR3dEFKM2FBSjc0VWlCMUhyUWtqUDZ1UDF4Uzd1dEhMd3QrT2VMbkZm?=
 =?utf-8?B?dU1RaXZ4OTM4RlhOVVFjVEVWRktKRDhEdS8rWjBsL2grNW9IOElRWG1DRU50?=
 =?utf-8?B?WmdhZWQ3V3A3ZjJUOUpZUnBySlQwZHdLUXBkR2Y3c0JneFBFUFlzTmI0UTU1?=
 =?utf-8?B?dlB2VUUxR0NTRXowNEhMVEhENTJJTnZpNy9neHN1cWZ5d2VTUWxXdW1KOFRr?=
 =?utf-8?B?OFYwbTVvYVdHa004Rm5JcTF6cUZQcU1oSDM3NzBTUlluM0pFaWFSRjNGeTFL?=
 =?utf-8?B?QS9kSnVWSlQvcUczcldhYWRxbVZWbVJ6K29lN29FaEpCczdmUXZoUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <027C87A2E6006D40A84DACF8DB023711@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Ky+wWke9IbzQQ3q1BNGUoyJwQmZ6ooDfiZk/CAJvBBbYd1AXXDjHWNVn8AwQTVjfnU+70ivkaNSRzJ+TEGzdF3J8t5TRsCDCI2PeEt0WIDQ+N7Q33UsqeAhL1tLCXA4vtRPhHpOckNmuzF5hLIKTM0HqT+7BJ4YBkX3Gvw2Lr1TDnPI7FzPAV6+0h9yLYMQgqt2TfKqVDKdQvzkzPoblQgyvosGeKVd8TQjlPH8xl/NP9cBkJoSuprrHPn44Hly2RIrt5Jpf42DDpt41UhgJ9TMa3isMThj6CX5JOpeQ0aX2EdfEX+LFQ2u+7KrlKjfS1MrhCtSs6zkacoHABcd5hQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PAJsx6aj9p09KnxCStRfFajCinCe9gz7WtOxgMYfgR9KXpeYXwVpfrNvv4bw1O6oVuBz39BmjyRAjLXC7INE+wfaWX7mvAuerSiUVDogXNGIwzim5+/4WSPe9QGXqKwd2UCRXHhpYhAIPwQ3+Guoj3zFMnYW9zVnBEcEP+/rXkIMBUPV3TH1XBZnrbqG2crmx+JPULU9aABmycUY154izgW+x817dMlYFYzpEjxswauXVaqjvlbnwxx9hc0AKK9xaquwHqw+gDCkWnZBq5NicuyRrmJT75PbgkeNuItiluXTFMAtjxj6UMzbTGq00vtNyo43KHXKRv2wZKMMjFXFaxUMk8lmD3MfFrEXQSIjZi7C8H/6FFsawHxCo8nhTXO9G+bj0wyLGD351HBJL22MQZ5RdLfJyYqvzCfMORhzI65T9EL5R+ccYA219BPFCXyHMrkxxS5Ygph4k3IzO7BWfLGFV0zkl7bGGTeUWrmZvwfiSfknTnaOG6N90eyg/MNooQ2kga8Nsc2Rxh7wpXRUB1LWSn/nhr3RLsXq8XDm1Ne5TSodgrqvfzti4GLhUYjGRDeusF9RtgWOCrLPmc4F6ksKZejGrHwbw826/v+5+cbmWuxCkuwGT42R0xRGS94G
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba4695d-a2e4-4209-7561-08def914d113
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 08:28:13.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3g7YuxFrlXgjlnyrf8BTcO63KPoqEMsoNFZCGvyGI4HQ/zApwpIrhHSCVOT+udpsrAkH2VeiwM7m9WorCcn1TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7793

T24gMTEvMDgvMjAyNiAxODo1MCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IERvbid0IG92
ZXJ3cml0ZSBJT01BUF9GX0RJUlRZIHdpdGggSU9NQVBfRl9BTk9OX1dSSVRFLCBidXQgZW5zdXJl
IGJvdGgNCj4gZmxhZ3MgYXJlIHNldCBpbnN0ZWFkLg0KPiANCj4gTm90ZSB0aGF0IGluIHByYWN0
aWNlIHRoaXMgaXMgaGFybWxlc3MgYXMgYWxsIHpvbmVkIHdyaXRlcyBmb3JjZSBhIG1ldGFkYXRh
DQo+IHRyYW5zYWN0aW9uIGFueXdheSwgYnV0IGluY29ycmVjdGx5IGFzc2lnbmVkIGZsYWdzIGFy
ZSBzdGlsbCBhIGxhbmRtaW5lDQo+IHRoYXQgd2lsbCBjYXVzZSBwcm9ibGVtcyBhdCBzb21lIHBv
aW50Lg0KPiANCj4gRml4ZXM6IDA1OGRkNzBjNjVhYiAoInhmczogaW1wbGVtZW50IGJ1ZmZlcmVk
IHdyaXRlcyB0byB6b25lZCBSVCBkZXZpY2VzIikNCj4gRml4ZXM6IDJlMjM4MzQwNTgyNCAoInhm
czogaW1wbGVtZW50IGRpcmVjdCB3cml0ZXMgdG8gem9uZWQgUlQgZGV2aWNlcyIpDQo+IENjOiA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2Ni4xNQ0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3Rv
cGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gUmV2aWV3ZWQtYnk6IEFuZHJleSBBbGJlcnNodGV5
biA8YWFsYmVyc2hAa2VybmVsLm9yZz4NCj4gUmV2aWV3ZWQtYnk6ICJEYXJyaWNrIEouIFdvbmci
IDxkandvbmdAa2VybmVsLm9yZz4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX2FvcHMuYyAgfCAzICst
LQ0KPiAgZnMveGZzL3hmc19pb21hcC5jIHwgMyArLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94
ZnNfYW9wcy5jIGIvZnMveGZzL3hmc19hb3BzLmMNCj4gaW5kZXggYzgwZjA1NTA3MzczLi45NTA2
Y2Q4ZDE1ZTYgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfYW9wcy5jDQo+ICsrKyBiL2ZzL3hm
cy94ZnNfYW9wcy5jDQo+IEBAIC02MzQsMTEgKzYzNCwxMCBAQCB4ZnNfem9uZWRfbWFwX2Jsb2Nr
cygNCj4gIAl4ZnNfaXVubG9jayhpcCwgWEZTX0lMT0NLX0VYQ0wpOw0KPiAgDQo+ICAJd3BjLT5p
b21hcC50eXBlID0gSU9NQVBfTUFQUEVEOw0KPiAtCXdwYy0+aW9tYXAuZmxhZ3MgPSBJT01BUF9G
X0RJUlRZOw0KPiAgCXdwYy0+aW9tYXAuYmRldiA9IG1wLT5tX3J0ZGV2X3RhcmdwLT5idF9iZGV2
Ow0KPiAgCXdwYy0+aW9tYXAub2Zmc2V0ID0gb2Zmc2V0Ow0KPiAgCXdwYy0+aW9tYXAubGVuZ3Ro
ID0gWEZTX0ZTQl9UT19CKG1wLCBjb3VudF9mc2IpOw0KPiAtCXdwYy0+aW9tYXAuZmxhZ3MgPSBJ
T01BUF9GX0FOT05fV1JJVEU7DQo+ICsJd3BjLT5pb21hcC5mbGFncyA9IElPTUFQX0ZfQU5PTl9X
UklURSB8IElPTUFQX0ZfRElSVFk7DQo+ICANCj4gIAl0cmFjZV94ZnNfem9uZWRfbWFwX2Jsb2Nr
cyhpcCwgb2Zmc2V0LCB3cGMtPmlvbWFwLmxlbmd0aCk7DQo+ICAJcmV0dXJuIDA7DQo+IGRpZmYg
LS1naXQgYS9mcy94ZnMveGZzX2lvbWFwLmMgYi9mcy94ZnMveGZzX2lvbWFwLmMNCj4gaW5kZXgg
MjI1YzNkZTg4ZDAzLi45ZmE5YWEzMzc0NWYgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfaW9t
YXAuYw0KPiArKysgYi9mcy94ZnMveGZzX2lvbWFwLmMNCj4gQEAgLTEwODEsMTEgKzEwODEsMTAg
QEAgeGZzX3pvbmVkX2RpcmVjdF93cml0ZV9pb21hcF9iZWdpbigNCj4gIAl9DQo+ICANCj4gIAlp
b21hcC0+dHlwZSA9IElPTUFQX01BUFBFRDsNCj4gLQlpb21hcC0+ZmxhZ3MgPSBJT01BUF9GX0RJ
UlRZOw0KPiAgCWlvbWFwLT5iZGV2ID0gaXAtPmlfbW91bnQtPm1fcnRkZXZfdGFyZ3AtPmJ0X2Jk
ZXY7DQo+ICAJaW9tYXAtPm9mZnNldCA9IG9mZnNldDsNCj4gIAlpb21hcC0+bGVuZ3RoID0gbGVu
Z3RoOw0KPiAtCWlvbWFwLT5mbGFncyA9IElPTUFQX0ZfQU5PTl9XUklURTsNCj4gKwlpb21hcC0+
ZmxhZ3MgPSBJT01BUF9GX0FOT05fV1JJVEUgfCBJT01BUF9GX0RJUlRZOw0KPiAgCXJldHVybiAw
Ow0KPiAgfQ0KPiAgDQoNCg0KTG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEhhbnMgSG9sbWJl
cmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
