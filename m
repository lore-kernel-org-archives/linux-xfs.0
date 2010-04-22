Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGVsgS214848 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:31:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DED04DA35A
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:33:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id V4X8mnDGa4sHdJw3 for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:33:55 -0700 (PDT)
Date: Thu, 22 Apr 2010 12:33:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mkfs.xfs man page for -nsize
Message-ID: <20100422163355.GA6360@infradead.org>
References: <20100422124118.GA3406@laptop.oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422124118.GA3406@laptop.oracle.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, xfs@oss.sgi.com

On Thu, Apr 22, 2010 at 08:41:18PM +0800, Wengang Wang wrote:
> I got no idea why the value is illegal.
> 
> Checking the codes, I found it also must be larger or equal to block size and it
> must be in powers of 2, 2^N. Should we add these two limitation to man page?

Yes, this should be added to the man page.  Can you submit a patch to
add it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
