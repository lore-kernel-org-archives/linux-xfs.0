Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A4F2FB080
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760110865; cv=none; b=VaO/cBJjgXQZpde/Wh/C7zvQ3DmGZOakk8jRiUEbxiQJULV0lQTdkcJ7Eg0eTONv+dk6vcIb5cmT+ofrQ4qKI0IK2a2iq55cHaXa/6wixkAZpG5HDwB3h1aeB3fyvBDaSA0r8hPGNvkeYiUjUKRHGZcY7NKxcoP0lVpbe/tjiqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760110865; c=relaxed/simple;
	bh=xOJuDOIlas451FiXAAHgBhsNRzt6HStLrb4Y3mKzjBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GuNqWmy/5F3YV2l1ggNAKbX453UteZFv9ra3uBcoMuDGxc0pCi89ZHtp9uDNZ0xwOAl6pz9YAOIIdSxtootjy4sbF+vzYdc8RqWyd0Y+nQThE/FgGQJdZQgAeQetz//+kY+r+MPRJTFXb+kT3RvqMOYBJCtuxkRCkvJ6twjWXQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAjzMCP6; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAjzMCP6"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-634cef434beso5128160a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 08:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760110861; x=1760715661; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNrx81VuCOUnlOhs53ChqFbGZmsPkwHURyqTboyD4SA=;
        b=HAjzMCP6WRFHv/sreS1KWvOy6uXorsCkmnygvRunN2bqmGbBktPhZ9U6HGiqyMP0cZ
         vcYM6+1DmRsf5UmsVPkExeA4WxM6kbNyB2VNxeu4ENsh3hpq9Wt6RuMc1X8lZ7HSIaWs
         EqIktZDYJcyX5J8DP6WL/i/WTfjV7NdvFv/trIlSgKJyMxW0Aisbc1WLCgoTmSmzq2tU
         4rcf7rzcR3yi7nRiW4ojKWvGw1hg2qy38twmbdGmAAtI2oCDGcmLTkDX+d1WAmlwHDBy
         KkHR6uV/go7sPmZTc+/dBMRFzIs+gbgdJBlT9wfbYDR3m+TfJFt+zxi0ii5lQeVsCD/E
         0i0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760110861; x=1760715661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNrx81VuCOUnlOhs53ChqFbGZmsPkwHURyqTboyD4SA=;
        b=mYlblcC7rXHdnTaMpl/uUxg9abJUTTraSWHLutQaheZT9VkXNdIyVry3FufzxapMgK
         l6VtPviWksQBU61tqHPPcykRrXNhshUdo0w1MHwiHIqJVl9+oolG1eG11+ZfW/Lxn2Y8
         xrOYlvIgvOELBzPi9zjNU51SUUwlO4zWIJ+OnFwa/lbNDwzU68VCIRST3FPhK++Evdzv
         N9wYUuMaCJKu0k/vNTIdX00BmIxlIq3oxrfw0RbbrFo6z/zNpHJyIA5jt61mrABXG8s5
         m0dmEHnf4n7TDJDwjzl8ksRnGuLTf7n+vRapQ1r9bqG2SyQ52qc7lozR7WAeuGonIbYf
         /sxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuBNruVUci9+PeB+lfuUrp9oiwNp57yODCDreq5vaRZ5tIwhV4qytOZ716MYY//5R611efPEIUILA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGeAHIPGtjkqbtM9D2JG89PH1fIkQyRrpHbq+raiI7WuVTJflX
	aNWuID0FEBahev3qncafbdaUAFHNo7vVbA9YfMqcjvluHrjGml+AgxLf6p2Fxv67FxLcLRcugVx
	5KvMsxlW7DphljTqCBFR2zU4ja33qyc0=
X-Gm-Gg: ASbGncuY3DaK2LLO8bV6jpUdt0VZ9/kcxdAFlXqHvcD666wmIB2tmG1sgKxOTNfDde3
	Sk5eJsfExOzdtDCQ0PNViMvd/wREovY4BKbtuOhnBK25W8YJiHdhEcV0KLiASzvK7RKFkBtCfuz
	fPqpnu8VH5mMBz8sOJnKmRT2Ds+1ffi3lYo1I5UgXHE93dFLlqZ9EsRiyZUULGwF9Y6AFO8CeYp
	GjE3tUtuvvnfy85tHxchtF95vWQIMomR7Y1yx+XPmnLen7kpy3spjhFNO+V9Iye9tZ7
X-Google-Smtp-Source: AGHT+IFsVwlKz3dpQMSn0djeXDN0dipdKA/kgBAE2NxkawkzYdINOsshggkYLd2MlBJ2D7HcedRqmChtEct9QlvTNTA=
X-Received: by 2002:a17:907:3e2a:b0:b2a:47c9:8ff5 with SMTP id
 a640c23a62f3a-b50bd050daemr1405146466b.10.1760110860769; Fri, 10 Oct 2025
 08:41:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009075929.1203950-1-mjguzik@gmail.com> <20251009075929.1203950-14-mjguzik@gmail.com>
 <ua3koqbakm6e4dpbzfmhei2evc566c5p2t65nsvmlab5yyibxu@u6zp4pwex5s7>
In-Reply-To: <ua3koqbakm6e4dpbzfmhei2evc566c5p2t65nsvmlab5yyibxu@u6zp4pwex5s7>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 10 Oct 2025 17:40:49 +0200
X-Gm-Features: AS18NWBB3Bmc7XAi8sS7M18NKhoZbvSirs7my7gPJLr4eYk4Rf7Ljkokn3EGE5o
Message-ID: <CAGudoHGckJHiWN9yCngP1JMGNa1PPNvnpSuriCxSM1mwWhpBUQ@mail.gmail.com>
Subject: Re: [PATCH v7 13/14] xfs: use the new ->i_state accessors
To: Jan Kara <jack@suse.cz>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 4:41=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 09-10-25 09:59:27, Mateusz Guzik wrote:
> > Change generated with coccinelle and fixed up by hand as appropriate.
> >
> > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
>
> ...
>
> > @@ -2111,7 +2111,7 @@ xfs_rename_alloc_whiteout(
> >        */
> >       xfs_setup_iops(tmpfile);
> >       xfs_finish_inode_setup(tmpfile);
> > -     VFS_I(tmpfile)->i_state |=3D I_LINKABLE;
> > +     inode_state_set_raw(VFS_I(tmpfile), I_LINKABLE);
> >
> >       *wip =3D tmpfile;
> >       return 0;
> > @@ -2330,7 +2330,7 @@ xfs_rename(
> >                * flag from the inode so it doesn't accidentally get mis=
used in
> >                * future.
> >                */
> > -             VFS_I(du_wip.ip)->i_state &=3D ~I_LINKABLE;
> > +             inode_state_clear_raw(VFS_I(du_wip.ip), I_LINKABLE);
> >       }
> >
> >  out_commit:
>
> These two accesses look fishy (not your fault but when we are doing this
> i_state exercise better make sure all the places are correct before
> papering over bugs with _raw function variant). How come they cannot race
> with other i_state modifications and thus corrupt i_state?
>

I asked about this here:
https://lore.kernel.org/linux-xfs/CAGudoHEi05JGkTQ9PbM20D98S9fv0hTqpWRd5fWj=
EwkExSiVSw@mail.gmail.com/

> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index caff0125faea..ad94fbf55014 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -1420,7 +1420,7 @@ xfs_setup_inode(
> >       bool                    is_meta =3D xfs_is_internal_inode(ip);
> >
> >       inode->i_ino =3D ip->i_ino;
> > -     inode->i_state |=3D I_NEW;
> > +     inode_state_set_raw(inode, I_NEW);
> >
> >       inode_sb_list_add(inode);
> >       /* make the inode look hashed for the writeback code */
>
> Frankly, the XFS i_state handling is kind of messy and I suspect we shoul=
d
> be getting i_state =3D=3D 0 here. But we need to confirm with XFS guys. I=
'm
> poking into this because this is actually the only case where we need
> inode_state_set_raw() or inode_state_clear_raw() outside of core VFS and
> I'd like to get rid of these functions because IMHO they are actively
> dangerous to use.
>

I'm going to address this in the other e-mail.
