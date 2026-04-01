Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A538940DFC1
	for <linux-xfs@vger.kernel.org>; Wed,  1 Apr 2026 13:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049041; cv=fail; b=b9WAINwiBCjcjXp/gpyNBXh9DksFgcMdHQzxL9oJB+HI8lDYNw6YwvDH6IFuFFG4lTPlpv8UzbDebOmkua+WhrapZUgefnqCvdPVe6GDMazx9rjha55Ped3XP5XxJ/NxI/xGFPOGyML3i1PZ9BxftlDVKWjg3o0qY21YgRicQxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049041; c=relaxed/simple;
	bh=GYjAtxm5NKXiToz2dKssFWxTWDGjKuIR+fkSmVppfYo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S3OhpR9fQzzLE6f26dlE21o+kFCIHo1H4skZ6PxmlFQdhhdGVJso1WGBnbgPR9eaZD5pq7lm+dyYPcZgF2feKvy6jTVcLh6x2U+tsN2LMImamiOpk4STTOFTvW7O99jyMdEmzCV8zY4SiCZctciRknxf5NzRdKV9jsAHmNVhoPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=B/6fBpNF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=x6podpt6; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="B/6fBpNF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="x6podpt6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1775049038; x=1806585038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GYjAtxm5NKXiToz2dKssFWxTWDGjKuIR+fkSmVppfYo=;
  b=B/6fBpNF/SDC7Elc4TGBss4BZYEtUrkKAEMl9kzZQrg7+mnKQHSOTuu3
   rGiN+Jn+vWKYqo5ZSif9SU3U47XCQAM2kwLSZyDtHoTHvoAvlzDMf0dKc
   sNG/NY0KMgE4xnLf2amyIB5KFyeGHJWg5upxl5JkBhJ23L7Yit4Yaw7RS
   SGCfTCSBHfUBxgtiVrao4uecSvwzi1Ep+po46X3NKjxH9kYoORKkGDd4k
   UJCr8rCOHImvHa7gqefisGOVMsolxX+3zZ8Zh0/mqMJ5lNedtKCUrSIfw
   Yn/guM+jg8RFvwsFIxQ8zbD7V0ICY0CNVbX784rl0FZ8VV6hQWDQN2qmj
   w==;
X-CSE-ConnectionGUID: 6nr2zyI4RDOs4/PhjkwqyA==
X-CSE-MsgGUID: /B9lUYrcQvGxQQkLQ63kSg==
X-IronPort-AV: E=Sophos;i="6.23,153,1770566400"; 
   d="scan'208";a="144821303"
Received: from mail-centralusazon11010052.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Apr 2026 21:10:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aj+o2PXTpkBGC07WJT6tTjEQujgtlP7cjd+USy+r2GMUto0z1ydOlEkZ8g7djA/vfrJhQfwVJxnz6bMwbOJzMZ2zw2FxuW0e75vgQqTPzuAI5Ll1cfjn6317HMV+7LjTGGiqMOPfb2/vPBGCu4MiEGnSEh3tSYH5RwqHufAwaLfrqj84iaRYDBeV+KeVx7/E/O2NSy9aX1jsLjb+Ff2yfnFU6S5DQJcqT+MnVBJ9nYo9VE0aaC4hH9nGJuECF9kM5hc+tJQUXH5zPLl2Dgi09uOf+/JPDg68RObYhj1dLwxmD+CWrq8UTxha2TTqa1eKSkzCIh3wTz6lWPeyrhqUKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYjAtxm5NKXiToz2dKssFWxTWDGjKuIR+fkSmVppfYo=;
 b=kg57o5xV7p2RIOe7rozb5eHZL9y8BuBclQ95lB5M+sSGebdZ08aApVBsGDdOkEGYRZNohCXiKlTBP4uYpT+yIyj1A/AqJZGivPppEOqsxuU8VbxotTCnGVLacxegtDHwxoRV+sO/ItUrKBmB6k0Y6KgvRjnYkTu+rgUXtcxE4dTWtIXJ/AiYRXPQbceQtYoQiBnYBmp6P3t9rk58yspuPQDY93kgWfGECoF4ELFWVsE8iN/H9mIZQgIqE1WnYN4FBikzEWdiW7V3xw64XDlaDpw1kCV+dAg2NmU9U5soKgj1Dox1NQrfuruBwfJQFg3IEdLey3jNmX8JHe+CUM9NkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYjAtxm5NKXiToz2dKssFWxTWDGjKuIR+fkSmVppfYo=;
 b=x6podpt6YuYohkedWrpIy2eoCbh57HFBYLnzCEWgntrL/gdXJl3JavH/LdR8X1dL0IXx0wrkmkXunf5tgTwrCCF0PH3L7uR1cV7GbS5KT7LLCIDS5iNVK5hfUjTwAbrg5ep4I8uT2eoWC5Mdj2X9P1XlkKUGnOcKFABptVxkZC8=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH7PR04MB8945.namprd04.prod.outlook.com (2603:10b6:510:2f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 13:10:24 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.017; Wed, 1 Apr 2026
 13:10:22 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 8/9] xfs: expose the number of open zones in sysfs
Thread-Topic: [PATCH 8/9] xfs: expose the number of open zones in sysfs
Thread-Index: AQHcwSMFCaqvPZaook+ZpHQ3GutxrbXKL4OA
Date: Wed, 1 Apr 2026 13:10:22 +0000
Message-ID: <f31b13cc-5076-4e3e-b36b-7bad7d88a427@wdc.com>
References: <20260331152751.4048218-1-hch@lst.de>
 <20260331152751.4048218-9-hch@lst.de>
In-Reply-To: <20260331152751.4048218-9-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH7PR04MB8945:EE_
x-ms-office365-filtering-correlation-id: efc57151-4fef-45f9-0eaa-08de8ff00819
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 ppbgRjutIRb119DAuJr2i4kMauNUhKXfwgOLmW+8I1bXRGBGKVYOiCwK8B9GeVMNDT/tEXsiYZiPlh5FpZIxnZRjmhN/KAUkQZ3GlSBbsou5EpNY1Y/CtGLgJoE1GIkEeG0PNpf4/hn5+6ikPSpKbldCFsWBt75iWci32MACQDkqHfbSxf9dknHRcXGVAIGG3ZEamDlldGFlvuq3XmmYLA4+H16Lg7hdHWraCXrwV7nhKbfBo8Qj6QmygKxBq4nzPiM79T/3GSCUVP+lX+JdCbuSxJEcIqZgeyjy9zrt+5pFU/bH18w7gBM3OC2UGfwzMe3Fjcvst8NMQm0X+xrfDK7trxpQqD0rpMthhcc2OTfizegl5LFT/3/QJGX1I94Qmrb4IXYbH1oTwksy8WT301B87y/cdxPFT80SWTt41pOCHpYgfKtsves6/m4f8zMH6YJKsMQe4QJZuhL/DRolLdzuWu9lmVVq6DDuA1lxq/DcMb1aHcfIWPzzT7ACeM24LUflbU415K9mVuMu6iq+sIe88QQp5TkuvdBtTUqmQUUGYkjPqLuiy52NKq/5B7Zaj0w5I30ccKnlxM9V6kRkJsx8fbXOWknrR7EuSJBO2YL1WftoYxEY1r4RoFeD6VM4wrED17bl2p0ejalDURfVy8cEwqyDYUx/2ehUOz7oXD59p6g3VO7nK7Zlpv0mH4dMSDYJgE3O+o4RTwaR0vaVtVJ3z+nj0xf0XVaqdItGJ0N6KcXTX+78d2t+ijZxRiEoSNlXX3BMkxR4ymx2Yz2SW0pqBRF2ko2VHMPAKgTwXkg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0R1aDNNL3ZoNXNIQVJ4V1BiYzJqdG9nUTlxcEg3disvZVcyaWROQnFvVnY0?=
 =?utf-8?B?Nk5MUHZ2aVVFRllYQVF2YmxaRGtTYXdZRWthb2xTdThwZHpUUGxkM3U4c28v?=
 =?utf-8?B?QzNRT3Q1cHNhU2Q3R2RqS2JLUHlZaGZ4TU1sSjFpK1hLdDlEY0tEL0N4WXZs?=
 =?utf-8?B?ZnVKS3NGMzhHU2lsNzZOdlpGZGNZMGFuaHNHd3FJeUd6TlNDS2pENElSWStx?=
 =?utf-8?B?TG5ORC9tMFNySW4zMHRNeHBPYmdiV0FtUzBuZW9SZTNyZXNFWXVZQStlRVJV?=
 =?utf-8?B?TnhhQU44T2p4bUZURUZhWEpEUHdCaFFWeFdDanVhR2F2TFEzWXZIUUdIQ0Zu?=
 =?utf-8?B?YzVPSHhMRUU4ZkMwMWhIS1pyeXEvYysxT2l4cFBGdWNWMnlFLzQrdmVMTCt1?=
 =?utf-8?B?VFdwVTY2ODZyV3JuRml1UEZLMFhDNmN5bXE2NmNrck15OEhoK3VNcUo2TEY5?=
 =?utf-8?B?OHcxdHNDZmJXMDlHeDJ5NkRMazRBWjdQdzMzN2JsZ1lNUFpVdGxFMzdXQW1u?=
 =?utf-8?B?R3hOcTNsUlZ0eTdnVXdhbW1WVUx2SE51ZjNKSEwzbnJQN2xCeFhlanozc1d6?=
 =?utf-8?B?cEFVSXVVTmdlNGgxMlFMUXZ0RXpCL0x2WHo3cEJqQWtEa1QvWldKdExhSzZJ?=
 =?utf-8?B?cFdBM1ZzdVlNS1J1S0tHNDhvamRMV244eFlhRVFXdVh2bkllaGlvYVRuMU9R?=
 =?utf-8?B?c3psRUJsZTJFbnFVWittVEY1Z3ZSWVl1Mjd4dDNrWW9MZktaQUxUQmlDSXBC?=
 =?utf-8?B?dGJNaTJVZGZqem1VZXlyMFR4MUh1VHN1aDl4ai9DbjFlWmZOaFp5T3h5RlRk?=
 =?utf-8?B?WFRQWVJiWkpvTVZqL0I2VTYycUtKQkpXQy81dUZ6VEhvWFUzYkYzR2Z3d3U4?=
 =?utf-8?B?TFBWOG9XSXQ3a01XSm80akZ1anJqc05kUFdLejJyQVU0bnl5NmZLRmczOVRG?=
 =?utf-8?B?eWphNCtId2loM1oySkMyUGwxZkVVT3RVWEZaRVBONUhpRk9hUUlEQ1hwSWg3?=
 =?utf-8?B?WkM3cjJlSnJrcUZTMC9OMGVndDlJUEJBY2R6Zkd4R3F0a1pKOUxuSWJ4Z0Nv?=
 =?utf-8?B?OVF6ZkVjMENJWTJ5UGd0VDZkaU9VRUMxaDIxajJyd3k3SERxVzdXcXRYcnRj?=
 =?utf-8?B?VUo0eW5oM1lnQlovWTlJNXV2WEtiblA1Z3g1amR2MCs1djV4aTFUanUwSGRy?=
 =?utf-8?B?WGphY0xzKzVBTWVpd2puTmVSOEU5RVJLVlVxam5MQ2pGeThlZTBlak9WQWth?=
 =?utf-8?B?dlNuR3RyOG1PV0hHRzNLb2N2UVUrZThjRC9rUm16QTRsR3lKZHI1eURaWm5Y?=
 =?utf-8?B?Tkl4TUc3anNRdGd2QXUwaTFlT21iWnBBNm1UblJGVTRSeTlPdXZNZ01TTUl3?=
 =?utf-8?B?SnpzOHJ4ZHEwaTNoQnlRblQ0cFI3T0RuK1lwdW5PWG55S2VuNHh5d1dEMWtI?=
 =?utf-8?B?eHBMdHhPVElXN2xyTjA3TEZudkVkVlhWNUtYeFVCR2dLU2dGUHZZSE1qUmtE?=
 =?utf-8?B?clUwUHhzSHc2YVB3QjQ1aFFjYmpIUTZVQzZNMVlGYkFhTEdkbEtpeDV6RVdF?=
 =?utf-8?B?N1hlU1V3bFJFdUdCUmJBRzdQMWp4K2pMYlNDaTRobkJXUzczSGxGT2ZZNEdh?=
 =?utf-8?B?R3ExZFRNZjZLYTIvM3Q3bFk1aXBVR1VtUURITUdyVVNlY2dUK3laWDdYTDZS?=
 =?utf-8?B?Mm5HL2REeEhzbHJ1QXdFUG9wK3JFLzhONEZ2c0VZRlo4VkVWRXJmNExEZmFh?=
 =?utf-8?B?b0Z6R211NW1pdVNlY0JCc2ZRQUl2b3R2Q2RGSHNaNUprby9RdmhzSmZrTEVX?=
 =?utf-8?B?WjZTSS9iSEVIUjl4b0orMldvb09VeE9NM25mbHFWUTU0dnNETS9iRi9XUXkw?=
 =?utf-8?B?SXdaWi9KV01rQTNJaUlRYkFSc1RVaU1QUDRzSzNXZUc2Y2t0M09NakUrMWRz?=
 =?utf-8?B?YThPb1ZiR1M5U1FiMXgzdnhJMS9KeWY2NHlNakdtODJTbEJUYmFwT3NKUFRj?=
 =?utf-8?B?T3FCWWx3aGU1ZWIrN1NxOHJTSkVSWUh4c3VWNFpEY25naWdkRSt1bzhTL2dT?=
 =?utf-8?B?cG9vNndWSjliYkJjVXNwVWpWQ0FIbDdoZGI1eHE2a2pMZ3FWTHc2cUVXK0ZJ?=
 =?utf-8?B?cDFWdWJkbnpXYUJmc2ovcXZ5aGdVN1haVTk4dEFWN2R3bXZUbTJwVFFieUFO?=
 =?utf-8?B?TGVYZHQ5b1JNek1GV3ZMRjl6SHBDRmN4NnhzU3RFTW84eTAzZlp6Ny9WR09X?=
 =?utf-8?B?WG5lQThJOGNzNEF0Sm5NejVqRkhhMDgzQnk4VjB3WkRjdkFEaVNlZzlkNTVF?=
 =?utf-8?B?ejZLa3dqMHpzcU5Mc1ltWURTRWtKVlRhTFM4WVZ1dVhucHVEWFZwZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B0826AF1A51AC4693038EF2C810D093@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Po7f2E7WBK4a5BGh1BXZcIlaouSGB5cCZBEJCEx9kj0r/36FpcibKlC6HrPNMmMtXVQvlg5sYNZ33qj2WKh7fGwa/iRi0tMd/UieP+w6FQGbtoNiBoPKc82N862gmpAsfpuFQo1hpyk4dcYBe4V6EOfPWK2pIknx+s7xWp8+rTXOj9GiluZnSwH4SqRc/K8r11An86ZqyCCHuwOfDssEjke/Vp1Nl3xPfNii9iNQkSWB1jNRZMQu8kTooQEF/cLJyip6+8k5sSZyoHhyIBNCBOCc2NMNpNYTe4IkN+UUoZDFPXTFqezCcOpSWycxNY+REC24tuqLSNkoaulCZSMeog==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A5d3KB8Ekyd+r98vxn9YfzWEbitoz1QtkC++P4H8axn0Zn/epHzHJg+DyWKRSw0Sxec4Ka61SMt/f/+XkUPdux4PH+0CFVVWWdQeMfZ+jiE81lyvL/jLXiqCY6pUk4t1tV7JWr9JsPhjfpTJgbVBcgwNXz8MzwQze6zx7QED+FyoiLxWC79aB+mqhfpXqfV/Er64ZrdIiCQxDuimRYppAQjn+5FkxuzNF0m9iNP9R4pC2vc6ANyoBIHK3gLduKmsFJr6E3yzJNoyYytv+Zhd0WLUdu8IKxjOmx3lzl2XiYW7kPOaF1TfW7Nx7h2RD8cCv9GckaO9LrnOsyAQ6zQzPz1bGHk3qYaL0g7ecs82P+a8fz3f8ovKHT4419OayXfDKWfTQSPANtZALjeTtKCrCh5VqaUMz7JNw0QUqgGgxnSTqr34gfkPibWykStW4zEowQKSEdnqbIL7tm/IVR0uZRWinjcOqy5JmgSL5bHq1P3B//cyTx1fFTJKpBiDMf+o8ztUnpBJeSPw2UH5g7grdBFK5VrKh4RTPzahgp9w0kAmsKbd4VkY36LpoGe3ZcQhQaD9CwlVmcOcBzLbmpkkvDQ608XxlTE8JObK1zoEoqIAOjy6QSBD9HbMWxCHE8uL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc57151-4fef-45f9-0eaa-08de8ff00819
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 13:10:22.3729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kP7wDr4mju5xnhjbtgjN+T4Lhcv8SCCgCoSbUmI8kkzcs26dSRIj8qJSpEMxUvdZf7abjenHul8CnLtixWvb7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8945

T24gMzEvMDMvMjAyNiAxNzoyOCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIHN5
c2ZzIGF0dHJpYnV0ZSBmb3IgdGhlIGN1cnJlbnQgbnVtYmVyIG9mIG9wZW4gem9uZXMgc28gdGhh
dCBpdA0KPiBjYW4gYmUgdHJpdmlhbGx5IHJlYWQgZnJvbSB1c2Vyc3BhY2UgaW4gbW9uaXRvcmlu
ZyBvciB0ZXN0aW5nIHNvZnR3YXJlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhl
bGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94
ZnMucnN0IHwgIDQgKysrKw0KPiAgZnMveGZzL3hmc19zeXNmcy5jICAgICAgICAgICAgICAgIHwg
MTMgKysrKysrKysrKysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94ZnMucnN0IGIvRG9j
dW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94ZnMucnN0DQo+IGluZGV4IDc0NmVhNjBlZWQzZi4uYWNk
ZDRiNjU5NjRjIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL3hmcy5y
c3QNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS94ZnMucnN0DQo+IEBAIC01NTAs
NiArNTUwLDEwIEBAIEZvciB6b25lZCBmaWxlIHN5c3RlbXMsIHRoZSBmb2xsb3dpbmcgYXR0cmli
dXRlcyBhcmUgZXhwb3NlZCBpbjoNCj4gIAlpcyBsaW1pdGVkIGJ5IHRoZSBjYXBhYmlsaXRpZXMg
b2YgdGhlIGJhY2tpbmcgem9uZWQgZGV2aWNlLCBmaWxlIHN5c3RlbQ0KPiAgCXNpemUgYW5kIHRo
ZSBtYXhfb3Blbl96b25lcyBtb3VudCBvcHRpb24uDQo+ICANCj4gKyAgbnJfb3Blbl96b25lcwkJ
CShNaW46ICAwICBEZWZhdWx0OiAgVmFyaWVzICBNYXg6ICBVSU5UTUFYKQ0KPiArCVRoaXMgcmVh
ZC1vbmx5IGF0dHJpYnV0ZSBleHBvc2VzIHRoZSBjdXJyZW50IG51bWJlciBvZiBvcGVuIHpvbmVz
DQo+ICsJdXNlZCBieSB0aGUgZmlsZSBzeXN0ZW0uDQo+ICsNCj4gICAgem9uZWdjX2xvd19zcGFj
ZQkJKE1pbjogIDAgIERlZmF1bHQ6ICAwICBNYXg6ICAxMDApDQo+ICAJRGVmaW5lIGEgcGVyY2Vu
dGFnZSBmb3IgaG93IG11Y2ggb2YgdGhlIHVudXNlZCBzcGFjZSB0aGF0IEdDIHNob3VsZCBrZWVw
DQo+ICAJYXZhaWxhYmxlIGZvciB3cml0aW5nLiBBIGhpZ2ggdmFsdWUgd2lsbCByZWNsYWltIG1v
cmUgb2YgdGhlIHNwYWNlDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3N5c2ZzLmMgYi9mcy94
ZnMveGZzX3N5c2ZzLmMNCj4gaW5kZXggNDUyNzExOWIyOTYxLi42NzY3NzcwNjRjMmQgMTAwNjQ0
DQo+IC0tLSBhL2ZzL3hmcy94ZnNfc3lzZnMuYw0KPiArKysgYi9mcy94ZnMveGZzX3N5c2ZzLmMN
Cj4gQEAgLTEzLDYgKzEzLDcgQEANCj4gICNpbmNsdWRlICJ4ZnNfbG9nLmgiDQo+ICAjaW5jbHVk
ZSAieGZzX2xvZ19wcml2LmgiDQo+ICAjaW5jbHVkZSAieGZzX21vdW50LmgiDQo+ICsjaW5jbHVk
ZSAieGZzX3pvbmVfcHJpdi5oIg0KPiAgI2luY2x1ZGUgInhmc196b25lcy5oIg0KPiAgI2luY2x1
ZGUgInhmc196b25lX2FsbG9jLmgiDQo+ICANCj4gQEAgLTcxOSw2ICs3MjAsMTcgQEAgbWF4X29w
ZW5fem9uZXNfc2hvdygNCj4gIH0NCj4gIFhGU19TWVNGU19BVFRSX1JPKG1heF9vcGVuX3pvbmVz
KTsNCj4gIA0KPiArc3RhdGljIHNzaXplX3QNCj4gK25yX29wZW5fem9uZXNfc2hvdygNCj4gKwlz
dHJ1Y3Qga29iamVjdAkJKmtvYmosDQo+ICsJY2hhcgkJCSpidWYpDQo+ICt7DQo+ICsJc3RydWN0
IHhmc196b25lX2luZm8JKnppID0gem9uZWRfdG9fbXAoa29iaiktPm1fem9uZV9pbmZvOw0KPiAr
DQo+ICsJcmV0dXJuIHN5c2ZzX2VtaXQoYnVmLCAiJXVcbiIsIFJFQURfT05DRSh6aS0+emlfbnJf
b3Blbl96b25lcykpOw0KPiArfQ0KPiArWEZTX1NZU0ZTX0FUVFJfUk8obnJfb3Blbl96b25lcyk7
DQo+ICsNCj4gIHN0YXRpYyBzc2l6ZV90DQo+ICB6b25lZ2NfbG93X3NwYWNlX3N0b3JlKA0KPiAg
CXN0cnVjdCBrb2JqZWN0CQkqa29iaiwNCj4gQEAgLTc1Niw2ICs3NjgsNyBAQCBYRlNfU1lTRlNf
QVRUUl9SVyh6b25lZ2NfbG93X3NwYWNlKTsNCj4gIA0KPiAgc3RhdGljIHN0cnVjdCBhdHRyaWJ1
dGUgKnhmc196b25lZF9hdHRyc1tdID0gew0KPiAgCUFUVFJfTElTVChtYXhfb3Blbl96b25lcyks
DQo+ICsJQVRUUl9MSVNUKG5yX29wZW5fem9uZXMpLA0KPiAgCUFUVFJfTElTVCh6b25lZ2NfbG93
X3NwYWNlKSwNCj4gIAlOVUxMLA0KPiAgfTsNCg0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVy
ZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
