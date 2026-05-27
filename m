Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149F2390223
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 22:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779921542; cv=fail; b=WVe92GS1ChdDnp/O3Bz23UvbnQpBG5q8WunOrOSlKeRn2Ax0JaejABAovdkbJnzCeVh9ojSpAMGDYrnTrAs/NflLjnq/o19J9veSm+u/Ag0Ao84/9+HY+WkFE3+Gk6AZfu6zRavjC8vnX8lQ5rn/wJ0nbXYyQ7jzuWeTJoxocKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779921542; c=relaxed/simple;
	bh=gIUd/cy7Sw2Kg3ABa1N8k3eE9WIElBKRmvpapnL2jdg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=toywyDBmCZu547LCBLFfqNWUtQhm+uKS569GKkzjLzAI0CHdghZvHG+lRXfcBELFcH2tgWS4cpK2Zcb9CEf9XtjgXc+7h2Uo716MVLB9pmQ16f4YNSxxQWkdzOPHT4MHtcq6iKs1Js8PXL2O1iFDiMLc04QRbPLxol+/fDTQG08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iVt1DgXA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=H1D8FnkS; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iVt1DgXA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H1D8FnkS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779921541; x=1811457541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gIUd/cy7Sw2Kg3ABa1N8k3eE9WIElBKRmvpapnL2jdg=;
  b=iVt1DgXArEx1UhcFDD6Lo0uUFku5i9SZEzOkF3THa841hxbnOTeLEnA0
   jcmEMsrM9eAd+KfLpDtwLONlUwTocrnvutv8WlJ4rlLilromauJWLYlHZ
   m3karLEzmJpFrgqewb2vC05fZQqR2et2ZqlShtUoEeqdAOiuGLnmkyHQ6
   akL7BKLW615nX3GZHiBBIo9gIVbBkdXhaqOE3OoWbowr+3Jpo/CCXaM1M
   OUDYRusT/ZNVjqh67N7Pt6WhhYFrqpUrsco6ZEbYTvaxwBQKxK/X10VSq
   6e2SS8gvLOtARRSXoMRWfbhfKsufgtYDUSoPD5Q1vnRQtuckZ3qnJaau8
   w==;
X-CSE-ConnectionGUID: 4aQt7XGCR/68pHN86KOOsA==
X-CSE-MsgGUID: 1U7Eq3NtQsumP/00ApJk6Q==
X-IronPort-AV: E=Sophos;i="6.24,172,1774281600"; 
   d="scan'208";a="147913581"
Received: from mail-southcentralusazon11013041.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 May 2026 06:39:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/ijgWeaOer1d/TD/X8bfw+A+v4OQHMH/2nifoJ7mugBH42AMAYGnJI5YqDUAcHtFQV4qtLFzDaJguorm/ocdb01a3D2FkvpJGNRjP4fHBfSVVJCnZxQOAm86raydFF9sCdBNSS9mwyqU4l6/YxjXKCpsVO8pBD/0YUGw9QEk2+OXdu/P5Q+MoBPETEO37bZi4wNjrhxlgib42Cd4KSzRqexHaIQxQrSkZHB6Er0tW3Flkr3K6F3Vw4ko+I9vUUv4mx0tOWT5K5w/aQiGBAbhpK28g5WPejh7JhSoeM/xc+jsmspMZX0edEH6la2+SwaInNtkfqTSbYc7mkCSYtUWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIUd/cy7Sw2Kg3ABa1N8k3eE9WIElBKRmvpapnL2jdg=;
 b=Cg8vEixCm9YhBnNgY6xq/m+UpeAjJtSmo+1gpTl8K4GumS8nCwp8+HSmpJCS7LoJr0LwadDyVXz3l4qJtgSn1jzm1nyYgEqGAPXxaPnF5DgL+5oueWjAooAnXYs2aGLSgqwvYEqqbXBiZ7QiB6ywvGKk5Q0ioaV+Qppu+PElmGs0V6a0RixJrx8Prx5W1T3aEV3V3jZQbQv8JR6Q2nDKkjRcvDAiEr2dPAm8/8GXB+vX78XDcFKkBOKji7XVAMAOyg03knSF01AYLwjJoockhYfj3kxS8ydnuELhgcNGlry2EXIQNYmO+zlu7+BMkaMWFqd5oIpknEIp2oeOCNBvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIUd/cy7Sw2Kg3ABa1N8k3eE9WIElBKRmvpapnL2jdg=;
 b=H1D8FnkSE7NNc93TVh4fDyE2VpP/p6f/38ABQ0eJ+JoqEkNT/AVJqp6Vmn2QXsEYRaoWq+KUhHoCo4FXgM80T/XE72fsscxd2Ib8j3BVjNwElsje+fhAj3QGbmiXMcYga42rBB/b1RBNtbNsctMMiE0UYECk7CmC9l4/RVIKvw0=
Received: from IA3PR04MB9680.namprd04.prod.outlook.com (2603:10b6:208:510::12)
 by MN2PR04MB7117.namprd04.prod.outlook.com (2603:10b6:208:1ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 22:38:58 +0000
Received: from IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f]) by IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f%7]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 22:38:58 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "hch@lst.de" <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "dlemoal@kernel.org" <dlemoal@kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: drop the experimental warning for the zoned
 allocator
Thread-Topic: [PATCH 3/3] xfs: drop the experimental warning for the zoned
 allocator
Thread-Index: AQHc7dXwXsc1jKNRXUuuKi1sIgd5YrYid4mA
Date: Wed, 27 May 2026 22:38:58 +0000
Message-ID: <8159c2d49e4b6f95b39a02a837ade5b0764faa58.camel@wdc.com>
References: <20260527123941.2319377-1-hch@lst.de>
	 <20260527123941.2319377-4-hch@lst.de>
In-Reply-To: <20260527123941.2319377-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR04MB9680:EE_|MN2PR04MB7117:EE_
x-ms-office365-filtering-correlation-id: f3f2d242-905a-47d9-a023-08debc40be05
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|38070700021|11063799006|4143699003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 uqeURu4GGSi4V6vgWoyxiyv4uEbqJxNUKHUmASGSunj8WnNeC+rBdTa80KEt653KYyym6blRalB37/UtSiN/3y1TcDIdnJQ3aXLYITAYKl7AmPxVZ8MXlGmrs6OTozPKJ5YaspscmLWw3qqiZPxgq1YR3C593tREJ73EYf9xB//OiwN50uz6viEonutZBKW5pwUDqUe+taMi6y64MWeIgteoK7vwXRw2TznMpzn8k3NQmN83d1xyYzIVftzklBviUk/mLJO7r/hB8N/+wLM0JUQ6DPimZ9/q3jkoXqeaNWhRp/jo/SmCIAEBukA2ri3/HbSJ6ffPpNx70QS6hBsyKpQuncej4btnco1Io62cCwpPcyK90KQo9q9r9iIsjQbYC+fj/M+cj0A4mB2JDRWrepUX2t/arYeGk6114P0OfxzaLm9ud6oUDCWzlWLimpBEcMVP5K1IRaIjI7CD8fQ/94HR2QbfaokzggYlqVCmru5wAsVLgxhjDraxFK5lJSE1K+EDhklSOktxEwqxvPQRz2Lgu4Vy+FuGbZcg7c910pXWHXAl8Wm6uCbgWEp4HyetASho/MIYRSsEo9ZGkAVS+rRmKTdUnKrMf79oMCKJGVwbabVfQD05K6J67+LR2DTGPmR6dUc8++F6uiL8AQ5TiPjaNfDyIn9vYO2FzUULqpTBk0Of6CHKZHg5EibbThaQDfVBt3r53PfXUfc6RAKlFCOySrcTQk+VCw/vIxi8MtzRCx4WPaRJTsuzRiP/EAgq
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR04MB9680.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(38070700021)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b0ljU2dYakl1Zjh3bHBteGVNU29XYitFTHR6ZXVKMEE3M2xxTkMxZUNoSkpE?=
 =?utf-8?B?dDIzS2xMWDRMSFN2eGhRcUpaYi9qNjVZN0NROWxvUm1wMWI3eUwvZnVxR3ZK?=
 =?utf-8?B?SXhuc1BCbDlmZmJHMHVwdEM1VGU0cGFVcEdtMTNlNEJpdzBMK1JzRys3b1FZ?=
 =?utf-8?B?WDhZVXJlcGxBbC9VcFhZUll6Zk0xR01QMkxCTkhKVGdRbFBuQ3YralpGaWh1?=
 =?utf-8?B?aFNMWlhiL1djQ09yZlJrV0h6bHZHSHlOckRQNHFDSDdTMDJFYXRJWnl6NjZK?=
 =?utf-8?B?eEdja0E2azR5aXNlYTUvVzh6aEExWkNlU1JlS2kxbFc0ZXd4N1BUV1RxWFdL?=
 =?utf-8?B?K2kzeEUxU2ZwNVpENUtDMGdiVG9WZTZiWHVzOEJCTXJGRG1mNGYrQkhweita?=
 =?utf-8?B?VGZ5YVpkemtFb0FMN1hKZU5IS3MwU0orV3NsckNOTzFLNGdGdzZ4dXFvZnNE?=
 =?utf-8?B?cVZVVktEK3p3aEdwYVM3azR0eUdjRno0YzhYbmNUbmtVV0RNQi8vL28ydFND?=
 =?utf-8?B?bTRUQkMvdGRSbDZZdzNKQ2hEZHQ4em5ha0RhdHFJbFdqQWRQMWczM2J5NzNX?=
 =?utf-8?B?VmZhQXRJZEJneDZDSzRxL2xxWnJMU09QOGU0cDEzcW45VU82N0hQK3Nnd3ZY?=
 =?utf-8?B?U2U4NTIyQ25VYi93L0tYZmZNY0Z4RDJXOXJ0VmQ3TXJDcjZ0ekFCUW42RTRX?=
 =?utf-8?B?SUExSTVnLytSWUhhVlN3djlyMVB0dlZJR3VYQ25xWnFLaVBiQkJKTVFicmU0?=
 =?utf-8?B?WjVzVE1yWENIaDROYmR1UlBjUnNDTjNwc1VGck9HUkVUMU9vSEZXaWV2NHFW?=
 =?utf-8?B?R2RYNFl3dW5TNjI1TjZzUWxYRWxjcU50ZEJBSU50b3dtcERBVDZqc1FLRGRn?=
 =?utf-8?B?STF2SWVtdDZla1lqaVp0VkpBY1dDUjBZbXhiSHBidklDUE1DOUNpenRXSEt6?=
 =?utf-8?B?WHZLQ3BLcktyTU5aOVMydzlnaWdxbVZNKzdNdXN6MCtDZzdXQ0tkSmVOM1h5?=
 =?utf-8?B?WldPSjMxSFFiKzlaN3ljc1lteXBpWHU2dlEzMDROQ1B6S3FFSXhVQVAvSjB2?=
 =?utf-8?B?SitvYXJldWtPNjluUDkzak5LRVVocW4xMWgxYUJUQkhUSkgvZk1wTVA1OU5x?=
 =?utf-8?B?RHJ6MklveldVK0JEMGd1aVNXYjJUcFQ1SXBxZzRZaSs3TnZiWXdrYllNUm1l?=
 =?utf-8?B?a1RTbXBzZWdIdStRN0ZZZUhsdXNWTHRBaVFiVHZQN2lIWnZNM0tueTloTlp0?=
 =?utf-8?B?K1BsMmdabkQvT2N1eEpwaUo4bXRlTVdGcmFyQW1IU2JKakZWd0NkSFIyQnZp?=
 =?utf-8?B?ZkQyb1YzM1hOa2Q2Mi85dXoyRW9NN0RNTHZKdEp3SFZ0MUlFcWRQS29wR1pM?=
 =?utf-8?B?MytFNEhMdlNaM3kxVk1YVE5PQkR4OFlsN1dlVnJpS3gwRWlPRHBiUklPSkFR?=
 =?utf-8?B?VHpoVE9xcFp0cUtJRUF1MTNHLzZ5SnFsbWtPOFYrZGpkY095ZzhISkhUQUlx?=
 =?utf-8?B?U3JFZzQveVBqbnJpSHFkZ2VuVklkemFDU0RUemxoOVJ6Vi95NS90cEtvNHMz?=
 =?utf-8?B?ZExyMmgyM2xpRHl1NUlLS2xjRkJOZzFHcHhrWlJoRGZIc0xzcTc2ZjI0djVy?=
 =?utf-8?B?ZlBuSGFSbkswdHhrRWhnRktTd1UvVW1RaEVYMVMvcE9xUVpVZUdmOUF0Umht?=
 =?utf-8?B?ZFNwcENtQ2V1SjZVV2FrRWE0UGoveUFtejZaWnZxSGhSRWZXVW5WOThpMW4z?=
 =?utf-8?B?UWUyeFloamZvbHhmWnk0M1ZqakN5cy9LSU0yeGtYOXNRUXgvTHhNUEZkMHFR?=
 =?utf-8?B?YVpQamJxLzBVS1c1YTVDVTVjSjNuWC9vcmVnYWgrT2R1RVBiNlBqZGRxcUxV?=
 =?utf-8?B?UFJ3ZlgrUWtiMTVxWFhSdFRJUmtiTkVSL3FTU3k5RFp0Qjl6N1FwUExCK0RE?=
 =?utf-8?B?RXYvK01rdlRvMUxLSlYrRjVBSUVOTmxGcytoZElvR1FWT05NMlp2U29wd0Iv?=
 =?utf-8?B?THlpZUxRcUJ3cDNjbUM0Qk9STkQ4QkVMSkE5OG5FdjNIWnZKZUpiNGhlemFk?=
 =?utf-8?B?VkZXYXNseUFIWVg1TnovWWRya0dlNVdYUDhIQXdZODRJZ0xQVWZxa3A1RHow?=
 =?utf-8?B?d05CYWwzR1dtc2FycFRsOG0rL3N0QThIM2V3UWpDRmFwak9hRFk1OXk2Z3FY?=
 =?utf-8?B?Uzl3QUpQTGdvN0szbFovOGE3TkVLY2d1Nm9YNkl6M1J3QmppRm81bEpXczlF?=
 =?utf-8?B?MjZBem4vTmtHU1Q3NGRjbkc4YnhTVTJObXRnYWhNWkR3UXFaSE5IWEpiZUU0?=
 =?utf-8?B?MExLMHRvb3JIejlwS0dkZ3RNNUYyVjNMVkJibFA4bWFqK1lJNjFQTHVNNGM0?=
 =?utf-8?Q?r+8XyxcxIO3GXCnQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72013E6ABCB8854898A61E9D79641860@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	fF8x3+8vqTCxERfFrUUaRWKB03HOI0j4fM0mm27MW9T+XAO4FXw/gQGEQevmxXcqs+8VxsKf37ri1c+qOwDdwHtRtR5L9TlhL81s3VQ2R8NdxHY8mmZj4a3psoV5+0iOWmvcGA6Iy0kJ5TMBURXgjdNm8CxtGcrUOG/KR220D/vE1nJmPhhH5i1M6ncQU7qFtT9Kk8HMfqyXyR1rt3Wr+jn83NGIH5zfLEWf16rNddgfxT3BUNVBfaAm+kzRJdLXL2yEd1m6vhxsSV1jS8kyjFd636isHv3ikOKw0YPCb7XuSqzjvnfao0o0JVijrbi0VqETkggyDTs3TImftqw8UA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jUW69H335DfGIyLT3Jhtivj4dRnIYqKi7ISfN9lVkonsNIGGHzAjY2RVqZrzm0PnTY+uVFwmc2wmQX2oy9RExb/KgQKaqDfLBRCkPcJbqQHM+YKVsRXA6Fzh8QXH99pLxJ+6Carv+YC1eJVTDAvOKrSANLQ+ysA6S/3GqrHsM/Qg2mNSfu+v0urpktJnqjGUEQDkpomQ78OaE5KuBd+kK5tHPmXTlX6FV2dBxYfUsr3yj9fktUHThfLebO0zmKNJG4KZiCyv1qteStVr9fI5ai76rrLnRdoTGCsLsoqecP0gqMH/8iS2/9PZwRdUpGvWJhpNIVH8FjKvto7vKpBaPuMUBzAKyAu3omogkFspfVJuVIBHCoWXtuaO40cdn3eekQ8rYXe99/NNkPelDxl8e6nuVz6MSE45NJigaWArOkCfYs2RjZWjMPy69xytHf9U1NJqbjGFavMXn3F2M4dGHG2IXcj+duCB3YH6clIQIJe7v2yE/Svcs6en7xUGsdXy3m8h8t30/wUnegj7UmeOhgl5iazSlX/9VfraW1tRKK/dU6VIYXrmxe/mfiDA53ENLwx4G8WPb3EWknJXYJRN2TvwiCVSJZNZWg5EyiJcviynBFpHcRZyUFWdfdbjRNbZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR04MB9680.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f2d242-905a-47d9-a023-08debc40be05
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 22:38:58.5080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xyeb0Q/e3qmWEtvhKVxILvzFpF8p3lHpBIM4+kqsAXaw6KsGNZUAdeIovDlte3kug3RsmQ+zPMCWhdfCCCpeoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7117

T24gV2VkLCAyMDI2LTA1LTI3IGF0IDE0OjM5ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gVGhlIHpvbmVkIGFsbG9jYXRvciBoYXMgYmVlbiByZWxlYXNlZCB3aXRoIDYuMTUgb24g
TWF5IDI1LCAyMDI1LsKgIEl0DQo+IGhhcw0KPiBzZWVuIGNvbnN0YW50IG1haW50ZW5hbmNlIGFu
ZCBpbXByb3ZlbWVudHMgYW5kIG5vIG1ham9yIGlzc3Vlcywgc28NCj4gcHJvbW90ZSBpdCBvdXQg
b2YgdGhlIGV4cGVyaW1lbnRhbCBjYXRlZ29yeS4NCj4gDQoNCk5pY2Ug8J+Oie+4jyENCg0KUmV2
aWV3ZWQtYnk6IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdhQHdkYy5jb20+DQoNCkNo
ZWVycywNCldpbGZyZWQNCg==
