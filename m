Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0630B2F3E;
	Sun, 17 Nov 2024 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731807332; cv=none; b=AUaQQw5hS3dw9qydWJfyaHRJft2ZFKkQKR8bx+9TvxrI75REGoZuDABf83RgZHT2rdRoO3hrEr868Ikh9qoUlyWGKLjadscOEPPBVXgZ+cVMC5ahXFVlDUq6lacqKN+6krq/+9CcMIFfPmBhv0/VbWYMszpL6A/oDtCQzIZM4ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731807332; c=relaxed/simple;
	bh=uzgwjUP+KPsrHihwohqoFaqlgBQUUjqVCdudBAh9ZeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dUfdLqz/EwOiwCwGnR1odXKmeUJebXUbQyTZzuqmaEWJHkn+RLFCegrKPvGXh+Pex29sn8VVFkitwzDHImHrG8rf18b+7leKp1rHw+h1DNmN4yCpbc87WCs4tph/0vAUv669FPbJdcgL7XTQ6IrK4N8XX+NRvQp99KdWIReC9RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsR9yjVt; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsR9yjVt"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-460b2e4c50fso21306481cf.0;
        Sat, 16 Nov 2024 17:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731807330; x=1732412130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CqmBKlSWynrsrcqfyioauQIXzcWQM8RbSMBn2piT/gk=;
        b=OsR9yjVtaTaITM1UJWgB9kKRXkYqyiMTbqez/ZdVzF6bE/Agkx9qp0yrHL8pd3D3Z0
         YHrQJgze+1Qp2Xb7tUc3+SOkKQYtiMaeTE+1C7HCX3FQZmBGjjmURlovygwpT+KAfhL4
         FxHt46S2mlz2PDrvPFrOHuN8vMpMPjeTBCUqWvzhUF0bnSozzYTzilKcpnmID+GSKsyA
         y0pU9FJmvjsOxkXdNTpbFZZnsM9dplhEsxERqwZ4Mzi49scOymZIVkTrSi0G19q4eVvJ
         rwDV6odLf2Xso84mDx37FnKQMnP8LxtFroS1D+xjbq7sXXW8YGgfutejZDe0pAbiSm30
         z4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731807330; x=1732412130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CqmBKlSWynrsrcqfyioauQIXzcWQM8RbSMBn2piT/gk=;
        b=K9XRLrjImBCJo7hDVyZ4bulYbb25LOByrG4D2TaMYyNKlEb+iZjKGC0m+jY01FpNV1
         fOrXuAYjrGExcO4LGw0QCSN5qbfCC4iOcaFYvShzlhsI4gAHDyPXouGI/8pH+flED0Dc
         Hw0nm5DVplyiKrbaxXBPEsTmp+JCnWE7DyMdIv3mmAJR08I3LuNh7m7T7UAjDxH8oVxS
         EzhmMapypLQnYC1fGIuOEh3e2ucCytfV/W3+b5gXSnRoDd6C68U4Yl+CBWxgJEKv8q/q
         nCcherXhsUDPI2KOkQQXnKQ1gAEPYkuvXoO9sTM8bCQfoU9ozpRlSIRfD5YRaI0wDhfV
         mHAw==
X-Forwarded-Encrypted: i=1; AJvYcCW1YML37IL7fp05Xnv5HuDYnBjRhOlB20aq4+M7OgJrCgkEjUlk8L8ohSINkExqI9o0YjejgDcrPfzVfnw=@vger.kernel.org, AJvYcCX38uWie5ZV5qS/fQviTV87HuqVIHz3yvcl2KHYRcVYVZtBR40B2cCoOgsbJ5+jf/NcBpGQZDy9zyy9@vger.kernel.org
X-Gm-Message-State: AOJu0YzUoVL0cHGCyBFPSnP04+T19kuVcsEizAOwCMkSthZSjZtrlFj4
	B0ij+ulNwS7ERBmhd0sl/AsNPvoB2rEwjrEbIfWrxz1NWM6njCUqjK8uXoKOCF3MDxXhkuS1evh
	oQmO2I59HnC/heADWTWNtWmpK+o+nXF3MikI=
X-Google-Smtp-Source: AGHT+IFMdFoyYKQWW6wadd6uJfItC/0LpHBzPBMxLCm0ohzqn7EhyKw6TiXAF8zGkNuN4p708UOQA5Z5y57UVmYat3E=
X-Received: by 2002:ac8:690c:0:b0:460:42f7:fa44 with SMTP id
 d75a77b69052e-46363df3fe3mr116526691cf.9.1731807329744; Sat, 16 Nov 2024
 17:35:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <ZyhAOEkrjZzOQ4kJ@dread.disaster.area> <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
 <Zyi683yYTcnKz+Y7@dread.disaster.area> <CANubcdX3zJ_uVk3rJM5t0ivzCgWacSj6ZHX+pDvzf3XOeonFQw@mail.gmail.com>
 <ZzFmOzld1P9ReIiA@dread.disaster.area>
In-Reply-To: <ZzFmOzld1P9ReIiA@dread.disaster.area>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sun, 17 Nov 2024 09:34:53 +0800
Message-ID: <CANubcdXv8rmRGERFDQUELes3W2s_LdvfCSrOuWK8ge=cdEhFYA@mail.gmail.com>
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, 
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org, 
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=8811=E6=
=97=A5=E5=91=A8=E4=B8=80 10:04=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 08, 2024 at 09:34:17AM +0800, Stephen Zhang wrote:
> > Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=884=
=E6=97=A5=E5=91=A8=E4=B8=80 20:15=E5=86=99=E9=81=93=EF=BC=9A
> > > On Mon, Nov 04, 2024 at 05:25:38PM +0800, Stephen Zhang wrote:
> > > > Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=
=884=E6=97=A5=E5=91=A8=E4=B8=80 11:32=E5=86=99=E9=81=93=EF=BC=9A
> > > > > On Mon, Nov 04, 2024 at 09:44:34AM +0800, zhangshida wrote:
>
> [snip unnecessary stereotyping, accusations and repeated information]
>
> > > AFAICT, this "reserve AG space for inodes" behaviour that you are
> > > trying to acheive is effectively what the inode32 allocator already
> > > implements. By forcing inode allocation into the AGs below 1TB and
> > > preventing data from being allocated in those AGs until allocation
> > > in all the AGs above start failing, it effectively provides the same
> > > functionality but without the constraints of a global first fit
> > > allocation policy.
> > >
> > > We can do this with any AG by setting it up to prefer metadata,
> > > but given we already have the inode32 allocator we can run some
> > > tests to see if setting the metadata-preferred flag makes the
> > > existing allocation policies do what is needed.
> > >
> > > That is, mkfs a new 2TB filesystem with the same 344AG geometry as
> > > above, mount it with -o inode32 and run the workload that fragments
> > > all the free space. What we should see is that AGs in the upper TB
> > > of the filesystem should fill almost to full before any significant
> > > amount of allocation occurs in the AGs in the first TB of space.
>
> Have you performed this experiment yet?
>
> I did not ask it idly, and I certainly did not ask it with the intent
> that we might implement inode32 with AFs. It is fundamentally
> impossible to implement inode32 with the proposed AF feature.
>
> The inode32 policy -requires- top down data fill so that AG 0 is the
> *last to fill* with user data. The AF first-fit proposal guarantees
> bottom up fill where AG 0 is the *first to fill* with user data.
>
> For example:
>
> > So for the inode32 logarithm:
> > 1. I need to specify a preferred ag, like ag 0:
> > |----------------------------
> > | ag 0 | ag 1 | ag 2 | ag 3 |
> > +----------------------------
> > 2. Someday space will be used up to 100%, Then we have to growfs to ag =
7:
> > +------+------+------+------+------+------+------+------+
> > | full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
> > +------+------+------+------+------+------+------+------+
> > 3. specify another ag for inodes again.
> > 4. repeat 1-3.
>
> Lets's assume that AGs are 512GB each and so AGs 0 and 1 fill the
> entire lower 1TB of the filesystem. Hence if we get to all AGs full
> the entire inode32 inode allocation space is full.
>
> Even if we grow the filesystem at this point, we still *cannot*
> allocate more inodes in the inode32 space. That space (AGs 0-1) is
> full even after the growfs.  Hence we will still give ENOSPC, and
> that is -correct behaviour- because the inode32 policy requires this
> behaviour.
>
> IOWs, growfs and changing the AF bounds cannot fix ENOSPC on inode32
> when the inode space is exhausted. Only physically moving data out
> of the lower AGs can fix that problem...
>
> > for the AF logarithm:
> >     mount -o af1=3D1 $dev $mnt
> > and we are done.
> > |<-----+ af 0 +----->|<af 1>|
> > |----------------------------
> > | ag 0 | ag 1 | ag 2 | ag 3 |
> > +----------------------------
> > because the af is a relative number to ag_count, so when growfs, it wil=
l
> > become:
> > |<-----+ af 0 +--------------------------------->|<af 1>|
> > +------+------+------+------+------+------+------+------+
> > | full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
> > +------+------+------+------+------+------+------+------+
> > So just set it once, and run forever.
>
> That is actually the general solution to the original problem being
> reported. I realised this about half way through reading your
> original proposal. This is why I pointed out inode32 and the
> preferred metadata mechanism in the AG allocator policies.
>
> That is, a general solution should only require the highest AG
> to be marked as metadata preferred. Then -all- data allocation will
> then skip over the highest AG until there is no space left in any of
> the lower AGs. This behaviour will be enforced by the existing AG
> iteration allocation algorithms without any change being needed.
>
> Then when we grow the fs, we set the new highest AG to be metadata
> preferred, and that space will now be reserved for inodes until all
> other space is consumed.
>
> Do you now understand why I asked you to test whether the inode32
> mount option kept the data out of the lower AGs until the higher AGs
> were completely filled? It's because I wanted confirmation that the
> metadata preferred flag would do what we need to implement a
> general solution for the problematic workload.
>

Hi, I have tested the inode32 mount option. To my suprise, the inode32
or the metadata preferred structure (will be referred to as inode32 for the
rest reply) doesn't implement the desired behavior as the AF rule[1] does:
        Lower AFs/AGs will do anything they can for allocation before going
to HIGHER/RESERVED AFs/AGS. [1]

While the inode32 does:
        Lower AFs/AGs won't do anything they can for allocation before goin=
g
to HIGHER/RESERVED AFs/AGS.

To illustrate that, imagine that now AG 2 is badly fragmented and AG 0/1 ar=
e
reserved for inode32:
       +------------------------+
       |                        |
ag 0   |                        |
       +------------------------+
       |                        |
ag 1   |                        |
       +------------------------+
       |  1     1     1         |
       |  1        1  1         |
       |  1  1 4       1        |
ag 2   |           1     1      |
       |      1     1           |
       |    4  8          1     |
       +------------------------+
We want a allocate a space len of 4, but ag 2 is so fragmented that there
is no such continuous space that we have only two choices:
1. Break down the 4 into many small pieces for a success allocation in AG 2=
.
2. Go to the reserved AG 0/1 for the allocation.

But unlike the AF, the inode32 will choose option 2...

To understand the reason for that, we must understand the general allocatio=
n
phases:
1. Best length fit. Find the best length for the current allocation in
two loops.
    1.1. First loop with *_TRY_LOCK flags.
    1.2. Second loop without *_TRY_LOCK flags.
2. Low space algorithm. Break the allocation into small pieces and fit them=
 into
   the free space one by one.

So for the AF, it will do anything it can before going to higher AFs. *anyt=
hing*
means the allocation must completely go through the whole 1.1->1.2->2 phase=
 and
then go to the next AF.
But for the inode32, it will only go through 1.1-> and then go to the
reserved AG.

Take a look at the core code snippet for inode32 in xfs_alloc_fix_freelist(=
):


        /*
         * If this is a metadata preferred pag and we are user data then tr=
y
         * somewhere else if we are not being asked to try harder at this
         * point
         */
        if (xfs_perag_prefers_metadata(pag) &&
            (args->datatype & XFS_ALLOC_USERDATA) &&
            (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)) {
                ASSERT(!(alloc_flags & XFS_ALLOC_FLAG_FREEING));
                goto out_agbp_relse;
        }

That's exactly how the inode32 sees if it should go to the RESERVED AG for
allocation or not.

The inode32 will see if the current alloction is in *_TRY_LOCK mode
or not, if it isn't, then it can go to the RESERVED AG for allocation.
But at this moment, the allocation in unreserved ags only have gone
through 1.1->...

And seen from the code analysis for metadata preference algorithm, using th=
e
preference info to comply with the rule[1](indicate the unreserved AGs alre=
ady
having gone through 1.1->1.2->2) will greatly increase the
system complexity compared with the AF algorithm, or basically impossible..=
.

To sum it up:
1. The inode32/metadata-preference doesn't comply with the rule[1]. So it h=
as
   no ability to solve the reported problem.
2. Since the inode32 is kinda conficted with AF, maybe the AF should be dis=
abled
   when inode32 gets enabled...


> Remeber: free space fragmentation can happen for many reasons - this
> mysql thing is just the latest one discovered.  The best solution is
> having general mechanisms in the filesystem that automatically
> mitigate the effects of free space fragmentation on inode
> allocation. The worst solution is requiring users to tweak knobs...
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
