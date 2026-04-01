Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5C7402B81;
	Wed,  1 Apr 2026 13:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050011; cv=fail; b=BZ6zvCaQNV/07RsnsIY6LoeOqOZSIHBhyawA84SzE/kHCurTfx5FBvzfINT8rTJeGqzwoj/KRZ0X4spUSkTocDoeqrFHQVL26bQmdcG9Veyt4gfUjHye+8PwSKNm9ukZJQAGVVUkb0BFpzOfWgb3qzjPNJEnaIpoqDEcI4MKmk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050011; c=relaxed/simple;
	bh=D4MXPcAcqDuMsHEeR75ohLaqOpgZwxXXeutRy64S/wo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NboNawCubA7HBlFV9tOPy5MKOYhDicXedhKex23ZM3yd8dUZIxNe2lvwu09IHpxvApY0OYaLPw622UViD6c97BgYlFU1mtbCBmg7HcKd819JAswr0a82RwSDJLx5ar1cdP1ePmcXAXwpl50Xob//o6KGV0Nsu/pdQID3P7LocR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YCMuqbv0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yljnMXLB; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YCMuqbv0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yljnMXLB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1775050009; x=1806586009;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D4MXPcAcqDuMsHEeR75ohLaqOpgZwxXXeutRy64S/wo=;
  b=YCMuqbv0DiWKg+AlHS1K0VDGWWM9vWSwfH3xCkfvPBLsZx6LENK8UVQQ
   LSDEzA7EQYMIXHr+7//hHl22H+R8jwRzQJP9HZ5St6K8sslgDPM7ugfn6
   puudh5sJr/+yBmXWX80nOMMhjFZRCDW6um5utvTZ0RgyuLuzEv68JtYD9
   eSUKNbUMzBIEuvMUhtwO26ofRz/kPKUwEw9YzMDtvBHxMA5iRldkN1ENf
   ji+JXHIrvbJGSIfqmR2hZyIGEOaW+cQub1jD94GLfMaZWQ7phe/I/ofbE
   fMBgvQhbEXIaHD8U2qNPwkQSoCAYZEFJvYM973MX2BUsS4unoMnbBosyD
   A==;
X-CSE-ConnectionGUID: 25akhDl/S5+xuNPuQJp51A==
X-CSE-MsgGUID: oCEmhtL+TD6yNFbFpkeCbQ==
X-IronPort-AV: E=Sophos;i="6.23,153,1770566400"; 
   d="scan'208";a="142623737"
Received: from mail-northcentralusazon11010023.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Apr 2026 21:25:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3ZQ6JFM3xJWiZ+4R4ZgjxUBovtDgW2r5CX+XFrztI6qhiao+mtph/sRVtAU6D4I38TdmNuHgEF7QGQWH9Hbw7S6zA8HA9TS98VtarFZYSZoinXpXyvm4woKU00VwtKztGWnvMJhenPlP2vnRAAEMyLRf2hXjQ5BeGEFlSNCa/JSrjQUlIHC3/zPrG5FQdGI9pRutEaplhxTWONUjTO2SCZ14B3XOHuvzvph54gWP5fhJU8OI+4HE3r/4i7D2csGpubt8cXGgMg+ulWYlgzlVZB2XEKbYTHOciP9SS7q+3TDxInRLLsPO+A6hthIkx70KJ74GX/iGu8FYepVobk6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4MXPcAcqDuMsHEeR75ohLaqOpgZwxXXeutRy64S/wo=;
 b=FxWjxHRxUDi2KvxW8DW+0iq854DqrJnpwJuEe1R1l9bBXm6R2IH7T4lIabS38YmxpOqQbaf1qMCTh2eTXzuM151jQLRbAb68W+S4s6S68eY9H4NfcEZu5fv41lF1LYkRRL+thGKBHKS8HIp1+WW9VIZQdyP/iAquFrxb3bh9TbZTwPJTOlIHYCzARRq8JuG8EtOx7PtP6ICsiAEA2s0cXipDdtaQYu6lFBayzYV4ztpejwzMKTmZ3e/PhAoVi/ZhZvcwOmVSuHaL/Wnd5/NbRkWrvHdugauxFEGGzAIHjf7wjThmXcf7Sn/KeAE2SBY3Ii59Y+3Mzajl5LT+OEcbrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4MXPcAcqDuMsHEeR75ohLaqOpgZwxXXeutRy64S/wo=;
 b=yljnMXLBGZyraa+/uBCdauNA1E8a0eZYpo44WuSoiU9Utq2AGPKAGxviQJYrL3SDegiMLav6Qs3yPK6cogOB99/CMj/UvoXe34yhataHaXBbujeHaH/igdWAMsPhq4XdDctE9yRZsHPiq1DdLcnk5DSi61/h5K2oo26tM6uhxj8=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN2PR04MB6399.namprd04.prod.outlook.com (2603:10b6:208:1a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 13:25:38 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.017; Wed, 1 Apr 2026
 13:25:38 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@lst.de>
CC: "zlang@kernel.org" <zlang@kernel.org>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, Damien Le Moal <dlemoal@kernel.org>, "Darrick J .
 Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] xfs: test that zone_gc_low_space writes start gc
 for rw fses
Thread-Topic: [PATCH v2 2/2] xfs: test that zone_gc_low_space writes start gc
 for rw fses
Thread-Index: AQHcveZeM3NG2VKJOkulEYsWI2aT8LXGkeuAgAKPSQCAARkMgA==
Date: Wed, 1 Apr 2026 13:25:37 +0000
Message-ID: <499dc713-ad24-4200-8855-3e6736f172b2@wdc.com>
References: <20260327123429.39330-1-hans.holmberg@wdc.com>
 <20260327123429.39330-3-hans.holmberg@wdc.com> <20260330053421.GC4876@lst.de>
 <20260331203942.jvlahulg7x3zkjd6@doltdoltdolt>
In-Reply-To: <20260331203942.jvlahulg7x3zkjd6@doltdoltdolt>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN2PR04MB6399:EE_
x-ms-office365-filtering-correlation-id: b1c8d627-fde8-464b-355e-08de8ff229d7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 yqCcSThf9F41x4SuRjY4iIDPbcxgkifANXynZA7d97Rh/EAIhMiUbOBpdj6ddLy7Sm17+otWnP4pF2Uv36mn4mCLLciTcXAi2WMtxvSfCmsRnQZMRsaq8fdGADz3t0AgfoHGWUPdt5slSR2FMWyw05c4ha0qIZvv8Ij+HQc/+vpnxMu2Q9Or1V/D3sG3alClz9+guWubPnMv163KTLWFwcDWzxw6Z+bAshNbUs1Avp0rxMhMDEkm4kUK8uusGJ5UhTF0q/WK6FcOy+mVkWivMC/kjV61AlCl3UivAo/GCeaP5y+lwUTHRIyXi2hvkdRl1YF0LE2w31829dOb3vG9iTjSDwkRc3tK3ySOhXAZ2FvQwFnafnLYr3zg6GQGDfbntOSuYCjZG0Lt/TgqXJNpuw3t/U7M6aAwgEvWvlcWGddtz/q7wCMhHG/jhu9JuB2HG55KIKf0xvBIHz6VlDPZRLACGa1NUOm1zeH5zewKpBVMDtU1RcxL+cVRdCFcIi7xI5O0/8+AXhBVhuJxWa/E4R2a25Ptbqssb8/WCdYkmSSzI8bt6V9MBna+CZOByUm6O4P+tI35BlEGehDIRVXXVDo/wB2fvhurKQQb190lyynyKiyBAI6HitdIs9KRk6drYIato8vLXMHcF4oKJGO2L7BzZSWYF1YJl31NwXtdMsQgFPo36R0mUAbNIIO7vTqkqxdGdjTjV4A/1LwRMAGz9Nm9+2vyezMYFLXCVlU/SZFel3/zYuLfqmOzhA2xhDdEFMyR6RzjARg38kkpjYFT9bjd+h7YeL7EANNn6xrMZqQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aXFab3ZYbmZWTlZHalpzRlpwWGFaeldmbFE1N3lBaVpVOU9qcGo2T211VmZ5?=
 =?utf-8?B?czhmcnp1QnVlNmcrOFVyMjFvNndvaXhoZURDbk0vQVJSZ0hyOVRPN0Vod0lH?=
 =?utf-8?B?enNMb1AxRE0yL2xSNVZsZkxGY3hDRHYzWndZdGdPV3hKMWJ3K2hrbzN5dlFY?=
 =?utf-8?B?c1BoS1h0aWVYTFRHSkVPNWphUXhQQVF4M3oxR2pteHdRdDRvNGFlenJvNWFm?=
 =?utf-8?B?UUFGbGNtWDVNekhLSFo1QXJpV1E0RitIVWJmVFcrQld3ejd6MWlhWkJmQUs5?=
 =?utf-8?B?cmdiQlk3VFNxZDBtdXFnYUFJdlB0dVZ1ZWNjakUwMlZtb3FhNWpNVzlZK21a?=
 =?utf-8?B?SC9kWVQwSWVBMytKb1FnK2hKeWVXS1pzVGU4MitkMVdZejFTeTB2WTBpZnQx?=
 =?utf-8?B?ZFNLbWg4MTNTNVcrTmR1VTJTRHhyRU9SMTFlUkRqRkJVenlXUWZ6Q0JoZVFy?=
 =?utf-8?B?a1NrODZ4bEFIQllZTy9XRFRTQU9hM3dvVVBjSkhZeTBIL1NDMm1CRmhLSDJz?=
 =?utf-8?B?NEg0WXdQc1FCNml2ZFFyNlFlaStRR2RDMk02WXZydzZYcHNacEhOdUx2eFFW?=
 =?utf-8?B?NkxQZVpSaU9QU1ZhT1h5bHJveXR0TEczUWVZTGJpcFh4K2RPUWlubkdYb256?=
 =?utf-8?B?bGxQUWx3Rlc5dDVCSVVmVHVZQ1JVSDQvUzRDMnZ1WkxVc0lOeTlHYUV6UlJ1?=
 =?utf-8?B?TytTZmlucENWVCtMV3RFSWNxdEFnUzYwWlBQM2Yzd0FtZGw5MTM0d25tZ1Jz?=
 =?utf-8?B?MW5IMFZxN0ZuRTRPMmpZVHlpK2lwbVllRDU4R1dDaUNlcStQUmtFd1ZPS04y?=
 =?utf-8?B?QjU2U0dFMFhzc1ZMcW9USW8wYkVVVUNYVjVQdWtodENCTFAxNEpLcUhybnNl?=
 =?utf-8?B?dDJBdDJ2ZXFqd1NtejFFQnc5WWVVU0JxVDk3OXlsOHFWZk1iNWRMRUdDTVJX?=
 =?utf-8?B?RllLRDl4RDR1c0NZZjBqKy84K3dJM2FneC8wVC94NEN1UzhlZ2txeG8rS2Ri?=
 =?utf-8?B?Zk90Nkt0NERlY3RpSUdoTVNLOU81RWF3b0NwZEVpQUlKZDkvbWp1Ky9hcmNU?=
 =?utf-8?B?TGJuV3MyZHJEVzhETEdwTnZ4dXhzOWhuVElnSjhGdUpWRnRSSXVUd0Z6aHpL?=
 =?utf-8?B?RlVSV0pMRkNEeG82QWZ1UnV1QTAvSkt5ZnlxUDlpL2RQOTlEZjdPYThacWJT?=
 =?utf-8?B?YVNwZGcyUlY0ZlFISXVjZzBSeCtzT0tqZGhxYTlVWkYzM1h6bjdDcmlMNHg2?=
 =?utf-8?B?K3pHS1NQNjhRV1RleHZSTzRXa2kycmdLRG5tWW95NDNQakI1WjN3QklsSWxu?=
 =?utf-8?B?TjJpTTRvSjFCdHhUaWtZSk5CRTM2S1ExaDZOS0R1aUtPaG1vVzUrY0Z6YTEw?=
 =?utf-8?B?aGN2ZEdOamZqTGFrZlJQVnpxOHF5M1dsUnhwRUFOSWZXYzFpSUlaRGtGYnFK?=
 =?utf-8?B?Y2VBb1RmeDBIdVBWbzRuS1g0eXpBZDIzeStieC8zOGk5d0w5dFA3eVZkNmFB?=
 =?utf-8?B?VzhLdXN6aVBYcWp2SEl6ai9nc25Wc3Rhd2VrRzNWRzhiampNYU5DaHdwL2Iy?=
 =?utf-8?B?a1oySXpHWDFnaFI1cE1SYWFjSUdmRzZ4WUEwMnZEZUVjeURkdzhBY3dxeDh3?=
 =?utf-8?B?NU0zRVgwMjhCVDQydUR4djNTWnlocXljcS9OR0huMkVvT0htZWVuemg2Vk9M?=
 =?utf-8?B?ejZQcDgreW9mWlJxYStnMFZaVnZ3NGRBaFN5NGJqZ1ljYTk4VnhlQ0Q2LzN5?=
 =?utf-8?B?a2J4NWtrc1dLbENXRkVJRlRmMTQzWitEOWpIK0Rlamk0RzFja0ZmMVh5b0tG?=
 =?utf-8?B?bGRjdTZlYzVFMGFPNkF4emNsMGR2Wkc4NUk2ODJ6VTVNY2RMS0RVWkhEZGJL?=
 =?utf-8?B?S2RYQXNXQm9kREtuTko5UzlobWdZd29wbjFQcEdzSms3bi9RTi9DNGE5QVpJ?=
 =?utf-8?B?TlE0UkpUOG9jbEM0anlvNWtENTN6SmJIMUk3ZDV5L1duVm9uVXViTXd3N3Bv?=
 =?utf-8?B?UVZuekhXRkZQVCtmbHZMNzQ1N0duNXJMNDl6TGJ1c29HZ2NwaTd3OEZRUWdk?=
 =?utf-8?B?LzQxSHBNU3NXYVNIc24wQ1k3YW5ZaElTT2JpQXQ4R0NuMHd3S3FsRzk5S2F1?=
 =?utf-8?B?cjlBWTJnblFnT3M2TTRNZmlDN3lqYmNENE40dUF1cCs4dVZmZ3lKMEI1ZElX?=
 =?utf-8?B?V3p3MDV1L3pSQmN0K2pick1yK21BMWVncnlwa3VmQm1TL3llVVNaN25pYkov?=
 =?utf-8?B?aVJLLzN4RnJkRVFrS0U1S0k5QXZVZG1lRnFZYjdZZFBzTWE0MEtkMVZJTXY2?=
 =?utf-8?B?VXQvMXpXNDM3WCt6NXRnTTJFQjlUTzJ4d1R1dnE0cmpmMG5KU2Fhdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBBD585EFAE5424CA5697BAD61A36B45@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	O7NHEJviF/y+ArjqKcGyu5hYnCDU+1rbBewHg33rdR817SbMrLUpPuYnEZEYLcqFYTjdAmPc1lwVrOo2XdXqQqAs1/l/YokBcH1P0qeU3duhwse7KIsQQIejbeObgrTZdtZvwVv3GRt1VZ/cR4ZRSSYTJBsYCkybgXIac3t08XtBq+E1cQzLNJUng6VbwnLTPaIlWKkBd90nmR/jq2cTk4nHjnisjt/+hOvV5KVn9iSzmNjCbjXC1o5UoPKhYxotjgAvZvfQxFEMcdmV2j6EGp4Ald0XUFGl6k7mgFcamUqkcmOaZdjcETnYWJ5oZ38tul12g0iGCY3vcWPqZxhQZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+okhSIOchDu5WLPs6kWgVcYROTz8ed1cjArJ5LROZhvb3djyytguefhHcfhhbncBpB6CkI/Rtt4XrJ9FGc4kxmKKLuyLmoLJM00f8ieZnCLkwK8LtbF4X6Hv224tHFG3bIXFw9dEIM/v4v7RECQIcNuQyu095NLQrslutTdsBapawCodhmMUDf4HMQKHxhujVRXOszJBZ4AwmqPOCd37SYigsnowHVsjSfIEDg6HVKB1MAxPaq1vCuvhYRf6XE1bsjhYTN6hy7r3lA7sgcM+HP1CavcE6F8z7bI3twwFVrTk+nFtF3gA4fNpxprgzyuy+teG9c1UCFhA5VlvXxn034Yud0OrvYTnRxrYVE+3KPFRSMPYoiXQcRepdNUCZmOMGfsHR79P7rwfFNKPWnD7k7DJEU1txE0+v60Xi8HKqeQnNYRpRVCPkO0+FdQzWq3D1IxvwUNecXPfIbhDoRqwHFt/Omf3vuflEryJMQXZksnP3igvxovJkDgBkj0B5YAzvYXL1fYdNOdSPXck4GkxiKlWxhjdxOQPqo+oSIm5Mw3tp1QUNkkLbJVuDyARVCbJ7/UgCdzcmzB0C33vMRQlW2DJHYDc5mUdLboycaSpu2KJrKWD8OWoUJCw06sjCnFV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c8d627-fde8-464b-355e-08de8ff229d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 13:25:37.9639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VqZFKV1c/6m/bU+nxpTQtwKv+8weyKkRIENS87zZA6Lo6MPmomqZtHjTog4JqLafX2yy/m4QSPwLzsFISZGTpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6399

T24gMzEvMDMvMjAyNiAyMjozOSwgWm9ycm8gTGFuZyB3cm90ZToNCj4gT24gTW9uLCBNYXIgMzAs
IDIwMjYgYXQgMDc6MzQ6MjFBTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+PiBP
biBGcmksIE1hciAyNywgMjAyNiBhdCAwMTozNDoyOVBNICswMTAwLCBIYW5zIEhvbG1iZXJnIHdy
b3RlOg0KPj4+IFRlc3QgdGhhdCB3cml0ZXMgdG8gdGhlIHN5c2ZzIGF0dHJpYnV0ZSB6b25lX2dj
X2xvd19zcGFjZSB0cmlnZ2Vycw0KPj4+IGdhcmJhZ2UgY29sbGVjdGlvbiBmb3IgcncgKGJ1dCBu
b3Qgcm8pIGZpbGUgc3lzdGVtcy4NCj4+DQo+PiAuLiBhbmQgYWRkIGNvbW1vbiBoZWxwZXJzIGZv
ciB0aGF0LiAgSSB0ZW5kIHRvIHNwbGl0IHRoZSBoZWxwZXJzIG91dA0KPj4gaW50byBzZXBhcmF0
ZSBjb21taXQsIGJ1dCBJJ20gbm90IHN1cmUgaWYgWm9ycm8gY2FyZXMgYWxsIHRoYXQgbXVjaA0K
Pj4gYWJvdXQgaXQuDQo+IA0KPiBJZiBhIG5ldyBjYXNlIGJyaW5ncyBpbiBhIG5ldyBoZWxwZXIs
IGl0IGRvZXNuJ3QgbWF0dGVyIHRvIG1lIGlmIHdlIHNlcGFyYXRlDQo+IHRoZSBoZWxwZXIgaW50
byBhIHN0YW5kYWxvbmUgcGF0Y2ggb3IganVzdCBidW5kbGUgaXQgd2l0aCB0aGUgbmV3IGNhc2Uu
DQo+IEJ1dCBpZiBpbnRyb2R1Y2UgYSBzZXJpZXMgb2YgaGVscGVycywgaXQgbWFrZXMgbW9yZSBz
ZW5zZSB0byBzcGxpdCB0aGVtIG91dC4NCj4gDQo+IEZvciB0aGlzIHBhdGNoLCBJIHdvbid0IHRy
ZWF0IHRoZSAic3BsaXR0aW5nIiBhcyBhIGJsb2NrZXIuIElmIHRoZSBhdXRob3INCj4gaXNuJ3Qg
a2VlbiBvbiBzZW5kaW5nIGFub3RoZXIgcGF0Y2hzZXQsIEknbSBmaW5lIHdpdGggdGhlIGN1cnJl
bnQgdmVyc2lvbiA6KQ0KPiANCg0KVGhhbmtzIGZvciBjbGFyaWZ5aW5nIHRoaXMsIHdvdWxkIHBy
ZWZlciBub3QgdG8gc2VuZCBvdXQgYW5vdGhlciB2ZXJzaW9uDQp3aXRoIHRoZSBlYXN0ZXIgdmFj
YXRpb24gY29taW5nIHVwIDopDQoNCkNoZWVycywNCkhhbnMNCg0KDQo=
