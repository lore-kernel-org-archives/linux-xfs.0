Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFTWOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 18:14:23 -0400
Date: Thu, 20 Jun 2019 15:13:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] mm/fs: don't allow writes to immutable files
Message-ID: <20190620221306.GD5375@magnolia>
References: <156022836912.3227213.13598042497272336695.stgit@magnolia>
 <156022837711.3227213.11787906519006016743.stgit@magnolia>
 <20190620215212.GG4650@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620215212.GG4650@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, matthew.garrett@nebula.com, yuchao0@huawei.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org, reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Jun 20, 2019 at 05:52:12PM -0400, Theodore Ts'o wrote:
> On Mon, Jun 10, 2019 at 09:46:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The chattr manpage has this to say about immutable files:
> > 
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> > 
> > Once the flag is set, it is enforced for quite a few file operations,
> > such as fallocate, fpunch, fzero, rm, touch, open, etc.  However, we
> > don't check for immutability when doing a write(), a PROT_WRITE mmap(),
> > a truncate(), or a write to a previously established mmap.
> > 
> > If a program has an open write fd to a file that the administrator
> > subsequently marks immutable, the program still can change the file
> > contents.  Weird!
> > 
> > The ability to write to an immutable file does not follow the manpage
> > promise that immutable files cannot be modified.  Worse yet it's
> > inconsistent with the behavior of other syscalls which don't allow
> > modifications of immutable files.
> > 
> > Therefore, add the necessary checks to make the write, mmap, and
> > truncate behavior consistent with what the manpage says and consistent
> > with other syscalls on filesystems which support IMMUTABLE.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I note that this patch doesn't allow writes to swap files.  So Amir's
> generic/554 test will still fail for those file systems that don't use
> copy_file_range.

I didn't add any IS_SWAPFILE checks here, so I'm not sure to what you're
referring?

> I'm indifferent as to whether you add a new patch, or include that
> change in this patch, but perhaps we should fix this while we're
> making changes in these code paths?

The swapfile patches should be in a separate patch, which I was planning
to work on but hadn't really gotten around to it.

--D


> 				- Ted
