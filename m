Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0392A43F081
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 08:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609643; cv=fail; b=JmCeEndUtnG4XcLvq4rPp4PAX5mOekXzyYtKWe5F7OlU1dBeGiB0fXDEmq1SNkAbDe3Vxb3zWz7Ujyfpwzb/enxV0tOQchI0ZPy6ugBLSixHKnVHsnAi38m8XOWTNez0474qUSvmTLCBwR1RPuj5WpqzwtuDMlB3uhnOHW0jHnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609643; c=relaxed/simple;
	bh=KWJisxgGghCYQ826wXE68T/2xuMm5HRFe8aMpX5RW5c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tuq+gZQ36WOhXhB15htYiXQW5YtFsJDwPs054lM8ToObUJSp7ih/8vZfGhDN4Tz+KkBTNRTEOo+4mVWHuFNDxVsGLbGJ9v6J6lflFH0NuFDDNuDtlIhKnMpOk//RHAduBy7jLKBRX1cI5NgwO0ecYJRm0+NESXhRxI43CNqXIag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q8i5RZ5E; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zRYOU83R; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q8i5RZ5E";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zRYOU83R"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786609645; x=1818145645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KWJisxgGghCYQ826wXE68T/2xuMm5HRFe8aMpX5RW5c=;
  b=q8i5RZ5EI2MP5Nojkx9ZdopVM+A00cFc+kviQQIcTpyte9k4hyD6IdkT
   SPSodCPR5shUqHCr9l6NV8kFInbNK/j7YdAf0DiDKOI5SWIuZRrgCtsmt
   x1pLFe3ctRCmmYMWd+TQcK+hrCOZZkMFaoiWtUmYJ8XBBCgRBYGYfTBxQ
   TmdETDiwbJ3SImFJ6zJ1hn1mFaxCTodzPjjV+tsFbXFAW0WuCJj44PcsN
   JoRzF5JSUE/vxnm7w0qdn6yfCTuygnhAIu4S6en1RQKHxJNjnNFGncbJl
   t+evWmqVrM/2sEoKDNUGCo4gPWt/PPe2UqTTA/lKLQE+jsPBbmc7T3p+Y
   g==;
X-CSE-ConnectionGUID: JIqi1qHzTf2wUOp6zW3kpw==
X-CSE-MsgGUID: R7rzizwpT86dZhMkY0yuQw==
X-IronPort-AV: E=Sophos;i="6.25,221,1779120000"; 
   d="scan'208";a="153986393"
Received: from mail-centralusazon11011054.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Aug 2026 16:26:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eOPZEsTCjQyKuac6jD34eaeg6o7kO21e7ez8iXWUATMI6splmSN7QWQQJAwNmHw7dRAGumxD38ircPiQsw/bG66jabC0YO0ABw4dE6aUUEdm7P+EkceYfS292RklrvqBr9K8hROV07UR0WU/2uKtvl70z04/0mNf+Nqv//KOyG77aNWBPx4x1+oWq1WLHOcMP9h69MllIf6c2Cc2+y0D3gIbmx5LXWlN+8zgyhzK8v+c/AD5BPy5USWuJolFUNSwohA0F4dZ/yg8qNb3o3E1jj4/DsNpaQXiP+SGbOWmRwqrP1GfMciz9e11K2ZubmtXRaFqBVwbs/BBYUVPjwxECQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWJisxgGghCYQ826wXE68T/2xuMm5HRFe8aMpX5RW5c=;
 b=jHU4smEkWVnDHXnI1A+8RJXSZWI9ZBjYmwSMn9kBJ8ufDq2PzwIQaiNlH9EIV2ReGiQz11ktMwczpatS15ouzSZhw0FWTmZ8z9QHXt8bYBU8TfIE2tbt5j5MfLbibUGeyEnPKL+9ZiZi47edZ+91Lr6Km70wP6gPUHdEoFWDYuLdpYuxXUl6MxvjmRuHfstEY0L0l3XBsBaGUSBgl2375oSPmuQW5P+eh9whlCtnFl65/SnokqaPf0cvvzrcTI0OB+84zVqOZdxoGrVbGHVT1mcDcl4LnbIBdZKw4Rfs9/un29Z6QhIitXvOXnEnjA7V7ZTEypaIDc0Nz93ybp3aXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWJisxgGghCYQ826wXE68T/2xuMm5HRFe8aMpX5RW5c=;
 b=zRYOU83Rqqx0Z6mfh5DOqA8CjK6c4KY25Z+Ys2/fhuL4lQEWXZmJXLqfw2Et0Ermbn7DnthU6GxgZtpLKLsNMzuUJwPZXBBe7JpJF6i6bDr7FZSWfw9Vb4MFl8D+oPYtj8ZHwshIV6zQAZrx+ImSmfXP8Ns4YkBLIr3BLRvM+4U=
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by CO6PR04MB7793.namprd04.prod.outlook.com (2603:10b6:303:13c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 08:26:10 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0315.012; Thu, 13 Aug 2026
 08:26:10 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Wilfred Mallawa <wilfred.mallawa@wdc.com>, Damien Le Moal
	<dlemoal@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] xfs: handle NULL open_zone for merged ioends in
 xfs_ioend_put_open_zones
Thread-Topic: [PATCH 1/5] xfs: handle NULL open_zone for merged ioends in
 xfs_ioend_put_open_zones
Thread-Index: AQHdKbFq/AuKUq/To02C/JU+brtdZ7abp2WA
Date: Thu, 13 Aug 2026 08:26:10 +0000
Message-ID: <dadef1f6-521b-44f2-a70e-90c420633ae1@wdc.com>
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-2-hch@lst.de>
In-Reply-To: <20260811164912.124416-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR04MB9269:EE_|CO6PR04MB7793:EE_
x-ms-office365-filtering-correlation-id: b1db3b77-895a-46d2-3e70-08def9148783
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|19092799006|23010399003|18002099003|22082099003|56012099006|11063799006|38070700021|10067099003|4143699003;
x-microsoft-antispam-message-info:
 LUDD52Ouq8fcxSvgbRVgrJd/sOYm0dqsx26k6jKKGVvpJ7wq5+EHizQoPY+e7v7yp1KFfC7mPuMi43ifgkBi+UIzp6Co4pQZgjFcPPgwrxt0BVjeGEYqlz7Ohs8H3kdOCi8KpdrTIOD1sNaRQ44BRcjJOn/OkixOpLvCjrumkZYc/3QHkE30mS9DW17MEvkfvX3y51pVO0/K9mpSgioHFBp6+HDIZmfUgex8pYaeytmRXBBul//nwuV+hdCuNBhbzmnfMgaVQFNnarNIPnNWX12A5ozxxjv9wLGsPTzr2FMPYo1qepvHJwnqsA7m9s4GUIyvgZVfMltp2xrsrTK1BvUUVPMtlY5y9qf+mUIZM9WLq6nwUNdGp4qUVrIrIcT9+BtM7VZimgyamC6SVK8smVgZdc3gAAjT7hx4gazmUwqt8pTOxeK/dsWYOP3IMKQqA9zfzEtBPcWzXjn3nmYnrTUHDwT4QCMYtxkVkSz9gzd9dFsYsd7AIJl3HgeBV/QCSd9IUeYwDetEXxZBJW2cj/dM+AO7U97AKAbI0NCjYXap273Q2cXdFX2s/AjFhwcRnH8oNg1tm5qEg75jamhEJm23KJMJAo9GaEUd3n0R0v3JCxlKRa0AkvT1mEoakPjm29wr3Saya4nRnhErx4IvqsC5FqQFF5bnJEkBVDpEdW0Ku4N7fCXPHWaQ+WA3bzDSyXtdmkp2PDEvgnl+IixQDhsm/KsCOyPJhvwd2ZwsCuA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(19092799006)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(38070700021)(10067099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d25FaEpkOUtkS0RyZVl4WUlPNWdGdUYvaGtuL3lmU2tud1l5alBPVDQ1V0l1?=
 =?utf-8?B?OWZ0a2pSNjI1MmU3RmtBRzAzNHowT0NDSHhMTm12Z1Yxak41eXZibFgyZnN4?=
 =?utf-8?B?UjNlMUNmWGtaWGZyRy9raWxIT1ZzeU9BbVhjZDB5bW5tZWNxV3pBYmlBRWxG?=
 =?utf-8?B?U3VSZXlIM3ZLbTBnYzJ4U05sTEUwZC93SnZzVDdqZmNWQ0djOHlhZGZHUHAz?=
 =?utf-8?B?bHNURzBvcVFjZSs1Mml5UzJiZjRBS1lxOVlEUUh0ZlZsKzkrK3hra250c283?=
 =?utf-8?B?Ujl6THk5RTFJT0FrYVBPTlZ0VGpoSko3MzN4SkFpZG82RmF3TFdrakQxc3pu?=
 =?utf-8?B?eHRRL1MwaThtVDJkSkh0NkRNWUJKRGVwNUF4M0hIbkN3S2U3bEYrZytPVWQ4?=
 =?utf-8?B?UVZTUWRHRVNSNnRhcEtVSDVKcUZxbWlkNk9uWEFPb0tIaUdqUEMzT0xvTWkr?=
 =?utf-8?B?OW5INCtQSStWbUt2NzI0TVRCQXF4eWUxS3JWMUZ6Z0d4cHRmZk9JTGRaVC9M?=
 =?utf-8?B?cHBaajI5bUZia3F6QWxIbVc4MVd6elMrb1duNnBaSkZXMG1TRUpxT0JvbWY5?=
 =?utf-8?B?WDVESUszOCtXWWxHVXFJRTlsNVNQbnUzR1RTTVBXdGZZTlc2c1dIWmhaNEVC?=
 =?utf-8?B?YUtpeHRUQitCNytESjdBbkZLK0VHZ2pLV3lQdkdyVWMxS3VKQy9KQmwyMDhW?=
 =?utf-8?B?ZlJUVkoyeDVkTmJTWXozLzhsazFNSS92UktsaWszdjZqZkd3aHhTU1FpN2kx?=
 =?utf-8?B?VEN0L2g5Q2pIRnErWHZZdTNBdEJ3K2RwMjFjNTFWankyR2NFOHRDSE1VYmh2?=
 =?utf-8?B?REMzQXR0QlBTbXEwTFhsVXJIWGp1MFZQMHBKazNyWDRibERIelFPU3pqanlT?=
 =?utf-8?B?WVV3UFVBR3BFOUpsblZhbjFMSURsZVYrcnY1NTI3NktMZ2lPYnl3TzhuK3NQ?=
 =?utf-8?B?WGxWYUtiY2RrVnNaY0piNXNQOTVWeXJCYW4yNkJTV3FIQkNQMFZ0TndXNGRy?=
 =?utf-8?B?aFhLV0NaOHFDTUxZamg1RFlvd3F3ekJZeitXUHBFZUZvZENxYldQTFJHTGpq?=
 =?utf-8?B?NkZGRjRWVjhzSjZ6RmhYVm95VlFVN2NIVDZDZlBVemtzVnA5Z3J6QlVUdjRY?=
 =?utf-8?B?YXg3eHJFYVZPbzhxVFhqUFl2MXpONnBOMUY4V04yWlMvQ0FwSmFYODFlZ1FR?=
 =?utf-8?B?cmxjN0xSQzJuRS91Y0Nhblo3ZThKRW5jTmRjTjRvNWpiYW5hSXRWQTB6bkQx?=
 =?utf-8?B?NDNJdFBDRUs2ek5zNzBMRkxtNlJnT2Y4TEdaZ2plaEhLSmRwRlhnQllva1JV?=
 =?utf-8?B?M0dobEpqRXpURGo3d3Q0Y3dDdUJyY1BmTVRiNlpKd1Ywc2pZUy83TFlTODFh?=
 =?utf-8?B?SkE3RTFjRlJieHJRVm55c0VuMDE4VGh1UTBwcjQrVmViUnlBOWREc2YyZCts?=
 =?utf-8?B?SFBMcFA4RUw0bGVhbnl1STBTRTdmdDlVaHlkRTFEV1l1MzdQaEhDVlJSUnh2?=
 =?utf-8?B?RnFJUFpOeEx1clhSVnN4ZFAycEQwc0pTcUdJTzgrQjBEQVpDMUJaS3UvOFlC?=
 =?utf-8?B?b0ozWHN5QmR1aW1NclM5WlRuQ2wzMkxaVFQ4K2RBWE95TWV2UDZ5ZlMvYXl4?=
 =?utf-8?B?ZC9EcVBkVktGWW03SlhsdXN4alNaU3dZODlWbVFBWC9BVnJLTDNTOFN2Z2h5?=
 =?utf-8?B?eU1jd3QvY1ZNcTVIZFF6UXJqYnpzeDRIcWt1VHVMT3NveFMxbS8vSC96WGxN?=
 =?utf-8?B?VWxXQVFhSkxMSGNvRW5CU3hNVDhQNWxYbWI0UEZaeG1WeFZEeSs4cUFLeGxq?=
 =?utf-8?B?d1RocllxWURvL2VCK3VqczlnT1c1a0JaQnZFeUFFU2hZdHJ2T3lzeTJsQWV0?=
 =?utf-8?B?OXpuZmxIZjUyZjlndExNNXBlUWJ5d0ZVLzV1ejR4Njk0b2lMWWJOUC9yZktT?=
 =?utf-8?B?QTVNYS9mdkR1eEtIbkc1UnIwamYyQmErMW1zYUxkcFpaZDR5Sk1IaTlNdmpL?=
 =?utf-8?B?VEhsOFpnRVNiRUpnNzRKNzRpempzTEJmWWEyRzJLOTl2U0c5UW50eHdnbXJY?=
 =?utf-8?B?OExuWEhYbW1PWUxoeFRPMFZUbHZ4a3g5YVlURnZscUlaRm1EZEJPSlNnRzRt?=
 =?utf-8?B?WlJYK1k4U1g4c2NBcEY2TGEvSDVrTFpBS0lyd3dqUVpGaDhKejNRaTNkU2dI?=
 =?utf-8?B?WTdNYzFKTUVFbkFYbUd3UUNZdi9ESmNHcXVEUU92S1VyM014RVRpY0NnUzgw?=
 =?utf-8?B?anJUL0Y2NWo3K1ZGOGJpM0l3MDg5N2c3dWprVUR5ZlllOXQyY3h5b0g2YTRl?=
 =?utf-8?B?NXZabGJidEhTRlBGRm1lYXpFcjBDcmoxekdWK0w2azhjdFpmbGlVQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20391C63E2CDFB4DAB8B11E3771F3031@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	TyKJMcCrV9u519WtVGKh+N6Ck4dgQtv0DxIKFlmwfiGZeSzMAvTQ6jnVwyvbPgPr+1oJ879A4U0WLzEMwevWte0yvJUARzpA9z0T4sIogOATVek57QRN0N0W7wrBlhqylXg4XU35GELeQn7D39cld67rCC+ZlKK9xoNYb4cd/K1vvKu87ScaiWVQZhVt+LpZl8Ak02etjY9kJw+n2HcQMGGk1CRxIQygxMJf0xyhZ22OLNnLIZgWhHRK2J3kFJ/h7KMeeM8W2zlK0QpidTHCNJ+uk2OLIAz2UlnAV9z9eG3T+Fv1fla/kUJmlQDtZLyH41e9TtXsvRI6hSoAW8oXUQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9mMH6vrdCXsx+1M7uPosO28bqmaCctG6+lC2cCF91D+Pu0EIASVmSOeUGNHwPs2+hh60f0fSMdxF+zX/HuCvmp53thcO8d6pcPoSwNmEh9l7JIhoiQEX3jIuFrO/Int6zH5sixqu2ajwnamMmxRFIODXlQ+6UxTQC1Uz8EIXomagyLwSf+OCZK8tG5xLh8zdDjqYE5vYNOy0HTzK5fKMvFEd298ruVOkx6bgOvKU5SsglZnc8p4Eyb5uq15HCDQcZwFNAU5x9yoHvrxxOwKq1K/7slU2KNMkxnPK/X2RMM3ecBJ57UtbvDBtGhNTzMyqJlkoGy/WUDOHz0xQiJCXvAYoBUCaHannyYKRUuli9IPWdWk/cB7zRSoBEXXAHGN8vTQlTnbyr0ijMdSvdj19FA2PXMJuyTAclO1eF7f2r1aRW8kiGJpSxn3jlwLhUGspXGgKmO9JSONA1iTJ0oOPxD9kO8tkqoBVuN+TVg5ShXQjBgB9VdqdmcQhMxHOK7mYIR0TSUXoYcZB8VwpxDOkR2Ampg34aF5gHmRzCOu2BcSC63RkUpsp2ZZqmbZd1DI1VLdxWa0QP/1Pl1tYjL+RloNyzA8yqHDfmMBu2Wfkx4S44kuTWiLxCjgvuWkMSaed
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1db3b77-895a-46d2-3e70-08def9148783
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 08:26:10.0963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jpy3EOBsxny6APqXjxRhJUbN3GfhKz3jHO9B9tB62ubO7WHoxkLMZQMU8y5yuEHLZsD4qLTECRvDPfhU060EVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7793

T24gMTEvMDgvMjAyNiAxODo0OSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEluIHRoZW9y
eSB3ZSBjb3VsZCBmYWlsIG11bHRpcGxlIGlvZW5kcyBiZWZvcmUgYW4gb3BlbiB6b25lIHdhcyBh
c3NpZ25lZA0KPiB0byB0aGVtLCBhbmQgdGhlIGlvbWFwIGNvZGUgY291bGQgbWVyZ2UgdGhlbS4g
IENoZWNrIGZvciBOVUxMIG5vdCBvbmx5DQo+IGZvciB0aGUgbWFpbiBpb2VuZCBidXQgYWxzbyBh
bGwgbWVyZ2VkIG9uZXMgb24gLT5pb19saXN0IHRvIGhhbmRsZSB0aGlzDQo+IGNhc2UuDQo+IA0K
PiBGaXhlczogMDU4ZGQ3MGM2NWFiICgieGZzOiBpbXBsZW1lbnQgYnVmZmVyZWQgd3JpdGVzIHRv
IHpvbmVkIFJUIGRldmljZXMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4NCj4gUmV2aWV3ZWQtYnk6ICJEYXJyaWNrIEouIFdvbmciIDxkandvbmdAa2Vy
bmVsLm9yZz4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX2FvcHMuYyB8IDYgKysrKy0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2ZzL3hmcy94ZnNfYW9wcy5jIGIvZnMveGZzL3hmc19hb3BzLmMNCj4gaW5kZXggMmEw
YzU0MjU2ZTkzLi5jODBmMDU1MDczNzMgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfYW9wcy5j
DQo+ICsrKyBiL2ZzL3hmcy94ZnNfYW9wcy5jDQo+IEBAIC04OSw4ICs4OSwxMCBAQCB4ZnNfaW9l
bmRfcHV0X29wZW5fem9uZXMoDQo+ICAJLyoNCj4gIAkgKiBQdXQgdGhlIG9wZW4gem9uZSBmb3Ig
YWxsIGlvZW5kcyBtZXJnZWQgaW50byB0aGlzIG9uZSAoaWYgYW55KS4NCj4gIAkgKi8NCj4gLQls
aXN0X2Zvcl9lYWNoX2VudHJ5KHRtcCwgJmlvZW5kLT5pb19saXN0LCBpb19saXN0KQ0KPiAtCQl4
ZnNfb3Blbl96b25lX3B1dCh0bXAtPmlvX3ByaXZhdGUpOw0KPiArCWxpc3RfZm9yX2VhY2hfZW50
cnkodG1wLCAmaW9lbmQtPmlvX2xpc3QsIGlvX2xpc3QpIHsNCj4gKwkJaWYgKHRtcC0+aW9fcHJp
dmF0ZSkNCj4gKwkJCXhmc19vcGVuX3pvbmVfcHV0KHRtcC0+aW9fcHJpdmF0ZSk7DQo+ICsJfQ0K
PiAgDQo+ICAJLyoNCj4gIAkgKiBUaGUgbWFpbiBpb2VuZCBtaWdodCBub3QgaGF2ZSBhbiBvcGVu
IHpvbmUgaWYgdGhlIHN1Ym1pc3Npb24gZmFpbGVkDQoNCkxvb2tzIGdvb2QsDQoNClJldmlld2Vk
LWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQo=
