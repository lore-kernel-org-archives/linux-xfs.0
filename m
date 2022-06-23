Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F72C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 04:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiFWEri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 00:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346096AbiFWEXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 00:23:03 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD76013D71;
        Wed, 22 Jun 2022 21:23:00 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id h38so11039113vsv.7;
        Wed, 22 Jun 2022 21:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pFrEfKD/U56o/sw4xb/sn32In6S7q3U8cJGbDDixPgY=;
        b=b3iKzEoko0m0+QUSEgtkacmZvILMMfu0t5WZ1wXeqictTgV7tFFl1ijC7FEM5n8QEy
         ru5/YaSUCWSrotCuK3bBYKjAZjWbjl6Gm0Lr4XQml1LPH4adhHBEyyPniopKzIw9Zpef
         UyCDpvB+pZHH7eWNc2hV0DQagDnW/EmCmI67oKcJ6OifJ5AQRhLcifZ9J0rj4si8e+/O
         2w7A7IeoWYJo2KVOvW4Jv8VcW248JQURK52fK6yPzt+RlCgrwIaKkfCtQWccdbsxWO8y
         A8jjilGYwFD7S10f8iXOTT4HVsmc1fsFfR9MOIC/R+0hq04HU1+NFzZ+plSfy0dYQ5B1
         nuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pFrEfKD/U56o/sw4xb/sn32In6S7q3U8cJGbDDixPgY=;
        b=W24T23uyPoS+lhG1/IOS9IxpTJ+6EFcthO4LSHXX12Nw1EuTgpbMae2/nenwnROPEj
         YgEZbDe2mycMj1BsRaMvbn1RIV3Ydw5x49tMZa+S26aNFnUJ9zY16E4QSn2thUnOIFje
         VZkx3YGE1S03tJuYU4jvenufjkqHSKxtjMQzQ42689pN/nDNEKXFcX0af7YymvXvNpsI
         oNpIelhgmo+jY7UvwFMaX7/EzQoaVH0w6j4r3EPWwRjT7og7TgRoLswS5n+aAeIaMJq+
         +dxneRF20h3HmOvupwpP44f+ls1GvzJvVHolA/Mdqxqy+r+wfqokBpd/YuXAXB7CXRdd
         +DBg==
X-Gm-Message-State: AJIora8fUHVsae2Zt/7mDeqATJRbLdX5CciFfg5erH7INAKFQ43vFl6w
        Ow4VbAHeTFk14iY45J52+E4haMy9zy8v+n/CpI4=
X-Google-Smtp-Source: AGRyM1sj5LCtfLVkgKK4rmsD3+s28YKetuf7RonC+1gz1hPVcnQMOux3s5yIh/F+jkFKQrqWUeKJ3yV6GJi0+pqRq9w=
X-Received: by 2002:a67:fa01:0:b0:354:3136:c62e with SMTP id
 i1-20020a67fa01000000b003543136c62emr9478594vsq.2.1655958179784; Wed, 22 Jun
 2022 21:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <20220617100641.1653164-12-amir73il@gmail.com>
 <YrNGJXYi2jQtPxs0@magnolia> <CAOQ4uxgXobea42K=WVyOhxxq+S=TA3RvLbxypKO02D9TZEgioA@mail.gmail.com>
 <YrOU/FPCEWkozAQI@google.com>
In-Reply-To: <YrOU/FPCEWkozAQI@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Jun 2022 07:22:48 +0300
Message-ID: <CAOQ4uxgEXC1v=JceqCwbmsbTaYqh7XUQ3dB=C-nLag4-BB4ArA@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 11/11] xfs: use setattr_copy to set vfs
 inode attributes
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 1:17 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> On Wed, Jun 22, 2022 at 09:36:53PM +0300, Amir Goldstein wrote:
> > On Wed, Jun 22, 2022 at 7:41 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Fri, Jun 17, 2022 at 01:06:41PM +0300, Amir Goldstein wrote:
> > > > From: "Darrick J. Wong" <djwong@kernel.org>
> > > >
> > > > commit e014f37db1a2d109afa750042ac4d69cf3e3d88e upstream.
> > > >
> > > > [remove userns argument of setattr_copy() for backport]
> > > >
> > > > Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> > > > revocation isn't consistent with btrfs[1] or ext4.  Those two
> > > > filesystems use the VFS function setattr_copy to convey certain
> > > > attributes from struct iattr into the VFS inode structure.
> > > >
> > > > Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> > > > decide if it should clear setgid and setuid on a file attribute update.
> > > > This is a second symptom of the problem that Filipe noticed.
> > > >
> > > > XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> > > > xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> > > > /not/ a simple copy function; it contains additional logic to clear the
> > > > setgid bit when setting the mode, and XFS' version no longer matches.
> > > >
> > > > The VFS implements its own setuid/setgid stripping logic, which
> > > > establishes consistent behavior.  It's a tad unfortunate that it's
> > > > scattered across notify_change, should_remove_suid, and setattr_copy but
> > > > XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> > > > functions and get rid of the old functions.
> > > >
> > > > [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> > > > [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> > > >
> > > > Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > Reviewed-by: Christian Brauner <brauner@kernel.org>
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > >
> > > Same question as I posted to Leah's series -- have all the necessary VFS
> > > fixes and whatnot been backported to 5.10?  Such that all the new sgid
> > > inheritance tests actually pass with this patch applied? :)
> >
> > The only patch I backorted to 5.10 is:
> > xfs: fix up non-directory creation in SGID directories
> >
> > I will check which SGID tests ran on my series.
> >
> > Personally, I would rather defer THIS patch to a later post to stable
> > (Leah's patch as well) until we have a better understanding of the state
> > of SGID issues.
> >
> > Thanks,
> > Amir.
>
> On the latest version of the SGID tests, I see failures of
> generic/68[3-7] and xfs/019 on both the baseline and backports branch.
> generic/673 fails on most configs for the baseline but seems to be fixed
> in the backports branch. Regardless, I am fine dropping this patch for
> this round.

Let's do that then.
I actually didn't plan to post this patch for this round to begin with.
I only posted it because you did.

Thanks,
Amir.
