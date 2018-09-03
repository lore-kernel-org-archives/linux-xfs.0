Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35417 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbeICJrP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Sep 2018 05:47:15 -0400
Received: by mail-yb1-f195.google.com with SMTP id o17-v6so2896385yba.2
        for <linux-xfs@vger.kernel.org>; Sun, 02 Sep 2018 22:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
 <1535484161-11059-24-git-send-email-allison.henderson@oracle.com> <20180903032031.GO5631@dastard>
In-Reply-To: <20180903032031.GO5631@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Sep 2018 08:28:32 +0300
Message-ID: <CAOQ4uxj-cB4fXUJXyw0P+SZKm9xhRuPpYY_HVo2X+25hv2RAtQ@mail.gmail.com>
Subject: Re: [PATCH v8 23/28] xfs: Add parent pointers to rename
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Sep 3, 2018 at 6:26 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Aug 28, 2018 at 12:22:36PM -0700, Allison Henderson wrote:
> > This patch removes the old parent pointer attribute during the
> > rename operation, and re-adds the updated parent pointer
> >
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>
[...]
> >       }
> >
> >       /* RENAME_EXCHANGE is unique from here on. */
> > -     if (flags & RENAME_EXCHANGE)
> > -             return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> > +     if (flags & RENAME_EXCHANGE) {
> > +             error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
> >                                       target_dp, target_name, target_ip,
> >                                       spaceres);
> > -
> > +             goto out;
> > +     }
>
> This looks problematic, too. i.e.  On error, xfs_cross_rename() will
> have already called xfs_trans_cancel(), but it hasn't unlocked any
> of the inodes. If it succeeds, it commits the transaction. Either
> way, the transaction has been finished and freed. However, the
> code we jump to expects that the transaction is open and still
> running.
>
> Also "out" typically means "goto end of function and return". This
> is jumping to parent pointer addition, not the function return
> processing. Hence the label needs to be changed to
> "parent_pointer"....
>
[...]
> > +out:
> > +     if (xfs_sb_version_hasparent(&mp->m_sb)) {
> > +             error = xfs_parent_add_deferred(target_dp, tp, src_ip, target_name,
> > +                             new_diroffset);
>
> And so when we try to add the a parent pointers, we haven't checked
> if the cross rename failed and aborted the transaction. Or if it
> succeeded, it expects to continue using the transaction which
> xfs_cross_rename() committed.
>

Allison,

Not sure if you know that xfs_cross_rename() exchanges src with target, so
the src_dp parent pointer has to be adjusted as well in case of cross rename.

Thanks,
Amir.
