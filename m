Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A45B7F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 18:17:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48BD18F8054
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 16:17:50 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 20mNZd7XnnwwBJ7t (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 16:17:45 -0700 (PDT)
Received: from zmail20.collab.prod.int.phx2.redhat.com
	(zmail20.collab.prod.int.phx2.redhat.com [10.5.83.23])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id t8ONHiHP008867
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 19:17:44 -0400
Date: Thu, 24 Sep 2015 19:17:44 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1482498135.42591149.1443136664561.JavaMail.zimbra@redhat.com>
In-Reply-To: <1054663595.42590503.1443136351475.JavaMail.zimbra@redhat.com>
Subject: Remove use of __psint_t in xfsdump as well
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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

Changes committed to git://oss.sgi.com/nathans/xfsdump.git master

Nathan Scott (1):
      xfsdump: remove use of __psint_t, it is no longer available


 common/drive_minrmt.c   |    4 ++--
 common/drive_scsitape.c |    4 ++--
 common/drive_simple.c   |    4 ++--
 common/util.h           |    4 ++--
 debian/changelog        |    6 ++++++
 5 files changed, 14 insertions(+), 8 deletions(-)


commit 8a468340b2b0592daa553d722b4eff5997e18fc1
Author: Nathan Scott <nathans@debian.org>
Date:   Fri Sep 25 09:11:31 2015 +1000

    xfsdump: remove use of __psint_t, it is no longer available
    
    Commit ee6cd73ed1e in xfsprogs switched __psint_t to the standards
    conforming intptr_t type - we need to make the same change here in
    xfsdump for builds using the latest xfsprogs headers.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
