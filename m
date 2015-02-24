Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FAC97F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 14:50:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E593304039
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 12:50:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8YWH5Hin1GrZpn8J (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 12:50:28 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1OKoQIl021258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 15:50:27 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1OKoQlC030693
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 15:50:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: avoid overflow of attr3 leaf block headers with 64k
	blocks
Date: Tue, 24 Feb 2015 15:50:22 -0500
Message-Id: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Hi all,

As it turns out, some of the leaf block codepaths other than xattr
addition look like they wouldn't work properly with an unaligned
firstused value as demonstrated in my previous patch:

http://oss.sgi.com/archives/xfs/2015-02/msg00479.html

Here's an alternate approach that handles the overflow in the header
conversion functions. It passes the basic tests so far, but more testing
is needed to make sure I've made valid assumptions. Thoughts?

FWIW, another approach could be to leak the last few bytes of the blocks
(e.g., max firstused at the last valid aligned offset and update freemap
size accordingly)...

Brian

Brian Foster (2):
  xfs: pass attr geometry to attr leaf header conversion functions
  xfs: use larger in-core attr firstused field and detect overflow

 fs/xfs/libxfs/xfs_attr_leaf.c | 99 +++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  6 ++-
 fs/xfs/libxfs/xfs_da_format.h |  8 +++-
 fs/xfs/xfs_attr_inactive.c    |  3 +-
 fs/xfs/xfs_attr_list.c        |  9 ++--
 5 files changed, 86 insertions(+), 39 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
