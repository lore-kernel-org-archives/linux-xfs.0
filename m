Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018739;
	b=EINl+Q5iOBNQ06cyVpOvSN8eYXrOiA6Ym8mL4M4+dVSNARE1keUsJym2y4DpLpaxAE/D
	 5jbshPkBzn8KhPawFM6j+vJSYYHlgmLnE+JFn6Jc4EC6BT5ZGP45eXyh5gLS+SfBkMNgM
	 D/HH+VwYO16Zde4VluuJ3WW/B8V21YNk+S9B0XvoYRpkl28aTuS1pFXghHZxB1sRlgSp5
	 6W6aqHWVW8kK5FHdLXqsJRTEvI3RJePs1Qe9RvmvyGg42ZUCCP+pkpJM2t5mf016XxCKi
	 T59NFWw9oPjaStJ27pdzB9tASH7E8EOXNcJL+uCCyfwxtX8SJjcv4yIwkhzIs84IYXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018739;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:To:
	 Cc:References:Subject:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=m/bYAf+dZPqaYiTr9U4wbR60qvam9O91KPznC9SM+Rw=;
	b=SNYykwH4H0Rk8/JQ48+sjAGsOFFOZGGnKek11OOmrtv/e5eJQOooBEyGNie052Mi1ll4
	 BiK22i8mt5xmx40CKuWOO54FSYak9RSjF8aZss56uiOG0VLNsYSnjyF9XsEAnD+o9QwFg
	 zkg/m0GvVH6XZU8UYyvf7PvqnGQzN4qHRlIzUFDGgV+Rx6pmqc8xFsIpubQOZe+9k/dbX
	 Qw0Mdj0Xa0AuYdXMLGbZrHrD5VK3YQI8I8yR3BCzEnhTLaiafKm4oiM/m7huMF0Vd1KER
	 FIOF9mQXBWF09ilu0pclIB4xSlCVjD29F7Cz+8KzfexHQ6ZDlj/uldYRb4dh7Fl9bzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=web.de;
	spf=pass smtp.mailfrom=web.de;
	dkim=pass header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=Sq2pZ4fJ;
	arc=none smtp.remote-ip=212.227.15.3
Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D598606A32A
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 16:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D598606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=Sq2pZ4fJ
DKIM2-Signature:  i=1; m=1; t=1795018736;
 mf=PE1hcmt1cy5FbGZyaW5nQHdlYi5kZT4=;
 rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
 d=web.de;
 s=s29768273:rsa-sha256:gBaqC9OhsCSO/ztjaSQ9Ox2F9IWf
   mn2vVeHABpfsRuysJbjGd77+tx0C7lpuGZCF0z9IZEgB6EeZBWhE2Ni8tkVS723fsWGkwB7q/WC
   mk4rgyJrFVz/FUkkGLdqVubyyN/KDf7v29H/96T/PsomTbbnnvF+muPLP/F465KTUiJN9OT1Wgv
   nP4fUnWR/Fs12kcvVH/ec912Jz69uRkwzwyiYh4SOIhvXe1LACfCKelFq3XQPsLcGnnEro15RRE
   iJLjfisGJl5R+MUhc519murBiODuP61A/KO8vsgSYOaeoAyoTJHe6DpR/OAGidzALNETgeNsV5+
   DL3CDIev8dRqQg==;
Message-Instance:  m=1;
 h=sha256:
   nmDQmRUZN+uSb6f41n1+u/twAW/9MOE+IlpKSrhtQ2c=:
   m/bYAf+dZPqaYiTr9U4wbR60qvam9O91KPznC9SM+Rw=,
  sha512:
   zX2+2XXbx3o4gU2xku4GB4cqxrBOQp8b36AIme9KhpF2+Tfpfrq7eCVISoNBJrVOiHre2EOgPDAktIpuxKNcAA==:
   zNQth83cxu+7P+zsMCoEGFA85dRG3Im3HA+UQSy2I1SSJBBxQex5ejV+UkYztj2FOXZaJDLzv8zHaeVc4P9ZvA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1795018349; x=1795623149; i=markus.elfring@web.de;
	bh=m/bYAf+dZPqaYiTr9U4wbR60qvam9O91KPznC9SM+Rw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Sq2pZ4fJs+BzhaIwvm8e/3/0HpxFCg7jQWws+b1dZ/6qneTU1yz+ROx/uwCCMRvJ
	 6cvWqldKmn6ywVqDff9eoYeX+ZZmuPtD+rqT5QpvJT1FEobai3gW6WyNsPOwtIK5F
	 gRHMeEL5J0/L5eFXiR1Ket8FnWRSbAtsEtA+BBRauRBAI2gDigW+LsPd9k5tRfvc/
	 qluUE5UgtiNgvQOgZkgFpXPuCZynTDrXUouM5kVYdwyYoz9McgjoD1I/3HZXlxx/V
	 DlsWkS0mG29EnRpCb72pLiglo7982hrmwcLVpI9gnFm21ve6N5p8BvpVAqJjc/uOn
	 Mfr3yY0ERjq5An+ogw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MSqXS-1x0Vzm49l8-00SiyN; Wed, 18
 Nov 2026 17:12:29 +0100
Message-ID: <bfe10f1f-443e-4286-8172-6f941663c86e@web.de>
Date: Wed, 18 Nov 2026 17:11:53 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Bence Csokas <bence.csokas@arm.com>, cocci@inria.fr,
 linux-hardening@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>
Cc: GR-QLogic-Storage-Upstream@marvell.com,
 James.Bottomley@HansenPartnership.com, Jes.Sorensen@gmail.com,
 airlied@gmail.com, andrealmeid@igalia.com, andrew+netdev@lunn.ch,
 andrii@kernel.org, arm-scmi@vger.kernel.org, ast@kernel.org,
 bcm-kernel-feedback-list@broadcom.com, bharathsm@microsoft.com,
 bleung@chromium.org, bpf@vger.kernel.org, brauner@kernel.org,
 cem@kernel.org, christian.koenig@amd.com, chrome-platform@lists.linux.dev,
 cristian.marussi@arm.com, dakr@kernel.org, daniel@iogearbox.net,
 dave@stgolabs.net, davem@davemloft.net, decui@microsoft.com,
 dri-devel@lists.freedesktop.org, dsahern@kernel.org, dvhart@infradead.org,
 eddyz87@gmail.com, edumazet@kernel.org, emil@etsalapatis.com, g@b4.vu,
 gnoack@google.com, groeck@chromium.org, gustavoars@kernel.org,
 haiyangz@microsoft.com, hansg@kernel.org, herbert@gondor.apana.org.au,
 horms@kernel.org, huangjunxian6@hisilicon.com, idosch@nvidia.com,
 ihor.solodrai@linux.dev, intel-gfx@lists.freedesktop.org,
 ipsec@lists.linux.dev, jack@suse.cz, jani.nikula@linux.intel.com,
 jgg@ziepe.ca, jmorris@namei.org, johannes@sipsolutions.net,
 jolsa@kernel.org, joonas.lahtinen@linux.intel.com,
 kalesh-anakkur.purayil@broadcom.com, kees@kernel.org, kuba@kernel.org,
 laurent.pinchart@ideasonboard.com, leon@kernel.org,
 linaro-mm-sig@lists.linaro.org, linkinjeon@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-bluetooth@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-xfs@vger.kernel.org, luiz.dentz@gmail.com, lyude@redhat.com,
 maarten.lankhorst@linux.intel.com, marcel@holtmann.org,
 martin.lau@linux.dev, mchehab@kernel.org, memxor@gmail.com, mic@digikod.net,
 mingo@redhat.com, miriam.rachel.korenblit@intel.com, mkp@kernel.org,
 mripard@kernel.org, netdev@vger.kernel.org, nicolas.palix@imag.fr,
 njavali@marvell.com, nouveau@lists.freedesktop.org, pabeni@redhat.com,
 paul@paul-moore.com, pc@manguebit.org, perex@perex.cz, peterz@infradead.org,
 phasta@kernel.org, pkshih@realtek.com, rodrigo.vivi@intel.com,
 ronniesahlberg@gmail.com, samba-technical@lists.samba.org,
 selvin.xavier@broadcom.com, serge@hallyn.com, simona@ffwll.ch,
 song@kernel.org, sprasad@microsoft.com, steffen.klassert@secunet.com,
 sudeep.holla@kernel.org, sumit.semwal@linaro.org, tangchengchang@huawei.com,
 tglx@kernel.org, tiwai@suse.com, tom@talpey.com, tursulin@ursulin.net,
 tzimmermann@suse.de, tzungbi@kernel.org, viro@zeniv.linux.org.uk,
 wei.liu@kernel.org, willemdebruijn.kernel@gmail.com,
 yonghong.song@linux.dev, zack.rusin@broadcom.com
References: <20261118-offsetof-v4-1-95b385c10b22@arm.com>
Subject: Re: [PATCH v4 1/2] coccinelle: Add offsetofend() variant of
 struct_offset()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261118-offsetof-v4-1-95b385c10b22@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6EPveX8Ri1t77eUHD87iadI+dVaiRGmKrcwX0pgqshl6eE/PUfu
 U/grdzqZeabqS0kEnnjyRXEVSYDjlvBsjC2oZG3t3rvYXHw3tr9N9kjJJpqOAEsA2vHBJqN
 AR+JHHmlfVSnKcJYWSJp1TR8Y5+Zu/geNXBYWb0YhnSvyDMYofveGe0n8eBYJD9wGvHxA8z
 U1kcbkwxGmL25oJsNUZfg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rM0ETHJyGqI=;7bapq5lffTVvrvQuskQh/L6Ng5n
 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
 PVQaXLpHYtdr+cU6hxQLaJ5A8jw==

=E2=80=A6
> +++ b/scripts/coccinelle/api/struct_offsetof.cocci
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/// Use struct_offset() family of macros
> +///
> +// Confidence: High
> +// Options: --no-includes --ignore ./tools/
> +
> +virtual patch

Can further coccicheck operation modes become more interesting here?


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

How do you think about to use the following SmPL rule variant instead?


@replacement depends on patch@
expression pointer, member;
@@
(
-offsetof
+struct_offset
|
-offsetofend
+struct_offsetofend
)(
-typeof(*
-(pointer)
+pointer
-)
 , member
 )


Regards,
Markus
