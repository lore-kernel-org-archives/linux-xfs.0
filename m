Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.162.55
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899081;
	b=BI10qXiXF/uQQMa6IqVsijGc9dBUko8P3FauDsGmX0az01t3jb63dwPpSio62GMLQAVp
	 6/TNZwhG65SGX2gYfS1jrqNBY3D1lRtGY0l37ckHXB47s2M7jQPv7Ce4u27zdviYMxEjm
	 dJLPHunL9GI/B8S6qiNMXsE+EsjTjWkZSCVMAoB5FlzowiPPDIPqPViFC3VgNdOHFRz6j
	 fYnbMj7+bZSeb+epnj4UcLBlOmtPRm/5Nkm9gAz+9U26WhUR5YdVHmjBuOd6ayoyz7pU3
	 cA9CeXAC2A1I4kKIM0gX6atqw3fAIuRQHZebzUiwfQbst2Qpg+vkclRXYowI7q15tUw==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899081;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Authentication-Results-Original:Received:Received:From:
	 Date:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 x-checkrecipientrouted:NoDisclaimer:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=SqS8iYrVP6Mx9SPLC0ApdwsAnkBqoV6pRSpfL8mSrOE=;
	b=Zl0z1FCrtoexrTyx0i3nIPLqQ/kanbnKxO3PguYV+QrLrtp8tQOkOjhcurY4spwwarGg
	 LWmFteeLossUlGRFl80yYSY8a8Pg+fQvGwYcTTGREOnfF/+UyVdmcZ3VD9pkd083NWn70
	 3em/NcBfwVsr8oGaYE4Hh+DszgRyYOS7rFAd/NRPED5iIkLWyXwexyquWXorM2xFOPp5c
	 Orfw34JrX8ijxKnbjNpQaz17etgE+TXUMncrvhrwaOCQZ9QEm/xD83YEFBlcYgIwG3mA4
	 x8KDDQ2c1w3Cb3bkfL55jXv8mNPCfVI5+u+gctk9iM0y1GPf4BcFRXWrOrD3htm3zlg==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=H9x1E0ei;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=H9x1E0ei;
	arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.162.55
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013055.outbound.protection.outlook.com [40.107.162.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5028360A3830;
	Thu,  5 Nov 2026 17:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5028360A3830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=H9x1E0ei;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=H9x1E0ei
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nSB7QU4d/OddjCRzW0H/rnpSuECCb8o/R8MbZE40agvva2ZpgnCAzqI6I2aRMK/Izdg61bWfuH+WVJn/WyCeNeYUz8Z8xUsRdK20PhCKokmUKE2d7ZcN4xETuDyj9o/NV//EDTlyiQ9eaNNeH0cPeSwmmw3H/wb4sAYnnVCuybz6CdMIfBU8Vphw1Q/lzKO02e4/U5KYn8RTGVdb+62qx/na+tR1jxvcZyAA39Wg/ubzkh0FbJYR63gyyak82pqqFdw2c20aXjMKjrzuSXEWbVqc93X3Dmro4QTsrbVNnKeePBupqwbHgqMgi2cqKbrKHskjNfot5azDikV/7vKX3Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqS8iYrVP6Mx9SPLC0ApdwsAnkBqoV6pRSpfL8mSrOE=;
 b=dhGbIPReZdXFJgB2bqr4ElPirlXgX9bj30UM+zi5abLTzWWtEKilOL+0nhVNGq4PFyhFJ/pyfXo0VTuokN1PiyMkzDMyUd4LdqwuNd1DGYkygIXdz1wznsOlKwcn5irg4D2nU0CwhomkRi1L2hA4yxE4TCoew80lCeIeIGzF8I52LpkcciJV9aCP3KcwDOn+ZVetyabXGUaSo/6ZC40YlWgR1IFJupwhqnCkBGOJEfSYYGsVKCw0SLCHy6P5O5AmPmkKhkLkEwYixZ2PvYswoX+At1IIC5lboJR+PM7694JUyJ1tECAtSvDN7qN9zE73A2RxpVKP4gF6sfsbG+TvMw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqS8iYrVP6Mx9SPLC0ApdwsAnkBqoV6pRSpfL8mSrOE=;
 b=H9x1E0eiFRWlJ2wUj7MWH/xOET4KG0X2Zk6WjVh2meH/KULtcS3+5dqLF5/ngIzWfHybvdMyEQpnjCfeaL93QOy/3UXUV/GH3zjBKgzlJqkE0KoD06q4NAbzz6I3x4b9ERge1yFTHNpYvkXhx4s9VAobsP8zbApaIHsJHMHMnqc=
Received: from DUZPR01CA0312.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::8) by DU0PR08MB8164.eurprd08.prod.outlook.com
 (2603:10a6:10:3ef::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 17:17:52 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:4ba:cafe::73) by DUZPR01CA0312.outlook.office365.com
 (2603:10a6:10:4ba::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 17:17:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.5
 via Frontend Transport; Thu, 5 Nov 2026 17:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yy1PlYrYiIc9F0wSH5V4szydX9eoFFtiSj7n68su3YOo0/j/ERzNsORwXIJ1PKFALB0dVgjGvZkZ+o75+XEj1sTVpy6YE+nNzVsNd195pvJGaMWXYc6aOc4drJxPQdAe1FxyvZTNuDoqiOt/hC2sGfNuQwBWoQpCZwbWNm0J7MXNSjbmRT0F/ySVV2eoenHTSn79iTYqE651DkXGTmzDhrWRYa1bKApsuNBNbILnHFPlvKtHFgLZ9Wu6C9+ceumhZotg5netOGDHMmR7WZhiguiXE18TPfpuMkHhAFzX6VewxFTvpoaGvjdTx7tbmV01nFDkJO+D0w0NelRnW80EbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqS8iYrVP6Mx9SPLC0ApdwsAnkBqoV6pRSpfL8mSrOE=;
 b=jQwT0gRcysyejhaHqr7rZnXIO86RGsnwNZezo9PKf0NejcUsPJZd7Gw37JknvNxnq7QB9cDiBjH14rLgkM6mrUOao2CZ3XWCx9DWX8mPQElrlYN1Chn4cEEmbUpN4LSpCTyn8cWqCHTWaT58FEgqFGls8oeTBvXFTAD3v5Up0P3tN80isoKODGpPYmL/otv1emOkItyDKK+wgoP1O5HbttCUFniVVghxFFAyoPZ02U155zRP8Im1TL7Sze6laRsQNwatM3K387h0toteiwKYImdsxaH+VEVu9b/1JC4pBESwlmOaTJ8TQHBSuIBIuDwin2yOK6UHYhjZFvh2nNFkIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqS8iYrVP6Mx9SPLC0ApdwsAnkBqoV6pRSpfL8mSrOE=;
 b=H9x1E0eiFRWlJ2wUj7MWH/xOET4KG0X2Zk6WjVh2meH/KULtcS3+5dqLF5/ngIzWfHybvdMyEQpnjCfeaL93QOy/3UXUV/GH3zjBKgzlJqkE0KoD06q4NAbzz6I3x4b9ERge1yFTHNpYvkXhx4s9VAobsP8zbApaIHsJHMHMnqc=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by AM9PR08MB6098.eurprd08.prod.outlook.com
 (2603:10a6:20b:2d9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:17:15 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 17:17:15 +0000
From: Bence Csokas <bence.csokas@arm.com>
Date: Thu, 05 Nov 2026 18:16:18 +0100
Subject: [PATCH 3/3] treewide: Use offsetofp()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-offsetof-v1-3-4153f5c10edc@arm.com>
References: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
In-Reply-To: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
To: Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, 
 Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
 =?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Vineet Gupta <vgupta@kernel.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Philipp Stanner <phasta@kernel.org>, Sudeep Holla <sudeep.holla@kernel.org>, 
 Cristian Marussi <cristian.marussi@arm.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, Lyude Paul <lyude@redhat.com>, 
 Danilo Krummrich <dakr@kernel.org>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
 Hans de Goede <hansg@kernel.org>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 Benson Leung <bleung@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
 Guenter Roeck <groeck@chromium.org>, Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>, Carlos Maiolino <cem@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 "Geoffrey D. Bennett" <g@b4.vu>, Jaroslav Kysela <perex@perex.cz>, 
 Takashi Iwai <tiwai@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-wireless@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
 linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
 linux-hyperv@vger.kernel.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-xfs@vger.kernel.org, linux-sound@vger.kernel.org, 
 Bence Csokas <bence.csokas@arm.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: PA7P264CA0148.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:377::20) To AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB10291:EE_|AM9PR08MB6098:EE_|DU2PEPF00028D11:EE_|DU0PR08MB8164:EE_
X-MS-Office365-Filtering-Correlation-Id: d6005ad0-054a-470e-f07e-08df3b60b94a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|22082099003|18002099003|921020|11063799006|261009223027099003|3023799007|261026121527099003|56012099006|261026140227099003|261009221227099003|261009223327099003|261009221727099003|261009220027099003|261022105027099003|261021135927099003|261102123227099003|261102130727099003|261021133027099003|261021130227099003|261022113327099003|261026130827099003|261026135527099003|261021123027099003|261021121427099003|261022115727099003|260925021911599003|261022075727099003|261028144727099003|260925022911599003|260925021311599003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 HQDMihludKvLxQozMxOIbeA1ImUUqxQacNly018rOIS0QAq72MMhZAumCX3827prmaq0I4WIfhm14Kc5uVJwD6Uwi5CVupG/YWSi4LhDgWaTQ+k4wFgyKlhPZu2rs6UOBt9Hs1NtQxyww8LPzPBzKkSeFgc8JhSF/361F4L45olzjI5r+kNTGSixCvIPx3OYiiM0BMmC4NcTZlw3dKPEq8rvW5LfIKYY1Sd+lnMVwaq6NE+ygk0E0we8mXqEZO0GkqONn3Vu6eT8lGNgaR/KiYT0LBMT5TQJ8bpdKkkCwXSUca2ouyQHo1RGX7GWTZ2eslpzdAdcuEnDKYHyPv8gsE0WVh1eAkTU6oydoKPQ3WLCerMlm75/KZF71GsObZeU4e9PcmfO/DYMzttLhokHEIJ6quljuMrYkOKoOonyH2vh1Xz4QiOQCL1Aasa0l9d7d8ycWoF5j1xgoNWI6xvOwAf0OePI8FKAuNEuKOvoohZSDGJfvETVIxPcSQtJb2PsELFbAuPVQqonp1owCrOAC7CHx4eY+cf/Nm9cPkyQSKTN9vEMx21DnEwQCjSEOID6HitWhjofzClyofb0KRuLeZm5Cy1+RccC8DzS9U5hRzub2L0XEd/Ws81W/K63N1De2e5OHGlu17LoKtT9PnMP//U7mqEXoIRseXSnmYfiSe+e/Oj71Zgn6XXcN/RRJPLQf+ziaYEhRwtIMdqlyUQ5Ng==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(22082099003)(18002099003)(921020)(11063799006)(261009223027099003)(3023799007)(261026121527099003)(56012099006)(261026140227099003)(261009221227099003)(261009223327099003)(261009221727099003)(261009220027099003)(261022105027099003)(261021135927099003)(261102123227099003)(261102130727099003)(261021133027099003)(261021130227099003)(261022113327099003)(261026130827099003)(261026135527099003)(261021123027099003)(261021121427099003)(261022115727099003)(260925021911599003)(261022075727099003)(261028144727099003)(260925022911599003)(260925021311599003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 YY3OfJkUoM0KdVtBpXEx0rNOwdCtiUgBP2b7abOL+kZgYBR3Jwz0gxg17K0Dlj8m+7CdMNX5ItlDLl8mXURSnWKBll4mgwkaQkT5kMtwkynoQLpa65gAbvKJq553054ZcZimZlSEQB/eBRojUV9pDXJQ4FI0HFwvGcMtgnjGrBpndzhoCUi4drnU/4MffFvvtDKRzpyvXC0rTg0EnKoatfDifDjjDw1uSOgDaCGqhFNesVRJMmkCvMB8nYvxD/JwbUgq+fJDzUu2qrjVjmfvjpgaUp1QTBZCy+x62ZdyjFXqTNj83rhSmXerkbuPVXl+LFu8WGHkofifi2HjKp+6Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6098
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d04951f7-4e9b-476f-f453-08df3b60a31f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|14060799003|376014|35042699022|7416014|1800799024|6133799003|10067099003|22082099003|18002099003|3023799007|921020|56012099006|11063799006|261022105027099003|261028144727099003|261022113327099003|261026140227099003|261026135527099003|261102123227099003|261026130827099003|261022115727099003|261009221227099003|261021121427099003|261009223327099003|261009223027099003|261026121527099003|261009220027099003|261021133027099003|261021123027099003|261009221727099003|261021135927099003|261021130227099003|261102130727099003|261022075727099003|260925022911599003|260925021311599003|260925021911599003;
X-Microsoft-Antispam-Message-Info:
	c675/Oof249wUBxC3T4dow58qB1N6BbwPKEvi+deQQGz85Uum3sT7yrtK2YlZpDQY7TcZCCjSswDY8nrtn0udo2x3QUN2HL8fgoU9+HWil9uLFCL7mIEaG/Tj4sdLaM8PbF14GTSmbzLVpfYmauI5KSThwHL+tS69JF5kuELqrKyynF1s5c9evVD0a4yGMvJ70xiP8CuTJ0wHlarrOAeMPeqArLwdXaY5aaAqUmclULZAwzHpzInJ/VTEiAxspwxNhANTVLj5hZscJ1u5K0h4A06/vAYfL203wlGf03WVYiK5xwzHEErPA2ygP53QIRXM8ZiF7mF+ItwvPbjZBsvmNfkF8PcpKzABrV554NmYZU1NFR5XVpYyNlglf6goAa18vl3i4tKMWep2mY48Ytnovc1WgrG73XqlOSr9bzHxH9En5ZkVTeceGNGT7/ZgdJP3N2PGsxeTqKjRde5d77zIlZUHvLS0xhQBsxoDkMtQQ4rO81G46Yf76XLn7/q/0B8/a0rxRzkqJNfw/jv00pLarFub83tO5GqJ5ltZHpMr5JX5DMKQS4EkctQZF/vazH6oBexXBb50EvSTfXJqye6enzcpGPe7KaQtXke5K6Mm2sJ8UVo0f/Se0Rdf/saBZkSBaXbmpUIUukvfRnvN3maCLfw4VdjjskgNCtlaotSFRaa6V45bKdC49xooHxrVN2MaJ4cE5DpXHDPIq4e4UPsbnkMkwC/xAq1aim3hA210crKIyoLMz/Qmd0ZToDwNetq
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(14060799003)(376014)(35042699022)(7416014)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(3023799007)(921020)(56012099006)(11063799006)(261022105027099003)(261028144727099003)(261022113327099003)(261026140227099003)(261026135527099003)(261102123227099003)(261026130827099003)(261022115727099003)(261009221227099003)(261021121427099003)(261009223327099003)(261009223027099003)(261026121527099003)(261009220027099003)(261021133027099003)(261021123027099003)(261009221727099003)(261021135927099003)(261021130227099003)(261102130727099003)(261022075727099003)(260925022911599003)(260925021311599003)(260925021911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FRTvLruRbxfHRWoyuC95E+scI0XMRUxhwWpqBwWjq9f0kjBPHD+bPSui2XTnv9ptaCB63zZULtvj+RONbwRh0X++SohWwcMqWCoPNzVtA9T90TR5cSb7PjvQ+iGfrVk2NTFMn6jt8F4Ehw01SUIdMBq7z/Cu1QSQnR4ZXZje0bBytDd+7q6TJ48gGrWRqR/ZBUbwlMd+z8nSjikCViF5DyH7jBTlygu6+SMU6Haq0q5i1ALlKwsXlEswwzQLbPgCkcS7F3UNT9fPycxs1g9nRRIaCwSEXuVzvw8IQkeSREG7s5btemPMv3qaS3/HHANgCDF02h9GejI6hCMS8vrW+oV7burGgwGtsau2ftMBgzoJ58AS9Uc/3gXE8vkavbWRoFWZGCNzp/j0jap1EYRqOlm4njb7t1eOT2yO0pvj7nncQllwPo87WWAHkIRkq4B9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:17:52.0704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6005ad0-054a-470e-f07e-08df3b60b94a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8164

Generated with the following simple Coccinelle patch:

@@
expression ptr, member;
@@
- offsetof(typeof(*ptr), member)
+ offsetofp(ptr, member)

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
 arch/arc/kernel/unwind.c                           |  4 ++--
 drivers/bluetooth/btmrvl_main.c                    | 12 +++++-----
 drivers/dma-buf/dma-resv.c                         |  2 +-
 drivers/firmware/arm_scmi/base.c                   |  2 +-
 drivers/gpu/drm/drm_edid.c                         | 26 +++++++++++-----------
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |  4 ++--
 drivers/gpu/drm/i915/i915_active.c                 |  2 +-
 drivers/gpu/drm/i915/i915_sw_fence_work.c          |  2 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            | 12 +++++-----
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  4 ++--
 drivers/net/hyperv/rndis_filter.c                  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  2 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  2 +-
 drivers/platform/chrome/cros_ec_lightbar.c         |  4 ++--
 drivers/scsi/qla2xxx/qla_gs.c                      |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  4 ++--
 drivers/scsi/scsi_transport_fc.c                   |  2 +-
 fs/readdir.c                                       |  2 +-
 fs/smb/client/cifssmb.c                            |  4 ++--
 fs/smb/client/reparse.c                            |  2 +-
 fs/xfs/scrub/attr.c                                |  4 ++--
 fs/xfs/scrub/attr_repair.c                         |  4 ++--
 fs/xfs/scrub/dir.c                                 |  4 ++--
 fs/xfs/scrub/dir_repair.c                          |  4 ++--
 kernel/futex/core.c                                |  2 +-
 net/ipv4/ip_output.c                               |  4 ++--
 net/ipv4/udp.c                                     |  4 ++--
 net/ipv6/udp.c                                     |  4 ++--
 net/mac80211/agg-rx.c                              |  3 +--
 net/mac80211/agg-tx.c                              |  3 +--
 net/mac80211/parse.c                               |  2 +-
 net/mac80211/tdls.c                                |  4 ++--
 sound/usb/mixer_scarlett2.c                        |  2 +-
 39 files changed, 75 insertions(+), 77 deletions(-)

diff --git a/arch/arc/kernel/unwind.c b/arch/arc/kernel/unwind.c
index 6fdc751f906e..dae3b5f3dff6 100644
--- a/arch/arc/kernel/unwind.c
+++ b/arch/arc/kernel/unwind.c
@@ -310,11 +310,11 @@ static void init_unwind_hdr(struct unwind_table *table,
 	header->fde_count_enc = DW_EH_PE_abs | DW_EH_PE_data4;
 	header->table_enc = DW_EH_PE_abs | DW_EH_PE_native;
 	put_unaligned((unsigned long)table->address, &header->eh_frame_ptr);
-	BUILD_BUG_ON(offsetof(typeof(*header), fde_count)
+	BUILD_BUG_ON(offsetofp(header, fde_count)
 		     % __alignof(typeof(header->fde_count)));
 	header->fde_count = n;
 
-	BUILD_BUG_ON(offsetof(typeof(*header), table)
+	BUILD_BUG_ON(offsetofp(header, table)
 		     % __alignof(typeof(*header->table)));
 	for (fde = table->address, tableSize = table->size, n = 0;
 	     tableSize;
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index d449fbdde464..ba23a31ed6d9 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -81,7 +81,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 	struct btmrvl_event *event;
 	int ret = 0;
 
-	if (skb->len <= offsetof(typeof(*event), data[0]))
+	if (skb->len <= offsetofp(event, data[0]))
 		return -EINVAL;
 
 	event = (struct btmrvl_event *) skb->data;
@@ -92,7 +92,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 
 	switch (event->data[0]) {
 	case BT_EVENT_AUTO_SLEEP_MODE:
-		if (skb->len <= offsetof(typeof(*event), data[2]))
+		if (skb->len <= offsetofp(event, data[2]))
 			return -EINVAL;
 		if (!event->data[2]) {
 			if (event->data[1] == BT_PS_ENABLE)
@@ -107,7 +107,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_HOST_SLEEP_CONFIG:
-		if (skb->len <= offsetof(typeof(*event), data[3]))
+		if (skb->len <= offsetofp(event, data[3]))
 			return -EINVAL;
 		if (!event->data[3])
 			BT_DBG("gpio=%x, gap=%x", event->data[1],
@@ -117,7 +117,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_HOST_SLEEP_ENABLE:
-		if (skb->len <= offsetof(typeof(*event), data[1]))
+		if (skb->len <= offsetofp(event, data[1]))
 			return -EINVAL;
 		if (!event->data[1]) {
 			adapter->hs_state = HS_ACTIVATED;
@@ -131,7 +131,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_MODULE_CFG_REQ:
-		if (skb->len <= offsetof(typeof(*event), data[2]))
+		if (skb->len <= offsetofp(event, data[2]))
 			return -EINVAL;
 		if (priv->btmrvl_dev.sendcmdflag &&
 				event->data[1] == MODULE_BRINGUP_REQ) {
@@ -150,7 +150,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		break;
 
 	case BT_EVENT_POWER_STATE:
-		if (skb->len <= offsetof(typeof(*event), data[1]))
+		if (skb->len <= offsetofp(event, data[1]))
 			return -EINVAL;
 		if (event->data[1] == BT_PS_SLEEP)
 			adapter->ps_state = PS_SLEEP;
diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index 2365a6d8ca15..83c204458d40 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -108,7 +108,7 @@ static struct dma_resv_list *dma_resv_list_alloc(unsigned int max_fences)
 		return NULL;
 
 	/* Given the resulting bucket size, recalculated max_fences. */
-	list->max_fences = (size - offsetof(typeof(*list), table)) /
+	list->max_fences = (size - offsetofp(list, table)) /
 		sizeof(*list->table);
 
 	return list;
diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index a9cea09355ff..3270268e578b 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -340,7 +340,7 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
 	if (evt_id != SCMI_EVENT_BASE_ERROR_EVENT || sizeof(*p) < payld_sz)
 		return NULL;
 
-	expected_sz = offsetof(typeof(*p), msg_reports);
+	expected_sz = offsetofp(p, msg_reports);
 	if (payld_sz < expected_sz)
 		return NULL;
 
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 3148038747b6..b2960eff80cd 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3124,9 +3124,9 @@ EXPORT_SYMBOL(drm_mode_find_dmt);
 
 static bool is_display_descriptor(const struct detailed_timing *descriptor, u8 type)
 {
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), pixel_clock) != 0);
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.pad1) != 2);
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.type) != 3);
+	BUILD_BUG_ON(offsetofp(descriptor, pixel_clock) != 0);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.pad1) != 2);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.type) != 3);
 
 	return descriptor->pixel_clock == 0 &&
 		descriptor->data.other_data.pad1 == 0 &&
@@ -3135,7 +3135,7 @@ static bool is_display_descriptor(const struct detailed_timing *descriptor, u8 t
 
 static bool is_detailed_timing_descriptor(const struct detailed_timing *descriptor)
 {
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), pixel_clock) != 0);
+	BUILD_BUG_ON(offsetofp(descriptor, pixel_clock) != 0);
 
 	return descriptor->pixel_clock != 0;
 }
@@ -3207,8 +3207,8 @@ is_rb(const struct detailed_timing *descriptor, void *data)
 	if (!is_display_descriptor(descriptor, EDID_DETAIL_MONITOR_RANGE))
 		return;
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.flags) != 10);
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.cvt.flags) != 15);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.flags) != 10);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.formula.cvt.flags) != 15);
 
 	if (descriptor->data.other_data.data.range.flags == DRM_EDID_CVT_SUPPORT_FLAG &&
 	    descriptor->data.other_data.data.range.formula.cvt.flags & DRM_EDID_CVT_FLAGS_REDUCED_BLANKING)
@@ -3237,7 +3237,7 @@ find_gtf2(const struct detailed_timing *descriptor, void *data)
 	if (!is_display_descriptor(descriptor, EDID_DETAIL_MONITOR_RANGE))
 		return;
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.flags) != 10);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.flags) != 10);
 
 	if (descriptor->data.other_data.data.range.flags == DRM_EDID_SECONDARY_GTF_SUPPORT_FLAG)
 		*res = descriptor;
@@ -3251,7 +3251,7 @@ drm_gtf2_hbreak(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.hfreq_start_khz) != 12);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.formula.gtf2.hfreq_start_khz) != 12);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.hfreq_start_khz * 2 : 0;
 }
@@ -3263,7 +3263,7 @@ drm_gtf2_2c(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.c) != 13);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.formula.gtf2.c) != 13);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.c : 0;
 }
@@ -3275,7 +3275,7 @@ drm_gtf2_m(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.m) != 14);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.formula.gtf2.m) != 14);
 
 	return descriptor ? le16_to_cpu(descriptor->data.other_data.data.range.formula.gtf2.m) : 0;
 }
@@ -3287,7 +3287,7 @@ drm_gtf2_k(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.k) != 16);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.formula.gtf2.k) != 16);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.k : 0;
 }
@@ -3299,7 +3299,7 @@ drm_gtf2_2j(const struct drm_edid *drm_edid)
 
 	drm_for_each_detailed_block(drm_edid, find_gtf2, &descriptor);
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.formula.gtf2.j) != 17);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.formula.gtf2.j) != 17);
 
 	return descriptor ? descriptor->data.other_data.data.range.formula.gtf2.j : 0;
 }
@@ -3312,7 +3312,7 @@ get_timing_level(const struct detailed_timing *descriptor, void *data)
 	if (!is_display_descriptor(descriptor, EDID_DETAIL_MONITOR_RANGE))
 		return;
 
-	BUILD_BUG_ON(offsetof(typeof(*descriptor), data.other_data.data.range.flags) != 10);
+	BUILD_BUG_ON(offsetofp(descriptor, data.other_data.data.range.flags) != 10);
 
 	switch (descriptor->data.other_data.data.range.flags) {
 	case DRM_EDID_DEFAULT_GTF_SUPPORT_FLAG:
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 9e01f8b2079a..0c05babc6779 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -101,8 +101,8 @@ void i915_gem_object_init(struct drm_i915_gem_object *obj,
 	 * A gem object is embedded both in a struct ttm_buffer_object :/ and
 	 * in a drm_i915_gem_object. Make sure they are aliased.
 	 */
-	BUILD_BUG_ON(offsetof(typeof(*obj), base) !=
-		     offsetof(typeof(*obj), __do_not_access.base));
+	BUILD_BUG_ON(offsetofp(obj, base) !=
+		     offsetofp(obj, __do_not_access.base));
 
 	spin_lock_init(&obj->vma.lock);
 	INIT_LIST_HEAD(&obj->vma.list);
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index b2442f05825e..bd2468e34ac8 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -263,7 +263,7 @@ static struct active_node *__active_lookup(struct i915_active *ref, u64 idx)
 			return it;
 	}
 
-	BUILD_BUG_ON(offsetof(typeof(*it), node));
+	BUILD_BUG_ON(offsetofp(it, node));
 
 	/* While active, the tree can only be built; not destroyed */
 	GEM_BUG_ON(i915_active_is_idle(ref));
diff --git a/drivers/gpu/drm/i915/i915_sw_fence_work.c b/drivers/gpu/drm/i915/i915_sw_fence_work.c
index 366418108f78..4b3c94355ba1 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence_work.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence_work.c
@@ -70,7 +70,7 @@ static void fence_release(struct dma_fence *fence)
 
 	i915_sw_fence_fini(&f->chain);
 
-	BUILD_BUG_ON(offsetof(typeof(*f), dma));
+	BUILD_BUG_ON(offsetofp(f, dma));
 	dma_fence_free(&f->dma);
 }
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
index 63aa30f94747..8dafb9bddf23 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
@@ -1169,7 +1169,7 @@ r535_gsp_shared_init(struct nvkm_gsp *gsp)
 	cmdq->tx.msgCount = (cmdq->tx.size - cmdq->tx.entryOff) / cmdq->tx.msgSize;
 	cmdq->tx.writePtr = 0;
 	cmdq->tx.flags = 1;
-	cmdq->tx.rxHdrOff = offsetof(typeof(*cmdq), rx.readPtr);
+	cmdq->tx.rxHdrOff = offsetofp(cmdq, rx.readPtr);
 
 	msgq = gsp->shm.msgq.ptr;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index a9136a6523cb..7aa03e0de6f6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2609,12 +2609,12 @@ static int vmw_cmd_dx_check_subresource(struct vmw_private *dev_priv,
 		};
 	} *cmd;
 
-	BUILD_BUG_ON(offsetof(typeof(*cmd), r_body.sid) !=
-		     offsetof(typeof(*cmd), sid));
-	BUILD_BUG_ON(offsetof(typeof(*cmd), i_body.sid) !=
-		     offsetof(typeof(*cmd), sid));
-	BUILD_BUG_ON(offsetof(typeof(*cmd), u_body.sid) !=
-		     offsetof(typeof(*cmd), sid));
+	BUILD_BUG_ON(offsetofp(cmd, r_body.sid) !=
+		     offsetofp(cmd, sid));
+	BUILD_BUG_ON(offsetofp(cmd, i_body.sid) !=
+		     offsetofp(cmd, sid));
+	BUILD_BUG_ON(offsetofp(cmd, u_body.sid) !=
+		     offsetofp(cmd, sid));
 
 	cmd = container_of(header, typeof(*cmd), header);
 	return vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 5301e4f21ade..2d0be579e0b2 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -780,7 +780,7 @@ int bnxt_qplib_post_srq_recv(struct bnxt_qplib_srq *srq,
 	srqe->wqe_type = wqe->type;
 	srqe->flags = wqe->flags;
 	srqe->wqe_size = wqe->num_sge +
-			((offsetof(typeof(*srqe), data) + 15) >> 4);
+			((offsetofp(srqe, data) + 15) >> 4);
 	srqe->wr_id[0] = cpu_to_le32((u32)next);
 	srq->swq[next].wr_id = wqe->wr_id;
 
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 644c2f1cd8e6..0ea8048d81f3 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1108,7 +1108,7 @@ static int uvc_v4l2_get_xu_mapping(struct uvc_xu_control_mapping *kp,
 static int uvc_v4l2_put_xu_mapping(const struct uvc_xu_control_mapping *kp,
 			struct uvc_xu_control_mapping32 __user *up)
 {
-	if (copy_to_user(up, kp, offsetof(typeof(*up), menu_info)) ||
+	if (copy_to_user(up, kp, offsetofp(up, menu_info)) ||
 	    put_user(kp->menu_count, &up->menu_count))
 		return -EFAULT;
 
@@ -1147,7 +1147,7 @@ static int uvc_v4l2_get_xu_query(struct uvc_xu_control_query *kp,
 static int uvc_v4l2_put_xu_query(const struct uvc_xu_control_query *kp,
 			struct uvc_xu_control_query32 __user *up)
 {
-	if (copy_to_user(up, kp, offsetof(typeof(*up), data)))
+	if (copy_to_user(up, kp, offsetofp(up, data)))
 		return -EFAULT;
 	return 0;
 }
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 9b6c44979b4e..edaf1fab04cc 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1041,7 +1041,7 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	set = &request->request_msg.msg.set_req;
 	set->oid = RNDIS_OID_GEN_CURRENT_PACKET_FILTER;
 	set->info_buflen = sizeof(u32);
-	set->info_buf_offset = offsetof(typeof(*set), info_buf);
+	set->info_buf_offset = offsetofp(set, info_buf);
 	memcpy(set->info_buf, &new_filter, sizeof(u32));
 
 	ret = rndis_filter_send_request(dev, request);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 0982e60842b1..72e45564b5ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -736,7 +736,7 @@ static void iwl_parse_dbg_tlv_assert_tables(struct iwl_drv *drv,
 	u32 length = le32_to_cpu(tlv->length);
 	u32 addr;
 
-	if (length < offsetof(typeof(*region), special_mem) +
+	if (length < offsetofp(region, special_mem) +
 		     sizeof(region->special_mem))
 		return;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index e2382be8edd7..c2f3f2f7d838 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -625,7 +625,7 @@ void iwl_mvm_rs_fw_rate_init(struct iwl_mvm *mvm,
 	cfg_cmd.sta_id = mvm_link_sta->sta_id;
 
 	lq_sta = &mvm_link_sta->lq_sta.rs_fw;
-	memset(lq_sta, 0, offsetof(typeof(*lq_sta), pers));
+	memset(lq_sta, 0, offsetofp(lq_sta, pers));
 
 	rcu_read_unlock();
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index d1619a229d8f..4bbcc17d417f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2939,7 +2939,7 @@ static void rs_drv_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lockdep_assert_held(&mvmsta->deflink.lq_sta.rs_drv.pers.lock);
 
 	/* clear all non-persistent lq data */
-	memset(lq_sta, 0, offsetof(typeof(*lq_sta), pers));
+	memset(lq_sta, 0, offsetofp(lq_sta, pers));
 
 	sband = hw->wiphy->bands[band];
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 58ee5efc3b5e..e839ea321f1a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2605,7 +2605,7 @@ static void rtw89_vif_sync_bcn_tsf(struct rtw89_vif_link *rtwvif_link,
 {
 	struct ieee80211_mgmt *mgmt = (typeof(mgmt))hdr;
 
-	if (len < offsetof(typeof(*mgmt), u.beacon.variable))
+	if (len < offsetofp(mgmt, u.beacon.variable))
 		return;
 
 	WRITE_ONCE(rtwvif_link->sync_bcn_tsf, le64_to_cpu(mgmt->u.beacon.timestamp));
diff --git a/drivers/platform/chrome/cros_ec_lightbar.c b/drivers/platform/chrome/cros_ec_lightbar.c
index 96dde19b15fa..f45fa7e069a9 100644
--- a/drivers/platform/chrome/cros_ec_lightbar.c
+++ b/drivers/platform/chrome/cros_ec_lightbar.c
@@ -460,7 +460,7 @@ static ssize_t sequence_store(struct device *dev, struct device_attribute *attr,
 	param = (struct ec_params_lightbar *)msg->data;
 	param->cmd = LIGHTBAR_CMD_SEQ;
 	param->seq.num = num;
-	msg->outsize = offsetof(typeof(*param), seq) + sizeof(param->seq);
+	msg->outsize = offsetofp(param, seq) + sizeof(param->seq);
 	msg->insize = 0;
 	ret = lb_throttle();
 	if (ret)
@@ -508,7 +508,7 @@ static ssize_t program_store(struct device *dev, struct device_attribute *attr,
 		 * Bound the payload strictly by the maximum value the structural
 		 * size field can natively support.
 		 */
-		extra_bytes = offsetof(typeof(*param), set_program_ex) +
+		extra_bytes = offsetofp(param, set_program_ex) +
 			sizeof(param->set_program_ex);
 		max_size = min_t(size_t, ec->ec_dev->max_request - extra_bytes,
 				 type_max(typeof(param->set_program_ex.size)));
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 20b1aef455c4..470fba1047f3 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -185,7 +185,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 				    comp_status, ct_rsp->header.response);
 				ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha,
 				    0x2078, ct_rsp,
-				    offsetof(typeof(*ct_rsp), rsp));
+				    offsetofp(ct_rsp, rsp));
 				rval = QLA_INVALID_COMMAND;
 			} else
 				rval = QLA_SUCCESS;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 59ec5605930b..62086459d60d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3225,7 +3225,7 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	uint32_t *iter = (uint32_t *)stats;
-	ushort dwords = offsetof(typeof(*stats), link_up_cnt)/sizeof(*iter);
+	ushort dwords = offsetofp(stats, link_up_cnt)/sizeof(*iter);
 	struct qla_hw_data *ha = vha->hw;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1084,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3c412c7fb6fe..cbdc22b24227 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6263,7 +6263,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 
 	if (qla25xx_rdp_rsp_reduce_size(vha, purex)) {
 		rsp_payload_length =
-		    offsetof(typeof(*rsp_payload), optical_elmt_desc);
+		    offsetofp(rsp_payload, optical_elmt_desc);
 		ql_dbg(ql_dbg_init, vha, 0x0181,
 		    "Reducing RSP payload length to %u bytes...\n",
 		    rsp_payload_length);
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index f96b9eb15126..6640fe0299dd 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -7,7 +7,7 @@
 #include "qla_tmpl.h"
 
 #define ISPREG(vha)	(&(vha)->hw->iobase->isp24)
-#define IOBAR(reg)	offsetof(typeof(*(reg)), iobase_addr)
+#define IOBAR(reg)	offsetofp((reg), iobase_addr)
 #define IOBASE(vha)	IOBAR(ISPREG(vha))
 #define INVALID_ENTRY ((struct qla27xx_fwdt_entry *)0xffffffffffffffffUL)
 
@@ -722,7 +722,7 @@ static struct qla27xx_fwdt_entry *
 qla27xx_fwdt_entry_t275(struct scsi_qla_host *vha,
 	struct qla27xx_fwdt_entry *ent, void *buf, ulong *len)
 {
-	ulong offset = offsetof(typeof(*ent), t275.buffer);
+	ulong offset = offsetofp(ent, t275.buffer);
 	ulong length = le32_to_cpu(ent->t275.length);
 	ulong size = le32_to_cpu(ent->hdr.size);
 	void *buffer = ent->t275.buffer;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index bec6ca38375b..5443ef3978b7 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -570,7 +570,7 @@ fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 	event->event_code = event_code;
 	if (data_len)
 		memcpy(event->event_data_flex, data_buf, data_len);
-	padding = len - offsetof(typeof(*event), event_data_flex) - data_len;
+	padding = len - offsetofp(event, event_data_flex) - data_len;
 	memset(event->event_data_flex + data_len, 0, padding);
 
 	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS,
diff --git a/fs/readdir.c b/fs/readdir.c
index f2288841337a..275ed265bcc4 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -22,7 +22,7 @@
 #include <linux/compat.h>
 #include <linux/uaccess.h>
 
-#define dirent_size(dirent, len) offsetof(typeof(*(dirent)), d_name[len])
+#define dirent_size(dirent, len) offsetofp((dirent), d_name[len])
 
 /*
  * Some filesystems were never converted to '->iterate_shared()'
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2936b38de98f..5024643b4bf1 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3195,7 +3195,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 	io_req->ParameterCount = io_req->TotalParameterCount;
 	io_req->ParameterOffset = cpu_to_le32(0);
 	io_req->DataCount = io_req->TotalDataCount;
-	io_req->DataOffset = cpu_to_le32(offsetof(typeof(*io_req), Data));
+	io_req->DataOffset = cpu_to_le32(offsetofp(io_req, Data));
 	io_req->SetupCount = 4;
 	io_req->SubCommand = cpu_to_le16(NT_TRANSACT_IOCTL);
 	io_req->FunctionCode = cpu_to_le32(FSCTL_SET_REPARSE_POINT);
@@ -5968,7 +5968,7 @@ int CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	param_offset = offsetof(struct smb_com_transaction2_spi_req,
 				InformationLevel);
 	offset = param_offset + params;
-	data_offset = (char *)pSMB + offsetof(typeof(*pSMB), hdr.Protocol) + offset;
+	data_offset = (char *)pSMB + offsetofp(pSMB, hdr.Protocol) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 	pSMB->DataOffset = cpu_to_le16(offset);
 	pSMB->SetupCount = 1;
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 3a27773186ae..99d7b3d38aa9 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1042,7 +1042,7 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 				     struct cifs_open_info_data *data)
 {
 	int len = le16_to_cpu(buf->ReparseDataLength);
-	int data_offset = offsetof(typeof(*buf), Target) - offsetof(typeof(*buf), Version);
+	int data_offset = offsetofp(buf, Target) - offsetofp(buf, Version);
 	int symname_utf8_len;
 	__le16 *symname_utf16;
 	int symname_utf16_len;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f909e2b25158..715b12bc3d7c 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -306,7 +306,7 @@ xchk_xattr_local_entry(
 	char				*name_end;
 	unsigned int			namesize;
 
-	name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+	name_end = (char *)lentry + offsetofp(lentry, nameval[0]);
 	if (name_end > buf_end) {
 		xchk_da_set_corrupt(ds, level);
 		return 0;
@@ -341,7 +341,7 @@ xchk_xattr_remote_entry(
 	char				*name_end;
 	unsigned int			namesize;
 
-	name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+	name_end = (char *)rentry + offsetofp(rentry, name[0]);
 	if (name_end > buf_end) {
 		xchk_da_set_corrupt(ds, level);
 		return 0;
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 720090895c20..1d852617eda3 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -294,7 +294,7 @@ xrep_xattr_salvage_local_attr(
 	 * Decode the leaf local entry format.  If something seems wrong, we
 	 * junk the attribute.
 	 */
-	name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+	name_end = (char *)lentry + offsetofp(lentry, nameval[0]);
 	if (name_end > buf_end)
 		return 0;
 	value = &lentry->nameval[lentry->namelen];
@@ -348,7 +348,7 @@ xrep_xattr_salvage_remote_attr(
 	 * junk the attribute.  Note that we should never find a zero-length
 	 * remote attribute value.
 	 */
-	name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+	name_end = (char *)rentry + offsetofp(rentry, name[0]);
 	if (name_end > buf_end)
 		return 0;
 	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d99e2a732723..69e939a95567 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -364,7 +364,7 @@ xchk_dir_check_entry(
 	unsigned int			advance;
 
 	/* must have namelen */
-	advance = offsetof(typeof(*dep), name);
+	advance = offsetofp(dep, name);
 	if (iter_off + advance >= end) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		return -1;
@@ -464,7 +464,7 @@ xchk_dir_rec(
 		int				advance;
 
 		/* must have freetag */
-		advance = offsetof(typeof(*dup), length);
+		advance = offsetofp(dup, length);
 		if (iter_off + advance >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 518e15d93d3b..5446687f751e 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -501,7 +501,7 @@ xrep_dir_recover_entry(
 	int				error;
 
 	/* must have namelen */
-	advance = offsetof(typeof(*dep), name);
+	advance = offsetofp(dep, name);
 	if (offset + advance >= end)
 		return 0;
 
@@ -546,7 +546,7 @@ xrep_dir_recover_data(
 			return error;
 
 		/* must have freetag */
-		advance = offsetof(typeof(*dup), length);
+		advance = offsetofp(dup, length);
 		if (offset + advance >= end)
 			break;
 
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index a240638f69e5..2ff7361739a6 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -388,7 +388,7 @@ __futex_hash(union futex_key *key, struct futex_private_hash *fph, struct futex_
 	}
 #endif
 
-	hash = jhash2((u32 *)key, offsetof(typeof(*key), both.offset) / sizeof(u32),
+	hash = jhash2((u32 *)key, offsetofp(key, both.offset) / sizeof(u32),
 		      key->both.offset);
 
 	if (node == FUTEX_NO_NODE) {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3396f177a18d..fca96a59e201 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -451,8 +451,8 @@ EXPORT_SYMBOL(ip_output);
  */
 static void ip_copy_addrs(struct iphdr *iph, const struct flowi4 *fl4)
 {
-	BUILD_BUG_ON(offsetof(typeof(*fl4), daddr) !=
-		     offsetof(typeof(*fl4), saddr) + sizeof(fl4->saddr));
+	BUILD_BUG_ON(offsetofp(fl4, daddr) !=
+		     offsetofp(fl4, saddr) + sizeof(fl4->saddr));
 
 	iph->saddr = fl4->saddr;
 	iph->daddr = fl4->daddr;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 303d0102519a..a8f944f43a30 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2526,7 +2526,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 	hash2 = 0;
 	hslot = udp_hashslot(udptable, net, hnum);
 	use_hash2 = hslot->count > 10;
-	offset = offsetof(typeof(*sk), sk_node);
+	offset = offsetofp(sk, sk_node);
 
 	if (use_hash2) {
 		hash2_any = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum) &
@@ -2534,7 +2534,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		hash2 = ipv4_portaddr_hash(net, daddr, hnum) & udptable->mask;
 start_lookup:
 		hslot = &udptable->hash2[hash2].hslot;
-		offset = offsetof(typeof(*sk), __sk_common.skc_portaddr_node);
+		offset = offsetofp(sk, __sk_common.skc_portaddr_node);
 	}
 
 	sk_for_each_entry_offset_rcu(sk, node, &hslot->head, offset) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 59f9872c3552..91bdf3cb506b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -962,7 +962,7 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 	hash2 = 0;
 	hslot = udp_hashslot(udptable, net, hnum);
 	use_hash2 = hslot->count > 10;
-	offset = offsetof(typeof(*sk), sk_node);
+	offset = offsetofp(sk, sk_node);
 
 	if (use_hash2) {
 		hash2_any = ipv6_portaddr_hash(net, &in6addr_any, hnum) &
@@ -970,7 +970,7 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		hash2 = ipv6_portaddr_hash(net, daddr, hnum) & udptable->mask;
 start_lookup:
 		hslot = &udptable->hash2[hash2].hslot;
-		offset = offsetof(typeof(*sk), __sk_common.skc_portaddr_node);
+		offset = offsetofp(sk, __sk_common.skc_portaddr_node);
 	}
 
 	sk_for_each_entry_offset_rcu(sk, node, &hslot->head, offset) {
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 01d6703767c6..5b2bd1c495ea 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -493,8 +493,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		ieee80211_retrieve_addba_ext_data(sta,
 						  mgmt->u.action.addba_req.variable,
 						  len -
-						  offsetof(typeof(*mgmt),
-							   u.action.addba_req.variable),
+						  offsetofp(mgmt, u.action.addba_req.variable),
 						  &buf_size);
 
 	__ieee80211_start_rx_ba_session(sta, dialog_token, timeout,
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f3ecdd8601a0..a49e4798e9fa 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -990,8 +990,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 	ieee80211_retrieve_addba_ext_data(sta,
 					  mgmt->u.action.addba_resp.variable,
-					  len - offsetof(typeof(*mgmt),
-							 u.action.addba_resp.variable),
+					  len - offsetofp(mgmt, u.action.addba_resp.variable),
 					  &buf_size);
 
 	buf_size = min(buf_size, local->hw.max_tx_aggregation_subframes);
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index f3c5a9f6ec7c..5eca72f82188 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -1068,7 +1068,7 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 	bool inside_multilink = false;
 
 	BUILD_BUG_ON(sizeof(empty_non_inheritance) != empty_non_inheritance[1] + 2);
-	BUILD_BUG_ON(offsetof(typeof(*elems_parse), elems) != 0);
+	BUILD_BUG_ON(offsetofp(elems_parse, elems) != 0);
 
 	/* cannot parse for both a specific link and non-transmitted BSS */
 	if (WARN_ON(params->link_id >= 0 && params->bss))
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 68bd64328937..8e80aa1e6e35 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1767,7 +1767,7 @@ ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tdls_data *tf = (void *)skb->data;
 	bool local_initiator;
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-	int baselen = offsetof(typeof(*tf), u.chan_switch_resp.variable);
+	int baselen = offsetofp(tf, u.chan_switch_resp.variable);
 	struct ieee80211_tdls_ch_sw_params params = {};
 	int ret;
 
@@ -1868,7 +1868,7 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_band band;
 	struct ieee80211_tdls_data *tf = (void *)skb->data;
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-	int baselen = offsetof(typeof(*tf), u.chan_switch_req.variable);
+	int baselen = offsetofp(tf, u.chan_switch_req.variable);
 	struct ieee80211_tdls_ch_sw_params params = {};
 	int ret = 0;
 
diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index ed5fe746d438..99022e057731 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -9656,7 +9656,7 @@ static long scarlett2_hwdep_write(struct snd_hwdep *hw,
 
 	/* Calculate the maximum permitted in data[] */
 	const size_t max_data_size = SCARLETT2_FLASH_RW_MAX -
-				     offsetof(typeof(*req), data);
+				     offsetofp(req, data);
 
 	/* If erasing, wait for it to complete */
 	if (private->flash_write_state ==

-- 
2.56.0

