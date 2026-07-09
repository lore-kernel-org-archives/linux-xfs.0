Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E007A27B357
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783561215; cv=pass; b=Il+LuyS2nAXrn6Tnf/WFRJGyMnPKSG5NqwAwgeSQGEosqQ/GlQ7WODtY4EqNjLstUguAJRz6rEeYJWnkYdUEnEHSMllU6so5I+TF4z1j/vdHk3wZCHeHwPB0rRikPjx5umkvuQbJE09HWHXbdEXDOkoEgeOppoJqVVApPGIjg4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783561215; c=relaxed/simple;
	bh=FAw7qKP2dFBOHFvPeuoQTMUIxdc4qnVjuaC1V1Dr2q8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IZjr3ugWiLBAeZF4QY2MbV6sWoLAm0w+VIw5Ar2Xa8YS/iIVA16mGuoqbDsse5X8t0QJjSyzr/LLrqsJtgisRxQ9Hoy3MCG3sH+vsDxX2LuEHOMvgoI0ZRlIu3I6Z5QUn/j0FxDW+PkIsVKT6KgM9C4Vc112wIceIVKe/pHEvTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WX1w8ic5; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WX1w8ic5"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4629051c9d1so718469f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 18:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783561211; cv=none;
        d=google.com; s=arc-20260327;
        b=ATpFFdM8dbrTpleuAmuWHkr2oZlT3FIHGQ3AXmJZpPEVMe0ut2qCNr5PP3Uu+rcaou
         SSbYVWqmDFVE184Nc3+aDhhbXjPHC3j8WnVvikpVM0iYZcNmXBkfp30sYGgqRb7qlEJZ
         UDl1jZ3i18E3x5R/gEJ3TNGdwPPH5jFWoTTbDzfk+S0o/AlfjdGLpzoCE//E3Tn6Ljoy
         U6WZ08xK93he8QuC6OcPPFQZm1yj/8sUhcSpxgpZ7N8cC7rAO9odqlLnuiKE4HR5cUWS
         URMzLxQYF6TZH1OBpQIBQU2fCQZOIbJxGeVesOSGR/JqOzHmGH2OKRsuPY1zUfo/+Qhe
         zm2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f+BUX34CKxbFk60A1i2YpiIKQatBxz+O5YmZO7fhItw=;
        fh=GYP3FSfS2c+9mxxdzObsQH/UbklNHnJrvoxAPJX0wZQ=;
        b=f8UXAag8DaPNds4S97y3xLbCRQ/oMTaRD0nO1G0JkWVLn5m/Co6bLyxK5dVgQp5kNb
         Fgk0E4jyg6oHvdAp85hQkqqPV7QsB7dk9MJsS/U65mx6LxmJ9jkuIvP8E25aF6hB4JoT
         nvT2I7BFSgUdQfg4nNW5Rc/b9NnfFJtpHiZPp+4Yi3ItsmEDA6Wlp7gc4pSA719aFrmT
         OxSk09MBKe8D8Op+xWa9g+jxcOlK2r/R1lWbIKi4guNV+vy296p0at17lUR6g+DIF1Gg
         VLSI0T4w66BuZZdmmJpVv6pVbAGwCgcVmB/b7MOfuA5AnaSjz6Oa587Zi+k8xkElPSh5
         yNaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783561211; x=1784166011; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f+BUX34CKxbFk60A1i2YpiIKQatBxz+O5YmZO7fhItw=;
        b=WX1w8ic5G6W1un6bluQ6zU1EUFSYafKYnxCzOOlkCHm3t80HmjVjCGjhWYWOYDF1is
         u7udX6FUI4lyozyTXHWCHb+QE0eaSg1wvJLCwHn284iQMrH0vcEAsTwj+G90wPb2oTJV
         da72ZMoMpyCGHqp2Dt07QvOD1n5IJOA1qeDRMpXbxWnC2u3tQz2yFHZI0xwVrELF4RTk
         YQZBoUixmPW2RDZl9QUd0zd9+R0Om6Qs2jhtvYgmcXzxkgiDAl3eDn2TfjJFPI6GYw3v
         bHIfv8D+9nWsm5pk/ZSHNiXLOk19M5+hZywclE6cK0ruSA8vdw62m2/9N8xdvBVAFDgM
         A0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783561211; x=1784166011;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+BUX34CKxbFk60A1i2YpiIKQatBxz+O5YmZO7fhItw=;
        b=D566+fT2l1IBwCjCmUP1Fk+FUdn5EXUWP3HsfwRUl/8MsIAiIfhqZhv+hScRYmMHDm
         EuZxb2C7XgCTEsBHAqVUeY3fCuRsI0DnXQ6sZVlTasq2KQiYNU7yW79XWA3B3G3UwyDt
         lE9o9PF8qD83FQvhEd9Ekb6wVk5GrZ+uXdL4o10lPXzLbwHaxAMuBPMj43S7svdOlY8i
         umDPLgxF22iPZZwwXlO6tXO9IOjnGdxJB8/OL/9Hodopvr0ldNgqlfzOybhgZs57wpcB
         /yh0SIBBOlzkuwMyhjp6+529QQPc/QeBOf8J+1G+gHpy3oFRmuyqdPcCPI6SnwkuoPaa
         3lqA==
X-Forwarded-Encrypted: i=1; AHgh+RoqjRxLnHeLicJAye+XRX595gVexgTdQYA37cp6ij54Ql/V9L3j1aeL5/UPoQ7HsIsfNvjZQMAmffM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7UzJitbl81SXtgnbs7WsbSP0yrUY9YmrGbYGPObp00nL7oFvy
	EOMSySpLtsvERycI1JmheJcfG46AkuoRVUKgb4GK2Ahq9649rH//FXcixDoG2OLFDSat7W60yHM
	4xHVIhpz2XSWwWn+DoEm0nEQnr15ijm4=
X-Gm-Gg: AfdE7clFXcRtOYN8csQFpcEb/rIkk8WXuei3+k7i+o9jEsZOyG0vOYLJR16boJLEmnt
	7MjNAygH0bf3ukhkVMSWuJdYsUlUmpJPnz4lUbguI2mnXpMQoItTsZXpf4kBPMxxGIRcwXW0OQT
	NFyhzkfPQvXQUe8cEyT7cri+iYnN+/NN7JXBaGKBWsbm9d5KsK1Pfk6rDWj2UJ2+zHcjo3NJUL5
	MH27Xbzw+yvY1AqqO5h2k7461fwgahBZg/BWyhWZga200nHoO/Ju3JzWmMPCqPpzlvQzIwgDOrK
	0tD1tEWoNzkdVLOAwkn8o/3feeHB/L/dcbERaTpFCuyhQn71XQ9F
X-Received: by 2002:a05:6000:2287:b0:47d:ec60:6578 with SMTP id
 ffacd0b85a97d-47df08103bfmr5260726f8f.50.1783561211021; Wed, 08 Jul 2026
 18:40:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org>
 <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com>
 <akZ3GErzJSTtOn-H@infradead.org> <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e3ea485f.90a4.4656.9103.275b1cd29206@bytedance.com>
 <akettUm5gBD8nj56@infradead.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.a1148d7a.4a0d.4c6a.b14d.4583b6b728ce@bytedance.com>
 <CAJnrk1avS6qra8OvJdbexqM0xGT-FVZxVKe+TH4ZkFgfFv_oEQ@mail.gmail.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.20f172db.1248.4925.882c.ef1d31b23985@bytedance.com>
 <CAJnrk1aPS3Z_N+6Fto_B=Sgo6Wt62Cr6XHEwa-KzqjtQWyJ4Vg@mail.gmail.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.415a9a6d.e936.40be.8db9.f087f85da92f@bytedance.com>
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.415a9a6d.e936.40be.8db9.f087f85da92f@bytedance.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 18:39:59 -0700
X-Gm-Features: AUfX_mzK8xtjxJ1hhnjVr7MklnTNvX9ip_arnVBrF8CD5WwCfvmt0IwHJP0bfyo
Message-ID: <CAJnrk1ZfkewVA2qwLAmDi2GGH0Djv6OM-ch3bB1ftkhqtDeJfQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
To: changfengnan <changfengnan@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, brauner <brauner@kernel.org>, djwong <djwong@kernel.org>, 
	ojaswin <ojaswin@linux.ibm.com>, dgc <dgc@kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, 
	lidiangang@bytedance.com, "pankaj.raghav" <pankaj.raghav@linux.dev>, 
	Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 1:42=E2=80=AFAM changfengnan <changfengnan@bytedance=
.com> wrote:
>
>
> > From: "Joanne Koong"<joannelkoong@gmail.com>
> > Date:  Wed, Jul 8, 2026, 10:07
> > Subject:  Re: [PATCH v6 3/3] iomap: add simple dio path for small direc=
t I/O
> > To: "changfengnan"<changfengnan@bytedance.com>
> > Cc: "Christoph Hellwig"<hch@infradead.org>, "brauner"<brauner@kernel.or=
g>, "djwong"<djwong@kernel.org>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dg=
c@kernel.org>, "linux-xfs"<linux-xfs@vger.kernel.org>, "linux-fsdevel"<linu=
x-fsdevel@vger.kernel.org>, "linux-ext4"<linux-ext4@vger.kernel.org>, "linu=
x-kernel"<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, "panka=
j.raghav"<pankaj.raghav@linux.dev>, "Brian Foster"<bfoster@redhat.com>
> > On Mon, Jul 6, 2026 at 11:57=E2=80=AFPM changfengnan <changfengnan@byte=
dance.com> wrote:
> > >
> > >
> > > > From: "Joanne Koong"<joannelkoong@gmail.com>
> > > > Date:  Tue, Jul 7, 2026, 03:27
> > > > Subject:  Re: [PATCH v6 3/3] iomap: add simple dio path for small d=
irect I/O
> > > > To: "changfengnan"<changfengnan@bytedance.com>
> > > > Cc: "Christoph Hellwig"<hch@infradead.org>, "brauner"<brauner@kerne=
l.org>, "djwong"<djwong@kernel.org>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc=
"<dgc@kernel.org>, "linux-xfs"<linux-xfs@vger.kernel.org>, "linux-fsdevel"<=
linux-fsdevel@vger.kernel.org>, "linux-ext4"<linux-ext4@vger.kernel.org>, "=
linux-kernel"<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, "p=
ankaj.raghav"<pankaj.raghav@linux.dev>, "Brian Foster"<bfoster@redhat.com>
> > > > On Mon, Jul 6, 2026 at 4:10=E2=80=AFAM changfengnan <changfengnan@b=
ytedance.com> wrote:
> > > > >
> > > > > > From: "Christoph Hellwig"<hch@infradead.org>
> > > > > > Date:  Fri, Jul 3, 2026, 20:40
> > > > > > Subject:  Re: [PATCH v6 3/3] iomap: add simple dio path for sma=
ll direct I/O
> > > > > > To: "changfengnan"<changfengnan@bytedance.com>
> > > > > > Cc: "Joanne Koong"<joannelkoong@gmail.com>, "Christoph Hellwig"=
<hch@infradead.org>, "brauner"<brauner@kernel.org>, "djwong"<djwong@kernel.=
org>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dgc@kernel.org>, "linux-xfs"<=
linux-xfs@vger.kernel.org>, "linux-fsdevel"<linux-fsdevel@vger.kernel.org>,=
 "linux-ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger=
.kernel.org>, <lidiangang@bytedance.com>, "pankaj.raghav"<pankaj.raghav@lin=
ux.dev>, "Brian Foster"<bfoster@redhat.com>
> > > > > > On Fri, Jul 03, 2026 at 05:13:12PM +0800, changfengnan wrote:
> > > > > > > taken, which introduced some overhead.
> > > > > > > I implemented some optimizations based on Christoph=E2=80=99s=
 suggestions and
> > > > > > > made some modifications to `iomap_process`;
> > > > > > > Now, XFS performance is essentially unchanged, while ext4 sti=
ll shows a
> > > > > > > 1.5% drop; I will continue to investigate the cause..   I=E2=
=80=99ve attached the patch.
> > > > > > > Actually, I had expected that switching to `iomap_next` would=
 improve
> > > > > > > performance, since it avoids an indirect call.
> > > > > >
> > > > > > I don't think it will for you - the direct I/O readers don't ha=
ve
> > > > > > iomap_end methods, so you still have the same number of indirec=
t
> > > > > > calls.  What could help is to inline the iterator as seen in Jo=
annes'
> > > > > > fist demo series.  We could even look into doing that only for =
simple
> > > > > > dio in a first step, shifting the burden to use the simple meth=
od
> > > > > > to the callers (at least for the POC).
> > > > >
> > > > > I'm not sure if this is what you had in mind, but I made some
> > > > > adjustments referencing Joannes' first patch, and using this appr=
oach,
> > > > > there was no performance degradation.
> > > >
> > > > Thanks, Fengnan. This is awesome that it got the degradation down t=
o zero.
> > > >
> > > > Would you be able to test how this change performs on your benchmar=
ks?:
> > >
> > > XFS basically has no performance degradation, while ext4 experiences
> > > a 1-1.5% performance degradation.
> > >
> > > Round 1:
> > >     d67      xfs : 2.04M, 2.05M, 2.04M, 2.04M, 2.04M  avg=3D2.042M
> > >     d67      ext4: 2.12M, 2.12M, 2.12M, 2.12M, 2.12M  avg=3D2.120M
> > >     joanne86 xfs : 2.13M, 2.05M, 2.04M, 2.05M, 2.05M  avg=3D2.064M
> > >     joanne86 ext4: 2.11M, 2.11M, 2.11M, 2.11M, 2.11M  avg=3D2.110M
> > >
> > >   Round 2:
> > >     d67      xfs : 2.05M, 2.05M, 2.05M, 2.05M, 2.05M  avg=3D2.050M
> > >     d67      ext4: 2.12M, 2.12M, 2.12M, 2.12M, 2.12M  avg=3D2.120M
> > >     joanne86 xfs : 2.04M, 2.04M, 2.04M, 2.04M, 2.05M  avg=3D2.042M
> > >     joanne86 ext4: 2.09M, 2.08M, 2.09M, 2.10M, 2.09M  avg=3D2.090M
> > >
> > >   Round 3:
> > >     d67      xfs : 2.04M, 2.04M, 2.04M, 2.04M, 2.05M  avg=3D2.042M
> > >     d67      ext4: 2.12M, 2.12M, 2.11M, 2.12M, 2.12M  avg=3D2.118M
> > >     joanne86 xfs : 2.04M, 2.05M, 2.04M, 2.04M, 2.04M  avg=3D2.042M
> > >     joanne86 ext4: 2.09M, 2.09M, 2.08M, 2.09M, 2.09M  avg=3D2.088M
> > >
> >
> > Thanks. I'm not sure why it makes ext4 worse. Maybe it being inlined
> > bloats it too much so it leads to more frontend stalls/icache misses
> > than what the devirtualization helps with? Looking at the begin
> > functions, ext4's is around 2.5x larger than xfs's. It also looks like
> > ext4's read_iomap_begin function has 2 callers, so I think that may
> > not get automatically inlined whereas xfs's will since
> > xfs_read_iomap_begin just has 1 caller, though I don't know if that
> > ends up mattering.
>
> I ran two rounds of tests using your patch, and ext4 still showed a 1.5%
> performance drop.
> However, I think your analysis is correct=E2=80=94it=E2=80=99s likely cau=
sed by too many
> inline functions.  Inlining the simple DIO wrappers expands the filesyste=
m
> read_iter hot path and increases frontend/register pressure. Keeping the
> wrappers out of line adds only a cheap direct call, while preserving a sm=
aller
> and better laid-out filesystem hot path.
> So I made some changes, reverting `iomap_dio_rw()` and `iomap_dio_simple(=
)`
> to non-inline versions, and performance returned to normal.
>

Thanks for tracking this down, I'm glad it doesn't regress the fast
path anymore.

I'll put your name as the author of the patch, especially since you
did all the benchmarking too. I think I just need your legal
permission to add your Signed-off-by. Is that ok? I'll add a
Suggested-by: for christoph since he came up with a lot of the ideas
with IOMAP_DIO_NO_IOMAP_END, moving some of the iteration logic into
iomap_process, etc. I'll carry this in v3 of the iomap_next series.

Thanks,
Joanne

> Patch based on https://github.com/joannekoong/linux/commits/iomap_simple_=
dio_iomap_next_ext4/
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index bc3b87e57592a..d0f7ef8ac140a 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -968,6 +968,33 @@ static void iomap_dio_simple_end_io(struct bio *bio)
>          iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
>  }
>
> +static bool iomap_dio_simple_supported(struct kiocb *iocb,
> +                                       struct iov_iter *iter,
> +                                       const struct iomap_dio_ops *dops,
> +                                       unsigned int dio_flags,
> +                                       size_t done_before)
> +{
> +        struct inode *inode =3D file_inode(iocb->ki_filp);
> +        size_t count =3D iov_iter_count(iter);
> +
> +        if (dops || done_before)
> +                return false;
> +        if (iov_iter_rw(iter) !=3D READ)
> +                return false;
> +        if (!count)
> +                return false;
> +        if (count > inode->i_sb->s_blocksize)
> +                return false;
> +        if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
> +                         IOMAP_DIO_BOUNCE))
> +                return false;
> +        if (iocb->ki_pos + count > i_size_read(inode))
> +                return false;
> +        if (IS_ENCRYPTED(inode))
> +                return false;
> +        return true;
> +}
> +
>  static inline void
>  iomap_dio_simple_finish(struct iomap_iter *iomi, iomap_next_fn iomap_nex=
t,
>                  size_t written)
> @@ -978,7 +1005,7 @@ iomap_dio_simple_finish(struct iomap_iter *iomi, iom=
ap_next_fn iomap_next,
>          iomap_next(iomi, &iomi->iomap, &iomi->srcmap);
>  }
>
> -ssize_t
> +static ssize_t
>  __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
>                  struct iomap_iter *iomi, iomap_next_fn iomap_next,
>                  unsigned int dio_flags)
> @@ -1070,7 +1097,97 @@ __iomap_dio_simple(struct kiocb *iocb, struct iov_=
iter *iter,
>          inode_dio_end(inode);
>          return ret;
>  }
> -EXPORT_SYMBOL_GPL(__iomap_dio_simple);
> +
> +/*
> + * Fast path for small, block-aligned direct I/Os that map to a single
> + * contiguous on-disk extent.
> + *
> + * iomap_dio_simple_supported() enforces the cheap up-front constraints =
before
> + * entering this path.
> + *
> + * @dops must be NULL: a non-NULL @dops means the caller wants its
> + * ->end_io / ->submit_io hooks invoked, and in particular wants its bio=
s to be
> + * allocated from the filesystem-private @dops->bio_set (whose front_pad=
 sizes a
> + * filesystem-private wrapper around the bio).  The fast path instead al=
locates
> + * from the shared iomap_dio_simple_pool, whose front_pad matches struct
> + * iomap_dio_simple; the two wrappers are not interchangeable, so we mus=
t fall
> + * back to __iomap_dio_rw() in that case.
> + *
> + * @done_before must be zero: a non-zero caller-accumulated residual can=
not be
> + * carried through a single-bio inline completion.
> + *
> + * @iter must describe a non-empty READ no larger than the inode block s=
ize:
> + * writes, zero-length I/O, and larger requests need the generic iomap d=
irect
> + * I/O path.
> + *
> + * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, =
or
> + * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial =
direct
> + * I/O, or bouncing.  The range must also stay within i_size and encrypt=
ed
> + * inodes must use the generic iomap direct I/O path. IOMAP_DIO_NO_IOMAP=
_END is
> + * a fast-path optimization the caller can set if there is no work that =
needs to
> + * be done after a mapping.
> + *
> + * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when =
it
> + * decides the request does not fit the fast path.  In that case we proc=
eed to
> + * the generic __iomap_dio_rw() slow path.  Any other errno is a real re=
sult and
> + * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach=
 the
> + * caller.
> + */
> +static ssize_t iomap_dio_simple(struct kiocb *iocb,
> +                                struct iov_iter *iter, iomap_next_fn iom=
ap_next,
> +                                void *private, unsigned int dio_flags)
> +{
> +        struct inode *inode =3D file_inode(iocb->ki_filp);
> +        size_t count =3D iov_iter_count(iter);
> +        struct iomap_iter iomi =3D {
> +                .inode                =3D inode,
> +                .pos                =3D iocb->ki_pos,
> +                .len                =3D count,
> +                .flags                =3D IOMAP_DIRECT,
> +                .private        =3D private,
> +        };
> +        ssize_t ret;
> +
> +        if (iocb->ki_flags & IOCB_NOWAIT)
> +                iomi.flags |=3D IOMAP_NOWAIT;
> +
> +        ret =3D kiocb_write_and_wait(iocb, count);
> +        if (ret)
> +                return ret;
> +
> +        inode_dio_begin(inode);
> +
> +        ret =3D iomap_next(&iomi, &iomi.iomap, &iomi.srcmap);
> +        if (ret <=3D 0) {
> +                inode_dio_end(inode);
> +                /* a zero return means no mapping, which should never ha=
ppen */
> +                return ret ? ret : -EFAULT;
> +        }
> +
> +        return __iomap_dio_simple(iocb, iter, &iomi, iomap_next, dio_fla=
gs);
> +}
> +
> +ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> +                     iomap_next_fn iomap_next, const struct iomap_dio_op=
s *dops,
> +                     unsigned int dio_flags, void *private, size_t done_=
before)
> +{
> +        struct iomap_dio *dio;
> +        ssize_t ret;
> +
> +        if (iomap_dio_simple_supported(iocb, iter, dops, dio_flags, done=
_before)) {
> +                ret =3D iomap_dio_simple(iocb, iter, iomap_next, private=
,
> +                                       dio_flags);
> +                if (ret !=3D -ENOTBLK)
> +                        return ret;
> +        }
> +
> +        dio =3D __iomap_dio_rw(iocb, iter, iomap_next, dops, dio_flags,
> +                             private, done_before);
> +        if (IS_ERR_OR_NULL(dio))
> +                return PTR_ERR_OR_ZERO(dio);
> +        return iomap_dio_complete(dio);
> +}
> +EXPORT_SYMBOL_GPL(iomap_dio_rw);
>
>  static int __init iomap_dio_init(void)
>  {
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 6213a3b1a0b93..d6028722c54b2 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -615,126 +615,9 @@ struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb=
, struct iov_iter *iter,
>  ssize_t iomap_dio_complete(struct iomap_dio *dio);
>  void iomap_dio_bio_end_io(struct bio *bio);
>
> -static inline bool
> -iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
> -                           const struct iomap_dio_ops *dops,
> -                           unsigned int dio_flags, size_t done_before)
> -{
> -        struct inode *inode =3D file_inode(iocb->ki_filp);
> -        size_t count =3D iov_iter_count(iter);
> -
> -        if (dops || done_before)
> -                return false;
> -        if (iov_iter_rw(iter) !=3D READ)
> -                return false;
> -        if (!count)
> -                return false;
> -        if (count > inode->i_sb->s_blocksize)
> -                return false;
> -        if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
> -                         IOMAP_DIO_BOUNCE))
> -                return false;
> -        if (iocb->ki_pos + count > i_size_read(inode))
> -                return false;
> -        if (IS_ENCRYPTED(inode))
> -                return false;
> -        return true;
> -}
> -
> -ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> -                struct iomap_iter *iomi, iomap_next_fn iomap_next,
> -                unsigned int dio_flags);
> -
> -/*
> - * Fast path for small, block-aligned direct I/Os that map to a single
> - * contiguous on-disk extent.
> - *
> - * iomap_dio_simple_supported() enforces the cheap up-front constraints =
before
> - * entering this path.
> - *
> - * @dops must be NULL: a non-NULL @dops means the caller wants its
> - * ->end_io / ->submit_io hooks invoked, and in particular wants its bio=
s to be
> - * allocated from the filesystem-private @dops->bio_set (whose front_pad=
 sizes a
> - * filesystem-private wrapper around the bio).  The fast path instead al=
locates
> - * from the shared iomap_dio_simple_pool, whose front_pad matches struct
> - * iomap_dio_simple; the two wrappers are not interchangeable, so we mus=
t fall
> - * back to __iomap_dio_rw() in that case.
> - *
> - * @done_before must be zero: a non-zero caller-accumulated residual can=
not be
> - * carried through a single-bio inline completion.
> - *
> - * @iter must describe a non-empty READ no larger than the inode block s=
ize:
> - * writes, zero-length I/O, and larger requests need the generic iomap d=
irect
> - * I/O path.
> - *
> - * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, =
or
> - * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial =
direct
> - * I/O, or bouncing.  The range must also stay within i_size and encrypt=
ed
> - * inodes must use the generic iomap direct I/O path. IOMAP_DIO_NO_IOMAP=
_END is
> - * a fast-path optimization the caller can set if there is no work that =
needs to
> - * be done after a mapping.
> - *
> - * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when =
it
> - * decides the request does not fit the fast path.  In that case we proc=
eed to
> - * the generic __iomap_dio_rw() slow path.  Any other errno is a real re=
sult and
> - * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach=
 the
> - * caller.
> - */
> -static __always_inline ssize_t
> -iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> -                iomap_next_fn iomap_next, void *private, unsigned int di=
o_flags)
> -{
> -        struct inode *inode =3D file_inode(iocb->ki_filp);
> -        size_t count =3D iov_iter_count(iter);
> -        struct iomap_iter iomi =3D {
> -                .inode                =3D inode,
> -                .pos                =3D iocb->ki_pos,
> -                .len                =3D count,
> -                .flags                =3D IOMAP_DIRECT,
> -                .private        =3D private,
> -        };
> -        ssize_t ret;
> -
> -        if (iocb->ki_flags & IOCB_NOWAIT)
> -                iomi.flags |=3D IOMAP_NOWAIT;
> -
> -        ret =3D kiocb_write_and_wait(iocb, count);
> -        if (ret)
> -                return ret;
> -
> -        inode_dio_begin(inode);
> -
> -        ret =3D iomap_next(&iomi, &iomi.iomap, &iomi.srcmap);
> -        if (ret <=3D 0) {
> -                inode_dio_end(inode);
> -                /* a zero return means no mapping, which should never ha=
ppen */
> -                return ret ? ret : -EFAULT;
> -        }
> -
> -        return __iomap_dio_simple(iocb, iter, &iomi, iomap_next, dio_fla=
gs);
> -}
> -
> -static __always_inline ssize_t
> -iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, iomap_next_fn io=
map_next,
> -                const struct iomap_dio_ops *dops, unsigned int dio_flags=
,
> -                void *private, size_t done_before)
> -{
> -        struct iomap_dio *dio;
> -        ssize_t ret;
> -
> -        if (iomap_dio_simple_supported(iocb, iter, dops, dio_flags, done=
_before)) {
> -                ret =3D iomap_dio_simple(iocb, iter, iomap_next, private=
,
> -                                dio_flags);
> -                if (ret !=3D -ENOTBLK)
> -                        return ret;
> -        }
> -
> -        dio =3D __iomap_dio_rw(iocb, iter, iomap_next, dops, dio_flags, =
private,
> -                             done_before);
> -        if (IS_ERR_OR_NULL(dio))
> -                return PTR_ERR_OR_ZERO(dio);
> -        return iomap_dio_complete(dio);
> -}
> +ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> +                     iomap_next_fn iomap_next, const struct iomap_dio_op=
s *dops,
> +                     unsigned int dio_flags, void *private, size_t done_=
before);
>
>  #ifdef CONFIG_SWAP
>  struct file;
> --
>
> >
> > I'm seeing that ext4_iomap_begin is ~1570 bytes vs.
> > xfs_read_iomap_begin is ~635 bytes. It looks like though
> > ext4_iomap_begin is a combined read + write begin, whereas xfs's is a
> > dedicated read-only begin. If we separate ext4_iomap_begin into
> > dedicated read vs write begins, then I think this gets
> > ext4_read_iomap_begin down to ~230 bytes.
> >
> > Would you be able to test if this improves the ext4 performance you're =
seeing?:
> >
> > change #1: separate out ext4_iomap_begin into ext4_read/write_iomap_beg=
in
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 4c30dd8dbec7..54cdecbc7539 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3771,8 +3771,46 @@ static int ext4_iomap_alloc(struct inode
> > *inode, struct ext4_map_blocks *map,
> >  }
> >
> >
> > -static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t=
 length,
> > -               unsigned flags, struct iomap *iomap, struct iomap *srcm=
ap)
> > +static int ext4_read_iomap_begin(struct inode *inode, loff_t offset,
> > +               loff_t length, unsigned int flags, struct iomap *iomap,
> > +               struct iomap *srcmap)
> > +{
> > +       int ret;
> > +       struct ext4_map_blocks map;
> > +       u8 blkbits =3D inode->i_blkbits;
> > +
> > +       if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
> > +               return -EINVAL;
> > +
> > +       if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> > +               return -ERANGE;
> > +
> > +       /*
> > +        * Calculate the first and last logical blocks respectively.
> > +        */
> > +       map.m_lblk =3D offset >> blkbits;
> > +       map.m_len =3D min_t(loff_t, (offset + length - 1) >> blkbits,
> > +                         EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
> > +
> > +       ret =3D ext4_map_blocks(NULL, inode, &map, 0);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       /*
> > +        * When inline encryption is enabled, sometimes I/O to an encry=
pted file
> > +        * has to be broken up to guarantee DUN contiguity.  Handle thi=
s by
> > +        * limiting the length of the mapping returned.
> > +        */
> > +       map.m_len =3D fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_=
len);
> > +
> > +       ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> > +
> > +       return 0;
> > +}
> > +
> > +static int ext4_write_iomap_begin(struct inode *inode, loff_t offset,
> > +               loff_t length, unsigned int flags, struct iomap *iomap,
> > +               struct iomap *srcmap)
> >  {
> >         int ret;
> >         struct ext4_map_blocks map;
> > @@ -3793,37 +3831,33 @@ static int ext4_iomap_begin(struct inode
> > *inode, loff_t offset, loff_t length,
> >                           EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
> >         orig_mlen =3D map.m_len;
> >
> > -       if (flags & IOMAP_WRITE) {
> > +       /*
> > +        * We check here if the blocks are already allocated, then we
> > +        * don't need to start a journal txn and we can directly return
> > +        * the mapping information. This could boost performance
> > +        * especially in multi-threaded overwrite requests.
> > +        */
> > +       if (offset + length <=3D i_size_read(inode)) {
> > +               ret =3D ext4_map_blocks(NULL, inode, &map, 0);
> >                 /*
> > -                * We check here if the blocks are already allocated, t=
hen we
> > -                * don't need to start a journal txn and we can directl=
y return
> > -                * the mapping information. This could boost performanc=
e
> > -                * especially in multi-threaded overwrite requests.
> > +                * For DAX we convert extents to initialized ones befor=
e
> > +                * copying the data, otherwise we do it after I/O so
> > +                * there's no need to call into ext4_iomap_alloc().
> >                  */
> > -               if (offset + length <=3D i_size_read(inode)) {
> > -                       ret =3D ext4_map_blocks(NULL, inode, &map, 0);
> > +               if ((map.m_flags & EXT4_MAP_MAPPED) ||
> > +                   (!(flags & IOMAP_DAX) &&
> > +                    (map.m_flags & EXT4_MAP_UNWRITTEN))) {
> >                         /*
> > -                        * For DAX we convert extents to initialized on=
es before
> > -                        * copying the data, otherwise we do it after I=
/O so
> > -                        * there's no need to call into ext4_iomap_allo=
c().
> > +                        * For atomic writes the entire requested
> > +                        * length should be mapped.
> >                          */
> > -                       if ((map.m_flags & EXT4_MAP_MAPPED) ||
> > -                           (!(flags & IOMAP_DAX) &&
> > -                            (map.m_flags & EXT4_MAP_UNWRITTEN))) {
> > -                               /*
> > -                                * For atomic writes the entire request=
ed
> > -                                * length should be mapped.
> > -                                */
> > -                               if (ret =3D=3D orig_mlen ||
> > -                                   (!(flags & IOMAP_ATOMIC) && ret > 0=
))
> > -                                       goto out;
> > -                       }
> > -                       map.m_len =3D orig_mlen;
> > +                       if (ret =3D=3D orig_mlen ||
> > +                           (!(flags & IOMAP_ATOMIC) && ret > 0))
> > +                               goto out;
> >                 }
> > -               ret =3D ext4_iomap_alloc(inode, &map, flags);
> > -       } else {
> > -               ret =3D ext4_map_blocks(NULL, inode, &map, 0);
> > +               map.m_len =3D orig_mlen;
> >         }
> > +       ret =3D ext4_iomap_alloc(inode, &map, flags);
> >
> >         if (ret < 0)
> >                 return ret;
> > @@ -3850,6 +3884,16 @@ static int ext4_iomap_begin(struct inode
> > *inode, loff_t offset, loff_t length,
> >         return 0;
> >  }
> >
> > +static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t=
 length,
> > +               unsigned flags, struct iomap *iomap, struct iomap *srcm=
ap)
> > +{
> > +       if (flags & IOMAP_WRITE)
> > +               return ext4_write_iomap_begin(inode, offset, length, fl=
ags,
> > +                                             iomap, srcmap);
> > +       return ext4_read_iomap_begin(inode, offset, length, flags, ioma=
p,
> > +                                    srcmap);
> > +}
> > +
> >  int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *iomap=
,
> >                            struct iomap *srcmap)
> >  {
> >
> >
> > change #2: use ext4_read_iomap_next in iomap_dio_rw
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 755fde1baf03..bef2851d5466 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -4006,6 +4006,8 @@ static inline void
> > ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
> >
> >  int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *iomap=
,
> >                 struct iomap *srcmap);
> > +int ext4_read_iomap_next(const struct iomap_iter *iter, struct iomap *=
iomap,
> > +               struct iomap *srcmap);
> >  int ext4_iomap_next_report(const struct iomap_iter *iter, struct iomap=
 *iomap,
> >                 struct iomap *srcmap);
> >
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index bf0c18cf1017..48c6a76a16a1 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -91,7 +91,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb
> > *iocb, struct iov_iter *to)
> >                 return generic_file_read_iter(iocb, to);
> >         }
> >
> > -       ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next, NULL,
> > +       ret =3D iomap_dio_rw(iocb, to, ext4_read_iomap_next, NULL,
> >                            IOMAP_DIO_NO_IOMAP_END, NULL, 0);
> >         inode_unlock_shared(inode);
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 54cdecbc7539..6e7c77276d58 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3771,9 +3771,9 @@ static int ext4_iomap_alloc(struct inode *inode,
> > struct ext4_map_blocks *map,
> >  }
> >
> >
> > -static int ext4_read_iomap_begin(struct inode *inode, loff_t offset,
> > -               loff_t length, unsigned int flags, struct iomap *iomap,
> > -               struct iomap *srcmap)
> > +static __always_inline int ext4_read_iomap_begin(struct inode *inode,
> > +               loff_t offset, loff_t length, unsigned int flags,
> > +               struct iomap *iomap, struct iomap *srcmap)
> >  {
> >         int ret;
> >         struct ext4_map_blocks map;
> > @@ -3900,6 +3900,12 @@ int ext4_iomap_next(const struct iomap_iter
> > *iter, struct iomap *iomap,
> >         return iomap_process(iter, iomap, srcmap, ext4_iomap_begin, NUL=
L);
> >  }
> >
> > +int ext4_read_iomap_next(const struct iomap_iter *iter, struct iomap *=
iomap,
> > +                          struct iomap *srcmap)
> > +{
> > +       return iomap_process(iter, iomap, srcmap, ext4_read_iomap_begin=
, NULL);
> > +}
> > +
> >  static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
> >                                    loff_t length, unsigned int flags,
> >                                    struct iomap *iomap, struct iomap *s=
rcmap)
> >
> > The github link for the changes are in [1].
> >
> > Thanks for your patience with this!
> >
> > [1] https://github.com/joannekoong/linux/commits/iomap_simple_dio_iomap=
_next_ext4/
> >
