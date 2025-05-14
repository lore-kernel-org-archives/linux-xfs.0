Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49865268FEB;
	Wed, 14 May 2025 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747219850; cv=fail; b=QMyXDn4O3e+EjBszN6HB/Pk/LbuIjau/MRvnTICKrXDJneygUuVodliivNGRT9CfOMeTk65SgYPshAWsmciNozh+hXZ08h6My3HlN4NUo1w45F7mE6uYEl/YaLcNaptbAh7I/XNSnPJXmhQoqlpl6Gw5DpiSsu7Y3VVTAPAMgUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747219850; c=relaxed/simple;
	bh=Hh9VaUNZJN6Tl5u4wCcvxQbCni4lTbh+6D4N5v4Yfyw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fpQbiAFMECDtjs69GblTX6g2mnpl5aBmzOqPqEfN8/YPomsorkZhz0Eu0IvpuSJBjIwmlNFu6ieHQxRSYtXES1oWaszxN207XjM5Veyu+OwYYzOYVHBqgqoXvaKNO07BTq9yUbsIFNwXtAO7X+jZXaNvT1JVkIt+D79rp73HH0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UXcQ91Qe; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Xoc6EV+1; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UXcQ91Qe";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Xoc6EV+1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1747219849; x=1778755849;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hh9VaUNZJN6Tl5u4wCcvxQbCni4lTbh+6D4N5v4Yfyw=;
  b=UXcQ91Qe3ha7XFyEDM/MGcTvi9qINt4AvhmpW6HHc0slGcQpto3+l//c
   TSdZE8hMrtEZv1XVhkHQXQg8sMIt1ILBxo0HDaqkJSfJOCs36tbgngrMg
   NJ9Ok7i2WXioHIGwStafFS9tedJ6hpq/NGHjnOKU+PPrLVAb2W7cdbvjF
   8Ga44Z4FRxuIN0hviH8z8Zva7Fzb7xjVS8+k8ecjSpu2QOwYcV5I3XRTL
   d8K3C//G0WcvuV8eGx/ySv3gL9ooxJcGvG79h7gjyGtCwL8GlI18kVaOl
   c9A7PzAOAh9OIPXlzuU1x4y2BOGUvEpjMa0mo/zhnP8be0AmBQrTmaAQE
   Q==;
X-CSE-ConnectionGUID: KwOVRNFXQwylWy95VdRpUA==
X-CSE-MsgGUID: PMexWCnmQcKafSuxxLRQPg==
X-IronPort-AV: E=Sophos;i="6.15,288,1739808000"; 
   d="scan'208";a="81835572"
Received: from mail-centralusazlp17010006.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.6])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2025 18:50:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgVAaifFfB4jJTvf3jaApo9oWdRZpaU3PcCW6/lzwg52qEHueOkUTvNKcAYMICmQIk73fPP/WrmCxfMLTJ4+5VTtsWOAM4bI4Qe/q8hr58mdTR6PYhZJ3KOkjrpcDGIl+TaQbl3P3v6s8Uxvb5qg1Da6x4aeSVyjIYfKri570UGPvH0U0MJusQrRDVvv+/pWJeBUsKJ3Vl7JdTZGWCg4tnRhoFJjOHGLC4oxy9eIGml+ONgSqb2ftfs2RhPOt/aaLJMTBrtjqxguSwNtdOfve2wowmoa+YQtin2NLw/Sr54Wrb+AgkMr0Zi+1koWzUtGDO+kQtd0/Pvi+fyVCA6aPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goGXh9Z8fGp/jDM2ReSJP6jbKlKlictK9pJFZKQGvVQ=;
 b=uxOlv9gMypoZ0LQGnlZxl3Ouw4l419MHWqtDQ7MNQ194jbPb0CTOmf2J4McJb0gWloqzyfueo/V3/v0MGYfhxz63+29IsJ8RcuHTzGMqfQm0AYlQ+UG034JssQXjUwaLaS0HLtmEIuu57qDIc2gEIqDUBgHD5BeTcAXkY52vIuikxG+zMAGzN7704hKCpSfkntWr4ItuNnp91Te2DXP0aHoSplPu3DE8TS7J6S57F9aCxuP1s6DOSHCLpbPIPqQvco5zYdIZBa7CTDx6DuPyxPV+KbDewPKoUU1SlzXKoD/usK5sROZstKt8yYcSOGu9380EAWiCfsYXdl/g8n0d3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goGXh9Z8fGp/jDM2ReSJP6jbKlKlictK9pJFZKQGvVQ=;
 b=Xoc6EV+1KwUCEtukGkDxy0SstVAx0Pe1k3KJLks7FmPWKLmk03MMSCS0ensomH8ZGDBhHxc8HcW2K7iGDSSVc8MwvhXFa1fmbf7b87lwHISNOTCUbxMyAS7vYFzLLZ8mkggQSTwUM7BnCLn/k097R3F0uQzPJKUEGJzHH9rKYn0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN2PR04MB7023.namprd04.prod.outlook.com (2603:10b6:208:1e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 10:50:37 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%3]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 10:50:37 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on failure
Thread-Topic: [PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on
 failure
Thread-Index: AQHbxL4GpncI4HfMrECLn3wPsXQ6Sg==
Date: Wed, 14 May 2025 10:50:37 +0000
Message-ID: <20250514104937.15380-2-hans.holmberg@wdc.com>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
In-Reply-To: <20250514104937.15380-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN2PR04MB7023:EE_
x-ms-office365-filtering-correlation-id: e094abf6-2309-4c6f-e139-08dd92d5293f
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?3mJjPN5yL5CNcAw9uIRh/EI5XGBleMqtpxTF+WFC7nZRpESxtdGq/CTI8w?=
 =?iso-8859-1?Q?5W2TDUDl9U0fvrDCW5qrdSq/5Zbi8hC0LzMYtKjMCjlRPnWQDPuhGWzfwZ?=
 =?iso-8859-1?Q?FtAgMvWyNOgZrnw96RRlVL41PJl/GSMTh4GStemd/sA+AF0NWe6M6yD8DP?=
 =?iso-8859-1?Q?0LL+ue+8MXTXqkByXn1v6ucuksoHh1W0UUDJkhaeajHCWrLZS7ZmabEgxK?=
 =?iso-8859-1?Q?4uPnBirvTDZRADGfSPob7BPEl2gSN+hlyv1x8EDskpXWqTmSI3XZtb6Owv?=
 =?iso-8859-1?Q?3XvfeOdoZvollHpG0K93NMQ1JOhr2VXAEB/KqrfhW6zwYg907xrR5kn2T0?=
 =?iso-8859-1?Q?6G9wFL1lXLoK4JLcTRqlTn7dO4mAMp12OqpeXu3maKDU/591db9BUb43kq?=
 =?iso-8859-1?Q?EU4+FzfcyP0aO1blbnsrbKVlfRjO/iDqI2uHRc/iBGWk5YOlGHkR1o3uY1?=
 =?iso-8859-1?Q?6fIfzmTsEGHIgZEJiBR57fJIxJJ0SMgp2PNyaJ5GPMilX2mLk/DhfFb7IW?=
 =?iso-8859-1?Q?EDsOTmnwbtPnJpP5fO/tzmJ+RsYfL8ttBhY9rt+uHLLPpaM17ZWjICvlXi?=
 =?iso-8859-1?Q?zJAbiXm6cxS4rCeko463+Bz6yEig2gwS1XMd/of5neMsX52hSJIdTtLmwl?=
 =?iso-8859-1?Q?dPeU1McJGd4/7Au+Bw7LUD9HYIqR2GV0NBX1i4Fpkp8cpjU5Qzz0hPicKs?=
 =?iso-8859-1?Q?wqFHVVmW6oFiwKBZ/nmPYkJJhi5si8rnq01KSEaSPby7xHkDbcz6WE23Zr?=
 =?iso-8859-1?Q?P63P9uhWcE6TlK+tnoYCQjwrXsl2h1Iuo09bPKX+2zE7X1k6uGppui9Qhn?=
 =?iso-8859-1?Q?C3FsOfBgdWs5bgv7WsUI0JSaAyrK8WRVjrNcYmv9W8dw/5fQTv+Rz599e/?=
 =?iso-8859-1?Q?JMzPs0GIMWFID7gtiIxmED6TmiJ3rFtoG/XhVOMJQlSsXR16SiqAUJxErd?=
 =?iso-8859-1?Q?17y6nuuKNP9vcPDujiPXWURurGaMJyAR86GfuxH/HE8+NYuwyU20354Z6d?=
 =?iso-8859-1?Q?lFxnfXpz4mZCYGfFK0HrE56P8lOpDnoJn7rbxFf4wQn7rBgZoh7J+s60WU?=
 =?iso-8859-1?Q?xi07T82d2vDQOjwMZ4FXzbZbF+QA56244I1j0gr8I+0kGwZRlo9NseF/tg?=
 =?iso-8859-1?Q?b6la1Qx1QGi/MVKOts6rw6xFNOe34o//DTeT+PRtu0bWSJfUm8fduJFTEA?=
 =?iso-8859-1?Q?6DZdz7Y6O0jbM0Mb3hrt10R0JZ9SDajtuoXowT+rymUb94P/3KXj8GA4sN?=
 =?iso-8859-1?Q?F71F7nJJTFM+dq8HD3fjCtRz0CTxIeGdkOFtIpiD7ok4ZVAYLs2LN9f5S4?=
 =?iso-8859-1?Q?GKhtmGTv+wRh6tspytQbKSrGykUgECawuanEH3iCh+KeXTikUHoJyMJhNy?=
 =?iso-8859-1?Q?rHziYt/nJn/k70cOZspw+p6g3/ELKRyZuJOttaBHroNB97144Jl46lxGf6?=
 =?iso-8859-1?Q?ASYUw5Ithlb7DH5Xkfr+KFu+6xkt4i8/WaK7ADnsJEB7QbH1YSD38zP/WR?=
 =?iso-8859-1?Q?YkX7doXy+OoqnoVnUGeoveK6s+RJtv84L7Nvzz1d5ueiH7iKIs5z6QrVYU?=
 =?iso-8859-1?Q?unj5AhM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?kqyM6qgljoLeH4t1aXeD3rfsTLY28ERXyDJO93zXUKuNiP3ByRGSJcGeOU?=
 =?iso-8859-1?Q?Yi9Y/Mm4oT3GwyhdDXj6tyY53rLsJ2uHE7q9FXjOS5j0xdi6jXY3G5Rqw0?=
 =?iso-8859-1?Q?N2Eygz690FmVSPJf+0Wtn0Edq0dZ4OTjtjn7xrmsr1Yzm/cmj4EkbJPzUo?=
 =?iso-8859-1?Q?vbt94duyT4Tq+y8b9ovmBdAaBpKBgEaoH7qWHmBQ4WL982YunTCrzPDmLk?=
 =?iso-8859-1?Q?XWHHuz/A77ynAJpHfU0sV9ix6x1H9SDf5QxffW0x5S9rvU2nHodK6oii+c?=
 =?iso-8859-1?Q?OioEASUSUFj7vso0ukrNM9emYmuQUnJsBx1deWMz2TNgGCpSadPWJhWCkS?=
 =?iso-8859-1?Q?A+6xmbjnagzLI/Rpix1j1ymyrO7rH05ptOOHzGVVfxRoNaXx5lWNSzBuyY?=
 =?iso-8859-1?Q?mIrseLmOH5g6Xgy0klDE3yC3vjWWHU5H9KvSzkFDruA1qKtzOQjAxEec4N?=
 =?iso-8859-1?Q?X7cEWBReurcZ9BvCYC/L1vOi26VIm7U3nqCcxo+JLhQIGVDHpfFWkeOz7H?=
 =?iso-8859-1?Q?WHyGVS6woWoDQJN7ctU/GCj4ExNok6mV/KU6AKGw4RvxKULem1OEQq7QkQ?=
 =?iso-8859-1?Q?IFyOj4om1hiLSxTkuu08xSKRIhV2zW4A+ZJNQkxUbEPVp81lZHw81zNmmy?=
 =?iso-8859-1?Q?2PJ2j6j7IPAYFx0wBf95V0UDvjdNfsNFSHiShfuVYFCKcKmWtGIkiv7j31?=
 =?iso-8859-1?Q?744/LBzzFJiIUVXTovj6PuVmKNVkdqjt1EM+zxX28QRYlxPCiyqfGe5z6x?=
 =?iso-8859-1?Q?ee16O80bFjvgEeqvJNuX+nl0BgzGmoR2qH7JLCQtNCG/9I/CdhY1M5XY3T?=
 =?iso-8859-1?Q?4vwOA/ufjCqgHcQWgz/rtGS6MTfOw1YOr7AXnq8BX/XM1vkmEe+r440oP6?=
 =?iso-8859-1?Q?UuscAtVHt9PbNdznL4qh2+NVtRWJA0fq7OP/CzrtCLPR+m2pebg3yIuV1a?=
 =?iso-8859-1?Q?NW2OdC8+jyAe64egEdsQ51J3gYwM3KIA7W8ccjmqGisXjEN+uCRkdJdYXy?=
 =?iso-8859-1?Q?v7tB9XA0yZrgnAz6ajPY4mAsF2lhvGXBvvxMbqDAeYxyPSeEGCubvW1Lcg?=
 =?iso-8859-1?Q?l8irAdCeJRYEkWdsU92ahVKSQEYT7sGvkm+lzZLen4fMcnCNVOffeBZ1VY?=
 =?iso-8859-1?Q?p8ueTH1h+heB4mz2pNMzrKrwvL075FHm/gbKxPIRIx0VuO9tUk4Ca7Q92z?=
 =?iso-8859-1?Q?+DWKTFW204/dw9JYFzriASd0abuu7I12M8ghhKqZ/ty6P3nfqKNLWb+Udi?=
 =?iso-8859-1?Q?eKlmHlJ/qlEqqru84/WUA8wDs2BpNGMtxTj8uhZMO7DJdsIKzLH1pVT55U?=
 =?iso-8859-1?Q?xSNUuA0FPTt+cUPuh+l9l/Vt2zKlpzYgTn+Q0vugWi2GFZipUT00Tf5UQO?=
 =?iso-8859-1?Q?OsAK5wXp4O8uYF2qvTi/pcynP1aj3ZCgmnPdQpEsvq5HO3NJuui1+3Q1Xw?=
 =?iso-8859-1?Q?tSMW9jWw/Mff9UzgmVGL0xg9rZPsA2qYIRzU3JetHjDEvNb8We/CZemyvS?=
 =?iso-8859-1?Q?F/M3hAeDAqy1xid2eOrzMg6xX1OJPKed2SG6Km2g+vXCebGwMcC8WZOmJg?=
 =?iso-8859-1?Q?kPmUKmeDum7MYAGAIyynUS7xbro5yS0XoLvw1LUqcWPs6lRSJkZd5GbmJQ?=
 =?iso-8859-1?Q?N0Qm9ddqOzsPdZdKSxnLPtwpK5yBbTi+QGSrAwqvLuS0B7tnH1bl/aUA?=
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
	x7kAvLdyAVaqEGf4MzPC4ITJNit/Sa5ykIWaYnj6thMFTwvo/Wb1WdtGlv5gDrdK8CO1SI6cZVnIaesasPsujNDLv+Wo9ZLwoD5fATzUr1FiDkniynmjMKfCXRzATIvyIOlGhwL0pIgbke+jQ4mQMWBQQykkEyzHKsd+EhR0i0QJhg9oeUMaBXTR8z6Ti2ZUvU4gUA9ApAVlqkOPC+c7wz+O0mQ5FlNLLqMcTMPSZWqD5TCIhjY4TSS1H+qeErlPzBhTK6hwcWyA9NKXTL68jeQFjeC/kBwgcu5Nl+kX1CSUASf0SllqNalqLuahBTJ5eAwvL/OZVnLbqRrrV54YBSmuYdUzayhIiVlioN0bSp4ynEUrdeeeSVc58CKYmSac0JzNh0aJxssxS8I359fCGGigsxPWq8I9AVDhMJjMQheh6T6oKJwYr5dr5R0pYk5hj6jSEvyYWdSEtsJRYlvgoEtATeVIVYGLNnkN2NZ/QxzNjZibce1kzE2sTGcarad2pxhts3p3DtcWMQ6arm+/7mI3wSzVZE/xAg4fBbS4CT3kpZBG+OA01Z5b6NICHzM7roNloHxKSsgbbB+P9G3puycx3Ljdo4f+EpXUiYojZT3AxeHKaqv0IEYVrIwbRBmO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e094abf6-2309-4c6f-e139-08dd92d5293f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 10:50:37.3618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pg0Y5F4vs1mxRjRKVu0rVzRukkBsbWzeWj07Qnw19BrI76eNydnPd0AJ2PU7A6CRYwcvKKqU3UoY5LWsM8N14Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7023

From: Christoph Hellwig <hch@lst.de>

Call the provided free_func when xfs_mru_cache_insert as that's what
the callers need to do anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_filestream.c | 15 ++++-----------
 fs/xfs/xfs_mru_cache.c  | 15 ++++++++++++---
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index a961aa420c48..044918fbae06 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -304,11 +304,9 @@ xfs_filestream_create_association(
 	 * for us, so all we need to do here is take another active reference to
 	 * the perag for the cached association.
 	 *
-	 * If we fail to store the association, we need to drop the fstrms
-	 * counter as well as drop the perag reference we take here for the
-	 * item. We do not need to return an error for this failure - as long as
-	 * we return a referenced AG, the allocation can still go ahead just
-	 * fine.
+	 * If we fail to store the association, we do not need to return an
+	 * error for this failure - as long as we return a referenced AG, the
+	 * allocation can still go ahead just fine.
 	 */
 	item =3D kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!item)
@@ -316,14 +314,9 @@ xfs_filestream_create_association(
=20
 	atomic_inc(&pag_group(args->pag)->xg_active_ref);
 	item->pag =3D args->pag;
-	error =3D xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
-	if (error)
-		goto out_free_item;
+	xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
 	return 0;
=20
-out_free_item:
-	xfs_perag_rele(item->pag);
-	kfree(item);
 out_put_fstrms:
 	atomic_dec(&args->pag->pagf_fstrms);
 	return 0;
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index d0f5b403bdbe..08443ceec329 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -414,6 +414,8 @@ xfs_mru_cache_destroy(
  * To insert an element, call xfs_mru_cache_insert() with the data store, =
the
  * element's key and the client data pointer.  This function returns 0 on
  * success or ENOMEM if memory for the data element couldn't be allocated.
+ *
+ * The passed in elem is freed through the per-cache free_func on failure.
  */
 int
 xfs_mru_cache_insert(
@@ -421,14 +423,15 @@ xfs_mru_cache_insert(
 	unsigned long		key,
 	struct xfs_mru_cache_elem *elem)
 {
-	int			error;
+	int			error =3D -EINVAL;
=20
 	ASSERT(mru && mru->lists);
 	if (!mru || !mru->lists)
-		return -EINVAL;
+		goto out_free;
=20
+	error =3D -ENOMEM;
 	if (radix_tree_preload(GFP_KERNEL))
-		return -ENOMEM;
+		goto out_free;
=20
 	INIT_LIST_HEAD(&elem->list_node);
 	elem->key =3D key;
@@ -440,6 +443,12 @@ xfs_mru_cache_insert(
 		_xfs_mru_cache_list_insert(mru, elem);
 	spin_unlock(&mru->lock);
=20
+	if (error)
+		goto out_free;
+	return 0;
+
+out_free:
+	mru->free_func(mru->data, elem);
 	return error;
 }
=20
--=20
2.34.1
