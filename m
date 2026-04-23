Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E64234C9A3
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 21:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776978190; cv=pass; b=WrdKpxBJIZALHGBMobETbL83IcmZYJZ6vaVTw5+j4nqmxLH3Wzg+RBFiR23AcvgQ5C51D8Xqtu+SAoLrLovUFygGeQKXndV3A+lULfHlwflX8gKR3Mbx9+tjG1WovWx72VHu1doDPTkoe+e5Dx4FKm2qB/bN0dnlhxz/+JbYWws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776978190; c=relaxed/simple;
	bh=xhEH603J8v85yHWTGq8ZnN7Uus4HM3riSO2QoNgy+fs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CoDCLAnOuvZ+VfsGq6MMrpuF4vBYp0fzwV4njV/seMf/ypdj07ZHHJuN3++GevtbtcVTWvZujh9diOb7goScUTRgcCkoynFy4nAByiNrHMctL2a2dM9BXP5UFXjnZ+m1+j4JGR3bEaPdghICUC6LGPewUj2q2e9mS+qoWQHxq8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rDvAu1SN; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDvAu1SN"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso80923726d6.3
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 14:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776978188; cv=none;
        d=google.com; s=arc-20240605;
        b=BUAdC7m+MNbJtfzjONp12RVv2ICARFjHhHKZxqCAHPGuCwjTJTIwQE7csusqoSDlfL
         +kX7NUMNL1Td8G0vId7mPqLJouGMbBFSpYvVhs1r17Lret7PES8fxC4qLsH06zky5jW/
         Sw81r7XMFQ9Zjv54fHegynhbZ9Mv9XVRpUMlaUtmgDhhG7Fi4JKRoatpwYmH75dustJq
         RPnm9fV5GtKa8LoqG2c/oWjkdw2TcVHjxZzDwM4NKQmVOVPWSDU7UMFSsZqpj/3KhscZ
         Uvx6REnhWHP0KQoOIH0v7kRyMCHzBZFepw0MauxvIGN9wEYM5qU6UGU1tokNQ3vd2L+D
         Pj5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PB9D2kfgkJFOe3p8pXvyrrOYHUrSUtT15eUJWPkJgQk=;
        fh=/3rQNiscFXRG7/4RfigFSM9/ZXgv9S6prFpYxxkNIsw=;
        b=WmHOKUz0bR3HHkiK5SLFT4vH5MtgPfW4mobF1GNp/KFeBOVbBB/nqRUG0wMf1ft0Tq
         ieAHWpp/AxmF0p1S55/PlcEYSJVWK9K+HKxzeka5Mxukp6YKvAz+96hI75lssGuq0Vh7
         ALSjH4ZYjXYBMUba2NtG20s4QY43RiPliFypzCtiGugw7FP34f8ALd0NYuMKRjVn5g7M
         IUMuNc1kS3PnCwZvhzg7fT2z/S5nbU0BEpjlSYUWK7WmNDE6yhFIfDea6aRyuxvZhB89
         6WgRzGQWOLuv7dXGXA2Zf6uBHrJg214FHBB1RJV6Oz9xythpO4hnnHltA0vFyOGNaPuQ
         0wvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776978188; x=1777582988; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PB9D2kfgkJFOe3p8pXvyrrOYHUrSUtT15eUJWPkJgQk=;
        b=rDvAu1SNNCNFOtPGGZA1Ilm0Le5RC3HqJ0wXokdqmzOLVNi8lHw7GMMZu9w9TKLwL2
         97WG5/8zvZHB8yvJKvWest8upLdKisDZ7H05Ka5/vdYNhsrnM3D9ri/hCBGJJWSYMJ6A
         4aV5pN8ZpW+OvUAVyQXtCxyz+lKlPQ3JSP3K8P+ESur67eGHrRIzYUzsXwVHkCd6yj2/
         ctzXdJjsBXDJTbKbibVy0FNHQzCBCqmL0wFBtBXUGYA9rjTxlgcuc+yyfB6WixhGhej1
         k1hqtskE52BY3YNgHMeEYZ4kRq1QB4GqeTj/Zh+a80rccrsXdmSCnU6wEvXr81Y4Mp/o
         /xVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776978188; x=1777582988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PB9D2kfgkJFOe3p8pXvyrrOYHUrSUtT15eUJWPkJgQk=;
        b=DHvK/8y3PrKmVZFvKf1dFPiCV1+px8QenmF1sc846xNBf05ix9w7VKerYLxOr+OeSL
         gpK+DFo5ay2XePjTR8JkUmTAEo/v43jeO3zCmLK4EkGvt3m2ThXhY8Ebwjv5FfSb2FK5
         FuE1NUR0ka/pCJ7C5DbhRdKim1h8Ln0SFGtLZpRCO67NJvLOkhq+phZPwEnAhTOzCeFs
         ujX7hL1lTDOEP3Lhy+U1y6j1dylMXFxWLAdllbjoChm6dJ1zdyZLNy0HriJdtk4Kk7ch
         fR2s1S7dm5BDfCWO7pZr43wKLej102MuMlYnbbBhY18lM7SDqv7Rn6h19IPVjHW+HR9F
         rc2Q==
X-Forwarded-Encrypted: i=1; AFNElJ8HO7I3up+n3CHubd8TRMU4Nh56gZSHMSc31dkUPU8NniKhz5RekFzENPPi3YFkKike6pYW38kx0Tk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIoW1EAIKoIq3epnsVgNSs79I0Jqtib6VDrNHdY8nZya3jN4qw
	ZA9c38Sidr2Erdv4NFY98F7eTlIE/gNsbq4rOoGzjr+T69fV8AJLDNR23ia+4zHPTYPW8rcTAKz
	fSc/eKzX+PZQFLUGkizeDD7oMCJuWlatNB1m6
X-Gm-Gg: AeBDieuZqPEpMEydb8ZvN8rprGlPZnf0yjz5C7kQQNS6L6q6QlEsECHwp//W24s78gX
	drZ+BKZpQa2RUAUFA+eVqV4JH5aZJFvnZP01lybLv+bfFBcUlI9DolTrXbctCVQc4qA7Fwpu6Kb
	OMvOHSjMT71h+r4Z9VbZ9TR5UpftULDRaQpk7T9YtAZTeLOnsomiac3tFA8B3NoeOSJm+IoNf46
	Qyqnv6zdtH/O8ckcX3sj2jpvyHqDowVXGH26AbVY6vCeswa9n6JwzEixd/VismRKD2MuRhRTsme
	0vdto56KxyTW+r+j0ZV6lQF8/LvM7AxWkW/aj/k0wlOWsD64rmnX1xvTgt4dJG0GpdWKaadmPjh
	EMzM1VH+3kGJSOVDfyfVD51pzum6ib7yKGci8Vh1FfkVTD9jklkYlHub0tlSlLa/T2UwgC+aaS3
	aWdvgF9VIOcs/w5+sZXsy6uxOktrsZMjc=
X-Received: by 2002:ad4:5d65:0:b0:8ae:6282:df2e with SMTP id
 6a1803df08f44-8b02822456emr461252066d6.44.1776978187970; Thu, 23 Apr 2026
 14:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260423-case-sensitivity-v10-0-c385d674a6cf@oracle.com> <20260423-case-sensitivity-v10-10-c385d674a6cf@oracle.com>
In-Reply-To: <20260423-case-sensitivity-v10-10-c385d674a6cf@oracle.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Apr 2026 16:02:56 -0500
X-Gm-Features: AQROBzDF43-id-Qgk6rRbL0HPyUPTg1w8GYo4-J0uBb2d6IfD5ElWAtE-TtbFxA
Message-ID: <CAH2r5mu1Wg_9tZCjei-xF357UjKR+h6jQr9zey39v59rx9quZQ@mail.gmail.com>
Subject: Re: [PATCH v10 10/17] cifs: Implement fileattr_get for case sensitivity
To: Chuck Lever <cel@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, trondmy@kernel.org, 
	anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, hansg@kernel.org, 
	senozhatsky@chromium.org, Chuck Lever <chuck.lever@oracle.com>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Should this also be checking if the SMB3.1.1 Linux Extensions or SMB
POSIX Extensions are negotiated (ie the server supports case
sensitivity)?

On Thu, Apr 23, 2026 at 8:20=E2=80=AFAM Chuck Lever <cel@kernel.org> wrote:
>
> From: Chuck Lever <chuck.lever@oracle.com>
>
> Upper layers such as NFSD need a way to query whether a filesystem
> handles filenames in a case-sensitive manner. Report CIFS/SMB case
> handling behavior via the FS_XFLAG_CASEFOLD flag.
>
> CIFS servers (typically Windows or Samba) are usually case-insensitive
> but case-preserving, meaning they ignore case during lookups but store
> filenames exactly as provided.
>
> The implementation reports case sensitivity based on the nocase mount
> option, which reflects whether the client expects the server to perform
> case-insensitive comparisons. When nocase is set, the mount is reported
> as case-insensitive.
>
> The callback is registered in all three inode_operations structures
> (directory, file, and symlink) to ensure consistent reporting across
> all inode types.
>
> Acked-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/smb/client/cifsfs.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 2025739f070a..9b70ffa3e01d 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -30,6 +30,7 @@
>  #include <linux/xattr.h>
>  #include <linux/mm.h>
>  #include <linux/key-type.h>
> +#include <linux/fileattr.h>
>  #include <uapi/linux/magic.h>
>  #include <net/ipv6.h>
>  #include "cifsfs.h"
> @@ -1199,6 +1200,22 @@ struct file_system_type smb3_fs_type =3D {
>  MODULE_ALIAS_FS("smb3");
>  MODULE_ALIAS("smb3");
>
> +static int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *f=
a)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +
> +       /*
> +        * The nocase mount option installs case-insensitive dentry
> +        * operations on this superblock. SMB preserves case on the
> +        * wire and at rest, so the mount matches FS_XFLAG_CASEFOLD
> +        * semantics: case-folded lookup, verbatim storage.
> +        */
> +       if (tcon->nocase)
> +               fa->fsx_xflags |=3D FS_XFLAG_CASEFOLD;
> +       return 0;
> +}
> +
>  const struct inode_operations cifs_dir_inode_ops =3D {
>         .create =3D cifs_create,
>         .atomic_open =3D cifs_atomic_open,
> @@ -1217,6 +1234,7 @@ const struct inode_operations cifs_dir_inode_ops =
=3D {
>         .listxattr =3D cifs_listxattr,
>         .get_acl =3D cifs_get_acl,
>         .set_acl =3D cifs_set_acl,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  const struct inode_operations cifs_file_inode_ops =3D {
> @@ -1227,6 +1245,7 @@ const struct inode_operations cifs_file_inode_ops =
=3D {
>         .fiemap =3D cifs_fiemap,
>         .get_acl =3D cifs_get_acl,
>         .set_acl =3D cifs_set_acl,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
> @@ -1261,6 +1280,7 @@ const struct inode_operations cifs_symlink_inode_op=
s =3D {
>         .setattr =3D cifs_setattr,
>         .permission =3D cifs_permission,
>         .listxattr =3D cifs_listxattr,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  /*
>
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
