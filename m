Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8FEu5nm215503 for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 09:56:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C10513F00E2
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 08:00:54 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	23fejpgy3YbLjDyP for <xfs@oss.sgi.com>;
	Thu, 15 Sep 2011 08:00:54 -0700 (PDT)
Date: Thu, 15 Sep 2011 10:55:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110915145556.GA19902@infradead.org>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
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
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

On Thu, Sep 15, 2011 at 09:47:55AM -0500, Shawn Bohrer wrote:
> I've got a workload that is latency sensitive that writes data to a
> memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
> up to 100ms that occur during writeback that we did not see with older
> kernels.  I've traced the stalls and it looks like they are blocking
> on wait_on_page_writeback() introduced in
> d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
> should wait for writeback to finish"
> 
> Reading the commit description doesn't really explain to me why this
> change was needed.

It it there to avoid pages beeing modified while they are under
writeback, which defeats various checksumming like DIF/DIX, the iscsi
CRCs, or even just the RAID parity calculations.  All of these either
failed before, or had to work around it by copying all data was
written.

If you don't use any of these you can remove the call and things
will work like they did before.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
