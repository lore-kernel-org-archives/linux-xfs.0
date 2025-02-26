Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A442036EB
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 08:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740558592; cv=none; b=DTt02HiVW0s5mKkN3rg5xAfWyi47DKHAh26WVXU2nJMLIlxTafImL7CuSqR4tyHwpYcr3O/zQD/vklOjO+GSXp6LL8jy3BwBMRNLVYH/YFrMtgutlqxli1MmtJ410bra2NXugY/PgZ8sQWfgg7ktM6bGg8OkAF8GWCowvK9Bf+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740558592; c=relaxed/simple;
	bh=+w08B6WQFLWGoY7KAUzC4ng4zpNF75XfE1/K5F/1xRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xe05wW/DiYw1ZqMBxh0j6pgOdxcbIkJjo4CCQ4Hs3EV+y9i3TfeTfo8o+3u27HMRbB0VIiHKwgpRn921KHWijP51RX9nYtr3KaadOoeWiL01WrDUDtezu78R6i+7m6HJXdqPM4N+m+ruM01VQlSDdz+nmY4U2rKPX9fZGsVbovk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hm/CYtcW; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hm/CYtcW"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-abb9709b5b5so1187372166b.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 00:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740558588; x=1741163388; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qd/P01QUb5F02hWZoi0IIwP5a5sgbN5wVj3NeUV9KKE=;
        b=Hm/CYtcWSPW1k4fv9hDPqmE66S4dHDlH3+8R0sXYWiBdQitIDMEmtvpLhZI/Y5By9S
         sKR7EEAWBP9y+hDW8nyhlSKuiTppxodU/pVlJAOgF6i/xxuAmdB3c+uBfd9mqRuVNfkm
         1nhKI4KTfI2DVSCdQJax6zLJQSfl0Nir+9hLn1CXgOyXpo0ydvtgt1ILpZsIKfIze3f7
         2ebGtc2bWVp0iTe6doS09oetqbmoeXAtO4D0lkQ6bDEIq2tJhJh7Mc+kWvYod31kDaMR
         SK6SfwUwNyNGVyKGLHuM2oEtVFrf4Pzxk945NBPutBBNUiSSSx4OHm3lFzog+Lh4xehk
         6bNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740558588; x=1741163388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qd/P01QUb5F02hWZoi0IIwP5a5sgbN5wVj3NeUV9KKE=;
        b=N+ZvyLZ+nDwqhBg9edLzrNJ2i9o2qpCBIU+J2j9blpdxFxCOsoxETvxqPjW2DPi+W0
         kNCTAReQsL+U6uYDCU9jIBY+wHwF8wcW5sJNvKVQFsimt37dNF1A/EXQISvjdzUn8Aov
         VH9DiF/z5JZGAIgP0SU6pArzV+nYSMUei+oU2IQoIl3kt6NEuqrg2AilQrkb5MbmlYL8
         v0/rx7lnL61heglA14yONcVZDO2L1Hb53LCvQmeeUUB4bYFLso69EhSu+Ve530HVQmcq
         v6HaZmDPl7uWRDe4Lo6nVPQ7Hg1S0Et8in5d3Txi9m3XXnMpibySNZiAdWfjgVhtvEg3
         X5Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVwyLYuQAd33+MI38Zb30mSWHE1ZSaQgwVhyZAjyUzQJGFC7ko7JMgOq2v54rJQvrFMZkgJQ36EkDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaCGpRAS8Bqs5BZJsIpJRPdqvX0zpHuGLnlG9knMtKwtoTMII7
	puREqLe6hupfsbT6Umo0/Kan2y4LLbMRtPq7c+E3HjcDbppahh2TP96J4b3RiRVjXo+A5qBl6Gp
	2BfvRN4MqYJ37TN+TKov8R5Z7HUbclSiyxXa1Hg==
X-Gm-Gg: ASbGncv3klP4iBpDhoXAh6aa3x8hJhEmjbnwfJaA3OIecAb3pNtE4HRacrqLrWAAtdb
	rym7FttdaI0DJ7pSxCSMTLyDGcK5UWhXdnoBjbJYEsWLm2SwCpXGVthVRyazT0m6I18JqGrdvB1
	KbVzox7g==
X-Google-Smtp-Source: AGHT+IHCBmf3hFVyDRWrbNjNMJpg3u3tAe5Gkum3edJXg5+W5jYzpdGCY2CkRcaqBj3q4FkgF3ZBCF2Ur/l8ZS65ls8=
X-Received: by 2002:a17:907:7711:b0:ab7:c152:a3ca with SMTP id
 a640c23a62f3a-abed0c66952mr598124866b.6.1740558587743; Wed, 26 Feb 2025
 00:29:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com>
 <20250225-converge-secs-to-jiffies-part-two-v3-6-a43967e36c88@linux.microsoft.com>
 <e53d7586-b278-4338-95a2-fa768d5d8b5e@wanadoo.fr> <CAPjX3Fcr+BoMRgZGbqqgpF+w-sHU+SqGT8QJ3QCp8uvJbnaFsQ@mail.gmail.com>
 <7b8346a1-8a7d-4fcf-a026-119d77f2ca85@wanadoo.fr>
In-Reply-To: <7b8346a1-8a7d-4fcf-a026-119d77f2ca85@wanadoo.fr>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 26 Feb 2025 09:29:36 +0100
X-Gm-Features: AQ5f1Jrr13SgxwVjT6ysFNM9oHlwZl6dEEKFUrutAasFQHuednVFm1EELk7zLLU
Message-ID: <CAPjX3Fc1UuWvih_krriaF32aPCbGP0SPg2TSrBA8Xb7a=Ozc5Q@mail.gmail.com>
Subject: Re: [PATCH v3 06/16] rbd: convert timeouts to secs_to_jiffies()
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Frank.Li@nxp.com, James.Bottomley@hansenpartnership.com, 
	Julia.Lawall@inria.fr, Shyam-sundar.S-k@amd.com, akpm@linux-foundation.org, 
	axboe@kernel.dk, broonie@kernel.org, cassel@kernel.org, cem@kernel.org, 
	ceph-devel@vger.kernel.org, clm@fb.com, cocci@inria.fr, 
	dick.kennedy@broadcom.com, djwong@kernel.org, dlemoal@kernel.org, 
	dongsheng.yang@easystack.cn, dri-devel@lists.freedesktop.org, 
	dsterba@suse.com, eahariha@linux.microsoft.com, festevam@gmail.com, 
	hch@lst.de, hdegoede@redhat.com, hmh@hmh.eng.br, 
	ibm-acpi-devel@lists.sourceforge.net, idryomov@gmail.com, 
	ilpo.jarvinen@linux.intel.com, imx@lists.linux.dev, james.smart@broadcom.com, 
	jgg@ziepe.ca, josef@toxicpanda.com, kalesh-anakkur.purayil@broadcom.com, 
	kbusch@kernel.org, kernel@pengutronix.de, leon@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sound@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-xfs@vger.kernel.org, 
	martin.petersen@oracle.com, nicolas.palix@imag.fr, ogabbay@kernel.org, 
	perex@perex.cz, platform-driver-x86@vger.kernel.org, s.hauer@pengutronix.de, 
	sagi@grimberg.me, selvin.xavier@broadcom.com, shawnguo@kernel.org, 
	sre@kernel.org, tiwai@suse.com, xiubli@redhat.com, yaron.avizrat@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Feb 2025 at 09:10, Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Le 26/02/2025 =C3=A0 08:28, Daniel Vacek a =C3=A9crit :
> > On Tue, 25 Feb 2025 at 22:10, Christophe JAILLET
> > <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org> wrote:
> >>
> >> Le 25/02/2025 =C3=A0 21:17, Easwar Hariharan a =C3=A9crit :
> >>> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> >>> secs_to_jiffies().  As the value here is a multiple of 1000, use
> >>> secs_to_jiffies() instead of msecs_to_jiffies() to avoid the multipli=
cation
> >>>
> >>> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci=
 with
> >>> the following Coccinelle rules:
> >>>
> >>> @depends on patch@ expression E; @@
> >>>
> >>> -msecs_to_jiffies(E * 1000)
> >>> +secs_to_jiffies(E)
> >>>
> >>> @depends on patch@ expression E; @@
> >>>
> >>> -msecs_to_jiffies(E * MSEC_PER_SEC)
> >>> +secs_to_jiffies(E)
> >>>
> >>> While here, remove the no-longer necessary check for range since ther=
e's
> >>> no multiplication involved.
> >>
> >> I'm not sure this is correct.
> >> Now you multiply by HZ and things can still overflow.
> >
> > This does not deal with any additional multiplications. If there is an
> > overflow, it was already there before to begin with, IMO.
> >
> >> Hoping I got casting right:
> >
> > Maybe not exactly? See below...
> >
> >> #define MSEC_PER_SEC    1000L
> >> #define HZ 100
> >>
> >>
> >> #define secs_to_jiffies(_secs) (unsigned long)((_secs) * HZ)
> >>
> >> static inline unsigned long _msecs_to_jiffies(const unsigned int m)
> >> {
> >>          return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
> >> }
> >>
> >> int main() {
> >>
> >>          int n =3D INT_MAX - 5;
> >>
> >>          printf("res  =3D %ld\n", secs_to_jiffies(n));
> >>          printf("res  =3D %ld\n", _msecs_to_jiffies(1000 * n));
> >
> > I think the format should actually be %lu giving the below results:
> >
> > res  =3D 18446744073709551016
> > res  =3D 429496130
> >
> > Which is still wrong nonetheless. But here, *both* results are wrong
> > as the expected output should be 214748364200 which you'll get with
> > the correct helper/macro.
> >
> > But note another thing, the 1000 * (INT_MAX - 5) already overflows
> > even before calling _msecs_to_jiffies(). See?
>
> Agreed and intentional in my test C code.
>
> That is the point.
>
> The "if (result.uint_32 > INT_MAX / 1000)" in the original code was
> handling such values.

I see. But that was rather an unrelated side-effect. Still you're
right, it needs to be handled carefully not to remove additional
guarantees which were implied unintentionally. At least in places
where these were provided in the first place.

> >
> > Now, you'll get that mentioned correct result with:
> >
> > #define secs_to_jiffies(_secs) ((unsigned long)(_secs) * HZ)
>
> Not looked in details, but I think I would second on you on this, in
> this specific example. Not sure if it would handle all possible uses of
> secs_to_jiffies().

Yeah, I was referring only in context of the example you presented,
not for the rest of the kernel. Sorry about the confusion.

> But it is not how secs_to_jiffies() is defined up to now. See [1].
>
> [1]:
> https://elixir.bootlin.com/linux/v6.14-rc4/source/include/linux/jiffies.h=
#L540
>
> >
> > Still, why unsigned? What if you wanted to convert -5 seconds to jiffie=
s?
>
> See commit bb2784d9ab495 which added the cast.

Hmmm, fishy. Maybe a function would be better than a macro?

> >
> >>          return 0;
> >> }
> >>
> >>
> >> gives :
> >>
> >> res  =3D -600
> >> res  =3D 429496130
> >>
> >> with msec, the previous code would catch the overflow, now it overflow=
s
> >> silently.
> >
> > What compiler options are you using? I'm not getting any warnings.
>
> I mean, with:
>         if (result.uint_32 > INT_MAX / 1000)
>                 goto out_of_range;
> the overflow would be handled *at runtime*.

Got it. But that may still fail if you configure HZ to 5000 or
anything above 1000. Not that anyone should go this way but...

> Without such a check, an unexpected value could be stored in
> opt->lock_timeout.
>
> I think that a test is needed and with secs_to_jiffies(), I tentatively
> proposed:
>         if (result.uint_32 > INT_MAX / HZ)
>                 goto out_of_range;

Right, that should correctly handle any HZ value. Looks good to me.

> CJ
>
> >
> >> untested, but maybe:
> >>          if (result.uint_32 > INT_MAX / HZ)
> >>                  goto out_of_range;
> >>
> >> ?
> >>
> >> CJ
> >>
>
> ...
