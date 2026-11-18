Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795044957;
	b=1o0DA7l6k5RXwnN+dN9eayP+mrIvN83okK79+uq63jgecqkIRx7QvQbWFEUucFrOewDD
	 Om5Cg6y5En4lPYDLEk3qZwdikzp8FcGnZpdnN/hyb90KKSlBFiAGhgkBOEiahYzmN0xVr
	 sxUo948huixd5guM+dbj+1uYX6AJa8voeJA+0m6uqFIuO65epdk69AwvJ0X86AMZHODB0
	 m4f7U+JKB9xa+DAJ4Tiy7AnatyM3Rr1jy/utknIB0Ht4h2A8dUqctIDuiyji6vT1CBf6d
	 RQ2iySpzXbr+PWFRihk/50jMjABRmdw0FBGBLLQVTpN1hLf8UAd9tJnQmVChl2iuL4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044957;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=1sqaAoxbPYdo18ldNOsiM1TbcJ03Gv+SVlc5ayXI+nY=;
	b=j2f5yl25cgWYRNE7q3TKycUCMcMuREqoSNk+eguZRObtWtHYB+eN8TrsSuIPTSWudc5g
	 7MmnMpeXtLNvSKv8A7KuYOk9wJOLKWvx+Qh6vMlyUgnmhyg9D29ymj6sTE7Nz4QSHP3vl
	 Igqszdlj1KC45bVHvtuPuGmD7XeNqpJNZJrfgzXXVOUoJBu2CFZEluQJxYWnTl3QZAMbM
	 039vEWw3iIZOoCpf99H2ePN+BDqHL8l1PtmKp8dYgGiDl7WtYjdcOY6sgvNuPDGphm9oO
	 xrZGIgQJ26712+fpSQC3W7AcxtBQ4/yTKHd1e97lr5FU/xZb4d6FO/aos96phxOA7JQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OeZtfPG5;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=VV4lacCc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEE6606A31C
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 23:35:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEEE6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OeZtfPG5;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=VV4lacCc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795044955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1sqaAoxbPYdo18ldNOsiM1TbcJ03Gv+SVlc5ayXI+nY=;
	b=OeZtfPG50Fjqj40s6Sj+6Did4ufEl3tVHRxceE+mdWNbGwx7fNYk44K7y6G04p78xFCD/R
	1kv1BumxCx310EyVnA8d4SqhUasQR7TMJCm7IYNKBrDLFc8ygMd69JH4NPy4EA0UV5oaOI
	oaiqNL+fbnuAUb7jfi3vcX/vMHMt/3w=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540--SMUzumyNxCnAVnAbjbeCw-1; Wed, 18 Nov 2026 18:35:54 -0500
X-MC-Unique: -SMUzumyNxCnAVnAbjbeCw-1
X-Mimecast-MFC-AGG-ID: -SMUzumyNxCnAVnAbjbeCw_1795044954
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-67be24704b9so2571935d50.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 15:35:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795044954; cv=none;
        d=google.com; s=arc-20260327;
        b=MCUGUTiIe+hZ9sqWdj2tXC9d9LzSjIunhXwAiwRlL0RSw0KD0v9vOG9aPokQkGQ+Lr
         hySX5oGNISXqXy2OTvdLbsWq8RKb/hN0SAnpN33W7SnV4oMkp3vKpPKIYXoD0d+SdPDO
         kWgU53YqCopAOUWlkt/PlgSiuTFAn3fshV9sGIcywehsl5pCCYO9OO2Rh6HoW6vZZMJN
         vzkJP9vrd3EgkLE08jxmxKt/72B6FKhWQPlUocwuDdkFEx1kOla0wrW2BicEdqnZXlOH
         ZXdU3LHNKYlJXxb73l5Dl5qSp9X7CEe2p5rTbXlUqlYfWsjtszi5a9DEkIHeAAogbbS9
         afKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1sqaAoxbPYdo18ldNOsiM1TbcJ03Gv+SVlc5ayXI+nY=;
        fh=QYSu4mj2B+TZo+LDLgI9/73wWdyCBK15C1NU/x8oUTs=;
        b=NM5aDrY/N1vrHJrnwUXd+PIl4Hn56FY5xs91Bdq3kar1bvBYP762mOBYBmYeMXL6zv
         F1WBQ9sWH1JSEztdDptNq8sFSlnFzwHONgCnjPh+O1/EAgj5sdBlVe7aw5wmftr8VAkl
         UWMn6T8RlEtz/TVbzSxS/xayHYRVcS+dIh68zc/OoHh7l2Ogx8PttHPshqClHoEFt2NM
         Rglx1Hwwyq1fJuHh9urYTmAHFP334WT5IGB+N3eNzmcX49R5wtLjp+FqnksYqlsF8pT2
         FeRu1ZKvJ3nQzuSJc8zGbuXaKuEQOYaiYHfzzonXzTz915LO62G+f0WfzUSDjKxqtz/t
         czMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795044954; x=1795649754; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1sqaAoxbPYdo18ldNOsiM1TbcJ03Gv+SVlc5ayXI+nY=;
        b=VV4lacCcYXl3jx6oU1yk7ocsmoMzxU9SP0AoOrXpBHytOyD+5/iloPPuTFDwHot85c
         i1CuguwIDMKYkYwOifW2jU2ON3pcwrl2ze+1M1zXcGvzpEjssC/9u8BP5GrnFxyulUg4
         m3kl+sBRcRdHC6cSbeJi+MrV0kK8R6nXJ+1+w101Ltg7NsQzens8JvDyW07HuceLJ6GS
         rA+E2+jV1u9T1OR/mFRBlrYQhI5+p4bfkvpqrJOCTWbtpDO3YyPi5JSYd2/v8scOcjke
         d/uPzbLWNdLsBIgq0z3OZKLiCCq8cx+Fg79vmPk4t0z6mQMU/UeaNF5w+hvK8lTtE+Iw
         eTvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795044954; x=1795649754;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1sqaAoxbPYdo18ldNOsiM1TbcJ03Gv+SVlc5ayXI+nY=;
        b=KW5Px6knGaZ0unESw0aNUoontrzZXtxs+xnT0MJ99IFcBB8glWCJj4+ySi8FufNQvl
         k6W7GSy+aeI59ziz+sBTRs70n4TgsvdddT2RExQhzTKqKXwmO7m5YSR0Xsz8GQtwjqgw
         393T8t2aBv/6M4S3W4uAlmHJn/UZJSiapOiCZcgWCdrEIMzo1QHYrLOAy4qglCaOeut4
         Jnu6lVpIN5maMoRUsfNRe6RG61/LIq0Cnfnea/xB8Hl0X+Nt/eBsVw2XP7vlYI4ABa8K
         iCt7Zu6AbIybGRoe4MyQOPHUh9wwLLNEYzkIYllgO5p0LD/pVUFcjI84AqPDGiHJfmEm
         01+A==
X-Forwarded-Encrypted: i=1; AL+hErH0FNeX61GKpQZBI8oj+KKXJUMpkbuqMBV+72yZX+Hx3rHVVg9fA7QzERxaWuNsojNFHyHSdzol+b0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/PxUKYt2EmTCXimr674PYRJ+6TQRxz+QpM0ZZpja/Y6fNLQ3Ke
	6sMX7FLgDNgNBXpBTYe2mv/GImo+to2+OKlIb4WEI7CpOAgzdvIWDZgtIf4jT56QcnywDKRm/dZ
	wYdGl/75GNwyBVCi30wrhzJtVEVVtD8zYvs46vTiaHVCoJNHqv/t6TfmXOLeziaWF12nsWQMR5L
	mWCE6lRgh9OLLJWjUl4pnrNISOnS6sX3wno0G+
X-Gm-Gg: AZFdTZeODX6I+lDyjUs1+Sf8Bas1XZGamHrfgSxk22pIssgZafdGTjCjrfeaYdb940U
	vIJoX0FyUYQ9/mi/k7uRnXXJ9T95ehTq+rdpX6GVKW5FgbZQ6GB+pjFMTC/A2FmTOncKy9/gOPh
	X0X9ecHB/6AlySvKHzDWrbHi+7rCCVEc+gpik6qHJgXool1BS8oLzbu+zplYbPnd4kDdab2tA36
	gQJ3ovSxxbWxsWE/FpJ6hnUxO2U0Yb+YiexhjHot+wPJQ==
X-Received: by 2002:a05:690e:128a:b0:679:2a90:d3ad with SMTP id 956f58d0204a3-67dd403bf8cmr1618032d50.102.1795044953736;
        Wed, 18 Nov 2026 15:35:53 -0800 (PST)
X-Received: by 2002:a05:690e:128a:b0:679:2a90:d3ad with SMTP id
 956f58d0204a3-67dd403bf8cmr1618023d50.102.1795044953295; Wed, 18 Nov 2026
 15:35:53 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116171044.6938-1-jack@suse.cz> <20261118145941.1063127-19-jack@suse.cz>
In-Reply-To: <20261118145941.1063127-19-jack@suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 19 Nov 2026 00:35:42 +0100
X-Gm-Features: AclHuK9zTsUN7zuq72-DSL1ny4jnrrzy1tFjBUU4DEu6A9maK7lyiUQZqwV6vuE
Message-ID: <CAHc6FU7NoZua98SGP9Kuga58gAcco6X__u=kOPfsUqbefAKLFQ@mail.gmail.com>
Subject: Re: [PATCH 06/13] gfs2: Avoid racy dirtiness check in gfs2_fsync()
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, devel@lists.orangefs.org, 
	Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	linux-afs@lists.infradead.org, Miklos Szeredi <miklos@szeredi.hu>, 
	fuse-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Wed, Nov 18, 2026 at 4:00=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> Check for I_DIRTY_PAGES state in gfs2_fsync() is racy because
> __writeback_single_inode() unconditionally clears the flag and
> reinstates it only later based on PAGECACHE_TAG_DIRTY tag. If
> gfs2_fsync() unlocked read of i_state hits in between, it will not see
> I_DIRTY_PAGES although there may be dirty folios in the mapping. Check
> for PAGECACHE_TAG_DIRTY instead and use inode_is_dirty() helper for
> inode metadata dirtiness check.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/gfs2/file.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index 1efd0679badd..f5532f72ab99 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -749,7 +749,7 @@ static int gfs2_fsync(struct file *file, loff_t start=
, loff_t end,
>  {
>         struct address_space *mapping =3D file->f_mapping;
>         struct inode *inode =3D mapping->host;
> -       int sync_state =3D inode_state_read_once(inode) & I_DIRTY;
> +       bool dirty_data =3D mapping_tagged(inode->i_mapping, PAGECACHE_TA=
G_DIRTY);
>         struct gfs2_glock *gl =3D gfs2_inode_glock(inode);
>         struct gfs2_inode *ip =3D GFS2_I(inode);
>         int ret =3D 0, ret1 =3D 0;
> @@ -760,12 +760,8 @@ static int gfs2_fsync(struct file *file, loff_t star=
t, loff_t end,
>                         return ret1;
>         }
>
> -       if (!gfs2_is_jdata(ip))
> -               sync_state &=3D ~I_DIRTY_PAGES;
> -       if (datasync)
> -               sync_state &=3D ~I_DIRTY_SYNC;
> -
> -       if (sync_state) {
> +       if (inode_is_dirty(inode, datasync) ||
> +           (gfs2_is_jdata(ip) && dirty_data)) {

this adds back the I_DIRTY_TIME check explicitly removed in commit:

3aac630b5ce1 ("gfs2: don't worry about I_DIRTY_TIME in gfs2_fsync()")

Could you please clarify what's going on?

>                 ret =3D sync_inode_metadata(inode, 1);
>                 if (ret)
>                         return ret;
> --
> 2.53.0
>

Thanks,
Andreas

