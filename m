Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE6E1F471F
	for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 13:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773582703; cv=pass; b=GZfte6GB0T/M84MHPNvdhQUGpw+eiAovvrDH49IaqPRp57WJsDX8m18JPgZU2SVA7iu2dcz4KJU7hhLQhDZxNnGpDmohzfNGLNUDypSJuh/rE1mokpg+JLoC/ZjZ/lng0GhcIBWEqW1OEqgmPqZTakk/T7eRqUhJjB5YCzE7Wbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773582703; c=relaxed/simple;
	bh=Vs01mlsWygXmaXPS3h5z1k3Hf3KZR9yElATURfIfNww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bDaaqF19suhNrprom3Q5zmFWI/n8dTWxjqIzX2rv/fwx0b7+xAAsWBhmdYYTBOrmsbCW1X5EprkHag33QSz7hlHMh3zdLBzuJMeEc5ePyIGAgjyN2MXMbwalByvJNiQHhM8kZewo5keqM0tPxLx2O0LHogCEouPa6XoOMXkZ+KI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=niOi+68t; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="niOi+68t"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b97bca3797dso6688866b.0
        for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 06:51:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773582700; cv=none;
        d=google.com; s=arc-20240605;
        b=kHpJRmWvKvZ9LsS0EIorQnxLkAK4LJNLLUN/7Aar9OYiGmCRZ12nmN00vPoXqL2ikX
         IS4NrlDNCAXthlHqgtr6j0FlrG9s7U1e2RKEqS2SfCFIjIDOIQkS2GOVQ9Y1P9vco4ft
         0VUqC6oYv5M6qKspUFl/TP3wPytabQna30al42zA1rVQYCBiBA2pCMmavI+k8M4DBeqT
         /n5iKM3URjheUs37QPD8qvTLdzeoz8uv38FZPFZTZDd1DXNC8yOzO+CjlDHvfcydImC4
         iRLHe7rbz2Z456ZVdHjG8bd6V3N7O+PdjNPqCihNF7fOmAMH1Ya0shxskMy0wIp0wAkn
         tw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LD1Y/Z+QIVaxjTqqF6DEde0TPCIZAs/xYcpmNl5+JUA=;
        fh=OSk/41znJlpFMgx81FJvokA1obKP5s4GyP6M388dUWs=;
        b=lyqdqD1GbC3W/TlvK/JiQqHuvwIHa087Sf+8QgjiKSKnovZC7VXWvr0pX07khNpIrl
         HuX638IH9zBlzwpBRxirubDDS7aMjnrg3FN9QuX/70PSbie4Ly73h0nHcsuw5Yyj+yGA
         Jg2TlonpL9EcZoRO0lelXZhMbaN241d88bsnC/IH6BIgbby1usZQgkPbp9SfBMAOvsX4
         aCm9y+pirSShQnmlLKqpLaxS/PCls6KhpRNhu4jCl+fSDB/YYJAfIjODuNnZqH7QnCDl
         8iDrfrUW4y3wFgNz/ixKeWJFRETBvuqG5BnxH1nj7upuCqxQgZN8guN37EXxHn+SJXYv
         FrNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773582700; x=1774187500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LD1Y/Z+QIVaxjTqqF6DEde0TPCIZAs/xYcpmNl5+JUA=;
        b=niOi+68t+4ftQYvaTzVsRIkap5gRXpAugLlwQHpWZCH0WvCYllQe1U7gpK6TQ746LN
         sNb6+5qFVJvATOEcP8S1YSgpJuP99izxvfE9uv+ymv5s8v7mpmYBgjxzgmmrMIO20ol5
         XRphCrEl9BexTpEgwv+wQSN4mImqSAHd9JsJo3w0NsYQAB6tOh/4qcvYp8Jff3IdmD2I
         4tSEzLy6dzy72soZcqjVHMHgUtghx14Tou/mIE3WQ2HWt4arTCyksDfNfZAyf2iOSfXz
         lwavfOdGwvHNzVdTXiKTbMW4WZkF9yE9MfkZ1gT2J9g25fenbgVIVPyGiFfk/1mzFyNE
         UBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773582700; x=1774187500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LD1Y/Z+QIVaxjTqqF6DEde0TPCIZAs/xYcpmNl5+JUA=;
        b=qpjrfxlZL+NYCrJmm6wVg+NYG+/4r6yrjfim1DmJLQ3jFbRe6pSBM3JOD9W9r+vpw4
         hFbTkh0X64/iY3BhOi/qafPW8Dc3If/WRHo14tMvBzHP4jidF+pMvym1oFrluJTHxR+/
         pkdTjlhNPbrK5hPdyTBT6iJx37fGnhckAt+eTtygY2EgSwifSUrD+kTiBaDtPEYa8f9+
         RHyl4sBFNuLjs9fAPR3HK9j8AETyQsVDz451270QqTy0f6p7ipDge7a1Erqm7LY7piim
         s8RKgt/vXIqsIHqQVwxkLWag7XRVbybBghyVYmMRNeAUsUTaqlqawUdLD5HqQPyOrY0e
         XO0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHfuQwphrtkSY1xCJ7J3GtT+JyHPFWr/AMy78KxVVGDFcnssuefPXPYFb4UNI1O1O7ofSENKHpwW8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu0FXeaR4/GnXJMh1IqKV5Vp7zQ6+Y2jORgDQFZ4BBBaHEX4ov
	2OHbt4Ax3SdYAe6+NFk1n1TSpY/atKSyr1WL2BAS5tHv6OzYaKyF7ucoOpP7EI6oEd2cDR4oxoK
	LDdLSibXmRkrlVIM08P08JsZQ/vIKQQM=
X-Gm-Gg: ATEYQzyJXSCpo40zCvn+mY2b0SHU6PDb4cOKZ1GqM5u7X9/XtebgpoG0DADRUqlnzM2
	s571P78s5shgketMmdCl1Jau2yFKMUARcZxwGhCqmNg6SsyE+I+Efv+qQUiFHwDwKaxi8U3MHcv
	bgwVsViMZSh443t3jf7LIPuH+xA5YZn/V+t7LBnpsN8/NoO1XwMRf10iaL5KtHlMwJobJ/IfJPX
	j2irATrjsYLBgkQzr4M4I6eNWLFgxNFkca61ySkQU+nEbH6QJxhq2p1HgnmPF0oXxbZjh5QRPCj
	kbVDxCfjVlzdWc0qETd+R4HTP9AQUA2hJWdRP5X3Kg==
X-Received: by 2002:a17:907:8dcd:b0:b93:c5a9:a5e6 with SMTP id
 a640c23a62f3a-b976507af92mr500109966b.2.1773582699724; Sun, 15 Mar 2026
 06:51:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net> <20260312214330.3885211-17-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-17-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Mar 2026 14:51:27 +0100
X-Gm-Features: AaiRm50yYPhN2uA9nBAPVNuAVUOhGIEBVS5rPtx5ZlpdDP1j4SB9NhEOC_7KNWo
Message-ID: <CAOQ4uxjmcNxsCmDSVgkTns=3BAuQcT3pVvsQzza+u3iqXqrz5g@mail.gmail.com>
Subject: Re: [PATCH 16/53] ovl: drop dir lock for lookups in impure readdir
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 10:49=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> From: NeilBrown <neil@brown.name>
>
> When performing an "impure" readdir, ovl needs to perform a lookup on som=
e
> of the names that it found.
> With proposed locking changes it will not be possible to perform this
> lookup (in particular, not safe to wait for d_alloc_parallel()) while
> holding a lock on the directory.
>
> ovl doesn't really need the lock at this point.

Not exactly. see below.

> It has already iterated
> the directory and has cached a list of the contents.  It now needs to
> gather extra information about some contents.  It can do this without
> the lock.
>
> After gathering that info it needs to retake the lock for API
> correctness.  After doing this it must check IS_DEADDIR() again to
> ensure readdir always returns -ENOENT on a removed directory.
>
> Note that while ->iterate_shared is called with a shared lock, ovl uses
> WRAP_DIR_ITER() so an exclusive lock is held and so we drop and retake
> that exclusive lock.
>
> As the directory is no longer locked in ovl_cache_update() we need
> dget_parent() to get a reference to the parent.
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/overlayfs/readdir.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1dcc75b3a90f..d5123b37921c 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -568,13 +568,12 @@ static int ovl_cache_update(const struct path *path=
, struct ovl_cache_entry *p,
>                         goto get;
>                 }
>                 if (p->len =3D=3D 2) {
> -                       /* we shall not be moved */
> -                       this =3D dget(dir->d_parent);
> +                       this =3D dget_parent(dir);
>                         goto get;
>                 }
>         }
>         /* This checks also for xwhiteouts */
> -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> +       this =3D lookup_one_unlocked(mnt_idmap(path->mnt), &QSTR_LEN(p->n=
ame, p->len), dir);

ovl_cache_update() is also called from ovl_iterate_merged() where inode
is locked.

>         if (IS_ERR_OR_NULL(this) || !this->d_inode) {
>                 /* Mark a stale entry */
>                 p->is_whiteout =3D true;
> @@ -666,11 +665,12 @@ static int ovl_dir_read_impure(const struct path *p=
ath,  struct list_head *list,
>         if (err)
>                 return err;
>
> +       inode_unlock(path->dentry->d_inode);
>         list_for_each_entry_safe(p, n, list, l_node) {
>                 if (!name_is_dot_dotdot(p->name, p->len)) {
>                         err =3D ovl_cache_update(path, p, true);
>                         if (err)
> -                               return err;
> +                               break;
>                 }
>                 if (p->ino =3D=3D p->real_ino) {
>                         list_del(&p->l_node);
> @@ -680,14 +680,19 @@ static int ovl_dir_read_impure(const struct path *p=
ath,  struct list_head *list,
>                         struct rb_node *parent =3D NULL;
>
>                         if (WARN_ON(ovl_cache_entry_find_link(p->name, p-=
>len,
> -                                                             &newp, &par=
ent)))
> -                               return -EIO;
> +                                                             &newp, &par=
ent))) {
> +                               err =3D -EIO;
> +                               break;
> +                       }
>
>                         rb_link_node(&p->node, parent, newp);
>                         rb_insert_color(&p->node, root);
>                 }
>         }
> -       return 0;
> +       inode_lock(path->dentry->d_inode);
> +       if (IS_DEADDIR(path->dentry->d_inode))
> +               err =3D -ENOENT;
> +       return err;
>  }
>
>  static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *pat=
h)
> --

You missed the fact that overlayfs uses the dir inode lock
to protect the readdir inode cache, so your patch introduces
a risk for storing a stale readdir cache when dir modify operations
invalidate the readdir cache version while lock is dropped
and also introduces memory leak when cache is stomped
without freeing cache created by a competing thread.
I think something like the untested patch below should fix this.

I did not look into ovl_iterate_merged() to see if it has a simple
fix and I am not 100% sure that this fix for impure dir is enough.

Thanks,
Amir.

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index d5123b37921c8..9e90064b252ce 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -702,15 +702,13 @@ static struct ovl_dir_cache
*ovl_cache_get_impure(const struct path *path)
        struct inode *inode =3D d_inode(dentry);
        struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
        struct ovl_dir_cache *cache;
+       /* Snapshot version before ovl_dir_read_impure() drops i_rwsem */
+       u64 version =3D ovl_inode_version_get(inode);

        cache =3D ovl_dir_cache(inode);
-       if (cache && ovl_inode_version_get(inode) =3D=3D cache->version)
+       if (cache && version =3D=3D cache->version)
                return cache;

-       /* Impure cache is not refcounted, free it here */
-       ovl_dir_cache_free(inode);
-       ovl_set_dir_cache(inode, NULL);
-
        cache =3D kzalloc_obj(struct ovl_dir_cache);
        if (!cache)
                return ERR_PTR(-ENOMEM);
@@ -721,6 +719,14 @@ static struct ovl_dir_cache
*ovl_cache_get_impure(const struct path *path)
                kfree(cache);
                return ERR_PTR(res);
        }
+
+       /*
+        * Impure cache is not refcounted, free it here.
+        * Also frees cache stored by concurrent readdir during i_rwsem dro=
p.
+        */
+       ovl_dir_cache_free(inode);
+       ovl_set_dir_cache(inode, NULL);
+
        if (list_empty(&cache->entries)) {
                /*
                 * A good opportunity to get rid of an unneeded "impure" fl=
ag.
@@ -736,7 +742,7 @@ static struct ovl_dir_cache
*ovl_cache_get_impure(const struct path *path)
                return NULL;
        }

-       cache->version =3D ovl_inode_version_get(inode);
+       cache->version =3D version;
        ovl_set_dir_cache(inode, cache);

        return cache;
