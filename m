Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECAF2EF652
	for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505014; cv=none; b=TRw2fOd7PhU0HlZTW9gKDE/1IQBrRlmBIya4S3gCe5f6RmKmKKbXzrUgpe8+FcVadJ/L3kMlMuVZYNbnRAJrhLWUUn45kTshkjdltRzNByDZANc9oc7s0ocCnX4mG2prOpHpf/DbtfmsjkYlrt9vxsS4Zrvlh4ZlX6kpypAn8Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505014; c=relaxed/simple;
	bh=K7EKeFZcYOwWj32Ok6OEcoTNGvsHPX2vPwhKzUVyoug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hWKcMGJYpAoIBfBwimAtNSifG6HKpvJPZ4brK1YaE5sVoERNXOskwlZrBwE6L+ta5czob64BLMYIL72MMLFnZvZIboIOSSHdIxPp90WZMaph7R00RyWBkLH5iTzDFX834tWvEm1ON8COKUCHb6aoN1LG/ejdaxbsswxqINqsjXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+d8bhIL; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+d8bhIL"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b87124c6295so198269266b.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 11:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768505009; x=1769109809; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HpNW/ml4xLa7Q+ZYoOd6NCigBelaQL2RtJ0aaDh9mI=;
        b=J+d8bhILA0dbk7t5hkmNO1mcsMKdM8fhTW1Ocr1dvZWCSsmJa7JumfRtv6adpfFHqm
         6EoeiPfosiEqcgJDEF8iRVcBmEzKJZYKHGka5fPFFnEO5DjlmHHCyplVtllcdEWKxVPS
         7f9HnOwO44sfz33ApLvvdQDuS2o1nPotoefgiAzWSyyvN8Mnw9E8397Y9GkYVtAcH5mK
         BTLEixHMcFNcxaRv9OxW2AqX58uGVSpZwSaeQhuPKJdv4mvEVz+EwSWYEdRXMZd2+jiL
         xAd7jVwMUpQ2rqFOyA1wKHBUdFrHiwAMCQeemIRpz7T0KnCZsKby8mDjZ1PerF/UP56G
         g4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505009; x=1769109809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1HpNW/ml4xLa7Q+ZYoOd6NCigBelaQL2RtJ0aaDh9mI=;
        b=kTlhHgiqj4Au0gwV5nYQPZnWyisWhp/vw7XnTkhxW8WWhzLIg2NRgnDor1FN0yVHSF
         XTWicciSVwvIuEnd4EHCbfIbU9Zv0stkTMjT6QMkdVZ4zE3V2TOTk74aQx65rIt4g/ji
         BJncOb/R6vDa3oYcrxnmsfsVHY3SXFU0yzV52jp5l6TnbiRfgm9itjyAB2XVrDTNowtZ
         dOIJoEKxEiZXTSla8wk5bpbZ4VQB7Ab0rnhhFpJGf6Yc8QD6bGlKgV87z4y7e2IEe9+y
         mfv9a5vp8eiKhGx5+r1S7Q60nobpfq+jbWRTbsBcOILM5hVUoDKbRPGShpaaRJjR6IeP
         bysw==
X-Forwarded-Encrypted: i=1; AJvYcCW21pGUqjlu8AOUQttVw/6MbtQTlrbeOx5rugc+9q095Ta6tK9JXuuvnpIbSyUMEKklR65zB6j7tLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwABwcpfGre+1SSlyinf1WYmrnk8Ci0JdC3G9DB5pDqe8ML/vCP
	k4vJUuUqsr2zawYdbrqsVMpYUX25zsM7V51+PTiRcu/mYyzwXfP6XJolvxx03KO4vWAMKh0M3s9
	xh1vcQbScP8sr/OYNdap57Mj0xnKtdzE=
X-Gm-Gg: AY/fxX6yM/E5rVb7LUwcNLcSGKAjpZumIcwhEVxhgIXFGzbiOpxOyxcoEUCWVlxBArm
	h4GmFjIJbwIXJ7ndksOhSM61GlRgdYxw1F2QbPODMU+q1CGOkwrd0FWN+ouzTOp+H4nLnUJ5jjp
	rmGSi731tqw/DUT7nSqkHrTBCCYL6yvkH1WdxHBUQYfLmqUXyiQt5eJ0aqrvkTj1zzCT4r9xcYP
	CHtgQwKbh96dW/q38o8pTA5AFlp7bTkJ3uj0Tdc9tswoyVTBIxvRfXmVmhCCm0ah5E4k58yireh
	4wQYefA4pzUXMWHFNhlFQsPMvqmVMA==
X-Received: by 2002:a17:907:3e97:b0:b73:7c3e:e17c with SMTP id
 a640c23a62f3a-b879327e30bmr63085666b.44.1768505008810; Thu, 15 Jan 2026
 11:23:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:23:17 +0100
X-Gm-Features: AZwV_Qj21qC7f0_83CWGwxMbCuhLisWPoHuSIOsZGqfnrVByhBJVGvUqJqXdQ-8
Message-ID: <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
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

On Thu, Jan 15, 2026 at 6:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Some filesystems have grown export operations in order to provide
> filehandles for local usage. Some of these filesystems are unsuitable
> for use with nfsd, since their filehandles are not persistent across
> reboots.
>
> In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
> and return nfserr_stale if it isn't.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/nfsd/nfsfh.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195da2e=
8678b3fcb3d444d 100644
> --- a/fs/nfsd/nfsfh.c
> +++ b/fs/nfsd/nfsfh.c
> @@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
>         dentry =3D fhp->fh_dentry;
>         exp =3D fhp->fh_export;
>
> +       error =3D nfserr_stale;
> +       if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HANDLES=
))
> +               goto out;
> +
>         trace_nfsd_fh_verify(rqstp, fhp, type, access);
>

IDGI. Don't you want  to deny the export of those fs in check_export()?
By the same logic that check_export() checks for can_decode_fh()
not for can_encode_fh().

Thanks,
Amir.
