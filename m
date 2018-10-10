Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60392 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbeJKB4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 21:56:12 -0400
Date: Wed, 10 Oct 2018 11:32:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/25] vfs: make remap_file_range functions take and
 return bytes completed
Message-ID: <20181010183236.GU28243@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913040858.32295.9474188640729118153.stgit@magnolia>
 <CAOQ4uxg0=EJp1WJXmUeHT05yF1txRKKhPHVTWeG+rdtRD5FfHA@mail.gmail.com>
 <20181010155055.GS28243@magnolia>
 <CAOQ4uxjsKZHxoYqbnJTxQ1SPGn7o_2QhYseuETHnvZxvgCV5vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjsKZHxoYqbnJTxQ1SPGn7o_2QhYseuETHnvZxvgCV5vg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 09:28:34PM +0300, Amir Goldstein wrote:
> On Wed, Oct 10, 2018 at 6:51 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Wed, Oct 10, 2018 at 09:47:00AM +0300, Amir Goldstein wrote:
> > > On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > >
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > >
> > > > Change the remap_file_range functions to take a number of bytes to
> > > > operate upon and return the number of bytes they operated on.  This is a
> > > > requirement for allowing fs implementations to return short clone/dedupe
> > > > results to the user, which will enable us to obey resource limits in a
> > > > graceful manner.
> > > >
> > > > A subsequent patch will enable copy_file_range to signal to the
> > > > ->clone_file_range implementation that it can handle a short length,
> > > > which will be returned in the function's return value.  Neither clone
> > > > ioctl can take advantage of this, alas.
> > > >
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> [...]
> > > Commit message wasn't clear enough on the behavior of copy_file_range()
> > > before and after the patch IMO. Maybe it would be better to pospone this
> > > semantic change to the RFR_SHORTEN patch and keep if (cloned == len)
> > > in this patch?
> >
> > There shouldn't be any behavior change here -- all implementations
> > return a negative error code or the length that was passed in.  I'll
> > clarify that in the commit message.
> >
> 
> OK. BTW, you forgot to update Documentation/filesystems/vfs.txt.

Yeah, I noticed that and updated it too.

> Also since this series has a potential to break clone/dedup on
> overlayfs, it would be great if you could run some of the clone/dedupe
> xfstests with overlay over xfs.
> 
> For the simple case of running ./check with a local.config file that is
> not multi section, this just means running ./check -overlay after the
> first ./check run (-overlay doesn't mkfs the base fs).

I'll give it a try, though we should probably both run '-g clone' just
to make sure everything is working...

> If this is a problem, let me know once new devel branch is ready

Yeah, Dave asked me to merge the xfs for-next branch so I'm working on
that too.

> and I'll pull it for testing. If I need to pull in extra xfstests, please
> mention that as well.

You'll probably want "generic: test creation time recovery after power
failure" that I sent to the fstests lists a few days ago.

--D

> 
> Thanks,
> Amir.
