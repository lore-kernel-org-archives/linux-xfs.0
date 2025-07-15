Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89052E762D
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587499; cv=none; b=KCHf5XfPp9nJUACz7qiUJ9nl8jtP9U7J6liRVUdIAHYA2bB3ZCSersXaOcsV92tVuh4J4oW+HjOE2ph9Kuq+SGpBQq5wEw4ypNKvK7KNYiigojQI+AMQYIRgQS42vX7ffOENnHkSnFeXkEf1J9N7SUzaYncQgzcuwUwvdYaZMUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587499; c=relaxed/simple;
	bh=xYnsJEEKmjPoR6xVBk1TVqzwQQq5B+P+Ave+N2LTG3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qatgiNd6T8WlsF7IB8JVpK0k0OCdeB38BYueFWyYB2DQy5TYPBXFoG+4b+Unl3aHJFHrO20FtnjiFyw2WZ1EYP8MFx0T8JJMizd5POljrL5BiIGC5O8Yis7ps8YrObHSzxvE56NS9PXZsWGtyuhm5XHPkTcREVNVWOsSx/9NBfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMin4lcU; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMin4lcU"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-32cd0dfbdb8so44255041fa.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 06:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752587495; x=1753192295; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDlxdanljwl0KU52CSiZjUdQkJ9lc3GcPx2JPxzzEcQ=;
        b=JMin4lcUBLAPpVtaZvsy/vvM3HmMrjBAwJKB0ILmt9pZssu2koi00MyS5Cc57VWy1M
         0komo1P27hcYR6ypJ6HVgaRnmpaBx1yqEQnvVto+bjfbTEPrljSkdRJntLExltb88ypr
         uy7zB5+4gz0YzIFpdd555cmrBQJpJO8vAmC1BIy7hYRUudmmsCy89IV+mgA1KP35hZMd
         xmNBm9g3phqWyMRGKrKL/PXozLlXuvmG5NklzklQfLO8qOd/Azy9ptyRADnplA4tfaiO
         gvjAGyeCoRiZTLSruMogyZOTM0ZxS4RqbPzljN379fcxPhG4GEjUj7EMM6hJ3KW8wdmr
         RhiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752587495; x=1753192295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CDlxdanljwl0KU52CSiZjUdQkJ9lc3GcPx2JPxzzEcQ=;
        b=VTWcfE0zZdqpcxeLf6yxSAMLXPlIwwYl4hYEWL9lqOTOBbCORF1Ynx1MckcA2sUrx7
         XAM716tCUeQLnPAsPx9UMHBFodQHCBwLg/zuExw7tnDBc9S9GnCUVs9fZG5Umz/zds9z
         hFvx0ZCfnNzscOMYfk2TxGGDVou2x/dshTgj1qi8l0DUSgkp3koObgELlMRe076qKZy3
         bd2+DcL7jaAL2zjGDfuS30WprpHbQVapC+VUIBhoZwgR8jwfDzRdbUtn89fIk/UHBJRC
         O8B0YffSsXXvcb1et5i4g9TBGNG+I/dRTBn1RZ87kDPnLb/1WbuoPCmOqL65Zn99xxUp
         wtow==
X-Gm-Message-State: AOJu0Yx7/NNkrrzwJ50J4jwBgW2jlygyq2DoCJvvDE4JKXEJwOQu+i/w
	kOgeYKY3EVhLkdR4ZK/NhpTMpp6pbpF8SF2Lzjf0cAxTHDWmqU/Nj58zBxsSloSpSzrfsAuLFCH
	OlEEN2G2lldLwwXc4dvugBLcJdNmzCburhxug
X-Gm-Gg: ASbGncvHdY3Oeu9f60xj1KGjjTXL2Gahabnqc4w83sqfnKKJJLrsXuYbVL3eoOOjPfR
	pHLgS5sJPAPo06wBBn8OZIae0LmVGfKhYrjj9augIGEbg4JazjyZtWFZQWv7TnQ4JRUQ6Zxdj1E
	qv8hhDY8TyaEJwmfmiz5cU4R8SURO50eWHKsjNPv2aNTiCqQ2ky3PHVVYpemhDzrCH0c4+EOkiz
	rwgxett
X-Google-Smtp-Source: AGHT+IHP0ND7bRPAcfe1jvLscJAB5tkj6HeWH8fe+J+sRdeov8GfCGXX0HhqwCuW5K7IB8n+0WICsu9DuYBimLMWyQo=
X-Received: by 2002:a05:651c:555:b0:32b:7ddd:279e with SMTP id
 38308e7fff4ca-330532dfb0emr53129721fa.14.1752587494368; Tue, 15 Jul 2025
 06:51:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAP=9937nv-k1dTbHHRZF3=jizvRKcQNAa9_nM_Z1RA8VMYhKSg@mail.gmail.com>
 <aHScbEVwQad_ryX5@infradead.org>
In-Reply-To: <aHScbEVwQad_ryX5@infradead.org>
From: Priya PM <pmpriya@gmail.com>
Date: Tue, 15 Jul 2025 19:21:22 +0530
X-Gm-Features: Ac12FXyb5aVrjXWZgDTlSfI66pEcX86Bb4fHbUeK-iM_BMEG0-_AMFTPLuoyjTk
Message-ID: <CAP=9937tVVUkFCOudoJWx7O8aBhrAkRmkGQY7YpOU_4aHgyrJA@mail.gmail.com>
Subject: Re: Query: XFS reflink unique block measurement / snapshot accounting
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For example,
/mnt/fs1 has file1 of size 40KB
Do a reflink cp of /mnt/fs1 to /mnt/.snap/1
Now, when I check the size of /mnt/.snap/1/, it should show only snap
usage. In this case, it should be 0, as no blocks are unique to this
snap.
Modify file1 in /mnt/fs1, modify 2 blocks of block size 4 KB.
Take snapshot /mnt/snap/2 --.> This should show only the unique snap
usage as 8KB.

I understand there is no snap accounting in XFS. However, to achieve
the above things, is there any XFS command that can help?

Thanks in advance for your time.

On Mon, Jul 14, 2025 at 11:28=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Sat, Jul 12, 2025 at 01:19:19PM +0530, Priya PM wrote:
> > Hi,
> >
> > I was using reflinks to create snapshots of an XFS filesystem;
> > however, I=E2=80=99m looking for ways to determine the unique snapshot =
usage
> > or perform snapshot accounting.
>
> Can you explain what you are trying to measure?  How many blocks in a
> given file are refcounted blocks with other users?  Or the difference
> between i_blocks for all files combined vs actual space usage?
>
> There isn't really such a thing as snapshot accouting in XFS.
>
