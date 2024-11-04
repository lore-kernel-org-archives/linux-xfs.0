Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631CE6FC5;
	Mon,  4 Nov 2024 09:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730712378; cv=none; b=IVxnGhV1gvxi56MP5LE7JBz2pm6b7FVEMpURXpC5aOzWqIImcA5EGp11K5rWyiX41Ki3sHT+MGLYMS56/AnMRgPFzfsqyP1L/6AP/YzIODUyJPZGYwO1FHgLwMpIHBjQQ0vRPqmCX3ljBx5esVHePNNIi5JNEBH7xc1vVMxtvjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730712378; c=relaxed/simple;
	bh=piRew1AhcQwYdlRW/QsetcSFfIG6NMcbOg1kKJARfpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HHGwDkhInzkbg5qlP2eOIGvLl8OvAVywBmWY+jit8+CoPHMOUEt9JA4JdOB789u71QsHbG4wIry/H0BH+qSBGe9tvI/baH7HLJCim570R9ZG2MKqbjT2W3hdcIIlv1R/uJrMrHFNYngGxZEdlhTpjfzIsKzpFBo2iiUCW8+p2hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=foEDZVni; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foEDZVni"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e2bd7d8aaf8so3441181276.3;
        Mon, 04 Nov 2024 01:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730712375; x=1731317175; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OpxBpxFtN14yehocdqlq7UgiX88PpHAp1pWICIoh6+k=;
        b=foEDZVni45nH92uf0ZDS4ogldHxCzbBX4eY/awmGuzQX0+vbxhJHENAtvfWBfk8K/e
         y50Y6SoaXt5uHu4+/roC9oj3ruv4Vee+Dv7GlJ/BfcLwTEuiVNPhKgrp5tkkJj9h/81L
         UbyvQf83FQ+4Ue8blHxN5oXZ03gZE9TnFyrrRiwZjOxEBOg1ObxIEU5gwEIXR6okADX6
         xqFz6cLnLX3fOGxObDlR1zOin47QsEvU7qnrNp6J0EuGJmChDdRnz8LmN5A92ZMY4MEB
         urfbM9qzTdbGjulGNRedeDyflWUcdPHuBliKETmMuN2+qezk8jQa+n0kxMDbOa94j6W8
         3UOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730712375; x=1731317175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpxBpxFtN14yehocdqlq7UgiX88PpHAp1pWICIoh6+k=;
        b=PVNiDUAH3ijPqb3aV0unoW3Ldlii2qiWQFB+WGJLU6L0pheGnfUanOJ+CbeUyRBKWU
         TWdkj34gS+/HxzQDOuOi+4LuUFvv7YSOwhNlrhjVIjRHZQgqBUtDl5DqnLKnNHLGBn0h
         I8VrkuJopDGXlDXxtL8Nzw+8Kv8vpokC0MZonLHPcsXBs7ysGS8ChbP38pQc9hDV/IAb
         gQii5ZVtqoOj7XwSixKSWS23rwohuqvszGkNf53/8lo2xLZSKJaH1sFTWm0aR9xYGZOV
         x5BkAbGOLjxrrmuUnLI3JjvuCSnA1uNEJUHokK/HDjpmfcMSVxS0JgWr+7MxbS2dUyvl
         rEKw==
X-Forwarded-Encrypted: i=1; AJvYcCW5MZlDarKjMb2xp8BLYsp1dx0CAgDuj8mrbLsQMzmSqWWHh3Ww8qVu5XOXV+lVd+hc9Eb8WKKJo6C5@vger.kernel.org, AJvYcCXkJ3mDMiWr7YYbS4r/HAHFRzohM73kRSckiMhSwRC1qbKHWy16xYuo5OKT77+fD6gklTs+pvPvpVUj5SQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw15ZoHnTg2WC1w8w6NeH7NER6ZHCoHdEe0oCT8Jd/YkjD+zQ6V
	wOqnBZ0EqyYBoaZAxryLjovidSaYORKFiLdtipcsPQLoYklilBjls7weCRBh9ZRv1uNgx6gIQ7x
	IU5jyAsI/q/yXL8PDCd9AOfRFihg=
X-Google-Smtp-Source: AGHT+IEIBjxBr4NOJqC4khLJ3IqA6cwWzB7jIUxAiiH/2Axcx86AjcOYGkjrLu/r0vKnCXDadNhbuo3sxlnBrxb+yNU=
X-Received: by 2002:a05:6902:154b:b0:e30:dc1e:d81f with SMTP id
 3f1490d57ef6-e30e5a663b3mr13611915276.21.1730712375251; Mon, 04 Nov 2024
 01:26:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104014439.3786609-1-zhangshida@kylinos.cn> <ZyhAOEkrjZzOQ4kJ@dread.disaster.area>
In-Reply-To: <ZyhAOEkrjZzOQ4kJ@dread.disaster.area>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 4 Nov 2024 17:25:38 +0800
Message-ID: <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, 
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org, 
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=884=E6=97=
=A5=E5=91=A8=E4=B8=80 11:32=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Nov 04, 2024 at 09:44:34AM +0800, zhangshida wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Hi all,
> >
> > Recently, we've been encounter xfs problems from our two
> > major users continuously.
> > They are all manifested as the same phonomenon: a xfs
> > filesystem can't touch new file when there are nearly
> > half of the available space even with sparse inode enabled.
>
> What application is causing this, and does using extent size hints
> make the problem go away?
>

Both are database-like applications, like mysql. Their source code
isn't available to us. And I doubt if they have the ability to modify the
database source code...

> Also, xfs_info and xfs_spaceman free space histograms would be
> useful information.
>

There are two such cases.
In one case:
$ xfs_info disk.img
meta-data=3Ddisk.img               isize=3D512    agcount=3D344, agsize=3D1=
638400 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1
data     =3D                       bsize=3D4096   blocks=3D563085312, imaxp=
ct=3D25
         =3D                       sunit=3D64     swidth=3D64 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D12800, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

$ xfs_db -c freesp disk.img
   from      to extents  blocks    pct
      1       1 43375262 43375262  22.32
      2       3 64068226 150899026  77.66
      4       7       1       5   0.00
     32      63       3     133   0.00
    256     511       1     315   0.00
   1024    2047       1    1917   0.00
   8192   16383       2   20477   0.01


Another was mentioned already by one of my teammates. See:
https://lore.kernel.org/linux-xfs/173053338963.1934091.14116776076321174850=
.b4-ty@kernel.org/T/#t

[root@localhost ~]# xfs_db -c freesp /dev/vdb
   from      to extents  blocks    pct
      1       1     215     215   0.01
      2       3  994476 1988952  99.99


> > It turns out that the filesystem is too fragmented to have
> > enough continuous free space to create a new file.
>
> > Life still has to goes on.
> > But from our users' perspective, worse than the situation
> > that xfs is hard to use is that xfs is non-able to use,
> > since even one single file can't be created now.
> >
> > So we try to introduce a new space allocation algorithm to
> > solve this.
> >
> > To achieve that, we try to propose a new concept:
> >    Allocation Fields, where its name is borrowed from the
> > mathmatical concepts(Groups,Rings,Fields), will be
>
> I have no idea what this means. We don't have rings or fields,
> and an allocation group is simply a linear address space range.
> Please explain this concept (pointers to definitions and algorithms
> appreciated!)
>
>
> > abbrivated as AF in the rest of the article.
> >
> > what is a AF?
> > An one-pic-to-say-it-all version of explaination:
> >
> > |<--------+ af 0 +-------->|<--+ af 1 +-->| af 2|
> > |------------------------------------------------+
> > | ag 0 | ag 1 | ag 2 | ag 3| ag 4 | ag 5 | ag 6 |
> > +------------------------------------------------+
> >
> > A text-based definition of AF:
> > 1.An AF is a incore-only concept comparing with the on-disk
> >   AG concept.
> > 2.An AF is consisted of a continuous series of AGs.
> > 3.Lower AFs will NEVER go to higher AFs for allocation if
> >   it can complete it in the current AF.
> >
> > Rule 3 can serve as a barrier between the AF to slow down
> > the over-speed extending of fragmented pieces.
>
> To a point, yes. But it's not really a reliable solution, because
> directories are rotored across all AGs. Hence if the workload is
> running across multiple AGs, then all of the AFs can be being
> fragmented at the same time.
>

You mean the inode of the directory is expected to be distributed
evenly over the entire system, and the file extent of that directory will b=
e
distributed in the same way?

The ideal layout of af to be constructed is to limit the higher af
in the small part of the entire [0, agcount). Like:

|<-----+ af 0 +----->|<af 1>|
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------

So for much of the ags(0, 1, 2) in af 0, that will not be a problem.
And for the ag in the small part, like ag 3.
if there is inode in ag3, and there comes the space allocation of the
inode, it will not find space in ag 3 first. It will still search from the
af0 to af1, whose logic is reflected in the patch:

[PATCH 4/5] xfs: add infrastructure to support AF allocation algorithm

it says:

+ /* if start_agno is not in current AF range, make it be. */
+ if ((start_agno < start_af) || (start_agno > end_af))
+       start_agno =3D start_af;

which means, the start_agno will not be used to comply with locality
principle.

In general, the evenly distributed layout is slightly broken, but only for
the last small AG, if you choose the AF layout properly.

> Given that I don't know how an application controls what AF it's
> files are located in, I can't really say much more than that.
>
> > With these patches applied, the code logic will be exactly
> > the same as the original code logic, unless you run with the
> > extra mount opiton. For example:
> >    mount -o af1=3D1 $dev $mnt
> >
> > That will change the default AF layout:
> >
> > |<--------+ af 0 +--------->|
> > |----------------------------
> > | ag 0 | ag 1 | ag 2 | ag 3 |
> > +----------------------------
> >
> > to :
> >
> > |<-----+ af 0 +----->|<af 1>|
> > |----------------------------
> > | ag 0 | ag 1 | ag 2 | ag 3 |
> > +----------------------------
> >
> > So the 'af1=3D1' here means the start agno is one ag away from
> > the m_sb.agcount.
>
> Yup, so kinda what we did back in 2006 in a proprietary SGI NAS
> product with "concat groups" to create aggregations of allocation
> groups that all sat on the same physical RAID5 luns in a linear
> concat volume. They were fixed size, because the (dozens of) luns
> were all the same size. This construct was heavily tailored to
> maximising the performance provided by the underlying storage
> hardware architecture, so wasn't really a general policy solution.
>
> To make it work, we also had to change how various other allocation
> distribution algorithms worked (e.g. directory rotoring) so that
> the load was distributed more evenly across the physical hardware
> backing the filesystem address space.
>
> I don't see anything like that in this patch set - there's no actual
> control mechanism to select what AF an inode lands in.  how does an
> applicaiton or user actually use this reliably to prevent all the
> AFs being fragmented by the workload that is running?
>

> > 3.Lower AFs will NEVER go to higher AFs for allocation if
> >   it can complete it in the current AF.

From that rule, we can infer that,
     For any specific af, if len1 > len2, then,
     P(len1) <=3D P(len2)

where P(len) represents the probability of the success allocation for an
exact *len* length of extent.

To prove that, Imagine we have to allocate two extent at len 1 and 4 in af =
0,
if we can allocate len 4 in af 0, then we can allocate len 1 in af 0.
but,
if we can allocate len 1 in af 1, we may not allocate len 4 in af 0.

So, P(len1) <=3D P(len2).

That means it will naturally form a layer of different len. like:

       +------------------------+
       |            8           |
af 2   |    1   8     8  1      |
       |       1   1            |
       +------------------------+
       |                        |
       |    4                   |
       |          4             |
af 1   |        4     1         |
       |    1       4           |
       |                  4     |
       +------------------------+
       |                        |
       |  1     1     1         |
       |                        |
       |           1            |
       |  1  1 4       1        |
af 0   |           1            |
       |      1                 |
       |                  1     |
       |          1             |
       |                        |
       +------------------------+

So there is no need so provide extra preference control info for
an allocation. It will naturally find where it should go.

So without the extra need of changing the application source code.




> > We did some tests verify it. You can verify it yourself
> > by running the following the command:
> >
> > 1. Create an 1g sized img file and formated it as xfs:
> >   dd if=3D/dev/zero of=3Dtest.img bs=3D1M count=3D1024
> >   mkfs.xfs -f test.img
> >   sync
> > 2. Make a mount directory:
> >   mkdir mnt
> > 3. Run the auto_frag.sh script, which will call another scripts
> >   frag.sh. These scripts will be attached in the mail.
> >   To enable the AF, run:
> >     ./auto_frag.sh 1
> >   To disable the AF, run:
> >     ./auto_frag.sh 0
> >
> > Please feel free to communicate with us if you have any thoughts
> > about these problems.
>
> We already have inode/metadata preferred allocation groups that
> are avoided for data allocation if at all possible. This is how we
> keep space free below 1TB for inodes when the inode32 allocator has
> been selected. See xfs_perag_prefers_metadata().
>
> Perhaps being able to control this preference from userspace (e.g.
> via xfs_spaceman commands through ioctls and/or sysfs knobs) would
> acheive the same results with a minimum of code and/or policy
> changes. i.e. if AG0 is preferred for metadata rather than data,
> we won't allocate data in it until all higher AGs are largely full.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
