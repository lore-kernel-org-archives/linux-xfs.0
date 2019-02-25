Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f179.google.com ([209.85.208.179]:42384 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfBYXVp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 18:21:45 -0500
Received: by mail-lj1-f179.google.com with SMTP id d14so9011397ljl.9
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 15:21:44 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtRODsGw85CdJRD7EF9U2vx7EwFkaFQCtC1mPwckUkUBNw@mail.gmail.com>
 <20190225231057.GH23020@dastard>
In-Reply-To: <20190225231057.GH23020@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 25 Feb 2019 16:21:31 -0700
Message-ID: <CAJCQCtRr28GZKcSAMu_8fho-h=3nvZoFtp_LinmjLpyG_r-Q4Q@mail.gmail.com>
Subject: Re: XFS root filesystem corruption after selinux-policy-targeted update
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Mon, Feb 25, 2019 at 4:11 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Feb 25, 2019 at 03:16:40PM -0700, Chris Murphy wrote:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1679697
> >
> > I'm not sure what the call trace is saying. User has been requested to
> > run xfs_repair -n to see if it's really corrupt and maybe get more
> > information in what manner it's corrupted.
>
> A free space tree is corrupted. What caused it is unknown, and
> without a reproducer we are unlikely to be able to find it.
> xfs_repair is needed to rebuild the free space trees and hence fix
> the corruption.
>
> > I don't think it's
> > selinux-policy related at all,
>
> It's not. Might be xattr related (because relabelling manipulates
> xattrs), but there's really nothing to go on at this point.

OK thanks.


-- 
Chris Murphy
