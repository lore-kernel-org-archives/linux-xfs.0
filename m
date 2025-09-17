Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97255309DB1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 10:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758104901; cv=none; b=dKTdPxBqImOI7W0NYNXVArI/0EEx8SY3+hDkiqILw6KVPfGdIIZdYUf8V9R8kO2Zs3M7edZi4eLIyn+Wyc0BtArEkTrM7EW9uFysGk4c9a8nkUAuPfsuEp8U57lxYYfISUnsN3jwEv714iEPDVx86c6iYasrjyWfuwVDsrJGuK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758104901; c=relaxed/simple;
	bh=86gJByRXwq9kuQ24ts14+BEC/rw0wzopAqsPP5NgRS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rC9gLgF4CsHxmPSEc9Q4NsmF0QKXChd1G6LBv+3lzxZGyvuzVsk4qRmBQCook/xVskKU92u6T6uQJ8qzkviqXx9mwCLQ2kGMNKOff3KdytPsfO18sWn5Yubh//Y1Hwi1RpoUgntrtjUimzbM6KnWD1/K+dgS3kZDEBcDDtLobRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YN9Nlw7+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YN9Nlw7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758104898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUAAnQLRCMhuZlzWRZLVPvQOh9GD2sSpiXk/7HQIAYg=;
	b=YN9Nlw7+Gimfjyl9I/4iZti+27lmbhZEZyfs/Bt2uMxp9d+ryotPcpyewRag9fDALJkvAB
	SochVsOAohHGsFKq/vDwIR0EoqHQpWZap/fzLKucXL4YfPcE/agIoBP6K99VUyWVC+cnWn
	WGpz0w4zIaANAAx7H/AryPrUfCfVA6k=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-3e3mjF1CPA2P0Zuyw6-H5w-1; Wed, 17 Sep 2025 06:28:16 -0400
X-MC-Unique: 3e3mjF1CPA2P0Zuyw6-H5w-1
X-Mimecast-MFC-AGG-ID: 3e3mjF1CPA2P0Zuyw6-H5w_1758104896
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4020e59b735so175049355ab.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 03:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758104896; x=1758709696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TUAAnQLRCMhuZlzWRZLVPvQOh9GD2sSpiXk/7HQIAYg=;
        b=pO1kQaPYLb2X831HIBGFcp4aq2ZWSWSuHHC/8Mdxv8aCeZpy8TIgQzG053JiAmOtSA
         jurtS6o94aYK5bYMAAJO7qk181WtVOM8a/QQMItgDmKxnCkDvlxarbZB3dOm5qsFhhAv
         y9wPh0TK+ixHLqAeMeT2PJRcZn2ePczL1iHvcwCx/sVXYLNFU3hO5Q8GV6aX6h5zhFop
         jZ8mksMsJitlCFe4x+y92MrwBmpUlSmf0aSUPc4dPdSL3h43Ye2A1MU3lWv8LRAtorpz
         jYGDsvyfMifGbMvznjqDvqyEEE2OpDjvnQJle/9krbjHzuEYoF7BKGvbvmk9nZKZZWXw
         U2Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWSCfz9HgWYWGoAWkMst0D2hj8sCebU5/g0huwC2Z1cW8KKYW17a20VN617PArAkLYTRZnvRdtIGH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYSMkaL+TixMKBzNZ8jc6YMM+1qm0ZgyWxiQZ3A+K7yl0YAr4a
	oh8QM1xXG76ba8U6yfuve2KEtbK0FNWRWff9vhawFfJdBlLFPtXYug3p+mwyrisz/CkM6Fya2QB
	mYUjRne6Ew8KYyddbgT+AxXTtgEMhPPtUrapjX8TwAfPaswGG9UfcV22CxZr6Qx7soAvw3hdUzf
	nxp/xJabQ5DU5jhTA1iWe47nKV709u80/VzExn
X-Gm-Gg: ASbGncsFzlaYGdvAsL+GELMiyj0QSS+xG5oIRp+pRx7KQRQ2Rlx40/S6hQ5sUiBeczj
	ZU9oPSmnGaLotA3vlG6/QS5B+BkOlCbdxwqz8u9V9a62XfpKfXS6pQ0Be4GZuU+R/d/VIU86EwT
	RB9Q6dJ65UATmWTC2LIQ==
X-Received: by 2002:a05:6e02:1608:b0:418:aefa:bb83 with SMTP id e9e14a558f8ab-4241a4bde68mr17443905ab.5.1758104895649;
        Wed, 17 Sep 2025 03:28:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpOUltTeogQgowkk2m2EL8GXixc/YZCgi2P1Hb4f7xuX6JUAB/JYg7PDkKOjDXHJ3rytKEGR26TcYpEsccTLI=
X-Received: by 2002:a05:6e02:1608:b0:418:aefa:bb83 with SMTP id
 e9e14a558f8ab-4241a4bde68mr17443765ab.5.1758104895269; Wed, 17 Sep 2025
 03:28:15 -0700 (PDT)
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
In-Reply-To: <hgk4f5iatzmdmrueuqww56nzc6cdev2mjbkcxxcytkaukzby34@5cwqi3j7pdie>
From: Lukas Herbolt <lherbolt@redhat.com>
Date: Wed, 17 Sep 2025 12:27:38 +0200
X-Gm-Features: AS18NWD8bvmRvLXcKKtnp7laxly18qxC2TqYSKpvwOHGMmCBf1a_rvXDGIl0BvQ
Message-ID: <CAM4Jq_6jgKeWrOpRAXnFPr+_Dg3vBBFaOP4xNFhrgQt3C0=CvQ@mail.gmail.com>
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>> I was actually trying hard to come up with a fio recipe to reproduce thi=
s
>> but I've failed.
I have a similar issue with DB2 observed during index reorg/rebuild.
The db opens
the files with O_DSYNC|O_DIRECT and writes with libaio 256 x 4k writes (mos=
tly
sequential)  I believe that with the 256 and 4K depends on DB2
internal page size
and extent size. Anyway with bellow I am getting around ~18MB/s
without the patch
and around ~75MB/s with your patch. Need to test Dave's as well.

The fio file looks like this
---
[global]
name=3Dfio-seq-write
filename_format=3D/mnt/test/$jobname/$jobnum/fio.$filenum.$jobnum
rw=3Dwrite
bs=3D4k
direct=3D1
numjobs=3D10
time_based
runtime=3D20
nrfiles=3D1
size=3D4G
ioengine=3Dlibaio
iodepth=3D16
iodepth_batch_submit=3D16
iodepth_batch_complete_min=3D16
iodepth_batch_complete_max=3D16
group_reporting=3D1
gtod_reduce=3D1
sync=3Ddsync
fadvise_hint=3D1

[posix]
fallocate=3Dposix
stonewall
---


On Wed, Sep 17, 2025 at 12:07=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 17-09-25 07:32:11, Dave Chinner wrote:
> > On Tue, Sep 16, 2025 at 03:32:42PM +0200, Jan Kara wrote:
> > > On Tue 16-09-25 16:15:32, Dave Chinner wrote:
> > > > On Thu, Sep 11, 2025 at 10:59:15AM +1000, Dave Chinner wrote:
> > > > > i.e. if we clear the commit sequences on last unpin (i.e. in
> > > > > xfs_inode_item_unpin) then an item that is not in the CIL (and so
> > > > > doesn't have dirty metadata) will have no associated commit
> > > > > sequence number set.
> > > > >
> > > > > Hence if ili_datasync_commit_seq is non-zero, then by definition =
the
> > > > > inode must be pinned and has been dirtied for datasync purposes.
> > > > > That means we can simply query ili_datasync_commit_seq in
> > > > > xfs_bmbt_to_iomap() to set IOMAP_F_DIRTY.
> > > > >
> > > > > I suspect that the above fsync code can then become:
> > > > >
> > > > >         spin_lock(&iip->ili_lock);
> > > > >         if (datasync)
> > > > >                 seq =3D iip->ili_datasync_commit_seq;
> > > > >         else
> > > > >                 seq =3D iip->ili_commit_seq;
> > > > >         spin_unlock(&iip->ili_lock);
> > > > >
> > > > >         if (!seq)
> > > > >                 return 0;
> > > > >         return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, =
log_flushed);
> > > > >
> > > > > For the same reason. i.e. a non-zero sequence number implies the
> > > > > inode log item is dirty in the CIL and pinned.
> > > > >
> > > > > At this point, we really don't care about races with transaction
> > > > > commits. f(data)sync should only wait for modifications that have
> > > > > been fully completed. If they haven't set the commit sequence in =
the
> > > > > log item, they haven't fully completed. If the commit sequence is
> > > > > already set, the the CIL push will co-ordinate appropriately with
> > > > > commits to ensure correct data integrity behaviour occurs.
> > > > >
> > > > > Hence I think that if we tie the sequence number clearing to the
> > > > > inode being removed from the CIL (i.e. last unpin) we can drop al=
l
> > > > > the pin checks and use the commit sequence numbers directly to
> > > > > determine what the correct behaviour should be...
> > > >
> > > > Here's a patch that implements this. It appears to pass fstests
> > > > without any regressions on my test VMs. Can you test it and check
> > > > that it retains the expected performance improvement for
> > > > O_DSYNC+DIO on fallocate()d space?
> > >
> > > Heh, I just wanted to send my version of the patch after all the test=
s
> > > passed :). Anyway, I've given your patch a spin with the test I have =
and
> > > its performance looks good. So feel free to add:
> > >
> > > Tested-by: Jan Kara <jack@suse.cz>
> >
> > Thanks!
> >
> > > BTW I don't have customer setup with DB2 available where the huge
> > > difference is visible (I'll send them backport of the patch to their =
SUSE
> > > kernel once we settle on it) but I have written a tool that replays t=
he
> > > same set of pwrites from same set of threads I've captured from sysca=
ll
> > > trace. It reproduces only about 20% difference between good & bad ker=
nels
> > > on my test machine but it was good enough for the bisection and analy=
sis
> > > and the customer confirmed that the revert of what I've bisected to
> > > actually fixes their issue (rwsem reader lockstealing logic).
> >
> > It was also recently bisected on RHEL 8.x to the introduction of
> > rwsem spin-on-owner changes from back in 2019. Might be the same
> > commit you are talking about, but either way it's an indication of
> > rwsem lock contention rather than a problem with the rwsems
> > themselves.
>
> Right. I've also come to a conclusion that the real problem is the too
> heavy use of ILOCK and not the rwsem behavior itself. Hence this patch :)=
.
>
> > > So I'm
> > > reasonably confident I'm really reproducing their issue.
> >
> > Ok, that's good to know. I was thinking that maybe a fio recipe
> > might show it up, too, but I'm not sure about that nor do I have the
> > time to investigate it...
>
> I was actually trying hard to come up with a fio recipe to reproduce this
> but I've failed. As you are noting in your changelog, this workload is
> bound by log throughput and one of the obvious differences between fast a=
nd
> slow kernels is that fast kernels do less larger log forces while slow
> kernels do many tiny log forces (with obvious consequences for throughput=
,
> in particular because we tend to relog the same blocks over and over agai=
n
> - the slow kernels end up logging about 3x as much data in total).  Now
> with fio the jobs were always managing to cram enough changes in one log
> force for the difference to not be visible. Somehow the distribution of
> writes among threads (and possibly their location determining how the btr=
ee
> gets fragmented and which blocks get logged) DB2 creates is pretty peculi=
ar
> so that it makes such a big difference.
>
> > > So I just wanted to suggest that as a possible optimization (my patch
> > > attached for reference). But regardless of whether you do the change =
or not
> > > I think the patch is good to go.
> >
> > I was on the fence about using READ_ONCE/WRITE_ONCE.
> >
> > However, xfs_csn_t is 64 bit and READ_ONCE/WRITE_ONCE doesn't
> > prevent torn reads of 64 bit variables on 32 bit platforms. A torn
> > read of a commit sequence number will result in a transient data
> > integrity guarantee failure, and so I decided to err on the side of
> > caution....
>
> Hum, right. I didn't think of 32-bits.
>
> > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > index 829675700fcd..2a90e156b072 100644
> > > --- a/fs/xfs/xfs_inode_item.c
> > > +++ b/fs/xfs/xfs_inode_item.c
> > > @@ -145,18 +145,7 @@ xfs_inode_item_precommit(
> > >             flags |=3D XFS_ILOG_CORE;
> > >     }
> > >
> > > -   /*
> > > -    * Record the specific change for fdatasync optimisation. This al=
lows
> > > -    * fdatasync to skip log forces for inodes that are only timestam=
p
> > > -    * dirty. Once we've processed the XFS_ILOG_IVERSION flag, conver=
t it
> > > -    * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
> > > -    * (ili_fields) correctly tracks that the version has changed.
> > > -    */
> > >     spin_lock(&iip->ili_lock);
> > > -   iip->ili_fsync_fields |=3D (flags & ~XFS_ILOG_IVERSION);
> > > -   if (flags & XFS_ILOG_IVERSION)
> > > -           flags =3D ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> > > -
> > >     /*
> > >      * Inode verifiers do not check that the CoW extent size hint is =
an
> > >      * integer multiple of the rt extent size on a directory with bot=
h
> > > @@ -204,6 +193,23 @@ xfs_inode_item_precommit(
> > >             xfs_trans_brelse(tp, bp);
> > >     }
> > >
> > > +   /*
> > > +    * Set the transaction dirty state we've created back in inode it=
em
> > > +    * before mangling flags for storing on disk. We use the value la=
ter in
> > > +    * xfs_inode_item_committing() to determine whether the transacti=
on is
> > > +    * relevant for fdatasync or not. ili_dirty_flags gets cleared in
> > > +    * xfs_trans_ijoin() before adding inode to the next transaction.
> > > +    */
> > > +   iip->ili_dirty_flags =3D flags;
> > > +
> > > +   /*
> > > +    * Now convert XFS_ILOG_IVERSION flag to XFS_ILOG_CORE so that th=
e
> > > +    * actual on-disk dirty tracking (ili_fields) correctly tracks th=
at the
> > > +    * version has changed.
> > > +    */
> > > +   if (flags & XFS_ILOG_IVERSION)
> > > +           flags =3D ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> > > +
> >
> > OK, I think I might have missed this. I'll check/fix it, and send an
> > updated version for inclusion.
>
> Yeah, your version may miss we've set XFS_ILOG_CORE in flags in
> xfs_inode_item_precommit(). Frankly, I wasn't sure whether fdatasync() no=
t
> flushing the log in these cases it fine or not so I've just preserved the
> existing behavior in my patch.
>
>                                                                 Honza
>
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
>


--=20
Lukas Herbolt
SSME
Red Hat

