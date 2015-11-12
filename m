Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D47577F66
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:37:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B195D8F8035
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6S9Sb1jvA87CzrLC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:29 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 40C23C0D8028
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 15:37:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-36.bos.redhat.com [10.18.41.36])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tACFbSZq017070
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:37:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/8] xfs: log recovery torn write detection
Date: Thu, 12 Nov 2015 10:37:20 -0500
Message-Id: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
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

Here's v2 of log recovery torn write detection. This fixes a couple bugs
as noted in the replies to the v1 series and replaces the error
injection mechanism with an alternate version that actually writes an
invalid log record CRC to disk. An xfstests test based on this mechanism
is forthcoming.

This survives xfstests and runs through a significant number of error
injection iterations without any related problems. I have seen one or
two assert failures and whatnot that do not appear related to this
series and so far are not repeatable. Thoughts, reviews, flames
appreciated.

Brian

v2:
- Fixed bug in first bad record detection to return correct block when
  log wraps.
- Update torn record handling to truncate back to tail.
- Fixed up warning messages.
- Replaced v1 error injection mechanism with log write time CRC error
  injection.
v1: http://oss.sgi.com/pipermail/xfs/2015-November/044841.html
- Added bug fix for mkfs log record header inconsistency.
- Refactored log recovery code to support a CRC-check-only recovery
  pass.
- CRC verify the last 8 records behind the head to account for
  concurrent log writes.
- Verify the tail of the log as well when the head is torn.
- Added (rfc) crc error injection patch for testing purposes.
rfc: http://oss.sgi.com/pipermail/xfs/2015-July/042415.html

Brian Foster (8):
  xfs: detect and handle invalid iclog size set by mkfs
  xfs: refactor log record unpack and data processing
  xfs: refactor and open code log record crc check
  xfs: return start block of first bad log record during recovery
  xfs: support a crc verification only log record pass
  xfs: refactor log record start detection into a new helper
  xfs: detect and trim torn writes during log recovery
  xfs: debug mode log record crc error injection

 fs/xfs/libxfs/xfs_log_recover.h |   1 +
 fs/xfs/xfs_log.c                |  45 +++-
 fs/xfs/xfs_log_priv.h           |   3 +
 fs/xfs/xfs_log_recover.c        | 569 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_sysfs.c              |  36 +++
 5 files changed, 541 insertions(+), 113 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
