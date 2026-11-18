Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010717;
	b=ZZE2dZnFqBBKXE3nmqAN7i41jopByNWuWPBZuY+MysN+zEuAmuL4rKNXbNCrNjv+MLKP
	 deuevMLQK2aTQ+HtMVSWWMdS/WuHBFmNJP967YBTobLQ7lccTb9ebA3sYH2t56jIMvjwT
	 RTFflDRUv3AaUm94yofdzOUXRBtEHd/Bjxa7tzQYz2sN8gW+O2OpVceW4HhK7z01VVhpY
	 ppopPZm4BbnLXEcPmEfxN8coKi9JY/W9i/oHoBKOytgM447rAZbx01DRarntWHR8d/Qwd
	 DTkTk7sEOHVujFjPIZUjfaZOoRHpOoOaThBPkfG070S3Ba7PetC6Z7zsgOx/6QT8ahw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010717;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=foydl+Nk9ZmJviej/30gV1cygoCTSVCceGPI7w/fow0=;
	b=QHs332L/Lr/gu6dQT6PYAhWtr9koXWUTXm9HUZ3CIdzTbdjlgmdVKYIdNOpjUxioWNJS
	 prSOWcxyr9Gf1hUYQoTZ88l/pehKB91vYx7n05m0LRvK5Qx4IFLfE67SdQYFQG/8W5S1f
	 V4JdipqJPT5QcU9uYZv+KH7DBh+C4IzOXNW1aLz4Fp0AcMc1mgeo9xMy0fkfXJ+K5OYBe
	 WVkQ1CMN45rgRl4y9q4i3XJ4v8bhmsK7jsMAHWzfNZ0Y9rxKFLZMJ++9axQLlXLHUwD3i
	 aXP+J/9ARPMhP54W6OEWWikYXpBogwbEfnfL48xD2lfDZN0CebiHih2wRifXAwBYpcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=WOhR5yIs;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14112606A31C;
	Wed, 18 Nov 2026 14:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14112606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=WOhR5yIs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=foydl+Nk9ZmJviej/30gV1cygoCTSVCceGPI7w/fow0=; b=WOhR5yIsaTPEeHWfDnVfXLmpTK
	p2fdJUW95t55sxIMgLSjl77d2uFvCfu73mU98Ke2aNCntsKl6aVpkbYBm1Cx/VDmluo1BPNv7+OAu
	tMoiX8BqQCyAo2LwGhBzWEtPnp6VCu494v+ZfDj7WbrayOV27fzo8fNM8HJjP8LHTkd9iaNFApzsE
	lk4vuXuzbMGP9cd4HMq3g6UiNuqhVUDjcimTbrMVwrnHALwefYKVv8Cm8jLfaq4XNJkH9YBTHZln7
	mXEN4VZW1Q1cyhZ4ngMZSOGFp8d6zXJFUUQZrn2EA8U/U3Fygy9Q03FgvLOc+ZshQqvdAFwW3JiIj
	8W5+1yxw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTgHj-0000000G6tZ-0guj;
	Wed, 18 Nov 2026 14:05:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E2EC13005AF; Wed, 18 Nov 2026 15:05:13 +0100 (CET)
Date: Wed, 18 Nov 2026 15:05:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bence Csokas <bence.csokas@arm.com>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <groeck@chromium.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Carlos Maiolino <cem@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"Geoffrey D. Bennett" <g@b4.vu>, Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	chrome-platform@lists.linux.dev, linux-scsi@vger.kernel.org,
	cocci@inria.fr, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
	ipsec@lists.linux.dev, linux-security-module@vger.kernel.org,
	linux-sound@vger.kernel.org
Subject: Re: [PATCH v4 2/2] treewide: Use struct_offset()
Message-ID: <20261118140513.GO1813469@noisy.programming.kicks-ass.net>
References: <20261118-offsetof-v4-0-95b385c10b22@arm.com>
 <20261118-offsetof-v4-2-95b385c10b22@arm.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-offsetof-v4-2-95b385c10b22@arm.com>

On Wed, Nov 18, 2026 at 12:50:09PM +0100, Bence Csokas wrote:
> Generated with a simple Coccinelle patch found in
> scripts/coccinelle/api/struct_offsetof.cocci

I think this is a good example of why we don't need this. It adds yet
another macro to remember, and doesn't actually save many characters at
all.
