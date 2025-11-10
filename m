Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF52B6A8D2
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 02:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762742494; cv=fail; b=AEgw6D5Az4HpJBGQmFuG0tZ3HE2FsK9wO3EWPQGdJQqxFpECukezLuppkgMSt+qIw1iYvrrAXzzxGXvqTKdyM3dxhdIJCLixhUtXtEsJWxNATBTnXpK4zTSvlWs+4FMPTqjAmTnBN3T3FT56i5PhygIPIQQkgzxOKHrSKqKUknc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762742494; c=relaxed/simple;
	bh=il1wHMYesuMuQwBKGX+Vxa0IBf/IWylXp7UlAHuEe0s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O+du2YBi6YiZPJClQeRDpxgR+w879F7W3jGfyXl+qCvaFdieb1IEpd0nI+rIZ58O5KV+2bh/a6NANd6+OZ//+Nw1tiP4PGVeULQMVI1kT56gssGhV+xXV+VFZ/N1J6gDDMAdgJwEtfsacymfprmPgSWUwAjjcEv//UbR2xV+M/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Okhb/Uv/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UZmeOoNl; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Okhb/Uv/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UZmeOoNl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762742492; x=1794278492;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=il1wHMYesuMuQwBKGX+Vxa0IBf/IWylXp7UlAHuEe0s=;
  b=Okhb/Uv/zgCk/ebj6L01RNCSsXLvKdPd10mmp+3k/cYy8CqXnm+Ob5/U
   hp44OdlHrXzg3kTrtblBkZTfhnfshec7ePAAYuPSQweYakEVRJkm7Mgui
   WVqYyTJv1/bxDS7wYgaDUR7cAEL2jVGPOsJ8UXT9Ybg9EoNdbYn3s8YiN
   2LggMROyk0HBh5KAgRy1zwMHYXREqeRg4FFN+LW/M9EXbBB0l0I1Brx6A
   8GhV/0dSB+Wg6weGSPNkOV+j+jlX2tVWxxgKEiVGOqofaTSrBSeDsQhG7
   9WFRa306/z/NeCKDk/YZqxv9mkiUqEkMt5o/lxPDfXdsocNCagIQZQwQ+
   Q==;
X-CSE-ConnectionGUID: myysrVtkQBWEMojM4Wq2+A==
X-CSE-MsgGUID: 8DWX2Y5dSQe2+ilo8smpuA==
X-IronPort-AV: E=Sophos;i="6.19,292,1754928000"; 
   d="scan'208";a="136108710"
Received: from mail-northcentralusazon11013002.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2025 10:41:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUK+2ip8QrYy477RiFmekWmw4ZWyccZa1sV2zzlIRwmnGsIaxv4So3gVhKsZ2sd49C+OlnOgU1axvDdLCQdJInEYOpYd6ofj2Rem7eaTdN2AF4SMR9+h9aCFZBlfeQFPiGfDyBBJQjrY959fRggrkTD4CTSrFI/05of2fYa/qmofAX8z20b65IX7sSjJnPfppHe7QxHdJlW4hhx9h2VoqUNTj61pLffpGGyfW97SCA8ZU5fYKk3UcfbPpHq46AZEcsVVmMRTckgv5qpHR9EYsAoyw34VeDgnt3jxkTaKDorJA2rc+0/C7ba0Krp0pxloEWnq+nhLYFnhPveeny7gVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=il1wHMYesuMuQwBKGX+Vxa0IBf/IWylXp7UlAHuEe0s=;
 b=jQaCbmO3LmYEbrEnH3KtN/GfJWD0MqFdC99MC02vrG4IvWLHKdlRTevpgiFWIWHlUqAj8XGQBT7dzkUFhQizgUoL1Dh9ZaGmXQ6rlVjgPmgjkvQjOjpjCwIGOv4qXWNMzNJjWePSiY8UL9w9SisoZEWDPdNlK5GYoEegBoJnHlWQGFde5NYxQM/c7GzLwsNCXjlF8lqaG+J4o3IdDUmbh3NFWSYDqKUjr2DcewxD/69qSFdHFGwWPK8u7sxNGAGhWJEv0rMbjN75SbYKelX+sWHfZG/mMd8Rw7WnScFvI6X7W5xIsTdE3LZ0hPI/6g0gjm+qSiB67OXmtNeOUe7lXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=il1wHMYesuMuQwBKGX+Vxa0IBf/IWylXp7UlAHuEe0s=;
 b=UZmeOoNlEclIeVY20QHZRt8/fYTB1Nqd/AWygmiAJMXuKZqYobK0IwaOJFPNI8U2AN1+6DYd0QQT3hn9izeq5k5T3BPRpRQPuyeRO5IA8J7URybn7Q7nx958NveVhib5Ej2NBU8AlqmIp6JwI5oaEqcb9UVUJ4DNh2OdRniyWoI=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by PH7PR04MB8662.namprd04.prod.outlook.com (2603:10b6:510:249::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 02:41:23 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 02:41:23 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: John Garry <john.g.garry@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [bug report] fstests generic/774 hang
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index:
 AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYCAAG3sAIAAHemAgAAgzgCAAUpDgIAACXaAgAEms4CAACHEAIAAF6aAgAB0CgCABA1SgA==
Date: Mon, 10 Nov 2025 02:41:23 +0000
Message-ID: <hc3y7n73vyxrbbvq2wss6lki6bhrdxmzwvs57w6aobfkuuadny@t567xq7xvgm7>
References: <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
 <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
 <coeibafpki7dasbxwom36kwjpfiv4urshmderxovgyuefx22pv@jiyp3ll44kyr>
 <c690eebb-ad51-4fc4-b542-58d0a9265115@oracle.com>
 <cc5yndgo6enxwtnwvcc26wdoxg3wdnnzie6lvn2mttrzkeez24@6sk5qlhlrozp>
 <20251107042840.GK196370@frogsfrogsfrogs>
 <raxwda5jgqm463olshbx5q32iy3kpfayoj7xaj5yl5dlduiv6m@szrvfmnxeant>
 <5e3f6b82-1e8c-4cd1-90a6-e1612f76370b@oracle.com>
In-Reply-To: <5e3f6b82-1e8c-4cd1-90a6-e1612f76370b@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|PH7PR04MB8662:EE_
x-ms-office365-filtering-correlation-id: d05b8c7f-9268-41e1-ffbe-08de2002a339
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|19092799006|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?xpIymZkPuXHNvX7ARVk0kGfiYMQO+mDpXPz1SutmAplA7jSoDPMko+MMKDzJ?=
 =?us-ascii?Q?OYCWofZxojeokKWgvZoq2/kso8rCDEK6hs+bIA7rXg7Pu6rcffbfds3dPmnC?=
 =?us-ascii?Q?pEOhEkixesLiV6+Hs5V7AUqxaZD5zKaw2XOO08NZdzu1N6Crl3Ew0y8cH3V9?=
 =?us-ascii?Q?bH51Ttesb1rpPYfYQw7+FyGouNcUYbz+6FgJd6zP0MUrF7NB9hneyoQPZHLP?=
 =?us-ascii?Q?5k+EHZyaGBiJgOFAlsEMw1Gk/DLRWC4EZSRjmJat+GFYlRrJVSxqVBpe0nEb?=
 =?us-ascii?Q?+fbvzIxBZrhoPQkq6oa6+vTS93Pbie84nHgfL/L/49IzSzoy4KemuOs/vac7?=
 =?us-ascii?Q?AvcLhN/BFejvrlZzSRGy6zyGP6J+z3MkbPGBD6GXBPQp0SlP4MkyGaNksz1t?=
 =?us-ascii?Q?oXlmFlqchK8ZI9o3bOTE3Jkxvm46ON1oEDP0JxeYc+I3HIwXMII9N7eqd+A4?=
 =?us-ascii?Q?K5TVccynNYmNV+eFLwRjx9QxpK1U6iqZWpe9OOsETBfOJm/EES900WAhYpd/?=
 =?us-ascii?Q?Z6HWESXDRFkK1KLpBfN4V7FzZbjcX2RogTSGwYBJg9c6t7lWDeAqv8vHK50J?=
 =?us-ascii?Q?Ykt3XFUWUXubk2siKbbaf1wTw5IDOhJK15IbAnbiY7LVKaVOu//FTZyvUR3h?=
 =?us-ascii?Q?DLrrTVY9cOHuXmobDCPo1U43mQk17+JFS/7YZvhuy7YwVi37Pmf4URDEhHtC?=
 =?us-ascii?Q?AD2X4QHOgBw+pnpb+wSgxVUkuP9OCsE8KXx5jEFNRpygbsOAvMmzDmuOlGlE?=
 =?us-ascii?Q?TfjVAzLaE/xk/2rcyroTJwhUyaVt2plcs1VqMM9YnRiUl28EADsUNi0GmEkv?=
 =?us-ascii?Q?FuC3buhxSW0kHnvTxfDYGcdxwfuyQ1LUMh4UjOlTVgMbiWfTc0H3M7f1f8ys?=
 =?us-ascii?Q?47ICzCQ4F2+69IaQNAessjttCS4K2gjBfGMCDy1RVEixiGTv7sL4O7pMpAUp?=
 =?us-ascii?Q?PWzthjBG1aqkutKQV/fTHJFBgW6n6Bt3lu0XSCRo9d2oAVEEyzk78N7V0ue2?=
 =?us-ascii?Q?YDdsILAFP3o7igY7SHFe3e2g/1NT9LtfoJ2pTe5VrpQVqGnRjNEWDnpefTzx?=
 =?us-ascii?Q?OiLCwdusYIHv7knG0cmVJUWK1HgaacVsf0mhkiq4W8jf4gKW9zrx/RcBikQE?=
 =?us-ascii?Q?QI++umYae71cgzdpHkT5fBZ8mDIv7frDxh0BMjTSNGxsAZLYZowzsbG54EWO?=
 =?us-ascii?Q?7ATHEZHfe0dDM8AL+U1HTatpYO7BKMEuLz0KqTabXwuuK8aEXFdiTSLUdoGY?=
 =?us-ascii?Q?GYzbNHdhXjetZS6h5UuetUDusLSTiThGEnV2TKNP8NfQC/zzcSeC22aU2fOy?=
 =?us-ascii?Q?pROi5SB2459MTuedaIUdjT+nstBwxD4OGAvJcYZIv/L3pvumyq6pJXmFTPNa?=
 =?us-ascii?Q?KXJKrnhXanG5LWgjbT7vJ1eezB7wLXR13VcdO+SaIYffXZps/xkILE71wp5f?=
 =?us-ascii?Q?a70lzcBIjWuLU5KQ3MFLVjIKzX3fupa8RLROEIht/4PNx5P+TdF5zEs3VmI9?=
 =?us-ascii?Q?fEDh2vRJfsGCwxz/1L5NIflK2WyPKphSp+Sx?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UzxXzTbUY+OTNpeaAi8fIf7AerkKK1Kj3ZperxsQRUPBrkrAyJKRlGyq8V+0?=
 =?us-ascii?Q?dVV80XBdUJWHIJCvDU7zmhsH/EMSb7CZaranCONGL+gpRv5T11XhuL2bWzcT?=
 =?us-ascii?Q?a8oiZUeB+WyWv2HMsTQlaZNplYsLsqw3oOMsv+08ZPlNy2auVQILSqqaKhmQ?=
 =?us-ascii?Q?Dl5BAG6gjTVKUGTUUoDmotuTEU5lxtL8SgTXvqTyShZYAOOAwF9rdIgg86a5?=
 =?us-ascii?Q?WXRqJowTqh11eQGrKdTc0lhykL5qRFYgWhDib2bQva60ZxfAkFJKPsAfdI7L?=
 =?us-ascii?Q?0Kpwie2DX7dnYYGoUb95BzzQGVU9POkkg7py6unqfSbGd/CaoAunhiVDPZtC?=
 =?us-ascii?Q?AvCtOxJwb1Vh0CXoa82n5KODF7NUoUTloLfN0Ea7ALMK/mnoWc3diwSz1QAk?=
 =?us-ascii?Q?DDtomvWAO0piIwHCzwCxs8jogJwT7VvzeJzod+u1017azk1NyP4G6ow36mYk?=
 =?us-ascii?Q?OXqCaOChFrQyPQSm6V/QwIBxGc53zColUE5AVJIGGlRfYcrs1reqSYR5K/xL?=
 =?us-ascii?Q?v2NDD5X4xUZsCSSbzum/gUsuyjii2HjJu0nmpPCV76qZuEjdQAa37DVikeSa?=
 =?us-ascii?Q?kqO949wr4N9L52sIuwt259Vsq35c0eW2Ol3WzGhVV1Otfa40dApVXXwXX5pL?=
 =?us-ascii?Q?Ys8ZwnwAoyNk963pOLclRrEoVsWd/lPTK+Hb/rlak88qFuwuu67pLRiyFPLZ?=
 =?us-ascii?Q?y+Ag387KxZH8KwKU69YJvDUQqy3zaoMBhtp7qcZRx1oCU51s/oOu4k9EzvkY?=
 =?us-ascii?Q?JuQVS4Jplndd3rqI07VhofM8StVFP1U44EjByd2M32Ke77PWtP9uzN/ov699?=
 =?us-ascii?Q?SAEmZJYzIeqa5RmOkjSiHrXuxDjAoxhP0LDJ6Xtc1NY0v7PHwasw2jgfYEhr?=
 =?us-ascii?Q?nqcVFIYaHGmRdZZ6asBSMF8YdvMT2Oh3zSbS0Sn8dVZHi0P0/uXOmunqN5ni?=
 =?us-ascii?Q?8cimF+DnKS8mQEuHV7XUPCOXpwv0MoPxgqPATLaXRSd7jIzJ8EjdEv2Ud97n?=
 =?us-ascii?Q?sBaLIrwMo+JpadqjlvctplvqLtUrn/EbbPVr+Gzeyu9Tpzi01k8NQ5Ag3v9i?=
 =?us-ascii?Q?0RQ9N/8DElfW5LihyyDZRE46c/xk/7C67wDxThzQGH3KArKGOBobnSDgo07i?=
 =?us-ascii?Q?wtZWn8xw5zwoE9N7wMQds7vE7X96kzMvh0P0aWeONTqbTlebv1m9/YPN6YAd?=
 =?us-ascii?Q?DwuJ8VAX2TtQ42G/aXH5hRz9qTv+gMZmpIO19FL16bW6Jaf5BzVAwSTdbJZF?=
 =?us-ascii?Q?Puqt4FXNUBAljDMYYqDMeW+/KmG0qRl9NwNZHEMZlw+6Fly/r40tEpoRHXU8?=
 =?us-ascii?Q?R/3gpozXMT6+/JdNVJ1vQPiTd9zS3CozisLQ59DS7HqLsOOSxfNenvS9xMyt?=
 =?us-ascii?Q?l4qpQrmGRgHjfa6sUpdLaPnztYwYjtEKJvUF/etg45C5qxbr0bx6ur9bxWkZ?=
 =?us-ascii?Q?jUfXS7WscFZOPjJFuXJ+Kh2UB049uJ/DyjbTPPrSGrFzqZKhfnE15BCABhKw?=
 =?us-ascii?Q?1jeq3252BAfVOaavU5yzAhHVgm7+WT96liIRBeivKi8By654cSG8y76okUj8?=
 =?us-ascii?Q?tX4+6eJAeZZYytf/LJ9wWfJdgDp9YTOrdbu0XgfVkkKjWHlQfPZenv5aIVFJ?=
 =?us-ascii?Q?+ntzD35VukeloZzeeVW5d4Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3AF1530F4E83CC4E9761685DEC272C27@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	axSQ1ltTanhrX7DYxsVOBQrbmR4zB1T/AKYvjVWQX1xzM2d0THHHOA6gHL85i+g4NNNwZXu+YXcQs66JT51WugeEV2KlDKtUvMTo+daLKcw+LZpcZL6h1YMfeom59wUoRrRYDR98iejRN67SmYB9K7g9ZElnsO0xMUea+gfRwoBC0hqfN2dW6HlocuiRWjV4tE+rU2e/N2sY3pdfZ7qHULdircTe6gzJnOqCISXkn9yyq2urF7jOpw3GelgWVTBsjvOR2Bfjss+ctbUGomT+ISSiYbkSlsBRWWolfwg+fAlogQSHdI/KaH68LdW2goswvq3EpEliO7wAZA5FkwkcNNoRyYj2CyNN9u1i1NsOT1Gmhh0G6dVLjAOq5EP6M0IzKHF92otsk84MFnyVFq5Vx4RxpVYc5uee4nw0F/ow886yraLx5UR3iVyAFfAAJqSZuXU3EnuDIlDAd2AtNhqkg7Q8uQVCibKtQloQGN/BQxq7xUxzEi2sq7wyZ8mnZ6HtOT8Bnz3YmoIob0oo7nQ4kpO1a0uB5OphxpJSOMgaOWjL3K/1RBhdtndjvhhPQzgauXUDa4xfft02XNoGOFFYylBxE3sIE228K83rtiCFHHoTbVSUoFOWhniP9iOzzmSe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05b8c7f-9268-41e1-ffbe-08de2002a339
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 02:41:23.3099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GKdXNdzHaUpOoEzrwXJJ2W/WqjuCDMx95Eej7CuhDCqcl9shbUlU/OBC3WwscYIPdKJJTuILpfPRNYwbdlIzjmYhOOq2CQmoc+Wc0sAjmC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8662

On Nov 07, 2025 / 12:48, John Garry wrote:
> On 07/11/2025 05:53, Shinichiro Kawasaki wrote:
> > On Nov 06, 2025 / 20:28, Darrick J. Wong wrote:
> > > On Fri, Nov 07, 2025 at 02:27:50AM +0000, Shinichiro Kawasaki wrote:
> > > > On Nov 06, 2025 / 08:53, John Garry wrote:
> > ...
> > > > > Having a hang - even for the conditions set - should not produce =
a hang. I
> > > > > can check on whether we can improve the software-based atomic wri=
tes in xfs
> > > > > to avoid this.
> > > >=20
> > > > Thanks. Will sysrq-t output help? If it helps, I can take it from t=
he hanging
> > > > test node and share.
> > >=20
> > > Yes, anything you can share would be helpful.
> >=20
> > Okay, I attached dmesg log file (dmesg.gz), which contains the INFO mes=
sages and
> > the sysrq-t output. It was taken with v6.18-rc4 kernel with the fix pat=
ches by
> > Darrick. I also attached the kernel config (_config.gz) which I used to=
 build
> > the test target kernel.
> >=20
> > > FWIW the test runs in 51
> > > seconds here, but I only have 4 CPUs in the VM and fast storage so it=
s
> > > filesize is "only" 800MB.
> >=20
> > FYI, my test node has 24 CPUs. The hang is sporadic and I needed to rep=
eat the
> > test case a few times to recreate it with the 8GiB TCMU devices. When i=
t does
> > not hang, the test case takes about an hour to complete.
>=20
> Hi Shinichiro,
>=20
> Can you still stop the test with ctrl^C, right?

No, I can't. Even when I type Ctrl-C after the hang, the fstests check proc=
ess
does not stop. I still can login to the system and create new terminals. To
clean up the system, I just do sysrq-b to reboot the system.
