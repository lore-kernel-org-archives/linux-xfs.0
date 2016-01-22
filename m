Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA8EA7F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 12:25:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C27C3304053
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 10:25:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id auB3IRImohm6tiZM for <xfs@oss.sgi.com>;
	Fri, 22 Jan 2016 10:25:39 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/7 V3] quota: add new quotactl Q_GETNEXTQUOTA
Date: Fri, 22 Jan 2016 12:25:29 -0600
Message-Id: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: jack@suse.cz

This adds a new quotactl, Q_GETNEXTQUOTA.

Q_GETNEXTQUOTA is exactly like Q_GETQUOTA, except that it will
return quota information for the id equal to or greater than
the id requested.  In other words, if the specified id has
no quota, the command will return quota information for the
next higher id which does have a quota set.  If no higher id
has an active quota, -ESRCH is returned.

So if you ask for id X, you can get back quota for id X,
id X+N, or -ESRCH if no higher id has a quota.

This allows filesystems to do efficient iteration in kernelspace,
much like extN filesystems do in userspace when asked to report
all active quotas.

Today, filesystems such as XFS require getpwent()-style iterations,
and for systems which have i.e. LDAP backends, this can be very
slow, or even impossible if iteration is not allowed in the
configuration.

Patches 1 and 4 are just small fixups that turned up along the way;
2 and 3 add the actual quota plumbing, and the rest are xfs-specific
to allow xfs to support this new interface.

For non-xfs quota, this does require a new structure which is
able to pass back the discovered ID along with the quota info.
For xfs-quota, the id is already present in the structure.

V3:
* Remove 32-bit compat stuff (i686/x86_64 at least works w/o it...)
* Require CAP_SYS_ADMIN for these calls
* Pass back found ID in &qid passed to ->get_nextdqblk, rather
  than modifying struct qc_dqblk
* Munge that found ID back through user-namespace conversions
  before returning it in the user structure.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
