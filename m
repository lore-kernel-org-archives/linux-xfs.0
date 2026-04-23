Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB95F3770B
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 12:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776946679; cv=fail; b=Wee8yCG78B43XvcaEg5zJyvNMPtR8dlQhPgAOJzyCIiWPXKG3AfTEdFdMjvaxuXAm8Mi78Ksxzl4toViygy7wRuxbFyMvugb+KY7QyZ+JX6k0B8Uc/bfV3SbC2CASypos4whiVmoNBEjoWMds9fXUFQrcjK5XvllsMnNH9e+AIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776946679; c=relaxed/simple;
	bh=CkTCV4JfIhkaTwnegtzwvcg5RtBmzvY9S3pBqNjDiNM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WiIAZlmtR4V6v16IMN+J46YPFydOdTUBxbllfbSXRAnLeQ7j+D4zK/mC7duyO02AyUELW4bObny6YIu6uJ70y28dCXQnPRcHIvBOVSXkPJS7/cbgY/C+VhKo6sM4FKwm3vId1A2h4+Ynxj1Vwyu5oVmJvv3+IGiBp/hFsfoebmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q+gYDjcG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qJRbkDBr; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q+gYDjcG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qJRbkDBr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776946677; x=1808482677;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CkTCV4JfIhkaTwnegtzwvcg5RtBmzvY9S3pBqNjDiNM=;
  b=q+gYDjcG/jeC3LpSMbKT8UFRTcZDlAMyhhhK7MQHI8ssIw3a6uLkvWsg
   0gtwv10HYoMQft7YII7zg0PsLrDTkE1iQ5LmoOLVlPdyFE0x35C6k5w9h
   XygGecXpx6KPGahGZgCdFO61WQ6uL3bAPXkJeX2tCaGHG3h0Y/PdQ0Lhy
   fkyKyv1+8Q1NXVHxQfB4evV6cI6Ylo0z7F2q6eBtbXuqsphBZsgs7X4hq
   UeRkXimTAoK1jGNsBJJ0X4CQgQj4cp0AuOF6GbCS/2SkhPuZ335x5btBL
   2a+7OJOCBpLc/RDEsUU/8Nl1iWhkyZiaVR+U80Jyiyu68Gmqi0SUw8Pzc
   g==;
X-CSE-ConnectionGUID: R79apAU9Q4iMMA3X+gAwrQ==
X-CSE-MsgGUID: aup2tVXATdOQAQ5naGRtFA==
X-IronPort-AV: E=Sophos;i="6.23,194,1770566400"; 
   d="scan'208";a="144597954"
Received: from mail-northcentralusazon11012059.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2026 20:17:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAGwArLJaQ/3dcMAdwGIQsB+eWyYvu3j7nbbEgxT5fnB2hwak14gqVcDYGIQWeXODRT1QB+g2jZh+qHui3f7ilmGTTUl6ZmCqEtpX7I6n+mPOLb2BFjm1weaCt90WM+HMY3qW9rzmWz+tIGLNfa3zDyJckjCNhmXCcHhS5pJBtMOYlkwK1L427ylYphD+WECw+7VZeCMRCkJsTxOTEjVdm1w5CUTzEHdaFCKvxGCPrBw5huoiOmnA1j0p3eymPUGbDX9TzZzKq2YhLpVUKdlCofqBgO9R+YDl4kR+lbzWEtJgOvwuSiXrf9VXMTjloITPKo++maBBPsC7sZ9DNoVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkTCV4JfIhkaTwnegtzwvcg5RtBmzvY9S3pBqNjDiNM=;
 b=n9aHmBQGuaY9uN3OMVm+mYYwWoRfm9DxWd0vIPzNWY9A1TgegzmWDCSHAiXqhjCStndDlSPRKRYcsIVkWjnvQFbHAuA1fTL+DYnRi+o9gWrvI11sF02ReGFIdLqeiHG9TUt0hXmsJSrYEdX2/pyP6msMyM9jOkPLFxmrPTNnUecixGdfhpAgtLKUqMxJYDQ+hgTJUk/sKxw8RItyt94J4mHP+pKDiLwymmU3tDaEmzNvHOVMSSP7VvLMhPJdH6BeexYkuPFD424m1blwBWZYcPik70McwXiIAXIFtzUnYN7SJaMldVJ8oC8xzBQjpjOOm21q6/uG2DtCpH1FL7ywAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkTCV4JfIhkaTwnegtzwvcg5RtBmzvY9S3pBqNjDiNM=;
 b=qJRbkDBrhPxOg4HzIz8XntA7TWHscI16ll4q+eNG0mxda7Ja7UUNKjZJc6vMvf9+9KiEbuLBC6clhGMbBJkS2pVBNeEJcgCyi7XCIDr1/ollcIvS/GSRielR7oootT3s1YYDTIT05lsqOMR71UcH+HdrmCCaCg6KTvwKgrZJY54=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BL3PR04MB7915.namprd04.prod.outlook.com (2603:10b6:208:33a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Thu, 23 Apr
 2026 12:17:45 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 12:17:45 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Niklas Cassel <cassel@kernel.org>, Christoph Hellwig <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: expose the number of free zones in sysfs
Thread-Topic: [PATCH 1/2] xfs: expose the number of free zones in sysfs
Thread-Index: AQHc0Mynz7C39AOgpEyON+6cqwyAirXqmdkAgABKSACAATmdAIAAQ9AAgAAzOoA=
Date: Thu, 23 Apr 2026 12:17:45 +0000
Message-ID: <36f67bd8-8525-4668-a778-3200b268a4ed@wdc.com>
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260420135011.624587-5-cassel@kernel.org> <20260422060322.GC5391@lst.de>
 <aeii-qIyPawexQci@ryzen> <20260423051142.GA27929@lst.de>
 <aeni8LnZNjpF1VxC@ryzen>
In-Reply-To: <aeni8LnZNjpF1VxC@ryzen>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BL3PR04MB7915:EE_
x-ms-office365-filtering-correlation-id: cd3bbafe-cacc-435a-cb5f-08dea13253a8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 jk2hOqL13WxNgqFh9is4jzQ0itJvhtC8L5CfEXRQ2LgW0Zu5MHfXk9h4/ZRM1uehvTcHEV3yE8spzi0eVYjaAXQROzn3WzdTVDFKVJ6LLXCmcB5vrv71bv3OHUxDDA95Bsv8tpvsGjoQusYn4ptg0VX51+Tm+12T0JHPKuJlQGB755mz/RJCRuZgyadnTqn+gb+24g9x1983PR9yn0uxtCbn/EQySMhjuOtAC9+8qZ7beP4f6NxxMvPY8cNxCLqLvl4OGu1DxHmuiyYBI4SXSiV+E3ZdGhxwSRKYClTeeBRrN0u6meCbUM4mAsh2D+MHQtW/njbIzteGvk6lbZYwc4Bz2uzFmm//BNzwhN5RlO4kaLSQCSUN7mPJh/oeo2JCnQB4z30OuCUc/wf73NBrPXJKeaElfVS6NvW1e98CFa2J/7PWxygnuqooMRL03Pjj9QzyryWItBB3YpUt0cir68ddh8vLCbtExN9B7klSN21BatBGP9DPUSgaAQ5TnMIYv+j5dCewWuvzf0LMfloDYtI8MYBGA+KukEBSjPeuBGcwEb2zFGPXGV9MSFtsKHVZpHiFbZGhOQBbkpgfx46tfF/AQvDOfC/uXPWoGXCuenM+ebJtaBnwuOugL0oeZ9zG94hK8UykljtQgXTW8/G5XCLmAx/jOXY0nlWWdRin1yOA+a69KyJxErpKgLUbOwIwrjzXN9udLFDfBdS3ziq0qLyQj2vC4PrA6p3oNLWxqEWiF/rOmX/Pr2nDOvib69Hq
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWo1cXkyQ3lZUzZlTDQvaXl2M1lVeldycTVpdGVMUFVCb3NoR3p1WFpwdnlk?=
 =?utf-8?B?YVJ6R0E2RTNjNjY2U1Z1dmE4d3dvMEprMjhyNVBrMnovUGRLQ0tORVVmNW9u?=
 =?utf-8?B?WVM2dTF2VEJoZ3J4VlhtaGVIZ1FBS0RtOThnUk01V2hVU3Erd0tHNDZURXZQ?=
 =?utf-8?B?OGowTXVIUGlxNlJhN3E0WkFKeEtoa21hNnlLd3ZBckdBS2l5Q3hRUEVoRGRU?=
 =?utf-8?B?ckowTkIrQmE3NHRZdHUzdXlocUJqMm1LMUV6c21MWUM4cWZQUmd1NE0yZkVk?=
 =?utf-8?B?Q2VFNVRXckZ3MjFkbUIrdnhVaHNXdWlhVTJHaGpCYUZRaDRDQXB5Vk5wQno2?=
 =?utf-8?B?N3RlVmZXODhqcUZ4ZmZIZVlZYTVVNERYMVpxZHpKK1J1NmFzaDZQTnlweG9J?=
 =?utf-8?B?dWg5NTFESkN4Nmc1aUFycVZQbXBhRVY4THJNTEdmT2hkZG1ncDAwbHBEa1Fh?=
 =?utf-8?B?UFp3dGZxanhNR21lVDZUb1BLYXJqQzVVcHU2eS9XYmVmQmFTcnI0SndCZ0tM?=
 =?utf-8?B?Y25EdmRMcklzZFlrZTl2UWV4SUFEM25yeWdRUWoxUDhFM0hXaVFBUmcwS0dT?=
 =?utf-8?B?amJ3OWRDWDI1MTFvNTI5S3VZSm15VEQvd3ExZ1JnREV1eUNXS1pybVpvRVlR?=
 =?utf-8?B?ZHgyR2ZsMGZ4bVFza3gybkNpdmNmUExjeUNsRm1Sb2FsMVhoMG9WU3ZWYkly?=
 =?utf-8?B?VU5LWkN2NDc4bzdtbG1RUWZxSDFyUG1tTUtwNXZHRWZsZ3ZzQitHUCs1VW5v?=
 =?utf-8?B?UDZYS0dxaDBPQzlzRWhuaFhZdExvUXBYUmdjQmUveGdtZ0RmWi92elNTNzd1?=
 =?utf-8?B?ekFUMm8rN1dJaEJMSm5SSi9iZ2dyeUpHOWJuVm1ZdzNTMjhPWVA0QTh0OFRr?=
 =?utf-8?B?M2VhVFlPY092NlkwR3lhMHlGRGNIWXJjdjN6cXl2dnpzZTFxUkVSVW9JOVUw?=
 =?utf-8?B?UUlOZ3RqcksyS09zNWJrYWMzSzRkeEhRRXo5M2hNNDQyN1o0a1p4cjJtMHky?=
 =?utf-8?B?QXlFZkg1d1JRZDBiTWllYmZKbFhNNEUvcFJHT25kVlpaY2tLdEFXVEY1TWtv?=
 =?utf-8?B?UHJoTi9RajJBa0hPaDROdElza094cDB4RWdYZXRCUGpMdm03UHlLN0Yzb1FG?=
 =?utf-8?B?SHp1U3ZuQXhaMjBJOVFXcmR3eU9LZnNKeXpkL2xCUmJKNFo0Qm9lamV0T3lF?=
 =?utf-8?B?MXBNQUNCTHV2QWIyOWJqNGVIeFNickFKZXhLYmp5YTZyZnJNOGwrZWtZQjR2?=
 =?utf-8?B?a2J3WVBXakRFRlJJdFpRQXJRaHhvM3BzTVVGTTdhbWRrOFhTYld6eHNGcDEz?=
 =?utf-8?B?cWYralhWRVpKL3NFZlNiSCtPVE80eUI1Q3pnN1JOaEZkTk1qT1M2cVk1TzhB?=
 =?utf-8?B?a0RNOE9Vb0RsMXlLVllsVituQmtsaWZQbE9qTXdFVmxpRFoxc3dLTkZOM0Yw?=
 =?utf-8?B?VUNiMWpvZTNsbXp5YkFnSGRrNUlaVWZadGVBQTViN3R1WFR3akV0eFBtazYy?=
 =?utf-8?B?ZllhMEx0RmM5NzdYOVJtK2ZxakdSOU5jRFI0YnlHSWNqM21BNnNCbHVNZFRH?=
 =?utf-8?B?SXQ5ZHBtdmRJdUkydE1adkk3cVArdlJJVTRCcEZLL0tDWXpIM0VTcnM5MXM4?=
 =?utf-8?B?bzVRd2g0bmU4bGlBY1dWaWlMelJ6TWZ2bEVGbU1LMkJkei90TU02Si9mV3hT?=
 =?utf-8?B?MnNhbmZha1Q1MERSZnJnSVRwZ002M2xyMWpkQ2Jva3FyM2VpNGZPdjEwa3JK?=
 =?utf-8?B?SHBzZjNxWTdOamVqaUhZeTRQTzhrZndRVTMrRTZDS1QvRWpDR01UMHUvWTda?=
 =?utf-8?B?Y0FFNTlYRXZ0eE10NVRpZkkvSVNVUXJmSS82NklVc3RPb2ROQVBKSDgxN215?=
 =?utf-8?B?RWVnWFFRVFVOYXEyWkxUQ2dWc2xyak9TWnN1UVNxVDh4WkI3Vm02eXBjWmNL?=
 =?utf-8?B?RkpES1lTb3hWalo2RDgydzhPZzlZUUEzMEwyVzZwTDhEL0NwdWFLMHBtYTA4?=
 =?utf-8?B?SjdMd0lzOWgvNXF4cVRKL0EvcUUwaFRTckMvN3NjanB1K3FvU1JQN1VDQzYr?=
 =?utf-8?B?RjArQkd3dDMzMlQxYVc4c1VtNnY0bzFSQ2t6YVdtZFBVaE4zeDVqbHhkWGNL?=
 =?utf-8?B?ZG5Xa2tvTnREVkU1cFdPRmNWVjNKdnVXQ1Y4VVMvM3lMMEpxYXZ3YXF1RlJl?=
 =?utf-8?B?ekdVWGsvSWpkOHNJZ0tUKzBkbk5GMlcvSFBjUjBLNDFMNENnZGkyYW5CZmhu?=
 =?utf-8?B?cEtrS05ZUEo1cFkvQWVTSVYzUlpsNzBUclliMGZraS9sVmVIcFQ2VkFoNnRC?=
 =?utf-8?B?V1dTUWF1TzdFSjNpOGN5M2NqVmFMVjlxenZvSkk4MllWMWZ1RVkvUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6182BE1C2CF4A4E9CE6DB705EEDAA41@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mdyIkYsKunH9pxKzoljfNULbWTygHAYWaAnFya9USKtr7qIFYriLNOcwYVyIidtpiXjTk0JDHSeKNq0yzMGDLN8vHhCOiOW7to40ATM7EAqJT7bZ2TeRqT3ZxPmeXZCRshYs+yzW0U/66YvOfR4sNuVHM8G3OWliJwlF/G2WySD2Ihwj/d9qYPtyRWRT86qVKJ49ekySWG4YP009TdDAehLlTPy8Ll4wL5Ku7EcOA9qITZa74UqFdR5Kx8Su14ciKYGgqLQe8vHoa8kXnYWPNenReXnr01xDiBiKUelJnT2cqb56D7I8Qy9aPJYA75PkRs+VhnNS+wOkQLpp0i012g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pxRWmC1umODdJZNBADOp67mL+g7N2nTHmE16J2oCF40264oSwPdKW0lP15iCSHtuDM1tSayZu02faM4bXVP9BXrMv7eexADo+AyqGObDocy1N4vmeRQoD5hxWpXjn0+QPzxWJ7HA0ZYamEHWlb3rKZ7mpGB8s//jD65RtCdaQ0W0rBYVnDTdetQl2EXlDeAxov45qY98nQ5QtWWqWmsEGBGX5U8Fox/1UDIr+x+WMNoXLkTJiqB6iIOTNc8vB5Iv9R5Nw8acHUjhbQun/BCYIMLhAZcvJo9nj5S/o1kuehYaKT6BvzkaQZDe6TX3Aj3AzbhiwiYx4kwUdp8ukQ8zW21EOFubFpwVHw6ZUMGC3A4n9XvYcHugkPLK/c+zMLEeweIJ4z4cO9lkfeUswk9jxKZwDMGsQEu7GEdQGL6D4Zu09OoFtWpVqworJtUDLy86KBnvooBImEs4E+nkgDoqGbo+vHL1mtZVw3TViGSQVHci+ZNAT34dhuqlmG+g1DinsdjGPZBv/EZ2eMfzDcCsTmzj5QahRK4zJcjqGSl4kncNlH+qePQBaqEkQZdVFO4T2+ZGNvIuFaSnudtolE3/VseiJGzdcFN/wHTRNbat1VYjsZ3hibQj77zUgCnQnMcG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd3bbafe-cacc-435a-cb5f-08dea13253a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2026 12:17:45.6682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paVAz1Th9Jt4UGUsnxpEqXPpQ/UMgXKe4iBttuwATA2gNrZWqW9rcums7iWPTAhG1QUTkn0BWpanV6b1h6zJzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB7915

T24gMjMvMDQvMjAyNiAxMToxNCwgTmlrbGFzIENhc3NlbCB3cm90ZToNCj4gT24gVGh1LCBBcHIg
MjMsIDIwMjYgYXQgMDc6MTE6NDJBTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+
PiBPbiBXZWQsIEFwciAyMiwgMjAyNiBhdCAxMjoyOToxNFBNICswMjAwLCBOaWtsYXMgQ2Fzc2Vs
IHdyb3RlOg0KPj4+IFlvdSBzYXkgdGhhdCB0aGUgdXN1YWwgd2F5IHRvIGV4cG9zZSBzdGF0cyBp
cyB0aHJvdWdoIDIpDQo+Pj4gYnV0IGUuZy4gbnJfb3Blbl96b25lcyBpcyBleHBvc2VkIHZpYSAx
KSwgaW50cm9kdWNlZCBpbiBjb21taXQNCj4+PiA2MmM4OTk4OGRjMTkgKCJ4ZnM6IGV4cG9zZSB0
aGUgbnVtYmVyIG9mIG9wZW4gem9uZXMgaW4gc3lzZnMiKQ0KPj4+IChZb3UgYXJlIHRoZSBhdXRo
b3Igb2YgdGhhdCBjb21taXQgYnR3IDopKQ0KPj4NCj4+IG5yX29wZW5fem9uZXMgaXMgaW1wb3J0
YW50IGZvciBhcHBsaWNhdGlvbnMgYXMgaXQgdGVsbHMgdGhlbSBob3cgbWFueQ0KPj4gZGlmZmVy
ZW50IHBsYWNlbWVudCBwb2ludHMgd2UgY2FuIGhhdmUuICBucl9mcmVlIGlzIHJlYWxseSBqdXN0
DQo+PiBhbiBpbXBsZW1lbnRhdGlvbiBkZXRhaWwuDQo+IA0KPiBUaGUgY29tbWl0IG1lc3NhZ2Ug
Zm9yIDYyYzg5OTg4ZGMxOSAoInhmczogZXhwb3NlIHRoZSBudW1iZXIgb2Ygb3BlbiB6b25lcw0K
PiBpbiBzeXNmcyIpIG1vdGl2YXRlZCB0aGUgY2hhbmdlIGJ5IHNheWluZyB0aGF0IG5yX29wZW5f
em9uZXMgY291bGQgYmUgdXNlZA0KPiBpbiBtb25pdG9yaW5nIG9yIHRlc3Rpbmcgc29mdHdhcmUu
DQo+IA0KPiBXaGljaCBzZWVtZWQgbGlrZSB0aGUgc2FtZSByZWFzb24vcHVycG9zZSB3aHkgSSB3
YW50ZWQgdG8gYWRkIG5yX2ZyZWVfem9uZXMuDQo+IA0KPiBZb3VyIGNvbW1pdCBtZXNzYWdlIGRp
ZCBub3QgbWVudGlvbiB0aGF0IHVzZXIgc3BhY2Ugc29mdHdhcmUgY291bGQgYWxzbyB1c2UNCj4g
bnJfb3Blbl96b25lcyB0byBjYWxjdWxhdGUgdGhlIG51bWJlciBvZiBkaWZmZXJlbnQgcGxhY2Vt
ZW50IHBvaW50cy4NCj4gDQo+IEFueXdheSwgSSBjYW4gY29udGludWUgd2l0aCB0aGUgY3VycmVu
dCAoc29tZXdoYXQgZnJhZ2lsZSkgd2F5IG9mIHBhcnNpbmcNCj4gL3Byb2MvPHBpZD4vbW91bnRz
dGF0cy4gSXQgaXMganVzdCBhIGJpdCB1bmZvcnR1bmF0ZSB0aGF0IHlvdSBjYW4ndCBnZXQgaXQN
Cj4gZm9yIGEgc3BlY2lmaWMgbW91bnRwb2ludCBvbmx5Lg0KDQpGeWkuIEknbSBhZGRpbmcgc29t
ZSBoZWxwZXJzIGZvciBnZXR0aW5nIHNwZWNpZmljIHhmcyBtb3VudHN0YXRzIGluIGZzdGVzdHM6
DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2ZzdGVzdHMvMjAyNjAzMjcxMjM0MjkuMzkzMzAt
My1oYW5zLmhvbG1iZXJnQHdkYy5jb20vDQoNCg0KPiANCj4gVGhlICJtb3VudHN0YXRzIiBjb21t
YW5kOg0KPiBodHRwczovL21hbjcub3JnL2xpbnV4L21hbi1wYWdlcy9tYW44L21vdW50c3RhdHMu
OC5odG1sDQo+IHNlZW1zIHRvIGJlIGFibGUgdG8gZGlzcGxheSB0aGUgbW91bnRzdGF0cyBmb3Ig
YSBzcGVjaWZpYyBtb3VudHBvaW50IG9ubHksDQo+IGJ1dCBpdCBzZWVtcyB0byBiZSBmb3IgTkZT
IG9ubHkuDQo+IA0KPiBDYXJsb3MsDQo+IHBsZWFzZSBkaXNyZWdhcmQgdGhpcyBzZXJpZXMuDQo+
IA0KPiANCj4gS2luZCByZWdhcmRzLA0KPiBOaWtsYXMNCj4gDQoNCg==
