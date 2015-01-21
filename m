Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20A3F7F59
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 18:40:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2E21AC00D
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 16:40:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Pz7ErXhkujeZtFr7 for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 16:39:59 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: buffer types need to be set
Date: Wed, 21 Jan 2015 11:39:37 +1100
Message-Id: <1421800780-26008-1-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz

Hi Jan,

These three patches detect and fix the issues you reported with log
recovery finding buffers with a format type of zero. The type of
zero (XFS_BLFT_UNKNOWN_BUF) is only valid for buffers that have
been cancelled (i.e. invalidated or marked stale as they have been
freed), so the series adds asserts to ensure these conditions are
met during transaction commit. Hence we shouldn't ever get new code
that fails to set the buffer type getting through testing.

The last two patches fix the cases that running xfstests uncovered
where we don't set the buffer type appropriately. There may be more,
but doing this much made my head hurt and xfstests is clean, so it's
as much as I'm going to do right now. Can you test it and see if it
runs clean (with CONFIG_XFS_WARN=y or CONFIG_XFS_DEBUG=y) on your
test setup?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
