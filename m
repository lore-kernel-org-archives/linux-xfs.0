Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952317;
	b=eaNvDA9Ae7wd/qlWTNBBeZ51HOfyvX2V7iJAoV+aDm2JYbwl831YI+f1fj/krQXbry5X
	 RrJCLNhNLGOanSBgcB7CLpBi78ZBorKFRjs98eD6qV+1xWQEBRHUG0zJgX2eSBtSEtjHa
	 2do3HEhmvHsPd3Cwl/8NQYQkercW3csnLzXUlfqqeOqZ5MZ8HsxYTXoV60mKe5TsNmaup
	 0DjiX4zi6m7X0IevrVgrGvNYSgkBL5SQvbMJJEsfFYJegFfgdJ+lSWGd+b2R3/F7kMXe1
	 0ztVJ3p9kkWdAsDTQ1TVsniAkInnBwop6FVE8gdXQ1uuFPGZjE/cp4SLamgJlvDizEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952317;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=x07awLmZl1uGnixljrDMUgu9d0OiWf2Z+sJydT2Lbr0=;
	b=kK90EZVLQTSrwkKFrGbmMmqDgnougbb6rsjrsuwRR4bQDz3QHyODOlITuadiqtzKqvTT
	 vutzURAuGDiqDetEp3mhvX+D8txijmGRETEeRi2yoUko0Qy7zvZAGd/h9WkOYMSGusLAt
	 8sOAJap0TCZ1s/ul2gtdTiYo5Te3noxE8yTdKtTO2Iu9v+MaxIUJzg/GHB0WzQns9BJpY
	 M7sU6jX1AShAfUqbVPcKhFW9Hn90wQ1ehWHT+VykRoAj+l3HwuHkgOFC2JpGg6QJct+vj
	 0raXbCpGg6asjsA8GhAooILQr4aBH6hzgglUZmuNN1UwbCiPilj08uoFy/mk4uaLEKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=oiRMln23;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1702A606A328;
	Fri,  6 Nov 2026 08:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1702A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=oiRMln23
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x07awLmZl1uGnixljrDMUgu9d0OiWf2Z+sJydT2Lbr0=; b=oiRMln23yl/QBuC0DzwXONkLv5
	qM+sNI41fnd6ZZdtIdfoPIuUSZHjJllyir3jn5dYul9Hhh11zXahz7DjQNGL6kqFmMxym0kEDtOmD
	JgIADndDf71VAul280x2lDyIVPe6HFQRskf9qC5NU/8P7kjkPPDBDgNWgZKWzmAJG/fm1BZ3LikI4
	AJReQOjF2xOHtD0/o6EMEslTbPj3TIA0VVZuOvKHyIPeRI6tauCfHZubFGOzh5ORdNmavj6txE4sb
	V62/yFS1hM13pH3V2NMo05nu4U1qu41e/vy7J1YKCYoB+vzlPGJYOKDkhh/XndWwFf9Phw2nFy/jN
	8N6Cktqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xPEvi-0000000BWDm-0Spo;
	Fri, 06 Nov 2026 08:04:10 +0000
Date: Fri, 6 Nov 2026 00:04:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bence Csokas <bence.csokas@arm.com>
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
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
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Vineet Gupta <vgupta@kernel.org>,
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
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <groeck@chromium.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Carlos Maiolino <cem@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	"Geoffrey D. Bennett" <g@b4.vu>, Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
	bpf@vger.kernel.org, netdev@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, linux-bluetooth@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-hyperv@vger.kernel.org, chrome-platform@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-xfs@vger.kernel.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 0/3] Add offsetofp() and offsetofendp() for pointer
 arithmetic
Message-ID: <au2J-lMcEn4p4KGR@infradead.org>
References: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
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
In-Reply-To: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 05, 2026 at 06:16:15PM +0100, Bence Csokas wrote:
> A common usage pattern for offsetof() is the following:
> 
>   offsetof(typeof(*ptr), member)
> 
> Condense this operation to one macro for a more maintainable code base.

What exactly makes non-standard macros with no obvious safety benefit
more maintainable?

