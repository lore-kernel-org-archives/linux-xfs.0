Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.83.56
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899070;
	b=XQl4QHUyPbYfypBrz95OFobTl8ehggGFYeKFzvuusFSW42PuiUVVMlGRgyz4+uvXheeE
	 65ZeY6pmU/Q1mUyFSX415+nd8IvAExNMAILTj8BCv0acAcLDUveks+T8zrMQhW/NRaNWF
	 9c1Yb/RMlq5X+aNBONH63R19rMh9Bv9CpDO2kmh9llJhAPp8Ev9d1RJNhccYwVbxRd+zM
	 z+ArmUr5+xk4sshjbswL/9aEBtvY+cBj3wGJyK6IQNJIV1paBou4B8JRscBs6OOSmoHuk
	 2k+M4DELiAhA+QOw70zcVfP2KRvXNziBrRiTNvyBTp6JElxhtR7EcdopIya3ao/VcRA==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899070;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Authentication-Results-Original:Received:Received:From:
	 Subject:Date:Message-Id:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-ClientProxiedBy:
	 MIME-Version:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 NoDisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
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
	bh=eTpVa0KXLbeyN7w0naRmQVXV/ayHx+u2by3c7Xc6o7k=;
	b=THJf/+Z13NexPT2qAArQV0MttPvTOHkTDNwcS3ssb0oThxlrXB/A2s5mlR4LBHXAltF/
	 t3ZZS7z2oDxg8S974ASZBm4QwyMFE1JF65d8Pt4ZsvcdRIWLFeFw4C76scp+Do96/pnEZ
	 PF1PVun5c6AIk8O0jhR6qCKNK738nshQALlfqjEmmrNfJt3PDw0A1j6va2FsneXkNB92D
	 CSxwIFFxUqsM2mLeoKw8k/J6qth9lLj9QCSPd9JE3DLfzFBzj+UEm9JwmlPLNu/3YfBaE
	 nC+Fma6VcfbA7+YqKZUIQ8tsKjPgTmvCIc6fRzB+y8IDoUdg6bYb1CYVZ3iyRGgQ0nQ==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=CaIAN5N4;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=CaIAN5N4;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.83.56
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013056.outbound.protection.outlook.com [52.101.83.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C43606A337;
	Thu,  5 Nov 2026 17:17:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84C43606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=CaIAN5N4;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=CaIAN5N4
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GG6uJ8vdVbG/ZshwMLun5UaB20DrITtL5jQXXrRI+bbYLsjt4qEEfwckmqjUrxhlGfNTayj7KInnpkETog3FrFmXmM6QLszE3H+ibid1iaIL0SP9dMQBD2LA8Z9MxM+ODbZhF7w6RZrrtKHOk/xGXf120447XR19BMvVY4ShxbMn0LsH9c6ZUbk5z4rL+REdb7UnRt2thWiF4oZ9IEWWDjHNPdKBcDBnTjOK3dwtqTPU3f4H6UPFgD92eWMbrPNwANdrWPrIcGLPH4eWFYAKnqsUJjI7hKmjUtk9Y3pcZYgXqyJUTqLDPey1k3y5mqUAXpJoIFVj5eMYiNkmKOU3tw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTpVa0KXLbeyN7w0naRmQVXV/ayHx+u2by3c7Xc6o7k=;
 b=N98R7wcm6n1eL4iAYorGbYYRZtwosX3HetQf30r6kQRDNniij+r7FpoCSyJyhm278OVtC5qkD9GdVB5Xg4YJcbrr0ig9MslWif8tF4dwLIwm1H94gZ62SxASfG+XnoVXi3MShPdPaGvlnEp9eKqo7LbZot2KLYOymcypEVn6bLwathE3VIibSUZP5ENYQNbU32E0RPeaTHyC/213E0QR5qESKym2NXcpqXDajvc6Zi6barvJLzZi6+fmC2+kBQt6NHLwyo6Wcna7GJrEISY3+nVHqyvYQSt1Lc12oSR8oL1iV/Ka5P0R8nQA+mYhR+NrkaVkRbuDPlgn9I23UJ2NNA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTpVa0KXLbeyN7w0naRmQVXV/ayHx+u2by3c7Xc6o7k=;
 b=CaIAN5N4KxHcigNOYRbk45xUO2LtjBwP1RcO6UocUwkLmLngtuH1PFm1W9qK070H8wGK+EAIvCMy1FmK+zskIqBAKkq1NYRD5QCr8KNA3xlgrYx00+WqKHZJ58CIKLbEGAkmo8kXeQNKaP/QVgTyeLDwpYmBJ5kP9HAUZ3Gm4Ds=
Received: from AM0P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::27)
 by GV2PR08MB771685.eurprd08.prod.outlook.com (2603:10a6:150:37f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:17:39 +0000
Received: from ZR1PEPF0000E463.eurprd04.prod.outlook.com
 (2603:10a6:208:190:cafe::7b) by AM0P190CA0017.outlook.office365.com
 (2603:10a6:208:190::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 17:17:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 ZR1PEPF0000E463.mail.protection.outlook.com (10.167.241.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Thu, 5 Nov 2026 17:17:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEZqCzho2/q+WM4A/n/O5lZPad5M03fWy6PydBnZ+pgD8xakqpjqKQ6yzLSqS9y1voz9C507lcDMwxeFMrZqYVA9Y4uxrld5ti01yE8ZMNkbbCd22kFKAy8CQbf0RXVo2BwPcwBX6ddkjgNINH3xiS3fhu7+Y4BnGPKZ61ukK31rrhDPeStjlKxEd5wwfYIZdto9ZqhnuyeKaZA/75PveSmb2cxOuRXr7L7sTPtX5kMapSYQ1d1BVkF8oOKJ5MVvk6ZvdWpLly4n6t8b5mu9U/Inzq06hBTh00rOMrwCa2/IhYypvdQ3fCeO0lchqdGchcHNya0LH1g14nFz+cQSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTpVa0KXLbeyN7w0naRmQVXV/ayHx+u2by3c7Xc6o7k=;
 b=cKmvEXKhg2kB4cgWM1cpqYzakFjRONndSFcXHpgnMGuwnfzUv/M2tx4fHwtGpMYEQrc1CJaVjdLszML62Xnh7RioTbXTZg3WfmVbj5+FYwXAiy6VBLWdKMWKlt7diBrXfStOI1+aLZAXIQBwl82A0KCpj6hA3RHcbX2tA3tZFGGijFRAoEbBypnHobn4JE6+bb+fOF9WRg6ssIspwaDJn/b2WUTKNOEeW/X3u5taONOZIeJlq66U4NQDi+Ru80g4kX6odBHezS/tEVY9iEn3A3srZlTIWpWv+r1k8GguIkQBUEU5cZVI9EOFNdngJ9r/+nf9Mysywjxr1kl/jfTTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTpVa0KXLbeyN7w0naRmQVXV/ayHx+u2by3c7Xc6o7k=;
 b=CaIAN5N4KxHcigNOYRbk45xUO2LtjBwP1RcO6UocUwkLmLngtuH1PFm1W9qK070H8wGK+EAIvCMy1FmK+zskIqBAKkq1NYRD5QCr8KNA3xlgrYx00+WqKHZJ58CIKLbEGAkmo8kXeQNKaP/QVgTyeLDwpYmBJ5kP9HAUZ3Gm4Ds=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by PAWPR08MB11487.eurprd08.prod.outlook.com
 (2603:10a6:102:509::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:17:02 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 17:17:02 +0000
From: Bence Csokas <bence.csokas@arm.com>
Subject: [PATCH 0/3] Add offsetofp() and offsetofendp() for pointer
 arithmetic
Date: Thu, 05 Nov 2026 18:16:15 +0100
Message-Id: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN+57GoC/yWM0QoCIRBFf2WZ5wS1kuhXoofRnWknSMOxCJb99
 7Qez+Wcu4JSFVI4TytUeotKyR3cboK0YL6RkbkzeOuDc/ZoCrNSK2w4eMSwP5zYztD1ZyWWz+/
 qcv2zvuKdUhv9MCIqmVgxp2VMD9RGFbbtC8SiO6aFAAAA
X-Change-ID: 20261105-offsetof-f62aa6348f0d
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
	AS8PR08MB10291:EE_|PAWPR08MB11487:EE_|ZR1PEPF0000E463:EE_|GV2PR08MB771685:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b5a8957-35f7-4f45-00fe-08df3b60b0ba
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|11063799006|261022105027099003|56012099006|261026140227099003|261021123027099003|261009221727099003|261009223027099003|261009220027099003|261102123227099003|261009223327099003|261009221227099003|261021121427099003|261028144727099003|18002099003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 VVFJelSxgClgHU9Gtoq4Np58blMsVJiYNVkaIgBD3Kda8p7uFES7uDdvskqBfhvNllgGw/qAtW12NPqaBVdvk4ZYFfnQe8laSo4WN2wZcLuV+6Ls+MvKPlHwMhcfL1RbKgblJo4i2rUS4jjtMhyz9qo2xvragkBFn34kbxM0iTHnsaN+gPhD67b/IcF3r6HVLcTNOnHRFMUpcf0+iLjkpRnYRUbrab/PHeOmbGtNro95TN9UsPvdhO6PldzlHPKf7ZZNJlpOSOh7OwLdtD0zysxFHY/C+b+ylXuYjsxqMQp9b+9BaEY0xf0L/3c4iA24o34oyh+UQi6dBvRJrDf6sW65Bz+VcdQqeUAkV0fGA6G10BtY8jy14IU1qHwZRGJm81pK4CX/E/o/7Amv2GxssrvtcJxbffPt37eOt+KSCMhp2CiUH5XN1+ZBilitXmoJivb5+2OWAoS6HLj95IdkmifoK+ovvckzuZXk/tavkwbXj5IakXLNZKy0L0r8lbrSQHC1Jy7nsmCQzJ2YWOamUbE8RA1sTgFPOpaCWWY5f1bL+jIPUHlEJpp791vLT/aQpcpVxHyR3vrpDYKvtgzfMu9aQaV+owbl9mB/ToTaBlQPYyEwiDcHLU+UHpbFGGdh/O1LYM9NItuCQfFZYumxpmoXSIDncDmWCUStHnEWJgFdqQxNQg1EcyeceAdb8xthdWSjR5qTTNbbstdKE8Al0w==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(11063799006)(261022105027099003)(56012099006)(261026140227099003)(261021123027099003)(261009221727099003)(261009223027099003)(261009220027099003)(261102123227099003)(261009223327099003)(261009221227099003)(261021121427099003)(261028144727099003)(18002099003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 i5Kdf4NVZB3qcEAKDEN8z3u/rEwYL5shrfrJ1u4X4MdMG+lv2DetnqLTnq31fZAnRYwiGzTgsf1oSpi6saZ75HkcUyx/3h98hXWOJlEPjrXUxg3OOBcysY7P3N55lMhG1Z2fNqG6Lak8blwYov+ix693fusE9l2kYOOApblXSbjK2x9WPTbcqM3wNFzOHQdk7H40neNVxiHnw60Ipx4+wODymJasqclub/qBHqK5Ml65fFKx36twCtDVU8LAtOt18dKbnZ0OUi7tvrv1F/Lty2sqVckwZdsOrP3RcW2owtVjVO0adkKnEIafdOw9MKYaTfJCIErf6dFsSeTV9WbIGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11487
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 ZR1PEPF0000E463.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3915e4d8-3158-4aa3-5d0f-08df3b609ba5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|14060799003|7416014|23010399003|376014|35042699022|18002099003|10067099003|3023799007|921020|56012099006|261021121427099003|11063799006|261026140227099003|261102123227099003|261028144727099003|261021123027099003|261009220027099003|261009221727099003|261022105027099003|261009221227099003|261009223027099003|261009223327099003;
X-Microsoft-Antispam-Message-Info:
	xaTR01x5s7BMEbGxoLAsOEFegz36gDBiuZulOVnD+y7uvR3pHE4TSEf6RgNpEVEsfG2qL7dCGrqWlP0O626OxQVdSW5YCD9Ti/tD6OLvOIbKaLFDkdswbu0CHZmaS/DYLzgGTr5z4Xion4SBpbnEvTaGHL07OG0z/RFytwVGXIkRAbkgwlZeotXxmfqUwXhdSQ0KUhX5K7IPmS+CCAlazBuMPWYe39CRYzvO6qpmM6lXPksExTlKvTQt3WbeGQyMxyl9H3f/sDLN2Tp/iWKeYw8HQWoUEjKNs0z9MrC2J7OStOteWx8SNO6mbDELwKQIO5sWgBGg1o3sWOMyEzCR6JhAt4YnR8saclaKknGXR5RLAsl+EsJVKagkdEzbW5q5W7ia9J5PZXBoZ3cWp9R6cykXMZhRiE/ol0HKc8jcQy/1+3XBzy3vVm6bNrf/yU0aKuEnRMT383hq9Z/2aVOgZB4p4B2UlF0KsrmmOsRPzSGWGpCjz4Bz8OWu+NhEd+y4ddHSW2oww5Dy/O0fIhzQltVFKOLx9Uf5gQcXpTDPh7TeCBIJwEWIUQEpm4z14VULIvArkAnEPqD1MYge+nwwrCOv8W5Lg14BN6kAQM3noxuqZ6yBk6ByoroqCmKGvBlGTGfoxzROvVBnUtOjpglWONckE8a8aNVtyIToTSx/vSDi58iY1OTO4QNa5jSq5OFqjKhxwgfgWtr17dxJyIdfuYGwG2/Xrllhl3YiEQkvQ2r5pqbQiveg8yyLJrUc3uwm
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(14060799003)(7416014)(23010399003)(376014)(35042699022)(18002099003)(10067099003)(3023799007)(921020)(56012099006)(261021121427099003)(11063799006)(261026140227099003)(261102123227099003)(261028144727099003)(261021123027099003)(261009220027099003)(261009221727099003)(261022105027099003)(261009221227099003)(261009223027099003)(261009223327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MUnEkuw+NPVM5RfE+sjkYO/GaipHcyy8aMPP+oiwXbnnsogw5LiNxUtT40N6NqtdrIFA4ppWvZ0HHWv/j44BSei76NRk9uAziSF9n/skydjfBZRm/63Gs45SE0Do+4fWNP6PLJDqlIiccjbHXad2P5x4dsBoNr2GHBl4EKX8hJENKll7WI/x//iTk1PyIYyZ8bD2Tlpts2VfuH5D7g84+4A2ZWLSwBUsF40/c5d6Iua7Xn8QP3ywLpvF6z2PL8YNictFIaFYvZe5tdtLl64U3Vl8NztCgIXkJKtPxBEYwXN+wxa9N5JCi1YtPvYP8HWaLwlkmFxBdD87sa3b7kKUNcbpYdsTRmHvxAOt7t0UZ33jq+I5w2RFP76bgJrRUaOdg/tr7Fx4gwqCURQDYQR1AWfd0fzkg6BnlHHnKUGDrRLdYOURqFZqTgHYZEkBpqjR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:17:37.6388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5a8957-35f7-4f45-00fe-08df3b60b0ba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	ZR1PEPF0000E463.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB771685

A common usage pattern for offsetof() is the following:

  offsetof(typeof(*ptr), member)

Condense this operation to one macro for a more maintainable code base.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
Bence Csokas (3):
      stddef: Add offsetofp() and offsetofendp() for pointer arithmetic
      treewide: Use offsetofendp()
      treewide: Use offsetofp()

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
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  6 ++---
 drivers/media/usb/uvc/uvc_v4l2.c                   |  4 ++--
 drivers/net/hyperv/rndis_filter.c                  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c |  5 ++---
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |  2 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  8 +++----
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  4 ++--
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
 include/linux/stddef.h                             | 16 +++++++++++++
 kernel/futex/core.c                                |  2 +-
 net/bpf/test_run.c                                 |  2 +-
 net/ipv4/ip_output.c                               |  4 ++--
 net/ipv4/udp.c                                     |  4 ++--
 net/ipv6/udp.c                                     |  4 ++--
 net/key/af_key.c                                   |  2 +-
 net/mac80211/agg-rx.c                              |  3 +--
 net/mac80211/agg-tx.c                              |  3 +--
 net/mac80211/parse.c                               |  2 +-
 net/mac80211/tdls.c                                |  4 ++--
 net/wireless/nl80211.c                             |  2 +-
 net/wireless/reg.c                                 |  2 +-
 net/wireless/scan.c                                |  2 +-
 security/landlock/net.c                            |  4 ++--
 sound/usb/mixer_scarlett2.c                        |  2 +-
 53 files changed, 113 insertions(+), 100 deletions(-)
---
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261105-offsetof-f62aa6348f0d

Best regards,
--  
Bence Csokas <bence.csokas@arm.com>

