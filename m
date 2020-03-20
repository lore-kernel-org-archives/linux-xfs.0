Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B699C4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 14:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43E5020732
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 14:41:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f1y+pObV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCTOlY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 10:41:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49583 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726847AbgCTOlY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 10:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584715283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kQdTuKtN7CvC5CjXuyX6MovaGe8L1rN4yrrHBeMrql0=;
        b=f1y+pObVrQg2AneRi2CI/1o62nPtzo/42Z7eKLNHRJMgiKEyMItSWYroEwIunKIunGuib6
        gO+uH01Xruer2eN7V7Iybe+jgrZFYnvBwWUmbfvj1g8pQdyz8lECF5lAwNevxo3gJQC0gH
        0c8kpOH6lQSevZuzqIqHww7IThHEjhk=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-7ixHB9yeMzmod5NpWe9Nbg-1; Fri, 20 Mar 2020 10:41:21 -0400
X-MC-Unique: 7ixHB9yeMzmod5NpWe9Nbg-1
Received: by mail-vk1-f199.google.com with SMTP id s128so1914732vkb.6
        for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2020 07:41:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQdTuKtN7CvC5CjXuyX6MovaGe8L1rN4yrrHBeMrql0=;
        b=qvOxIt1hk0HAhSPQkZoogcFmrfSL/egZxrt9Lo7JJGwt77h2M/tCu8/N3LAjQMNUQ2
         FbcZJvHn5sbFotT9JKiByOqXNCBhzk2do00V0JUHWaHkzXFQR+xiRAMVpQspvQOC0tY7
         qYHKxHLJd3+pMy2llGXu7hesGpT2siBNYhZF/lFDaK/reqk5gBgT6Opa6sPkpKAGPHZg
         kbxGenZy0cd4OlBhahbyihtNTGJnDS8sm/dnbavQizTqtPWgCK0ZivSgt/mhiqZxq8Yh
         suJ96F64mXN7bwUtMKBMPt3Fa1LSO/P3vI7r+dQC32VozgS8oRMpPQQvWYfHsa3csUox
         scaw==
X-Gm-Message-State: ANhLgQ10P+n9eVTSae+OjVvdLEGhTGb1ZowSphA8Lhy4bAhc/T1ebh85
        y1cqRR8bsIbdaeKfRClT8ugb0/qJS93BgkZrkggjzMq1+OSJmF8cDzVJk2Gu3UaM+pf+KxeBU75
        IULXjFneLqUqMaJgNl9Kd2jCi9cOK9Fesn/Jp
X-Received: by 2002:a05:6102:5ee:: with SMTP id w14mr6290765vsf.135.1584715279903;
        Fri, 20 Mar 2020 07:41:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtqcZeNySLh5gv2DACQYvMCeJsqEiRGXG939kwwddK/MxQ1CLGxk5qH8H1oHYP1+aTKBPKIPem4TDJm6Gmwve8=
X-Received: by 2002:a05:6102:5ee:: with SMTP id w14mr6290744vsf.135.1584715279651;
 Fri, 20 Mar 2020 07:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200227203636.317790-1-preichl@redhat.com> <20200227203636.317790-2-preichl@redhat.com>
 <20200228171014.GC8070@magnolia> <CAJc7PzUGViiVOuaJz8+cPoxGZZiLkNq23vamCdLktJtxpmRh_Q@mail.gmail.com>
 <62b07adc-eb63-0fd2-8206-38052abfe494@sandeen.net> <20200318184927.GE256767@magnolia>
In-Reply-To: <20200318184927.GE256767@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Fri, 20 Mar 2020 15:41:08 +0100
Message-ID: <CAJc7PzUW23DHtxOLbvYiX9mYMqqfyEbPb9YgQx-PA-mOvnJE_Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] xfs: Refactor xfs_isilocked()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 7:50 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Mar 18, 2020 at 12:46:37PM -0500, Eric Sandeen wrote:
> > On 3/18/20 12:13 PM, Pavel Reichl wrote:
> > > On Fri, Feb 28, 2020 at 6:10 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > ...
> >
> > >> So, this function's call signature should change so that callers can
> > >> communicate both _SHARED and _EXCL; and then you can pick the correct
> > >
> > > Thanks for the suggestion...but that's how v5 signature looked like
> > > before Christoph and Eric requested change...on the grounds that
> > > there're:
> > > *  confusion over a (true, true) set of args
> > > *  confusion of what happens if we pass (false, false).
>
> Yeah.  I don't mean adding back the dual booleans, I meant refactoring
> the way we define the lock constants so that you can use bit shifting
> and masking:
>
> #define XFS_IOLOCK_SHIFT        0
> #define XFS_ILOCK_SHIFT         2
> #define XFS_MMAPLOCK_SHIFT      4
>
> #define XFS_SHARED_LOCK_SHIFT   1
>
> #define XFS_IOLOCK_EXCL     (1 << (XFS_IOLOCK_SHIFT))
> #define XFS_IOLOCK_SHARED   (1 << (XFS_IOLOCK_SHIFT + XFS_SHARED_LOCK_SHIFT))
> #define XFS_ILOCK_EXCL      (1 << (XFS_ILOCK_SHIFT))
> #define XFS_ILOCK_SHARED    (1 << (XFS_ILOCK_SHIFT + XFS_SHARED_LOCK_SHIFT))
> #define XFS_MMAPLOCK_EXCL   (1 << (XFS_MMAPLOCK_SHIFT))
> #define XFS_MMAPLOCK_SHARED (1 << (XFS_MMAPLOCK_SHIFT + XFS_SHARED_LOCK_SHIFT))

Thank you for the code - now I see what you meant and I like it,
however allow me a question:
Are you aware that XFS_IOLOCK_SHIFT, XFS_MMAPLOCK_SHIFT,
XFS_ILOCK_SHIFT are already defined with different values and used in
xfs_lock_inumorder()?

I have no trouble to investigate the code and see if it is OK i.g.
XFS_IOLOCK_EXCL to be 21 (I guess I should check that no bit arrays
are used to store the value, etc)

Or maybe I should just rewrite  the '#define XFS_IOLOCK_SHIFT
0' to something like '#define XFS_IOLOCK_TYPE_SHIFT        0' ?

Do you have any thoughts about that?

Thanks!


>
> Because then in the outer xfs_isilocked function you can do:
>
> if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED))
>         return __isilocked(&ip->i_lock, lock_flags >> XFS_ILOCK_SHIFT);
>
> if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED))
>         return __isilocked(&ip->i_mmaplock, lock_flags >> XFS_MMAPLOCK_SHIFT);
>
> if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED))
>         return __isilocked(&VFS_I(ip)->i_rwsem, lock_flags >> XFS_IOLOCK_SHIFT);
>
> And finally in __isilocked you can do:
>
> static inline bool __isilocked(rwsem, lock_flags)
> {
>         int     arg;
>
>         if (!debug_locks)
>                 return rwsem_is_locked(rwsem);
>
>         if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
>                 /*
>                  * The caller could be asking if we have (shared | excl)
>                  * access to the lock.  Ask lockdep if the rwsem is
>                  * locked either for read or write access.
>                  *
>                  * The caller could also be asking if we have only
>                  * shared access to the lock.  Holding a rwsem
>                  * write-locked implies read access as well, so the
>                  * request to lockdep is the same for this case.
>                  */
>                 arg = -1;
>         } else {
>                 /*
>                  * The caller is asking if we have only exclusive access
>                  * to the lock.  Ask lockdep if the rwsem is locked for
>                  * write access.
>                  */
>                 arg = 0;
>         }
>         return lockdep_is_held_type(rwsem, arg);
> }
>
> > >> "r" parameter value for the lockdep_is_held_type() call.  Then all of
> > >> this becomes:
> > >>
> > >>         if !debug_locks:
> > >>                 return rwsem_is_locked(rwsem)
> > >>
> > >>         if shared and excl:
> > >>                 r = -1
> > >>         elif shared:
> > >>                 r = 1
> > >>         else:
> > >>                 r = 0
> > >>         return lockdep_is_held_type(rwsem, r)
> > >
> > > I tried to create a table for this code as well:
> >
> > <adding back the table headers>
> >
> > > (nolockdep corresponds to debug_locks == 0)
> > >
> > > RWSEM STATE             PARAMETERS TO XFS_ISILOCKED:
> > >                         SHARED  EXCL    SHARED | EXCL
> > > readlocked              y       n       y
> > > writelocked             *n*     y       y
> > > unlocked                n       n       n
> > > nolockdep readlocked    y       y       y
> > > nolockdep writelocked   y       y       y
> > > nolockdep unlocked      n       n       n
> > >
> > > I think that when we query writelocked lock for being shared having
> > > 'no' for an answer may not be expected...or at least this is how I
> > > read the code.
> >
> > This might be ok, because
> > a) it is technically correct (is it shared? /no/ it is exclusive), and
> > b) in the XFS code today we never call:
> >
> >       xfs_isilocked(ip, XFS_ILOCK_SHARED);
> >
> > it's always:
> >
> >       xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
> >
> > So I think that if we document the behavior clearly, the truth table above
> > would be ok.
> >
> > Thoughts?
>
> No, Pavel's right, I got the pseudocode wrong, because holding a write
> lock means you also hold the read lock.
>
>         if !debug_locks:
>                 return rwsem_is_locked(rwsem)
>
>         if shared:
>                 r = -1
>         else:
>                 r = 0
>         return lockdep_is_held_type(rwsem, r)
>
> --D
>
> > -Eric
>

