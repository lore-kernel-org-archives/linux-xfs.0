Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D075F7F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:03:36 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD37A8F804C
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 13:03:33 -0700 (PDT)
Received: from xfsqa-xe6.americas.sgi.com (xfsqa-xe6.americas.sgi.com
	[128.162.242.7])
	by estes.americas.sgi.com (Postfix) with ESMTP id 8706D700295C
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:03:33 -0500 (CDT)
Received: by xfsqa-xe6.americas.sgi.com (Postfix, from userid 48222)
	id 6FBD0620E6; Mon, 21 Oct 2013 15:03:33 -0500 (CDT)
Message-Id: <20131021193830.885912820@sgi.com>
Date: Mon, 21 Oct 2013 15:02:30 -0500
From: rjohnston@sgi.com
Subject: [PATCH V4 0/2] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore are not lost
References: <20131011041911.238407600@sgi.com>
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

         "partial_reg: Out of records. Extend attrs applied
          early."

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
