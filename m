Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SHSe8s126096 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 12:28:40 -0500
Received: from cxfsxe4.americas.sgi.com (cxfsxe4.americas.sgi.com
	[128.162.240.177])
	by estes.americas.sgi.com (Postfix) with ESMTP id CAF637001AAD;
	Tue, 28 Aug 2012 12:29:28 -0500 (CDT)
Received: by cxfsxe4.americas.sgi.com (Postfix, from userid 48222)
	id BDF18CDA81; Tue, 28 Aug 2012 12:29:28 -0500 (CDT)
Message-Id: <20120828172605.607853317@sgi.com>
Date: Tue, 28 Aug 2012 12:26:05 -0500
From: Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH 0/5] Use libtool to install apps and remove relative lib paths
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

This 5 part patchset (for xfstests, dmapi and xfsdump):

1. Uses libtool to install the binary from the proper location and display a
   warning if any shared library dependancies are not properly installed.
2. Ensures that a libtool wrapper shell script is not installed in place of
   the application when libtool wrappers are being used.
3. Removes the undocumented feature which allowed xfs developers to build and
   run xfstests without having to install the libraries.  This can lead to
   touble if you expect that xfstests is using the versions of the libraries
   installed on the system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
