Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36863 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDVQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 16:16:42 -0500
MIME-Version: 1.0
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
 <1551449184-7942-3-git-send-email-wshilong1991@gmail.com> <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
 <20190304205006.GX23020@dastard>
In-Reply-To: <20190304205006.GX23020@dastard>
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 4 Mar 2019 22:16:29 +0100
Message-ID: <CAKgNAki3teB9-9D-D2yObqLfAB4VUdr-Pg0qz735RfHmP+YzBg@mail.gmail.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, Andreas Dilger <adilger@dilger.ca>, Wang Shilong <wshilong@ddn.com>, linux-man <linux-man@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

Hi Dave,
On Mon, 4 Mar 2019 at 21:50, Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Mar 04, 2019 at 02:52:59PM +0100, Michael Kerrisk (man-pages) wrote:
> > Hello Wang Shilong,
> >
> > On Fri, 1 Mar 2019 at 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
> > >
> > > From: Wang Shilong <wshilong@ddn.com>
> >
> > I take it that these patches relate to some API changes that are not
> > yet merged into the kernel, right?
> >
> > Also, I think we need some accompanying info to describe project IDs.
> > Can you point me at any documents/resources?
>
> Probably "best" documented in the man pages that ship with xfsprogs.

But, these IDs are a kernel construct, right? Is their scope limited
just to XFS, or do other filesystems have the concept also?

Cheers,

Michael

> Basically, it's just another quota ID that can be used to account
> for files/directories in arbitrary admin defined groups. i.e. quotas
> that aren't bound by user/group identities.
>
> $ man 8 xfs_quota
> $ man 5 projects
> $ man 5 projid
