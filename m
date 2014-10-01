Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD0467F72
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:02:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89EFD304081
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:02:34 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id PDTwyNbr5acSdgzy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 14:02:30 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: preadv2/pwritev2 updates
Date: Wed,  1 Oct 2014 23:04:51 +0200
Message-Id: <1412197494-7655-1-git-send-email-hch@lst.de>
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
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi Miklos,

attached are the patches that go on top of your
"[RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache only)"
series.  The first one adds RWF_NONBLOCK to XFS, the other two
add a new RWF_DSYNC flag that adds a per-operation O_DSYNC flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
