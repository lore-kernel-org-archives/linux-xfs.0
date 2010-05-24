Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OECGlR183221 for <xfs@oss.sgi.com>; Mon, 24 May 2010 09:12:16 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 307C4369D3C
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 07:14:37 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 9yss86CdH2hNRDxY for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 07:14:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8 v3] Quota tests for XFSQA
Date: Mon, 24 May 2010 16:14:11 +0200
Message-Id: <1274710459-11446-1-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org


  Hello,

  this is a third version of my quota tests for XFSQA. The first two patches
are just fixes of bugs I've found while adding new tests. Other six patches
add new tests.

  Changes since last time:
- Fixed detection of quota support for XFS and GFS2 as suggested by Christoph
- Added fix for fallocate support detection
- Added test to verify quota behavior after remount (based on recent kernel bug...)

  Comments welcome.

										Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
