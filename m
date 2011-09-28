Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SBid0j105755 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 06:44:39 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 0/2] xfsprogs: libxcmd: support wildcard for fs_table lookups
Date: Wed, 28 Sep 2011 06:44:32 -0500
Message-Id: <1317210274-13086-1-git-send-email-aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These two patches add support for the use of 0 as a wildcard value
for indicating the type of entry wanted in a fs_table search.  This
allows some code in xfs_quota to be simplified a bit, and (perhaps)
makes it clearer that in most cases searches only look for one type.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
