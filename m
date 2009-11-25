Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPMtka8013583 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 16:55:47 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7F38AC00F
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 14:56:10 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: User Space Releases
Date: Wed, 25 Nov 2009 16:56:10 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AF34@cf--amer001e--3.americas.sgi.com>
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
To: xfs@oss.sgi.com

On October 23, I published an updated set of some XFS user-space
source code on oss.sgi.com.

One of the changes (in xfsprogs) affected the ABI presented by
libhandle, but libhandle itself was not updated with a new
version number to reflect the change.  This has the potential to
cause problems in the future, and in order to avoid that I will
be withdrawing the 3.0.5 release of xfsprogs (as well as the
3.0.3 release of xfsdump that I published at the same time).

For most users, there is no harm in continuing to use the October
code.  (If you are developing code that uses the interface added
in that release, be advised it may not be present in future
releases.)

A new release of xfsprogs and xfsdump will be published in early
December, and everyone will be encouraged to upgrade when these
are available.

I will be replacing the tar files on oss.sgi.com for xfsprogs and
xfsdump with the versions that were there previously.  If you
follow the git change history you will also see that some changes
that were applied in October will be reverted.

I apologize for whatever confusion or concern have resulted due
to the October release.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
