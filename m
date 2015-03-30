Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC94E7F51
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 10:12:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCC8330404E
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 08:12:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id j7DvQ3Mr1uD8R5Bk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 08:12:47 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2UFCk2m020155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:12:46 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t2UFCki3025475
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:12:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: avoid overflow of attr3 leaf block headers with
	64k blocks
Date: Mon, 30 Mar 2015 11:12:42 -0400
Message-Id: <1427728365-15842-1-git-send-email-bfoster@redhat.com>
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

Here's v2 of the series previously posted here:

	http://oss.sgi.com/archives/xfs/2015-02/msg00516.html

This version incorporates the feedback from v1 to use separate helpers
for firstused conversion. I've also added a 3rd patch to kill what looks
like a (now unnecessary) overflow check.

To give a little more context... it appears that this overflow might
have been handled previously in the attr code by reducing the firstused
value by the required offset alignment and leaking the last few bytes of
the block. In fact, xfs_attr3_leaf_create() used to have a similar check
that was removed in:

	517c22207b04 xfs: add CRCs to attr leaf blocks

... so I suspect that introduced the regression. Both of those
!firstused checks appear to exist as of the original git import.
Unfortunately, I haven't seen them documented anywhere, but I can't
think of any other purpose for them.

Finally, I took a quick look at userspace... First, this depends on
xfs_da_geometry, which is not yet available there. So I suspect this
will depend on a larger xfsprogs update. IIRC, something of that nature
is pending or in progress..?

Second, from what I can see, nothing functional actually needs to
change. xfs_repair already does the correct thing by using a larger type
to compute firstused. It's written directly to the on-disk header and
will overflow at 64k, but that naturally results in the correct value of
0 on-disk. We should definitely make the code explicit, but this is
resolved simply by updating the conversion functions in libxfs.

Thoughts, reviews, flames appreciated...

Brian

v2:
- Created separate firstused conversion helpers to isolate the overflow
  management to a single point.
- Added patch 3/3 to kill an unnecessary overflow check.
- Comment cleanups, additions.

Brian Foster (3):
  xfs: pass attr geometry to attr leaf header conversion functions
  xfs: use larger in-core attr firstused field and detect overflow
  xfs: kill unnecessary firstused overflow check on attr3 leaf removal

 fs/xfs/libxfs/xfs_attr_leaf.c | 150 ++++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr_leaf.h |   6 +-
 fs/xfs/libxfs/xfs_da_format.h |  14 +++-
 fs/xfs/xfs_attr_inactive.c    |   3 +-
 fs/xfs/xfs_attr_list.c        |   9 ++-
 5 files changed, 139 insertions(+), 43 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
