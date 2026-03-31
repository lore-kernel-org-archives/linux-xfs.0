Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750212BD02A
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 07:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774941184; cv=fail; b=cEHGUsL94LrVW72iakVi9g7SLTpyDwEKjcGTQA7suF8zj3sb7QBN6cFPjZoKHHi1hz+/CHABAeIzPw2OACvif53qfXvbOb4EyEVsMrfBU9ebPg65KK2xXec6UndWBUK6uw5PRi3q1si47VLWxbPXC/xbMCucM1x0kDhUF3etYIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774941184; c=relaxed/simple;
	bh=ct0piRjV7fLpC8ZUGfHvEP6AtRP0ifEdZsbdpV1/azo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dWnW3P6DiRZ48c58hSAc45r0DT8rm9l0gM+++vIczLZlNpj9LCSV8GTOEMwc7RwQXLP8b8BP80v2y79eQoP7bdURPqULznkGq0KODXco7t21mMQfXNtNDa7NYa44+zgJ3waXYdTGcwCkIkxhCS13k7THHPP5J3E5Wnkv386wQNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rLp613Ok; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=giXAcdeI; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rLp613Ok";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="giXAcdeI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774941181; x=1806477181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ct0piRjV7fLpC8ZUGfHvEP6AtRP0ifEdZsbdpV1/azo=;
  b=rLp613OkeyNAoztguWnS4u9veI+y3nH/Aepm4DSTrM5zvLxhqVTuvwzD
   3Qp3mV+9VDnRHCpvIqc+3suRzGHywiFB8GKXq1qTgBpd8vGusxR+DB1ae
   xpJWJG78otx8zF9o6bMiZF6Nezt8V5Uur9EQCi8+LnKF4Azyu4FJxaFF8
   2Z5xHCk8rcbItekYkOxD7TsgEMQON6mYBXktnXxQGGjL5uOLUxWqqHyzL
   rAchimYmRWUyohV0BgYK9+tao6J2cRxBCmomFyT5k8oJM94X9GY85ozgz
   +L3XHCtzh1LC9UvZ0wOcJXSQYQUI9aCMGVF1CjyPms4Gmc4D4sluslYKm
   g==;
X-CSE-ConnectionGUID: dTzN/SjbTASNHRPghtknSg==
X-CSE-MsgGUID: uszGdYogRtyCsUXvvU4z2w==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="144076668"
Received: from mail-eastusazon11012056.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 15:12:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSwurfCFJINeFPQumuuWBX6EuhV/yh1CEYKYCRTtaxCcDaf+gn79gadspap6ADOq5TAqq/9l1Ejlev43XRXTWBKAa4qfLM8hSoyR+2hdJpc6EYEKLCB7kn/RghbdeC2/Zq2wJkOqr6lMXu9KhOvSC1iPjIT8mWTrQ5/lc5BC+0ClHG8RLaEk/+oM08ObYLR1vCkRbz5cHPPYUHJtZiHvBz8+8TuQo95xHLU4lojIw+OGBvPoy5S7OpYUqE2PKS6agyuqmjkCOtYmUFgnLpJ82JhxewmbB9JwDol3uPL4jQV+UVzKrevGdg+mFyXuHiBqa5kYEYL//C9dBBDXr8WsjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ct0piRjV7fLpC8ZUGfHvEP6AtRP0ifEdZsbdpV1/azo=;
 b=xUMo7r7G2409ILtJrb/P0maBRorTks01SEhv66W8btJuLTpb350TPHvbRirg3A5FgJ3TJJjynn90p3ibwgpBu3bLLsNhFpZKQmV0qJjfwaSh4tS3pGqpjCfJrUsRvMFxTnd7et0gZ20dhxXPGSU4qxOZg/gLcH1OxbN1NJjOAe7wda65Sd31QIFC63O6YZseMhJr4UNRaV3nGnjFrwPKdIK5l2AjNAIWoenaw7oDptJmY4D1tY+xUil5BXS6HTzS1jMCo4+ynQytl+paFKTBL9QchxlY2HYU7mWSI8k5MoiZL3HzRG9w1JgICMucclctfHGNvh62zX7trNh/6r6h5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ct0piRjV7fLpC8ZUGfHvEP6AtRP0ifEdZsbdpV1/azo=;
 b=giXAcdeIMuZ/sNnFhRzBTeT0cnnWOUZwn91NJuowwnsjS/n69SfCLOTuYV3GAfTQ//4NzvM6NdHlqEBZzXX3PcOF7HckKqANbzD0I80Bhqjf6Bz2f189lYntGxX6vK9l67Fx5xzEtzQ09vaUGzK51UVZE7lJLEhpXre82qnvmmU=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SA0PR04MB7323.namprd04.prod.outlook.com (2603:10b6:806:e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 07:12:52 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 07:12:52 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] xfs: refactor xfs_mount_zones
Thread-Topic: [PATCH 1/4] xfs: refactor xfs_mount_zones
Thread-Index: AQHcwAffi8y2TW8BJEC8myl/iHPNlbXIO4KA
Date: Tue, 31 Mar 2026 07:12:52 +0000
Message-ID: <b29a0652-930a-441a-9af1-d641f92a3efc@wdc.com>
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-2-hch@lst.de>
In-Reply-To: <20260330054111.3855818-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SA0PR04MB7323:EE_
x-ms-office365-filtering-correlation-id: 80ed474a-c1ea-45e0-de9f-08de8ef4ec65
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 TFJXuZFDSbuobr2pgOfbXTLIZvrzzq+ynFT7R8GIw/XoQshpGsO7y7oYM9/k7tM6ixlwkLI7NOvksaMmBvZ3mSO3Z57EPQua3k8r9HPraNTWDWMmJqbcnYpXDe03yGjy4eRkHi/6EFt0VHjOF0UOjPP9dIe5R//x/TEjfkA0/EGSDBmTPsmmU1xi2d3RWYggYXzrx2W9LF0FTwGjbJ7e5+5Kf+Lfc0Bg/K+MxbCWk7iwRzV492b21kZBx8YvJxMaFHKOknaAUT7/svpbnLm7Mtzl3QlDGw8zja2qAPJq79uHMoKIS8jgOU6DUF9E+0YlDbSDeQMYDGdni2aINLQkv9zeY8dB4vcyOK8jqwl1zqIgrynlflsanoPOrWGXPPfDY6Rv55j7AW86Zjf8FKUQVhg2deekVk8m5HNNj7bPUFS4RjYiX3zqnqlqRapppf03mnnSoJIMyGdQUd+15lg8aSTXo587N/10MacSVnGf07y+8O2c5UrAOyiWB534l80eDI/fwz4W/j4EK1I1lpbSOQdgR7L5dkXmfTIrBAUTlpRu8bYqanxOCLZaeJNXm53g6JM94sspGcHkVu+akHc7TlOJh9WIqsX+VtbHj13JLtsA1vSm5oWgBixZvLFrBzDzHvn3oLgg5RCZKLOfMZIcT+6QGMhSkLz2TCChMIrNeBgpY3pgByvnCqKpGfkAl751MYHQqSmuX6iN9fFV5RtRkqbfQLK6q1ZVj030vevljDSRKzeBN9M6Z+jTpB5s780cPllNXwLKboOL97eNSBiiq6eEmnG+w1PKk8xa2UXMjCo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RXVRYmFNcXNaUmhrSis0eFBSa0FTWk16aVN5c2hRT2tnTEpJV0pvcG1hZDJT?=
 =?utf-8?B?TkxzVmlNVjBIS3Rwd29LdU5yT2ZUR0t0WXIvakN0NGorQk0vNm8rcXdhV2hy?=
 =?utf-8?B?SFV4MmUrK0doT05HNGxSRCsvcFdqMW40MWtuMWVVZmM3YVdXYUZPTzAvdy9R?=
 =?utf-8?B?ZU9FQTQvNitvM0x3QzUwVVpoTFh1eTdJWUw4VlNuSkYxQ1podGRwTTl4N0hE?=
 =?utf-8?B?UHVDZTFIRVhhUUhyeWxHUmRsRUgzeUtTc0U5blFsbVp2cFZPZlcrOWxqbjgw?=
 =?utf-8?B?TzBINVQ1QzNac0g1TEorcUhPVUJlVGluNTRCL0Y2OUpkL0FQYzhaRWY3RmJE?=
 =?utf-8?B?ZThSYStHSGpLU3VjYmN0b2FLdFZ3S004QzRzMWk0WlBHOGc2WDNSOEkxVHpG?=
 =?utf-8?B?aWxqZHlSRTAvMFplUXhUSXpsN2RId2RsZjZkUEh4a1l1K2htK0UwdHo0N0lX?=
 =?utf-8?B?QlF6WGxaejlXSXl6S002QjdGa3RYZDM5Zkk3V2VKdzhOWThQRHFCMWNNUUpV?=
 =?utf-8?B?aVR4bEFTK2V6VnhlUVkyMFBRc1hpSnZJbEE1YnpIK0ZXU3VRdUVKUUt0UGt0?=
 =?utf-8?B?QTVYVkdpKyt4Y0Fobytpak9nZzNJNU5nYlRKZmJkVlI3YnFJNGJVaVBMQ01Q?=
 =?utf-8?B?dGQyVnJ1RElxUEp1RnJWTFh5aURiZ2dJOC80UmhXS0QwZmhERGg4YmxmR0dn?=
 =?utf-8?B?dzJpV1c5TW9qbmhYK1Y4ZDJpZm1pNkJhSUsxUEtjL0Z1ZDJBeUxaZTMzQkNN?=
 =?utf-8?B?ektqR2tFZURqNGlrZWJCWjJOaXRuR2hxSjRGdEx2eHJJQ0NVWS9GTVd4THBQ?=
 =?utf-8?B?TkcwNkFONGE0bXZZeFBCemVMZTdXSEJMcWU5V2FoOElQNys1ajRleDM3dzJI?=
 =?utf-8?B?aWIvZHRydVpvV2EwZkJhMUhvZStoRDMzcFZKMzRpSGlUL0VmbGNoWVdZTGdR?=
 =?utf-8?B?WE5CeGE5M0NDS0tFYUZxL3ZDeStkWlp4Vk56QW5OZDFnOFFBWHd3S1JCNWxM?=
 =?utf-8?B?RHpZZW4xOHppN3dJT1F1cjd0TTVmeVBRMm1FZnVaL3JkLzZkc3Y5aEdjMFFt?=
 =?utf-8?B?bVBUZFl6UWJ5Mk03cTdqaUdWYXlqakxWNnN1a2RzUk9RTXcrVkdsT0tybjRo?=
 =?utf-8?B?bnRNRnhRNjY1ZmIwcXBWYURTdjdBdVRtaTRKRDNubzVKdjRvU1h5ekFTUUl3?=
 =?utf-8?B?cytDOVZEZVh5bmxoQjYrR05kdURRbW1TMk00Vit5S1NIRmUwcFpvN1FBcEtN?=
 =?utf-8?B?NTRzZlZIZE4zQ21BM3ZycFc1cFpjT2ZFeGtVbENLUXczVXpOckRlQ2xxOStB?=
 =?utf-8?B?WTl1Nm56ZkZQWExxU3RSZ21DbWovUkpyVkNyWHNnV3VYTXBTS3NaMUZ6ck4y?=
 =?utf-8?B?eW1CMGp1WCtmWVpqTWFmY2J2cFdaR0haRjk5L29KRFlQQWlGNFRmcGZIZ2w0?=
 =?utf-8?B?RytJMzBwbEU1UUZ3VUIwVitMcGVUZVI4c25SWTVzVVJtdStkaG1EZDkwdHdv?=
 =?utf-8?B?aE9VTWFOc3JWUG8rMXF2OTFCazg3dkRsN0VpSUc5eTFCQ1FWTFpMbVlVY2JK?=
 =?utf-8?B?ZlV4eWtDK1IzVGRHNkJ4L21ZdEdCKzhGMUhnckppR3EvS1dtY2JnQVpWWjRv?=
 =?utf-8?B?WkpNdktCcElidGRhTkQwSytrMHp2Q2NqekE3eEJpK1BSR09rYlJ5RTZ1VWRn?=
 =?utf-8?B?WGJ0Nzd4Ylc0NndKWHN5cVgzT2pBa2JYVHNNRWc0ejJiRDhxVVY2ZXUrUlBp?=
 =?utf-8?B?bEtPaXRrd1ZBaWpuaDVjL3BkcTJ3OFE2S3F5eDRMWnRUMkw1dXE3L1czZE8y?=
 =?utf-8?B?ZXQ5cUdIYWViNWtSVStINms4c2hEMTBBeTUybForaHZCMHpHZ1Y1UXREUjNL?=
 =?utf-8?B?Mkp2N3QzOTBTSVlUMi9sNEhIcnNGTU5xbEhNUFZsS2xKWlRXeSsrVndYZjBy?=
 =?utf-8?B?SisvdWoxNzM2N1kwSVBrYkpwOWtvakMyMEhSWm10alFQVlhGaWNPa3pJLzJB?=
 =?utf-8?B?aS9mNTJSN0JIbVFGdkZGWVZ3d1d3dGpYSmF3MkZNcUZMSmZDeTZQUzR6T2Fk?=
 =?utf-8?B?OVJSV3hVakdkdzZlNC9CR3F0R3pnTDN2enI1ZHhCNFRiZkxobDdIVFFaZTk0?=
 =?utf-8?B?MGFaUXZpSnd2cjdBL2MxeG93Ynk1QlNCM1pidGhvM2hScWZJclRTTFBaRVpP?=
 =?utf-8?B?TjZWYjFOay9lUmRCUmZXQTZieWdjNnFOREc3dEZSWXhPN3Z5YnRYeFFwd1B4?=
 =?utf-8?B?ZDR0N2xPaHAzbnlXaTZRY1pkZS9ObTN1Q3ZmVnRhWDVqekZ1d0NZa2xKSEpt?=
 =?utf-8?B?K3UrQUNhUVdlQm1iZzN5YVVKK3g4MEFnaHdmUGNpRHdWdlVmQlVQQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB2ED1489178094B884240EE12F18E63@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	OHYWlCYRG65n/k8ggXvD896FFU9WmzjEotOo9oW1r2M0Sg6ZnMf8T/V6AprpZpRNS+sPWBjgkXDXUiseT/yBsnnajvvhkz2ULrC9WiJyYKXhDOyzo/LE1Ct3JHEiN7vnGiW1TMe81O97bjO0CyX1Nf/5pr3rZuo6mjsvXua+kgAJYFgu5cX0Hqc98TqBpn046kVcrFmRYehrZZcvFbEgAlnVJtxBxGehrR7ZsvNwUaXywLKkTLIdYjp320t7ayw8ntXvHvSfpeLdIWFXB28gZIlK1dG+JX8+h2wz0oEuqmGm4CEp1naM8fIIYWmjSBKMOaubWTNUnJjGgtEzq/Yqng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZLX7cKvNepnZL6FqsDPaKNPtEkWckl9M0HxInjysm7i359crcApdOsBcFgFju4gX6bsOvaUfadg8z7mbkYuWliU+aID3Af3aX82Q08s/I4hyTkX+IvwpOG2pYwtF3Lnnr/FuNrlm2JvMmQ4FONDblRLEP5I3PIEc6cw1tmnaOLz4vWxNW82bKDqyv5UHXxycpXYUxRDtL31YvF22sJzy6blrIlt2VyVzxX03NbbKK6ugU4qR3n2KyggUwFYgh70rg0ff3/13KAtHoK8hh/Wz/eTmyHFLMk4Yjt6x9QaATa3XNzkHHqWYO2DVN8rSSVnuUnJsLq0M7OAyoqjqgrLeGBQ1GJ+k0zdJMmI54kmVywySaY9UInI90dFTGYFpMGmqetLSYkZg56hJEglLujA5tbzRT9ksyIGsvZl26ECEnzyNlEIn3QjIEaaCpKyoRp2/W+IHrIydcFwxQldaizgw3vw/gRCbo6USwTjglITJ3cmOVRZclzbnqHyoWNC9cwgJJRjsdUVXv3ilI7VN1EiSdmBhbh8Eue2HkT7LygCJRBYaiyYw1Oih09f5gogo+9Y47mwhVK8sNesbfGI4ZB0rMQ4YTnl3GXLPvXmPe7rM2ZPMw9vIA8iJAPJxJab16KZL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ed474a-c1ea-45e0-de9f-08de8ef4ec65
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 07:12:52.2013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TD7LMqKEdhadplnSBVgJKgQ0OZkbj5cay0A90FUnIDS+qLOX39bm+An4dlp0E9tPmrULu/pEdi6Z3IRL0x9Eww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7323

T24gMzAvMDMvMjAyNiAwNzo0MSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IHhmc19tb3Vu
dF96b25lcyBoYXMgZ3Jvd24gYSBiaXQgdG9vIGJpZyBhbmQgdW5vcmdhbml6ZWQuICBTcGxpdCB0
aGUNCj4gem9uZSByZXBvcnRpbmcgbG9vcCBpbnRvIGEgc2VwYXJhdGUgaGVscGVyLCBoaWRpbmcg
dGhlIHJ0ZyB2YXJpYWJsZQ0KPiB0aGVyZS4gIFByaW50IHRoZSBtb3VudCBtZXNzYWdlIGxhc3Qs
IGFuZCBhbHNvIGtlZXAgdGhlIFZGUyB3cml0ZWJhY2sNCj4gY2h1bmsgc2l6ZSBsYXN0IGluc3Rl
YWQgb2YgaW4gdGhlIG1pZGRsZSBvZiB0aGUgbG9naWMgdG8gY2FsY3VsYXRlDQo+IHRoZSBmcmVl
L2F2YWlsYWJsZSBibG9ja3MuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdp
ZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDU0ICsr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMzQgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZnMveGZzL3hmc196b25lX2FsbG9jLmMgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPiBpbmRl
eCAwNmUyY2I3OTAzMGUuLmU5ZjFkOWQwODYyMCAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc196
b25lX2FsbG9jLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2FsbG9jLmMNCj4gQEAgLTEyMzAs
NiArMTIzMCwyOSBAQCB4ZnNfZnJlZV96b25lX2luZm8oDQo+ICAJa2ZyZWUoemkpOw0KPiAgfQ0K
PiAgDQo+ICtzdGF0aWMgaW50DQo+ICt4ZnNfcmVwb3J0X3pvbmVzKA0KPiArCXN0cnVjdCB4ZnNf
bW91bnQJKm1wLA0KPiArCXN0cnVjdCB4ZnNfaW5pdF96b25lcwkqaXopDQo+ICt7DQo+ICsJc3Ry
dWN0IHhmc19ydGdyb3VwCSpydGcgPSBOVUxMOw0KPiArDQo+ICsJd2hpbGUgKChydGcgPSB4ZnNf
cnRncm91cF9uZXh0KG1wLCBydGcpKSkgew0KPiArCQl4ZnNfcmdibG9ja190CQl3cml0ZV9wb2lu
dGVyOw0KPiArCQlpbnQJCQllcnJvcjsNCj4gKw0KPiArCQllcnJvciA9IHhmc19xdWVyeV93cml0
ZV9wb2ludGVyKGl6LCBydGcsICZ3cml0ZV9wb2ludGVyKTsNCj4gKwkJaWYgKCFlcnJvcikNCj4g
KwkJCWVycm9yID0geGZzX2luaXRfem9uZShpeiwgcnRnLCB3cml0ZV9wb2ludGVyKTsNCj4gKwkJ
aWYgKGVycm9yKSB7DQo+ICsJCQl4ZnNfcnRncm91cF9yZWxlKHJ0Zyk7DQo+ICsJCQlyZXR1cm4g
ZXJyb3I7DQo+ICsJCX0NCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiAg
aW50DQo+ICB4ZnNfbW91bnRfem9uZXMoDQo+ICAJc3RydWN0IHhmc19tb3VudAkqbXApDQo+IEBA
IC0xMjM4LDcgKzEyNjEsNiBAQCB4ZnNfbW91bnRfem9uZXMoDQo+ICAJCS56b25lX2NhcGFjaXR5
CT0gbXAtPm1fZ3JvdXBzW1hHX1RZUEVfUlRHXS5ibG9ja3MsDQo+ICAJCS56b25lX3NpemUJPSB4
ZnNfcnRncm91cF9yYXdfc2l6ZShtcCksDQo+ICAJfTsNCj4gLQlzdHJ1Y3QgeGZzX3J0Z3JvdXAJ
KnJ0ZyA9IE5VTEw7DQo+ICAJaW50CQkJZXJyb3I7DQo+ICANCj4gIAlpZiAoIW1wLT5tX3J0ZGV2
X3RhcmdwKSB7DQo+IEBAIC0xMjY4LDkgKzEyOTAsMTMgQEAgeGZzX21vdW50X3pvbmVzKA0KPiAg
CWlmICghbXAtPm1fem9uZV9pbmZvKQ0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIA0KPiAtCXhm
c19pbmZvKG1wLCAiJXUgem9uZXMgb2YgJXUgYmxvY2tzICgldSBtYXggb3BlbiB6b25lcykiLA0K
PiAtCQkgbXAtPm1fc2Iuc2Jfcmdjb3VudCwgaXouem9uZV9jYXBhY2l0eSwgbXAtPm1fbWF4X29w
ZW5fem9uZXMpOw0KPiAtCXRyYWNlX3hmc196b25lc19tb3VudChtcCk7DQo+ICsJZXJyb3IgPSB4
ZnNfcmVwb3J0X3pvbmVzKG1wLCAmaXopOw0KPiArCWlmIChlcnJvcikNCj4gKwkJZ290byBvdXRf
ZnJlZV96b25lX2luZm87DQo+ICsNCj4gKwl4ZnNfc2V0X2ZyZWVjb3VudGVyKG1wLCBYQ19GUkVF
X1JUQVZBSUxBQkxFLCBpei5hdmFpbGFibGUpOw0KPiArCXhmc19zZXRfZnJlZWNvdW50ZXIobXAs
IFhDX0ZSRUVfUlRFWFRFTlRTLA0KPiArCQkJaXouYXZhaWxhYmxlICsgaXoucmVjbGFpbWFibGUp
Ow0KPiAgDQo+ICAJLyoNCj4gIAkgKiBUaGUgd3JpdGViYWNrIGNvZGUgc3dpdGNoZXMgYmV0d2Vl
biBpbm9kZXMgcmVndWxhcmx5IHRvIHByb3ZpZGUNCj4gQEAgLTEyOTYsMjIgKzEzMjIsNiBAQCB4
ZnNfbW91bnRfem9uZXMoDQo+ICAJCVhGU19GU0JfVE9fQihtcCwgbWluKGl6LnpvbmVfY2FwYWNp
dHksIFhGU19NQVhfQk1CVF9FWFRMRU4pKSA+Pg0KPiAgCQkJUEFHRV9TSElGVDsNCj4gIA0KPiAt
CXdoaWxlICgocnRnID0geGZzX3J0Z3JvdXBfbmV4dChtcCwgcnRnKSkpIHsNCj4gLQkJeGZzX3Jn
YmxvY2tfdAkJd3JpdGVfcG9pbnRlcjsNCj4gLQ0KPiAtCQllcnJvciA9IHhmc19xdWVyeV93cml0
ZV9wb2ludGVyKCZpeiwgcnRnLCAmd3JpdGVfcG9pbnRlcik7DQo+IC0JCWlmICghZXJyb3IpDQo+
IC0JCQllcnJvciA9IHhmc19pbml0X3pvbmUoJml6LCBydGcsIHdyaXRlX3BvaW50ZXIpOw0KPiAt
CQlpZiAoZXJyb3IpIHsNCj4gLQkJCXhmc19ydGdyb3VwX3JlbGUocnRnKTsNCj4gLQkJCWdvdG8g
b3V0X2ZyZWVfem9uZV9pbmZvOw0KPiAtCQl9DQo+IC0JfQ0KPiAtDQo+IC0JeGZzX3NldF9mcmVl
Y291bnRlcihtcCwgWENfRlJFRV9SVEFWQUlMQUJMRSwgaXouYXZhaWxhYmxlKTsNCj4gLQl4ZnNf
c2V0X2ZyZWVjb3VudGVyKG1wLCBYQ19GUkVFX1JURVhURU5UUywNCj4gLQkJCWl6LmF2YWlsYWJs
ZSArIGl6LnJlY2xhaW1hYmxlKTsNCj4gLQ0KPiAgCS8qDQo+ICAJICogVGhlIHVzZXIgbWF5IGNv
bmZpZ3VyZSBHQyB0byBmcmVlIHVwIGEgcGVyY2VudGFnZSBvZiB1bnVzZWQgYmxvY2tzLg0KPiAg
CSAqIEJ5IGRlZmF1bHQgdGhpcyBpcyAwLiBHQyB3aWxsIGFsd2F5cyB0cmlnZ2VyIGF0IHRoZSBt
aW5pbXVtIGxldmVsDQo+IEBAIC0xMzIyLDYgKzEzMzIsMTAgQEAgeGZzX21vdW50X3pvbmVzKA0K
PiAgCWVycm9yID0geGZzX3pvbmVfZ2NfbW91bnQobXApOw0KPiAgCWlmIChlcnJvcikNCj4gIAkJ
Z290byBvdXRfZnJlZV96b25lX2luZm87DQo+ICsNCj4gKwl4ZnNfaW5mbyhtcCwgIiV1IHpvbmVz
IG9mICV1IGJsb2NrcyAoJXUgbWF4IG9wZW4gem9uZXMpIiwNCj4gKwkJIG1wLT5tX3NiLnNiX3Jn
Y291bnQsIGl6LnpvbmVfY2FwYWNpdHksIG1wLT5tX21heF9vcGVuX3pvbmVzKTsNCj4gKwl0cmFj
ZV94ZnNfem9uZXNfbW91bnQobXApOw0KPiAgCXJldHVybiAwOw0KPiAgDQo+ICBvdXRfZnJlZV96
b25lX2luZm86DQoNCg0KTG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcg
PGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
