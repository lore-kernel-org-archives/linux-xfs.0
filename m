Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBF43A4F28
	for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768504466; cv=pass; b=VHcal0gZSXLzrGO1IFHOAMFeQqnremg0IMK9G9tO8r7noX2/fW/lrneFfDBEjFNSi1sdQTBGy/82V8mziKRds8Pj4cCuDG55NCvwT8hCcCzccUdqYimSLlt6eYDYMf+pRO5WyCUoUm8NO9/ba8Mx5VWhhlC8q3ujeBBzncrde94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768504466; c=relaxed/simple;
	bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RxOEhny+hRMC0056HQF0St8g1N7UB73ixqd7cDGNEI0u5RsGzDIHUzjcaO+uRblsFUdTh7K7kBkwVq6v5EFDo2NTzmm08DKh+46Gjbp+INVEcrg+VHZNfOMV2YvkznmHe5KT72gN+ZJYOCbsDPfS/ulKAM7h9FljD2zjOLKySwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDvYdYL0; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDvYdYL0"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47f3b7ef761so7306675e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 11:14:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768504461; cv=none;
        d=google.com; s=arc-20240605;
        b=BoillBP1G9ctsBJLLAu+GOTCHty3tYsBsdsX9SQLs1QqzBHaq3fYg+ZqhOwoB5lr+f
         f5ALTGZ2/IKD7U1JPNXz0/15W/wr/vFX/IROFnKa+tUANZ+KECncNfy5Jk8ZtB9NmYSF
         68KPosi0MyyBwP7QMNK5Wd/Wei3EKFSeKDaNLRVc/uecMTuP0Ok+yE5FPANMO5vUB9OY
         Bb6eEIYSahn8ysAxIlF51to+sYIpXY8qlwijABq3JN7CMAxMAC0oYG8ZZt9j1CQsta7i
         80j3KsvLf3U284YTM8MDP605YtkFpObgkvHIBiKqEIUXYu+sgbWa39wjPUFXCTU9z1mn
         0E4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
        fh=AY731PTgaJiwQZgjx17tSlscqCjtceKSZuxE4M//pW8=;
        b=GIBBeTARqSEmYO6D5MuFRvFGw6hKnmFo59+JsojazUV+RE43D9LJ2934DGSXlJMsJI
         roKnrZMS/hvZoTRxVCYj3zfaP7Aw1CSrqWsv0j+o/9PaPu+TmnF7Ijm0TUHZGQSy1kTo
         34pWAib4OemjSoGGXMXbxnbWKo7FSYPCP6L4p2tX9R2W9JCf/mU7lYRAlKUnX3RHvv25
         O6PSb/gQfOHPGN2kLGJ2IFTcq7qMybMyBJLr0Ji3csre/qo+5nTYBtdjOndcYdc2DDu3
         scgVe3EffpJ6XCsx4+9Q3w23t7LfV5NFI7fLid6QssQZf8/ZPxkTemA4ZieiFHY7NO4Y
         UjKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768504461; x=1769109261; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
        b=eDvYdYL0yZ6SV5I85cBjsgP/sNA1X8xt4pIFzkPf14WQU8PWsnFTZbFP0w7gvj2vKR
         su7k/MnvLCToRHyNtBK2Ctyl74xxKbrSK0oilR42ZtVbwVIidcOzpn6LGa+m0L219bov
         LPfgSseqpVZriPFbBElJW4XsMxajo2fDIMAOwj69wq2QZXSx760mtGmSS7iSQT2OVYn3
         nHlQxi2/qPexhK3NToOklsvBJV74vyrx0cnd0+iL4bB9t8TovQ8oOPh4KgdANp7Ff4FW
         lIM5A0H6dpndNCHyHgWetB48LZIZV1yGHzsBBYn5Vz8YNJFWL/CrTlVVBJyKHRkqqpd9
         IUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768504461; x=1769109261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bpVL1RB5I8PR85y4mxEedr9T/Q0DYVA2jeDelSaqSc8=;
        b=u0UIY90Zrz8MCsewxWGYIA9ni5obCf7UXxqPh3QZ/v6UUmPoD34YvW6ktCp0WoU85I
         CsXHCbqXuC4INjePOtbdfTHtY778o60tstzvvnWV7qjAzguPp36T+4PBac1NiiEU5TsD
         Krz9iRTuSOGCkH6Gc9G5WJIRbGazTsIwYupn78hMnU2TEFCxJ7lH5jDgvcre/2Dbr8wm
         452x/4dtdmVLhBLKVZ3DyC7oCMrmayi4r9xy7KYSrS7VD4Yk5IJLsMdGsskLameU3T+E
         eWppDbnvj6Tde1BDwZRYmx+OQkjzA45IHGA855mCydbLlxoBj7GvRpJvmr/J/NLQRNtx
         7hng==
X-Forwarded-Encrypted: i=1; AJvYcCU0AhADtT1fkRfG6Kef1tRPMUeiU9HK0nJhqZGuV6azKyzzdeSRR9hZfjh2D0tg9hc0lQljOY7q2VI=@vger.kernel.org
X-Gm-Message-State: AOJu0YznPSQn1I/rlfllNm0UxtKavZAR5obQu9QLtvOYaPes8IzbLAp9
	yyNt4R5lrCiueo8jBPeG7HNLW88SP0N+Pk9hHd52JBMGGIlGz2gBl8l1SediTQePspDPnsnCwIa
	m+YHZm4F5Egj3APRjrnnRprSulhFgx6k=
X-Gm-Gg: AY/fxX5r8VmhMFZBUPqvs9gSBWtBQ3H+WQX7QjuK9PXYChNmjBW4L3NbzAiMNl+9KGb
	144niy3oABw5zccegj75vKUhWg8g2vZV22Y5jAJQ/IUxH4kEb8DAbsWnYcG7lZtM91wc+UlanoS
	gTarI0IGJxXVzCIPvdp29Q/45pg6JDhjvVAZfLg89qHcszQnP8XQpiWujdYENCfFp3OLFrfiMY9
	Ft2Okuaer3j0H8steafghVSzkdBDEJcML+KQ2LXHQTwvKXROMgBlldle39ZiJ8bzSWFhZk6Ii5w
	RSrVJzHCHhVxYAyvRmM6FpMSFg51Bw==
X-Received: by 2002:a05:600c:5487:b0:46f:d682:3c3d with SMTP id
 5b1f17b1804b1-4801e30d482mr9929055e9.13.1768504460920; Thu, 15 Jan 2026
 11:14:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com> <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
In-Reply-To: <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:14:09 +0100
X-Gm-Features: AZwV_QgZJLcC_-bQ-_VIrtnGFnLgmiVjy_ytBB44u2cGVyBOwKNqVyWt_Jfm7Ds
Message-ID: <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
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

On Thu, Jan 15, 2026 at 7:32=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org=
> wrote:
> >>
> >> In recent years, a number of filesystems that can't present stable
> >> filehandles have grown struct export_operations. They've mostly done
> >> this for local use-cases (enabling open_by_handle_at() and the like).
> >> Unfortunately, having export_operations is generally sufficient to mak=
e
> >> a filesystem be considered exportable via nfsd, but that requires that
> >> the server present stable filehandles.
> >
> > Where does the term "stable file handles" come from? and what does it m=
ean?
> > Why not "persistent handles", which is described in NFS and SMB specs?
> >
> > Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> > by both Christoph and Christian:
> >
> > https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e=
93c00c@brauner/
> >
> > Am I missing anything?
>
> PERSISTENT generally implies that the file handle is saved on
> persistent storage. This is not true of tmpfs.

That's one way of interpreting "persistent".
Another way is "continuing to exist or occur over a prolonged period."
which works well for tmpfs that is mounted for a long time.

But I am confused, because I went looking for where Jeff said that
you suggested stable file handles and this is what I found that you wrote:

"tmpfs filehandles align quite well with the traditional definition
 of persistent filehandles. tmpfs filehandles live as long as tmpfs files d=
o,
 and that is all that is required to be considered "persistent".

>
> The use of "stable" means that the file handle is stable for
> the life of the file. This /is/ true of tmpfs.

I can live with STABLE_HANDLES I don't mind as much,
I understand what it means, but the definition above is invented,
whereas the term persistent handles is well known and well defined.

Thanks,
Amir.
