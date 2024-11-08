Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD65DDC3;
	Fri,  8 Nov 2024 01:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731029696; cv=none; b=O3UTCLMoDOh/7n9D9gtr48uevf3CS3vp9UBzWLPm2ByoVk03ORKIjR++FBBKRSh8+ZovEAoNSiAdPn3VUpbU+o3R1bU8T715PniIuFLWLz2EFK5xqPxjzpeZiLRYQB6z6Jaabt1XJT+RF1h4AIktM3jyra+RnKFac6L5HJfOve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731029696; c=relaxed/simple;
	bh=pbZYt/02amPB9lCQvyPOSDaMAJfyB4rMhw/vap355j8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aBqQPjsy2jLXXl10qL3BfJ/X/daZE+l/c6r3D1l+Jtbhoskw9NHy0bYN8kWTpu8ORB+0IzDt2dSwB4Rb5YYAtmwN1SInIVLnTbVqhwXtgQ0wCr6dGmUKDUCvRUSYfN6wX7B0R8bQVthqKMA/UvO83o8+RwCQeYEwNkZrNgqI+wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWZDAZmH; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWZDAZmH"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-460a415633fso10483131cf.2;
        Thu, 07 Nov 2024 17:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731029693; x=1731634493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3+cjkS2xzzlxoYBvaO/Bikxdj3sLXEIWPHUQixUsgUU=;
        b=jWZDAZmHX0HAo6m9y4/LbsgAlHDuQXOGy/G1EItf7vPs+gvgy6rQz+8VcZtzWYywPN
         c0iX1JEHWjkmE96fjNKpgGYvbtaDsk3i636aNKARIpE+d6hQhPjw/rrqfjIDY7JPnUBO
         9nqADmIBIpP/WaNJo6tOj/Hln/NcvPv0jqa449w+5svaHiOSIPj62LC6ptM3o1BJ5Bn4
         AOoniExTvU3zy1Y1e2DOQbmubqn0zEIWHRwVh2LMwqC457s1wZvtdziojvoAZ5gXOlVf
         T97CzbPFcuiWqiDzwi72m3L8hUoL9ozQl3TlqbpQVpjEFrr4KYZc1ka7seVAXigytW9z
         3yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731029693; x=1731634493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+cjkS2xzzlxoYBvaO/Bikxdj3sLXEIWPHUQixUsgUU=;
        b=vLXVohGdGEgV6T+azK1h4Fli+KV4d3aBb0ciCFVYU6xN4GjNiV06zn7emgsRkHD+Qh
         Zq2jaikxOeTYN9MNnuHU2qlUTWJyseZma/9XPt/nhGv24GeGq0/Cos5XWooAn3/uP2P6
         GxdP48qW7LO1sMMSR9oSrRVlWpkypR2xaRmnw/udHFBlOJX3zHOFwpb/6jSfDu5khbYR
         vfg9YNujllC6HRLTTLJ0wJXN1K1lygnZbCILwUOM3yENIw15p0a3V84OOxqog7cDO9jz
         0hnXEbt4S/vTmg7QLDWkb6ac2MtZmSxeReebPwitqIKPDGcSC/O7b2+vysbRgYVlbzC7
         pipQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuC7fbFnju4Jf/xZL9qRUrFvHXsfKBauCX5jhgGsri6fdGGlAWXx/JCGPpJR+mDSD3fznrXeJOkcdf@vger.kernel.org, AJvYcCXvzWkVUKW2eCd/eUoIbLu0sMHzbKJ6ND5844ea1NJxhHbMEgC6rQBUt7lEJxFEN8wLJbjJtuJ9tOwTyMM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyjJSpxZH37Oclu0bAZBAqODQwCxjqTNnFlLODK+Sl2dmcr/Wa
	EKAdsw8ZpkGq8EnZPFWE8+d1QYyJnG8T/E5jAYXplo/F0z8dhVoZdfCozAoXSjkbgO7Fwt0MM/u
	tTahRCc+kdaIndg0oPWDVcdphm74=
X-Google-Smtp-Source: AGHT+IGeaNnGX07V8zKVSOUmIwak3o3M0GJATdDEZv9fb9H4tN8SRF4UUfynv1wnbpHLOEvzRgH+sBMY3xbUN+xcL10=
X-Received: by 2002:a05:622a:14cf:b0:461:189:5f35 with SMTP id
 d75a77b69052e-4630937ea87mr15034141cf.25.1731029693127; Thu, 07 Nov 2024
 17:34:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <ZyhAOEkrjZzOQ4kJ@dread.disaster.area> <CANubcdVbimowVMdoH+Tzk6AZuU7miwf4PrvTv2Dh0R+eSuJ1CQ@mail.gmail.com>
 <Zyi683yYTcnKz+Y7@dread.disaster.area>
In-Reply-To: <Zyi683yYTcnKz+Y7@dread.disaster.area>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 8 Nov 2024 09:34:17 +0800
Message-ID: <CANubcdX3zJ_uVk3rJM5t0ivzCgWacSj6ZHX+pDvzf3XOeonFQw@mail.gmail.com>
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, 
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org, 
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=884=E6=97=
=A5=E5=91=A8=E4=B8=80 20:15=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Nov 04, 2024 at 05:25:38PM +0800, Stephen Zhang wrote:
> > Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=884=
=E6=97=A5=E5=91=A8=E4=B8=80 11:32=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Mon, Nov 04, 2024 at 09:44:34AM +0800, zhangshida wrote:
> > > > From: Shida Zhang <zhangshida@kylinos.cn>
> > > >
> > > > Hi all,
> > > >
> > > > Recently, we've been encounter xfs problems from our two
> > > > major users continuously.
> > > > They are all manifested as the same phonomenon: a xfs
> > > > filesystem can't touch new file when there are nearly
> > > > half of the available space even with sparse inode enabled.
> > >
> > > What application is causing this, and does using extent size hints
> > > make the problem go away?
> > >
> >
> > Both are database-like applications, like mysql. Their source code
> > isn't available to us. And I doubt if they have the ability to modify t=
he
> > database source code...
>
> Ok, so I did a bit of research. It's the MySQL transparent page
> compression algorithm that is the problem here. Essentially what
> this does is this:
>
> Write : Page -> Transform -> Write transformed page to disk -> Punch hole
>
> Read  : Page from disk -> Transform -> Original Page
>
> Essentially, every page is still indexed at the expected offset,
> but the data is compressed and the space that is saved by the
> compression is then punched out of the filesystem. Basically it
> makes every database page region on disk sparse, and it does it via
> brute force.
>
> This is -awful- for most filesystems. We use a similar technique in
> fstests to generate worst case file and free space fragmentation
> ('punch_alternating') for exercising this sort of behaviour, and it
> really does screw up performance and functionality on all the major
> Linux filesysetms. XFS is the canary because of the way it
> dynamically allocates inodes.
>
> It's also awful for performance. There can be no concurrency in
> database IO when it is doing hole punching like this. Hole punching
> completely serialises all operations on that file, so it cannot be
> doing read(), write() or even IO whilst the hole punch is being
> done.
>
> IOWs, page compression allows the database to store more data in the
> filesystem, but it does so at a cost. The cost is that it degrades
> the filesystem free space badly over time. Hence as the FS fills up,
> stuff really starts to slow down and, in some cases, stop working...
>
> As the old saying goes: TANSTAAFL.
>
> (There Ain't No Such Thing As A Free Lunch)
>
> If you can't turn off page compression via a database configuration
> flag, you could always shim the fallocate() syscall to always return
> -EOPNOTSUPP to fallocate(FALLOC_FL_PUNCH_HOLE)....
>

Wow...thanks for the research. I didn't even think about going to
dig this far with respect to the MySQL application layer...

And I decide to do a research to the source code in:

https://github.com/mysql/mysql-server/blob/61a3a1d8ef15512396b4c2af46e922a1=
9bf2b174/storage/innobase/os/os0file.cc#L4796

Here is the simplified version of the function os_file_io():
--------
os_file_io(src_len)
    if (is_compressed())
        len =3D os_file_compress_page(src_len);
    sync_file_io();
    if (len !=3D src_len)
        (os_file_punch_hole(src_len - len));
--------
that means, on default case, the disk and the memory are indexed
like:
+------------+-------------+
|   16 KB    |     16 KB   |  memory
+--------------------------+
|            |             |
v            v             v
+--------------------------+
|   16 KB    |     16 KB   |  disk
+------------+-------------+

When the compression is enabled. It's like:
+------------+-------------+
|   16 KB    |     16 KB   |  memory
+-----------X+-------------X
|         X  |          X
v       X    v        X
+------+v------------v-----+
| 8 KB | hole|  8 KB|  hole|  disk
+------+-------------------+
So it trades the extra cpu time to compress/decompress for
saving half of storage cost.
In another words, it will double the storage cost when the config
is disabled.
How much will that cost? like a billion dollars?
Then I think it will not be a simple problem any more. It is a war
about money. :P
The filesystem who can fully take advantage of these saved storage
will earn millions or even billions of dollars from it. :p


> Of course, this all changes when you mount with "inode32". Inodes
> are all located in the <1TB region, and the initial data allocation
> target for each inode is distributed across AGs in the >1TG region.
> There is no locality between the inode and it's data, and the
> behaviour of the filesystem from an IO perspective is completely
> different.
>
> > The ideal layout of af to be constructed is to limit the higher af
> > in the small part of the entire [0, agcount). Like:
> >
> > |<-----+ af 0 +----->|<af 1>|
> > |----------------------------
> > | ag 0 | ag 1 | ag 2 | ag 3 |
> > +----------------------------
> >
> > So for much of the ags(0, 1, 2) in af 0, that will not be a problem.
> > And for the ag in the small part, like ag 3.
> > if there is inode in ag3, and there comes the space allocation of the
> > inode, it will not find space in ag 3 first. It will still search from =
the
> > af0 to af1, whose logic is reflected in the patch:
>
> That was not clear from your description. I'm not about to try to
> reverse engineer your proposed allocation algorithm from the code
> you have presented. Looking at the implementation doesn't inform me
> about the design and intent of the allocation policy.
>
> > [PATCH 4/5] xfs: add infrastructure to support AF allocation algorithm
> >
> > it says:
> >
> > + /* if start_agno is not in current AF range, make it be. */
> > + if ((start_agno < start_af) || (start_agno > end_af))
> > +       start_agno =3D start_af;
> > which means, the start_agno will not be used to comply with locality
> > principle.
>
> Which is basically the inode32 algorithm done backwards.
>

Yep, to some degree, it can be equivalent to the inode32 algorithm.
Because firstly, I didn't know the inode32 algorithm.
And I want to design an algorithm that will reserve continuous space
for inodes only. The info of the preferred agno can be passed from the
user via ioctl() or something.

But then I think, now that we can reserve the space for inodes, can
we just enlarge this idea so that the space can be arranged in any
desired way?

The problem is, to achieve this goal, we have to pass various info from
the user to the kernel and add some code to manage the special AG
properly..., which will greatly increase the complexity of the system.

And one idea comes to my mind, if only we can add a rule:
    Lower AFs will NEVER go to higher AFs for allocation if it can
complete it in the current AF. [1]

This rule can serve as a way to slow down the over-speed extending of
space,
since without this rule[1], the space will be extending quickly by:
1.Ag contention. That means if an ag is busy, then it will search for the
  next ag.
2.Best length fit. That means if the current ag have no suitable length for
  the current allocation even if it has enough space, it will go to next ag=
.
3.Rotored directories across all AGs and locality rules? (That's what
  I learned from Dave.)

Using this single rule[1] to rule them all, then everything will be
manifested as a clear and beautiful form, which will not add extra
complexity to design construct that preference needed or add code to
manage the reserved AG or pass the extra info from user space.

So I'll explain how the inode32 algorithm can be seen as a special case/sub=
set
of AF.
When you do:
    mount -o af1=3D1 $dev $mnt
the AF layout becomes:
|<-----+ af 0 +----->|<af 1>|
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------
And with the AF rule[1] above, no extra preference info is needed,
ag3 just becomes the reserved space of inodes.
Not only it can be used as the reserved space of inodes, but also it can
be used for any type of space that must need 4 continuous blocks.
More generally, with more levels of AFs, Higher AF can be used as a reserve=
d
space of the lower AF that must be at length 4/5/../8/16/...whatever.

To illustrate that, Imagine that now AF 0 is badly fragmented:
       +------------------------+
       |                        |
af 2   |                        |
       +------------------------+
       |                        |
af 1   |                        |
       +------------------------+
       |  1     1     1         |
       |  1        1  1         |
       |  1  1 4       1        |
af 0   |           1     1      |
       |      1     1           |
       |    4  8          1     |
       +------------------------+

We want to allocate a space len of 4, but af 0 is so fragmented that there
is no such continuous space that we have only two choices:
1. Break down the 4 into many small pieces so as to get a success
   allocation in af 0.
2. Go to AF 1 for the allocation.

So keep in mind the rule[1],
for regular data extent allocation, it can break it down into small pieces,=
 so
it must allocate in af 0.
for inode allocation, it cannot allocate in af 0 at any possibility. so it =
has
to go to af 1 for allocation.

That's how it became the reserved space for inodes. But not confined to
inodes only, it reserves space for any allocation that must be 4.
further,
       +------------------------+
       |                        |
af 2   |                        |
       +------------------------+
       |     4      4     4     |
af 1   |  4     4  1 1  4    4  |
       +------------------------+
       |  1     1     1         |
       |  1        1  1         |
       |  1  1 4       1        |
af 0   |           1     1      |
       |      1     1           |
       |    4  8          1     |
       +------------------------+
if the af 1 is badly fragmented too, now we want an allocation of continuou=
s
len 8 exactly.
Because we want an exact 8 so we can't break it down. Thus we have to go to
af 2 for allocation.
Finally it will form layers of different len:
       +------------------------+
       |   8                    |
af 2   | 8  8    8              |
       +------------------------+
       |     4      4     4     |
af 1   |  4     4  1 1  4    4  |
       +------------------------+
       |  1     1     1         |
       |  1        1  1         |
       |  1  1 4       1        |
af 0   |           1     1      |
       |      1     1           |
       |    4  8          1     |
       +------------------------+

And what? you don't want it because it breaks the original AG rules too muc=
h.
Then you can adjust the af1 leftwards or rightwards:
|<-----+ af 0 +----->|<af 1>|
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------
let's say, you don't want it all. then you move af1 rightwards:
|<-----+ af 0 +------------>|
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------
The behavior will be totally the same as the original logic.
Or, you want it, but not that much. Then I believe there must a point in
the middle that will satisfy your demand.

To sum it up,
The rules used by AG are more about extending outwards.
whilst
The rules used by AF are more about restricting inwards.
like:
|                           |
+---->    af rule    <------+
|                           |
|        +          +       |
|    <-+ |  ag rule | +->   |
+        +          +       +
They are constructed in a symmetrical way so that we can strength/weaken
one rule or the other to reach a best balance, by adjusting the af location=
,
when combining the advantage and disadvantage of them.

> > > > 3.Lower AFs will NEVER go to higher AFs for allocation if
> > > >   it can complete it in the current AF.
> >
> > From that rule, we can infer that,
> >      For any specific af, if len1 > len2, then,
> >      P(len1) <=3D P(len2)
> >
> > where P(len) represents the probability of the success allocation for a=
n
> > exact *len* length of extent.
> >
> > To prove that, Imagine we have to allocate two extent at len 1 and 4 in=
 af 0,
> > if we can allocate len 4 in af 0, then we can allocate len 1 in af 0.
> > but,
> > if we can allocate len 1 in af 1, we may not allocate len 4 in af 0.
> >
> > So, P(len1) <=3D P(len2).
> >
> > That means it will naturally form a layer of different len. like:
> >
> >        +------------------------+
> >        |            8           |
> > af 2   |    1   8     8  1      |
> >        |       1   1            |
> >        +------------------------+
> >        |                        |
> >        |    4                   |
> >        |          4             |
> > af 1   |        4     1         |
> >        |    1       4           |
> >        |                  4     |
> >        +------------------------+
> >        |                        |
> >        |  1     1     1         |
> >        |                        |
> >        |           1            |
> >        |  1  1 4       1        |
> > af 0   |           1            |
> >        |      1                 |
> >        |                  1     |
> >        |          1             |
> >        |                        |
> >        +------------------------+
> >
> > So there is no need so provide extra preference control info for
> > an allocation. It will naturally find where it should go.
>
> This appears to be a "first fit from index zero" selection routine.
> It optimises for discontiguous, small IO hole filling over
> locality preserving large contiguous allocation, concurrency and IO
> load distribution. XFS optimises for the latter, not the former.
>
> First fit allocation generally results in performance hotspots in
> large storage arrays. e.g. with a linear concat of two luns, a
> first-fit from zero algorithm will not direct any IO to the second
> lun until the first lun is almost entirely full. IOWs, half the
> performance of the storage hardware is not being used with such an
> algorithm. The larger the storage array gets, the worse this
> under-utilisation becomes, and hence we have never needed to
> optimise for such an inefficient IO pattern as the innodb page
> compression algorithm uses.
>
> FWIW, as this appears to be a first-fit algorithm, why is there
> a need for special "AF"s to control behaviour? I may be missing
> something else, but if we treat each AG as an AF, then we
> effectively get the same result, right?
>
> The only issue would be AG contention would result in allocations in
> higher AGs before the lower AGs are completely full, but the
> filesystem would still always fill from one end to the other as this
> AF construct is attempting to do. That leaves space for inodes to be
> allocated right up until the last AG in the fs becomes too
> fragmented to allocate inodes.
>
> AFAICT, this "reserve AG space for inodes" behaviour that you are
> trying to acheive is effectively what the inode32 allocator already
> implements. By forcing inode allocation into the AGs below 1TB and
> preventing data from being allocated in those AGs until allocation
> in all the AGs above start failing, it effectively provides the same
> functionality but without the constraints of a global first fit
> allocation policy.
>
> We can do this with any AG by setting it up to prefer metadata,
> but given we already have the inode32 allocator we can run some
> tests to see if setting the metadata-preferred flag makes the
> existing allocation policies do what is needed.
>
> That is, mkfs a new 2TB filesystem with the same 344AG geometry as
> above, mount it with -o inode32 and run the workload that fragments
> all the free space. What we should see is that AGs in the upper TB
> of the filesystem should fill almost to full before any significant
> amount of allocation occurs in the AGs in the first TB of space.
>

So for the inode32 logarithm:
1. I need to specify a preferred ag, like ag 0:
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------
2. Someday space will be used up to 100%, Then we have to growfs to ag 7:
+------+------+------+------+------+------+------+------+
| full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
+------+------+------+------+------+------+------+------+
3. specify another ag for inodes again.
4. repeat 1-3.

for the AF logarithm:
    mount -o af1=3D1 $dev $mnt
and we are done.
|<-----+ af 0 +----->|<af 1>|
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+----------------------------
because the af is a relative number to ag_count, so when growfs, it will
become:
|<-----+ af 0 +--------------------------------->|<af 1>|
+------+------+------+------+------+------+------+------+
| full | full | full | full | ag 4 | ag 5 | ag 6 | ag 7 |
+------+------+------+------+------+------+------+------+
So just set it once, and run forever.

Cheers,
Shida
> If that's the observed behaviour, then I think this problem can be
> solved by adding a mechanism to control which AGs in the filesystem
> are metadata preferred...
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
