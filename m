Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13FE67F47
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:07:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B77E8AC003
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:07:30 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id V1UZi6xqkVpLtHAY for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:07:26 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/7 V2] quota: add new quotactl Q_GETNEXTQUOTA
Date: Thu, 21 Jan 2016 22:07:17 -0600
Message-Id: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
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

I sent a regression test to the fstests list today, and will
send updated xfsprogs & linux-quota patches soon.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
