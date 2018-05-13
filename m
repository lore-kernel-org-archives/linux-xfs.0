Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46904 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751926AbeEMUvr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 May 2018 16:51:47 -0400
Date: Sun, 13 May 2018 16:51:32 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [RFC v2 3/4] ext4: add verifier check for symlink with
 append/immutable flags
Message-ID: <20180513205132.GG14763@thunk.org>
References: <20180510231359.16899-1-mcgrof@kernel.org>
 <20180510231359.16899-4-mcgrof@kernel.org>
 <20180511211218.rs365ftuw53c4qj2@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511211218.rs365ftuw53c4qj2@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, darrick.wong@oracle.com, adilger.kernel@dilger.ca, clm@fb.com, jbacik@fb.com, dsterba@suse.com, sandeen@sandeen.net, dhowells@redhat.com, fliu@suse.com, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, May 11, 2018 at 11:12:18PM +0200, Jan Kara wrote:
> On Thu 10-05-18 16:13:58, Luis R. Rodriguez wrote:
> > The Linux VFS does not allow a way to set append/immuttable
> > attributes to symlinks, this is just not possible. If this is
> > detected inform the user as the filesystem must be corrupted.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> 
> Looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied into the ext4 tree after verifying that e2fsck already handles
this case:

% e2fsck -fy /tmp/foo.img
e2fsck 1.44.1 (24-Mar-2018)
Pass 1: Checking inodes, blocks, and sizes
Special (device/socket/fifo/symlink) file (inode 13) has immutable
or append-only flag set.  Clear? yes

(The btrfs and xfs maintainers might want to make a similar check
before accepting their respective patches.)

						- Ted
