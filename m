Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFDB45038
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 02:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763949682; cv=none; b=Zow7arUeZn3UBMT7UOfW0Lwwzwno7POg7GuzhydwUS97t4r+vefVNQlK1Libjlzp4KpJjBGcl+bgJAfEUIYdHeZViDTeXO7OkPZorNIVNvrAwGxEHCwK3++ywLgvDQWCFNexEMOeSxCBM5XKVKmEeA+DW/UA4kc7Sp0WJlKpKqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763949682; c=relaxed/simple;
	bh=+3kr6H4DmPEksHjU6g1IKbfBmlyqFl0Wz9vrA013Ppo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dOm1qzyDFC01ymITN3LxGL17QAUbXBQW2I8Oft5ThsPg7M+MewU//BnII3PS5UfTLTB3uXeyCks6aqXFVz1yRV3wSBLpefNHrS2kEg8j7GrPcnqn9r8eiHpr/iIZ13WVVQcoKAoyCmD0WIGHJjloTb10S+n3Zcu2FtfQY6RJq8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVi8jF2M; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVi8jF2M"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b2d32b9777so517011785a.2
        for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 18:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763949679; x=1764554479; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rihsM/MbquITk52HblBTEqieTE9a8UregXTIhN3Xc4g=;
        b=FVi8jF2Ma8ZsCgKugcmAz1IC69reoRIIOH8YESWy6yG8XBvVlbB+Yv0Qt6AzOT4hc6
         olH20NNcX9BNCtjvCfzbKsOT/jFl2Ak2DgPwDNa06A4pNjHv+irN7/TddW7NB4BZ+iME
         TkYlPOOKHZ3Ch/t55QZYW6xO7YaRikXbQsN/4mVFDhSVQuoVuotDRo1VpKU3k+xkAk8n
         BkhdEnw4LVZry1BVIgwLND4ras3leRv05Jlc4i0R7FNYH298yXsOm3QPTGz2IxMav+0c
         iRasjnxknCMsSRYLoMonDuUnCrwoMTxdnJD57pzaseU6C5mS3m0uh1PO11BtmfPbdYo0
         mwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763949679; x=1764554479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rihsM/MbquITk52HblBTEqieTE9a8UregXTIhN3Xc4g=;
        b=F88YpaktSyuh3jNAwyczY1hj2MD+33VYFqpbDSmr1Xwn0TpAvS2wu3XqgfLOo1IEsB
         /8sYbIQTFV3c9lTzI4wWTrab/BxZhGAVOkngIM8X2UnoSb78/ed6BGEUzivMe6DhBY12
         djMo3g57RS2F94Hjri1MvCAR6NlemyPI0ne1tsf4o83rEfDkWLorSNaPai04OfRGNGU8
         XcTKaBnJGA+66UXK2tCNYoQH9qzOkpZ3buBCHIsYXGSAmUQkvkbqRydwUhdQLM0VHBza
         fT7SuBm3HXfp1lx5OiA1cqLcrL6QqEOz1eO8wwnHgXyNEzojF65NHatFQVMrH1adWm9L
         Aweg==
X-Forwarded-Encrypted: i=1; AJvYcCVYG83zJzr13TLV8xDwV6vxLDjrPqtJz1LJkLBKKZ9VLwCBtpi001KkhihRHoPrG2uMFYAN+3KA7G8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGgUFoeV73BTrNEfx92sUhuTMeeUgFEzY6dp0p0rj2uqwDQ9YH
	rzUSCAWbFFDyUpljDjq+uLrqj5UHXrdwT02Oh/NsbQOO3age9n4L+awngKXQIBhFm04QHtLH6Rl
	NrrZhlllBnZZ/CEGBBFpXCzdJ2rkB0lw=
X-Gm-Gg: ASbGncsVz6Wfevgp3auyfFf+e/QW1BAnGxuHgSOPsPIl61+ZaUMpPMVzvO9oKnFNQ3t
	8rJC5UrlCVtYLvU8Ww/UWQxohhMdgF83oxRSBnQLFSHabE6AJKuCelLDkVJCO+2ZnTjRO9eFIS/
	eRa6HUMDFqKICIBUQjMH0uMrNy5/xe3Z2u5g0BS1L+A3Z2Jml8wRTib2qBI7C7ndaP9BheC5nRZ
	/6voxepxNNmYRkGDOtVeEKieHlQ/aWT8hgFLCztX4axyH+bYLRd/XfS1tOnlxtDiTxPtwU=
X-Google-Smtp-Source: AGHT+IFK0j8LOMDrS9m/1v8ASo3ky7d0+WiDpTykg8BeSrWtC+6aSCAuT2UVyteglGE8TJ8JAm0pjMBxqVbt9nw2ETI=
X-Received: by 2002:a05:620a:4415:b0:85b:8a42:eff9 with SMTP id
 af79cd13be357-8b33d4a706fmr1352114785a.53.1763949678764; Sun, 23 Nov 2025
 18:01:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSEvg8z9qxSwJmZn@fedora> <CANubcdULTQo5jF7hGSWFqXw6v5DhEg=316iFNipMbsyz64aneg@mail.gmail.com>
 <aSGmBAP0BA_2D3Po@fedora> <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
 <aSMQyCJrqbIromUd@fedora> <CANubcdX4oOFkwt8Z5OEJMm7L5pusVZW0OaRiN8JyYoPN_F0DpA@mail.gmail.com>
In-Reply-To: <CANubcdX4oOFkwt8Z5OEJMm7L5pusVZW0OaRiN8JyYoPN_F0DpA@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 24 Nov 2025 10:00:42 +0800
X-Gm-Features: AWmQ_blmSEmZQDursBh3YUhqjicM04mA6N_YKxn2rH4yPFBEnFOKPn_NEARJprU
Message-ID: <CANubcdUG_3VwagV-cSfhp4+95Dj_e-wkxegzCdmuNieWqrehug@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Ming Lei <ming.lei@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn, Coly Li <colyli@fnnas.com>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Stephen Zhang <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8824=
=E6=97=A5=E5=91=A8=E4=B8=80 09:28=E5=86=99=E9=81=93=EF=BC=9A
>
> Ming Lei <ming.lei@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8823=E6=97=
=A5=E5=91=A8=E6=97=A5 21:49=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sat, Nov 22, 2025 at 03:56:58PM +0100, Andreas Gruenbacher wrote:
> > > On Sat, Nov 22, 2025 at 1:07=E2=80=AFPM Ming Lei <ming.lei@redhat.com=
> wrote:
> > > > > static void bio_chain_endio(struct bio *bio)
> > > > > {
> > > > >         bio_endio(__bio_chain_endio(bio));
> > > > > }
> > > >
> > > > bio_chain_endio() never gets called really, which can be thought as=
 `flag`,
> > >
> > > That's probably where this stops being relevant for the problem
> > > reported by Stephen Zhang.
> > >
> > > > and it should have been defined as `WARN_ON_ONCE(1);` for not confu=
sing people.
> > >
> > > But shouldn't bio_chain_endio() still be fixed to do the right thing
> > > if called directly, or alternatively, just BUG()? Warning and still
> > > doing the wrong thing seems a bit bizarre.
> >
> > IMO calling ->bi_end_io() directly shouldn't be encouraged.
> >
> > The only in-tree direct call user could be bcache, so is this reported
> > issue triggered on bcache?
> >

I need to confirm the details later. However, let's assume our analysis pro=
vides
a theoretical model that explains all the observed phenomena without any
inconsistencies. Furthermore, we have a real-world problem that exhibits al=
l
these same phenomena exactly.

In such a scenario, the chances that our analysis is incorrect are very low=
.

Even if bcache is not part of the running configuration, our later invetiga=
tion
will revolve around that analysis.

Therefore, what I want to explore further is: does this analysis can
really hold up
and perfectly explain everything without inconsistencies, assuming we can
introduce as much complex runtime configuration as possible?

Thanks,
Shida

> > If bcache can't call bio_endio(), I think it is fine to fix
> > bio_chain_endio().
> >
> > >
> > > I also see direct bi_end_io calls in erofs_fileio_ki_complete(),
> > > erofs_fscache_bio_endio(), and erofs_fscache_submit_bio(), so those
> > > are at least confusing.
> >
> > All looks FS bio(non-chained), so bio_chain_endio() shouldn't be involv=
ed
> > in erofs code base.
> >
>
> Okay, will add that.
>
> Thanks,
> Shida
>
> >
> > Thanks,
> > Ming
> >
