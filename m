Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A5E387375
	for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2026 12:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784377244; cv=pass; b=U5Do67sO3ZP93oDrcphr6LaHQNj/bAiuwtGcZtxEuWPTDh1fIp4eChN/cUeLEafp2oNsVHSJjK77wLNSlukUE3RVATyybVwV186nOu9GblIeI2VKEZYxU3qou+XKsPpSLYEHZkOfotRTtYgp4lRHVahQoTAhsGe9hnWO22ec/6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784377244; c=relaxed/simple;
	bh=avct8YtrMK97ljcoDS44ALYVtDCv4wJcv/q8qrk3BBs=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t2FidK+uM0XMrWcz6FgOqxnMj7MscFfIhY/FmE2vabJs/DokJytm023dE6HLZ+Ogx+NcbP96Xg15eO2WxZ87lUrl05yG0FVEoN9ZUkLEbaaCKoUohTEucW8QFNpU6hah/fl8LuUaB3kzzZpnP5DCsR+rwzOfw5IoGnioe1zeiyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EcRRetOi; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EcRRetOi"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-667f1390f58so6306655d50.1
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2026 05:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784377242; cv=none;
        d=google.com; s=arc-20260327;
        b=cHFnjwsJlC3Lb5CQWyBOSn06DeLPKSF9mubKYWLH8ouxNYvTYg0On4PTv2InZLoQ+8
         qIu98RhV3p1EPhkUg8sdYN2JNth4rzQvR/DQmaVsOUrhnRdd9w0ORtP4ZdMRglE7R+aY
         7lPDr/HAsl3Yy6V4lImzgY/dircytfg6NVMiqjI+Ijax6rc7my8Je3BRoT2Uy7F1AQoF
         /NnZZN74QFyA2DItKcdVNMt6ynGaZk23l3kKbmVhEnrAYIZU2QU2WX346RAjLmvf0gsg
         NHGHLEx8BCKohR4jQqXRiKwdSZKdmdKNEb0FlG1Fag1viHW9K+7rUmijAnqZ10XSV6fu
         f05g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=avct8YtrMK97ljcoDS44ALYVtDCv4wJcv/q8qrk3BBs=;
        fh=SU1q7gjrj4CP1SDbRyj7NyVpOiISnZTujwNpSJlbgKs=;
        b=HT3wNtecyz9ry5F+3BdwKjkoiVKMTmX5M2z0Eu7ynGUbzNcPRmuhaEyYr45I4gsfT8
         P8/ZzocDspDPN02DzqIDpJs7e6HffavGZjuQAvGWP4Xzga+rNszBDteK3JndFRxIOnGR
         M+S42ZlI74BVmlUADDpFtrX1b1m8vd+DUhZ3T8JhNuZNWOesujFM/tS25UZT20OUHbxU
         Bgbpub8SUnyo7jEiwp+68gNuVTH1SZREsEVDojveUbmMNCjpSaj66NGUlNZJvPuXARaa
         i6qFjFoEg4hP+V+fqHOX2UbARpk8Wx+PBtIFiZdmKa1jIUmd6rOIWzYcRshx18k+JJkY
         Cffg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784377242; x=1784982042; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=avct8YtrMK97ljcoDS44ALYVtDCv4wJcv/q8qrk3BBs=;
        b=EcRRetOiP+Nk1C3+oMetMv5XCbpii0k61CzaskpMuLDD6JVTbCh79w696aEaO715Qw
         ueFJyPgQ1NHFoqivy0hOarHUHknt5lNbOwcQJTD4rZHsu/o16y29ANZuSp/r8CeWafCc
         DoU/QZvNhJXI5gB0feO1Fo9aHotRzOGHaanfHWEvvQwjLWYGlsKng1qNrrv7gxcds25a
         zSVGEX+Dl9qp30vi7VPqQKD0iES/swt/DdY4W9WaKPEzt03w5GTLL/tCzNPn/hqJKnnb
         fXLLX+Cm+HHw9XpJymm1ZF0an4B8/btgvxBPJ2X/mhsPtuEVMJ+OEsGrsNsnXfoqOtyM
         oenw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784377242; x=1784982042;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=avct8YtrMK97ljcoDS44ALYVtDCv4wJcv/q8qrk3BBs=;
        b=cU5twweAyIvlMu1Z9oSdxO1tk3NBkWc/Qo3IqhXSKAkdNn8s0ah8XjHngY2occxmSi
         V2bMpdii+1QSsSY8OFpoMR72U8DWefmGXC7vvAsd7A34emT3vtbRrFSAuW+nnWC6n4M9
         zJDDrZU2ISPiXloraQYkSOBO7x3Y/Rhr9vQrX/TRhFBcVajIBNbKU21vjHQlwbkPAq5J
         fCAZ1gXoINO86VlIuGlKr9NDFcQa8tRLMC+m9d/ptANcQn0DpgBDgx1CqL1D5U58eaaS
         6c3ZxwS3PjwYIo4vaMamdkKmbPD9M7W8OAAqru4COCvZOKFA5Ytc3/ZvFgrmxg1ckgJR
         Z4Nw==
X-Forwarded-Encrypted: i=1; AHgh+RoRiy2YZ404BRfcIYikvkV1mUF7B7irh9CxL3QEb7WgbYwjraRM5rirnbSel7VfIj4CIIp4w6ZMthI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6WnFd0MpyYX12nQekp7lj0mSCS0jtRTM3SXfJyNXdRMqulMTT
	8TlaxvzhC2TPMzCKpoOpohpWy0tgxPJ9ztIyjYyhinogdP6n1XbT01CigiGGYP0xDcR0dpO0kpy
	TFQ38R52WdIkK9ZIsEqeHz7uTaYEjFOA=
X-Gm-Gg: AfdE7cnan0DDzKpGg7DYp5TpFRhali0LyY/FJP7MI+tuRUpFmedD3VzymNdrFEZvcDn
	NyWug7FLy3UkuLwTMflDgwRDHEjbndTTRRyXfMbsrPpqQ6lx1DMl/WLQGBtY0i8UK6nmO9Nb/qc
	tYLtta3yGGPk1OYJddJRbN41RMWsPr3QqAXUgUER1/WHNnhEA2QNRcQ/8/MYRI7NUZ5t9e1E0BY
	9ihw4440PkdKzQ9dO/s0SrjgNatLU6G1PHutWcOMGV0q/W+3UzPRsBJAMNz6w==
X-Received: by 2002:a05:690e:b4f:b0:667:db0d:dd5a with SMTP id
 956f58d0204a3-6683bbbc0b4mr2080878d50.44.1784377241704; Sat, 18 Jul 2026
 05:20:41 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 18 Jul 2026 05:20:41 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 18 Jul 2026 05:20:41 -0700
In-Reply-To: <20260707163839.GC9392@frogsfrogsfrogs>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com>
 <20260630161113.GB6526@frogsfrogsfrogs> <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
 <akTyUXMN4_I1fOaM@infradead.org> <20260701155234.GF6526@frogsfrogsfrogs>
 <akZF4ib9KpSxnBQ3@infradead.org> <20260702153102.GA9392@frogsfrogsfrogs>
 <aky0peCyFau-S6hL@nidhogg.toxiclabs.cc> <20260707163839.GC9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
Date: Sat, 18 Jul 2026 05:20:41 -0700
X-Gm-Features: AUfX_mywX6Dcix4L5AWnUWHfpHgukDZ-2hLBhASccTnWtTphkjjJ3fZci1Xywsg
Message-ID: <CAMuQ4bUA2LOVRKZ+0DJy2uBBUTAabZ7-gO68T+a+dc4n5zApyA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
To: djwong@kernel.org, cem@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Understood. I'll rework this as a v3 that zeroes the extents-to-btree
allocation/layout gap at the specific conversion site, instead of
adding __GFP_ZERO to every if_broot allocation and reallocation.

Thanks,
Yousef

On Tue, 7 Jul 2026 09:38:39 -0700, "Darrick J. Wong" <djwong@kernel.org> wrote:
> On Tue, Jul 07, 2026 at 10:15:01AM +0200, Carlos Maiolino wrote:
> > On Thu, Jul 02, 2026 at 08:31:02AM -0700, Darrick J. Wong wrote:
> > > On Thu, Jul 02, 2026 at 04:05:06AM -0700, Christoph Hellwig wrote:
> > > > On Wed, Jul 01, 2026 at 08:52:34AM -0700, Darrick J. Wong wrote:
> > > > > > This almost sounds like we should explicitly zero this case just for that
> > > > > > particular case. Although Darrick was kinda heading in a different
> > > > > > direction and I don't want to start a fight here.
> > > > >
> > > > > I'm fine with either solution; I simply prefer the one that fixes all
> > > > > the current and future "oops we forgot to zero a hidden padding" bugs in
> > > > > one action.
> > > >
> > > > Maybe we should avoid creating hidden zero padding to start with? :)
> > > > But this is a small allocation, and most of it gets overwritten
> > > > while the cache is still hot, so I can live with the unconditional
> > > > zeroing. Still feels a bit odd to reach for the big hammer.
> > >
> > > <shrug> If this is truly the only place where we forget to initialize
> > > if_broot fully then I'm ok with just doing that and not going for
> > > GFP_ZERO. If we have an army of KASAN syzbotters whacking away at the
> > > system, then I could reevaluate my resistance to whack-a-mole.
> > >
> > > --D
> > >
> >
> > Sorry, this conversation fell through the cracks.
> >
> > I'd say the right approach here would be to measure the performance
> > penalty if we opt to go with GFP_ZERO and document it on the patch
> > description.
> > But I'd also prefer to just closing this gap and initializing if_broot
> > only here instead of GFP_ZEROing everything.
>
> Ok, let's do that then. I concede there /are/ far fewer
> extents_to_btree calls than if_broot reallocations.
>
> --D
