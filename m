Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3BNXpei117334
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 18:33:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FA0B14BBC01
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:37:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VK5GSmyqgGM9OuTQ for
	<linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:37:11 -0700 (PDT)
Date: Mon, 11 Apr 2011 19:37:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2 question about XFS fragmentation and _fsr
Message-ID: <20110411233705.GA29358@infradead.org>
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
	<20110411214238.GE21395@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110411214238.GE21395@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Janos Haar <janos.haar@netcenter.hu>

On Tue, Apr 12, 2011 at 07:42:38AM +1000, Dave Chinner wrote:
> Depends on your samba configuration to how it does writes. If it is
> conigured to do sync writes then it will have all sorts of
> fragmentation problems. So without more details about the workload,
> the kernel that is being used, the fragmentation occurring (xfs_bmap
> is your friend) and the samba config, there's little that can be
> suggested here.

Very few people configure Samba to do sync writes, but even without
that I see files written by Samba heavily fragmented when the systems
operates under intense memory pressure.  The CIFS protocol has very
small write sizes, and it seems like they do not always arrive in order.
If the system is under enough memory pressure to write them out already
before the previous fragment arrive it can cause very fragmented
extent maps.  Enabling the "strict allocate" option in newer Samba
version fixes that problem by doing fallocates in larger chunks, which
from my observation always happen in order.  The downside is that
current fallocate in XFS is not designed to be used in a fastpath,
and thus causes performance degradations during the actual write.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
