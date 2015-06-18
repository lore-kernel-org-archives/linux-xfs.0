Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9B2729DFB
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 07:49:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52B54AC003
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 05:49:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mxkQegvVGJtEsRs8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2015 05:49:03 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 0CBB538AB5C
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 12:49:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5ICn2aq022164
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 08:49:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: misc. attribute and log recovery fixes
Date: Thu, 18 Jun 2015 08:48:59 -0400
Message-Id: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
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

This is just a couple miscellaneous fixes. Patch 1 fixes a regression in
the attribute fork destruction path in xfs_inactive(). Considering that
the cause of said regression was stable fodder, this might be as well.
Patch 2 fixes a crash reproduced on an s390x box due to a memcpy()
overflow in log recovery due to a corrupted log operation header (caused
by fsfuzzer).

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  xfs: don't truncate attribute extents if no extents exist
  xfs: validate transaction header length on log recovery

 fs/xfs/xfs_attr_inactive.c |  3 ++-
 fs/xfs/xfs_log_recover.c   | 10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
