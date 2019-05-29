Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36349 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfE2VJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 17:09:09 -0400
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-9-amir73il@gmail.com>
 <20190529183333.GH5231@magnolia>
In-Reply-To: <20190529183333.GH5231@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 30 May 2019 00:08:56 +0300
Message-ID: <CAOQ4uxgttcbN7xtztB0A3wEV61NABgSsXufdOjPSiP8bb0iN0A@mail.gmail.com>
Subject: Re: [PATCH v3 08/13] vfs: copy_file_range needs to strip setuid bits
 and update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>

On Wed, May 29, 2019 at 9:33 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, May 29, 2019 at 08:43:12PM +0300, Amir Goldstein wrote:
> > Because generic_copy_file_range doesn't hold the destination inode lock
> > throughout the copy, strip setuid bits before and after copy.
> >
> > The destination inode mtime is updated before and after the copy and the
> > source inode atime is updated after the copy, similar to
> > generic_file_read_iter().
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Looks reasonable,

Actually, it isn't reasonable. I'd like to recall this patch :-/
As one might expect, splice_direct_to_actor() already has file_accessed()
and "file_modified" is the responsibility of filesystem's ->write_iter().

Thanks,
Amir.
