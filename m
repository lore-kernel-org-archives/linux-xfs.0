Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A7434F48F
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 02:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772592580; cv=none; b=dmAp0/1ZqYwMfzdDK+JXPHA9Vmrv0BYQwUdt/KCnZ68nM5fcYpVOI+IiAx7dHD5dxmZ7x6bZ9w42xNK8bv1Ek34NjH4yV9Rmx8DvcozkWNV/TN2EIEtuInOhpVzvOMS/KdtKEPkbhzD4GfydRhBmv7zezWc8929vFvkpkLWvGHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772592580; c=relaxed/simple;
	bh=Yh8dBMe3ibg8tK09EirKlKZM1uMUm94vien5uMRloZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r7EphHwJNhhlVR892SEEww3fjJHPJqCqRi+EJyt0swe7eFeOKKYMUJJxTGFQNwLFVaKR0jV0g3bc2xc0F/1TJWSUGxGXosEEaDEsc+0+2MFiWwIL5uOv3DYttbtbCCZCqb9X1m4nQXmmdiQOlfE7kGBRkQUo7oCC6Pnkh20f7ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jbJx9YHi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jbJx9YHi"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae49120e74so29120225ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2026 18:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772592578; x=1773197378; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wlfxAiLCYE9X+ss6Nds/jzCWOjzdQvgrRAY6r5Hx7j0=;
        b=jbJx9YHiJ+WPah7GaRASFMPpnhJpC89X1VEt7t7uOXdxW9ui4S5BV8nEmnFwwucLuy
         2DP1g+BXTNfahxRQ3c5bNOmsk4VGpCJTV/DeH/KU5FknJBbeV//S2UbbE3LMF1facWh1
         hHRMG3MaiJ+/3JjlZpYQypG6vavbkLj/WGXr/+JZB9Di0csdOnzeuSYtRrZUuzFXPVlZ
         V+nHwfQ+OOu93OkF5KrOhH7PDYq8/lNNOH/PhUY+Lq7Lq+C6cphl8HZhs7RqN9Nwr+Gz
         GGJcSKdbL2CXSVi8oionrs44kO1BzATDhtuqGPXHN7yc2Wtk0yLhrD+fgpgILH7GlC8D
         CrBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772592578; x=1773197378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlfxAiLCYE9X+ss6Nds/jzCWOjzdQvgrRAY6r5Hx7j0=;
        b=DNGZE7a3Nstd5kM68kqa2fitoTKQmJ9YkbnKPF1ItdhvHGxFQUnCP4kcRUZ+NY61o8
         BycGR9d+Zf6KLhrj2T/rgnIpTHYztiZOG2ZId0pJh9/t922fthq6LyVZs2cDMMiXwN4g
         83z+UBcsaoKIPzWLrJhmu6IjevbKJfeF8qNyC2r/CVe9jMVU5NnV/3XLZisAOsp1OATT
         LBrA7Vc39TCkDhhBFTUmMNyCR1Okjt79BNu9v2H3q4ysLRTU6H5NH/NOTaNOl+y0SmKn
         kbAiGE5CFBT2BxGtsBsY/SL97mVEvwSEhGDtE8xcQ+uAhKiFIcBrqDWXtMyFXe3BGzGB
         Ithg==
X-Forwarded-Encrypted: i=1; AJvYcCWH3/D6FSJmN5f08Sb8wdAgFOagDLGtiBPLJlntET5efgNw0tT6OYyQSX3MSpLeeoguX2/gQzm3Ogc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0sHex8cIh2sAXsA1ItZK3AbO/EsWstpT/LIvM+YKgpEaAf0cH
	v9ikH0i+UPyevwHCuShkoP8J2mqfqScrmJ8NuI38ii1MiH4BK6rqBUoLFM9BOsj5YMSg6Tp+RZ0
	E+gJIxw==
X-Received: from plzv9.prod.google.com ([2002:a17:902:b7c9:b0:2ae:6338:73ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2446:b0:2ae:483f:b239
 with SMTP id d9443c01a7336-2ae6aaf9469mr6114485ad.30.1772592577810; Tue, 03
 Mar 2026 18:49:37 -0800 (PST)
Date: Tue, 3 Mar 2026 18:49:36 -0800
In-Reply-To: <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304012717.201797-1-ynorov@nvidia.com> <20260303182845.250bb2de@kernel.org>
 <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
Message-ID: <aaedwFwXh9QXS3Ju@google.com>
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
From: Sean Christopherson <seanjc@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jakub Kicinski <kuba@kernel.org>, Yury Norov <ynorov@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexander Duyck <alexanderduyck@fb.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexandra Winter <wintera@linux.ibm.com>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Anna Schumaker <anna@kernel.org>, Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, 
	Carlos Maiolino <cem@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Chao Yu <chao@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Airlie <airlied@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, 
	Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Dumazet <edumazet@google.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Latchesar Ionkov <lucho@ionkov.net>, 
	Linus Walleij <linusw@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>, 
	Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <pjw@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Simona Vetter <simona@ffwll.ch>, Takashi Iwai <tiwai@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
	Zheng Gu <cengku@gmail.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	dm-devel@lists.linux.dev, netdev@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-sound@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 03, 2026, Jens Axboe wrote:
> On 3/3/26 7:28 PM, Jakub Kicinski wrote:
> > On Tue,  3 Mar 2026 20:27:08 -0500 Yury Norov wrote:
> >> The net/9p networking driver has a handy macro to calculate the
> >> amount of bytes from a given pointer to the end of page. Move it
> >> to core/mm, and apply tree-wide. No functional changes intended.
> >>
> >> This series was originally introduced as a single patch #07/12 in:
> >>
> >> https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/
> >>
> >> Split it for better granularity and submit separately.
> > 
> > I don't get what the motivation is here. Another helper developers
> > and readers of the code will need to know about just to replace 
> > obvious and easy to comprehend math.
> 
> I fully agree, I had the same thought reading this.

+1 from KVM-land.
