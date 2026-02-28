Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5292517AF
	for <linux-xfs@vger.kernel.org>; Sat, 28 Feb 2026 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772277883; cv=pass; b=p0T75yyPBEt++MaQ99DlmFXaMhvTFcuTpMacs02i4q0tz+GelmWDdKyulW4d1NP5B6z5KArO4yODw8j4SEmXmP6Yu/5WZFd9VV4ymTFNfSzPgki5k7yGzpaOFLeMJETlwTMvdR3ilc/SSkc90K4jE6bjum/3ptjyUvjNZyCOel4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772277883; c=relaxed/simple;
	bh=eFGXCq/hBt+URSVUm6i3fmxtbHXSefLy4vtmzF+5LRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mD1EzbxGdONtkH2CoGH/tuRfzPRcJMcmioFwynNVNZ0qddn8zZNxEMqXVDkssTTWVKlCd+VHQDdSoNz/Vf7PRyJsMuLIcWJeJVIW7bdGy8hW8esdpkByCNWPsVNYx5PD5yTMRlGg7OrYgjMeHXxOsUEIKNgLNDNz/m0zhOwLREU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JH3FAICq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WfFk8aGm; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JH3FAICq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfFk8aGm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772277880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tV12gD3o0Lbbev84UbC9Yes91hyFWKOMyZ98vyyRa4U=;
	b=JH3FAICqDcRm3PkyZU85R9ucwNnDHREBRGBuLAkrV7Y80r6cTR1IS2A3LVw/HRIS9/FHJ/
	143qNLiqNw+2lJUoEBPIdKOXVVPnqrcqvByEyOCNOBawgEsu0VCHHujLWc80BKk+2UKeQF
	MpAcWVebV/UCeHefHaAxPsGeMt0G+qs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-xMjYnDK4N6u3cFG1Y56_ZA-1; Sat, 28 Feb 2026 06:24:38 -0500
X-MC-Unique: xMjYnDK4N6u3cFG1Y56_ZA-1
X-Mimecast-MFC-AGG-ID: xMjYnDK4N6u3cFG1Y56_ZA_1772277878
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-65f70f3f801so3675002a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 28 Feb 2026 03:24:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772277877; cv=none;
        d=google.com; s=arc-20240605;
        b=iT7w38QynxOxSY8U/fCV9TY3/biYDYiBUfcAjmCUDZqAYa6rzH1MTloTDmUld1NywA
         r/cobIRIgHrY+Xnkij2X6SIFIBMv43g4UzQTDdbw7mgyKDP9TD9KXK18tiU489+B9XMU
         l2T4VTf3EqghhqAWDsWCMM3Bwhj7klSt08AUqDW/96BeubgnmjEgpu9V62m8rGvocFXg
         D2nwfO1O9b3y7Gwy7h3DT6SoybyJyFRoQtTgcZ/qZOzOp/KAogA1gImFZvKAqUXxcUpF
         Uh+smMIt7/CLJnwuhiADJsxeDUN9vQj6189YdcxzjAu+h49pqnUFzKzprDxdcG38yJQG
         vv2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tV12gD3o0Lbbev84UbC9Yes91hyFWKOMyZ98vyyRa4U=;
        fh=Gb1k6Jlr5cEsBujR0FnpZ+g5FNdZefpO8/luaHm0zdI=;
        b=JQ0RAmNYURKBqdR8gm8Z2yLT8SDpXLY9LWmPGij/OfJu6i6cosMSWnUO6AvHCeyg0M
         J9srqAGJnetAhQA3aow4bleKT2vt3ZSqni2J5TS/8LYAAUL3HQ5bjOnrg/aXNmdLvU5r
         yrCK1e5VuA0Pho0luHvJZssymu2CW7EOxweeJHNQJJ0F9heO3EaLD8VuefH+bEv74ZnA
         eJWkC7O+JTcPmptVTMKUhBvowKs1eRmeKZRat+pDqnkswEeWXVR7n/NEIhea0mKI6B+9
         UEKnzoH+wta1OOf3KrTiFGhngk6jOJy1THKSiX+zI8aptXM4jibDyNJeMetC9iQYAe/O
         BJ4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772277877; x=1772882677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tV12gD3o0Lbbev84UbC9Yes91hyFWKOMyZ98vyyRa4U=;
        b=WfFk8aGmO+iT4W/6H8H0O4FScx417wRs+nGaefPB5jBWVN8YORzHeHg/BK8tlO6Fi2
         7ldeoYSGuX2o1kXIoCcrc8238quMcll9HwK7n6hqO6bTCdSTre62nCdJx88aw7lWj4yN
         l0yePXq3Pz5PB2RzWDpOFDfyYWEpeum/ArLG+GGMwOURajhpM3Hqk14Q5J+8zoXlNU0f
         3gky92vajHCmA2cHplS4IoAUZu986WXFTIr6j6KpRHUu3ie3oEjbefx4XfbmG5kKJtV4
         1EIkqcXT5WJC3KwI5e02sRd4658+Ke0zkdHOmbhldXDefcuNMVwpYwbGncdsrTnfOeAV
         1A0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772277877; x=1772882677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tV12gD3o0Lbbev84UbC9Yes91hyFWKOMyZ98vyyRa4U=;
        b=ojmseitSQu8IX6UsR8Xml1xpKRzco+eIWWv8xoV/o1xnZV9QoOzNU6+uQRhkGndl+x
         ZKD69d6fUSQ5vfP/KvsFTYdNyahZ4HaXZsmPpWhgEgrNhRR45eOih2jBOw/DxUbwqErn
         1vvoIn5E3eG3FWjx4N6ydFSIzVAKUCkIMC+Xi45EytBeft9SU39riDPYi6sFmy9Jk0lA
         7hYRwpRaDtnWt7wf0/Mdz+sf+AIs/2Yu5jvwXze3cHnfB7zmU2jTvhp1evvps5SYPGiD
         SDmoOdIkZcGZGib9Ik2vnHbN66Dp4kEjLruhiL6b6Lz3zxcpjedM90+Mz6TPxD79zEgg
         sgSg==
X-Forwarded-Encrypted: i=1; AJvYcCXzIK0C4yc0ns3iw+SWiceH0dJwHEfwLET8oEQFaVT+ets/6adnHzkOfWNF0/MXA58q1vHKIQpDh20=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw73BRPXMrtvv7cJOKsMOCSPDf6gXyweopM/Lf1nVYURn+FcgWO
	yGgpiNtR9i+v4kbwiFbolOQKRKQ6JlkA7KihK4u2Uxr3tsVFoLg1XbYMpE4KvxdJF6Qqt1dnD2d
	q+qZwxcDPxjOpJANXdFXfY5D+j20eb/Q26IQ5S6C/vJNuRqCExVcrv29scHfYel7BEqojNHxS3a
	FotEGpWuYtrYWv+t3GOut0K8hfiVkUoinoW4Cy
X-Gm-Gg: ATEYQzzyHQXxzmyhqtecRaIrcTKM376jLkWMVQUywTtLqSiD2TL+XFUsJ3ZvVnIRu+E
	A/qVatKntwKKTMTH82mZTKAa3IUb+eLPS+VM1aJUGKU3SgSrez9k/pDs25+Ekx73gzMRh0F0O3j
	AHBNEafTod6nxWSY3oW6jEKdarCxmopv4JX0G9fWqwS9Fqw+N5oZfJNPZ/xpAZkYZjA2+cEMg3v
	/fG
X-Received: by 2002:a05:6402:51c8:b0:65c:b21:2df4 with SMTP id 4fb4d7f45d1cf-65fdd6b6399mr3970803a12.6.1772277877564;
        Sat, 28 Feb 2026 03:24:37 -0800 (PST)
X-Received: by 2002:a05:6402:51c8:b0:65c:b21:2df4 with SMTP id
 4fb4d7f45d1cf-65fdd6b6399mr3970788a12.6.1772277877075; Sat, 28 Feb 2026
 03:24:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aYC0pe-S-RWSMXHn@infradead.org> <20260202185959.GJ7712@frogsfrogsfrogs>
 <CAF-d4OshnJ997DDsgWzr0f+4-JpRaQ+B5-y6M0PUm=es9LpQXA@mail.gmail.com> <20260226053052.GE13853@frogsfrogsfrogs>
In-Reply-To: <20260226053052.GE13853@frogsfrogsfrogs>
From: Ravi Singh <ravising@redhat.com>
Date: Sat, 28 Feb 2026 16:54:25 +0530
X-Gm-Features: AaiRm51zGZrMzypoWMW9MThBwz04v7oBl60iTgsBk2woZR1usYsGtkblaM8DmHg
Message-ID: <CAF-d4Oscq=qaCd9dbbEZjG8dA5Q7erdWSszoxY1migM8j85eRw@mail.gmail.com>
Subject: Re: generic/753 crash with LARP
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 26, 2026 at 11:01=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:

> Hrm.  Where should we insert a xfs_force_shutdown call to reproduce the
> problem?  I can get this to trip, but only after 18-25 minutes of
> letting g/753 run.

I'm able to reproduce the crash reliably with the patch below.
With this change, g/753 crash quickly.
Please see if this works for you as well.

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 354472bf4..15eefa3e1 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -500,6 +500,17 @@ xfs_attr_finish_item(
                goto out;
        }

+       /* Simulate crash after setflag committed during LARP replace. */
+       if ((attr->xattri_dela_state =3D=3D XFS_DAS_NODE_REMOVE_RMT ||
+            attr->xattri_dela_state =3D=3D XFS_DAS_NODE_REMOVE_ATTR) &&
+            (args->op_flags & XFS_DA_OP_LOGGED) &&
+            !(args->op_flags & XFS_DA_OP_RECOVERY)) {
+               xfs_force_shutdown(args->dp->i_mount,
+                                  SHUTDOWN_CORRUPT_INCORE);
+               error =3D -EIO;
+               goto out;
+       }
+
        error =3D xfs_attr_set_iter(attr);
        if (!error && attr->xattri_dela_state !=3D XFS_DAS_DONE)
                return -EAGAIN;

>
> Also, if you apply that patch so that it creates the incomplete attr
> name, do you end up with a consistent filesystem afterwards?

No. After applying the patch, the filesystem remains consistent
after the run. xfs_repair -n does not report any structural
corruption or incomplete attribute.
I haven=E2=80=99t done exhaustive testing yet, though.

>
> I think xfs_repair could report incomplete attr names instead of
> clobbering the whole attr fork.  xfs_scrub can fix it, so it's not a big
> deal to leave incomplete names around ... unless it'll confuse
> xfs_attr_set?

I agree. I took a look at your xfs_progs commit
11a22e694671c112b3ebfffe879cc148cb8b5494.

>
> (Also, do you ever see the xfs_repair in g/753 fail with complaints
> about a corrupt attr leaf block at block offset 0?  I've seen that once
> or twice but haven't reproduced it consistently yet...)

If you're referring to xfs_repair -n corruption errors like:

Metadata corruption detected at 0x55dc57df7f68,
xfs_da3_node block 0x10801d0/0x1000
corrupt block 0 of inode 25165954 attribute fork
problem with attribute contents in inode 25165954
would clear attr fork

Yes, I=E2=80=99ve seen this once as well. However, I haven=E2=80=99t been a=
ble
to reproduce it reliably.

Thanks,
Ravi

>
> --D
>

