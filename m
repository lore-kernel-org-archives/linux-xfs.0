Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30F2258EC3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 21:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757539410; cv=none; b=XHN6VW0dEkhC/W4xyMFBA/i9lM63TW/zlxFGWG+3mWC5tLCZ/CCNa/45pMIETyzsESp21GiE/1BMPucFXa1aCsklKkoYCcHwqORwy8WaIZrg0wQ/y+4HXVOfGS6YR1MCLasj6kotuU/NOGl9fpTk2ax+XYKTA2FbDKPJZnTfzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757539410; c=relaxed/simple;
	bh=B4wrOQQtyEn6oCtlv9strvpGx4cFs9e70ZIslrrvt9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UYtyHpCQKLxXZcWw8iv+shk6h4OqJELZhCl+q89zyBJy+UcnYOaFgxc1QEaH7kXpJDrzFkK278eRKncQG77j54/NjnOPDKq9JCISO69Jb/CqSv7WFIQH8NfVIFPMyxMslht/cR+mfqxvC6F0WZscQI6N6qpldmoZCywht2A53rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEK1xoNI; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEK1xoNI"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b00a9989633so15238566b.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 14:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757539407; x=1758144207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4wrOQQtyEn6oCtlv9strvpGx4cFs9e70ZIslrrvt9M=;
        b=QEK1xoNIzgb2fUSD0kjL6/Fad6pjwExtK6fUFZ2UT3a/3I2CJpdtIOCNoh4E0UxX19
         AuEiEkFFyY02+DvY9t+8PBr6IwEpk0HJYvMTTTlEbsVi3WDnBK1EGsXcGYiErt5CpJfd
         JZhL14xjVeDMepml1nb8D/7nCZvcnedlkz6uIDzSpfSZ5YYc+tQgb6L8Pf41pv56ingI
         vVCIyvJFlwFkHJPhpT+cf3D/1B/y6MSr3PYO7tV5AjEvritmkqrTvYarXzdpO2zARwiw
         c6i3r2LCVNKs6yJfwp0MBjRKDHUekh/VKoyg27iiyeHrMH6QgFjxMEP15PNLvV2gpPu5
         b+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757539407; x=1758144207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B4wrOQQtyEn6oCtlv9strvpGx4cFs9e70ZIslrrvt9M=;
        b=VWukerf8uB6w2MzQjXR43FnDJaEZA1poS3DEC6MUbb6u39VxmNt5yu+n1XjNlbGjAk
         JW70gUJAkupRsdRcPRH8WTcHhq4iT/zTO474uREtctyP7L1hlOSZijzSSEhYzexV/W34
         3FPViQruVqG6epVcEGCBoh844vVHvIOYGZay3esHWP+KKeJ8DgnWzvnSkZHZapsEizLn
         W55OGkba+eSRA71ewCFl0xHGfJ2I3sNGfD5BoU9bssAUehlaqTcz4fXKp3u+3NH2e482
         k3PU+3OBrCB81Y8YRxRxixWaWfCQtqpbgrZSu6QxC7VzNKdcJpHOQK4f05IlbXjE0Sow
         hQiw==
X-Gm-Message-State: AOJu0Yz+HVVv2YLZcFu8A7Huk5Vv5cHzaY2OXG0CMD/j+FxOiV2qQLyN
	TD7gtmGcc/aBCFBelkQng6GmUPskddsoCCSQdFF1O4b4uf0gXiO5kr/plVIiN4eaWmLZlkt+sjN
	fS0qXPRrRasmO2L12dS1diVNUb9YJHAE=
X-Gm-Gg: ASbGncs7h8ilKIfgsJVQII7XjAim/Pg6/0ddNl3FkjpE3MSCpjAZnNGDpxmAb3Q2DHS
	RegSnFq27khPj7XWfnhc9nkNP898gfz4D7E4j9Ip4EgTwhGQH04enoNelHeWfmD4/aCF6igKp6l
	0Hzi99DU5bwpZqOR3/ESXa0NbU59PftbwseYts45BafMUFbAdTUeWAqrOYmrVREdtKXBfMKaAYy
	MFAM/o=
X-Google-Smtp-Source: AGHT+IFoRngI79Y8kVyoegluef1LH9J3EXYFx1B2U6H7k+MWsIgG4WxnFpNz5mnyT1SBJqfE4mvV+rFXGIffMjhHs0M=
X-Received: by 2002:a17:907:7290:b0:af9:479b:8c80 with SMTP id
 a640c23a62f3a-b07a629105amr114993566b.4.1757539406992; Wed, 10 Sep 2025
 14:23:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd5fWjEwkExSiVSw@mail.gmail.com>
 <aMHra0oELOSN3AxP@dread.disaster.area>
In-Reply-To: <aMHra0oELOSN3AxP@dread.disaster.area>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 10 Sep 2025 23:23:14 +0200
X-Gm-Features: AS18NWBfy8LCJFGnkTaWRxfJiQcbIxeLcuR_4lpDlFKujDXP3xOs1ymD829il50
Message-ID: <CAGudoHFPeQv+zsHjFbifPRiU4Ar2WjTpiJD-JvkPcuTYBVO3gQ@mail.gmail.com>
Subject: Re: clearing of I_LINKABLE in xfs_rename without ->I_lock held
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 11:19=E2=80=AFPM Dave Chinner <david@fromorbit.com>=
 wrote:
>
> On Wed, Sep 10, 2025 at 11:40:59AM +0200, Mateusz Guzik wrote:
> > Normally all changes to ->i_state requires the ->i_lock spinlock held.
> >
> > The flag initially shows up in xfs_rename_alloc_whiteout, where I
> > presume the inode is not visible to anyone else yet.
> >
> > It gets removed later in xfs_rename.
> >
> > I can't tell whether there is anyone else at that point who can mess
> > with ->i_state.
>
> No-one else can find it because the directory the whiteout was added
> to is still locked. Hence any readdir or lookup operation that might
> expose the new whiteout inode to users will block on the directory
> lock until after the rename transaction commits.
>
> We really don't care if the inode->i_lock is needed or not. We can
> add it if necessary, but it's pure overhead for no actual gain.
>

Ok, I'll add a variant which foregoes the assertion.

> > The context is that I'm writing a patchset which hides all ->i_state
> > accesses behind helpers. Part of the functionality is to assert that
> > the lock is held for changes of the sort.
>
> Yup, the version I looked at yesterday was .... too ugly to
> consider. If I've got time, I'll comment there...
>

I'll be sending an updated patch today or tomorrow.

--=20
Mateusz Guzik <mjguzik gmail.com>
