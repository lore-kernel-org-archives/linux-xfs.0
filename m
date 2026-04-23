Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18B222ACEB
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776906000; cv=pass; b=fpphnxDxtsxBUnuyg3i2q+AxalzJ7sO3HWN+oaLLt373WQRLVCBgrJ2mfUxoGqbbiEY4VoIo5TAIYOSEQXiDhv3RcS5JvUTPf0sAX+UcYfTbajfIzIxxd+6i6s0MWEBZ8pXDA1MCLUFZVX20u4dlzQXtNEM0to5mGlRlczd/ZCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776906000; c=relaxed/simple;
	bh=glEATcMQjgXcIVNGcFv/jGZwSA4FOZck5uTqZXkwZrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWfpuHiVVVN1g3FeXNCYKpIvEYNn9GutN8KL2qQGlS659hHP0+jnr3+4t5h3Q74QUJ2CcBJ2yi7aAiqLBKmwIvC0v+aMYHZ5AkAgfFzPvoI0+rg87cFecx/6Pm5vGhKWPtvC9fx9ZbmPjf9s1f6cLxCS06N+wB6fz4W1q5EwTuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMRiJS2/; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMRiJS2/"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8ee7ffd738dso243490985a.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 17:59:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776905998; cv=none;
        d=google.com; s=arc-20240605;
        b=GpOpF4xKu5xg8cX34RI2FabqXSPvKZEa5klPT0oHDmlgOYu6QxpTo9B+GGAWVXylXc
         9tWlhNhRfxPsinSIBHtS08iLGYvm6H7I9Rzj91mCR1gU0txosgbbt5NGtfwsfbfZUQZl
         POECU1L/JwhSKjse/p9T3vGf4RfVj4yE4x42QQoQxYo5ke7EknNB7JQ600Du/XbyON/b
         0FtoqD22yxWrt9kzCUybAx8ssEyBKSm1HAym3ZJktSjR0wiOxrL61x1MVtNWmmI30gvP
         A2EJL9aUv+FVLBL8MPWgbPXCwr7MtVtozJ1UqB/lh9+9FAbjSaFfH4oIwMKZbS5sfwQL
         5rYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        fh=he+StvcOrB8Mcpz4xevVID9t/Kk7aACi7BJ/YYe1AGw=;
        b=VH7EP7xz0Rv5bQaqKAxmpi1+1Zf1onWmt9YAtb0Vg2EmRANbcmZOSKv429HyZF/jci
         BNjmAHisMLbb/1tUpEteGCej7dbKqfojU4aG9IQNDHSQPoQEyFiKx4KDKl9TVjyutKvE
         MXZicApUHWukBL5Dli5BWEJI/ZSb8Vz2dmwMPLhzPM2N+isqh9rRsgleVax4S10D1F4a
         34CK9YfFan/Kdb7+4IQjRwCV9ZZtjFkIvLCLK3zGpzW8ei0puAWH8yDSrV4gZFzlf+7i
         1wnUa76ofhQxVeH1S7ZwoAdMiEsGgnDQz48P/dSQH4ojlVeoSR4MRxfxGrybJVsUqCAB
         Dlpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776905997; x=1777510797; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        b=YMRiJS2/7iPeV6CGivmFNZlhKtWjZPgsedWvhWP74UAv3lHrFmEFD0Aur6BIskzh0g
         QWBYcqG55fzdQVfvpnQ9RV5vQsjz0rWZL56X2ebc3clKJU48exG+EENE6kbVBxOFpPk+
         5t2gNgAxnqyaIvLY5ck4yRXX+nydQgvVrTEgBY8JAQXSqA8G3K6ongzaSlOAcv5LE5uM
         Yo7Lct+7ITiCGlvIXN81wLh8Pdlp3XWrN5vkapIFlpVoCanONo4VVCoHnyFslJtMBaWb
         mcFu62lehj3ZRz/Tw8nwq2iDe7aP0WaWjUg+TjiMd5pr/GNJgLYryCDxWm3FILghrLh2
         OYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776905997; x=1777510797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        b=KRuc3aPFFpezEib32tuy/81QviWgBl3MXSTuIfOIw0wKhPpa1Ri/9Iv8tpTnUNl4ER
         4S9pGT5s8v7ctHqbZbSLzLbyYwOQ4OwU+xQCUEwger8PZTlMcl2OcWWDgOXkJGr/xdPe
         zIqbMk2+NX9Mlze9mXh2vAD25dckM44Fzxrxqv72i1Q1KpW6vcdG/zRWGPNjJQwSaB/O
         cSV9A/mnet9T7yA0Dal17RA32lI+so1RQGHbZvvn9pTZkR5RlZqBm/zN7DeEQTh7IGg/
         l0fKi0UmZVntTkqP7zL3HhP0mS5EAxi2UvyjXBXZoq1x28rNhy1qjXEdDUH6wo97FtEB
         9fnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+e34mmlI1l7g9jn+EezL8RSdl7ImFB48AOOLBo/zJnGCDsrCYKYQhWeXOS34M1skFVdL0Q4TjPPnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwS4upRE5ly4usb9cMk/oSzHhO6JmGDgiLNi2nGjJcb7g9SSRCd
	gdFltV2D+tfGR475/1wTEzm06FN3n+94AMZwV97h1Z8KVFrG//5LVhCSQlsfGRGzpuDJsBos3vf
	TwAowvW7baoLVjib38YChjAVkTakh/JQ=
X-Gm-Gg: AeBDievLf8JiMcmK0UO4+5BeHv3c+r/JquuuzwJH3l4WHPZkCnnf29b/tRH0V1/OHXp
	4/mJcuG6OFIt1zHcrZBOGgxzXvizi0BJT4fAwYuYd576l59P2jOJQOJaP9NvU4EO34RwG9OcO/K
	aicMPg2V8tKjndA4SHZLVmKUqFrn+m0mlucxg5y0ujYvCZ6Dso92vXQYLhypQnTlxbWjUhF7hLj
	27DDFvop3OkwfHBOXXR/2yEydKAfnmME1LpwVmBj3vVH1ePIlM5iRd3KH7XtviVVIp+UD17iHs2
	96upML2gdByb1kD7xapEO8XLedfQgyPg11csyJFUiFy/gxMxmZJO35MBV1Nt/8fmEbVF3Y5tPRL
	x0qy+SKoONYL3GapVdSMIG9P9Q9puNa3cvmL0TEJXBVBqlKD2Q3fnVZL+cgHPDY6YMmBHljDW+Q
	uR1xtWfNB922LYg7KUz71PI8gS/F3Rlu05yk5mpgYk5MM=
X-Received: by 2002:a05:6214:490a:b0:8ac:b3ba:eb0c with SMTP id
 6a1803df08f44-8b0282f35c0mr336785626d6.2.1776905997499; Wed, 22 Apr 2026
 17:59:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422-case-sensitivity-v9-0-be023cc070e2@oracle.com> <20260422-case-sensitivity-v9-10-be023cc070e2@oracle.com>
In-Reply-To: <20260422-case-sensitivity-v9-10-be023cc070e2@oracle.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 22 Apr 2026 19:59:43 -0500
X-Gm-Features: AQROBzCtyORnfuVHnIm1n6WO0qai8y2HQyRw138-ozkefgToPmyDNAGdDckhKog
Message-ID: <CAH2r5muvUVY8FD6ZM+ARecM8evjejB15n0Ea9Z=GGn=i5aKFNA@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] cifs: Implement fileattr_get for case sensitivity
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
	senozhatsky@chromium.org, Chuck Lever <chuck.lever@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Acked-by: Steve French <stfrench@microsoft.com>

Do you know which xfstests this would enable?  IIRC a few of them
depend on the fs supporting fileattr_get

On Wed, Apr 22, 2026 at 6:34=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
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
