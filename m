Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA6A47F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 15:53:36 -0600 (CST)
Date: Thu, 6 Feb 2014 15:53:32 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [GIT PULL] XFS fix for 3.14-rc2
Message-ID: <20140206215332.GQ1935@sgi.com>
References: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
	<CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Feb 06, 2014 at 01:34:53PM -0800, Linus Torvalds wrote:
> I have no idea why you keep re-sending this.
> 
> It got merged a week ago. See commit f1499382f114.

Ok, there it is.  Sorry for the noise.

Thanks,
	Ben	

> On Thu, Feb 6, 2014 at 9:31 AM, Ben Myers <bpm@sgi.com> wrote:
> > Hi Linus,
> >
> >    Please pull this xfs update for 3.14.  This is to allow logical sector sized
> >    direct io on advanced format disks.  Eric expressed a desire to get this fix
> >    in 3.14 because this bug affects some virtualization packages.
> >
> > Thanks,
> >         Ben
> >
> > The following changes since commit bf3964c188d686424ff7b69a45941851b9f437f0:
> >
> >   Merge branch 'xfs-extent-list-locking-fixes' into for-next (2014-01-09 16:03:18 -0600)
> >
> > are available in the git repository at:
> >
> >
> >   git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.14-rc1-2
> >
> > for you to fetch changes up to 7c71ee78031c248dca13fc94dea9a4cc217db6cf:
> >
> >   xfs: allow logical-sector sized O_DIRECT (2014-01-24 11:55:42 -0600)
> >
> > ----------------------------------------------------------------
> > xfs: update #2 for v3.14-rc1
> >
> > - allow logical sector sized direct io on 'advanced format' 4k/512 disk.
> >
> > ----------------------------------------------------------------
> > Eric Sandeen (3):
> >       xfs: clean up xfs_buftarg
> >       xfs: rename xfs_buftarg structure members
> >       xfs: allow logical-sector sized O_DIRECT
> >
> >  fs/xfs/xfs_buf.c   | 14 +++++++++-----
> >  fs/xfs/xfs_buf.h   | 20 +++++++++++++++++---
> >  fs/xfs/xfs_file.c  |  7 +++++--
> >  fs/xfs/xfs_ioctl.c |  2 +-
> >  4 files changed, 32 insertions(+), 11 deletions(-)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
