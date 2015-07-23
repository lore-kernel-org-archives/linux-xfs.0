Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2FA87F86
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 15:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37FF7AC006
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 13:13:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zjxNiyLDUAApkyri (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 13:13:33 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id C834DC12A7
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 20:13:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t6NKDWVF015699
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 16:13:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 0/2] xfs: fix up EFI/EFD error handling
Date: Thu, 23 Jul 2015 16:13:28 -0400
Message-Id: <1437682410-51778-1-git-send-email-bfoster@redhat.com>
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

This is another quick RFC related to testing issues I'm hitting with my
previously posted log recovery fixes. Patch 1 is a small refactor to
support patch 2. Patch 2 describes the issues I'm hitting in repeated
shutdown and log recovery testing.

This passes some spot testing and seems to resolve the hang from the
test sequence described in the commit log description, but more testing
is definitely required. I _think_ I follow the log callbacks and how the
EFI/EFD are expected to be managed, but I could easily be missing
something. As it is, I'm off for a long weekend after today so I'm
sending this to hopefully get some eyes to sanity check before I get too
deep into testing this along with the previous fixes next week...

Brian

Brian Foster (2):
  xfs: return committed status from xfs_trans_roll()
  xfs: fix efi/efd error handling to avoid fs shutdown hangs

 fs/xfs/xfs_bmap_util.c    | 35 ++++++++++++++++++++--------
 fs/xfs/xfs_extfree_item.c | 59 +++++++++++++++++++++++++----------------------
 fs/xfs/xfs_trans.c        | 15 ++++++++++--
 fs/xfs/xfs_trans.h        |  1 +
 4 files changed, 71 insertions(+), 39 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
