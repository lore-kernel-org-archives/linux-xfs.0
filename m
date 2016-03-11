Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FE247CA0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:10:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D56D58F8033
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 14:10:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BiFGQb259DEcA0Yx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 14:10:41 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id F27EFC00F5FD
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 22:10:39 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2BMAcx0003909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 17:10:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/4] xfs: rework the attr ->put_listent code a bit
Message-ID: <56E3425E.40509@redhat.com>
Date: Fri, 11 Mar 2016 16:10:38 -0600
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
To: xfs@oss.sgi.com

Lots of cruft in there, maybe more to do but here's the
obvious stuff; removing bad error returns, unused variables
and structure members, and then consolidating a little code.

 xfs_attr.h      |    4 +-
 xfs_attr_list.c |   86 ++++++++++++++++----------------------------------------
 xfs_xattr.c     |   17 +++++++----
 3 files changed, 39 insertions(+), 68 deletions(-)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
