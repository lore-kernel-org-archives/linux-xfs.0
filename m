Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA9FE7F54
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 17:39:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 797E7304043
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 15:39:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oI2nDh56grV52SpN for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 15:39:14 -0700 (PDT)
Date: Wed, 9 Jul 2014 08:39:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Error (failing assert) in xfs_repair
Message-ID: <20140708223911.GB22339@dastard>
References: <trinity-ff2aab11-c2a0-4349-9805-8dc72af47741-1404856231271@3capp-gmx-bs13>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <trinity-ff2aab11-c2a0-4349-9805-8dc72af47741-1404856231271@3capp-gmx-bs13>
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
To: Hans Kraus <hans.w.kraus@gmx.at>
Cc: xfs@oss.sgi.com

On Tue, Jul 08, 2014 at 11:50:31PM +0200, Hans Kraus wrote:
> Hi Dave,
> 
> sorry for the HTML mail. My normal mail account isn't allowed to
> send mail to the list, my provider got somehow onto a spam list. I
> had to revert to GMX and only recently learnt how to send plain
> text mails via GMX. I hope that that works now.

Looks good ;)

> The system is now down, therefore some of the details you
> requested are only from my memory.  The version of xfstools is the
> one I got with the command "git clone
> git://oss.sgi.com/xfs/cmds/xfsprogs", sunday or monday this week.

Ok.

> The story is as follows: my backup file system is on a Raid6
> (mdadm), on top of that lvm2 and xfs.  One of the HDs reported
> smart errors, I replaced it with a new one. During the Raid6
> resyncronisation I got a kernel panic. After reset the raid didn't
> come up. I finally started it with the '--force' parameter. After
> that the filesystem didn't mount. I issued the 'xfs_repair -L ...'
> from the current distribution, Debian 7 amd64. During the repair
> process the command stalled for more than 24 hours. After that I
> got nervous and restarted the machine.

Yup, happens occasionally on older repairs - the "-P" option
probably helps there. That also helps explains why repair only
started complaining at AG 16.

> Then I downloaded the git xfstools version and compiled it. Now I
> get repeatedly the error from my first mail.

Yes, the IO verifier is reporting bp->b_error == EFSCORRUPTED on the
AGF buffer, and this assert is firing:

		ASSERT(agf_dirty || agfbuf->b_error != EFSCORRUPTED);

The issue is that the initial checks on the AGF are not resulting in
a dirty AGF because the fields that are corrupted can't be repaired
in phase 2, and hence the agf is not being dirtied despite being
corrupted.

The assert needs fixing.

> Two more drives failed, I'm now back to a system without any
> retundancy. I will only power it up again when I have two new
> replacement drives (already ordered).

Taking the failed raid resync, the --force to reconstruct it and
the style of corruption being reported in the XFS metadata, I'd
say you've probably corrupted all the data on your filesystem beyond
the point you can recover any of it.

The patch below will avoid the assert failure issue so repair runs
further, but if I were you I'd be considering the filesystem and the
data it contains a complete loss and restoring from backups....

.... which you probably don't have because this is a backup server.
Who has backups of their backups?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

repair: handle uncorrected corruptions in phase 2

From: Dave Chinner <dchinner@redhat.com>

Some of the AG header corruptions detected by the IO verifiers
cannot be corrected in phase 2 when we do the initial scan of the
AGs. Correcting some errors cannot be done until a full rebuild of
the trees is done in phase 5.

Hence we can end up with a "clean" AGF/AGI buffer but have a
EFSCORRUPTED error on the buffer. This results in an assert failing:

	ASSERT(agf_dirty || agfbuf->b_error != EFSCORRUPTED);

and repair not beign able to fix the problems it has tripped over.
Hence the assert that we corrected all corruptions in the buffers
is not valid and should be removed.

Reported-by: Hans Kraus <hans.w.kraus@gmx.at>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/scan.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index f29ff8d..142d8d7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1572,14 +1572,13 @@ scan_ag(
 
 	/*
 	 * Only pay attention to CRC/verifier errors if we can correct them.
-	 * While there, ensure that we corrected a corruption error if the
-	 * verifier detected one.
+	 * Note that we can get uncorrected EFSCORRUPTED errors here because
+	 * the verifier will flag on out of range values that we can't correct
+	 * until phase 5 when we have all the information necessary to rebuild
+	 * the freespace/inode btrees. We can correct bad CRC errors
+	 * immediately, though.
 	 */
 	if (!no_modify) {
-		ASSERT(agi_dirty || agibuf->b_error != EFSCORRUPTED);
-		ASSERT(agf_dirty || agfbuf->b_error != EFSCORRUPTED);
-		ASSERT(sb_dirty || sbbuf->b_error != EFSCORRUPTED);
-
 		agi_dirty += (agibuf->b_error == EFSBADCRC);
 		agf_dirty += (agfbuf->b_error == EFSBADCRC);
 		sb_dirty += (sbbuf->b_error == EFSBADCRC);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
