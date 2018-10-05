Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbeJFAmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 20:42:39 -0400
Date: Fri, 5 Oct 2018 10:42:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/15] vfs: implement opportunistic short dedupe
Message-ID: <20181005174247.GX19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870036143.29072.11970142092673351715.stgit@magnolia>
 <CAOQ4uxgqQ9ovr1i5+uGz1hq=fedFGKK7TpPCUvXkYPXhoPji3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgqQ9ovr1i5+uGz1hq=fedFGKK7TpPCUvXkYPXhoPji3g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>

On Fri, Oct 05, 2018 at 09:40:44AM +0300, Amir Goldstein wrote:
> On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > For a given dedupe request, the bytes_deduped field in the control
> > structure tells userspace if we managed to deduplicate some, but not all
> > of, the requested regions starting from the file offsets supplied.
> > However, due to sloppy coding, the current dedupe code returns
> > FILE_DEDUPE_RANGE_DIFFERS if any part of the range is different.
> > Fix this so that we can actually support partial request completion.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/read_write.c    |   44 +++++++++++++++++++++++++++++++++++---------
> >  include/linux/fs.h |    2 +-
> >  2 files changed, 36 insertions(+), 10 deletions(-)
> >
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 292d68c2f47c..9be9f261edd2 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1781,13 +1781,11 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
> >          * Check that the extents are the same.
> >          */
> >         if (is_dedupe) {
> > -               bool            is_same = false;
> > -
> >                 ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
> > -                               inode_out, pos_out, *len, &is_same);
> > +                               inode_out, pos_out, len);
> >                 if (ret)
> >                         return ret;
> > -               if (!is_same)
> > +               if (*len == 0)
> >                         return -EBADE;
> >         }
> >
> > @@ -1872,13 +1870,30 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
> >         return page;
> >  }
> >
> > +static unsigned int vfs_dedupe_memcmp(const char *s1, const char *s2,
> > +                                     unsigned int cmp_len)
> > +{
> > +       const char *orig_s1 = s1;
> > +       const char *e1 = s1 + cmp_len;
> > +       const char *e2 = s2 + cmp_len;
> > +
> > +       while (s1 < e1 && s2 < e2) {
> > +               if (*s1 != *s2)
> > +                       break;
> > +               s1++;
> > +               s2++;
> > +       }
> > +
> > +       return s1 - orig_s1;
> > +}
> > +
> 
> A few nits:
> 'len' wouldn't have been ambiguous in this context.
> I find the for loop in memcmp more elegant. It is definitely shorter.
> Not sure how differently the variants compile, but decrementing
> count/len seems much more sane then checking 2 conditions that
> always have the same result.

Fair enough; will fix.

--D

> Thanks,
> Amir.
