Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E69233949
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791765820; cv=fail; b=ZgPDfD+C9NpOJnUg1q9o4uurhRzdGv00EbKdKDTSUP8FjqLPU2zG/lJQD2Zm/0ElERUFqQ2wfMyjrYMZLCrY3Zbfwmi7B1mK3mn7rEBHyXYrQeidguSdxYnJqXcAjZ9yvt9xhFezYJ9hGtJ7lL14IzreeqQcA++cRim7fkcSHaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791765820; c=relaxed/simple;
	bh=eLRPLSMsGHm2uJi4Ef7OO3X9FmIytJRdsfQcnuA4poA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uWsJpKASplPduGqp93GfzuCinwU0aZWzQlgUsrGsllQLffVnIOj6babkuE0Z6EqjB/k6Iz6XWughB1/HkzOjy2q5jZpR5HLIY9sX0WfbDg1/Ppy0K+5CrEHGzfSk+di1tX71G+dKkhsfdzYQ+6PGTdhbqG+0ySEu3ALy6aniahE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PjLx9W7U; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nanKOmZ2; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PjLx9W7U";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nanKOmZ2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791765819; x=1823301819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eLRPLSMsGHm2uJi4Ef7OO3X9FmIytJRdsfQcnuA4poA=;
  b=PjLx9W7UQxBE2Gvq5Uk+OEzqbZ04/R+bWmQvTizgJc1pmJw+cnRtNypL
   l4JFhvtPXO1Gf5zyarJO4phiCQ14dswshresreeNz4Y6by26eQDpYvnFU
   6vJeN16nbRZUvx/sB7y0FrWiwHtJcsGv3tkrEUNIccyV58Rq+ntA10OHz
   U6FEmtEPGAHRqqff3eDlkDc9NcoqJEaIAwwUJpG3u1Xo8vSkvGwW3h2w4
   1qxJ5wUnm214a3RabzAUjtsVQxBFhG7q7CeE3ftLLwzHChfnGWy/7iEmH
   WKhs9sdCPw3cPgilQdRDZX1CBd4yuzNXy1kDU+PYSicd1ixU6HOteLpHL
   Q==;
X-CSE-ConnectionGUID: LOXd0TupRCK1JM3VQldjcg==
X-CSE-MsgGUID: DQHzNU+7ROmsQJTVVVDqAg==
X-IronPort-AV: E=Sophos;i="6.27,152,1786982400"; 
   d="scan'208";a="157856912"
Received: from mail-eastusazon11012033.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Oct 2026 08:43:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gEqWyWrJUJbO9t/Vi3f7Iopfn7seNkVKXlcyF0fjEeXRrWFKCfYcIEMAE35Jd7iAJNjLE2N+JEmvIBfjayOaT4DWaq1anmQ3qnbPF1gLw8/PcAiAJe72S8mszU+7PGVlSqv8RwYc/waN/W++EQAYEDEnM6zbwlD9yUDRcETuuegdvjIJhdbN1+zlfEdDc2hzfiUNEUJ50PiRpH6Sge1A+sNVoPxKr7Bz9vGfmxwqITmkRS5G7+n+lsUDkO6vKLIkZyjQxi324wIzZuf513XybVHbekg8lEEEYQicbqI+4VQ/g5KTgdtHRysSKG1gpNb3J4G1t14WVImkqQUGUM8fiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLRPLSMsGHm2uJi4Ef7OO3X9FmIytJRdsfQcnuA4poA=;
 b=lOz6gmpoqLd5MwBMAwlIxKQyl31tghHFYzreQcXIhwHSanrkz3dXkTdoFTTBORXnJg5d/h/Fa8pyW714EFB3EpBY+UjiWnALHkKbQ96oNGOT+Era0c9f9jsqPffXNMa++BkznHrTHg3SeNOagVALoSgdJA8M8POn2jZ6vGVrCBIwVdKR/uYrtxLSS1il88uYFm+os6hVuZ9tpPxoRoYZR5ez7KBiJEFMJsjldpZwTOjJaeAockG9dEGHGLfUVRuIol0gB4W5TfSOsVVsiI7bpDFLpJw3DyZLMGsrHY98zpD+Sa7/CBnO9yyzx5qfhn+JHmSuoUr8KhXdGN5ydH3JMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLRPLSMsGHm2uJi4Ef7OO3X9FmIytJRdsfQcnuA4poA=;
 b=nanKOmZ2YGbL9nHi2/T8GTXNcL7H1RQ8bvdvgIRpC6hTi1Q+vH5W1wUcWzMm9WFaQB/LEFR32A8dK2bnQXgsK0eqEiRPyvMaqCciuMTC+WiII7XaPrICS5SVIQfHDBC6DCHQqJN3UhJB/YaZ4ogV80WyvVpl8XrXtX13PHIAmVQ=
Received: from IA3PR04MB9680.namprd04.prod.outlook.com (2603:10b6:208:510::12)
 by SN4PR04MB10244.namprd04.prod.outlook.com (2603:10b6:806:1ef::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 00:43:28 +0000
Received: from IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f]) by IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f%6]) with mapi id 15.21.0496.017; Mon, 12 Oct 2026
 00:43:28 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Topic: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Index:
 AQHdVXtCquID+nF6ek64bdvaE5VYBbbwVlcAgAAyfoCAAA/OgIAC6lwAgAQS7YCAAF4SAIABJm6A
Date: Mon, 12 Oct 2026 00:43:28 +0000
Message-ID: <d74e85022834ec1c39c79931d64b4c805001e7cd.camel@wdc.com>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
	 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
	 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
	 <20261006144851.GX2705364@frogsfrogsfrogs>
	 <asd7554UisFwlOsc@cronus.toxiclabs.cc>
	 <e042c937a34eb92afdc0208a2f6571076f096ba6.camel@wdc.com>
	 <ass13wWEOO9woOOw@cronus.toxiclabs.cc>
In-Reply-To: <ass13wWEOO9woOOw@cronus.toxiclabs.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR04MB9680:EE_|SN4PR04MB10244:EE_
x-ms-office365-filtering-correlation-id: 5b47b351-4982-41be-87e8-08df27f9d50a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|23010399003|1800799024|19092799006|376014|366016|10067099003|38070700021|4143699003|11063799006|18002099003|22082099003|56012099006;
x-microsoft-antispam-message-info:
 faDhDAYVyCk3jP53/kM4u822nKi3yHDy+iWb2SiEAhNynmYr07GQnlSpjh4F8Tk7HPN0wpZdq/FJvsunfTIHZzBnZAhUr5eEY0+OZKO5hZpCjbOCB4u+41Np8BfRGRCQGYhViaS+IJvKKTDpbzOIB7+QZ+LMTO9nWykyrkrOGA+jZgF4JPQmr6LpjSeHUj3yQ5cj6wBuKIUkQAArcqLUyirGMWN0KC2GPuQHs3XY+x+nKhtMLS70pJVdty+cYI53swx0jJfnlHpHv8jPlXt6zaFiA7gbR1svfFkvHsYKRwQ4P2zEaL1fMozhc8z8V/dPV7tsAH6H7Thw/cEVQFYjCSMkGQxSe4uxZ/4EdLPmV8YTNRS6iw0U/9uTMO2H488GkR4lgN/fJisvaa1v3xVXWkLXyg8fy59b0sU1AGncJ41/GvQZmDVskudenCZ0qQXspLwhpYjUBEmytp/FaNVvYu4D8Yt5bmm6z0mjNyP9PqZFRKhpzqPLdoTfZ6nR2zXH8Z+2rXJHLAlHF0cV8a736TFBeS7LNzMo1QY/1pOKtTyDyNHPX6JSEGFoiBnD/UjOXX0wlpKl+JBCw4POV3+3kp+s7vBzv3JR8lySeX3yI8Q4UVGxcjBVlabMcRhFaMMFvpPs1b6vAMSbRFIz+EhGMvVmE9qchbS436WoDsygOfd1fLuoFsBfmGXhYJOT2iAFKXwtI4+qpt4Eypcmy3HGvjT/Bv+pJDIq9HFw8513U/w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR04MB9680.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(1800799024)(19092799006)(376014)(366016)(10067099003)(38070700021)(4143699003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TWw4cERKbUVSS1d1WVBtUzlKcDdYT3dFNXB5aEc0bDVOWmNJZXZVeXlrRzYy?=
 =?utf-8?B?QnBwS2I4WDRwSVp2akpuZS9HaE8ySUcyTmd3RWh0dUhsN0VZcm5RaXV1cTg5?=
 =?utf-8?B?ek5wWFhWbEE0c1NKempac1JsNnpTZUpmeXVqdVRvb2F6UGIva1oyYjdCU2Fa?=
 =?utf-8?B?WmdybTZVa1JmZm9GeTlXU1kxWnRhdzI5ME9LMDE2M3FQak9NV0VyY3pDUUZR?=
 =?utf-8?B?ckdnclJIczZmUk9oVzBDUTF4QnllUEpUV0dER3ZlQS9oejdqNmhQS2tQZDhG?=
 =?utf-8?B?WDQrdkpUWk1NTWlGSE9EcDhlV3ZMeDVtS3VGMytwTkxLUHUvajU5TC9kWnhV?=
 =?utf-8?B?Z1ZFcUMwSm5sS1FyOVlLVXgzN0plbzRYTytKNDUxRXNCeExoaHIza1Vic04v?=
 =?utf-8?B?M0dqT3BpSitFRU1rL2xYclVYRTJNdXBpdEw0TU5idU9YWElvOXFPU2FETFpX?=
 =?utf-8?B?cC9OV2VtNXQyaHQzWWdUQ1lhRW41c1lmeHRHRFNlVUlBRlFyRTkxd2l5NWJv?=
 =?utf-8?B?MUNKSS8zcHFnOGtaRi9iK2VjQVJkZjNwMmlKMmNSVlBTVE9qeEdNU2pXb0dH?=
 =?utf-8?B?MDc3djN1K3dtN3hhdW9EVml4M21KVnNDVVN6cVlqdHpldjBIVXRuWUZqSTVy?=
 =?utf-8?B?V0NFUDdrMStMb2hQRmFXUUY3My9SblJYNElCM1paeHdrd1Y2RHRHUWV3VVFW?=
 =?utf-8?B?MTJqcHRjVFF4bWxWK2VNZ2FJaHFOcFNGVmlWUVB2YzJUSnJVWlhPSU5ZejNL?=
 =?utf-8?B?YXhGemFNdjdiUExBVXYrc0E4THEwdmt5dTNUU2RkUkh0b21tdVNEZG04ZFQ1?=
 =?utf-8?B?dnp4NkVXREN3UHFLK2xsQ1hvTHF6b1I2NFY3dTBWVFBsdlpVTW9CQ1VDVXJ4?=
 =?utf-8?B?b21LcUUzK3IvcWhlcFZYS2R0QTgwTnZmbi9QVWwyRGVPVWUyWDUrQ0E5MUZj?=
 =?utf-8?B?ZGt2OTRyZjIxM2JnbjcyZG9hMEVvUzFnNG1aZTRkem9hSzJLbmQ1cTlEdmNS?=
 =?utf-8?B?TGlBcnpHcklSQVZ5QVpLYXpXMVlvT2F4K2JpRWVmKzIzaGpwYUdMV2laT0dr?=
 =?utf-8?B?NjFxM3YrME5mdEZ3TG5lNzAvdEV3SWI3eW1JSyt2TjVUZkNVcHMyNExVMFQ1?=
 =?utf-8?B?cFBqQWlFbm9IVFZ6TDF3NUNac1YvSExwalRORW5JdU5nYTBQYTMwUWJzYnZ4?=
 =?utf-8?B?TTN5RnVQUTM5bko5dENXZEZHYmNqeDVtYWhnNUwwamR4QklPWTdwSnpXei9V?=
 =?utf-8?B?alpEL3pSOG9MM1BYS1lnaVZGczk3N1F6Qlh6aGtyVHVTekNqa1J5WHZLZWNK?=
 =?utf-8?B?SXkzSXBmKzlQZVBCNlBQdUtzNDRUOE93NFExNWZsYzdVK3A3RmQva2NoMmtl?=
 =?utf-8?B?ellETWtKNmpyOUR1ZVRjdXdudzJCTWdKZUd5eHVURkd5bTJtVkFtS3BsSDhN?=
 =?utf-8?B?S1ZNZkwza1gxUDhyazlyaHI3MTg1VWZvU21HbGNYeFEvQ1gzKzZtOHR5dTAy?=
 =?utf-8?B?QXNiR29zSyswaUZ5NlIvM2pyOWlNNTVmM2VxbkxJTTF0dXFPSmh1cWV6Y3VV?=
 =?utf-8?B?T2l5bkZJTGF1S0IyVlBSYmd2eDVucHhTbUQwbTdLZG51Z2ZKT1J5SjM4d0VQ?=
 =?utf-8?B?L0N2UVBxMmNINVBMVTV5SW1qTCt3elBoQUVEMXVaUDM3cnhWNWt6UW5INjlv?=
 =?utf-8?B?Z3lVNzVZbWpKRm1NeVowTGlDZUM2K01ncU1FTXZia2x6b1pNOVhXZlUvNjA4?=
 =?utf-8?B?cDlkV1d6ZzhBbmp3WVJjR3JyN2xiZEViSUJaaDZRNVZWVzQ3SXJXRG5UVnpt?=
 =?utf-8?B?TkhPbkxVc0daNk13bzliY1RHbHNOS2taVklOeFVrUmxkdDRrbGxFck52VmVR?=
 =?utf-8?B?K0hJTDlLRzgrelZ2dHp5VExkbXZ0bnJXcGJzU0cvTDdCWFlJdkQ3UHZqVWZa?=
 =?utf-8?B?RTRZVFI2cDRvdHVyeTZBb2N4bnA2NUtBTGd0VjJ5aWxlaStYWXhWc0Nud0Zp?=
 =?utf-8?B?T0U2RTB2bENIYS9tTFg5eWRXY0tSUWdMOXN5M0RkZjVyV2w2SzlSeFFXN0dq?=
 =?utf-8?B?aG0wOU9jUncweUxQZ3JZVFBWUWRNbzdKMUFEN0tQRHkvSGZwNkhxSXRFREQv?=
 =?utf-8?B?U0Z6ZFdVN3VrQVloOFFnSENnbGk0c3gydU1nSFRPNlhXK0NjMS9kaUF6YTJt?=
 =?utf-8?B?OGhVVU9LNHNOSnhBOGM0WWErRmNEWjVYUStPNnp1b2NqNExYK1VuMlZJa0s2?=
 =?utf-8?B?MnFTdUQ4N1RaY1BhalBZdXNocTlBajhreVZ3US8wWGY0NHNQQWxWRDV4bmdh?=
 =?utf-8?B?c3NWeEVaK2p1aS9Ua2xmYTl5RFhxNXZ5UmVTM2tEcElHRHVrU0hJbGV1aWRx?=
 =?utf-8?Q?WWZoWTxkR21UBMqcxgctJf+cV8agi02zIhW5HEztOJUMG?=
x-ms-exchange-antispam-messagedata-1: McMZyZPEScdxdmWpoFK79SlkiBpoOa0RumM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <961623E69F61014E837A85C4D6CC1A17@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	TsMddHH1OsSHxnMITgn6duD/8CdPkVEMRm7q7L4jPqBdxi1gEstLpLAmtNDCjGeFlxjsMldGWlWf8YkH5Z6sGih3g859Fp6n3V/q2A/S8LC65wQdgEr+w+NW8mLpugSUWp8uDWT7gDXAojCrphxvSLWtslSrVXT1HDVLcmtGnxCm/8EI4W4+fxzdxVnA4nrr6BnVzWOPkXuM0WX7mHUofUAEGiowe/y+Qjrmxox8/YWZuie8NRMyKwZuRgwi/lDV4AaO9ATj30y+Ldhw89XCfjRFQXaCdGdD9B0B8MCDn9r/gM1UxtbHDgYgNd3sqmQpAJAbuJPr4UtbkZRPe758Lw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GcmyOi08BpdcEHRoQv7xqKOVMFey9oR0WyartmjUPKdLa39+vVMj1d7o4THKlR3cEZh0WOguY/JFAL+lThEE7xy9Bir46t0+XO6L3/nMVUWKyMgaM5vNTNYRteCKSnC+1pBXsvb7bsLICfvZ5JqSUvhTwWOgsXpcMgFWOYwofr1KTdQkY8yHq/zOkCXmLY5ZgajoGSuRqO2waE0NVvH0I+qeo5al/YRcrzSyofWAp0r283K8Gq4NfZ2tr/GVV3xkmU0LOffKJPToDJIx3meP021cib8E7ok8myff/0dFXOgrBOZK+x151lRoHYGYDS+8eXWlFBcydaqldwxsMSTUoNlVYqh40aUEINRnFgsy5ivtzWbBuZHppTdv3CzU4PGZP5rm52RT14QQvIHG3kZtWSt87Ae9C7C4qCoCRNXTVbNA2mxzoYaZEnAn1d8wyOLLYK2ME0U7RFIrERLlA3MfhiwMZlMG/lYx9bFIh9lfsNIkVMRqUwVBuE1kwpN8rJHOb6OCSLc7vGhTXykMJZZGh6/YluBtHr8b95A5ooGZV1oXaEd9N8VMBrvxkCrteGwbvkF0m4wYs9RHIUoaqkfm0T1Ei3KYsAF8nf6R6hsjWdMikspUp0NDGzPZWgmJMaIA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR04MB9680.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b47b351-4982-41be-87e8-08df27f9d50a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2026 00:43:28.4385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 93I7yjUFJ6udVYnifHV7CFDbq7aMC6BikB55Mplp5A7nf/kuuIoeEIEC1+z76zNSKc4qXygdoUIvT1D0v/Q+2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB10244

T24gU3VuLCAyMDI2LTEwLTExIGF0IDA5OjA5ICswMjAwLCBDYXJsb3MgTWFpb2xpbm8gd3JvdGU6
DQo+ID4gPiANCj4gPiANCj4gPiBKdXN0IHRvIGNsYXJpZnksIHNob3VsZCBJIGNhbiBzcGluIHVw
IGEgVjIgdGhhdCBmcmVlcyBhbGwgb2YgdGhlDQo+ID4gZ2V0c3RyKCkgYWxsb2NhdGlvbnMgaW4g
eGZzX21rZnM/IG9yIHNoYWxsIHdlIGRyb3AgdGhpcyBmb3Igbm93Pw0KPiANCj4gSSdtIGhhcHB5
IGdldHRpbmcgcmlkIG9mIGxlYWtzIGV2ZW4gaWYgdGhleSBhcmUganVzdCBiZWZvcmUgd2UNCj4g
ZXhpdCgpLg0KPiBGaW5hbCBkZWNpc2lvbiBpcyBmcm9tIHRoZSBtYWludGFpbmVyIHRob3VnaHQu
IEFuZHJleSBoYXMgYmVlbiBPT08NCj4gcGFzdA0KPiBmZXcgZGF5cywgc28gcGVyaGFwcyB3YWl0
IGZvciBoaW0gdG8gY29tZSBiYWNrIGFuZCBkZWNpZGU/IQ0KPiANCj4gQ2hlZXJzLg0KDQpPa2F5
LCBzb3VuZHMgZ29vZCENCg==
