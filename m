Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4115325E81E;
	Wed,  9 Apr 2025 12:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744202403; cv=fail; b=W1AagJwMM+iHCjhv0L8dXo5q5S7QslQ85aF6NVuAROHi+F8nC01kBJAm85/3BSO4v7545Im2vobZ3oVpTfnpDczuNo46MaE6ZYE60PCkHOswitH4O4WfPhA/Uq8mRizzWQ5/JNb/oT7S38R3iM4NDJNsbDLm/nXeIXGkPgHQ+Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744202403; c=relaxed/simple;
	bh=Uuw9Qjzm7SEUlfcbd7/cF3jCwFEKzKCZGlzlhrFmE70=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KWGtmHms46lk45mmrUQvP+J4uixwYHDNrp1ibWdHUdjV/aVhhe0x4b5PeutuSFZ7K3GiFUXW73f7uugxb2yaTrEnNhxgp+vSxY4IRb2jSnsRVpnk4W4nJFQuh1qmTz+5TIiUCJBaGzuaq98LMNk6mHKHV2yinMTDmFW1V6UuiGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cdzlZ1wN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wa/6IHao; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cdzlZ1wN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wa/6IHao"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744202401; x=1775738401;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=Uuw9Qjzm7SEUlfcbd7/cF3jCwFEKzKCZGlzlhrFmE70=;
  b=cdzlZ1wNSsSA2FqTUQKAia6IrZQXLOJ3j9hneNUsy3yJv20yyxDt4v+4
   h39axunVZmhiztb5ixN6qHg19uzNv1/mpShhIS5ZlU7adXGf0epih7ESY
   V7s1AYAQdhvmLRh8s2Ex/G7kRiNgnvKis4sP3vusICCX6cIZQMFS5d8E5
   VX6f+haSOrioQymb0sf3wIonzSDSt7MkPtHFZo4RO40rwcmWMxRXH9YGP
   oZzMqMSzFoJ7ww3KxnlVe24gROO7S9Qyeo12Kf/oPNzh1eRT9PPd8jsTA
   ihxHCRwS/n9QBBFEhxmZx3pIOt8BWR6gB8bNEA/mQzGITFXPLYcA3KmDQ
   w==;
X-CSE-ConnectionGUID: 2IZ5mQeLSzaN7mD2TezB7A==
X-CSE-MsgGUID: eNFIpH4ITF+aerPpbBCutA==
X-IronPort-AV: E=Sophos;i="6.15,200,1739808000"; 
   d="scan'208";a="74855821"
Received: from mail-northcentralusazlp17013058.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.58])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2025 20:39:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nV2f/tPZGf2CQPslvbQLxCj0tkXSSMT+4rNiQO6/e2zuCMb+qHsHaSwd9v64FZ+p1tqa29eVu8pZz66W58675dMDi45HnO0E7R2/1zhISOytW3I7zz8WMf5VGi/DIbzkR6cXSuagMdftEZeJKOksok2THhoy6YE5J4B1RvfQIsSxHR0XDCOW3HGMgF9DosPvAkxkuBSzDCvz4joYBwPaV92ClSoGleIK29RvjnO4U9cdVCxmoSiIQzyU/gwm+ZNvYSUcBjrEtdflN8x7O1iRgRFzcd4JJsjdvr+frDcOFQ8ElsIU2aYVDgwM5EQcj7aPDPsFM7LsRaMCrgn1y/RLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4/VFZltjTLpv+POtDPkZCkkhfgKdNMydWP6PzMUcJA=;
 b=GVcYXz4lT3MxLpaTNBsTqE8LAABwgv+KuF9QLuOTLoT+EeKJHRlIvah/Rtee0WzXPAkD+qjzSgvGfP9dJMPwLYHmt572pIJ8kkeJZzj5LkZYsLqpJYTWbCWh+nGWNE4JwHzMY2dG3RDL2uHqEmc4RzoLHh0EnAFcvf+WVwy2CphVXQs0AMjgXL9C9dW2NPV4+8XCkr/y5nX/f4P/z3MH2g4S4cN+WG3r7D7gZwkQEx9+QUD9EY59eTcNsE+FM+N+9s+/B4W0ObQhfRhkUJGe7rSbAL2EHpFjgk5toqXzI+RNTGm1LXhWv06g/rM2XCpFrnWaNa0RgW0/6vS5ym2wjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4/VFZltjTLpv+POtDPkZCkkhfgKdNMydWP6PzMUcJA=;
 b=wa/6IHao912m1hOoY+HlyGlgvIPnQopSMgjbDzYtDWmWaiPiv87hFj2kNKszegtaIJmBKVXi2xGcfgK1fRDivi43nS2OlccVH3fCSDucqg4/kyxqIZsZ8xt7ZPrG/tYMsV8dwUO8bkd8Gd+lR8+ETCr6vJ9gNn8g/FkCTnAxLhs=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH2PR04MB6919.namprd04.prod.outlook.com (2603:10b6:610:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Wed, 9 Apr
 2025 12:39:56 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 12:39:56 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong"
	<djwong@kernel.org>, hch <hch@lst.de>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH RESEND] xfs: document zoned rt specifics in admin-guide
Thread-Topic: [PATCH RESEND] xfs: document zoned rt specifics in admin-guide
Thread-Index: AQHbqUx/m8FDxyqr6kWdIDK3smxFuw==
Date: Wed, 9 Apr 2025 12:39:56 +0000
Message-ID: <20250409123947.14464-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH2PR04MB6919:EE_
x-ms-office365-filtering-correlation-id: d9aebaac-266e-47dc-0ee8-08dd7763a225
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?hoUeCmw5GWVJwZ3Y+1fH9vpHW6Sspikv4u1Cl1GCiN1ckxkzoUtJQ/TqVf?=
 =?iso-8859-1?Q?mKPwfgyOutkGE1aJ65HU6o8ZunIiY9diUUeJ4My8XhqcVVDxNIa/WpnlME?=
 =?iso-8859-1?Q?bN1JMNbhypeeS6lEZUpooOdxdboZylJMAFexW8piHlgRw+FdbjdqucUl2F?=
 =?iso-8859-1?Q?KqaCkMBbN/IgymYgGaJ9qwt5ZWGGACuPZ5qenuRWxlzKxJzryiqlw6d4MG?=
 =?iso-8859-1?Q?eyKwspEhw1ZZlgWlO0yFaxtixc6CJbCEKdvO5QTLPa7QN4tbJhUYgyxlyI?=
 =?iso-8859-1?Q?t3CMXSmqmAYqreeDuYRgvD8mAOPza/KcmceqvJw5HuSLDSAen0fBREQx6O?=
 =?iso-8859-1?Q?BKmKtG0ljwbx4d2KjqJ3DK5ObkaDMA0M/qzTyzX2sKNmPwBRd2wPVrmdPh?=
 =?iso-8859-1?Q?JeHcseBCfh4l7OSv11DQM8Hi9AojYJMVYI2eBVP7ItTH2GhihmxUUGl45e?=
 =?iso-8859-1?Q?d+nnn09tQ+0rcJV4GSWyWMCiSIwaiv7ForQrzyEY/JkWRxIgc3Fv2VYOpR?=
 =?iso-8859-1?Q?iFulOoT/TSXb5n1hcAY0U6r+qd0zshtGoEb/iwGcRMrhWF0E3o/3+DYy+g?=
 =?iso-8859-1?Q?HGV3bAxfgiPCZshQXAm9DcsJoZxTDaIIZdApLichVn/q49pCUSsx5dIvgL?=
 =?iso-8859-1?Q?v22guysWtWhZFliw2Sj21iOaRblMEaYxpS4r3A+ax9eQBd8nxHkde5BYcR?=
 =?iso-8859-1?Q?onBWVmmQnrEx8hmBZJv3k3DZTJG7jfr6K7f6f85FOb4nGsWfDpO2B/Rv0L?=
 =?iso-8859-1?Q?/mvPcgSMi7BDHFU1JWCERX5ZBks0w3mgQYqPbiZMjizYojI6gEinTs0Dso?=
 =?iso-8859-1?Q?Pl7Ll6FAnbPUQ8FyNyaEQtB1yzct/1//zXdGbyytGpMBq7ckRerxkjX0Jo?=
 =?iso-8859-1?Q?R/Xm2uA5q/zDp3+QJjCI75EBmRqR36kzUujgsb3ZKeyKxCmWRCE15ZKzUP?=
 =?iso-8859-1?Q?s0ng9jrsPxOBdNlj4tSamaG1R/hft0M65aYJ/DBBvTo6B5JR//gvrUMHH5?=
 =?iso-8859-1?Q?g6giodsFuMvWBFAMyQiSC5FKQJeRPT/DnzZWimf3do6P3QgV8Zr8MYkpln?=
 =?iso-8859-1?Q?wt0Q9gY1ZTV5Duw0L/4Ymt0wHpPGEhEPSXR7CCQ0EfW5/WfIlWRfZnaEpy?=
 =?iso-8859-1?Q?MjBCNocQUs0XLziG2FDeesWUvlo5TTkKomNNJMU+zwiI/U+DjMkqlKpec4?=
 =?iso-8859-1?Q?lLqEPVDDRCMfiaRFnWpa7Q7kAVNJA/OUiQWZ5ZeZUfz8UBqaVnOhpL11bA?=
 =?iso-8859-1?Q?/Ok1Fiul3ufhGDK7zxQNUHIdoD//7RiWzGn9LwdhPPtS/+XPJsyEhgg3eM?=
 =?iso-8859-1?Q?MNbYsC2biqelac4IjMSveMKItpQzk4PWLoHMVe1bTJCcCwLb0hU2X0aRsi?=
 =?iso-8859-1?Q?bgebHNlU8D4YQyjAklrsChCiLuvZZDzO61gwVqwQiO6Bxu+GqqNpPDQQws?=
 =?iso-8859-1?Q?YfXIAeyNidoazwItMmfF7fEiqvStOvNrLiTpXTnJhJyVR4thNLEBGou6RE?=
 =?iso-8859-1?Q?X/Rq/v4pPSqFDJphqZ125R?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?9Z0v3QfKBUiyvVIuePFPyNi+oCek4Z6KCVwzYsLR8hXQWZBapsuNCX4wXB?=
 =?iso-8859-1?Q?8Pf4ctVLNup6Q9GqhQ1lKD9p4qAkBZZcBq3AhxZ2+sjuomBwpFlpDhRAjn?=
 =?iso-8859-1?Q?3mXDjUHknQxYqzOn46ZxndWgMA+IPdgwo0FaEvhDBspfKK+v7VDsSH4mOb?=
 =?iso-8859-1?Q?Zo1rVfcvRjFzqVGIV2P/QpAsHGEF25fKd4806Zt9t3Y3J5p/FUh9WmPxea?=
 =?iso-8859-1?Q?SRlcxEJEaGcE6m2fR6GXewWC8FSBM4nuxGr/wnel5O/ctZEtc8B4QESzNk?=
 =?iso-8859-1?Q?eeXW9wI8UrX3Rg1v0wNt964FyL8kkzJSZzCydDBo/a6D7hnSzQfp0tYdMo?=
 =?iso-8859-1?Q?wou4ion71jCe6iUH8PV8IVYYoZ1y3z04K+tGohMy6UMeK1Ab/Am4Xz5S+v?=
 =?iso-8859-1?Q?GH8usYlz6A+iBgLdizGb116hGe0iWYojbwssB9qYbO/NF57Z1+3SeqKNwU?=
 =?iso-8859-1?Q?02gMvHi+OImqBxsVjRa/s+FQWIsY6w+vyhHjIzP7QnqsBbxRKWY0tuicXz?=
 =?iso-8859-1?Q?QY5EB5jcIaVbOwoogExdZzbIg/9OIKEgmRVpbMqy0VSsAk78Bn8nJSDi2U?=
 =?iso-8859-1?Q?WylwWx00i6EFYqHZ6wzaDQ6qzZa9cOxIOvndkpkP7AIvTfSvPKza4pdA4d?=
 =?iso-8859-1?Q?cZzAD2taMZ2BNkG+9OuxkCxPZihkyxiA7Az5xC3LTDYSAd0vDEsPpWNFew?=
 =?iso-8859-1?Q?XTB7t65jpbB7ZneyDWfp9boSJXDrMWBYyezMkel/zS1WBRlZ7Fl0H7QvPr?=
 =?iso-8859-1?Q?d7Srz1w9F0h1Vq9YNiciACpDfik7JTdJdu9RZ9tdF/Yw0UgoZsjpMZH0en?=
 =?iso-8859-1?Q?8mbT3sVVMzHhM2lKH3q8OGPEWxiEwZqtDte0n9X+JNcpN3A/6zcqqneVVF?=
 =?iso-8859-1?Q?Mf2TsT6NfO1nkyCFd1L8JRk787Ge6Xa6YRS6EyuhlmXAg5zzs7lHMF8faP?=
 =?iso-8859-1?Q?1MCNPwAGL9ffs+KsXwiPcuvgz4d+VYKqCt4WDtsQ9EZcS1NgFutY8hkIgv?=
 =?iso-8859-1?Q?Wn1LgPYExFT8SZjld/Hy7QBjA2oSWR9qO3mvVKqJymzx6MLLfq7ShtnwJq?=
 =?iso-8859-1?Q?4yi3aD4huG2Za6+Yq8QLLV/btJBPK2i2PTj6VMwQtxAyBLlwme1z6aavok?=
 =?iso-8859-1?Q?FO+QsLR191yt38Kmm/W93KWNK+iMdNYzfSHOt77/7SCdUg518DE7+5PP7j?=
 =?iso-8859-1?Q?gIhDEnrBRM1O6wQdxedlZBBXIkKM8Nf6eBhHjjMcz4ubMtHPHctzQQIJRo?=
 =?iso-8859-1?Q?v2u1I1qF2mvr4FscFgumSE7tcy1JJ4R9t8FAbcHbQnlvwpFWSc3OPiRdsY?=
 =?iso-8859-1?Q?bqVRdhdgAgSUWisFbMpCFbdAyXjPXAjo+MXGec+lLnf+YdYAe369MxHdyh?=
 =?iso-8859-1?Q?mBjkm8eDvguMmIf+hJHLzfF6R4JAeK+fifwgCxbj6GNbpA37iNVIiUYIug?=
 =?iso-8859-1?Q?swhwIZsZxWACRpoKJmdObFviCFcD7KeipmRXkAKyfLm+0CCCRf/a1RPEcT?=
 =?iso-8859-1?Q?1xyscKe92DNReBOCqQZPs9AwykMeiChUh2/CsZaAzvnt1FJVo6CbNiuNwd?=
 =?iso-8859-1?Q?bZYVfAqZtx5ZU2M2wt9pMdB0A56zjmQj83GGeM1tFIZhdmrhJDzfxMv9U+?=
 =?iso-8859-1?Q?Itnx2JeYmXwtavrL4xYSDqKl55yV4/6vUIeg65nt0rUpNHLnES2YDfKg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/J0BeajRey0PziI/kFRKmwr1bjbbXYpTti+OcXmyIAoSwoVkw2WjJjDI6lT5qFKN9cwHfmEsQsM9WWY2A2m4TRmLoFyoxBLVkHgfqEeS2erwVGgtQke8GTAOho4n9o+wp0OBf33FvXdzuRJl5Kyn+5ahgFxibv6ZmprCQFbAPdx9+U8XLm1RzAPmOJMPZxh7fAglYD9+lt5QsioYCafbmhcxz210t+152V3bpbLHSwuDUeRwpwtljgzwT+OyNB4bbw/Ph9hPOsZZSGDd2cgrxTb7EG9vXtJlSTWij/CLg7RZ8bB0FvxbdSgwenZLc/vWsuTaNsTwehUs19Qeho1lJ3B0h3z74pd5GHBbnN471gyKrc8GDdbRq6ZooJOiddaEmlnUYSTQgnu4ZNR1Lt+gfh7t9iGdzLh9exIibDfDDuqVm3dnoIvjhf6DIpmXRoI8P4zgEstbclBWXnm4Qkzeztj/ohV5n/uKUIShTurnabTHvHtmJn0eMHfZhYvMFd/D9t6HPEqKHkQeRz9Wp9YFFXhc67ABCLfgfvQogmVovjLxSFf+Dy61+ViH/dOT4SJ/4qTH1zNP34eXku1nnJDvZrwD6oUPpDcGDy0Zp+HRX0pfdw9obp5HefxyVc+4Akt/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9aebaac-266e-47dc-0ee8-08dd7763a225
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 12:39:56.2147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLqNEUvhAOMjrp1miklV8X3uflwD81YOSU1MQ2Tl8AzYvWNcHQiPFoBy43OwTy222zLPFdjWbhri9AOcQ/vLCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6919

Document the lifetime, nolifetime and max_open_zones mount options
added for zoned rt file systems.

Also add documentation describing the max_open_zones sysfs attribute
exposed in /sys/fs/xfs/<dev>/zoned/

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

Resending this fix for v6.15-rc1
Added reviewed-by tags from Christoph and Darrick's reviews.

 Documentation/admin-guide/xfs.rst | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/=
xfs.rst
index b67772cf36d6..c0a0501b610c 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -124,6 +124,14 @@ When mounting an XFS filesystem, the following options=
 are accepted.
 	controls the size of each buffer and so is also relevant to
 	this case.
=20
+  lifetime (default) or nolifetime
+	Enable data placement based on write life time hints provided
+	by the user. This turns on co-allocation of data of similar
+	life times when statistically favorable to reduce garbage
+	collection cost.
+
+	These options are only available for zoned rt file systems.
+
   logbsize=3Dvalue
 	Set the size of each in-memory log buffer.  The size may be
 	specified in bytes, or in kilobytes with a "k" suffix.
@@ -143,6 +151,14 @@ When mounting an XFS filesystem, the following options=
 are accepted.
 	optional, and the log section can be separate from the data
 	section or contained within it.
=20
+  max_open_zones=3Dvalue
+	Specify the max number of zones to keep open for writing on a
+	zoned rt device. Many open zones aids file data separation
+	but may impact performance on HDDs.
+
+	If ``max_open_zones`` is not specified, the value is determined
+	by the capabilities and the size of the zoned rt device.
+
   noalign
 	Data allocations will not be aligned at stripe unit
 	boundaries. This is only relevant to filesystems created
@@ -542,3 +558,16 @@ The interesting knobs for XFS workqueues are as follow=
s:
   nice           Relative priority of scheduling the threads.  These are t=
he
                  same nice levels that can be applied to userspace process=
es.
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Zoned Filesystems
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+For zoned file systems, the following attribute is exposed in:
+
+  /sys/fs/xfs/<dev>/zoned/
+
+  max_open_zones		(Min:  1  Default:  Varies  Max:  UINTMAX)
+	This read-only attribute exposes the maximum number of open zones
+	available for data placement. The value is determined at mount time and
+	is limited by the capabilities of the backing zoned device, file system
+	size and the max_open_zones mount option.
--=20
2.34.1
