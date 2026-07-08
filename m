Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B42D40928B
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783526999; cv=pass; b=OFoS6WlJnf+G0CMYXP5aAhioUaNClL+ZAafSzmTGmp5Dkf6qpBjO6Axw+pCufZFdF3CWN9LQ6jaI7b7Mv9UAjZXlB1HUpvsOIFK9mJ+8YVb7b9BwBmpzNrFE0wH2QVxT1iK6/TGMxRiIOdcseGgM9PTjQagAh45XkdCwDUi+ZB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783526999; c=relaxed/simple;
	bh=/cCoEIAMZjgDwndNc5TH4+TopiGNAKrc5bmeS1zi6bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VG+rm1KzUJ/CxwIbXg1RH2lGMG5K2eGSH42IaGekbpwBeMm+c6jsTNxYaaTpjIF4l+skg3VDUNH+Ck1+bFmIYdLvHx1l0fLxh8HLKujva8MLV/6oez0yw5ciAD5noT4Ux1SgWJ0O8L9ygHW/1ftlObwPPThpy0Zd9PiegpWTJ4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fay8I8/v; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fay8I8/v"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-698b558a792so1074012a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 09:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783526996; cv=none;
        d=google.com; s=arc-20260327;
        b=OXcxxY5YxbY3Qa5gSWxMmCluZqpc27Qz4P0qlNY9bwMjYkWx7zWJ4OQc1TtxJ68tV/
         kfynLjPeBwwj0vSRXEIWnbF9anCmojSgFEh0OfoxMctvoRkVJHo1hTZafOg9Qwt11sHu
         hadnzLfbSZLiwwO5vmFIIKPjWjhaa1YhDN9GwQfFgyQXBJD/m8/vyZmpFb17VK1wd8n9
         thM2sgZvWrYoK6i1qkEAzbDXvT8NmO6Bqmql30wOcf4qvz+EWWV7UP0x4MEHUMh71i6o
         8bGEsaQu0s45RyJVazx+jLWANuC8G6EislYvQVRd4Gof2LWYyS+KDV8me4ayThBYyPYM
         Vhiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NhVUTGb4dwhaH+1X487bCAmqqigGbO5f/feF/gmVFJ4=;
        fh=HWKBeFGTW9AWNI1e4tfQS9Zvs6BxsiFxjjfVG3FkASM=;
        b=Viqff//wIw6VFVzNC+hwCxsEAzI4hndy4TISEK2S8bFKf7tQitsdxIhZ+Bp23dMECH
         qymq/eXDWWTJN5FA/tMt/30SjA023PSRWWs9KzbopHRvP0sAO0EraFZa2LULHzqtJjqt
         4++hbzfgZUgac3kXcs1ekXgK1ZuvQ29v6RIewfvvGdDYt2E/rCRK8RqnR36V34HCGzxX
         /NB7eFba1B7wLfg5onrS0uWK8mTW9ArlIARLVua2dceBLCegocz51Vp2rgsZG/ZJqMWF
         KfJTpVZYdpyW9cfYntjs3JLblXETgyTuhNUVwPz4S2jqgEmvldSmlG7UmtcxhpWMO3rV
         2KxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783526996; x=1784131796; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NhVUTGb4dwhaH+1X487bCAmqqigGbO5f/feF/gmVFJ4=;
        b=Fay8I8/vpDP1QBgBTTYX0h13G/I/vEu+ovK0C+YLKeZIv55mE7xkQv3XU22t64LuOZ
         JzNANBMWND42Ka0ImxBBmyOUpDIksGdM/SnT7cYmFSsAv21eVm1brGwuRoL8S82LlM81
         55GnewrZEcKYNiHhqZUjxa30JTtESyft+waSM9Goe6tpjXYRdztl9Hja0fVGUvpe6/JW
         /1alxPL/NuHRGfsLUbABdW0+z6zh2UmFGBBWkLv8v4/MqvgJT8jFVE5cdBaRnUqDrfVz
         sqTFwF+/Dpoz23CoJwxe+SoW07tVA1CSVyrWyPF9i6ZHxFs9OH+yhK59IlqzwGVf9BRO
         SoNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783526996; x=1784131796;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NhVUTGb4dwhaH+1X487bCAmqqigGbO5f/feF/gmVFJ4=;
        b=oJc98fwNM0Ph3ToMt2+fkVoDgLaoXKomqeJ1Pxzd5dmh6PoT+r6LPzzf+a4VeGDMYV
         uZp30zuQ2p6m1Wv3NGIICkngdsUnpXg1U0mFaqITh0sWdV5BtUy5IwRG8BG0IVKEcbjl
         1PA/62F8HI796byr3NXr0DSipAl+9M+hyLujD+Fp96o0F7+wmS0P/E7v+TMElNOU7rNq
         bJ5hUbaGvhswNUXC/9dyOYzJm30LZvhEZwr4ogWMaVhRubqRgTtppQbQQ8r+oRabeOlz
         JI0XZNGuEtohNtTiJKQPgJS9FK8nyDV4yqN7tFh4B7s9jzd/cQOW5tj5zCm55yjCj6+c
         j2nQ==
X-Forwarded-Encrypted: i=1; AHgh+RrgyLYp0WKEN6j6SFzwh1qSCMC76xysYmgKPQU4fiByRcJAoZf5vQeKgsoP5GYH51KPPy9x1AkmD5c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8DmgCsMq30E9BXpgg9UH42uJllJ3AyFhPpladc0hGGgQg8fKs
	jjpD8RBST3gb8o3rU/0S3EWhKfwePdLcfR3ETD72+TONs6D9NafdXox0RPBPdL9AoujESPHar/y
	XQmCQmnmOYdsGBxhKDwRdbtprTdf1fYo=
X-Gm-Gg: AfdE7ckZFHXqTLAzKTk35JX2VDmri4yF09bLVCzPE2yJmYtXfTFG/Sxt0ETMCaqp8qQ
	1wIjYUXLMIdwm25N7FR/Iwu3DsDZXp4Pj06uWKUcVsgUVDDr8RfHz3DMLY10ZQHV4u1s4jyy+px
	uk2kkaf/876iIKDmaIxjMdKjBlV9+0YPxWh752CrqyOdBLSxPr3Ctax4Q1pdk5MDvg4JmbWcRQy
	AAHSuUVetXTjjxeL/Z3Tx1+BRgju+XwooMs2RyQt9+5yQacYEac5USfMT0p/NpII+2JCqrbci47
	CI2jj9ZGbDeYntlVKeSmZStSLzJL
X-Received: by 2002:a17:907:9709:b0:c15:dc92:5df with SMTP id
 a640c23a62f3a-c15dc9207cfmr57067666b.49.1783526995710; Wed, 08 Jul 2026
 09:09:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707180235.1142581-4-bestswngs@gmail.com> <20260708052855.GF9392@frogsfrogsfrogs>
In-Reply-To: <20260708052855.GF9392@frogsfrogsfrogs>
From: Weiming Shi <bestswngs@gmail.com>
Date: Thu, 9 Jul 2026 00:09:18 +0800
X-Gm-Features: AVVi8Cc62Fx0LBjbFwac7xQonQf9upQeMKEfyzwrMHGOC-FWNYnt6BGYtL2Isds
Message-ID: <CANgPUi2ydzD7P_agT_c5EACVbjqZ=ujsr0W6TYsBsMYjqiw9zQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: reject attr leaf blocks with inconsistent usedbytes
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
	Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B47=E6=9C=888=E6=97=
=A5=E5=91=A8=E4=B8=89 13:28=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Jul 07, 2026 at 11:02:38AM -0700, Weiming Shi wrote:
> > xfs_attr3_leaf_verify() checks each attr leaf entry on its own, but nev=
er
> > checks that the entries' nameval regions are disjoint. A crafted leaf c=
an
> > point several entries at overlapping offsets: every entry passes the
> > per-entry check, yet the summed entry sizes far exceed the nameval regi=
on.
> >
> > ichdr.usedbytes is kept as the exact sum of the entries'
> > xfs_attr_leaf_entsize() (see xfs_attr3_leaf_add()), so for such a leaf =
the
> > real sum no longer matches usedbytes. When the leaf is later repacked,
> > xfs_attr3_leaf_compact() resets firstused to blksize and calls
> > xfs_attr3_leaf_moveents(), which subtracts each entry size from firstus=
ed;
> > the oversized sum underflows the 32-bit firstused and the following mem=
move
> > writes out of bounds. The same repack runs from xfs_attr3_leaf_rebalanc=
e()
> > and xfs_attr3_leaf_unbalance(). The only guard is an ASSERT, which is
> > compiled out on production kernels.
> >
> > A single setxattr() on a file with such a leaf, after mounting a crafte=
d
> > image, triggers the write:
> >
> >   BUG: KASAN: use-after-free in xfs_attr3_leaf_moveents (fs/xfs/libxfs/=
xfs_attr_leaf.c:2788)
> >   Write of size 400 at addr ffff88802b187f98 by task exploit
> >    xfs_attr3_leaf_moveents (fs/xfs/libxfs/xfs_attr_leaf.c:2788)
> >    xfs_attr3_leaf_compact (fs/xfs/libxfs/xfs_attr_leaf.c:1790)
> >    xfs_attr3_leaf_add (fs/xfs/libxfs/xfs_attr_leaf.c:1563)
> >    xfs_attr_set_iter (fs/xfs/libxfs/xfs_attr.c:556)
> >    xfs_attr_set (fs/xfs/libxfs/xfs_attr.c:1244)
> >    xfs_xattr_set (fs/xfs/xfs_xattr.c:186)
> >    __vfs_setxattr (fs/xattr.c:218)
> >    vfs_setxattr (fs/xattr.c:339)
> >    __x64_sys_fsetxattr (fs/xattr.c:774)
> >
> > Sum the entry sizes while verifying and reject the leaf unless the sum
> > equals usedbytes (so the on-disk usedbytes can be trusted) and that
> > usedbytes fits in the nameval region [firstused, blksize) (so the trust=
ed
> > value cannot drive firstused below zero).  Both checks are required: th=
e
> > first alone can be bypassed by forging usedbytes to equal the real sum,=
 and
> > the second alone by forging a small usedbytes, so only together do they
> > bound the actual summed entry size against the nameval region and preve=
nt
> > the underflow.
> >
> > Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Assisted-by: Claude:claude-opus-4-8
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> > v2: drop the inaccurate scrubber reference; explain why both checks are
> >     needed. No code change.
> >
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_lea=
f.c
> > index 86c5c09a5db4..9814dcfbd7ac 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -300,7 +300,8 @@ xfs_attr3_leaf_verify_entry(
> >       struct xfs_attr3_icleaf_hdr             *leafhdr,
> >       struct xfs_attr_leaf_entry              *ent,
> >       int                                     idx,
> > -     __u32                                   *last_hashval)
> > +     __u32                                   *last_hashval,
> > +     unsigned int                            *usedbytes)
> >  {
> >       struct xfs_attr_leaf_name_local         *lentry;
> >       struct xfs_attr_leaf_name_remote        *rentry;
> > @@ -344,6 +345,7 @@ xfs_attr3_leaf_verify_entry(
> >       if (name_end > buf_end)
> >               return __this_address;
> >
> > +     *usedbytes +=3D namesize;
> >       return NULL;
> >  }
> >
> > @@ -376,6 +378,7 @@ xfs_attr3_leaf_verify(
> >       char                            *buf_end;
> >       uint32_t                        end;    /* must be 32bit - see be=
low */
> >       __u32                           last_hashval =3D 0;
> > +     unsigned int                    usedbytes =3D 0;
> >       int                             i;
> >       xfs_failaddr_t                  fa;
> >
> > @@ -410,11 +413,21 @@ xfs_attr3_leaf_verify(
> >       buf_end =3D (char *)bp->b_addr + mp->m_attr_geo->blksize;
> >       for (i =3D 0, ent =3D entries; i < ichdr.count; ent++, i++) {
> >               fa =3D xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ic=
hdr,
> > -                             ent, i, &last_hashval);
> > +                             ent, i, &last_hashval, &usedbytes);
> >               if (fa)
> >                       return fa;
> >       }
> >
> > +     /*
> > +      * usedbytes must equal the summed entry sizes and fit in the
> > +      * nameval region; otherwise a later repack underflows firstused
> > +      * in xfs_attr3_leaf_moveents().
> > +      */
> > +     if (usedbytes !=3D ichdr.usedbytes)
> > +             return __this_address;
>
> This part is clearly correct.
>
> > +     if (ichdr.usedbytes > mp->m_attr_geo->blksize - ichdr.firstused)
>
> This check is still novel to me -- neither online fsck nor xfs_repair
> check this explicitly.  It makes sense to me that usedbytes can't exceed
> the number of bytes between the start of the nameval data and the end of
> the block (the entries array grows up from zero; namevals grow down from
> $blocksize).
>
> I wonder, will this make it harder to salvage xattrs from a broken leaf
> block since the verifier won't work?  I think it won't because the
> salvage operation does an xfs_buf read with null ops, but I wonder if
> you've considered this point?  Or run this through the xattr stress
> tests?
>
> --D
>
> > +             return __this_address;
> > +
> >       /*
> >        * Quickly check the freemap information.  Attribute data has to =
be
> >        * aligned to 4-byte boundaries, and likewise for the free space.
> > --
> > 2.43.0
> >
> >

Hi,

Yeah, it does affect salvage. The read uses NULL ops, but
xrep_xattr_recover_block() gates recovery on xrep_buf_verify_struct(), whic=
h
runs the verifier including my checks. So a leaf that fails the usedbytes
check never reaches xrep_xattr_recover_leaf(), and a leaf that's only off i=
n
usedbytes (entries otherwise fine) now gets tossed instead of salvaged.
That's in attr_repair.c, not this patch, so the verifier change itself
doesn't need to move. I didn't want to poke at the salvage gate blindly
since it leans on the verifier for the firstused/count bounds too, so how d=
o
you want to handle it?

On stress: I ran fsstress on the patched KASAN kernel, weighted toward the
attr ops (setxattr/removexattr/setfattr etc), 4 rounds of -n 5000 -p 4,
unmounting and remounting between rounds to force re-verify. All rc=3D0, no
EFSCORRUPTED, nothing from the verifier. Haven't done a full auto run.

Best,
Weiming Shi
