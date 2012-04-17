Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H0hYUw260325 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 19:43:34 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YR2A5itASWPpa9L0 for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 17:43:32 -0700 (PDT)
Date: Tue, 17 Apr 2012 10:43:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/19 v5] Fix filesystem freezing deadlocks
Message-ID: <20120417004329.GE6734@dastard>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
	<C9A0E2F0-ED57-40D6-9F75-5D72D45D21F0@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C9A0E2F0-ED57-40D6-9F75-5D72D45D21F0@dilger.ca>
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
To: Andreas Dilger <adilger@whamcloud.com>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, ocfs2-devel@oss.oracle.com, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nilfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Anton Altaparmakov <anton@tuxera.com>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Joel Becker <jlbec@evilplan.org>, dchinner@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Chris Mason <chris.mason@oracle.com>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org

On Mon, Apr 16, 2012 at 03:02:50PM -0700, Andreas Dilger wrote:
> On 2012-04-16, at 9:13 AM, Jan Kara wrote:
> > Another potential contention point might be patch 19. In that patch
> > we make freeze_super() refuse to freeze the filesystem when there
> > are open but unlinked files which may be impractical in some cases.
> > The main reason for this is the problem with handling of file deletion
> > from fput() called with mmap_sem held (e.g. from munmap(2)), and
> > then there's the fact that we cannot really force such filesystem
> > into a consistent state... But if people think that freezing with
> > open but unlinked files should happen, then I have some possible
> > solutions in mind (maybe as a separate patchset since this is
> > large enough).
> 
> Looking at a desktop system, I think it is very typical that there
> are open-unlinked files present, so I don't know if this is really
> an acceptable solution.  It isn't clear from your comments whether
> this is a blanket refusal for all open-unlinked files, or only in
> some particular cases...
> 
> lsof | grep deleted
> nautilus  25393  adilger   19r      REG           253,0      340     253954 /home/adilger/.local/share/gvfs-metadata/home (deleted)
> nautilus  25393  adilger   20r      REG           253,0    32768     253964 /home/adilger/.local/share/gvfs-metadata/home-f332a8f3.log (deleted)
> gnome-ter 25623  adilger   22u      REG            0,18    17841    2717846 /tmp/vtePIRJCW (deleted)
> gnome-ter 25623  adilger   23u      REG            0,18     5568    2717847 /tmp/vteDCSJCW (deleted)
> gnome-ter 25623  adilger   29u      REG            0,18      480    2728484 /tmp/vte6C1TCW (deleted)

Unlinked-but-open files are the reason that XFS dirties the log
after the freeze process is complete. This ensures that if the
system crashes while the filesystem is frozen then log recovery
during the next mount will process the unlinked (orphaned) inodes
and free the correctly. i.e. you can still freeze a filesystem with
inodes in this state successfully and have everythign behave as
you'd expect.

I'm not sure how other filesystems handle this problem, but perhaps
pushing this check down into filesystem specific code or adding a
superblock feature flag might be a way to allow filesystems to
handle this case in the way they think is best...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
