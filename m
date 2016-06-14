Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61B767CA0
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 08:37:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0F3DAC003
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 06:37:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9VDCwE8mGrimHaak (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2016 06:37:24 -0700 (PDT)
Date: Tue, 14 Jun 2016 09:37:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: refactor xfs_reserve_blocks() to handle ENOSPC
	correctly
Message-ID: <20160614133721.GD32443@bfoster.bfoster>
References: <1465909139-36329-1-git-send-email-bfoster@redhat.com>
	<B68205CB-0E29-4BB5-BB2A-C41CB2F1C32E@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B68205CB-0E29-4BB5-BB2A-C41CB2F1C32E@zytor.com>
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
To: Paulo Alcantara <pcacjr@zytor.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 14, 2016 at 10:32:57AM -0300, Paulo Alcantara wrote:
> 
> 
> On June 14, 2016 9:58:59 AM GMT-03:00, Brian Foster <bfoster@redhat.com> wrote:
...
> >
> >Signed-off-by: Brian Foster <bfoster@redhat.com>
> >---
> >
> >This is something I had laying around from the thin block device
> >reservation stuff. That work introduced a more common
> >xfs_mod_fdblocks()
> >failure scenario that isn't as much of a problem with the current code,
> >but the current xfs_reserve_blocks() retry code is clearly broken and
> >so
> >should probably be fixed up.
> >
> >Brian
> >
> >fs/xfs/xfs_fsops.c | 105
> >++++++++++++++++++++++++++++++-----------------------
> > 1 file changed, 60 insertions(+), 45 deletions(-)
> >
> >diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> >index b4d7582..003d180 100644
> >--- a/fs/xfs/xfs_fsops.c
> >+++ b/fs/xfs/xfs_fsops.c
...
> >@@ -707,54 +709,67 @@ retry:
> > 			mp->m_resblks_avail -= lcounter;
> > 		}
> > 		mp->m_resblks = request;
> >-	} else {
> >-		__int64_t	free;
> >+		if (fdblks_delta) {
> >+			spin_unlock(&mp->m_sb_lock);
> >+			error = xfs_mod_fdblocks(mp, fdblks_delta, 0);
> >+			spin_lock(&mp->m_sb_lock);
> >+		}
> >+
> >+		goto out;
> >+	}
> > 
> >+	/*
> >+	 * If the request is larger than the current reservation, reserve the
> >+	 * blocks before we update the reserve counters. Sample m_fdblocks
> >and
> >+	 * perform a partial reservation if the request exceeds free space.
> >+	 */
> >+	error = -ENOSPC;
> >+	while (error == -ENOSPC) {
> 
> Why don't you make this a "do { } while (error == -ENOSPC)"? xfs_mod_fdblocks() will already set the error at the end of that loop.
> 

Sure, I can clean that up. Thanks.

Brian

> Paulo
> 
> -- 
> Paulo Alcantara, HP
> Speaking for myself only.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
