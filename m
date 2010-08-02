Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o727Pum2177205 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 02:25:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5215015CE136
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 00:34:04 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	Pnjlo9XquGa1GnSe for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 00:34:04 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] dio: serialise unaligned direct IO V2
Date: Mon,  2 Aug 2010 17:25:43 +1000
Message-Id: <1280733945-16231-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: sandeen@sandeen.net, xfs@oss.sgi.com

The first patch is unchanged from the first posting. The second patch adds
multiple lists and locks to avod potential scalability issues with a single
list. This is just a simple hash based on the block address being zeroed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
