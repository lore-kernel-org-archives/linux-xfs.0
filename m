Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46147 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJWqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 18:46:35 -0400
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913029885.32295.7399525233513945673.stgit@magnolia> <CAOQ4uxj_wftoGvub9n_6X3Qc64LKxs+8TB-opUiq59sGQ=YoKw@mail.gmail.com>
 <20181010151321.GR28243@magnolia>
In-Reply-To: <20181010151321.GR28243@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 Oct 2018 18:23:43 +0300
Message-ID: <CAOQ4uxjrkgiKXTYP8d93kLvU2zaKO14Wx3ZL7-7TnDd95CHnOA@mail.gmail.com>
Subject: Re: [PATCH 08/25] vfs: combine the clone and dedupe into a single remap_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 6:13 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 08:54:44AM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Combine the clone_file_range and dedupe_file_range operations into a
> > > single remap_file_range file operation dispatch since they're
> > > fundamentally the same operation.  The differences between the two can
> > > be made in the prep functions.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> >

> >
> > Apart from the generic check invalid flags comment - ACK on ovl part.
>
> Thanks for the review!  Is that an official Acked-by to add to the
> commit message, or an informal ACK?
>

I would offer my Acked-by for whole of the vfs patches
if we agree on the correct way to handle invalid flags
(see more comments up the series regarding the "advisory" flags).

Thanks,
Amir.
