Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83E7CCA47C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 06:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiFWGiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 02:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiFWGiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 02:38:15 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19DD2A962;
        Wed, 22 Jun 2022 23:38:13 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id 75so5536818uav.9;
        Wed, 22 Jun 2022 23:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0B6TaiNF82K6ks5JviDSqCc7gv+DueOkbG9nd92dgPo=;
        b=IBq4MdJi0y5ER9cbVO5tN2naSFgSQJeMiryiKvfArufoGroKll1lD58xw2E00iCXyV
         5S06rRx9k0nm4g+2Jh5wp9Uk8AcP8mov2SeEC979n5e+Tx6mXhnhlWsSydOzj7zS8gP8
         CEz64+RzDzNxCovN3802g1SG7dEqVtK5upis9Ey5H1L5Hn+ItofJC7Y9NWnbb0pLV03L
         aNogKUEMmlHJDJv95WtnhXeDewVpLfwaFcscjjIH0Cw3GnVMkzbC9BgzU5fNNlB7/gA7
         iOD4vptrTr0HeaHEwQsE3St8vvGRK9hBhgQg7QCkXjZBQFCc1za4lGO56+R++Z5RGV0/
         hyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0B6TaiNF82K6ks5JviDSqCc7gv+DueOkbG9nd92dgPo=;
        b=NXJwix87DAw1c5eA9FChEvNbdZADHwx4d4IHGw6oOt0ljVJRhRCSnMaYJZCeXNRwVD
         tlgU4IRi6wSTCyCiqzrSdyalEmHUfxJVMNA007PaP8KOcgkSqSorJytjOHtIr9F0n2HD
         H7NpYkcep3zTyDZI5bHSl1Sx6b+fTHAJyFcTHWJ3CFNBLN9dcizVdbBl6a9H5e+fAMmH
         gd4zG96dUxzrtwgD6Y3Kid3ITEqNkgDRU79CpeLwCfxtglcZ/rQ4AH6d1DYl4x9AXXNx
         7mr8SziVmbTx+gbJka9IWiORA7AltKnYrlKDFPq41AEMh/u8TqclR5W/M9gtVEg1gz/E
         cXfw==
X-Gm-Message-State: AJIora/0N96AgPj/AQEGtNCVeE3HJWiwdeAAB4hFV/XcKwz2C4mVfvTp
        c3XWqph2XjTBVApCmGIeydcJ31DEDV+Nu2RfL69r4qax73ut3g==
X-Google-Smtp-Source: AGRyM1u3wHQXWkIZicp9B5c+pbODyRW9/4AoFjLNSPQvzZ8r3da1qS35QvObnWlXREHjl8ucbPnEhBOmkXdPcmToKUc=
X-Received: by 2002:ab0:67d2:0:b0:37f:d4b:f9c2 with SMTP id
 w18-20020ab067d2000000b0037f0d4bf9c2mr3634547uar.60.1655966292907; Wed, 22
 Jun 2022 23:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <20220617100641.1653164-10-amir73il@gmail.com>
 <YrNFb9999OY/8JDZ@magnolia> <CAOQ4uxi1th2XJ7Ss8avKjrR=k1wMw524+2+ahyafBhSAUsS7dQ@mail.gmail.com>
 <YrOo5wW6CtkK6p8C@magnolia>
In-Reply-To: <YrOo5wW6CtkK6p8C@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Jun 2022 09:38:01 +0300
Message-ID: <CAOQ4uxjrLUjStjDGOV2-0SK6ur07KZ8hAzb6JP+Dsm8=0iEbSA@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 09/11] xfs: only bother with
 sync_filesystem during readonly remount
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 2:42 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Jun 22, 2022 at 07:54:33PM +0300, Amir Goldstein wrote:
> > On Wed, Jun 22, 2022 at 7:38 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Fri, Jun 17, 2022 at 01:06:39PM +0300, Amir Goldstein wrote:
> > > > From: "Darrick J. Wong" <djwong@kernel.org>
> > > >
> > > > commit b97cca3ba9098522e5a1c3388764ead42640c1a5 upstream.
> > > >
> > > > In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
> > > > into xfs_fs_remount.  The only time that we ever need to push dirty file
> > > > data or metadata to disk for a remount is if we're remounting the
> > > > filesystem read only, so this really could be moved to xfs_remount_ro.
> > > >
> > > > Once we've moved the call site, actually check the return value from
> > > > sync_filesystem.
> >
> > This part is not really relevant for this backport, do you want me to
> > emphasise that?
>
> Not relevant?  Making sync_fs return error codes to callers was the
> entire reason for creating this series...
>
> > > >
> > > > Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >  fs/xfs/xfs_super.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > index 6323974d6b3e..dd0439ae6732 100644
> > > > --- a/fs/xfs/xfs_super.c
> > > > +++ b/fs/xfs/xfs_super.c
> > > > @@ -1716,6 +1716,11 @@ xfs_remount_ro(
> > > >       };
> > > >       int                     error;
> > > >
> > > > +     /* Flush all the dirty data to disk. */
> > > > +     error = sync_filesystem(mp->m_super);
> > >
> > > Looking at 5.10.124's fsync.c and xfs_super.c:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/sync.c?h=v5.10.124#n31
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/xfs/xfs_super.c?h=v5.10.124#n755
> > >
> > > I think this kernel needs the patch(es) that make __sync_filesystem return
> > > the errors passed back by ->sync_fs, and I think also the patch that
> > > makes xfs_fs_sync_fs return errors encountered by xfs_log_force, right?
> >
> > It wasn't my intention to fix syncfs() does not return errors in 5.10.
> > It has always been that way and IIRC, the relevant patches did not
> > apply cleanly.
>
> ...because right now userspace can call syncfs() on a filesystem that
> dies in the process, and the VFS eats the EIO and returns 0 to
> userspace.  Yes, that's the historical behavior fo 5.10, but that's a
> serious problem that needs addressing.  Eliding the sync_filesystem call
> during a rw remount is not itself all that exciting.

Yes, this is a just cause.

>
> > THIS patch however, fixes something else, not only the return of the error
> > to its caller, so I thought it was worth backporting.
>
> Assuming "something else" means "moving the sync_filesystem callsite" --
> that was a secondary piece that I did to get the requisite RVB tag under
> time pressure after 5.17-rc6 dropped.

Right. looking back at my notes:
https://github.com/amir73il/b4/commit/fddd6d961c029441d2f0e9dd86d0f83b754d0c47

I didn't pick this patch at all because of the missing dependencies.
I must have picked it up later from Laeh's series, because
I thought it was harmless to apply the "something else".

>
> > If you think otherwise, I'll drop it.
>
> On the contrary, I think the ->sync_fs fixes *also* need backporting.
> It should be as simple as patching __sync_filesystem:
>
> static int __sync_filesystem(struct super_block *sb, int wait)
> {
>         if (wait)
>                 sync_inodes_sb(sb);
>         else
>                 writeback_inodes_sb(sb, WB_REASON_SYNC);
>
>         if (sb->s_op->sync_fs) {
>                 int ret = sb->s_op->sync_fs(sb, wait);
>                 if (ret)
>                         return ret;
>         }
>         return __sync_blockdev(sb->s_bdev, wait);
> }
>
> Granted, that can be a part of the next batch.  If you plan to pick up
> the vfs sync_fs changes then I guess this one's ok for inclusion now.

I picked up the vfs fixes, it was pretty simple as you say.
I even backported "fs: remove __sync_filesystem" for dependency
to make the backport more straightforward.

But that adds 3 more more patches to the series and needs to go
back to testing, so I will just drop patch 9 from this batch.

Thanks,
Amir.
