Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.134.164.83
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010894;
	b=KWbMdUxZStBczeeoNgIZb9SScHt4ybvJ/FYtaFQ19RPVG2XuuKKOe0HsPpvgoYaFhvgT
	 E/rnp0dc6NfRB8aeUIgQtKnrjO5/MzghY40eobaZHhAY4pGilaTxRZbuuVHgxhBhue0VI
	 H16K9UXrFY46KOOu1YTuZD6pAlET6UhKqQu4XEqMJHlvovqc9xHHTkuy15SMSGBmum8T6
	 0vUFbi5ChCnwDrEHspR3yOKZWoNPISefxodaHiPLt8AZBf4ApBW7x+TpDP+NDuZTFrRnL
	 CvNnr+c7ThoCzUMfcSRqJWpVkdEYfk5BUUIM4EjPmVeylgg/KDmmTvcacHSrYDTyC9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010894;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:
	 References:MIME-Version:Content-Type;
	bh=kSUE/o5CqDYurph69R6wpud9Np7SIjoEFQ7s0L3TdZE=;
	b=4EMIilZ8cQtQTU/9VXo4mmb8fbzLhKV+0okgLf0eKcOJXybmFA9VHsYRhNlbxqjq4+r9
	 LWB2NKL62TBtc5gSUJVelUH9mxw3kwCj0gq+I1ejZItlHBAxodJUo+tzzaxLGQqnv6y2R
	 OTOubtdXh1IT87QU24bIMWOfVggy+ObAODJZ4Ro71J4bTd0UZxjIckWs3GLj8vt/UhcF3
	 kwfgkw+8Jx1wpv4BeCUD3WQGWsS1k4KUbOCsjoXtHiTnV02MgNTPmXWZ3/jAKSiKIPhOf
	 YWcmltS3oip51jspxf3tqTjJnvMihuC6xyliU2UP8NmTvu6kwtuEfpbNzdj+kTsNeKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inria.fr;
	spf=pass smtp.mailfrom=inria.fr;
	dkim=pass header.d=inria.fr header.i=@inria.fr header.a=rsa-sha256 header.s=dc header.b=lO8vUGAB;
	arc=none smtp.remote-ip=192.134.164.83
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3878B606A31C;
	Wed, 18 Nov 2026 14:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3878B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.a=rsa-sha256 header.s=dc header.b=lO8vUGAB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=kSUE/o5CqDYurph69R6wpud9Np7SIjoEFQ7s0L3TdZE=;
  b=lO8vUGABN3SRz8stmFI6GOw5EdtNndRF+CQvv0/fdjATmxkGTAFZQyyX
   q3S3Iji9niTjJuaRWhbudJSEAZZKtnIYWDJnU5+hLPXuIFXtC4McFue5K
   zJmH9mSahEE3uuCKvqXtwc7RUVjEQny86msZaIn/W22PRg53MToih5RN6
   4=;
X-CSE-ConnectionGUID: NpDResvMRHWEoFCgk5A11w==
X-CSE-MsgGUID: tkj3zeBCTZKFS5tJsQM2+w==
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.27,219,1787004000"; 
   d="scan'208";a="306121450"
Received: from 72-255-236-003.static.imsbiz.com (HELO hadrien) ([72.255.236.3])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 15:07:35 +0100
Date: Wed, 18 Nov 2026 22:07:31 +0800 (+08)
From: Julia Lawall <julia.lawall@inria.fr>
To: Bence Csokas <bence.csokas@arm.com>
cc: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
    Marcel Holtmann <marcel@holtmann.org>, 
    Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
    Sumit Semwal <sumit.semwal@linaro.org>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Philipp Stanner <phasta@kernel.org>, 
    Sudeep Holla <sudeep.holla@kernel.org>, 
    Cristian Marussi <cristian.marussi@arm.com>, 
    Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
    Maxime Ripard <mripard@kernel.org>, 
    Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
    Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
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
    "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, 
    Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
    Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
    Johannes Berg <johannes@sipsolutions.net>, 
    Benson Leung <bleung@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
    Guenter Roeck <groeck@chromium.org>, Nilesh Javali <njavali@marvell.com>, 
    GR-QLogic-Storage-Upstream@marvell.com, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, 
    Julia Lawall <Julia.Lawall@inria.fr>, 
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
    =?ISO-8859-15?Q?Andr=E9_Almeida?= <andrealmeid@igalia.com>, 
    Alexei Starovoitov <ast@kernel.org>, 
    Daniel Borkmann <daniel@iogearbox.net>, 
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
    =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, 
    =?ISO-8859-15?Q?G=FCnther_Noack?= <gnoack@google.com>, 
    Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
    "Serge E. Hallyn" <serge@hallyn.com>, "Geoffrey D. Bennett" <g@b4.vu>, 
    Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
    linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org, 
    dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
    arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
    linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
    netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
    chrome-platform@lists.linux.dev, linux-scsi@vger.kernel.org, 
    cocci@inria.fr, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, 
    samba-technical@lists.samba.org, linux-xfs@vger.kernel.org, 
    bpf@vger.kernel.org, ipsec@lists.linux.dev, 
    linux-security-module@vger.kernel.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH v4 1/2] overflow: Add offsetofend() variant of
 struct_offset()
In-Reply-To: <20261118-offsetof-v4-1-95b385c10b22@arm.com>
Message-ID: <c6fbb025-8de-b716-5d32-877c3d3fa2a6@inria.fr>
References: <20261118-offsetof-v4-0-95b385c10b22@arm.com> <20261118-offsetof-v4-1-95b385c10b22@arm.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Wed, 18 Nov 2026, Bence Csokas wrote:

> Many call sites of offsetofend() use it for the purpose of pointer
> artihmetic. Thus, a common usage pattern is:
>
>   offsetofend(typeof(*ptr), member)
>
> Capturing this in one macro helps keep lines short and terse, while
> still making the purpose clear. It also helps discourage spelling out
> the type name on every callsite, leading to more maintainable code.
>
> A similar struct_offset() macro already exists, so add an offsetofend()
> variant in the same spirit.
>
> Signed-off-by: Bence Csokas <bence.csokas@arm.com>
> ---
>  include/linux/overflow.h                     | 12 ++++++++++++
>  scripts/coccinelle/api/struct_offsetof.cocci | 18 ++++++++++++++++++
>  2 files changed, 30 insertions(+)
>
> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> index d0f04436343e..c029d68daeca 100644
> --- a/include/linux/overflow.h
> +++ b/include/linux/overflow.h
> @@ -464,6 +464,18 @@ static __always_inline size_t __must_check size_sub(size_t minuend, size_t subtr
>   */
>  #define struct_offset(p, member) (offsetof(typeof(*(p)), member))
>
> +/**
> + * struct_offsetofend() - Calculate the end of a member within a struct
> + * @p: Pointer to the struct
> + * @member: Name of the member to get the end offset of
> + *
> + * Calculates the offset of the end of a particular @member of the structure
> + * pointed to by @p.
> + *
> + * Return: number of bytes to the end of @member.
> + */
> +#define struct_offsetofend(p, member) (offsetofend(typeof(*(p)), member))
> +
>  /**
>   * __DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
>   * Enables caller macro to pass arbitrary trailing expressions
> diff --git a/scripts/coccinelle/api/struct_offsetof.cocci b/scripts/coccinelle/api/struct_offsetof.cocci
> new file mode 100644
> index 000000000000..5a30647d3787
> --- /dev/null
> +++ b/scripts/coccinelle/api/struct_offsetof.cocci
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/// Use struct_offset() family of macros
> +///
> +// Confidence: High
> +// Options: --no-includes --ignore ./tools/
> +
> +virtual patch
> +
> +@offsetof depends on patch@
> +expression ptr, member;
> +@@
> +- offsetof(typeof(*(ptr)), member)
> ++ struct_offset(ptr, member)
> +@offsetofend depends on patch@
> +expression ptr, member;
> +@@
> +- offsetofend(typeof(*(ptr)), member)
> ++ struct_offsetofend(ptr, member)

Coccinelle script

Reviewed-by: Julia Lawall <julia.lawall@inria.fr>
