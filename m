Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:62905 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbeLCXAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 18:00:12 -0500
Date: Tue, 4 Dec 2018 10:00:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] vfs: introduce generic_copy_file_range()
Message-ID: <20181203230007.GG6311@dastard>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-3-david@fromorbit.com>
 <CAOQ4uxiSjmmm5OBx+K5qff4mtL5jSih71izWGQKjA_WQSLe=AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiSjmmm5OBx+K5qff4mtL5jSih71izWGQKjA_WQSLe=AA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Dec 03, 2018 at 12:03:41PM +0200, Amir Goldstein wrote:
> On Mon, Dec 3, 2018 at 10:34 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Right now if vfs_copy_file_range() does not use any offload
> > mechanism, it falls back to calling do_splice_direct(). This fails
> > to do basic sanity checks on the files being copied. Before we
> > start adding this necessarily functionality to the fallback path,
> > separate it out into generic_copy_file_range().
> >
> > generic_copy_file_range() has the same prototype as
> > ->copy_file_range() so that filesystems can use it in their custom
> > ->copy_file_range() method if they so choose.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Looks good.
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Question:
> 2 years ago you suggested that I covert the overlayfs copy up
> code that does a do_direct_splice() with a loop of vfs_copy_file_range():
> https://marc.info/?l=linux-fsdevel&m=147369468521525&w=2
> We ended up with a slightly different solution, but with your recent
> changes, I can get back to your original proposal.
> 
> Back then, I wondered whether it makes sense to push the killable
> loop of shorter do_direct_splice() calls into the vfs helper.
> What do you think about adding this to generic_copy_file_range()
> now? (I can do that after your changes are merged).

No. Adding another loop on top of all the loops already in the
do_direct_splice() is just crazy. The code is hard enough to follow
to begin with. If we are going to make do_splice_direct() killable,
then it needs to be done the splice_direct_to_actor loop that
already splits large splice ranges up into smaller chunks.

As it is, addressing the flaws of do_splice_direct() is not
something I'm about to do in this patchset. It has many issues, and
it's yet another piece of work we need to undertake to make
copy_file_range() somewhat user friendly.

> The fact that userspace *can* enter a very long unkillable loop
> with current copy_file_range() syscall doesn't mean that we
> *should* persist this situation. After all, fixing the brokenness
> of the existing interface is what you set out to do.

That's not an API issue - that's an implementation problem.

Quite frankly, making copy offload implementations killable is going
to "fun" for filesystems that offload the copy to remote servers, so
whatever we do fo the fallback isn't going to prevent
copy_file_range() from being unkillable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
