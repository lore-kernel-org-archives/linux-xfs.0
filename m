Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3318B3AF66C;
	Wed, 15 Apr 2026 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776260042; cv=fail; b=OminSIlWRNRSIpvGuS/0NetYjrtb4fq8t1WMHSWK/jn8d2fNgScwJrKiFlm4wEpzxUkAPEHJuX0skreIkTkQOHnHi4s/2rFtIZQRhIZV2kHjrprIgi87EoMyPhKyc6VNhYZfin0njTBgNrOYhUIXa4zVURPJYW7JyKEhKlAhU7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776260042; c=relaxed/simple;
	bh=iWkHzp9WrCIiNIjwKNUN18e4jf8RGt4J405y2KHPGaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sN0SJxpxlqKc/MxT+6PAEBsMMc+zJWhlV62s3Ugo6wwEHNevi4msaUPfYEzOgFX4trSWh6TwPGCZPcrG1qAemZcslXc18AQz0TU/wY94I/El2iOrl+bQZIHx08jTAZNbH1TLtL6CplQ0ZtSUjYoKoiKWyJufXNd7x2ukUSDCX4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AB/fxlas; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=hfZumQJ9; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AB/fxlas";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hfZumQJ9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776260039; x=1807796039;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iWkHzp9WrCIiNIjwKNUN18e4jf8RGt4J405y2KHPGaE=;
  b=AB/fxlas6a+E65eQcQAc3MgtXR7m9KLQ5qWx4bqS1SN2vlkF2RDoYwbY
   yRbB+WJu/f9c+8EH+Qfhm7uwWzPhoZ0rw/2Evz6KJ6pqunCrioGpqbnWA
   i1NI1LffiP95sOo8Kn6stCdLPVEstuuZNKe4QLHiUHiB79aKKZvBxRUP7
   00ehkqj79WD6ty1rKAVXAlXOcHwEQu51pkkeHSEKBVVMjoYTGG7zSsthH
   3yXgpe+LhqtXSGnGmYbv4pcfp98e2oARooU4gHQtQGDQv2tfUrFPPNfdn
   JBaKME4xMRVyFmNmIiQrn2CEx/UrhGKXWViSwQcBG+Z3q8DTAeeSqT72Y
   Q==;
X-CSE-ConnectionGUID: fzIboiWxSEaNjSWJYAue9A==
X-CSE-MsgGUID: dyCdpW4gSqC33yAwRgu/NQ==
X-IronPort-AV: E=Sophos;i="6.23,179,1770566400"; 
   d="scan'208";a="144089448"
Received: from mail-eastus2azon11011036.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.36])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Apr 2026 21:33:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YhUKMRHjMPwVAwCJbT+0Ds95RGYCtIwFLGMcvfjHMWKKOsv18nUmAm6Zlc6ohW5lXNHj5LVPYYOGmZOG7XiVg9u+Zy9yl7oZcFeR4emY5NNdGaH1ztiiLoGPvdU0jdB3I3BDO/dmYKBYiJizwUS7CAO9i7kbp22Yu3j6EvgAUpHHRpoeZ7wgV9omuSl0FXPft8VlKBWyJIEJQfeZiaOy+xSDhQcL8DvH9+cVvGR4G4TH8vnewTk5yuN1eqHskOPrMejVdt78TrNFYgUA99wUNF7Km6FadmsQ9Q5IbFcKHHpmMccXhDXXjrIBg7ONIbMaWsIGAWqhOFw2VZJkW70vFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWkHzp9WrCIiNIjwKNUN18e4jf8RGt4J405y2KHPGaE=;
 b=kvQkAT65lxvYnawFwg5tORBPEKvgnj5MnUlTYwaJaxVFdSuBfQeHE3APjm3JBN5kw9UDze1Mg2gzIi2po6yxZkWyGlEJoGCKT+zLiMMDDzmm4lZDA7HXl4fQ0+S3vAc2OZ9cZLdjY6PdBiLlzu1QWCLkEC7DBkEtE7uqMrDQ1iP7jEmrK4BsOJbuzugXuUJDoyUcZOM8YCIHTRVR6inxPdfoUaeY3c7o/lmGsLZAmLOl2h59/YJeAOBjwoef1p0XxuvUPJBU3B6i3KIc8CIOG3SUUsflNC6ZIsy7sWewH1mvph6iYAZStpH5N/WROh47F/IWuejKUBvxEJ0kOtW5LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWkHzp9WrCIiNIjwKNUN18e4jf8RGt4J405y2KHPGaE=;
 b=hfZumQJ9G1RzCAmG4mMMbQd4cgbu/7TaYw5/RYmw0OJcOewHqFJYr3I5iURN9kxhkHDMovmrW9aG29//liYDgqwHr32ZQlI31ho2/hC61gyE9ruhKlrS7lvkB2esmoGpx+H0kFqWQ5iyGLJTLVPQsoh3rvYI37+SsVYnKq/w9fE=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB6812.namprd04.prod.outlook.com (2603:10b6:5:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 13:33:56 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 13:33:55 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, Alistair Francis
	<Alistair.Francis@wdc.com>, Carlos Maiolino <cem@kernel.org>, "Darrick J .
 Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Wilfred Mallawa
	<wilfred.mallawa@wdc.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs: fix memory leak on error in xfs_alloc_zone_info()
Thread-Topic: [PATCH v2] xfs: fix memory leak on error in
 xfs_alloc_zone_info()
Thread-Index: AQHczGjyxi/LzVZqLk2juGQXQm3U/7XgIDCA
Date: Wed, 15 Apr 2026 13:33:55 +0000
Message-ID: <9e8aa95c-1b9a-4a20-92cf-70e52f9a1948@wdc.com>
References: <20260414234513.1457961-2-wilfred.opensource@gmail.com>
In-Reply-To: <20260414234513.1457961-2-wilfred.opensource@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB6812:EE_
x-ms-office365-filtering-correlation-id: 60ab764a-f33c-40aa-d4ba-08de9af3a458
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 Jp3R6FXd/Amp+FgLlkggZVUAKLilFIiqeodxh0KUZrzRIhLp2eY/RmESjyVIuDOb7rtL5cZgCW59CmwqrswA6qCoPveQ6eB1tQJX89YbUyaVoprfRKSQ+0rqLCvu+fRkF28zxl9fg1xOqIi9vfZ7lwvG0izVuFi4uPFto7amCuMyqJ7hrNtNE9v0TKNEcDzlhPGyTBPLgREuSXpJUh+W/IUwFS1jQ3ZSZ7zgY1Ix3sxeXNUO5F5lAnOmGm9nmBN4sAUeXlI68isAI8LcxVjBHg499CIOuvSsH1y5Q/mFsX63GynJsY4c4HWPxkSv93Ci5Kd83U9w/I1B0SktMzgxBJGlVMnphu8JdMcpm+EIMFxVPFNuPMRJ/JKZj1aIxtdt0U0apn2tOLJD5cQctZF/bid1RfJaBe1mENJhBcoQAIQU2CE2A2X8XpdxW1avsdeISmHjvU8n2nmX962stclZpu+0MfV5R//2QCtaWurI9qkXmoy+11shuyd/rBmFTpU6SZlmEooR+q0c7idbkgGNfvEgHgFN/h0Rk3GoQH1Khmk2G9uLDdIW8vQf8QTy7KGOWOVtRXLke66OTCNbNJmUlmaLbRQSTkwjGtIUVIlzUODFGMOACDd7jElWOzcGLZZMZiFKmfBu/75MoDfjhR1ntM1qHreEkBjSrmnR+ZwSKz5IPtGdVAAGm7kxCUhNpRFVzkq4mU0tbGr0+/3jjB8es/GgdV3grLwpmpOy6H2yDQvB38eHsFB2VG+2MbF58eUWxF9E5sJygG7twDgquCh+IQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RHIrNThDV2Z5Wkc2VXRESmV5L2s0TG9HbjNyWlczM0lLTjJaU1E3cEV1SUw2?=
 =?utf-8?B?a1N1WjJJOCtZTTQ5SUoxaDVXVXRzYStOYmV0Rjk0aythMWlRV3VUdGlZL2JI?=
 =?utf-8?B?N2xYRkhCNWRDdmRjbVRXZVJsMkp6V1hqNDBzVEtwMXhVdEViTEpwNUJWR0pW?=
 =?utf-8?B?Y3YvcnJlZHNLNFlzVnVjcDA4cGxWN09Mdkp5b0h0S0pQaGt4c0ZhR0Z0cnZC?=
 =?utf-8?B?WjNGQXEvOHhZNGc2MjBqZ2p4cWFTTnMwRnZMbzFHN0R2eDlvN29pSDBaNXRm?=
 =?utf-8?B?cFdLSE4vRWM1N0p0dmF4VEl6NTdoUzhLcThPbFIzRnI2cTZrUCtIQS9STXMy?=
 =?utf-8?B?bk85a3hCYXJ0alFIN1dhUWtJRVNBemRSbjAwODBhVFRobWhTcmltWGtiTVNP?=
 =?utf-8?B?SloxMlRMek5CMkNkcWNRb3dZS3pJL3hDcEtrSWd2ZnNRM1VDQk1paktNYXBn?=
 =?utf-8?B?U29rSkRPM0dKdWFCNmRHQ1F2aGpRME1abUczZHJrUjExS3VmN0F2eXMzNElp?=
 =?utf-8?B?NUk5ejVKejFQVGNwcWxScmxWU0w1TjU2WVlGcmNiYjNEQlRqR2I3S0twWFl4?=
 =?utf-8?B?N1VFQjBLVjZNMFFBV2gzb0Z3NW1kNGRXOGFnRUlWL01xc2ZZZGxMQWE2cXc0?=
 =?utf-8?B?SndId3hNbll0ZjF4MExhRUVxVGRHcGd1NnJGakIzSEZZelg3UU1hQjlzbFhw?=
 =?utf-8?B?Wk1LTEhUdTdTMlN2dlhMTmIwc3VvUG5QdWhPTU9GT0Q2ZHlISkdldTV6TjZB?=
 =?utf-8?B?akY3bTVGY0ozeHBsMk9qMGhvbmtlaWx0S2ZGSjdja25yWCt0MWtPQWJHRnZR?=
 =?utf-8?B?RGJDbWRPcm9jWWRPZ0VHOE5keTkza0FmSUplNnFvUmlrU3RBZzYzaVlBUjg2?=
 =?utf-8?B?dVNxdXVBbnROUDFDSDdaKzlVamFWYjYvRkZ0NVRkb2FCVm1hSkFWUjBmWVBG?=
 =?utf-8?B?UEFiQitlOWhYUTNENGM2N0Z5Q3ZRWHRkczdyRGNUOXRrT1RldXlJZjF3dmFj?=
 =?utf-8?B?VDI4VEpVM0ZkRXVzOUR3VUFRQnNFenhYejVOK1VFWVBxUlFhQWdmL01sUEtK?=
 =?utf-8?B?WWh3RmVYbjFkelgvdm5YSmVzQ0hPRTdES0JxcVZXa0dVak5SRmx3cXg3Sm9k?=
 =?utf-8?B?OWZmWmRVTlZQdGp0dnNMMUZPSS9TTlpVdjVQeEtYb3dhaThPd0VhR0pBOTQ5?=
 =?utf-8?B?N2dCS3NNRzJsdFNYWXVWajF5NXlyeDIveVpZYldGU0ZIRXFEMEJyeGVTQ3NW?=
 =?utf-8?B?YXhDM2M4Tm1PNGw5cmovcVM4L1VDc29HWEhxS1Fjb2p2cHVHQWpsdGhGclBC?=
 =?utf-8?B?RE0yKzNSZkVQOVJkR2hHMmg1cUNxc1VSV285czJzaFVHazV4UHlWa28yUHRM?=
 =?utf-8?B?dGZNa0ZKbnByQUNZSW1CZkxrMEFxQnpoMUM4N1U4emY2dlc5M0VNeTVvTjBr?=
 =?utf-8?B?TzN6bzBGb25GU0Y4dTVzckpxYk0xMldwNStkaElUTnp1OWRrbGVjb09TeVBZ?=
 =?utf-8?B?UEs5T282bjJFTVEvS25oNVdINE8rSGdralBrTlAvbG8xZmtpQW5zNDVLKzY4?=
 =?utf-8?B?b2xlenpxZGRHNk1LMTBQZlhNOHVaZEVoWHpkVmp5QkFjRHBMZmtlUHFXajJ2?=
 =?utf-8?B?THVFaUZSSUxaako4TXVjd01kQnJzbm1KZG9oN2pTOEd0TFNxdVhXS1cyK1lj?=
 =?utf-8?B?T1ZRVmdSdkh3TmtseENRakgwZmF2RWhRcWE0OXQrdWRVMzJLVnI3Z292WjNK?=
 =?utf-8?B?TWU0c3hmcWdvRWZ4dllGQkdzSDhpelV1TG1LVnk4eDRINW1aVzdFLzZkWDVw?=
 =?utf-8?B?UzJNNFhldHdnNHFQN0YxWXo1alZyekttUTFFZ256R002cW5DWk9VZEtUaXdC?=
 =?utf-8?B?a2VidUt1OTRIdzN1S2FvMzMxOTd4c2NZY3Y2b0liaHZrUG43cW50MzJSUWhh?=
 =?utf-8?B?L0hxTjlKYUVFQ3kwSjBDSlVzNTZRSnlaUEhlRDhDZG5YYXVRaDZ4Y3JFQ0NV?=
 =?utf-8?B?eVR5L3VJYkplQ0xGTW5GNS83K0ZTd3dHOXlPMjFoamVSYlVCdWdrcGFXcVR4?=
 =?utf-8?B?Q1ZoMGh0WGFWU1U2WFVNMHRCdERSblF3NU5YaFZQSHlDRG0reVo3cUtZWDhZ?=
 =?utf-8?B?dkRRcTNCZll1Y0ROeEJjYzlKM2lLaWhWdjRNOEtVMjJYNEpvZ1B4SGdLT0dG?=
 =?utf-8?B?MHpYTEdmWHNpbXlTSWF0ZmErMFVITjdRVGlJVTAxdm9WSVJ4UHBwRXRXdzNG?=
 =?utf-8?B?bUxNejZFRmdsVFdLbkhMeDJ5WmIrdEo0ZTBPVFBFTFo3Q09IRTVuSG4xdkY4?=
 =?utf-8?B?SHFzcm4vaVo3THlZQjV5QktHalBIeEt5d2NFaHI4VERHN1JxbmpvZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2888E725FEC31498A2B936EB6E9C371@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	E86OF4GME4pW2qISlPiNxsrVtLjGGyQl0napGVHWTOkCHfUNDA7CGSczfzdCVX7M4mC/G1q7/s5Qwnu4DxmsWfVZKD7dnnTbsUShWB3FTPypMm2EH4dhVBtCxfwJpKOv3bF34gJ7X4EP6hmNclPvLD5/72VyBSAd7Vg4EFloWlHyqhomm5p9SJidfd9VBOABU5GUspnaiA0c6E1d8Oi+j5g7EieKD4TzB6f4gYpcYN8wDxoWLTvZYzUuTCfj5R4UtNC8ApdJdEHvgtcu1OBUOM8itjkS3/9UZ+Yq8VdRxirN+a2Oc6Ee+ocMhdyCdhb66UQPz0Ef+vHx16sgpSVymA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a5nF2MDxITOWYr1SZyJ6+a29+EAUIRar9so2855py3dXG1CAH0iSiUyUbAJwQQdXc03ikw47c4a6A1VwZN0Wdftgm4Xxg3/i9QNHHAcPGO1GXRlAgnyjvH8lHjruUU9gK7/WeZLHdkx+SR40L7focJSrT6EWUKkdqhxSQURs3r4IIQm6FYRtS6LRz6y+jUTjjY7hoCGfdKg+KLBHPplfNY13hYhDFDHaszEXNJ2wmD/D9Rxam2qEStpKgNc4zDIlh8D3jbC8C/pvp981N0jDrJuQBHZpnxy3iyRHivE9WA317TyYFKThYVx1mzFNxUjANmMoJC92G8xf1ziB6Krp8WfZAmI3AHPeiygDfxgz3fWpB55a62vkcNcBf3dunoSWdtpqajKA+uk4JTt2UZaVrm51SGnjSWWGvjYqS/acPb15x1KN+aCOoNxQRCL3ZE3PWwg4/qo9w35RjpnHwepeMwYvALhJXAG1VAdx1w8nbUvCcWLj5e2OC0qvC//REPDUbvVQyKxWN4MLEUuBzvdlk2X+QXmvq7oxARPEgwjQorC47eE+NEgBuNWoMn7fEZlHKYGkWj7DiyuSWIEQihBfYms1rMLSE7YDfJMcf120Sc/MCBui4kCH0+Rkr9T7cxpn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ab764a-f33c-40aa-d4ba-08de9af3a458
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2026 13:33:55.7621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: msVJdeGpM4C4Q3iBGXpNRR3vomtFWI9E4RsqZq3Nu50xkNkhTPl9ISg95GviPdXwozrzBAuAwYc+UN8OmYgfwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6812

T24gMTUvMDQvMjAyNiAwMTo0NiwgV2lsZnJlZCBNYWxsYXdhIHdyb3RlOg0KPiBGcm9tOiBXaWxm
cmVkIE1hbGxhd2EgPHdpbGZyZWQubWFsbGF3YUB3ZGMuY29tPg0KPiANCj4gQ3VycmVudGx5LCB0
aGUgMHRoIGluZGV4IG9mIHRoZSB6aV91c2VkX2J1Y2tldF9iaXRtYXAgYXJyYXkgaXMgbm90IGZy
ZWVkDQo+IG9uIGVycm9yIGR1ZSB0byB0aGUgcHJlLWRlY3JlbWVudCB0aGVuIGV2YWx1YXRlIHNl
bWFudGljIG9mIHRoZSB3aGlsZQ0KPiBsb29wIHVzZWQgaW4geGZzX2FsbG9jX3pvbmVfaW5mbygp
LiBGaXggaXQgYnkgYWxsb3dpbmcgZm9yIHRoZSBpID09IDANCj4gY2FzZSB0byBiZSBjb3ZlcmVk
Lg0KPiANCj4gRml4ZXM6IDA4MGQwMWM0MWQ0NCAoInhmczogaW1wbGVtZW50IHpvbmVkIGdhcmJh
Z2UgY29sbGVjdGlvbiIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFJldmlld2Vk
LWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGxlbW9hbEBrZXJuZWwub3JnPg0KPiBSZXZpZXdlZC1ieTog
Q2FybG9zIE1haW9saW5vIDxjbWFpb2xpbm9AcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
V2lsZnJlZCBNYWxsYXdhIDx3aWxmcmVkLm1hbGxhd2FAd2RjLmNvbT4NCj4gLS0tDQo+ICBmcy94
ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9h
bGxvYy5jIGIvZnMveGZzL3hmc196b25lX2FsbG9jLmMNCj4gaW5kZXggYTg1MWI5ODE0M2MwLi5j
NjRmOWFiNzQzYTYgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+ICsr
KyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IEBAIC0xMjE3LDcgKzEyMTcsNyBAQCB4ZnNf
YWxsb2Nfem9uZV9pbmZvKA0KPiAgCXJldHVybiB6aTsNCj4gIA0KPiAgb3V0X2ZyZWVfYml0bWFw
czoNCj4gLQl3aGlsZSAoLS1pID4gMCkNCj4gKwl3aGlsZSAoLS1pID49IDApDQo+ICAJCWt2ZnJl
ZSh6aS0+emlfdXNlZF9idWNrZXRfYml0bWFwW2ldKTsNCj4gIAlrZnJlZSh6aSk7DQo+ICAJcmV0
dXJuIE5VTEw7DQoNClRoYW5rcyENCg0KUmV2aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMu
aG9sbWJlcmdAd2RjLmNvbT4NCg==
