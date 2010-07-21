Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6L5ltEE063417 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 00:47:56 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 895DE45F658
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 22:50:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	JDjTUBBr71UomBLV for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 22:50:54 -0700 (PDT)
Date: Wed, 21 Jul 2010 15:50:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] Shrinker conversion fixes
Message-ID: <20100721055048.GV32635@dastard>
References: <20100720004630.GH23223@dastard> <20100720233238.GS32635@dastard>
	<AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 20, 2010 at 04:35:14PM -0700, Linus Torvalds wrote:
> On Tue, Jul 20, 2010 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Ijust rebased the series - the shrinker context patch did not pickup
> > the new shrinker in the TTM DRM code for radeon. New pull-request output
> > below.
> 
> Not good. I already pulled the earlier version yesterday. So a rebased
> series is useless.

Ok, here's the commit to fix the missing bits.

The following changes since commit f4b23cc2d5dc78ef5acbc529eb1219cc41eb5b96:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-07-20 18:29:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev shrinker

Dave Chinner (1):
      mm: add context argument to shrinker callback to remaining shrinkers

 drivers/gpu/drm/ttm/ttm_page_alloc.c |    2 +-
 net/sunrpc/auth.c                    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
