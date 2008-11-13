Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mADA2vZa032613 for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 02:03:00 -0800
Date: Thu, 13 Nov 2008 05:02:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20081113100256.GA28659@infradead.org>
References: <20081111035805.EEC4B58FA24A@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081111035805.EEC4B58FA24A@chook.melbourne.sgi.com>
Subject: Re: [xfs] [GIT PULL] XFS update for 2.6.28
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Linus, whats preventing this from going in?

On Tue, Nov 11, 2008 at 02:58:05PM +1100, Lachlan McIlroy wrote:
> This pull request is a little more conservative than the last one!  Just
> critical bug fixes this time.
> 
> The following changes since commit 3ad4f597058301c97f362e500a32f63f5c950a45:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com:8090/xfs/xfs for-linus
> 
> Dave Chinner (1):
>       [XFS] handle memory allocation failures during log initialisation
> 
> David Chinner (2):
>       [XFS] Account for allocated blocks when expanding directories
>       [XFS] XFS: Check for valid transaction headers in recovery
> 
> Lachlan McIlroy (2):
>       [XFS] Fix use-after-free with log and quotas
>       [XFS] Wait for all I/O on truncate to zero file size
> 
>  fs/xfs/xfs_da_btree.c    |    5 +++++
>  fs/xfs/xfs_dir2.c        |    6 ++++++
>  fs/xfs/xfs_inode.c       |    2 +-
>  fs/xfs/xfs_log.c         |   39 ++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_log_recover.c |    8 +++++++-
>  fs/xfs/xfs_mount.c       |    5 +++--
>  6 files changed, 58 insertions(+), 7 deletions(-)
> 
> 
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
