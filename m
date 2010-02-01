Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o11BRJtv104831 for <xfs@oss.sgi.com>; Mon, 1 Feb 2010 05:27:20 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 048881C95CFF
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2010 03:28:27 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TRayOJ7yMFSWbx6c for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2010 03:28:27 -0800 (PST)
Date: Mon, 1 Feb 2010 22:28:14 +1100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20100201112813.GA17689@laptop>
References: <20081021120932.GB13348@infradead.org>
	<20081022093018.GD4359@wotan.suse.de>
	<20100119121505.GA9428@infradead.org>
	<20100125075445.GD19664@laptop>
	<20100125081750.GA20012@infradead.org>
	<20100125083309.GF19664@laptop> <20100125123746.GA24406@laptop>
	<20100125213403.GA1309@infradead.org>
	<20100127083819.GA11072@laptop>
	<20100201110153.GA588@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100201110153.GA588@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

On Mon, Feb 01, 2010 at 06:01:54AM -0500, Christoph Hellwig wrote:
> On Wed, Jan 27, 2010 at 07:38:19PM +1100, Nick Piggin wrote:
> > > So far I've not run out of vmalloc space yet with quite a few xfstests
> > > iterations and not encountered any other problems either.
> > > 
> > > Thanks for looking into this!
> > 
> > OK thanks for testing. I'll send it upstream if you haven't had any
> > problems so far.
> 
> Still working fine, so please send it upstream ASAP.  That'll make
> re-eabling the scalable vmap API in XFS much more easier for 2.6.34.

Done. Thanks for testing this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
