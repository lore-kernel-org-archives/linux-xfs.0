Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 20:40:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O3dokX005488
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:39:51 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 649A84754EC
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:41:24 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id JPw9E2W2j9Vmp9re for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:41:24 -0700 (PDT)
Date: Wed, 24 Sep 2008 13:41:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Check for valid transaction headers in recovery
Message-ID: <20080924034120.GG5448@disturbed>
References: <1222218974-5161-1-git-send-email-david@fromorbit.com> <48D9AF0C.3050404@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9AF0C.3050404@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 23, 2008 at 10:07:56PM -0500, Eric Sandeen wrote:
> Dave Chinner wrote:
> > When we are about to add a new item to a transaction in recovery,
> > we need to check that it is valid first. Current we just assert
> > that header magic number matches, but in production systems
> > that is not done add a corrupted transaction to the list to be
> > processed. This results in a kernel oops later when processing the
> > corrupted transaction.
> > 
> > Instead, if we detect a corrupted transaction, abort recovery and
> > leave the user to clean up the mess that has occurred.
> > 
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> Seems fine to me (I guess you tried the provided corrupt image?)

Yes, I tried to mount it.

> but the
> commit message could be made a bit more ... English ;)

Right. Updated patch (description) below ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: Check for valid transaction headers in recovery

When we are about to add a new item to a transaction in recovery, we
need to check that it is valid first. Currently we just assert that
header magic number matches, but in production systems that is not
present and we add a corrupted transaction to the list to be
processed. This results in a kernel oops later when processing the
corrupted transaction.

Instead, if we detect a corrupted transaction, abort recovery and
leave the user to clean up the mess that has occurred.
---
 fs/xfs/xfs_log_recover.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 37c2bf9..1ccc80d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1420,7 +1420,13 @@ xlog_recover_add_to_trans(
 		return 0;
 	item = trans->r_itemq;
 	if (item == NULL) {
-		ASSERT(*(uint *)dp == XFS_TRANS_HEADER_MAGIC);
+		/* we need to catch log corruptions here */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xlog_warn("XFS: xlog_recover_add_to_trans: "
+				  "bad header magic number");
+			ASSERT(0);
+			return XFS_ERROR(EIO);
+		}
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len); /* d, s, l */
