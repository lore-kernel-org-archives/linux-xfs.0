Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B594C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 09:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE8364F41
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 09:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhCRJwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 05:52:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229785AbhCRJvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 05:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616061103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LD3vADOwrq+InaBHxbZWWh5xtRnlZ5DSGoSF8obvd60=;
        b=BtHc+ZdA7fAZpadslTFzQdDGbt0p3z7Sq/HWmReLdqn//Cy54u/hGOfNsUFKrlJQrSD6PX
        to2jZDLL3szJ+fz3t35MmU9CJGGPA8u1ghl3l0bg8aXIxdeBE8nDz5sm75jnQGwaENATJ7
        cmbxUMZzI19EaYpxXv/SoVrPghjVbX8=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-oDPu56woMnW5qlzE-OuwYw-1; Thu, 18 Mar 2021 05:51:41 -0400
X-MC-Unique: oDPu56woMnW5qlzE-OuwYw-1
Received: by mail-yb1-f200.google.com with SMTP id g17so48077619ybh.4
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 02:51:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LD3vADOwrq+InaBHxbZWWh5xtRnlZ5DSGoSF8obvd60=;
        b=qnhELUGTyjszxrnq+37paRSQPgpI3KVaJV4Oh7SvUtiqPKjXEXdo8LojWmHxjdIGpT
         qWu+T3O8yLpICUVEEMUWzRe2ovzUZcRyat7tvZGbajBwy1Z/kme2G40t7kM44Av2L1eX
         kvuZEeTll9f0EauvB0qeX7UwGNuUE3HEDnWX2U6vrqrKijWkt0hwSU7ymVMf6VgF7P/V
         Fu1TbhfGLkWOaNjz2qvgM9Um28WvQ63/PKyVKkvSEiOg8TlxCw2j6D3Y3rcuTig0j057
         BgGWXqfbchQOHgIGIO/2eyb7NFr67PRF1ppLYhbhnInu5TtgCkgSRQAJLlmIoQA8By9j
         tGiw==
X-Gm-Message-State: AOAM532pmYMlJ4dREHdQ+qNfC47KSV1qerVFgGS0HjouO9jNPtm8/9pf
        lY4Rds7Pog4Pmyz31d7OXP2XIT7WMAeBy1RhGpf2bVWxaCL+8Oj6s4fAalQALiFzfl50x2LNkDC
        /SVO4m1v2ATrqpACMRpx83BG3tL2iJH5wlJEU
X-Received: by 2002:a5b:d43:: with SMTP id f3mr3253676ybr.81.1616061101324;
        Thu, 18 Mar 2021 02:51:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/vY1k7DqyBHNDlU9PXfrjgZCoxTtcxoU0Szw9loUR7LgUT0ftrFeyqdshYiaA866w8JRs7VOZmn/Hm9zj4NA=
X-Received: by 2002:a5b:d43:: with SMTP id f3mr3253658ybr.81.1616061101080;
 Thu, 18 Mar 2021 02:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210316173226.2220046-1-omosnace@redhat.com> <20210316205010.GN63242@dread.disaster.area>
In-Reply-To: <20210316205010.GN63242@dread.disaster.area>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 18 Mar 2021 10:51:29 +0100
Message-ID: <CAFqZXNv5GPCU040gO3s-o2UTkXF3HExSkx2AjzE+4VC1REsQBg@mail.gmail.com>
Subject: Re: [PATCH] xfs: use has_capability_noaudit() instead of capable()
 where appropriate
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 10:09 PM Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Mar 16, 2021 at 06:32:26PM +0100, Ondrej Mosnacek wrote:
> > In cases when a negative result of a capability check doesn't lead to an
> > immediate, user-visible error, only a subtle difference in behavior, it
> > is better to use has_capability_noaudit(current, ...), so that LSMs
> > (e.g. SELinux) don't generate a denial record in the audit log each time
> > the capability status is queried. This patch should cover all such cases
> > in fs/xfs/.
>
> Is this something new? I only see 4 calls to
> has_capability_noaudit() in 5.12-rc3...

I don't know all the history, but I don't think it's new. It's just
that few people really are aware of the difference and no one from the
LSM/SELinux cared enough to maintain proper use across the kernel...

>
> Also, has_capability_noaudit() is an awful name. capable_noaudit()
> would actually be self explanatory to anyone who is used to doing
> capability checks via capable(), ns_capable(), ns_capable_noaudit(),
> inode_owner_or_capable(), capable_wrt_inode_uidgid(), etc...
>
> Please fix the name of this function to be consistent with the
> existing capability APIs before propagating it further into the
> kernel.

That's a fair point - I should take this opportunity to add the
missing function and add some documentation... I'll make sure to do
better in v2.

>
> > Note that I kept the capable(CAP_FSETID) checks, since these will only
> > be executed if the user explicitly tries to set the SUID/SGID bit, and
> > it likely makes sense to log such attempts even if the syscall doesn't
> > fail and just ignores the bits.
>
> So how on earth are we supposed to maintain this code correctly?
> These are undocumented rules that seemingly are applied to random
> subsystems and to seemingly random capable() calls in those
> subsystems. ANd you don't even document it in this code where there
> are other capable(...) checks that will generate audit records...
>
> How are we supposed to know when an audit record should be emitted
> or not by some unknown LSM when we do a capability check?
> Capabilities are already an awful nightmare maze of similar but
> slightly different capability checks, and this doesn't improve the
> situation at all.
>
> Please make this easier to get right iand maintain correctly (an
> absolute, non-negotiable requirement for anything security related)
> before you spray yet another poorly documented capability function
> into the wider kernel.

Again, you're right that I shouldn't have taken the lazy path :)

>
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  fs/xfs/xfs_fsmap.c | 4 ++--
> >  fs/xfs/xfs_ioctl.c | 5 ++++-
> >  fs/xfs/xfs_iops.c  | 6 ++++--
> >  fs/xfs/xfs_xattr.c | 2 +-
> >  4 files changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 9ce5e7d5bf8f..14672e7ee535 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -842,8 +842,8 @@ xfs_getfsmap(
> >           !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
> >               return -EINVAL;
> >
> > -     use_rmap = capable(CAP_SYS_ADMIN) &&
> > -                xfs_sb_version_hasrmapbt(&mp->m_sb);
> > +     use_rmap = xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> > +                has_capability_noaudit(current, CAP_SYS_ADMIN);
> >       head->fmh_entries = 0;
> >
> >       /* Set up our device handlers. */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 3fbd98f61ea5..3cfc1a25069c 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1470,8 +1470,11 @@ xfs_ioctl_setattr(
> >
> >       if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
> >           ip->i_d.di_projid != fa->fsx_projid) {
> > +             int flags = has_capability_noaudit(current, CAP_FOWNER) ?
> > +                     XFS_QMOPT_FORCE_RES : 0;
> > +
> >               code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
> > -                             capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
> > +                             flags);
> >               if (code)       /* out of quota */
> >                       goto error_trans_cancel;
> >       }
>
> You missed a capable() call here - see the call to
> xfs_trans_alloc_ichange( ... capabale(CAP_FOWNER), ...); in
> xfs_ioctl_setattr_get_trans().

Ah, I mistakenly based the path against an old tree. Sorry, I'll redo
it against xfs/for-next...

>
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 67c8dc9de8aa..abbb417c4fbd 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -729,10 +729,12 @@ xfs_setattr_nonsize(
> >               if (XFS_IS_QUOTA_RUNNING(mp) &&
> >                   ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
> >                    (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
> > +                     int flags = has_capability_noaudit(current, CAP_FOWNER) ?
> > +                             XFS_QMOPT_FORCE_RES : 0;
> > +
> >                       ASSERT(tp);
> >                       error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> > -                                             NULL, capable(CAP_FOWNER) ?
> > -                                             XFS_QMOPT_FORCE_RES : 0);
> > +                                             NULL, flags);
> >                       if (error)      /* out of quota */
> >                               goto out_cancel;
> >               }
>
> You missed a capable() call here - see the call to
> xfs_trans_alloc_ichange( ... capabale(CAP_FOWNER), ...); in this
> function.
>
> I think this demonstrates just how fragile and hard to maintain the
> approach being taken here is.
>
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index bca48b308c02..a99d19c2c11f 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -164,7 +164,7 @@ xfs_xattr_put_listent(
> >                * Only show root namespace entries if we are actually allowed to
> >                * see them.
> >                */
> > -             if (!capable(CAP_SYS_ADMIN))
> > +             if (!has_capability_noaudit(current, CAP_SYS_ADMIN))
> >                       return;
> >
> >               prefix = XATTR_TRUSTED_PREFIX;
>
> This one should absolutely report a denial - someone has tried to
> read the trusted xattr namespace without permission to do so. That's
> exactly the sort of thing I'd want to see in an audit log - just
> because we just elide the xattrs rather than return an error doesn't
> mean we should not leave an audit trail from the attempted access
> of kernel trusted attributes...

I'm not sure about that... without CAP_SYS_ADMIN the caller would
still get the ACL xattrs, no? IIUC, it's a filter to not show
restricted xattrs to unprivileged users via listxattr(2)**, where the
user is not saying "give me the trusted xattrs", just "give me
whatever I'm allowed to see", so logging the denial wouldn't make much
sense - the user may not even care about trusted xattrs when doing the
syscall (and in 99% of cases a user without CAP_SYS_ADMIN really
won't).

(**) But I don't understand how exactly that function is used and what
the XFS_ATTR_ROOT flag means, so I may be getting it wrong...


--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

