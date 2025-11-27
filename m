Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8C33148A0
	for <linux-xfs@vger.kernel.org>; Thu, 27 Nov 2025 07:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227169; cv=none; b=Dw+O0s79ynF5y4p1kvR5LSRKplNK3qx73t4+HtLF3zrSjLgrcD8e+wnELZbu8g8SJQiPhfHmdJs2N7mlt/MVur8eBc4QIabx3fKk3VTGB370Ch0G64ccvXNPnyIxFl9usM7mXr2U++AQtFghnIdA7iOXwcUZQ3gCx8aH5VIzw0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227169; c=relaxed/simple;
	bh=CMn8Ph+lvXBEATa6Qkf2qs1z8fpeEQ8hfjfQnD544JE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kc76gFzmJX10tBMlBplKJiF4lulg4tnysNib+FUlZ0SNpxuLss5MRq6NdyKHHFcvZ9ZtdUfw/fRTRIzvEf0JsRQL8Q8H++18ZajSk42a8mV8YJjH/kzOGNR8zlYks++VonLnf7lI5QWJGsuxoOxl31PDVELAlRrLw+vtSNsDX0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=esGNtgYD; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esGNtgYD"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8843ebf2facso7164646d6.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Nov 2025 23:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764227165; x=1764831965; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWx41fjiYDvxJBDcxhBox+FSm0FMogENCux+016VrYw=;
        b=esGNtgYDyNXlf0RzmTfrH2Px8jiojYxfKOFOCAOtgMF3JLkpyqffNhS2axVozhCEuT
         R0SbQ6SKq109clRPJ+E7EfoWSH8UX5nQN+4VtVegaVzpFzsbPLTUoR7DN7xOpNQv9qvP
         dJ/AnFHCn5qMw+591IW9tCVsbHVAYKTy6bYglAAdU1QFbMFhBTQBh6yWj3lmQkgshohP
         OHSLzXLdIbYuYISAlk7zrXDuGewwx8gheeHHv5mvBZ4wdtAO08bRe49LIiDZhCsG+xrF
         Ft6cgAZZvl7xXwLy05uO+K/TG232oEI5K2rlJYJOZWgGWSfWtwwXqHueY1RLg4ZoWlsT
         TuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764227165; x=1764831965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NWx41fjiYDvxJBDcxhBox+FSm0FMogENCux+016VrYw=;
        b=NH8dWJB1PnNG6+QMq7TqjZX/8aL5lLlYBD6aQt+tGkesfDwKHSdyZ0hwlzh1BTh4lT
         wBGmJDJmc+nFl0MPi4i4i0vkeBjbxQpiwAR/z3147LjKJpPzNNirEVSIiQR5MNsKcfBc
         7cgNlE9lvLF1ESFNdIZHexy1fK3VxjZQNEFnKthtffQLBXPMnH8Vg9qL7Jc3DDEzKfVV
         m4C+JQ216lenU+TvvItXVT3HoZktO1J8za6/vBwpq1XHMLMah9UjPkzisyao+UH9AEnn
         5vqZWqsNLAbtrVJ9QActGtjLQJYNexiswm1Zv6bZWg4bhim/W5Dqfgt/AWNquGHYq2Ig
         S/Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXe+I6YxfD2z65Tj5bzCqvBQwVMfodQaeqgYEOCsWIjP0bF74UQw6NuXC8TrX+wdokLKA82qd1CG38=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvFZO4vOInuvh5K7cWE4hYmhCsZdBCaccky7AjVrNMYHVkltPW
	Gz/qpqqTpwAlqXHJE9SLH3z6rcUDRcHm3ryW2QfSdJxMKAUsrAT82fmGnEBd1yeVAvN8DtpVTOz
	CCPfTG9KCtMbpKpfDcvXuZIMvXFkWWt8=
X-Gm-Gg: ASbGncu7RwXZLK9JjlKq1geWQHXxL75JMbXTGjIXIDH3/wsTNGJGC/2LxsXYDhALsGC
	enqeiQ9crN4v+hAe+jD38LGoBwhQ7/1TiCYZtrhCsmrNTjPlPJpol6xVmuDK1TmIBQnU+9OxxdF
	UaBglI0ooH05O+kqweQVcWgGoQ9navciuKoew6Wm5SGO4BXm1HtL8qPgyvqRmdOwsYr0auNDeyS
	CTw+SaSxSeKOk/3jC/Jz8QkbHMCqbjL+mxZMzwaH1Wha054njD2WIsYgTy1pL+YiDMTVOPPNI+D
	ocaf5Q==
X-Google-Smtp-Source: AGHT+IHzM3mMsS8tgLfoKGHhBY7XCjpG2AMXOtnZwN9X/T1/YsQGgtSmkxVAO42GtcErC0+dnzj4kMOng2ojzVjt/kM=
X-Received: by 2002:ac8:5ac4:0:b0:4ed:aa7b:e1a6 with SMTP id
 d75a77b69052e-4ee58b06ceemr313796031cf.81.1764227165447; Wed, 26 Nov 2025
 23:06:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org> <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
 <aSP5svsQfFe8x8Fb@infradead.org>
In-Reply-To: <aSP5svsQfFe8x8Fb@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 27 Nov 2025 15:05:29 +0800
X-Gm-Features: AWmQ_bk_Q7JOTiSFa20fvKvOS6m3SqnDBEgFzZo8VoXEPgg04GUPVW1qbNBOsHU
Message-ID: <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8824=
=E6=97=A5=E5=91=A8=E4=B8=80 14:22=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Nov 22, 2025 at 02:38:59PM +0800, Stephen Zhang wrote:
> > =3D=3D=3D=3D=3D=3Dcode analysis=3D=3D=3D=3D=3D=3D
> > In kernel version 4.19, XFS handles extent I/O using the ioend structur=
e,
>
> Linux 4.19 is more than four years old, and both the block I/O code
> and the XFS/iomap code changed a lot since then.
>
> > changes the logic. Since there are still many code paths that use
> > bio_chain, I am including these cleanups with the fix. This provides a =
reason
> > to CC all related communities. That way, developers who are monitoring
> > this can help identify similar problems if someone asks for help in the=
 future,
> > if that is the right analysis and fix.
>
> As many pointed out something in the analysis doesn't end up.  How do
> you even managed to call bio_chain_endio as almost no one should be
> calling it.  Are you using bcache?  Are the others callers in the
> obsolete kernel you are using?  Are they calling it without calling
> bio_endio first (which the bcache case does, and which is buggy).
>

No, they are not using bcache.
This problem is now believed to be related to the following commit:
-------------
commit 9f9bc034b84958523689347ee2bdd9c660008e5e
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Feb 1 09:14:22 2019 -0800

xfs: update fork seq counter on data fork changes

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 771dd072015d..bc690f2409fa 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -614,16 +614,15 @@ xfs_iext_realloc_root(
 }

 static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp, int state)
 {
-       if (state & BMAP_COWFORK)
-               WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
+       WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
 }
----------
Link: https://lore.kernel.org/linux-xfs/20190201143256.43232-3-bfoster@redh=
at.com/
---------
Without this commit, a race condition can occur between the EOF trim
worker, sequential buffer writes, and writeback. This race causes writeback
to use a stale iomap, which leads to I/O being sent to sectors that have
already been trimmed.

If there are no further objections or other insights regarding this issue,
I will proceed with creating a v2 of this series.

Thanks,
shida
