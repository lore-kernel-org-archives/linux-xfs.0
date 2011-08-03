Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73KnJjA179519 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 15:49:19 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56B35F2B225
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 13:50:08 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id HCdyW6DpVWKkPDg5 for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 13:50:08 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Improve writeout pattern from xfs_flush_pages()
Date: Wed,  3 Aug 2011 22:49:03 +0200
Message-Id: <1312404545-15400-1-git-send-email-jack@suse.cz>
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
To: hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com


  Hi,

  at one of customer's machines, I've spotted an issue that sync(1) called
after writing a single huge file has been achieving rather low throughput. After
debugging this with blktrace, I've found that the culprit was in flusher thread
racing with page writeout happening from XFS sync code. The patches below helped
that case. Although they are not a complete solution, I belive they are useful
anyway so please consider merging them...

									Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
