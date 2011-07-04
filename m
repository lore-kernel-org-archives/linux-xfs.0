Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p64FYpQN162449 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 10:34:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5623C1EE87E4
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 08:34:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oo6AeMUdGO55OGkd for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 08:34:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QdlAZ-0005o8-N7
	for xfs@oss.sgi.com; Mon, 04 Jul 2011 15:34:43 +0000
Date: Mon, 4 Jul 2011 11:34:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [RFC] remove filestreams support?
Message-ID: <20110704153443.GA21501@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I'd like to know if there are any people actively using the filestreams
support in XFS (-o filestreams).  It's pretty much a fringe feature, and
I've not seen any user reports for it, while it never passes all its
XFSQA tests reliably.  It was added specificly for CXFS media streaming
operations on one particular array model that hasn't been sold for a
long time.  The feature purely is an in-memory one so unlike for example
the realtime device there are no issue about beeing able to read old
filesystems.  The filestreams specific files are around 1500 lines of
code, not even counting the hooks in the core XFS codebase.

If no serious users reply to this mail I'd like to add a deprecation
warning to the mount option in the Linux 3.0 release cycle, with a goal
to drop it 4 releases later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
