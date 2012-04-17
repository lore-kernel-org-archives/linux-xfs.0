Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3HJZPXH099546 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 14:35:25 -0500
Date: Tue, 17 Apr 2012 12:34:42 -0700
From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 00/19 v5] Fix filesystem freezing deadlocks
Message-ID: <20120417193441.GE31464@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
	<C9A0E2F0-ED57-40D6-9F75-5D72D45D21F0@dilger.ca>
	<20120417093246.GD7198@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120417093246.GD7198@quack.suse.cz>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, ocfs2-devel@oss.oracle.com, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nilfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Andreas Dilger <adilger@whamcloud.com>, Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, dchinner@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Anton Altaparmakov <anton@tuxera.com>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org

On Tue, Apr 17, 2012 at 11:32:46AM +0200, Jan Kara wrote:
> On Mon 16-04-12 15:02:50, Andreas Dilger wrote:
> > On 2012-04-16, at 9:13 AM, Jan Kara wrote:
> > > Another potential contention point might be patch 19. In that patch
> > > we make freeze_super() refuse to freeze the filesystem when there
> > > are open but unlinked files which may be impractical in some cases.
> > > The main reason for this is the problem with handling of file deletion
> > > from fput() called with mmap_sem held (e.g. from munmap(2)), and
> > > then there's the fact that we cannot really force such filesystem
> > > into a consistent state... But if people think that freezing with
> > > open but unlinked files should happen, then I have some possible
> > > solutions in mind (maybe as a separate patchset since this is
> > > large enough).
> > 
> > Looking at a desktop system, I think it is very typical that there
> > are open-unlinked files present, so I don't know if this is really
> > an acceptable solution.  It isn't clear from your comments whether
> > this is a blanket refusal for all open-unlinked files, or only in
> > some particular cases...
>   Thanks for looking at this. It is currently a blanket refusal. And I
> agree it's problematic. There are two problems with open but unlinked
> files.

	Let me add my name to the chorus of "we have to handle freezing
with open+unlinked, we cannot assume they don't exist."

> One is that some old filesystems cannot get in a consistent state in
> presence of open but unlinked files but for filesystems we really care
> about - xfs, ext4, ext3, btrfs, or even ocfs2, gfs2 - that is not a real
> issue (these filesystems will delete those inodes on next mount read-write).

	Others have pointed out that we can flag the safe filesystems.
I'd even be willing to say you can't freeze the unsafe filesystems.

> The other problem is with what should happen when you put last inode
> reference on a frozen filesystem. Two possibilities I see are:
> 
> a) block the iput() call - that is inconvenient because it can be
> called in various contexts. I think we could possibly use the same level of
> freeze protection as for page fault (this has changed since I originally
> thought about this and that would make things simpler) but I'm not
> completely sure.

	Given that frozen filesystems can stay that way for a while,
couldn't that lead to a million frozen df(1)s?  It's like your average
NFS network failure.

> b) let the iput finish but filesystem will keep inode on its orphan list
> (or it's equivalent) and the inode will be deleted after the filesystem is
> thawed. The advantage of this is we don't have to block iput(), the
> disadvantage is we have to have filesystem support and not all filesystems
> can do this.

	Perhaps we handle iput() like unlinked.  If the filesystem can
handle it, we allow it, otherwise we block.

Joel

> 
> Any thoughts?
> 
> 								Honza
> > 
> > lsof | grep deleted
> > nautilus  25393  adilger   19r      REG           253,0      340     253954 /home/adilger/.local/share/gvfs-metadata/home (deleted)
> > nautilus  25393  adilger   20r      REG           253,0    32768     253964 /home/adilger/.local/share/gvfs-metadata/home-f332a8f3.log (deleted)
> > gnome-ter 25623  adilger   22u      REG            0,18    17841    2717846 /tmp/vtePIRJCW (deleted)
> > gnome-ter 25623  adilger   23u      REG            0,18     5568    2717847 /tmp/vteDCSJCW (deleted)
> > gnome-ter 25623  adilger   29u      REG            0,18      480    2728484 /tmp/vte6C1TCW (deleted)
>   
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

-- 

"The first requisite of a good citizen in this republic of ours
 is that he shall be able and willing to pull his weight."
	- Theodore Roosevelt

			http://www.jlbec.org/
			jlbec@evilplan.org

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
