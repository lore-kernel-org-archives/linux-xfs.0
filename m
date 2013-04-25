Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC70729DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 10:40:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8B80304059
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:40:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rVZmEIiC9sz2kY75 for
	<xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:40:42 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PFef3X006050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:40:41 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r3PFefYM024339
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:40:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: minor inode unlink debug enhancements
Date: Thu, 25 Apr 2013 11:41:28 -0400
Message-Id: <1366904490-46821-1-git-send-email-bfoster@redhat.com>
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

The following couple of patches provide a bit more debug info in the inode
unlink code paths. This data proved useful for the investigation around a
recent (downstream/distro) link/unlink race problem:

http://oss.sgi.com/archives/xfs/2013-04/msg00342.html

Brian

Brian Foster (1):
  xfs: tracepoints for xfs_iunlink() and xfs_iunlink_remove()

Eric Sandeen (1):
  xfs: enhance warning on xfs_imap() failure in xfs_iunlink_remove()

 fs/xfs/xfs_inode.c |   10 ++++++++--
 fs/xfs/xfs_trace.h |    2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
