Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52B399A6C
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768574828; cv=pass; b=Tz4Qb8W0Pi9mH1qEGYbKgBzw+bJ8j1UYhMlK+ppYsnf9Bb+2F5UyrKOpJmcxqIcRnSSSMfoUUMvdtjAEPlWqjfqIeJ4CUOWC10cvKKE2Ro4t1J0xp5GdfoIvoDzJm/Xg74gqIaHYQ+0T4vsRDOad15KMBwBnMBOZKulF0waiExc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768574828; c=relaxed/simple;
	bh=roiUOgMNh/uHT7xq/Ufc65Xx1gVdLlGNv2hq3QwsGUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EXllQt+ER6Cq65r4yvbiIez5Pm4vsqcqj4oWUBjf6TdDvWT2MAEQZSegDFdLh2YqoywDXbfHxv8RZTYlMFp4FyY83jzeeF8bFJAdHfAnmJmY5hONFmkWf+HGbio2WtzfreYqg/W02hy9zO5ChDhr64KSFHTSKuG34CTv8aOU7GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aISfwXja; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aISfwXja"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b874c00a3fcso342389566b.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 06:47:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768574823; cv=none;
        d=google.com; s=arc-20240605;
        b=IhY1S4gJfIbk5huhgrhBnFgxZxafimGBuJl4xhu67HEELc4WZIV8Vcg7MkqmML5SON
         ODXxrjoMeOpY/z9QMpUNJ2SigtRVMnpTSe2ONPrjQSqwnOgYO8LVWIjcQJlVePWi5nfR
         hO2Z6jo4/1LgjZLzoJnuMJt6/KeeWMoppXrIeJSur8lEi2iTHSakf+1/Yzsz1dWDGGvV
         ye+FzauvH3eSnw3BKBZlyZnmzk2udletqzc91sqkOczoCKMP4dcv2hKS3tv9RKOoxBoH
         G0weq1aWInbOfUdZEAz1wOQpxn7qtDGnzTprHH5TU6jp3PEtUd0R01RIKCbQcC6l/W3G
         CXTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        fh=+hJmzaUXu6OVX8ZIoqUMNu8xM0N2rkVD+OPO8nOF87g=;
        b=JpHtCem+2Zx6SDzZQ8va01PBOkCGMT3q5nLFBj3I4TNW7MjPd93y6IITEjfR5h+udp
         fiVc555h6hyxyp92p/NGkQbA5tQMOWqQtFSJgH2frJzzUrG0L0OdSy4qLKNmHnBKECzJ
         Le1PEBr9QvJW02cQxYK6PF+iQ9+1X1W9ZrM7ZQyw/Yng9ccG+jgSDf2hHajmBwiCY6Rc
         0NzPvsVbt4qJfN2NOvFbHH9dxrcatB8785MQhErN64z4WgYv/XqDQ2mQiDlhj3KOHdrl
         iq5x/w3PSZUBaVAdDbJ6l6pAN6PvDNsCdDD419uYEW85oR6dPGjHzZGmf3cLbLDJtJlN
         Dxwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768574823; x=1769179623; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        b=aISfwXja07pJFqC/Do7mY8gNIFuC06/Iung/cJCgn25q90SuyiOspfPUPOM2LhaQxH
         iwzQers6OzLoIg4Kl6pDLgvW43r+pJ78+MBLopjQlSq7gmSLR62A57QIW4O0ePhqobBd
         aw+rgc/BxWP6VKKbQ4YcnFAWsAi12quI6k0vNwu4qDgnMRDg7laAjU+oGlerzPAy8xg+
         iZAC0LuWW28yezP2tM9VKx3GqXVMcTznKh+bWfpEp1m+1/J+OC0fSAM3kyJaA1+5pHub
         qp+geSLjw/Ca6WDAXfapdCsJDIBcZXpglHWhAvDKlCQI9dvaELsQCw1YUCk5ohtGbApk
         VX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768574823; x=1769179623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        b=E+C83gxw3GEyaSaWVMFtk+SJn+f5oUuf6kl4BirlfXpYNl5MX1N3d7NKIyy3tr1XEI
         YCgpL4nrFfc8m+BP6b+2Sg+jlAEDPmpCdtESQKFcUdTTtuv7dQJKE9d+KSycqs5W30UF
         csTCInj/kWFap++9ekY2atpjavgEXhTECDjQVoSVfC3EbEGADRSkQ7vMCHWDhSemf/IW
         MNDVr7XIaaMdYZKAtFUtykIGYEF7GbsBj28Zge+LR/8tTSsw8e+gHIy/hYXYZjltBEiq
         1tDUdmxp4rcEKG3A0jth7XhdoFTKDS7K+FkYzq26gzsiRfSURPyyiv2kfnRHJcSucn2h
         TqWw==
X-Forwarded-Encrypted: i=1; AJvYcCVVnDiREooPqQJDvOuo1bAWr56sv9Jb8CcMQw6mZCjOk8QHe+SNQTS8kLVvefc122MT4YdqLbTuDO8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM8bzrlrIUROolryeTdfaMwoWN1R2Dd8gfNWe5oolQR8yTQpSA
	zEZJEvfpRZwe+7qW20SY687bLJD6aCtOs72oJ+2HgT4C8ZDwE/jz5e+HAwpyPHnmhRHocaFLMqT
	T4ziUA7kVdW9pWH76luzsxGFCaSr4+4s=
X-Gm-Gg: AY/fxX6j1T+gTJXDNDenCJ6fA0YZKZ6+//g8glzCUQNnvkqfKdnHsGUtBX9OTU4XHVV
	HsgaskTLwWtAcM8ww9fuWePe1hjUz4QWaPDWvy0ikjPgVEvEucLIDGxX0EARQ67LDQgZDwTvjE2
	/GfITAhFkuiuCxHAYXmH8iBd+hAxJB1jj1IPBvO+yQDkgAKci3uJrqpsOaeY/PBbqQNkskfWXZj
	kmX+uTy5xSzCw0Wvy3yE4GBj+BeRAw3e//XNQ7xyvKCLUuz9W9Jna/5g2tQrEWq7YKkHb5EtlVI
	KnVEfZTGcdHW0pwKXsmSoye2F9+7VA==
X-Received: by 2002:a17:906:7305:b0:b72:a899:169f with SMTP id
 a640c23a62f3a-b8792d6cf8amr335795366b.4.1768574823087; Fri, 16 Jan 2026
 06:47:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org> <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
 <8e4c3df4828351c677186bf018061f2b1fd1b48e.camel@kernel.org>
In-Reply-To: <8e4c3df4828351c677186bf018061f2b1fd1b48e.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Jan 2026 15:46:50 +0100
X-Gm-Features: AZwV_QiRcITYtWxbtRpeIxfeQr9ho0AGFQM_8wESdHA53c49E-5t7eaX1T9rC3o
Message-ID: <CAOQ4uxhkZNueydP0tTCAj6tuzKWPTYB7=JR_hb4gaavSKQ8C2w@mail.gmail.com>
Subject: Re: [PATCH 29/29] nfsd: only allow filesystems that set EXPORT_OP_STABLE_HANDLES
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026 at 1:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Thu, 2026-01-15 at 20:23 +0100, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 6:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org=
> wrote:
> > >
> > > Some filesystems have grown export operations in order to provide
> > > filehandles for local usage. Some of these filesystems are unsuitable
> > > for use with nfsd, since their filehandles are not persistent across
> > > reboots.
> > >
> > > In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
> > > and return nfserr_stale if it isn't.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/nfsd/nfsfh.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> > > index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195=
da2e8678b3fcb3d444d 100644
> > > --- a/fs/nfsd/nfsfh.c
> > > +++ b/fs/nfsd/nfsfh.c
> > > @@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
> > >         dentry =3D fhp->fh_dentry;
> > >         exp =3D fhp->fh_export;
> > >
> > > +       error =3D nfserr_stale;
> > > +       if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HAN=
DLES))
> > > +               goto out;
> > > +
> > >         trace_nfsd_fh_verify(rqstp, fhp, type, access);
> > >
> >
> > IDGI. Don't you want  to deny the export of those fs in check_export()?
> > By the same logic that check_export() checks for can_decode_fh()
> > not for can_encode_fh().
> >
>
> It certainly won't hurt to add a check for this to check_export(), and
> I've gone ahead and done so. To be clear, doing that won't prevent the
> filesystem from being exported, but you will get a warning like this
> when you try:
>
>     exportfs: /sys/fs/cgroup does not support NFS export
>
> That export will still show up in mountd though, so this is just a
> warning. Trying to mount it though will fail.
>

Oh, I did not know. What an odd user experience.
Anyway, better than no warning at all.

Thanks,
Amir.
