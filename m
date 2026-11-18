Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.159.3
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795003612;
	b=NdSuDTzW8brDXczW+G/EwtmGxiSaL5QRSVtKhjG8V9EcInlzo4qvaOCcLVGkDUa+ZPOY
	 tueFIkoc3ozFv3RYzebXwJg6H5CO3F7X2A/62k9xsAXbzFaO+4MnZ64mQk1v1+EFnRbDU
	 mA3oSgdzpJLXOsMFTvcohcdEDRcmdsMcwBWy7IWYYZHy35NPKNvhIsvu827Pxs5gCsOE4
	 ztkocdcOhLHqEunROsL4qBlc5K6Xxsp2NiDDkWHWYGqtCFv0mrqax+/MeC9QCjfX2yNwK
	 S/jZkllYSYPYYg6srcR8DItw4G96opaiZaN26i3RfEUCQ1Fv3lxyT2huJtWXrZ1UcTA==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003612;
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
	bh=sBiLiVHJZt1pubTAm+ktmHAi06mJEUhVPswX+ta/qkI=;
	b=cBRyr5zD40nOdWS3Spv2HhqBMHOJ65LP2baFR/t/VCSEllkoe9WOPoa/9ptgWoddknb7
	 1aa75pIPSc9muAYxdES4ijs8mrcDKo0KZjFVmqQ2IAE88T8XUCrF4IspXgb0w249Vzy5w
	 DdFWhrnePfPWZnKAGQIGO4aFjgn+jih3kho4W4PD6o479XnQ/zWRXMoBqUDNwZBNyL2LY
	 OQbpRvp6YYqhlqcAAs3677BTIDF0IpqTUKLnBcP58V/CVNwCXPzXcW7BuR3Dj7fi8TsYT
	 OExFf7i6YxPpf4wElLnw6a+9vsy6YxP1Iz962aFl63cvm+M0dGci8cII5F9p4PSFVSQ==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=LBpdmgSU;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=LBpdmgSU;
	arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.159.3
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013003.outbound.protection.outlook.com [40.107.159.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0679C606A31C;
	Wed, 18 Nov 2026 12:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0679C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=LBpdmgSU;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=LBpdmgSU
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rNgZoFm0hqG5Xw7zK5DqFxoogfUMXLoLcgeSlvzEyDzJ/V6lfpl8aiOFLsoD7l40wBDtjJ2wiXsvxSko9SDcUFT4QAlYMk+RX520wrD64azvMSx4B2dJQX3tKDyb8Fwi1oPqptVO/aX3lsyZWt+MMF7Y99io+5m+104fv2R3OM3syJE9KrEwpo+WOzWMCzApxt1K7aWQEYvl6XhysiYS5f1dx0YBtacAEq72T2hMIxcQ9F+5ZopBO/8KJochbYCSBt8R10ADH5ESMSzlax28Vo/xhPxzGc4FsiJoITBxDIIoKkxSYL8R81TkxkwSCItRJ2SrNTOg4cg/vTdIdByV7w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBiLiVHJZt1pubTAm+ktmHAi06mJEUhVPswX+ta/qkI=;
 b=NYxXy7Tz5NdxtWpr8LjOp3lTyY+XemiepEQt/EdFqQXbCalzU0ycBmGlBRayXdV/pcWvkIfN1xtdX+VNFJP3gkESXv8xzVahuazPsr/TCvaOfLH8JtnD/hsjL/XplDMEP2z4QsGIE/GadiUXExjtSUetqhEzUpnRMtyyC5EjEnbwdJgYHCDNjNJZVCb0C74TsOAwO4/BCZgQLVa89kbsTG+jn5czMFbK1jUlpRU7lzS74A8rLvgRTGLjCkdiP94ZQsDftl3VDvgkossrqL5sZbwt7MKjutQFD+gaKKA5L7bM6MuWF0XQFnzKQCOL48PFNZU2m/7mtexg9TGp+QqVuA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=broadcom.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBiLiVHJZt1pubTAm+ktmHAi06mJEUhVPswX+ta/qkI=;
 b=LBpdmgSUBwA4sxM5dN7If9+dgFpFneuwAe0qXlYVTKUm9wISiJflr52JQp30ebgmmwN28cp9XpW07rN9IQ7+hkojCs/ZXKA+15m9YHXAgXE0TCyqZbUG5bJ8DnIQsQCuqSBTMnGL69H5c8ndg/SqM191w4K+xxzDpeJ54mL+9QU=
Received: from PAZP264CA0215.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:237::29)
 by DU0PR08MB8663.eurprd08.prod.outlook.com (2603:10a6:10:401::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Wed, 18 Nov
 2026 12:06:45 +0000
Received: from MI3PEPF0000848C.eurprd02.prod.outlook.com
 (2603:10a6:102:237:cafe::82) by PAZP264CA0215.outlook.office365.com
 (2603:10a6:102:237::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 12:06:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF0000848C.mail.protection.outlook.com (10.167.240.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Wed, 18 Nov 2026 12:06:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0IPzJGMWGSU92326zf4gjel7617TXbguAPuNMVsuXVoQLz/bCGb245A1KzI3EMD2z3hwQyzq5dkiSJ6J0aZXyWZKVJc+MQypvZ32LL+2rLeIZC99Qc/nk1D0NHIa5NJ6EXER0iEaK29ZIZe9/su9e6vmr8h8+OusCLBRZWlS66gp7IcFZBGzwdhMvs4fPlZhRDdbseuQqLFt8l5l5iClspEQGyDiFNYccHBk7guQYsVuw1cm4JDfyo+RcEW27YYfN1LKsw2fMa3meOI4I7vJPy+TiM4QoeZ7FYJVKXX4bWwwOq5oCkYds0eXwgA9TJ6sqKAVIcjDTsVVU4lp+KOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBiLiVHJZt1pubTAm+ktmHAi06mJEUhVPswX+ta/qkI=;
 b=BV6RIhAY71rWVJ7FfTUURGo/COstLstirD3tfhREVZIEyg+RLPnrR3CUkPbf+B+EzS6bG/MA4doLS6DJ4et0tKxHZkeelN7g1Oqj/RcHVFMXNFW4OICACeMMifENTi0YdobJ3SAzc+KWUClNp7IHsJXuPhiXKwiwVVzIFU0KV48kxIbZGA27AMDwmYUU/8DQ3Cc6cbAn8iKhO6KtFvKZMISBTUi+EjEjsYdJQlvayVkiI7u80WVPgpX8gEc2K6yAYLlIeJv7V2URgWb0e6RPpuyoGkDBYkM2KhWqXsURnXf4Q1dVthLcfqoX3s8Ikr9/8BB2eVxkmex9pYMHyluO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBiLiVHJZt1pubTAm+ktmHAi06mJEUhVPswX+ta/qkI=;
 b=LBpdmgSUBwA4sxM5dN7If9+dgFpFneuwAe0qXlYVTKUm9wISiJflr52JQp30ebgmmwN28cp9XpW07rN9IQ7+hkojCs/ZXKA+15m9YHXAgXE0TCyqZbUG5bJ8DnIQsQCuqSBTMnGL69H5c8ndg/SqM191w4K+xxzDpeJ54mL+9QU=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by PA4PR08MB5918.eurprd08.prod.outlook.com
 (2603:10a6:102:e7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:50:31 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:50:30 +0000
From: Bence Csokas <bence.csokas@arm.com>
Subject: [PATCH v4 0/2] Add struct_offsetofend() for pointer arithmetic
Date: Wed, 18 Nov 2026 12:50:07 +0100
Message-Id: <20261118-offsetof-v4-0-95b385c10b22@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAPCQ/WoC/23OzQ7CIAwH8FcxnMXwsbHNk+9hPDAoDpMNA0g0y
 95dmAdn4vHf9td2RgG8hYCOuxl5SDZYN+VQ7XdIDXK6ArY6Z8QIE5SSGjtjAkRnsBFMSsGr1hC
 N8vjdg7HPddX58snh0d9AxeLLRC8D4N7LSQ2lNMoQwZfGYEN0/rU+kWhZ8Odeopjgitbc1IoS0
 Ook/XhQbkTlWmIbRtmGscxYI0BDy7tONL+MbxnfMJ5ZQyttGlLztuNftizLGxTLjMU3AQAA
X-Change-ID: 20261105-offsetof-f62aa6348f0d
To: Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
 Hans de Goede <hansg@kernel.org>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Benson Leung <bleung@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
 Guenter Roeck <groeck@chromium.org>, Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>, 
 Nicolas Palix <nicolas.palix@imag.fr>, 
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
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, Simon Horman <horms@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
 =?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, "Geoffrey D. Bennett" <g@b4.vu>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: Bence Csokas <bence.csokas@arm.com>, linux-hardening@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, arm-scmi@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, intel-gfx@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, cocci@inria.fr, linux-fsdevel@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org, ipsec@lists.linux.dev, 
 linux-security-module@vger.kernel.org, linux-sound@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: LO4P265CA0199.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::16) To AS8PR08MB10291.eurprd08.prod.outlook.com
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
	AS8PR08MB10291:EE_|PA4PR08MB5918:EE_|MI3PEPF0000848C:EE_|DU0PR08MB8663:EE_
X-MS-Office365-Filtering-Correlation-Id: 45639181-c2d1-455b-2168-08df456c6a26
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|261009223027099003|6133799003|18002099003|261009220027099003|261009221227099003|261009221727099003|261009223327099003|3023799007|921020|56012099006|11063799006|261026140227099003|261102123227099003|261028144727099003|261022075727099003|261022115727099003|261021123027099003|261026121527099003|261021135927099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 oLwuc5b/edBhVMqP8hQFu4yLstH5AtnnXrYm/Li/ikj1YuORIDG6smOeeWJcPZ1XyYqEaBM0VW3GRV0lHSLtE+HG0IQ5bCh7jQeLT1/Qc1hGCazrdUKQiAIuy0CgQKEgS/R7yQYeT32JETtZBOJLTqsRKGp9hlnv1S1lh3hASsM0ml2rW3giVCDr9mHzEPGMzRbqmSBTolnDOsu2SolytM1JfHh2SAKiK82WXQGYAX7IIkFyDNu0/3Pbw2/8YvWqFx455x8ubTue9ji8jxTmVkYg8FqsjZJVZph1PhyMzqL7dRVnhohJHt9aIV7o30rFWk87DD7V60yrZan/GfutZH6cQZninIPnVC/2H63CAx9jIEQP/hE8ZF3O7LvBwAagDcJaUTm2iey+ApD/0zq5OBJnJWUaFAApHVpft4vs2bsNvkjs47PwVd2xIwQr5DyoRbw0LVTiiPND6bSYTWudaIY5Z/v06Lt+QX9j2auoo4N3rDMQjISRXtQJmesuUfk6Vlssouo1emVpL2dYNnBUrEMMvGPmEQqSTBY/TSjKXLRr7FZ6AAAXERUMPwcggHvj5+TCEPdGwLCJQZEYR62HIlekNtqPHF83zskanxIblsxY3PiCH7m5/PnEX8YKr0IconjWmE9n5GYXpSuMGugFXWE3wX1A5cyUycAEO5U1xfU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(261009223027099003)(6133799003)(18002099003)(261009220027099003)(261009221227099003)(261009221727099003)(261009223327099003)(3023799007)(921020)(56012099006)(11063799006)(261026140227099003)(261102123227099003)(261028144727099003)(261022075727099003)(261022115727099003)(261021123027099003)(261026121527099003)(261021135927099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 aOXmkKx4aDCJhKDBub4F5KcGjFaYPGczWj5EPgfxxO2F+aO3ocmB91VVJFPKyjaUXs7C09HV842802+7fVLfP3j22xYHr6f0q2YjhJWSw1hTauRX80Ksm+t6/riuTqoxsqe0dS2f3jxdEJpevbryRgdJr3L+FXFvRcTQAElFf/QhDK7D7b1YAjdFgRZvsOGnOol9CpocG4Qiq8Q7kkux8Zbif/x01xCg2lBFS4d4fn+dxM0vo1ELliZjhXgV8sqIsfMjONUlB9wNfVlCJ5Gqm3SniFJA39CztMRkREYji4ty4JcF9kEOmZhsmywzzscyKNi6KgZnf39nRMYT/pIi+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5918
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF0000848C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	10554276-ef6e-4e25-9cf3-08df456a252c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|35042699022|23010399003|7416014|14060799003|261009223027099003|6133799003|18002099003|261009220027099003|261009221227099003|261009221727099003|261009223327099003|3023799007|13003099007|921020|56012099006|11063799006|261026140227099003|261102123227099003|261028144727099003|261022075727099003|261022115727099003|261021123027099003|261026121527099003|261021135927099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	59oYc01KXEIX5oJJa3UkPUfqe6obKxWBSG5g8AiyZX9v/7akdbpSHU15F630r5OkOOIShc4yjy3uiR4CZtDuQ/dvxqEgGYHUCtrTrkRf4XkRXIyFLeOqN1jo9wc4b96BAOOZ5tv6+908LmnAFhWBuMmJN01gqtTAFRywxqLH8czBPpEfCfg5PjpWOCmGFgv20J6XCuMgMpvBgGsibpemd8WxXk/k6y8jO4QmWgp2uWKAxnnL70GbFCRJIBULpvuId4ssb+nvQBRR56JpAgfgv0x7vVGB77qqIdQ5oaOfrFBfT6ATRjUEpw8PlSpxBBNj0J24+npOmb+05ZLB0ZPw8ZVHMvKnxPgNc2kuNCmQBKy7fe3rlaJs7A+Xn6HqjUcLkmTAJwdfVtfFUOaOw5ViiU8c0CA1uJWfa4ml8oF9K7EkH9ledoz1AqCaEqqLf5kaoYJJOZ6786jbALlitqugiX26zCZkkcJJmOsA/GFf+ex81kK0sKeSgRCcNTfDp+gfgTgeLBVMMwBMedX2+Cr1qIQ/zH1uzbgVp8l/jvK7TeuS0zYyR8pa4iZxmY2YI4VyarM7wZW5xJWmBvS7psLd8BG120EGysqfsmH02lLoJQp1B6t/XOrZPyWZxbeCqJ88tLT8SA2XoWNPXo7feD/VOETPXqQJGk3BiUAoaQFXNPJq+wKyLlqifJmN4DZXd4fK9CRKh/4313c2yQPGwYIfMA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(35042699022)(23010399003)(7416014)(14060799003)(261009223027099003)(6133799003)(18002099003)(261009220027099003)(261009221227099003)(261009221727099003)(261009223327099003)(3023799007)(13003099007)(921020)(56012099006)(11063799006)(261026140227099003)(261102123227099003)(261028144727099003)(261022075727099003)(261022115727099003)(261021123027099003)(261026121527099003)(261021135927099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VslN7SupWwWN3A+qWw/KA8fJ34DKJGp9Zfz9hT4qFBAXvSWMQVNEYRnWhrFfkzaqysjM8yF1vLw3Z8srhfeKYRMuCnIvlrJD4EdyvxGY9SEXvngL6/YKoAYtVIg6+OrR+QL87L2IbTpJpa/MooBAnrDkvPtNn4CguobI8eDBJideX77domf83Mc9UraCXtJYeBLto6HVFK/xtUh5W/MX7w2C4OjKi/ZLWwl2kOljkIndaXVkQ6211WpGhlGx3m5zszkP6vbpTcxJvEGJ3afGNRZcC4Hd2NHSWFmr4+a6Yy09Te7nWRWZCWtGhY99VQ/pzz6o0eietMNUuYS9t9i1DHzYU9xtnKfP6WD2KYImrSd9XoaEH8xQ8Mlj9AKVaUprAFQxqNNlHRczhSOr7W+4QwiNwNJzzhOD1f+wBNQjaxJ45OuEUhTvD5o9+K/XIEIQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 12:06:44.7532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45639181-c2d1-455b-2168-08df456c6a26
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF0000848C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8663

A common usage pattern for offsetof() is the following:

  offsetof(typeof(*ptr), member)

This is exactly the definition of struct_offset(). Some call sites use
offsetofend() instead of offsetof(). Add this variant, then replace all
call sites with the corresponding macros.

Signed-off-by: Bence Csokas <bence.csokas@arm.com>
---
Changes in v4:
- Fix more Sashiko issues
  - Add `virtual patch` to cocci file
  - Skip tools/ directory
  - Remove redundant parens
- Regen treewide patch with coccicheck
  - Except arch/arc, as I can't test that
- Fix (preexisting) style issues in treewide patch too
  - Except for CAMELCASE, which cannot be trivially fixed
- Link to v3: https://patch.msgid.link/20261113-offsetof-v3-0-714df7053893@arm.com

Changes in v3:
- Add Coccinelle patch to tree instead of just the commit msg
- Fix Sashiko issues in prefix, commit msg and doc-comment
- Link to v2: https://patch.msgid.link/20261112-offsetof-v2-0-276ede839967@arm.com

Changes in v2:
- Use struct_offset() instead of reinventing it
- Rename offsetofendp() to struct_offsetofend()
- Merge the two treewide patches
- Link to v1: https://patch.msgid.link/20261105-offsetof-v1-0-4153f5c10edc@arm.com

To: Kees Cook <kees@kernel.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
To: Christian König <christian.koenig@amd.com>
To: Philipp Stanner <phasta@kernel.org>
To: Sudeep Holla <sudeep.holla@kernel.org>
To: Cristian Marussi <cristian.marussi@arm.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To: Maxime Ripard <mripard@kernel.org>
To: Thomas Zimmermann <tzimmermann@suse.de>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Tvrtko Ursulin <tursulin@ursulin.net>
To: Lyude Paul <lyude@redhat.com>
To: Danilo Krummrich <dakr@kernel.org>
To: Zack Rusin <zack.rusin@broadcom.com>
To: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
To: Selvin Xavier <selvin.xavier@broadcom.com>
To: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
To: Chengchang Tang <tangchengchang@huawei.com>
To: Junxian Huang <huangjunxian6@hisilicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hansg@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
To: Wei Liu <wei.liu@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
To: Johannes Berg <johannes@sipsolutions.net>
To: Benson Leung <bleung@chromium.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
To: Guenter Roeck <groeck@chromium.org>
To: Nilesh Javali <njavali@marvell.com>
To: GR-QLogic-Storage-Upstream@marvell.com
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <mkp@kernel.org>
To: Julia Lawall <Julia.Lawall@inria.fr>
To: Nicolas Palix <nicolas.palix@imag.fr>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Paulo Alcantara <pc@manguebit.org>
To: Namjae Jeon <linkinjeon@kernel.org>
To: Ronnie Sahlberg <ronniesahlberg@gmail.com>
To: Shyam Prasad N <sprasad@microsoft.com>
To: Tom Talpey <tom@talpey.com>
To: Bharath SM <bharathsm@microsoft.com>
To: Carlos Maiolino <cem@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhart@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
To: André Almeida <andrealmeid@igalia.com>
To: Alexei Starovoitov <ast@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
To: Andrii Nakryiko <andrii@kernel.org>
To: Eduard Zingerman <eddyz87@gmail.com>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
To: Martin KaFai Lau <martin.lau@linux.dev>
To: Song Liu <song@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
To: Jiri Olsa <jolsa@kernel.org>
To: Emil Tsalapatis <emil@etsalapatis.com>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Simon Horman <horms@kernel.org>
To: David Ahern <dsahern@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: Mickaël Salaün <mic@digikod.net>
To: Günther Noack <gnoack@google.com>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
To: "Geoffrey D. Bennett" <g@b4.vu>
To: Jaroslav Kysela <perex@perex.cz>
To: Takashi Iwai <tiwai@suse.com>
Cc: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: arm-scmi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: intel-gfx@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-hyperv@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: chrome-platform@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Cc: cocci@inria.fr
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-xfs@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: ipsec@lists.linux.dev
Cc: linux-security-module@vger.kernel.org
Cc: linux-sound@vger.kernel.org

---
Bence Csokas (2):
      overflow: Add offsetofend() variant of struct_offset()
      treewide: Use struct_offset()

 drivers/bluetooth/btmrvl_main.c                    | 12 +++++-----
 drivers/dma-buf/dma-resv.c                         |  2 +-
 drivers/firmware/arm_scmi/base.c                   |  2 +-
 drivers/gpu/drm/drm_edid.c                         | 28 ++++++++++++----------
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
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c |  5 ++--
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
 fs/smb/client/reparse.c                            |  3 ++-
 fs/xfs/scrub/attr.c                                |  4 ++--
 fs/xfs/scrub/attr_repair.c                         |  4 ++--
 fs/xfs/scrub/dir.c                                 |  4 ++--
 fs/xfs/scrub/dir_repair.c                          |  4 ++--
 include/linux/overflow.h                           | 12 ++++++++++
 kernel/futex/core.c                                |  3 ++-
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
 scripts/coccinelle/api/struct_offsetof.cocci       | 18 ++++++++++++++
 security/landlock/net.c                            |  4 ++--
 sound/usb/mixer_scarlett2.c                        |  2 +-
 53 files changed, 129 insertions(+), 98 deletions(-)
---
base-commit: 20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
change-id: 20261105-offsetof-f62aa6348f0d

Best regards,
--  
Bence Csokas <bence.csokas@arm.com>

