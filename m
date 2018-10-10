Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46111 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJKBwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 21:52:09 -0400
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913040858.32295.9474188640729118153.stgit@magnolia> <CAOQ4uxg0=EJp1WJXmUeHT05yF1txRKKhPHVTWeG+rdtRD5FfHA@mail.gmail.com>
 <20181010155055.GS28243@magnolia>
In-Reply-To: <20181010155055.GS28243@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 Oct 2018 21:28:34 +0300
Message-ID: <CAOQ4uxjsKZHxoYqbnJTxQ1SPGn7o_2QhYseuETHnvZxvgCV5vg@mail.gmail.com>
Subject: Re: [PATCH 14/25] vfs: make remap_file_range functions take and
 return bytes completed
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 6:51 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 09:47:00AM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Change the remap_file_range functions to take a number of bytes to
> > > operate upon and return the number of bytes they operated on.  This is a
> > > requirement for allowing fs implementations to return short clone/dedupe
> > > results to the user, which will enable us to obey resource limits in a
> > > graceful manner.
> > >
> > > A subsequent patch will enable copy_file_range to signal to the
> > > ->clone_file_range implementation that it can handle a short length,
> > > which will be returned in the function's return value.  Neither clone
> > > ioctl can take advantage of this, alas.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
[...]
> > Commit message wasn't clear enough on the behavior of copy_file_range()
> > before and after the patch IMO. Maybe it would be better to pospone this
> > semantic change to the RFR_SHORTEN patch and keep if (cloned == len)
> > in this patch?
>
> There shouldn't be any behavior change here -- all implementations
> return a negative error code or the length that was passed in.  I'll
> clarify that in the commit message.
>

OK. BTW, you forgot to update Documentation/filesystems/vfs.txt.

Also since this series has a potential to break clone/dedup on
overlayfs, it would be great if you could run some of the clone/dedupe
xfstests with overlay over xfs.

For the simple case of running ./check with a local.config file that is
not multi section, this just means running ./check -overlay after the
first ./check run (-overlay doesn't mkfs the base fs).

If this is a problem, let me know once new devel branch is ready
and I'll pull it for testing. If I need to pull in extra xfstests, please
mention that as well.

Thanks,
Amir.
