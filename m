Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355A22264B0;
	Wed, 10 Jun 2026 06:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781073362; cv=fail; b=mpKGWgLH9siTrj1xVdha1jA0iZGBUm3ewdk7def1GM8s+Osu7sEMd6EKBH5+KQ7uvFblCO1UI8KuWNpJSyOnBzbAKW56jgkxWUDtSpkJs7Uf/+1EwhqA7PYPKK0a1zVz8ef+9sRkNt6SkWqE7V01k7ZwzEg9FDKjUkRinLbVlQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781073362; c=relaxed/simple;
	bh=MNfMs/e57pcpL6SoO3Rq+O5eDzASrkOChVYJss8KS8I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PqcqZI0YWBurkNCZUrfBDGwYk5Mg84udEP2DYBJLkKosiimIPzUxSMU6kje8DQC1N4NCyHI9HvvqVjGGo6zzr2MDG4IWMiB8+QaaTJQ96iAU6zpjieiOeGKX5/RQUY3IQDNbS2BexROEhIDrTg+bjdGrHeK/Ls+GGFTLPv3pcE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eRA58pQY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UMNJBATY; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eRA58pQY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UMNJBATY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781073361; x=1812609361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MNfMs/e57pcpL6SoO3Rq+O5eDzASrkOChVYJss8KS8I=;
  b=eRA58pQYSTjhLDZuLb61BzhQvmhGbT7O8cTjTGOJYUxVfHGta9Tg4yDF
   0/hSmckTfNOlWG2wKgFCKgOEnpXRookE2fooqMDIhteCRkBTE6I8OLOMa
   Udn6EYfdtEB+MyIk1XAoyEpMPTSTx8ErhS6oSPqOQU4Z58D9Uba4snkkl
   PZt3uDTJWYRVDfa9abmoLVota+ZcTYiAtTeXOA7/5JBhU+lnQinsZmnTt
   wSEaC1L7AsVkdjpTdRoXe2CZ1zlHJeUdc2+Wpz2zVxsTD+H4Qai9M9Tih
   4EbAdNWRuBuNdXdt4VXDMOnjGR3q67IA8HOhNhtEr+SqkdTu0Qzk1DjDF
   A==;
X-CSE-ConnectionGUID: 8e706pjXSwyjPSI2xrRhzw==
X-CSE-MsgGUID: dtyjh8dXQWyp1rZbo4WRsw==
X-IronPort-AV: E=Sophos;i="6.24,197,1774281600"; 
   d="scan'208";a="149697814"
Received: from mail-westus2azon11012061.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jun 2026 14:34:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wLD+C45lWvcIZRW12ug+dGH6lWWQpI3mTTWiwkDx9Y1dbpBdVCvDAt1Mvr3GtKZdiYTXDikJYD2441txYuIkn+y1SPvYnpn3yBxHdIWgE4oxnES+1mNaCmAweculIKkIwSzM3+hWaVY6TzPi9/OXbq3cNk8Md0L1i7kg28hvb4fmS3KgD82znIsbDE74mpgIjfUt/jVW8z73Bdc/QvHffriDIInTdzosWQ1bTUkjwFRa8q4gEftYRt7p7n+qnpJL77YihZwn+o+ykC0INM4Cfu8veBGgaTMyTKQ3bHVdOwcmbSiTBB5fY16BO0Q7M8IvApk9o7bRSAo/1Lrz1ZaXLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNfMs/e57pcpL6SoO3Rq+O5eDzASrkOChVYJss8KS8I=;
 b=gR+7hvrh9MAsjb0sbhftJv4AJDXzYD5P2HnwnbRM8u0pTuZ2Ljra/pOZj4bBaiba2r6f2ml2uQ7osecjKaO6BJvdhnOQ/aFLjE6ouDY3ScaOQ4dF18NZ45VN95qlYQhiA3CAj8ch/5XUSa+vGukbw0mpmYLYqwrFloAC5Y0IY8aC6chI2x0hT2znXD3KipJ8MLt/Ls0LUNam2q3X6m/fd0vioI8kXxkdGu8aBQsLysqb/Fw0G9zoezExrsHS+vG+e44qA9ryFk7E5MV5amPIiPncspegod1AIVnh8T8iBi73yuXMDgPidduDur4M8BeBzWfUJx5GQ+O+szC1uBubEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNfMs/e57pcpL6SoO3Rq+O5eDzASrkOChVYJss8KS8I=;
 b=UMNJBATYHuSoH93QW7dl1ZfNEaGypRG7CkGrAv0L2Uym9RB5DIPmsE9JQT67GhYSMh2Wuj40ifmTUryS1+2IzDmgEmIBcF5k9iJlmzhBVMlXySIwb1Vcwt6BaUpt/SuqkwAgVpIgnkI6qTX3nLsvgXq4yrQJRxh6WM734DuQCmg=
Received: from LV3PR04MB9259.namprd04.prod.outlook.com (2603:10b6:408:26d::9)
 by CO1PR04MB9604.namprd04.prod.outlook.com (2603:10b6:303:271::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 06:34:45 +0000
Received: from LV3PR04MB9259.namprd04.prod.outlook.com
 ([fe80::ad82:88c4:91dd:53b1]) by LV3PR04MB9259.namprd04.prod.outlook.com
 ([fe80::ad82:88c4:91dd:53b1%6]) with mapi id 15.21.0113.011; Wed, 10 Jun 2026
 06:34:45 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] common: add a _require_external_realtime_device
 helper
Thread-Topic: [PATCH 1/2] common: add a _require_external_realtime_device
 helper
Thread-Index: AQHc9+aNPl19mNtgJkqdEbNSMnLJsbY3VqaA
Date: Wed, 10 Jun 2026 06:34:45 +0000
Message-ID: <b375da45-42b2-4cae-a6da-7f5e708a0ae2@wdc.com>
References: <20260609080051.1712103-1-hch@lst.de>
 <20260609080051.1712103-2-hch@lst.de>
In-Reply-To: <20260609080051.1712103-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR04MB9259:EE_|CO1PR04MB9604:EE_
x-ms-office365-filtering-correlation-id: 8f6dd488-3fd0-46e1-4e26-08dec6ba5cc6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|19092799006|366016|38070700021|4143699003|11063799006|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 B3xwmzW+8jCUgTmb4AFpsokxYRb1ZT0KVc2W//s9EpyZHo5z6oppm7J+XMx6K6rFuhwzGI+EIyIQLaT08Ly0DGJqjjV2E23yVE1WaPttyj7EpoVMDghrULBBK9Uzgz9YwcY4AMF3rI+2+PJs4EK4xu/TNzJiF5mjwDZ7l8Kd9UMOxHiCSyVmL5lbBlSBTgTzy/fT8m573WVh5eoWsQJ07NR0JAjoYcNDuZ6L0e3g9mzK9jvPdMtyL5ob2Gt/vtF3jS0UaAjTt/VG19NkWjVopeDVejeZrHu77LKruK6ibFlP9Rjp9k5aS8oNOoqcoZOtESpNvW4Jh+l+cOOv2cLwYxA8WY5jMscSWLeEQIJ9YQm7JGtXRRO0cWDXvaiHqGWpU8mIerX1i3sqOdQQ11cY3x+fF/AYTVoYDmGEQUPNEn0wro/uc1G7O4Nw+sHFH8Im8bJpZ25TgEzl/iMGTda9v++XSCnO3geIs9XQp+p9h+/NcbpuALAH2O2mRx46901d84ZX589/5Fy3Fc6c9FqmeBdFNh3BeNKl2HGAGnijU/O3CyhPLtLRnpQETlaEFE+m9Ol70WYZIZo9qIAEFYfWGR/SCXurhIbd7EWChgj+umvFoShvSwmeM9VzI/tvXLR5cgoh7IUoBW2CGiQyTvPRFsI76oyZSmmRFanaGpcSLc8jpQN+XCVhj+TGsd3RJf3wU+KNvcAKnmQ5LOPOQWP6jn5IRVUIdGAkCnI3xLDVW8REglO12F21PD0nWeC7UDKc
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR04MB9259.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(19092799006)(366016)(38070700021)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UDNRSWFWSWVVZXIxQ3puVGg2WjNpSEgvMGcrL2JrQ0h1eityMDhXdlpSK2FV?=
 =?utf-8?B?S0MxR0hpdEdkMXVFUDRDdnN2UGNmQnlUQ3BkejZpcFBsT2tvS0h6TmYva2to?=
 =?utf-8?B?YVR3NGpGSGExaDJvTmZhOU5kUjhONXRMS2RsVXQxOWRoNWJwMkE3NlFSYjBK?=
 =?utf-8?B?ckdxakdiUko4dE9CN2VWamdld1F6UkhUNENtTW84ZzhtQVBaRTZIOE5WZjhs?=
 =?utf-8?B?bWQ3Y0cwcDFQZHJrbWJ0aG05NHNlUVY5QXBibmN6eWxSV1E1djNvTzR2em5F?=
 =?utf-8?B?NDhSVUZudCt3Z0RTeUtrUG9TeEtmenFXQS9xUVVrUWx5clhmM0xCeWFwcFR1?=
 =?utf-8?B?NmNROGZUcjhRYTVnV3FBZXdRcExnWGQyRVZNNm8xb0hhVm9JQjNJV2FHYm16?=
 =?utf-8?B?SWxDZVVycUJiR3Q4anBXUXQ0bnZIekVZWjZZdHlRaCtzOUdUWUtsSWtja0Y2?=
 =?utf-8?B?d2hWTm1hWXRweXlOakhzQWtQTjhjR2s4bVNreTd3MHl1Z05DMzBOWmh6dkVL?=
 =?utf-8?B?NGVpa3JIdWVaYnR0b0dELzVPZHRzekFiN0JrUVhDMWovV0cvQ283U1Rla1I4?=
 =?utf-8?B?QTcvbTM1SWZkN1d4QkQxTmtWZjdneGswQmV5Y0NzSnNMd0xqbUJkcXFDUGFH?=
 =?utf-8?B?TWwwbDhmdTY1Wk1kb0dWUzV6dTdKQ2w2UWtwdTlDVWhCYzIyNE9raE93ZTBl?=
 =?utf-8?B?ME1NdERFelpMS3k0ekpyYmM2K3BkSzI3YVNhSHFvMTNrOXc2cnpRY1d1cUpB?=
 =?utf-8?B?TFpoN1hiNzRPRXBuWEJiQnZpTXVQRy9iSUo2MEFJaW9DRnJoREUvRWVaUE95?=
 =?utf-8?B?bGlKd2p0cnVRbmM3WTFVaE1NRGpxVGlOSnNVNjZmbjhoNFI3ZFEwWTQ2aGNF?=
 =?utf-8?B?MUdyV1I5MnZDeUEyRDFsaFllWThxZi9xcFZMa1NZeEdGTG9JVnR3VUJsc3k3?=
 =?utf-8?B?QU4zUndrc1FNaXZ3ZnE3ZG41cXkrdEhnMFV3V014aEEwMTlNZGpSUlA5Wlhv?=
 =?utf-8?B?UnRlWlRQUWhxSXdPRktva1NWUmFrdGRVZDZSNDBiUlB0ekFTaURzUVQxZmtY?=
 =?utf-8?B?OWVwZG1aTHl3MC9hUDk4bFhFd1BLaWRwUm5UaFJ3UHVEMG04dnhVdHBBZzly?=
 =?utf-8?B?aWduUnF2Z1c0MjJKaURlOW5zT0p2Ylhib3MzTlM3azRLTkk4azRvd2dLVktY?=
 =?utf-8?B?RVhHRlg4UHd0OU41aloxYVZHeGFWZnhjTTFSemNvNURLdmJGaWhHSVVuWUZ5?=
 =?utf-8?B?eWpkaXhSb0MzUTl6OSthV1lyTS84VVpLTlNENjlhMGNYaThrcDVnczVRdlZZ?=
 =?utf-8?B?TEc2cGVIYmlNTjByYm03Nm0weHlxeGZiMDlqaE5CcnlwL0wzZTRRMEt2S3Rv?=
 =?utf-8?B?aGd2QVhNajJKRWpNSW8zaHp2Z1JDaEdpQ3pLQm5naGw0eDlKcGFUMEl5aDY0?=
 =?utf-8?B?RmkzSUhlQWg1MkgrVXFNRHg4eFBuMFZhb1A1SXJraFVmSzJ5Z2pxYUcyY3lX?=
 =?utf-8?B?V2RiWjJtSWVtRWdPaXlZcjlKdG9YZnlSSVJPMk1xUE5TT3V1RGFqL3VnV2dC?=
 =?utf-8?B?ZTNqdExGa3QydmFyZzgxdTAweVdseUlRWUpUMGJnZGYvaU1jOHRnZ0F0L015?=
 =?utf-8?B?VHk3R2pEQ1BPaU5Sbk5OazV4ZXhvQUJYa09ranpnNERUK0pYYUJVSHRsYUNZ?=
 =?utf-8?B?NlI2K2VkcXlHWWdCU3RQYUpOZmJudW9aS0ROR0FueTFGenplTFRPZ0Y0NXFI?=
 =?utf-8?B?L1IxZmUzWi9HN2MyUW5RdVN4TlVDMXVIYWtCdHhsQVZ3ZWg5dmdpUUFCNGMv?=
 =?utf-8?B?OThZUEJXK3VRN0g0S1g1SDFhQS9lbHBuTGVvdmlkenBrVUlERFp1Qk44QXZF?=
 =?utf-8?B?WFczUHFyY3lVMHc5UlZnNVVPT2JkMVRyUlRYS0xXWXFXdm5sN1dQTHNDTkpi?=
 =?utf-8?B?RzZ6cXBVc0RYRUtmQmFZNS84VVQ1dmQ1a0tlVWVsRy9xR1BOdHczZXhsQUZz?=
 =?utf-8?B?cEh6REx0VEtYZzhIOW8yUlI5NlNpbW5nVUdWQlVOQTFVajBzWldPSkI2Sks4?=
 =?utf-8?B?ZUdzT25QMTQvbUxtSzMyazZqZVRVa09MSThLelZjckFudXlMTSt6UzhGdCsx?=
 =?utf-8?B?aWN4N1JUelc5d0dIYVhTSzRRdDY1N2w0elhwY05MTVlYdHljS3RORU16RXU4?=
 =?utf-8?B?SHNZb0IxZ2xiNW5CdVNsWWpIQUYxNDNtZEUyNWJWNXZJYVlxaFgyQVR4TXYy?=
 =?utf-8?B?TnRIWE12NlFBRVRBWTA4UURPdk55cjBTUklZdDh2blA3ZnRidUsrZ290YWxJ?=
 =?utf-8?B?QXlYRWM1RkIzcWN4VGRiZTloZ1p3SW5YWDFxV0ZhS1hPR3lqWGZXUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AFD89A8CC0D864FA5B0E8F1189D7691@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	j9FzaxuaGkWqE3dASfqIXtnCXE+TJDmCtXuFxHjdeyxHOoWv5HG0+fQhH6qZrjjYH3xYQIhW2CeC6xQ3pno0fVUmW/6GTFHdOp4Elq/nTbrfmUhFAtg53NzqUNfHkW1aB71/nP7wDpchtsotAaLVQy77SyB0QYzwZMgMM64Ub5GRgK7E2D6vu4BvTAfmxCAUCOx2asSMr3eFZhzBFSr1SflWzHhorczCFF2a/0EVtUa3AwZKeqDTOaHan2zB4yRtFnq9S+AuSrvCwwMTPJ4WVhtjDCmu1PH8XjdFGMXbT78atII2YwkzHM79CoVRissICCQEil+/l1LKd+V+JirFKg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z0ZTZ2Gdwlx76+//Zv30znUA3DwRYOQgl1CfRV5UjGvaEPzilvfuZe5XVmdUsMnlQ1fVZOrcF3ya+P4EAwdCTbMjx8aM0HMtqqvSvL8RsY5R0FpN8rMKMSk1/oqafJ6gA8SpDag2AAfeBtB8iyHzUKlPU4L9qHu02W4jMza/aJU8qz/DuWJm4FYgS75ze1Cc4AAViWPkcfxb7Z1hlp8U8g4/+1G+ZjyVGVpVBfu6X5kRr5MIimbFUP1/MzBTphMCupl3rpRzUbyasrBUU5ZDud4Rs1Y9rstZfrzBj2KzrPT/M66bfOKko8eGbaruQmJcJaraX9Zk6FnkMl7fv+haxAN0mWCWTEr/VM8tFECk5GYFBDUaD8EiG0oUbIyHFap1zZPVWCg7pvkfmwu6HO6XXIeCiqonSpDEebuJ3MKjcXjnF4LcWivJ9deEJHtlRCVSKV4JajTOKaxQ8YT5Hy7In9Dofahri+8BLwjOeYVhLZFLIOCnLG6LK0kmySgiC0lPb0m84ulkKRR+1zv1M6/EsF9jByemZ5GuNyDjvUYz0JoEt+LkC2asYFsDUuwPUZsWwxZl2Nwp7cnqGVjvKwZDCxr/8McUCEtijZwNQsrH1N30TVqqZuB8zPAqUlV5CW3m
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR04MB9259.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6dd488-3fd0-46e1-4e26-08dec6ba5cc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2026 06:34:45.5716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6rSFyWTQMwlA7SQhju/JPoyb64KMpaNtZsjYzV6YgiSALGm09L0DLhOI5pf5agjrB51UJrCBFYV/VBdQsYaaog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB9604

T24gMDkvMDYvMjAyNiAxMDowNCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEZhY3RvciBv
dXQgdGhlIGNoZWNrIGZvciBhbiBSVCBkZXZpY2Ugb24gYW4gZXh0ZXJuYWwgc2VjdGlvbi4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQpOaWNl
LA0KUmV2aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg0K
PiAtLS0NCj4gIGNvbW1vbi9yYyB8IDE4ICsrKysrKysrKysrKy0tLS0tLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvY29tbW9uL3JjIGIvY29tbW9uL3JjDQo+IGluZGV4IDcxZDg3Mjg4MTYxMC4uMzM2NDQxYzdh
NTIyIDEwMDY0NA0KPiAtLS0gYS9jb21tb24vcmMNCj4gKysrIGIvY29tbW9uL3JjDQo+IEBAIC0y
NDA1LDYgKzI0MDUsMTcgQEAgX3JlcXVpcmVfbm9fbGFyZ2Vfc2NyYXRjaF9kZXYoKQ0KPiAgCV9u
b3RydW4gIkxhcmdlIGZpbGVzeXN0ZW0gdGVzdGluZyBpbiBwcm9ncmVzcywgc2tpcHBlZCB0aGlz
IHRlc3QiDQo+ICB9DQo+ICANCj4gKyMgcmVxdWlyZSBhbiBleHRlcm5hbCByZWFsdGltZSBkZXZp
Y2UgKGV4Y2x1ZGVzIHRoZSBpbnRlcm5hbCBSVCBkZXZpY2UpDQo+ICtfcmVxdWlyZV9leHRlcm5h
bF9yZWFsdGltZV9kZXZpY2UoKQ0KPiArew0KPiArCWlmIFsgIiRVU0VfRVhURVJOQUwiICE9ICJ5
ZXMiIF07IHRoZW4NCj4gKwkJX25vdHJ1biAiRXh0ZXJuYWwgdm9sdW1lcyBub3QgaW4gdXNlLCBz
a2lwcGVkIHRoaXMgdGVzdCINCj4gKwlmaQ0KPiArCWlmIFsgIiRTQ1JBVENIX1JUREVWIiA9ICIi
IF07IHRoZW4NCj4gKwkJX25vdHJ1biAiUmVhbHRpbWUgZGV2aWNlIHJlcXVpcmVkLCBza2lwcGVk
IHRoaXMgdGVzdCINCj4gKwlmaQ0KPiArfQ0KPiArDQo+ICAjIHRoaXMgdGVzdCByZXF1aXJlcyB0
aGF0IGEgcmVhbHRpbWUgc3Vidm9sdW1lIGlzIGluIHVzZSwgYW5kDQo+ICAjIHRoYXQgdGhlIGtl
cm5lbCBzdXBwb3J0cyByZWFsdGltZSBhcyB3ZWxsLg0KPiAgIw0KPiBAQCAtMjQxMiwxMiArMjQy
Myw3IEBAIF9yZXF1aXJlX3JlYWx0aW1lKCkNCj4gIHsNCj4gIAlsb2NhbCB6b25lX3R5cGU9YF96
b25lX3R5cGUgJFNDUkFUQ0hfREVWYA0KPiAgCWlmIFsgIiR7em9uZV90eXBlfSIgPSAibm9uZSIg
XTsgdGhlbg0KPiAtCQlpZiBbICIkVVNFX0VYVEVSTkFMIiAhPSAieWVzIiBdOyB0aGVuDQo+IC0J
CQlfbm90cnVuICJFeHRlcm5hbCB2b2x1bWVzIG5vdCBpbiB1c2UsIHNraXBwZWQgdGhpcyB0ZXN0
Ig0KPiAtCQlmaQ0KPiAtCQlpZiBbICIkU0NSQVRDSF9SVERFViIgPSAiIiBdOyB0aGVuDQo+IC0J
CQlfbm90cnVuICJSZWFsdGltZSBkZXZpY2UgcmVxdWlyZWQsIHNraXBwZWQgdGhpcyB0ZXN0Ig0K
PiAtCQlmaQ0KPiArCQlfcmVxdWlyZV9leHRlcm5hbF9yZWFsdGltZV9kZXZpY2UNCj4gIAlmaQ0K
PiAgfQ0KPiAgDQoNCg==
