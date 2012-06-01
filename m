Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51MVxk8183747 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 17:31:59 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id kGqKIDbnsDp8aAkk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Jun 2012 15:31:57 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 00/27 v6] Fix filesystem freezing deadlocks
Date: Sat,  2 Jun 2012 00:30:14 +0200
Message-Id: <1338589841-9568-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, ocfs2-devel@oss.oracle.com, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Joel Becker <jlbec@evilplan.org>, dchinner@redhat.com, Anton Altaparmakov <anton@tuxera.com>, Steven Whitehouse <swhiteho@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, Al Viro <viro@ZenIV.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org

  Hello,

  here is the sixth iteration of my patches to improve filesystem freezing.
The change since last iteration is that filesystem can be frozen with open but
unlinked files. After some thinking, I've decided that the best way to handle
this is to block removal inside ->evict_inode() of each filesystem and use
fs-internal level of freeze protection for that (usually I've instrumented
filesystem's transaction system to use freeze protection). Handling
inside VFS would be less work but the only level of freeze protection that
has a chance of not causing deadlocks is the one used for page faults and even
there it's not clear lock ordering would be correct wrt some fs-specific locks.
I've converted ext2, ext4, btrfs, xfs, nilfs2, ocfs2, gfs2 and also checked
that ext3, reiserfs, jfs should work as well (they have their internal freeze
protection mechanisms, possibly they could be replaced by a generic one but
given these are mostly aging filesystems, it's not a real priority IHMO).
So finally I'm not aware of any pending issue with this patch set so if you
have some concern, please speak up!

Introductory text to first time readers:

Filesystem freezing is currently racy and thus we can end up with dirty data on
frozen filesystem (see changelog patch 13 for detailed race description). This
patch series aims at fixing this.

To be able to block all places where inodes get dirtied, I've moved filesystem
file_update_time() call to ->page_mkwrite callback (patches 01-07) and put
freeze handling in mnt_want_write() / mnt_drop_write(). That however required
some code shuffling and changes to kern_path_create() (see patches 09-12). I
think the result is OK but opinions may differ ;). The advantage of this change
also is that all filesystems get freeze protection almost for free - even ext2
can handle freezing well now.

Another potential contention point might be patch 19. In that patch we make
freeze_super() refuse to freeze the filesystem when there are open but unlinked
files which may be impractical in some cases. The main reason for this is the
problem with handling of file deletion from fput() called with mmap_sem held
(e.g. from munmap(2)), and then there's the fact that we cannot really force
such filesystem into a consistent state... But if people think that freezing
with open but unlinked files should happen, then I have some possible
solutions in mind (maybe as a separate patchset since this is large enough).

I'm not able to hit any deadlocks, lockdep warnings, or dirty data on frozen
filesystem despite beating it with fsstress and bash-shared-mapping while
freezing and unfreezing for several hours (using ext4 and xfs) so I'm
reasonably confident this could finally be the right solution.

Changes since v5:
  * handle unlinked & open files on frozen filesystem
  * lockdep keys for freeze protection are now per filesystem type
  * taught lockdep that freeze protection at lower level does not create
    dependency when we already hold freeze protection at higher level 
  * rebased on 3.5-rc1-ish

Changes since v4:
  * added a couple of Acked-by's
  * added some comments & doc update
  * added patches from series "Push file_update_time() into .page_mkwrite"
    since it doesn't make much sense to keep them separate anymore
  * rebased on top of 3.4-rc2

Changes since v3:
  * added third level of freezing for fs internal purposes - hooked some
    filesystems to use it (XFS, nilfs2)
  * removed racy i_size check from filemap_mkwrite()

Changes since v2:
  * completely rewritten
  * freezing is now blocked at VFS entry points
  * two stage freezing to handle both mmapped writes and other IO

The biggest changes since v1:
  * have two counters to provide safe state transitions for SB_FREEZE_WRITE
    and SB_FREEZE_TRANS states
  * use percpu counters instead of own percpu structure
  * added documentation fixes from the old fs freezing series
  * converted XFS to use SB_FREEZE_TRANS counter instead of its private
    m_active_trans counter

								Honza

CC: Alex Elder <elder@kernel.org>
CC: Anton Altaparmakov <anton@tuxera.com>
CC: Ben Myers <bpm@sgi.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: cluster-devel@redhat.com
CC: "David S. Miller" <davem@davemloft.net>
CC: fuse-devel@lists.sourceforge.net
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: Joel Becker <jlbec@evilplan.org>
CC: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
CC: linux-btrfs@vger.kernel.org
CC: linux-ext4@vger.kernel.org
CC: linux-nfs@vger.kernel.org
CC: linux-nilfs@vger.kernel.org
CC: linux-ntfs-dev@lists.sourceforge.net
CC: Mark Fasheh <mfasheh@suse.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: ocfs2-devel@oss.oracle.com
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: xfs@oss.sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
