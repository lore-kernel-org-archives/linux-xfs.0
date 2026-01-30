Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBFB24729A;
	Fri, 30 Jan 2026 11:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769771790; cv=fail; b=DitaCadmiZ1jIGTWmbsjDN8+HmvR/25zhQrf3ynIn4sn6Yf3u6QUjLChcMCo4osl+AYkoqpvIuVXVNfH2wv6R3r3sNVMCpCXhGSo3Fo+BaGLD3SUOtw+WWQQ/z7Q9zBAvHpu6NZFApjPvz2RSuvdxFrk9RwbHBnL8cBC59BrA5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769771790; c=relaxed/simple;
	bh=/icSJdaQKpwfJTql8FDtmf+FQkS+m6azBirfN07tRdA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M5KnwTSny/YMjsdLZDeAHY/ZMBuiDqrHlK/PwnbTKjtdSqiLwngx/GEnSgZVBUyiH6ALbG8mPQnmCuxYq/3jnpjmhvW0yy6Ve1H/Qdj7WEEYHOCWGxOfSGzLahuuc+eH5FE9oS+uXlaq2YXomKzx5n/TZKJDd8vagqwzmQ4IPJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YemESs68; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZRKHnuZF; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YemESs68";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZRKHnuZF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769771789; x=1801307789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/icSJdaQKpwfJTql8FDtmf+FQkS+m6azBirfN07tRdA=;
  b=YemESs68PEELwwfcTFJlbEeYJdpYFBVlYOZZ7Z7JFrDRCizshQewoQU3
   uukeBVc8q6klkiawdL4iVFU49lwu2EhR39hQoMJusgPrcaeThuAcbLTg8
   ZNyr2zg7eVeprE+kZOGsVPupiTWBkRtH/9agg5ITkfYwfcMvmASn0EtfX
   1JqGjytW6AbmrQdkkcHzL8hzTDGSrnRmSD2hzeWkeBoePqPycw0UEqjGI
   zL2CRk/yGp+R8cMiK/Cv64m5cRbl4DUwxWu6tQ1hfnkDBptLYxpnWdir3
   RMc9QXeJHqgATtOU/aFv2AWndtWbhlWQqiEq9GB3xlFKeEU7z2zCDkedi
   A==;
X-CSE-ConnectionGUID: aRFpugo3TLWN1cQaFv6sIA==
X-CSE-MsgGUID: yvuW9YBURw+XiGGTm4fXKQ==
X-IronPort-AV: E=Sophos;i="6.21,262,1763395200"; 
   d="scan'208";a="140424865"
Received: from mail-eastusazon11011064.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.64])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jan 2026 19:16:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vln+9faoDFGNDjfM0GjjxD24LswplWeMAAtvuLpiXtDcF4xKTolwku4cUc6qcMopXwOrig+xr5Feib2xICqUYGEw4FQTpQA/2Jfo9Sik7+uQf3w+UXIqpkmtl6HUDAhxsz3yPfFTzktLYEQhYGOXar/Dv1hW8ZRNPDVBkApApcVCqFbbVR7BWEyuhARj91FscWB6FqNbz04BYoncecbIKdYYrevfOARF2sBFlIW6bqxK++LtxEzYK/lNrtET4uOyIoAY1voCacZxQlxDkNqAUb0+uqE99yQgqihLKCEfnQOsT2WvSYJvC1P4rTrhduY5PYZSPvdnJ01dixo6M9QpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxkNSrtmLgmxBY3cj/n/CgAOJKkA3JcVz++mQW6iOMw=;
 b=w7KPvcxUiM6F3f616FsKWxn0lTIKAPMZqUd9OL+B0g9hJr85iY4HD0DAomo6jBXZZQzBVbFnpXxgXts/izMmGhagFvNWYXAlo/cU73x5Y/foG7OKjImOZeSApc4E7Ipg4d7wOS6A/IFGnZT0bBkLb4IlNn6cka0Pe/mBxWqE4bno1xsV5IjNjvsJiP9SW0Y4oqCi4yYliXuLHM0cVMMcOK76/7IrNda5O/eMtesX7eFfYrC89UO0c5jfY7iWOwy2O7wVV+Pj1feefbgMrKeQ19zS7RKlIyAJtpkzYMrtqVpA51uEHOuQDnipkW4HKEDlCxm32QEH0Jk0TUXT+Arshg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxkNSrtmLgmxBY3cj/n/CgAOJKkA3JcVz++mQW6iOMw=;
 b=ZRKHnuZFtDrxA+RgaTtUJmr+rKZ6SWhRHrVZLW+z70pkGQoKvwJsYeM7NGtjFJdfl+RYqAfWyBzjiK2HVD4jWtTGXOspeh3N4tA6stXeehXCXnkVZaV4XeNmJ6UfeVmHIB7IFmINGKCzJtyynYISaocYAbQcLw9dYtOKiQ0TMI0=
Received: from SJ2PR04MB8536.namprd04.prod.outlook.com (2603:10b6:a03:4f9::11)
 by DS2PR04MB9726.namprd04.prod.outlook.com (2603:10b6:8:27a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 11:16:24 +0000
Received: from SJ2PR04MB8536.namprd04.prod.outlook.com
 ([fe80::8820:e830:536b:b29a]) by SJ2PR04MB8536.namprd04.prod.outlook.com
 ([fe80::8820:e830:536b:b29a%3]) with mapi id 15.20.9564.008; Fri, 30 Jan 2026
 11:16:24 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
CC: Kunwu Chan <kunwu.chan@hotmail.com>, "rcu@vger.kernel.org"
	<rcu@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, hch <hch@lst.de>
Subject: Re: rcu stalls during fstests runs for xfs
Thread-Topic: rcu stalls during fstests runs for xfs
Thread-Index:
 AQHcjrclowh1moKuUEq8Mwy02Ri3kbVnWueAgABxzACAANWrgIAAzoQAgABdO4CAAMgvAA==
Date: Fri, 30 Jan 2026 11:16:23 +0000
Message-ID: <aXyRRaOBkvENTlBE@shinmob>
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
 <aXrl46PxeHQSpYbX@shinmob>
 <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>
 <c33c3d3e-a59c-4f5a-a562-13e2cabc2faf@paulmck-laptop>
In-Reply-To: <c33c3d3e-a59c-4f5a-a562-13e2cabc2faf@paulmck-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR04MB8536:EE_|DS2PR04MB9726:EE_
x-ms-office365-filtering-correlation-id: bb988c41-5f1e-4d45-6d84-08de5ff100e1
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?en/2DOWawyCRka8uLRP8agtP04r3bcdrFdQ4kCzCzrCVBt/hAGhrZmWhjWJx?=
 =?us-ascii?Q?wgNuITxA5yBHQMF6lWG5Pnub2l7Qvvr5KcCTfP+MYtKrBcMWGzZFraQ9Ndmk?=
 =?us-ascii?Q?a5kNrpRtMK5UFbDYE9OG0FGO4Nt1/Tp4WRIUBR9EH8ftv8S+ZI+A5Jude19v?=
 =?us-ascii?Q?/gD6g9PMAX7sFYpZHToftCMkA/OE2ks+1honUtPwm42scLvWjaS0R9pn/UIb?=
 =?us-ascii?Q?Pz3tuQtio0IQ41GjVzX8/ckiSSl/AK3fWN5gpSAKHDu0vPfcRPql7cM3LPaE?=
 =?us-ascii?Q?o9gwVfltN7wfUUBJmg2RtVdccXmiJ8vlTSA+hq/aXL+SrMpHqLXiy4qxlkFM?=
 =?us-ascii?Q?yhzcsWC1S6Bd31IR2qAmT+9RoOlzt+uF88HF9uHYcWjxrQ0ZwXTCJZ3GrFwW?=
 =?us-ascii?Q?oGWEJJQ0zqvcbpQ1A7CDCoCNfQEuFk5x1+HjIFWOGwYyiTkyg0isRvcvWgAI?=
 =?us-ascii?Q?2064eI0vyZzdJJ4q6GC2eei5iv0IT69vNnwbkX7kvW3oWGBGZvkiG6eaIeSU?=
 =?us-ascii?Q?AfX/AFS7Cl9FgqmZviQifNCH82NemQO0YMDv/J39uCJJ80P3eDH2OBC7xUwk?=
 =?us-ascii?Q?BkgKrGpB44a197SDmcTHcMt8gCOh0Xll4HFA4N28ZgczXDc2WnVbcaL3kxQg?=
 =?us-ascii?Q?mGkbyb9MZHtqVJtSu26mg04Hzx5w2/N2+6O3woRm3Pyt3r0b8/wmNviCFnVP?=
 =?us-ascii?Q?TCyz2NuOdZRA9OiBBaQjv8Qvf+SLsEH4Uw1Gn8uazZBbL9/TYCS0TSFh5tml?=
 =?us-ascii?Q?eriuJoBmtAVRc5YzqV0mPbRx5xN+MQqmvsh+Qo+bgdx7/yH7tN9aaCwiynLH?=
 =?us-ascii?Q?hz6i6AW5wffK9LvGXusIwUsB2fWPZzOzqLCj7sZ/0fqVrJTCRUYvvixjl6ii?=
 =?us-ascii?Q?Suv6Pn1cAJfWk81Z/CC1t2ereoi0DjJUFu/rnivwq0LKmQN+Ks4jefZfBdSg?=
 =?us-ascii?Q?wKrfoHTZJOIYeaYq3/u2OxkQdsu+1zBF+L64lX4pjKWhE49j2gRQQE8/uori?=
 =?us-ascii?Q?ddh4K6PKUDiu59+aTMSdQIW6Qn4bapvw0DtKZL07cXGHA8fyOSEJz0JgXHa1?=
 =?us-ascii?Q?Wee1xwvmWC/DBxAKbGU+6yRj4aDoqx96y0F31T3L1U2mNXwsKcp7J5Gf43RF?=
 =?us-ascii?Q?L++VxHsSNVp75iAb4AZtqjQPy1JMhrvqQm5urBdITxHk1QcZ1fBeM3e7mc7v?=
 =?us-ascii?Q?36rosuGLDgMcYDlfrh/q9s86RezatRWYWKVYftWOmMDDRtZtUsIonVGWYqry?=
 =?us-ascii?Q?if7uC+BHyrVo6BQivj+MFObXZP5d5ZMVXyK07OxXSAkvL786gADZtEjOrL1d?=
 =?us-ascii?Q?a8Oo4+QsJCUasnT6eJsL4IIkguRCufY3UvlUppIh3NtrAFyTNwKEyPkTD9Nc?=
 =?us-ascii?Q?hhmb45UAMGvstYnAIcE2nEk843xzsjgHZ9msl10YKASmA7WaNwKqcP+wEH2r?=
 =?us-ascii?Q?3kE/7bzR+s3xa5Z6CzHY/YCCMCvIhQeGKkFCxXk5e/RD+7ycMcsgp91t6uBJ?=
 =?us-ascii?Q?SXFpnTCr3zZS4b0x4VU3ZWzMUFqOQTUcSfZuZeCmcZNErNgzdQ3h4P7n5Lwj?=
 =?us-ascii?Q?RtmlV7cHybT3kz6zFarw4mk1+K1M2HwzNfmfXezGEmGwIHxRxLC5Og+TXt6m?=
 =?us-ascii?Q?urFAwukN7r6tGIqoUUo8JUA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR04MB8536.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?BHh+iB/iiVGwSdsheVKH24MpbqoMkhG2Ll3G9c6S56cTf3CQ4Q/Rq+h66/MA?=
 =?us-ascii?Q?hH1PXE7BPVtzr5lrT2CyAYY5v1FYhU0kTJYvCpmXl4WM3TZt7YJ6dSnqLnZk?=
 =?us-ascii?Q?QtxpMVG921iO/Q+iRdk1M4L87DgrkADZ28VE+iXOUDtrgv4fiW5+Bz2cP+A7?=
 =?us-ascii?Q?ZOGU308rZQUDyZsQPDOUfO3i00n6SyVUuNf5Z7xXkobCIycAl1gCgRam/uRy?=
 =?us-ascii?Q?YPRQU5Kg+W39vwuhx6wlrnT75tBnZudmDpmJBvR7D1I3lAOV4XXOMUqb0sTW?=
 =?us-ascii?Q?b6yhw9Q9qNoRFPbgUE/3QqoJiHbEx+2EcDWAtOvYwcPVapHm5AASkfGkB188?=
 =?us-ascii?Q?dt1xzGaHCY+N1IE4DguL6X6LDCNW2HwIw1wrfbt0dCrx2qbcwEOc/ML2FlJH?=
 =?us-ascii?Q?LchSCFkXz7ib8Of7c9euoemxdNHSBuENRk047wENsDSauD5LkGP84Tb/p90n?=
 =?us-ascii?Q?WO6HHVsi1YzO8m/Ij3ya+a6XreKZtYKlPUqowEl+3E44tmgrI5ENhtZS/r1h?=
 =?us-ascii?Q?MFqyFWa+U/1A2exzRcTJvJ0gONo2prFjX1Oayh3B8skahqutZ632tZ9+QDy0?=
 =?us-ascii?Q?HJeyZ69JO+vTweapPsOJjl/nlf0811dYTh7avol8kXwfj6lcztbpuDPVXVoL?=
 =?us-ascii?Q?+A9EBQwVzUjWoenUsKLrl9UTZOnPVQqk+aMWldW7THk/HJIY8d1TCjE2POFJ?=
 =?us-ascii?Q?FggNycjaSISJ5l/6V4aLb9QwvU4aqco2HpWNRr725lw/bTHntD+MqT5SHbc1?=
 =?us-ascii?Q?8KzUusduRnfzpBb88D4vkCRTtg9otM3qM3wTvTP0m7XxtELFFiMA+iUrwl6k?=
 =?us-ascii?Q?qF364FSeuHVkNqjazgudXHQ2sZ1iXqga1dKsYJAUYfdUmVIzB95RD+Dxa4ba?=
 =?us-ascii?Q?ych/eCht2lk62OPrCtkbgJlz1WDHUHA6non0MvteFCX4aL1kya81AhqqWJfI?=
 =?us-ascii?Q?sxetytWYuMSTEXFzv3kIcboQzb9XCg6HVoo/cTQ3E22o7rsvK0oWmtjQpb4F?=
 =?us-ascii?Q?UXOM6ExkTZ+5ZQNUFbqGPZA1LoHX+qH5coa1vezUccEgqrm9UNJjwL39I2sL?=
 =?us-ascii?Q?iQSb7zEMsoDEX2xlPvT9yYqFMK7ZDFV39s6gQVb1vfsvrl6on7+5sPJ5BcZs?=
 =?us-ascii?Q?e4T2VaUZJzRU+YPEQdJe1vOF+JFCA1Ulkcd4YGNngJayh+Pg81OBQgdfKQrW?=
 =?us-ascii?Q?9na/8ilbU54E/Xe6o0D3n7Lgo+q/vWDW7GhR4PNQnr/fETUGzOx2D2aaOBYk?=
 =?us-ascii?Q?hznglGxsgOs2cqUBcJ+iqOdn9UqquzAgyG3n1tw5slIZs8yOdetC1I+QaYYp?=
 =?us-ascii?Q?Ey14gGbRdU/UbOMTOPEVie9+mRSnO2Do6qD68BRu+iKFOZjxLrGVZiWecHLl?=
 =?us-ascii?Q?9eAN4b4H58uknv7CN2oBll72VanEy3NR2gsfbn8QS9Czx8tlnbf6l5kJcE5Z?=
 =?us-ascii?Q?0WTAC871+4y+MmVGYcBURuONDiLZ/uqtRQH6f7JuaQ8a3FIxRrGvRBwYkrxB?=
 =?us-ascii?Q?enWE3yHt/DWXDTlaaPl01qJiFLCmPzMUVq3/BA4HPUG/hBloQ9gD7v0RraiU?=
 =?us-ascii?Q?seI0AYq3kQeTus1gF/vD9prpRlSvKk+rSHbAx0744CfoPXH5kNdymrgvT1jX?=
 =?us-ascii?Q?epgXR2EZJB+PcvDtxs7nIAwUTfLBOPqhljsRPZxznsr+ZBvZmTPrnH/2wndG?=
 =?us-ascii?Q?CG3e3SzkeXaQazP5H/mnIO7h9/xouzEOBewtu6tqoPockuJJRYegf1gW2YoM?=
 =?us-ascii?Q?vEP6yflGWVJ63Xa+i95+XjlnTELd37g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8822CAAAF4D8224C879F4D20664ABA83@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uEeAd2cTHZUNwEbwQfDIDcsesAfzuLwaVUzAG8wT4KkE5vaQIKS4Tak4VQWjzBISEYrrXU3BlRNm2HQjZLS0/j88zFMMVRD5UGFizR4OFFe2BLlL8ZJ1JTWlIwd7wfe3HC7p7Rbh1mh475QC0tUu1u3fOTHBpyPMxlcoOBhHSujg3xmb1XoT/hH52ZNvXAO/4Uu2MdzJYUdXRtM1SA8kfxTHNrxkjNaWeJ/Rk7fVGnOD0GVNLjondfVDHh0OQDxiMCGC3fDKu8cuJjzx3QJRN6SdaxjdQ8DNxyZnOsYPjjOAg+vE4q2ka1XNDlcBiBZiXAjSPCtmDKp8O273zo5lKc/Gc1pUxtLUVTCxt9OYPuX5nEXj7w3YJ2CI1VAbQjO1PXF0oUbf8wCv5sS5dRvKH5o1Biy+j0iyyun9TbbUe4K+84owe6rNR4HRbKusbf4vWlKgGVRtqFiebES/sz6AP6dOrVQQOizMTwfi7slX6HLMr+04qmlfeColK3EO+Lrh1+eogCW+tuN+zSHV5uPyX6B9N3UjbVroPWAHgUWKaBzAc3qRR2rwfo1hDSHqDQZiDw4ec10AxzrT2K74IDPTJFVfx7UzfA8hN7dKGnvNue8047yDHUhSvQgbSj2N8MOk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR04MB8536.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb988c41-5f1e-4d45-6d84-08de5ff100e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 11:16:23.9382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L47wFwgGrjnv+9Ddj+YkK2YbzDQbaeOyq364qYgpx4P+PuYJ5EIyfK6q3blcI1WYF8lMey6Ni/9bVcWtKgkYFWM8kpgE1R2gmi81plO8huI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB9726

On Jan 29, 2026 / 15:19, Paul E. McKenney wrote:
[...]
> > > > I have seen the static-key pattern called out by Dave Chinner when =
running
> > > > KASAN on large systems.  We worked around this by disabling KASAN's=
 use
> > > > of static keys.  In case you were running KASAN in these tests.
> > >=20
> > > As to KASAN, yes, I enable it in my test runs. I find three static-ke=
ys under
> > > mm/kasan/*. I will think if they can be disabled in my test runs. Tha=
nks.
> >=20
> > There is a set of Kconfig options that disables static branches.  If yo=
u
> > cannot find them quickly, please let me know and I can look them up.

Thank you. But now I know the fix series by Thomas is available. I prioriti=
ze
the evaluation of the fix series. Later on, I will try disabling the static=
-keys
if it is required.

>=20
> And Thomas Gleixner posted an alleged fix to the CID issue here:
>=20
> https://lore.kernel.org/lkml/20260129210219.452851594@kernel.org/
>=20
> Please let him know whether or not it helps.

Good to see this fix candidate series, thanks :) I have set up the patches =
and
started my regular test runs. So far, the hangs have been observed once or =
twice
a week. To confirm the effect of the fix series, I think two weeks runs wil=
l be
required. Once I get the result, will share it on this thread and with Thom=
as.=
