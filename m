Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 605597F5F
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 10:12:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4DD288F8049
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 08:12:26 -0800 (PST)
Received: from mail-ia0-f171.google.com (mail-ia0-f171.google.com
	[209.85.210.171]) by cuda.sgi.com with ESMTP id
	UZCPybvR5xuLFpLY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 08:12:25 -0800 (PST)
Received: by mail-ia0-f171.google.com with SMTP id z13so8280957iaz.2
	for <xfs@oss.sgi.com>; Mon, 04 Feb 2013 08:12:24 -0800 (PST)
Message-ID: <510FDDE5.4050103@inktank.com>
Date: Mon, 04 Feb 2013 10:12:21 -0600
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: [PATCH 0/2] xfs: insert memory barriers before wake_up_bit()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Sage Weil <sage@inktank.com>

These two patches insert memory barriers in xfs_iunlock() and
xfs_inode_item_unpin() before their calls to wake_up_bit(),
to ensure just-queued processes are properly awakened.

					-Alex

[PATCH 1/2] xfs: memory barrier before wake_up_bit()
[PATCH 2/2] xfs: another memory barrier before wake_up_bit()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
