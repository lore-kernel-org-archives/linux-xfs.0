Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9UD0EFd204149 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 08:00:14 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [GIT PULL] two small xfs regression fixes
Date: Fri, 30 Oct 2009 07:59:51 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE45@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091030085356.GA7539@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> The two one-liner regression fixes have been reviewed and tested by the active
> XFS developers long time ago, but it seems Alex as the maintainer
> disappeared again.
> 
> If youre back Alex can you send this to Linus ASAP?  Alternatively Linus
> might aswell just take it himeself given how simple these fixes are,
> and especially Eric's patch is a bit of a show-stopper for people
> building xfs as module.


I'll post them on oss this morning, and will send a
pull request to Linus thereafter.

					-Alex



> The following changes since commit ba313e68facf190317d8db3afdc0f0028c963a96:
>   Alex Elder (1):
>         Merge branch 'master' of ssh://oss.sgi.com/oss/git/xfs/xfs into for-linus
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/fs/xfs/xfs.git for-linus
> 
> Eric Sandeen (1):
>       xfs: free temporary cursor in xfs_dialloc
> 
> Ryota Yamauchi (1):
>       xfs: fix xfs_quota remove error
> 
>  fs/xfs/linux-2.6/xfs_quotaops.c |    2 +-
>  fs/xfs/xfs_ialloc.c             |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
