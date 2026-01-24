Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CE31A9F87
	for <linux-xfs@vger.kernel.org>; Sat, 24 Jan 2026 10:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769251532; cv=pass; b=Qb246KuLvrmDg2oLHCi0vOSEi72BsMtywZHUmaUdnfUYH86BEtt382AXaCEvI7L3dsjgwB6QI5NDWHn5DNUMRhdUsZJtZJlI1Frkbo+VjTYKu2PjrZbQgL0SrF4dc9m9am2LWVspzuBkxddNF5utyMto1svp6EIyT7eqf2Xx/aU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769251532; c=relaxed/simple;
	bh=OhfWhlQZiS1Yq37GsKg1ZRvFgI+/q0guhtaSDhFcjg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VqwJXeAoBMiqPPHpTf3SX8P0R+LnaMhK/8ier+UehFAHCawiRcTvpoJKVaPGVu+CNz0kCP09oq8BYe/6bFSPz0qkNG3m8iQEauckslwUCeY0BxEWFDr5Ow2BVvbnAOJfRsIkU0TNLjQ3zKcNmEDj27zoq1NY9SBwnoZuHzvYtxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nWrdm395; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWrdm395"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8850aa5b56so408698066b.2
        for <linux-xfs@vger.kernel.org>; Sat, 24 Jan 2026 02:45:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769251529; cv=none;
        d=google.com; s=arc-20240605;
        b=N1ZhjX0k15RlYBj85vRdxotxdZl+q/AMUeQnPXqoiI8eQF8LK5ajMbYg2R+HqZ5AXc
         dLXX5w8CZVDzAsK4cLcxi87GowP4YkIYBqqoLuquNYc15h4s3wv68yRIapnQDutY/woN
         tOIW+EVbh6UdCM6lx8SqZuoDqr8+HvZ/LaJaEsTxZxeSd54y+3deRXXM4gtboNQplytK
         jNOjbucRuf1qVeGLZft++KBhUebOkC0Xqnc8mUUYWeaIQ6Ilc9MQvf6p9iwEiCJ5u8iB
         zBUabyL8n9LE0Htbu1JmZsBWjGiOh5OdvnxQMMevIS4hMZ88NdWzwZv3rZ9bxcM1FN+7
         Hcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eYTZThtnBEBRsjkEMZ8Jc1BneVEDWprUm5MZX/gFhJo=;
        fh=qeKOcXAmoISVl5u+/PjAgE0j6yE43VUkXIVZTW2RZZs=;
        b=Wpbd2uAdWc5MRo9rQ6xSPI6+YXnrcziXnXKMqOT5jvCP9ZsqIf87/+rZ+ALz3iTWBy
         Odw6j1okl52x8KjdVTBdWDOwiWrvaw+GPASvP/TDCojZ+zV9Nt/vzZzYXXiKdBNgRfb6
         0fPV+J2LNELiCnPdOmJeGU6Dp/h8XAB0Zn7Dxt6fR7UDJkT529ZhuwIiW+Gj/u3m7jG+
         1iU78wNncaxLKJo46C5BRZBCpXApnL3jIM8kiJ88beGwU2IPUZKtYKxVAOoxlc1ju+gz
         mOVTJqA/h+wl0uhkH7TVNiyqEwToktbfNO0W+VnJ2Pq8Y2DBOvEDxeM1p2MVnUzhZnQj
         /Vng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769251529; x=1769856329; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYTZThtnBEBRsjkEMZ8Jc1BneVEDWprUm5MZX/gFhJo=;
        b=nWrdm395wUmY0BCaISWaPOutLg163MXaaFaptr3TTl4rfWl7AxdcgS6OuDLbYYEpaz
         wME6dE/pV4njENzX/dnctf1XEEQ37vKc7YP2fi/sWsKFP+qDie/YBSevOnzomRoJtiYo
         KMqzTpsJ+MwgRfGOu231yJ8/8kW47AMeWL50DlUX42blTBQKPcLC4C0MmTkdbDquDbra
         aGjiNQRHD9Am8aaaPhEa0sTUxxFWuByY0Y9yX5e9Avzpr8Y2dA3dbTopa12UxBbIXfwl
         mnW4sFPT0BasxFjWJrHNA5XOdlSRWKTj9C+w4Ku3fYVpEGO2k7fWwPo1tQsGP0cKx0hy
         T/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769251529; x=1769856329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eYTZThtnBEBRsjkEMZ8Jc1BneVEDWprUm5MZX/gFhJo=;
        b=hysu+4On4Ocx0ZctUUIwYmk6C1O2RikATBxuV2AsjnQZuRJxNml9FSkZNVrxWEnaka
         +eePTU9xBBOJLfULC8Y50zz7PmUlrs38vqNOsIhOzDrCSevx041bo29Ji5lJ1MpFJj1M
         RGiZH31af3GMGGZejNFDpHC1RrkKKTzhYCJx60BGRvgPrlgxF5spqLARnWuKxH4D3xl/
         n4ErGnZ0KmcVTLVNMkmfzK7/hgtfN4xuJtpQ4ZU969+bAHnvjWH+SDBHFjR+TCDYlbgN
         m7LA46sn/oqw57bbnPJM5j+WyUYvxh5hycRAHV3G31yFxb0YaKw0JzmCWHKh66edZAHn
         zOWg==
X-Forwarded-Encrypted: i=1; AJvYcCVTbuRhES2R2gEvC3/QLyX4FdhJ5PRs1w1n4VWJPfaNTohEJ7Lzcdn6A5kRFtfukKF/uVXJQGpNzZg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGf5JoFRDZ3OyWZ0n3v4D/qyeGONy1Iv6xQ4iPls+TB6qH6R4N
	H74iqB3CNL2qC97p/mcag18tcUaoGKcNWLdhVbgbu3Cl9wcGCH9tPzToZSCjjqUOdnB3ZbyO3oD
	NaNdUJlgiceZIhONqs2qbdy4IaE68Je0=
X-Gm-Gg: AZuq6aI/tkkLe0T7h3jixpcGtoa5WjAX2jvlKVNV8621ZI+/QnBFKuQFkK30PBl4v3q
	ZfOXwDBmV2gu6NoZ2q0yUCudzjS1pfP3mRuYhHU4x1PhmE2y+kW5CZ2WpxTJ6vCynLKbwUP5D46
	OnK9K3Ps3OM8A7pNmsgHhkZKcO3zdoX0VcXCbssykpZi6OoGktrenWPaQe6sdRjFFLe5mb8KYOC
	Z8H+0ajhPIvfryjPsXUQNWUe6oLQW+C9oN0pBJBmIRqjsB4FHs/WQaeMbCpBTLNuUiVkXQ5A6wC
	nfEsfMCp/K/x+eWLusGCiAFMuHQu0O7ULPRr7EY=
X-Received: by 2002:a17:907:1c0a:b0:b87:173f:630 with SMTP id
 a640c23a62f3a-b885ae61dc2mr478554866b.40.1769251528580; Sat, 24 Jan 2026
 02:45:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114-tonyk-get_disk_uuid-v1-0-e6a319e25d57@igalia.com>
 <20260114-tonyk-get_disk_uuid-v1-3-e6a319e25d57@igalia.com>
 <20260114062608.GB10805@lst.de> <5334ebc6-ceee-4262-b477-6b161c5ca704@igalia.com>
 <20260115062944.GA9590@lst.de> <633bb5f3-4582-416c-b8b9-fd1f3b3452ab@suse.com>
 <20260115072311.GA10352@lst.de> <22b16e24-d10e-43f6-bc2b-eeaa94310e3a@igalia.com>
 <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com>
 <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com> <CAOQ4uxi988PutUi=Owm5zf6NaCm90PUCJLu7dw8firH8305w-A@mail.gmail.com>
 <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com> <CAOQ4uxgCM=q29Vs+35y-2K9k7GP2A2NfPkuqCrUiMUHW+KhbWw@mail.gmail.com>
 <75a9247a-12f4-4066-9712-c70ab41c274f@igalia.com> <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
 <CAOQ4uxg6dKr4XB3yAkfGd_ehZkBMcoNHiF5CeB9=3aca44yHRg@mail.gmail.com>
 <ee38734b-c4c3-4b96-8ff2-b4ce5730b57c@igalia.com> <8ab387b1-c4aa-40a5-946f-f4510d8afd02@igalia.com>
In-Reply-To: <8ab387b1-c4aa-40a5-946f-f4510d8afd02@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 24 Jan 2026 11:45:17 +0100
X-Gm-Features: AZwV_QilNv7skh3Dbv-Uyf4qbklEv15lpqvlCHXP7YddmY5hXQul6pw3DTKCtH8
Message-ID: <CAOQ4uxiRpwuyfj_Wy3Zj+HAi+jgQOq8nPQK8wmn6Hgsz-9i1fw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use real disk UUID for origin file handles
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Carlos Maiolino <cem@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kernel-dev@igalia.com, vivek@collabora.com, 
	Ludovico de Nittis <ludovico.denittis@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2026 at 9:08=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Em 23/01/2026 10:24, Andr=C3=A9 Almeida escreveu:
> >
> > Em 22/01/2026 17:07, Amir Goldstein escreveu:
> >> On Tue, Jan 20, 2026 at 4:12=E2=80=AFPM Amir Goldstein <amir73il@gmail=
.com>
> >> wrote:
> >>>
> >>> On Mon, Jan 19, 2026 at 5:56=E2=80=AFPM Andr=C3=A9 Almeida
> >>> <andrealmeid@igalia.com> wrote:
> >>>>
> >> ...
> >>>> Actually they are not in the same fs, upper and lower are coming fro=
m
> >>>> different fs', so when trying to mount I get the fallback to
> >>>> `uuid=3Dnull`. A quick hack circumventing this check makes the mount
> >>>> work.
> >>>>
> >>>> If you think this is the best way to solve this issue (rather than
> >>>> following the VFS helper path for instance),
> >>>
> >>> That's up to you if you want to solve the "all lower layers on same f=
s"
> >>> or want to also allow lower layers on different fs.
> >>> The former could be solved by relaxing the ovl rules.
> >>>
> >>>> please let me know how can
> >>>> I safely lift this restriction, like maybe adding a new flag for thi=
s?
> >>>
> >>> I think the attached patch should work for you and should not
> >>> break anything.
> >>>
> >>> It's only sanity tested and will need to write tests to verify it.
> >>>
> >>
> >> Andre,
> >>
> >> I tested the patch and it looks good on my side.
> >> If you want me to queue this patch for 7.0,
> >> please let me know if it addresses your use case.
> >>
> >
> > Hi Amir,
> >
> > I'm still testing it to make sure it works my case, I will return to yo=
u
> > ASAP. Thanks for the help!
> >
>
> So, your patch wasn't initially working in my setup here, and after some
> debugging it turns out that on ovl_verify_fh() *fh would have a NULL
> UUID, but *ofh would have a valid UUID, so the compare would then fail.
>
> Adding this line at ovl_get_fh() fixed the issue for me and made the
> patch work as I was expecting:
>
> +       if (!ovl_origin_uuid(ofs))
> +               fh->fb.uuid =3D uuid_null;
> +
>          return fh;
>
> Please let me know if that makes sense to you.

It does not make sense to me.
I think you may be using the uuid=3Doff feature in the wrong way.
What you did was to change the stored UUID, but this NOT the
purpose of uuid=3Doff.

The purpose of uuid=3Doff is NOT to allow mounting an overlayfs
that was previously using a different lower UUID.
The purpose is to mount overlayfs the from the FIRST time with
uuid=3Doff so that ovl_verify_origin_fh() gets null uuid from the
first call that sets the ORIGIN xattr.

IOW, if user want to be able to change underlying later UUID
user needs to declare from the first overlayfs mount that this
is expected to happen, otherwise, overlayfs will assume that
an unintentional wrong configuration was used.

I updated the documentation to try to explain this better:

Is my understanding of the problems you had correct?
Is my solution understood and applicable to your use case?

Thanks,
Amir.

diff --git a/Documentation/filesystems/overlayfs.rst
b/Documentation/filesystems/overlayfs.rst
index ab989807a2cb6..af5a69f87da42 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -753,9 +753,9 @@ Note: the mount options index=3Doff,nfs_export=3Don
are conflicting for a
 read-write mount and will result in an error.

 Note: the mount option uuid=3Doff can be used to replace UUID of the under=
lying
-filesystem in file handles with null, and effectively disable UUID checks.=
 This
+filesystem in file handles with null, in order to relax the UUID checks. T=
his
 can be useful in case the underlying disk is copied and the UUID of this c=
opy
-is changed. This is only applicable if all lower/upper/work directories ar=
e on
+is changed. This is only applicable if all lower directories are on
 the same filesystem, otherwise it will fallback to normal behaviour.


@@ -769,7 +769,7 @@ controlled by the "uuid" mount option, which
supports these values:
     UUID of overlayfs is null. fsid is taken from upper most filesystem.
 - "off":
     UUID of overlayfs is null. fsid is taken from upper most filesystem.
-    UUID of underlying layers is ignored.
+    UUID of underlying layers is ignored and null used instead.
 - "on":
     UUID of overlayfs is generated and used to report a unique fsid.
     UUID is stored in xattr "trusted.overlay.uuid", making overlayfs fsid
