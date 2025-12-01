Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0089B2E54DE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764577391; cv=none; b=Xc2f23InxVeh40h5zPkCsf/jhjMd5TqWIfIKoBOvgu801QFtlLppW3wXxsC9tNB+p1IrYrpm7G4XFYR/H9kyydccUjrOqf9dswgsu1AHQWqrPDmFy+FBD5vkjmQrZDeeXIO2H79yE2orWietGdbcruL/q3UL43Am6kzRQS6dJBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764577391; c=relaxed/simple;
	bh=TrlI8KF/qCeVsAfOA6ACvSSTJoCfx71xxH3YdpjqFy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mw2nahuz2JP0R5Y/gWNkJfwPubCznSF4GqC2D9MXpwGOuTndL/Tnm9v8vP+23uUA3B0SY3In70jcnC0oMD9U97VSgsTB/jIV9ri6lzdcFAnUbXcVlAMS8gs315BVnLvxDyzCHME+2a0tn0Lsj95O0nwp8Sz9nnociFWm5EICfr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jYChTdbZ; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jYChTdbZ"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so6721234a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 00:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764577387; x=1765182187; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UDNGf4W59vxX6MyDgWfRD0V6LCN4sc0r1Qgyk2LJH4=;
        b=jYChTdbZ5OUD1+vaubSuu+HN5tydPki6kg8b6tc8pSohrpj81F4D9Uj+76RsdVV6TO
         cps70XcuOHZHLoQXHb+3DE5vQOdeGq2zQE5RzPvNbO0nBJbrmrOiZHjKK0Ft7k5FVzDt
         jG0aveXq+1ZG/2DkFXvzWOia9SnlN2wVRv560vjuprSo+e4B2ugFdxbJYgY5PA7ifnit
         sj0m0v9V+nsiySi8ujx0BxeOSGvVLhjJyYbZ5mDZT3iMbO+F7m+rnpz0yA1lnbBB3UrL
         eoPWZcYstP/FS0S6Y+++ywzAqYXjdGm5QrqK4Zmhupc77lTvXJpREzA6b8DCIvxPwww6
         GeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764577387; x=1765182187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+UDNGf4W59vxX6MyDgWfRD0V6LCN4sc0r1Qgyk2LJH4=;
        b=oiSbqISRZaYMxQFF9XG0IaHcwpmKPjXZ5jSJFxsgNtoBknmEnywMu/iVrR2A+iyMEW
         EdOkg6+UQaM5CUjSBmbQwT0lTPaB7gKiwNtRveQ0t7eQUkm/SBuHvmPK+Ws4L7n2P8RO
         bCToFoFYCht990VAs7uwAVS3Gh/dGIjilQMUgXn2tgeaOq1et2lvAGayYdJpKChhyb9o
         GNUgINRRMSChoay8hK2+k8uVkD4xpks4mCKeEnIQn7b5YFCb8fA3hAIGrFnjNDJSDqq7
         fTfGgBmi+liswNtJoLCjjpj/1jbFoRym5txHbARO3DfzzKm3lsXttXH4J2rrpXy+rdlJ
         FmeA==
X-Forwarded-Encrypted: i=1; AJvYcCU39ekhghyZlxnaR3YPyZ008n2jG85b/0LldhhomEOULQjLNU1tfjcPZqlmDPQTkk0cmKaaALnzFM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWy1Ke5/vCzk2L9rhbmcGGMiW//fR8gM6ZxI71NvLYJzCvxF+e
	fHdEaKEF1ErRK5tRCVDUlFbsqVno5mY0GH2Bl6+9svaHs8j0MGxUthFpqj3+mnI/ez9nazNoWKN
	jNJapS5NdRdlhyaiAkzVJOwQoYa0l62U=
X-Gm-Gg: ASbGncsLm/nXNYxoGY8+JRBDu/6+bzXaiEEY3UUcBOaUlPwQ8cGbUeWgv5kcKA0eBHH
	PzM1sNuFBmEcZYB9v4h/8AR5Y1mwaj8qIC9CxWRramlSbK+GEeiwoj0QumWx7CjKV3/z8NoZZHI
	QHuK+XgOG8WoVPSEb/CCSHuzQxiBegLc9um5Xlrql5ZoaI3N16NqJjWPl6RCQNd6wHVxs5BJ5pF
	NpAPfakZKr7xwutJwIdOwIkcid2FS23EBAFacbrmCzwaOtnQnCb9UjrViVefJUH2N7kJMH7B+17
	8NWOp24hGKb9p6t9nCEqARL14h3A
X-Google-Smtp-Source: AGHT+IHj59Fq162Q+xUifGgiokcU6h4xrAjviadpNqTh31A0WmXmIZVxJbhdYoPX7MCvx0GXwNcf5jp7tW359myAd7I=
X-Received: by 2002:a05:6402:4388:b0:645:cd33:7db5 with SMTP id
 4fb4d7f45d1cf-645cd337dd5mr21497896a12.24.1764577387055; Mon, 01 Dec 2025
 00:23:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113002050.676694-1-neilb@ownmail.net> <20251113002050.676694-7-neilb@ownmail.net>
 <6713ea38-b583-4c86-b74a-bea55652851d@packett.cool> <176454037897.634289.3566631742434963788@noble.neil.brown.name>
In-Reply-To: <176454037897.634289.3566631742434963788@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 1 Dec 2025 09:22:54 +0100
X-Gm-Features: AWmQ_bkmbCFj52T5piKawt5MYU4Qwo914sia_qtE6Q0yvLfrgb4Ycc6nfs_K2NQ
Message-ID: <CAOQ4uxjihcBxJzckbJis8hGcWO61QKhiqeGH+hDkTUkDhu23Ww@mail.gmail.com>
Subject: Re: [PATCH] fuse: fix conversion of fuse_reverse_inval_entry() to start_removing()
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Val Packett <val@packett.cool>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Jeff Layton <jlayton@kernel.org>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	David Howells <dhowells@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tyler Hicks <code@tyhicks.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Chuck Lever <chuck.lever@oracle.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Carlos Maiolino <cem@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Stefan Berger <stefanb@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, 
	netfs@lists.linux.dev, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 30, 2025 at 11:06=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
>
>
> From: NeilBrown <neil@brown.name>
>
> The recent conversion of fuse_reverse_inval_entry() to use
> start_removing() was wrong.
> As Val Packett points out the original code did not call ->lookup
> while the new code does.  This can lead to a deadlock.
>
> Rather than using full_name_hash() and d_lookup() as the old code
> did, we can use try_lookup_noperm() which combines these.  Then
> the result can be given to start_removing_dentry() to get the required
> locks for removal.  We then double check that the name hasn't
> changed.
>
> As 'dir' needs to be used several times now, we load the dput() until
> the end, and initialise to NULL so dput() is always safe.
>
> Reported-by: Val Packett <val@packett.cool>
> Closes: https://lore.kernel.org/all/6713ea38-b583-4c86-b74a-bea55652851d@=
packett.cool
> Fixes: c9ba789dad15 ("VFS: introduce start_creating_noperm() and start_re=
moving_noperm()")
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/fuse/dir.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index a0d5b302bcc2..8384fa96cf53 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1390,8 +1390,8 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, =
u64 parent_nodeid,
>  {
>         int err =3D -ENOTDIR;
>         struct inode *parent;
> -       struct dentry *dir;
> -       struct dentry *entry;
> +       struct dentry *dir =3D NULL;
> +       struct dentry *entry =3D NULL;
>
>         parent =3D fuse_ilookup(fc, parent_nodeid, NULL);
>         if (!parent)
> @@ -1404,11 +1404,19 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc=
, u64 parent_nodeid,
>         dir =3D d_find_alias(parent);
>         if (!dir)
>                 goto put_parent;
> -
> -       entry =3D start_removing_noperm(dir, name);
> -       dput(dir);
> -       if (IS_ERR(entry))
> -               goto put_parent;
> +       while (!entry) {
> +               struct dentry *child =3D try_lookup_noperm(name, dir);
> +               if (!child || IS_ERR(child))
> +                       goto put_parent;
> +               entry =3D start_removing_dentry(dir, child);
> +               dput(child);
> +               if (IS_ERR(entry))
> +                       goto put_parent;
> +               if (!d_same_name(entry, dir, name)) {
> +                       end_removing(entry);
> +                       entry =3D NULL;
> +               }
> +       }

Can you explain why it is so important to use
start_removing_dentry() around shrink_dcache_parent()?

Is there a problem with reverting the change in this function
instead of accomodating start_removing_dentry()?

I don't think there is a point in optimizing parallel dir operations
with FUSE server cache invalidation, but maybe I am missing
something.

Thanks,
Amir.
