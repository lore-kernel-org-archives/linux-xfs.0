Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B77027F51
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 23:28:48 -0500 (CDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48D78AC003
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 21:28:45 -0700 (PDT)
Message-Id: <20131011041911.238407600@sgi.com>
Date: Thu, 10 Oct 2013 23:19:11 -0500
From: rjohnston@sgi.com
Subject: [PATCH 0/2 V3] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore are not lost
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

Extended attributes are lost after multi-stream xfsdump/xfsrestore
of wholly-sparse files.  This can happen in two ways:

  1 - The restore succeeds, however the extended attributes are lost
  2 - The restore in not successful because xfsrestore segfaults
      with the following warning:

        "partial_reg: Out of records. Extend attrs applied early."

---
Changelog
V2:
  Updated test description and comments
  Changed test status to default to failure
  Added missing _requires_XXXX statements
  Removed the attr root (-R) namespace argument
V3:
  Split into 2 tests and used functions from the common
  directory where appropriate.

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
