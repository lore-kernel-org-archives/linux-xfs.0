Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C6B269CEC;
	Mon, 28 Apr 2025 12:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745843329; cv=fail; b=oIP3Zc8cQTbOaeP0L62XY13zpdVtUypeDcDKawQi/FxSteRHveTzgfXtCJ0dyNNqp4S/LudKB2MLgPbk7uHxQQ57Xn9Fs2la9zYtZDbFxhlAHRynswajBiiziet/5Q9v/4GoXaHzLYeR8bWsrVg3VV4xQiWLCOJrnJ5vM9sZtqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745843329; c=relaxed/simple;
	bh=/m9qQhwOrxPlY7kIReuyiD2M6vbxCmDvchaNEuvK8xY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h3fZKine3GsFm4DhmFWC8nE8cjiZw3E0di34CIrbS8h9fG0Fzc1nT2EeQXUd21TPpw2PCfusYYDLk0OigrFyG8bs+SOEd/yoQNB7xqN9/Xb71U4OnBjakpebWYFWnbqfjV3ab5PYSl8xiZNku6vrtdF+u+YiAV+BkTF2e2U25wY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=flK0m2wk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JvPx5esq; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="flK0m2wk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JvPx5esq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745843327; x=1777379327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/m9qQhwOrxPlY7kIReuyiD2M6vbxCmDvchaNEuvK8xY=;
  b=flK0m2wk5cRu2KDOUd/sPEvZUW7J6pdku+GEsFMxxSTCZq2XVLnN2pLm
   hv0nn+2MI8GDgEU6LwyZ+w8FbQ4y/NoK1OdlNyx8GeQ6/VTJAo4NuuZQZ
   f1aP4aaLbdmUMTwbcLxLcGDfwa5FPcF4yRArzzlcWakVm9nV6//xkWrmQ
   9Z/+EuT3TTtjTlu/7fjesTjIGaqaXsT/pNcUU5lzg4P4YkNgzvjWy2GaZ
   kXV0UqxK8iw4M5fBPqXh4UH17QCnnWc3NTwFI18JdYlUB9AQjaJ60OSjT
   ZSmHRFibVS55WaCQH5Ar0FV6nfQZxBJcvKjuSVPsPZ1SuVQge9Vqn/zLx
   A==;
X-CSE-ConnectionGUID: 5JI0Nc9GTiWLQx6ALt+dNw==
X-CSE-MsgGUID: dgdodd8HSWKDKotl5aPAXA==
X-IronPort-AV: E=Sophos;i="6.15,246,1739808000"; 
   d="scan'208";a="83567975"
Received: from mail-mw2nam10lp2045.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.45])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2025 20:27:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lcPcg8WsdeCcWqiBK/qj3fTmp9LTHiCzz8l5m2dQFT0dm5ezYBwyyaAENzJPqYqWxN4VNBbH2B/089EZzGLpLkbvblNFhNPGoqrGYeiafB/GOxyBPLr5S+R9cDHhjpRfXm9T8Xy/0a7oBxIEcZYNYa4hjPPEPIrFfE6Xk8F9DYvjefA5LByWrC+KPkoi3882YK9iMWsSuUJMkefQi0ix4RqMAsLH+WV6S6ssUsDSBtihLaUcxq6uR62WkgDPVqOKJm7iFR2BeNgqKZPxJjWIGORkrCs5kThlb4Dwa2WCcpujMUc9BwfPKw9idHk0oiUBldIY0Lc1IdWCU9/CBFyjsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/m9qQhwOrxPlY7kIReuyiD2M6vbxCmDvchaNEuvK8xY=;
 b=yaUTz5WKlTiMhjhXBSCUARTLlBohGmuQGzlT3gGLtHApESPaUsOhqLRTqQp8GMdNpS+NmsFRTZxFqnjMS2oPc1ftGU+tI5QBnyNSR1x8wG3udgaoollvl8+LmFc1RXRdrxIrR07Umwe0YRBdnlXJPYeNymfHpPvs9ruzjC0JNUl96MDwNgy6ImImBmuEd+05mvWyx6dLYkhLHCcPMY7AxsYsYEEHAe0zbQmVLqpy46dKIsRV/4DIofISeXDdTYVcB9ZMMn6jk5n6YrCs+u3P9t4gi8s9j5cB/WsVRiRoQnsI3W8lw3q2vNZZ18PrPKc6XVqBRNfr8uqSSU2W9jNnDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/m9qQhwOrxPlY7kIReuyiD2M6vbxCmDvchaNEuvK8xY=;
 b=JvPx5esqVjggj5/OcKFkJIsZwpM2fRytKR0kbUHyyt44BGaz6glKqpWh02wUf9KxY5MRPTQmpBfrsDgsJWpz8WMDiMi7DBYpJdSO0OKXaIIbM/rWLKbWnaUsmX1liaUg6hmiYq1fnjl3wuic4K9QEQM9kicqcsdVIDq7oLHNfvU=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY1PR04MB8752.namprd04.prod.outlook.com (2603:10b6:a03:535::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Mon, 28 Apr
 2025 12:27:37 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 12:27:37 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>, hch
	<hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Topic: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Index: AQHbtb9ugJyGk1wFU0SBquvCoobacLO0eGEAgASN+AA=
Date: Mon, 28 Apr 2025 12:27:37 +0000
Message-ID: <68fe75c0-852b-4e81-ab39-1c10a3af506b@wdc.com>
References: <20250425085217.9189-1-hans.holmberg@wdc.com>
 <20250425145426.GL25675@frogsfrogsfrogs>
In-Reply-To: <20250425145426.GL25675@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY1PR04MB8752:EE_
x-ms-office365-filtering-correlation-id: fcdfeea7-429a-46ec-8ff4-08dd86500f87
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NFBLK25ZazQ2MGx1N3dDVzlLVUNVVlZhM2tkN0FyQkVJTU00UzBRT0FDWGlJ?=
 =?utf-8?B?MVlaZ1FDNFVLc2NsQWVxNlQrSlAzdW5IeGRBMkZ5V0VXRzM0cW95NUQ3MzFP?=
 =?utf-8?B?KzkyOTFHUExQWUpYQjBUUzFocmQzL1lxcFIxZVNkTDhzRkdsdW1mbDFaY0sw?=
 =?utf-8?B?K080ZWFnK3JubktlcHR0MSs3dXJIQ2ZJOXJvUFZOWUxIV0R4TUt4SVVTRlNu?=
 =?utf-8?B?WDdVd3ZkT2R1aFcydVJTdU5MMFovV25YaStxV2E4SjdvcnowRlhtR281aGlz?=
 =?utf-8?B?c0xGZDN1bEhqSzZCa0k3VlAxT1ZWbmd6RWFpS1NxWFdNeGdDa2ZXS0dZRXJn?=
 =?utf-8?B?ZDlIZEtFbmhFLzRHaW5qY0ZoUEZJMGcvdFE0ckFtcGJ3TTVwb21vMXdYMVEr?=
 =?utf-8?B?aUhrNno1a1RDMVNSS29HTG11N0RvQUtoZ0hKOEpIRlBwWTFUWXRWM3lVbGJD?=
 =?utf-8?B?b1RDV3JFYUtRNGN5ajRIWFkwdTVWTkIyZGdNQkYwbmgwSFBPcG5QRGFJZ1Rj?=
 =?utf-8?B?ZlZJcXd6dHNwdUlGazZRcFJFUVNIZ0xITlRRMDFhTmlqY3JodVpOYUs3bnd0?=
 =?utf-8?B?bXA2OWFhZHQzc0Nxd1l5S1ZmWlI0RHJJbGN3dEo1bk5xUjJKVUN2REEwNjh5?=
 =?utf-8?B?MEt4Rld0MmtueDZka3cwcVp0VEd0cFpJbktSYnpUcWxBbWpWQzArUllUZEc3?=
 =?utf-8?B?UTM3V0g0Q0ZSODZaZlFWYTdFK0ZvWnJHdkNZWXdhMHZZNDVicHZTbkJrTmk5?=
 =?utf-8?B?T2dady83TG9SWHBaVVVRano1NHV0SmhGWkpzR0RNVEIxZ1REeXdVOHBWZ1BZ?=
 =?utf-8?B?MDNTaCtrcHk5RzNreks3WEpGVmVDL1E2UE50bnJTYTFwNWhBTS92TkgyU2JZ?=
 =?utf-8?B?Qy9sOHRCdTlaWnIxU2hzZU1wNXVDVHlDSHVsOHdMTTcveDlWUGdpeTNJM29C?=
 =?utf-8?B?ZFBGUUhESjljSS8zVXJzZ3hWcGdLUkVVWmVDdWh5R215OFdVMk9CTXlLWU53?=
 =?utf-8?B?T2RmODBiTFBIN3hpamZYVWJhVkNlUHFPQWpCd0ZtMzhPbktrZGNSWDF0aTA1?=
 =?utf-8?B?ekhJQnBtRk1PMjhsQmpPbW9reFd1bnZYWElwbjFraUNQM0ZOOUJDbGJySVp2?=
 =?utf-8?B?TkZLMzZOYjdYUC9UTGZRcGp1U0tnZWZvZ2tBcVFoSFlXS3dUTzVJMXlTaEdw?=
 =?utf-8?B?WTJ5elRXenZlc1NRRHN6WmtFc0F5dW1tVHhFVkVSU01KMUVzcVJFaXQzWVM1?=
 =?utf-8?B?Umh0Mnp6UTdxYUQ2Z3lDOC9vV2U1NWhEdXNwSFQyYmpDc0xzNERqNVF0VGxB?=
 =?utf-8?B?U2NOTndESUtsejczTERDK0VRYkdkZ0xKY3BlcGV3V25PVE9MNEdzUHV6c0dS?=
 =?utf-8?B?TWkyMElaQUc0U0VhZCs2VFZqY3dLMHhGMGFnM2hqUnUzQzB3cHplY1NkSGl4?=
 =?utf-8?B?SVlzNHZEQlBWM2tBKy9yQ00ra2hLQTN5UzFsRDZvcXdxeEpHcnpES1pzMUxP?=
 =?utf-8?B?SFk3UWUyYmlwbFlOQUtTL1NuMTNuRm9GWnNqekxZNlNjTWR5bE5ZVWZKdmpv?=
 =?utf-8?B?YVVnOFJmb0N6T0JZSkxmeEtsaUtqT01aNEhrRllLV2dzM25pODFhNzlpQmNj?=
 =?utf-8?B?YUdIZzA2dUhqYTd4ZnNDd1RvaGFUUmtHYWp3MElEOFlObW5teU9zRHc0V0RR?=
 =?utf-8?B?S0pQWG82WllZcVJqVWFCYWZWYk1ZVTg1TzV3bHVQenV1S21TRUNVSzAyUEFP?=
 =?utf-8?B?TkcvUHRCOGQ1MHRkMk9GMjNWMEdScERJdWE5YjJXQkpNTzF6eVk5bXV6cytR?=
 =?utf-8?B?ZXJiOXVjanIzNW1tTTIxdlFzK3VsL1NmZVFYSmxhYnhMTk5BY3hEUGZsQXJZ?=
 =?utf-8?B?dHhLNG0zSy9ITE9Ca0QxOEJQZXFtNU1SMm5qM0tCUVRuYWhEMUFacGJvVUxa?=
 =?utf-8?B?d3luOWR5OFFBYjh0YkkvU203RklmVkVIR3JlRTBVcll6bWY3ZFBmZ2tSQVpl?=
 =?utf-8?B?Tmx1K1l6ejJBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z2JCejNrSlFrc09ZU2lKR0VqT0tEZ3QyV093MWxZY2VxVVdxeG84Nzd2bmdC?=
 =?utf-8?B?TnNiYTVMM0xObGxBWGNSS2ovWDR5a09Cc3VFb3hqRGNhVmFEajh3TTVtMGFk?=
 =?utf-8?B?ZEpqN2ZGTFdPdjliNzkzVmMzS0RGaFlCeHY1VWx5SzN3Ykl6MHFVTjhteEl5?=
 =?utf-8?B?R1Exb0ZmMUVGczRnT0RDRmt1OGo5K3pGcXp2MjZ4YmwxOXdxWUJIWmZSdU5W?=
 =?utf-8?B?QjBGUEtFY0Q1bCt2ZEtuS1VmdlpwdTVqSys1MEdPazJVUWFJMU5RU3JMaXFP?=
 =?utf-8?B?NEpVNTgra3B0b20ybE5jbWRFbTFGUFNmQjEzWW56RU1xWEMydEFhL1lmc0Z5?=
 =?utf-8?B?YWZaMjQyY29SNFVmN2kxUnIyaW5lRVdGalhSUXlubHBSaGZrR21qM3lSM1R4?=
 =?utf-8?B?cjFtTWpmYmJRRHJDTDVHZE4yUDR4UkhDeFZhcTc4TXNRT0ZQbXViUjBHM1Zx?=
 =?utf-8?B?YkdremVDaTlrT1JYMGpBNFk1RytFSDFndkF4SlA0aEJsby9nRE01SWk3U1pm?=
 =?utf-8?B?dG12blkxRUVDZytKU3dpdyt4LzZPcVBnVjBRMHd4MXNVQ2R6YmpDcVFveXF3?=
 =?utf-8?B?VVNsOWNkUkpUUGxkbDJFUWE3N0FUVXo1T3BEak9pZmFQVHB0bE1nRW1pMXpH?=
 =?utf-8?B?SWhybUZ5THlLUWZrQm9KN3FUWkM0cXNFbVk3VnB0TlBMT3V5OVNmbkE5OFBH?=
 =?utf-8?B?cElyM1V5M3Bzb0pzSS9YZmE5M2ZjNEEyV1VzeUUyemdKYnFPbkxCTGhUeGN0?=
 =?utf-8?B?SmwrSzRSdUJXQnp3TFpBTXR0OStvcFQ1RXZXSzhEZTRVWjZ2VWlna3NJWDRu?=
 =?utf-8?B?ejhrSFIyY2Z5ZjBJWHhrOFQySVpJRENLbnFUWmM0dGs4Qk5FYm8wU2tiZTJ2?=
 =?utf-8?B?ekZqUlZ4NkJ0OERYOXY3dXFobElvakhhTFZSUmZVRFQxLzlOc1hmMVN3T3Rz?=
 =?utf-8?B?dC96cnFERFV6MjFrMS82TzIrM2NsMnFBUFl2THBsd2VsUUtnUExoWk9IaUxV?=
 =?utf-8?B?KzRHTmd5N0NqQW5zNi9waUlWU29CTStvUURjZ1A3MUozN0dvdmpvRkIrbVI1?=
 =?utf-8?B?NkwwSW9vQXhUQmVaamFOOFRibEpMM3c2WC81S3V2YnZ1V3B4MnVhcDdlN0xO?=
 =?utf-8?B?dGFGZXBZUFkxbkN4NFpIQUZSWFA0S3FZN3hQa3NzS20vdWRONjNWMnVucW5E?=
 =?utf-8?B?VTdCZ2NBbUNUWk5IOVpZN0Q3cjZDZVlZNEF0ZG4yRlZja2NJSDk4dG1WRFln?=
 =?utf-8?B?N2xMSnFJclBDM01xUXYvcWlQaGZ0dUZhNmNFYXVralBncFZxK1pZR2pPZUx0?=
 =?utf-8?B?RDdYV3c4U0ZlbXpWdm56UndQS3I4NWs2ZkFMSS91cGpsRjZoVW5CekNpbldW?=
 =?utf-8?B?bEM4RkQ4K3l0UmxaeFVveWxiQlVNYmtSd2crSGovaUJzckdqSWlFOUpqT0lV?=
 =?utf-8?B?OHFpT0Z2TjR0c0Fxakt6TkJWRm5XekhLcGdDM0F1b2cxUGo0ZU00RXdHSDlG?=
 =?utf-8?B?Smppd3ZZV2kxTEhLMXQ2ODNlaXd3MDAvencxN21YV25ER3EyK25RNnh3TjVs?=
 =?utf-8?B?TXh3WE1xMGZOK1VrNzE3TjhranZjakw0OGVRdDdaS1NRTlBVaDlnby9COUgv?=
 =?utf-8?B?QU55SHlmZGZoK3pPdVYzNHY3OUhHQm4vZW1Ma2Ixd1pxTmluc0VzOU9jZEdH?=
 =?utf-8?B?dDNzRVNzaVp2cjRRQWlpL1U2N1JyTzRKZnVkY1RGVDRFRForTUMza0EyaUJC?=
 =?utf-8?B?UXROZGF0ZUV4ZHJCaE9kdzJlbmlhT0RkcDJxYlhZMS9WTFBUTkNDdis3M2pM?=
 =?utf-8?B?QzBYR09UZzVrMHArUXZibUtDc2RHczN5cG9aRGsxVzA5dW5MWEtPSm05Yllv?=
 =?utf-8?B?NlpHVUY5Z2RLb3R2YlFqUUdWeXZ3S1EzS2cxcjgwOW0xQ1puekZ0TUxwdnV4?=
 =?utf-8?B?YVBTOWdrYzBZbjdpR1o5R3BvNXhIUTZaSzY1M2tPZFE2OURPM0ZoVnBZM3k4?=
 =?utf-8?B?TkNhVSt2Mkp2VWpwMU5xTG50UWtGUHU2R1BrYjFmWXdxbWZYd1ZHV2FYRFVH?=
 =?utf-8?B?MXZRMFBjYmNWT3RJcnJBY2RCb1RmTVQ2TVhYdTZUV3dMbTYxa0hIYWZJVFNQ?=
 =?utf-8?B?RFVETHFLbC8yeTYzU0JvdEl0dGRWWmZYTnp4MmVKQ01vQ2NpRmFkb2s3c01F?=
 =?utf-8?B?bUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0C3749BEA056C40854815D4EE2A51A6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rbt4LbrHXcdwlQ3PbNNVXKyxx+3DLXLCQz737uEjD/qr6dINAD/K6OscDRcHN2S8GVCksnNBdaVw85BV1kgCz8vUuxGV2htOdbKcwaA4QoI0hSNhT0lhS+pNYEjzBB/5vNUCEKiYY4bp01mTpTXz0BoheUsAWMMhwrh7hC+pBsU4ZbKHP+XkCftIueq8sleeJ5Y/p+VE2w8+WCBzJ+KRcp/R0+xEbeqIZIQHxxVUSd+Nlpchb82UHQ30jXraZnLU5SKU95N2Gd76t7BhlMlyhSaKGBmEr37vcju3RlyhLn1eKpw+9IGj66ExoBWlcq4YJfkdY3un40Vi3oFaBqBDfg62SyNGh88aAXcAWShBIA00BmWBUE5FtL3zfFuvvaRKxSSXf2fa1OveKCFZNIn3ZQaMQFrwLp5JQRqOA8tULM2A2lSGIXSAANMentjcLMbxsmtlEPLoqDsmel1OfwR9YPfIVGykLr6VFlQqVaklgDw4HHfS2KvUliiRiW437joxSLxyKGaJOs2Qw7mIjleHbfz5PtKmzMQrT8HuGHK4n5j7wDdo5wIynS7zLEkOqJ2nx/8dvg1/Nkfth6I7qCAfSrbK3Bv6K9BdyTFf88vypoWSuWpaKPsdzlV0GO0jdHZt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcdfeea7-429a-46ec-8ff4-08dd86500f87
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2025 12:27:37.2224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F6F/Lwze5aW3o9pQEUKIzOctAsH/bRECJL1hgwKjlGU2umHRz57HH5cVy0mYBnF0qmphG7o9lZn1VJXGH/WFXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB8752

T24gMjUvMDQvMjAyNSAxNjo1NCwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBGcmksIEFw
ciAyNSwgMjAyNSBhdCAwODo1Mjo1M0FNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
QWxsb3cgcmVhZC1vbmx5IG1vdW50cyBvbiBydGRldnMgYW5kIGxvZ2RldnMgdGhhdCBhcmUgbWFy
a2VkIGFzDQo+PiByZWFkLW9ubHkgYW5kIG1ha2Ugc3VyZSB0aG9zZSBtb3VudHMgY2FuJ3QgYmUg
cmVtb3VudGVkIHJlYWQtd3JpdGUuDQo+IA0KPiBJZiB0aGUgbG9nIGRldmljZSBpcyByZWFkb25s
eSwgZG9lcyB0aGF0IG1lYW4gdGhlIGZpbGVzeXN0ZW0gZ2V0cw0KPiBtb3VudGVkIG5vcmVjb3Zl
cnkgdG9vPyAgWW91ciB0ZXN0IG1pZ2h0IHdhbnQgdG8gY2hlY2sgdGhhdCBhIGRpcnR5IGxvZw0K
PiBpcyBub3QgcmVjb3ZlcmVkIGV2ZW4gaWYgdGhlIGZpbGVzeXN0ZW0gbW91bnRzLg0KPiANCg0K
UmVhZCBvbmx5LW1vdW50cyBkbyBub3QgbWVhbiB0aGF0IG5vcmVjb3ZlcnkgaXMgc2V0LCBidXQg
eGZzIHdpbGwgZmFpbA0KdG8gbW91bnQgaWYgcmVjb3ZlcnkgaXMgbmVlZGVkIGFuZCB0aGUgbG9n
ZGV2L3J0ZGV2Ly4uIGlzIHJlYWQtb25seS4NClRvIG1vdW50IGluIHRoaXMgc3RhdGUsIHRoZSB1
c2VyIG5lZWRzIHRvIHBhc3MgaW4gbm9yZWNvdmVyeS4NCg0KDQoNCj4gLS1EDQo+IA0KPj4gU2ln
bmVkLW9mZi1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KPj4gLS0t
DQo+Pg0KPj4gSSB3aWxsIHBvc3QgYSBjb3VwbGUgb2YgeGZzdGVzdHMgdG8gYWRkIGNvdmVyYWdl
IGZvciB0aGVzZSBjYXNlcy4NCj4+DQo+PiAgZnMveGZzL3hmc19zdXBlci5jIHwgMjQgKysrKysr
KysrKysrKysrKysrKysrLS0tDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfc3VwZXIuYyBi
L2ZzL3hmcy94ZnNfc3VwZXIuYw0KPj4gaW5kZXggYjJkZDBjMGJmNTA5Li5kN2FjMTY1NGJjODAg
MTAwNjQ0DQo+PiAtLS0gYS9mcy94ZnMveGZzX3N1cGVyLmMNCj4+ICsrKyBiL2ZzL3hmcy94ZnNf
c3VwZXIuYw0KPj4gQEAgLTM4MCwxMCArMzgwLDE0IEBAIHhmc19ibGtkZXZfZ2V0KA0KPj4gIAlz
dHJ1Y3QgZmlsZQkJKipiZGV2X2ZpbGVwKQ0KPj4gIHsNCj4+ICAJaW50CQkJZXJyb3IgPSAwOw0K
Pj4gKwlibGtfbW9kZV90CQltb2RlOw0KPj4gIA0KPj4gLQkqYmRldl9maWxlcCA9IGJkZXZfZmls
ZV9vcGVuX2J5X3BhdGgobmFtZSwNCj4+IC0JCUJMS19PUEVOX1JFQUQgfCBCTEtfT1BFTl9XUklU
RSB8IEJMS19PUEVOX1JFU1RSSUNUX1dSSVRFUywNCj4+IC0JCW1wLT5tX3N1cGVyLCAmZnNfaG9s
ZGVyX29wcyk7DQo+PiArCW1vZGUgPSBCTEtfT1BFTl9SRUFEIHwgQkxLX09QRU5fUkVTVFJJQ1Rf
V1JJVEVTOw0KPj4gKwlpZiAoIXhmc19pc19yZWFkb25seShtcCkpDQo+PiArCQltb2RlIHw9IEJM
S19PUEVOX1dSSVRFOw0KPj4gKw0KPj4gKwkqYmRldl9maWxlcCA9IGJkZXZfZmlsZV9vcGVuX2J5
X3BhdGgobmFtZSwgbW9kZSwNCj4+ICsJCQltcC0+bV9zdXBlciwgJmZzX2hvbGRlcl9vcHMpOw0K
Pj4gIAlpZiAoSVNfRVJSKCpiZGV2X2ZpbGVwKSkgew0KPj4gIAkJZXJyb3IgPSBQVFJfRVJSKCpi
ZGV2X2ZpbGVwKTsNCj4+ICAJCSpiZGV2X2ZpbGVwID0gTlVMTDsNCj4+IEBAIC0xOTY5LDYgKzE5
NzMsMjAgQEAgeGZzX3JlbW91bnRfcncoDQo+PiAgCXN0cnVjdCB4ZnNfc2IJCSpzYnAgPSAmbXAt
Pm1fc2I7DQo+PiAgCWludCBlcnJvcjsNCj4+ICANCj4+ICsJaWYgKG1wLT5tX2xvZ2Rldl90YXJn
cCAmJiBtcC0+bV9sb2dkZXZfdGFyZ3AgIT0gbXAtPm1fZGRldl90YXJncCAmJg0KPj4gKwkgICAg
YmRldl9yZWFkX29ubHkobXAtPm1fbG9nZGV2X3RhcmdwLT5idF9iZGV2KSkgew0KPj4gKwkJeGZz
X3dhcm4obXAsDQo+PiArCQkJInJvLT5ydyB0cmFuc2l0aW9uIHByb2hpYml0ZWQgYnkgcmVhZC1v
bmx5IGxvZ2RldiIpOw0KPj4gKwkJcmV0dXJuIC1FQUNDRVM7DQo+PiArCX0NCj4+ICsNCj4+ICsJ
aWYgKG1wLT5tX3J0ZGV2X3RhcmdwICYmDQo+PiArCSAgICBiZGV2X3JlYWRfb25seShtcC0+bV9y
dGRldl90YXJncC0+YnRfYmRldikpIHsNCj4+ICsJCXhmc193YXJuKG1wLA0KPj4gKwkJCSJyby0+
cncgdHJhbnNpdGlvbiBwcm9oaWJpdGVkIGJ5IHJlYWQtb25seSBydGRldiIpOw0KPj4gKwkJcmV0
dXJuIC1FQUNDRVM7DQo+PiArCX0NCj4+ICsNCj4+ICAJaWYgKHhmc19oYXNfbm9yZWNvdmVyeSht
cCkpIHsNCj4+ICAJCXhmc193YXJuKG1wLA0KPj4gIAkJCSJyby0+cncgdHJhbnNpdGlvbiBwcm9o
aWJpdGVkIG9uIG5vcmVjb3ZlcnkgbW91bnQiKTsNCj4+IC0tIA0KPj4gMi4zNC4xDQo+Pg0KPiAN
Cj4gDQoNCg0K
