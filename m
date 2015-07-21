Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42FAE7F7B
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 20:17:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3F50AC007
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 18:17:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Jq8q4M1EglAeGJUf for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 18:17:22 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: various fixes
Date: Tue, 21 Jul 2015 11:09:01 +1000
Message-Id: <1437440945-23457-1-git-send-email-david@fromorbit.com>
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
Cc: willy@linux.intel.com

Hi folks,

The first 3 patches fix various issues that need to head to Linus
before 4.2 is released. Patch 1 is a bug in the DAX support
resulting froma botched merge on my part - DAX doesn't do the direct
access part of DAX without this fix. (Willy, you only need to look
at this patch. :)

Patch 2 and 3 are stable kernel candidates - if nobody objects I'll
add stable cc's to them - as they affect recovery behaviour and
thought they are hard to trigger they can result in silent on-disk
corruption occurring if they do.

Patch 4 is just a cleanup that I noticed when looking at other code.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
