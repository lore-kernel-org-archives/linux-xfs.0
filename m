Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21B233134
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043280; cv=pass; b=AYjzNU3wS83bKXjDOP5z4dqf43IyZqRrVFjMRFGEWzv/NvzMjSQU8tSniERbJPvuWxH/RpjHAklbQBZvMItdm3Km5DSwK9nfFChoA0wz/qNlLQX24tLtwoej77B7Qvh82lDS6SN408jtsZVvhczO7tXOec3v/6zC7YawWGNJV7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043280; c=relaxed/simple;
	bh=JLtvplRuOrV1XCd+vmBKYGpvhguS1Ynr34OsxGcjbOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YXWqO8qiFw6QMxSyurTTecrBJjXe2Un9wucFfEjwFRVtJ28P0kByp6Zob9SHFxPbKNSk3Tv1/k3nmv0Ks8qI0J4wcvW8kJGQV4qA8UYC2ndmrbcC//kYYcjnJdg2Ilpa65wW39EnR+lUc5H6Kkc4ryg3wKvoFT9V5lkQuIgcup0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dufoFZFh; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dufoFZFh"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4629051c946so28066f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 18:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783043277; cv=none;
        d=google.com; s=arc-20260327;
        b=JGW+29FDAz2fmasoHoOuwfbCiVKzMqz+9MnMO4OzUxZbrfGqeRCDEHwGnHPPZgWvuT
         1PVH5PVYa+4lAbVP4L0y/MuVyMHTPXFnCivfb826qyXc9e6oeLw5AI0k6skCiLej/FmM
         9iKZeoxfC+aLRvDB2zr8C1oMqr/YSdSIwt7TJDVOrdhg0dTr5+bb1UbYXwK+c1DqzTbb
         tKVsBCYRcyxoMl/iJfjrwrB2nAaKyVESC9b4blVDzwsLtvHkto8LeGzpm7YkHrdnlelF
         GPUHsR5EFwFyCzaaZ1xoI+VbQ/uYBR3pYfI1i022Fg6MH64o9tb5dpVLB2yA1dl29Qeu
         3Bfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        fh=I6O6cTUqVEUReOeHXZBRAny4b0khfmHknKw/3hkO240=;
        b=AEGeoGswiyYGkGGFfHOJ2sLJ4Tpa6tCLwJB56FJJEL9Vsdd8Cw6T8emot8+STDp+Vu
         C131iIapHiqBz+839NoVwR/nr+3ofaEPIJc2SimnwIRNmyzu6/8V2NmFb7Ohu/N3C6nK
         LwL1ysY9eaTmjimC9nryJ5mLsp/z5J8fJa7IzoLXNumfiCIKIdgQeVzumL/hypQ03cL8
         Dk/i2qb2Aio2fvZixJujyfl7Vt2PCY/krD5ZzSadC20hlzyub9afaUVI4z2FIWn0Tv90
         L2FqrWFaG04Syrx1P7chp4qR0EjpcMS1E8oxQk2TH75GftbvvbK45a3g9mM7JTT4T9ou
         dFqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783043277; x=1783648077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=dufoFZFhKQJbHC9rHylIz0aof78rVCYT3QUD5mRkGhy2l7H+cJFcrmx0ybWXWVb0Bz
         lrW7QlHAltzBw+kvMLizK0YEHAsZoyWS0+XBAoIi5xhndr82fJHS0BTO14xA2bp0pF09
         V9ZauT/73+0QwIKwA8dZRxz7vTpOQodLMGz6+b6JtbzgHZWnE4U3ZSPxEiq9b/IPAP61
         XgxOaQaSXfFyC+6XiKajOM6iaFL3E6uuC8U+Vp4QxuvemfkTSW28CH+qwU8M2vcSQlbp
         EcQ0Cc6bpR44VXn7DnhTNgPmvFIcLFMk2xzoNdLcWJ+zRAytywpl/r3mFm9GN/af3ipm
         Fn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783043277; x=1783648077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=BetSd5Zh5yN/t40LyqQXsqmpBsMyH4cOfG7vj5JrUuYmfoMYTPPAvveSxKdURyzWYv
         jJnipP/Cbr/ja8lUXxFIm8Zusd7EcEjqP7xVVxYoGCFQvcLuK15t9hmlx1mQDJxM4zbt
         CX9yfM1edzgzmsDW8dO9w8Y2VYvrcbQxH3xtKI++GuDxfopdVb9gs6NlhQJPZ+IeQLcx
         rD72hxt7bQOzkg9C94XfQlDEEh841IeHmeLk7cZmSrc+mcGw0+bUdqFyAXzNaUDWT0IT
         BjrR0eIKeHT5peDoDtOgcFG/CSZ7lvFDZZ8OIDHh/1SxIM7pG8Bo6YRF6LdCf5eHCnvD
         DjcA==
X-Forwarded-Encrypted: i=1; AHgh+RpgiR9fwqe913gST2z5tPZuKAyUmrq+gwN694X/Q9l8fSUX/MNwPRKV4HEPSO8ikkOH/iOwIZHoZxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyniFWtl5H3avF4OAwg/FgWsVM+1SP4JTzWTBh4TZXAHcAFxGBE
	WiMd+9agP1oJ6OhDnJdf0l/tGh3lf/AAbdo4+RMauklmMQ1NyCynWti2EfScrKPwL01iDWFJUcz
	889p4uQ/w+4PhVOH30+yN8Ts0y12z/Vg=
X-Gm-Gg: AfdE7ckHgRQNhDpAMlkoxWJiixLyQJMlScRl4ops7l8H4nviIE8ChXPLSzd86oQSH7u
	i4BFhh0A5V7baco7J0uQPiDzlG03N+6vwsPbqPwdhVzom4R4nxBqcUtTzZkzdcEkV4ZhaLmd5i5
	iYFxalBWLpjsUg0+PUd11SvLMU72cB5sgQj56GU/rsLjZUjY5Mb8RhGQ8Cx3pe0521EBoc7G0Jb
	yKLIBXk5v3NS3Io6sB6Nv/ZueVFI4CVLd2Qal+bekHIaZN4Vxp5EdjRXpnsA8GQ5QCIwGRX8war
	NFM59kuJzsBg+klESgkacwj2t7piYWFI+n6Zb7ztP1cr3zTtYzBF
X-Received: by 2002:a05:6000:188a:b0:474:88ef:cdec with SMTP id
 ffacd0b85a97d-479347abc89mr3414307f8f.6.1783043276701; Thu, 02 Jul 2026
 18:47:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com> <20260702140705.GE21339@lst.de>
 <20260702165117.GK9392@frogsfrogsfrogs>
In-Reply-To: <20260702165117.GK9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:47:43 -0700
X-Gm-Features: AVVi8CdwjVgCnc8OibEiAJiLFqrCHykAhTtcw0AOMmm18cQj3dSCo5Q-SEBvMhY
Message-ID: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:51=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > Looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > In terms of merge logistics, I wonder if we should delay this and
> > the previous patch to the next merge window so that we can minimize the
> > cross-subsystem merge pain with more file system iomap conversion.
> > If none of them actually happen until rc6 or so, orif  the merges aren'=
t
> > painful we could still pick them up late in the merge window.
>
> I'd say everything but this patch should go in during the merge window
> for 7.3, along with clear instructions to brauner/torvalds to expect
> this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> the other changes that come in.

Just to clarify, did you mean this patch and the previous one? If i'm
interpreting Christoph's concern correctly, I think he's worried about
other filesystems converting to iomap using the ->iomap_begin() /
->iomap_end() functions still? That sounds like a good plan to me, for
v3 I'll submit everything but this patch and the last one and then
submit these patches (and any cleanup ones that become necessary) to
Christian right before 7.3-rc1 gets tagged (which as I understand it,
is when the merge window is about to close).

Thanks,
Joanne
