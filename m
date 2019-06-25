Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727687AbfFYRMM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 13:12:12 -0400
Date: Tue, 25 Jun 2019 19:12:54 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] vfs: create a generic checking function for
 FS_IOC_SETFLAGS
Message-ID: <20190625171254.GT8917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <156116136742.1664814.17093419199766834123.stgit@magnolia>
 <156116138140.1664814.9610454726122206157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156116138140.1664814.9610454726122206157.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Jun 21, 2019 at 04:56:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a generic checking function for the incoming FS_IOC_SETFLAGS flag
> values so that we can standardize the implementations that follow ext4's
> flag values.

I checked a few samples what's the type of the flags, there are unsigned
types while the proposed VFS functions take signed type.

> +int vfs_ioc_setflags_check(struct inode *inode, int oldflags, int flags);

Specifically ext4 uses unsigned type and his was the original API that
got copied so I'd think that it should unsigned everywhere.

>  fs/btrfs/ioctl.c    |   13 +++++--------

For the btrfs bits

Acked-by: David Sterba <dsterba@suse.com>

and besides the signedness, the rest of the changes look good to me.
