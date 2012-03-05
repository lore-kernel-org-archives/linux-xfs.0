Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25G1f5X223965 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 10:01:42 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uZjhm7CsJySmFhw3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 08:01:40 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 00/19] Fix filesystem freezing deadlocks
Date: Mon,  5 Mar 2012 17:00:58 +0100
Message-Id: <1330963277-26336-1-git-send-email-jack@suse.cz>
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
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, sandeen@redhat.com, linux-nilfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>, Anton Altaparmakov <anton@tuxera.com>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Joel Becker <jlbec@evilplan.org>, dchinner@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Chris Mason <chris.mason@oracle.com>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, Kamal Mostafa <kamal@canonical.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org

  Hallelujah,

  after a couple of weeks and several rewrites, here comes the third iteration
of my patches to improve filesystem freezing.  Filesystem freezing is currently
racy and thus we can end up with dirty data on frozen filesystem (see changelog
patch 06 for detailed race description). This patch series aims at fixing this.

To be able to block all places where inodes get dirtied, I've moved filesystem
freeze handling in mnt_want_write() / mnt_drop_write(). This however required
some code shuffling and changes to kern_path_create() (see patches 02-05). I
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

And for people wanting to test - this patchset is based on patch series
"Push file_update_time() into .page_mkwrite" so you'll need to pull that one
in as well.

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
