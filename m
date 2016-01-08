Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E80807F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 10:56:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D72B3304039
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 08:56:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d0RbfzkG1xaNQoEm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2016 08:56:14 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
Message-ID: <568FEA2C.6080708@redhat.com>
Date: Fri, 8 Jan 2016 10:56:12 -0600
MIME-Version: 1.0
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
To: fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>

This adds a new quotactl, Q_XGETQUOTA2.

Q_XGETQUOTA2 is exactly like Q_XGETQUOTA, except that it will
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
slow, or even impossible, if iteration is not allowed in the
configuration.

I have patches to xfsprogs to allow xfs_quota to use this interface,
but I haven't looked at generic quota tools yet TBH.  I'll send the
xfsprogs patches to the xfs list shortly.

Using an id as input fits very nicely with existing interfaces;
however, I could imagine that making it a more generic "cookie"
interface might be more extensible; is there any filesystem which
wouldn't be collecting all active IDs in a linear fashion, and
would rather have an arbitrary cookie passed back & forth?
(I hope not) :)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
