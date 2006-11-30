Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 10:04:38 -0800 (PST)
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAUI4VaG017106
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 10:04:31 -0800
Message-ID: <456F1CFC.2060705@sgi.com>
Date: Thu, 30 Nov 2006 18:03:40 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
References: <20061123044122.GU11034@melbourne.sgi.com>
In-Reply-To: <20061123044122.GU11034@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Dave,

Could you have changed the SB_LOCK from a spinlock to a blocking
mutex and have achieved a similar effect?

Has this change had much testing on a large machine?

These changes wouldn't apply cleanly to tot (3 hunks failed in
xfs_mount.c) but I couldn't see why.

The changes look fine to me, couple of comments below.

Lachlan


@@ -1479,9 +1479,11 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
  		case XFS_SBS_IFREE:
  		case XFS_SBS_FDBLOCKS:
  			if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-				status = xfs_icsb_modify_counters_locked(mp,
+				XFS_SB_UNLOCK(mp, s);
+				status = xfs_icsb_modify_counters(mp,
  							msbp->msb_field,
  							msbp->msb_delta, rsvd);
+				s = XFS_SB_LOCK(mp);
  				break;
  			}
  			/* FALLTHROUGH */

Is it safe to be releasing the SB_LOCK?  Is it assumed that the
superblock wont change while we process the list of xfs_mod_sb
structures?


@@ -1515,11 +1517,12 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
  			case XFS_SBS_IFREE:
  			case XFS_SBS_FDBLOCKS:
  				if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-					status =
-					    xfs_icsb_modify_counters_locked(mp,
+					XFS_SB_UNLOCK(mp, s);
+					status = xfs_icsb_modify_counters(mp,
  							msbp->msb_field,
  							-(msbp->msb_delta),
  							rsvd);
+					s = XFS_SB_LOCK(mp);
  					break;
  				}
  				/* FALLTHROUGH */

Same as above.


@@ -1882,6 +1895,17 @@ xfs_icsb_disable_counter(

  	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));

+	/*
+	 * If we are already disabled, then there is nothing to do
+	 * here. We check before locking all the counters to avoid
+	 * the expensive lock operation when being called in the
+	 * slow path and the counter is already disabled. This is
+	 * safe because the only time we set or clear this state is under
+	 * the m_icsb_mutex.
+	 */
+	if (xfs_icsb_counter_disabled(mp, field))
+		return 0;
+
  	xfs_icsb_lock_all_counters(mp);
  	if (!test_and_set_bit(field, &mp->m_icsb_counters)) {
  		/* drain back to superblock */

Nice one, that will avoid a lot of unnecessary work.
