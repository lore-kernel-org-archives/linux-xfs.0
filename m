Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026393B47EE
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 02:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783476431; cv=pass; b=BTyp+rcEALF9bhPZt0jeW9i0EC/UgQ5TRnYm7fVlbv7MH6IEQYtqUkrn5osfFDNF4PSMGjuv/3aqvcq5VpMrvMEBwGXH48WqJITOQVihBun8bHWHbNBOt2Ee40y0k7e+MCisuhuUJM0Vh9A5yf5C/zDcf7PC1gHb2WhnNwwdxH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783476431; c=relaxed/simple;
	bh=a4s51OJSKt+NHGQxXJTYWDvPEeNPY/woXPXav6DxxX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XR5CWdfFroLuE9l/Zn6R/qkX4FnlfnuJ8xsbcYISdqLeY7oIktV+ejDMoVlVsOlA74Ge3aKUi26rIB5m2jhHaSLg1bI+evoGgfD0yqK8oEFf5dJrqhKTVbgGmC32uAvUotalAH7VxP22uXPNir3HdgzQXdS0dln9Xv0EPNpgILc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+R0WLlU; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+R0WLlU"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-474303f3c72so90722f8f.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 19:07:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783476427; cv=none;
        d=google.com; s=arc-20260327;
        b=AQXZx/i4wJ+UzoJ5KVL/sUiED/K9dNvCmG/DknVxWZGJDcfbAgz34hk4Ib+z7x+Xfe
         EDZ+SbaG2yOFzDoYjmf1PmebRXKW0KHcEJrxKVdKjtTEVLwq8NtdSP9HuFmP+iP11gvg
         wcj9PeWSSexvGke9yzeER+ErEz5tvk5R+nVZe2sRPDSJeXaVf4Wjey8iuR6RZ8g2Aqug
         ztkl7ye1m+5NhUi7Z+x2Na/K59th09keo5gArxJj+SMfNPqSpbkqrg6sNcj4q+f3T3Is
         ybWB2kcvSuJ0u6QmJPj2ufdD/E/jmrOqt7K96xfUXE3GCwM3pXj/ZzPmfly+AqOU7eQh
         Pcyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ORF6ttoTrmazHMg6VNy9Hoketi9Owk/y4zWX+03jHq4=;
        fh=Td26iJHwWF0EazbRJYI2SdhMNzUctOuE1LG0WjTpKI4=;
        b=p7ahSZ9GW3ueSOAScXk0x1UwcWi6IpD1S2rpgS6Q4Md+Uqj9xwbMxdO2dvt1hG2flJ
         kCqr55GJItSEswxHwBOxm4kvCiU2sI8mopg8dIoBdjzF0D3+EPsOu2x8GL/ib7TMIzXd
         nsH6P8uWoqYJ/Fx95IukjkYi3PH1kYNudTJKbffC4Qt45EKGBaFbTif/fmQyu0YIR4Jc
         lp9VTjWTmna1WXGKDUSK4EQBctlYqbbxai+FHz1Q5x5+V6wkKCHLLG2l7D2UzzKNTD+j
         dXF6Et9t+MhgvRUJL7031sVtCNdLu/n7tZXuE985zCFDN2SZZ2qovMAdqfY7l1rnSkgI
         xzaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783476427; x=1784081227; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ORF6ttoTrmazHMg6VNy9Hoketi9Owk/y4zWX+03jHq4=;
        b=V+R0WLlUWhLf3i9ucQ4ADMTQwP8A40RSGMCVqxIhZXv1LWn+KpAkmmcAN7EXcn2RSe
         YER2C6vrIyZGNpUi98VLnwi1NtjYeTg9mTd7xLWVGuhVqwi1WhXBJRmsNHtzkiY5zkGE
         RYN920y1l9gl8BrfuTAWI9qz5V4pAwozHF9guuVXRBQw6V7abEwLJ6Ae+IhtSRnybJNv
         DONZH1NgdiPBoenyeE+zQwisccRxYzExbbaXu90m3F3O1J55oNfFG0Mpl/Z6QFUnVX1+
         Ovu3hUAuUIP8zIAnnSf8WUQnF6voKrdPQtFg/sgJkohltOh6jriw5OYAd2XWXnOKiALg
         7Gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783476427; x=1784081227;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ORF6ttoTrmazHMg6VNy9Hoketi9Owk/y4zWX+03jHq4=;
        b=q/dWsDBxNQPPOO2KJ7jx1empQhsisJX9zLUQRxt8ASKwHbK4nvkwz7V0RxqnyILPVM
         R3T9S4TebaJEAxUP+vJiAULl9K0e62BMlndrkp2w7KTMMNz0BwREOaKCGHouX6ihDUB2
         vfCOqc8Sb28CzXlS8ZTzPBeQXQMvOoMK8CZDtEeX06mjFCkpsuKSfEr61ZVWAzOImc5d
         PfTdUZASY7jEl3p2SKRKcbx6gGLXmsTo3pY1Vo9+Q+Y7JUmf9YGZZWVjN+BwiqM9DIwn
         hN+Lb+IRjfdp1SZHzxfA7teWOHGTqK1rwx/nUR0tEycnbsLxSrnQeKmhai/OtS//TY9z
         LZjw==
X-Forwarded-Encrypted: i=1; AHgh+Rp3QHbUL3Yv/3B2iC5le/GNm8yQxNXpkFX4TaOM0ytQ8cwOr40H64AnOs8LMHwjDV+nGIho45joKKk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp0WcYocYCUo8+CEI5mrzIPtgNY1PSchJHQCRHjMI0+hdgx2sh
	ckR1FGP0cAVpNmYnU00evOiMCfOcz8XBfsw9dfOwFaK30Ej1audYnHBGO7KOtrvD98rXZJThiaF
	SSp8yIdnMrX4A9msHp6Md6VrLmt8W8/U=
X-Gm-Gg: AfdE7ckIxH2AkW7+SCDYevT/kRW34du2nySkM59K0CQVWqaledzGXDZVytEAPAbw9os
	jmc8sfV27OiD/mtkWFPizyik3c6gDeBS+V51LYSQMGjRlgAkezEoiXJFhBvITgWJ6gzs9Ng8dvK
	zXNAaAs0AjasrZfyvRvB69uPl/CJIM7a52pBVgCW97+QbxClkJtZ/aXbDPAe7uotUSjEdGVvYzV
	4OxRNltzNytvOiNsm2Hd1ZIRIwVDNSqsJkDi52lP0/t0hj47y3y2FPUazwBAEoulfvfgjRjlKRG
	4WBqlLASLZaE9+tyaO2jptZjJSKmD1QI+YENjzoXzkFod3PgDHQ+
X-Received: by 2002:a5d:5846:0:b0:47c:de1f:7ad1 with SMTP id
 ffacd0b85a97d-47df081e2b9mr171008f8f.57.1783476427128; Tue, 07 Jul 2026
 19:07:07 -0700 (PDT)
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
 <CAJnrk1avS6qra8OvJdbexqM0xGT-FVZxVKe+TH4ZkFgfFv_oEQ@mail.gmail.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.20f172db.1248.4925.882c.ef1d31b23985@bytedance.com>
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.20f172db.1248.4925.882c.ef1d31b23985@bytedance.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 7 Jul 2026 19:06:53 -0700
X-Gm-Features: AVVi8Ce9dVSv5gb-MmQR63RNcTJ_JQ4saHZsMR2pN8NmucDCrIPXFtHDdz5i5Mo
Message-ID: <CAJnrk1aPS3Z_N+6Fto_B=Sgo6Wt62Cr6XHEwa-KzqjtQWyJ4Vg@mail.gmail.com>
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

On Mon, Jul 6, 2026 at 11:57=E2=80=AFPM changfengnan <changfengnan@bytedanc=
e.com> wrote:
>
>
> > From: "Joanne Koong"<joannelkoong@gmail.com>
> > Date:  Tue, Jul 7, 2026, 03:27
> > Subject:  Re: [PATCH v6 3/3] iomap: add simple dio path for small direc=
t I/O
> > To: "changfengnan"<changfengnan@bytedance.com>
> > Cc: "Christoph Hellwig"<hch@infradead.org>, "brauner"<brauner@kernel.or=
g>, "djwong"<djwong@kernel.org>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dg=
c@kernel.org>, "linux-xfs"<linux-xfs@vger.kernel.org>, "linux-fsdevel"<linu=
x-fsdevel@vger.kernel.org>, "linux-ext4"<linux-ext4@vger.kernel.org>, "linu=
x-kernel"<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, "panka=
j.raghav"<pankaj.raghav@linux.dev>, "Brian Foster"<bfoster@redhat.com>
> > On Mon, Jul 6, 2026 at 4:10=E2=80=AFAM changfengnan <changfengnan@byted=
ance.com> wrote:
> > >
> > > > From: "Christoph Hellwig"<hch@infradead.org>
> > > > Date:  Fri, Jul 3, 2026, 20:40
> > > > Subject:  Re: [PATCH v6 3/3] iomap: add simple dio path for small d=
irect I/O
> > > > To: "changfengnan"<changfengnan@bytedance.com>
> > > > Cc: "Joanne Koong"<joannelkoong@gmail.com>, "Christoph Hellwig"<hch=
@infradead.org>, "brauner"<brauner@kernel.org>, "djwong"<djwong@kernel.org>=
, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dgc@kernel.org>, "linux-xfs"<linu=
x-xfs@vger.kernel.org>, "linux-fsdevel"<linux-fsdevel@vger.kernel.org>, "li=
nux-ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.ker=
nel.org>, <lidiangang@bytedance.com>, "pankaj.raghav"<pankaj.raghav@linux.d=
ev>, "Brian Foster"<bfoster@redhat.com>
> > > > On Fri, Jul 03, 2026 at 05:13:12PM +0800, changfengnan wrote:
> > > > > taken, which introduced some overhead.
> > > > > I implemented some optimizations based on Christoph=E2=80=99s sug=
gestions and
> > > > > made some modifications to `iomap_process`;
> > > > > Now, XFS performance is essentially unchanged, while ext4 still s=
hows a
> > > > > 1.5% drop; I will continue to investigate the cause..   I=E2=80=
=99ve attached the patch.
> > > > > Actually, I had expected that switching to `iomap_next` would imp=
rove
> > > > > performance, since it avoids an indirect call.
> > > >
> > > > I don't think it will for you - the direct I/O readers don't have
> > > > iomap_end methods, so you still have the same number of indirect
> > > > calls.  What could help is to inline the iterator as seen in Joanne=
s'
> > > > fist demo series.  We could even look into doing that only for simp=
le
> > > > dio in a first step, shifting the burden to use the simple method
> > > > to the callers (at least for the POC).
> > >
> > > I'm not sure if this is what you had in mind, but I made some
> > > adjustments referencing Joannes' first patch, and using this approach=
,
> > > there was no performance degradation.
> >
> > Thanks, Fengnan. This is awesome that it got the degradation down to ze=
ro.
> >
> > Would you be able to test how this change performs on your benchmarks?:
>
> XFS basically has no performance degradation, while ext4 experiences
> a 1-1.5% performance degradation.
>
> Round 1:
>     d67      xfs : 2.04M, 2.05M, 2.04M, 2.04M, 2.04M  avg=3D2.042M
>     d67      ext4: 2.12M, 2.12M, 2.12M, 2.12M, 2.12M  avg=3D2.120M
>     joanne86 xfs : 2.13M, 2.05M, 2.04M, 2.05M, 2.05M  avg=3D2.064M
>     joanne86 ext4: 2.11M, 2.11M, 2.11M, 2.11M, 2.11M  avg=3D2.110M
>
>   Round 2:
>     d67      xfs : 2.05M, 2.05M, 2.05M, 2.05M, 2.05M  avg=3D2.050M
>     d67      ext4: 2.12M, 2.12M, 2.12M, 2.12M, 2.12M  avg=3D2.120M
>     joanne86 xfs : 2.04M, 2.04M, 2.04M, 2.04M, 2.05M  avg=3D2.042M
>     joanne86 ext4: 2.09M, 2.08M, 2.09M, 2.10M, 2.09M  avg=3D2.090M
>
>   Round 3:
>     d67      xfs : 2.04M, 2.04M, 2.04M, 2.04M, 2.05M  avg=3D2.042M
>     d67      ext4: 2.12M, 2.12M, 2.11M, 2.12M, 2.12M  avg=3D2.118M
>     joanne86 xfs : 2.04M, 2.05M, 2.04M, 2.04M, 2.04M  avg=3D2.042M
>     joanne86 ext4: 2.09M, 2.09M, 2.08M, 2.09M, 2.09M  avg=3D2.088M
>

Thanks. I'm not sure why it makes ext4 worse. Maybe it being inlined
bloats it too much so it leads to more frontend stalls/icache misses
than what the devirtualization helps with? Looking at the begin
functions, ext4's is around 2.5x larger than xfs's. It also looks like
ext4's read_iomap_begin function has 2 callers, so I think that may
not get automatically inlined whereas xfs's will since
xfs_read_iomap_begin just has 1 caller, though I don't know if that
ends up mattering.

I'm seeing that ext4_iomap_begin is ~1570 bytes vs.
xfs_read_iomap_begin is ~635 bytes. It looks like though
ext4_iomap_begin is a combined read + write begin, whereas xfs's is a
dedicated read-only begin. If we separate ext4_iomap_begin into
dedicated read vs write begins, then I think this gets
ext4_read_iomap_begin down to ~230 bytes.

Would you be able to test if this improves the ext4 performance you're seei=
ng?:

change #1: separate out ext4_iomap_begin into ext4_read/write_iomap_begin

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4c30dd8dbec7..54cdecbc7539 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3771,8 +3771,46 @@ static int ext4_iomap_alloc(struct inode
*inode, struct ext4_map_blocks *map,
 }


-static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t len=
gth,
-               unsigned flags, struct iomap *iomap, struct iomap *srcmap)
+static int ext4_read_iomap_begin(struct inode *inode, loff_t offset,
+               loff_t length, unsigned int flags, struct iomap *iomap,
+               struct iomap *srcmap)
+{
+       int ret;
+       struct ext4_map_blocks map;
+       u8 blkbits =3D inode->i_blkbits;
+
+       if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
+               return -EINVAL;
+
+       if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
+               return -ERANGE;
+
+       /*
+        * Calculate the first and last logical blocks respectively.
+        */
+       map.m_lblk =3D offset >> blkbits;
+       map.m_len =3D min_t(loff_t, (offset + length - 1) >> blkbits,
+                         EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
+
+       ret =3D ext4_map_blocks(NULL, inode, &map, 0);
+       if (ret < 0)
+               return ret;
+
+       /*
+        * When inline encryption is enabled, sometimes I/O to an encrypted=
 file
+        * has to be broken up to guarantee DUN contiguity.  Handle this by
+        * limiting the length of the mapping returned.
+        */
+       map.m_len =3D fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len)=
;
+
+       ext4_set_iomap(inode, iomap, &map, offset, length, flags);
+
+       return 0;
+}
+
+static int ext4_write_iomap_begin(struct inode *inode, loff_t offset,
+               loff_t length, unsigned int flags, struct iomap *iomap,
+               struct iomap *srcmap)
 {
        int ret;
        struct ext4_map_blocks map;
@@ -3793,37 +3831,33 @@ static int ext4_iomap_begin(struct inode
*inode, loff_t offset, loff_t length,
                          EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
        orig_mlen =3D map.m_len;

-       if (flags & IOMAP_WRITE) {
+       /*
+        * We check here if the blocks are already allocated, then we
+        * don't need to start a journal txn and we can directly return
+        * the mapping information. This could boost performance
+        * especially in multi-threaded overwrite requests.
+        */
+       if (offset + length <=3D i_size_read(inode)) {
+               ret =3D ext4_map_blocks(NULL, inode, &map, 0);
                /*
-                * We check here if the blocks are already allocated, then =
we
-                * don't need to start a journal txn and we can directly re=
turn
-                * the mapping information. This could boost performance
-                * especially in multi-threaded overwrite requests.
+                * For DAX we convert extents to initialized ones before
+                * copying the data, otherwise we do it after I/O so
+                * there's no need to call into ext4_iomap_alloc().
                 */
-               if (offset + length <=3D i_size_read(inode)) {
-                       ret =3D ext4_map_blocks(NULL, inode, &map, 0);
+               if ((map.m_flags & EXT4_MAP_MAPPED) ||
+                   (!(flags & IOMAP_DAX) &&
+                    (map.m_flags & EXT4_MAP_UNWRITTEN))) {
                        /*
-                        * For DAX we convert extents to initialized ones b=
efore
-                        * copying the data, otherwise we do it after I/O s=
o
-                        * there's no need to call into ext4_iomap_alloc().
+                        * For atomic writes the entire requested
+                        * length should be mapped.
                         */
-                       if ((map.m_flags & EXT4_MAP_MAPPED) ||
-                           (!(flags & IOMAP_DAX) &&
-                            (map.m_flags & EXT4_MAP_UNWRITTEN))) {
-                               /*
-                                * For atomic writes the entire requested
-                                * length should be mapped.
-                                */
-                               if (ret =3D=3D orig_mlen ||
-                                   (!(flags & IOMAP_ATOMIC) && ret > 0))
-                                       goto out;
-                       }
-                       map.m_len =3D orig_mlen;
+                       if (ret =3D=3D orig_mlen ||
+                           (!(flags & IOMAP_ATOMIC) && ret > 0))
+                               goto out;
                }
-               ret =3D ext4_iomap_alloc(inode, &map, flags);
-       } else {
-               ret =3D ext4_map_blocks(NULL, inode, &map, 0);
+               map.m_len =3D orig_mlen;
        }
+       ret =3D ext4_iomap_alloc(inode, &map, flags);

        if (ret < 0)
                return ret;
@@ -3850,6 +3884,16 @@ static int ext4_iomap_begin(struct inode
*inode, loff_t offset, loff_t length,
        return 0;
 }

+static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t len=
gth,
+               unsigned flags, struct iomap *iomap, struct iomap *srcmap)
+{
+       if (flags & IOMAP_WRITE)
+               return ext4_write_iomap_begin(inode, offset, length, flags,
+                                             iomap, srcmap);
+       return ext4_read_iomap_begin(inode, offset, length, flags, iomap,
+                                    srcmap);
+}
+
 int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
                           struct iomap *srcmap)
 {


change #2: use ext4_read_iomap_next in iomap_dio_rw

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 755fde1baf03..bef2851d5466 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4006,6 +4006,8 @@ static inline void
ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)

 int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
                struct iomap *srcmap);
+int ext4_read_iomap_next(const struct iomap_iter *iter, struct iomap *ioma=
p,
+               struct iomap *srcmap);
 int ext4_iomap_next_report(const struct iomap_iter *iter, struct iomap *io=
map,
                struct iomap *srcmap);

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bf0c18cf1017..48c6a76a16a1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -91,7 +91,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb
*iocb, struct iov_iter *to)
                return generic_file_read_iter(iocb, to);
        }

-       ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next, NULL,
+       ret =3D iomap_dio_rw(iocb, to, ext4_read_iomap_next, NULL,
                           IOMAP_DIO_NO_IOMAP_END, NULL, 0);
        inode_unlock_shared(inode);

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 54cdecbc7539..6e7c77276d58 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3771,9 +3771,9 @@ static int ext4_iomap_alloc(struct inode *inode,
struct ext4_map_blocks *map,
 }


-static int ext4_read_iomap_begin(struct inode *inode, loff_t offset,
-               loff_t length, unsigned int flags, struct iomap *iomap,
-               struct iomap *srcmap)
+static __always_inline int ext4_read_iomap_begin(struct inode *inode,
+               loff_t offset, loff_t length, unsigned int flags,
+               struct iomap *iomap, struct iomap *srcmap)
 {
        int ret;
        struct ext4_map_blocks map;
@@ -3900,6 +3900,12 @@ int ext4_iomap_next(const struct iomap_iter
*iter, struct iomap *iomap,
        return iomap_process(iter, iomap, srcmap, ext4_iomap_begin, NULL);
 }

+int ext4_read_iomap_next(const struct iomap_iter *iter, struct iomap *ioma=
p,
+                          struct iomap *srcmap)
+{
+       return iomap_process(iter, iomap, srcmap, ext4_read_iomap_begin, NU=
LL);
+}
+
 static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
                                   loff_t length, unsigned int flags,
                                   struct iomap *iomap, struct iomap *srcma=
p)

The github link for the changes are in [1].

Thanks for your patience with this!

[1] https://github.com/joannekoong/linux/commits/iomap_simple_dio_iomap_nex=
t_ext4/
