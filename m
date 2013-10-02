Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C33477F92
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 08:24:42 -0500 (CDT)
Received: from eagdhcp-232-155.americas.sgi.com
	(eagdhcp-232-155.americas.sgi.com [128.162.232.155])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A659C8F804C
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 06:24:42 -0700 (PDT)
Received: from eagdhcp-232-155.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-155.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r92DOflm002403
	for <xfs@oss.sgi.com>; Wed, 2 Oct 2013 08:24:41 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-155.americas.sgi.com)
Message-Id: <20131002125110.745269864@sgi.com>
Date: Wed, 02 Oct 2013 07:51:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/2] misc kernel leak patches
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

Here are a couple patches to free leaked memory.

First patch is v2 of a Coverity found leak in xfs_dir2_node_removename().

Second patch arose from an eariler leak found by Coverity. In looking
at that patch, Eric noted that it appeared that the transaction's
item list is also leaked if recovery fails. I tested this patch by forcing
errors into the recovery code to verify that the items are now being released.

I will send patches for xfsprogs equivalent.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
