Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DD62FBDF2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 19:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771875003; cv=pass; b=ew0NX0VnpbSb0mrs2+JTw39xpO4mzBs/XuNMBIYRqkQ5fdvCs+b8UbZUPrBAwDswLlpXcNEy4TeoJ5PF5PK2+F39diEQRYRhIApmA9mze1cDbzepb2damV8WfYuKbr5SHIT2LblISSqgvxYaM55h85va6kDWpJW2w/Q33f1wTdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771875003; c=relaxed/simple;
	bh=XFYGItsRopBY/c/uvdcQikQkEhkdsjYEffSvHO6PNBg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CzoRqTzSzC1SGmwEwRpOEx2FQ8tWoN8PPpWmZBY2Vbkva1PQL3VL3k7/2Gv1qwbn086AW8AuQUGs54dcSk/D1+dwEmUDMKs7spImkj4gRRQhW1Y7t35MsCsapy9wHZycIxagBic+ngpcHvljAA0JRsKN57Zg4xqAcRGTFWGzWuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jh4vOJ7p; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jh4vOJ7p"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1271195d2a7so366209c88.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 11:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771875001; cv=none;
        d=google.com; s=arc-20240605;
        b=lwDegsk9CIb5Zq2g0kCXVc7s+JqgTqZdAhuCuo0GSHL9kXtiqdvV917Ii1HWr2Dwgs
         yyBbTTN1b2wtVgalGHmk+I5Q+JNaxPrE19XcGLPXJRAnSQ+51QYzLGASi+Tn0GzQVAYK
         I9ckriUD9LdR7ouNSGDN6Q+mXd5AHRhGnMw5TFuNnWfDFTvdbYyMCmlK7mWtxQaJm2zF
         k/K9S55mQ5KhXlK3ullLboMkJBHfouqFmnoQqDiviRkhveSpNuBw+gA8iOZfHguofyRY
         ES+Jit9pMlNOEgULqNqVEB8dA63CkMU2G3XNfHhyxWjujwU02+/aOxUXwYY5jkINggv9
         lEaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DB3mrvlAWBDGLJZPudSFT/UEOEJwKv0sAbUe8nKUiKM=;
        fh=pSdrseqNupkxNxqKlXhEMb/2RRkeMT4fn8FFpitvwgI=;
        b=gOEcKAK0mPUocS/jVCB1J2sq6xHz1fSDfNBfkB+TWt5jDUYfc9WZyQe1R09dglJtk9
         Nsz/R8xOLiHGI7D9ZlLgbfEBzPUcn4bLVPejLyo10RuaE1uObIXJ+bJiHXjOOgxgZwvu
         RAvAIJyWZaZ9mAagXHM2qHXOKC8MCP0oKaEhtEvr7GijCHaFJcgrGnlVzWn7Qzzenai5
         726N6drHfFWTx19f4leH57agFWZ92fL4Y81rYayCqgIxle617edN9rwQievVt/wTJcug
         +TkkHUsQyB6UuY8d+eZffFuoodqj7TR2qfj6PgFiuEEBeTt9HYzqBubeCzNitppsC/2j
         CJWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771875001; x=1772479801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DB3mrvlAWBDGLJZPudSFT/UEOEJwKv0sAbUe8nKUiKM=;
        b=Jh4vOJ7pFp7Hr/NgvLoD3piD507RV0jGwlXpnVm7dRC/6KGLCJjbt/xfrU9Hb6QIbL
         Sz7hzhKC5sqP25Yp0uz01KbZ/GOCft/w2Uvqer1jQk8CuHHQZIxf0M690RsICYARLu+g
         Vph6Ap7RcrmmCOGu1K9Wn5hjeLqdIJY+NyNHdAA4SPPRgdFWtAyW+Yp+VEq8IfE/wCfi
         5WagygE5ra1H2QEbyMrO+DWx1/iqMD7/3J4SQTcSlEAKVzRiquJyfmn9yZoh4oCoLOoF
         odpo7/dxqPJ6UdehPLnattVryHborIBn9+ZaFzBpRO0mkuwqAoNgrOZnyHrJLf40uU6F
         3+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771875001; x=1772479801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DB3mrvlAWBDGLJZPudSFT/UEOEJwKv0sAbUe8nKUiKM=;
        b=UqSbi3+h9s8OEqcx5OxNRpHztsbYR+Skqw2xTrIYkpd2iX9RhfzmOre9CdqXGUdY8f
         N08NQoeTp4MvytOBT1gcf36RQRCL4EbSByZfku2axWjf4GA7n8DrU45J7MQghV8LqmNl
         DDBq54DzNHfhs4faowtZP3Uvek+bA/R1wYjUnJb1jcCCzzaa6nSDKPKXa/SMRoNwqsfv
         ta+3nKcUKJO1eljnSzXgMJtPe0wrp1SzRD+0EM4eWN6F2GnZn5RhI1C0rEw58nFYkaSr
         Y15Zb9UBTrtBP1JD1GYJl7YAdeKc1qemyYyjg5cOLppa5AEZTTQOIERzfROxzZyLg181
         fR2w==
X-Gm-Message-State: AOJu0Yz/lN3wfpXD4T5SZx+4utyjUZOA5erT/qPwXWId+LJTsEUD4rU8
	H6y/GcmQ0bIpUotJn7mkdN55jZ8xyB5KNA5/XbQriRG/uJT74KmfPEBZ58s0OI6MqtLyKC2qf7b
	HgL6qdbzqwQalpsTzW83c2pw5iJVoAC9ju7FK
X-Gm-Gg: ATEYQzxrNJv63sWSzt94t4GDxTbPbL7qCZD+9Q8rwpGhWo8mXqZlEs6Q3vYWyDac/VZ
	JjQGuVufctmCT8FlWHzBHm/m9wARBc3Zh+yD9QUxKeSS/OeCpC5XKsvgihKxcQ5rxXG0Ayx+8ep
	YmB8OPiSbv63nntbva0mAeQgtyIKGCNgvYNEtykc2ZZlq7Hq1sxRfvq6VVtzntlj6slbh89VUek
	pRc50IzEqTiWZ3PneJRPJBUnAi9BrtewpqWW4Y5e5s7Kg+7/MhfatIYDdLDsDVVUYAQQavxG3iy
	TYU8hg==
X-Received: by 2002:a05:7300:ac90:b0:2b8:5159:eca5 with SMTP id
 5a478bee46e88-2bd7bc71d7amr4089717eec.14.1771875000842; Mon, 23 Feb 2026
 11:30:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <20260223162320.GB2390353@frogsfrogsfrogs>
In-Reply-To: <20260223162320.GB2390353@frogsfrogsfrogs>
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Tue, 24 Feb 2026 00:29:49 +0500
X-Gm-Features: AaiRm50DNqY1VV1gEGWYUF_u_s_FMbf6VVLyszOf8Y2xZ0LuhhHlxgo9Zsl8gkQ
Message-ID: <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

```
cp: failed to clone
'/run/ideco-overlay-dir/ideco-trash-o4ut52ue/upperdir/var/lib/clickhouse/st=
ore/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/prim=
ary.cidx'
from '/run/ideco-overlay-dir/storage/ideco-ngfw-19-7-19/upperdir/var/lib/cl=
ickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_1=
1925_0/primary.cidx':
No space left on device
```

In all such cases `xfs_bmap -v  ......` always refer to the last AG.

# xfs_spaceman -c 'freesp -g' /run/ideco-overlay-dir
        AG    extents     blocks
         0        461    6658463
         1         98    6406298
        .......
        15        125    6638281
        16          1          1   <=3D=3D=3D=3D=3D=3D (!)

=D0=BF=D0=BD, 23 =D1=84=D0=B5=D0=B2=D1=80. 2026=E2=80=AF=D0=B3. =D0=B2 21:2=
3, Darrick J. Wong <djwong@kernel.org>:
>
> On Mon, Feb 23, 2026 at 02:48:48PM +0500, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=
=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
> > Hi,
> >
> > I ran into an issue after growing an XFS filesystem where the final
> > allocation group (last AG) ended up very small. Most workloads were
> > fine, but large reflink-heavy copies started failing. In my case,
> > copying a ClickHouse data directory with:
> >
> > `cp -a --reflink=3Dalways ...`
> >
> > fails on a filesystem with a tiny last AG. Using --reflink=3Dauto
>
> How does it fail?
>
> --D
>
> > doesn=E2=80=99t help either, because `cp` doesn=E2=80=99t fall back to =
a non-reflink
> > copy if the reflink attempt fails.
> >
> > To work around this, I had to write scripts that compute a =E2=80=9Csaf=
e=E2=80=9D
> > target size before running xfs_growfs. The alignment I needed is a bit
> > awkward:
> >
> > 1. Round the LV size up to the next multiple of the filesystem AG
> > size, so the grown filesystem ends exactly on an AG boundary (no
> > partial/tiny last AG).
> >
> > 2. Then round the LV size down to the LVM extents size (4 MiB in my
> > case). Rounding up to the LVM granularity can reintroduce a tiny last
> > AG.
> > If the automatically chosen AG size were aligned to that granularity,
> > step (2) wouldn=E2=80=99t be necessary.
> >
> > This feels like something xfsprogs could support directly. My proposals=
:
> >
> > 1. xfs_growfs: add an option to print an =E2=80=9Coptimal grow target s=
ize=E2=80=9D:
> > the current(new) block device size rounded **down** to a multiple of
> > the AG size.
> > A --json output mode would make this easy to consume from scripts.
> >
> > 2. AG size calculation/alignment: when choosing an automatic AG size,
> > always round it down to an alignment such as 4 MiB, or (preferably)
> > consider the underlying device/LVM extent size when it can be
> > detected, instead of using a constant.
> >
> > 3. Docs (mkfs + AG sizing): when specifying AG size manually,
> > recommend: choosing filesystem sizing so the final size is an integer
> > multiple of AG size (i.e., no partial last AG), and aligning the AG
> > size to the underlying allocation granularity (e.g., LVM
> > extent/segment size) when applicable.
> >
> > 4. Docs (xfs_growfs): add a note that it=E2=80=99s highly preferable to=
 grow
> > the filesystem in multiples of the existing AG size, to avoid a tiny
> > last AG.
> >
> > 5. Optional grow mode: add a xfs_growfs mode/switch that grows =E2=80=
=9Cas
> > much as possible=E2=80=9D, but clamps the resulting filesystem size **d=
own**
> > to an AG boundary, and reports how much space is left unused (e.g., =E2=
=80=9CX
> > bytes left unallocated to avoid a partial final AG=E2=80=9D).
> >
> > This might sound like a corner case, but it=E2=80=99s easy to hit in pr=
actice
> > when the block device is resized to just arbitrary chosen size then
> > xfs_growfs expands to consume the whole device.
> >
> > Thanks,
> > Mark
> >



--=20
Segmentation fault
