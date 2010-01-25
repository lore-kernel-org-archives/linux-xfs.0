Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P8W8cR043884 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 02:32:08 -0600
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AC3D1C77282
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 00:33:12 -0800 (PST)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id eLmCOccHDzLIKamp for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2010 00:33:12 -0800 (PST)
Date: Mon, 25 Jan 2010 19:33:09 +1100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20100125083309.GF19664@laptop>
References: <20081021082542.GA6974@wotan.suse.de>
	<20081021082735.GB6974@wotan.suse.de>
	<20081021120932.GB13348@infradead.org>
	<20081022093018.GD4359@wotan.suse.de>
	<20100119121505.GA9428@infradead.org>
	<20100125075445.GD19664@laptop>
	<20100125081750.GA20012@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125081750.GA20012@infradead.org>
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

On Mon, Jan 25, 2010 at 03:17:50AM -0500, Christoph Hellwig wrote:
> On Mon, Jan 25, 2010 at 06:54:45PM +1100, Nick Piggin wrote:
> > Is this on a 32-bit system with small vmalloc area?
> 
> Yes.

OK, I would say it could easily be just due to fragmentation then.


> > When the vmap allocation fails, it would be good to basically see the
> > alloc_map and dirty_map for each of the vmap_blocks. This is going to be
> > a lot of information. Basically for all blocks with
> > free+dirty == VMAP_BBMAP_BITS are ones that could be released and you
> > could try the alloc again.
> 
> Any easy way to get them?  Sorry, not uptodate on your new vmalloc
> implementation anymore.

Let me try writing a few (tested) patches here first that I can send you.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
