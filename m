Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.66.28
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899073;
	b=0zIthi9MyKi4Yq34h6RuAW2hH0qwgkS5uYFrwFAfyJRCm4AZb2mxPASEryRAGE1zES0X
	 5tnzuZj7ssYrZpPVOBgP9tW8J/rroWNrvczUNKTjgGlQP8QHlxiCGs+KxVwpKW+IBFHiQ
	 kwMtZW07hY+QGzIZl8nugIT9QzsqU9su3eyF62z3E05C9qM6VeLghcIzf2HCSa3w/5GZB
	 lqJlQVt9eVWKgi4hVBonlREWC9ShXecazac/1wqziP0J76oQPpoglYAMr3XyRnPgmGjr2
	 wPZre+2+8YWx0iiSEbd3RythQn4mD2XwNANrC8tlLZTK+JEermd8/GDfT1OkCleLXyQ==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899073;
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
	bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
	b=V1e5Nf5IUzUWKmiARp0Gm8mcU1GuPRhnp+97T4LrzFVDiHG1jinBrcqTo1oMctXYLX6j
	 CKN4EmJqfpFzq1jaMeFRX6Jf3ra0d86sFawOjm/7dHjZyM3Rx9VQ12SM26iNQTZ8NCtvh
	 3NLV0MgS2aWDCTFvaWvu2bmXh5525P5OBCJYHl9uRhtbV7/YYc/QUQEv6SszVlM84ABeT
	 BIhnsgo02HEyy0tgSEny3iP1LiZ3tqm9ROsH4yS/G92jsbsIv47Z7A7IqI3fli7ldu1gR
	 dYjz578aH0Gq2UOLAW3TmMSvgUN1bUNnAhCLrykScu7mATuLsuLBi9BCJXI6KiPhXzQ==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.66.28
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012028.outbound.protection.outlook.com [52.101.66.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7811E6082BEA;
	Thu,  5 Nov 2026 17:17:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7811E6082BEA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=FSAvztfE
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=I2+pI/5xJep6r2pAFwhNiEJu9nXuffXylDvDljk+DrH186pbK4CKcDQkMzyrGj/wXWJopjt5C4QnmStR9Xh1zVbPCLe+WcpOl7jnztUs0DPuww/Xs3/Z+nPOgMawuQAkBsZjOlTLMmCxXvDVYqcoUvii4nCFgZXKKFDk4pkA3kg29hfXYjteieilj9sSSCynZj5C8wMaHL6jn/IOmtCM5GwxU3sdytUKv0/Ec9Z5175STfbT6Suw4788SxNyK/TY/JLz1vj9JjMnJQ1NtaUs24xxRSzzdFqCm4uick7zgueHcIQWGLyrptL8LFUoW+tS42j4ZFf/Ii0PP+z1Q9pg1A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=r7ebM4lhoT0Cq2d29av3eiuyPlBb61fWlvi0+z6VQsoV+RcpE80zsfB7UT/Y4S9BCFVcZY1t0G899V0m9hSzCgvA2kR/s/b18wSUfVxfZDavxt7rYlk6MGEJfpJ26NBkGKuivbDf8Cv2o6YMguaIrIwVcf/2rDDOgLnBMGZlmwMpeVhNLsyz4YglGGYQTD5tRdU9vmv+CC6Ij35K/0ETMZk/R7MZ708pUfVsdu5tAMY+DQJZvD4+/Ym6Igj4lIELioPSVDpyjvhG8izqX978+qN3uyXdquXGXThRHSQWGfW6IwHXxGJ4st0uwCO5u86O3kms1OkPBsnPhF9fE/A8wQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=FSAvztfEPnknaC/TMy3ESjhRBjjRXq/zp74UI0MrAnJj7FITg+55aSuRjoVG4owmEIiL0L3oE0wVskuug2uVtjVZjaEWIXiy0LgDR7UC1xFLYYON2o9oqNdV8uI1m8QGdPPKCWSgH/9fYPHdSEuApIdfPjc0KxYkFGmREC1m3zY=
Received: from MA3P292CA0043.ESPP292.PROD.OUTLOOK.COM (2603:10a6:250:46::17)
 by AS8PR08MB8134.eurprd08.prod.outlook.com (2603:10a6:20b:54f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 17:17:46 +0000
Received: from MA3PEPF00000407.eurprd04.prod.outlook.com
 (2603:10a6:250:46:cafe::7a) by MA3P292CA0043.outlook.office365.com
 (2603:10a6:250:46::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 17:17:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MA3PEPF00000407.mail.protection.outlook.com (10.167.241.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Thu, 5 Nov 2026 17:17:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ylgddM04/VpwnH9LjtAmsAH9Y8XtIOv3v882jdIzqIFg288FgiJWlYx0C8n3SGvCiRsqR0sxvX4K276CApFuox/5K5cH2L4igyP1FnF+QUqDRyd7h9/aYumPr9sQdWtU3uzKfx/0dNhuYDkNbvv0qnmBfbWnfgtRDYVnzAm/1k4uSHyDuw6WVcp8laiZUxT5A9t5Z29Y5xvSSfNrf0c3BG0eZhY3SEbdZTNdvWSLUlLhgr1XbTqZa0VLWIExoCxxIgefTOe/V4ZIPDC0oZcq4zlcioZAXqjJwiQsca4dn/9BeSL80tKS6mfrSLfXrkIRJ446uupm6/aFC5dLDlxerw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=XuwnLGQDwL7b0bd9imEGYO+LROwrlwX68atkLYWusea1mgDRNtXFGqvpom8Q3zP2/OaL9Njkppu13XdpwEwiPewguLwDVeBPzeeBQlGS89/R2AAs2nQZ4jlq6UFbkW8WKXWE4oAtQg59bbsp5Dul3XAG4onbNnfF0wV85ODW600rM+CvAx1iL+x0M2tP5J3av5KX9H73M3JWBWwPNrKsoGWo6GFLRRTYDUxpYe6JrEVoAwSfpOpI6FvDwh4f5vvrN7GAJSVmBM5wYQ4i+n/HquK41ppHRczPar2uV4NwnA4KoCTngFbMHCQLWcNPX6u8+zXCdLD8ECQbe5KJjxo3/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/TaJi9SnqmwvhFyBrHMq9Y3vPQStOAFo/IUZNNvXGQ=;
 b=FSAvztfEPnknaC/TMy3ESjhRBjjRXq/zp74UI0MrAnJj7FITg+55aSuRjoVG4owmEIiL0L3oE0wVskuug2uVtjVZjaEWIXiy0LgDR7UC1xFLYYON2o9oqNdV8uI1m8QGdPPKCWSgH/9fYPHdSEuApIdfPjc0KxYkFGmREC1m3zY=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by PAWPR08MB10897.eurprd08.prod.outlook.com
 (2603:10a6:102:46a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 17:17:07 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 17:17:06 +0000
From: Bence Csokas <bence.csokas@arm.com>
Date: Thu, 05 Nov 2026 18:16:16 +0100
Subject: [PATCH 1/3] stddef: Add offsetofp() and offsetofendp() for pointer
 arithmetic
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-offsetof-v1-1-4153f5c10edc@arm.com>
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
	AS8PR08MB10291:EE_|PAWPR08MB10897:EE_|MA3PEPF00000407:EE_|AS8PR08MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: e576cb7b-b28d-48aa-8ed5-08df3b60b5f8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|22082099003|10067099003|921020|11063799006|261028144727099003|261022105027099003|56012099006|261102123227099003|261026140227099003|261021121427099003;
X-Microsoft-Antispam-Message-Info-Original:
 mr5OB7YJkX4sA+UAoD5rIJy3VTvVYYdViPg9GzAW7Tq5jQNBv5IpbZJMaV/vr4lw6bNREXCtAuvO23wv5lboaGb2iyHxKueczHoZaLQruXjnJ4YsCWbLpTEYbaLN2b3JvrgYbeggZrgBqdNLIpGvM0KDUI/1Y2SuF4oHsDFUPNwtOd/2FLXh1QbEv73jXLyrVk7IWKQRsxMQyKYZF5QyCPh2HS3n1cmt4i6rX7DLoZNf9ln06GSM9GUJZzgZ9bqKU/aX5Y7Kop665I4/c4mR/yqeN6QA/MtQ4AHgb6wdpXFSZyraqBC11X7fdax/7ceQntHlN9bu9h0G4M85891n9S/oHiGnfiA+SwRWOJIEYH9ht3/94aPp8GdFObuFMlJjR9WRsVwhddQCTzRxi6NoJYQPREiL0F6SmYlaL5uwXNcrhzCeKzLeUTKfj4Fw3AL7XHfiCwpX9Jf/ZHlovSnr6Kg8NeVaS1won8b6DFaSYRRFdbvViur7VcgJphgovJ5nBuCAkXqOE0Z4lMc09/q5khyBH98Zu4ffavRIyp5gqu/c0oWEcxjDv3FpUyVNkzPANuxvwxTF6b2vxulqsbgGivqeVmRNSqfUlFyr7hL3hNZbvJums5toHYZtNQYVdZFx5mbIctvTAZoX7OmZbmBex426aM+aO0s8jTJNsdnA5fLXxFg2wvIN0XC1qJh8+wQi9EH5FRzWFRAL2zpsu+jvug==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(10067099003)(921020)(11063799006)(261028144727099003)(261022105027099003)(56012099006)(261102123227099003)(261026140227099003)(261021121427099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ET/QPDjVBSYkB8BUfVvcUDBeNRCOk2q3Cf2mO3C0HiuTAFVggj+y8VTqq6VaDo9mhlFYEEM4ZKPI5OCip1bcAZaPjBdAfEGNZKkBeeI4/g8jDco4K3dFDZ68IgTGyXZFh70/3fz4tfUqbMN9OLpR6s0kwCdHgaYyHjyJMJCqjFHz6mwxuLnanowdZomKxYxXNMKPdIdVgT0/PowPWsbP+M//dYvR2MIfHFaoeRUHiZaHcXqhixWJvo57kZjhyJCpZrE1WXDjjIhOHdXt+iT+2cpJ7P1DskNvUgaqafnjFSIhNLZNth9Z36G1pOdK2ZnP9Yx46uPe5cq4WiF3Rdz5CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10897
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MA3PEPF00000407.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a755c22f-cf8f-446b-21f1-08df3b609e27
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|23010399003|82310400026|376014|7416014|36860700016|921020|261021121427099003|11063799006|56012099006|261102123227099003|261026140227099003|261022105027099003|261028144727099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hz8hbtEDhdAbxUphjQx0+xOhR1aBOJq0Bc6eUOt3NdsBH6Xjwul7iOlaSOemi0y56c0OPQRFKJKN9tSpxz35H0jYq2k2x500svaUHb5j70auyPE0e4SxAYwA9Tdph1U+eoaQG8Rea22Yr4WKHE51lKnDrK0f7ev/Zd7qLJ9lqxZjrp63vXkAFqw/5aFuSLBQ7WNYEN23hIObC2o+KAiFU8VmpnAPu68ENJsHXz7a2cVofHb1UuWekzEtblNcawtDbEPQFroYgPKEmFC+hvI1y+Czrtn8zZ+YxLP7HRopFlR/r5A+KOorrlfr8wMHSmtW00BGEJ+2ptxedRXgLlk2/p2j4hLSiUu1f4M1ULY738yf/PXIFxd2wFGOyDVBS7gzf2pD/KY3VsIr7kU6VG7Hnwmh9HKUoUg0DrtrmoNKrZ2BRUQUWRCRG8w8Sf9p94Hkj1UhpJ1bRhrkJh6AuKeG4zlgUCDCODIbJaC5VJiZkCXV8CkmruRidz8mKFHkczzP8tkweoPoZyBGsz9EZ8NEODzWKCGCkEKKO/UyS6Un2++6jHU1uGRSJvUZsEeX4Eo7UVz2fumwjnXjePXA08sRDzZBrWy9MMXOFwROJlqQLmmX59grmNeqZeQYh1+EivaQzYxTQUHXFup8G1C8PE44Ev+SRzTrVScErg3nOc7w5IkdpcYmJykN/IpNk/gO7BwWVCTR9Oi+dJa5Tegmkt9ZMDL1Hj3VUJsUEI94TIHjW32rNYFbP1OanU9rLIcHSSUe
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(23010399003)(82310400026)(376014)(7416014)(36860700016)(921020)(261021121427099003)(11063799006)(56012099006)(261102123227099003)(261026140227099003)(261022105027099003)(261028144727099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MIosdEa/eYZc5HIzXDcF6O2cMkZugV8f5Wm6zBEpiwhh25xTCuQrH/IA7V6EZ/g/ZbRN5DmzwGNKekkH2iRI72wmi91W3fcQ6OdIawYOSjoH/V1ksw87/dAy632zLwAcT5iQPNjTh0LfJHqp5dFikWL435HTxd7FNb4U7EtOS6+IxpMcLgIQEl7tD+qs3ys7/31rzQ5wijTXpkJ+SKQRMKY2OzO1nGFonblcoxR4ZrW//wE638jLs4UQXzSbL3FL+G+QyGJ4NrVcssbaSaPy0dC+T12x+VaiG7SgkV+DSus91T3/TVD6F7QAxvjlbbC5I4nMZMxSdsfopnEdlEebYTrn2czyrRdYGNWpF39m0lqVIbiPXald/l0st0o0YnGhoXywMRwtEH//Cm0qY47yGjkROm3sk1roTazdaQ2An7EyLg7pX0HIkon6Gaq6Amns
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:17:46.4246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e576cb7b-b28d-48aa-8ed5-08df3b60b5f8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MA3PEPF00000407.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8134

Many call sites of offsetof() use it for the purpose of pointer
artihmetic. Thus, a common usage pattern is:

  offsetof(typeof(*ptr), member)

Capturing this in one macro helps keep lines short and terse, while
still making the purpose clear. It also helps discourage spelling out
the type name on every callsite, leading to more maintainable code.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
 include/linux/stddef.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index e1851c50c89b..87f0e131d235 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -32,6 +32,22 @@ enum {
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
 
+/**
+ * offsetofp() - Get the offset of a struct field from a pointer to the struct
+ *
+ * @P: Pointer to the structure
+ * @MEMBER: The member within the structure to get the start offset of
+ */
+#define offsetofp(P, MEMBER) offsetof(typeof(*(P)), MEMBER)
+
+/**
+ * offsetofendp() - Get the end of a struct field from a pointer to the struct
+ *
+ * @P: Pointer to the structure
+ * @MEMBER: The member within the structure to get the end offset of
+ */
+#define offsetofendp(P, MEMBER) offsetofend(typeof(*(P)), MEMBER)
+
 /**
  * struct_group() - Wrap a set of declarations in a mirrored struct
  *

-- 
2.56.0

