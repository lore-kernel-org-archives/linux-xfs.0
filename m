Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJOXSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 19:18:41 -0400
Date: Mon, 15 Oct 2018 08:32:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/25] vfs: make remapping to source file eof more
 explicit
Message-ID: <20181015153219.GG28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938925737.8361.3995899966552253527.stgit@magnolia>
 <20181014172433.GG30673@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014172433.GG30673@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Sun, Oct 14, 2018 at 10:24:33AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 12, 2018 at 05:07:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a RFR_TO_SRC_EOF flag to explicitly declare that the caller wants
> > the remap implementation to remap to the end of the source file, once
> > the files are locked.
> 
> The name looks like a cat threw up on your keyboard :)

Yeah... :(

> From reading the code this seems to ask for a whole file remap, right?

Nope.  In the original btrfs clonerange ioctl, length == 0 meant "to EOF".
If you made a call like this:

struct btrfs_ioctl_clone_range_args x = {
	.src_offset = 16384,
	.src_length = 0,
	.dest_offset = 0,
	.src_fd = whatever,
};
ftruncate(dest_fd, 0);
ioctl(dest_fd, BTRFS_IOC_CLONE, &x);

Then dest_fd ends up with the contents of [16k...EOF] from src_fd.
It's annoying to have the magic length number (and no flags?) but we're
stuck with this quirk of the interface.

> Why not put that in the name to make it more descriptive?

I'm all ears for better suggestions. :)

--D
