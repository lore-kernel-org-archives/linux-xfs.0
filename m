Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA0022576E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758122243; cv=none; b=I8hzHZYb1mOHRrd55kznTqbEnztfxqZ148cKhD5w+lRdsTurqCINrZq/1sOCqsLek7qjl3OGWYJBn4XGw8Qvio2DgrDyQG63vrfAdcDFPnNo/nKiUmBhMDhIQRx/94fHS7LP77KEmKr/77PiEhdNNu8nGbvpprbdtdtI52Awlas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758122243; c=relaxed/simple;
	bh=cTp3uyiChnS/qz7JaL+uXnI0Ew0t0E7b5gkQ32AXCJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PscVtTpZK/cpmG7h2lj3//IImHeFTlU3i4zRw5+pzIcEgujrLP0TWCD8H0CT30Dnj6/tlM2sLzZrWHe/s7b7vjU5XRHlV4MPcNf1qxH4iq7zItwOfGlbMmX6hV6NtIIU3FtDknDk5fSntQgrdCs/iS49WjdKAMxWilR/3gCTQ3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FKXR/IqL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FKXR/IqL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758122240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Qg5I0xbq33/zQLrO1C+pWKL80XyRH9GfKIHP2qw4+0=;
	b=FKXR/IqLl4UvqjMIYHUsJyHZ5r7ccv1HjNSX0AtkeKG/R4/TGcOiBmQ+cOxaICiV7T/4st
	uX0/c7WgLlo1IYX2bqgKjWOy8yhWuCfUJvfn2a2b2KImbVrBr0F3twa6+Nn/ZMxFHHdrWY
	X3rJfPskh81Bh+geSJR5EPqtjjVFJAw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-10ucNFHEOiSeW0Gb_LjT0A-1; Wed, 17 Sep 2025 11:17:15 -0400
X-MC-Unique: 10ucNFHEOiSeW0Gb_LjT0A-1
X-Mimecast-MFC-AGG-ID: 10ucNFHEOiSeW0Gb_LjT0A_1758122233
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-401eba8efecso13585875ab.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 08:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758122233; x=1758727033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Qg5I0xbq33/zQLrO1C+pWKL80XyRH9GfKIHP2qw4+0=;
        b=DqqEtUTCc+t3YehngAIFFSgP5zPKOvY+Fc0i1O0LePPN9+gZQxYyqBhbuslakqEWxS
         7v7NxFXBZMi8x4L+RYqmxuAcH76tsS0trPd5E+rX9HTAXa8YH78nTqSyzfMFor+rCqXx
         3Zjj+/ugiZbbHN5rz2UlcOs86WZn1nzABOAc9jIUC4jKAqyrpZiFifc9IQURVAlfuPx+
         gaEdkOay8vCXV+SSaNbez2Ov2Nqfd/gF8x1XpxQbu8tT21ZKOPWRXXDukhvTazhQxH+2
         F2VHSg63u4KPCKGdYr5jnOQdYVXMfPNygplBl1G4ZmUuzf4pXMbgoYZ6n2Z7FYfYXikp
         Xs8g==
X-Forwarded-Encrypted: i=1; AJvYcCXUtLMcrKK6Gh878M6sO9+oApsyNzeW8wAuyGWSyV/fq2rLyeE1c3zTMR3fZhAZ4pdSNSWSiGtLPKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YymtdFWUyWdtvNWW4Wxs0uMIJcVz2jCz4ZktcvRs0bR09kR/naJ
	lRSLP/PD/zvDWg+P8fvtIut+j2IUMDX9jIQZLzJ/7AdDecafpzgOHtfDZ2T6H0Dn34vSjOFAAbJ
	e6MCxFnaosCv7NAnVhgePH5s4JdytFM825hWidMxgKCycBAi82/gD2uQ6l3IZgKL2vawtsK3QLy
	fr3SdICWhnU/ecP63vPcyQeDQNGZSHQZLBoczc5oFyfnhEk/k=
X-Gm-Gg: ASbGncvx3i1R3Oa0aytZ8fKIAIdPlzDsISWiETJA/Nerdcll5IqJefs1yqcuBE3Bd1t
	8pnqEosprsXHU3/3E+bFyYfzQ8rcaDnlEY6lMNrlmLjl09VbKGoe6TBSP5ed7Qkhsvk8p4fMNtg
	lAToR5Xv6cXBY1RukMvA==
X-Received: by 2002:a05:6e02:e03:b0:424:86d:7bb9 with SMTP id e9e14a558f8ab-424402defafmr388025ab.0.1758122232373;
        Wed, 17 Sep 2025 08:17:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHR2TRKb6LAg3PbEEhSv+QyxhRVGoiDIU2I5nGQmEvnZGiYmRrbMS40YSCwzH0gHt9x6sIFRgl1pdKK23bpN7c=
X-Received: by 2002:a05:6e02:e03:b0:424:86d:7bb9 with SMTP id
 e9e14a558f8ab-424402defafmr387765ab.0.1758122231778; Wed, 17 Sep 2025
 08:17:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908151248.1290-2-jack@suse.cz> <aL9yc4WJLdqtCFOK@dread.disaster.area>
 <hzjznua7gqp32yc36b5uef6acy4nssfdy42jtlpaxcdzfi5ddy@kcveowwcwltb>
 <aMIe43ZYUtcQ9cZv@dread.disaster.area> <aMkAhMrKO8bE8Eba@dread.disaster.area>
 <vpsyvzbupclvb76axyzytms5rh5yzubcyj5l5h2iwpk3d7xf6a@dw6pemmdfcka>
 <aMnXW_sEk_wTPnvB@dread.disaster.area> <hgk4f5iatzmdmrueuqww56nzc6cdev2mjbkcxxcytkaukzby34@5cwqi3j7pdie>
 <CAM4Jq_5kSfwPRiVsGD67n3ftoNPsdXOwMx0jxxQ4f8T9kcqgcw@mail.gmail.com> <xnmqfaxsl234r32xs625y5dgox7ewtv3n36pymbl3mo5ep3oey@g4f4yth4q5jp>
In-Reply-To: <xnmqfaxsl234r32xs625y5dgox7ewtv3n36pymbl3mo5ep3oey@g4f4yth4q5jp>
From: Lukas Herbolt <lherbolt@redhat.com>
Date: Wed, 17 Sep 2025 17:16:35 +0200
X-Gm-Features: AS18NWDzSB7JAo5kq7FuMvP89KKBjy7E3Zn_hwiK7zVezDLeajC5UvR8YYQJYkw
Message-ID: <CAM4Jq_71gxMcnOdgqWhKEa53sr9r57Qpi0hc5bs3NgtnNOGwtg@mail.gmail.com>
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I forgot to mention, I am not sure if fio always preallocates
(deallocates) the file extents if the
writes (ie. unwritten-> written) to that file already happened. Also
the mount in my test is done
with nodiratime, noatime.

So I was running before each fio, to be sure
---
find  /mnt/test/posix -type f -exec fallocate -v -z -l 1G {} \;;
xfs_bmap -vp  /mnt/test/posix/*/*
---
and checking that the extents are unwritten.
With that, the results were quite stable, I would say.

On Wed, Sep 17, 2025 at 5:05=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 17-09-25 12:22:46, Lukas Herbolt wrote:
> > >> I was actually trying hard to come up with a fio recipe to reproduce
> > this
> > >> but I've failed.
> > I have a similar issue with DB2 observed during index reorg/rebuild. Th=
e db
> > opens
> > the files with O_DSYNC|O_DIRECT and writes with libaio 256 x 4k writes
> > (mostly
> > sequential)  I believe that with the 256 and 4K depends on DB2
> > internal page size
> > and extent size. Anyway with bellow I am getting around ~18MB/s without=
 the
> > patch
> > and around ~75MB/s with your patch. Need to test Dave's as well.
> >
> > The fio file looks like this
> > ---
> > [global]
> > name=3Dfio-seq-write
> > filename_format=3D/mnt/test/$jobname/$jobnum/fio.$filenum.$jobnum
> > rw=3Dwrite
> > bs=3D4k
> > direct=3D1
> > numjobs=3D10
> > time_based
> > runtime=3D20
> > nrfiles=3D1
> > size=3D4G
> > ioengine=3Dlibaio
> > iodepth=3D16
> > iodepth_batch_submit=3D16
> > iodepth_batch_complete_min=3D16
> > iodepth_batch_complete_max=3D16
> > group_reporting=3D1
> > gtod_reduce=3D1
> > sync=3Ddsync
> > fadvise_hint=3D1
> >
> > [posix]
> > fallocate=3Dposix
> > stonewall
> > ---
>
> Thanks for sharing this! The results of this fio job vary significantly o=
n
> my test machine (even if I increase the runtime to several minutes) but
> indeed average throughput seems to be about 30% better with the patch
> applied so I think it's good enough smoke test.
>
>                                                                 Honza
>
> >
> > On Wed, Sep 17, 2025 at 12:07=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> >
> > > On Wed 17-09-25 07:32:11, Dave Chinner wrote:
> > > > On Tue, Sep 16, 2025 at 03:32:42PM +0200, Jan Kara wrote:
> > > > > On Tue 16-09-25 16:15:32, Dave Chinner wrote:
> > > > > > On Thu, Sep 11, 2025 at 10:59:15AM +1000, Dave Chinner wrote:
> > > > > > > i.e. if we clear the commit sequences on last unpin (i.e. in
> > > > > > > xfs_inode_item_unpin) then an item that is not in the CIL (an=
d so
> > > > > > > doesn't have dirty metadata) will have no associated commit
> > > > > > > sequence number set.
> > > > > > >
> > > > > > > Hence if ili_datasync_commit_seq is non-zero, then by definit=
ion
> > > the
> > > > > > > inode must be pinned and has been dirtied for datasync purpos=
es.
> > > > > > > That means we can simply query ili_datasync_commit_seq in
> > > > > > > xfs_bmbt_to_iomap() to set IOMAP_F_DIRTY.
> > > > > > >
> > > > > > > I suspect that the above fsync code can then become:
> > > > > > >
> > > > > > >         spin_lock(&iip->ili_lock);
> > > > > > >         if (datasync)
> > > > > > >                 seq =3D iip->ili_datasync_commit_seq;
> > > > > > >         else
> > > > > > >                 seq =3D iip->ili_commit_seq;
> > > > > > >         spin_unlock(&iip->ili_lock);
> > > > > > >
> > > > > > >         if (!seq)
> > > > > > >                 return 0;
> > > > > > >         return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SY=
NC,
> > > log_flushed);
> > > > > > >
> > > > > > > For the same reason. i.e. a non-zero sequence number implies =
the
> > > > > > > inode log item is dirty in the CIL and pinned.
> > > > > > >
> > > > > > > At this point, we really don't care about races with transact=
ion
> > > > > > > commits. f(data)sync should only wait for modifications that =
have
> > > > > > > been fully completed. If they haven't set the commit sequence=
 in
> > > the
> > > > > > > log item, they haven't fully completed. If the commit sequenc=
e is
> > > > > > > already set, the the CIL push will co-ordinate appropriately =
with
> > > > > > > commits to ensure correct data integrity behaviour occurs.
> > > > > > >
> > > > > > > Hence I think that if we tie the sequence number clearing to =
the
> > > > > > > inode being removed from the CIL (i.e. last unpin) we can dro=
p all
> > > > > > > the pin checks and use the commit sequence numbers directly t=
o
> > > > > > > determine what the correct behaviour should be...
> > > > > >
> > > > > > Here's a patch that implements this. It appears to pass fstests
> > > > > > without any regressions on my test VMs. Can you test it and che=
ck
> > > > > > that it retains the expected performance improvement for
> > > > > > O_DSYNC+DIO on fallocate()d space?
> > > > >
> > > > > Heh, I just wanted to send my version of the patch after all the =
tests
> > > > > passed :). Anyway, I've given your patch a spin with the test I h=
ave
> > > and
> > > > > its performance looks good. So feel free to add:
> > > > >
> > > > > Tested-by: Jan Kara <jack@suse.cz>
> > > >
> > > > Thanks!
> > > >
> > > > > BTW I don't have customer setup with DB2 available where the huge
> > > > > difference is visible (I'll send them backport of the patch to th=
eir
> > > SUSE
> > > > > kernel once we settle on it) but I have written a tool that repla=
ys the
> > > > > same set of pwrites from same set of threads I've captured from s=
yscall
> > > > > trace. It reproduces only about 20% difference between good & bad
> > > kernels
> > > > > on my test machine but it was good enough for the bisection and
> > > analysis
> > > > > and the customer confirmed that the revert of what I've bisected =
to
> > > > > actually fixes their issue (rwsem reader lockstealing logic).
> > > >
> > > > It was also recently bisected on RHEL 8.x to the introduction of
> > > > rwsem spin-on-owner changes from back in 2019. Might be the same
> > > > commit you are talking about, but either way it's an indication of
> > > > rwsem lock contention rather than a problem with the rwsems
> > > > themselves.
> > >
> > > Right. I've also come to a conclusion that the real problem is the to=
o
> > > heavy use of ILOCK and not the rwsem behavior itself. Hence this patc=
h :).
> > >
> > > > > So I'm
> > > > > reasonably confident I'm really reproducing their issue.
> > > >
> > > > Ok, that's good to know. I was thinking that maybe a fio recipe
> > > > might show it up, too, but I'm not sure about that nor do I have th=
e
> > > > time to investigate it...
> > >
> > > I was actually trying hard to come up with a fio recipe to reproduce =
this
> > > but I've failed. As you are noting in your changelog, this workload i=
s
> > > bound by log throughput and one of the obvious differences between fa=
st and
> > > slow kernels is that fast kernels do less larger log forces while slo=
w
> > > kernels do many tiny log forces (with obvious consequences for throug=
hput,
> > > in particular because we tend to relog the same blocks over and over =
again
> > > - the slow kernels end up logging about 3x as much data in total).  N=
ow
> > > with fio the jobs were always managing to cram enough changes in one =
log
> > > force for the difference to not be visible. Somehow the distribution =
of
> > > writes among threads (and possibly their location determining how the=
 btree
> > > gets fragmented and which blocks get logged) DB2 creates is pretty pe=
culiar
> > > so that it makes such a big difference.
> > >
> > > > > So I just wanted to suggest that as a possible optimization (my p=
atch
> > > > > attached for reference). But regardless of whether you do the cha=
nge
> > > or not
> > > > > I think the patch is good to go.
> > > >
> > > > I was on the fence about using READ_ONCE/WRITE_ONCE.
> > > >
> > > > However, xfs_csn_t is 64 bit and READ_ONCE/WRITE_ONCE doesn't
> > > > prevent torn reads of 64 bit variables on 32 bit platforms. A torn
> > > > read of a commit sequence number will result in a transient data
> > > > integrity guarantee failure, and so I decided to err on the side of
> > > > caution....
> > >
> > > Hum, right. I didn't think of 32-bits.
> > >
> > > > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > > > index 829675700fcd..2a90e156b072 100644
> > > > > --- a/fs/xfs/xfs_inode_item.c
> > > > > +++ b/fs/xfs/xfs_inode_item.c
> > > > > @@ -145,18 +145,7 @@ xfs_inode_item_precommit(
> > > > >             flags |=3D XFS_ILOG_CORE;
> > > > >     }
> > > > >
> > > > > -   /*
> > > > > -    * Record the specific change for fdatasync optimisation. Thi=
s
> > > allows
> > > > > -    * fdatasync to skip log forces for inodes that are only time=
stamp
> > > > > -    * dirty. Once we've processed the XFS_ILOG_IVERSION flag, co=
nvert
> > > it
> > > > > -    * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
> > > > > -    * (ili_fields) correctly tracks that the version has changed=
.
> > > > > -    */
> > > > >     spin_lock(&iip->ili_lock);
> > > > > -   iip->ili_fsync_fields |=3D (flags & ~XFS_ILOG_IVERSION);
> > > > > -   if (flags & XFS_ILOG_IVERSION)
> > > > > -           flags =3D ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CO=
RE);
> > > > > -
> > > > >     /*
> > > > >      * Inode verifiers do not check that the CoW extent size hint=
 is an
> > > > >      * integer multiple of the rt extent size on a directory with=
 both
> > > > > @@ -204,6 +193,23 @@ xfs_inode_item_precommit(
> > > > >             xfs_trans_brelse(tp, bp);
> > > > >     }
> > > > >
> > > > > +   /*
> > > > > +    * Set the transaction dirty state we've created back in inod=
e item
> > > > > +    * before mangling flags for storing on disk. We use the valu=
e
> > > later in
> > > > > +    * xfs_inode_item_committing() to determine whether the
> > > transaction is
> > > > > +    * relevant for fdatasync or not. ili_dirty_flags gets cleare=
d in
> > > > > +    * xfs_trans_ijoin() before adding inode to the next transact=
ion.
> > > > > +    */
> > > > > +   iip->ili_dirty_flags =3D flags;
> > > > > +
> > > > > +   /*
> > > > > +    * Now convert XFS_ILOG_IVERSION flag to XFS_ILOG_CORE so tha=
t the
> > > > > +    * actual on-disk dirty tracking (ili_fields) correctly track=
s
> > > that the
> > > > > +    * version has changed.
> > > > > +    */
> > > > > +   if (flags & XFS_ILOG_IVERSION)
> > > > > +           flags =3D ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CO=
RE);
> > > > > +
> > > >
> > > > OK, I think I might have missed this. I'll check/fix it, and send a=
n
> > > > updated version for inclusion.
> > >
> > > Yeah, your version may miss we've set XFS_ILOG_CORE in flags in
> > > xfs_inode_item_precommit(). Frankly, I wasn't sure whether fdatasync(=
) not
> > > flushing the log in these cases it fine or not so I've just preserved=
 the
> > > existing behavior in my patch.
> > >
> > >                                                                 Honza
> > >
> > > --
> > > Jan Kara <jack@suse.com>
> > > SUSE Labs, CR
> > >
> > >
> >
> > --
> > Lukas Herbolt
> > SSME
> > Red Hat
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
>


--=20
Lukas Herbolt
SSME
Red Hat

