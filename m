Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 629787F5F
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 16:16:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53BBB30405F
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HGZ5GHbrrWASmLuj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:16:13 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id CB6CD19CBFE
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 21:16:12 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 0/4] xfs: SGI ACL Fixes
Date: Sat, 24 Oct 2015 23:16:05 +0200
Message-Id: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<CAHc6FU7L15fCusqOONjtB8QQnGVPSW7+KKuENvFxKELmdnqmaA@mail.gmail.com>
In-Reply-To: <CAHc6FU7L15fCusqOONjtB8QQnGVPSW7+KKuENvFxKELmdnqmaA@mail.gmail.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Here are some fixes for the trusted.SGI_ACL_* attributes.  This adds some
more warts and it would be much better to get rid of those unnecessary
attributes instead; we probably can't though.

I have tested this manually but haven't run xfstests against that.  Please
review.

Thanks,
Andreas

Andreas Gruenbacher (4):
  xfs: Validate the length of on-disk ACLs
  xfs: SGI ACLs: Fix caching and mode setting
  xfs: SGI ACLs: Map uid/gid namespaces
  xfs: SGI ACLs: Prepare for richacls

 fs/xfs/libxfs/xfs_format.h |   8 +++-
 fs/xfs/xfs_acl.c           | 115 ++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_acl.h           |   3 ++
 fs/xfs/xfs_xattr.c         |   9 ++--
 fs/xfs/xfs_xattr.h         |  28 +++++++++++
 5 files changed, 147 insertions(+), 16 deletions(-)
 create mode 100644 fs/xfs/xfs_xattr.h

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
