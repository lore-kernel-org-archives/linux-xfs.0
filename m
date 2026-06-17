Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436B23876BA
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 09:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781687979; cv=pass; b=lRO+b+0qDBZjP3z2SgssnGi3A98upMveAi/ne+j9XR/TAJSM45U045JUGKDWvWudw2OA8TS5SkOSZMe48lwePIpJlp2I4gMteYxQ8wa6m+rqGxL3+gCDGHSbrw5tEmD8PA906/hqECwkKnsvdI8wY3ckcIaFY5XVeOT2aICjaUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781687979; c=relaxed/simple;
	bh=TtmlPZkdUEGWVMO3BaztFv7ViFMKiwGF4OaOQ3x2ymU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HghUMOsvgyu+ev5PeFcaEg0hL6dKvE5munoIyGJxySAtZygCj2+w1Hb5VnHrC1DVclaZEQeWw4/5Dsf7w8BOs6xZGt0xCk4XjoPCTDEzq8AJKoJZl8SxVvglnXQoLddKt6ACPgpqNVHyAvMPIeKInXCbi0We7iwCSc1mqq6Y3hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fsorKhlC; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsorKhlC"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6955a9e6efeso927383a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 02:19:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781687977; cv=none;
        d=google.com; s=arc-20240605;
        b=fUNhlKyRsOzscVgi/VW4f6Tdtw73Y9q2TUnTvIEQ6Eg/ah0HxGLxsJMj6Dy/Lds+eX
         +C/UXmbbdUFCR2efclRhuDJN+EPvObmyaCD374M99ZDbHUVpTMX+//Cr0H2/Gux77/6C
         p2rbfkrv4abrCJ0OjBYN7sm5Rc0rMC6Y2SRPCKMkqzhUIWsTMTI82HY+EaJVcPd9u32A
         BdP3Dn15XDsVzQ84jTB8KX1tAje/uymbMZ65H/BSCiPWRM0JyqiRXQbuuh2XOEqmACza
         NUmv9eF07a2w6s4ubu+uDo7gX1KTl/gxBpA4hPq001y6oaHfdT9GKGCfCmks0O1I2l0a
         iCRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TtmlPZkdUEGWVMO3BaztFv7ViFMKiwGF4OaOQ3x2ymU=;
        fh=+w0A9DxABfcAldmp6hcMnFudlsnRcVI6adIfTQQW3zE=;
        b=FEqF7mmZJCk2yVEEU0Iq6/D//I/3PFYY23WD43cLoNxvHVGj0B4wcBzhkB4DiE1g8e
         n8OTTkllKlQaFyXnZL3nIshPIIL8EEtIlQrb4j7+Xe7V6Z/7Jk+mT2KkcQmN3bqYbp8k
         DFBBo6yjFnwrPssqbEb3Uddi2D+XFiqS408fuv7JacI/l67G+XepdoFcwPUswB8C07uI
         sjS/X0QpnDGsiQ9epoTF6F1exUH9c8blC5HkD+fDhrEZPRYYyNXHM6LLPr5SI4QdUrX8
         Mszscy86IRLYWcV4IM1CA05DWvKAEMTQ0Q7aUp2+CfscVUVSQi1jQaoisZkqQqU7Jl/Q
         95xA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781687977; x=1782292777; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtmlPZkdUEGWVMO3BaztFv7ViFMKiwGF4OaOQ3x2ymU=;
        b=fsorKhlCbkaWHRHMVDxRAXv0DMwi8XcIx1aK306AXXuRc25t76t3K9bATnj20dAerV
         zXMQqXbgv4/y88wdfdqHW5uRalAZ7Ev4lC+tMPR3nvLMrQJqy6Z5YGDeLvAFVqF4vcwh
         gSJR8q4o3SL1U9hgG+Obd3BfVVAWGWZ+Ht6FZIv1MK9BYRB4ovNxITCBF95v51radIba
         BsOSCfV+PFzXG4E5TCHqEXByggVzvdMLs9gLi+p1DintMCwHPt5plcJY4ebkXIPa5WnB
         zn1WQEtj34Dlp9PvsVqnbozU8eWuH5SIN8EUhA4hLkfIf+t+nC/lErpQuRKIA7bZytRX
         0/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781687977; x=1782292777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TtmlPZkdUEGWVMO3BaztFv7ViFMKiwGF4OaOQ3x2ymU=;
        b=m/eHBXQJOL0jMzTSZqO/fAOEBNkcEb6BVhfqjkqHp6NjvadM1qWSnMklQjJd3Ajr3g
         5SHRhmvX2xCR2NIDbH3Z7fK3Jg8odbVkZZt6GvF3LTPLubbP/tba57ajToc0lJSL869N
         F/LrPY4SBD4PjMT1jm8Nm4TfP/Ca0OfSprt14je2B4HFW7t6zGGOVn4swsUxah0awaHz
         +fwIxcqvdE1nP0UhiljViLFS2Tn+4Mx+gHpc6v6jzpHs/0fRlT9xB3EaKjDLMgbF5jE1
         EOPFfdeUK4B2uTHDNAR8g4etTR5O+Czfm3xD6+x8qN2o0kLEzv7m6WSYUbn+HYmrAoPL
         KolQ==
X-Forwarded-Encrypted: i=1; AFNElJ+wjo1aULhj7dbQEsafw20OwLSpvoXxuT/VGk2696Q48H/oMQn9BGVkp4fTjAXRabspRs1tPEP4mis=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYlm5skKtC74JYEaFl1xpzY4cDw84ipxnC+kVGp2yMZcqV3xD5
	FLu1+YU3AEq+QtIulz5xNQ/VMG/6SfFdc+MsCFJJkBSzqSnjNdnb+/Jn4DZ5eR00kF5W+jhejTC
	EZkzyhJFnPZlp7Ko+EDSBBsWdKZXZG2E=
X-Gm-Gg: AfdE7cleEoGAgc+WTgxKMQy2B05lRBn2WMfWGKFGliBk7Yu88U6LEemKOYE5seS+dfz
	TNFhq1mDKn3QEvgxKqqcw7AN4GkrxvTnGu6RJkRjnl9FA5xJSPbEpEay4Md6v2x/1ftoia6PhoQ
	3BOpk0vJ12yvQCSboABllLkP19KXVPWeeH/Km2K4uybjSOxPQT8MhS8md/7crWZ1lMhd4NV78hJ
	KdB7ZGC5UxwgKa4/UEKzQihMAuJg0RwG1go2YZRXIt1iEegOMehxJjbWlT2vMiMzuao6Nfk+xpx
	435CIc3diAOx/+JH9kSFGvXvsYs1u1787Q5fhHpUfQ==
X-Received: by 2002:a05:6402:13c4:b0:695:830:bb89 with SMTP id
 4fb4d7f45d1cf-6954747df63mr1395872a12.13.1781687976321; Wed, 17 Jun 2026
 02:19:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250322143418.216654-1-pchelkin@ispras.ru> <aisAxyXVxf4wql2u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260612233110.2-1-sashal@kernel.org> <ajBQPNuKCruxhkXX@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc> <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajFabPtI8UGfkyix@nidhogg.toxiclabs.cc> <CACzhbgS59uCYhjX80__+nPjEx=N8mKUsYyFS1+aRDpMA-b-VXQ@mail.gmail.com>
In-Reply-To: <CACzhbgS59uCYhjX80__+nPjEx=N8mKUsYyFS1+aRDpMA-b-VXQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Jun 2026 11:19:25 +0200
X-Gm-Features: AVVi8Cc9eUtJ7SFshQ1kNO4f0YyZBdUzhILlClrpolwmyxOlqH5yukBv9F0GLVo
Message-ID: <CAOQ4uxgXqmP49FV3b_cKDD_703bRHz0fjm=k=FmNytsPpnKx3g@mail.gmail.com>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, 
	Sasha Levin <sashal@kernel.org>, Fedor Pchelkin <pchelkin@ispras.ru>, stable@vger.kernel.org, 
	xfs-stable@lists.linux.dev, Christoph Hellwig <hch@lst.de>, 
	Catherine Hoang <catherine.hoang@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lvc-project@linuxtesting.org, 
	linux-xfs@vger.kernel.org, Leah Rumancik <leah.rumancik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2026 at 7:33=E2=80=AFPM Leah Rumancik <leah.rumancik@gmail.=
com> wrote:
>
> I have changed teams so I no longer work on kernel and I don't believe
> my xfs maintenance work was backfilled ;(
>
> On Tue, Jun 16, 2026 at 7:19=E2=80=AFAM Carlos Maiolino <cem@kernel.org> =
wrote:
> >
> > On Tue, Jun 16, 2026 at 09:31:41AM -0400, Hamza Mahfooz wrote:
> > > Cc: linux-xfs@vger.kernel.org
> > >
> > > On Tue, Jun 16, 2026 at 09:13:45AM +0200, Carlos Maiolino wrote:
> > > > On Mon, Jun 15, 2026 at 03:19:24PM -0400, Hamza Mahfooz wrote:
> > > > > Cc: Carlos Maiolino <cem@kernel.org>
> > > >
> > > > FWIW I don't maintain the stable trees I really don't have time for
> > > > that. Darrick/Leah have been doing a best effort case for that, but
> > > > again, this is mostly a best effort so we shouldn't expect them to =
be
> > > > looking/picking up every single possible patch suggested for stable=
.
> > > >
> > >
> > > Now that you mention it, the xfs-stable mailing list seems to be pret=
ty
> > > much dead (i.e. the last time fixes from it were merged into stable w=
as
> > > almost a year ago). I guess no one is really working on it anymore?
> >
> > IIRC Darrick started it, I personally never worked on it, but I didn't
> > follow the evolution there.

I think at this point we can officially declare xfs in stable <=3D 6.6
unmaintained
maybe need to send patches to LTS MAINTAINERS.

The best chance in this case to apply the requested fix to 6.6.y is that th=
e
author (Darrick) approves it.

Thanks,
Amir.
