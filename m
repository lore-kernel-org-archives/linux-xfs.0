Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KGUgUO070689 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:30:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B74F91403065
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 09:36:00 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xWbdl5nsirHfXqvO for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 09:36:00 -0700 (PDT)
Date: Tue, 20 Sep 2011 12:30:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110920163034.GB18914@infradead.org>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
	<20110915145556.GA19902@infradead.org>
	<20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
	<20110916002557.GN11984@tux1.beaverton.ibm.com>
	<20110916163232.GA2109@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110916163232.GA2109@BohrerMBP.rgmadvisors.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

On Fri, Sep 16, 2011 at 11:32:32AM -0500, Shawn Bohrer wrote:
> So for the most part it sounds like this change is needed for DIF/DIX.
> Could we only enable the wait_on_page_writeback() if
> CONFIG_BLK_DEV_INTEGRITY is set?  Does it make sense to tie these
> together?

It will also allow for huge efficiency gains on software raid.  There
have been some Lustre patches for that.

> The other thread in this case is the [flush-8:0] daemon writing back
> the pages.  So in our case you could see the spikes every time it wakes
> up to write back dirty pages.  While we can control this to some
> extent with vm.dirty_writeback_centisecs and vm.dirty_expire_centisecs
> it essentially impossible to ensure the writeback doesn't coincide
> with us writing to the page again.

Can you explain how your use case looks in more details?  Right now
for example a mlock removes the page from the lru list and thus stops
VM writeback.  If such an interface would be useful for you we could
offer an fadvice call that stops writeback entirely, and requires you
to force it when you want it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
