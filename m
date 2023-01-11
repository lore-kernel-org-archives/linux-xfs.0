Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB25EC46467
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Jan 2023 03:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjAKDOe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Jan 2023 22:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjAKDOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2023 22:14:31 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA67DFDB
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2023 19:14:22 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id h185so11787747oif.5
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2023 19:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PIlhT0mLcvr3i6I9zH4G9h8dj3oxRUPYoVw78qlakek=;
        b=EuGmXo1iZlX+ZkB4DqAEYUqUeDdL8JALTPmGQy8CEo8YgoNX2mNqXomfZ9/2O2rnxD
         /r+CmJ7qanAF0IUyzbRdLLm51VBCWNGyWWT4BAqAROi58oirlE8amr+FDgLyIcX6xOBi
         rZ8IV4yVRgBqtiVVxhXqGf721eHs75r30IbL29FOCF4nKAmYiVYYlNgmR6PsqD64jM26
         tG+Eey10bK3AS38Q8J4KqyeNq9uj9qsG6MX32fYUjITsXWN9jePjnOdIefeUTVbjFIYo
         w1UYvDbNfVpWMEEEFLfn42mdN5/QFP3Cxj6RHxff+XLYuqy681anH8EEvNZ4Q07pGXEo
         URng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PIlhT0mLcvr3i6I9zH4G9h8dj3oxRUPYoVw78qlakek=;
        b=hoB69t5FPecsf7ba7xuc6ZTt2d9lw80/RKXx23Ne8Te+CsIB2qPpXWpVTuCIDqFm0T
         Q/ozZn4pZ8DZK8W9jnz4EJup7W3bPAua2Ym00YQZ+1GY6+TJhKJdMPj157AopvI7zLfC
         7iDiO3+OqeDpMeosFkBesYCRee+oj3vGADHGvuu9Lrhx4EWFGuyWFTp+TNkuKbEqcxaS
         ThcXK08XGqO9ns7cJLyAdVOlpKBCSQ/8W/VFTa6qGj44fSjJj7SC5hdsr0kJLrIxHudP
         f0R3QgcQkGFJgYwwS22UKrfjN8f34A7lMQd2DbEUiWbifO4OS2sWtA5hcTixHPto38fm
         7F+g==
X-Gm-Message-State: AFqh2ko+pFZm5ROXAwVDXfSj1am9JXLysd9ehgtH0LXHQEm2RWfqAaGt
        6IXLHA+29kGqBP0DxqUnzSbxFGs+ZTy3wSqgFD1r9kk8tNIn9A==
X-Google-Smtp-Source: AMrXdXudu35DUQI89C0hLFaDECWaQsP2s6dRIAs+bKW53+L1WvLmXeRDiQE9/DH45H0uMso3NIlU45BBuvS4dKNVL7w=
X-Received: by 2002:a05:6808:c9:b0:35a:2a68:8d6a with SMTP id
 t9-20020a05680800c900b0035a2a688d6amr4487228oic.261.1673406861999; Tue, 10
 Jan 2023 19:14:21 -0800 (PST)
MIME-Version: 1.0
References: <CALg51MN+crXt0KcsLOAUF6feGa1q5SJ+bPDy=-SsfQD45nKuMA@mail.gmail.com>
 <878ria7ds8.fsf@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <878ria7ds8.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Date:   Wed, 11 Jan 2023 11:14:11 +0800
Message-ID: <CALg51MM2V1aLQgyYfD+MDY1GweQz-QxPJkU12Z9RaOy5_SMJHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     chandanrlinux@gmail.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Okay :)

I am going to reproduce it, and will return to this thread if I get something.

Thanks!

On Tue, Jan 10, 2023 at 8:52 PM Chandan Babu R <chandan.babu@oracle.com> wrote:
>
> On Tue, Jan 10, 2023 at 08:24:41 PM +0800, Xiao Guangrong wrote:
> > On 6/17/21 12:48, Chandan Babu R wrote:
> >
> >>>>
> >>>> Just because we currently do a blocking flush doesn't mean we always
> >>>> must do a blocking flush....
> >>>
> >>> I will try to work out a solution.
> >>
> >> I believe the following should be taken into consideration to design an
> >> "optimistic flush delay" based solution,
> >> 1. Time consumed to perform a discard operation on a filesystem's block.
> >> 2. The size of extents that are being discarded.
> >> 3. Number of discard operation requests contained in a bio.
> >>
> >> AFAICT, The combinations resulting from the above make it impossible to
> >> calculate a time delay during which sufficient number of busy extents are
> >> guaranteed to have been freed so as to fill up the AGFL to the required
> >> levels. In other words, sufficent number of busy extents may not have been
> >> discarded even after the optimistic delay interval elapses.
> >>
> >> The other solution that I had thought about was to introduce a new flag for
> >> the second argument of xfs_log_force(). The new flag will cause
> >> xlog_state_do_iclog_callbacks() to wait on completion of all of the CIL ctxs
> >> associated with the iclog that xfs_log_force() would be waiting on. Hence, a
> >> call to xfs_log_force(mp, NEW_SYNC_FLAG) will return only after all the busy
> >> extents associated with the iclog are discarded.
> >>
> >> However, this method is also flawed as described below.
> >>
> >> ----------------------------------------------------------
> >>   Task A                        Task B
> >> ----------------------------------------------------------
> >>   Submit a filled up iclog
> >>   for write operation
> >>   (Assume that the iclog
> >>   has non-zero number of CIL
> >>   ctxs associated with it).
> >>   On completion of iclog write
> >>   operation, discard requests
> >>   for busy extents are issued.
> >>
> >>   Write log records (including
> >>   commit record) into another
> >>   iclog.
> >>
> >>                                 A task which is trying
> >>                                 to fill AGFL will now
> >>                                 invoke xfs_log_force()
> >>                                 with the new sync
> >>                                 flag.
> >>                                 Submit the 2nd iclog which
> >>                                 was partially filled by
> >>                                 Task A.
> >>                                 If there are no
> >>                                 discard requests
> >>                                 associated this iclog,
> >>                                 xfs_log_force() will
> >>                                 return. As the discard
> >>                                 requests associated with
> >>                                 the first iclog are yet
> >>                                 to be completed,
> >>                                 we end up incorrectly
> >>                                 concluding that
> >>                                 all busy extents
> >>                                 have been processed.
> >> ----------------------------------------------------------
> >>
> >> The inconsistency indicated above could also occur when discard requests
> >> issued against second iclog get processed before discard requests associated
> >> with the first iclog.
> >>
> >> XFS_EXTENT_BUSY_IN_TRANS flag based solution is the only method that I can
> >> think of that can solve this problem correctly. However I do agree with your
> >> earlier observation that we should not flush busy extents unless we have
> >> checked for presence of free extents in the btree records present on the left
> >> side of the btree cursor.
> >>
> >
> > Hi Chandan,
> >
> > Thanks for your great work. Do you have any update on these patches?
> >
> > We met the same issue on the 4.19 kernel, I am not sure if the work has already
> > been merged in the upstream kernel.
>
> Sorry, The machine on which the problem was created broke and I wasn't able to
> recreate this bug on my new work setup. Hence, I didn't pursue working on this
> bug.
>
> --
> chandan
