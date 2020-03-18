Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA037C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 17:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77AA12071C
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 17:13:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMFzr/Lx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCRRN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 13:13:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:33883 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbgCRRNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 13:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584551633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bvn/BOfHlMmHUKuLR+8dugoXH64B16plXMrPQ8U4dj8=;
        b=VMFzr/LxzU/Hz9ypxywQ+2KyNrxv5zUMWt4YmKezaPywjhrpYcZpMLGg863eSQNtbdPTEC
        SOBpOwN0MoRWtchCCNtHHvy1BikNUxcx32RuKHRWzMsjrHgpD1bPIT8cS9H1bkThkmRyNY
        0G+0xckff2jl022VhJD+NN2G+/AVIrk=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-AruSBVhnO4eS3IOHCqGzww-1; Wed, 18 Mar 2020 13:13:52 -0400
X-MC-Unique: AruSBVhnO4eS3IOHCqGzww-1
Received: by mail-ua1-f71.google.com with SMTP id 77so4489262uaj.8
        for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2020 10:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bvn/BOfHlMmHUKuLR+8dugoXH64B16plXMrPQ8U4dj8=;
        b=o5Dy7kWAXAIJoD8FejzPtDAuJnhWV6yrDODth9fkJhwoegR0lk/IHU0VwqaKV+WFQY
         Myjsx3+i6UIPe5OkwXU2Qtd2rJ0JKPAK3C6MkD1gnNp6hScL11vzRCGmKFGS+Jh5Mi1P
         rfeVbq+dd6W8kDlJz9U7W5DwRAu2ZnEf5ckFylw1cSzVKwy1LLv9+ggN7J9yAJUjMgru
         b7+EdvJjJ+eVFu7jV+Fe4VCSDGNOc54BDROVaOgbPZVdeF3fphRPslEX1VgDdDrUcOGq
         sYsjLdxT/AdSHJW2huYd901qBcrXPPF+ICvj/1pFhtCWWrQCkSQMkHuP6SNpwnZiKwYg
         ZBmw==
X-Gm-Message-State: ANhLgQ0YWOHAvIAnQFGbns39io9B7qa20Yt4x4wREQ1/ZYDSmlQ2JLwI
        qMdPmAZz8Hc1pff67e8RQHZNEGKCyP14ATO0qn35iNktBOARb/XGWM3A9hc6Fhj8qWmBu0tyXSU
        8CZffE37s6x1lbkyYANZA1TrDojynRGdIbPyA
X-Received: by 2002:a67:30c4:: with SMTP id w187mr4030525vsw.77.1584551631444;
        Wed, 18 Mar 2020 10:13:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvIKnEfzoWGegZGVm+mQgOZ00ha9qMN2x0vTJEoSPKmOt9BAVc2t1/CRhr6uLLOkazWv1zjxuWRtgpltgWSJNM=
X-Received: by 2002:a67:30c4:: with SMTP id w187mr4030500vsw.77.1584551631089;
 Wed, 18 Mar 2020 10:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200227203636.317790-1-preichl@redhat.com> <20200227203636.317790-2-preichl@redhat.com>
 <20200228171014.GC8070@magnolia>
In-Reply-To: <20200228171014.GC8070@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Wed, 18 Mar 2020 18:13:32 +0100
Message-ID: <CAJc7PzUGViiVOuaJz8+cPoxGZZiLkNq23vamCdLktJtxpmRh_Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] xfs: Refactor xfs_isilocked()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 6:10 PM Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
>
> On Thu, Feb 27, 2020 at 09:36:33PM +0100, Pavel Reichl wrote:
> > Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked()=
.
> > __xfs_rwsem_islocked() is a helper function which encapsulates checking
> > state of rw_semaphores hold by inode.
> >
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > Suggested-by: Dave Chinner <dchinner@redhat.com>
> > Suggested-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > Changes from V5:
> >       Drop shared flag from __xfs_rwsem_islocked()
> >
> >
> >  fs/xfs/xfs_inode.c | 42 ++++++++++++++++++++++++++----------------
> >  fs/xfs/xfs_inode.h |  2 +-
> >  2 files changed, 27 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c5077e6326c7..4faf7827717b 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -345,32 +345,42 @@ xfs_ilock_demote(
> >  }
> >
> >  #if defined(DEBUG) || defined(XFS_WARN)
> > -int
> > +static inline bool
> > +__xfs_rwsem_islocked(
> > +     struct rw_semaphore     *rwsem,
> > +     bool                    excl)
> > +{
> > +     if (!rwsem_is_locked(rwsem))
> > +             return false;
>
> So, uh, I finally made the time to dig through what exactly lockdep
> provides as far as testing functions, and came up with the following
> truth table for the old xfs_isilocked behavior w.r.t. IOLOCK:

Thank you for doing that and I'm sorry that I'm replying with such a delay.

>
> (nolockdep corresponds to debug_locks =3D=3D 0)
>
> RWSEM STATE             PARAMETERS TO XFS_ISILOCKED:
>                         SHARED  EXCL    SHARED | EXCL
> readlocked              y       n       y
> writelocked             y       y       y
> unlocked                n       n       n
> nolockdep readlocked    y       y       y
> nolockdep writelocked   y       y       y
> nolockdep unlocked      n       y       n
>
> Note that EXCL =C3=97 nolockdep_unlocked returns an incorrect result, but
> because we only use it with ASSERTs there haven't been any failures
> reported.
>
> And here's your new version:
>
> readlocked              y       y       y
> writelocked             y       n       n
> unlocked                n       n       n
> nolockdep readlocked    y       y       y
> nolockdep writelocked   y       y       y
> nolockdep unlocked      n       n       n
>
> Thanks for fixing the false positive that I mentioned above.
>
> > +
> > +     if (debug_locks && excl)
> > +             return lockdep_is_held_type(rwsem, 1);
>
> This is wrong, the second parameter of lockdep_is_held_type is 0 to test
> if the rwsem is write-locked; 1 to test if it is read-locked; or -1 to
> test if the rwsem is read or write-locked.

Thank you for noticing.


>
> So, this function's call signature should change so that callers can
> communicate both _SHARED and _EXCL; and then you can pick the correct

Thanks for the suggestion...but that's how v5 signature looked like
before Christoph and Eric requested change...on the grounds that
there're:
*  confusion over a (true, true) set of args
*  confusion of what happens if we pass (false, false).

> "r" parameter value for the lockdep_is_held_type() call.  Then all of
> this becomes:
>
>         if !debug_locks:
>                 return rwsem_is_locked(rwsem)
>
>         if shared and excl:
>                 r =3D -1
>         elif shared:
>                 r =3D 1
>         else:
>                 r =3D 0
>         return lockdep_is_held_type(rwsem, r)

I tried to create a table for this code as well:

readlocked              y       n       y
writelocked             *n*       y       y
unlocked                n       n       n
nolockdep readlocked    y       y       y
nolockdep writelocked   y       y       y
nolockdep unlocked      n       n       n

I think that when we query writelocked lock for being shared having
'no' for an answer may not be expected...or at least this is how I
read the code.

int __lock_is_held(const struct lockdep_map *lock, int read)
{
        struct task_struct *curr =3D current;
        int i;

        for (i =3D 0; i < curr->lockdep_depth; i++) {
                struct held_lock *hlock =3D curr->held_locks + i;

                if (match_held_lock(hlock, lock)) {
                        if (read =3D=3D -1 || hlock->read =3D=3D read)
                                return 1;

                        return 0;
                }
        }

        return 0;
}

Thanks for any comments

>
> Note also that you don't necessarily need to pass shared and excl as
> separate parameters (as you did in v3); the XFS_*LOCK_{EXCL,SHARED}
> definitions enable you to take care of all that with some clever bit
> shifting and masking.
>
> --D
>
> > +
> > +     return true;
> > +}
> > +
> > +bool
> >  xfs_isilocked(
> > -     xfs_inode_t             *ip,
> > +     struct xfs_inode        *ip,
> >       uint                    lock_flags)
> >  {
> > -     if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> > -             if (!(lock_flags & XFS_ILOCK_SHARED))
> > -                     return !!ip->i_lock.mr_writer;
> > -             return rwsem_is_locked(&ip->i_lock.mr_lock);
> > +     if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> > +             return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
> > +                             (lock_flags & XFS_ILOCK_EXCL));
> >       }
> >
> > -     if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> > -             if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> > -                     return !!ip->i_mmaplock.mr_writer;
> > -             return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> > +     if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> > +             return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
> > +                             (lock_flags & XFS_MMAPLOCK_EXCL));
> >       }
> >
> > -     if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
> > -             if (!(lock_flags & XFS_IOLOCK_SHARED))
> > -                     return !debug_locks ||
> > -                             lockdep_is_held_type(&VFS_I(ip)->i_rwsem,=
 0);
> > -             return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
> > +     if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> > +             return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
> > +                             (lock_flags & XFS_IOLOCK_EXCL));
> >       }
> >
> >       ASSERT(0);
> > -     return 0;
> > +     return false;
> >  }
> >  #endif
> >
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 492e53992fa9..3d7ce355407d 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -416,7 +416,7 @@ void              xfs_ilock(xfs_inode_t *, uint);
> >  int          xfs_ilock_nowait(xfs_inode_t *, uint);
> >  void         xfs_iunlock(xfs_inode_t *, uint);
> >  void         xfs_ilock_demote(xfs_inode_t *, uint);
> > -int          xfs_isilocked(xfs_inode_t *, uint);
> > +bool         xfs_isilocked(xfs_inode_t *, uint);
> >  uint         xfs_ilock_data_map_shared(struct xfs_inode *);
> >  uint         xfs_ilock_attr_map_shared(struct xfs_inode *);
> >
> > --
> > 2.24.1
> >
>

