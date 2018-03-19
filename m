Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:34753 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932750AbeCSXpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 19:45:39 -0400
Date: Tue, 20 Mar 2018 10:39:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: list corruption in xfs_setup_inode()
Message-ID: <20180319233913.GA1150@dastard>
References: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com>
 <CAM_iQpVBmhiN05ZpxEZ2cNLSJpczc7z=Sz7a1tnUGeQimtDTYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVBmhiN05ZpxEZ2cNLSJpczc7z=Sz7a1tnUGeQimtDTYA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Mar 19, 2018 at 02:37:22PM -0700, Cong Wang wrote:
> On Mon, Oct 30, 2017 at 2:55 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > Hello,
> >
> > We triggered a list corruption (double add) warning below on our 4.9
> > kernel (the 4.9 kernel we use is based on -stable release, with only a
> > few unrelated networking backports):
> 
> We still keep getting this warning on 4.9 kernel. Looking into this again,
> it seems xfs_setup_inode() could be called twice if an XFS inode is gotten
> from disk? Once in xfs_iget() => xfs_setup_existing_inode(), and once
> in xfs_ialloc().

AFAICT, the only way this can happen is that if the inode ->i_mode
has been corrupted in some way. i.e. there is either on-disk or
in-memory corruption occurring.

> Does the following patch (compile-only) make any sense? Again, I don't
> want to pretend to understand XFS...

No, it doesn't make sense because a newly allocated inode should
always have a zero i_mode.

Have you turned on memory poisoning to try to identify where the
corruption is coming from?

And given that it might actually be on-disk corruption that is
causing this, have you run xfs_repair on these filesystems to
determine if they are free from on-disk corruption?

Indeed, that makes me wonder format are you running on these
filesystems, because on the more recent v5 format we don't read
newly allocated inodes from disk. Can you provide the info listed
here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

as that will tell us what code paths are executing on inode
allocation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
