Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF7D43F4DA
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 13:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791294813; cv=fail; b=a+htYPJ7uv9AaMAcBRCqMcP393WngMPsyPOa9DVG1Rx3f4xsksGUXSzha4KJZuBVvjgrcYjCQQFs81yd+/7b+gOZvia9cOGAa3u57ovPYtcyesRCsDtAaGG+xpdhzEVceClQv1EmjJjIBS3Sh4SMmCV2J5sUIWRtyVm1/9PXYLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791294813; c=relaxed/simple;
	bh=HuSMRipBBINhA6qAtchLJ5o1OI+zzTirmdAyOhTku60=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NuoRRFhuxAkZ83E5HzN5VrfE8ZcH+1v1Nfj2xDrgW1YQ8bb7AM9dFCETvI8NrIm4Yj6CZLM3PYCZo9s5HsXrU/UkZpE1qreM3Yg9/AtwtUpPzUENaS1s4gODTH+7awgpuFY9p3+uI60gkQLYMPixsX2KrP50Wm0U51SfNG8ipRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kKUSmZjy; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SZlZE6/x; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kKUSmZjy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SZlZE6/x"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791294810; x=1822830810;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HuSMRipBBINhA6qAtchLJ5o1OI+zzTirmdAyOhTku60=;
  b=kKUSmZjya4SRZqCOsMKof1qeYLxX+rf+2AxvwjfVxLNkh2SLPClQxKDK
   HILX+M97fx9oE70MdOlwV8MdtxcUTOss6AKrcmUhu5zjbCfuDBDL5yISz
   mm73A8T8R0wmXjp+7mrNZ9km/FzQ59jgs06xXORHAuJcUUPkbCxzg36AC
   rUM04O8gsMT9+kby+10isngPjQCMRQlsP7K2j8836It2dqx9hJy6IYwa4
   DlTIEseMqnc+oKAzmuXfmA3uu24meq85zqarPhBFEjIWLXwiBeBDNpCk0
   PboveXdKXKjzcEhVwsXN6mD0cFubzbvAGi7G3SwEKbVk2ZWLK0FUKv3rr
   g==;
X-CSE-ConnectionGUID: tShJfd8US76LAwn0txhYKA==
X-CSE-MsgGUID: tadDt5QWTJGq/VIgH9889Q==
X-IronPort-AV: E=Sophos;i="6.27,143,1786982400"; 
   d="scan'208";a="153197453"
Received: from mail-westus3azon11010009.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Oct 2026 21:52:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnp33nOrqCUCdx7jS6hPAGuv7l4Gtz3883eG9F5Gif5zTuNdKqeC749fSkFv/kiIvZ0SnoJsUr0Lw9FL/HdllyXpjGa8xGLIgqbQFvsufR1xOKKL10hj98Jw8ylYcWVUcFeo/a1ypXvYpnxiUjFvA8KPznlPXncSa01XlmJqc0LU5oY3mIXuJzZPGA5nOLDGR2tmt9kg00m3T0XTxAW+MVeQgbcjVeIIOF656CCIcv+JptCHMebH3xAnhd2+bCMg6MRn+uV8OklNgq/Ro89sUjEoMDYWGyJP6wZy1fH/huIYk1r2k8jg3EBvIsNKAV+KyPOHBPiHOVnehqbWTsPpbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuSMRipBBINhA6qAtchLJ5o1OI+zzTirmdAyOhTku60=;
 b=kZDkatS7C+8x8QvZs+OUMyEVi/kQwvsA48zdJj2M9fYjVac8dCRXb4GCtq6QT8BSQiNHjJqY7vDHcY1L8BcLTM0zhEzDLr1W30whuy/m2dcfeB8C/RlMyp8A/2D+Iihlb1EVyEJXxCk5UXdsw//CY5i5gNmY6pNVFpqKvOtgqIYoCm7Xi6YPJ5HPpwjctlOIMokk6IZW1mGxPVXnU1QLCqr5CiyQC7KHJsi2/NGGdf0WSAayhbRoCWX1iH53vc6jcR0VJu1iBJXY1uQAIVkas/XrkgQR+iA0sFC+NN18+KrQp4SzC5S8GnAEYPeiyLDPSJk9bbkt/QBRcN07mC/VFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuSMRipBBINhA6qAtchLJ5o1OI+zzTirmdAyOhTku60=;
 b=SZlZE6/xD7zTeIR8ZfwxEzOIlRGb88/xK8R1WsszsT6ymNh1YZ93lcbGImPEMYnDWLYheK2RHFoNmirpKuMNLxKk+pcjzSAzsjEerztv72r/nBZO0fzWRU4p1zOPWi9Xg9bYaxu+I2z1nYoGoGhr/O/xEjFbG2dYEhawkXTgJ0I=
Received: from CH4PR04MB9666.namprd04.prod.outlook.com (2603:10b6:610:235::7)
 by DS2PR04MB993920.namprd04.prod.outlook.com (2603:10b6:8:337::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Tue, 6 Oct
 2026 13:52:19 +0000
Received: from CH4PR04MB9666.namprd04.prod.outlook.com
 ([fe80::c5c2:d54b:103e:3895]) by CH4PR04MB9666.namprd04.prod.outlook.com
 ([fe80::c5c2:d54b:103e:3895%6]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 13:52:18 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Topic: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Index: AQHdVXtCquID+nF6ek64bdvaE5VYBbbwVlcAgAAyfoA=
Date: Tue, 6 Oct 2026 13:52:18 +0000
Message-ID: <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
	 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
In-Reply-To: <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH4PR04MB9666:EE_|DS2PR04MB993920:EE_
x-ms-office365-filtering-correlation-id: 71e4c680-e661-4238-2045-08df23b1097e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|23010399003|38070700021|11063799006|4143699003|10067099003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 /768TOK9K0MkLM2mKthGDIGqaALwrKrHRE2vV9qYMeKiArU/GVfgPxhxqp1y0MlQLIt7U7aiKwd1NP30Fs0WAVuAfw5m5FDvjcSbJcCB76NYibK3c3kk2z/gNbmpRT2yuJ+HkWeKEfh1jUmpgbqNdfwS9IwLTj9ioTm3ooQgurdJFWL9wxeGnni+gggoMoDeVn7yAT/M6A7B43hBhr2VzKoaednDW4GvWRlmq1LzOaaZpfU+feV4qHMT/sy4W+S3lQtez4rJRLyvj/cE9YleoHvdm9Y/bMwcAigTKOmeY3cjRM3iAvUQ+aMVazh5BJGnml1CkRlOpTTKQLBO6HQShNfEYEUgEHKgy+nmtmNiYob86aG47G+wWi2vVOdRnqu87FUt8KB/7Ro6EFTzlCgT5ij4vwdILinQoJFJ4olciRaN3FaS7lk2NuZfWmT6VRYE86Vurr6FraF67rZTbNaqwiC4kUCQ2l7h9Ex1SPFHlNJdkf+MhjwP4hcVzvx0PET6iZVNyuIsbcdIdty34S+HXnP+lE1UoevYzaJ0gCro7SCeAFC0YFeDSlzrQQTbW9LpivnfEHazNk8H9HuHVhqvv4uXCXBgvoMzksLcoQ/ui8pyy2+cEbtOcK+vyWcQvemA2HMl/G8SzhDQ54SOFwqxU17KXBGcWlVa3A83itfl+p6Nzy80qW6tImi4akUSRctp0UbsM6X5ZMcZ38Br9GR9G3XYhWFN4UUU/xfn+fdJqGA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH4PR04MB9666.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(23010399003)(38070700021)(11063799006)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZmFPQTM2Q1JZTkdMWGp5V2JEbEJveEhXTTlvdUtBS3hDZHMvako0bjU5VitX?=
 =?utf-8?B?R29LWklVOUFodUVOb3ErV3BNY2VBR0hGQjJPR3BZTzI4WDNLTTltM3FnbjlI?=
 =?utf-8?B?UmF4Q0NZZGRydSt4cTBMWGhleXVpQkNSaUpnVjhHMjlpSERueXVVSnpwVExz?=
 =?utf-8?B?NURhekVJZG9rK2hReFNzWFgxMHN2OGhHZnJwMmdZTHBYa0w1djdsblpXS0dl?=
 =?utf-8?B?eHFMdlVCQ1V6cU9WenVFdCt5ekx2V3MrelNkZVQrTUVURkk4NUxDU2ZaY1ZR?=
 =?utf-8?B?RTNNbytUbDFYQmdNeUxUZElBSXlXWVFSSU9VSE1LWkwzanM4VExNNGhzdVJo?=
 =?utf-8?B?d0RJSmlQOWYzcFV5SkpkODBDZyt3MWZUSjF5dVJRakJEcS9GcFdlRVFtWitB?=
 =?utf-8?B?enZ1OUdkdHRIYjVDVUcwUElYZExDNEcyeWtsRmQzOUhsK3U5U29NeTZ6bzdj?=
 =?utf-8?B?NFRJazJFbHp4YjFTZ1prN2ZqRTVZRkU3WW9oSXRhZFFIY2F1aldxTVFJOGY1?=
 =?utf-8?B?MDg2K2xud3RFV29NczBJQW8wVkU1MlFaNUJ3TjBlbmw5UkZ6Zldibjg1Uzk1?=
 =?utf-8?B?SEl6Qmt2VlVnMHQwdXBXaU5LcnhQMjNOZ2hPRFA3SmVWSzR2UkF4ZkhKeld0?=
 =?utf-8?B?S0swN294d0VKekw3V2VsQzR0bXlMb09WczV5MDN3RVo4QnRqMkhya1NYeXpM?=
 =?utf-8?B?QVBvKzJueWNqVXE1N3JSWTJDc085ZkdzRGZzbTc3dEYzWWVzOEdjUnVQK1JG?=
 =?utf-8?B?dFNEeE1nMXZ6MHd1VHJubHprV2pRNlhldVNTR296UGhLeVVtK1ZuanBra2FX?=
 =?utf-8?B?ZURvUllobXF5WmNyUCs0ZEJWZ3NPWXVsTEhjTU1KZUJDMDJ6aUFnWCs0QTZB?=
 =?utf-8?B?MHU0bUVpWDBjWk5JcDJqSDlWZnhRK3dWNTZQUUt3d2QwUmNKZnRVTS81VEFF?=
 =?utf-8?B?WDN4ZHh2NnB2WTlTZlhvanIwOE9aemw2WFQ3bjBwcDZmbGxGUm04SUEzc1cx?=
 =?utf-8?B?NUVFSUVqVVp4b3ZxeDJWOUZnYVZpem5wSlFaYzRCY1lCNDlOZjQ1WWcwSksz?=
 =?utf-8?B?UFM2NmFuUzdDeGZZTXV2c3lWaGsybXhUYUhMLzhubm5GMDk2M1UwSHFpaTVD?=
 =?utf-8?B?YVh6YkY1U2lkNlNZUUdCQmpNYmU5UFU4SUpqN0FFd2NUTkI0eElRbXZxTDVx?=
 =?utf-8?B?YXVLWnd2YWlIQWFScVB1cmtyNTltVEh0K2hDcE45OU8xVnphbXMrVzFkaVZV?=
 =?utf-8?B?K2tWNDJCRTNENnZzL1NWSWpBNVRkaDVMSlBoME0reStqemJieDF3V1JycU5B?=
 =?utf-8?B?ZFRqa1hkR3RLUDBEbUR6VklZMWpML24wYWEzVEg2ZHpXR05GS0xCMGJyMThy?=
 =?utf-8?B?eGN5cEk3NEQyU0ozcmo5THg2cGxqTXQ4WGplcmFqbkNTMXUrVjZTYXlPV1lG?=
 =?utf-8?B?eTRDZVBUSWUrTzZaRmYzVUxPSndFVkFwRnVkVlBzWksvSVVzMjBNS3FpY0VQ?=
 =?utf-8?B?QnFid3hXa2tlSk5YeE5yNThmQS9BQjFXYVA3dVFUbHArS3lSdDF3MEJKNi90?=
 =?utf-8?B?eFg1VGpmLy9lY3lQbVNkQU1SVEh3K29LQnZ6UGZsVnJTZ09uVDFoZGNzU3Nn?=
 =?utf-8?B?QzFkWjE4eTFhQTdaZnFsMDI4MXB6bWlySENRQXdHSVFQem1HWVhYM2VVRnp1?=
 =?utf-8?B?am5yT1N5ZjZIRWR1a2RHRUpXSWhlUVNxV251bDE3M0piWFZ2QUlpRUJoNGFO?=
 =?utf-8?B?bE9UMWpQazNic0dpMC9yczFhWWdFQUJYTkd5bS9UcEFyTE5md2ZZN0ZQYmZU?=
 =?utf-8?B?NjlubC9wREtHN0VSL2hNSXo3R2c1VTFVdnhCSjFFYUZIaGVHbzZuNHFUUWRl?=
 =?utf-8?B?VlQvQjVPZGs4VG1ReFdqUTk5TWk3Tkd6dHZDb2tzcTBmTTE4d24xVFVlazdH?=
 =?utf-8?B?R3c1dlQzMktMalhVZ0tnY29sTTN6S0J6QytlWVlEWFREd2ZBbnlEbnRkQTFD?=
 =?utf-8?B?RUZQb0pjcXo2c2ZjbjlLeGJPY09yVlBsVUVZUGFBdnVQbHAxMFpTaUJQbnJO?=
 =?utf-8?B?U1hpU1dHYTlxNWQwU0kwenpvYk85QlRJcksveE85Rnl1ZmFyamx4SmdIeUFt?=
 =?utf-8?B?Uk1Md2hlamFkSW9naDMyMTRtT3FOck1oeHVhd2d6eWh1cTlFdkR0NXU1c3M0?=
 =?utf-8?B?RUpONE5iclBzTDhNZFYzNFBac3dmemFobHgyRm1lR1Q1eGM0a29LM1NEalM2?=
 =?utf-8?B?Q3drOFJFQXpIN21sMDdHd2RlUUlxMS9VZFpuZElldDJmMGltZkVRVk5OWEFS?=
 =?utf-8?B?UWNaOWllNEwyRHZwVFBDWEtoYkd2ZGxDY2kyakEzeEMwMHRYeDZkQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <162010C4EDE13A4EA888B65D44E1ACAB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	469MP3SeYjlMzK0TwAGtmq1FGY9cAnHhvn6IeBUiEZUWOaWNCR3LZVHY44V7gjvRO3/+Kk0n1EjuA7OTwV/dDyfSjEmluCmuFjNa86hBaX3QWEzKdo7M0ljSenSK2zCkFzzSbFPc4VJgAwi7q/RWiRGOO1IESGGAAfOsqOf0HiTS92qkiEzcpI6w2ZXSgmW8CAcKN3arNaAXh0nHeDmA+NGNonfuafDG55O/fTI4XS57vk80Swf3v8cO/xDaYBKLcje/UfuqeL5fniipRbBJPR/sG01egiDJtBVZNPFoPWdvgBu5p0ftGawFLQtmKe9ntwXQXQxXdahi1ArE0XUp7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fzdT//Zrz/n1+X7o0UxLOdLA+1biHFxnghD1v0zploFgxhIQOlLXIpCFOa3JJNXkSR7eIUOnD2/1mJgMQcm2nwaQ4mtG6BdJT6vpeoBypbqiyz+1476+Tg/wqkh31JK34xMOZAm88OiSPDI3hiHekRawyzn04/1nm8RQD9I3LFoeMTIZ9Zk4UAXV4ps63ZJ15E5D8UFToPjeudleNb5op+2phppyZPDJZCDYoAu0XggPDTKZhTdQUUwT+R93Gei3WJZGMg1SoBXvgR4ulLZMJGl1IheE+bJoY2/weZB2v1bFhpgQr5kpT72171/DwKhFlawB4yho4L+2BNSiE6l78dLpR1cJwBzWQL7RxX//uuIU4/5e19IGkT4ccu6ul65UPiJ3Bhx3OYi8Cv6uKqxBvTq2ODWe2cDfoyavxYUclbH5eWJz9w1QWyRL5JjXi7FOdYeFgIoUKcrKcNkaI0u6M+gFb4wmesjw3XrBa1pas27Uw+FhJ4N3Mu6XH0Hio6ItoriMxkDjXoq1nUacrQfqeMHlyKwfw8/jB59WJjTmqLj8qHgVDE92bMxMtmI+cyuD3Xv9GL63qT2a1l0r86JBkM0qc/UrxdfnBCyJuhC2/dwwj6IVMey/L/8guFEOniwX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH4PR04MB9666.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e4c680-e661-4238-2045-08df23b1097e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2026 13:52:18.5155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AnVul5fjGve9IP5FkRXtzj+xzKm8ajphz/uA8uYgABKG2qTgX78/WJ7N/y7nDyHTluVbC9ysIUcu3Xr864yg9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB993920

T24gVHVlLCAyMDI2LTEwLTA2IGF0IDEyOjUxICswMjAwLCBDYXJsb3MgTWFpb2xpbm8gd3JvdGU6
DQo+ID4gwqBta2ZzL3hmc19ta2ZzLmMgfCAzICsrKw0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDMg
aW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9ta2ZzL3hmc19ta2ZzLmMgYi9t
a2ZzL3hmc19ta2ZzLmMNCj4gPiBpbmRleCAzMzQzNjdiOC4uZmVjNDM5ODcgMTAwNjQ0DQo+ID4g
LS0tIGEvbWtmcy94ZnNfbWtmcy5jDQo+ID4gKysrIGIvbWtmcy94ZnNfbWtmcy5jDQo+ID4gQEAg
LTY1MDMsNSArNjUwMyw4IEBAIG1haW4oDQo+ID4gwqAJCWV4aXQoMSk7DQo+ID4gwqANCj4gPiDC
oAlsaWJ4ZnNfZGVzdHJveSgmeGkpOw0KPiA+ICsJZnJlZShjbGkueGktPmRhdGEubmFtZSk7DQo+
ID4gKwlmcmVlKGNsaS54aS0+bG9nLm5hbWUpOw0KPiA+ICsJZnJlZShjbGkueGktPnJ0Lm5hbWUp
Ow0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0KPiANCj4gSG0sIHdvdWxkbid0IHBlcmhhcHMg
YmUgYmV0dGVyIHRvIGhvb2sgdGhpcyBpbnRvIGxpYnhmc19kZXN0cm95Pw0KPiBBbHRob3VnaCB0
aGlzIHdvdWxkIGxpa2VseSBuZWVkIHNvbWUgb3RoZXIgZXh0cmEgc3VyZ2VyeSBvbg0KPiB4ZnNf
Y29weS5jLg0KPiANCj4gSXQganVzdCBzb3VuZHMgd2VpcmQgdG8gbWUgdG8gZnJlZSB0aGUgbWVt
b3J5IGhlcmUgJ2FmdGVyJyB3ZSBhbHJlYWR5DQo+IGNhbGxlZA0KPiBsaWJ4ZnNfZGVzdHJveSgp
IGhlcmUuwqANCg0KQWggeWVhaC4uLi4gSSBiYWNrLXBvcnRlZCB0aGlzIG9mZiB0aGUgeHJhaWQg
dHJlZSwgd2hlcmUgd2UgaGF2ZSBhIGJpdA0KbW9yZSBjbGVhbnVwIGFmdGVyIGxpYnhmc19kZXN0
cm95KCkgYW5kIEkgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdG8gZG8NCnRoZXJlIGJ1dCBtYXliZSBu
b3QgaGVyZS4uLg0KDQo+IElJVUM6IGNsaS54aSA9PSAmeGkgaW4gdGhpcyBwbGFjZSwgc28gZnJl
ZWluZyB1cA0KPiBtZW1vcnkgYWZ0ZXIgZGVzdHJveWluZyB0aGUgc3RydWN0IHVzaW5nIGl0IHNv
dW5kcyBsaWtlIGEgdGltZSBib21iLg0KDQpJIGNhbiBwbHVtYiB0aGlzIGludG8gbGlieGZzX2Rl
c3Ryb3koKSBidXQgYXMgeW91IG1lbnRpb25lZCwgaXQgd2lsbA0KbmVlZCBjaGFuZ2VzIGluIHhm
c19jb3B5LCB4ZnNfZGIgYW5kIHhmc19yZXBhaXIgYmVjYXVzZSB0aGV5IHRyYWNrIHRoZQ0KYXJn
diBwb2ludGVycywgYnV0IHdlIGNhbiBqdXN0IHN0cmR1cCgpLiBEb2VzIHRoYXQgc2VlbSBva2F5
Pw0KDQpUaGFua3MhDQoNCg==
