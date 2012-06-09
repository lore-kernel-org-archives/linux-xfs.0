Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q596ULEX044151 for <xfs@oss.sgi.com>; Sat, 9 Jun 2012 01:30:21 -0500
Date: Sat, 9 Jun 2012 07:29:52 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 00/27 v6] Fix filesystem freezing deadlocks
Message-ID: <20120609062952.GY30000@ZenIV.linux.org.uk>
References: <1338589841-9568-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1338589841-9568-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Chris Mason <chris.mason@oracle.com>, Anton Altaparmakov <anton@tuxera.com>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Joel Becker <jlbec@evilplan.org>, dchinner@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org

On Sat, Jun 02, 2012 at 12:30:14AM +0200, Jan Kara wrote:
>   Hello,
> 
>   here is the sixth iteration of my patches to improve filesystem freezing.
> The change since last iteration is that filesystem can be frozen with open but
> unlinked files. After some thinking, I've decided that the best way to handle
> this is to block removal inside ->evict_inode() of each filesystem and use
> fs-internal level of freeze protection for that (usually I've instrumented
> filesystem's transaction system to use freeze protection). Handling
> inside VFS would be less work but the only level of freeze protection that
> has a chance of not causing deadlocks is the one used for page faults and even
> there it's not clear lock ordering would be correct wrt some fs-specific locks.
> I've converted ext2, ext4, btrfs, xfs, nilfs2, ocfs2, gfs2 and also checked
> that ext3, reiserfs, jfs should work as well (they have their internal freeze
> protection mechanisms, possibly they could be replaced by a generic one but
> given these are mostly aging filesystems, it's not a real priority IHMO).
> So finally I'm not aware of any pending issue with this patch set so if you
> have some concern, please speak up!

Could you rebase on top of e.g. -rc2 and repost?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
