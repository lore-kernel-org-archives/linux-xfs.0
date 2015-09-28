Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 70EEA7F37
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 13:38:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40E638F8068
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 11:38:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vA8rBBhzH1xbWKP9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Sep 2015 11:38:04 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id ADC02A145C
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 18:38:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8SIc3Sp029241
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 14:38:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: fix eof zeroing i_size race
Date: Mon, 28 Sep 2015 14:37:59 -0400
Message-Id: <1443465481-63460-1-git-send-email-bfoster@redhat.com>
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

This addresses an EOF zeroing race that's been reproduced by a somewhat
obscure virtual machine workload on qcow2 vdisks with an increasing
i_size. Patch 1 contains the fix and patch 2 just adds a tracepoint that
helped identify the problem. Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  xfs: always drain dio before extending aio write submission
  xfs: add an xfs_zero_eof() tracepoint

 fs/xfs/xfs_file.c  | 17 +++++++++++------
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
